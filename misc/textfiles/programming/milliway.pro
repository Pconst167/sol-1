

L9>F1

////\\\\\/////\\\\\/////\\\\\/////\\\\\/////\\\\\/////\\\\\/////\\\\\/////\\\\
||                        Mastering Milliways Volume I                      ||
||                     "Hard drive partitions and Setup"                    ||
||                                                                          ||
||                  Written in despiration by  The Outland                  ||
||                                                                          ||
||          I/O-net 1.2  (c) 1985  David Calaprice and Derek Gross          ||
\\\\/////\\\\\/////\\\\\/////\\\\\/////\\\\\/////\\\\\/////\\\\\/////\\\\\////

  This is the first in a series of files I intend to finish up on my spare
time that I hope will be around with us for a long time no matter what what
happens in the future.   Hope they come into use some day.


--> Hard drive partitions

First Class Peripherals release 1/2/3

Cylinders                                        306
Number of heads                                    4
Reduce write cylinders                           306
Pre-comp cylinder                                306
Control byte                                       7
Number of alternate tracks                        12
Interleave                                        16
Small volumes                                     17
Large volumes                                      0
Total                                             17
CP/M A                      Start:  330 | Size:    2
CP/M B                      Start:  333 | Size:    2
CP/M C                      Start:  336 | Size:    2
CP/M D                      Start:  339 | Size:    2
ProDOS volume 1  /HARD1     Start:  343 | Size: 3888
ProDOS volume 2  /HARD2     Start:  586 | Size: 9776
Pascal # 9                  Start: 1199 | Size:   48
Pascal #10                  Start: 1202 | Size:   48
Pascal #11                  Start: 1208 | Size:   48
Pascal #12                  Start: 1208 | Size:   48


--> DOS 3.3

  The assignment of seventeen volumes each having 560 sectors or 143k.  The
complete DOS 3.3 partition holds 2437k.   Volume assignments should, and
always will be posted on volume one of the 3.3 partition for ae/catfur users
as a reference.  Maintaining the 3.3 partition is next to impossible for
anyone in remote mode unless a special module is created for sysops where in
they can delete any file on any volume, this possibility has not yet been
implimented as of 03-JAN-86.


--> ProDOS

  The assignment of two volumes maximum led me to partition one main volume
to hold 90% of the bulletins, and 100% of all textfiles.  The other partition
would hold the system files/modules/mail/news, and 10% boards.  Setup and
where to locate what on the ProDOS volumes is difficult due to the tree
structure, this will be opened up further in this file.

  Volume one is named "/HARD1", likewise volume two is "/HARD2".  /HARD1
has a maximum capacity of 3888 blocks (7776 sectors or 1990k), while
/HARD2 over powers this with a whopping 9776 blocks (19552 sectors or 
5005k).  Both partitions together in maximum storage capacity hold 
13664 blocks (27328 sectors or 6995k).   In terms of megabytes --


DOS 3.3                                      2.437 megabytes
ProDOS /HARD1                                1.990 megabytes
ProDOS /HARD2                                5.005 megabytes
Total  (ProDOS)                              6.995 megabytes
Total  (Alltogether)                         9.432 megabytes


--> CP/M and Pascal

  The two partitions holding these OS's have been made as small as possible,
they maintain 90% of what is left of the hard disk, the rest is lost to
hard disk files.  Parameter blocks, and so on.


--> ProDOS setup

  As mentioned before, there are two volumes in the ProDOS partition, one
for system files/mail/news/boards 1-5+21, and /HARD2 which is larger than
the first for the sole reason that it holds everything else.   Boards 6-20,
and textfiles (5 megabytes).   Mastering the structure of the entire system
needs a hands on experience, but through these files I hope to aid any sysops
of present and future into understanding where everything is kept, and where
it should be kept.   Many hours of time has gone into making the system as
easy to use as possible, with I/O-net being very modular, I have created many
modules for xfer, textfiles, other functions and so on.


--> /HARD1

Size:  1.990 megabytes

Structure:


/HARD1 ---!
          ! -->BOOT  (I/O-net 1.2 boot/modules)
          !
          ! -->BBS !
          !        ! --> Boards 1-5 and 21
          !        ! --> Mail/Transfer files/News files
          !        ! --> System menus/help/info/setup/ACCOUNTS
          !        ! --> Other module/files
          !
          ! -->HG  (Heart of Gold (ae/catfur)/modules/menus/info)


--> /HARD2

Size: 6.995 megabytes

/HARD2 ---!
          ! --> Boards 6-20  (any subsequent boards in future)
          ! --> Textfiles !
                          ! --> Libraries 1-28  (some unused)
                          ! --> Menu/info/DIR
                          ! --> Slipped Disk's File of the week/info

  Future features such as filter systems for the illegal activities of the
system, data files, should be found on /HARD2 on the main directory under
some file name.


--> Setup

  Setup of Milliways takes exactly 22.35 seconds from warm start to awaiting
carrier.  The process from partition to partition is quick, and is setup
like this--

Parameter block (3.3)-->RUN MAIN MENU
Boot ProDOS-->RUN STARTUP-->Setup modem-->Setup drivers-->RUN IO.1
Read SETUP-->Read US.NUM-->Await ring

The following files should under no circumstances be tampered with though a
remote logon.

Under Dos 3.3  "MAIN MENU", and "PRODOS"
Under ProDOS   "/HARD1/STARTUP", and "/HARD1/BOOT/="/HARD1/BBS/SETUP and FILE"

  The files, and what purpose they serve will be explained in the next volume.
"System Files/Daily Routine".


////\\\\\/////\\\\\/////\\\\\/////\\\\\/////\\\\\/////\\\\\/////\\\\\/////\\\\
||                        Mastering Milliways Volume I                      ||
||                     "Hard drive partitions and Setup"                    ||
||                                                                          ||
||                  Written in despiration by  The Outland                  ||
||                                                                          ||
||          I/O-net 1.2  (c) 1985  David Calaprice and Derek Gross          ||
\\\\/////\\\\\/////\\\\\/////\\\\\/////\\\\\/////\\\\\/////\\\\\/////\\\\\////

L9>
