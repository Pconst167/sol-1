****************************************
*     B U C K A R O O  B A N Z A I     *
*	  aka the Reset Vector	       *
*				       *
*	       presents 	       *
*				       *
*	 Cracking On the IBMpc	       *
*		Part I		       *
*				       *
****************************************

Introduction
------------
  For years, I have seen cracking tutorials for the APPLE computers, but never
have I seen one for the PC.  I have decided to try to write this series to help
that pirate move up a level to a crackest.

  In this part, I will cover what happens with INT 13 and how most copy
protection schemes will use it.  I strongly suggest a knowledge of Assembler
(M/L) and how to use DEBUG.  These will be an important figure in cracking
anything.

INT-13 - An overview
--------------------
  Many copy protection schemes use the disk interrupt (INT-13).  INT-13 is
often use to either try to read in a illegaly formated track/sector or to
write/format a track/sector that has been damaged in some way.

  INT-13 is called like any normal interupt with the assembler command INT 13
(CD 13).  [AH] is used to select which command to be used, with most of the
other registers used for data.

INT-13 Cracking Collage
-----------------------
  Although, INT-13 is used in almost all protection schemes, the easiest to
crack is the DOS file.	Now the protected program might use INT-13 to load some
other data from a normal track/sector on a disk, so it is important to
determine which tracks/sectors are inportant to the protection scheme.	I have
found the best way to do this is to use LOCKSMITH/pc (what, you don't have LS.
Contact your local pirate for it.)

  Use LS to to analyze the diskette.  Write down any track/sector that seems
abnormal.  These track are must likely are part of the protection routine.

  Now, we must enter debug.  Load in the file execute a search for CD 13.
Record any address show.  If no address are picked up, this mean 1 or 2 things,
the program is not copy protected (bullshit) or that the check is in an other
part of the program not yet loaded.  The latter being a real bitch to find, so
I'll cover it in part II.  There is another choice.  The CD 13 might be hidden
in self changing code.	Here is what a sector of hidden code might look like

-U CS:0000
1B00:0000 31DB	   XOR	  BX,BX
1B00:0002 8EDB	   MOV	  DS,BX
1B00:0004 BB0D00   MOV	  BX,000D
1B00:0007 8A07	   MOV	  AL,[BX]
1B00:0009 3412	   XOR	  AL,12
1B00:000B 8807	   MOV	  [BX],AL
1B00:000D DF13		  FIST	 WORD...

  In this section of code, [AL] is set to DF at location 1B00:0007.  When you
XOR DF and 12, you would get a CD(hex) for the INT opcode which is placed right
next to a 13 ie, giving you CD13 or INT- 13.  This type of code cann't and will
not be found using debug's [S]earch command.

Finding Hidden INT-13s
----------------------
  The way I find best to find hidden INT-13s, is to use a program called
PC-WATCH (TRAP13 works well also).  This program traps the interrupts and will
print where they were called from.  Once running this, you can just disassemble
around the address until you find code that look like it is setting up the disk
interupt.

  An other way to decode the INT-13 is to use debug's [G]o command.  Just set a
breakpoint at the address give by PC-WATCH (both programs give the return
address).  Ie, -G CS:000F (see code above).  When debug stops, you will have
encoded not only the INT-13 but anything else leading up to it.

What to do once you find INT-13
-------------------------------
  Once you find the INT-13, the hard part for the most part is over.  All that
is left to do is to fool the computer in to thinking the protection has been
found.	To find out what the computer is looking for, examine the code right
after the INT-13.  Look for any branches having to do with the CARRY FLAG or
any CMP to the AH register.

  If a JNE or JC (etc) occurs, then [U]nassembe the address listed with the
jump.  If it is a CMP then just read on.

  Here you must decide if the program was looking for a protected track or just
a normal track.  If it has a CMP AH,0 and it has read in a protected track, it
can be assumed that it was looking to see if the program had successfully
complete the READ/FORMAT of that track and that the disk had been copied thus
JMPing back to DOS (usually).  If this is the case, Just NOP the bytes for the
CMP and the corrisponding JMP.

  If the program just checked for the carry flag to be set, and it isn't, then
the program usually assumes that the disk has been copied.  Examine the
following code

      INT 13	  <-- Read in the Sector
      JC 1B00	  <-- Protection found
      INT 19	  <-- Reboot
1B00  (rest of program)

  The program carries out the INT and find an error (the illegaly formatted
sector) so the carry flag is set.  The computer, at the next instruction, see
that the carry flag is set and know that the protection has not been breached.
In this case, to fool the computer, just change the "JC 1B00" to a "JMP 1B00"
thus defeating the protection scheme.

  NOTE:  the PROTECTION ROUTINE might be found in more than just 1 part of the
program


Handling EXE files
------------------
  As we all know, Debug can read .EXE files but cannot write them.  To get
around this, load and go about cracking the program as usual.  When the
protection scheme has been found and tested, record (use the debug [D]ump
command) to save + & - 10 bytes of the code around the INT 13.

  Exit back to dos and rename the file to a .ZAP (any extention but .EXE will
do) and reloading with debug.

  Search the program for the 20+ bytes surrounding the code and record the
address found.	Then just load this section and edit it like normal.

  Save the file and exit back to dos.  Rename it back to the .EXE file and it
should be cracked.  ***NOTE:  Sometimes you have to fuck around for a while to
make it work.

DISK I/O (INT-13)
-----------------
  This interrupt uses the AH resister to select the function to be used.  Here
is a chart describing the interrupt.

AH=0	Reset Disk
AH=1	Read the Status of the Disk
	system in to AL

    AL		Error
  ----------------------------
    00	 - Successful
    01	 - Bad command given to INT
   *02	 - Address mark not found
    03	 - write attempted on write prot
   *04	 - request sector not found
    08	 - DMA overrun
    09	 - attempt to cross DMA boundry
   *10	 - bad CRC on disk read
    20	 - controller has failed
    40	 - seek operation failed
    80	 - attachment failed
(* denotes most used in copy protection)
AH=2	Read Sectors

  input
     DL = Drive number (0-3)
     DH = Head number (0or1)
     CH = Track number
     CL = Sector number
     AL = # of sectors to read
  ES:BX = load address
  output
      AH =error number (see above)
	  [Carry Flag Set]
      AL = # of sectors read

AH=3 Write (params. as above)
AH=4 Verify (params. as above -ES:BX)
AH=5 Format (params. as above -CL,AL
	     ES:BX points to format
	     Table)

  For more infomation on INT-13 see the IBM Techinal Reference Manuals.

Comming Soon
------------
  In part II, I will cover CALLs to INT-13 and INT-13 that is located in
diffrents overlays of the program


Happy Cracking.....
	Buckaroo Banzai
       <-------+------->

PS: This Phile can be Upload in it's
unmodified FORM ONLY.

  PPS:	Any suggestion, corrections, comment on this Phile are accepted and
incouraged.....

