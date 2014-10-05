##Terminology

Segmentation - logically divide our memory into different sized segments
Paging - divide our memory into fixed size pages
Page Table - contains the virtual to physical translations per process
TLB - a very fast cache for virtual to physical translations
PTE - page table entry, has VPN, PFN, bits for validity, protection, dirty
TLB miss - when no valid VPN->PFN exists in the TLB

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

##Performance
Spatial locality, Consider the effect of page sizes, Temporal locality



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

Address Space Identifier
(think of it like a PID for address spaces)


##Beyond Physical Memory

We've been assuming our address space is small
Small enough to fit in physical memory

In fact we assumed all our address spaces could fit in physical memory

Now we want to support many concurrently-running large address spaces!

Our current memory hierarchy has two levels:
Transaction look-aside buffer (very fast, very small)
Physical memory (fast, much larger)

we are going to add
Swap space (slow, very large)

