

Well, here's my 3 cents worth on LPT/COM port addresses and IRQ's:
 
The "standard" addresses for the LPT and COm ports are:
           COM1   3F8   IRQ4
           COM2   2F8   IRQ3
           COM3   2E8   IRQ4
           COM4   2E0   IRQ3
           LPT1   3BC   IRQ7
           LPT2   378   IRQ7
           LPT3   278   IRQ5
 
However,....   I have also seen LPT2 use IRQ5 and LPT3 use IRQ7!!!
               COM3 and COM4 addresses are not really that "standard",
                 and COM4 especially may vary depending on your board.
 
I believe that the using IRQ7 for all LPT ports in a system works fine,
LPT ports seem to share IRQ's just fine.  This is not nearly as true for
COM ports, although in most cases the pairs COM1/3 {IRQ4) and COM2/4
(IRQ3) work fine.  Some COM boards/modems are just not happy sharing an
IRQ with another COM port/modem!!  If you have trouble with a COm port
in a machine with more than two ports, try disabling/removing the other
member of the pair and see if the problem goes away.
 
I have also seen some software that is hardcoded to expect the above
address/IRQ "standard" settings, even though most CO{ boards allow you
to m{x and match (say COM2 using IRQ 2,4 or 5)!!  Unless you are setup
for non-standard IRQ #'s to avoid some other IRQ conflict, it's best to
stick to the "standards".
 
For an explaination of when COM1 isn't COM1 see the message I will post
titled COM/LPT ports and their addresses.  It explains how the BIOS
determines how to assign the COM1/2/3/4 & LPT1/2/3 device names to a
hardware port at a particular address.

------

One of the most confusing things about how PC hardware is configured has
to do with the way the BIOS assigns device names (COM1, COM2, etc)
to a hardware port.
 
Most users think that by addressing their serial board at address 2F8,
that they have set that port up as COM2.  This is not always true!!!
If this poor user didn't have a serial port at address 3F8 (COM1's
"standard" address), then their port at 2F8 will be given the device
name COM1!!!!!!  How can this be???  Well, let me explain.
 
When your machine boots and the BIOS does its initialization magic, it
goes out to the hardware of your system, and checks certain addresses
(in a fixed order) for serial ports and parallel ports.  The first
serial port it finds is given the DOS device name "COM1".  The second is
given the name "COM2", and so on for up to 4 serial ports.  Parallel
ports are given device names in the same way.  The first port found gets
the device name "LPT1" and so on.
 
Serial ports are searched for at addresses (in this order!):
    3F8   2F8   2E8   2E0
Parallel ports are searched for at (in this order):
    3BC   378   278
 
As I said before, the first port of each type found gets the first
device name (COM1 or LPT1), the second gets the second (COM2 or LPT2),
and so on.  Thus in the simple example above, since the first address in
the serial port list that the BIOS finds an actual serial port at is 2F8
(the "standard" COM2 address), that port gets the device name COM1 !!!
 
The only reason I have figured out for this, is so that if a user only
has one serial port on their machine, they can just call it COM1, they
don't have to know hosw it's addressed.  This causes problems for some
dumb software that assumes that serial/parallel ports use the "standard"
IRQ (interrupt request) assignments.  In the example, the user has a
serial port that looks to DOS like it's COM1, but the IRQ is probably
comfigured to COM2's "Standard" IRQ (IRQ.  If a dumb piece of software
says, "Gee, I'm using COM1, so it must be using IRQ4.  I'll setup~r the
IRQ4 interrupt vector so I'll get the interrupts for that po!!"
The problem is that the software will NEVER see the ports interrupt (it
is actually using IRQ3)!!!  No interrupts = No data transfer!!!!!
 
Most programs (TELIX, PROCOMM, etc.) allow the user to change the
port address/IRQ information (for that program only!), so that they can
correctly access the serial ports.  NOTE: Parallel ports don't seem to
have these sorts of problems.

	-Fafhrd