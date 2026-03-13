
        Linux: Free Unix Information Sheet 


        0.1 Introduction to Linux 

        Linux is  a completely free  clone of the  unix operating system 
        which is available  in both source  code and binary  form. It is 
        copyrighted by Linus  B. Torvalds (torvalds@kruuna.helsinki.fi), 
        and is freely redistributable under  the terms of the Gnu Public 
        License. Linux runs only on 386/486 machines with an ISA or EISA 
        bus.  MCA (IBM's  proprietary  bus) is  not  currently supported 
        because   there  is  little  available  documentation.  However, 
        support for MCA  is being added  at this time.  Porting to other 
        architectures is  likely to  be difficult,  as the  kernel makes 
        extensive  use of  386  memory management  and  task primitives. 
        However,    despite   these  difficulties,   there   are  people 
        successfully working on a port to the Amiga. 

        Linux is still considered to be in beta testing. There are still 
        bugs  in  the  system, and  since  Linux  develops  rapidly (new 
        versions come  out about once  every two weeks),  new bugs creep 
        up. However, these bugs are fixed quickly as well. Most versions 
        are quite stable, and  you can keep using  those if they do what 
        you need and you don't want to be on the bleeding edge. One site 
        has had  a computer  running version  0.97 patchlevel  1 (dating 
        from last summer) for  over 136 days without  an error or crash. 
        (It  would  have  been longer  if  the  backhoe  operator hadn't 
        mistaken a main power transformer for a dumpster...) 

        One thing  to be aware  of is  that Linux is  developed using an 
        open and distributed model, instead  of a closed and centralized 
        model  like much  other software.  This  means that  the current 
        development version is always public (with up to a week or two's 
        delay) so that anybody can use it. The result is that whenever a 
        version  with new  functionality is  released, it  almost always 
        contains bugs, but  it also results in  a very rapid development 
        so  that the  bugs  are found  and  corrected quickly,  often in 
        hours, as  many people work  to fix them.  Furthermore, the bugs 
        are  generally  discovered  within hours  of  a  kernel release, 
        especially those  which might endanger  a user's data,  so it is 
        easy for an end-user to avoid these bugs. 

        In contrast, the  closed and centralized  model means that there 
        is only one person or team working on the project, and they only 
        release software  that they  think is  working well.  Often this 
        leads to long  intervals between releases,  long waiting for bug 
        fixes, and slower development. Of  course, the latest release of 
        such software to the public is  often of higher quality, but the 
        development speed is generally much slower. 

        As  of March  17, 1993,  the  current version  of Linux  is 0.99 
        patchlevel 7. 


        0.2 Linux Features 


         * multitasking: several programs running at once. 

         * multiuser: several users on the  same machine at once (and NO 
           two-user licenses!). 

         * runs in 386 protected mode. 

         * has memory protection between  processes, so that one program 
           can't bring the whole system down. 

         * demand loads  executables: Linux  only reads  from disk those 
           parts of a program that are actually used. 

         * shared copy-on-write pages among executables. 

         * virtual memory using paging (not swapping whole processes) to 
           disk: to a separate partition or a file in the filesystem, or 
           both,  with the  possibility  of adding  more  swapping areas 
           during runtime (yes, they're  still called swapping areas). A 
           total of  16 of  these 16  MB swapping  areas can  be used at 
           once, for a total 256 MB of useable swap space. 

         * a unified  memory pool for  user programs and  disk cache (so 
           that all free memory  can be used for  caching, and the cache 
           can be reduced when running large programs). 

         * dynamically linked shared  libraries (DLL's)(static libraries 
           too, of course). 

         * does core dumps for post-mortem analysis (using a debugger on 
           a program after it has crashed). 

         * mostly compatible with POSIX, System V, and BSD at the source 
           level. 

         * all source code is available,  including the whole kernel and 
           all  drivers, the  development tools  and all  user programs; 
           also, all of it is freely distributable. 

         * POSIX job control. 

         * pseudoterminals (pty's). 

         * 387-emulation in the kernel so that programs don't need to do 
           their  own  math  emulation.  Every  computer  running  Linux 
           appears to have a math coprocessor. 

         * support for many national or  customized keyboards, and it is 
           fairly easy to add new ones. 

         * multiple virtual consoles: several independent login sessions 
           through  the  console,  you  switch  by  pressing  a  hot-key 
           combination (not dependent on video hardware). 

         * Supports  several common  filesystems, including  minix-1 and 
           Xenix,  and  has an  advanced  filesystem of  its  own, which 
           offers  filesystems  of up  to  4  TB, and  names  up  to 255 
           characters long. 

         * transparent   access  to  MS-DOS   partitions  (or  OS/2  FAT 
           partitions)  via a  special  filesystem: you  don't  need any 
           special commands to  use the MS-DOS  partition, it looks just 
           like a normal Unix  filesystem (except for funny restrictions 
           on filenames, permissions, and so on). 

         * CD-ROM   filesystem  which  reads  all  standard  formats  of 
           CD-ROMs. 

         * TCP/IP networking, including ftp, telnet, NFS, etc. 


        0.3 Hardware Issues 


        0.3.1 Minimal configuration 

        The following  is probably  the smallest  possible configuration 
        that Linux will work  on: 386SX/16, 2 MB RAM,  1.44 MB or 1.2 MB 
        floppy, any supported video card  (+ keyboards, monitors, and so 
        on of course). This should allow you to boot and test whether it 
        works  at  all on  the  machine, but  you  won't be  able  to do 
        anything useful. 

        In order to do something, you  will want some hard disk space as 
        well, 5 to 10  MB should suffice for  a very minimal setup (with 
        only the  most important commands  and perhaps one  or two small 
        applications installed, like, say,  a terminal program). This is 
        still very, very limited, and  very uncomfortable, as it doesn't 
        leave  enough  room  to  do  just  about  anything,  unless your 
        applications are  quite limited. It's  generally not recommended 
        for anything  but testing  if things work,  and of  course to be 
        able to brag about small resource requirements. 


        0.3.2 Usable configuration 

        If you are going to run computationally intensive programs, such 
        as gcc, X,  and TeX, you  will probably want  a faster processor 
        than  a  386SX/16,  but  even that  should  suffice  if  you are 
        patient. 

        In practice, you need at  least 4 MB of RAM  if you don't use X, 
        and 8 MB if you do. Also, if you want to have several users at a 
        time, or run  several large programs  (compilations for example) 
        at a time, you may want more  than 4 MB of memory. It will still 
        work with a  smaller amount of  memory (should work  even with 2 
        MB), but  it will  use virtual memory  (using the  hard drive as 
        slow memory) and that will be so slow as to be unusable. 

        The amount of  hard disk you  need depends on  what software you 
        want to install. The normal basic set of Unix utilities, shells, 
        and administrative programs  should be comfortable  in less than 
        10 MB, with  a bit of room  to spare for user  files. For a more 
        complete system, SLS  reports that a full  base system without X 
        fits into 45 MB, with X into  70 MB (this is only binaries), and 
        a complete  distribution with  everything takes  90 MB.  Add the 
        whatever  space you  want  to reserve  for  user files  to these 
        totals. 

        Add more  memory, more hard  disk, a faster  processor and other 
        stuff depending  on your needs,  wishes and budget  to go beyond 
        the merely  usable. In general,  one big difference  from DOS is 
        that with Linux, adding memory makes a large difference, whereas 
        with dos, extra  memory doesn't make  that much difference. This 
        of course has something to do with DOS's 640KB limit. 


        0.3.3 Supported hardware 

        CPU: Anything that runs 386  protected mode programs (all models 
        of 386s and 486s should work; 286s don't work, and never will). 

        Architecture: ISA  or EISA bus  (you still need  an ISA-bus hard 
        disk controller,  though). MCA (aka  PS/2) does  not work. Local 
        bus works. 

        RAM:  Theoretically  up to  1  GB,  but using  more  than  16 MB 
        requires that the kernel be recompiled. 

        Data storage: Generic AT drives (IDE, 16 bit HD controllers with 
        MFM or RLL) are  supported, as are SCSI  hard disks and CD-ROMs, 
        with a  supported SCSI  adaptor. Generic  XT controllers  (8 bit 
        controllers with MFM or RLL) need  a special driver which is not 
        currently part of the  standard kernel. Supported SCSI adaptors: 
        Adaptec  1542  (but  not  1522),  1740  in  extended  (not  1542 
        compatible) mode, Seagate ST-01 and ST-02, Future Domain TMC-88x 
        series (or any board based on the TMC950 chip) and TMC1660/1680, 
        Ultrastor 14F, and Western Digital wd7000. SCSI and QIC-02 tapes 
        are also supported. 

        Video: VGA, EGA, CGA, or Hercules (and compatibles) work in text 
        mode. For graphics and  X, there is support  for (at least) EGA, 
        normal VGA,  some super-VGA  cards (most  of the  cards based on 
        ET3000, ET4000,  Paradise, and  some Trident  chipsets), some S3 
        cards (not Diamond Stealth,  because the manufacturer won't tell 
        how  to  program  it), 8514/A,  and  hercules.  (Linux  uses the 
        Xfree86 X server, so that determines what cards are supported.) 

        Other hardware: SoundBlaster, AST  Fourport cards (with 4 serial 
        boards),  several  flavours of  bus  mice  (Microsoft, Logitech, 
        PS/2). 


        0.4 An Incomplete List of Ported Programs and Other Software 


        Most of the common  Unix tools and programs  have been ported to 
        Linux, including almost all of the  GNU stuff and many X clients 
        from various  sources. Actually,  ported is  often too  strong a 
        word,  since  many  programs  compile  out  of  the  box without 
        modifications, or only small modifications, because Linux tracks 
        POSIX  quite closely.  Unfortunately,  there are  not  very many 
        end-user  applications at  this time.  Nevertheless, here  is an 
        incomplete list of software that is known to work under Linux. 

        Basic Unix commands:  ls, tr, sed,  awk and so  on (you name it, 
        we've probably got it). 

        Development tools: gcc, gdb, make,  bison, flex, perl, rcs, cvs, 
        gprof. 

        Graphical environments: X11R5 (Xfree86), MGR. 

        Editors: GNU Emacs, Lucid Emacs, MicroEmacs, jove, epoch, elvis, 
        joe, pico. 

        Shells: Bash,  zsh (include  ksh compatiblity  mode), tcsh, csh, 
        rc, ash. 

        Telecommunication: Taylor  (BNU-compatible) UUCP,  kermit, szrz, 
        minicom, pcomm, xcomm, term/slap  (runs multiple shells over one 
        modem line), and Seyon. 

        News and mail: C-news, trn, nn, tin, smail, elm, mh. 

        Textprocessing: TeX, groff, doc. 

        Games: Nethack, several Muds and X games. 

        All of these programs  (and this isn't even  a hundredth of what 
        is available) are freely available. 


        0.5 Getting Linux 



        0.5.4 Anonymous FTP 

        At least  the following  anonymous ftp  sites carry  Linux. This 
        list is taken from the Meta-FAQ list, which is posted every week 
        to  the comp.os.linux  newsgroup (the  Meta-FAQ is  updated more 
        often than this information sheet, so  the list below may not be 
        the most current one). 



         Textual name                   Numeric address  Linux directory
         =============================  ===============  ===============
         tsx-11.mit.edu                 18.172.1.2       /pub/linux
         sunsite.unc.edu                152.2.22.81      /pub/Linux
         nic.funet.fi                   128.214.6.100    /pub/OS/Linux
         ftp.mcc.ac.uk                  130.88.203.12    /pub/linux
         fgb1.fgb.mw.tu-muenchen.de     129.187.200.1    /pub/linux
         ftp.informatik.tu-muenchen.de  131.159.0.110    /pub/Linux
         ftp.dfv.rwth-aachen.de         137.226.4.105    /pub/linux
         ftp.informatik.rwth-aachen.de  137.226.112.172  /pub/Linux
         ftp.ibp.fr                     132.227.60.2     /pub/linux
         kirk.bu.oz.au                  131.244.1.1      /pub/OS/Linux
         ftp.uu.net                     137.39.1.9       /systems/unix/linux
         wuarchive.wustl.edu            128.252.135.4    mirrors/linux
         ftp.win.tue.nl                 131.155.70.100   /pub/linux
         ftp.stack.urc.tue.nl           131.155.2.71     /pub/linux
         srawgw.sra.co.jp                                /Linux
         ftp.ibr.cs.tu-bs.de            134.169.34.15    /pub/os/linux
         cair.kaist.ac.kr                                /pub/Linux
         ftp.denet.dk                   129.142.6.74     /pub/OS/linux



        tsx-11.mit.edu and  fgb1.fgb.mw.tu-muenchen.de are  the official 
        sites for Linux' GCC. Some  sites mirror other sites. Please use 
        the site closest (network-wise) to you whenever possible. 


        0.5.5 Other methods of obtaining Linux 

        There are many  BBS's that have  Linux files. A  list of them is 
        maintained  by  Zane Healy;  he  posts it  to  the comp.os.linux 
        newsgroup around the  beginning and middle  of the month, please 
        see that post  for more information.  comp.os.linux is echoed on 
        the   LINUX  echoid  on  fidonet.  This  list  is  available  as 
        tsx-11.mit.edu:/pub/docs/bbs.list,   and  is  mirrored  on  fine 
        mirrors everywhere. 

        There is also  at least one  organization that distributes Linux 
        on floppies, for a fee. Contact 


               Softlanding Software
               910 Lodge Ave.
               Victoria, B.C., Canada
               V8X-3A8
               +1 604 360 0188
               FAX: 604 385 1292

        for  information on  purchasing. There  is also  an organization 
        which sells Linux on CD-ROM --- contact 


               Yggdrasil Computing, Incorporated
               CDROM sales
               PO Box 8418
               94707--8418
               510--526--7531

        for  information on  purchasing the  CD-ROM. Also,  don't forget 
        about friends and user's groups, who are usually glad to let you 
        make a copy. 


        0.5.6 Getting started 

        As   mentioned  at   the  beginning,  Linux   is  not  centrally 
        administered. Because of this,  there is no ``official'' release 
        that  one could  point at,  and  say ``That's  Linux.'' Instead, 
        there  are various  ``distributions,''  which are  more  or less 
        complete collections of software configured and packaged so that 
        they can be used  to install a Linux  system. The most important 
        one is currently the SLS release. 

        SLS  is  put  together  by  Peter  MacDonald,  and  is  the more 
        full-featured one. It  contains much of  the available software, 
        and includes X.  I really recommend SLS  to anyone who's serious 
        about getting started with Linux. 

        The first  thing you should  do is to  get and read  the list of 
        Frequently Asked Questions  (FAQ) from one of  the FTP sites, or 
        by     using    the   normal    Usenet   FAQ    archives   (e.g. 
        pit-manager.mit.edu). This  document has  plenty of instructions 
        on what to  do to get started,  what files you  need, and how to 
        solve  most  of  the  common  problems  (during  installation or 
        otherwise). 


        0.6 Legal Status of Linux 


        Although Linux is supplied with  the complete source code, it is 
        copyrighted   software,  not  public   domain.  However,  it  is 
        available for free under the GNU Public License. See the GPL for 
        more information.  The programs that  run under  Linux have each 
        their own copyright, although  much of it uses  the GPL as well. 
        All of the software on the  FTP site is freely distributable (or 
        else it shouldn't be there). 


        0.7 News About Linux 


        There   is   a  Usenet   newsgroup,  comp.os.linux,   for  Linux 
        discussion, and  also several mailing  lists. See  the Linux FAQ 
        for more information about the mailing lists (you should be able 
        to find the FAQ either in the newsgroup or on the FTP sites). 

        The  newsgroup comp.os.linux.announce  is a  moderated newsgroup 
        for announcements about Linux (new programs, bug fixes, etc). 

        For the current status of the  Linux kernel and a summary of the 
        most recent versions, finger torvalds@kruuna.helsinki.fi 

        There is also a more  or less weekly ``newsletter,'' Linux News, 
        which summarizes  the most important  announcements and uploads, 
        and    has  occasional   other   articles  as   well.   Look  in 
        comp.os.linux.announce for a sample issue. 


        0.8 Future Plans 


        Work is underway on Linux version  1.0, which will close some of 
        the gaps in the  present implementation. The major functionality 
        shortcomings      are   advanced    interprocess   communication 
        (semaphores,  shared memory),  closer compatibility  with POSIX, 
        and a lot of tweaking. Documentation is also sorely missing, but 
        is  being  worked  on  by  those  on  the  ``Linux Documentation 
        Project'' (the DOC channel of the linux-activists@niksula.hut.fi 
        mailing  list).  By  April  1993  there  should  be  a  complete 
        installation and getting started manual for Linux. 


        0.9 This document 


        This    document   is   maintained   by   Michael   K.  Johnson, 
        johnsonm@stolaf.edu. Please mail me with any comments, no matter 
        how small. I  can't do a  good job of  maintaining this document 
        without your help. A current copy of this document can always be 
        found as  tsx-11.mit.edu:/pub/linux/docs/INFO-SHEET, and  a .dvi 
        version can be found as INFO-SHEET.dvi, in the same directory. 


        0.10 Legalese 


        Trademarks are owned by their owners. There is no warranty about 
        the information in this document. Use and distribute at your own 
        risk. The content of this document  is in the public domain, but 
        please be polite and attribute any quotes. 

