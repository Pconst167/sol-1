

 ____________________________________________________________________________
/                                                                            \
|                      HOW TO WRITE A VIRUS PROGRAM                          |
|                                  by                                        |
|                                  The Cheshire Cat                          |
\                                                                            /
 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

        For people who have nothing else to do but cause unprecidented havoc
     on other peoples systems, this is something you should read.  To begin
     with, I'd like to explain briefly to the ignorant readers of this, what
     exactly a virus program is.  A virus program is in the genre of tapeworm,
     leech, and other such nasty programs.  I will show clearly, one possible
     application of it, on an Apple system, and I will demonstrate how easily
     this little pest could lead to wiping out most of someone's important
     disks.  Here we go!

        One day, while I had little else to do, I was reading an computing
     article in some obscure science magazine.  As it happened, the article
     discussed a growing problem in the computer community about the danger
     of virus programs.  Someone quoted in the article said that they wrote
     a very simple virus program and put it on the univerisity computer as
     a test.  All the program did was l}iook through the computers memory,
     and devices (tape drives, hard drives, etc...) for stored programs, and
     when it found one, it would search through the program for itself.  If
     it didn't find anything, it would find an empty spot in the program, and
     implant itself.  This may not sound too exciting, but this little program
     was actually part of another program (maybe a word processor, or spread-
     sheet, or maybe even zaxxon) and whenever someone ran that program, and
     executed the little virus stuck inside it, the virus would stop program
     execution (for a time period that even us humans wouldn't notice) and do
     its little job of infecting other programs with itself.   This example
     of a virus was harmless, but even so, after only 4 hours the whole system
     had to be shutdown and the whole memory core dumped because the virus had
     begun to fill up too much space and it was using up all the mainframe's
     time.  I don't think it would have been so easy if this professor had
     just done this experiment on his own and had not got permission or told
     anyone about it.  Think of the havoc!!
         Well, that has taken up too much time discussing already, so I'll
     add only one more thing before we get down to business, that REAL
     viruses are extemely BAD.  They usually are designed as time bombs that
     start erasing disks, memory, and maybe even backups or the operating
     system after they have been run so many times, or after a certain date
     is reached.  Someone did this to a bank one time (and by the way he was
     never caught!)  He was given the task of designing their operating system
     and security, and he decided he wasn't getting paid enough, so he devised
     his own method of compensation.  Every so often, the computer would steal
     a certain amount of money from the bank (by just CREATING it electronic-
     ally) and would put it in an account that didn't exist as far as the bank
     or the IRS or anybody knew, and whenever this guy wanted, he went to
     the bank and withdrew some money.  They aren't sure how he did it, but
     he probably visited the electronic teller as often as possible.  As I
     said, the authorities still haven't found him, but after several years
     of his leech program being in service, it "expired."  They assume that
     he set it up to destroy itself after so long, and when this little
     program was gone, the bank suddenly was missing several million dollars.
     Now, I wouldn't recommend doing this sort of thing, but then again, who
     said crime doesn't pay?
          Now to discuss the application of this to a Personal Computer is
     very simple.  When I decided to do this, I figured it would be easiest
     to stick my program in the DOS, so that I would always know where to put
     another copy of my virus while it was reproducing itself, and that it
     would be easier to explain why the disk drive is running when it starts
     to initialize your disks.  For those who have a copy of Beneath Apple DOS
     it would be easy to find the space to put in the program.  If you don't,
     I tell you a few places that are not used (or where you can put it and
     it won't be noticed) but I'd recommend getting the book anyways - it's
     an excellent tool for doing these sort of things, and useful even if you
     don't.  As suggestions for where to put it (if you choose to infect DOS),
     you could use BCDF-BCFF which is still unused, or BFD9-BFFF, which WAS
     unused, but has since been used in updates of DOS.  Likewise, I would
     also suggest using space taken up by junk like LOCK or UNLOCK commands.
     Who the hell ever uses them?  Think about it, when was the last time you
     used the lock command?  Get real.  If you don't like that, how about
     MAXFILES.  I've only used that in a program once in my entire life.  I
     know people who couldn't even tell you what it does.  That would make me
     feel safe about sticking a virus there.
           But now comes the part that will be harder for the inexperienced,
     but easier as long as you know what you're doing.  By the way, you've
     been TOTALLY wasting your time reading this if you don't understand
     assembly, because you HAVE TO in order to accomplish a task such as this.
     But, don't fret, you could insert a little BASIC code into some dumb
     utility (like an program whose only function is to initialize disks) that
     would put itself on the disk, as it initializes it (probably as the hello
     program) and would work from that aspect.  Of course, it would be easier
     for a less experienced person to detect, but who really cares!
           As I was saying, however, you now have to write the code.  If you
     work in an area where you are limited memorywise (like I did) it can get
     tough at times.  The only way I got through it was by referring to
     documented listings of all of DOS that I got somewhere, and using bits
     and pieces of routines from other things as much as I could.  When I
     was done, I had a copy of DOS that when it was booted into the computer,
     would work completely properly (except for maybe some bizarre circum-
     stances that I didn't bother testing for), but when someone CATALOGed a
     disk, it did a few different things.  It would first load up the VTOC as
     usual, but then it would jump to MY routine.  In this instance, it was
     very easy to use the VTOC which contains many unused bytes to house my
     counter.  I would increment it, check if it was time to destroy the disk,
     and then execute an INIT, or just save the VTOC.  Then it would save
     three more sectors to the disk.  One was the place where DOS branched to
     my routines, the others were my actual routine.  And thus was born a
     virus.  I guarentee that if anyone has experienced a problem with their
     disks, it was not my fault because I have not yet implemented the virus.
     No one has pissed me off enough to warrant its use.  Even worse is the
     fact that it could backfire (after being distributed across the country,
     I don't doubt I'd end up with it also) because not only was it very well
     planned, but you don't even notice any sort of a pause.  The virus
     executes itself so fast that there is little more than a microsecond of
     a pause while the catalog is going on.  I tried comparing it to a normal
     catalog, and found I couldn't tell the difference.  The only way this
     thing wouldn't work is if the disk it was cataloging wasn't DOS 3.3, and
     if that happened, it would probably screw the disk anyways.  I know
     there are people who will abuse this knowledge, so you may wonder why I
     even bothered writing it.  The fact is that it isn't important to shield
     people from this knowledge, what is important is for people to know that
     can be done, and perhaps find a way to prevent it.  Just consider what
     would happen if someone starting putting a virus in a DDD ][.2.  First of
     all, everyone would get a copy of it and use it.  Only a few would be
     that interested to check what these new updates to it were.  And perhaps
     within a month, whenever you tried to unpack a program, it would instead
     initialize the disk with your file on it.  So, like I said, beware of
     those that would jeapordize themselves and would do such a thing.  Of
     course, I wouldn't hesitate to drop my "bomb" on a few leech friends of
     mine who don't have modems, but thats a different story.  I don't have
     to worry too much about getting the "cold" back from them.  They'll be
     too screwed up to worry about trading disks.  Well, I've said too much
     already.  Please keep my name on this file if you put it on your BBS,
     ect..., but I don't really care if you want to put your local AE line
     number, or whatever up at the beginning too, just give me credit where
     I'm due.  Thank-you, and good luck, and, as I said before, be careful
     out there!!

                       FROM  --  THE CHESHIRE CAT
                        written: 12/30/85
=-=-=-= If you need to reach me for more information, try E-mail on =-=-=-=
=-=-=-=-=-=-=-=-=-=-= OSB systems (215)-395-1291 =-=-=-=-=-=-=-=-=-=-=-=-=-
=-=-=-= I may offer a listing of my virus's coding if there is =-=-=-=-=-=-
=-=-=-= significant interest.  But I leave you now, The Cheshire Cat -=-=-=
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

(>
