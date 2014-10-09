##Concurrency  
  
We have seen two basic abstractions the OS handles  
- virtual CPUs  
- virtual memory  
  
We introduce a new abstraction, the __thread__  
  
We have multiple "programs" running in the same address space  
  
Each thread has its own:  
- private set of registers  
- program counter  
- stack  
  
They share the rest of the address space  
- heap  
- code section  
- static global  
  
  
##Threads  
  
Each thread has its own registers  
Registers are virtualized by the context switch that save and restores them  
  
On a context switch we save state of T1 and load T2  
Before we had a process control block (PCB) to save state  
Now we also have a thread control block (TCB)  
  
As mentioned we have multiple stacks now.  
See [Figure 26.1 in OSTEP](http://pages.cs.wisc.edu/~remzi/OSTEP/threads-intro.pdf)
  
  
##Creation  
  
```c  
#include <stdio.h>  
#include <assert.h>  
#include <pthread.h>  
  
void * mythread(void * arg) {  
    printf("%s\n", (char *) arg);  
    return NULL;  
}  
  
int main(int argc, char * argv[]) {  
    pthread_t p1, p2;  
    int rc;  
    printf("main: begin\n");  
    rc = pthread_create(&p1, NULL, mythread, "A"); assert(rc == 0);  
    rc = pthread_create(&p2, NULL, mythread, "B"); assert(rc == 0);  
    // join waits for the threads to finish  
    rc = pthread_join(p1, NULL); assert(rc == 0);  
    rc = pthread_join(p2, NULL); assert(rc == 0);  
    printf("main: end\n");  
    return 0;  
}  
```  
  
  
##Worse  
  
"Computers are hard enough to understand without concurrency.   
Unfortunately, with concurrency, it gets worse. Much worse."  
  
See (Tables 26.1, 26.2, 26.3 in OSTEP)[http://pages.cs.wisc.edu/~remzi/OSTEP/threads-intro.pdf]  
  
  
##Atomicity  
  
atom  
atomic  
atomicity  
  
Atomic operations  
"all or none"  
  
Atomic operations in a huge instruction set?  
  
Synchronization primitives to build multi-threaded code  
  
  
##Terminology  
  
Critical Section  
  
Race Condition  
  
Indeterminate / Deterministic  
  
Mutual Exclusion  
  
  
  
  
  
  
##Debugging tools  
  
```bash  
gcc -D_GNU_SOURCE -pthread -lpthread -g -o main main-thread-0.c  
objdump -rS main > dmain.dis  
pygmentize -l c-objdump dmain.dis | less -R  
```  
