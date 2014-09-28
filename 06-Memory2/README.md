##Memory

{~Stack~}
allocations and deallocations are handled implicitly by the compiler

{~Heap~}
allocations and deallocations are explicitly handled by the programmer

```c
void func(){
    int *x = (int *) malloc(10 * sizeof(int)); 
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

notice we have not mentioned {~system calls~}?
malloc() and free() are library calls
they handle the brk system call for us

Some other flavours of malloc():
- calloc() allocates and zeros memory
- realloc() allocates a larger memory region and copies old data to it


##Translation

Address Translation

let's make some assumptions

the address space must be:
- contiguous in physical memory
- less than the size of physical memory
- the same size as any other address space


##Physical

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


##Virtual

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


##Base / Bounds

We again make use of hardware support

two registers to store:
- the base address of the virtual address space
- the limit (bound) of the virtual address space

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


##Segmentation

Using one pair of base and bounds is wasteful with our memory.

Why not use a base/bound pair for each logical segment of memory?

Let's see some example translations with segmentation
