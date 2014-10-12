##Memory

We've virtualized the CPU
Now to discuss memory.


##History

Physical memory view of early OSs

|                                     |
| Operating System (code, data, etc.) |
|                                     |
|-------------------------------------|
|                                     |
| Current Program (code, data, etc.)  |
|                                     |
|                                     |
|                                     |
|                                     |
|                                     |
|                                     |


##History 2

Later we get time sharing

0KB     | Operating System (code, data, etc.) |
        |-------------------------------------|
64KB    |                {free}               |
        |-------------------------------------|
128KB   |              Process C              |
        |-------------------------------------|
192KB   |              Process B              |
        |-------------------------------------|
256KB   |                {free}               |
        |-------------------------------------|
320KB   |              Process A              |
        |-------------------------------------|
384KB   |                {free}               |


##History 3

And finally address spaces (process view)

0KB
1KB     |            Program Code             |
        |-------------------------------------|
2KB     |                Heap                 |
        |-------------------------------------|
        |                                     |
        |                                     |
        |                                     |
        |                Free                 |
        |                                     |
        |                                     |
        |                                     |
        |-------------------------------------|
        |                                     |
15KB    |                Stack                |
16KB


##Stack

allocations and deallocations are handled implicitly by the compiler
sometimes called automatic memory

```c
void func(){
    int x; // declares an integer on the stack
    ...
}
```

Compiler:
makes space on stack when you call into func()
deallocates memory when you return from func()


##Heap

allocations and deallocations are explicitly handled by the programmer
(the cause of many bugs)

```c
void func(){
    int *x = (int *) malloc(sizeof(int)); // pointer to an integer on the heap
    ...
}
```

How many allocations happen here?


##malloc()

You pass malloc a size and it returns :
- a pointer to your newly allocated memory
- NULL, which means it failed


##free()

takes one argument, a pointer, and frees the memory the pointer points to.
Note then the size of the allocated space is not tracked by the user.


##errors

As mentioned before, trusting programs with memory leads to bugs.

Newer languages support
- automatic memory management
- garbage collection


##errors 2

{~Forgetting to allocate memory~}
some routines expect allocation before they are called

strcpy() copies from a source pointer to a destination pointer
it expects the destination pointer to be allocated

```c
char *src = "hello";
char *dst;        // not allocated!
strcpy(dst, src); // segfault
```

Quote from textbook on the meaning of a segmentation fault:
"YOU DID SOMETHING WRONG WITH MEMORY YOU FOOLISH PROGRAMMER AND I AM ANGRY."


##errors 3

```c
char *src = "hello";
char *dst = (char *) malloc(strlen(src) +1);
strcpy(dst, src); // works!
```

The +1 with the strlen is to make room for the end-of-string character.

malloc() actually returns to type void, we are casting here.


##errors 4

{~Not allocating enough memory~}

```c
char *src = "hello";
char *dst = (char *) malloc(strlen(src));
strcpy(dst, src); // works?
```

This might work, depending on the implementation of malloc()

when it doesn't work, it is often called a buffer overflow
these can cause major security problems


##errors 5

{~Not initializing memory~}

this happens when you've allocated memory with malloc()
but never set any values and then read random memory bits


##errors 6

{~Forgetting to free memory~}

if you never free() unused memory your memory usages grows and grows
often called a memory leak

in long running applications (like a browser) this can be a huge problem

garbage collected languages do not help here. why?


##errors 7

{~Freeing memory before you're done with it~}

this can lead to dangling pointers

calling free() then malloc() could overwrite mistakenly freed data


##errors 8

{~Freeing memory repeatedly~}

a 'double free' is undefined


##errors 9

{~Calling free() incorrectly~}

free() expects the pointer malloc() returns
anything else could be bad


##support

notice we have not mentioned {~system calls~}?

malloc() and free() are library calls

this is another abstraction to help us

an actual system call is {~brk~} which changes a programs break point
(where the end of the heap occurs)
it takes one agrument, the new address of the break

do not use brk!


##other calls

calloc() allocates and zeros memory

realloc() allocates a larger memory region and copies old data to it.
useful for increasing array sizes


##TXTBOOK

Lets look at the textbook's chapter 15 to understand
Address Translation

But first, as before, let's make some assumptions

the address space must be:
- contiguous in physical memory
- less than the size of physical memory
- the same size as any other address space

