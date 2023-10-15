Design:

The wiznet device will have a major device number of 8.
The key to our sockets will be the minor device number.  Numbers
0-7 will refer to actual sockets, while 8 refers to a debugging
port and 9-11 refer to a protocol.

Opening a protocol device will result in the allocation of an actual
socket, and will initialize the socket_t record with callbacks specific
to that protocol.

This means we will have some unusual minor device numbers for the standard
ip device files:

   8  - /dev/winfo   // debugging port - any action here causes dump
   9  - /dev/wip
   10 - /dev/tcp
   11 - /dev/udp

The central structure will be an array of 10 socket_t records.  When
a protocol device is opened, its socket_t record will be copied to
the allocated socket slot (thus setting up the proper callbacks).

We will require that the /dev/wip device is first set up with the
proper host address, netmask and gateway.

Writes to any socket will be blocking - the device is fast enough that
we don't need to worry about wasting time busywaiting.  Until I find
a good use case otherwise, sockets will be owned by a single process,
so we need not have message queues attached.  Only 1 suspended
command will be supported per socket.  My hope is that this simplifies
things considerably.

Not sure whether I need a response queue.  Need to understand better when
I can send a delayed response and when it might need to be blocked.

** Looks like I can reply immediately after getting a message from
   FS, and before I process that new message.  Also, if it's a cancel,
   looks like I cancel the proper message and return.
   The other revives should happen before the cancel, because we return
   after sending the revive on the cancelled message.  It does not appear
   that we reply to the cancel message in the case that we find the
   message to cancel and do a send() cancelling it.

open and close always reply (never block)
cancel will reply if message result is EINTR, and not reply otherwise.  (What
is the not replay case?)

for cancel, responses appear to be EAGAIN (resource temporarily not
available), EINTR (interrupted syscall) or OK (cancel succeeded).  They
appear to be using EAGAIN to mean they didn't find the message to
cancel on the particular queue they were looking at.  Expected final
messages are OK and EINTR. (actually, the FS may always expect EINTR, and
the OK is just used internall to detect whether to send a reply).

I think all of this is moot for us if we can get away with a single
blocked message per socket.   Should always be a message waiting (if not,
return EAGAIN & output warning).



