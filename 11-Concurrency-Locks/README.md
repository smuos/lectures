Locks
=====

We have seen how to use locks.
Now let's consider how to build them.

Evaluating Locks
----------------

1. Does the lock provide mutual exclusion?
2. Does any lock starve while waiting for the lock?
3. Does the lock add so much overhead it affects performance?


Controlling Interrupts
----------------------

The simplest solution to provide mutual exclusive is to disable interrupts.  

```c
void lock{
    DisableInterrupts();
}
void unlock{
    EnableInterrupts();
}
```

This approach is not without considerable disadvantages.

- It requires trusty the application with a privileged instruction
- It does not work with multiple CPUs
- It is not necessarily performant


Spin Locks
----------

```c
typedef struct __lock_t { int flag; } lock_t;

void init(lock_t *mutex) {
    // 0 -> lock is available, 1 -> held 
    mutex->flag = 0;
}

void lock(lock_t *mutex) {
    while (mutex->flag == 1) // TEST the flag
        ; // spin-wait (do nothing)
    mutex->flag = 1; //Set the flag
}

void unlock(lock_t *mutex) { 
    mutex->flag = 0;
}
```

> How would this lock evaluate using our criteria from above?


Test and Set
------------

We need some hardware support.  
The test-and-set is referred to as `xchg` on x86.  
(atomic exchange instruction)  

The following describes the test-and-set instruction.  

```c
int TestAndSet(int *ptr, int new){
   int old = *ptr;  //save value of old
   *ptr = new;      //set value to new
   return old;      //return value of old
```

Let's build another spin lock:  

```c
typedef struct __lock_t { int flag; } lock_t;

void init(lock_t *mutex) {
    // 0 -> lock is available, 1 -> held 
    mutex->flag = 0;
}

void lock(lock_t *mutex) {
    while (TestAndSet(&mutex->flag, 1) == 1)  //simultaneously sets
        ; // spin-wait (do nothing)
}

void unlock(lock_t *mutex) { 
    mutex->flag = 0;
}
```

> For this to work it requires a 'preemptive scheduler'. Why?  

> How does this evaluate?


More Hardware Primitives
------------------------

`compare-and-swap`    
`load-linked` and `store-conditional`  
`fetch-and-add`  


Performance and Spinning
------------------------

So far, everything we've seen still relies on spinning when a thread cannot get a lock.

> How do we develop a performant lock that does not waste CPU cycles?


Queues and Two-Phase Locks
--------------------------

So far there has been a lot left to luck.  
We need to better inform the OS what thread we want scheduled next.  

Solaris implements `park()`, `unpark()`, and `setpark()`

`park()` puts a particular thread to sleep.  
`unpark()` wakes up a particular thread.  
`setpark()` indicates a thread is about to park.  


Linux impliments a 'futex' to accomplish a similar task.
This is a two-phase lock. The idea being that spinning can be useful.

> Why, on a multi CPU system, might some spinning on a lock be useful?


Lock-based Concurrent Data Structures
-------------------------------------

When we use locks to make a data structure usable by threads we call the structure 'thread safe'.

Simple counter  
Correct counter  
Sloppy counter (performant)  

Linked list  
Concurrent Linked List  
Better Concurrent Linked List  
Performant?  

Tips
----

- More concurrency is not necessarily faster. Test and *measure* both methods.
- Beware of locks and control flows leading to exits.
- Avoid premature optimization.


Condition Variables
-------------------

The lock is not the only primitive we need for building concurrent systems.

We want some way to signal and wait on threads.  
Perhaps we want a thread to check a condition before executing.  

To do this we use a 'condition variable' which is a queue threads can put themselves in.

`pthread_cond_wait()` Used when a thread wants to sleep.  
`pthread_cond_signal()` Used when a thread has changed something...  


Parent waiting for child
------------------------

```c
int done = 0;
pthread_mutex_t m = PTHREAD_MUTEX_INITIALIZER;
pthread_cond_t c = PTHREAD_COND_INITIALIZER;

void thr_exit() {
    Pthread_mutex_lock(&m);
    done = 1;
    Pthread_cond_signal(&c);
    Pthread_mutex_unlock(&m);
}

void *child(void *arg) { 
    printf("child\n");
    thr_exit();
    return NULL;
}
void thr_join() {
    Pthread_mutex_lock(&m);
    while (done == 0)
        Pthread_cond_wait(&c, &m); 
    Pthread_mutex_unlock(&m);
} 

int main(int argc, char *argv[]) { 
    printf("parent: begin\n");
    pthread_t p;
    Pthread_create(&p, NULL, child, NULL); 
    thr_join();
    printf("parent: end\n");
    return 0; 
}

```


Without the state variable 'done'
---------------------------------

```c
int done = 0;
pthread_mutex_t m = PTHREAD_MUTEX_INITIALIZER;
pthread_cond_t c = PTHREAD_COND_INITIALIZER;

void thr_exit() {
    Pthread_mutex_lock(&m);
    Pthread_cond_signal(&c);
    Pthread_mutex_unlock(&m);
}

void *child(void *arg) { 
    printf("child\n");
    thr_exit();
    return NULL;
}
void thr_join() {
    Pthread_mutex_lock(&m);
    Pthread_cond_wait(&c, &m); 
    Pthread_mutex_unlock(&m);
} 

int main(int argc, char *argv[]) { 
    printf("parent: begin\n");
    pthread_t p;
    Pthread_create(&p, NULL, child, NULL); 
    thr_join();
    printf("parent: end\n");
    return 0; 
}

```


Without a lock while signaling
------------------------------

```c
int done = 0;
pthread_mutex_t m = PTHREAD_MUTEX_INITIALIZER;
pthread_cond_t c = PTHREAD_COND_INITIALIZER;

void thr_exit() {
    done = 1;
    Pthread_cond_signal(&c);
}

void *child(void *arg) { 
    printf("child\n");
    thr_exit();
    return NULL;
}
void thr_join() {
    if (done == 0)
        Pthread_cond_wait(&c, &m); 
} 

int main(int argc, char *argv[]) { 
    printf("parent: begin\n");
    pthread_t p;
    Pthread_create(&p, NULL, child, NULL); 
    thr_join();
    printf("parent: end\n");
    return 0; 
}

```


Tip: hold the lock while calling signal or wait.

Next time we'll be looking at the Producer Consumer problem.
