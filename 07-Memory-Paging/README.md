##Segmentation

We need to wrap up our discuss on segmentation.

Segmentation saves us a lot a of memory.
No longer is the enitre adress space allocated in physical memory.
The unused memory between the heap and the stack doesn't get allocated.

However, segmentation comes with some issues:
- We need hardware support for segmentation registers.
- What do we do during a context switch?
- How do we manage free space?


##Free space

Why is managing free space an issue?

Let's go back to our assumptions about memory:
{~
    Address spaces are:
    - contiguous in physical memory
    - less than the size of physical memory
    - the same size as any other address space
~}

How many of these remain valid?

With different sized segments of memory spread out through the physcial memory
finding free regions of memory is not as simple.

We end up with holes of memory.

We call this external fragmentation.

        {~Not Compacted~}
0KB     |-------------------------------------|
        |                                     |
8KB     | Operating System (code, data, etc.) |
        |                                     |
16KB    |-------------------------------------|
        |                {free}               |
24KB    |-------------------------------------|
        |              Process A              |
32KB    |-------------------------------------|
        |              Process B              |
40KB    |-------------------------------------|
        |                {free}               |
48KB    |-------------------------------------|
        |              Process A              |
56KB    |-------------------------------------|
        |                {free}               |
64KB    |-------------------------------------|


        {~Compacted~}
0KB     |-------------------------------------|
        |                                     |
8KB     | Operating System (code, data, etc.) |
        |                                     |
16KB    |-------------------------------------|
        |              Process A              |
24KB    |                                     |
        |-------------------------------------|
32KB    |              Process B              |
        |-------------------------------------|
40KB    |                                     |
        |                {free}               |
48KB    |                                     |
        |                                     |
56KB    |                                     |
        |                                     |
64KB    |-------------------------------------|


##Paging

Instead of splitting address space into logical segments,
we split into fixed-sized units called pages.

Weird thing: 
when we say 64 byte address space we think small
when we say 64 bit address space we think HUGE
but bits are smaller than bytes, right?

{~Flexibility~} wrt address space usage
  We won't make assumption about the direction of the address space

{~Simplicity~} of free-space management
  Just find enoough free pages

{~Per-process~} page table
keeps track of where virtual pages are in physcial memory


##A.T. Example

Let's perform an address translation in our simple 64 byte address space.

Our virtual address has two components:
- virtual page number
- offset into page

We have the following memory access instruction:

```
movl 21, %eax
```

How many bits do we need in a 64 byte space?
- How many bits for VPN?
- How many bits for offset?

What is the physical address this instruction will use?


##Page Tables

These page tables could get very big...

32bit address space with 4KB pages:
- 20bits for virtual page number
- 12bits for offset into 4KB page

This means the OS has to manage 2^20 translations!
Per-process!

Say each PTE takes 4 bytes...
that's 4MB per process
that's 400MB for just 100 processes

We can't store this on special MMU hardware
we store it in memory (OS controlled memory)

##PTE

What makes up a page table entry?

Page tables map virtual page numbers to physical page frames
Many data structures could do this
The simplest is a linear array indexed by the VPN

Each entry:
- {~valid bit~} is this bit valid (allocated?)
- {~protection bit~} read/write/execute?
- {~present bit~} in memory?
- {~dirty bit~} changed?
- {~reference bit~} accessed?
- more bits describing caching, modes, etc


##Slow

Paging is slow.

{~See figure 18.6: Accessing Memory with Paging in OSTEP~}
