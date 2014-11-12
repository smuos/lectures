Abstraction
-----------

We've seen two major OS abstractions so far:
- cpu
- memory

Let's explore some storage abstractions.  

Previously we looked at I/O devices and discussed:

- The storage hierarchy
- The abstraction layers from applications to device drivers

Our motivation was increased flexibility and deferral of concerns.

```
Application -> File System -> Generic Block Layer -> Device Driver
```


Files and Directories
---------------------

__Files__
- linear array of bytes
- low level name (inode)

__Directory__
- low level name (inode)
- contents: low level name, and human readable name pairs
- can contain links to files or other directories

File extensions are a convention.


Interface
---------

`open()`

```c
int fd = open("foo", O_CREAT | O_WRONLY | O_TRUNC);
```

`fd` is a file descriptor.
Think of it as a pointer to an object of type file.

```c
int main(int argc, char *argv[]) {
    DIR *dp = opendir(".");
    assert(dp != NULL);
    struct dirent * d;
    while ((d = readdir(dp)) != NULL) {
        printf("%d %s\n", (int) d->d_ino, d->d_name);
    }
    closedir(dp);
    return 0;
}
```


Utilities
---------

Let's see how some utilities interact with files!

> Plays with strace in linux...


Non-Sequential Access
---------------------

`lseek()`

We have something like a program counter for files.

The OS keeps track of an offset into a file.

It is advanced when we `read()` or changed when we `lseek()`


Buffering and fsync()
---------------------

Calling write(), like most things, just means the data will be written eventually.

The data to be written if buffered for a while to help optimize performance.

> When might we want a write to happen immediately?

To support this type of usage we have `fsync()`

`fsync()` takes in a file descriptor and writes all its dirty data to disk, returning only once complete.


More Operations
---------------

- Renaming
- Getting information
- Removing files and directories
- Making directories
- Hard and Symbolic Links
- Mounting a File System

> Runs off to a terminal again...
