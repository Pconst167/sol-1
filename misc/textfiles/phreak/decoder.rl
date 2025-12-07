





                 *  R e n e g a d e   L e g i o n  *



                          DTMF Tone Decoder

                                 by

                               Kingpin



                         Technical Report #8



                              Feb.  1992



The Night Elite BBS    Temporarily Down  (RL HeadQ)
Electric Eye ][        313-776-8928      (NUP: PHUCK_MICH_BELL)
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


Brief RL Information - By: The Knight

Well, as some people know RL has no HQ BBS right now and is just trying
to start up again. Its "subgroup" "LoST" has published since the last
RL Report yet RL its self the serious side of LoST has yet to really do
anything since last April. RL has been around for about 1 year and 1
month and has very recently re organised.

You can ALWAYS find all RL files on Electric Eye ][ BBS. And if you
wish to join or submit any articles I welcome them. You can contact
me (The Knight) on Electric Eye.

Thanks to those of you who are reading our files.

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

By Kingpin:


     Introduction
     

     These plans explain in detail how you can build a device
that decodes DTMF (Dual-Tone-Multi-Frequency) tones, or touch
tones.  The device uses a single chip to decode 12 or all 16 of
the DTMF tones (1-9, A-D).  Up to 16 tones can be stored in the
circuits static RAM memory.  They can be reviewed by reading them
out one by one on the LED display.  The DTMF decoder can be
hooked up directly to a telephone, scanner, or a tape recorder. 
The 16 tones that this circuit decodes are as follows:

     1 = 697 + 1209hz
     2 = 697 + 1336hz
     3 = 697 + 1477hz
     4 = 770 + 1209hz
     5 = 770 + 1336hz
     6 = 770 + 1477hz
     7 = 852 + 1209hz
     8 = 852 + 1336hz
     9 = 852 + 1477hz
     0 = 941 + 1336hz
     * = 941 + 1209hz
     # = 941 + 1477hz
     A = 697 + 1633hz
     B = 770 + 1633hz
     C = 852 + 1633hz
     D = 941 + 1633hz

     To build this circuit, you will need quite a bit of
electronics knowledge.  If you have never built anything
involving electronics before, don't try this project, because it
is way to difficult.  A .GIF should be included in this file,
showing the schematic of the circuit.  If it is not included with
this, look at the end of the text on where to get it.  In order
to make the decoder, the .GIF is essential.


     Applications/Uses
  

The tone decoder can be used for many things. Basically,
anytime you hear a DTMF tone, and want to know what
it is, just hook up the decoder.  When it is hooked up
to a phone line,  any tones sent over the line can be decoded
in a split second.  It is great for services like credit card
verification, voice mail systems, answering machines, COCOTS,
etc. DTMF signalling is so widespread, there is no doubt that you
will discover many useful applications with the decoder.

     Theory of Operation
   

     The DTMF decoder operates as follows: DTMF signals are
coupled to pin 9 of IC1, the DTMF decoder chip, by .01uf
capacitor C1.  ED (pin 6 of IC1) goes high within 20 milliseconds
of DTMF input detection.  This signal increments the counter,
IC4, via the Schmitt NAND, IC3.  Then, DV (pin 14 of IC1) goes
high within 46 milliseconds of tone reception.  This signal
causes the R/W input of the RAM to go low. Within 50 milliseconds
after the tone ends, DV goes low, writing the data into the first
address of the RAM.  4.56 milliseconds after DV goes low, the
outputs D1, D2, D4, D8 of the decoder clear.  The digit received
is displayed on LED1 until the next digit is read.  This sequence
will contine until all 16 memory locations contain data.  At this
time, the counter recycles and data will be written over what was
previously stored.
     
     To read out the contents of memory, S3 is opened, causing
pins 1 and 2 of the counter to go high.  This resets the counter,
so the RAM will be at address 00. The data in address 00 of the
RAM is presented to IC5, the BCD to 7-segment decoder/driver. 
IC5 converts the RAM output data to a digit which is displayed on
LED1.  When S2 is momentarily closed, a high pulse is presented
to pin 14 of the counter by way of the NAND.  This increments the
counter, which presents the first address to the RAM, and the
first digit is displayed.  S2 is repeatedly pressed until all the
contents of memory have been displayed.


     Parts List
   

     C1 - .01uf capacitor          
     C2 - 2.2uf electrolytic capacitor
     C3, C4 - .1uf capacitor
     S1, S4 - SPST switch
     S2 - Momentary, normally open 
     S3 - Momentary, normally closed
     D1 - 1N914 general purpose diode   
     IC1 - UM9203, DTMF Decoder chip
     IC2 - 5101, 256 x 4 SRAM
     IC3 - 4093, quad Schmitt NAND
     IC4 - 74C93, ripple counter
     IC5 - 74C48, BCD to 7-segment
     IC6 - 78L05, 5 volt regulator
     R1, R3 - 4.7K ohm 1/8 watt resistor
     R2 - 1M ohm 1/8 watt resistor 
     R4 - 1K ohm 1/8 watt resistor 
     LED1 - 7-segment, common cathode
     X1 - 3.579Mhz colorburst crystal   
     
     Misc. parts - 1/8" input jack, IC sockets, PC board, 9V
battery and clip, enclosure box, mounting hardware

     All the IC's except for IC1 are available from JDR
Microdevices, 2233 Branham Lane, San Jose, CA, 95124,
800/538-5000.  Other components are available from Digi-Key, 701
Brooks Ave. South, P.O. Box 677, Thief River Falls, MN,
56701-0677, 800/344-4539.  If the components are not available
from the above places, check Radio Shack or your local
electronics store.


     Circuit Construction
   

     There are two different techniques you can use to contruct
the Renegade Legion DTMF decoder.  Either wire-wrapping or using
a PC (printed circuit) board and soldering.  Building a PC board
is the most ideal way to mount the project, because the circuit
involves many confusing and difficult areas. 

     Assembly with the PC board is basically straightfoward. 
Note that the switches, LED1, and the input jack are not mounted
on the board.  These should be mounted on the enclosure box, if
you want.  There are 6 jumpers that need to be installed on the
component side of the board.  They are labelled "JU" on the
schematic.  You can use excess component leads for these jumpers.
In addition, pads can be used so that pin 4 of IC1 can be
jumpered high or low for either 12 or 16 DTMF tone detection.
Also, note the polarity marking for C2, which is very important.
Crystal X1 should be mounted horizontally.  You should use
sockets for all the DIP IC's.  All other components are mounted
normally. 

     Three things need to be done on the solder side of the
board.  First, cut the trace running between pins 6 and 12 of
IC3.  Next, use a small piece of wire or a leftover component
lead to solder a jumper between pins 5 and 6 of IC3.  Also, diode
D1 needs to be installed on the solder side.  Solder the diode
between pin 6 of IC1 and pin 6 of IC3.  Make sure the leads of
the diode do not cause any shorts by enclosing the diode in
heat-shrink, electrical tape, or some other kind of insulant.

     Double checking your work at various stages along the way
will assure a functional device at power-up.  Before you insert
the IC's into the sockets at the end of the project, check all
connections with a continuity meter.  If the circuit does not
operate correctly, suspect your work before questioning the IC's
(See the section on Testing and Troubleshooting).

     This project uses CMOS IC's, which are static sensitive.
Optimally, you and your soldering iron should be grounded when
working with the IC's.  If you don't have an antistatic mat or
workplace, don't worry about it.  Just try not to touch the pins
of the IC's and store them in conductive foam or a piece of
aluminium foil when not in use.  If you have to, touch a wall,
radiator, computer, dog, cat, or any grounded object to discharge
yourself before you get to work with the IC's. 

     It is also important to ground the case of the 3.579Mhz
crystal.  To do this, solder a wire from the case of the crystal
to a ground trace on the PC board or the ground side of a switch,
like S2 or S3.

     Depending on the specific characteristics of your LED
display, you may need to adjust the value of R4 for the proper
LED intensity.  If your display is too dim, try a slightly lower
resistance value for R4.  If your display is too bright, try a
slightly higher resistance value for R4.  I chose a 1K ohm
resistor because it works fairly well.

     After you are done assembling the circuit, think about where
you are going to put the LED display, input jack, and switches on
your enclosure box.  Assembly and disassembly will be easier if
all of these parts are attached to the same half of your box.


     Testing and Troubleshooting
  

     Having thoroughly checked all the connections of your
contructed unit, you are ready to power up the device.  Current
with the display on should be about 75-85 milliAmps.  Hit the
reset switch, S3, to reset the counter.  Connect the device to a
source of DTMF tones, such as a phone line.  Pick up the phone
and hit some keys.  The number of the tone you entered should be
on the display until another tone is entered.  Hit the reset
switch again and then hit the sequence switch, S2.  You should
see the first tone you entered.  Hit the sequence switch again,
and you should see the subsequent tones you entered.

     If at any time you sense something is wrong, turn the power
off to protect the IC's.  Check to see if the IC's are hot.  If
things aren't working the way they should be, check out the
following: Pins 6 and 14 of the decoder IC, IC1, should be in a
high logic state for the duration of the tone.  Pin 20 of the
RAM, IC2, should be low for the duration of the tone.  Pin 14 of
the counter, IC4, should be low for the duration of the tone.

     If the device appears to be decoding tones properly but does
not store them in memory, the decoder IC may be hung up.  Check
pin 14 (DV) of the decoder IC to make sure it is normally low,
and high for the duration of a tone.  If DV is always high, the
decoder IC is hung up.  To solve this problem, ground the case of
the crystal as mentioned earlier in this text.  If the problem
persists, connect a 5 pF capacitor from pin 11 of the decoder IC
(XOUT) to ground.

  
     Using Your Decoder
   

     Using the decoder is not too hard, but there are a few
details about its operation that you need to observe.  When you
first turn the unit on, be sure to hit the reset switch.  This
ensures that the tones (or rather the data sent from the decoder
to the memory) will be stored in the first memory location.  Then
just wait for some DTMF tones to come down the line.  When they
do, the device will decode them and store them in memory.  When
the tones have stopped, hit the reset switch, and then the
sequence switch.  You will see a number on the display, which in
the number stored in the first memory location.  Hit the sequence
switch and the numbers in the subsequent memory locations will be
read out.  Once you have read out all the numbers, hit the reset
switch again.  You are ready to start decoding all over again.
The numbers will be in the memory as long as the power is on and
new numbers haven't been written over the old ones.

     For detection of all 16 DTMF tones, pin 4 of the DTMF
decoder IC must be tied low.  If detection of only the 12 common
tones (1-9) is needed, pin 4 should be tied high.  The numbers 1
to 9 will read out as numbers on the LED display.  However 0, #,
*, A, B, C, D will read out with different unique patterns (see
the enclosed .GIF).

     There are a few other helpful hints that can make using the
decoder easier.  First of all, turn the LED display off when you
are not reading out numbers.  You only need the display when
you're reading out numbers, and switching it off will prolong
battery life.  Also, while reading out the numbers, you might
want to remove the device from the phone line or whatever it is
hooked up to.  If the decoder happens to receive a tone while
you're reading out the numbers in memory, the tone will be stored
in whatever memory location you happen to be at and generally
make things confusing. 

     Although the DTMF decoder is intended to be powered by a 9V
battery, the 78L05 voltage regulator, IC6, can handle input
voltages from 7 to 30V DC.  Other batteries or power supplies can
be used to power the decoder as long as they conform to the
voltage regulator's sprecifications.

     Remember that the decoder can only store 16 tones at one
time.  If more than 16 tones are read by the decoder, the counter
resets the RAM to the first memory location and the excess tones
are read into memory, erasing the previous ones.  This is a
problem sometimes, since information is lost.  If you know you
will be decoding more than 16 tones at one time, just record them
onto a tape recorder, then play them back a few at a time into
the decoder.

     When using the decoder with a tape recorder, hook it up to
the earphone jack and adjust the volume so the decoder will read
the tones off the tape.  When using the decoder with a scanner,
it is best to hook it up to the "tape out" jack if it has one. 
If not, just hook it up to the earphone jack on the scanner.
 
     Be warned that if you are going to hook up the decoder to
the phone line for any extended period of time, circuitry must be
added (which is unavailable through me) to the input to protect
the device from the ringing voltage on the phone line.  90 volts
AC on the line will basically destroy the CMOS IC's.

	Later..

RL
- -
