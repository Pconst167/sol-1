.c -*- Hey, ZISNAGAZ (ZISNAGAZ Is Not As Good As Zwei), this is bogus Text -*-

RELEASE NOTES FOR SYSTEM 286 (TM)

(c) 1982 Slimebolics Machines Inc.

Enhancements (c) 1982 Metaphorics, Inc.

Enhancements (c) 1982 Digicomputronomatics,
	a Division of Flexopneumohydroservosystematization and Control
	[better known by its acronym, Flexopneumohydroservosystematization and C]

Enhancements (c) 1982 Hyperbolics, Inc.

  (The number 286 is a trademark of Hyperbolics, Inc.  Usage of System 286 or
MCR286 (used by systems 231-285) will result in prosecution.)

*** An invalid MIT copyright notice on OZ:SRC:<L.DOC>SYS286.MSG removed on
*** 2/31/82 by Hyperbolics personnel.  This file had been installed as the
*** official SLiMi source in direct contravention to instructions to
*** Digicomputronomatics personnel acting on Metaphorics' behalf.

INTRODUCTION

These notes accompany the Symbolic Lisp Machines Inc. (SLiMi) software release
that includes System version 286 (TM).  They cover all important changes since
the System 279 (TM) release notes, except those you get to find out about for
yourself.

This document is in the following files:

EE:LIB:<LISPM.DOCUMENTATION>SYSTEM-286.RELEASE
AI: LMDOC; SYS286 MSG
OZ: SRC: <L.DOC>SYS286.MSG
SCRC:<DOC>MIT-RELEASE-286.TEXT

There have been no particularly major changes in system 286 (TM).  There are
the usual slew of minor bug fixes, some slight performance improvements, some
minor new features, and a pile of new bugs.  Hoo Boy!

This set of release notes is very, very long.  To help make it more manageable,
these release notes are divided into five sections:

 o  Changes to take note of.

      Everybody should read, or at least skim, this section.  It tells
      about incompatible changes that might break programs, or that might
      confuse you.  Don't worry, most of them confuse us too.

 o  Changes that only affect advanced users.

      The changes in this section might break programs written by advanced
      users, but are very unlikely to affect normal or casual users of the
      system.  You only have to worry about things in this section if you
      work with advanced subsystems and use advanced features.  Regretably,
      we have yet to locate a normal user of our systems.  You'll all have
      to slog through this garbage eventually.  Get it over with now.

 o  Upward-compatible changes.

      This section documents new features.  You can skip this entirely if
      you don't feel like reading a lot of stuff.  However, there are
      several interesting new features that you might like to know about,
      and we encourage you to take advantage of them.  The mandatory Pascal
      syntax required in this release is a good example.  Maintainers of
      non-SLiMi systems will want to look here to see what code to copy.

 o  Notes.

      This section isn't about changes at all.  It answers some commonly
      asked questions and provides various news.  Of course, you can skip
      this entirely if you like, but we haven't got anywhere else to advertise.
      We'll know if you skip it, though.  Wait till you want help.

 o  Bugs.

     This section really doesn't tell you much, except for which functions
     the documention had been deleted as the functions don't work.  You
     also can safely skip this section, especially if you don't care why
     your machine just crashed.  A bug in our text formatter (Scribble,
     not for non-personnel) has caused this section to disappear.
    


SUMMARY OF CHANGES.
 
Changes to take note of.
[1] The garbage collector now works.
[2] Recursion is now obsolete and will generate compiler warnings.  Use LOOP.
[3] Common lisp installed.
[4] LOOP is now obsolete and will generate compiler warnings.  Use recursion.
[5] Docuemtation for all numbers.

Changes that only affect advanced users.
[1] In Zwei, M-X Visit Other Window in Other Microcode works again.
[2] Change to implementation of WITHOUT-INTERRUPTS and UNWIND-PROTECT.
[3] SK combinators are now the primitive programming elements.
[4] Bug in HALTSP fixed.

Upward-compatible changes.
[1] ZMail has new menu item "IGNORE".
[2] LOOP has been extended.
[3] Advertising.
[4] CAR and CDR now return extra values.
[5] The TV:WIN-BIG special form.
[6] m-X View Function Through Rose Colored Glasses.
[7] New file system editor.
[8] RMail installed.
[9] Password server.
[10] JCL support as alternative to system menu.
[11] A new system, the CIRCULATORY system, has been added.
[12] Compiler optimization.
[13] NIL ;;we're superstitious
[14] New server: EVIL server.
[15] Package DWIM improved.
[16] New special form:  WITHOUT-NES
[17] New function:  TV:DWIMIFY
[18] Memory storage and allocation improved.
[19] Personality awareness.
[20] New ZWEI commands.

Notes.
[1] New mice.
[2] Helpful hints in using CPT monitors.
[3] Confusion concerning MAPCAR cleared up.
[4] New machine to be relased soon.
[5] New address for bug reports.



CHANGES TO TAKE NOTE OF.

[1] The garbage collector now works.  In addition a new, experimental
    garbage collection algorithm has been installed.

    With SI:%%DSK-GC-QLX-BITS set to 17. [the default] the old garbage
    collection algorithm remains in force: when virtual storage is filled,
    the machine cold boots itself.

    With SI:%%DSK-GC-QLX-BITS set to 23. the new garbage collector is
    enabled.  Unlike most current garbage collectors, the new gc starts its
    mark phase from the mind of the user, rather than from the obarray.
    This allows the garbage collection of significantly more Qs.  As the
    garbage collector runs, it may ask you something like ``Do you remember
    what SI:RDTBL-TRANS does?'' and if you can't give a reasonable answer in
    thirty seconds, the symbol becomes a candidate for GCing.

    The variable SI:%%GC-QLX-LUSER-TM governs how long the GC waits before
    timing out the user.

    The variable SI:%%GC-QLX-LUSER-STREAM-IS-BACKGROUND if T will
    only allow the user to answer GC related questions while to background
    window NEVER-GIVE-THE-USER-A-BREAK-IN-ANSWERING-GC-RELATED-QUESTIONS-1
    is exposed.  This window is created as a background window with as
    deexposed typeout action of permit and an exposed typein action of 
    Other: &ignore.

[2] Recursion is now obsolete.  Use LOOP.

    Direct use of recursion will be temporarily supported giving only a
    style warning from the compiler.

    See the new RECURSIVELY keyword to LOOP.

[3] Common lisp installed.

    The semantics of most functions have changed to conform to Common Lisp.
    Many argument orders have been reversed.  Truth and falsity have reverted
    to the Lisp 1.5 definitions: T is bound to *T* and F is bound to NIL.
    However, code which refers only to primitives in the set {1+, CAR, CDR,
    COND, CONS, DEFUN, LAMBDA, SETQ, ZEROP} should continue to function
    normally. Note:  (NOT T) generates an error.
    Numbers are now also EQ so = is now obsolete and will not work.
    Also, you should replace (>= A B) with (OR (> A B) (EQ A B)) and 
    the same goes for <=.

[4] LOOP is now obsolete.  Use recursion.

    Direct use of LOOP will be temporarily supported giving only a style
    warning from the compiler.

    Recode your LOOP code using recursion, making sure you have a
    terminating clause in the definition.

[5] Number are documented.

    As part of our policy of keeping things well documented, all numbers
    in the system must be documented.  Creation of a number without any
    documentation will result in an error.  Use of the DESCRIBE function
    on a number will print out its documentation.  Note that numbers are
    EQ now, so don't try to use one number for more than one purpose.
    (That's why there's an infinite number of them.) (Well, almost, 
    as we only have a sex bit machine.)

  

CHANGES THAT ONLY AFFECT ADVANCED USERS.

[1] In Zwei, m-X Visit Other Window in Other Microcode works again.

    As you will recall, this oft-broken feature is a conceptual extension of
    c-X O, allowing system designers to visit their competitors' systems in
    a second Zwei window.  This way, they can test that their new features
    will run only in microcodes compatible with their political beliefs
    without even rebooting their machines.

[2] Change to implementation of WITHOUT-INTERRUPTS and UNWIND-PROTECT.

    In an attempt to reduce the number of control special forms in the
    language, WITHOUT-INTERRUPTS and UNWIND-PROTECT are now just ordinary
    functions, no longer special forms.  Their calling conventions, however,
    remain unchanged.

[3] SK combinators are now the primitive programming elements.

    (SKK(KSKKS(SKS)(KKS(KKKSKSSSK))(KKS)(SSSKSK((KKS)((SKSS))))))!

    They go best with dotted pairs such as ((SKK.(KS.S).(KSKSS)).(S.K))

[4] Bug in HALTSP fixed.

    The bug which caused HALTSP to get hung in a tight microcode loop when
    given certain pathological arguments (such as its own FEF) has been fixed.
    This function now always returns.



UPWARD-COMPATIBLE CHANGES.

[1] ZMail has new menu item "IGNORE".

    Mousing this item with a left click will reply to the current message
    with one of several cleverly worded messages chosen at random from the
    list held by the variable ZWEI:*GLIB-REPLIES*.  This list defaultly
    includes messages like "Fixed in the new error system.", "Fixed in the
    new activity system.", and "Fixed in the new system system."
    Other messages include "This is a Twenex bug.", "This is a Multics
    bug.", and the quite useful "Loser, that's a feature.  Next time mail
    to the right list: FEATURE-LISPM."

    With a middle click, different tactics are tried.  A fake message from
    COMSAT or XMAILR is formatted to say that the message was undeliverable
    due to microwave bridge sabotage.

    A right click will just caused the message to be ignored.

[2] LOOP has been extended.

    The new RECURSIVELY keyword handles cases that would seem to require
    recursion.

    This is simplest to explain with an example.  Where formerly you had to
    write:

     (DEFUN EQUAL (X Y)
       (IF (OR (NLISTP X) (NLISTP Y)) (EQ X Y)
           (AND (EQUAL (CAR X) (CAR Y)) (EQUAL (CDR X) (CDR Y)))))

    you can now write simply:

     (DEFUN EQUAL (X Y)
       (LOOP RECURSIVELY INTO X AND Y
	     DESCENDING-UNTIL (OR (NLISTP X) (NLISTP Y))
	     FAILING-IF (NEQ X Y)
	     PREMATURELY NIL
	     FINALLY T
	     BELATEDLY (FERROR NIL "Bug in LOOP!  Please report this to JONL.")))

[3] Advertising.

    The function SI:BITBLT-SUBLIMINALLY is now released to users.  You've
    probably seen it used many times without realizing it.  It's the function
    that the system uses at random intervals to display the message "Converse
    isn't all THAT bad" on the screen in our official corporate font for
    50msec.  You're probably wondering how we can do anything on the screen in
    50msec, but take our word for it that it works.  We hardly get any more
    bug reports on Converse and we haven't fixed any bugs in it for months.
    Note: this function will cause your machine to crash if you use it to
    say anything bad about our company or its code.

[4] CAR and CDR now return extra values.

    The function CAR now returns two values.  Since it has to go to the
    trouble to figure out if the object is carcdr-able anyway, we figured
    you might as well get both halves at once.  For example, the following
    code shows how to destructure a cons (SOME-CONS) into its two slots
    (THE-CAR and THE-CDR):

        (MULTIPLE-VALUE-BIND (THE-CAR THE-CDR) (CAR SOME-CONS) ...)

    For symmetry with CAR, CDR returns a second value which is the CAR of
    the object.

    In a related change, the functions MAKE-ARRAY and CONS have been fixed
    so they don't allocate any storage except on the stack.  This should
    hopefully help people who don't like using the garbage collector because
    it cold boots the machine so often.

[5] The TV:WIN-BIG special form is useful for writing window system
    code.

    The TV:WIN-BIG special form is a macro whose function is to ensure that
    all "window system" code executed inside of it will work correctly.  This
    special form combines all the features of these now obsolete window
    system functions:

      TV:WITH-BLINKER-READY
      TV:SHEET-FORCE-ACCESS
      TV:WITH-DEADLY-FORCE-AND-LICENCE-TO-KILL
      TV:DELAYING-SCREEN-MANAGMENT
      TV:DELAYING-YOUR-PAYCHECK
      TV:WITH-MOUSE-GRABBED
      TV:WITH-MOUSE-YU-SHIANG-STYLE
      TV:OPEN-BLINKER
      TV:CLOSE-THE-DOOR
      TV:OPEN-DOOR-AT-COMPETIORS
      TV:MOUSE-BLINKER-FAST-TRACKING-MIXIN
      TV:FAST-NEW-CAR-FOR-CHRISTMAS-MIXIN
      TV:STEVES-MIXIN
      TV:SWITCH-FROM-VHF-TO-UHF
      TV:SCREEN-UNPROTECT

    An example of the TV:WIN-BIG special form follows: Where previously it
    took pages of code to arrange things so that you could use the mouse to
    draw a box on the screen, now all that is needed is:
       (TV:WIN-BIG
         (DRAW A BOX ON THE TV:SCREEN USING THE FURRY:MOUSE))

    OK!

    [6] The Zwei command m-X View Function Through Rose Colored Glasses has
    been installed.  It is also available on h-c-V.  This command (invaluable
    when reading SLiMi system source code) reads and analyzes the function
    that the point is in and recodes it, removing crocks, hacks, obscurities,
    and SETQs in COND branches.  On machines with color screens, the recoded
    definition is also displayed on the color screen in shocking pink.  With a
    c-U argument, h-c-V will replace the version in the buffer with the
    recoded version.

    m-X View Function Through Rose Colored Glasses has aesthetic parameters
    you can set to suit your own coding style.

    ZWEI:*ACCEPTABLE-LOOPING-CONSTRUCTS*, initially set to (LOOP), is a
    list of the special forms the command will use in coding loops.

    ZWEI:*ALLOW-SETQS-IN-COND-BRANCHES* is for diehard losers.

    ZWEI:*REQUIRE-SETQS-IN-COND-BRANCHES* is for our maintenance personnel,
    the number of whom is now a bignum.

    ZWEI:%%PROG-DENSITY-THRESHOLD is the minimum percentage of PROG's allowed
    as a percentage of all lines of code.  DO NOT USE A NUMBER LESS THAN 40.

[7] New file system editor.

    A meta-level up from Dired, the new File System Editor gives you the
    same control of file systems on your machine that Dired used to give you
    of files.  So if your disk seems overly cluttered with file systems, you
    can just type c-X s-D and you'll be put in a window where you can remove
    the file systems you don't want with a single keystroke.

[8] RMail windows installed.

    Like ZMail windows, but tolerably fast.  Built out of essentially the
    same flavors but omitting TV:MOLLASSES-MIXIN.

[9] Password server.

    If you fail three times to remember your password when asked for it, all
    other lisp machine users will be queried to see if they can remember.
    This is built on CHAOS:NOTIFY-ALL-LMS.  This shouldn't be really have
    to be used, as everytime you use a new password, the next patch file
    updated to store your password.  That's why it takes so long to
    read in all of the patch-directories.  (For your protection, only
    your encrypted password is saved.)

[10] JCL support as alternative to system menu.

    In our continuing effort to support languages other than Lisp on the
    CADDR, we have developed an OS/360-compatible JCL.  This can be used as
    a alternative to the standard system menu.  Type System J to get to a
    JCL interactive read-execute-diagnose loop window.  [Note that for 360
    compatibility, all input lines are truncated to 80 characters.]  This
    window also maintains a mouse-sensitive display of critical job
    parameters such as dataset allocation, core allocation, channels, etc.
    When a JCL syntax error is detected or your job ABENDs, the
    window-oriented JCL debugger is entered.  The JCL debugger displays
    appropriate OS/360 error messages (such as IEC703, ``disk error'') and
    allows you to dequeue your job.

[11] A new system, the CIRCULATORY system, has been added.
   
    The long-experimental CIRCULATORY system has been released to users.
    The Lisp Machine uses Type B fluid, the L machine uses Type A fluid.
    When the switch to Common Lisp occurs both machines will, of course, be
    Type O.  Please check fluid level by using the DIP stick which is
    located in the back of VMI monitors.  Unchecked low fluid levels can
    cause poor paging performance.



[12] Speed up in efficiency for LET.

     Compiler optimizations have been made to macro expand LET
     into a WITHOUT-INTERRUPTS special form so that it can PUSH
     things into a stack in the LET-OPTIMIZATION area, SETQ 
     the variables and then POP them back when its done.  Don't 
     worry about this unless you use multiprocessing.

     Note that LET *could* have been defined by:

(LET ((LET '`(LET ((LET ',LET))
		  ,LET)))
     `(LET ((LET ',LET))
	   ,LET))

     This is believed to speed up execution by as much as a factor 
     of 1.01 or 3.50 depending on whether you believe our friendly
     marketing representatives.  This code was written by a new 
     programmer here (we snatched him away from Itty Bitti Machines
     where we was writting COUGHBOL code) so to give him confidence
     we trusted his vows of "it works pretty well" and installed it.


;;an unlucky number was omitted. (the code didn't work)

[14] New server: EVIL server.

     A new server, the EVIL server, has been installed for your pleasure.
     Now anyone can connect to your machine cause havoc on your machine.
     If there is no data on the next packet you recieve on the EVIL connection,
     as random function is called.  If you are given a negative number, 
     you automatically open an EVIL connection on their machine, and send
     them as their data, the absolute value of that number.  A small fixnum
     will cause one of your Chaos connections to be closed.  A large fixnum
     will cause one of your ZWEI buffers to be killed.  A small flonum
     will cause a random message to be sent to all objects in your world.
     A large flonum will do randomly do a warm boot or cold boot, and a bignum
     will start cause you to start EVIL serving all machines at your site,
     and then crash your machine.

     As usual, most of the user settable variables relavent are undocumented,
     but we will tell you that you can set EVIL:ESCALATION-FUNCTION to
     some expression to escalate the numbethat you were sent, and start
     EVIL serving the person who got you.  Note that you can also set
     EVIL:*NUMBER-OF-DIRTY-MESSAGES* to an number of insults to be 
     returned in your SLOW-ANSWER-STRING.  The evil server is implimented
     using .daemon. flavors.

[15] Package DWIM improved.
 
     So that error handling caused by by typing the name of a function 
     will be faster, all functions, variables and symbols which are
     unique are now globalized.  Note that PKG-GOTO is obsolete.
     PKG-GOSUB is still maintained for downward compatability.


[16] New special form:  WITHOUT-NES

    So that error handling will be faster, just wrap a 
    WITHOUT-NES form around the body.  Afterwards, you 
    will be able to quickly get MUCKLISP style error messags
    like ;Bpt: i/o lossage.  This form is already wrapped around
    LISP-TOPLEVEL99 for you.  Just remember to set the variable
    *ALLOW-ERROR-IN-ERROR-HANDLER* to T to avoid infinite loops.
   
[17] New function:  TV:DWIMIFY

     Pops up a menu window, and runs an AI program to do what
     you mean instead of what you click.  Great when your
     mouse is flakey.

[18] Memory storage and allocation improved.

     There is a new special form:  WITHOUT-CONSING.
     This special form will ensure that now consing is done
     evaluating its body.  This is used by the garbage
     collector to make sure you don't create more garbage
     than you free up.  Also, if your idle time exceeds
     *IDLE-TIME-BEFORE-GC* 60ths of second, a full gc is
     ddone for you.  Just don't do a HACKS:PIZZA and take
     too long eating it.


[19] Personality awareness.

     Set the variable *LOSERS* to all the people that you think are losers.
     This will cause all the variable *PEOPLE-WHO-THINK-I-AM-A-LOSER*
     to be updated in all of your loser's init file.  Now you can run
     a program on another machine which if there are no free lisp machines,
     will free up one just for you, by cold booting it.


[20] New ZWEI command.

     SUPER-HYPER-META-CONTROL-SHIFT-GREEK-X Correct Grammar will correct
     grammer of buffer the.

     SUPER-HYPER-META-CONTROL-SHIFT-GREEK-X Correct Programming Bugs
     will correct bugs in your programming, provided you have Set 
     Default programming language.

     SUPER-HYPER-META-CONTROL-SHIFT-GREEK-X Translate Into Language
     will prompt you for a two new langauges: the first is  the langauge
     to translate the program into, the second is the langauge to
     translate the comments into.  Known langauges are found in the
     variable *LINGUA-KNOWLECHEN* (from the Latin and the French).
     If you set this variable to include a language it really doesn't
     know, it will try hard to find the language on the File-computer
     (not yet supported in the default file system).




NOTES.

[1] New mice.

    Remember those white mice that were fed 20 liters of strong coffee a
    day?  New mice in our official corporate colors will arrive soon.
    Remember, our mice are much better than our competitor's rats.

[2] Helpful hints in using CPT monitors

    A new font is available for users of CPT monitors.  FIX200 allows a full
    5 x 8 character area of your file to be visible simultaneously, despite
    the slight imperfections in the newer CPT monitors [users of older CPT
    monitors will have to wait for the upcoming release of FIX400].  A crash
    development effort to develop horizontal scrolling in the editor is
    underway.  Howard is away on vacation, however, and no one else can
    fathom the window system code.

    Our crack hardware team has announced the availability of retrofit kits
    consisting of microscopes with image intensifiers, and a case of
    dramamine tablets.  Marketing can't decide the price for this, however,
    so you'll just have to wait.

[3] There has been some confusion concerning MAPCAR.

    (DEFUN MAPCAR (&FUNCTIONAL FCN &EVAL &REST LISTS) ;(c) SLiMi, 1982
      (PROG (V P LP)
 	    (SETQ P (LOCF V))
       L    (SETQ LP LISTS)
    	    (%START-FUNCTION-CALL FCN T (LENGTH LISTS) NIL)
       L1   (OR LP (GO L2))
    	    (AND (NULL (CAR LP)) (RETURN V))
    	    (%PUSH (CAAR LP))
    	    (RPLACA LP (CDAR LP))
    	    (SETQ LP (CDR LP))
    	    (GO L1)
       L2   (%FINISH-FUNCTION-CALL FCN T (LENGTH LISTS) NIL)
    	    (SETQ LP (%POP))
    	    (RPLACD P (SETQ P (NCONS LP)))
    	    (GO L)))

    We hope this clears up the many questions we've had about it.

[4] New address for bug reports.

    Bug reports now amount to an average of 12,853 per day.  Unfortunately,
    this is only a small fraction [ < 1% ] of the mail volume sent to
    BUG-SLiMi.  In order that we may more expeditiously deal with these
    valuable messages, please communicate them by one of the following
    paths:

    ARPANET sites: "Wastebasket@SLiMiHQ"@AI
      Note:  AI is not expected to run TCP/IP so mail will not get through
    after January 1.  So much the better.

    UUCP sites:  ucb70!progn!a!caddr!cddadr!fubar!go!a!slimivixen!slimivaxen!slimihq!wastebasket

    Non-network sites:  Federal Express to:
		Wastebasket
		Room NE43-926
		Copernicus, The Moon, 12345-6789

    Dialnet number  1-900-555-1212

    Our trained operators are on call 24-hours a day.  That toll-free number
    again is 1-900-555-1212.  Try some today.  Visa and Mastercharge
    accepted. *

*
Our very rich lawyers assure us that we are not responsible 
for any errors in advice given over the phone.