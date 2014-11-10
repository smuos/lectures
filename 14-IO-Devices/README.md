Persistence
===========

This marks our start of the third piece of Operating Systems: Three Easy Pieces!  


I/O Devices
-----------

Without input and program would run the same every time.  
And without output, what is the purpose of running the program?

Clearly, when we say I/O we do not just mean keyboard input and screen output.

See [Prototypical System Architecture (Figure 36.1)](http://pages.cs.wisc.edu/~remzi/OSTEP/file-devices.pdf#page=2)


Hierarchical Bus
----------------

- Memory
- PCI
- SATA, SCSI, USB

This is done for cost and performance limitation reasons.  


Example Device
--------------

```
While (STATUS == BUSY)
    ; // wait until device is not busy
Write data to DATA register
Write command to COMMAND register
    (Doing so starts the device and executes the command)
While (STATUS == BUSY)
    ; // wait until device is done with your request
```

Polling - Repeatedly reading the status of the devices
Programmed I/O - The CPU is involved in the data movement

> How can we improve upon this?


Lowering Overhead
-----------------

Polling devices involves a lot of wasted CPU usage.

If we use interrupts, the OS can issue a I/O request and then perform a context switch while waiting.  
The device handles the request, while the CPU performs some other task.  
When the device is finished it issues an interrupt, which the OS then handles.

Keep in mind, interrupts may not always be better than polling.

> When might you prefer polling a device?

- "Slashdot effect"  
- livelock
- coalescing (check out Apple's marketing of [Timer Coalescing](https://www.apple.com/osx/advanced-technologies/))


Direct Memory Access
--------------------

Transferring data between the device and memory still takes time.  
A DMA controller can do this heavy lifting for the CPU.


Device Interaction
------------------

__I/O instruction__  
x86 `in` and `out` which take a register and port as arguments.  
These are usually privileged instructions.  

__Memory-mapped I/O__  
Device registers made to look like memory locations

Both approaches are in use today.


Drivers
-------

We want to abstract some details of each device.  
We wouldn't want to have to think about how to implement a filesystem on SCSI, SATA, or USB.  

```
Application -> File System -> Generic Block Layer -> Device Driver
```

> Can you think of a limitation of this approach?

" Studies of the Linux kernel reveal that over 70% of OS code is found in device drivers [C01]; 
for Windows-based systems, it is likely quite high as well. "
