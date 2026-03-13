  Author's Note:  The following article was written for submission to
ComputerFun magazine.  Alas, the mag died!  Some information, specifically that
about pirates and piracy, is somewhat biased, due to the intended audience.
Keep that in mind as you read this.  Still good for a laugh tho!  -dt

   COPY PROTECTION: A HISTORY AND OUTLOOK

  Back in the last seventies, when personal computers were just starting to
catch on, a lot of software was distributed on audio cassettes.  The price was
generally low ($15 and under), and so was the quality.	Personal computer owners
knew that audio cassettes could be duplicated fairly easily with two
decent-quality tape recorders.	However, the process was time-consuming and
unreliable (volume levels were critical), and it did not save that much money,
since the cassette alone cost five dollars anyway.  The market for cassette
software was stable.

  As the prices of home systems continued to drop, the popularity of the floppy
disk as a storage medium increased so that software suppliers had to carry each
program on both tape and disk.	Typically, the disk version cost slightly more,
due to the higher cost of the disk itself, and the fact that disk drive owners
were prepared to pay a little extra for a program that loads several times
faster.

  These software prices, still relatively low, were short-lived.  Disks, unlike
tapes, were trivially easy to copy.  User clubs formed in which one copy was
purchased (legally) and copied (illegally) for everyone in the group.  Worse
yet, schools and businesses owning more than one system would make copies for
all of their systems from one original.  Then, individuals connected with the
schools or businesses would copy the disks for themselves, for friends, for
their user club, for other schools and businesses...  Piracy had spread like a
cancer to ridiculous proportions, throwing a monkey wrench into the once-stable
software market.

  The software distributors' next move was to modify their program disks in such
a way that they could not be duplicated by conventional means, and to raise
their prices somewhat.	These early efforts at copy-protection were very simple,
and equally simple to undo.  Every disk has on it a list of what data is
contained on it, where on the disk it is, what type of data it is, etc.  The
part of the disk that contains this information is called the catalog or
directory of the disk.	On copy-protected disks, the catalog was altered
slightly in format, moved to elsewhere on the disk, or omitted entirely.  All
someone would have to do was restore the catalog, an easy task if you know what
you're doing, and the disk would copy normally.

  The new copy-protected disks kept a significant proportion of the pirates
discouraged, much the same way a flimsy doorknob lock "keeps an honest man
honest".  Most of the early large-scale piracy stopped.  Businesses and schools
could not afford the time required to duplicate the disks, so they shrugged,
gave in and bought the disks.  Hobbyists quickly found ways to copy the new
software, but they were working independently, and therefore not dangerous.  The
software industry was content and hopeful.

  It was a false hope.	As the popularity of personal computers continued to
escalate, hobby users banded together more and more.  Some broke the software
"lock" and made the disks copyable while others purchased the tape versions of
software and transferred them to disk.	The industry retaliated by discontinuing
most of the taped versions of software, as they were far too easy to copy, and
by using more sophisticated techniques to protect the disks.  Of course, they
also raised the prices.

  These second generation copy-protection schemes worked remarkably well for a
while.	Data on a disk is encoded (pre-nibbilized) in a standard way before it
is written out to disk, and then decoded (post-nibbilized) as it is read back.
By altering the code under which the data is written and read, the software
companies rendered ordinary copy programs useless.  Another technique of this
era was to write data in unusual formats in odd places on the disk, such as
between two tracks or after the last track normally used.

  The hobby users, indignant at the recent price increase, adapted the general
attitude that piracy is okay because they would never buy the software at the
exhorbitant price being asked.	User clubs were now considered essential.  To
not belong to one was to be repeatedly "cheated" when buying software.  No
matter what copy-protection methods the software people tried, the pirates broke
the disk and circulated the copy, quite literally around the country.

  In order to make piracy easier, enthusiasts and certain software firms
(considered traitors by other software firms) developed special copy programs
which analyzed the data being copied as little as possible, attempting to copy
as directly as is possible from one disk to another.  The infamous Locksmith and
the more recent COPY ][ are examples of such programs, called bit copiers or
nibble copiers because they copy the data one bit or one nibble at a time,
rather than one sector or one track at a time.

  Still, the goal of a pirate was downright unprotection, not duplication.  To a
new breed of pirate, it was a game.  Each new disk provided the pirate with a
new challenge, a puzzle, which, if he could solve, would make him famous
(pirates tended to leave their mark on the disks they unprotected in those
days).	To the software firms, it was hardly a game, it was a war of attrition,
and until they could outsmart the pirates, they would just have to increase the
prices and hope for the best.

  Or would they?  Some software companies stepped back at this point and
surveyed the situation:  they probably could not keep the pirates at bay for
long, as there was genuine intelligence out there -- thousands of users all
working toward one goal -- to break that disk!	It seemed to them that they
actually had a number of options if they wished to continue to do a healthy
business.  First, they lobbied for stricter copyright laws and won.  Bootleg
disk distribution is now more illegal than every before, but it is still
difficult to enforce the law.  Second, they could fight it out, raising the
prices as necessary and developing more diabolical methods of copy-protection.

  Only so much can be done to protect disks, however.  Those firms that
continued to protect their disks were upset by the introduction of a hardware
device developed by pirates and later marketed which allows the entire state of
the computer to be frozen and remembered, down to the last status bit, and
restored at will later.  Duplication of the program disk was no longer
necessary.  The whole program was right there in memory waiting to be run.  All
the pirate had to do was duplicate the state the computer was in, not the disk
that got it there.

  The software firms, to work around the setback, tried a new technique:  they
caused their programs to look at the disk periodically and make sure it is the
original.  How to tell the difference between the original and a copy was an
ingenious trick called nibble counting.  When disks are copied, the two drives
doing the copying are seldom running at the exact same speed, so the duplicate
disk will contain tracks which are slightly longer (more nibbles) or shorter
(fewer nibbles) than the original.  The software could count the nibbles and
determine whether the disk being used is an original.  Soon, though, nibble
copiers began to allow the user to preserve the nibble count, foiling the
protectors again.

  Another particularly devious tactic in copy-protection is called sector
skewing.  To simplify a complex process, data is spread finely over the entire
disk, so that it would take an exceptionally high-quality disk drive to write
such a disk, though any drive can read it under direction of the software.  What
these software firms realize too late is that the pirates have one secret weapon
-- a foolproof, though painful, procedure to break any disk protection scheme --
boot tracing!  You see, software has the unfortunate characteristic that it has
to be written in such a way that the computer can understand it.  It has to, so
to speak, spoon-feed itself to the computer.  The process of boot tracing is
simply to painstakingly, step by step, pretend you're the computer, follow all
the rules it follows, and you will eventually succeed in reading the disk.

  Some software firms still fight the war of attrition, such as Br0derbund,
On-line systems and others.  Other firms had a better idea:  to give up on
protection altogether and direct their attention to providing an attractive
package -- with ample documentation, quick-reference cards and other goodies --
at a good price.  An excellent example of this novel approach, to give the buyer
a good deal, is Beagle Bros, whose software has never been protected, and never
will be.  Their products are of highest quality and reasonably priced.	To be
sure, it is duplicated to some degree, but the package with all its goodies is
worth the investment.  Penguin software has used this approach successully as
well.

  A final possibility, useful only in the more expensive packages, is to require
a hardware device to be installed in the computer for the software to run
properly.  Softerm 2 for Apple, for instance, requires a plug-in card to be
installed in the computer which has attached to it three special function
switches necessary for the operation of the program.  You can copy the disk, but
not the card.  Not all computers have as much room for extra hardware as the
Apple, though, and hardware devices cost a lot of money compared to disks and
manuals, so this method is only practical in expensive packages.

  So where does all that leave you, the honest (ahem!) consumer?  Well, the
software firms really are anxious to serve you.  If your copy-protected disk
ever fails to work, you can send it back for free replacement.	If the disk is
damaged physically, the replacement fee is about five dollars (provided you send
in the old disk!!).  Many packages come with two copies of the software, in case
one should fail, and legitimate software owners often receive free updates to
both the software and the documentation.  Software companies try to make it
worth your while to buy their product.	Also, due to a recent crackdown,
big-time pirates are getting caught, and piracy is more anonymous now.	Trust
among pirates has broken down, and so has the once widespread circulation of
pirated disks.	The heyday of piracy is over.  So, if you are thinking of
getting some software, examine the package.  Find out exactly what the program
can do, the guarantee, and all the fringe benefits you will receive as a
legitimate owner of the software.  If, after all that, the package does not
interest you, don't buy it.  If you are considering being a pirate, be careful!
Imprisonment is entirely possible if you are caught, and even if you are not,
you are only raising software prices for yourself and everyone else.

  -DT

 if you are caught, and even if you are not,
you are only raising software prices for yourself