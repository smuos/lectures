##Book keeping

- Course docs on moodle.cs.smu.ca
- Moodle enrollment key: init

- Overrides?
-   6 types


# The

# Process


##Processes

A fundamental abstraction
(a running program)

How can the OS provide the illusion of many CPUs?

Virtualizing the CPU
- Time sharing
- Performance cost

Policies and Mechanisms
- "high-level intelligence" {~which/what~}
- "low-level machinery" {~how~}

Scheduling Policy
- which process has run in last minute?
- what type of workload?
- throughput / interaction?


##Process

machine state
memory (address space)
registers
  program counter (instruction pointer)

list of open files


##Interaction

The OS provides an API to work with processes

Create
Destroy
Wait
Control
Status


##Tools
lsof
ps
netstat


##Creation

How do we get a program up and running?

If a program is bytes in storage, how do we make it a process?

Loads code and data into memory.
(we assume executable files)

Allocate memory for the stack
local variables, function parameters, return addresses

Allocate some memory for the heap
dynamically-allocated data
malloc() and free()

create/open file descriptors
3 special file descriptors for standard input, output, and error

main()


##Process States

Running
- the cpu is executing instructions
Ready
- process is ready to run but OS is not yet running it
Blocked
- process is waiting for something

Register context (used in a context switch)


##xv6 proc structure

```c
// the registers xv6 will save and restore
// to stop and subsequently restart a process struct context {
  int eip;
  int esp;
  int ebx;
  int ecx;
  int edx;
  int esi;
  int edi;
  int ebp;
};

// the different states a process can be in 
enum proc_state { UNUSED, EMBRYO, SLEEPING,
		RUNNABLE, RUNNING, ZOMBIE };

// the information xv6 tracks about each process 
// including its register context and state 
struct proc {
char *mem;                       // Start of process memory             
uint sz;                         // Size of process memory 
char *kstack;                    // Bottom of kernel stack 
                                 // for this process
enum proc_state state;           // Process state
int pid;                         // Process ID
struct proc *parent;             // Parent process
void *chan;                      // If non-zero, sleeping on chan 
int killed;                      // If non-zero, have been killed 
struct file *ofile[NOFILE];      // Open files
struct inode *cwd;               // Current directory
struct context context;          // Switch here to run process 
struct trapframe *tf;            // Trap frame for the
                                 // current interrupt

￼};
```


##summary

different process data structures and sub structure

process control block

lets move on to some low-level mechanisms to implement processes.


#fork()

System call to create a process
fork()

We also have exec() and wait()


##fork1.c

```c
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main(int argc, char *argv[])
{
	printf("hello world (pid:%d)\n", (int) getpid());
	int rc = fork();
	if (rc < 0) {		//fork failed; exit
		fprintf(stderr, "fork failed\n");
		exit(1);
	} else if (rc == 0) { // child (new process)
		printf("hello, I am child (pid:%d)\n", (int) getpid());
	} else {
		printf("hello, I am parent of %d  (pid:%d)\n", 
			rc, (int) getpid());
	}
	return 0;
}
```

##Determinism

We'd like if our code ran the same everytime.

fork1.c is NOT deterministic
(trust me)

How can we control this?


##fork2.c

```c
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main(int argc, char *argv[])
{
	printf("hello world (pid:%d)\n", (int) getpid());
	int rc = fork();
	if (rc < 0) {		//fork failed; exit
		fprintf(stderr, "fork failed\n");
		exit(1);
	} else if (rc == 0) { // child (new process)
		printf("hello, I am child (pid:%d)\n", (int) getpid());
	} else {
		{~int wc = wait(NULL);~}
		printf("hello, I am parent of %d  (wc:%d) (pid:%d)\n", 
			rc, wc, (int) getpid());
	}
	return 0;
}
```


##wait()

Non-determinism becomes a large problem with multi-threaded programs
We'll see a lot more of this when we cover concurrency

For now, we have wait()

Parent waits for child to finish.


##exec()

What if we'd like to run a different program?

Using the exec() system call we can load new code and data.

This does not create a new process.
exec() changes the running code

