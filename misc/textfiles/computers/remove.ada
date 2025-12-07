From: news@fedfil.UUCP (news)
Newsgroups: talk.origins
Subject: The other crusade
Message-ID: <133@fedfil.UUCP>
Date: 29 Nov 92 02:59:28 GMT
Organization: HTE
Lines: 494



This post has absolutely nothing to do with origins, but rather with
the one other crusade I occasionally indulge in on usenet, i.e. the
crusade to rid the earth of the Ada programming language.  I am about as 
universally loved in the Ada group as on t.o. and for the same basic
crime, preaching reality.  I've had one such article published in the
C++ Journal, and a number of others which are favorites on usenet (comp.
lang.ada), and the following article is probably THE all time favorite.

Two reasons for bringing this up at all:  to give t.o. readers just a tad
more than the one-dimensional view of myself which you'd get on t.o., and 
two, as an exmple of the utility of comprehending something BEFORE it
becomes common knowledge.  Not too many people would have told you that
Ada was not going to make it even two years ago;  I've been telling 
everybody who would listen that Ada couldn't make it for five years.
Traffic on comp.lang.ada now concerns the demise of the Army STANFINS
project at Fort Benjamin Harrison, the project which General Short
said Ada would live or die with.

................................................................
................................................................


I and a number of my associates, as well as a number of the most
prominent computer scientists of our age, most notably Charles Anthony
Richard Hoare, the inventor of the quick-sort process (Turing Award
Lecture, 1980), believe the Ada programming language to be not only a
major source of frustration and unnecessary cost to everybody involved
with it, but an actual threat to the security of the United States and
of any other nation which might become involved with it.

The following is from usenet:


 From: Nigel Tzeng, NASA


>Oh yes...on the other front...executable size...we are sometimes space limited
>on the size of the programs we can have in the on-board systems...how do the
>C vs ADA sizes compare?
 
>This information is important to know...otherwise we cannot make an intelligent
>decision on which language to use in the future.  NASA is trying to figure out
>if they should adopt ADA as the single official language.  Developers at NASA
>need to know the hard data in order to decide whether to support such a stand.
 
Good thinking.  With enough work and most Ada features turned off, Ada speeds
for some tasks should approach those of C.  This has little or nothing to do
with the BIG problems of Ada, which are philosophical/economic in nature
and not easily amenable to technical solution.  Executable size is a
symptom of one such problem.


From: Jim Harkins, Scientific Atlanta, San Diego, CA

>(Bill Wolfe) writes:
>>   There is a great need for a single production programming language
>>   which supports good software and code engineering practices.

>Yep, and there is great need for a single type of automobile.  Any idiot can
>see that not only is it extremely dangerous for a person to go from driving
>a Hyndai Excel to a Ford Aerostar, as a nation we are wasting an awful lot
>of time both in learning new skills and in designing automobiles that differ
>in several respects.  I think a good compromise would be the Ford Escort...

This is a REAL good analogy, but I'm afraid Jim doesn't carry it far
enough, simply because he can't conceive of it actually happening.
Problem is, the Ada crew CAN.  You have to put yourself in their
shoes;  they want to control the two extremes of programming, embedded
systems and mainframe/database work, and everything in between and,
hence, they need every feature in the world in their CORE LANGUAGE.
Letting people make up their own libraries for applications (as per C/UNIX)
would be too much like a free system.  Logical consequence:


  "My only problem with Ada at this point is the cost ($ and hardware
  resources) of a compiler for my XT clone.  Both IntegrAda and Janus require
  more memory than DOS 4.01 leaves available.  This is BAD DESIGN.  There
  is no excuse for a 551K executable in a PC (pass 2 of Integrada).  Janus
  Ada requires > 580K available to run, and rumor has it that the Integrada
  compiler is a repackaged Janus compiler."
             
From a recent comp.lang.ada posting.


Everybody begins to realize: "Hey!, looks like Ada's the only
thing I'm ever gonna have, so I'd better see to it that everything I
ever plan on doing is part of Ada...", and we get Ada-9x, the language
which will include all the great features that Ada left out.  Kind of like
quick-sand or one of those old Chinese finger traps... the more you
struggle, the worse it gets.

The good news is that, given the speed at which these things happen,
Ada-9x is probably 10 years away.  The bad news is two-fold:  first,
Ada-9x will probably break all existing Ada code and, second, the clunk
factor will likely be so great (1,000,000+ bytes for "HELLO WORLD" might
actually be achieveable), that no more working Ada code will ever be written
afterwards.  Total paralysis.

Several times recently, Ada affectionados have posted articles
concerning the national information clearinghouse for Ada-9x, including
the phone-modem number (301) 459-8939 for Ada-9x concerns.  This BBS
contains 744 recent user comments on Ada in it's present state; true life
experiences of actual Ada sufferers.  These are grouped in bunches of 50
in self-extracting zip files (e.g. 101-150.exe) and may be downloaded.
For instance:


complaint #0300


   PROBLEM:

   Currently, to create and mature an Ada compiler, it takes from
   3..5 years.  For the new architectures of the future and rapid
   compiler development, the language needs to be expressed in terms
   that are easy to parse and to generate code.

   The definition should be revamped so that the grammar in Ada to
   conform to LR(m,n) for consistent/complete parsing rules -- the
   most efficient and accurate compiler techniques.  Move more
   semantics to the grammar specification to rid the language
   definition of so many special cases.

The solution proposed, unless I'm missing something, would break nearly
all existing Ada code, hence it isn't likely to happen.  Doesn't say
much for the basic design of Ada either, does it?

Add the time to finish the 9x standard and the 2 - 3 year time between
first-compiler <--> compiler-which-anybody-can-stand-to-use, and you get
my ten year figure for 9x.  Sort of;  there may never actually be a 9x
compiler which anybody can stand to use.

Here's the rub:  a casual reading of the 744 little "problems" would
lead one to believe that 1 out of every ten or so was a show-stopper, and
that nine of ten are just people whining for new features.  This would
be a misinterpretation.  In fact, it's probably all of those new
features which are the big serious problem, given past history.  The ten
year problem, however, says that anybody figuring to use Ada starting
now had best get used to the more minor problems (the 1 out of 10).
These include:


complaint #0237

    We cannot adequately configure large systems as the language now
    stands.  There are no standard means of performing the kind of
    operations on library units generally considered desirable.  These
    include:
    -     creating a new variant or version of a compilation unit;
    -     mixed language working, particularly the use of Ada units by
          other languages;
    -     access control, visibility of units to other programmers;
    -     change control and the general history of the system.
    The inability to do these things arises out of a few loosely worded
    paragraphs in the LRM (in 10.1 and 10.4), which imply the existence
    of a single Ada program library, whose state is updated solely by
    the compiler.  This can be an inconvenient foundation on which to
    build.  The relationships between compilations in a project will be
    determined by the problem and the organization of work, and any
    automatic enforcement of a configuration control regime must come
    from a locally chosen PSE.  Ada especially, as a language with large
    and diverse application, must have a separate compilation system
    which gives the greatest freedom possible in this area.


    IMPORTANCE:

    ESSENTIAL

    Ada was intended for use in large projects, involving many people,
    possibly at different centers.  These are precisely the projects
    which will collapse if the programming support technology is
    inadequate.



That is, Ada can't realistically be used for large systems.


complaint #0150

    Due to the availability of virtual memory, most minicomputer
    and mainframe programmers rarely consider the size of main memory
    as a limiting factor when creating their programs.  In contrast,
    th size of main memory is a major concern of microcomputer
    programmers.  The most widely used microcomputer operating
    systems, MS-DOS, does not have virtual memory capabilities.
    Without the availability of special programming techniques to get
    around this limitation, microcomputer programmers would have to
    severely limit the functionality of their programs, and, it would
    be impossible to create large, integrated information systems for
    microcomputers.  One of most widely used of these programming
    techniques is the "chaining" capability provided in many
    programming languages.  "Chaining" gives a programmer the ability
    to break down large integrated information systems into separate
    executable programs, and, then, when the system is operated, swap
    these programs in and out of main memory as the need arises.
    "Chaining", in effect, simulates virtual memory.  Ada does not
    have the capability to chain programs.  As a result,
    microcomputer programmers who use Ada must severely limit the
    functionality of their programs.

    Importance (1-10)

    1 - Microcomputer programmers who use Ada will have to
    continue limiting the functionality of their programs.
    Current Workarounds

    Programmers must either limit the functionality of their Ada
    programs or use a proprietary CHAIN command supplied by the
    compiler manufacturer - which hurts portability.


I.e., Ada can't be used for small systems... klunk factor's too high.


Consider the one feature which might come remotely close to justifying
this giant klunk factor:  object-oriented capabilities.

complaint #0599

 
    PROBLEM:

    Inheritance has become one of the standard attributes of
    modern object-oriented programming languages (such as C++
    and Smalltalk-80).  Unfortunately, Ada is quite deficient in
    its support for inheritance ( it is based primarily on
    derived types, and then not particularly well),  and this is
    a valid criticism leveled at the language by critics (and C
    bigots who, if forced to learn a new language, simply prefer
    to learn C++).  There are currently many proposals to add
    full-blown inheritance (and other standard object-oriented
    attributes, such as polymorphism) to Ada; the scope of this
    revision request is much more modest, intended only to make
    the derived type mechanisms that already exist work better.

    IMPORTANCE: ESSENTIAL

    If the lack of modern object-oriented attributes is not
    addressed in Ada 9X, Ada will almost certainly become the
    FORTRAN of the '90's.

    CURRENT WORKAROUNDS:

    Be thankful for what limited object-oriented support is
    offered by the current language.




Consider Ada's original primary mandate:  embedded systems:


complaint #0021


      PROBLEM:

    A high priority task may be suspended because it needs to rendezvous with
    a low priority task.  That low priority task does not get scheduled
    promptly because of its priority.  However this causes the high priority
    task to be suspended also.

    IMPORTANCE:  (7)

    This problem makes the use of task priorities extremely difficult to apply
    correctly in a large system.  It limits the ability to use task priorities
    to improve throughput in a system.


complaint #0072



   PROBLEM:

   The Ada priority system has proved quite inadequate for the
   needs of certain classes of hard realtime embedded systems.
   These are applications where a high degree of responsiveness
   is required.

   For example, there is a major conflict between the fifo
   mechanism prescribed for the entry queue and the need for the
   highest priority task to proceed wherever possible.


complaint #0084
   
   problem

   Ada tasking involves too much run-time overhead for some high-performance
   applications, including many embedded systems applications for which the
   language was designed. This overhead not only slows down the program in
   general, but may also occur at unpredictable times, thus delaying response at
   critical times. To avoid the overhead, real-time programmers frequently
   circumvent Ada tasking.

   The problem is exacerbated by Ada's lack of support for those who do try to use
   tasking in an efficient manner. There is no standard set of guidelines to
   programmers for writing optimizable tasking code, or to language implementors,
   for deciding which optimizations to perform. Also, there is no simple way for a
   programmer who is concerned with writing portable high-performance code to
   check that optimizations applied under one implementation will be applied under
   different implementations.

   The consequences of Ada tasking overhead have not gone unnoticed in higher
   circles of government. A recent General Accounting Office report [1] noted that
   Ada has limitations in real-time applications that require fast processing
   speed, compact computer programs, and accurate timing control. All three of
   these requirements are directly and adversely affected by Ada's current
   tasking overhead.


complaint #0278


   PROBLEM:

   In the last 5 years, tomes have been written on the Ada tasking
   model.  It is too complex and has too much overhead for embedded
   systems to utilize effectively.  It also does not fit well with
   architectures found in embedded systems, e.g., multiprogramming/
   distributed processing.  The control mechanisms are not
   responsive to realtime needs.  Applications programs are
   responsible for housekeeping on context switches where the
   process will not return to the previously selected context.  The
   model does not support the well-known basic scheduling
   disciplines, e.g., preempt or nonpreempt and resume or nonresume,
   see Conway's Theory of Scheduling.  The problems with tasking
   efficiency is not the maturity of the compilers, but in the
   underlying model defined in the language and the validation
   requirements for the compilers.

   importance:  very high, one of the major goals for the Ada 9x

   current workarounds: Programming standards to avoid tasking or
   only initiate a single task and to not use rendezvous of any kind
   as they are too unpredictable and require too much overhead.
   Allow the ACVC not to test this section so that the application
   does not have to absorb a runtime system from a compiler vendor
   that has little experience with the applications.

   Or, write in a language like Modula-2 or object oriented C++ that
   does not interfere in the target architecture.



i.e. Ada can't really be used for embedded systems, its original mandate.
How about something simple like string handling?


complaint #0163

Problem: 
  Strings are inadequate in Ada.  It is very frequently the case that
  the length of a string is not known until it is formed...after it
  has been declared.  This leads to ugly, clumsy constructions (blank
  pad everything, keep track of length separately, play tricks with
  DECLARE's and constant strings, etc.).  The obvious solution of
  writing a variable-length string package (see LRM, section 7.6) is
  unsatisfactory:  you are lead to a limited private type because
  neither the standard equality test nor assignment are appropriate.
  (you want the both to ignore everything beyond the actual length of
  the strings)  For limited private types, however, you have no
  assignment statement at all.  We implemented such a package and
  found that using a procedure (SET) for assignment was error-prone
  and hard-to-read.  This even for experienced programmers and even
  after getting beyond the initial learning curve for the package.


How about something REAL SIMPLE, like argc/argv?

complaint #355


   PROBLEM:

   It is difficult, in a standard manner, to get at the operating
   system command line arguments supplied when the program is invoked.


   IMPORTANCE:

   (Scale of 1 - 10, with 10 being most important):
   <<8>>


   CURRENT WORKAROUNDS:

   Look up in vendor-specific manuals the method of accessing the
   command line parameters and access them differently on different
   operating systems.
 

What about writing an OS in Ada (so that real "software engineers" won't have
to screw around with UNIX anymore)?

complaint #0186


    It is difficult, if not impossible, to use Ada to write an operating
    system.  For example, a multiprocessor naval command and control
    system might need basic software, comparable in complexity to a
    minicomputer network operating system, to support fault tolerance,
    load sharing, change of system operating mode etc.  It is highly
    desirable that such important software be written in Ada, and be
    portable, i.e. be quite independent of the compiler supplier's Ada
    run time system.  Currently, it would be very difficult to do this
    in Ada, because of the difficulty of manipulating tasks of arbitrary
    type and parentage.

    IMPORTANCE: 7.


    CURRENT WORKAROUNDS:

    Use operating systems written in C or assembler.

    Write the operating system as an extension of the Ada run time
    system - this is undesirable because it is non-portable and
    unvalidated.


What about basic portability?


complaint #0365


   Problem:
   Implementation Options Lead to Non-Portability and
   Non-Reusability.

   Discussion:     The LRM allows many implementation
   options and this freedom has lead to numerous
   "dialects" of Ada.  As programs are written to rely on
   the characteristics of a given implementation,
   non-portable Ada code results.  Often, the programmer
   is not even aware that the code is non-portable,
   because implementation differences amy even exist for
   the predefined language features.  Further, it is
   sometimes not impossible to compile an Ada program with
   two different implementations of the same vendor's
   compiler.

   Another kind of non-portability is that of the programmer's
   skills,  The user interfaces to Ada compilers have become so
   varied that programmers find it very difficult to move from
   one Ada implementation to another,  Not only does the
   command line syntax vary, but so do program library
   structures, library sharability between users, compiler
   capabilities, capacity limits. etc.

   Importance:     ESSENTIAL

   Current Workarounds:

   Significant amounts of code rewriting, recompilation, and
   testing must be done to get a given Ada program to compile
   and to run successfully using another compiler, if at all
   possible, even on the same host-target configuration.  It
   is very difficult to write a truly portable Ada program.

   Another possible solution to porting an Ada program is for
   a customer to carefully choose a compiler to suit the given
   Ada program, or perhaps collaborate with a vendor to tailor
   the compiler to suit these needs.

   Significant amounts of programmer retraining must occur
   when a different Ada compiler is used.



Somehow, all of this is beginning to remind me of a song I used to hear in
the late 60's/early 70's (roughly paraphrased):


  "ADA! - KUH! - Yeah!, what is it GOOD for, absolutely NOTHIN!, say
  it again...  ADA! - KUH! - Yeah..."








-- 
Ted Holden
HTE
 