##Book keeping

- Labs this week!

- REC A:Operating Systems - CSCI 3431 - {~L182~}


##Review

We have learned about what we expect of the OS

Virtualizing the CPU
- the process
- system calls
- limited direct execution
- context switch


##Switching

When the program is running the OS is NOT.
How can the OS regain control of the CPU?

{~Cooperative approach:~}
wait for system calls (trusting)
yield()
what about evil/buggy programs?

{~Timer interrupt:~}
More help from the hardware
Timer device raises an interrupt ever N milliseconds
At boot, the OS starts timer

Hardware must save enough information for return-from-trap
(very similar to hardware instructions during a system call)


##Context Switch

The OS has now regained control
(either cooperatively or through a timer interrupt)

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
| perform the context switch            |                                 |             |
|   {~save regs(A) to proc-struct(A)~}      |                                 |             |
|   {~restore regs(B) from proc-struct(B)~} |                                 |             |
|   {~switch to k-stack(B)~}                |                                 |             |
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


##CPU Policy

This is the last CPU part.

We will follow the text explicitly for this topic.

TXT4 and TXT5 are on the moodle.
They correspond to chapters 7 and 8 in the text book.

