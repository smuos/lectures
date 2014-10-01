##Paging  

Instead of splitting address space into logical segments,  
we split into fixed-sized units called pages.  

__Flexibility__ wrt address space usage  
  We won't make assumption about the direction of the address space  

__Simplicity__ of free-space management  
  Just find enough free pages  

__Per-process__ page table  
keeps track of where virtual pages are in physical memory  


##Page Tables  

These page tables could get very big...  

We can't store this on special MMU hardware  
we store it in memory (OS controlled memory)  

What makes up a page table entry?  

Page tables map virtual page numbers to physical page frames  
Many data structures could do this  
The simplest is a linear array indexed by the VPN  

Each page table entry (PTE):  
- __valid bit__ is this bit valid (allocated?)  
- __protection bit__ read/write/execute?  
- __present bit__ in memory?  
- __dirty bit__ changed?  
- __reference bit__ accessed?  
- more bits describing caching, modes, etc  


##Slow  

Paging is slow.  

__See figure 18.6: Accessing Memory with Paging in OSTEP__  

Recall how many memory lookups a simple instruction add.  

```  
movl 21, %eax  
```  


##TLB  

We said before the page table was too big to store on the MMU  
But we could store some of it in a cache  

We call that cache the Translation-lookaside buffer  
(It should really be called address-translation cache)  

We'll first look at a simple case  
- assume a linear page table  
- assume a hardware-managed TLB  


##TLB  

__TLB Control Flow Algorithm__  

```c  
VPN = (VirtualAddress & VPN_MASK) >> SHIFT  
(Success, TlbEntry) = TLB_Lookup(VPN)  
if (Success == True) // TLB Hit  
    if (CanAccess(TlbEntry.ProtectBits) == True)  
        Offset = VirtualAddress & OFFSET_MASK  
        PhysAddr = (TlbEntry.PFN << SHIFT) | Offset  
        AccessMemory(PhysAddr)  
    else  
        RaiseException(PROTECTION_FAULT)  
else // TLB Miss  
    PTEAddr = PTBR + (VPN * sizeof(PTE))  
    PTE = AccessMemory(PTEAddr)  
    if (PTE.Valid == False)  
        RaiseException(SEGMENTATION_FAULT)  
    else if (CanAccess(PTE.ProtectBits) == False)  
        RaiseException(PROTECTION_FAULT)  
    else  
        TLB_Insert(VPN, PTE.PFN, PTE.ProtectBits)  
        RetryInstruction()  
```  


##TLB array  

Let's look at an example of memory access in a tiny array.  

Say we have some code like:  

```c  
int sum = 0;  
for (i=0; i<10; i++) {  
    sum += a[i];  
}  
```  

Let's simplify and ignore every memory access except the array  

__Look at Figure 19.2: An Array In A Tiny Address Space ([OSTEP](http://pages.cs.wisc.edu/~remzi/OSTEP/vm-tlbs.pdf))__

Spatial locality
Consider the effect of page sizes
Temporal locality


##TLB Miss

Who handles the TLB miss?

Older CISC architectures like x86 handle the TLB in hardware
Modern RISC architectures have software managed TLB

Software:
On a TLB miss the hardware traps to kernel
Kernel handles TLB miss (instructions to update TLB)
return-from-trap

How does the TLB miss return-from-trap need to differ from before?


##TLB OS  

With software handled TLB misses the OS needs to be careful  
we don't want to get stuck with infinite TLB misses  

Keep TLB miss handlers in physical memory
(no virtual to physical mapping)
Hard wire permanent translations

The software approach offers:
- flexibility
- simplicity (see simplified algorithm below)


##TLB OS  

__TLB Control Flow Algorithm (OS Handled)__  

```c  
VPN = (VirtualAddress & VPN_MASK) >> SHIFT  
(Success, TlbEntry) = TLB_Lookup(VPN)  
    if (Success == True) // TLB Hit  
        if (CanAccess(TlbEntry.ProtectBits) == True)  
            Offset = VirtualAddress & OFFSET_MASK  
            PhysAddr = (TlbEntry.PFN << SHIFT) | Offset  
            Register = AccessMemory(PhysAddr)  
    else  
        RaiseException(PROTECTION_FAULT)  
else // TLB Miss  
    RaiseException(TLB_MISS)  
```  


##TLB contents

Let's consider the contents of the TLB

VPN  |  PFN  |  other bits

Both VPN and PFN as TLB cache is fully associative
(It is read entirely each time)

Other bits:
- valid bit
- protection bit
- ASID
- dirty bit

The valid bit is different from the PTE valid bit.


##TLB Context Switch

The TLB contains VPN -> PFN mappings that are only valid for running process
(this is what the valid bit is for)

We need a way to flush the TLB
In software implementations there is an instruction to flush
In hardware implementations the flush might happen whenever PTBR changes

However, flushing obviously has a cost.

The ASID can help!

Address Space Identifier
(think of it like a PID for address spaces)


##Replacement Policy

We will look at this more in depth when we discuss disk paging...

For now, consider two policies:
- least-recently-used
- random

When might random be better than least-recently-used?


##Real TLB Entry

Lets look at section 19.7 in [OSTEP](http://pages.cs.wisc.edu/~remzi/OSTEP/vm-tlbs.pdf) and see a real MIPS TLB entry.
