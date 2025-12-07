
� Area: Batch Files (help, hints, tips, etc.) (Fido) 컴컴컴컴컴컴컴컴컴컴컴컴�
  Msg#: 446             Rec'd                        Date: 12 Apr 95  19:38:00
  From: Greg Miskelly                                Read: Yes    Replied: No 
    To: Tony Baechler                                Mark:                     
  Subj: Multcopy.Bat
컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
@REPLY: 1:102/125.6 2f885e5e
@MSGID: 2:255/100.0 2f8c7268
@FLAGS DIR

  -=> Quoting Tony Baechler to All <=-

Hi Tony

 TB> @ECHO OFF
 TB> REM MULTCOPY.BAT - copies files from the current directory
 TB> REM   to drive A: across multiple diskettes.
 TB> ATTRIB +A *.*
 TB> :Loop
 TB> XCOPY /M *.* A:
 TB> IF NOT ErrorLevel 4 GOTO Out
 TB> REM ^G in next line represents Ctrl+G
 TB> ECHO ^G
 TB> ECHO Insert a fresh diskette in drive A: and...
 TB> PAUSE
 TB> GOTO Loop
 TB> :Out
 TB> ECHO Done.

I think you need to be a bit more sophisticated than that. It
will ruin your archive attribute record on your files, which
might in turn mess up an incremental backup.

Try this: I wrote it for DOS 5 so it could easily be lightened
for DOS 6 where CHOICE can be used.

- - - - - - - - - - - - - - - < cut > - - - - - - - - - - - - - - -
@echo off
rem CLDD.BAT Copy Large Directories to Diskettes
   if "%1 == "/subroutine goto dothebiz
   if "%1 == " goto help
   if "%1 == "/? goto help
   if not exist %1 echo Error! Source file(s) %1 do not exist
   if not exist %1 goto help
   if "%2 == "a: set cldddrv=A:
   if "%2 == "A: set cldddrv=A:
   if "%2 == "b: set cldddrv=B:
   if "%2 == "B: set cldddrv=B:
   if "%cldddrv% == " goto help
   for %%a in (%1) do call %0 /subroutine %%a %2
   set clddno=
   set cldddsk=
   set cldddrv=
   goto end
:dothebiz
   if "%cldddsk% == " goto disksub
   :dsreturn
      xcopy %2 %cldddrv% > nul
      if errorlevel 4 goto disksub
      echo File %2 successfully copied to %cldddrv%
      goto end
:disksub
   set cldddsk=new
   if "%clddno% == "9 set clddno=10
   if "%clddno% == "8 set clddno=9
   if "%clddno% == "7 set clddno=8
   if "%clddno% == "6 set clddno=7
   if "%clddno% == "5 set clddno=6
   if "%clddno% == "4 set clddno=5
   if "%clddno% == "3 set clddno=4
   if "%clddno% == "2 set clddno=3
   if "%clddno% == "1 set clddno=2
   if "%clddno% == " set clddno=1
   :drvloop
      if exist %temp%\~ynflag.tmp del %temp%\~ynflag.tmp
      echo Place Diskette No %clddno% in Drive %cldddrv%
      pause
      rem > %temp%\~ynflag.tmp
      echo Is diskette a new unformatted diskette Y/N
      del %temp%\~ynflag.tmp /p > nul
      if not exist %temp%\~ynflag.tmp goto initial
      if exist %cldddrv%\*.* goto formdisk
      goto doform
      :formdisk
         echo There are Files on Target Diskette
         echo Do you want to overwrite?  Y/N
         rem > %temp%\~ynflag.tmp
         del %temp%\~ynflag.tmp /p > nul
         if exist %temp%\~ynflag.tmp goto dsreturn
         :doform
            echo.
            echo Preparing Diskette. Please Wait!
            ren /?|format %cldddrv% /u /q /v:"" > nul
            if errorlevel 4 goto fault
            goto dsreturn
         :fault
            echo Please fix error, and try again.
            pause
            goto doform
         :initial
            if exist %temp%\~ynflag.tmp del %temp%\~ynflag.tmp
            format %cldddrv% /autotest /v:""
            goto dsreturn
:help
echo CLDD.BAT Copy Large Directories to Diskette
echo.
echo Syntax     CLDD FILESPEC DRVSPEC
echo.
echo where FILESPEC is the files to be copied and
echo DRVSPEC is the target diskette drive.
echo.
echo Example   CLDD *.* A:
echo.
:end
- - - - - - - - - - - - - - - < cut > - - - - - - - - - - - - - - -
This should work okay for systems using MSDOS 5 and above.

Regards
Greg
___ Blue Wave/QWK v2.12

-!- Maximus/2 2.01wb
 ! Origin: The MonuSci BBS (2:255/100)
SEEN-BY: 102/2 125 128 129 138 210 230 332 390 435 523 752 851 861 903 1302
SEEN-BY: 112/1 147/7 206/1701 270/101 280/1 7 9 10 45 65 66 69 101 113 115
SEEN-BY: 280/118 145 161 180 222 301 306 314 315 333 335 343 359 385 398
SEEN-BY: 290/627 396/1 3615/50
@PATH: 255/100 141/209 375 754 1130 1135 3615/50 396/1 280/1 102/2 138 129
@PATH: 102/125



