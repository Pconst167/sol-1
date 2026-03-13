^S  
0-0-0-0-0-0-0-0-0-0-0-0
AppleMouse Programming

    Typed by Z-Man
0-0-0-0-0-0-0-0-0-0-0-0

The following information is for advanced assembly language programmers who wish to use the AppleMouse in their programs.  It is assumed that the reader understands the registers of the 6502 (65c02) microprocessor and understands the different addressing modes.

FINDING THE MOUSE

The AppleMouse II may be installed in any of the peripheral device slots 1 through 7 of the Apple II, II Plus, or IIe (and IIc without the use of a slot).  Installationg in slot 4 is recommended but not required.  Whereever it is installed, however, it places the following signature bytes in the Apple main memory, where n is its slot number:

Address         Contents
$Cn0C           $20
$CnFB           $D6

Thus, your program can located the mouse by scanning all memory locations of the forms show here for values of n from 1 to 7, looking ofr the occurences of both signature bytes.

SETTING THE OPERATING MODE

When power is applied to the Apple system, the mouse subsystem comes up in the off condition, with its position registers cleared to 0.  To activate the mouse, you must load a modem byte in the 6502 accumulator and call the firmware routine SETMOUSE.  Only the low-order 4 bits of the mode byte are significant:

Bit 0     Turn mouse on
    1     Enable interrupts on mouse movement
    2     Enable interrupts when button pressed
    3     Enable interrupts every screen refresh
Bits 4-7  Reserved

Any combination of interrupts may be invoked.  Mode byte values above $0F will cause SETMOUSE to return an illegal mode error.
When your program executes SETMOUSE with a mode byte of $01, it invokes 'passive mode'.  With any other legal byte, it invokes one of the 'interrupt modes'.  These modes will be described later.

READING MOUSE DATA

Mouse position and button status data are placed in specific memory locations called 'screen holes'.  These are where your program looks to find out what the mouse has been doing:

$478 + n        Low byte of X position
$4F8 + n        Low byte of Y position
$578 + n        High byte of X position
$5F8 + n        High byte of Y position
$678 + n        Reserved
$6F8 + n        Reserved
$778 + n        Button and interrupt status
$7F8 + n        Current mode

In the foregoing addresses, n is the mouse's slot number, which is added to the base address.  For example, if the mouse lives in slot 4, the low byte of its X position will be stored at address $47C.
In the mouse's normal working position (with its tail away from the user), X increses as the mouse is moved toward the right, and Y increases as it is moved toward the user..  The mouse subsystem measures X and Y movement in increments of approximately 0.020 inch (0.5 mm) over a maximum range of -32768 to +32767 (or 0 to +65535).  However, both measurements are normally clamped to the rage of $0 to $3FF (0 to 1023 decimal).  Your program cn change tese clamping boundaries by executing CLAMPMOUSE, as explained later.

The button and interrupt status byte conveys the following information, where a bit set to 1 indicates true:

Bit  7  Button is down
     6  Button was down at last reading
     5  X or Y changed since last reading
     4  Reserved
     3  Interrupt caused by screen refresh
     2  Interrupt caused by button press
     1  Interrupt caused by mouse movement
   `   Reserved

PASSIVE MODE

In passive mode, the mouse does not send any interrupts to the main system.  All position and button interpretation is performed on the peripheral card, and the resulting data are stored there without disturbing other routines.  When you call READMOUSE, mouse information is transferred from the peripheral card to the screen holes in the main Apple memory, where your program can read it.
Passive mode represents the simplest way to manage the mouse because the operation of the mouse sybsystem does not interrupt the main program.  This is an important feature in applications where the mouse must function at the same time as noninterruptible peripheral devices.

INTERRUPT MODES

In the various interrupt modes, the mouse interrupts the main system whenever specific events occur.  This allows your program to read mouse data and process the resulting information only when there is a significant change, instead of having constantly to poll the mouse.  Dependig on the mode byte implanted by SETMOUSE, the interrupt events can be any one or more of the following:

Mouse motion in any direction
Button being pressed
Screen refresh (every 1/60th second)

Upon detecting a valid interrupt event, the mouse subsystem sends and interrupt (IRQ) instruction to the Apple's microprocessor at the end of the current monitor screen writing cycle. This allows your program to service the interrupt during the screen's vertical blanking (retrace) cycle.
If your program invokes one of the interrupt modes, it must contain an interrupt-handling routine.  At a minimum, this routine must call SERVEMOUSE. SERVEMOUSE determines whether or not the interrupt was caused by the mouse, so your program can call READMOUSE if it was.  Your interrupt-handlng routine may also call other firmware routines, such as CLEARMOUSE, if you want.

MOUSE ROUTINES

The AppleMouse II firmware contains eight routines that your program may call.  Except for SERVEMOUSE, your program must load the following values before calling any of them (n is the mouse slot number again):

$Cn in the X register
$n0 in the Y register

Upon exiting any of these routines, the contents of the accumulator and X and Y registers will be undefined, except as noted in the following sections.  Except for SERVEMOUSE, the status of the carry bit (C) indicates whether or not the routine was successfully executed:

C = 0   Successful execution
C = 1   Error condition

SETMOUSE

SETMOUSE starts up mouse operation according to the mode byte it finds in the accumulator.  If C = 1 on exiting, the mode byte was illegal (greater than $0F).  This routine does not clear any data registers or screen holes.

SERVEMOUSE

If an interrupt was cause by the mouse, SERVEMOUSE updates the status byte ($778 + n) to show which event caused the interrupt.  Upon exiting, SERVEMOUSE sets C to 0 if the interrupt was caused by the mouse and sets C to 1 otherwise.  SERVEMOUSE does not transfer data to the screen holes.

READMOUSE

READMOUSE transfers current mouse data to the screen holes.  It sets bits 1,2 and 3 in the status byte ($778 + n) to 0.

CLEARMOUSE

CLEARMOUSE sets the mouse's X and Y position values to $0, both on the peripheral card and in the screen holes.  The button and interrupt status byte remain unchanged.

POSMOUSE

POSMOUSE sets the position registers on the peripheral card to the values it finds in the X and Y position screen holes.
WARNING - DO NOT TRY TO CHANGE THE CONTENTS OF ANY SCREEN HOLES EXCEPT THE X AND Y POSITION BYTES.

CLAMPMOUSE

CLAMPMOUSE establishes new value boundaries for mouse position data.  The default range for X and Y position values is $0 to $3FF.  CLAMPMOUSE changes the numeric limits of either the X or Y register on the mouse peripheral card, depending on the value it finds in the accumulator:

If A = 0        it changes the X coordinate limits
If A = 1        it changes the Y coordinate limits

The new boundaries are read from the Apple main memory:

$478    Low byte of lower boundary
$4F8    Low byte of higher boundary
$578    High byte of lower boundary
$5F8    High byte of higher boudary

CLAMPMOUSE destroys the contents of the mouse's X and Y position screen holes; to restore them, your program must follow it with READMOUSE.

HOMEMOUSE

HOMEMOUSE sets the mouse posistion registers on the peripheral card to their lower boundaries (equivalent to the upper-left corner of a screen image of the clamping window).  HOMEMOUSE does not update the screen holes; to change the screen-hole values to home posistion, your program must follwow it with READMOUSE.

INITMOUSE

INITMOUSE sets the intermal default values for the mouse subsystem and synchronizes it with the monitor screen's vertical blanking cycle.  Your program must call INITMOUSE before any other mouse routnes.  A typical sequence to initialize a mouse application program would be

INITMOUSE
SETMOUSE
CLEARMOUSE

With the Apple II and Apple II Plus, INITMOUSE overwrites page 1 of the graphics screen memory; hence, your program should call it before creating any screen displays.

CALLIG THE MOUSE ROUTINES

The mouse firmware contains a table that gives you the low bytes of the entry addresses of its routines.  The high byte is always $Cn, where n is the mouse slot number.  This table occupies addresses $Cn12 through $Cn19:

-------------------------------------------------
$Cn12   Low byte of SETMOUSE entry point address
$Cn13   Low byte of SERVEMOUSE entry point address
$Cn14   Low byte of READMOUSE entry point address
$Cn15   Low byte of CLEARMOUSE entry point address
$Cn16   Low byte of POSMOUSE entry point address
$Cn17   Low byte of CLAMPMOUSE entry point address
$Cn18   Low byte of HOMEMOUSE entry point address
$Cn19   Low byte of INITMOUSE entry point address
--------------------------------------------------

Thus, for example, if the mouse lives in slot 4, the entry point for the routine SETMOUSE can be calculated by adding $C400 to the contents of address $C412.  Your program can use these values as the basis for constructomg a jump table (an arrary of values used for JMP instructions with indirect addressing), from which it can call al the mouse routines.

:){
