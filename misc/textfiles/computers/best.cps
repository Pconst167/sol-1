
*****************************************************************************
*                                                                           *
*    FIRE Starter : Get the BEST out of JRCOMM and your DUALST 14.4k Bds    *
*                                                                           *
*****************************************************************************
-----------------------------------------------------------------------------


         a

 '' __    -    -__
   _\ /> / /> / /
   _ /_   _   _       _ ___    _
  |_)|_) | | | \ | | |   |  | | | |\ | ``     19 may 1991.
  |  | \ |_| |_/ |_| |_  |  | |_| | \|

                               (c) 1991 Text Files. Call TRADE-LINE.
                                   The Fastest CANADIAN ELITE AMIGA BBS.
                                   [ 514 ] 966-1133. 14,400 BDS. 395 MEGS.


















----------------------------------------------------------------------------
TEXT CREATED BY THE SPIRIT (MONTREAL,CANADA)
----------------------------------------------------------------------------
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
The REAL Best Settings for a DUAL STANDARD V42 BIS. (USERS VERSION)
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


This settings where not designed for SysOp.

If you have a DUAL STANDARD and use JRCOMM, then read the whole file.
If you have a HST, then skip the DUAL STANDARD settings.
This file will tell you how to configure your DUAL STANDARD and/or
JRCOMM X.X (Tested on version 1.02a) for ULTIMATE Speeds.

I don't have the Super Fat Agnus, so I can't try anything in PAL
mode. I have heard that CPS are quite faster using a PAL mode..
Well, try it out if you have the chip, you have nothing to loose!

It's amazing the number of LAME text files & TOP, ULTIMATE, BEST, K-RAD
CPS utility we see each day (almost) floorishing in our ware list..
Believe me, with this, if you have the configuration I talked about,
YOU CANNOT HAVE BETTER CPS. Period. I made a LOT of tests..
And that is the best configuration I got.



NOW PRESS CONTROL+C and LOAD JRCOMM! (or stop a new CLI)

---------------------------------------------------------------------
JRCOMM PART
---------------------------------------------------------------------

FILE TRANSFER PARAMETER MENU
****************************

EVERYTHING OFF.. Except :
                           ZMODEM (when will we get a NEW protocol???)
                           Don't care
                           Expand Blanks
                           Resume Transfer (useful!)
                           Auto Download
                           Auto D/L challenge
                           32 Bit CRC
                           Binary Mode
                           Save Aborted (saves the file even if aborted)
                           Relaxed Timing
                           Overdrive

SERIAL MENU
***********

EVERYTHING OFF.. Except :

                           19,2k (Why the HELL use 38.4k on 68000 machines?
                                  And besides, the REAL 38.4k modems aren't
                                  even out yet!)
                           8
                           None
                           1
                           Full


MODEM MENU
**********

                          ATZ^M for the Init Command (Why RECONFIGURE
                                 when everything is the NRAM?? )
                          ~~+++~~ATH^M (Why put THREE ~ when it works
                                        with two, it's faster when
                                       ya need to hangup! hehe)
                                       |
                                       |__\  Well of course, you can
                                          /  always use the VOICE/DATA
                                              or a LIGHTNING fast hang up.

The rest of this menu is up to you. It won't affect the speed in any way.
(The Hangup function of course does not alter the speed, but since I'm
writing this text, I might give ya some hints on other option.. eh?)..


TERMINAL MENU
*************

Bahaha.. There is NOTHING to change in here. I like the people who
actually think putting 2 color will speed up the transfer, NO IT
WON'T! Not even by 1 CPS!! Not even 0.000001 CPS! Another rumour..

(Yeh, Like the CLOCK VIRUS thing.. :-) )


GENERAL MENU
************

CTS/RTS handshake on (of course)
Disk Check (nothing to do with speed, but it's nice to see automatically
            when you download if the file will fit on your d/L directory)
Task Priority ---> 15 <--- Yes! 15.. It's the HIGHEST.. It will slow
                           down your machine LIKE HELL. But it will
                           avoid 99% of the ZRD32, GARGAGE and other
                           shitty errors coming in and SLOWING everything
                           down. You can put this to 0 if you want, you'll
                           be able to multitask, but the transfers won't
                           be so kickin! You'll might ERRORS & lower CPS..

Transfer Buffer Size --> 6 <--  This should not be put to anything else.
                                It's the RIGHT balance. If you put too much
                                buffer size, it means that when there is
                                an errors, it will have to send all the
                                buffer all over. If it's too small, it won't
                                help either. I made a LOT of tests on that
                                particular option, so put it to that value!

GMT Offset --> 0 <--









SOME HINTS..........
---------------------

There you go with JRCOMM! I use the IBEUMA-ZINC.FONT made by my friend,
Marc Dionne. I feel It's the BEST looking font when BBS'ing. It allows
a perfect display of IBM ANSI Codes and AMIGA ANSI Codes without any problem,
and it looks quite good. I included it in the archive. Just take
IBEUMA-ZINC.font and move it to your FONTS: directory and create a
directory in there called IBEUMA-ZINC and put the little "8" thing..
(3188 BYTES).

Another neato thing..

Go in the TERMINAL Menu and change the TEXT #.. Put it to 5 or something.
Then go in your palette menu (use 8 color in IBM mode by the way, that
way you will see NICE looking ANSI, IBM 100% and AMIGA 100%) and change
the FIFTH color. Put it to WHITE. Then modify the FIRST color (which is
white, and put it to something like BLUE!). When you will download,
you won't have that dirty looking WHITE window, you will have a kool
blue or whatever color window you want.

Adjust the other colors to your own taste (call several boards),
DON'T USE THE DEFAULT IBM COLORS, they SUCK shit!! Put more INTENSITY
and use different colors if you want.. But you'll have to EDIT all your
JRCOMM Phone Book and adjust the colors after too.. That's a pain. So
make sure you REALLY like your colors be4 re-creating your phone book.

Would be NICE if J. RADIGAN could put an AUTO COLOR adjusts for every
phone book entry.. As soon as you change the DEFAULT Jrcomm.def palette,
it would adjusts all the other entry (this would be an OPTION.. ).
Would have saved ME and other guys some time fer sure!!
















--------------------------------------------------------------------------
PREFERENCES Best Settings
--------------------------------------------------------------------------

Use the PREF program I included in the ARCHIVE. It's a must. I wonder
if you don't have it already. Go in your prefs, then click on the serial
menu and put 31250 for the Baud speed and 16384 for the buffer. Everything
setted out for maximum input. The buffer will be reduced by  JRCOMM after
(to 6 like I said), so it doesn't really matter. Same thing for the baud.

Save out everything and go back into your JRCOMM.





















-------------------------------------------------------------------------
DUAL STANDARD Best Settings
-------------------------------------------------------------------------

Type ATI5..

Then adjust all options to those ones :


ati5

USRobotics Courier 14400 HST Dual Standard NRAM Settings...

   DIAL=TONE   B0  F1  M1  X3
   BAUD=19200  PARITY=N  WORDLEN=8

   & A3  & B1  & G2  & H1  & I0  & K1  & L0  & M4  & N0
   & P0  & R2  & S0  & T5  & X1  & Y1  % R0

   S02=043  S03=013  S04=010  S05=008  S06=001
   S07=060  S08=003  S09=006  S10=007  S11=036
   S12=050  S13=000  S15=000  S19=000  S21=010
   S22=017  S23=019  S24=150  S26=001  S27=000
   S28=008  S29=020  S32=001  S33=000  S34=000
   S35=000  S36=000  S37=000  S38=007

   STORED PHONE #0: (514) 966-1133
                #1: (514) 966-1133
                #2:
                #3:

OK
ati4

USRobotics Courier 14400 HST Dual Standard Settings...

   B0  C1  E1  F1  M1  Q0  V1  X3
   BAUD=19200  PARITY=N  WORDLEN=8
   DIAL=HUNT   ON HOOK   TIMER

   & A3  & B1  & C1  & D2  & G2  & H1  & I0  & K1  & L0
   & M4  & N0  & P0  & R2  & S0  & T5  & X1  & Y1  % R0

   S00=000  S01=000  S02=043  S03=013  S04=010
   S05=008  S06=001  S07=060  S08=003  S09=006
   S10=007  S11=036  S12=050  S13=000  S14=001
   S15=000  S16=000  S17=001  S18=000  S19=000
   S20=000  S21=010  S22=017  S23=019  S24=150
   S25=000  S26=001  S27=000  S28=008  S29=020
   S30=000  S31=000  S32=001  S33=000  S34=000
   S35=000  S36=000  S37=000  S38=007

   LAST DIALED #: T9661133

OK

Then you do AT&W to save everything out.

Ya can change the ATS11 for SPEED DIALING.. Well at 36, it's VERY QUICK!
(In fact, it can't be quicker for my place, In Montreal!)

The ATS6 thing (1) is the delay between the DIAL TONE & the ACTUAL
Dialing..

__________________________________________________________________________
##########################################################################
--------------------------------------------------------------------------

This is the END of the Text file! Was short & sweet. Now that you are
ready to get KICKIN speeds, dial up my Board...

( 514 ) 966-1133

It's known as the F A S T E S T amiga bbs in CANADA. Only ELITE will
be allowed.

Hope this file will help several users out there!

Later!
__________________________________________________________________________
##########################################################################
--------------------------------------------------------------------------
Greetings go out to : (no order)

                Andeveron, Professor, The Raven, DOC, Spread(s)
                Ti-Bob, Mega Man, Stingray, Raj Dood, Lone Wolf,
                Aries, Solo, Beowulf, Sycon (sorry man!), Animal,
                Elektra (Call our system! H/P base!), HellRat,
                Bernard/SkyMan, Etrop, Capricorn, Problem Child,
                Lazarus Long, Creative Impulse, King Cobra,
                The Omega, The Drummer, The Kid, The Adept,
                Tomcat, The Dream Warriors (Canada), Devious Doze,
                and all others I know!



         a

 '' __    -    -__
   _\ /> / /> / /
   _ /_   _   _       _ ___    _
  |_)|_) | | | \ | | |   |  | | | |\ | ``     19 may 1991.
  |  | \ |_| |_/ |_| |_  |  | |_| | \|

                               (c) 1991 Text Files. Call TRADE-LINE.
                                   The Fastest CANADIAN ELITE AMIGA BBS.
                                   [ 514 ] 966-1133. 14,400 BDS. 395 MEGS.
                                     ~~~   ~~~~~~~~



