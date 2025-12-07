
                                   ARC VERSUS LBR


     I decided to test the ARC utility against the SQ and LBR utilities to see
     if it would be a good thing to switch over to ARC, or to try to maintain
     LBR files in an increasingly dominated ARC world.

     I selected the 30 BASIC files listed below for the test since they
     contained a mix of ASCII and tokenized files, (and mostly because they were
     sitting in a sub-directory already and were about the right size).  The
     tests were conducted on an IBM PC with an external hard disk - floppies
     would have taken too long.  As you can see already I used nothing but the
     most "rigorous" test methods.

     The source files:  30 BASIC Programs totalling 139,030 bytes.

     The ARC utility was invoked: ARC a BASFINPG *.*.
     The resultant file took 12 minutes 20 seconds to produce and was 95,571
     bytes large.


     I used ZIP082.EXE to tag and SQueeze the BASIC files and then invoked LUU
     with: LUU FINPGBAS *.?Q?  I responded with 36 for the number of slots.
     When LUU was through, I entered ERASE *.?Q?.  The resultant file was
     116,096 bytes large and the three step process took 8 minutes and 6
     seconds.


     I didn't really come up with any startling data, other than the time
     difference - I didn't think it would be that much.  My "conclusions":

          COMPRESSION RATE (to original file)
                    ARC = 68.7%
               SQ & LBR = 83.5%

            The ARC file is 17.7% smaller than the .LBR file.  What this
            means is the per 100Kb of file, the ARC file will be 17.7Kb
            smaller, or 1.77Mb per 10 MB, if your files are like the
            files used in this test.  Another way of looking at it is
            about 64Kb per floppy.  Not bad!


          TIME FACTORS

            The ARC File took 12 minutes 20 seconds versus the SQ & LBR
            times of 8 minutes and 6 seconds.  You could say that the
            ARC utility is 53.3% slower, or the SQ & LBR utilities are
            34.6% faster (even having to do three operations).  The time
            in minutes per 100 KB of original file are 8.9 minutes for
            ARC and 5.8 minutes for SQ & LBR.  To do 1 floppy (362Kb)
            would take 32.22 minutes using ARC and 21 minutes for SQ &
            LBR.  A 10Mb hard disk would result in 890 minutes (14.83
            hrs.) for ARC and 580 minutes (9.67 hrs.) for SQ & LBR.


     I think another factor that should be considered is data transfer time.
     Most of these files get moved by modem.  What is the time difference at
     1200 Baud?  300 Baud?

     Does the time savings for creating a SQ & LBR file offset the file size
     savings of ARC?  I think I could have improved on the SQ & LBR times, but
     there is no way I could make the ARC times faster.  How important is the
     "on-line" time?  How much of a factor is ease of use, (one command and file
     versus three)??  LUE and LUU are pretty small files as is SQPC.  ZIP is
     pretty large but it does many, many other things.  I could have used ZIP
     for the LBR file creation as well as the squeeze, but I thought it was a
     little easier to exit and use LUU because of the wild cards.  Other SQ
     utilities (than ZIP's) might offer better compression ratios?

     I would like to know what other people think?  Should we start consciously
     shifting over to ARC, or should we reconsider??  My name is Bob Hobbs and I
     can be reached at:

          PC Spectrum      714/980-8607  RBBS
          Zaphod's Machine 714/626-1843  FIDO


     .           <DIR>   08:1484 31:55         INCOME  .BAS   8832 22Oct82 00:02
     ..          <DIR>   08:1484 31:55         KALCOL  .BAS    896
     BALANCE .BAS    512 29Jul82 03:15         LEASE   .BAS   2176 22Oct82 00:02
     BESTLINE.BAS    896 01Jan80 00:03         LEASEBUY.BAS   2944 15Jun84 07:58
     BOND    .BAS   2816 22Oct82 00:02         MEAN    .BAS    640 25Apr82
     BUDGET  .BAS   7808 29Jan83 01:09         NETPREST.BAS    896 22Oct82 00:03
     COMPOUND.BAS    768 22Oct82 00:02         NUMERIC .BAS   1280 22Oct82 00:03
     CRITICAL.BAS   2176 22Oct82 00:03         PERT    .BAS   3072 22Oct82 00:03
     FINANCE .BAS  22016 31Jan83 21:54         PRLIST  .BAS   3584 01Jan80 00:15
     FINANCE1.BAS   6400 25Jan82               PVTAX   .BAS    640 22Oct82 00:03
     FINANCEA.BAS  21114 28May84 13:13         REGRESS .BAS    768 25Apr82
     FINPAC  .BAS  16640 29May84 09:27         REPORTS .BAS  10496
     FUTURE  .BAS    896 22Oct82 00:03         RLTYLOAN.BAS   5916 27Apr85 22:13
     GROWTH  .BAS   1792                       STATPAK .BAS   9984 28May84 11:04
     GROWTH1 .BAS   1536 18Jul82 16:13         TREASURY.BAS   1536 22Oct82 00:02
           139030 Bytes in       30 File(s);



Notes added by sysop of FIDO 107/7  24 Sept 85

The difference in file transfer time is about 4 mins for each 20k
difference in file length.  About the same figures for the test above.
Baud rates will give some difference in file transfer time. (protocol
overhead reduces the effects of baud rate)

The above test uses 2 common file types,  and may give good results,
however your results may vary.

The version of ARC in the test is not given,  version 2.3 is faster
then earlier versions.

In our experence,  the savings in disk space are more important
then the time to ARC something.
