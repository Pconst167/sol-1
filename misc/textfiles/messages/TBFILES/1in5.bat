
Ä Area: Batch Files (help, hints, tips, etc.) (Fido) ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
  Msg#: 320             Rec'd                        Date: 23 Apr 95  10:45:15
  From: STEVE REID                                   Read: Yes    Replied: No 
    To: TONY BAECHLER                                Mark:                     
  Subj: 1in5.bat
ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
@EID:3573 80C57140
@FLAGS DIR

 TB>Although a great idea, my only question is, is there any way that could be
TB>made to put the file on a RAM drive, like D: and, if it has not been run
TB>five times yet, add or edit a line at the very end of AUTOEXEC.BAT (or
TB>somewhere else in that file) so that an entire cluster would not be used
TB>for a file with 5 "X"'s in it.

Sounds like you're asking for two contradicting things... Put the count
file on the ramdrive, *and* use AUTOEXEC.BAT?

You might like this:

::1IN5.BAT by Steve Reid
@echo off
echo rem !!!count>>c:\config.sys
find /c "rem !!!count" c:\config.sys>%temp%\temp.bat
echo set count=%%2>%temp%\--------.bat
set oldpath=%path%
path %temp%
call %temp%\temp.bat
path %oldpath%
set oldpath=
del %temp%\temp.bat
del %temp%\--------.bat
if not %count%==5 goto end
type c:\config.sys|find /v "rem !!!count">c:\config.sys
::Once in Five commands go here
rem c:\dos\defrag c: /f/sn
:end
set count=

I use %TEMP% whenever possible, so set that to point to a subdirectory
on a ramdrive. It uses CONFIG.SYS to store the count. It no longer uses
Xs, since they may already exist in CONFIG.SYS. It instead searces for
"rem !!!count". I know that REM statements are ignored in CONFIG.SYS, at
least with dos 6. I used CONFIG.SYS instead of AUTOEXEC.BAT since this
batch file may be called from AUTOEXEC.BAT, and I didn't want to be
messing with a running batch file.

                           Steve Reid - Supreme Overlord of the Universe


Fido: STEVE REID (1:153/414)
Internet: sreid@sea-to-sky-freenet.bc.ca

-!-
 þ SLMR 2.1a þ 

-!- GOMail v2.0v2 Beta [94-0405]
 ! Origin: Bandylan BBS, Squamish, BC (1:153/414)
SEEN-BY: 102/2 125 128 129 138 210 230 332 390 435 523 851 861 903 1302 112/1
SEEN-BY: 147/7 206/1701 270/101 280/1 7 9 10 45 65 66 69 101 113 115 118 145
SEEN-BY: 280/161 180 222 301 306 314 315 333 335 343 359 385 398 290/627
SEEN-BY: 396/1
@PATH: 153/414 7091 7041 752 716 920 270/101 280/1 102/2 138 129 125


