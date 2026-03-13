This document describes how to install 640k of RAM on the system board in the
IBM XT and the IBM portable (which uses the same mother board).

Parts list:

Quantity    Description
---------------------------------------------------------------
18	 256k by 1 Dynamic RAM chips (any of the following)

Manufacturer	    Part number
----------------------------------
Fujitsu 	    MB81256-15
Hitachi 	    HM50257-15
Mitsubishi	    M5M4256-15
NEC		    UPD41256-15
OKI		    MSM41256-15
TI		    TMS4256-15
Toshiba 	    TMM41256-15

1	74LS158 Decoder/multiplexer Integrated circuit

IBM XT Instructions:

1.  Turn off the system unit, and disconnect the power cables, monitor and
keyboard cables and any cables that may be connected to expansion boards.
Remove	the monitor and the keyboard.  Place the System unit in a convenient
work area.
2.  Take off the cover from the system unit by removing the 5 screws on the
back (4 corners and top center), slide the cover forward and tip up to remove
completely.
3.  Take out any boards installed in the expansion slots by removing the hold
down screw at the rear of the chassis, and pulling the card straight up.
4. The floppy disk drives will have to be removed to gain access to portions of
the mother board.  This is done by removing the screws on the left side of  the
drive(s).  Gently slide the drive(s) out of the unit far enough to get at  the
cables plugged into the back of them.  Making note of where each cable goes,
remove the data and power cables by gently pulling them away from the drive.
When the cable are off, remove the drive(s) from the chassis and set them
aside.
5.  Refer to figure 1 and locate the jumper block labeled E2 on the
motherboard.  It is located near the edge of the board near the power supply.
6.  A jumper has to be installed between pads 1 and 2 on E2.  This can be done
without removing the mother board using a short piece of wire.	Hold the wire
with a pair of needle nose pliers and heat up one of the pads with a soldering
iron.  When the solder melts, push the wire into the pad and remove the
soldering iron.  Do the same thing with the other end of the wire and pad.
7.  Refer to figure 1 and locate the IC socket labeled U84 on the mother board.
This will be an empty socket near the front of the board, underneath  where the
floppies were mounted.	Install the 74LS158 chip in this socket making	sure
pin 1 (marked with a dot or notch) is pointing away from the front panel.
8.  Remove the 64k RAM chips in the rows labeled BANK 0 and BANK 1 (9 in each
bank) on the mother board using an IC puller.  If you currently only have 128k
of memory on the mother board (BANK's 2 and 3 empty) you can move these chips
to  those banks.  Be careful not to damage the pins when removing them (you can
sell  them to a friend whose machine has amnesia).
9.  Install the 256k RAM chips in the now empty sockets of BANK 0 and BANK 1
making sure they are installed correctly with pin 1 pointing away from the
front  panel.  You should now have 2 banks (0 and 1) of 256k RAM chips, and 2
banks (2  and 3) of 64k RAM chips, giving you a total of 640k.
10. Refer to figure 1 and locate the switch block, SW1 on the mother board.
Make sure that switch positions 3 and 4 are in the OFF position.
11. Re-install the floppy drive(s) by sliding them into the front panel about
half way and reconnect the data and power cables in the same locations they
came  off of.  Push the drive(s) the rest of the way in and anchor them with
the  screws removed earlier.
12. Re-install the your expansion boards (minus any memory boards that used to
be in the system) in the reverse order of when you took them out. 13. Put the
cover back on, re-connect the cables and install your monitor and keyboard.

------------------------------------------------------------------------

.	 EXPANSION
.	  SLOTS


---------------------------------------------

------------------------------------
.	      BANK 0					       ----
------------------------------------			      E 12
------------------------------------			      2 34
.	      BANK 1				  ---	       ----
------------------------------------		   S
------------------------------------		   W
.	      BANK 2				  1
------------------------------------		   ---
------------------------------------
.	      BANK 3		     ---
------------------------------------  U
.				       8
.				       4
---
------------------------------------------------------------------------
Figure 1
(XT/Portable motherboard)
