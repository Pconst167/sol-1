From telecom@eecs.nwu.edu Tue Feb  5 00:45:02 1991
Received: from hub.eecs.nwu.edu by gaak.LCS.MIT.EDU via TCP with SMTP
	id AA27456; Tue, 5 Feb 91 00:44:57 EST
Resent-Message-Id: <9102050544.AA27456@gaak.LCS.MIT.EDU>
Received: from uunet.UU.NET by delta.eecs.nwu.edu id aa16957; 4 Feb 91 16:14 CST
Received: from inmos-c.inmos.com by uunet.UU.NET (5.61/1.14) with UUCP 
	id AA08423; Mon, 4 Feb 91 17:12:29 -0500
Newsgroups: comp.dcom.telecom
Path: andyr
From: Andy Rabagliati <andyr@inmos.com>
Subject: Re: How do you Program This Phone?
Message-Id: <1991Feb4.220645.4448@inmos.COM>
Organization: SGS-Thomson/Inmos Division
References: <16388@accuvax.nwu.edu>
Date: Mon, 4 Feb 91 22:06:45 GMT
Apparently-To: uunet!comp-dcom-telecom
Resent-Date:  Mon, 4 Feb 91 23:46:03 CST
Resent-From: telecom@eecs.nwu.edu
Resent-To: ptownson@gaak.LCS.MIT.EDU
Status: R

[ Part 1 of 2 of Motorola programming manual ]

Programming Your Personal or Portable Cellular Telephone

Programming Manual

68P81155E16-D  6/15/89-RGC              CONTENTS

Introduction ..................................................3
Features to be Programmed .....................................3
Obtaining System Registration Data ............................6
Programming Your Telephone ....................................6
 Determine the Initial Programming Sequence ...................6
 Initial Steps ............................................... 7
 Programming Procedure ........................................8
 Reviewing of NAM Programming ................................10
 Storing the Information .....................................10
 Programming the Second Telephone Number .....................10
Before Calling for Service ...................................11
Personal or Portable Cellular Telephone Battery Chargers .....12
 Personal Telephone Battery Charger ..........................12
 Portable Telephone Battery Charger ..........................12
 Safety Information ..........................................12
 Portable Charger Operation ..................................13
 Portable Charger Maintenance ................................13
Telephone Number Label Installation Instructions .............13
NAM Programming Data Table ...................................15
Rules, Regu1ations, and Precautions ..........................17
General Safety lnformation ...................................18

1. INTRODUCTION

Your cellular phone contains a special memory which retains information
about the phone's individual characteristics, such as its assigned
telephone number, system identification number, and other information that
is necessary for cellular operation. This special memory is known as the
Number Assignment Module (NAM). You can program the phone yourself, if the
phone has not already been programmed where you purchased it. You can also
reprogram the phone yourself should you wish to change some of the
features already selected for the NAM.

The programming of the NAM is performed after you have contacted your
cellular system operator (or operators) for the necessary information as
described below. Enter the information received from your cellular system
operator in the NAM Programming Data Table (included in this manual)
before programming the NAM of your cellular telephone. Follow your system
operator's instructions regarding each NAM information entry. Incorrect
NAM entries can cause your cellular telephone to operate improperly or not
at all.

Your cellular telephone can be programmed up to three times. After that,
it must be reset at a Motorola-authorized service facility.

Be sure to read through this entire manual before attempting to program
your phone.

2. FEATURES TO BE PROGRAMMED

You must request seven pieces of information from the cellular system
operator to allow you to program your cellular phone. You provide the
remaining information. Write all of this programming information on the
NAM Programming Data Table provided on page 15 of this manual before
commencing the procedure. Incorrect NAM entries can cause your cellular
telephone to operate improperly or not at all. The required information is:

* System Identification (SID) Code (S-digits)--Indicates your Home
  system. Enter O's into the left-most unused positions. Provided by
  the system operator.

* Cellular Telephone Number (10 digits)--Used in the same manner
  as a standard land-line telephone. The mobile phone number and
  the Electronic Serial Number are checked against each other by the
  cellular system each time a call is placed or received. Provided by the
  system operator.
  
* Station Class Code (2 digits)--06 or 14 for most personal or portable
  telephones. Even though your phone has extended bandwidth capability (832
  channel capacity), the cellular system operator may require your station
  class code to remain 06. The code should be 14 if 832 channel operation is
  allowed. (If you have the convertible accessory, and wish it to be
  programmed with a separate phone number for standalone operation, the
  class code mark will be set to 12 for the convertible accessory--with the
  personal telephone disconnected) Provided by the system operator.

* Access Overload Class (2 digits)--Provided by the system operator.

* Group ID Mark (2-digits)--Provided by the system operator.

* Security Code (6-digits)--The six-digit security code allows the user to
  restrict his calls in certain ways and it permits other advanced security
  measures. Refer to your operator's manual for further details. Select any
  6-digit code that you will remember, but one that will not be easily
  compromised.

* Unlock Code (3-digits)--The 3-digit unlock code unlocks the telephone
  after it has been locked. Locking the telephone allows you to prevent
  unauthorized usage. With many models, this number can be programmed as
  often as desired. Consult your user manual. Select any convenient 3-digit
  number.

* Initial Paging Channel (4 digits)--Use a leading zero if required.
  (Example: Channel 334 is entered as 0334.) Provided by the system
  operator.

* Option Bits (6 digits)--This programming step allows you to program six
  separate features in one step. Each feature is either selected or
  cancelled by assigning a value of 1 or 0. The six individual single-digit
  features combine to form a six-digit code which is entered as one step. If
  any of the features is to be changed, the entire six-bit word must be
  reentered.

--Internal Speaker-- This feature is normally selected by programming 0.
However, if you purchased the Convertible Accessory and it contains a
separate External Speaker/VSP unit, cancel the internal speaker feature by
programming 1.

--Local Use--This feature is normally selected by programming 1.
Your system operator can tell you if you need to cancel this feature
by programming 0.
 
--MIN Mark--This feature is normally not used and is assigned a
value of 0. Your system operator can tell you if you need to select
this feature. To select, program 1.

--Auto Recall--This feature is always set at 1.

--Second Phone Number--This feature is normally not used and is
assigned a value of 0. However, if you have arranged with a cellular
system operator to have a second phone number, select this feature by
programming 1.

--Diversity--This feature is always set at O for the portable/personal
telephone used alone. (If you have a convertible accessory, and it has two
external antennas, select this feature by programming 1.)

* Option Bits (3 digits)--This programming step allows you to program an
additional three separate features in one step. Each feature is either
selected or cancelled with the digit 1 or 0. The three individual
single-digit features combine to form a three-digit code which is entered
as one step. If any of the features is to be changed, the entire three-bit
word must be reentered.

--Long Tone DTMF--Certain electronic devices, such as answering machines,
are not able to decode the normal DTMF tones because the telephone system
standard duration is too short. The Long Tone DTMF feature allows access
to answering machines and other similar devices by transmitting the DTMF
tone for as long as the key is depressed. This feature is normally not
used and is assigned a value of 0. However, you can select Long Tone DTMF
by programmlng 1.

NOTE

Personal or portable models with a MENU key can more flexibly select and
cancel this feature through the Menu. However to allow Menu control of the
function it must be cancelled in the NAM by setting this bit to 0.  If
Long Tone DTMF is selected in the NAM with a 1 in this bit, it cannot be
reversed throughh the Menu.

--Future Use--This feature is always set at 0.

--Eight-Hour Timeout (Convertible only)--Personal or portable telephones
with the convertible accessory can normally be left active in the vehicle
for eight hours with the ignition off. If the timeout feature is selected,
the telephone will turn itself off after eight hours to preserve the
vehicle's battery. This feature is normally selected by programming 0.
However, you can cancel this eight-hour time limit by programming 1.

3. OBTAINING SYSTEM REGISTRATION DATA

A cellular phone owner purchases service from a cellular system operator,
just as he would purchase land-line service (for standard telephones) from
the local telephone company. In cities with cellular coverage, the
customer may have the option of picking one oE two possible cellular
system operators.

Before you can obtain a phone number, you will have to supply your
cellular system operator with your electronic serial number.AII cellular
telephones contain a special Electronic Serial Number (ESN). The ESN
uniquely identifies your phone and provides a measure of protection
against theft and fraud. The ESN is an eight-character (numeric/
hexadecimal) number printed on the box your phone came in.

Once you supply your electronic serial number to the system operator, he
will issue your phone number and supply the other information required to
program the NAM. You should immediately enter this information on the NAM
Programming Data Table on page 15 of this manual.

4. PROGRAMMING YOUR TELEPHONE

4.1 Determining the Initial Programming Sequence

The initial programming steps include a sequence of keypresses which vary
depending on the type of cellular telephone you have. The telephone NAM
can be programmed from the personal or portable telephone keypad.
Determine from Table 1 which of the six keystroke sequence numbers to use
on your phone, based on the type of keys present on the keypad.

                         Table 1

Determining the Sequence Number with Personal/Portable Keypad

Keys on Personal or Portable Keypad     Sequence

MENU and FCN keys                       6
FCN key but no MENU key                 1
No Fcn key                              2

If you have the convertible accessory, the telephone NAM must be
programmed from the convertible handset. (Makesurethatthepersonaltelephone
is disconnected from the convertible accessory before programming the
convertible.)The handset type can be read from the label on the back of
the handset. The keystroke sequence number is determined from Table 2.  If
you have the convertible accessory, and wish to use it separately as a
standalone mobile, you may obtain an additional telephone number and
program this into the convertible accessory at this time.

                       Table 2
                       
Determining the Sequence Number with Convertible Handset

Model         Handset Type   Sequence

3000          SCN2007A        6
6000          SCN2023A        2
6000X         SLN2020A        1
6000XL        TLN2659A        1
6800XL        TLN2733A        6


Chose one of the six initial programming sequences from Table 3 depending
on the sequence number which you determined from Table 1 or 2.

                    Table 3

          Initial Programming Sequence

Sequence
Number              Sequence

1               FCN, Security Code entered twice, RCL
2               STO, #, Security Code entered twice, RCL
3               Ctl, O + Security Code entered twice, RCL
4               Ctl, O + Security Code entered twice, *
5               FCN, O + Security Code entered twice, MEM
6               FCN, O + Security Code entered twice, RCL

        Security code is programmed 000000 at the factory.


4.2 Initial Steps

Before you proceed with the programming procedure, be sure you have filled
out the NAM Programming Data Table on page 15.

Step a. Turn on your cellular telephone by pressing the Pwr or On/Off
button. The power indicator in the display will flash.

Step b. Enter the proper keystroke sequence determined from Table 3.

Step c. The message 01 will appear in the display to confirm the
activation of the NAM programming feature. It also indicates that you are
at the first step in the NAM programming sequence. If this message does
not appear, it may be due to one of the following:

* The initial sequence may not have been entered quickly enough. The
appearance of zeros in the display will indicate this. Press Clr and try
again.

* The six digit Security Code may have previously been programmed
into your cellular telephone. If this is the case, you must re-enter the
activation sequence using the assigned security code.

* The maximum number of times that your cellular phone can be reprogrammed
from the keypad may have been reached. Contact the personnel where you
obtained your cellular telephone if reprogramming is required.

* The ability for your cellular phone to be programmed from the keypad may
have been disabled or cancelled. Contact the personnel where you obtained
your cellular telephone if reprogramming is required.


From telecom@eecs.nwu.edu Tue Feb  5 00:45:48 1991
Received: from hub.eecs.nwu.edu by gaak.LCS.MIT.EDU via TCP with SMTP
	id AA27488; Tue, 5 Feb 91 00:45:42 EST
Resent-Message-Id: <9102050545.AA27488@gaak.LCS.MIT.EDU>
Received: from uunet.UU.NET by delta.eecs.nwu.edu id aa22773; 4 Feb 91 16:14 CST
Received: from inmos-c.inmos.com by uunet.UU.NET (5.61/1.14) with UUCP 
	id AA08455; Mon, 4 Feb 91 17:12:38 -0500
Newsgroups: comp.dcom.telecom
Path: andyr
From: Andy Rabagliati <andyr@inmos.com>
Subject: Re: How do you Program This Phone?
Message-Id: <1991Feb4.220711.4530@inmos.COM>
Organization: SGS-Thomson/Inmos Division
References: <16388@accuvax.nwu.edu>
Date: Mon, 4 Feb 91 22:07:11 GMT
Apparently-To: uunet!comp-dcom-telecom
Resent-Date:  Mon, 4 Feb 91 23:46:53 CST
Resent-From: telecom@eecs.nwu.edu
Resent-To: ptownson@gaak.LCS.MIT.EDU
Status: R

[Part 2 of 2 of Motorola programming manual ]

4.3 Programming Procedure

Programming for a single phone number can be as quick as a four-step
process or may take up to 11 steps, depending on how many programable
features you wish to review or change. The phone always has some
information programmed for each of the features, whether that information
is standard programming performed at the factory or information provided
by someone who programmed the unit previously. If, while you are
programming, you are satisfied with the value already programmed for a
particular feature, simply press * to move to the next feature.

At any time that a two-digit step number (01-11) appears in the display,
you may store all the information programmed in the phone by pressing
SND to return to normal phone operation.

In order to perform the following steps, it is necessary for you to refer
to the completed NAM Programming Data Table. If you enter a digit
incorrectly, press the Clr button and start again.

       Enter/Press 
Step   on the Keypad Display              Comment

01                                        Ready for step 1
la  *                Current System I.D.  Factory Setting 000000
lb  New system ID    xxxxxxx              New system ID
lc  *                02                   Ready for step 2

2a  *                Current area code    Factory setting 111
2b  New area code    xxx                  New area code
2c  *                03                   Ready for step 3

3a  *                Current phone        Factory setting 1110111
                     number
3b  New phone        xxxxxx               New phone number
    number
3c  *                04                   Ready for step 4

4a  *                Current station      Factory setting 06 or 14
                     class mark.          for portable/personal,12
                                          for standalone mobile.
4b  New station     xx                    New station class mark
     class mark
4c  *               05                    Ready for step 5

5a  *               Current access
                    overload class
5b  New access      xx                    New access overload
     overload class                       class
5c  *               06                    Ready for step 6

6a  *               Current Group ID      Factory Setting 00
6b  New group ID    xx                    New group ID
6c  *               07                    Ready for step 7

7a  *               Current security code Factory setting 000000
7b  New security    xxxxxx                New security code
     code
7c  *               08                    Ready for step 8

8a  *               Current unlock code   Factory setting 123
8b  New unlock      xxx                   New unlock code
     code
8c  *               09                    Ready for step 9

9a  *               Current initial       Factory setting 0334
                     paging channel
9b  New initial     xxxxxx                New initial paging
     paging channel                       channel
9c  *               10                    Ready for step 10

10a  *              Current options       Factory setting 010100
10b  New options    xxxxxx                New options
10c  *              11                    Ready for step 11

lla  *              Current options       Factory setting 000
llb  New options    xxx                   New options
llc  *              01 or 01 2            Ready for review or
                                          programming second
                                          phone number

4.4 Reviewing of NAM Programming

Once you have completed the programming steps, review the information by
repeatedly pressing *. Check to make sure that the information programmed
matches what you wrote in the NAM Programming Table. Make any required
changes.

4.5 Storing the Information

If you are programming a single phone number, press SND to store the
programming information when you are satisfied that it is all correct. A
two-digit step number (01-11) must appear in the display in order for you
to store the data. Press * until one appears and then press SND.

Your personal or portable cellular telephone is now ready for normal use,
if you are programming a single phone number.

4.6 Programming the Second Telephone Number

If 01 2 appears in the display after you have pressed SND to store the
programming information for the first phone number, you are ready to
repeat some or all of the ten steps, this time for a second phone number.
The 01 indicates that you are ready to enter the System ID information
(step l) and the 2 indicates that you are programming information for the
second telephone number. The phone assigns the same security and lock
codes (steps 7 and 8) for the second phone number and as so skips from
step 6 to step 9. There is no step 11 when programming a second phone
number.

If 01 2 did not appear after programming the first phone number, and you
wish to program a second number, either the second telephone option has 
not been selected (step 10) or your phone is not equipped for dual system
operation.

Once you have completed the programming steps, review the information by
repeatedly pressing *. Check to make sure that the information programmed
matches what you wrote in the NAM Programming Table. Make any required
changes. Press SND to store the programming information when you are
satisfied that it is all correct. (A two-digit step number (01-10) must
appear in the display.)

Your personal or portable cellular telephone is now ready for normal use.

5. BEFORE CALLING FOR SERVICE

If you experience operating difficulties, check the following before making
a call for service.

* Have you read your User's Manual ?

Everything you need to know to operate your cellular telephone is in your
User's Manual. Take the time to read it and become familiar with all the
features of your telephone before calling for service. Note that not all
of the features discussed below are included in all telephone models.

* If your telephone is equipped with Vehicular Speaker Phone (V.S.P.), do
you hear excessive feedback noise during a V.S.P. call ?

Because of audio variations in the cellular system, excessive feedback
noise or howling may sometimes be heard when a full duplex (if your
telephone is so equipped) V.S.P. call is placed or received. If this
occurs, decrease the speaker volume using the volume control of the side
of the handset. Motorola's full duplex Vehicular Speaker Phone is
designated V.S.P. 11.

* Have you unlocked your unit ?

Your cellular telephone is inoperative when locked as indicated by
the word Locked in the display. To unlock the telephone, enter your
3-digit lock code. The word Locked will disappear.

* Is the red NS (No Service) indicator lighted ?

This may indicate that you are outside the service area or in a marginal
reception area. Marginal reception may also be indicated by a fast busy or
alternating high-low sound when attempting to place a call.
 
* Have you programmed a unique operating mode into the unit ?  Constant
flashing of the yellow Roam or Rm indicator or illumination of the red No
Svc or NS (no service) indicator while in your home service area may
indicate an undesired roam characteristic choice has been selected. See
"Roaming and System Operation" in your User's Manual.

         NAM PROGRAMMING DATA TABLE

Step number  Description           No. of digits Source

01           System ID Numbcr        5 Digits    System Operator
02           Cellular Area Code      3 Digits    System Operator
03           Cellular Phone Number   7 Digits    System Operator
04           Station Class Mark      2 Digits    System Operator
   
   (Usually 14 for 832 channels 12 for Standalone mobile)

05           Access Overload Class   2 Digits    System Operator
06           Group ID Mark           2 Digits    System Operator
07           6-Digit Security Code   6 Digits    Telephone Owner
08           3-Digit it Unlock Code  3 Digits    Telephone Owner
09           Initial Paging Channel  4 Digits    System Operator
         
         (Usually 0333 or 0334)
10           Option Programming      6 Digits
  /--------- Handset Internal        1 Digit     Telephone owner
  |          Speaker disable
  |          If your installation contains a separate External Speaker/VSP unit
  |          The handset internal speaker must be disabled.
  |             1 = disabled, 0 = enabled. This bit normally enabled.
  |/-------- Local Use               1 Digit    System Operator
  ||            ( Normally enabled 1 = Enabled 0 = Disabled )
  ||/------- MIN Mark                1 Digit    System Operator
  |||           ( Normally disabled 1 = Enabled 0 = Disabled )
  |||/------ Auto Recall             1 Digit    Always 1
  ||||
  ||||/----- 2nd Phone No            1 Digit    Telephone Owner
  |||||         ( Normally disabled 1 = Enabled 0 = Disabled )
  |||||
  |||||/---- Diversity               1 Digit    Telephone Owner
  ||||||      (based on the number of antenna ports with which your cellular
  ||||||       phone is equipped  O = Standard 1 antenna; 
  ||||||       1 = optional two antennas
  ______     Optional programming data entry
  
11               Option Programming 3 Digits
                 (Cont d)

  /--------- Long Tone DTMF          1 Digit   Telephone Owner
  |             ( Normally disabled 1 = Enabled 0 = Disabled )
  |/-------- For Future Use          1 Digit   Always O
  ||
  ||/------- Eight-hour Timeout      1 Digit   Telephone Owner
  |||           ( Normally enabled I = Disabled O = Enabled )
  |||
  ___               Optional Programming Data Entry

Step number - This number is the message that appears in the display during 
programming

(OCR'ed and edited by Andy Rabagliati )

