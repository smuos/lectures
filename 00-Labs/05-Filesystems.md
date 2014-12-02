Filesystem Simulator
====================

Download the [vsfs.py file](http://pages.cs.wisc.edu/~remzi/OSTEP/Homework/HW-VSFS.tgz) from the OSTEP homework.

Play around with the simulator, working through questions 1 through 4 at the end of [OSTEP: Chapter 40](http://pages.cs.wisc.edu/~remzi/OSTEP/file-implementation.pdf#page=18).  

You only need to answer the following two questions.

Submit your answers before 4:00pm November 27th 2014.

> Question 1: Determine the operations for the following simulation run:

```
Initial state

inode bitmap  10000000
inodes        [d a:0 r:2] [] [] [] [] [] [] []
data bitmap   10000000
data          [(.,0) (..,0)] [] [] [] [] [] [] []

Which operation took place?

inode bitmap  11000000
inodes        [d a:0 r:3] [f a:-1 r:1] [] [] [] [] [] []
data bitmap   10000000
data          [(.,0) (..,0) (f,1)] [] [] [] [] [] [] []

Which operation took place?

inode bitmap  10000000
inodes        [d a:0 r:2] [] [] [] [] [] [] []
data bitmap   10000000
data          [(.,0) (..,0)] [] [] [] [] [] [] []

Which operation took place?

inode bitmap  11000000
inodes        [d a:0 r:3] [d a:1 r:2] [] [] [] [] [] []
data bitmap   11000000
data          [(.,0) (..,0) (c,1)] [(.,1) (..,0)] [] [] [] [] [] []

Which operation took place?

inode bitmap  11100000
inodes        [d a:0 r:3] [d a:1 r:3] [f a:-1 r:1] [] [] [] [] []
data bitmap   11000000
data          [(.,0) (..,0) (c,1)] [(.,1) (..,0) (d,2)] [] [] [] [] [] []

Which operation took place?

inode bitmap  11100000
inodes        [d a:0 r:3] [d a:1 r:3] [f a:2 r:1] [] [] [] [] []
data bitmap   11100000
data          [(.,0) (..,0) (c,1)] [(.,1) (..,0) (d,2)] [o] [] [] [] [] []

Which operation took place?

inode bitmap  11100000
inodes        [d a:0 r:3] [d a:1 r:4] [f a:2 r:2] [] [] [] [] []
data bitmap   11100000
data          [(.,0) (..,0) (c,1)] [(.,1) (..,0) (d,2) (y,2)] [o] [] [] [] [] []

```

> Question 2: Determine the state after each operation.

```
Initial state

inode bitmap  10000000
inodes        [d a:0 r:2] [] [] [] [] [] [] []
data bitmap   10000000
data          [(.,0) (..,0)] [] [] [] [] [] [] []

creat("/a");

  State of file system (inode bitmap, inodes, data bitmap, data)?

fd=open("/a", O_WRONLY|O_APPEND); write(fd, buf, BLOCKSIZE); close(fd);

  State of file system (inode bitmap, inodes, data bitmap, data)?

link("/a", "/s");

  State of file system (inode bitmap, inodes, data bitmap, data)?

unlink("/s");

  State of file system (inode bitmap, inodes, data bitmap, data)?

unlink("/a");

  State of file system (inode bitmap, inodes, data bitmap, data)?

creat("/b");

  State of file system (inode bitmap, inodes, data bitmap, data)?
```
