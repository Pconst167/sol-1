Date: Mon, 21 Sep 87 12:52 EDT
From: Tom Knight <tk@STONY-BROOK.SCRC.Symbolics.COM>
Subject: Pros and Cons of Suns
To: info-explorer@mc.lcs.mit.edu
Message-ID: <870921125238.6.TK@CUCKOO.SCRC.Symbolics.COM>

Date: Fri, 27 Feb 87 21:39:24 EST
From: rose@think.com
To: sun-users, systems

Pros and Cons of Suns  (Flame ON)

Well, I've got a spare minute here, because my Sun's editor window
evaporated in front of my eyes, taking with it a day's worth of Emacs
state.

So, the question naturally arises, what's good and bad about Suns?

This is the fifth day I've used a Sun.  Coincidentally, it's also the
fifth time my Emacs has given up the ghost.  So I think I'm getting a
feel for what's good about Suns.

One neat thing about Suns is that they really boot fast.  You ought to
see one boot, if you haven't already.  It's inspiring to those of us
whose LispM's take all morning to boot.

Another nice thing about Suns is their simplicity.  You know how a LispM
is always jumping into that awful, hairy debugger with the confusing
backtrace display, and expecting you to tell it how to proceed?  Well,
Suns ALWAYS know how to proceed.  They dump a core file, and kill the
offending process.  What could be easier?  If there's a window involved,
it closes right up.  (Did I feel a draft?)  This simplicity greatly
decreases debugging time, because you immediately give up all hope of
finding the problem, and just restart from the beginning whatever
complex task you were up to.  In fact, at this point, you can just boot.
Go ahead, it's fast!

One reason Suns boot fast is that they boot less.  When a LispM loads
code into its memory, it loads a lot of debugging information too.  For
example, each function records the names of its arguments and locals,
the names of all macros expanded to produce its code, documentation
strings, and sometimes an interpreted definition, just for good measure.

Oh, each function also remembers which file it was defined in.  You have
no idea how useful this is:  There's an editor command called
"Meta-Point" which immediately transfers you to the source of any
function, without breaking your stride.  ANY function, not just one of a
special predetermined set.  Likewise, there's a key which causes the
calling sequence of a function to be displayed instantly.

Logged into a Sun for the last few days, my Meta-Point reflex has
continued unabated, but it is completely frustrated.  C* has about 80
files.  If I want to edit the code of a function Foo, I have to switch
to a shell window and grep for Foo in various files.  Then I have to
type in the name of the appropriate file.  Then I have to correct my
spelling error.  Finally I have to search inside the file.  What used to
take 5 seconds now takes a minute or two.  (But what's an order of
magnitude between friends?)  By this time, I really want to see the Sun
at its best, so I'm tempted to boot it a couple of times.

There's a wonderful Unix command called "strip", with which you force
programs to remove all their debugging information.  Unix programs (such
as the Sun window system) are stripped as a matter of course, because
all the debugging information takes up disk space and slows down the
booting process.  This means you can't use the debugger on them.  But
that's no loss; have you seen the Unix debugger?  Really.

Did you know that all the standard Sun window applications ("tools") are
really one massive 3/4 Mb binary?  This allows the tools to share code
(there's a lot of code in there).  Lisp Machines share code too this way
too.  Isn't it nice, that our workstations protect our memory
investments by sharing code.

None of the standard Sun window applications ("tools") support Emacs.
Unix applications cannot be patched either; you must have the source so
you can patch THAT, and then regenerate the application from the source.

But I sure wanted my Sun's mouse to talk to Emacs.  So I got a couple
hundred lines of code (from GNU source) to compile, and link with the
very same code which is shared by all the standard Sun window
applications ("tools").  Presto!  Emacs gets mice!  Just like the LispM;
I remember Dan's and my hacks to the LispM terminal program:  a couple
tens of lines of Lisp code.  (Well, it was less work than those
aforementioned couple hundred lines of code, but what's an order of
magnitude between friends?)

Ok, so I run my Emacs-with-mice program, happily mousing away.  Pretty
soon Emacs starts to say things like "Memory exhausted" and
"Segmentation violation, core dumped".  The little Unix console is
consoling itself with messages like "clntudp_create: out of memory".
Eventually my Emacs window decides it's time to close up for the day.

What has happened?  Two things, apparently.  One is that when I created
my custom patch to the window system, to send mouse clicks to Emacs, I
created another massive 3/4 Mb binary, which doesn't share space with
the standard Sun window applications ("tools").

This means that instead of one huge mass of shared object code running
the window system, and taking up space on my paging disk, I had two such
huge masses, identical except for a few pages of code.  So I paid a
megabyte of swap space for the privilege of using a mouse with my
editor.  (Emacs itself is a third large mass.)

The Sun kernel was just plain running out of room.  Every trivial hack
you make to the window system replicates the entire window system.  But
that's not all:  Apparently there are other behemoths of the swap
volume.  There are some network-y things with truly stupendous-sized
data segments.  Moreover, they grow over time, eventually taking over
the entire swap volume, I suppose.  So you can't leave a Sun up for very
long.  That's why I'm glad Suns are easy to boot!

But why should a network server grow over time?  You've got to realize
that the Sun software dynamically allocates very complex data
structures.  You are supposed to call "free" on every structure you have
allocated, but it's understandable that a little garbage escapes now and
then, because of programmer oversight.  Or programmer apathy.  So
eventually the swap volume fills up!  This leads me to daydream about a
workstation architecture optimized for the creation and manipulation of
large, complex, interconnected data structures, and some magic means of
freeing storage without programmer intervention.  Such a workstation
could stay up for days, reclaiming its own garbage, without need for
costly booting operations.

But of course, Suns are very good at booting!  So good, they sometimes
spontaneously boot, just to let you know they're in peak form!

Well, the console just complained about the lack of memory again.  Gosh,
there isn't time to talk about the other LispM features I've been free
of for the last week.  Such as incremental recompilation and loading.
Or incremental testing of programs, from a Lisp Listener.  Or a window
system you can actually teach new things (I miss my mouse sensitive Lisp
forms).  Or safe tagged architecture that rigidly distinguishes between
pointers and integers.  Or the Control-Meta-Suspend key.  Or manuals.

Time to boot!

[ Seriously folks:  I'm doing my best to get our money's
  worth out of this box, and there are solutions to some of
  the above problems.  In particular, thanks to Bill for
  increasing my swap space.  In terms of raw CPU power,
  a Sun can really get jobs done fast.  But I needed to let off
  some steam, because this disappearing editor act is really
  getting my dander up.
  ]