		    A COMMENT ON ERROR TRAPS
		      By Nick Fotheringham
		 From The Apple Barrel, July'82
			   I.A.C.-TC

  You have finally gotten all of the bugs out of that special program that has
kept you in seclusion for the past several weeks.  It does exactly what you
want it to do, and you are ready to impress someone with it.  You beg your boss
to take time from his busy schedule for a session with your Apple, and after
ten minutes of routine data entry, your program is nearing its flashy finale.
The next question appears:  "How many sides on an octogon?" As your boss enters
"e..i..g...", you stifle, "Not that key, you dummy, the '8'".  Too late...  The
Apple has already responded with a "TYPE MISMATCH" message and shut your
program.

  One purpose of an "error trap" or "error handling routine" is to help prevent
such embarrassing situations.  Your Apple's BASIC interpreter already has
several built-in error traps which were designed to protect the system from
your unreasonable requests, such as attempts to divide by zero or to exceed to
system's capacity ("STRING TOO LONG", "OVERFLOW", "FORMULA TOO COMPLEX", "OUT
OF MEMORY").  Fortunately for many applications, these traps can be avoided by
using the ONERR GOTO.....POKE 216,0 commands.  ONERR GOTO...  disables the
system's internal error handling routine and, upon encountering an error,
transfers program processing to a statement defined by the GOTO statement,
typically a replacement error handling routine of your design.	The POKE 216,0
command reinstates the system's error handling routine.

  For many beginning programmers, disabling the system's error handling
routine, only to replace it with one that you must design and which uses some
of your precious RAM memory seems like lunacy.	The major reason for doing so
is that most of the errors to which the system reacts need not be fatal to your
run.  The computer views these errors as fatal because the contexts in which
they may occur are so diverse that the only general solution that ensures
protection to your computer is to terminate your run.  However, within your
program the context within which an error may occur can often be much more
narrowly defined, and nonfatal solutions may be developed.  Some of these
solutions are described below.

  One of the most common applications for error traps is to guard your program
against typing errors during data entry from the keyboard.  Most such errors
can be resolved without aborting your program by designing the program to
receive all input as a string variable, say A$.  Because A$ will accept input
from nearly every key (except RESET) without a TYPE MISMATCH error, it is
preferable to A or A% as an input variable.  You may then test the input to see
if a RETURN has been entered (A$=""), to see if a number has abeen entered
(ASC(A$)>47 AND ASC(A$)<58.  If the desired numerical input has been entered,
you may then convert the input to its numerical equivalent (A=VAL(A$) or
A%=INT(VAL(A$))) and then test to see if this value is within the range that
you expected as an answer to your question (A%>0 AND A%<5).

  One of the great advantages of owning your own computer system on which you
run programs interactively is that you can usually train the system to come
back to you for help when it has a complaint instead of just dying.  When a
"fatal" problem is encountered, such as an attempt to divide by zero, an error
trap can be used to print an error message of your choosing and then give you
an opportunity to change the denominator to a non-zero number and continue the
calculation or to abort that program segment (e.g.  return to the menu).

  Good programs should never "crash".  Even when they fail to complete the task
for which they were designed, they should reach a controlled ending which
provides a detailed description of what went wrong and an opportunity to fix it
before ending.	Since most of us write programs with the expectation that
others will run them, we should get in the habit of using error traps
routinely, and we should insist on such programming style in the commercial
software we buy.
