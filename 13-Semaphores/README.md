Semaphores
==========


Edsger Dijkstra

A semaphore is an object with an integer value.
We can manipulate this object with two routines.
`sem_post()` and `sem_wait()`

We need to intialize our semaphore first.

```c
#include <semaphore.h>
sem_t s;
sem_init(&s, 0, 1);
```

- first: reference to semaphore  
- second: share the semaphore among threads  
- third: the semaphores initial value is 1  


Semaphores as Locks
-------------------

```c
sem_t m;
sem_init(&m, 0, X); //What should X be?

sem_wait(&m);
  //critical section of code
sem_post(&m);
```

> What value should we use to initialize our semaphore?


Semaphores as Condition Variables
---------------------------------

It is not difficult to use semaphores as condition variables.

```c
sem_t s;

void *child(void *arg) {
    printf("child\n");
    sem_post(&s); // signal here: child is done 
    return NULL;
}

int
main(int argc, char *argv[]) {
    sem_init(&s, 0, X); // what should X be?
    printf("parent: begin\n");
    pthread_t c;
    Pthread_create(c, NULL, child, NULL);
    sem_wait(&s); // wait here for child
    printf("parent: end\n");
    return 0;
}
```

Producer Consumer
-----------------

As before we need locks and conditions.

[See code in Figure 31.7 of OSTEP Chapter 31.](http://pages.cs.wisc.edu/~remzi/OSTEP/threads-sema.pdf#page=9)


Deadlock
--------

Four conditions are necessary for deadlock:

- Mutual exclusion
Exclusive control of shared resources.

- Hold-and-wait
A thread holds the lock while waiting for other resources.

- No preemption
Locks cannot be forcibly removed from threads.

- Circular wait
Each thread holds a resource being requested by another thread.


Reader-Writer Locks
-------------------

We want to have some flexibility in our concurrent systems.  
One example is of reader-writer locks.

Consider concurrent operations on a linked list.  
One routine reads data, and another writes new data.  
Obviously this system has some critical sections we would protect with locks.  

A reader-writer lock allows multiple readers access to the list concurrently,
while preventing writers access while any one reader still has access.  

[See code in Figure 31.9 of OSTEP Chapter 31.](http://pages.cs.wisc.edu/~remzi/OSTEP/threads-sema.pdf#page=11)

> What about fairness?


The Dining Philosophers
-----------------------

Let's again refer to the lovely diagrams and code in OSTEP:  
[See code in Figure 31.10 of OSTEP Chapter 31.](http://pages.cs.wisc.edu/~remzi/OSTEP/threads-sema.pdf#page=13)
