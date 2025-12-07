                                                         05/20/90
This document describes the steps in enabling out of band
transmit to the Kenwood 231A 2 meter transceiver. This
modification will allow transmit throughout the 136.000 to
173.995 Mhz range.  I do not condone, authorize or any way
promote illegal out of band communication. More than likely,
performing this modification will void the warranty, also no
guarantees are made and you are at your own risk. In other words,
don't blame me if you kill your radio!  Please read all of text
before deciding or continuing.  Also performing either the
MARS/CAP mod or the full extended transmit mod will erase the
memories. 

   First of all you should be aware that this modification
disables the automatic ARRL transmit offset feature.  Second, if
you do not feel comfortable taking your radio apart, soldering to
a surface mount board,or working with very small items, please
find someone who can help you.

   Ok, now with all that out of the way, here we go.  You will
need:
a VERY small soldering iron with a tip no larger than about a
sixteenth of an inch, a phillips screwdriver, a pair of VERY
small tweezers or forceps, some very thin solder, a 1N914, or
similiar glass diode (NOTE: if you have a chip diode of similiar
rating, all the better!), a small box to put all the tiny parts
in.  Also a small vise or circuit board
holder and a pair of external snap ring pliers are helpful. At
this time it would be a good idea to write down the memories on a
piece of paper, as doing the mod erases the memories.  Disconnect
the microphone, power, and antenna. 

          MAKE SURE NO POWER IS CONNECTED TO THE RADIO!

   1) Take the radio apart --- Remove the 4 black phillips head
screws from the top and bottom black metal shields, put them in
the small box so as not to lose them. Remove the two metal covers
and put them aside.

Note: If you just want to mod the radio for MARS/CAP, just remove
the  top cover and clip the GREEN wire just above the VFO,MR,MHZ
switches, and replace the top cover. This extends transmit about
3 Mhz on either side of the ham band. 
 
Place the radio on a pad or soft STATIC free work area.  Looking
at the front of the radio, you will see how the black face plate
is held in place by 4 little plastic keepers that run over metal
bumps in the sub-frame.  By GENTLY inserting your finger nail and
pushing each keeper, you will be able to remove the face plate,
be careful, its plastic. Pull the volume, squelch and frequency
selector knobs off, the freq. selector is a real bear, but a
strong steady pull will remove it. Next, using a pair of pliers
or a set of external snap ring pliers, remove the mic connector
ring nut from the mic connector, now remove the nut that is on
the freq. selector.  Again put all the parts in the small box. 
Gently remove the LCD assembly from the radio.  You will see a
series of silver springs mounted horizontaly on the back of the
LCD assembly, these mate with short silver pins on the cpu board. 
Put the LCD assembly aside in a safe STATIC free place.  The next
step is to remove the metal shield that covers the cpu board.  Do
this by removing 4 screws, two are located on the short sides and
the other two are located on the top and bottom of the radio. Put
the screws in the small box for safe keeping.  Gently remove the
metal plate from the radio and put it aside.  Finally the cpu
board must be removed.  If your radio has the CTCSS encoder
and/or the DRU voice recorder, you must remove these before
continuing.  Consult the manual and reverse the installation
procedures to remove them.  Be careful when pulling the small
white multi pin connectors, forceps work the best.  There are 3
screws that hold the cpu board on to the radio frame. Two are
located to the right of the frequency selector and the third is
located near the squelch control.  Also there are two multi pin
connectors located at the bottom of the backside of the cpu board
that connect to the rf portion of the radio.  Remove the 3 screws
making sure not to drop them on the board.  (Remember the battery
backup!)  Now using your thumbs at the bottom, and your fore
fingers at the top of the board, gently disconnect and remove the
cpu board.  Be careful in handling the board as it contains many
static sensitive components.  Always hold the board by the sides
as to not touch any traces or pin leads.  If you have a small
vise or circuit board holder, place the board in it, solder side
up, so the row of switches (Call, F, Shift, Tone, Rev, Drs) are
pointing toword you. 

    What needs to be done, is to solder a diode to the pads
located under the tone switch. (S205)  This is D209 on the
schematic.  Note that Kenwood calls the radio with this diode
installed a -21 version, for use in "other areas". You will
probobly notice how small and how thinly spaced the pads are, and
you will be wondering how that BIG diode is going to fit!...

   2) Making the mod --- If you have a chip diode that will fit,
skip this part.  Otherwise, like me, you will have to fabricate
your own SMT diode. Do this by bending the leads of the diode
under the body and clipping the remaining lead lengths so that
space between the leads are equal to the spacing of pads on the
board. THE DIODE MUST BE POSITIONED SO THAT THE CATHODE IS
POINTING DOWN, TOWORD THE CPU CHIP.   THIS IS VERY IMPORTANT. 
Try making about 5 of these guys, taking each one and visually
fitting it to the pads.  Look at the overall height compared to
the height of the connectors.  Also look at the pad spacing, a
magnifiying glass works well unless you have eyes like a
microscope.  Once you've selected the best one, tin the leads of
the diode so just a quick tap of the hot soldering iron will
"plant" the part on the pads. Now, holding the diode in the
proper orientation, tack down one lead, (hopefully you didn't
drink too much coffee this morning!), then, using the tweezers
orient the other lead and tack it down with the soldering iron. 
You shouldn't need any additional solder, just the solder on the
pad and the tinning on the diode leads.  Using the magnifiying
glass, FULLY INSPECT THE CONNECTION, making sure there are no
solder bridges and that the diode is positioned properly with the
cathode pointing toword the cpu. Once you are satisfied proceed
with step 3.

  3) Button it up --- Reverse the take down procedure to put the
radio back together.  Attach the cpu board by aligning the
connectors on the back, press firmly to engage the connectors,
insert the 3 screws and tighten, remember the radio frame is
aluminum, so don't strip them out. Attach the metal sub frame
using the 4 screws.  Gently place the LCD sub assembly on top and
hold it in place so the little springs make contact while you
attach the microphone connector ring nut and the freq. selector
nut.  Tighten them down.  Press the plastic face plate so that
the little keepers "snap" over the bumps.  Re-attach the CTCSS
and/or DRU if applicable. Replace the top and bottom black covers
with the four screws.  Check the small box and make sure you
don't have any "spare" parts.  

  That's it, just connect power, antenna and the microphone. 
Turning on the power will reset the radio erasing all memories. 
Oh well...

                         Good luck and 73,

                       Paul Saffren --- N6NHH
                       @KI6EH
