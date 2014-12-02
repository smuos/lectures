Very Simple File System
=======================

Two crucial aspects to think about:
1. The data structures (lists, arrays, trees)
2. The access methods (mapping system calls to data structures)

Divide our 256kb disk into 4kb `blocks`.  
Reserve the first 8 blocks (indexed at zero) for metadata.  

We store our file metadata in inodes.
We have use bitmaps to store our allocation information.

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



Filesystem States
=================


Let's consider the following filesystem state:

We have a single directory `/` which contains the usual `.` and `..` files, as well as a file `x`.

```
inode bitmap  11000000
inodes        [d a:0 r:3] [f a:1 r:1] [] [] [] [] [] []
data bitmap   11000000
data          [(.,0) (..,0) (x,1)] [x] [] [] [] [] [] []
```

The first line is the inode bitmap which tells us what inodes are in use.

Second, we get to see the actual inodes and their contents.
Here we have two inodes, one for a directory at the first (0th) data block, and one regular file.

The data bitmap shows which data blocks are in use.

Finally the data shows the contents of each data block.
The first data block is a directory containing 3 directory entries.
The second data block is a regular file containing the data `x`.

The inumber for the root directory is 0. See that both `.` and `..` point to 0.

> Will `.` and `..` point to the same inumber for other directories?


We want to write a new file `y` to the root directory.
Here is the desired state of the filesystem after the write:

```
inode bitmap  11100000
inodes        [d a:0 r:3] [f a:1 r:1] [f a:2 r:1] [] [] [] [] []
data bitmap   11100000
data          [(.,0) (..,0) (x,1) (y,2)] [x] [y] [] [] [] [] []
```

Let's consider the changes.

We have added a new inode, updated the inode bitmap, added a new data block, and updated the data bitmap.

> How many operations are required to change from our first state to this state?

> What if some of those operations failed?


Crash Consistency
=================

A single write of a file needs to update several data structures.

There are several ways the above state transition could fail.
Let's first consider the case where only a single write succeeds:

__data block__: The data is written but with no record of it.
The file system can't tell the difference between this data and garbage data.

__inode__: The inode now points to a data block without our data in it.

__bitmap__: If only a bitmap (either one) is updated, the filesystem is inconsistent.

And if two writes succeed:

__inode__ and __bitmap__: Filesystem metadata is consistent, but points to garbage data; this is very bad.

__inode__ and __data block__: Filesystem metadata is not consistent, but the data exists; there might be hope...

__bitmap__ and __data block__: Filesystem metadata is not consistent, the data exists but without reference; this is very bad.

Let's look at some solutions to these possible problems:


fsck
----

- Sanity checks the superblock
- Check inodes to compute new inode bitmap
- Check the inode state (valid type?)
- Verify inode link count
- Check for duplicates (inodes point to the same data block)
- Bad blocks (bad pointers really)
- Directory checks

This process is slow and perhaps overkill.

> Which of the failure scenarios above could `fsck` recover from?

Surely we are lost without at least a valid inode pointing to a data block.

But even then, the data block could contain unexpected or garbage data.


Journaling
----------

Also known as write-ahead logging, journaling is an idea taken from the database world.

The principle is simple, before writing the data to disk,
record a small note about the structures you are going to update.

The note would look something like this:

1. Transaction beginning block
2. Inode
3. Bitmap
4. Datablock
5. Transaction ending block

The TxE (transaction ending block) is written only after the other blocks are confirmed to be written.
And so the entire write process can be broken down like this:

1. Journal write (write contents and metadata to log, wait for the writes to complete)
2. Journal commit (when the above is completed, record the TxE)
3. Checkpoint (Write the contents and metadata to final disk locations)

We can recover from a failed write with this log information.

If the write fails before the journal commit we simply skip the write.
If the write fails before the checkpoint is finished but after the journal commit,
we use the information in the log to 'replay' the write to disk.

The journal is finite in size, and thus after a successful checkpoint we need to update the journal to free space.


Other approaches
----------------

- Soft Updates (writing pointed-to structures first)
- Copy on write
- Backpointer-based consistency


ZFS
---

- copy-on-write transaction model with tree based checksums!
- snapshots
- variable block sizes (128kb by default!)
- deduplication
- RAID-Z1, RAID-Z2, RAID-Z3
- Combining a lvm and fs
- Oracle you bastard.
