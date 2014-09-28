## Intro

 Operating Systems in Three Easy Pieces

1. Virtualization
2. Concurrency
3. Persistence

 What does a running program do?

- Fetches instructions
- Decodes the instructions  
- Executes the instructions  
- Fetches more instructions
  
//This assumes a simple processor that runs sequentially and in order.


## The OS

The OS manages resources to make the computer...

-easier to use
-more efficient
-use portable software

It does this through virtualization.
We will focus on {~how the operating system virtualizes resources.~}


# C

Structured assembly
Used heavily in systems programming

Parent: B
Grandparent: BCLP

Created by Kernighan and Ritchie at Bell Labs

- 1969-1973: "C came into being".
The most creative year being 1972
- 1978 K&R's The C Programming Language
- 1980s-90s A mess of different C's
- 1989-1990 ANSI C 
- C95, C99, C11
- 2012 GCC now builds from source with C++03


## The CPU

{~Interrupts~}
Hardware interrupts (timer, system bus)
Software interrupts (system call)

CPU stops executing and switches to a fixed location


## The CPU 2

CPU support for an OS mode bit
This means hardware support for protected and privileged code

User Mode: CPU executing user application
Kernel Mode: CPU is executing OS code


## The CPU 3

The operating system virtualizes the CPU
This creates the illusion of having many CPUs

Let's see some code!


##

---cpu.c:

```c
#include <stdio.h>
#include <stdlib.h>
#include "common.h"

int main(int argc, char *argv[])
{
    if (argc != 2) {
	fprintf(stderr, "usage: cpu <string>\n");
	exit(1);
    }
    char *str = argv[1];

    while (1) {
	printf("%s\n", str);
	Spin(1);
    }
    return 0;
}
```


## Bash

Bourne Again SHell

A shell is a {~command line interface~} (CLI) to interact with the 
Operating System

Unix implements commands as system programs.

$ rm myFile.txt

$ ./cpu & ./cpu


## Memory

Memory is an array of bytes
To read memory we must specify an address
To write to memory we need address and data

```c
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include "common.h"

int main(int argc, char *argv[])
{
	int *p = malloc(sizeof(int));
	assert(p != NULL);
	printf("(%d) address of p: %08x\n",
		getpid(), (unsigned) p);
	*p = 0;
	while (1) {
		Spin(1);
		*p = *p + 1;
		printf("(%d) p: %d\n", getpid(), *p);
	}
	return 0;
}
```


## Memory 2

The OS virtualized the memory for us

A shared resource managed by the OS

Security implications?
- Address Space Layout Randomization


## Concurrency

Needing to deal with many things at once
Multi-threaded programs (pthreads)


## Persistence

Volatile memory is erased on power loss

Why do we use it then?
There is a storage-device hierarchy:

- RAM, main memory
- cache
- solid state disk
- optical disk
- registers
- magnetic tape
- magnetic disk


## Persistence

Storage-device hierarchy:

1. registers
2. cache
3. RAM, main memory
4. solid state disk
5. magnetic disk
6. optical disk
7. magnetic tape


## Persistence

Storage-device hierarchy:

1. registers
2. cache
3. RAM, main memory
4. solid state disk
5. magnetic disk
6. optical disk
7. magnetic tape
8. The SMUNET J-drive


## File Systems

Software component responsible for storing files.

- FAT
- NTFS
- EXT
- UDF
- ZFS


## File Systems

In some respects we don't virtualize the disk
(Not like we do with memory or CPU)

Users want to share information on disk
(amongst themselves or with processes!)

vim hello.c
gcc -Wall -Wextra -o hello hello.c
./hello

creating, editing, reading, executing


## Design

Abstractions
  c -> assembly -> logic gates -> transistors
Performance
  Minimize OS overhead
Protection
  Isolation

  Energy efficiency
  Reliability/redundancy
  Mobility


## History

In the beginning, OS's were really just libraries
Batch mode computing with human operator

Code running on behalf of OS was special
  it controlled devices!

System calls
  like procedures but done in OS mode
Traps and trap handlers


## History 2

Minicomputers
  enable more access to computers

Multiprogramming
  switching to improve utilization
  (IO is slow)
  (users are slow!)

Memory Protection
Concurrency


## History 3

Personal Computer

DOS and Mac OS
  many missing features...
  (memory protection, job scheduling)

Eventually...
  Linux/BSD on PCs
  Windows NT
  Mac OS becomes a Unix


## Fin

{~That's all folks.~}


