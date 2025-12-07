***************************************************************************** 
*                 THE ULTIMATE CELLULAR MODIFICATION MANUAL                 * 
*                              released by                                  * 
*                    %%%%%%%% Dr. Bloodmoney %%%%%%%%%%                     * 
*                              June 1, 1992                                 * 
***************************************************************************** 
 
The following information was gathered from various sources and is not meant  
to be a technical treatise on the cellular network.  There are plenty of  
other files out there on the subject.  This file specifically deals with the 
processes involved in modifying cellulars.  I put together this file because 
I have not seen one that actually tells how to do this.  When some of you   
start reading this you might say to yourselves "Hey, some of this is almost 
word for word from Brian Oblivion's article (incidently, one of the best 
I have seen on the subject) in Phrack #38 or so and so's article in so and so  
magazine".  Well, not to discount anyone who has written anything on cellular  
phones, but all the information in this file was purchased by me from various  
ads in the back of various radio and communications magazines.  I make no  
pretense as to where the original source of this material comes from.  In  
fact,  most of the t-files I have seen contain some of the Consumertronics  
info. word for word, and the writers try and claim it as their own.  Or maybe  
vice versa.  I make no claim to have written this manual (but beleive me  
after putting this together I could).  The only thing I have done is spent  
many hours compiling what I believe to be a very good file on the subject.   
         
============================================================================= 
                 THE ULTIMATE CELLULAR MODIFICATION MANUAL            
                            TABLE OF CONTENTS 
 
PART I.          WHAT IS BROADCAST FROM A CELLULAR TOWER? 
PART II.         DEFINITIONS 
PART III.        TYPES OF NAMS 
PART IV.         NAM FORMAT MAP 
PART V.          STANDARD NAM FORMATS 
PART VI.         NAM REPROGRAMMING INSTRUCTIONS FOR 30+ PHONES 
PART VII.        THE ELECTRONIC SERIAL NUMBER - AN INTRODUCTION 
PART VIII.       IDENTIFYING THE ESN IN YOUR CELLULAR PHONE 
PART IX.         SCANNING TO FIND THE ESN/MIN PAIR 
PART X.          A FEW COMMON SCANNER MODIFICATIONS 
PART XI.         THE 40-50 MHZ CELLULAR SCANNER 
PART XII.        HOW THE ESN IS REPLACED 
PART XIII.       EQUATIONS FOR PROGRAMMING THE CHIPS 
PART XIV.        MANUFACTURER'S ESN CODE LISTING 
PART XV.         HOME SYSTEM ID LISTING  (A-L) 
PART XVI.        HOME SYSTEM ID LISTING  (M-Z) 
PART XVII.       "THE ROAMING SCAM" 
PART XVIII.      MERCHANDISE SHEET 
 
***************************************************************************** 
Comments can be left to me at RIPCO (bloodmoney),Blitzkrieg,or Lucid Dreams 
PART I.          WHAT IS BROADCAST FROM A CELLULAR TOWER? 
 
        When a cellular phone makes a call, it normally transmits it's 
Electronic Security Number(ESN),Mobile Identification Number(MIN),it's 
Station Class Mark(SCM) and the number called in a short burst of data.  
This burst is the short buzz you hear after you press the SEND button and 
before the tower catches the data.  These four things are the components 
the cellular provider uses to ensure that the phone is programmed to be  
billed and that it also has the identity of both the customer and the 
phone. 
 
        There are usually two cellular phone companies in an area.  One is 
the wire-line carrier (Band B), which is usually Bell, and the other is the 
non-wireline carrier (Band A). Within the two bands are 832 cellular phone 
channels.  Each one has 416 bands, and within the bands are voice channels 
that actually transmit and receive information from cellular phones. 
 
        The ESN and the phone number (MIN) are the two primary identifiers 
for any cellular phone.  By changing both, the cellular carrier will accept 
the call and bill it to either a wrong account or provide service based on  
the fact that it is NOT a disconnected receiver.  It will also look at the 
other two components, in order to insure that it is actually a cellular 
phone and to forward billing information to that carrier. 
 
        The Station Class Mark can also be changed if you wish to prevent  
the cellular carrier from determining the type of phone that is placing the 
call.  By providing the cellular tower with a false SCM, the cellular 
carrier, the FCC, or whoever happens to chase down cellular fraud is often 
looking for a particular phone which in reality is not the phone they are 
looking for.  For example, you can provide the SCM for a Radio Shack phone, 
when in reality you are using a Novatell (How this is done from changing 
the SCM I do not know...remember...I didn't write this). 
 
        The Number Assignment Module (NAM) also has the SIDH (System 
Identification for Home System) number programmed into it.  Refer to SIDH 
TABLE.  The transmittal of the SIDH number tells the carrier where to forward 
the billing information to in case the user is "roaming".  The SIDH table 
tells the major cities and their identifying numbers.  Changing an SIDH is 
programming job that takes only minutes, but be aware that the ESN is still 
sent to the cellular phone company.  After they realize that the ESN is  
connected to either a fake number or a phone that is not in the network, they 
will block service.  They only way around this is to reprogram the ESN. 
 
***************************************************************************** 
 
PART II.                      DEFINITIONS 
 
 
The following is a list of commonly used abbreviations used in cellular 
phones. 
 
SIDH 
 
A 15-bit field in the NAM designating the System Identification for the Home 
System.  Bit 0 of the SIDH corresponds to the Preferred System flag used 
elsewhere in the NAM.  Bits 6 and 5 of byte 0 are international code bits. 
Normally the SIDH is entered during programming of the phone as a 5 digit 
decimal number.  Enter 0's to the left-most unused positions when  
reprogramming. 
 
L.U. 
 
Local Use Flag.  Tells the cellular phone user if it must preregister with 
the system.  Preregistration with the system means that a mobile must  
transmit its parameters to the Cellular System as soon as the power-up 
task and the control channel tasks are completed. "1" enables the flag. 
Usually set to "1". 
 
MIN MARK 
 
A 1-bit flag designating that MIN2 (area code) is always sent when making 
system access.  "1" enables the flag.  Usually set to "1". 
 
MIN2 
 
A 10-bit field representing the area code of the mobile ID number. 
 
MIN1 
 
A 24-bit field representing the mobile telephone number.  MIN2 plus MIN1 
equals MIN, the 10-digit phone number. 
 
SCM 
 
A 4-bit field designating the Station Class Mark. A (3-Watt) 832 channel 
mobile unit typically will be 1000, a 1.2 Watt portable 1001 or a 0.6 Watt 
handheld 1010 or 1110 (discontinuous transmission, meaning push-to-talk). 
These are class I, Class II and Class III power levels respectively. 
With the SCM the cellular system determines whether or not a cellular phone 
can be switched to one of the 156 channels. 
        Bit-1 is "0" for 666 and "1" for 832. (See cellular freq. list) 
        Bit-2 is "0" for a mobile unit and "1" for a voice-activated  
          transmit. 
        Bit-3 and -4 identify the power class of the phone:  
                "00" = 3.0 watts 
                "01" = 1.2 watts 
                "10" = 0.6 watts 
                "11" is not assigned 
 
IPCH 
 
An 11-bit field designating the initial paging channel to be used if in 
the home system.  Normally it is 334 for wireline systems, 333 for non- 
wireline systems.  But most phones allow other settings for test purposes. 
 
ACCOLC 
 
A 4-bit field designating the overload class for the cellular phone.  The 
intention of this entry is to allow the Cellular System to be able to  
determine priority in the event of a system overload, however it is currently 
useless as the system operators have generally not provided guidance for 
thier installers.  The usual (and correct) system now in effect (in U.S.) is 
to use a "0" plus the last digit of the phone number.  Test phones should be 
set at "10",emergency vehicles at "11","12" through "15" are reserved. 
(A class 15 system is supposed to be police, fire, or military). 
P.S. 
 
1 1-bit flag designating the preferred system.  If PS is "0", channels 334 
through 666(EVIL!!!) are used.  If PS is "1" then channels 1 through 333 are 
used.  Even numbered system numbers (B systems) require a PS of "0", odd 
system numbers (A systems) require a "1". 
 
GIM 
 
A 4-bit field designating the Group Identification Mark.  This number tells 
the Cellular system how far to look in the SIDH to determine if it is roaming 
in a system which may have a roam agreement with the phone system.  It is 
usually set to "10". 
 
LOCK DIGITS 
 
A 4-bit field designating the unlock code.  The digit "0" in the lock code 
is represented by an "A" in the actual NAM hexidecimal data.  A lock code of 
all "0" sometimes unlocks the cellular phone.(Note: Lock codes are 3 digits. 
When programming a phone use "0" as the first number.) 
 
E.E. 
 
A 1-bit flag designating that end-to-end signaling is enabled.  End-to-end 
signaling means that the DTMF tones will be transmitted on the voice channel 
as well as being echoed on the handset.  This feature in necessary for 
such services as Bank by Phone, activating answering machines and in third 
party long distance services such as Sprint and MCI. A "1" enables the flag. 
Usually set to "1". 
 
REP 
 
A 1-bit flag designating that repertory memory (speed dialing) in the 
cellular phone is enabled.  And once a again a "1" enables the flag. 
 
H.A. 
 
A 1-bit flag designating that the horn alert feature in enabled. "1" enables  
the flag. 
 
H.F. 
 
A 1-bit flag designating that the handsfree option is enabled. A "1" enables 
the flag.  Often, transceivers supplied as hands-free units require that 
this flag be left at "0". 
 
***************************************************************************** 
 
PART III.                      TYPES OF NAMS 
 
                     NAM Types Used in Cellular Phones 
 
NAM- Number Assignment Module - A 32 word by 8 bit PROM 
The NAM contains all the information that can be programmed to the phone 
directly from the handset. (i.e. SIDH,MIN,LOCK-CODE,etc.). 
 
All phones except NEC will accept tri-state NAMs.  NEC requires an open 
collector NAM.  Fujitsu phones will accept either open collector or tri- 
state NAMs. 
 
Brand Qualifications:  Fujitsu and Alpine phones will not operate properly 
with any Harris Brand NAM or with any Signetics brand NAMs with a part 
number NOT ending with an "A".  TI NAMs must not be used in GE Star models. 
Panasonic has suggested only TI NAMs should be used in their phones.  NAMs 
are available in ceramic (F) or plastic encapsulation (N). 
 
BRAND        OPEN COL.    TRI-STATE      OPEN COL.        TRI-STATE 
============================================================================= 
 
Signetics        82S23       82S123 
 
Texas Inst.     74S188       74S288     TBP18SA030        TBP18S030 
                                         
AMD           AM27LS18     AM27LS19        AM27S18          AM27S19 
 
Texas Inst. TBP38SA030    TBP38S030 
 
Harris          HM7602       HM7603 
 
MMI            53/6330      53/6331 
 
MMI          53/63S080    53/63S081 
 
NSC           DM54S188     DM54S288       DM74S188 
 
NSC            DM82S23     DM82S123 
 
Motorola   This is for a special NAM used in some Motorolas.  Requires 
           an adapter. 
 
Fujitsu         MB7056       MB7051 
 
***************************************************************************** 
 
PART IV.                        NAM FORMAT MAP 
 
                                                               HEX 
MARK DEFINITION    MOST <-  BIT SIGNIFICANCE ->  LEAST       ADDRESS    
---------------------------------------------------------------------------- 
                  0         SIDH (14-8)                        00  
                            SIDH (7-0)                         01 
LU=LOCAL USE**    000000          MIN                          02 
LU                A/B*  RI*       MIN2(33-28)                  03 
                            MIN2(27-24)       0000             04 
                  0000      MIN1(23-20)                        05 
                            MIN1(19-12)                        06  
                            MIN1(11-4)                         07 
                            MIN1(3-0)         0000             08 
                  0000      SCM(3-0)                           09  
                  00000     IPCH(10-8)                         0A 
                            IPCH(7-0)                          0B  
                  0000      ACCOLC(3-0)                        0C   
PS=PREFERRED**    0000000   PS                                 0D 
   SYSTEM         0000      GIM(3-0)                           0E  
                   LOCK DIGIT 1           LOCK DIGIT 2         0F 
                   LOCK DIGIT 3           LOCK SPARE BITS      10 
EE=END TO END      EE           000000          REP            11 
  SIGNALING        HA           000000          HF             12 
REP=REPERTORY      ---------------------------------------------- 
HA=HORN ALERT                                                  13 
HF=HANDS FREE                                                  14 
                                                               15 
                                                               16 
                              SPARE LOCATIONS (13-1D)          17 
                              CONTAIN ALL ZEROS EXCEPT         18 
                              FOR MANUFACTURERS OPTIONS        19 
                                                               1A 
                                                               1B 
                                                               1C 
                                                               1D 
                                    NAM CHECKSUM ADJUSTMENT    1E 
                                    NAM CHECKSUM               1F  
                                 
 
The Checksum Adjustment and Checksum are calculated automatically after 
the data has been edited for the NAM.  The sum of all words in the NAM plus 
the last two must equal a number with "0" in the last two digits.  The radio 
checks this sum and if it isn't correct, the radio assumes the NAM is bad or 
that it has been tampered with. 
 
 
 * - These bits are used only by AT&T,Hitachi and Mitsubishi. They are A/B 
 Enable and Roam Inhibit. They must be "0" for all other models. 
 
** - My information does not agree here. One source claims that address 03 
     has 6 bits and that address 0D has 7 bits. The other source states the 
     the exact opposite. 
 
***************************************************************************** 
PART V.                     STANDARD NAM FORMATS 
 
        NAMs are generally mapped the same in all cellular phones, and the 
ones that have no "fancy" options are generally programmed the same.  This 
chart provides the usual digits and settings for almost every NAM. 
 
ITEM        DESCRIPTION             NO. OF DIGITS         USUAL SETTING 
-------------------------------------------------------------------------- 
1           First 3 digits               3                     XXX 
            of phone number 
 
2           Last 4 digits                4                    XXXX 
            of phone number 
 
3           Lock Code(LOCK)            3 or 4               XXXA or XXXX           
 
4           Area Code (MIN2)             3                     XXX 
 
5           Home Area System 
            ID No. (SIDH)                4*                   XXXX 
 
6           Horn Alert (HA)              1                    0 or 1 
 
7           Hands Free (HF)              1                    0 or 1 
 
8           End-to-End Signaling         1                      1 
            (EE) 
 
9           Repertory Mark (REP)         1                      1 
 
10          Group Identification         2                     10 
            Mark (GIM) 
 
11          Access Overload Class        2                     XX* 
            (ACCOLC) 
 
12          Station Class Mark (SCM)     4*                   XXXX 
 
13          Local Use Mark (LU)          1                      1 
 
14          Min Mark (MIN)               1                      1 
 
15          Initial Paging Channel       3                 333 or 334* 
            (IPCH) 
 
16          Preferred System Mark        1                   0 or 1* 
            (PS) 
 
* Notes-  
 
   1. Home Area ID Number normally consists of five digits. However, four 
   are usually sufficient is the U.S. 
 
   2.  Access Overload Class is generally made up of a "0" plus the last 
   digits of the telephone number.  Some systems set at "15" or "00". 
 
   3. Station Class Mark is expressed as four binary digits. 
 
   4. Initial Paging Channel is 334 for wireline, 333 for non-wireline 
   systems. 
 
   5. The Preferred Mark System is set to "0" for wireline, "1" for non- 
   wireline systems. 
 
***************************************************************************** 
PART VI. 
                 NAM Programming (Reprogramming) Instructions 
 
                          For 30+ Cellular Telephones 
 
 
----------------------------------------------------------------------------- 
PLEASE NOTE: Area specific numbers contained within these programming 
             instructions may not be accurate for your cellular area. 
----------------------------------------------------------------------------- 
 
                        Programming Instructions for: 
 
                        DIAMONDTEL MESA90X HANDHELD 
 
 
ACTION                            TO STORE            DISPLAY 
 
USED EQUIPMENT: TO DISPLAY CURRENT UNLOCK CODE - 
PRESS FCN 7 
ENTER 4 DIGIT SECURITY CODE 
ENTER NEW 3 DIGIT UNLOCK CODE 
PRESS CLR 
 
PWR up unit 
Press "END" and hold within 10 seconds of pwr up 
Enter "5132920" 
Release END key. 
 
0                                 SEND                DUAL NO 
 
XXXXXXXXXX                        SEND                NO1 
 
_ _ _ _ _                         SEND                SID1 
 
1                                 SEND                LU1 
 
1                                 SEND                EX1 
 
334                               SEND                IPCH1 
 
07                                SEND                ACCOLC1 
 
0                                 SEND                PREF1 
 
10                                SEND                GIM1 
 
0                                 SEND                RI1 
 
1                                 SEND                DTX1 
 
1                                 SEND                AR1 
 
1234                              SEND                SEC 
 
1                                 SEND                EE 
 
1                                 SEND                C TONE 
 
0                                 SEND                AL 
 
0                                 SEND                BO 
 
1                                 SEND                BEEP 
 
 
TO EXIT PROGRAMMING MODE PRESS "END" AT ANY TIME 
 
TO RESET NAM FROM THE LIMIT OF 3 PROGRAM ATTEMPTS 
PWR up unit 
Press "END" and hold within 10 seconds of pwr up 
TO RESET NAM OF MESA 90 HANDHELD USE THE CODE "6972814" 
 
 
 
 
                        Programming Instructions for: 
 
                        DIAMONDTEL MESA99X HANDHELD 
 
 
ACTION                            TO STORE            DISPLAY 
 
USED EQUIPMENT: TO DISPLAY CURRENT UNLOCK CODE - 
PRESS FCN 7 
ENTER 4 DIGIT SECURITY CODE 
ENTER NEW 3 DIGIT UNLOCK CODE 
PRESS CLR 
 
PWR up unit 
Press "END" and hold within 10 seconds of pwr up 
Enter "5132920" 
Release END key. 
 
0                                 SEND                DUAL NO 
 
XXXXXXXXXX                        SEND                NO1 
 
_ _ _ _ _                         SEND                SID1 
 
1                                 SEND                LU1 
 
1                                 SEND                MIN MARK1 
 
334                               SEND                IPCH1 
 
07                                SEND                ACCOLC1 
 
10                                SEND                GIM1 
 
0                                 SEND                RI1 
 
0                                 SEND                DTX1 
 
0                                 SEND                AR1 
 
1234                              SEND                SEC 
 
1                                 SEND                CONTINUE D.T.M.F. 
 
0                                 SEND                AUTO LOCK 
 
0                                 SEND                BOOSTER 
 
 
TO EXIT PROGRAMMING MODE PRESS "END" AT ANY TIME 
 
 
 
 
                        Programming Instructions for: 
 
                          GATEWAY CP 900 HANDHELD 
 
USED EQUIPMENT: TO DISPLAY CURRENT UNLOCK CODE - 
CURRENT UNLOCK CODE CAN NOT BE SEEN AND MUST BE KNOWN TO CHANGE 
THE CURRENT UNLOCK CODE. 
PRESS MENU 
ENTER 03 
ENTER CURRENT 4 DIGIT SECURITY CODE 
ENTER NEW 4 DIGIT SECURITY CODE 
PHONE WILL AUTO EXIT TO READY 
 
ACTION                            TO STORE            DISPLAY 
 
PRESS MENU  99  ENTR SCRTY CODE(FCTRY PRST IS 9999)  PROGRAM NAM 
 
_ _ _ _ _                         SEND                SID 
 
XXXXXXXXXX                        SEND                PHONE NUMBER 
 
0334                              SEND                IPC 
 
07                                SEND                ACCOL 
 
10                                SEND                GIM 
 
1                                 SEND                MOBILE I.D. NUMBER 
 
1                                 SEND                LOCAL USE MARK 
 
2                                 SEND                SYSTEM SELECT (B) 
 
UPON PRESSING SEND THE PHONE WILL CYCLE TO WAIT  AND THEN RETURN TO THE 
READY MODE. 
 
TO DISPLAY THE NEW PHONE NUMBER: 
 
PRESS RCL 00 
 
 
 
 
                         Programming Instructions for: 
 
                           GENERAL ELECTRIC MINI II 
 
ACTION                            TO STORE            DISPLAY 
 
USED EQUIPMENT: TO DISPLAY CURRENT UNLOCK CODE - 
PRESS FCN 7 
ENTER 4 DIGIT SECURITY CODE 
ENTER NEW 3 DIGIT UNLOCK CODE 
PRESS CLR 
 
PWR up unit 
Press and hold END key within 10 seconds of pwr up 
Enter "6282905" 
Release END key 
 
0                                 Press SEND          DUAL NO 
 
XXXXXXXXXX                        Press SEND          NO1 
 
_ _ _ _ _                         Press SEND          SID1 
 
1                                 Press SEND          LU1 
 
1                                 Press SEND          EX1 
 
0334                              Press SEND          IPCH1 
 
07                                Press SEND          ACCOLC1 
 
0                                 Press SEND          PREF1 
 
10                                Press SEND          GIM1 
 
0                                 Press SEND          RI1 
 
1                                 Press SEND          DTX1 
 
1                                 Press SEND          AR1 
 
1234                              Press SEND          SEC 
 
1                                 Press SEND          EE 
 
1                                 Press SEND          C DTMF 
 
0                                 Press SEND          AL 
 
0                                 Press SEND          BEEP 
 
0                                 Press SEND          BO 
 
 
TO EXIT PROGRAMMING MODE PRESS "END" AT ANY TIME 
 
 
 
 
                       Programming Instructions for: 
 
                            GENERAL ELECTRIC MINI 
 
ACTION                            TO STORE            DISPLAY 
USED EQUIPMENT: TO DISPLAY CURRENT UNLOCK CODE - 
UNLOCK CODES WILL BE CHANGED ONLY IN PROGRAMMING MODE 
FOLLOW THE INSTRUCTIONS THAT FOLLOW 
 
PWR up unit 
Press and hold CL key within 10 seconds of pwr up 
0Enter "7591122" 
Release CL key 
 
 
XXXXXXXXXX                        PRESS SEND          MIN 
 
123                               PRESS SEND          UNLOCK 
 
_ _ _ _ _                         PRESS SEND          SID 
 
1                                 PRESS SEND          LU 
 
1                                 PRESS SEND          MIN MARK 
 
334                               PRESS SEND          IPCH 
 
07                                PRESS SEND          ACCOLC 
 
0                                 PRESS SEND          PS 
 
10                                PRESS SEND          GIM 
 
1                                 PRESS SEND          EE 
0                                 PRESS SEND          BOOSTER 
 
1                                 PRESS SEND          AR 
 
 
TO EXIT PROGRAMMING MODE PRESS "END" AT ANY TIME 
 
 
 
 
                       Programming Instructions for: 
 
                              MITSUBISHI  800 
 
ACTION                            TO STORE            DISPLAY 
 
PWR up unit 
Press and Hold STO within 10 Seconds of pwr up 
Enter "5474432" 
Release STO 
 
 
0                                 Press SEND          dUAL 
 
XXXXXXXXXX                        Press SEND          NO1 
 
_ _ _ _ _                         Press SEND          SId1 
 
1                                 Press SEND          LU1 
 
0                                 Press SEND          MIN Mark 
 
0334                              Press SEND          IPCH 
 
07                                Press SEND          ACCOLC 
 
0                                 Press SEND          PS1 
 
10                                Press SEND          GI1 
 
1234                              Press SEND          SECUrity 
 
1                                 Press SEND          EE 
 
0                                 Press SEND          dt 
 
1                                 Press SEND          HF 
 
0                                 Press SEND          InHIbit 
 
1                                 Press SEND          C tOnE 
 
0                                 Press SEND          SyS A/B 
 
0                                 Press SEND          dUAL HS 
 
0                                 Press SEND          InHibit Ld 
 
 
TO EXIT PROGRAMMING MODE PRESS "END" AT ANY TIME 
 
 
 
 
                        Programming Instructions for: 
 
                                MITSUBISHI 900 
 
ACTION                            TO STORE            DISPLAY 
 
PWR up unit 
Press and Hold END key within 10 seconds of pwr up 
Enter "6972814" 
Release END key 
 
0                                 Press SEND          DUAL NO 
 
XXXXXXXXXX                        Press SEND          NO1 
 
_ _ _ _ _                         Press SEND          SID1 
 
1                                 Press SEND          LU1 
 
0                                 Press SEND          EX1 
 
0334                              Press SEND          IPCH1 
 
07                                Press SEND          ACCOLC1 
 
0                                 Press SEND          PREF1 
 
10                                Press SEND          GIM1 
 
0                                 Press SEND          RI1 
 
1                                 Press SEND          DTX1 
 
1                                 Press SEND          AR1 
 
1234                              Press SEND          SEC 
 
1                                 Press SEND          EE 
 
1                                 Press SEND          C DTMF 
 
0                                 Press SEND          AL 
 
0                                 Press SEND          BO 
 
1                                 Press SEND          BEEP 
 
TO EXIT PROGRAMMING MODE PRESS "END" AT ANY TIME 
 
TO ENTER TEST MODE HOLD END ON PWR UP-CODE 0944635 
 
 
 
 
                        Programming Instructions for: 
 
                              MOTOROLA 8000H 
 
 
ACTION                            TO STORE            DISPLAY 
 
USED EQUIPMENT: TO DISPLAY CURRENT UNLOCK CODE - 
THIS FUNCTION IS PROVIDED IN STEP 9 OF THE PROGRAMMING 
MODE 
 
 
PWR up unit 
Enter   STORE #123456123456 RCL 
If the phone is fresh from factory then 
Enter   STORE #000000000000 RCL 
If the phone is used or already programmed then 
Enter   STORE #123456123456 RCL 
 
DISPLAY WILL SHOW    01 
PRESS  * 
 
_ _ _ _ _                         *                   02  (SID) 
 
XXX                               *                   03  (Area Code) 
 
XXX XXXX                          *                   04  (Phone #) 
 
14                                *                   05 
 
07                                *                   06 
 
00                                *                   07 
 
123456                            *                   08 
 
123                               *                   09 
 
334                               *                   10 
 
010100                            *                   11 
 
000                               * 
 
PRESS * TO REVIEW ENTRIES 
 
TO BURN NAM:  PRESS SEND WHILE 01,02,03, ETC. IS DISPLAYED 
 
SET TO SCAN B MODE BY : 
 
RCL *  :  PRESS * UNTIL SCAN B MODE SHOWS then: 
 
press store 
 
 
 
 
                        Programming Instructions for: 
 
                      MOTOROLA ULTRA CLASSIC HANDHELD 
 
ACTION                            TO STORE            DISPLAY 
 
USED EQUIPMENT: TO DISPLAY CURRENT UNLOCK CODE - 
THE UNLOCK CODE IS PROGRAMMED IN STEP 8 OF THE PROGRAMMING 
MODE 
 
 
FOR NEW PHONE:  Press FCN, 0 + Security code entered twice (Factory 
                preset is 000000),  RCL 
 
The message 01 will appear in the display to confirm programming mode. 
 
Press *                                               01        Press * 
 
1)  _ _ _ _ _                     Press *             02        Press * 
 
2)  XXX                           Press *             03        Press * 
 
3)  XXX XXXX                      Press *             04        Press * 
 
4)  14                            Press *             05        Press * 
 
5)  07                            Press *             06        Press * 
 
6)  10                            Press *             07        Press * 
 
7)  123456                        Press *             08        Press * 
 
8)  123                           Press *             09        Press * 
 
9)  0334                          Press *             10        Press * 
 
10) 010101                        Press *             11        Press * 
 
11) 101                           Press *             12        Press * 
 
Review entries by pressing  "*" repeatedly. 
 
Press SEND to program phone. 
 
 
 
 
                        Programming Instructions for: 
 
                             NEC  P300 
 
 
ACTION                            TO STORE            DISPLAY 
 
   THESE INSTRUCTIONS FOR SERIAL NUMBERS AFTER 135-839601 
 
Insert NAM Programming Adapter (NECAM #41-2019) into plug connector on P300 
phone bottom. 
 
PWR On 
 
RCL # 0 1   to enter test mode.  Phone will display shaded blocks. 
 
RCL # 7 6   to select NAM.  Phone will show 76- 
Press 0 #   to program NAM 1.   (NAM 1=0,NAM 2=1,NAM 3=2,NAM 4=3) 
 
RCL # 7 1   to enter programming mode. 
 
XXXXXXXXXX                        PRESS #             MIN 
 
1234                              PRESS #             LOCK CODE 
 
_ _ _ _ _                         PRESS #             SID 
 
10                                PRESS #             GROUP I.D. 
 
0334                              PRESS #             INITIAL PAGING CH 
 
0                                 PRESS #             SYSTEM SELECT (1=A) 
 
07                                PRESS #             ACCOLC 
 
1                                 PRESS #             MIN MARK 1 
 
1                                 PRESS #             LOCAL USE 
 
911                               PRESS #             EMERGENCY NO. 
 
Press Clr (and hold) to exit programming and return to TEST MODE. 
 
Press RCL # 0 2  to burn and exit to standby. 
 
 
 
   THESE INSTRUCTIONS FOR SERIAL NUMBERS PRIOR TO 135-839601 
 
Insert NAM Programming Cable (41-2019) 
PWR on 
RCL # 7 6 to enter TEST MODE 
Press 0 # to select NAM. 
RCL # 7 1 
You are now in Programming Mode. 
Enter NAM info as above. 
Press and hold CLR to exit. 
Pwr down. 
 
 
 
 
                        Programming Instructions for: 
 
                             NEC  P9100 
 
 
ACTION                            TO STORE            DISPLAY 
 
USED EQUIPMENT: TO DISPLAY CURRENT UNLOCK CODE - 
UNLOCK CODES WILL BE CHANGED ONLY IN PROGRAMMING MODE 
FOLLOW THE INSTRUCTIONS THAT FOLLOW 
 
 
 
Make sure NAM battery is fully charged before attempting programming 
Switch power on 
Press RCL #01 display will then show shaded blocks 
 
For a USED phone - to clear nam and accumulated call timer 
Press RCL #39 
 
To program NAM1 
Press RCL #760# 
To enter programming mode Press RCL #71 
 
XXXXXXXXXX                        Press #             MIN 
 
1234                              Press #             Lock Code 
 
_ _ _ _ _                         Press #             SYS. I.D. 
 
10                                Press #             G.I. Mark 
 
0334                              Press #             First Paging Channel 
 
0                                 Press #             System Select 
 
07                                Press #             ACCOLC 
 
0                                 Press #             MIN Mark 
 
1                                 Press #             Local Use 
 
 
TO EXIT PROGRAM MODE AT THIS TIME PRESS CLR AND HOLD 
DISPLAY WILL SHOW TEST MODE 
 
TO EXIT TEXT MODE PRESS RCL#02 
 
IF THE MEMORY IS CLEARED VIA RCL #39 DURING THE PROGRAMMING THEN THE PHONE 
WILL AUTOMATICALLY ENTER FULL-LOCK AFTER EXITING THE TEST MODE 
TO UNLOCK: FCN #XXXX(4 DIGIT LOCK CODE FOR LAST NAM PROGRAMMED). 
 
 
 
 
                        Programming Instructions for: 
 
                                 NOKIA P-30 
 
ACTION                            TO STORE            DISPLAY 
 
USED EQUIPMENT: TO DISPLAY CURRENT UNLOCK CODE - 
PRESS SEL 7 UNLCODE APPEARS ON THE DISPLAY 
ENTER 5 DIGIT SECURITY CODE AND THE CURRENT UNLOCK CODE APPEARS IN 
THE DISPLAY PRESS CLR AND ENTER THE NEW FOUR DIGIT UNLOCK CODE 
PRESS SEL TO STORE THE NEW CODE - NOTE: IF YOU DON'T PRESS SEL WITHIN 
FIVE SECONDS THE DISPLAY WILL CLEAR AND CANCEL THE FUNCTION 
 
 
PWR up unit 
Enter  *17*2001*12345* 
HO-Id must appear on display 
Press SEL to view current value 
Display will be one step behind TO STORE instructions 
 
 
_ _ _ _ _                         Press SEL           ACCESS  (SID) 
 
1                                 Press SEL           LOCAL 
 
1                                 Press SEL           PhonE n 
 
XXXXXXXXXX                        Press SEL           CLASS 
 
10                                Press SEL           PAGE ch 
 
334                               Press SEL           O-LOAd 
 
07                                Press SEL           GrouP 
 
10                                Press SEL           SEC 
 
12345                             Press SEL          AUTO EXIT PROGRAM MODE 
 
TO EXIT PROGRAMMING MODE AT ANY TIME PRESS "END" 
 
WHEN THE SEL KEY IS PRESSED FOLLOWING THE LAST PARAMETER VALUE, THE PHONE 
WILL AUTOMATICALLY EXIT THE NAM PROGRAMMING MODE AND RETURN TO NORMAL 
OPERATION 
 
 
 
 
                        Programming Instructions for: 
 
                                NOVATEL PTR800 
 
 
 
ACTION                            TO STORE            DISPLAY 
 
USED EQUIPMENT: TO DISPLAY CURRENT UNLOCK CODE - 
UNLOCK CODES WILL BE CHANGED ONLY IN PROGRAMMING MODE 
FOLLOW THE INSTRUCTIONS THAT FOLLOW 
 
 
PWR up unit 
Press FCN 
Press FCN again 
Enter *626776* 
Display will show CMT REV and a date code - Press Volume Up 
Display will show NAM SELECT1  Press Volume Up 
 
_ _ _ _ _       PRESS #           PRESS VOLUME UP     SIDH 
                                  PRESS VOLUME UP     SCM 
XXXXXXXXXX      PRESS #           PRESS VOLUME UP     MIN 
0333            PRESS #           PRESS VOLUME UP     IDCCA 
0334            PRESS #           PRESS VOLUME UP     IDCCB 
0334            PRESS #           PRESS VOLUME UP     IPCH 
07              PRESS #           PRESS VOLUME UP     ACCOLC 
10              PRESS #           PRESS VOLUME UP     GIM 
123             PRESS #           PRESS VOLUME UP     LOCK A 
456             PRESS #           PRESS VOLUME UP     LOCK B 
1               PRESS #           PRESS VOLUME UP     OPTION LC 
1               PRESS #           PRESS VOLUME UP     OPTION EX 
0               PRESS #           PRESS VOLUME UP     OPTION PS 
0               PRESS #           PRESS VOLUME UP     OPTION NSC 
1               PRESS #           PRESS VOLUME UP     OPTION EE 
1               PRESS #           PRESS VOLUME UP     OPTION REP 
0               PRESS #           PRESS VOLUME UP     OPTION HA 
0               PRESS #           PRESS VOLUME UP     OPTION HF 
0               PRESS #           PRESS VOLUME UP     OPTION F1 
0               PRESS #           PRESS VOLUME UP     OPTION F2 
0               PRESS #           PRESS VOLUME UP     OPTION F3 
0               PRESS #           PRESS VOLUME UP     OPTION F4 
 
TO EXIT PROGRAMMING MODE AT ANY TIME PRESS FCN END 
 
FCN FCN *6462257* WILL CLEAR THE NAM IF IT HAS BEEN PROGRAMMED MORE THAN 
3 TIMES OR IF THE NEED EXISTS TO CLEAR THE MEMORY 
 
 
 
 
                        Programming Instructions for: 
 
                                NOVATEL PTR825 
 
ACTION                            TO STORE            DISPLAY 
PWR up unit 
Press FCN 
Press FCN again 
Enter *697201* 
Display will show CMT REV 972  105  Press Volume Up 
 
1                                 PRESS # VOL UP      NAM SELECT 1 
_ _ _ _ _                         PRESS # VOL UP      SIDH 
10                                PRESS VOL UP        SCM 
XXXXXXXXXX                        PRESS # VOL UP      MIN 
0333                              PRESS VOL UP        IDCCA 
0334                              PRESS VOL UP        IDCCB 
0334                              PRESS # VOL UP      IPCH 
07                                PRESS # VOL UP      ACCOLC 
10                                PRESS # VOL UP      GIM 
123                               PRESS # VOL UP      LOCK A 
123                               PRESS # VOL UP      LOCK B 
1                                 PRESS # VOL UP      LC 
1                                 PRESS # VOL UP      OPTION EX 
0                                 PRESS # VOL UP      PS - PREF SYSTEM 
0                                 PRESS VOL UP        OPTION NSC 
1                                 PRESS # VOL UP      OPTION EE-END TO END 
1                                 PRESS # VOL UP      OPTION REP 
0                                 PRESS # VOL UP      HORN ALERT 
0                                 PRESS # VOL UP      HANDS FREE 
0                                 PRESS # VOL UP      OPTION F1 
0                                 PRESS # VOL UP      OPTION F2 
0                                 PRESS # VOL UP      OPTION F3 
1                                 PRESS # VOL UP      OPTION F4 AIR RND UP 
0                                 PRESS # VOL UP      OPTION F5 FUTURE USE 
0                                 PRESS # VOL UP      OPTION F6 FUTURE USE 
0                                 PRESS # VOL UP      OPTION F7 FUTURE USE 
 
 
 
Programming will now wrap to beginning SIDH display. 
Press VOL UP to review entries 
 
 
 
 
                       Programming Instructions for: 
 
                         OKI HANDHELD MODEL # 750 
 
ACTION                            TO STORE            DISPLAY 
 
USED EQUIPMENT: TO DISPLAY CURRENT UNLOCK CODE - 
THIS FUNCTION IS PROVIDED FOR IN THE PROGRAMMING SEQUENCE 
 
 
 
 
Pwr up unit 
Press (*) and (#) simultaneously 
Enter 10 digit Sec Code as follows:  *12345678# 
What follows can be done only once! 
 
The display "Enter NEW PW-Sto" 
Enter 0123456789 then press STORE 
 
Pwr unit down. 
 
Pwr up unit 
Press MENU and RCL simultaneously 
Enter 0123456789                                      Software Version and 
                                                      ESN Number in HEX 
 
                                                      Clears in 2 secs. 
 
                                                      Spd Dial Mem Clear 
 
Press 0                           Press STO           Def Data Reset 
 
Press 0                           Press STO 
 
                                  NAM 1 Mode 
 
                                                      Own #111 111-1111 
 
XXX XXX XXXX                      Press STO  Vol Up   Security 
 
123456                            Press STO  Vol Up   OPTION 
 
1100                              Press STO  Vol Up   SCM 
 
1010                              Press STO  Vol Up   GIM 
 
10                                Press STO  Vol Up   Unlock # 
 
1234                              Press STO  Vol Up   ACCOLC # 
 
07                                Press STO  Vol Up   IPCH NO. 
 
0334                              Press STO  Vol Up 
 
_ _ _ _ _                         Press STO  Vol Up   System ID: 
 
At this time you may exit the programming mode by pressing CLR to bypass 
the other NAM modules. 
 
 
 
 
                       Programming Instructions for: 
 
                         OKI HANDHELD MODEL # 900 
 
ACTION                            TO STORE            DISPLAY 
 
USED EQUIPMENT: TO DISPLAY CURRENT UNLOCK CODE - 
THIS FUNCTION IS PROVIDED FOR IN THE PROGRAMMING SEQUENCE 
 
 
Pwr up unit 
Press RCL and MENU simultaneously 
Enter 10 digit Sec Code as follows:  *12345678# 
What follows can be done only once! 
 
The display "Enter NEW PW-Sto" 
Enter 0123456789 then press STORE. 
The display "Re-Enter New PW-Sto" 
Enter 0123456789 then press STORE to enter Programming Mode. 
IF You don't wish to keep the new password then Pwr unit down. 
 
 
                                                      Software Version and 
                                                      ESN Number in HEX 
 
                                                      Clears in 2 secs. 
 
                                                      Spd Dial Mem Clear 
 
Press *                           Press STO           SPD DIAL MEM CLEAR 
 
Press *                           Press STO           DEFAULT DATA CLEAR 
 
                                  NAM 1 Mode 
 
                                                      Own #111 111-1111 
 
XXX XXX XXXX                      Press STO  Vol Up   MIN 
 
123456                            Press STO  Vol Up   SECURITY 
 
_ _ _ _ _                         Press STO  Vol Up   SYSTEM ID: 
 
0334                              Press STO  Vol Up   IPCH 
 
07                                Press STO  Vol Up   ACCOLC # 
 
15                                Press STO  Vol Up   GROUP I.D. 
 
1234                              Press STO  Vol Up   UNLOCK CODE 
 
1010                              Press STO  Vol Up   STATION CLASS 
 
1110                              Press STO  Vol Up   OPTION 
 
 
 
At this time you may exit the programming mode by pressing CLR to bypass 
the other NAM modules. 
 
 
 
 
                       Programming Instructions for: 
 
                             PANASONIC EB3500 
 
 
 
    Charged Battery and Nam Adaptor are needed. 
 
ACTION                        TO STORE            DISPLAY 
 
USED EQUIPMENT: TO DISPLAY CURRENT UNLOCK CODE - 
THIS FUNCTION IS PROVIDED FOR IN THE PROGRAMMING SEQUENCE 
 
 
 
 
*0000# to enter program mode 
 
 
*1                           Press SND            NAM 1 MODE 
 
_ _ _ _ _                    Press STO 01         SIDH 
 
XXXXXXXXXX                   Press STO 02         OWNDL 
 
0                            Press STO 03         PRESYS 
 
334                          Press STO 04         IPCH 
 
07                           Press STO 05         ACCOLC 
 
10                           Press STO 06         GIM 
 
00                           Press STO 07         DLMT 
 
10                           Press STO 08         SCM 
 
911                          Press STO 09         SPDL 
 
1234                         Press STO 10         LOCK 
 
1 1 0 1 1 0 0 0              Press STO 11         FCN 1 
 
0 0 0 1 0 1 0 0              Press STO 12         FCN 2 
 
1 1 1 1 0 1 1 1              Press STO 13         FCN 3 
 
STO ** 
END   to program phone 
 
 
 
 
                     Programming Instructions for: 
 
                         COLT TRANSPORTABLE 
 
 
ACTION                            TO STORE            DISPLAY 
 
USED EQUIPMENT: TO DISPLAY CURRENT UNLOCK CODE - 
UNLOCK CODES WILL BE CHANGED ONLY IN PROGRAMMING MODE 
FOLLOW THE INSTRUCTIONS THAT FOLLOW 
 
Phone must be locked, to accomplish:   press FUNC 5 
Enter:  FUNC #626# FUNC 
The software revision date will be shown. 
Press SEND 
This will advance phone through memory locations. 
E.S.N. will be displayed, press SEND again. 
 
XXX                               Press SEND          AREA CODE 
 
XXX XXXX                          Press SEND          PHONE NUMBER 
 
_ _ _ _ _                         Press SEND          SYSTEM ID 
 
07                                Press SEND          ACCOLC 
 
10                                Press SEND          GIM 
 
1                                 Press SEND          LOCAL USE MARK 
 
1                                 Press SEND          MIN MARK (MOBILE ID) 
 
123                               Press SEND          LOCK CODE 
 
0                                 Press SEND          AUTOMATIC LOCK 
 
123                               Press SEND          CALL RESTRICTION 
 
12                                Press SEND          CALL COUNTER RESET 
 
1                                 Press SEND          ENABLE HANDSFREE 
 
0                                 Press SEND          DISABLE HORN ALERT 
 
0                                 Press SEND          HA TURN OFF TIME 
 
12                                Press SEND          TOTAL AIRTIME RESET 
 
TO REVIEW PROGRAMMING AT THIS TIME PRESS SEND. 
 
TO EXIT PROGRAMMING AND STORE DATA AT ANY TIME PRESS 
END FUNC END   -    WAKE UP WILL SOUND, PHONE WILL BE LOCKED 
ENTER UNLOCK CODE- 123 
 
SYSTEM PREFERENCE MUST BE KEYPAD SELECTED!  PRESS  FUNC 7 FOR "A" NON W/L 
 
                                  OR        PRESS  FUNC 8 FOR "B" W/L SYS. 
 
 
 
 
                        Programming Instructions for: 
 
                     DIAMONDTEL MESA 55 TRANSPORTABLE 
 
 
ACTION                            TO STORE            DISPLAY 
 
PWR up unit 
Press "CL" and hold within 10 seconds of pwr up 
Enter "1951426" 
Current Mobile I.D. will display 
 
XXXXXXXXXX                        Press SEND                      MIN 
 
123                               Press SEND          1           SECURITY 
 
_ _ _ _ _                         Press SEND          2           SID 
 
1                                 Press SEND          3           LU 
 
1                                 Press SEND          4           MIN MARK 
 
334                               Press SEND          5           IPCH 
 
07                                Press SEND          6           ACCOLC 
 
0                                 Press SEND          7           PREF SYS 
 
10                                Press SEND          8           GIM 
 
1                                 Press SEND          9           EE 
 
1                                 Press SEND          10     ENBL HANDSFREE 
 
0                                 Press SEND          11          RI 
 
04                                Press SEND          12          AUX 1 
 
07                                Press SEND          13          AUX 2 
 
Phone automatically returns to show the 10 digits MIN number at this time 
and to indicate that the NAM has been programmed.  The END key should be 
pressed to burn the NAM. 
 
 
 
 
                        Programming Instructions for: 
 
                       DIAMONDTEL MESA95 TRANSPORTABLE 
 
ACTION                            TO STORE            DISPLAY 
 
PWR up unit 
Press and hold Clr within 10 Seconds of pwr up 
Enter "1951426" 
Release Clr 
 
 
0                                 Press SEND          duaAL no 
 
XXXXXXXXXX                        Press SEND          no1 
 
_ _ _ _ _                         Press SEND          SId1 
 
1                                 Press SEND          LU1 
 
1                                 Press SEND          E1 
 
334                               Press SEND          IPCH1 
 
07                                Press SEND          ACCOLC1 
 
0                                 Press SEND          PS1 
 
10                                Press SEND          GI1 
 
5                                 Press SEND          t InC1 
 
1234                              Press SEND          SECUrIty 
 
1                                 Press SEND          EE 
 
0                                 Press SEND          dt 
 
0                                 Press SEND          HF 
 
0                                 Press SEND          InHIbIt 
 
1                                 Press SEND          Ctone 
 
0                                 Press SEND          dIS CU 
 
0                                 Press SEND          dIS IGn 
                                                      SEnSE 
 
0                                 Press SEND          DUAL HS 
 
 
TO EXIT PROGRAMMING MODE PRESS "END" AT ANY TIME 
 
TO RESET NAM FROM THE LIMIT OF 3 PROGRAM ATTEMPTS 
FOLLOW THE BLOCK OF INSTRUCTIONS AT TOP USING "8291112" W/CLR 
 
TO RESET NAM OF MESA 90 HANDHELD USE THE CODE "6972814" 
 
 
 
 
                      Programming Instructions for: 
 
                           FUJITSU MOBILE PHONE 
 
ACTION                            TO STORE            DISPLAY 
 
PWR up unit 
Unit must be locked to program. 
To lock press F+LOCK 
PWR down unit. 
PWR up unit. 
Within 10 seconds press    #626#7764726 (#NAM#PROGRAM) 
A continuous tone will be heard for 7 seconds. 
PRESS AND HOLD THE   *   KEY WHILE THE TONE SOUNDS, 
                 DO NOT LET GO! 
The tone will change to an intermittent tone, then it will stop. 
Release the  *  key. 
 
CONGRATULATIONS!!! YOU ARE NOW IN PROGRAMMING MODE! 
 
_ _ _ _ _                         PRESS STOR          1           SIDH 
 
1                                 PRESS STOR          2           LOCAL 
 
1                                 PRESS STOR          3           MIN MARK 
 
XXXXXXXXXX                        PRESS STOR          4           MIN 
 
10                                PRESS STOR          5           STATION 
 
0334                              PRESS STOR          6           IPCH 
 
07                                PRESS STOR          7           ACCOLC 
 
0                                 PRESS STOR          8           PS 
 
10                                PRESS STOR          9           GIM 
 
1234                              PRESS STOR          10          LOCK 
 
1                                 PRESS STOR          11          CALL TIME 
 
2                                 PRESS STOR          12          AUTO LOCK 
 
1                                 PRESS STOR          13          CALL REST 
 
PRESS STOR TO REVIEW ENTRIES. 
WHEN AT MODE #1 PRESS SEND TO BURN NAM AND RETURN TO NORMAL OPERATION. 
 
IF PROGRAMMING WAS DONE INCORRECTLY A SHORT HIGH TONE WILL BE HEARD, YOU 
MUST THEN REPEAT DATA ENTRY. YOU MUST PRESS STOR AFTER EACH ENTRY FOR THE 
CHECKSUM FUNCTION TO BE FULFILLED. 
 
 
 
 
                       Programming Instructions for: 
 
                      GENERAL ELECTRIC CARFONE XR3000 
 
ACTION                            TO STORE            DISPLAY 
 
USED EQUIPMENT: TO DISPLAY CURRENT UNLOCK CODE - 
THE UNLOCK CODE IS PROGRAMMED IN STEP 2 OF THE PROGRAMMING 
MODE 
 
 
 
PWR up unit 
Press "CL" and hold within 10 seconds of pwr up 
Enter "923885" 
Serial # will display 
Press Send key to advance to first entry 
 
XXXXXXXXXX                        Press SEND          MIN 
 
123                               Press SEND          UNLOCK 
 
_ _ _ _ _                         Press SEND          SID 
 
1                                 Press SEND          LU 
 
1                                 Press SEND          MIN MARK 
 
334                               Press SEND          IPCH 
 
07                                Press SEND          ACCOLC 
 
0                                 Press SEND          PS 
 
10                                Press SEND          GIM 
 
0                                 Press SEND          AUX 
 
1                                 Press SEND          HANDS 
 
 
PRESS SEND TO REVIEW ENTRIES.  NOTE: AREA CODE (402) WILL DISPLAY FOR MIN 
THEN AUTO SWITCH TO REST OF NUMBER ON DISPLAY - BE PATIENT 
 
PRESS "E" KEY TO COMPLETE PROGRAMMING OF THE XR 3000 AT THIS TIME 
 
 
 
 
                       Programming Instructions for: 
 
                        GOLDSTAR SERIES 5000 MOBILE 
 
ACTION                            TO STORE            DISPLAY 
 
PWR up Unit 
Press FCN 4 to see the selected NAM. Press * to advance. Select NAM1. 
Press FCN, 9, 9, *    "Enter Code" will be displayed. 
Enter   1234567890 
 
XXXXXXXXXX                        PRESS MEM           Enter MIN 
 
_ _ _ _ _                         PRESS MEM           Enter System ID 
 
0334                              PRESS MEM           Enter IPCH 
 
07  (ACCOLC)                      PRESS MEM           Enter OVLD Class 
 
1234                              PRESS MEM           LOCK CODE 
 
123456                            PRESS MEM           SECURITY CODE 
 
1234                              PRESS MEM           ALARM DISARM CODE 
 
0                                 PRESS MEM           PREFFERED SYSTEM 
 
0                                 PRESS MEM           STATION CLASS MARK 
 
1                                 PRESS MEM           HANDS FREE MARK (ON) 
 
1                                 PRESS MEM           LOCAL USE MARK (ON) 
 
1                                 PRESS MEM           MIN MARK (ON) 
 
0                                 PRESS MEM           HORN ALERT (OFF) 
 
0                                 PRESS MEM           OPT. SPEAKER (OFF) 
 
TO SAVE TO NAM NOW                PRESS MEM 
 
TO REVIEW ENTRIES USE THE VOLUME UP OR DOWN KEYS 
 
 
 
 
                      Programming Instructions for: 
 
                           MITSUBISHI  555,560,600 
 
ACTION                            TO STORE            DISPLAY 
 
USED EQUIPMENT: TO DISPLAY CURRENT UNLOCK CODE - 
TO PROGRAM THIS FUNCTION YOU MUST BE OUT OF THE PROGRAMMING MODE 
ENTER FCN 6 AND THEN ENTER THE NEW 3 DIGIT UNLOCK CODE 
PRESS CLR. 
 
To program from keypad remove and discard Nam Pad 
PWR up unit 
Press and Hold STO key within 10 seconds of pwr up 
Enter "5474432" 
Release STO key 
 
XXXXXXXXXX                        Press SEND          MIN 
 
123                               Press SEND          SECURITY CODE 
 
_ _ _ _ _                         Press SEND          SID 
 
1                                 Press SEND          LU 
 
1                                 Press SEND          MIN MARK 
 
334                               Press SEND          IPCH1 
 
07                                Press SEND          ACCOLC1 
 
0                                 Press SEND          PS1 
 
10                                Press SEND          GIM 
 
1                                 Press SEND          EE 
 
1                                 Press SEND          HANDS FREE 
 
0                                 Press SEND          ROAM INHIBIT 
 
0                                 Press SEND          A/B SELECT 
 
00                                Press SEND          f3-f0 DUAL HEAD 
 
00                                Press SEND          f7-f4 LD INH 
 
TO EXIT PROGRAMMING MODE PRESS "END" AT ANY TIME 
 
Installing the LOCK CODE 
 
To program the customer's lock code, the phone must be out ot the 
programming mode. 
To program, enter FCN, 6,3-digit security code, the a 3-digit lock code. 
Press CLR. 
 
 
 
 
                     Programming Instructions for: 
                        NEC M3700 SERIES MOBILE 
 
ACTION                            TO STORE            DISPLAY 
 
USED EQUIPMENT: TO DISPLAY CURRENT UNLOCK CODE - 
UNLOCK CODES WILL BE CHANGED ONLY IN PROGRAMMING MODE 
FOLLOW THE INSTRUCTIONS THAT FOLLOW 
 
A NAM PROGRAMMER ADAPTOR (NECAM #41-2012) IS 
REQUIRED 
 
PWR UP 
 
TO ENTER TEST MODE: 
 
RCL, #,0,1.                                           WILL CYCLE TO SHADED 
 
TO CLEAR MEMORY: 
 
RCL # 3 9 
select nam 
RCL # 7 6 0 #   nam 1 
RCL # 7 6 1 #   nam 2 
 
TO ENTER PROGRAMMING MODE: 
 
RCL #71 
 
 
XXX XXX XXXX                      PRESS #             Telephone No. (MIN) 
 
1234                              PRESS #             Lock Code 
 
_ _ _ _ _                         PRESS #             Home Area (SYS I.D.) 
 
10                                PRESS #             G-NO  (Group I.D.) 
 
0334                              PRESS #             First Paging Channel 
 
0      for wireline               PRESS #             System Select 
 
07                                PRESS #             ACCOLC 
 
1                                 PRESS #             ACCESS 
 
1                                 PRESS #             Local Use 
 
 
To exit PROGRAMMING MODE          PRESS CLR and hold  TEST MODE will show 
 
to exit TEST MODE                 RCL #02 
 
IF MEM WAS CLEARED VIA RCL #39, PHONE WILL AUTOMATICALLY ENTER FULL-LOCK 
AFTER EXITING THE TEST MODE. 
TO UNLOCK PRESS FCN # 1234. 
 
 
 
 
                      Programming Instructions for: 
 
                                 NOKIA LX-11 
 
ACTION                            TO STORE            DISPLAY 
 
USED EQUIPMENT: TO DISPLAY CURRENT UNLOCK CODE - 
PRESS SEL,5  THEN ENTER 5 DIGIT SECURITY CODE 
PRESS SEL TO RECEIVE DISPLAY OF CURRENT UNLOCK CODE 
PRESS 5 NOW TO CLEAR ALL CALL TIMERS 
ENTER THE NEW UNLOCK CODE 
PRESS SEL TO ACCEPT 
 
PWR up unit 
Enter *3001#12345 Then - SEL 9 END 
IdEnt IF InFO should appear on display 
 
Pressing END will move you through the parameters 
Pressing SND will toggle between choices available 
 
_ _ _ _ _                         Press END           HO-Id  (SID) 
 
1                                 Press END           ACCESS 
 
1                                 Press END           LOCL OPt 
 
XXXXXXXXXX                        Press END           Phonxx 
 
08                                Press END           St CLASS 
 
334                               Press END           PAging Ch 
 
07                                Press END           O-LOAd CLASS 
 
B                                 Press END           PrEF SyS 
 
10                                Press END           grOUP Id 
 
12345                             Press END           SECUrIty 
 
-------- (Can't be changed)       Press END           1 dAtE 
 
00/00/90  (INSTALLATION DATE)     Press END           2 dAtE 
 
 
TO EXIT PROGRAMMING MODE AT ANY TIME PRESS "END" TO STORE LAST PARAMETER 
THEN POWER DOWN 
WHEN THE "END" KEY IS PRESSED FOLLOWING THE LAST PARAMETER, THE TEXT 
Prog donE  WILL APPEAR ON DISPLAY 
 
 
 
 
                      Programming Instructions for: 
 
                                NOKIA M-10 
 
ACTION                            TO STORE            DISPLAY 
 
USED EQUIPMENT: TO DISPLAY CURRENT UNLOCK CODE - 
THIS FUNCTION IS PROVIDED BY THE SECURITY CODE PROGRAMMED AT THE 
TIME OF PROGRAMMING 
 
 
 
PWR up unit 
Enter  *17*3001*1234* 
HO-Id must appear on display 
Press SEL to view current value 
Display will be one step behind TO STORE instructions 
 
 
_ _ _ _ _                         Press SEL           ACCESS  (SID) 
 
1                                 Press SEL           LOCAL 
 
1                                 Press SEL           PhonE n 
 
XXXXXXXXXX                        Press SEL           CLASS 
 
08                                Press SEL           PAGE ch 
 
334                               Press SEL           O-LOAd 
 
07                                Press SEL           GrouP 
 
10                                Press SEL           SEC 
 
1234                              Press SEL          AUTO EXIT PROGRAM MODE 
 
TO EXIT PROGRAMMING MODE AT ANY TIME PRESS "END" 
 
WHEN THE SEL KEY IS PRESSED FOLLOWING THE LAST PARAMETER VALUE, THE PHONE 
WILL AUTOMATICALLY EXIT THE NAM PROGRAMMING MODE AND RETURN TO NORMAL 
OPERATION 
 
 
 
 
                        Programming Instructions for: 
 
                        NOVATEL 8305 TRANSPORTABLE 
 
CA08 SOFTWARE VERSION 
 
USED EQUIPMENT: TO DISPLAY CURRENT UNLOCK CODE - 
IF EQUIPMENT IS PROVIDED WITH A MENU KEY THEN ENTER THE MENU PORTION OF 
THE PHONE AND DISPLAY AND IF NECESSARY REPROGRAM THE UNLOCK CODE FROM 
THERE. 
IF PHONE DOES NOT HAVE A MENU KEY THEN THERE CAN BE NO PROGRAMMING OF THE 
UNLOCK CODE... THE SECURITY CODE WILL BE ALL THAT IS PROVIDED 
 
Lock Phone  by pressing FCN 1 
Enter Programming Mode by pressing #259 
 
Screen will display the software revision number 
Press Volume Up 
 
Screen will display Phone's E.S.N. 
Press Volume Up 
 
Screen will display INIT REP USE SND 
Press SEND to erase any numbers stored in the phones memory 
Press Volume Up 
 
_ _ _ _ _                         Send Vol. Up        SIDH      system I.D. 
 
XXX XXX XXXX                      Send Vol. Up        MIN       mobile I.D. 
 
Must be changed when done         Send Vol. Up        LOCK CODE 1 
programming - BY CUSTOMER 
Must be changed when done         Send Vol. Up        LOCK CODE 2 
programming - BY CUSTOMER 
SET                               Vol. Up             Option EX extnd adrss 
334 press send to change          Vol. Up             IPCH      initial pge 
07                                Send Vol. Up        ACCOLC    overload 
10                                Send Vol. Up        GIM       group i.d. 
333                               Vol. Up             IDCCA     initl a 
334                               Vol. Up             IDCCB     initl b 
1                                 Vol. Up             REG TBL SIZE 
Volume up through the four invalid System I.D. addresses 
SET                               Vol. Up             OPTION LU local use 
B   press send to change          Vol. Up             OPTION PS (prefered sys) 
CLR                               Vol. Up             OPTION IRI  rm inhbt 
CLR                               Vol. Up             OPTION SSD 
SET                               Vol. Up             OPTION QRC  qck rcall 
SET                               Vol. Up             OPTION QST  qck store 
SET                               Vol. Up             OPTION WUT  wake tone 
SET                               Vol. Up             OPTION EE   use dtmf 
SET                               Vol. Up             OPTION FD   use dtmf 
SET                               Vol. Up             OPTION MFD  ext dtmf 
SET                               Vol. Up             OPTION 32D  dgt dial 
CLR                               Vol. Up             OPTION MLH  timer 
CLR                               Vol. Up             OPTION LHM  timer 
CLR                               Vol. Up             OPTION CRU  timer dsp 
CLR                               Vol. Up             OPTION NLM  timer 
SET for on CLR for off            Vol. Up             OPTION HA   hrn alert 
CLR                               Vol. Up             OPTION ONL  diagnostc 
END to exit or VOLUME UP to review entries. 
 
 
 
 
                     Programming Instructions for: 
 
                             OKI  CDL400 
 
ACTION                            TO STORE            DISPLAY 
 
To Enter Programming mode: 
 
Press IN SEQUENCE: 
END  RCL  FUNC  CLR  SND 
 
Screen shows Entr id 
 
Enter 08693427 
 
XXX XXX XXXX     PRESS #          PRESS *             PHon 
 
_ _ _ _ _        PRESS #          PRESS *             S id no 
 
0334             PRESS #          PRESS *             iPCH 
 
07               PRESS #          PRESS *             ACC oLC 
 
123              PRESS #          PRESS *             LoC Cod 
 
10               PRESS #          PRESS *             G id 
 
0000             PRESS #          PRESS *             Stn CLS 
 
0111             PRESS #          PRESS *             HORN ALERT, HANDS 
                                                      FREE, LOCAL USE, 
                                                      MIN. MARK. 
 
PRESS END AT THIS TIME TO EXIT PROGRAMMING MODE. 
 
__________________________________________________________________________ 
 
TO REPROGRAM TELEPHON NUMBER AND SYSTEM I.D. # - 
 
PRESS IN SEQUENCE THE FOLLOWING KEYSTROKES: 
 
FUNC  90 *  123 (SECURITY CODE) 
 
PHon WILL DISPLAY 
 
ENTER NEW PHONE NUMBER 
 
XXX XXX XXXX     PRESS #          PRESS *             PHon 
 
_ _ _ _ _        PRESS #          PRESS *             S id no 
 
PRESS END AT THIS TIME TO EXIT PROGRAMMING MODE. 
 
___________________________________________________________________________ 
 
To Re-Initialize Nam Memory for Handset Programmable Models - 
Func 99* 
Enter Last 8 digits of S.N. 
Press * 
 
 
 
 
                   Programming Instructions for: 
 
                         PANASONIC  EB362 
 
 
 
Charged Battery and Nam Adaptor(Grey Cord w/25pin Connector)are needed. 
 
ACTION                        TO STORE            DISPLAY 
 
USED EQUIPMENT: TO DISPLAY CURRENT UNLOCK CODE - 
THIS FUNCTION IS PROVIDED FOR IN THE PROGRAMMING SEQUENCE 
 
 
 
 
*0000# to enter program mode 
 
*1                            Press SND 
 
50                            Press SND           NAM 1 MODE 
 
_ _ _ _ _                     Press STO 01        SIDH 
 
XXXXXXXXXX                    Press STO 02        OWNDL 
 
1 2 3                         Press STO 03        LOCK 
 
0 0 0 0 0 0 0 0 0 0 0 0 (12)  Press STO 04        SPDL 
 
00                            Press STO 05        SCM 
 
334                           Press STO 06        IPCH 
 
07                            Press STO 07        ACCOLC 
 
10                            Press STO 08        GIM 
 
1 1 0 1 1 1 0 0               Press STO 09        FEATURE A 
 
0 0 0 0 0 1 0 0               Press STO 10        FEATURE B 
 
1 0 0 0 0 0 1 1               Press STO 11        FEATURE C 
 
00                            Press STO 12        DLMT 
 
STO ** 
Turn power off 
 
 
 
 
                      Programming Instructions for: 
 
                        PANASONIC EB-500 OR TP-500 
 
ACTION                            TO STORE            DISPLAY 
 
USED EQUIPMENT: TO DISPLAY CURRENT UNLOCK CODE - 
THIS FUNCTION IS PROVIDED FOR IN THE PROGRAMMING SEQUENCE 
 
Attach Nam Programmer Cable (Our Stock # 823) 
 
Pwr up unit 
 
Enter *0000#                                          0 
 
*1  SND 
You are now in the NAM 1 Program mode. 
 
_ _ _ _ _                         Press STO 01        S.I.D. 
 
XXXXXXXXXX                        Press STO 02        OWN # 
 
0                                 Press STO 03        O for W/L system 
 
334                               Press STO 04        IPCH 
 
07                                Press STO 05        ACCOLC 
 
10                                Press STO 06        GIM 
 
00                                Press STO 07        Digit Dial Limit 
 
08                                Press STO 08        SCM (3watt i.d.) 
 
911                               Press STO 09        Rcl 00 
 
1234                              Press STO 10        Security Code 
 
11000000                          Press STO 11        FUNCTION BYTE 1 
 
00010010                          Press STO 12        FUNCTION BYTE 2 
 
10010111                          Press STO 13        FUNCTION BYTE 3 
 
TO BURN NAM AT THIS TIME          Press STO **        NAM is burned 
 
Turn off unit 
Detach programming cable 
 
 
 
 
                       Programming Instructions for: 
 
                     RADIO SHACK 17-1002 TRANSPORTABLE 
 
THIS UNIT REQUIRES A SERVICE HANDSET TO BE PROGRAMMED!!! 
 
A Mobira Service Handset (Modified) may be used.  It is made from an ME53 
or ME57 handset by opening and adding a jumper to the left of the one 
factory installed just below the white 24 pin connector joining the top and 
bottom PCB's. Also, pins 1 and 14 of the handset connector must be jumpered 
at the radio end.  To disassemble the handset, carefully pry off the 
plastic earpad retaining housing to expose on hexdrive screw.  Two other 
screws are under the rubber plugs at either side of the microphone.  The 
handset then splits apart.  This is a ticklish job and isn't recommended 
except in an extreme case and not with the customer's handset.  The  
modification does not affect normal operation of the handset.  It is not  
known if a Radio handset will work the same. 
 
After the Service Handset has been applied: 
 
        To enter LOCAL MODE (which takes the phone off the air and allows 
service commands to be obeyed) press 01#.  The display should clear and noise 
is heard from the earpiece. 
 
        To enter the NAM programming mode, enter 48#.  The display shows 48 
briefly and clears. 
 
ACTION              KEYBOARD ENTRY            DISPLAY 
 
0                         *                 (5-digit SID) 
1                         * 
1                         * 
XXXXXXXXXX                * 
10                        * 
334                       * 
07                        * 
0                         * 
10                        * 
12345                     * 
 
        Press * to exit NAM programming mode and return to Local Mode. 
To enter the NAM reading mode, press 49#.  The display will show  49. 
 
 
***************************************************************************** 
 
PART VII.         THE ELECTRONIC SERIAL NUMBER - AN INTRODUCTION 
 
        When a cellular phone is removed from factory packaging, the ESN 
normally can be found in the document package (or on a sticker stuck to the 
phone).  This ESN is usually correct and system registration procedes 
quickly.  If the phone is used or has been turned off for non-payment of 
bills, the person who restores the service needs the ESN in order to program 
the system with an MIN.  Every manufacturer assigns their own ESN,  
consequently it is possible to have a number of the same ESN's, although 
each may be produced by a seperate manufacturer.  For example, there may be 
a Motorola ESN of 123456, an Audiovox ESN of 123456, etc.  With this in mind 
it is a possibility that a person could broadcast without changing the ESN, 
but rather changing the SCM and the SIDH. 
 
        The ESN is a 32-bit number which uniquely identifies each unit.  This 
ESN is factory programmed and installed and cannot be changed in the field 
without removing it and reprogramming a new chip.  The ESN may or may not be 
related to the serial number stamped on the outside of the transceiver  
chassis.  The ESN is encoded into messages which are interchanged with the 
cellular tower.  The ESN must be provided when the phone is registered for 
service.  The ESN is an 11-digit number.  THE FIRST THREE NUMBERS ARE THE 
MANUFACTURERS DECIMAL CODE, THE NEXT TWO ARE RESERVED (BUT MAY CONTAIN ZEROS 
OR NUMBERS) AND THE REMAINING SIX ARE THE DECIMAL SERIAL NUMBER. 
 
***************************************************************************** 
 
PART VIII.         IDENTIFYING THE ESN IN YOUR CELLULAR PHONE 
 
        Depending on what model phone you have, the ESN will be located on a 
PROM.   The PROM is programmed at the factory, and installed usually with the 
security fuse blown to prevent tampering.  The code on the PROM might  
possibly be obtained by unsoldering it from the cellular phone, putting it in 
a PROM reader, and then obtaining a memory map of the chip. 
 
        The PROM is going to have from sixteen to twenty-eight leads coming 
from it.  It is a bipolar PROM.  SEE ESN.GIF FOR ADDITIONAL INFORMATION. 
The majority of phones will accept the National Semiconductor 32x8 PROM, 
which will hold the ESN and cannot be reprogrammed.  If the ESN is known 
on the phone,  it is possible to trace the memory map by installing the PROM 
into a reader, and obtaining the fuse map from the PROM by triggering the 
"READ MASTER" switch of the PROM programmer.  In addition, most PROM  
programming systems include a verify and compare switch to allow you to  
compare the programming of one PROM with another. 
 
        As said earlier, the ESN is uniformly black with sixteen to  
twenty-eight leads emanating from it's rectangular body, or square shaped 
body.  If it is the dual-in-line package chip, (usually found in  
transportables and installed phones),it is rectangular.  If it is the plastic 
leaded chip carrier (PLCC), it will be square and have a much smaller 
appearance.  Functionally, they are the same chip, but the PLCC is used with 
hand held cellular phones because of the need for reduced size circuitry.  
It will have a notch within, and also have writing in small white letters 
on it. (A black chip with small white letters? Should be easy to spot huh?). 
Look for the follow letters on the chip: 
 
                                MMI 
                                TI 
                                NS 
                                HARRIS 
                                NSC 
                                MB 
                                DM 
                                HM 
                                AMD 
                                TBP 
                                MOTOROLA 
                                AMPS 
 
 
Once you have found the chip, try ordering a new one (maybe a couple of new 
ones) from the businesses in the MERCHANDISE SECTION located at the end of 
this file. 
 
***************************************************************************** 
 
PART IX.              SCANNING TO FIND THE ESN/MIN PAIR 
 
        Well if you haven't guessed by now, the mobiles ESN and MIN must 
match in the switch or no go.  This is required for billing purposes.  If one 
had the ESN and the mobile phone number (MIN), he could call anytime and 
anyplace without fear of a trace - let alone a bill.  The ideal setup would 
let you listen with a scanner to the reverse control channel, record and 
display heard working numbers and ESN's, and recall them as one needs to make 
calls. 
 
        This would be it, but we are not quite there yet.  But some of the 
hard work has already been done for us.  All the aforementioned codes are  
sent in hex, in NRZ code (phase-key shifting), when a cellular subscriber 
places a call.  But guess what?  All phones have an NRZ receiver and 
transmitter built right into them.  All that has to be done is to have a 
receiver on the reverse control channel, recover the other subscibers data 
and save it or print it out. 
 
        Cellular phones operate on a full duplex channel.  One frequency is 
used for transmission from the base to the phone, while another is used for 
transmission from the phone to the base.  The base frequencies are always 
exactly 45 MHZ higher than the phone frequency, and both of these are 
incremented by 30 KHZ as the progression of channels increases from  Channel 
#1 to Chanel #1023 (NOTE: There are no channels between 800 and 990). 
 
        With some systems (not all) the cellular transmission is received by 
the base and retransmitted on the base frequency.  When this is done, a  
scanner can listen to both sides of the conversation by simply monitoring the 
base frequency.  When this is not the case, two scanners set 45 MHZ apart 
will work. 
 
        Here is a list of all Cellular Frequencies: 
 
Non-Wireline                              Wireline         
 
 
Channel    Tx Freq    Rx Freq             Channel   Tx Freq    Rx Freq     
Number       Mhz        Mhz               Number      Mhz        Mhz         
 
      1     870.03     825.03               334     880.02     835.02   
      2     870.06     825.06               335     880.05     835.05   
      3     870.09     825.09               336     880.08     835.08   
      4     870.12     825.12               337     880.11     835.11   
      5     870.15     825.15               338     880.14     835.14   
      6     870.18     825.18               339     880.17     835.17   
      7     870.21     825.21               340     880.20     835.20   
      8     870.24     825.24               341     880.23     835.23   
      9     870.27     825.27               342     880.26     835.26   
     10     870.30     825.30               343     880.29     835.29   
     11     870.33     825.33               344     880.32     835.32   
     12     870.36     825.36               345     880.35     835.35   
     13     870.39     825.39               346     880.38     835.38   
     14     870.42     825.42               347     880.41     835.41   
     15     870.45     825.45               348     880.44     835.44   
     16     870.48     825.48               349     880.47     835.47   
     17     870.51     825.51               350     880.50     835.50   
     18     870.54     825.54               351     880.53     835.53   
     19     870.57     825.57               352     880.56     835.56   
     20     870.60     825.60               353     880.59     835.59   
     21     870.63     825.63               354     880.62     835.62   
     22     870.66     825.66               355     880.65     835.65   
     23     870.69     825.69               356     880.68     835.68   
     24     870.72     825.72               357     880.71     835.71   
     25     870.75     825.75               358     880.74     835.74   
     26     870.78     825.78               359     880.77     835.77   
     27     870.81     825.81               360     880.80     835.80   
     28     870.84     825.84               361     880.83     835.83   
     29     870.87     825.87               362     880.86     835.86   
     30     870.90     825.90               363     880.89     835.89   
     31     870.93     825.93               364     880.92     835.92   
     32     870.96     825.96               365     880.95     835.95   
     33     870.99     825.99               366     880.98     835.98   
     34     871.02     826.02               367     881.01     836.01   
     35     871.05     826.05               368     881.04     836.04   
     36     871.08     826.08               369     881.07     836.07   
     37     871.11     826.11               370     881.10     836.10   
     38     871.14     826.14               371     881.13     836.13   
     39     871.17     826.17               372     881.16     836.16   
     40     871.20     826.20               373     881.19     836.19   
     41     871.23     826.23               374     881.22     836.22   
     42     871.26     826.26               375     881.25     836.25   
     43     871.29     826.29               376     881.28     836.28   
     44     871.32     826.32               377     881.31     836.31   
     45     871.35     826.35               378     881.34     836.34   
     46     871.38     826.38               379     881.37     836.37   
     47     871.41     826.41               380     881.40     836.40   
     48     871.44     826.44               381     881.43     836.43   
     49     871.47     826.47               382     881.46     836.46   
     50     871.50     826.50               383     881.49     836.49   
     51     871.53     826.53               384     881.52     836.52   
     52     871.56     826.56               385     881.55     836.55   
     53     871.59     826.59               386     881.58     836.58   
     54     871.62     826.62               387     881.61     836.61   
     55     871.65     826.65               388     881.64     836.64   
     56     871.68     826.68               389     881.67     836.67   
     57     871.71     826.71               390     881.70     836.70   
     58     871.74     826.74               391     881.73     836.73   
     59     871.77     826.77               392     881.76     836.76   
     60     871.80     826.80               393     881.79     836.79   
     61     871.83     826.83               394     881.82     836.82   
     62     871.86     826.86               395     881.85     836.85   
     63     871.89     826.89               396     881.88     836.88   
     64     871.92     826.92               397     881.91     836.91   
     65     871.95     826.95               398     881.94     836.94   
     66     871.98     826.98               399     881.97     836.97   
     67     872.01     827.01               400     882.00     837.00   
     68     872.04     827.04               401     882.03     837.03   
     69     872.07     827.07               402     882.06     837.06   
     70     872.10     827.10               403     882.09     837.09   
     71     872.13     827.13               404     882.12     837.12   
     72     872.16     827.16               405     882.15     837.15   
     73     872.19     827.19               406     882.18     837.18   
     74     872.22     827.22               407     882.21     837.21   
     75     872.25     827.25               408     882.24     837.24   
     76     872.28     827.28               409     882.27     837.27   
     77     872.31     827.31               410     882.30     837.30   
     78     872.34     827.34               411     882.33     837.33   
     79     872.37     827.37               412     882.36     837.36   
     80     872.40     827.40               413     882.39     837.39   
     81     872.43     827.43               414     882.42     837.42   
     82     872.46     827.46               415     882.45     837.45   
     83     872.49     827.49               416     882.48     837.48   
     84     872.52     827.52               417     882.51     837.51   
     85     872.55     827.55               418     882.54     837.54   
     86     872.58     827.58               419     882.57     837.57   
     87     872.61     827.61               420     882.60     837.60   
     88     872.64     827.64               421     882.63     837.63   
     89     872.67     827.67               422     882.66     837.66   
     90     872.70     827.70               423     882.69     837.69   
     91     872.73     827.73               424     882.72     837.72   
     92     872.76     827.76               425     882.75     837.75   
     93     872.79     827.79               426     882.78     837.78   
     94     872.82     827.82               427     882.81     837.81   
     95     872.85     827.85               428     882.84     837.84   
     96     872.88     827.88               429     882.87     837.87   
     97     872.91     827.91               430     882.90     837.90   
     98     872.94     827.94               431     882.93     837.93   
     99     872.97     827.97               432     882.96     837.96   
    100     873.00     828.00               433     882.99     837.99   
    101     873.03     828.03               434     883.02     838.02   
    102     873.06     828.06               435     883.05     838.05   
    103     873.09     828.09               436     883.08     838.08   
    104     873.12     828.12               437     883.11     838.11   
    105     873.15     828.15               438     883.14     838.14   
    106     873.18     828.18               439     883.17     838.17   
    107     873.21     828.21               440     883.20     838.20   
    108     873.24     828.24               441     883.23     838.23   
    109     873.27     828.27               442     883.26     838.26   
    110     873.30     828.30               443     883.29     838.29   
    111     873.33     828.33               444     883.32     838.32   
    112     873.36     828.36               445     883.35     838.35   
    113     873.39     828.39               446     883.38     838.38   
    114     873.42     828.42               447     883.41     838.41   
    115     873.45     828.45               448     883.44     838.44   
    116     873.48     828.48               449     883.47     838.47   
    117     873.51     828.51               450     883.50     838.50   
    118     873.54     828.54               451     883.53     838.53   
    119     873.57     828.57               452     883.56     838.56   
    120     873.60     828.60               453     883.59     838.59   
    121     873.63     828.63               454     883.62     838.62   
    122     873.66     828.66               455     883.65     838.65   
    123     873.69     828.69               456     883.68     838.68   
    124     873.72     828.72               457     883.71     838.71   
    125     873.75     828.75               458     883.74     838.74   
    126     873.78     828.78               459     883.77     838.77   
    127     873.81     828.81               460     883.80     838.80   
    128     873.84     828.84               461     883.83     838.83   
    129     873.87     828.87               462     883.86     838.86   
    130     873.90     828.90               463     883.89     838.89   
    131     873.93     828.93               464     883.92     838.92   
    132     873.96     828.96               465     883.95     838.95   
    133     873.99     828.99               466     883.98     838.98   
    134     874.02     829.02               467     884.01     839.01   
    135     874.05     829.05               468     884.04     839.04   
    136     874.08     829.08               469     884.07     839.07   
    137     874.11     829.11               470     884.10     839.10   
    138     874.14     829.14               471     884.13     839.13   
    139     874.17     829.17               472     884.16     839.16   
    140     874.20     829.20               473     884.19     839.19   
    141     874.23     829.23               474     884.22     839.22   
    142     874.26     829.26               475     884.25     839.25   
    143     874.29     829.29               476     884.28     839.28   
    144     874.32     829.32               477     884.31     839.31   
    145     874.35     829.35               478     884.34     839.34   
    146     874.38     829.38               479     884.37     839.37   
    147     874.41     829.41               480     884.40     839.40   
    148     874.44     829.44               481     884.43     839.43   
    149     874.47     829.47               482     884.46     839.46   
    150     874.50     829.50               483     884.49     839.49   
    151     874.53     829.53               484     884.52     839.52   
    152     874.56     829.56               485     884.55     839.55   
    153     874.59     829.59               486     884.58     839.58   
    154     874.62     829.62               487     884.61     839.61   
    155     874.65     829.65               488     884.64     839.64   
    156     874.68     829.68               489     884.67     839.67   
    157     874.71     829.71               490     884.70     839.70   
    158     874.74     829.74               491     884.73     839.73   
    159     874.77     829.77               492     884.76     839.76   
    160     874.80     829.80               493     884.79     839.79   
    161     874.83     829.83               494     884.82     839.82   
    162     874.86     829.86               495     884.85     839.85   
    163     874.89     829.89               496     884.88     839.88   
    164     874.92     829.92               497     884.91     839.91   
    165     874.95     829.95               498     884.94     839.94   
    166     874.98     829.98               499     884.97     839.97   
    167     875.01     830.01               500     885.00     840.00   
    168     875.04     830.04               501     885.03     840.03   
    169     875.07     830.07               502     885.06     840.06   
    170     875.10     830.10               503     885.09     840.09   
    171     875.13     830.13               504     885.12     840.12   
    172     875.16     830.16               505     885.15     840.15   
    173     875.19     830.19               506     885.18     840.18   
    174     875.22     830.22               507     885.21     840.21   
    175     875.25     830.25               508     885.24     840.24   
    176     875.28     830.28               509     885.27     840.27   
    177     875.31     830.31               510     885.30     840.30   
    178     875.34     830.34               511     885.33     840.33   
    179     875.37     830.37               512     885.36     840.36   
    180     875.40     830.40               513     885.39     840.39   
    181     875.43     830.43               514     885.42     840.42   
    182     875.46     830.46               515     885.45     840.45   
    183     875.49     830.49               516     885.48     840.48   
    184     875.52     830.52               517     885.51     840.51   
    185     875.55     830.55               518     885.54     840.54   
    186     875.58     830.58               519     885.57     840.57   
    187     875.61     830.61               520     885.60     840.60   
    188     875.64     830.64               521     885.63     840.63   
    189     875.67     830.67               522     885.66     840.66   
    190     875.70     830.70               523     885.69     840.69   
    191     875.73     830.73               524     885.72     840.72   
    192     875.76     830.76               525     885.75     840.75   
    193     875.79     830.79               526     885.78     840.78   
    194     875.82     830.82               527     885.81     840.81   
    195     875.85     830.85               528     885.84     840.84   
    196     875.88     830.88               529     885.87     840.87   
    197     875.91     830.91               530     885.90     840.90   
    198     875.94     830.94               531     885.93     840.93   
    199     875.97     830.97               532     885.96     840.96   
    200     876.00     831.00               533     885.99     840.99   
    201     876.03     831.03               534     886.02     841.02   
    202     876.06     831.06               535     886.05     841.05   
    203     876.09     831.09               536     886.08     841.08   
    204     876.12     831.12               537     886.11     841.11   
    205     876.15     831.15               538     886.14     841.14   
    206     876.18     831.18               539     886.17     841.17   
    207     876.21     831.21               540     886.20     841.20   
    208     876.24     831.24               541     886.23     841.23   
    209     876.27     831.27               542     886.26     841.26   
    210     876.30     831.30               543     886.29     841.29   
    211     876.33     831.33               544     886.32     841.32   
    212     876.36     831.36               545     886.35     841.35   
    213     876.39     831.39               546     886.38     841.38   
    214     876.42     831.42               547     886.41     841.41   
    215     876.45     831.45               548     886.44     841.44   
    216     876.48     831.48               549     886.47     841.47   
    217     876.51     831.51               550     886.50     841.50   
    218     876.54     831.54               551     886.53     841.53   
    219     876.57     831.57               552     886.56     841.56   
    220     876.60     831.60               553     886.59     841.59   
    221     876.63     831.63               554     886.62     841.62   
    222     876.66     831.66               555     886.65     841.65   
    223     876.69     831.69               556     886.68     841.68   
    224     876.72     831.72               557     886.71     841.71   
    225     876.75     831.75               558     886.74     841.74   
    226     876.78     831.78               559     886.77     841.77   
    227     876.81     831.81               560     886.80     841.80   
    228     876.84     831.84               561     886.83     841.83   
    229     876.87     831.87               562     886.86     841.86   
    230     876.90     831.90               563     886.89     841.89   
    231     876.93     831.93               564     886.92     841.92   
    232     876.96     831.96               565     886.95     841.95   
    233     876.99     831.99               566     886.98     841.98   
    234     877.02     832.02               567     887.01     842.01   
    235     877.05     832.05               568     887.04     842.04   
    236     877.08     832.08               569     887.07     842.07   
    237     877.11     832.11               570     887.10     842.10   
    238     877.14     832.14               571     887.13     842.13   
    239     877.17     832.17               572     887.16     842.16   
    240     877.20     832.20               573     887.19     842.19   
    241     877.23     832.23               574     887.22     842.22   
    242     877.26     832.26               575     887.25     842.25   
    243     877.29     832.29               576     887.28     842.28   
    244     877.32     832.32               577     887.31     842.31   
    245     877.35     832.35               578     887.34     842.34   
    246     877.38     832.38               579     887.37     842.37   
    247     877.41     832.41               580     887.40     842.40   
    248     877.44     832.44               581     887.43     842.43   
    249     877.47     832.47               582     887.46     842.46   
    250     877.50     832.50               583     887.49     842.49   
    251     877.53     832.53               584     887.52     842.52   
    252     877.56     832.56               585     887.55     842.55   
    253     877.59     832.59               586     887.58     842.58   
    254     877.62     832.62               587     887.61     842.61   
    255     877.65     832.65               588     887.64     842.64   
    256     877.68     832.68               589     887.67     842.67   
    257     877.71     832.71               590     887.70     842.70   
    258     877.74     832.74               591     887.73     842.73   
    259     877.77     832.77               592     887.76     842.76   
    260     877.80     832.80               593     887.79     842.79   
    261     877.83     832.83               594     887.82     842.82   
    262     877.86     832.86               595     887.85     842.85   
    263     877.89     832.89               596     887.88     842.88   
    264     877.92     832.92               597     887.91     842.91   
    265     877.95     832.95               598     887.94     842.94   
    266     877.98     832.98               599     887.97     842.97   
    267     878.01     833.01               600     888.00     843.00   
    268     878.04     833.04               601     888.03     843.03   
    269     878.07     833.07               602     888.06     843.06   
    270     878.10     833.10               603     888.09     843.09   
    271     878.13     833.13               604     888.12     843.12   
    272     878.16     833.16               605     888.15     843.15   
    273     878.19     833.19               606     888.18     843.18   
    274     878.22     833.22               607     888.21     843.21   
    275     878.25     833.25               608     888.24     843.24   
    276     878.28     833.28               609     888.27     843.27   
    277     878.31     833.31               610     888.30     843.30   
    278     878.34     833.34               611     888.33     843.33   
    279     878.37     833.37               612     888.36     843.36   
    280     878.40     833.40               613     888.39     843.39   
    281     878.43     833.43               614     888.42     843.42   
    282     878.46     833.46               615     888.45     843.45   
    283     878.49     833.49               616     888.48     843.48   
    284     878.52     833.52               617     888.51     843.51   
    285     878.55     833.55               618     888.54     843.54   
    286     878.58     833.58               619     888.57     843.57   
    287     878.61     833.61               620     888.60     843.60   
    288     878.64     833.64               621     888.63     843.63   
    289     878.67     833.67               622     888.66     843.66   
    290     878.70     833.70               623     888.69     843.69   
    291     878.73     833.73               624     888.72     843.72   
    292     878.76     833.76               625     888.75     843.75   
    293     878.79     833.79               626     888.78     843.78   
    294     878.82     833.82               627     888.81     843.81   
    295     878.85     833.85               628     888.84     843.84   
    296     878.88     833.88               629     888.87     843.87   
    297     878.91     833.91               630     888.90     843.90   
    298     878.94     833.94               631     888.93     843.93   
    299     878.97     833.97               632     888.96     843.96   
    300     879.00     834.00               633     888.99     843.99   
    301     879.03     834.03               634     889.02     844.02   
    302     879.06     834.06               635     889.05     844.05   
    303     879.09     834.09               636     889.08     844.08   
    304     879.12     834.12               637     889.11     844.11   
    305     879.15     834.15               638     889.14     844.14   
    306     879.18     834.18               639     889.17     844.17   
    307     879.21     834.21               640     889.20     844.20   
    308     879.24     834.24               641     889.23     844.23   
    309     879.27     834.27               642     889.26     844.26   
    310     879.30     834.30               643     889.29     844.29   
    311     879.33     834.33               644     889.32     844.32   
    312     879.36     834.36               645     889.35     844.35   
    313     879.39     834.39               646     889.38     844.38   
    314     879.42     834.42               647     889.41     844.41   
    315     879.45     834.45               648     889.44     844.44   
    316     879.48     834.48               649     889.47     844.47   
    317     879.51     834.51               650     889.50     844.50   
    318     879.54     834.54               651     889.53     844.53   
    319     879.57     834.57               652     889.56     844.56   
    320     879.60     834.60               653     889.59     844.59   
    321     879.63     834.63               654     889.62     844.62   
    322     879.66     834.66               655     889.65     844.65   
    323     879.69     834.69               656     889.68     844.68   
    324     879.72     834.72               657     889.71     844.71   
    325     879.75     834.75               658     889.74     844.74   
    326     879.78     834.78               659     889.77     844.77   
    327     879.81     834.81               660     889.80     844.80   
    328     879.84     834.84               661     889.83     844.83   
    329     879.87     834.87               662     889.86     844.86   
    330     879.90     834.90               663     889.89     844.89   
    331     879.93     834.93               664     889.92     844.92   
    332     879.96     834.96               665     889.95     844.95   
    333     879.99     834.99               666     889.98     844.98   
    667     890.01     845.01               717     891.51     846.51   
    668     890.04     845.04               718     891.54     846.54   
    669     890.07     845.07               719     891.57     846.57   
    670     890.10     845.10               720     891.60     846.60   
    671     890.13     845.13               721     891.63     846.63   
    672     890.16     845.16               722     891.66     846.66   
    673     890.19     845.19               723     891.69     846.69   
    674     890.22     845.22               724     891.72     846.72   
    675     890.25     845.25               725     891.75     846.75   
    676     890.28     845.28               726     891.78     846.78   
    677     890.31     845.31               727     891.81     846.81   
    678     890.34     845.34               728     891.84     846.84   
    679     890.37     845.37               729     891.87     846.87   
    680     890.40     845.40               730     891.90     846.90   
    681     890.43     845.43               731     891.93     846.93   
    682     890.46     845.46               732     891.96     846.96   
    683     890.49     845.49               733     891.99     846.99   
    684     890.52     845.52               734     892.02     847.02   
    685     890.55     845.55               735     892.05     847.05   
    686     890.58     845.58               736     892.08     847.08   
    687     890.61     845.61               737     892.11     847.11   
    688     890.64     845.64               738     892.14     847.14   
    689     890.67     845.67               739     892.17     847.17   
    690     890.70     845.70               740     892.20     847.20   
    691     890.73     845.73               741     892.23     847.23   
    692     890.76     845.76               742     892.26     847.26   
    693     890.79     845.79               743     892.29     847.29   
    694     890.82     845.82               744     892.32     847.32   
    695     890.85     845.85               745     892.35     847.35   
    696     890.88     845.88               746     892.38     847.38   
    697     890.91     845.91               747     892.41     847.41   
    698     890.94     845.94               748     892.44     847.44   
    699     890.97     845.97               749     892.47     847.47   
    700     891.00     846.00               750     892.50     847.50   
    701     891.03     846.03               751     892.53     847.53   
    702     891.06     846.06               752     892.56     847.56   
    703     891.09     846.09               753     892.59     847.59   
    704     891.12     846.12               754     892.62     847.62   
    705     891.15     846.15               755     892.65     847.65   
    706     891.18     846.18               756     892.68     847.68   
    707     891.21     846.21               757     892.71     847.71   
    708     891.24     846.24               758     892.74     847.74   
    709     891.27     846.27               759     892.77     847.77   
    710     891.30     846.30               760     892.80     847.80   
    711     891.33     846.33               761     892.83     847.83   
    712     891.36     846.36               762     892.86     847.86   
    713     891.39     846.39               763     892.89     847.89   
    714     891.42     846.42               764     892.92     847.92   
    715     891.45     846.45               765     892.95     847.95   
    716     891.48     846.48               766     892.98     847.98   
    991     869.04     824.04               767     893.01     848.01   
    992     869.07     824.07               768     893.04     848.04   
    993     869.10     824.10               769     893.07     848.07   
    994     869.13     824.13               770     893.10     848.10   
    995     869.16     824.16               771     893.13     848.13   
    996     869.19     824.19               772     893.16     848.16   
    997     869.22     824.22               773     893.19     848.19   
    998     869.25     824.25               774     893.22     848.22   
    999     869.28     824.28               775     893.25     848.25   
   1000     869.31     824.31               776     893.28     848.28   
   1001     869.34     824.34               777     893.31     848.31   
   1002     869.37     824.37               778     893.34     848.34   
   1003     869.40     824.40               779     893.37     848.37   
   1004     869.43     824.43               780     893.40     848.40   
   1005     869.46     824.46               781     893.43     848.43   
   1006     869.49     824.49               782     893.46     848.46   
   1007     869.52     824.52               783     893.49     848.49   
   1008     869.55     824.55               784     893.52     848.52   
   1009     869.58     824.58               785     893.55     848.55   
   1010     869.61     824.61               786     893.58     848.58   
   1011     869.64     824.64               787     893.61     848.61   
   1012     869.67     824.67               788     893.64     848.64   
   1013     869.70     824.70               789     893.67     848.67   
   1014     869.73     824.73               790     893.70     848.70   
   1015     869.76     824.76               791     893.73     848.73   
   1016     869.79     824.79               792     893.76     848.76   
   1017     869.82     824.82               793     893.79     848.79   
   1018     869.85     824.85               794     893.82     848.82   
   1019     869.88     824.88               795     893.85     848.85   
   1020     869.91     824.91               796     893.88     848.88   
   1021     869.94     824.94               797     893.91     848.91   
   1022     869.97     824.97               798     893.94     848.94   
   1023     870.00     825.00               799     893.97     848.97  Here is a method of determining which frequencies are used in a cellular 
system, and which ones are in what cells.  If the system uses OMNICELLS, as 
most do, you can readily find all the channels in a cell if you know just one 
of them, using tables constructed with the instructions below. 
 
    Cellular frequencies are assigned by channel number, and for all channel 
numbers, in both wireline and non-wireline systems, the formula is: 
 
   Transmit Frequency = (channel number x .030 MHz) + 870 MHz 
    Receive Frequency = (channel number x .030 Mhz) + 825 Mhz 
  
    "Band A" (one of the two blocks) uses channels 1 - 333.  To construct a 
table showing frequency by cells, use channel 333 as the top left corner of a 
table.  The next entry to the right of channel 333 is 332, the next is 331, 
etc., down to channel 313.  Enter channel 312 underneath 333, 311 under 332, 
etc.  Each channel across the top row is the first channel in each CELL of the 
system; each channel DOWN from the column from the the first channel is the 
next frequency assigned to that cell.  You may have noted that each channel 
down is 21 channels lower in number.  Usually the data channel used is the 
highest numbered channel in a cell. 
 
    "Band B" uses channels from 334 to 666.  Construct your table in a similar 
way, with channel 334 in the upper left corner, 335 the next entry to the 
right.  The data channel should be the lowest numbered channel in each cell 
this time. 
 
Cellular Phone Band A (Channel 1 is Data) 
 
Cell # 1 
-------------------------------------------------- 
Channel 1       (333)   Tx 879.990      Rx 834.990 
Channel 2       (312)   Tx 879.360      Rx 834.360 
Channel 3       (291)   Tx 878.730      Rx 833.730 
Channel 4       (270)   Tx 878.100      Rx 833.100 
Channel 5       (249)   Tx 877.470      Rx 832.470 
Channel 6       (228)   Tx 876.840      Rx 831.840 
Channel 7       (207)   Tx 876.210      Rx 831.210 
Channel 8       (186)   Tx 875.580      Rx 830.580 
Channel 9       (165)   Tx 874.950      Rx 829.950 
Channel 10      (144)   Tx 874.320      Rx 829.320 
Channel 11      (123)   Tx 873.690      Rx 828.690 
Channel 12      (102)   Tx 873.060      Rx 828.060 
Channel 13      (81)    Tx 872.430      Rx 827.430 
Channel 14      (60)    Tx 871.800      Rx 826.800 
Channel 15      (39)    Tx 871.170      Rx 826.170 
Channel 16      (18)    Tx 870.540      Rx 825.540 
 
Cell # 2 
-------------------------------------------------- 
Channel 1       (332)   Tx 879.960      Rx 834.960 
Channel 2       (311)   Tx 879.330      Rx 834.330 
Channel 3       (290)   Tx 878.700      Rx 833.700 
Channel 4       (269)   Tx 878.070      Rx 833.070 
Channel 5       (248)   Tx 877.440      Rx 832.440 
Channel 6       (227)   Tx 876.810      Rx 831.810 
Channel 7       (206)   Tx 876.180      Rx 831.180 
Channel 8       (185)   Tx 875.550      Rx 830.550 
Channel 9       (164)   Tx 874.920      Rx 829.920 
Channel 10      (143)   Tx 874.290      Rx 829.290 
Channel 11      (122)   Tx 873.660      Rx 828.660 
Channel 12      (101)   Tx 873.030      Rx 828.030 
Channel 13      (80)    Tx 872.400      Rx 827.400 
Channel 14      (59)    Tx 871.770      Rx 826.770 
Channel 15      (38)    Tx 871.140      Rx 826.140 
Channel 16      (17)    Tx 870.510      Rx 825.510 
 
Cell # 3 
-------------------------------------------------- 
Channel 1       (331)   Tx 879.930      Rx 834.930 
Channel 2       (310)   Tx 879.300      Rx 834.300 
Channel 3       (289)   Tx 878.670      Rx 833.670 
Channel 4       (268)   Tx 878.040      Rx 833.040 
Channel 5       (247)   Tx 877.410      Rx 832.410 
Channel 6       (226)   Tx 876.780      Rx 831.780 
Channel 7       (205)   Tx 876.150      Rx 831.150 
Channel 8       (184)   Tx 875.520      Rx 830.520 
Channel 9       (163)   Tx 874.890      Rx 829.890 
Channel 10      (142)   Tx 874.260      Rx 829.260 
Channel 11      (121)   Tx 873.630      Rx 828.630 
Channel 12      (100)   Tx 873.000      Rx 828.000 
Channel 13      (79)    Tx 872.370      Rx 827.370 
Channel 14      (58)    Tx 871.740      Rx 826.740 
Channel 15      (37)    Tx 871.110      Rx 826.110 
Channel 16      (16)    Tx 870.480      Rx 825.480 
 
Cell # 4 
-------------------------------------------------- 
Channel 1       (330)   Tx 879.900      Rx 834.900 
Channel 2       (309)   Tx 879.270      Rx 834.270 
Channel 3       (288)   Tx 878.640      Rx 833.640 
Channel 4       (267)   Tx 878.010      Rx 833.010 
Channel 5       (246)   Tx 877.380      Rx 832.380 
Channel 6       (225)   Tx 876.750      Rx 831.750 
Channel 7       (204)   Tx 876.120      Rx 831.120 
Channel 8       (183)   Tx 875.490      Rx 830.490 
Channel 9       (162)   Tx 874.860      Rx 829.860 
Channel 10      (141)   Tx 874.230      Rx 829.230 
Channel 11      (120)   Tx 873.600      Rx 828.600 
Channel 12      (99)    Tx 872.970      Rx 827.970 
Channel 13      (78)    Tx 872.340      Rx 827.340 
Channel 14      (57)    Tx 871.710      Rx 826.710 
Channel 15      (36)    Tx 871.080      Rx 826.080 
Channel 16      (15)    Tx 870.450      Rx 825.450 
 
Cell # 5 
-------------------------------------------------- 
Channel 1       (329)   Tx 879.870      Rx 834.870 
Channel 2       (308)   Tx 879.240      Rx 834.240 
Channel 3       (287)   Tx 878.610      Rx 833.610 
Channel 4       (266)   Tx 877.980      Rx 832.980 
Channel 5       (245)   Tx 877.350      Rx 832.350 
Channel 6       (224)   Tx 876.720      Rx 831.720 
Channel 7       (203)   Tx 876.090      Rx 831.090 
Channel 8       (182)   Tx 875.460      Rx 830.460 
Channel 9       (161)   Tx 874.830      Rx 829.830 
Channel 10      (140)   Tx 874.200      Rx 829.200 
Channel 11      (119)   Tx 873.570      Rx 828.570 
Channel 12      (98)    Tx 872.940      Rx 827.940 
Channel 13      (77)    Tx 872.310      Rx 827.310 
Channel 14      (56)    Tx 871.680      Rx 826.680 
Channel 15      (35)    Tx 871.050      Rx 826.050 
Channel 16      (14)    Tx 870.420      Rx 825.420 
 
Cell # 6 
-------------------------------------------------- 
Channel 1       (328)   Tx 879.840      Rx 834.840 
Channel 2       (307)   Tx 879.210      Rx 834.210 
Channel 3       (286)   Tx 878.580      Rx 833.580 
Channel 4       (265)   Tx 877.950      Rx 832.950 
Channel 5       (244)   Tx 877.320      Rx 832.320 
Channel 6       (223)   Tx 876.690      Rx 831.690 
Channel 7       (202)   Tx 876.060      Rx 831.060 
Channel 8       (181)   Tx 875.430      Rx 830.430 
Channel 9       (160)   Tx 874.800      Rx 829.800 
Channel 10      (139)   Tx 874.170      Rx 829.170 
Channel 11      (118)   Tx 873.540      Rx 828.540 
Channel 12      (97)    Tx 872.910      Rx 827.910 
Channel 13      (76)    Tx 872.280      Rx 827.280 
Channel 14      (55)    Tx 871.650      Rx 826.650 
Channel 15      (34)    Tx 871.020      Rx 826.020 
Channel 16      (13)    Tx 870.390      Rx 825.390 
 
Cell # 7 
-------------------------------------------------- 
Channel 1       (327)   Tx 879.810      Rx 834.810 
Channel 2       (306)   Tx 879.180      Rx 834.180 
Channel 3       (285)   Tx 878.550      Rx 833.550 
Channel 4       (264)   Tx 877.920      Rx 832.920 
Channel 5       (243)   Tx 877.290      Rx 832.290 
Channel 6       (222)   Tx 876.660      Rx 831.660 
Channel 7       (201)   Tx 876.030      Rx 831.030 
Channel 8       (180)   Tx 875.400      Rx 830.400 
Channel 9       (159)   Tx 874.770      Rx 829.770 
Channel 10      (138)   Tx 874.140      Rx 829.140 
Channel 11      (117)   Tx 873.510      Rx 828.510 
Channel 12      (96)    Tx 872.880      Rx 827.880 
Channel 13      (75)    Tx 872.250      Rx 827.250 
Channel 14      (54)    Tx 871.620      Rx 826.620 
Channel 15      (33)    Tx 870.990      Rx 825.990 
Channel 16      (12)    Tx 870.360      Rx 825.360 
 
Cell # 8 
-------------------------------------------------- 
Channel 1       (326)   Tx 879.780      Rx 834.780 
Channel 2       (305)   Tx 879.150      Rx 834.150 
Channel 3       (284)   Tx 878.520      Rx 833.520 
Channel 4       (263)   Tx 877.890      Rx 832.890 
Channel 5       (242)   Tx 877.260      Rx 832.260 
Channel 6       (221)   Tx 876.630      Rx 831.630 
Channel 7       (200)   Tx 876.000      Rx 831.000 
Channel 8       (179)   Tx 875.370      Rx 830.370 
Channel 9       (158)   Tx 874.740      Rx 829.740 
Channel 10      (137)   Tx 874.110      Rx 829.110 
Channel 11      (116)   Tx 873.480      Rx 828.480 
Channel 12      (95)    Tx 872.850      Rx 827.850 
Channel 13      (74)    Tx 872.220      Rx 827.220 
Channel 14      (53)    Tx 871.590      Rx 826.590 
Channel 15      (32)    Tx 870.960      Rx 825.960 
Channel 16      (11)    Tx 870.330      Rx 825.330 
 
Cell # 9 
-------------------------------------------------- 
Channel 1       (325)   Tx 879.750      Rx 834.750 
Channel 2       (304)   Tx 879.120      Rx 834.120 
Channel 3       (283)   Tx 878.490      Rx 833.490 
Channel 4       (262)   Tx 877.860      Rx 832.860 
Channel 5       (241)   Tx 877.230      Rx 832.230 
Channel 6       (220)   Tx 876.600      Rx 831.600 
Channel 7       (199)   Tx 875.970      Rx 830.970 
Channel 8       (178)   Tx 875.340      Rx 830.340 
Channel 9       (157)   Tx 874.710      Rx 829.710 
Channel 10      (136)   Tx 874.080      Rx 829.080 
Channel 11      (115)   Tx 873.450      Rx 828.450 
Channel 12      (94)    Tx 872.820      Rx 827.820 
Channel 13      (73)    Tx 872.190      Rx 827.190 
Channel 14      (52)    Tx 871.560      Rx 826.560 
Channel 15      (31)    Tx 870.930      Rx 825.930 
Channel 16      (10)    Tx 870.300      Rx 825.300 
 
Cell # 10 
-------------------------------------------------- 
Channel 1       (324)   Tx 879.720      Rx 834.720 
Channel 2       (303)   Tx 879.090      Rx 834.090 
Channel 3       (282)   Tx 878.460      Rx 833.460 
Channel 4       (261)   Tx 877.830      Rx 832.830 
Channel 5       (240)   Tx 877.200      Rx 832.200 
Channel 6       (219)   Tx 876.570      Rx 831.570 
Channel 7       (198)   Tx 875.940      Rx 830.940 
Channel 8       (177)   Tx 875.310      Rx 830.310 
Channel 9       (156)   Tx 874.680      Rx 829.680 
Channel 10      (135)   Tx 874.050      Rx 829.050 
Channel 11      (114)   Tx 873.420      Rx 828.420 
Channel 12      (93)    Tx 872.790      Rx 827.790 
Channel 13      (72)    Tx 872.160      Rx 827.160 
Channel 14      (51)    Tx 871.530      Rx 826.530 
Channel 15      (30)    Tx 870.900      Rx 825.900 
Channel 16      (9)     Tx 870.270      Rx 825.270 
 
Cell # 11 
-------------------------------------------------- 
Channel 1       (323)   Tx 879.690      Rx 834.690 
Channel 2       (302)   Tx 879.060      Rx 834.060 
Channel 3       (281)   Tx 878.430      Rx 833.430 
Channel 4       (260)   Tx 877.800      Rx 832.800 
Channel 5       (239)   Tx 877.170      Rx 832.170 
Channel 6       (218)   Tx 876.540      Rx 831.540 
Channel 7       (197)   Tx 875.910      Rx 830.910 
Channel 8       (176)   Tx 875.280      Rx 830.280 
Channel 9       (155)   Tx 874.650      Rx 829.650 
Channel 10      (134)   Tx 874.020      Rx 829.020 
Channel 11      (113)   Tx 873.390      Rx 828.390 
Channel 12      (92)    Tx 872.760      Rx 827.760 
Channel 13      (71)    Tx 872.130      Rx 827.130 
Channel 14      (50)    Tx 871.500      Rx 826.500 
Channel 15      (29)    Tx 870.870      Rx 825.870 
Channel 16      (8)     Tx 870.240      Rx 825.240 
 
Cell # 12 
-------------------------------------------------- 
Channel 1       (322)   Tx 879.660      Rx 834.660 
Channel 2       (301)   Tx 879.030      Rx 834.030 
Channel 3       (280)   Tx 878.400      Rx 833.400 
Channel 4       (259)   Tx 877.770      Rx 832.770 
Channel 5       (238)   Tx 877.140      Rx 832.140 
Channel 6       (217)   Tx 876.510      Rx 831.510 
Channel 7       (196)   Tx 875.880      Rx 830.880 
Channel 8       (175)   Tx 875.250      Rx 830.250 
Channel 9       (154)   Tx 874.620      Rx 829.620 
Channel 10      (133)   Tx 873.990      Rx 828.990 
Channel 11      (112)   Tx 873.360      Rx 828.360 
Channel 12      (91)    Tx 872.730      Rx 827.730 
Channel 13      (70)    Tx 872.100      Rx 827.100 
Channel 14      (49)    Tx 871.470      Rx 826.470 
Channel 15      (28)    Tx 870.840      Rx 825.840 
Channel 16      (7)     Tx 870.210      Rx 825.210 
 
Cell # 13 
-------------------------------------------------- 
Channel 1       (321)   Tx 879.630      Rx 834.630 
Channel 2       (300)   Tx 879.000      Rx 834.000 
Channel 3       (279)   Tx 878.370      Rx 833.370 
Channel 4       (258)   Tx 877.740      Rx 832.740 
Channel 5       (237)   Tx 877.110      Rx 832.110 
Channel 6       (216)   Tx 876.480      Rx 831.480 
Channel 7       (195)   Tx 875.850      Rx 830.850 
Channel 8       (174)   Tx 875.220      Rx 830.220 
Channel 9       (153)   Tx 874.590      Rx 829.590 
Channel 10      (132)   Tx 873.960      Rx 828.960 
Channel 11      (111)   Tx 873.330      Rx 828.330 
Channel 12      (90)    Tx 872.700      Rx 827.700 
Channel 13      (69)    Tx 872.070      Rx 827.070 
Channel 14      (48)    Tx 871.440      Rx 826.440 
Channel 15      (27)    Tx 870.810      Rx 825.810 
Channel 16      (6)     Tx 870.180      Rx 825.180 
 
Cell # 14 
-------------------------------------------------- 
Channel 1       (320)   Tx 879.600      Rx 834.600 
Channel 2       (299)   Tx 878.970      Rx 833.970 
Channel 3       (278)   Tx 878.340      Rx 833.340 
Channel 4       (257)   Tx 877.710      Rx 832.710 
Channel 5       (236)   Tx 877.080      Rx 832.080 
Channel 6       (215)   Tx 876.450      Rx 831.450 
Channel 7       (194)   Tx 875.820      Rx 830.820 
Channel 8       (173)   Tx 875.190      Rx 830.190 
Channel 9       (152)   Tx 874.560      Rx 829.560 
Channel 10      (131)   Tx 873.930      Rx 828.930 
Channel 11      (110)   Tx 873.300      Rx 828.300 
Channel 12      (89)    Tx 872.670      Rx 827.670 
Channel 13      (68)    Tx 872.040      Rx 827.040 
Channel 14      (47)    Tx 871.410      Rx 826.410 
Channel 15      (26)    Tx 870.780      Rx 825.780 
Channel 16      (5)     Tx 870.150      Rx 825.150 
 
Cell # 15 
-------------------------------------------------- 
Channel 1       (319)   Tx 879.570      Rx 834.570 
Channel 2       (298)   Tx 878.940      Rx 833.940 
Channel 3       (277)   Tx 878.310      Rx 833.310 
Channel 4       (256)   Tx 877.680      Rx 832.680 
Channel 5       (235)   Tx 877.050      Rx 832.050 
Channel 6       (214)   Tx 876.420      Rx 831.420 
Channel 7       (193)   Tx 875.790      Rx 830.790 
Channel 8       (172)   Tx 875.160      Rx 830.160 
Channel 9       (151)   Tx 874.530      Rx 829.530 
Channel 10      (130)   Tx 873.900      Rx 828.900 
Channel 11      (109)   Tx 873.270      Rx 828.270 
Channel 12      (88)    Tx 872.640      Rx 827.640 
Channel 13      (67)    Tx 872.010      Rx 827.010 
Channel 14      (46)    Tx 871.380      Rx 826.380 
Channel 15      (25)    Tx 870.750      Rx 825.750 
Channel 16      (4)     Tx 870.120      Rx 825.120 
 
Cell # 16 
-------------------------------------------------- 
Channel 1       (318)   Tx 879.540      Rx 834.540 
Channel 2       (297)   Tx 878.910      Rx 833.910 
Channel 3       (276)   Tx 878.280      Rx 833.280 
Channel 4       (255)   Tx 877.650      Rx 832.650 
Channel 5       (234)   Tx 877.020      Rx 832.020 
Channel 6       (213)   Tx 876.390      Rx 831.390 
Channel 7       (192)   Tx 875.760      Rx 830.760 
Channel 8       (171)   Tx 875.130      Rx 830.130 
Channel 9       (150)   Tx 874.500      Rx 829.500 
Channel 10      (129)   Tx 873.870      Rx 828.870 
Channel 11      (108)   Tx 873.240      Rx 828.240 
Channel 12      (87)    Tx 872.610      Rx 827.610 
Channel 13      (66)    Tx 871.980      Rx 826.980 
Channel 14      (45)    Tx 871.350      Rx 826.350 
Channel 15      (24)    Tx 870.720      Rx 825.720 
Channel 16      (3)     Tx 870.090      Rx 825.090 
 
Cell # 17 
-------------------------------------------------- 
Channel 1       (317)   Tx 879.510      Rx 834.510 
Channel 2       (296)   Tx 878.880      Rx 833.880 
Channel 3       (275)   Tx 878.250      Rx 833.250 
Channel 4       (254)   Tx 877.620      Rx 832.620 
Channel 5       (233)   Tx 876.990      Rx 831.990 
Channel 6       (212)   Tx 876.360      Rx 831.360 
Channel 7       (191)   Tx 875.730      Rx 830.730 
Channel 8       (170)   Tx 875.100      Rx 830.100 
Channel 9       (149)   Tx 874.470      Rx 829.470 
Channel 10      (128)   Tx 873.840      Rx 828.840 
Channel 11      (107)   Tx 873.210      Rx 828.210 
Channel 12      (86)    Tx 872.580      Rx 827.580 
Channel 13      (65)    Tx 871.950      Rx 826.950 
Channel 14      (44)    Tx 871.320      Rx 826.320 
Channel 15      (23)    Tx 870.690      Rx 825.690 
Channel 16      (2)     Tx 870.060      Rx 825.060 
 
Cell # 18 
-------------------------------------------------- 
Channel 1       (316)   Tx 879.480      Rx 834.480 
Channel 2       (295)   Tx 878.850      Rx 833.850 
Channel 3       (274)   Tx 878.220      Rx 833.220 
Channel 4       (253)   Tx 877.590      Rx 832.590 
Channel 5       (232)   Tx 876.960      Rx 831.960 
Channel 6       (211)   Tx 876.330      Rx 831.330 
Channel 7       (190)   Tx 875.700      Rx 830.700 
Channel 8       (169)   Tx 875.070      Rx 830.070 
Channel 9       (148)   Tx 874.440      Rx 829.440 
Channel 10      (127)   Tx 873.810      Rx 828.810 
Channel 11      (106)   Tx 873.180      Rx 828.180 
Channel 12      (85)    Tx 872.550      Rx 827.550 
Channel 13      (64)    Tx 871.920      Rx 826.920 
Channel 14      (43)    Tx 871.290      Rx 826.290 
Channel 15      (22)    Tx 870.660      Rx 825.660 
Channel 16      (1)     Tx 870.030      Rx 825.030 
 
Cell # 19 
-------------------------------------------------- 
Channel 1       (315)   Tx 879.450      Rx 834.450 
Channel 2       (294)   Tx 878.820      Rx 833.820 
Channel 3       (273)   Tx 878.190      Rx 833.190 
Channel 4       (252)   Tx 877.560      Rx 832.560 
Channel 5       (231)   Tx 876.930      Rx 831.930 
Channel 6       (210)   Tx 876.300      Rx 831.300 
Channel 7       (189)   Tx 875.670      Rx 830.670 
Channel 8       (168)   Tx 875.040      Rx 830.040 
Channel 9       (147)   Tx 874.410      Rx 829.410 
Channel 10      (126)   Tx 873.780      Rx 828.780 
Channel 11      (105)   Tx 873.150      Rx 828.150 
Channel 12      (84)    Tx 872.520      Rx 827.520 
Channel 13      (63)    Tx 871.890      Rx 826.890 
Channel 14      (42)    Tx 871.260      Rx 826.260 
Channel 15      (21)    Tx 870.630      Rx 825.630 
 
Cell # 20 
-------------------------------------------------- 
Channel 1       (314)   Tx 879.420      Rx 834.420 
Channel 2       (293)   Tx 878.790      Rx 833.790 
Channel 3       (272)   Tx 878.160      Rx 833.160 
Channel 4       (251)   Tx 877.530      Rx 832.530 
Channel 5       (230)   Tx 876.900      Rx 831.900 
Channel 6       (209)   Tx 876.270      Rx 831.270 
Channel 7       (188)   Tx 875.640      Rx 830.640 
Channel 8       (167)   Tx 875.010      Rx 830.010 
Channel 9       (146)   Tx 874.380      Rx 829.380 
Channel 10      (125)   Tx 873.750      Rx 828.750 
Channel 11      (104)   Tx 873.120      Rx 828.120 
Channel 12      (83)    Tx 872.490      Rx 827.490 
Channel 13      (62)    Tx 871.860      Rx 826.860 
Channel 14      (41)    Tx 871.230      Rx 826.230 
Channel 15      (20)    Tx 870.600      Rx 825.600 
 
Cell # 21 
-------------------------------------------------- 
Channel 1       (313)   Tx 879.390      Rx 834.390 
Channel 2       (292)   Tx 878.760      Rx 833.760 
Channel 3       (271)   Tx 878.130      Rx 833.130 
Channel 4       (250)   Tx 877.500      Rx 832.500 
Channel 5       (229)   Tx 876.870      Rx 831.870 
Channel 6       (208)   Tx 876.240      Rx 831.240 
Channel 7       (187)   Tx 875.610      Rx 830.610 
Channel 8       (166)   Tx 874.980      Rx 829.980 
Channel 9       (145)   Tx 874.350      Rx 829.350 
Channel 10      (124)   Tx 873.720      Rx 828.720 
Channel 11      (103)   Tx 873.090      Rx 828.090 
Channel 12      (82)    Tx 872.460      Rx 827.460 
Channel 13      (61)    Tx 871.830      Rx 826.830 
Channel 14      (40)    Tx 871.200      Rx 826.200 
Channel 15      (19)    Tx 870.570      Rx 825.570 
 
************************************************** 
 
Cellular Phone Band B (Channel 1 is Data) 
 
Cell # 1 
-------------------------------------------------- 
Channel 1       (334)   Tx 880.020      Rx 835.020 
Channel 2       (355)   Tx 880.650      Rx 835.650 
Channel 3       (376)   Tx 881.280      Rx 836.280 
Channel 4       (397)   Tx 881.910      Rx 836.910 
Channel 5       (418)   Tx 882.540      Rx 837.540 
Channel 6       (439)   Tx 883.170      Rx 838.170 
Channel 7       (460)   Tx 883.800      Rx 838.800 
Channel 8       (481)   Tx 884.430      Rx 839.430 
Channel 9       (502)   Tx 885.060      Rx 840.060 
Channel 10      (523)   Tx 885.690      Rx 840.690 
Channel 11      (544)   Tx 886.320      Rx 841.320 
Channel 12      (565)   Tx 886.950      Rx 841.950 
Channel 13      (586)   Tx 887.580      Rx 842.580 
Channel 14      (607)   Tx 888.210      Rx 843.210 
Channel 15      (628)   Tx 888.840      Rx 843.840 
Channel 16      (649)   Tx 889.470      Rx 844.470 
 
Cell # 2 
-------------------------------------------------- 
Channel 1       (335)   Tx 880.050      Rx 835.050 
Channel 2       (356)   Tx 880.680      Rx 835.680 
Channel 3       (377)   Tx 881.310      Rx 836.310 
Channel 4       (398)   Tx 881.940      Rx 836.940 
Channel 5       (419)   Tx 882.570      Rx 837.570 
Channel 6       (440)   Tx 883.200      Rx 838.200 
Channel 7       (461)   Tx 883.830      Rx 838.830 
Channel 8       (482)   Tx 884.460      Rx 839.460 
Channel 9       (503)   Tx 885.090      Rx 840.090 
Channel 10      (524)   Tx 885.720      Rx 840.720 
Channel 11      (545)   Tx 886.350      Rx 841.350 
Channel 12      (566)   Tx 886.980      Rx 841.980 
Channel 13      (587)   Tx 887.610      Rx 842.610 
Channel 14      (608)   Tx 888.240      Rx 843.240 
Channel 15      (629)   Tx 888.870      Rx 843.870 
Channel 16      (650)   Tx 889.500      Rx 844.500 
 
Cell # 3 
-------------------------------------------------- 
Channel 1       (336)   Tx 880.080      Rx 835.080 
Channel 2       (357)   Tx 880.710      Rx 835.710 
Channel 3       (378)   Tx 881.340      Rx 836.340 
Channel 4       (399)   Tx 881.970      Rx 836.970 
Channel 5       (420)   Tx 882.600      Rx 837.600 
Channel 6       (441)   Tx 883.230      Rx 838.230 
Channel 7       (462)   Tx 883.860      Rx 838.860 
Channel 8       (483)   Tx 884.490      Rx 839.490 
Channel 9       (504)   Tx 885.120      Rx 840.120 
Channel 10      (525)   Tx 885.750      Rx 840.750 
Channel 11      (546)   Tx 886.380      Rx 841.380 
Channel 12      (567)   Tx 887.010      Rx 842.010 
Channel 13      (588)   Tx 887.640      Rx 842.640 
Channel 14      (609)   Tx 888.270      Rx 843.270 
Channel 15      (630)   Tx 888.900      Rx 843.900 
Channel 16      (651)   Tx 889.530      Rx 844.530 
 
Cell # 4 
-------------------------------------------------- 
Channel 1       (337)   Tx 880.110      Rx 835.110 
Channel 2       (358)   Tx 880.740      Rx 835.740 
Channel 3       (379)   Tx 881.370      Rx 836.370 
Channel 4       (400)   Tx 882.000      Rx 837.000 
Channel 5       (421)   Tx 882.630      Rx 837.630 
Channel 6       (442)   Tx 883.260      Rx 838.260 
Channel 7       (463)   Tx 883.890      Rx 838.890 
Channel 8       (484)   Tx 884.520      Rx 839.520 
Channel 9       (505)   Tx 885.150      Rx 840.150 
Channel 10      (526)   Tx 885.780      Rx 840.780 
Channel 11      (547)   Tx 886.410      Rx 841.410 
Channel 12      (568)   Tx 887.040      Rx 842.040 
Channel 13      (589)   Tx 887.670      Rx 842.670 
Channel 14      (610)   Tx 888.300      Rx 843.300 
Channel 15      (631)   Tx 888.930      Rx 843.930 
Channel 16      (652)   Tx 889.560      Rx 844.560 
 
Cell # 5 
-------------------------------------------------- 
Channel 1       (338)   Tx 880.140      Rx 835.140 
Channel 2       (359)   Tx 880.770      Rx 835.770 
Channel 3       (380)   Tx 881.400      Rx 836.400 
Channel 4       (401)   Tx 882.030      Rx 837.030 
Channel 5       (422)   Tx 882.660      Rx 837.660 
Channel 6       (443)   Tx 883.290      Rx 838.290 
Channel 7       (464)   Tx 883.920      Rx 838.920 
Channel 8       (485)   Tx 884.550      Rx 839.550 
Channel 9       (506)   Tx 885.180      Rx 840.180 
Channel 10      (527)   Tx 885.810      Rx 840.810 
Channel 11      (548)   Tx 886.440      Rx 841.440 
Channel 12      (569)   Tx 887.070      Rx 842.070 
Channel 13      (590)   Tx 887.700      Rx 842.700 
Channel 14      (611)   Tx 888.330      Rx 843.330 
Channel 15      (632)   Tx 888.960      Rx 843.960 
Channel 16      (653)   Tx 889.590      Rx 844.590 
 
Cell # 6 
-------------------------------------------------- 
Channel 1       (339)   Tx 880.170      Rx 835.170 
Channel 2       (360)   Tx 880.800      Rx 835.800 
Channel 3       (381)   Tx 881.430      Rx 836.430 
Channel 4       (402)   Tx 882.060      Rx 837.060 
Channel 5       (423)   Tx 882.690      Rx 837.690 
Channel 6       (444)   Tx 883.320      Rx 838.320 
Channel 7       (465)   Tx 883.950      Rx 838.950 
Channel 8       (486)   Tx 884.580      Rx 839.580 
Channel 9       (507)   Tx 885.210      Rx 840.210 
Channel 10      (528)   Tx 885.840      Rx 840.840 
Channel 11      (549)   Tx 886.470      Rx 841.470 
Channel 12      (570)   Tx 887.100      Rx 842.100 
Channel 13      (591)   Tx 887.730      Rx 842.730 
Channel 14      (612)   Tx 888.360      Rx 843.360 
Channel 15      (633)   Tx 888.990      Rx 843.990 
Channel 16      (654)   Tx 889.620      Rx 844.620 
 
Cell # 7 
-------------------------------------------------- 
Channel 1       (340)   Tx 880.200      Rx 835.200 
Channel 2       (361)   Tx 880.830      Rx 835.830 
Channel 3       (382)   Tx 881.460      Rx 836.460 
Channel 4       (403)   Tx 882.090      Rx 837.090 
Channel 5       (424)   Tx 882.720      Rx 837.720 
Channel 6       (445)   Tx 883.350      Rx 838.350 
Channel 7       (466)   Tx 883.980      Rx 838.980 
Channel 8       (487)   Tx 884.610      Rx 839.610 
Channel 9       (508)   Tx 885.240      Rx 840.240 
Channel 10      (529)   Tx 885.870      Rx 840.870 
Channel 11      (550)   Tx 886.500      Rx 841.500 
Channel 12      (571)   Tx 887.130      Rx 842.130 
Channel 13      (592)   Tx 887.760      Rx 842.760 
Channel 14      (613)   Tx 888.390      Rx 843.390 
Channel 15      (634)   Tx 889.020      Rx 844.020 
Channel 16      (655)   Tx 889.650      Rx 844.650 
 
Cell # 8 
-------------------------------------------------- 
Channel 1       (341)   Tx 880.230      Rx 835.230 
Channel 2       (362)   Tx 880.860      Rx 835.860 
Channel 3       (383)   Tx 881.490      Rx 836.490 
Channel 4       (404)   Tx 882.120      Rx 837.120 
Channel 5       (425)   Tx 882.750      Rx 837.750 
Channel 6       (446)   Tx 883.380      Rx 838.380 
Channel 7       (467)   Tx 884.010      Rx 839.010 
Channel 8       (488)   Tx 884.640      Rx 839.640 
Channel 9       (509)   Tx 885.270      Rx 840.270 
Channel 10      (530)   Tx 885.900      Rx 840.900 
Channel 11      (551)   Tx 886.530      Rx 841.530 
Channel 12      (572)   Tx 887.160      Rx 842.160 
Channel 13      (593)   Tx 887.790      Rx 842.790 
Channel 14      (614)   Tx 888.420      Rx 843.420 
Channel 15      (635)   Tx 889.050      Rx 844.050 
Channel 16      (656)   Tx 889.680      Rx 844.680 
 
Cell # 9 
-------------------------------------------------- 
Channel 1       (342)   Tx 880.260      Rx 835.260 
Channel 2       (363)   Tx 880.890      Rx 835.890 
Channel 3       (384)   Tx 881.520      Rx 836.520 
Channel 4       (405)   Tx 882.150      Rx 837.150 
Channel 5       (426)   Tx 882.780      Rx 837.780 
Channel 6       (447)   Tx 883.410      Rx 838.410 
Channel 7       (468)   Tx 884.040      Rx 839.040 
Channel 8       (489)   Tx 884.670      Rx 839.670 
Channel 9       (510)   Tx 885.300      Rx 840.300 
Channel 10      (531)   Tx 885.930      Rx 840.930 
Channel 11      (552)   Tx 886.560      Rx 841.560 
Channel 12      (573)   Tx 887.190      Rx 842.190 
Channel 13      (594)   Tx 887.820      Rx 842.820 
Channel 14      (615)   Tx 888.450      Rx 843.450 
Channel 15      (636)   Tx 889.080      Rx 844.080 
Channel 16      (657)   Tx 889.710      Rx 844.710 
 
Cell # 10 
-------------------------------------------------- 
Channel 1       (343)   Tx 880.290      Rx 835.290 
Channel 2       (364)   Tx 880.920      Rx 835.920 
Channel 3       (385)   Tx 881.550      Rx 836.550 
Channel 4       (406)   Tx 882.180      Rx 837.180 
Channel 5       (427)   Tx 882.810      Rx 837.810 
Channel 6       (448)   Tx 883.440      Rx 838.440 
Channel 7       (469)   Tx 884.070      Rx 839.070 
Channel 8       (490)   Tx 884.700      Rx 839.700 
Channel 9       (511)   Tx 885.330      Rx 840.330 
Channel 10      (532)   Tx 885.960      Rx 840.960 
Channel 11      (553)   Tx 886.590      Rx 841.590 
Channel 12      (574)   Tx 887.220      Rx 842.220 
Channel 13      (595)   Tx 887.850      Rx 842.850 
Channel 14      (616)   Tx 888.480      Rx 843.480 
Channel 15      (637)   Tx 889.110      Rx 844.110 
Channel 16      (658)   Tx 889.740      Rx 844.740 
 
Cell # 11 
-------------------------------------------------- 
Channel 1       (344)   Tx 880.320      Rx 835.320 
Channel 2       (365)   Tx 880.950      Rx 835.950 
Channel 3       (386)   Tx 881.580      Rx 836.580 
Channel 4       (407)   Tx 882.210      Rx 837.210 
Channel 5       (428)   Tx 882.840      Rx 837.840 
Channel 6       (449)   Tx 883.470      Rx 838.470 
Channel 7       (470)   Tx 884.100      Rx 839.100 
Channel 8       (491)   Tx 884.730      Rx 839.730 
Channel 9       (512)   Tx 885.360      Rx 840.360 
Channel 10      (533)   Tx 885.990      Rx 840.990 
Channel 11      (554)   Tx 886.620      Rx 841.620 
Channel 12      (575)   Tx 887.250      Rx 842.250 
Channel 13      (596)   Tx 887.880      Rx 842.880 
Channel 14      (617)   Tx 888.510      Rx 843.510 
Channel 15      (638)   Tx 889.140      Rx 844.140 
Channel 16      (659)   Tx 889.770      Rx 844.770 
 
Cell # 12 
-------------------------------------------------- 
Channel 1       (345)   Tx 880.350      Rx 835.350 
Channel 2       (366)   Tx 880.980      Rx 835.980 
Channel 3       (387)   Tx 881.610      Rx 836.610 
Channel 4       (408)   Tx 882.240      Rx 837.240 
Channel 5       (429)   Tx 882.870      Rx 837.870 
Channel 6       (450)   Tx 883.500      Rx 838.500 
Channel 7       (471)   Tx 884.130      Rx 839.130 
Channel 8       (492)   Tx 884.760      Rx 839.760 
Channel 9       (513)   Tx 885.390      Rx 840.390 
Channel 10      (534)   Tx 886.020      Rx 841.020 
Channel 11      (555)   Tx 886.650      Rx 841.650 
Channel 12      (576)   Tx 887.280      Rx 842.280 
Channel 13      (597)   Tx 887.910      Rx 842.910 
Channel 14      (618)   Tx 888.540      Rx 843.540 
Channel 15      (639)   Tx 889.170      Rx 844.170 
Channel 16      (660)   Tx 889.800      Rx 844.800 
 
Cell # 13 
-------------------------------------------------- 
Channel 1       (346)   Tx 880.380      Rx 835.380 
Channel 2       (367)   Tx 881.010      Rx 836.010 
Channel 3       (388)   Tx 881.640      Rx 836.640 
Channel 4       (409)   Tx 882.270      Rx 837.270 
Channel 5       (430)   Tx 882.900      Rx 837.900 
Channel 6       (451)   Tx 883.530      Rx 838.530 
Channel 7       (472)   Tx 884.160      Rx 839.160 
Channel 8       (493)   Tx 884.790      Rx 839.790 
Channel 9       (514)   Tx 885.420      Rx 840.420 
Channel 10      (535)   Tx 886.050      Rx 841.050 
Channel 11      (556)   Tx 886.680      Rx 841.680 
Channel 12      (577)   Tx 887.310      Rx 842.310 
Channel 13      (598)   Tx 887.940      Rx 842.940 
Channel 14      (619)   Tx 888.570      Rx 843.570 
Channel 15      (640)   Tx 889.200      Rx 844.200 
Channel 16      (661)   Tx 889.830      Rx 844.830 
 
Cell # 14 
-------------------------------------------------- 
Channel 1       (347)   Tx 880.410      Rx 835.410 
Channel 2       (368)   Tx 881.040      Rx 836.040 
Channel 3       (389)   Tx 881.670      Rx 836.670 
Channel 4       (410)   Tx 882.300      Rx 837.300 
Channel 5       (431)   Tx 882.930      Rx 837.930 
Channel 6       (452)   Tx 883.560      Rx 838.560 
Channel 7       (473)   Tx 884.190      Rx 839.190 
Channel 8       (494)   Tx 884.820      Rx 839.820 
Channel 9       (515)   Tx 885.450      Rx 840.450 
Channel 10      (536)   Tx 886.080      Rx 841.080 
Channel 11      (557)   Tx 886.710      Rx 841.710 
Channel 12      (578)   Tx 887.340      Rx 842.340 
Channel 13      (599)   Tx 887.970      Rx 842.970 
Channel 14      (620)   Tx 888.600      Rx 843.600 
Channel 15      (641)   Tx 889.230      Rx 844.230 
Channel 16      (662)   Tx 889.860      Rx 844.860 
 
Cell # 15 
-------------------------------------------------- 
Channel 1       (348)   Tx 880.440      Rx 835.440 
Channel 2       (369)   Tx 881.070      Rx 836.070 
Channel 3       (390)   Tx 881.700      Rx 836.700 
Channel 4       (411)   Tx 882.330      Rx 837.330 
Channel 5       (432)   Tx 882.960      Rx 837.960 
Channel 6       (453)   Tx 883.590      Rx 838.590 
Channel 7       (474)   Tx 884.220      Rx 839.220 
Channel 8       (495)   Tx 884.850      Rx 839.850 
Channel 9       (516)   Tx 885.480      Rx 840.480 
Channel 10      (537)   Tx 886.110      Rx 841.110 
Channel 11      (558)   Tx 886.740      Rx 841.740 
Channel 12      (579)   Tx 887.370      Rx 842.370 
Channel 13      (600)   Tx 888.000      Rx 843.000 
Channel 14      (621)   Tx 888.630      Rx 843.630 
Channel 15      (642)   Tx 889.260      Rx 844.260 
Channel 16      (663)   Tx 889.890      Rx 844.890 
 
Cell # 16 
-------------------------------------------------- 
Channel 1       (349)   Tx 880.470      Rx 835.470 
Channel 2       (370)   Tx 881.100      Rx 836.100 
Channel 3       (391)   Tx 881.730      Rx 836.730 
Channel 4       (412)   Tx 882.360      Rx 837.360 
Channel 5       (433)   Tx 882.990      Rx 837.990 
Channel 6       (454)   Tx 883.620      Rx 838.620 
Channel 7       (475)   Tx 884.250      Rx 839.250 
Channel 8       (496)   Tx 884.880      Rx 839.880 
Channel 9       (517)   Tx 885.510      Rx 840.510 
Channel 10      (538)   Tx 886.140      Rx 841.140 
Channel 11      (559)   Tx 886.770      Rx 841.770 
Channel 12      (580)   Tx 887.400      Rx 842.400 
Channel 13      (601)   Tx 888.030      Rx 843.030 
Channel 14      (622)   Tx 888.660      Rx 843.660 
Channel 15      (643)   Tx 889.290      Rx 844.290 
Channel 16      (664)   Tx 889.920      Rx 844.920 
 
Cell # 17 
-------------------------------------------------- 
Channel 1       (350)   Tx 880.500      Rx 835.500 
Channel 2       (371)   Tx 881.130      Rx 836.130 
Channel 3       (392)   Tx 881.760      Rx 836.760 
Channel 4       (413)   Tx 882.390      Rx 837.390 
Channel 5       (434)   Tx 883.020      Rx 838.020 
Channel 6       (455)   Tx 883.650      Rx 838.650 
Channel 7       (476)   Tx 884.280      Rx 839.280 
Channel 8       (497)   Tx 884.910      Rx 839.910 
Channel 9       (518)   Tx 885.540      Rx 840.540 
Channel 10      (539)   Tx 886.170      Rx 841.170 
Channel 11      (560)   Tx 886.800      Rx 841.800 
Channel 12      (581)   Tx 887.430      Rx 842.430 
Channel 13      (602)   Tx 888.060      Rx 843.060 
Channel 14      (623)   Tx 888.690      Rx 843.690 
Channel 15      (644)   Tx 889.320      Rx 844.320 
Channel 16      (665)   Tx 889.950      Rx 844.950 
 
Cell # 18 
-------------------------------------------------- 
Channel 1       (351)   Tx 880.530      Rx 835.530 
Channel 2       (372)   Tx 881.160      Rx 836.160 
Channel 3       (393)   Tx 881.790      Rx 836.790 
Channel 4       (414)   Tx 882.420      Rx 837.420 
Channel 5       (435)   Tx 883.050      Rx 838.050 
Channel 6       (456)   Tx 883.680      Rx 838.680 
Channel 7       (477)   Tx 884.310      Rx 839.310 
Channel 8       (498)   Tx 884.940      Rx 839.940 
Channel 9       (519)   Tx 885.570      Rx 840.570 
Channel 10      (540)   Tx 886.200      Rx 841.200 
Channel 11      (561)   Tx 886.830      Rx 841.830 
Channel 12      (582)   Tx 887.460      Rx 842.460 
Channel 13      (603)   Tx 888.090      Rx 843.090 
Channel 14      (624)   Tx 888.720      Rx 843.720 
Channel 15      (645)   Tx 889.350      Rx 844.350 
Channel 16      (666)   Tx 889.980      Rx 844.980 
 
Cell # 19 
-------------------------------------------------- 
Channel 1       (352)   Tx 880.560      Rx 835.560 
Channel 2       (373)   Tx 881.190      Rx 836.190 
Channel 3       (394)   Tx 881.820      Rx 836.820 
Channel 4       (415)   Tx 882.450      Rx 837.450 
Channel 5       (436)   Tx 883.080      Rx 838.080 
Channel 6       (457)   Tx 883.710      Rx 838.710 
Channel 7       (478)   Tx 884.340      Rx 839.340 
Channel 8       (499)   Tx 884.970      Rx 839.970 
Channel 9       (520)   Tx 885.600      Rx 840.600 
Channel 10      (541)   Tx 886.230      Rx 841.230 
Channel 11      (562)   Tx 886.860      Rx 841.860 
Channel 12      (583)   Tx 887.490      Rx 842.490 
Channel 13      (604)   Tx 888.120      Rx 843.120 
Channel 14      (625)   Tx 888.750      Rx 843.750 
Channel 15      (646)   Tx 889.380      Rx 844.380 
 
Cell # 20 
-------------------------------------------------- 
Channel 1       (353)   Tx 880.590      Rx 835.590 
Channel 2       (374)   Tx 881.220      Rx 836.220 
Channel 3       (395)   Tx 881.850      Rx 836.850 
Channel 4       (416)   Tx 882.480      Rx 837.480 
Channel 5       (437)   Tx 883.110      Rx 838.110 
Channel 6       (458)   Tx 883.740      Rx 838.740 
Channel 7       (479)   Tx 884.370      Rx 839.370 
Channel 8       (500)   Tx 885.000      Rx 840.000 
Channel 9       (521)   Tx 885.630      Rx 840.630 
Channel 10      (542)   Tx 886.260      Rx 841.260 
Channel 11      (563)   Tx 886.890      Rx 841.890 
Channel 12      (584)   Tx 887.520      Rx 842.520 
Channel 13      (605)   Tx 888.150      Rx 843.150 
Channel 14      (626)   Tx 888.780      Rx 843.780 
Channel 15      (647)   Tx 889.410      Rx 844.410 
 
Cell # 21 
-------------------------------------------------- 
Channel 1       (354)   Tx 880.620      Rx 835.620 
Channel 2       (375)   Tx 881.250      Rx 836.250 
Channel 3       (396)   Tx 881.880      Rx 836.880 
Channel 4       (417)   Tx 882.510      Rx 837.510 
Channel 5       (438)   Tx 883.140      Rx 838.140 
Channel 6       (459)   Tx 883.770      Rx 838.770 
Channel 7       (480)   Tx 884.400      Rx 839.400 
Channel 8       (501)   Tx 885.030      Rx 840.030 
Channel 9       (522)   Tx 885.660      Rx 840.660 
Channel 10      (543)   Tx 886.290      Rx 841.290 
Channel 11      (564)   Tx 886.920      Rx 841.920 
Channel 12      (585)   Tx 887.550      Rx 842.550 
Channel 13      (606)   Tx 888.180      Rx 843.180 
Channel 14      (627)   Tx 888.810      Rx 843.810 
Channel 15      (648)   Tx 889.440      Rx 844.440 
 
***************************************************************************** 
 
PART X.              A FEW COMMON SCANNER MODIFICATIONS 
 
        Here a few scanners and what it takes to modify them.  If your  
scanner is not shown here, don't worry.  Ham Radio BBS's are all over the 
country.  You should be able to find the instructions for modifying your 
scanner there. 
 
Restoration of Cellular Frequency Coverage on 
Radio Shack PRO-34 Handheld Scanner 
  
1.  Remove battery cover and battery, four black screws on rear cover, and volume and squelch knobs. 
  
2.  Remove rear cover, lifting back and up to clear controls.  Do not remove belt clip or circuit board screws. 
  
3.  Unplug the brown volume control connector (grn/yel/blk) and white squelch control connector (wht/blk/red) from the linear circuit board. 
  
4.  Unsolder the ground lead from T111 (at corner of linear circuit board above the external power connectors).  Unsolder the two power switch leads from the back of the volume control.  Unsolder the antenna connector center pin and ground wires from the l 
  
5.  Unscrew the four combination screws that hold the linear circuit board and received the back cover screws. 
Grasp the linear board at the top and lift it straight away from the front case, unplugging the 16-pin connector. 
  
6.  Remove the three screws holding the metal frame assembly which held the linear board to the front panel.  Unplug the red-black power lead and lay the frame aside.  It is still connected to the battery contacts. 
  
7.  Locate diodes D9 - D12 on the volume control side of the of the logic circuit board under T1; D10 and D11 are marked.  Clip one lead of D11, separating the gap.  This may be resoldered later if desired. 
  
8.  Reassemble the board by reversing the disassembly procedures above. 
 
Restoration of Cellular Frequency Coverage on 
Radio Shack PRO-2004 Scanner 
 
By cutting diode D513 on the PC 3 sub chassis in the Realistic PRO-2004 
Scanner you can re-enable the 825.00 to 845.00 and 870-00 to 890.00 frequency 
selection.  To scan in 30KHZ steps press "STEP-RESET".  
 
Restoration of Cellular Frequency Coverage on 
Radio Shack PRO-2005 Scanner 
 
1. Unplug the radio 
2. Remove the screws and take off the top cover. 
3. Look for D502 on the inside right hand-side of the front panel. 
   (No need to unsolder the silver plate protecting the vertical board!) 
4. Simply cut the diode and reverse the process. 
 
        Aren't you glad I only chose to cover Radio Shack models. I'm sure 
you appreciate the fact that I only deal with quality merchandise.  If you 
have some cash to blow (like $500), I would recommend buying the ICOM R-1 
handheld scanner.  It scans from 1 to 1400 in 1/2 step increments and already 
includes the cellular frequencies.  Plus is is about as tall as a box of 3.25 
floppies and about as wide as a 16 oz. coke bottle.  It is the smallest and 
one of the more powerful hand-scanners around. 
 
***************************************************************************** 
 
PART XI.                THE 40-50 MHZ CELLULAR SCANNER 
 
 
        The cellular phone freqs. occupy the UHF spectrum previously assign 
to commercial TV stations.  Since a TV channel occupies a Bandwidth(BW) of 6 
MHZ and each cellular channel requires 24 KZ (for a plus and minus 12 KHZ 
signal) and a 3KHZ guard band for each audio signal (thus the 30KHZ spacing). 
200 cellular channels can fit into one UHF TV channel.  Thus, with a little 
fine tuning, and old TV set with variable VHF tuning can tune in all 
cellular freqs. between 824 and 890 MHZ. 
 
UHF TV tuners ares designed to convert these UHF freqa. to intermediate 
(difference) freqs. between 41 and 47 MHZ.  Thus, by purchasing a commonly 
available UHF tuner (check sith a TV shop and try to get a copy of the 
SAMS for powering the AFC info, and avoid those with tubes).  Tuner voltage 
is usually 8-24 volts, and must be correctly connected up.  You should also 
remove with the tuner, the TV's channel select and fine tuning controls 
for ease of use - and they should be in good condition. 
 
Once you have the tuner, you can then wire it between a 30-50 MHZ scanner and 
a UHF antenna (highly directional yagi type is preferred).  Since the tuner 
will probably have a 300 ohm input impedance, a twin antenna cable is  
preferred (Yes Radio Shack has 'em).  If you are into directional-finding, 
the UHF antenna should NOT have AGC (automatic Gain Control) as those with 
active AGC will amplify reflections, resulting in readings from so many  
directions that the target will be lost.  Because of the use of inconspicuous, 
commonly available, inexpensive, high-gain UHF antennas, using a good UHF 
tuner to scan cellular channels is a good method of doing it. 
 
Tuner output is usually through an RCA-type plug. CAUTION: BE SURE TO COUPLE 
YOUR SCANNER TO THE UHF TUNER WITH A 0.01-0.1 mf (50 V min.) CAPACITOR FOR 
DC BLOCKING.  AND DO NOT TRY TO OPERATE THE TUNER THROUGH ITS TV SET AS THE 
DANGER OF HIGH-VOLTAGE DISCHARGE IS HIGH.  Also, connect a ground wire 
between the tuner and the scanner. 
 
The table below describes how cellular freqs. can be downconverted by a 
commonly available UHF TV tuner (all freqs. are in MHZ) 
 
               CELLULAR MOBILE FREQS & SCANNER EQUIVALENTS 
 
TV               
BAND            CELL. CHAN.             SCAN    TV OSCIL                       
CHAN.           # and FREQ.             FREQ.     FREQ.         LIMIT  
-----------    ------------             -----   --------        ----- 
73 (first)      0001-825.03             45.97     871           824-830 
73 (last)       0166-829.98             41.02     871           824-830 
74 (first)      0167-830.01             46.99     877           830-836 
74 (last)       0366-835.98             41.02     877           830-836 
75 (first)      0367-836.01             46.99     883           836-842 
75 (last)       0566-841.98             41.02     883           836-842 
76 (first)      0567-842.01             46.99     889           842-848 
76 (last)       0766-847.98             41.02     889           842-848 
77 (first)      0767-848.01             46.99     895           848-854 
77 (last)       0799-848.97             46.03     895           848-854 
               CELLULAR PHONE FREQS. HAVE NOT BEEN ASSIGNED 
                       FOR CHANNELS 800-990 
73 (first)      0991-824.04             46.96     871           824-830 
73 (last)       1023-825.00             46.00     871           824-830 
80 (first)      0001-870.03             42.97     913           866-872 
80 (last)       0066-871.98             41.02     913           866-972 
81 (first)      0067-872.01             46.99     919           872-878 
81 (last)       0266-877.98             41.02     919           872-878 
82 (first)      0267-878.01             46.99     925           878-884 
82 (last)       0466-883.98             41.02     925           878-884 
83 (first)      0467-884.01             46.99     931           884-890 
83 (last)       0666-889.98             41.02     931           884-890 
83 (**)         0667-890.01             46.99     931           884-890 
83 (**)         0799-893.97             37.03     931           884-890 
               CELLULAR PHONE FREQS. HAVE NOT BEEN ASSIGNED 
                       FOR CHANNELS 800-990 
80 (first)      0991-869.04             43.96     913           866-872 
80 (last)       1023-870.00             43.00     913           866-872 
 
(**) These freqs. are outside of the normal Channel 83 BW. However, most UHF 
tuners have a fine tuner that can be adjusted up to about another 6 MHZ. 
 
Note that the term "first" and "last" refers to the first and last cellular 
channels receivable by the UHF tuner for the given TV channel.  Base voice 
channels are monitored when both sides of the conversation is required.   
Mobile voice channels or base control channels are monitored to locate a 
cellular phone.  Tuning is simple: 
        (1) Decide which cellular channel or freq. you wish to monitor. 
        (2) Find what UHF channel includes that freq. and switch the TV 
            to that channel. 
        (3) Using the table, look up the corresponding TV oscillator freq. 
            (ex: 919 MHZ for TV channel 81).  Subtract the cellular channel 
            freq. from the TV oscillator freq. 
        (4) Tune your scanner to the difference freq. 
 
When you select a scanner, you should pick one that will scan in 30 MHZ 
increments to efficiently receive cellular transmissions.  If you can't get 
one like that, then get one that will scan in 15,10 or 5 KHZ increments. 
 
***************************************************************************** 
 
 
PART XII.                   HOW THE ESN IS REPLACED 
 
        It takes some electronics skill to pull or unsolder the ESN.  If you 
are sketchy about messing around with your phone, I suggest practicing on  
something else first, like an old calculator or something.  It is also a 
good idea to use the proper tools (A very small soldering tip,chip pullers, 
It is imperative NOT to touch any of the surrounding connections, soldering 
joints, or chips.  The job MUST be done right the very first time.  After 
that it is not so important, because after the first time you should have the 
ESN information stored safely to disk.  The only dangers remaining are 
physically damaging the chip.  (Note: There are devices that wipe PROMs 
clean in the event of programming errors). 
 
        When removing the ESN, try to follow these 5 steps: 
 
A. Remove the PC board containing the ESN from the entire phone unit.  The 
boards are usually screwed in with Phillips heads.  This will insure  
against damage to the rest of the unit. 
 
B.  Ascertain the correct chip.  Find the letters on the chip, and check it 
against the letters from the IDENTIFYING THE ESN section. Refer to the .Gif 
file included if necessary. 
 
C. It is a good idea to draw a sketch to help you remember which way the chip 
went in.  You may laugh, but do it anyway. 
 
D. Carefully remove the chip.  Take your time and use the proper tools. 
 
E.  Solder in a zero insertion force (ZIF) replacement, so that replacement 
chip can be changed easily. 
 
        After the ZIF socket has been successfully soldered in, reinsert the 
ESN and attempt to make a phone call (Be sure the NAM is programmed 
correctly). If it doesn't, check the leads on the ZIF to insure that you 
have soldered them correctly.  After that, insert your ESN into your PROM 
reader and make sure it provides some sort of reading.  You should use the 
search mode to look for the manufacturers serial number. 
(see MANUFACTURER'S ESN CODE LISTING) to identify the address on the PROM 
where to reprogram the ESN. 
 
***************************************************************************** 
 
PART XIII.             EQUATIONS FOR PROGRAMMING THE CHIPS 
 
        In most instances, you will not be able to tell the code on a PROM 
because the manufacturer will have blown the security fuse in order to  
prevent people from obtaining the codes to reprogram their own chips. 
Therefore, it might be necessary to produce a set of equations that are 
programmed into the cip to produce a bogus ESN.  The bogus chips must contain 
the first three digits of the manufacturer's code listing, which is  
consequently the first marker of the actual ESN.  Experimentation might be 
necessary, but hey, isn't that half the fun?  
 
        With the aid of an EPROM emulator, the whole process should be able 
to be completed in under an hour - this includes pulling the chip, creating 
a new ESN, programming the chip, and replacing it. 
 
        So know you're saying "Holy Cow this project is getting expensive!". 
Well it can get that way, but the long run payoff is worth it.  I have seen 
both emulators and burners for under $200 (I'm not talking about those spiffy 
models that program RAM, just the basic EPROMs...in fact I can buy them for 
under $150. Same with the emulator. Just look around.) 
 
        I wouldn't be surprised if actual ESN data started appearing on  
boards in the near future.  I know when I finsish my phone (Hopefully soon) 
I plan on U/L the ESN info somewhere. 
 
**************************************************************************** 
 
PART XIV.              MANUFACTURER'S ESN CODE LISTING 
 
--------------------------------------------------------------------------- 
MANUFACTURER                  DECIMAL         HEX CODE        OCTAL CODE 
--------------------------------------------------------------------------- 
 
Alpine Electronics #            150             96              226              
Antel (see Emptel,Sanyo) 
ARA *                            
AT&T Technologies (see notes)   158             9E              236 
Astrotel (see OKI) 
Audiovox-Audiotel (see notes)   138             8A              212 
Blaupunkt (R. Bosch) #          148             94              224 
Clarion Company Ltd.            140             8C              214 
Clarion Manufacturing Co.       166             A6              246 
CM Communications               153             99              231 
Diamondtel (See Mitsubishi) 
DI-BAR Electronics              145             91              221 
E.F. Johnson  #                 131             83              203 
Emptel Electronics Co.          178             B2              262 
Ericsson                        143             8F              217 
Ericsson GE Mobile              157             9D              235 
Fujitsu #                       133             85              205 
Gateway Telephone               147             93              223 
General Electric # (mini is 134)146             92              222 
Glenayre (see notes) 
Goldstar Products Co. #         141             8D              215 
Harris #                        137             89              211 
Hitachi #                       132             84              204 
Hughes Network Systems          164             A4              244 
Hyundai                         160             A0              240 
Japan Radio Co.                 152             98              230 
Kokusai                         139             8B              213 
Mansoor Electronics             167             A7              247 
Mitsubishi (see notes)          134             86              206 
Mobira (Nokia-Kinex) #          156             9C              234 
Motorola                        130             82              202 
Motorola Int'l.                 168             A8              250 
Murata Machinery LTD.           144             90              220 
NEC #                           135             87              207 
Nokia #                         165             A5              245 
Novatel                         142             8E              216 
OKI #                           129             81              201 
Panasonic (Matsushita) #        136             88              210 
Phillips Telecom #              170             AA              252 
Phillips Circuit                171             AB              253 
Qualcomm, Inc.                  159             9F              237 
Sanyo                           175             AF              257 
Satellite Technology            161             A1              241 
Samsung Communications          176             B0              258 
Shintom West (Audio-Vox BC-20)# 174             AE              256 
Sony Corp.                      154             9A              232 
Sun Moon Star #                 178             B2              262 
Tama Denki Co.                  155             9B              233 
Tandy/Mobira #                  165             A5              245 
TacTel (see notes) 
Technophone #                   162             A2              242 
Toshiba                         138             8A              212 
Uniden Corp. of America #       172             AC              254 
Uniden Corp. of Japan           173             AC              255 
Universal Cellular              149             95              225 
USA Corp. # (see notes) 
Walker (JRC, Technophone)       152             98              230 
Western Electric # (see notes) 
Western Union # (see notes) 
Yupiteru Industries             163             A3              243 
 
 
NOTES: 
 
The hexidecimal ESN is an 11-digit number, first three are manufacturer's 
decimal code, next two are reserved (but may contain zeros or numbers); 
remaining six are the decimal serial number. 
 
These companies use phones from various manufacturers, code will be of actual 
manufacturer. 
 
Alpine 9510 is Fujitsu 362A - Antel, use GE, Emptel, Sanyo - ARA varies- ATT 
1300, 1800 use Mitsubishi -  AT&T 1100,1400,1440,1700,1710 use Hitachi - 
Audiotel 1000,3000,500,BC-40,400,450,550,600 use Toshiba - PC100,200 use 
Technophone - BC-20,CMT-125 use Shintom - TacTel use Toshiba,Blaupunkt, most 
are Panasonic, some are Blaupunkt - GE Mini, Gelayre 301 , USA A&B  
use Mitsubishi - Mitsubishi 460 use Toshiba - Walker Pocketphone use 
JRC or Technophone - Western Electric use Hitachi - Western Union use E.F. 
Johnson. 
 
# - Chassis number abd ESN correspond to each other. 
 
Decimal ESN conversion is required for serial numbers over 1,000,000 or  
2,000,000, etc.  Simply drop the millions digit and add 262,144 times the 
millions digit to the remaining number.  For example, 01,123,456 = 
385,600 or 02,123,46 = 647,744.  Then affix the Manufacturers Decimal Code plus 
two zeros on left to yield 11-digit ESN.  The Hex ESN may be found by  
converting this number to hexidecimal.  
 
***************************************************************************** 
 
PART XV.                  HOME SYSTEM ID LISTING (A-L) 
 
 
SYSTEM                NON(A)          WIRE(B) 
 
Abilene,TX              131             422   
Aguadilla               605             188 
Aiken,GA                181             084 
Akron,OH                073             054 
Albany,GA               241             204 
Alburquerque,NM         079             110 
Alexandria,LA           243             212 
Allentown,PA            103             008 
Alton,IL                017             046 
Altoona,PA              247             032 
Amarillo,TX             249             422 
Anchorage,AK            251             234 
Anderson,IN             253             080 
Anderson,SC             139             116 
Anniston,AL             113             098 
Appleton,WI             217             240 
Asheville,NC            263             246 
Ashland,WV              307             TBA 
Athens,AL               203             198 
Athens,GA               041             034 
Atlanta,GA              041             034 
Atlantic City,NJ        267             250 
Augusta,GA              181             084 
Aurora,IL               001             020 
Austin,TX               107             164 
Bakersfield,CA          183             228 
Baltimore,MD            013             018 
Bangor,ME               271             254 
Baton Rouge,LA          085             106 
Battle Creek,MI         403             256 
Beaumont,TX             185             012 
Bellingham,WA           047             006 
Beloit,WI               217             210 
Benton Harbor,MI        277             260 
Biddeford,ME            501             484 
Billings,MT             279             262 
Biloxi,MS               281             264 
Binghamton,NY           283             266 
Birmingham,AL           113             098 
Bismarck,ND             285             268 
Bloomington,IL          455             532 
Boise,ID                289             272 
Boston,MA               007             028 
Bradenton,FL            175             042 
Bremerton,WA            047             006 
Bridgeport,CT           119             088 
Bristol,TN              149             074 
Brownsville,TX          451             434 
Bryan,TX                297             280 
Buffalo,NY              003             056 
Burlington,NC           069             144 
Burlington,VT           313             300 
Canton,OH               073             054 
Casper,WY               301             284 
Ceder Falls,IA          589             568 
Cedar Rapids,IA         303             286 
Champaign,IL            305             532 
Charleston,WV           307             290 
Charleston,SC           127             156 
Charlotte,NC            139             114 
Charlottesville,VA      309             292 
Chattanooga,TN          161             148 
Chicago,IL              001             020 
Chico,CA                311             294 
Cincinnati,OH           051             014 
Clarksville,TN          179             296 
Cleveland,OH            015             054 
College Station,TX      297             280 
Colorado Springs,CO     045             180 
Columbia,MO             317             298 
Columbia,SC             189             182 
Columbus,GA             319             302 
Columbus,OH             133             138 
Corpus Christi,TX       191             184 
Council Bluffs,IA       137             152 
Cumberland,MD           321             304 
Dallas,TX               033             038 
Danville,VA             323             306 
Davenport,IA            193             186 
Dayton, OH              163             134 
Daytona Beach,FL        325             308 
Decatur,IL              327             532 
Dennison,TX             033             038 
Denver,CO               045             058 
Des Moines,IA           195             150 
Detroit, MI             021             010 
Dothan,AL               329             312 
Dover,NH                501             484 
Dubuque,IA              331             314 
Duluth,MN               333             316 
Durham,NC               069             144 
Eau Claire,WI           335             318 
Elgin,IL                001             020 
El Paso,TX              097             092 
Elkhart,IN              549             530 
Elmira,NY               283             266 
Elyria,OH               TBA             054 
Enid,OK                 341             324 
Erie,PA                 343             326 
Eugene,OR               061             328 
Evansville,IN           197             190 
Fargo,ND                347             330 
Fayettesville,NC        349             100 
Fayetteville,AR         607             342 
Flint,MI                021             010 
Florence,AL             113             334 
Florence,SC             377             350 
Fort Collins,CO         045             336 
Fort Lauderdale,FL      037             024 
For Meyers,FL           355             042 
Fort Pierce,FL          037             340 
Fort Smith,AR           359             342 
Fort Walton Bch,FL      361             344 
Fort Wayne,IN           199             080 
Fort Worth,TX           033             038 
Fresno,CA               153             162 
Gadsden,AL              113             098 
Gainesville,FL          365             348 
Galveston,TX            367             012 
Gary,IN                 001             020 
Glens Falls, NY         063             078 
Grand Forks,ND          371             356 
Grand Rapids,MI         021             244 
Granite City,IL         017             046 
Great Falls, MT         373             358 
Greeley,CO              045             360 
Green Bay,WI            217             362 
Greensboro,NC           095             142 
Greenville,SC           139             116 
Gulf of Mexico,LA       171             194 
Gulfport,MS             TBA             264 
Gunterville,AL          203             198 
Hagerstown,MD           381             364 
Hamilton,OH             383             366 
Harlingen,TX            451             434 
Harrisburg,PA           159             096 
Hartford,CT             119             088 
Hickory,NC              385             368 
Honolulu,HI             167             060 
Houma,LA                387             370 
Houston,TX              035             012 
Huntington,WV           307             196 
Huntsville,AL           203             198 
Indianapolis,IN         019             080 
Iowa City,IA            389             286 
Jackson,MI              391             374 
Jackson,MS              205             160 
Jacksonville,FL         075             136 
Jacksonville,NC         393             376 
Janesville, WI          217             210 
Johnson City,TN         149             074 
Johnstown,PA            039             032 
Joliet,IL               001             020 
Joplin,MO               401             384 
Kalamazoo,MI            403             386 
Kankakee,IL             001             020 
Kansas City,KS/MO       059             052 
Kennewick,WA            TBA             500 
Kenosha,WI              217             044 
Killeen,TX              409             392 
Kingsport,TN            149             074 
Knoxville,TN            093             104 
Kokomo,IN               411             080 
La Crosse,WI            413             396 
Lafayette,IN            415             080 
Lafayette,LA            431             414 
Lake Charles,LA         417             400 
Lakeland,FL             175             042 
Lancaster,PA            159             096 
Lansing,MI              021             188 
Laredo,TX               419             402 
Las Cruces,NM           097             404 
Las Vegas,NV            211             064 
Lawrence,KS             059             406 
Lawton,OK               425             408 
Lewiston,ME             427             482 
Lexington,KY            213             206 
Lima,OH                 021             412 
Lincoln,NE              433             416 
Little Rock,AR          215             208 
Long Branch,NY          173             022 
Longview,TX             229             418 
Lorain,OH               437             054 
Los Angeles,CA          027             002 
Louisville, KY          065             076 
Lubbock,TX              439             422 
Lynchberg,VA            441             424 
 
***************************************************************************** 
 
PART XVI.                  HOME SYSTEM ID LISTING (M-Z) 
 
 
SYSTEM                NON(A)          WIRE(B) 
 
Macon,GA                443             426 
Madison,WI              217             210 
Manchester,NH           445             428 
Mansfield,OH            447             430 
Marshall,TX             229             418 
Mayaguez                449             432 
McAllen,TX              451             434 
Medford,OR              061             436 
Melbourne,FL            175             068 
Memphis,TN              143             062 
Miami,FL                037             024 
Midland,TX              459             422 
Millville,NH            TBA             250 
Milwaukee,WI            005             044 
Minneapolis,MN          023             026 
Mobile,AL               081             120 
Modesto,CA              233             224 
Moline,IL               193             186 
Monroe,LA               463             440 
Monterey,CA             527             126 
Montgomery,AL           465             444 
Moorehead,ND            TBA             330 
Muncie,IN               467             080 
Muskegon,MI             021             448 
Nashua,NH               445             428 
Nashville,TN            179             118 
NE Pennsylvania         103             172 
New Bedford,MA          119             028 
New Brunswick,NY        173             022 
New Haven,CT            119             088 
New London,CT           119             088 
New Orleans,LA          057             036 
Newport News,VA         083             168 
New York,NY             025             022 
Norfolk,VA              083             168 
Ocala,FL                473             348 
Odessa,TX               475             422 
Oklahoma City,OK        169             146 
Olympia,WA              047             006 
Omaha,NE                137             152 
Orange County,NY        479             486 
Orlando,FL              175             068 
Owensboro,KY            197             190 
Oxnard,CA               027             002 
Panama City,FL          483             462 
Parkersburg,WV          485             032 
Pascagoula,MS           487             264 
Pasco,WA                TBA             500 
Pensacola,FL            361             120 
Peoria,IL               221             214 
Petaluma,CA             031             040 
Petersburg,VA           071             472 
Philadelphia,PA         029             008 
Phoenix,AZ              053             048 
Pine Bluff,AR           215             208 
Pittsburg,PA            039             032 
Pittsfield,MA           119             480 
Ponce,PR                497             082 
Portland,ME             499             482 
Portland,OR             061             030 
Portsmouth,NH           501             484 
Poughkeepsie,NY         503             486 
Providence,RI           119             028 
Provo,UT                091             488 
Pueblo,CO               045             490 
Racine,WI               217             044 
Raleigh,NC              069             144 
Rapid City,SD           511             494 
Reading,PA              103             008 
Redding,CA              513             294 
Reno,NV                 515             498 
Richland,WA             517             500 
Richmond,VA             071             170 
Roanoke,VA              519             502 
Rochester,NH            501             484 
Rochester,MN            521             504 
Rochester,NY            117             154 
Rockford,IL             217             506 
Sacramento,CA           129             112 
Saginaw,MI              021             389 
Salem,OR                061             030 
Salinas,CA              527             126 
Salt Lake City,UT       091             094 
San Angelo,TX           529             510 
San Antonio,TX          151             122 
San Diego,CA            043             004 
San Francisco,CA        031             040 
San Jose,CA             031             040 
Terre Haute,IN          567             080 
Texarkana,AR/TX         229             550 
Toledo,OH               021             130 
Topeka,KS               059             552 
Trenton,PA              029             008 
Tuscon,AZ               053             140 
Tulsa,OK                111             166 
Tuscaloosa,AL           577             098 
Tyler,TX                579             418 
Utica,NY                235             226 
Vallejo,CA              031             040 
Victoria,TX             581             562 
Vineland,NJ             583             250 
Visalia,CA              153             162 
Waco,TX                 587             566 
Warren,OH               089             126 
Washington,DC           013             018 
Waterloo,IA             589             568 
Wausau,WI               591             570 
West Palm Beach,FL      037             024 
Wheeling,WV             039             032 
Wichita Falls,TX        595             574 
Wichita,KS              165             070 
Wilkes Barr,PA          103             172 
Williamsport,PA         103             576 
Wilmington,DE           123             008 
Wilmington,NC           599             578 
Winston-Salem,NC        095             142 
Worcester,MA            007             028 
Yakima,WA               601             580 
York,PA                 159             096 
Youngstown,OH           089             126 
Yuba City,CA            129             112 
 
 
***************************************************************************** 
 
PART XVI.                     "THE ROAMING SCAM" 
 
        Some people who are playing with phones that have been originally 
registered but have been turned off for non-payment of bills have used the 
"Roaming Scam" to place free calls.  NOTE: The cellular carriers will still 
have records of these calls, and will prosecute those they eventually catch 
up to (yeah,right).  However, industry standards have shown that they pursue 
less than one percent of the fraudulent calls placed.  It is far more  
economical for them to build software and hardware traps to prevent unbilled 
calls from being placed rather than attempt to collect on the other end 
which involves greater amounts of personnel and manpower with smaller actual  
collections. 
 
        People have performed the roaming scam by taking their phones into  
areas where the SIDH numbers are different from the ones currently programmed  
into their phones.  Refer to the SIDH listing in this file for the codes for 
particular cities.  By reprogramming the NAM and inserting a fake SIDH, the 
cellular carrier will often accept the phone call, but on occassion the user 
will get a message that the phone must have a local code in order to access 
the system.  As cellular carriers grow larger in size, this message is less 
frequently heard.  At this point, the cellular carrier instructs the user to 
contact them.  I don't think so. 
 
        The cellular service has the best chance of of catching a spoofer who 
either calls a friend continually at home or by developing traceable trends 
such as calling the same number from within the same cell at the same time 
every day.  Or doing something stupid like ordering a Pizza. 
 
        "But I want to hook up the phone to an acoustic coupler, d00d, and 
        call all the k-rad out-state-boards for the latest 
        PyRut WaR3z!4@$$!$@!@"  <-lamer. 
 
        Well, one of the properties of cellular phone systems is that the    
transmitter freqs. may be changed or "hopped" in the constant effort to 
allocate freqs.  Because of freq. hopping it is very difficult to 
triangulate a cellular phone using standard directional finding methods 
(trace you, d00d).  Further, it is known that a directional antenna randomly 
aimed at  cellsite repeaters will confuse directional finding equipment 
being used by them that is synced to their freq. hopping scheme. 
 
***************************************************************************** 
 
PART XVIII.              MERCHANDISE SHEET 
 
 
                        CELLULAR PHONE SUPPLIERS 
 
     NCI                                R/M Wholesale Communications 
     744 Roble Road, Suite 185          800-837-5532 
     Allentown,PA 18103 
     800-669-5167 
     215-264-5117 
 
     Superior Cellular Products         Cellular Enterprises, Inc. 
     3925 N. Rosemead Blvd. #205        813-885-7766 
     Rosemead,CA 91770 
     818-280-6665 
 
     Dynatek Communication Dist.        Wholesale Cellular, Inc. 
     340 Constance Dr.                  5720 West 71st St. 
     Warminster,PA 18974                Indianapolis, IN 46278 
     215-672-5000                       317-297-6100 
 
 
                        CELLULAR SERVICE MONITORS 
 
     InTouch USA 
     800-USA-ROAM 
     800-872-7626 
 
                        CELLULAR TEST EQUIPMENT 
 
     WAVETEK 
     1-800-223-WVTK 
     Ask for free Communications Catalog 
 
 
                        CELLULAR SERVICE MONITORS 
 
     Communication Instruments 
     356 Hillcrest Street 
     El Segundo, CA 90245 
     800-288-8223 
     213-322-3666 
 
                        CELLULAR PHONE REPAIRS 
 
     Communication Consultants Co.      Cellular Phone Services, Inc    
     16128 Cohasset St.                 403 E. Gude Dr. 
     Van Nuys, CA 91406                 Rockville, MD 20850 
     818-901-9711                       800-326-7901 
                                        ext. 101 
 
                        PROM EMULATORS 
 
     Parallax, Inc.                    Incredible Technologies 
     6200 Desimone Lane, #69A          708-437-2433 
     Citrus Heights, CA 95621 
     916-726-1905 
 
     Technical Solutions 
     P.O. Box 462101 
     Dept. 101 
     Garland, TX 75046 
     214-272-9392 
 
                        PROM PROGRAMMERS 
 
     BP Microsystems                    Link Computer Graphics           
     10681 Haddington                   369 Passaic Road, Ste. 100 
     Houston,TX 77043                   Fairfield, NJ 07004 
     713-461-9430                       201-808-8990 
 
     MVS                                Needhamps Electronics 
     Box 994                            4539 Orange Grove Ave. 
     Merrimack, NH                      Sacramento, CA 95841 
     508-792-9507                       916-924-8037 
 
                        PROM CHIPS 
 
     National Semiconductor 
     Offices throughout the U.S. 
     408-721-5000 
 
     JDR Microdevices 
     800-538-5000 
 
     Easy Tech 
     2917 Bayview Drive 
     Fremont, CA 94538 
     800-582-4044 
 
 