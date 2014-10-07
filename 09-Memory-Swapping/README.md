##Terminology  
  
Segmentation - logically divide our memory into different sized segments  
Paging - divide our memory into fixed size pages  
Page Table - contains the virtual to physical translations per process  
TLB - a very fast cache for virtual to physical translations  
PTE - page table entry, has VPN, PFN, bits for validity, protection, dirty  
TLB miss - when no valid VPN->PFN exists in the TLB  
  
##Performance  
Spatial locality, Consider the effect of page sizes, Temporal locality  
  
  
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
  
  
##Page Fault  
  
When a requested page is not in physical memory, we get a page fault.  
  
TLB misses could be handled by hardware or software  
Page Faults are always handled by the OS  
- page faults to disk are slow  
- hardware doesn't know how to issue I/Os to disk  
  
How does the OS know where to look?  
Make use of the PTE present bit, and store disk address instead of PFN  
  
A page fault handler:   
- requests the page from disk  
- updates the PTE to mark the page as present, updates PFN  
- retries the instruction (possibly resulting in TLB miss)  
  
While the disk request is being serviced the process is __blocked__  
The OS is free to perform other tasks  
(remember disk I/O is slow!)  
  
  
##Full Memory  
  
Above we assumed we had room in physical memory to swap a page from disk into  
When this is not the case we need to evict pages from memory...  
  
We need a replacement policy!  
  
Our replacement policy should act to minimize __average memory access time__  
  
AMAT = (Hit% * Tm)+(HIT% * Td)  
  
A typical Tm (memory time) value might be 100 nanoseconds  
A typical Td (disk time) value might be 10 milliseconds  
Huge difference  
  
  
##Optimal Replacement  
  
The optimal replacement policy involves looking into the future  
If we could, we replace the page accessed furthest in the future.  
  
This is obviously unrealistic  
  
Act as a comparison.  
We can't have a perfect hit rate with a limited cache size  
We use optimal replacement to compare other realistic algorithms  
  
Let's checkout some chart in the text to learn about realistic replacement algorithms!  
[OSTEP](http://pages.cs.wisc.edu/~remzi/OSTEP/vm-beyondphys-policy.pdf)  
  
