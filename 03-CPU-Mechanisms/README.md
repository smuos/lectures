##Book keeping

- Labs this week!

Tuesday lab section now available
- REC B:Operating Systems - 15075 - CSCI 3431 - 1RB
- Remember you MUST bring a laptop!


##Processes

One of the OS's fundamental abstractions.

A process is a {~running~} program.

Virtualizing the CPU through time sharing
(Performance cost and control)

Process state


##Interaction

The OS provides an API to work with processes

Create Destroy Wait Control Status

{~Creation~}

Loads code and data into memory.
Allocate memory for the stack and heap
Create/open file descriptors
main()


##System calls

{~fork()~}
System call to create a process

{~wait()~}
Parent waits for child to finish.

{~exec()~}
This does not create a new process.
exec() changes the running code


##Mechanisms 1

Recall we spoke about concerns of time sharing:
- performance
- control

Policies and Mechanisms
- "high-level intelligence" {~which/what~}
- "low-level machinery" {~how~}


##Mechanisms 2

"How can we implement virtualization without adding excessive overhead?"
"How can we run processes efficiently while retaining control over the CPU?"


##Mechanisms 3

Limited Direct Execution

'Direct Execution' - run the process directly on the CPU


{~Direct Execution Protocol~}

| {~OS~}                            | {~Program~}                    |
|-------------------------------|----------------------------|
| create entry for process list |                            |
| allocate memory for program   |                            |
| load program into memory      |                            |
| setup stack with argc/argv    |                            |
| clear registers               |                            |
| execute call main()           |                            |
|                               | run main()                 |
|                               | execute return from main() |
| free memory of process        |                            |
| remove from process list      |                            |


##Mechanism 4

Here we get different modes of operation.
But what stops the program from being evil?
Does this present the illusion of many CPUs?


##Mechanism 5

We solve these problems with  hardware support and two processing modes.

{~User mode~}
Cannot execute priviledged operations
(No I/O requests)

{~Kernel mode~}
Can execute privileged operations
Can control/access all devices

The system call then enables user mode programs to perform privileged operations.


##Mechanism 6

A system call like fork() is actually a C procedure call.
- code is in the C library
- agreed upon conventions to store arguments to open in correct memory locations
- executes the trap instructions
- after trap code unpacks return values
- returns control to program

The C library system calls are hand coded in assembly
They need to carefully follow conventions to process arguments/return codes correctly
The trap instruction is also hardware specific

x86 pushes program counter, flags, some registers to a per-process kernel stack


##Aside

How does the trap code know what code to run?

Specify an address in kernel space of code to run?


##Aside

The kernel needs to control what code executes upon a trap.

"One of those awesome, mind-blowing ideas that you’ll see in research from time to time.
The author shows that if you can jump into code arbitrarily, you can essentially stitch 
together any code sequence you like (given a large code base) – read the paper for the 
details. The technique makes it even harder to defend against malicious attacks, alas."

At boot time the OS is in kernel mode, and configures machine hardware
A trap table defines what code to run during exceptional events

Let's checkout a timeline.


##LDE
{~Limited Direct Execution Protocol~}
(At boot, OS initializes trap table)

| OS                              | Hardware                       | Program          |
| (kernel mode)                   |                                | (user mode)      |
|---------------------------------|--------------------------------|------------------|
| create entry for process list   |                                |                  |
| allocate memory for program     |                                |                  |
| load program into memory        |                                |                  |
| setup user stack with argc/argv |                                |                  |
| fill kernel stack with reg/PC   |                                |                  |
| return-from-trap                |                                |                  |
|                                 | restore regs from kernel stack |                  |
|                                 | move to user mode              |                  |
|                                 | jump to main()                 |                  |
|                                 |                                | run main()       |
|                                 |                                | ...              |
|                                 |                                | call system call |
|                                 |                                | trap into OS     |
|                                 | save regs to kernel stack      |                  |
|                                 | move to kernel mode            |                  |
|                                 | jump to trap handler           |                  |
| handle trap (do system call)    |                                |                  |
| return-from-trap                |                                |                  |
|                                 | restore regs from kernel stack |                  |
|                                 | move to user mode              |                  |
|                                 | jump to PC after trap          |                  |
|                                 |                                | ...              |


##Switching

When the program is running the OS is NOT.
How can the OS regain control of the CPU?

{~Cooperative approach:~}
wait for system calls (trusting)
yield()
what about evil programs?
buggy programs? (infinite loops)

{~Timer interrupt:~}
More help from the hardware
Timer device raises an interrupt ever N milliseconds
At boot, the OS starts timer

Hardware must save enough information for return-from-trap
(very similar to hardware instructions during a system call)


##Context Switch

The OS has now regained control
(either cooperatively or through a timer interrupt)
What should it do now?

Continue running the previous process?
Start running another process?

Context switch is low level code.
- store registers from currently-executing Process A
- load registers for soon-to-be-executing Process B
Now when the return-from-trap instruction is run the CPU is running Process B


##LDE+
{~Context Switch with a timer interrupt~}

| OS                                    | Hardware                        | Program     |
| (kernel mode)                         |                                 | (user mode) |
|---------------------------------------|---------------------------------|-------------|
|                                       |                                 | Process A   |
|                                       |                                 | ...         |
|                                       | timer interrupt                 |             |
|                                       | save regs(A) to k-stack(A)      |             |
|                                       | move to kernel mode             |             |
|                                       | jump to trap handler            |             |
| handle the trap                       |                                 |             |
| call switch() routine                 |                                 |             |
|   save regs(A) to proc-struct(A)      |                                 |             |
|   restore regs(B) from proc-struct(B) |                                 |             |
|   switch to k-stack(B)                |                                 |             |
| return-from-trap (into B)             |                                 |             |
|                                       | restore regs(B) from k-stack(B) |             |
|                                       | move to user mode               |             |
|                                       | jump to B's program counter     |             |
|                                       |                                 | Process B   |
|                                       |                                 | ...         |


##Context Switch 2

There are two types of register save operations 
- user registers (saved by hardware)
- kernel registers (saved by operating system)

The kernel register switch:
"moves the system from running as if it just trapped into the kernel from A
to as if it just trapped into the kernel from B."


##Next time...

Worried about concurrency?
The OS can disable interrupts...

Context switches take less than microseconds

We have baby proofed the CPU for user programs

Next lecture:
Which process should we run at a given time?
