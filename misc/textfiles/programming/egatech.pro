From: PC-Share, to CIS via Ward Christensen 76703,302  03/10/85

<<< NOTE EGA-TECH - 597 LINES >>>

Technical Information on the Enhanced Graphics Adapter
EXT-Info-IBMPC-1VFRR 23-Feb-85 Info-IBMPC Digest V4 #17
From: {Info-IBMPC Digest <Info-IBMPC@USC-ISIB.ARPA>}DDN
To: {Info-IBMPC: ;}DDN
Identifier: EXT-Info-IBMPC-1VFRR
Length: 5 page(s)[estimate]
Posted: 23-Feb-85 13:10-PST  Received:  5-Mar-85 09:14-PST
Message:
Return-path: <INFO-IBMPC@USC-ISIB.ARPA>
Received: from USC-ISIB.ARPA by OFFICE-2.ARPA; 23 Feb 85 15:44:23 PST
Info-IBMPC Digest       Saturday, 23 February 1985      Volume 4 Issue 17

This Week's Editor: Billy Brackenridge

Today's Topics:

Extended Graphics Adaptor Tech Info

How I Got my EGA Manual, a True Story



Date: 23 Feb 1985 11:57:04 PST
Subject: Extended Graphics Adaptor Tech Info
From: Billy <BRACKENRIDGE@USC-ISIB.ARPA>

Here is a bit more technical information on the extended graphics adaptor
card. It still isn't complete, but it is a start:

The adapter memory (base) is configured a 4 16K bit planes. The graphics
memory expansion adds one bank of 16K to each of the 4 bit planes. Additional
memory may be added to increase each bit plane by another 16K.

Modes of Operation

IBM Color Display

                        Alpha   Buffer   Box   Max
 Mode #  Type   Colors  Format  Start    Size  Pages   Resolution
 ------  ----   ------  ------  ------   ----  -----   ----------
   0     A/N      16    40x25   B8000    8x8    8       320x200
   1     A/N      16    40x25   B8000    8x8    8       320x200
   2     A/N      16    80x25   B8000    8x8    8       640x200
   3     A/N      16    80x25   B8000    8x8    8       640x200
   4     APA       4    40x25   B8000    8x8    1       320x200
   5     APA       4    40x25   B8000    8x8    1       320x200
   6     APA       2    80x25   B8000    8x8    1       640x200
   D     APA      16    40x25   A8000    8x8    2/4/8   320x200
   E     APA      16    80x25   A8000    8x8    1/2/4   640x200

Modes 0-6 emulate CGA adapter support.

Modes 0,2,5 are identical to 1,3,4 at the adapters direct drive interface.

The maximum page fields for modes D and E indicate the number of pages for
64k,128k,256k bytes of graphics memory.

IBM Monochrome Display

                        Alpha   Buffer   Box   Max
 Mode #  Type   Colors  Format  Start    Size  Pages   Resolution
 ------  ----   ------  ------  ------   ----  -----   ----------
   7     A/N       4    80x25   B0000    9x14   8       720x350
   F     APA       4    80x25   A0000    8x14   1/2     640x350

Mode 7 provides Mono adapter emulation support.

IBM Enhanced Color Display

                        Alpha   Buffer   Box   Max
 Mode #  Type   Colors  Format  Start    Size  Pages   Resolution
 ------  ----   ------  ------  ------   ----  -----   ----------
   0*    A/N    16/64   40x25   B8000    8x14   8       320x350
   1*    A/N    16/64   40x25   B8000    8x14   8       320x350
   2*    A/N    16/64   80x25   B8000    8x14   8       640x350
   3*    A/N    16/64   80x25   B8000    8x14   8       640x350
   10    APA     4/64   80x25   A8000    8x14   1/2     640x350
   16/64

* Note that modes 0,1,2,3 are also listed under Color Display. BIOS provides
support when enhanced display is attached.

The values in "Colors" indicates 16 colors out of a palette of 64 or 4 colors
out of 16.

Basic Operations

   Alphanumeric Modes

      The data format for alpha modes on the EGA is the same as the data
      format on the CGA and Mono adapter cards.

      As an added function, bit three of the attribute byte may be
      re-defined by the Character map select register to act as a switch
      between character sets. This gives the programmer access to 512
      characters at one time. This function is valid only when you have
      128K or more of graphics memory.

      When alpha mode is selected, BIOS transfers character patters from
      ROM into bit plane 2. The processor stores character data into
      plane 0, and the attribute into plane 1. The programmer views
      planes 0 and 1 as a single buffer in alpha modes.

      The CRTC generates sequential addresses, and fetches one character
      code byte and one attribute byte at one time. The character code
      and row scan count address bit plane 2, which contain the character
      generators. The appropriate dot patterns are then sent to the
      palette in the attribute chip, where the color is assigned
      according to the attribute data.

      Graphics Modes

      320x200 Two and Four Color Graphics (Modes 4 and 5)
      --------------------------------------------------- Addressing,
      mapping, and data format are the same as the 320x200 pel mode of
      the CGA. The display buffer is at B8000. The bit image is stored in
      bit planes 0 and 1.

      640x200 Two Color Graphics (Mode 6)

      -----------------------------------

      Addressing, mapping and data formats are the same as the 640x200
      pel mode on the CGA. Buffer starts at B8000 and bit image is in
      plane 0.

      640x350 Monochrome Graphics (Mode F)

      ---------------------------

      This supports the Mono display with the following attributes:
      black, video, blinking, intensified. Maps 0,1 and 2,3 are chained
      together to form 2 32k bit planes. The first map is the video bit
      plane, the second is the intensity plane. Both planes reside at

      A0000.

      Two bits, one from each plane, define one pel on the screen. The
      bit definition for the pels are given in the following table. Video
      plane is C0, intensity is C2.

  C2  C0  Pixel Color  Valid Attributes
  --  --  -----------  ----------------
  0   0   Black         0
  0   1   Video         3
  1   0   Blinking      C
  1   1   Intensified   F

The byte organization of the memory is sequential. The first 8 pels on
the screen are defined by the contents in A000:0H, the second 8 in
A000:1, and so on. The first pel within a byte is bit 7 in the byte, the
last is bit 0.

Mono graphics works in odd/even mode, which means that odd CPU address go
to odd planes, and even addresses to even planes. Since both planes
reside at A0000, the user must select the plane or planes to update. This
is accomplished by the map mask register of the sequencer.

16/64 Color Graphics Modes (Mode 10)
 ------------------------------------

These modes support graphics in 16 colors on either medium or hi
resolution monitor. This uses all four bit planes. The planes are denoted
as C0,C1,C2, and C3.

   C0 = Blue Pels
   C1 = Green Pels
   C2 = Red Pels
   C3 = Intensified Pels

Four bits (one from each plane) define one pel on the screen. Color
combinations are as follows:

   I  R  G  B  Color
   -  -  -  -  ------------------
   0  0  0  0  Black
   0  0  0  1  Blue
   0  0  1  0  Green
   0  0  1  1  Cyan
   0  1  0  0  Red
   0  1  0  1  Magenta
   0  1  1  0  Brown
   0  1  1  1  White
   1  0  0  0  Dark Gray
   1  0  0  1  Light Blue
   1  0  1  0  Light Green
   1  0  1  1  Light Cyan
   1  1  0  0  Light Red
   1  1  0  1  Light Magenta
   1  1  1  0  Yellow
   1  1  1  1  Intensified White

The display buffer resides at A0000, The map mask register of the
sequencer is used to select any or all of the bit planes to be updated
when a memory write to the display buffer is performed.

   Color Mapping

      Character               Mode 10H      Mode 10H
      Attribute   Monchrome   64KB          > 64KB
      ---------   ---------   ---------    ----------
         00H        Black      Black        Black
         01H        Video      Blue         Blue
         02H        Black      Black        Green
         03H        Video      Blue         Cyan
         04H        Blink      Red          Red
         05H        Inten      White        Magenta
         06H        Blink      Red          Brown
         07H        Inten      White        White
         08H        Black      Black        Dark Grey
         09H        Video      Blue         Light Blue
         0AH        Black      Black        Light Green
         0BH        Video      Blue         Light Cyan
         0CH        Blink      Red          Light Red
         0DH        Inten      White        Light Magenta
         0EH        Blink      Red          Yellow
         0FH        Inten      White        Intens White

External Registers
------------------

This section describes registers of the EGA card not contained in the LSI
device.

Name                    Port  Index
----------------------- ----  -----
Misc Output Register    3C2    -
Feature Control Reg     3?A    -
Input Status Reg 0      3C2    -
Input Status Reg 1      3?2    -
? = B in Monchrome modes, D in color modes

   Misc Output Register
   --------------------

   Write only. Hardware reset causes all bits to zero.

   Bit 0 - 3BX/3DX CRTC I/O Address - This bit maps the CRTC I/O
   addresses for the mono or CGA emulation. 0 sets the CRTC addresses to
   3BX and Input status reg 1 to 3BA for mono emulation. 1 sets the CRTC
   address to 3DX and status reg 1 to 3DA for CGA emulation.

   Bit 1 - Enable RAM - 0 disables ram from the processor, 1 enables ram
   to respond at addr's designated by the Contol Data Select value in the
   Graphics Controllers.

   Bit 2,3 - Clock Select, according to the following table:

          Bit 2   Bit 3
          -----   -----
            0      0     14Mhz from Processor I/O channel
            0      1     16Mhz On-board clock
            1      0     External clock from feature connector
            1      1     Not used

Bit 4 - Disable Video Drivers - 0 activates internal video drivers, 1
disables them. When disabled, the source of the direct drive color output
becomes the feature connector.

Bit 5 - Page Bit for Odd/Even - Selects between 2 64K pages of memory
when in Odd/Even modes (0,1,2,3,7). 0 selects low pase, 1 selects high
page of memory.

Bit 6 - Horiz Retrace Polarity - 0 selects positive, 1 selects negative.

Bit 7 - Vert Retrace Polarity - 0 selects positive, 1 selects neagative.

Feature Control Register
------------------------

Write only. Ouput address is 3BA or 3DA.

Bits 0,1 - Feature Control Bits - Output of these bits go to FEAT0
(Pin19) and FEAT1 (Pin 17) of the feature connector.

Bits 2,3 - Reserved.

Bits 4-7 - Not Used.

Input Status Register Zero
--------------------------

Read Only. Input address is 3C2.

Bits 0-3 - Not Used.

Bit 4 - Switch Sense - When set to 1, this allows proc to read the 4
config switchs on the board. The setting of the CLKSEL field determines
switch to be read. The switch setting can also be determined by reading
40:88H in RAM. 0 indicates switch is closed

Bit 5,6 - Feature Code - Input from FEAT0 and FEAT1 on the feature
connector.

Bit 7 - CRT Interrupt - 1 indicates video being displayed, 0 indicates
vertical retrace is occurring.

Input Status Register One
-------------------------

Bit 0 - Display Enable - 0 indicates the CRT raster is in a Horizontal or
vertical retrace interval. This bit is real time status of display enable
signal.

Bit 1 - Light Pen Strobe - 0 indicates light pen trigger has not been
set, 1 indicates set.

Bit 2 - Light Pen Switch - 0 indicates switch closed, 1 is switch open.

Bit 3 - Vertical Retrace - 0 indicates video information being displayed,
1 indicates CRT is in vertical retrace. This bit can be programmed to
interrupt the proc at int level 2 at the start of retrace. This is done
by bits 4,5 of the Vertical End Register of the CRTC.

Bit 4,5 - Diagnostic Usage.

Bit 6,7 - Not Used.

Sequencer Registers
-------------------

  Name             Port Index
---------------- ---- -----
  Address          3C4   -
  Reset            3C5   00
  Clocking Mode    3C5   01
  Map Mask         3C5   02
  Char Map Select  3C5   03
  Memory Mode      3C5   04

Sequencer Address Register
--------------------------

A pointer register located at output address 3C4H. Loaded with a value to
indicate where the sequencer data is to be written

Bits 0-4 - Sequencer Address.

Bits 5-7 - Not Used.

Reset Register
--------------

Write only. Written to when address register is 00H.

Bit 0 - Asynchronous Reset - 0 commands the sequencer to asynchronous
clear and halt. 1 causes sequencer to run unless bit 1 is zero. Reseting
sequencer can cause loss of data in display buffer.

Bit 1 - Synchronous Reset - 0 commands sequencer to synchronous clear and

halt. bits 0 and 1 both must be 1 to allow sequencer to operate. Reset
the sequencer with this bit before changing clock mode to allow memory
contents to be preserved.

Clocking Mode Register
----------------------

Write only. Written when address register is 01H.

Bit 0 - 8/9 Dot Clocks - 0 directs sequencer to generate character clocks
9 dots wide, 1 causes 8 dots wide. Mono alpha (Mode 7) is the only mode
that uses 9 dot clocks.

Bit 1 - Bandwidth - 0 makes CRT memory cycles occur 4 out of 5 available
memory cycles; 1 makes CRT memory cycles occur on 2 out of 5 available
memory cycles. All hi-res modes must use 4 out of 5 in order to refresh
the display image.

Bit 2 - Shift Load - When 0, video serializes are reloaded every
character clock, 1 causes load every other clock. The later mode is
useful when 16 bits are fetched per cycle and chained together in the
shift registers.

Bit 3 - Dot Clock - 0 selects normal dot clocks derived from the
sequencer master input. 1 causes the clock to be divided by 2 to generate
the dot clock. Dot clock divided by to is used for modes 0,1,4,5.

Bit 4-7 - Not Used.

Map Mask Register
-----------------

Write only. Written when address register is 02H.

Bit 0-3 - Map Mask - A 1 in bits 3 through 0 enables the proc to write to
the corresponding maps 3 through 0. If this register is 0FH, the CPU can
perform a 32 bit write on a single memory cycle. Data scrolling is
enhanced when this register is 0FH. When odd/even modes are selected,
maps 0,1 and 2,3 should have the same mask value.

Character Map Select Register
-----------------------------

Write only. Written when the address register is 03H.

Bit 0,1 - Character map select B - Selects the map used to generate alpha
characters when attribute bit 3 is 0, according to the following table:

   Bit1  Bit0  Map Selected   Table Location
   ----  ----  ------------   ------------------------
     0    0         0         1st 8K of Plane 2 Bank 0
     0    1         1         2nd 8K of Plane 2 Bank 1
     1    0         2         3rd 8K of Plane 2 Bank 2
     1    1         3         4th 8K of Plane 2 Bank 3

Bit 2,3 - Character map select A - Selects the map used to generate alpha
characters when attribute bit 3 is 1, according to the following table:

   Bit3  Bit2  Map Selected   Table Location
   ----  ----  ------------   ------------------------
     0    0         0         1st 8K of Plane 2 Bank 0
     0    1         1         2nd 8K of Plane 2 Bank 1
     1    0         2         3rd 8K of Plane 2 Bank 2
     1    1         3         4th 8K of Plane 2 Bank 3

Bits 4-7 - Not used.

In alpha modes, bit 3 of the attribute byte normally has the function of
turning the forground intensity on or off.  This bit may be redefined as
a switch between character sets.This function is selected only when the
values in character map select A and B are different.  When they are the
same, the function is disabled.  Memory mode register bit 1 must be a 1
in order to enable this function; otherwise bank 0 is always selected.

128K of memory is required for 2 character sets, 256K for 4 sets.

Memory Mode Register
--------------------

Write only. Written when address register is 04H.

Bit 0 - Alpha - 0 indicates non-alpha mode active. 1 indicates alpha mode
is active and enables character generator map select function.

Bit 1 - Extended Memory - 1 indicates memory expansion card installed. 0
indicates card not installed

Bit 2 - Odd/Even - 0 directs even processor addresses to maps 0 and 2,
odd to maps 1,3. 1 causes processor addresses to sequentially address the
bit map. The maps are accessed according to the value in the Map Mask
Register.

------------------------------

Date: Thu, 21 Feb 85 22:35:27 est

From: "John Levine, P.O.Box 349, Cambridge MA 02238-0349 (617-494-1400)"
<ima!johnl@cca-unix> Subject: How I Got my EGA Manual, a True Story

To: brackenridge@USC-ISIB.ARPA

I was in the same boat as you -- I had the Seminar Proceedings issue on
the EGA, but couldn't find the manual pages.  Then out of the blue, a
local guy called me up and offered to swap a copy of the seminar
proceedings for a copy of the EGA manual.  Needless to say, I took him
up on it.

It turns out that he took the totally straightforward approach, entirely
by accident, and it worked.  He bought a copy of the "Options and
Adapters Technical Reference," which costs $125, a total ripoff,
particularly since almost everything in it is in the XT technical
reference, too.  In the front of this manual is a postcard you send in
for the update service.  Wait a month, and a mountain of updates arrives
in the mail, including the EGA manual.  It is over 100 pages including a
lot of diagrams.  About half of it is the assembler listing of the BIOS
code in the ROM.

John Levine, ima!johnl or Levine@YALE.ARPA
------------------------------

End of Info-IBMPC Digest


*** CREATED 03/07/85 22:56:13 BY BILL.FRANTZ/BILL ***
