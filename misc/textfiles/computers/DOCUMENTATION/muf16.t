
Ä Area: [ECHO] BATCH POWER PROG. ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
  Msg#: 4967                                         Date: 09-12-93  20:18
  From: Gary Cooper                                  Read: Yes    Replied: No 
    To: ALL                                          Mark:                     
  Subj: MUF Ver. 1.6 #1
ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
                                 The

                               Fabulous

       ####       ####        ###    ###         ##########
       #####     #####        ###    ###         ##########
       ### ##   ## ###        ###    ###         ###
       ###  ## ##  ###        ###    ###         ########
       ###   ###   ###        ###    ###         ########  
       ###    #    ###        ###    ###         ###
       ###         ###        ###    ###         ###
       ###         ###  ##    ##########   ##    ###     ##
       ###         ###  ##     ########    ##    ###     ##

                                 List 

                  (MicroSoft's Undocumented Features)

                          Volume 1  Number 6

===============================================================================

1)  TRUENAME

    Internal DOS 5.0 command.  Canonicalize a filename or path (using
    DOS interrupt 21h, function 60) prints the actual directory.

    SYNTAX

    TRUENAME filename      prints the complete path to file

    TRUENAME directory     prints the complete path to directory

    Note: If the path is in a network, it starts with a \\machine-name

                              Michael Larsson


    TRUENAME is analogous to the "whence" command in the UNIX Korn
    shell.  It returns the real fully qualified pathname for a command.

    TRUENAME is useful in networks, where a physical drive may be mapped
    to a logical volume, and the user needs to know the physical location
    of the file.  It ignores the DOS SUBST, and JOIN commands, or network
    MAPped drives.

    It is an undocumented MS/DOS feature, but is documented in 4DOS as
    follows:

    SYNTAX        (Internal DOS 5.0 / 4DOS)
 
    TRUENAME [d:][path]filename

    PURPOSE

    Returns a fully qualified filename.

    COMMENTS

    TRUENAME will see "through" JOIN and SUBST commands, and requires
    MS-DOS 3.0 or above.

    EXAMPLE

    The following command uses TRUENAME to get the true pathname for a
    file:

    c:\> subst d: c:\util\test
    c:\> truename d:\test.exe

    c:\util\test\test.exe

                              Dennis McCunney

    TRUENAME : will reveal the full name drive and path of the filename.
    If you specify a wildcard ('*') in the filename, it will expand
    the filename to use question marks instead. If the path includes
    the ..\ sequence, TRUENAME will examine the directory structure and
    calculate the path.  Stranger still, the line:

        TRUENAME \CRONK\FLIBBET\..\ART
        produces the response:
        C:\CRONK\ART

    even if the directories \CRONK\FLIBBET and the file ART don't exist!
    Don't expect this command to work across networks.

                              PC Magazine #212 Pg. 48-49
                              Forwarded by:
                              Rodney Atkins

===============================================================================
 
... A feature is a bug with seniority.
___ Blue Wave/QWK v2.12

-!- EzyQwk V1.02
 ! Origin: Programmer's Corner BBS, Saint John, NB  (v32/v42) (1:255/6)

Ä Area: [ECHO] BATCH POWER PROG. ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
  Msg#: 4968                                         Date: 09-12-93  20:19
  From: Gary Cooper                                  Read: Yes    Replied: No 
    To: ALL                                          Mark:                     
  Subj: MUF Ver. 1.6 #2
ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
2)  FDISK /STATUS ?

    Prints a screen just like using option 4 of fdisk "Partition
    information", but includes extended partition information.
    Nice if you want to get an overview without fear of pressing
    the wrong keys.
                              Armin Hanisch

    Doesn't work in Ver 3.30.

                              Mitch Ames

    FDISK /MBR

    MS-DOS 5.0 FDISK has an undocumented parameter, /MBR, that causes it
    to write the master boot record to the hard disk without altering the
    partition table information. While this feature is not documented, it
    can be told to customers on a need-to-know basis.

    What is the MBR?
 
    At the end of the ROM BIOS bootstrap routine, the BIOS will read and
    execute the first physical sector of the first floppy or hard drive on
    the system. This first sector of the hard disk is called the master
    boot record, or sometimes the partition table or master boot block. At
    the beginning of this sector of the hard disk is a small program. At
    the end of this sector is where the partition information, or
    partition table, is stored. This program uses the partition
    information to determine which partition is bootable (usually the
    first primary DOS partition) and attempts to boot from it.

    This program is what is written to the disk by FDISK /MBR and is
    usually called the master boot record.  During normal operation,
    FDISK only writes this program to the disk if there is no master
    boot record.

    Why is the MBR changed during Setup?

    During installation of Microsoft MS-DOS 5 Upgrade, Setup will replace
    the master boot record on the hard disk with code to display the
    message:

       The MS-DOS 5.0 Setup was not completed.
       Insert the UNINSTALL #1 diskette in drive A.
       Press the ENTER key to continue.

    This message should be erased and the master boot code rewritten
    before Setup is completed. If a problem occurs during Setup and you
    return to the previous MS-DOS, UNINSTAL should also remove this
    message. However, should Setup or UNINSTAL fail to remove this
    message, or should the master boot record become corrupted, a new
    master boot record can be written to the disk using the following
    command:

        C:\>fdisk /mbr

    Warning:  Writing the master boot record to the hard disk in this
    manner can make certain hard disks unusable.  IE: those partitioned
    with SpeedStor, or Microhouse's DrivePro program.  It can also cause
    problems for some dual-boot programs, or for disks with more than 4
    partitions.  Specific information is below.

    WARNINGS:

    This option should not be used if:

       - the disk was partitioned using Storage Dimensions' SpeedStor
         utility with its /Bootall option
       - the disk was partitioned using MicroHouse's DrivePro program AND
         the drive was NOT setup using a standard CMOS value.
       - more than 4 partitions exist
       - certain dual-boot programs are in use

    Storage Dimensions' SpeedStor utility using the /Bootall option
    redefines the drive's physical parameters (cylinder, head, sector).
    /BOOTALL stores information on how the drive has been changed in an
    area of the master boot record that MS-DOS does not use. FDISK /MBR
    will erase that information, making the disk unusable.

    MicroHouse's DrivePro program functions similarly to SpeedStor above, 
    and has the same boot record vulnerability.  MicroHouse identifies their
    boot program at boot-up by a small MICROHOUSE logo near the left side of
    the screen about two-thirds down, at power on.  If you see this logo, 
    do NOT use FDISK /MBR, or the drive will become unusable.

    Some older OEM versions of MS-DOS and some third-party partitioning
    utilities can create more than 4 partitions.  Additional partition
    information is commonly stored information on partitions in an area
    that FDISK /MBR will overwrite.

    Some dual-boot programs have a special MBR that asks the user which
    operating system they want on bootup.  FDISK /MBR erases this program.
    Dual-boot systems that boot whichever partition is marked Active are
    not affected by FDISK /MBR.

                              Edited: MicroSoft Publication
                              forwarded by Don Dean
                              editing suggestions made by
                              Matt Mc_Carthy (info re:
                              MicroHouse's DrivePro)
 
... BUG (n.) An undocumented feature   FEATURE (n.) A documented bug.
___ Blue Wave/QWK v2.12

-!- EzyQwk V1.02
 ! Origin: Programmer's Corner BBS, Saint John, NB  (v32/v42) (1:255/6)

Ä Area: [ECHO] BATCH POWER PROG. ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
  Msg#: 4969                                         Date: 09-12-93  20:21
  From: Gary Cooper                                  Read: Yes    Replied: No 
    To: ALL                                          Mark:                     
  Subj: MUF Ver. 1.6 #3
ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
2)  FDISK /MBR (Continued)

    If you have a Boot Sector Virus, just boot from a known "clean"
    floppy disk (which has the System files and FDISK on it - IE:
    your "disaster recovery disk") and run FDISK /MBR.  Bye, Bye Virus!

                              Gary Cooper

    Make sure it's write protected ..

                              Jasen Betts


    [Begin quote]

    One of the FDISK functions, updating the Master Boot Record (MBR),
    does not appear on any of the FDISK menus. The Master Boot Record is
    located at the beginning of your primary fixed disk. It is composed of
    two parts -- the master boot code and the partition table. The master
    boot code is a short program that determines which operating system
    will start the computer, then transfers control to that operating system.
    The partition table contains information about the partitions located on
    the fixed disk.

    The Master Boot Record may need to be updated when:

    * An operating system other than MS-DOS is on the fixed disk.
      Some operating systems replace the master boot code with their
      own program, which may not allow MS-DOS to start the system,
      even if the partitions are valid DOS partitions. If this condition
      exists, updating the Master Boot Record will replace only the master
      boot code.

    * The information at the beginning of the fixed disk has been
      overwritten. The partition information is destroyed and the fixed
      disk will no longer start any operating system. If this condition
      exists, updating the Master Boot Record will replace both the master
      boot code and the partition table. However, the partition table will
      not have any defined partitions.

    If you cannot get your system to start MS-DOS from the fixed disk and
    you are sure the initialization process was performed correctly, you
    may need to update the Master Boot Record. To do this, enter the
    following command:

         FDISK /MBR

    FDISK does not display any menus or messages while it is updating the
    Master Boot Record. When the procedure is complete, the MS-DOS
    prompt is displayed.

    If you are unable to start MS-DOS from the fixed disk after updating
    the Master Boot Record, you may need to partition and format your fixed
    disk. If you still cannot use the fixed disk to start MS-DOS, contact
    your Authorized COMPAQ Computer Dealer for further assistance.

    [End quote]
                              Compaq DOS 4.01 Manual
                              Submitted by
                              Paul Maserang

    If the situation at hand involved a trashed partition table. This
    regenerates the partition table, but does NOT restore the user
    partition information in it. Therefore, after using FDISK /MBR, you
    must still use FDISK without the /MBR switch to re-enter the partition
    information before you can do anything else. If the newly entered
    partition information is identical to that which existed there prior
    to the partition table being trashed, and nothing else has been damaged,
    there should be no need to reformat the drive, because the boot sector,
    FATs, directories, and data should still be undisturbed. If the boot
    sector or either of the two hidden system files (IBMBIO.COM/IBMDOS.COM 
    or IO.SYS/MSDOS.SYS) are damaged, the SYS command can be used to restore
    them without losing anything else.

                              Paul Maserang
 
... Its not a bug, its an undocumented feature.
___ Blue Wave/QWK v2.12

-!- EzyQwk V1.02
 ! Origin: Programmer's Corner BBS, Saint John, NB  (v32/v42) (1:255/6)

Ä Area: [ECHO] BATCH POWER PROG. ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
  Msg#: 4970                                         Date: 09-12-93  20:23
  From: Gary Cooper                                  Read: Yes    Replied: No 
    To: ALL                                          Mark:                     
  Subj: MUF Ver. 1.6 #4
ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
2)  FDISK /MBR (Concluded)

    Paul, I work _only_ with the Microsoft versions, and have not had the
    same experience.  The /MBR parameter _only_ rewrites the MBR.  It does
    not affect the partition information.  I use it daily on various
    machines and have not lost one byte of data.

                              Matt Mc_carthy

    I guess you didn't know that "Master Boot Record" and "Partition Table"
    refer to the same thing.  What you're talking about is the master boot
    CODE, the executable code that accompanies the partition table and is
    located on the same physical sector (0).

    Here's what I find in the first few bytes of my physical sector 0
    (unassembled with DEBUG after copying the sector to a file):

    2BB7:0100 33C0            XOR     AX,AX
    2BB7:0102 FA              CLI
    2BB7:0103 BED0            MOV     SS,AX
    2BB7:0105 BC007C          MOV     SP,7C00
    2BB7:0108 BEC0            MOV     ES,AX
    2BB7:010A BED8            MOV     DS,AX
    2BB7:010C FB              STI
    2BB7:010D 8BF4            MOV     SI,SP
    2BB7:010F BF0006          MOV     DI,0600
    2BB7:0112 B90002          MOV     CX,0200
    2BB7:0115 FC              CLD
    2BB7:0116 F3              REPZ
    2BB7:0117 A4              MOVSB
    2BB7:0118 EA1D060000      JMP     0000:061D

    I also find the following text in the first half of the sector:

        Missing operating system.Error loading operating system.Invalid
        partition table.Author - Siegmar Schmidt

    I have only one partition on my C: drive, and its information is in
    the last of four possible positions in the partition table. The first
    significant byte (non-zero) is at offset 01EEh in physical sector 0.
    The rest, from offset 00EDh to 01EDh is nothing but 00h.

    So it would appear that everything from offset 0000h to 00ECh is the
    Master Boot CODE, and everything from 00EDh to the end of the sector
    (01FFh) is the Master Boot RECORD (aka partition table). More likely,
    the partition table probably begins at offset 0100h, and takes up the
    last 256 of the 512 bytes available in the sector.

    Beginning with the first significant byte of my partition table (at
    offset 01EEh), this is what mine shows:

       80 01 01 04 03 91 65 11 00 00 00 07 A3 00 00 55 AA
       ^^
    This first byte, I think, is the drive on which this partition
    is located, and the next byte might indicate that this is the
    first (primary) partition (in my case, the ONLY partition for
    this drive).

    Now, according to my manual, FDISK /MBR can either re-write only
    the Master Boot CODE when necessary; or it can re-write both the
    Master Boot Code AND the Master Boot RECORD, if it determines that
    the partition table has been corrupted.

    If it does re-write both, then you do have to use FDISK without
    the /MBR switch after using it with the switch, because the
    re-written partition table has no defined partitions until you do.
    But when you use the /MBR switch, it produces no screen output
    (at least not on the version I'm using), so you don't know whether
    it did both or just the code. So you should still check to see that
    you have a valid partition by using FDISK without the /MBR switch
    afterwards.

                              Paul Maserang
===============================================================================
 
... Life has a lot of undocumented features!
___ Blue Wave/QWK v2.12

-!- EzyQwk V1.02
 ! Origin: Programmer's Corner BBS, Saint John, NB  (v32/v42) (1:255/6)

Ä Area: [ECHO] BATCH POWER PROG. ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
  Msg#: 4971                                         Date: 09-12-93  20:24
  From: Gary Cooper                                  Read: Yes    Replied: No 
    To: ALL                                          Mark:                     
  Subj: MUF Ver. 1.6 #5
ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
3)  SHELL=C:\COMMAND.COM /E:1024 /F /P

    The /F in your Config.sys SHELL= statement is another undocumented
    feature.

    It forces a "Fail" response to the "Abort, Retry, Fail" prompt issued
    by the DOS critical error handler.

                              Dennis McCunney

    The /F switch on the SHELL command in CONFIG.SYS will not work in
    a DESQview environment. The only thing I have found that will is a
    program called FATAL.COM.

                              Bruce Bowman

    COMMAND /F

    Makes all those annoying "Abort, Retry, Ignore, Fail?"
    disk error messages default to "Fail".

                              Erik Ratcliffe

    For DOS 3.30 (somebody might care to check these for other versions):

    COMMAND /P

       Docs say that this doesn't allow you to exit back to the
       previous shell (ie /Permanent), but /P also forces
       \autoexec.bat to be run on secondary shells.

    COMMAND /D

       (When used with a primary shell, or secondary with /P)
       prevents execution of \autoexec.bat

                              Mitch Ames

    I just checked, and these also both apply to DOS 5.00

                              Mitch Ames

===============================================================================
4)  VER/R

    Yields extended information about the OS Version.  IE:

    MS-DOS Version 5.00
    Revision A
    DOS is in HMA

                              Billy Gilbreath

    Doesn't work with DOS 3.30

                              Mitch Ames

===============================================================================
5)  ECHO OFF     from the command line erases the prompt and leaves
                 just a cursor on the screen.

    ECHO ON      from the command line restores the prompt.
 
    This works with all version of DOS (tested so far!).

                              Michael Larsson

    One of the most frequently asked questions in the BatPower echo
    is "How do I ECHO a blank line?"  The most common answer is "ECHO."
    However, I have captured a few posts which expand on the
    possible answers to this request:

                              Editor's Note

    ECHO"

                              Paul Welsh

    just about any white space character will work. 

                              Alan Newbery

    I just found out myself that any delimiter will work here
    (ECHO. ECHO" ECHO, ECHO: ECHO; ECHO[ ECHO] etc.).  Apparently
    it's just the way that the command handles the delimiter and
    has been available from way back.  Microsoft just began
    mentioning it in the documentation recently, though, and their
    examples use a period.

                              John Whitfield
===============================================================================
 
... _My_ software never has bugs.  It just develops random features...
___ Blue Wave/QWK v2.12

-!- EzyQwk V1.02
 ! Origin: Programmer's Corner BBS, Saint John, NB  (v32/v42) (1:255/6)

Ä Area: [ECHO] BATCH POWER PROG. ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
  Msg#: 4972                                         Date: 09-12-93  20:26
  From: Gary Cooper                                  Read: Yes    Replied: No 
    To: ALL                                          Mark:                     
  Subj: MUF Ver. 1.6 #6
ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
6)  FORMAT

    FORMAT /H

        In DOS 3.30 (I don't know about other versions), FORMAT /H
        will cause the format to begin immediately after pressing Y
        in response to "Format another?", rather than displaying
        "Place disk to be formatted in drive A: and press Enter" on
        a second and subsequent disks.

                              Mitch Ames

        On 5.0 it comes back as "invalid switch".

                              John Mudge

    FORMAT A: /AUTOTEST

        The autotest parameter will allow format to proceed, checking
        existing format (unless the /u parameter is also present) and
        proceeding with the format.

        All this will take place with no delay and no waiting for user
        input.  It will also end without pausing.  It will not ask for
        a volume label or whether to format another diskette.

        WARNING!  This procedure will also work on hard drives!  Be very
        cautious if you plan to use this feature.

                              Wayne Woodman

        Problem is that it won't take any other switches like /U, /S or
        /Q which is a bit of a shame really.

                              Peter Lovell

        With Dos 5 it certainly takes /u and /s as I have used it, in
        fact I think /u is required if the disk is not pre-formatted as
        the drive hangs up otherwise.

        I would agree about /q though, this does not work and gives the
        error message you quote.

                              Terry Kreft


        FORMAT/U is not available in DOS 3.30

                              Mitch Ames

    FORMAT C: /BACKUP

        This week I've read some articles in Dutch computer magazines about
        MUF's which are very interesting (if you don't already know about
        them).

        I already knew the FORMAT option /AUTOTEST, but new to me was the
        /BACKUP option.

        EXAMPLE: FORMAT A: /BACKUP

        It seems to work exactly like /AUTOTEST, but it DOES ask for a
        volume label.
                              Willem Van.den.broek
  
    FORMAT/SELECT

        is like DOS-Mirror  ... for safety-fanatics only

    FORMAT/SELECT/U

        makes disks unreadable (remember the U)

                              Reinhard Kujawa
                              Info from The German magazine PC PRAXIS

    FORMAT A: /SPACE

        On IBM DOS v6.01 the command:

        FORMAT A: /SPACE

        puts a 12288 byte file named MIRROR.FIL on the disk ...

        So, the command:

        FORMAT A: /U /SPACE

        just ruins the durn diskette!  A subsequent "DIR A:" gives you a:

          General failure reading drive A
          Abort, Retry, Fail

                              Vernon Frazee
===============================================================================
 
... Hidden OLR feature: CTRL-ALT-DEL to view BBS user password file.
___ Blue Wave/QWK v2.12

-!- EzyQwk V1.02
 ! Origin: Programmer's Corner BBS, Saint John, NB  (v32/v42) (1:255/6)

Ä Area: [ECHO] BATCH POWER PROG. ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
  Msg#: 4973                                         Date: 09-12-93  20:28
  From: Gary Cooper                                  Read: Yes    Replied: No 
    To: ALL                                          Mark:                     
  Subj: MUF Ver. 1.6 #7
ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
7)  DRIVPARM /c

    Syntax:  DRIVPARM /d:number [/c] [/f:factor] [/h:heads] [/i] [/n]
             [/s:sectors] [/t:tracks]

    /d:n   refers to the drive NUMBER (0=A:, 1=B:, 2=C:, etc...) of the drive
           whose parameters you are changing (in your case, it would be 2 for
           B:).

    /c     is the switch I was referring to for change line support.  IF YOU
           INCLUDE /c, YOU ARE TELLING DOS THAT YOUR COMPUTER *CAN* TELL
           WHETHER THE DRIVE DOOR HAS BEEN OPENED SINCE THE LAST ACCESS.

    /i     specifies an electronically-compatible 3.5 inch floppy disk-drive.
           You should use it if your computer's ROM BIOS does NOT support 3.5
           floppy diskette drives.

    /n     specifies a NON-removable block device

    The other parms are similar to DRIVER.SYS

                              IBM Technical Publication Information
                              forwarded by Andrew Barnhardt

    The '/C' switch doesn't actually check to see if the drive -door-
    has been opened or not, but it does make another check to see if
    the disk in there now is different from the one when the drive was
    last accessed.  I have to use that switch with my 5 1/4 floppy
    because it's an older drive working with a new motherboard (at
    least that's the explanation I've heard).

                              Andrew Barnhardt

    Does DRIVPARM return an errorlevel, or give a warning message?

                              Gary Cooper

    No, not that I'm aware of.  You insert the drivparm command in
    your CONFIG.SYS file.  Just DRIVPARM=xx xx ...

                              Andrew Barnhardt
===============================================================================
8)  IF EXIST

    IE: IF EXIST EMMXXXX0 GOTO APPLICATION

    This is a handy quirk of DOS - installable drivers are seen as files
    in all directories.  You can use the if exist test to either test for
    the existence of a directory, with "if exist <dirname>\nul", (which
    fails if the directory does not exist because the nul device is not
    found,) or to test whether a driver is loaded.

    Caveats:  you need to know the name of the directory or the driver
    whose existance you are testing, and this is MS/DOS specific - it
    doesn't work on network drives, and may not work under DR-DOS.

                              Gary Marden

    This works definitely under DRDOS:

              DR DOS Version 6.0
              Copyright (c) 1976,1982,1988,1990,1991 Digital Research Inc.
              Alle Rechte vorbehalten.

              C:\>if exist emmxxxx0 echo ja
              ja

                              Wolfram Serber

    Where did you learn the "EMMXXXX0" name from?

    Instead of typing MEM /C, type MEM /D for the "debug" listing.
    That should give the names you're looking for.

                              Erik Ratcliffe

    The trouble is, EXISTS returns TRUE for COM3/4 and LPT2/3 even
    though the hardware does not exist.

                              Rudy Lacchin
===============================================================================
 
... Aha! Another 'undocumented feature'!
___ Blue Wave/QWK v2.12

-!- EzyQwk V1.02
 ! Origin: Programmer's Corner BBS, Saint John, NB  (v32/v42) (1:255/6)

Ä Area: [ECHO] BATCH POWER PROG. ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
  Msg#: 4974                                         Date: 09-12-93  20:30
  From: Gary Cooper                                  Read: Yes    Replied: No 
    To: ALL                                          Mark:                     
  Subj: MUF Ver. 1.6 #8
ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
9) SWITCHES

    SWITCHES=/W

        Enables you to have your WINA20 file anywhere on your boot
        drive.  Without this you have to have it in the root directory.

                              Erik Ratcliffe

         You should also mention that this one should not be used with
         Windows 3.1. I've noticed a lot of people who do, and it wastes
         around 120K of UMBs.

                              George Hannah

         This is documented in DOS 6.0

                              Richard Pade

    SWITCHES=/F

        Do you know that there is a rarely known switch called /F?
        If you put this line:

              SWITCHES=/F

        as the first line in your CONFIG.SYS, MS-DOS would not delay 2
        seconds, but immediately start processing your CONFIG.SYS. This
        trick has no other effects (AFAIK), but those who DO know better,
        correct me if I'm wrong!

                              Samuel Tan Yi Hsuen

        But where would you put the switch, it's not like you load a device
        driver that early in boot up do you?

           RF? Beats me. I think it goes in the SHELL= statement. Just don't
           RF? remember what character you use. I saw it mentioned in the
           RF? Tech conference /K maybe?

        No, it's SWITCHES=/F, right?

                              Paul Senechko 

        Actually, its both:

            /W allows you to move the WINA20.386 file
            /K makes your AT Keyboard act like a XT
            /F Disables the wait
            /N Disables F5/F8 exiting

        and to use any just put the command SWITCHES= and the parameters
        on the first line of your config.sys (Can go on other lines, but for
        the /F and /N you need it at the first line....), also the Switches
        command IS compatible w/ DOS 5, but only using the /W & /K options

                              John Guillory

===============================================================================
10) FOR IN DO

          for %%z in (test1 test2 test3) do goto %%z
          goto end
          :test1
          echo test1
          :test2
          echo test2
          :test3
          echo test3
          :end

     When I posted this explaining the traps and pitfalls
     of FOR IN DO, something got lost. GOTO commands in FOR IN DO
     statements do not work correctly / as expected. This fragment
     will work in 4DOS, but not with COMMAND.COM. You've seen
     what happens when running under COMMAND.COM already. 4DOS
     will display test1 test2 test3.

     So, that's what I was trying to explain: that GOTO's don't work
     right, and that IF's will break FOR IN DO's.

                              Bill George
===============================================================================
 
... Any sufficiently advanced bug will become a feature.
___ Blue Wave/QWK v2.12

-!- EzyQwk V1.02
 ! Origin: Programmer's Corner BBS, Saint John, NB  (v32/v42) (1:255/6)

Ä Area: [ECHO] BATCH POWER PROG. ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
  Msg#: 4975                                         Date: 09-12-93  20:32
  From: Gary Cooper                                  Read: Yes    Replied: No 
    To: ALL                                          Mark:                     
  Subj: MUF Ver. 1.6 #9
ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
11) FOR %%V IN /SOMETHING

    ... quoting Dirk Treusch to All ...

    How can a batch file (without 4DOS) determine from which drive it has
    been started?

    Example: C:\> a:test.bat

    Now my batch should be able to find out that it is located on drive A:
    (not the path - only drive!).

    Mitch Ames responds:

    The variable %0 contains the name of the batch file
    _as_it_was_typed_at_the_command_line.  If you call the batch file as
    A:TEST.BAT, %0 will be "A:TEST.BAT".  If you have the directory on
    your path, and simply type TEST, then %0 will be "TEST".  The drive,
    path and extension will only appear in %0 if you enter them in the
    command used to call the batch file (either typed at the command
    line, or called from another batch file).

    So you _must_ specify the drive as part of the batch filename for
    this to work.  To extract the drive only, use STRINGS, or similar (I
    don't have a copy, so don't ask me to post it).  Alternatively use
    the undocumented FOR %%V in /SOMETHING command, eg:

          set drive=
          for %%v in (/%0) do call test2 %%v
          echo Calling drive is %drive%

    where TEST2.BAT is:

          if not '%drive%'=='' set drive=%1:

    Disclaimer - I haven't tested this.  Debugging is up to you.

    (You can, of course, fit this into a single recursive batch file -
    but that's left as an exercise for the student.)

    FOR %%V IN (/SOMETHING) DO WHATEVER will do WHATEVER twice - the
    first time with %%V set to the first character in SOMETHING ("S"),
    the second time with all the remaining characters in SOMETHING
    ("OMETHING").  If SOMETHING is only a single character, WHATEVER will
    only be called once, with that character in %%V.  If the single
    character is a wildcard (? or *) that wild card will _not_ be
    expanded to a set of filenames.  (The main purpose of this feature is
    apparently to allow inclusion of the literal characters "?" and "*" 
    without them being expanded.)

    This works in DOS 3.30 and 5 - I don't know about other versions.

                              Mitch Ames

===============================================================================
12) LEADING SLASH WITH FOR IN DO LOOP

    In the FOR statement in the INIT and COUNT routines below the
    parameters in the () show a leading "/".  This seems to separate
    the first digit of the environmental variable used within the
    brackets ().  Am I correct? Is this documented anywhere?

    :================= INIT =================
    set &=%4&|set n$=%4|set m$=%3|set #=%2|set !=%0
    if not '%m$%'=='0' for %%a in (/%m$%z) do if '%%a'=='0' set @=0
    %!%
    :================= COUNT ================
    if '%&%'=='&' goto PROCESS
    for %%a in (/%&%) do set &=%%a

                              Peter Joynson
      
    I have read some articles about this in PC Computing & PC Magazine.
    I don't believe it is documented anywhere but you're right, it strips
    off the first character of whatever string is passed.  I will try to
    find one of the articles that explains it better if you need it.

                              Robert Hupf

    Correct.  I believe it is not documented (up to DOS 5 anyway) by MS,
    but I have read from other sources that the leading / will split an
    item into the first character and everything else.  Eg:

            for %%n in (/hello there) do echo %%n

    will display "h", "ello" and "there".  "There" is not split because
    it is a separate item, delimited by the space.  If used with an item
    including wildcard (? or *) characters the item will not be expanded
    to the files which match it, thus allowing inclusion of those
    characters in the set.  Eg:

            for %%n in (/? /*.bat hello) do echo %%n

    will display "?", "*", ".bat", "hello".  This apparently is the
    original reason for the feature, but it may also be used recursively
    to parse a string one character at a time.

                              Mitch Ames
===============================================================================
 
... Features should be discovered, not documented.
___ Blue Wave/QWK v2.12

-!- EzyQwk V1.02
 ! Origin: Programmer's Corner BBS, Saint John, NB  (v32/v42) (1:255/6)

Ä Area: [ECHO] BATCH POWER PROG. ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
  Msg#: 4976                                         Date: 09-12-93  20:34
  From: Gary Cooper                                  Read: Yes    Replied: No 
    To: ALL                                          Mark:                     
  Subj: MUF Ver. 1.6 #10
ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
13)  ATTRIB

    ATTRIB +h dirname

    Is there anyway to create a hidden directory on a hard drive?

    I've since learned that DOS 5.0 ATTRIB can do the same thing
    from the command line:  ATTRIB +h dirname.

                              Gary Smith

    ATTRIB ,

    attrib ,|echo y|del *.*

    It is not really piping the output of attrib to echo.  Using the pipe
    is one way of stacking multiple commands on one line.  All the "attrib ,"
    does is reset _ALL_ attributes on _ALL_ files in the current directory.
    So if you were to run that from the root of your c: drive you would no
    longer have a bootable drive.

                              Jim Banghart

    Worked fine here, took out all the files (system, hidden, read-only),
    like a dream with no lock up, using MSDos 5.0

                              Terry Kreft

    I do not recommend this practice. It does attempt to pipe the output
    of attrib to echo, and thus writes a file to the directory specified
    by the environment variable TEMP. If you try to run this program in
    your TEMP directory, you will get a sharing violation. It also
    actually slows your program, because it has to write and delete a
    useless file (unless you have your TEMP on a ramdisk).

    I can't say I see much reason for stacking commands like this -- put
    the commands on separate lines. A character is a character, be it a
    carriage return or a pipe, and your files will be easier to understand.

                              Bruce Bowman
===============================================================================
14) INSTALLHIGH

    I think I may have found an undocumented feature for DOS 6....
    I wasn't able to find this anywhere in the online help.  It's
    called INSTALLHIGH= and amazingly enough it works just like
    INSTALL= but loads the file high!

    The only drawback to this is: Memmaker will not go through and
    add switches for that particular line during the "optimizing
    process".  It just takes it as it is currently.  But then again
    INSTALL= is ignored too!

    Example:
    DEVICE=C:\DOS\HIMEM.SYS
    DEVICE=C:\DOS\EMM386.EXE NOEMS HIGHSCAN WIN=F500-F7FF WIN=F200-F4FF
    dos=HIGH
    dos=UMB
    installhigh=c:\dos\share.exe

                              Robin Francis

    MUF reported in the magazine C'T:  You can use the DOS 6.0 command
    "installhigh" in config.sys to load TSR programs into UMA. A 48 byte
    environment will be added for every program.  If you use it you don't
    need the "loadhigh" in autoexec.bat any more.

    But Memmaker can't handle installhigh!

                              Thomas Erbe

    Further to Robins explanation, INSTALLHIGH cannot be directed to a
    specific UMB area and thus defaults to largest currently available.
    Like INSTALL it is processed (about) last of C.SYS lines and causes
    more consumed RAM overhead than calling TSR from A.BAT or later.

                              Richard Pade

    There is an undocumented CONFIG.SYS command called INSTALLHIGH. It
    is similar to INSTALL except that it will load the TSR into an UMB.
    It is available under DOS 6. However, it does not support the
    /L and /S switches that DEVICEHIGH and LOADHIGH support.

                              Tom Dyas

    Then it is useless, isn't it? It has less than the capabilities of
    LOADHIGH and DEVICEHIGH but load the same TSRs that they load ... no
    wonder it is an undocumented command.

                              Wayne Moses

    Just wondering, does INSTALLHIGH work with Microsoft DOS 5? It
    would also be nice to know why it is undocumented. It doesn't do
    anything major! Microsoft gains nothing by keeping it undocumented.
    Loading TSR's from CONFIG.SYS is better because an environment is
    not allocated for the TSR. A very small amount of memory is
    conserved, but it is still conserved.

                              Tom Dyas
===============================================================================
 
... DOS 6.0 - DOS 4.01 with its features documented.
___ Blue Wave/QWK v2.12

-!- EzyQwk V1.02
 ! Origin: Programmer's Corner BBS, Saint John, NB  (v32/v42) (1:255/6)

Ä Area: [ECHO] BATCH POWER PROG. ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
  Msg#: 4977                                         Date: 09-12-93  20:35
  From: Gary Cooper                                  Read: Yes    Replied: No 
    To: ALL                                          Mark:                     
  Subj: MUF Ver. 1.6 #11
ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
15) : (command)

    DOS uses a leading : to indicate a label.  If the next character
    following the : is a space or other non-alphanumeric char, DOS
    will decide it's an invalid label and skip to the next line,
    performing no further action.

                              Dennis Mccunney
===============================================================================
16) PATH

    With MS-Dos 6.0 you CAN exceed the normal path length limit by
    putting a "Set Path=C:\;..." in your Config.Sys file instead of
    your AutoExec.Bat file.  The usual limits do not apply there.

    I have put in a path well over 800 characters and it works fine.
    The path doesn't display correctly via PATH or SET, but it's in
    there and it all gets searched.

    I don't recommend having a path that long, mine is normally
    only 6-8 directories.

                              Andrew Barnhardt
===============================================================================
17) EDLIN

    where an EDLIN script is:

           -1,#r 1:^Z  1:
           -1,#r 2:^Z  2:
           -1,#r 3:^Z  3:
           -1,#r 4:^Z  4:
           -1,#r 5:^Z  5:
           -1,#r 6:^Z  6:
           -1,#r 7:^Z  7:
           -1,#r 8:^Z  8:
           -1,#r 9:^Z  9:
           e

    Note the spaces (one after R, two after ^Z) which prevent replacement
    of the second digit in a two digit number.

    This will update the last line only, so needs to be done at each
    boot.  '#' means last line +1. '-1' means the line before the current
    one (ie: the last line of the file, if "#" is the current line).  Note
    that you can only use '-1' in later versions (it works in 5, but not
    in 3.30 as far as I know).

                              Mitch Ames
===============================================================================
18) DELIMITING CHARACTER:

    Prior to DOS 5.0, there was an undocumented DOS function that
    would allow you to set the DOS option delimiting character to
    something else, like -.  Once you did this, you could use either
    \ *or* / in PATH specs.

    DOS 5.0 removed the function to *set* the option delimiter, but
    *retained* the one to query what it currently is!  (Don't ask me,
    ask M'Soft...)  Fortunately, the MKS Toolkit still works with no
    apparent glitches.

    I believe in pre-DOS 3.X versions that there was a parm you could
    provide in CONFIG.SYS to do this, but have no further details.

    Just remember: "undocumented" is a synonym for "unsupported, and
    not guaranteed to be there next release", which is what happened
    in the case I mentioned above.

                              Dennis Mccunney
===============================================================================
19) REM IN LINES WITH PIPES OR REDIRECTS

    ie:    REM echo y | del *.*

    Michael Serber reported that he encountered problems when
    he tried to REM out an "echo y|del *.*" line in his batch
    file.  Here is the content of some of the responses he 
    received in response to his question asking why he experienced
    the problem:

    It (the problem) appears to only occur if there is a pipe or
    redirection in the line (REM'd out), leading me to believe that
    DOS first handles pipes and redirections, then goes back to
    find out what to do with them.

                              John Mudge

    It's actually doing what it thinks you've told it: piping the
    output of REM to DEL.  Since REM _has_ no output (remember
    REM > NULLFILE?), DEL hangs, waiting for the answer to its
    question.

                              Gary Smith

    What is happening here is that DOS reads the entire line, and
    always processes redirection and piping *first*, regardless of
    where they happen to appear.

                              Dennis Mccunney
===============================================================================
 
... That's not a bug! It's a seldom-used, undocumented feature!
___ Blue Wave/QWK v2.12

-!- EzyQwk V1.02
 ! Origin: Programmer's Corner BBS, Saint John, NB  (v32/v42) (1:255/6)

Ä Area: [ECHO] BATCH POWER PROG. ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
  Msg#: 4978                                         Date: 09-12-93  20:38
  From: Gary Cooper                                  Read: Yes    Replied: No 
    To: ALL                                          Mark:                     
  Subj: MUF Ver. 1.6 #12
ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
20) CALL

    The DOS 5.0 manual, in the command reference for CALL, states:

    Syntax: call [drive:][path]filename [batch-parameters]

            Parameters [drive:][path]filename

            Specifies the name and location of the batch program you
            want to call.  Filename must have a .BAT extension.

            The latter sentence is not true in DOS 5.0.  CALL works
            equally well whether "filename" is a .BAT, .COM, or .EXE
            file, or even internal command the following all work
            just fine:

            call dir
            call mem
            call tree
            call echo Phhhhhhht!

                              Gary Smith

===============================================================================
21) CHOICE

    I blundered onto an interesting choice.com feature:

        CHOICE /C:XM*; /N /T:2,5
        if errorlevel=4 goto help
        if errorlevel=3 goto end
        ......etc

        The "*" is the escape key, and the ";" is F1 etc.

                              Robert Lindsay

===============================================================================
22) MEM /A

    If you do a MEM /A it'll give you details of what's in the first meg
    of memory.

    Windoze owners get MSD.EXE (a pretty undocumented utility), that tells
    you this sort of thing.  If you do a MEM /A it'll give you details of
    what's in the first meg of memory.

                              Ben Davis

===============================================================================
23) MOUSE /U

    Microsoft mouse driver version 8.1 has a /U switch.  Adding that switch
    loads all but 3.3k of the driver into HMA.  It's not quite the most
    recent version mouse driver, but hey, a mouse driver is a mouse driver
    is a mouse driver, right?  Especially when it only takes 3.3k of ram!

                              Mark Carter

    Are you getting that result by loading the mouse driver high on a 286?
    If so, that is good news. Mine takes up 12k of main RAM (MS mouse
    driver ver. 7.0).

                              Gerry Pareja

    Mouse 8.0 _is_ able to load itself into HMA (I think) on a 286 by using
    the undocumented /U switch. I read it in PC Magazine sometime back.
    Also, PC Mag said that the BUFFERS have to be set to a low value, e.g. 5.

                               Ng Cheng Kiang
===============================================================================
 
... All On-Line readers, press the un-documented ALT-H combination now...
___ Blue Wave/QWK v2.12

-!- EzyQwk V1.02
 ! Origin: Programmer's Corner BBS, Saint John, NB  (v32/v42) (1:255/6)

Ä Area: [ECHO] BATCH POWER PROG. ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
  Msg#: 4979                                         Date: 09-12-93  20:40
  From: Gary Cooper                                  Read: Yes    Replied: No 
    To: ALL                                          Mark:                     
  Subj: MUF Ver. 1.6 #13
ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
24) %0

    Note that %0 is (almost) always defined as the name of the batch file
    itself (including drive\directory as typed at the command line).  The
    only time %0 is not defined is in Autoexec.bat when run by
    Command.com at boot time (or command/p).

                              Mitch Ames

    The %0 parameter is the name of the program.  But wait, there's
    more.  If you want to test for the name of the program you are in!
    What do your want to test for?

    One time you type "edit", another you type "EDIT", another "EDIT.BAT",
    another "C:EDIT.BAT", and another "C:\BELFRY\EDIT.BAT".  How many
    combinations do you want to test for at the start of your batch file?

    You can map the file name to upper case and take care of some of the
    problem as follows:

        SET SAVEPATH=%PATH%
        PATH %0
        SET PROGNAME=%PATH%
        PATH %SAVEPATH%
        SET SAVEPATH=

    To do the test, something like this might work:

        FOR %%E IN (EDIT EDIT.BAT C:EDIT C:EDIT.BAT C:\BELFRY\EDIT ...
               ... C:\BELFRY\EDIT.BAT) DO IF '%%E'=='%PROGNAME%' GOTO HIT
        ECHO BAD COMMAND OR FILE NAME
        GOTO ENDIT
        ...
        :HIT
        REM START EXECUTION HERE....

     There is one last gotcha to %0.  When AUTOEXEC.BAT is run by the bootup
     sequence, %0 has no value.  This is important if you want to find out if
     you are in AUTOEXEC.BAT, and if you are in AUTOEXEC.BAT for the first
     time.

     I have seen this work with IBM's PC-DOS 3.10, various flavors of
     MS-DOS 3.10, 3.30, 3.31, 4.01, and 5.00.  It also seems to work
     with DR-DOS 6.0.  As to 4DOS, I have no idea, but would welcome
     feedback on the matter (although 4DOS and DR-DOS hardly qualify
     for a MUF entry....)

                              Mike Avery

    So far as I know, it's not been documented anywhere 'officially',
    but I did read about it in an article sometime back, probably
    either in PC Magazine or in PC Computing.

                              Gary Smith

    I've never seen it documented - it just bit me one day REAL HARD!
     
    Well, the way I figured it was that when the boot process hands control
    to AUTOEXEC.BAT, the normal command line interface isn't used, so %0
    never gets set.

                              Mike Avery

    This feature can actually be useful, because you can put
    statements like this in your autoexec:

       if NOT (%0) == () goto skip
       [statements that should not be re-executed go here]
       :skip
       [statements that can be re-executed go here]
       path ...
       set ...
       etc.

    Then you can recreate your bootup environment at any time by
    simply typing AUTOEXEC.

                              Gary Smith
===============================================================================
 
... Bill Gates and his search for undocumented Windows 3.1 code...
___ Blue Wave/QWK v2.12

-!- EzyQwk V1.02
 ! Origin: Programmer's Corner BBS, Saint John, NB  (v32/v42) (1:255/6)

Ä Area: [ECHO] BATCH POWER PROG. ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
  Msg#: 4980                                         Date: 09-12-93  20:44
  From: Gary Cooper                                  Read: Yes    Replied: No 
    To: ALL                                          Mark:                     
  Subj: MUF Ver. 1.6 #14
ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
25) , . ...

DIR,    Using a comma IMMEDIATELY after DIR, shows ALL files, including
        the HIDDEN ones.

        EXAMPLE: DIR,

                              Willem van den Broek

        This appears only to work with version 5.  I tried it with 3.30,
        and it didn't display either IO.SYS, MSDOS.SYS (both with S, H
        and R attribs) or a test file with A and H attribs.

        With version 5 it displayed the test file with H and A, but would
        not display IO.SYS or MSDOS.SYS with S, H and R.  This doesn't
        surprise me actually, since S alone (without H) will prevent
        inclusion of a file in a normal DIR.

        I didn't try version 4.

                              Mitch Ames

        Interesting: it does for me (display DOS5 IO.SYS and MSDOS.SYS):
        However, 4DOS does not do it:

                              Dennis Mccunney

        It was pointed out in the 4DOS echo, and there were people
        who said it didn't work for them.   But, on my machine
        running straight dos6, it works! DIR, (dir comma) in my C:\
        shows all files including hidden and system.

                              Bill George

DIR..   With DOS 6.0 you can get a directory of -all- files (hidden,
        system, etc.) with this command.

        It was in a PC/Mag. or PC/Comp. issue not too long ago.

                              Andrew Barnhardt

        Have you noticed also how DIR... only displays directories, not
        files?

                              Gary Marden

        That's pretty slick. I tried DIR.. and got the parent 
        directory. DIR... got the current directory subdirs only.

                              Bill George

        Works for any level of directories. ".." will go to the previous
        directory as with pure DOS, "..." will go to the directory before
        the previous and so on.

                              Ng Cheng Kiang

        In DOS 5.0 it displays directories and files with no extensions.
        I tried "DIR ...", "DIR...", and "DIR ....".  They all behave
        the same way.

                              Gary Smith

        With DOS 5.0 and NDOS 6.0 DIR... gives me a list of
        subdirectories off of the root and a list of all files in
        the root directory, regardless of the file extension.
        It will yield this result regardless of what directory / 
        subdirectory I am in at the time the command is issued.

                              Gary Cooper
        
        COMMAND.COM generally seems to ignore excess characters.  Try
        copying something the AIRPLANES.PLAN, for example, and see what
        happens.

                              Gary Smith

        While I was playing around with "dir ..." and trying to see how
        it parses to showing all extensionless entities in the current
        directory, I noticed that DIR doesn't care if a specified directory
        structure exists or not, as long as the overall structure points
        back to something that does exist, i.e.

            "dir \thisdirdoesnotexist\.."

        will ignore the garbage and show the root directory.  If
        c:\bat exists, then

            "dir c:\bat\thisdirdoesnotexist\nordoesthisone\..\.."

        will show the c:\bat directory.

        Again, absolutely useless as far as i can tell <g>, but interesting.

        BTW, has anybody solved the "dir ..." mystery yet?  I also noticed
        "dir \..." works while "dir \bat\..." fails (any explicitly specified
        directory other than the root generates an "invalid directory"
        message).

                              Paul Leonard
===============================================================================
 
... WOMAN.ZIP....Great program, no documentation! 
___ Blue Wave/QWK v2.12

-!- EzyQwk V1.02
 ! Origin: Programmer's Corner BBS, Saint John, NB  (v32/v42) (1:255/6)

Ä Area: [ECHO] BATCH POWER PROG. ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
  Msg#: 4981                                         Date: 09-12-93  20:48
  From: Gary Cooper                                  Read: Yes    Replied: No 
    To: ALL                                          Mark:                     
  Subj: MUF Ver. 1.6 #15
ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
26) COPY. A:

    The use of a decimal point IMMEDIATELY after some DOS statements,
    will replace *.*

    EXAMPLES: DEL.       (erase all files in current directory)
              COPY. A:   (copy all files in current directory to A:)

    There may be more statements with which it works, but I haven't
    tried them yet.

                              Willem van den Broek

    "." means the current directory, and Command.com will assume that
    \directory implies \directory\*.* for most commands where a
    filename(s) should be specified, eg:

    DIR \ is the same as DIR \*.*
    COPY \FRED is the same as COPY \FRED\*.*
    COPY. A:\ is the same as COPY .\*.* A:\ which is the same as COPY *.* A:\
    DEL. is the same as DEL .\*.* which is the same as DEL *.*

                              Mitch Ames

    Have you noticed also how DIR ... only displays directories, not files?

                              Gary Marden

    In DOS 5.0 it displays directories and files with no extensions.
    I tried "DIR ...", "DIR...", and "DIR ....".  They all behave
    the same way.

                              Gary Smith

    Another good thing is you can travel from directories to
    directories without typing "CD".  Just type the directory name
    followed by a backslash '\'.

    Example: To go from C:\BATCH to C:\WP51, you type "\wp51\".
    That's it!  fast and easy.

                              Marc Y. Paulin

    If you are in the following directory :

        \WORD\FILES\LETTERS\APRIL

    And wanted to go to the directory \WORD\FILES, you'd normally 
    type two lines : 

         CD \
         CD WORD\FILES

    Or even the single line "CD \WORD\FILES" to combine the two 
    commands into one. There is a shorter way, simply type the 
    following : CD ..\..     You're there !

                              Andrew Barnhardt
           
    In DOS 5.0, it displays files and directories which have no extension.

                              Larry Kessler

    On this machine with DOS 5.0 and NDOS 6.0 DIR... gives me a list of
    subdirectories off of the root and a list of all files in the root
    directory, regardless of the file extension.  It will yield this result
    regardless of what directory/subdirectory I am in at the time the command
    is issued.

                              Gary Cooper

    Editor's Note:

    I admit that "features" in the last two MUFs may be documented
    (although obscure feature), the reason that it continues to be
    seen in the MUF list is because I believe that the ability to use
    the period immediately IE: COPY. is not documented.  What is
    documented is the fact that "." and ".." can be used to represent
    the current and parent directories respectively, and these will work
    with many applications which can handle directory names as arguments.
    In this case the "." could also be viewed as a replacement for "*.*"

===============================================================================
 
... Documentation - The worst part of programming.
___ Blue Wave/QWK v2.12

-!- EzyQwk V1.02
 ! Origin: Programmer's Corner BBS, Saint John, NB  (v32/v42) (1:255/6)

Ä Area: [ECHO] BATCH POWER PROG. ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
  Msg#: 4982                                         Date: 09-12-93  20:49
  From: Gary Cooper                                  Read: Yes    Replied: No 
    To: ALL                                          Mark:                     
  Subj: MUF Ver. 1.6 #16
ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
27) MULTIPLE DOS COMMANDS ON ONE LINE

    set &=%4&|set n$=%4|set m$=%3|set #=%2|set !=%0 
            /|\       /|\       /|\      /|\ 
             |_________|_________|________|_________________________Separators


    The separators (|) used in the line, are these doing anything
    other than separating commands?  Can this be used for entering multiple
    commands on any line in a batch file regardless of type of command?

                              Peter Joynson

    I believe you are right about this, but I think it pipes any output from
    the previous command to the next one (your example doesn't have any
    output.  For example: ECHO Y|ERASE *.*  This would pipe the Y to the
    command ERASE *.* so you wouldn't have to enter the Y for the "Are you
    sure" prompt.

                              Robert Hupf

    The | is a pipe symbol, well documented in your DOS manual.  (Read it
    before you read the rest of this message if you don't know about
    pipes already, otherwise the rest won't make sense.)  Pipes can be
    used to put multiple commands on a single line, provided that the
    first command does not write anything to StdOout which might cause a
    problem when read by the second command as StdIn. Also, it is assumed
    that you don't want to see the output of any but the last command,
    since each command's output will be piped to the next's input.  Note
    that in this case SET neither writes anything to StdOut nor reads
    StdIn.  Thirdly, you must have write access to the current drive, or
    %temp% if defined, since a pipe always creates a temporary file.  Eg
    this would not work if run from a write protected floppy (unless
    %temp% was defined), since DOS would fail to create the temporary
    files.

    Pipes create temporary files even if no actual data is sent to
    StdOut because Command effectively treats this:

            prog1 | prog2

    as something like this:

            prog1 > %temp%tempfile
            prog2 < %temp%tempfile
            del %temp%tempfile

    Even if prog1 doesn't create any output, at least one zero length
    file is created.  To demonstrate, try this

            set temp=
            set | dir

    I must say this beats the usual boring old "how do I echo a blank
    line in a batch file" etc.

                              Mitch Ames

===============================================================================
28) COM or EXE

    Also, have you noticed that 4DOS.COM (when viewed with LIST) begins
    with the letters "MZ"?  Isn't that the mark of a .EXE file?  Very
    interesting...

                              Thomas Smith

    It sure is, and that's an example of something else that may be
    a MUF.  DOS doesn't care whether the extension on an executable
    file is .COM or .EXE.  It looks at the beginning of the file and
    does the right thing according to what it finds.

                              Gary Smith

===============================================================================
 
... Real users don't read documentation.
___ Blue Wave/QWK v2.12

-!- EzyQwk V1.02
 ! Origin: Programmer's Corner BBS, Saint John, NB  (v32/v42) (1:255/6)

Ä Area: [ECHO] BATCH POWER PROG. ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
  Msg#: 4983                                         Date: 09-12-93  20:51
  From: Gary Cooper                                  Read: Yes    Replied: No 
    To: ALL                                          Mark:                     
  Subj: MUF Ver. 1.6 #17
ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Editor's Note:

Technically the following information is NOT a MUF, but is included
here due to the fact that it may help save someone a lot of grief!
Similar to advising others not to use delayed cache writes and DOS
6.0's DoubleSpace.

29) CHKDSK

    Can you tell me the _date_ of the BAD CHKDSK?  I live in
    fear of it as I mainly work on other peoples computers an I
    have no way of telling if I will destroy their HD with a
    simple chkdsk command!

                              Wallace Mcgee

    The only problem with CHKDSK is with large partitions where DOS uses
    a 256-sector FAT. Specifically with partition sizes in the ranges of:

        127MB-129MB
        254MB-258MB
        508MB-516MB
        1018MB-1030MB
        2035MB-2061MB

    The date of the CHKDSK that has that problem is 04/09/91. The
    replacement being dated 11/11/91.

    UNDELETE has the same problem for the same reason.

    Bottom line is - if you don't have partitions in these size ranges -
    you don't have a problem.

    The corrected versions can be had by downloading from the MS BBS.
    Probably also available off of CompuServ. The file to look for is:
    PD0464.EXE. The phone number for the MS BBS is (206) 936-6735.

    Hope that helps you and others with the same question.

                              Steve Osterday

===============================================================================
30) DELTREE

    Another new, and potentially dangerous, feature of IBM DOS v6.01.
    If you were on drive C: and issued the command:

    DELTREE /Y \

    it would dutifully, and without stopping to ask for verification,
    delete your entire drive C:!

    (You can test it on a floppy with directories, subdirectories,
    and files scattered throughout ... just make sure you specify
    and/or are on that drive (disk) when issuing the above command).

                              Vernon Frazee
===============================================================================
Well folks, that's it for Vol.1 #6

Please forward any information about other Fabulous MUFs to Gary Cooper
in the FidoNet BatPower echo or at the addresses below.

Gary Cooper, Co-Sysop Programmer's Corner FidoNet 1:255/6.0
gary.cooper.@f6.n255.z1.fidonet.org

Thanks!  Till next time, we return you to your regularly scheduled
BatPower program . . .
 
... Damn the documentation, full speed ahead!
___ Blue Wave/QWK v2.12

-!- EzyQwk V1.02
 ! Origin: Programmer's Corner BBS, Saint John, NB  (v32/v42) (1:255/6)
