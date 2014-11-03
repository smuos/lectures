Evaluating Locks
----------------

1. Does the lock provide mutual exclusion?
2. Does any lock starve while waiting for the lock?
3. Does the lock add so much overhead it affects performance?


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

> Tip: hold the lock while calling signal or wait.


Producer Consumer Problem
=========================

Imagine we have one or more producer threads and one or more consumer threads.  
Producers generate data items and place them in a buffer.  
Consumers take items from the buffer and do something with them.  

We call this buffer a bounded buffer.

Examples
--------

__Web servers__  
In a multi-threaded web server, a producer puts HTTP requests into a queue.  
Consumer threads take these requests out of the queue and process them.  

__Piping in a shell__  
`grep csci3431 classes.txt | wc -l`  
Here we have two processes running concurrently.  
`grep` writes matching lines from classes.txt to its stdout.  
Our shell redirects `grep`'s stdout to a pipe connected to `wc`'s stdin. 
`wc` then counts the lines in its input stream and prints the result.  

> Question: Who is the producer, and who is the consumer?


Put and Get Routines
--------------------

```c
int buffer;
int count = 0; // initially, empty

void put(int value) {
    assert(count == 0);
    count = 1;
    buffer = value;
}

int get() {
    assert(count == 1);
    count = 0;
    return buffer;
}
``` 

Producer and Consumer
---------------------

```c
void *producer(void *arg) {
    int i;
    int loops = (int) arg;
    for (i = 0; i < loops; i++) {
        put(i);
    } 
}

void *consumer(void *arg) { int i;
    int i;
    while (1) {
        int tmp = get();
        printf("%d\n", tmp);
    }
}
```

Synchronization
---------------

The bounded buffer is a shared resource, so we must require synchronization to access it.  
Let's only put data in when the count is zero and take data out only when count is one.  
Of course we are going to have critical sections, so lets look at a solution with locks.

```c
cond_t  cond;
mutex_t mutex;

void *producer(void *arg) {
    int i;
    for (i=0;i<loops;i++){ 
        Pthread_mutex_lock(&mutex);             // p1
        if (count == 1)                         // p2
            Pthread_cond_wait(&cond, &mutex);   // p3
        put(i);                                 // p4
        Pthread_cond_signal(&cond);             // p5
        Pthread_mutex_unlock(&mutex);           // p6
    }
}

void *consumer(void *arg) {
    int i;
    for (i=0;i<loops;i++){ 
        Pthread_mutex_lock(&mutex);             // c1
        if (count == 0)                         // c2
            Pthread_cond_wait(&cond, &mutex);   // c3
        int tmp = get();                        // c4
        Pthread_cond_signal(&cond);             // c5
        Pthread_mutex_unlock(&mutex);           // c6
        printf("%d\n", tmp);
    }
}
```

This code appears to work with just a single producer and single consumer.  
What about when we have multiple producers or consumers?  

Look at [Table 30.1](http://pages.cs.wisc.edu/~remzi/OSTEP/threads-cv.pdf#page=8) in OSTEP 
to see what happens to the above code when we have two consumers.

Let's look at some other possible solutions.
