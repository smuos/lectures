Distributed Systems
===================

__Disclaimer__: There is enough out there to fill and entire course on distributed systems. We will unfortunately only introduce the topic.

How do we handle failure?

Other concerns with distributed systems:

- performance
- security
- communication

Communication Basics
--------------------

Packet loss is fundamental.

Even with working components, we still have finite buffers.

Treat communication as unreliable.

__UDP__

`ack`, acknowledgment.

timeout/retry

sequence counter

__TCP__ is the most common reliable communication layer.


Distributed shared memory (DSM)
------------------------------

Resulting from research considering OS abstractions.  
Many machines share and address space.  
On a memory access request we could have the page locally, or we page fault to the network.  

How would you handle failure here?

We don't want parts of our address space to disappear.  
Additionally, performance is a concern.  

"Though much research was performed in this space, there was little practical impact;  
nobody builds reliable distributed systems using DSM today."  


Remote Procedure Call (RPC)
---------------------------

RPC is a programming language abstraction (in contrast to an OS abstraction).  
Makes remote code execution look like a local function.  

Stub Generator

Also known as a protocol compiler  
Handles function arguments  

The input could be as simple as:

```c
interface {
    int func1(int arg1);
    int func2(int arg1, int arg2);
};
```

This generate a server stub that exports the functions.  
It also generates a client stub which contains everything necessary to perform the RPC.  

The client just sees a normal function call, for example, `func1()` does the following:

- Create a message buffer
- Build the message
- Send the message to the server
- Wait for a reply
- Handle the reply
- Return to the caller

The server code does the following:

- Unpack the message
- Call into the actual function
- Package the results into a reply
- Send the reply

Consider some issues:
- How do we send complex data structures.
- Concurrently handling requests. (thread pool)
- How do we locate a remote server? (IPs, and ports)
- What protocol do we build RPC on top of? (TCP or UDP)
- How do we handle long running RPC calls?
- Do we offer asynchronous options?


