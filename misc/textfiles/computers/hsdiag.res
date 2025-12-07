  =========================================================================
                                    ||
  From the files of The Hack Squad: ||  by Lee Jackson, Moderator, FidoNet
                                    ||    Int'l Echos SHAREWRE & WARNINGS
          The Hack Report           ||  Volume 2, Number 5
         File Test Results          ||  Result Report Date: April 10, 1993
                                    ||
  =========================================================================

  *************************************************************************
  *                                                                       *
  *  The following test was performed by R. Wallace Hale, sysop of the    *
  *      Driftnet BBS, (506) 325-9002.  The results, forwarded by         *
  *    James FitzGibbon (FidoNet 1:250/301) and HW Bill Lambdin, are      *
  *        preliminary.  Thanks to everyone for their assistance.         *
  *                                                                       *
  *************************************************************************


                                HSDIAG.ZIP WARNING!!!
                                ~~~~~~~~~~~~~~~~~~~~~

The file HSDIAG.ZIP, masquerading as a high speed modem diagnostic
utility is a Torjan horse.

This is a PRELIMINARY report and will be expanded and/or modified
(and probably corrected) in due course.

I received HSDIAG from Bob Feldman today, and have not had sufficient
time to disassemble HSDIAG.EXE completely, but I have done enough to
determine that the program will overwrite the first 255 sectors on the
first eight drives on a system!

The Trojan begins with the highest number drive and works downward,
finishing with the floppy diskette in Drive A, if such exists.  In
addition to data loss, the system will no longer be bootable from
the hard drive.

Error messages are suppressed and once started, the Trojan can NOT
be halted by a Ctrl-C or Ctrl-Break key sequence.

No virus scanner in my arsenal twigs to the Trojan, nor does
F-PROT 2.07 in heuristic mode find anything suspicious.  This is
not at all surprising, and one shouldn't expect any virus scanner
to provide protection against Trojan programs.

However, tired old PROGNOSE warns of possible danger.

The following strings can be found in HSDIAG.EXE:

     18C:      High Speed Modem Diagnostics
     1B6:              Version 1.0
     1E0:         Sound Blaster Support
     232: )       Written by Bully Bros, Incoporated)
       Please Press [ENTER] To Load Diagnostics,
     287: Please wait ..
     296: ..Loading Done!#Press [ENTER] to Start Diagnostics.
     2CA: Bully Bros.Dallas TX.
     2E0: -Copyrite (C) 1993 Bully Bros. Raj And Asshole
     DF0: #$456789:;<=>?uRuntime error
     E0E:  at


The Trojan archive contents are:

Archive:  HSDIAG.ZIP

Name          Length    Method     SF   Size now  Mod Date    Time     CRC
============  ========  ========  ====  ========  =========  ======== ========
HSDIAG.EXE        4864  Deflated   34       3172  08 Mar 93  22:03:58 1C84FC4D
FILE_ID.DIZ        245  Deflated    7        228  17 Mar 93  02:02:50 7CF5CBD2
HSDIAG1.DAT      17264  Deflated   36      11044  27 Nov 92  13:47:34 46B34F7D
HSDIAG2.DAT       7121  Deflated   57       3012  27 Nov 92  13:47:34 7127D2C7
HELP.DAT          4064  Deflated   31       2802  27 Nov 92  13:47:34 6FD0DD60
UART1.DAT         5872  Deflated   39       3542  27 Nov 92  13:47:34 AFB5E3CE
HSDIAG3.DAT       2848  Deflated   50       1404  27 Nov 92  13:47:34 0089171B
============  ========  ========  ====  ========  =========  ======== ========
*total     7     42278  ZIP 2.0    38%     26706  10 Apr 93  11:23:42

All executables in the archive appear to have been written with
Borland's Turbo Pascal, version 4.0 or higher.  Since I am not a
Pascal programmer, I can't really be certain on this point.

I am absolutely certain that all of the .DAT files were taken from
Joseph Sheppard's ATSEND v.1.8 and have merely been renamed.  The
contents of ATSEND18.ZIP are listed below, and I have done a
byte-by-byte comparison of the .DAT files from the hack with the
files in ATSEND18.ZIP to verify this.

Archive:  ATSEND18.ZIP

Name          Length    Method     SF   Size now  Mod Date    Time     CRC
============  ========  ========  ====  ========  =========  ======== ========
ATSEND.EXE       17264  Imploded   33      11452  27 Nov 92  13:47:34 46B34F7D
ATSEND.DOC        7121  Imploded   55       3142  27 Nov 92  13:47:34 7127D2C7
HEX2DEC.EXE       4064  Imploded   28       2899  27 Nov 92  13:47:34 6FD0DD60
ATBATCH.EXE       5872  Imploded   37       3688  27 Nov 92  13:47:34 AFB5E3CE
FILE_ID.DIZ        332  Imploded    9        302  27 Nov 92  13:49:38 09F0E0D8
ATSEND.NEW        2848  Imploded   44       1589  27 Nov 92  13:47:34 0089171B
============  ========  ========  ====  ========  =========  ======== ========
*total     6     37501  ZIP 1.10   36%     23708  27 Nov 92  13:49:38


I received HSDIAG in ZIP 2.0 format and have no idea whether the
author of the Trojan released it initially in an archive created
with PKZip 1.10 with a forged -AV or not.  Mr. Sheppard uses the
AV feature of PKZip to provide some slight measure of security:

PKUNZIP (R)    FAST!    Extract Utility    Version 1.1    03-15-90
Copr. 1989-1990 PKWARE Inc. All Rights Reserved. PKUNZIP/h for help
PKUNZIP Reg. U.S. Pat. and Tm. Off.

Searching ZIP: ATSEND18.ZIP
Testing: ATSEND.EXE    OK -AV
Testing: ATSEND.DOC    OK -AV
Testing: HEX2DEC.EXE   OK -AV
Testing: ATBATCH.EXE   OK -AV
Testing: FILE_ID.DIZ   OK -AV
Testing: ATSEND.NEW    OK -AV

Authentic files Verified!   # CRI220   Joseph Sheppard

The hacked archive, HSDIAG.ZIP contains a FILE_ID.DIZ file:

°±² High Speed Modem Diagnostics ²±°
Superb tool for testing and configuring high
speed (9600bps and up) modems.  Reports on
UART, FIFO, S-Registers, and full NVRAM
editor with context sensitve help.  $35
Written by: Norman Shelbert <ASP>

This is NOT the FILE_ID.DIZ from Sheppard's ATSEND18.
Don't know who Norman Shelbert may be, but possibly there
is a legitimate high speed modem diagnostic program
written by such a person, and the FILE_ID.DIZ may have
been lifted from that program.

If at all possible, I will post further information
within the next day or two.


R. Wallace Hale, sysop
Driftnet (506) 325-9002

10 April 1993

