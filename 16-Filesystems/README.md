File Systems
============

Consider the crux of the problem:
- How can we build a simple file system?
- What data structures are needed?
- What do we keep track of?
- How do we access the data?

Two crucial aspects to think about:

1. The data structures (lists, arrays, trees)
2. The access methods (mapping system calls to data structures)


Very Simple File System
=======================

Divide our 256kb disk into 4kb `blocks`.  
Reserve the first 8 blocks (indexed at zero) for metadata.  

Metadata:
---------

- Which data blocks make up a file
- The size of a file
- owner, group, access rights
- access and modify times

This metadata is stored in an inode table (inside our metadata region).

If we allocate 5 blocks to the inode table, and inodes are 256 bytes, 
then our filesystem has 80 inodes in total.

This is the upper limit on how many files our 256kb file system can hold.

Allocation
----------

We need some way to keep track of whether inodes and data blocks are allocated.  
For this, we'll use a simple bitmap for each.  
We now have a single block remaining in our metadata region.  
This block is the super block, which holds our file system parameters.  


The Inode
=========

The inode contains the metadata for an individual file.  
Each inode has an inumber which is the 'low level name' we referred to previously.  

Checkout the Inode Table and example structure in [OSTEP 40.3](http://pages.cs.wisc.edu/~remzi/OSTEP/file-implementation.pdf#page=4)


Referencing Blocks
==================

How do we go about referring to the blocks that make up a file?

In the most simple case we could have pointers to blocks. 

What about for larger files?  
We have indirect pointers, that point to a block containing direct pointers.  
And for yet larger files we can have double indirect or triple indirect pointers.  
This approach is called multi-level indexing.

A separate approach is to use extents.  
An extent is simply a disk pointer and a length in blocks.

> When might one system be better than another?


General Summary
---------------

- Most files are small (2kb)
- Average file size is growing (200kb)
- Most bytes are in large files.
- File systems contain a lot of files (100,000 on average)
- File systems are roughly half full.
- Directories are typically small.


Directory Organization
----------------------

| inum | record | strlen | name   |
|------|--------|--------|--------|
| 5    | 4      | 2      | .      |
| 2    | 4      | 3      | ..     |
| 12   | 4      | 4      | foo    |
| 13   | 4      | 4      | bar    |
| 24   | 8      | 7      | foobar |


Access Paths
============

We've mostly talked about the data structures, let's consider the access methods.

See [table 40.3 in OSTEP](http://pages.cs.wisc.edu/~remzi/OSTEP/file-implementation.pdf#page=11).


Caching
-------

As you can see, even reading causes numerous I/O requests.  
To help alleviate this we cache import blocks to memory.  

Recall possible issues with write buffering.
