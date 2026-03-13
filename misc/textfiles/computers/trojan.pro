

    Mark Garvin -- Xymetric Productions -- New York City             3-7-87


    I guess I have stirred some interest with my recent messages to BBS's
    concerning Trojan horse programs.  I have decided to write the following
    file in the interest of warning others and hopefully finding clues to the
    origin of the programs.

    I have been operating a Priam 60 Meg hard disk on my AT for the past two
    years with good results.  About four months ago, I encountered a Trojan
    horse program called HI-Q.COM which corrupted the FAT table on the disk.
    I lost access to the entire D: drive and the files and boot sectors on
    the C: drive were so badly damaged that I had to reformat the drive.
    Since there was nothing to be lost by trying the program again, I decided
    to confirm that HI-Q.COM was indeed the culprit.  I ran a couple of the
    popular Trojan finders on the file first:  Nothing.  Thinking perhaps I
    was mistaken, I ran HI-Q under an INT13-trapper.  No INT 13's were found
    and HI-Q ran normally.  Upon rebooting the system, I found the same boot-
    sector errors, and CHKDSK again reported numerous cross-links, etc.  I
    reformatted the drive and ran media checks to make sure the Priam was
    sound.   After checking several other programs (I did NOT run the Trojan-
    testers or INT13-trapper again in case those were perhaps Trojan), I ran
    HI-Q.COM for the third time.  Same results.  This is enough for me: I'm
    convinced.

    Up until this point, I had heard of Trojan horses, but honestly doubted
    that there were actually competant computer programmers around who were
    wierd enough to write such a thing.  I should also note that there is a
    program called HI-Q.EXE which has been tested by some boards, and is
    supposedly NOT a Trojan.  I'm not going to try it on my hard disk system.
    The HI-Q.COM program may not have even been an intentional Trojan -- I'm
    willing to keep an open mind on the subject.  Maybe it was incompetent
    programming, or perhaps someone ran SPACEMAKER or a similar program on
    the .EXE file to convert it to a .COM file, and inadvertantly created a
    Trojan.

    OK -- that's one thing.. The next Trojan I ran was DEFINITELY intentional.
    I had reformatted my Priam after the previous incident, and I haven't
    allowed the mysterious HI-Q program back on the system.  However, I HAVE
    run numerous file-managers, etc. from local BBS's -- maybe I'm just a
    trusting individual, but I wasn't ready to give up on Public Domain or
    shareware software just yet.  Recently, the Priam starting giving me
    trouble again: crosslinked and lost files, and no boot.  I called Priam,
    hoping to get instructions for perhaps salvaging files on the D: drive,
    since the partition was destroyed.  Priam's tech guided me through a HEX/
    ASCII dump of the boot record via a trap-door in Priam's FDISK program.
    Needless to say, we were BOTH incredulous at the result.  Dis-believers
    should look closely at the HEX/ASCII dump below.  This was NOT retyped
    or altered in any way.  After booting from floppy, I redirected printer
    output to a disk file.  What you are looking at below is exactly what
    appeared on my screen after the crash.

____________________________________________________________________________



0 = Master Boot Record, 25 = Extended Volume Record
1 - 24 = Volume Boot Record
                             
Enter number of record to display (0 - 25) : [   0] 

  D   H   0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F 0123456789ABCDEF
  0/  0  EB 7D 53 4F 46 54 4C 6F 4B 2B 20 33 2E 30 0D 0A ..SOFTLoK+ 3.0..
 16/ 10  11 28 43 29 20 53 4F 46 54 47 55 41 52 44 0D 0A .(C) SOFTGUARD..
 32/ 20  53 59 53 54 45 4D 53 2C 20 49 4E 43 2E 20 0D 0A SYSTEMS, INC. ..
 48/ 30  32 38 34 30 20 53 74 20 54 68 6F 6D 61 73 0D 0A 2840 St Thomas..
 64/ 40  45 78 70 77 79 2C 20 73 74 65 20 32 30 31 0D 0A Expwy, ste 201..
 80/ 50  53 61 6E 74 61 20 43 6C 61 72 61 2C 20 20 0D 0A Santa Clara,  ..
 96/ 60  43 41 20 39 35 30 35 31 20 20 20 20 20 20 0D 0A CA 95051      ..
112/ 70  34 30 38 2D 39 37 30 2D 39 34 32 30 10 07 00 FA 408-970-9420....
128/ 80  8C C8 8E D0 BC 00 7C FB 8B F4 8E C0 8E D8 FC BF ......|.........
144/ 90  00 06 B9 00 01 F3 A5 EA D4 06 00 00 45 72 72 6F ............Erro
160/ A0  72 20 6C 6F 61 64 69 6E 67 20 6F 70 65 72 61 74 r loading operat
176/ B0  69 6E 67 20 73 79 73 74 65 6D 00 4D 69 73 73 69 ing system.Missi
192/ C0  6E 67 20 6F 70 65 72 61 74 69 6E 67 20 73 79 73 ng operating sys
208/ D0  74 65 6D 00 BE BE 07 B9 04 00 AC 3C 80 74 15 83 tem........<.t..
224/ E0  C6 0F E2 F6 CD 18 AC 0A C0 74 FE BB 07 00 B4 0E .........t......
240/ F0  CD 10 EB F2 4E 8B 14 8B 4C 02 BB 00 7C B8 11 02 ....N...L...|...
       
Press <Esc> to ABORT, any other key to continue .

0 = Master Boot Record, 25 = Extended Volume Record
1 - 24 = Volume Boot Record


_____________________________________________________________________________


   In the interest of justice, I would like to make the following obser-
   vations:

   1) The MAIN phone no. for SoftGuard systems is: 408-970-9240, NOT 9420.
      The no. listed above is not in use.  The message it gives IS the
      normal message for that area, even though it sounds like it is com-
      puter generated.  The phone co. says it is actually registered to
      Siliconix, a Silicon Valley chip-manufacturer, who probably has no
      interest in Public Domain software or BBS's.

   2) I called SoftGuard, and they gave me a Mr. Phelps-type message, disavow-
      ing any knowledge of any Trojan programs or of SOFTLok, etc. which they
      said is not an official product.  However, they have not returned my
      calls requesting additional information, and a request to speak to some-
      one knowledgable about their software protection techniques has not been
      answered.  This may mean either that the message was cooked up by some-
      one with a vendetta against SoftGuard (I don't know why!), or that Soft-
      Guard wants to be able to identify the source of the Trojan program by
      the information phoned in by irate people whose disks have just crashed.
      In my opinion, the juxtaposition of the phone no. digits could be caused
      by errors on the part of whoever wrote the Trojan program, whether it
      was within SoftGuard, or not.   After restoring the hard disk, I scanned
      every file on it, and "SoftGuard" did not appear anywhere.  The clever-
      ness in bit-shifting the ASCII digits, or otherwise disguising them, may
      also have resulted in the wrong phone no.

   3) I have not, and will not, install SoftGuard programs on my disks.  Also,
      I obviously do not have any reason to run any of the unprotect programs
      for SoftGuard, of which some are supposedly Trojans themselves (see
      below).  I have no idea of which file of the 2,000+ files on my system
      was the origin of the message.  As explained above, I have scanned them
      for ASCII text and I've come up with nothing so far.



   There are numerous warnings in circulation concerning SoftGuard Systems,
   manufacturers of the SuperLock copy-protection scheme.  They SUPPOSEDLY
   upload Trojan programs to BBS's either to try to get their own form of
   justice against those who try to crack their software, or because they
   are just bitter about the numerous SoftGuard/SuperLock unprotectors which
   are circulating on the BBS's.  Most of these Trojans have the name SUG..
   (Soft-Un-Guard) or something similar.  I did not originally believe that
   SoftGuard would be stupid enough to do such a thing.  After all, a lesson
   should have been learned by the example of Prolok (another copy-protect
   manufacturer), who claimed that their new software would destroy the hard
   disk of anyone who tried to mis-use it.  Most users, legitimate and other-
   wise, dropped them instantly, even though Prolok realized their grave
   error and retracted their previous advertising.  After all, who wants to
   have their hard disk destroyed by accidently inserting the wrong key disk?

   The SUG programs mentioned are reported to say something like: "Courtesy
   of SoftGuard Systems .. So sue us!" -- after trashing the hard disk.

   My feelings about possibly casting doubt on the integrity of SoftGuard ?
   They did NOT convince me that they were blameless, and if they cared, they
   would have returned my phone calls.  However, it MAY just be coincidence
   that a lot of the Trojan programs mention SoftGuard.


   Recommendations:

     Whether SoftGuard is at fault or not, they did not give me an adequate
     explanation of the rumors circulating about them, and they did not
     return my calls.  I would recommend that individuals and companies stay
     away from SoftGuard/SuperLock, or any other copy-protect program which
     writes hidden, strange information onto their hard disks.  Users of such
     copy-protected software should write or call the manufacturers and re-
     quest that the copy protection be discontinued.  Explain to them that
     pirates will always crack copy-protection, and that only the legitimate
     users suffer from its use.  If you work for a company that uses copy-
     protected software, why not get a print-out of this file and show it to
     the person in charge of purchasing software?

     If you DO have a hard disk crash, try to recover the boot-record on the
     disk before just giving up and reformatting.  You may find something
     similar to the above.  The manufacturer or vendor of your hard disk may
     be able to steer you through the proper procedure for doing this.

     Read this month's (March 1987) issue of 'Computer Language' for more
     information on Trojan horse programs.  The article recommends contacting
     Eric Newhouse at THE CREST BBS regarding trojan horse programs.  If you
     DO run into one, keep a copy of the file, and have a knowledgable BBS-
     user send it, and an explanation to Eric's BBS at 213-471-2518.  DO NOT
     SEND THE FILE WITH ITS ORIGINAL NAME.  The file name should be changed
     to something NOT ending in .EXE or .COM (how about .TRJ), and it should
     be sent to the attention of the SYSOP.  This is usually done by waiting
     for the prompt to enter the file description, and starting the descrip-
     tion with '/'.  Afterwards, also leave a comment to SYSOP which states
     the nature, and description of the file.  In other words, don't inadver-
     tantly upload a Trojan program which could victimize others.

     Watch out for some of the so-called Trojan testers.  The majority of
     these are legitimate, but a few of them are actually Trojans themselves.
     Also, before jumping the gun and assuming a program is Trojan, check
     other possible sources for disk errors, etc.  Sometimes hard disk media
     just develops errors, and there ARE some programs circulating as 'jokes'
     which put a message up which says they are reformatting your drives, or
     even claim to be draining excess water out of your disk drives.  Most of
     the nasty Trojan programs don't cause their damage immediately.  They
     wait for the drive to fill up a bit, or they wait for a random time
     interval.  In the latter case described above, I suspected a file manager
     that I had just run.  It turns out that others have used the program with
     no ill effects.

     It seems to me that the future of PD software, as well as BBS systems
     is being threatened by this type of thing.  A concerted effort on the
     part of SYSOPS to correlate the names and origins of people who upload
     Trojan software may help to track them down.  Most BBS software keeps
     track of the names of people uploading software.  I doubt that Trojan
     writers are stupid enough to list their real names, but it's time that
     some ingenuity was used in putting a stop to this.

     I am a serious software developer, and I have taken some time off to
     write this message in the interest of helping other PD software users.
     Unfortunately, I don't have the time to coordinate any effort in analysis
     of Trojan programs and I cannot be contacted by phone (unlisted), but if
     you DO run into something similar, or if you have questions about any of
     the info presented here, leave me a personal message on any of the larger
     BBS's in New York City, and I will try to reply on the same board.


     PLEASE DO circulate this file.  It is important information for anyone
     running a BBS, or using Public Domain or SoftGuard/SuperLock software.




cturer), who claimed that their new software would destroy the hard
   disk of anyone who tried to mis-use it.  Most users, legitimate and other-
   wise, dropped them instantly, even though Prolok realized their grave
   error and retracted their previ