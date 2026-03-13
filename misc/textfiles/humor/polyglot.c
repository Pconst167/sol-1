From: gnat@kauri.vuw.ac.nz (Nathan Torkington)
Newsgroups: alt.folklore.computers
Subject: Generic Program (was Re: Date of first ____)
Message-ID: <GNAT.91Aug25181850@kauri.kauri.vuw.ac.nz>
Date: 25 Aug 91 06:18:50 GMT
References: <KHB.91Aug23143926@chiba.Eng.Sun.COM>
<1991Aug24.151903.6461@ddsw1.MCS.COM>
        <BAGCHI.91Aug24213036@snarf.eecs.umich.edu>
Sender: news@rata.vuw.ac.nz (USENET News System)
Organization: Contract to CSC, Victoria Uni, Wellington, New Zealand
Lines: 126
In-Reply-To: bagchi@eecs.umich.edu's message of 25 Aug 91 02: 30:36 GMT
Nntp-Posting-Host: kauri.vuw.ac.nz
 
In article <BAGCHI.91Aug24213036@snarf.eecs.umich.edu> bagchi@eecs.umich.edu
(Ranjan Bagchi) writes:
 
           More impressive would be a file which is interpreted/compiled to
   say "Hello World!" in each of these languages. 
 
Something from alt.folklore.computers a while ago:
 
----begin-~gnat/Docs/Folklore/polyglot.program----
Newsgroups: rec.puzzles,comp.lang.misc,alt.folklore.computers
Subject: A polyglot program
From: peril@extro.ucc.su.OZ.AU (Peter Lisle)
Date: 18 Mar 91 13:19:07 GMT
Organization: Uni Computing Service, Uni of Sydney, Australia
Nntp-Posting-Host: extro.ucc.su.oz.au
 
A little while ago some people were talking about polyglot programs in
rec.puzzles, these are programs that are written in several languages.
We thought it sounded like fun so we wrote this one.
 
Our friends suggested we should post it -- so here it is, let us know
what you think.
 
 
-------- cut here (keep the blank lines: they are important) --------
 
 
                                                                        
(*O/*_/
Cu  #%* )pop mark/CuG 4 def/# 2 def%%%%@@P[TX---P\P_SXPY!Ex(mx2ex("SX!Ex4P)Ex=
CuG #%*                                                                  *+Ex=
CuG #%*------------------------------------------------------------------*+Ex=
CuG #%*   POLYGLOT - a program in seven languages      15 February 1991  *+Ex=
CuG #%*                                                                  *+Ex=
CuG #%*   Written by Kevin Bungard, Peter Lisle, and Chris Tham          *+Ex=
CuG #%*                                                                  *+Ex=
CuG #%*   We have successfully run this program using the following:     *+Ex=
CuG #%*     ANSI COBOL:            MicroFocus COBOL85 (not COBOL74)      *+Ex=
CuG #%*     ISO  Pascal:           Turbo Pascal (DOS & Mac), Unix PC,    *+Ex=
CuG #%*                            AIX VS Pascal                         *+Ex=
CuG #%*     ANSI Fortran:          Unix f77, AIX VS Fortran              *+Ex=
CuG #%*     ANSI C (lint free):    Microsoft C, Unix CC, GCC, Turbo C++, *+Ex=
CuG #%*                            Think C (Mac)                         *+Ex=
CuG #%*     PostScript:            GoScript, HP/Adobe cartridge,         *+Ex=
CuG #%*                            Apple LaserWriter                     *+Ex=
CuG #%*     Shell script:          gnu bash, sh (SysV, BSD, MKS), ksh    *+Ex=
CuG #%*     8086 machine language: MS-DOS 2.00, 3.03, 4.01, 5.00 beta    *+Ex=
CuG #%*                            VPix & DOS Merge (under unix)         *+Ex=
CuG #%*                            SoftPC (on a Mac), MKS shell          *+Ex=
CuG #%*                                                                  *+Ex=
CuG #%*   Usage:                                                         *+Ex=
CuG #%*     1. Rename this file to polyglot.[cob|pas|f77|c|ps|sh|com]    *+Ex=
CuG #%*     2. Compile and/or run with appropriate compiler and          *+Ex=
CuG #%*        operating system                                          *+Ex=
CuG #%*                                                                  *+Ex=
CuG #%*   Notes:                                                         *+Ex=
CuG #%*     1. We have attempted to use only standard language features. *+Ex=
CuG #%*        Without the -traditional flag gcc will issue a warning.   *+Ex=
CuG #%*                                                                  *+Ex=
CuG #%*     2. This text is a comment block in all seven languages.      *+Ex=
CuG #%*                                                                  *+Ex=
CuG #%*     3. When run as a .COM file with MS-DOS it makes certain      *+Ex=
CuG #%*        (not unreasonable) assumptions about the contents of      *+Ex=
CuG #%*        the registers.                                            *+Ex=
CuG #%*                                                                  *+Ex=
CuG #%*     4. When transfering from Unix to DOS make sure that a LF     *+Ex=
CuG #%*        is correctly translated into a CR/LF.                     *+Ex=
CuG #%*                                                                  *+Ex=
CuG #%*   Please mail any comments, corrections or additions to          *+Ex=
CuG #%*   peril@extro.ucc.su.oz.au                                       *+Ex=
CuG #%*                                                                  *+Ex=
CuG #%*------------------------------------------------------------------*QuZ=
CuG #%*                                                                  *+Ex=
CuG #%*!Mx)ExQX4ZPZ4SP5n#5X!)Ex+ExPQXH,B+ExP[-9Z-9Z)GA(W@'UTTER_XYZZY'CPK*+
CuG #(*                                                                  *(
C   # */);                                                              /*(
C   # *)  program        polyglot (output);                             (*+
C   #     identification division.
C   #     program-id.    polyglot.
C   #
C   #     data           division.
C   #     procedure      division.
C   #
C   # * ))cleartomark   /Bookman-Demi findfont 36 scalefont setfont     (
C   # *                                                                 (
C   #
C   # *                  hello polyglots$
C   #     main.
C   #         perform
C     * ) 2>_$$; echo   "hello polyglots"; rm _$$; exit
              print
C             stop run.
     -*,                'hello polyglots'
C
C         print.
C             display   "hello polyglots".                              (
C     */  int i;                                                        /*
C     */  main () {                                                     /*
C     */      i=printf ("hello polyglots\n"); O= &i; return *O;         /*
C     *)                                                                (*
C     *)  begin                                                         (*
C     *)      writeln  ('hello polyglots');                             (*
C     *)                                                                (* )
C     * ) pop 60 360                                                    (
C     * ) pop moveto    (hello polyglots) show                          (
C     * ) pop showpage                                                  ((
C     *)
           end                                                          .(* )
C)pop%     program       polyglot.                                      *){*/}
------------------------------ cut here --------------------------------------
 
Have fun...
 
Peter
 
----end-~gnat/Docs/Folklore/polyglot.program----
 
Cheers;
 
Nat.
(gnat@kauri.vuw.ac.nz // Nathan Torkington \\ CSC MS-DOS + etext archive admin)
(C/- Computing Services Centre, P.O. Box 600, Wellington, New Zealand         )
 
The opinions expressed herein are not necessarily those of my employer,
not necessarily mine, and probably not necessary.
 
I have to convince you, or at least snow you...
                -- Prof. Romas Aleliunas, CS 435
 
