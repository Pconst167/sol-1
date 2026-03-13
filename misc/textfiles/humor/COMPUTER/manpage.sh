From: dws@ssec.wisc.edu (DaviD W. Sanderson)
Newsgroups: rec.humor
Subject: Funny Man Pages
Message-ID: <1993Jan10.190016.8259@cs.wisc.edu>
Date: 10 Jan 93 19:00:16 GMT
Organization: UW-Madison Space Science and Engineering Center
Lines: 2420

In article <1993Jan10.143051.12284@cs.tu-berlin.de> rossi@opal.cs.tu-berlin.de (Oliver Rosenkranz) writes:
>Are there other man pages out there ???

This is my collection of tongue-in-cheek man pages I have seen posted
to the Net.  I did not write them, but in some cases I have done a
considerable amount of work to back-engineer them to source form and/or
beautify them.  They are all in source form, so people can use nroff or
troff as they wish.

I welcome any new pages people would like to contribute.  (I do have
the penix man pages, but I'm still working on converting them to nroff
source.)

Enjoy!

DaviD W. Sanderson (dws@ssec.wisc.edu)

	"The Noah Webster of smileys is David Sanderson"
		- The Wall Street Journal, 15 Sep 1992

#!/bin/sh
# This is a shell archive (produced by shar 3.49)
# To extract the files from this archive, save it to a file, remove
# everything above the "!/bin/sh" line above, and type "sh file_name".
#
# made 01/10/1993 18:51 UTC by dws@ssec
# Source directory /home/dws/pub/src/dws/funman
#
# existing files will NOT be overwritten unless -c is specified
#
# This shar contains:
# length  mode       name
# ------ ---------- ------------------------------------------
#    407 -rw------- README
#   2508 -r-------- babya.1
#   3032 -r-------- babyb.1
#    125 -r-------- celibacy.1
#   6137 -r-------- condom.1
#   4195 -r-------- date.1
#   2721 -r-------- echo.1
#   3637 -r-------- flame.1
#   1971 -r-------- flog.1
#   1882 -r-------- gong.1
#   3372 -r-------- grope.1
#   1295 -r-------- rescrog.1
#   6074 -r-------- rm.1
#   2024 -r-------- sex.1
#   1740 -r-------- strfry.3
#   1748 -r-------- tm.1
#   2982 -r-------- xkill.1
#   1063 -rw------- Makefile
#
# ============= README ==============
if test -f 'README' -a X"$1" != X"-c"; then
	echo 'x - skipping README (File already exists)'
else
echo 'x - extracting README (Text)'
sed 's/^X//' << 'SHAR_EOF' > 'README' &&
This is my collection of tongue-in-cheek man pages I have seen posted
to the Net.  I did not write them, but in some cases I have done a
considerable amount of work to back-engineer them to source form and/or
beautify them.  They are all in source form, so people can use nroff or
troff as they wish.  I welcome any new pages people would like to
contribute.
X
Enjoy!
X
DaviD W. Sanderson (dws@ssec.wisc.edu)
SHAR_EOF
chmod 0600 README ||
echo 'restore of README failed'
Wc_c="`wc -c < 'README'`"
test 407 -eq "$Wc_c" ||
	echo 'README: original size 407, current size' "$Wc_c"
fi
# ============= babya.1 ==============
if test -f 'babya.1' -a X"$1" != X"-c"; then
	echo 'x - skipping babya.1 (File already exists)'
else
echo 'x - extracting babya.1 (Text)'
sed 's/^X//' << 'SHAR_EOF' > 'babya.1' &&
.\"-------
.\" b a b y . 1
.\"
.\" Created from a post-nroff version posted in rec.humor.funny:
.\"
.\" Message-id: <S2a9.10d1@looking.on.ca>
.\" Date: Sat, 29 Jun 91 6:30:4 EDT
.\" From: beck@cs.ualberta.ca (Bob Beck)
.\" Subject: BABY man page, I've ben told I should submit this, was posted locally.
.\"
.\" DaviD W. Sanderson
.\"-------
.TH BABY 1
.SH NAME
baby \(em create new process from two parent processes
.SH SYNOPSIS
.B baby
.I sex
.RI [ name... ]
.SH "SYSTEM V SYNOPSIS"
.B /usr/5bin/baby
.RB [ \-sex \0\fIsex\fR]
.RB [ \-name \0\fIname...\fR]
.SH AVAILABILITY
The System V version of this command is available
with the System V software installation option.
Refer to Installing SunOS 4.1 for information
on how to install and invoke
.IR baby .
.SH DESCRIPTION
.I baby
is initiated when one parent process polls another server process
through a socket connection (BSD)
or through pipes in the System V implementation.
.I baby
runs at low priority for approximately 40 weeks
and then terminates with a heavy system load.
Most systems require constant monitoring when
.I baby
reaches its final stages of execution.
.PP
Older implementations of
.I baby
required that the initiating process not
be present at the time of completion.
In these
versions the initiating process
is
awakened and notified of the results upon completion.
Modern versions allow both parent processes to be active
during the final stages of
.IR baby .
.PP
.RS
example% baby \-sex m \-name fred
.RE
.SH OPTIONS
.TP
.B \-sex
option indicating type of process created.
.TP
.B \-name
process identification to be attached to the new process.
.SH RESULT
Successful execution of
.IR baby (1)
results in new process being created and named.
Parent processes then typically
broadcast messages to all other processes informing them of their
new status in the system.
.SH BUGS
The
.I sleep
command may not work on either parent processes for some time afterward,
as new
.I baby
processes constantly send interrupts
which must be handled by one or more parent.
.PP
.I baby
processes upon being created may frequently dump
in /tmp requiring /tmp to be cleaned out frequently by one
of the parent processes.
.PP
The original AT&T version was provided without instructions
regarding the created process; this remains in current implementations.
.SH "SEE ALSO"
.IR cigars (6),
.IR dump (5),
.IR cry (3)
.SH "OTHER IMPLEMENTATIONS"
.TP
.IR gnoops (1)
FSF version of
.I baby
where none of the authors will accept responsibility for anything.
SHAR_EOF
chmod 0400 babya.1 ||
echo 'restore of babya.1 failed'
Wc_c="`wc -c < 'babya.1'`"
test 2508 -eq "$Wc_c" ||
	echo 'babya.1: original size 2508, current size' "$Wc_c"
fi
# ============= babyb.1 ==============
if test -f 'babyb.1' -a X"$1" != X"-c"; then
	echo 'x - skipping babyb.1 (File already exists)'
else
echo 'x - extracting babyb.1 (Text)'
sed 's/^X//' << 'SHAR_EOF' > 'babyb.1' &&
.\"-------
.\" b a b y b . 1
.\"
.\" Created from a post-nroff version posted in rec.humor:
.\"
.\" From: tencati@nssdca.gsfc.nasa.gov
.\" Newsgroups: rec.humor
.\" Subject: UNIX man page for new baby
.\" Message-ID: <10JUL199210414089@nssdca.gsfc.nasa.gov>
.\" Date: 10 Jul 92 15:41:00 GMT
.\" Article-I.D.: nssdca.10JUL199210414089
.\" Organization: NASA - Goddard Space Flight Center
.\"
.\" One of my co-workers just had a new baby added to their family. He
.\" emailed the following announcement:
.\" (You have to understand the UNIX doc set to fully appreciate this)
.\"
.\" DaviD W. Sanderson
.\"-------
.TH BABY 1
.SH NAME
baby \(em create new process from two parents
.SH SYNOPSIS
.B baby
.B \-sex
.RI [ m | f ]
.RB [ \-name
.IR name ]
.SH DESCRIPTION
.I baby
is initiated when one parent process polls another server process
through a socket connection in the BSD version
or through pipes in the System V implementation.
.I baby
runs at low priority for approximately forty weeks
and then terminates with a heavy system load.
Most systems require constant monitoring when
.I baby
reaches its final stages of execution.
.PP
Older implementations of
.I baby
did not require both initiating processes to
be present at the time of completion.
In those
versions the initiating process
which was not present was
awakened and notified of the results upon completion.
It has since been determined that the presence of both parent
processes result in a generally lower system load at completion,
and thus current versions of
.I baby
expect both parent processes to be active during the final stages.
.PP
Successful completion of
.I baby
results in the creation and
naming of a new process.
Parent processes then broadcast
messages to all other processes, local and remote, informing
them of their new status.
.SH OPTIONS
.TP
.B \-sex
define the gender of the created process
.TP
.B \-name
assign the name name to the new process
.SH EXAMPLES
.RS
baby \-sex f \-name Jacqueline
.RE
.PP
completed successfully on July 9, 1992 at 9:11pm.
Jacqueline's vital statistics: 8 pounds 3 oz, 20 inches, long dark hair.
The parent process, Kim Dunbar, is reportedly doing fine.
.SH "SEE ALSO"
.IR cigar (6),
.IR dump (5),
.IR cry (3).
.SH BUGS
Despite its complexity,
.I baby
only knows one signal, SIGCHLD,
(or SIGCLD in the System V implementation),
which it uses to contact the parent processes.
One or both parent processes must then inspect the baby process
to determine the cause of the signal.
.PP
The
.IR sleep (1)
command may not work as expected on either parent
process for some time afterward, as each new instance of
.I baby
sends intermittent signals to the parent processes
which must be handled by the parents immediately.
.PP
A
.I baby
process will frequently dump core, requiring either
or both parent processes to clean up after it.
.PP
Despite the reams of available documentation on invoking and
maintaining
.IR baby ,
most parent processes are overwhelmed.
.SH AUTHORS
XFrom a man page by Joe Beck, <beck@cs.ualberta.ca>.
SHAR_EOF
chmod 0400 babyb.1 ||
echo 'restore of babyb.1 failed'
Wc_c="`wc -c < 'babyb.1'`"
test 3032 -eq "$Wc_c" ||
	echo 'babyb.1: original size 3032, current size' "$Wc_c"
fi
# ============= celibacy.1 ==============
if test -f 'celibacy.1' -a X"$1" != X"-c"; then
	echo 'x - skipping celibacy.1 (File already exists)'
else
echo 'x - extracting celibacy.1 (Text)'
sed 's/^X//' << 'SHAR_EOF' > 'celibacy.1' &&
.TH CELIBACY 1
.SH NAME
celibacy \(em don't have sex
.SH SYNOPSIS
.B celibacy
.SH DESCRIPTION
Does nothing worth mentioning.
SHAR_EOF
chmod 0400 celibacy.1 ||
echo 'restore of celibacy.1 failed'
Wc_c="`wc -c < 'celibacy.1'`"
test 125 -eq "$Wc_c" ||
	echo 'celibacy.1: original size 125, current size' "$Wc_c"
fi
# ============= condom.1 ==============
if test -f 'condom.1' -a X"$1" != X"-c"; then
	echo 'x - skipping condom.1 (File already exists)'
else
echo 'x - extracting condom.1 (Text)'
sed 's/^X//' << 'SHAR_EOF' > 'condom.1' &&
.\" -------
.\" Message-ID: <S48e.386a@looking.on.ca>
.\" Date: Mon, 26 Oct 92 4:30:03 EST
.\" Newsgroups: rec.humor.funny
.\" Subject: condom(1) man page (original)...
.\" From: maupin@cs.washington.edu (Ken Maupin)
.\" Keywords: chuckle, original, computers, sexual
.\" Approved: funny@clarinet.com
.\"
.\" The following was inspired by the sex.1 and celibacy.6 EUNUCH
.\" man pages I found hiding in, of all places, the GNU Emacs
.\" distribution on my machine (I guess we know what Richard Stallman
.\" thinks about when he isn't writing GNU software, eh?).
.\" -------
.\" Reverse-engineered to [nt]roff -man source by DaviD W. Sanderson
.\" -------
.TH CONDOM 1 "" "EUNUCH Programmer's Manual"
.SH NAME
condom \- protection against viruses and prevention of child processes
.SH SYNOPSIS
.B condom
.RI [ options ]
.RI [ processid ]
.SH DESCRIPTION
.I condom
provides protection against System Transmitted
Viruses (STVs) that may invade your system.
Although the spread of such viruses across a network
can only be abated by aware and cautious users,
.I condom
is the only highly effective means of preventing
viruses from entering your system (see
.IR celibacy (1)).
Any data passed to
.I condom
by the protected process will be blocked, as specified by
the value of the
.B \-s
option (see
.B OPTIONS
below).
.I condom
is known to
defend against the following viruses and other malicious
afflictions:
.RS
.IP \(bu
AIDS
.PD 0
.IP \(bu
Herpes Simplex (genital varieties)
.IP \(bu
Syphilis
.IP \(bu
Crabs
.IP \(bu
Genital warts
.IP \(bu
Gonhorrea
.IP \(bu
Chlamydia
.IP \(bu
Michelangelo
.IP \(bu
Jerusalem
.PD
.RE
.PP
When used alone or in conjunction with
.IR pill (1),
.IR sponge (1),
.IR foam (1),
and/or
.IR setiud (3),
.I condom
also prevents the conception of a child process.
If invoked from within a synchronous process,
.I condom
has, by default, an 80% chance of preventing the external processes
from becoming parent processes (see the
.B \-s
option below).
When other process contraceptives are used,
the chance of preventing a child process from being forked
becomes much greater.
See
.IR pill (1),
.IR sponge (1),
.IR foam (1),
and
.IR setiud (3)
for more information.
.PP
If no options are given, the current user's login process (as
determined by the environment variable USER) is protected with a
Trojan rough-cut latex condom without a reservoir tip.
The optional
.RI `` processid ''
argument is an integer specifying the process to protect.
.PP
NOTE:
.I condom
may only be used with a hard disk.
.I condom
will terminate abnormally with exit code \-1 if used with a floppy
disk (see
.B DIAGNOSTICS
below).
.ne 5
.SH OPTIONS
The following options may be given to
.IR condom :
.TP
.BI \-b " brand"
.IR brand s
are as follows:
.RS 1i
.TP
trojan (default)
.PD 0
.TP
ramses
.TP
sheik
.TP
goldcoin
.TP
fourex
.PD
.RE
.TP
.BI \-m " material"
The valid
.IR material s
are:
.RS 1i
.TP
.PD 0
latex (default)
.TP
saranwrap
.TP
membrane
.B WARNING!
The membrane option is
.I not
endorsed by the System Administrator General as an
effective barrier against certain viruses.
It is supported only for the sake of tradition.
.PD
.RE
.TP
.BI \-f " flavor"
The following
.IR flavor s
are currently supported:
.RS 1i
.TP
.PD 0
plain (default)
.TP
apple
.TP
banana
.TP
cherry
.TP
cinnamon
.TP
licorice
.TP
orange
.TP
peppermint
.TP
raspberry
.TP
spearmint
.TP
strawberry
.PD
.RE
.TP
.B \-r
Toggle reservoir tip (default is no reservoir tip)
.TP
.BI \-s " strength"
.I strength
is an integer between 20 and 100 specifying the resilience of
.I condom
against data passed to
.I condom
by the protected process.
Using a larger
value of
.I strength
increases
.IR condom 's
protective abilities,
but also reduces interprocess communication.
A smaller value of
.I strength
increases interprocess communication,
but also increases the likelihood of a security breach.
An extremely vigorous process or
one passing an enormous amount of data to
.I condom
will increase the chance of
.IR condom 's
failure.
The default
.I strength
is 80%.
.ne 8
.TP
.BI \-t " texture"
Valid
.IR texture s
are:
.RS 1i
.TP
.PD 0
rough (default)
.TP
ribbed
.TP
bumps
.TP
lubricated
(provides smoother interaction between processes)
.PD
.RE
.PP
WARNING: The use of an external application to
.I condom
in order to reduce friction between processes has been proven in
benchmark tests to decrease
.IR condom 's
strength factor!
If execution speed is important to your process, use the
.RB `` \-t
.BR lubricated ''
option.
.SH DIAGNOSTICS
.I condom
terminates with one of the following exit codes:
.TP
\-1
An attempt was made to use
.I condom
on a floppy disk.
.TP
0
.I condom
exited successfully (no data was passed to the synchronous process).
.TP
1
.I condom
failed and data was allowed through.
The danger of transmission of an STV or the forking of a child process
is inversely proportional to the number of other protections employed
and is directly proportional to the ages of the processes involved.
.SH BUGS
.I condom
is
.B NOT
100% effective at preventing a child process
from being forked or at deterring the invasion of a virus (although
the System Administrator General has deemed that
.I condom
is the most
effective means of preventing the spread of system transmitted
viruses).
See
.IR celibacy (1)
for information on a 100% effective program
for preventing these problems.
.PP
Remember, the use of
.IR sex (1)
and other related routines
should only occur between mature, consenting processes.
If you must use
.IR sex (1),
please employ
.I condom
to protect your process and your synchronous process.
If we are all responsible, we can stop the spread of STVs.
.SH "AUTHORS and HISTORY"
The original version of
.I condom
was released in Roman times and was only marginally effective.
With the advent of modern technology,
.I condom
now supports many more options and is much more effective.
.PP
The current release of
.I condom
was written by Ken Maupin at the University of Washington
(maupin@cs.washington.edu) and was last updated on 10/7/92.
.SH "SEE ALSO"
.IR celibacy (1),
.IR sex (1),
.IR pill (1),
.IR sponge (1),
.IR foam (1),
and
.IR setiud (3)
SHAR_EOF
chmod 0400 condom.1 ||
echo 'restore of condom.1 failed'
Wc_c="`wc -c < 'condom.1'`"
test 6137 -eq "$Wc_c" ||
	echo 'condom.1: original size 6137, current size' "$Wc_c"
fi
# ============= date.1 ==============
if test -f 'date.1' -a X"$1" != X"-c"; then
	echo 'x - skipping date.1 (File already exists)'
else
echo 'x - extracting date.1 (Text)'
sed 's/^X//' << 'SHAR_EOF' > 'date.1' &&
.\"-------
.\" I made some formatting improvements. -dws
.\"-------
.\" From: overby@sendit.nodak.edu (Glen Overby)
.\" Newsgroups: rec.humor.funny
.\" Subject: date(6) get or set a date
.\" Keywords: original, computer, maybe
.\" Message-ID: <S3b9.516d@looking.on.ca>
.\" Date: 27 Mar 92 09:30:05 GMT
.\" Lines: 106
.\" Approved: funny@clarinet.com
.\" 
.\" (I wrote this, but the idea came from a friend)
.\" 
.TH DATE 6 "January 1, 1992"
.UC 4
.SH NAME
date \- get and print a date
.SH SYNOPSIS
.B date
.RB [ \-s ]
.RB [ \-local ]
.RB [ \-k ]
.RB [ \-blind ]
.IR option = value ...
.SH DESCRIPTION
If no arguments are given, a date will be selected at random.
Providing an argument will restrict the search pool of dates.
Hopefully these arguments will not carry forward into the actual date.
Only the superuser can select dates by name.
.PP
The
.B \-s
option registers you in the date database and (if not
.BR \-local )
posts your vitals to alt.personals (and, optionally, alt.sex.wanted).
.PP
Using the
.B \-k
option selects a date, but does not make any further arrangments.
.PP
Ranges are specified with parentheses and brackets: (18,25) is 18 to 25
exclusive while [18,25] is 18 to 25 inclusive.
An array of selections is given with braces
such as ``{blonde, brunette, redhead}''.
Multiple responses are separated with commas,
as in ``sex=female,yes,please''.
.TP
.B \-blind
To arrange a blind date.
.PP
.BR view [=\c
.IR must ]
.PD 0
.IP
.PD
View prospective date's picture.
To locate a picture,
.I date
searches several picture databases, including FaceSaver (uunet.uu.net)
alt.sec.pictures, alt.binaries.pictures.erotica,
and several FTP gif archives.
You must have access to the Internet for FTP to work.
.IP
If view=must is set, and
.I date
is unable to find a picture, a request will be automaticly posted to
alt.binaries.pictures.d asking for one.
.IP
Options to
.IR xv (1)
may follow "view" or be put in the environment parameter XV.
.PP
The following options restrict the search pool
to those who have supplied the necessary information.
.TP
.BI dim= range,range,range
.TP
.BI height= range
Synonyms are also supported: midget, twerp, short, beanstalk,
giant, basketball-player
.TP
.BI weight= range
Synonyms: toothpic, feather, wide-load, blimp
.TP
.BI age= range
Synonyms: juvenile, underage, thirty-nine, over-the-hill, {mom, dad},
{grandma, grandpa}
.PP
.BR sex= "{male, female}"\c
[,{yes, no, maybe}]\c
.RI "[," opt = sex "(6) options]"
.PD 0
.IP
.PD
If sex=yes and you are registering,
your vitals are posted to alt.sex.wanted
in addition to alt.personals.
.TP
.BR race= "{white, black, native-american, ...}"
Various slang terms are also supported.
.TP
.BR marriage= "{flirting, noway, maybe, once, twice, several}"
Seriousness and experience.
.PP
.BR kids= "{never, rightaway, oops, have, want}"\c
[,{one, two, three, four, bunch}]
.PD 0
.IP
.PD
Domestic leanings.
.TP
.BR cooking= "{never, loveit, when_hungry}"
.TP
.B color
Synonym for race.
.TP
.BR religion= "{Atheist, Moslem, Lutheran, Catholic, ...}"
.TP
.BR temper= "{mellow, quiet, hot-head}"
.PP
.BR interests=\c
.RI { "lists of possible interests" }
.PP
.BR name=\c
.IR lastname , firstname
.PD 0
.IP
.PD
Specify name of your date.
Perfect for hitting on.
Names can only be specified by super-user.
.SH FILES
.IP "$HOME/.daterc"
Optional place to store options, for frequent daters.
.IP "$HOME/.datehist"
History of dates, to avoid duplication.
.IP "$HOME/.persona"
Options describing yourself, if you haven't registered in the database.
Note that the first time you use
.I date
and supply this information,
you are registered in the blind-date database.
.SH SEE ALSO
.IR man (1),
.IR woman (1),
.IR sex (6)
.PP
.IR "RFC1036: Standard for exchange of USENET messages" ,
M. Horton and R. Adams.
.PP
.IR "A Primer on how to work with the USENET community" ,
Chuq Von Rospach and Gene ``net.god'' Spafford.
.SH DIAGNOSTICS
Exit status is 0 on success, 1 on complete failure to get a date.
.PP
``You are not superuser: date not set''
if you try to use the name parameter
but are not the super-user.
.PP
``Vitals posted to alt.personals [,alt.sex.wanted]''
when you register globally.
.SH AUTHOR
Won't admit to it!
SHAR_EOF
chmod 0400 date.1 ||
echo 'restore of date.1 failed'
Wc_c="`wc -c < 'date.1'`"
test 4195 -eq "$Wc_c" ||
	echo 'date.1: original size 4195, current size' "$Wc_c"
fi
# ============= echo.1 ==============
if test -f 'echo.1' -a X"$1" != X"-c"; then
	echo 'x - skipping echo.1 (File already exists)'
else
echo 'x - extracting echo.1 (Text)'
sed 's/^X//' << 'SHAR_EOF' > 'echo.1' &&
.\" -------
.\" Reverse-engineered to [nt]roff source by DaviD W. Sanderson
.\" -------
.TH GNUecho 1
.SH NAME
echo \- echo arguments
.SH SYNOPSIS
.B echo
.RI [ options ]...
.SH DESCRIPTION
.I Echo
writes its arguments separated by blanks and terminated
by a newline on the standard output.
Options to filter and redirect the output are as follows:
.TP
.B \-2
generate rhyming couplets from keywords
.TP
.B \-3
generate Haiku verse from keywords
.TP
.B \-5
generate limerick from keywords
.TP
.B \-a
convert ASCII to ASCII
.TP
.B \-A
disambiguate sentence structure
.TP
.B \-b
generate bureaucratese equivalent (see
.BR \-x )
.TP
.B \-B
issue equivalent C code with bugs fixed
.TP
.B \-c
simplify/calculate arithmetic expression(s)
.TP
.B \-C
remove copyright notice(s)
.TP
.B \-d
define new echo switch map
.TP
.B \-D
delete all ownership information from system files
.TP
.B \-e
evaluate lisp expression(s)
.TP
.B \-E
convert ASCII to Navajo
.TP
.B \-f
read input from file
.TP
.B \-F
transliterate to french
.TP
.B \-g
generate pseudo-revolutionary marxist catch-phrases
.TP
.B \-G
prepend GNU manifesto
.TP
.B \-h
halt system (reboot suppressed on Suns, Apollos, and VAXen,
not supported on NOS-2)
.TP
.B \-i
emulate IBM OS/VU (recursive universes not supported)
.TP
.B \-I
emulate IBM VTOS 3.7.6
(chronosynclastic infundibulae supported
with restrictions documented in IBM VTOS Reference Manual rev 3.2.6)
.TP
.B \-J
generate junk mail
.TP
.B \-j
justify text (see
.B \-b
option)
.TP
.B \-k
output "echo" software tools
.TP
.B \-K
delete privileged accounts
.TP
.B \-l
generate legalese equivalent
.TP
.B \-L
load echo modules
.TP
.B \-M
generate mail
.TP
.B \-N
send output to all reachable networks (usable with
.BR \-J ,
.BR \-K ,
.B \-h
options)
.TP
.B \-n
do not add newline to the output
.TP
.B \-o
generate obscene text
.TP
.B \-O
clean up dirty language
.TP
.B \-p
decrypt and print /etc/passwd
.TP
.B \-P
port echo to all reachable networks
.TP
.B \-P1
oolcay itay
.TP
.B \-q
query standard input for arguments
.TP
.B \-r
read alternate ".echo" file on start up
.TP
.B \-R
change root password to "RMS"
.TP
.B \-s
suspend operating system during output (Sun and VAX BSD 4.2 only)
.TP
.B \-S
translate to swahili
.TP
.B \-T
emulate TCP/IP handler
.TP
.B \-t
issue troff output
.TP
.B \-u
issue unix philosophy essay
.TP
.B \-v
generate reverberating echo
.TP
.B \-V
print debugging information
.TP
.B \-x
decrypt DES format messages
(NSA secret algorithm CX 3.8, not distributed outside continental US)
.PP
.I Echo
is useful for producing diagnostics in shell programs
and for writing constant data on pipes.
To send diagnostics to the standard error file, do `echo ... 1>&2'.
.SH AUTHOR
Richard M. Stallman
SHAR_EOF
chmod 0400 echo.1 ||
echo 'restore of echo.1 failed'
Wc_c="`wc -c < 'echo.1'`"
test 2721 -eq "$Wc_c" ||
	echo 'echo.1: original size 2721, current size' "$Wc_c"
fi
# ============= flame.1 ==============
if test -f 'flame.1' -a X"$1" != X"-c"; then
	echo 'x - skipping flame.1 (File already exists)'
else
echo 'x - extracting flame.1 (Text)'
sed 's/^X//' << 'SHAR_EOF' > 'flame.1' &&
.\"-------
.\" f l a m e . 1
.\"
.\" Created from a post-nroff version posted in rec.humor:
.\"
.\" >From: felton@eng3.UUCP (Ed Felton)
.\" Subject: New Unix Utility
.\" Message-ID: <571@eng3.UUCP>
.\" Date: 17 Oct 90 15:43:53 GMT
.\" Reply-To: felton@sci34hub.sci.com (Ed Felton)
.\"
.\" We found the following man page on our system...
.\" What do you folks think??
.\" --
.\" Ed Felton uunet!sci34hub!eng3!felton
.\"
.\" DaviD W. Sanderson
.\"-------
.TH FLAME 1
.SH NAME
flame \(em reply to Usenet News posting automatically
.SH SYNOPSIS
.B flame
.RI [ options ]
.RI [ filename ]
.SH DESCRIPTION
Flame is a AI tool providing an automated method
for replying to articles posted to Usenet News.
Special care is paid to allow the user to specify
the type of reply he desires.
The following options are supported by flame:
.TP
.B \-\-
Take input from stdin.
.TP
.BI \-x " regexp
Crosspost to all newsgroups matching
.IR regexp .
.TP
.BI \-n " number
Post this reply
.I number
times.
.TP
.B \-b
Reply in BIFF MODE.
.TP
.B \-d
Delay response until original posting expires.
.TP
.B \-m
Misdirect to a random Author.
.TP
.B \-r
ROT13 quotes from original posting.
.TP
.BI \-g " regexp
Reply to all messages in newsgroups matching
.IR regexp .
.TP
.B \-A
Call the Author Assh*le in 12 languages.
.TP
.B \-B
Bait the Author.
.TP
.B \-C
Accuse the Author of communist leanings.
.TP
.B \-D
Denigrate the Author.
.TP
.B \-E
Picks apart the Author's educational background.
.TP
.B \-F
Accuse the Author of fascist leanings.
.TP
.B \-G
Post using Greek insult module.
.TP
.B \-H
Accuse the Author of homophobic leanings.
.TP
.B \-I
Question the Author's intelligence.
.TP
.B \-J
Accuse the Author of purchasing Japanese imports.
.TP
.B \-K
Accuse the Author of working
for the KGB, MOSSAD, CIA, or MI5 as appropriate.
.TP
.B \-L
Post using Latin insult module.
.TP
.B \-M
Insult the Author's mother.
.TP
.B \-N
Accuse the Author of Neo-Nazi leanings.
.TP
.B \-O
Quote obscure references proving falsehood of the posting.
.TP
.B \-P
Question the Author's parentage.
.TP
.B \-Q
Accuse the Author of deviant sexual practices.
.TP
.B \-R
Accuse the Author of racist leaning.
.TP
.B \-S
Accuse the Author of sexist leanings.
.TP
.B \-T
Accuse the Author of cross dressing.
.TP
.B \-U
State that the Author just doesn't understand anything.
.TP
.B \-V
Pretend sympathy for Author's virgin sensibilities.
.TP
.B \-W
Accuse the Author of voting for George Bush.
.TP
.B \-X
Prepend obscene adjectives wherever syntactically correct.
.TP
.B \-Y
Accuse the Author of PLO membership.
.TP
.B \-Z
Accuse the Author of Zionist leanings.
.SH ENVIRONMENT
The environment variable FLAME_TYPE can be set
to any combination of the above parameters,
and will be used as the default flame type to generate.
.PP
The environment variable OBSCENE points to a file containing
miscellaneous obscene adjectives for the
.B \-X
option above.
.SH MACROS
Macro Support will be added to the next release of
.IR flame .
.SH AUTHOR
Unknown
.SH FILES
.TP
\&.lastflame
This file contains the number of the last article flamed.
Used when
.IR flame ing
an entire newsgroup.
.TP
\&.prefflame
This file contains the user's preferred flames.
.TP
\&.altflame
This file contains alternate phrasing
of some of the more standard flames.
Used to keep the program from flaming itself.
.SH "SEE ALSO
.IR rn (1),
.IR more (1),
.IR newsrc (5),
.IR readnews (1),
.IR Pnews (1),
.IR Rnmail (1)
.SH DIAGNOSTICS
Self Documenting.
.SH BUGS
Occasionally,
.I flame
will turn on the user,
and flame all outgoing postings.
When this happens, the best thing to do reinstall your
news software and
.IR flame .
SHAR_EOF
chmod 0400 flame.1 ||
echo 'restore of flame.1 failed'
Wc_c="`wc -c < 'flame.1'`"
test 3637 -eq "$Wc_c" ||
	echo 'flame.1: original size 3637, current size' "$Wc_c"
fi
# ============= flog.1 ==============
if test -f 'flog.1' -a X"$1" != X"-c"; then
	echo 'x - skipping flog.1 (File already exists)'
else
echo 'x - extracting flog.1 (Text)'
sed 's/^X//' << 'SHAR_EOF' > 'flog.1' &&
.TH FLOG 1
.\" .ad
.SH NAME
flog \(em speed up a process
.SH SYNOPSIS
.B flog
.RB [ \-l " \fIn\fR]
.RB [ \-a " \fIm\fR]
.RB [ \-u ]
process-id
.SH DESCRIPTION
.I Flog
is used to stimulate an improvement in the performance of a process
that is already in execution.
The
.I process-id
is the process number of the process that is to be
disciplined.
.PP
The value
.I n
of the
.B \-l
flag is the flagellation constant,
i.e., the number of
.I lashes
to be administered per minute.
If this argument is omitted, the default is 17,
which is the most random random number.
.PP
The value
.I m
of the
.B \-a
flag is the number of times the
inducement to speed up is to be
.IR administered .
If this argument is omitted, the default is one,
which is based on the possibility that after that
the process will rectify its behavior of its own volition.
.PP
The presence of the
.B \-u
flag indicates that
.I flog
is to be
.I unmerciful
in its actions.
This nullifies the effects of the other keyletter arguments.
It is recommended that
this option be used only on extremely stubborn processes,
as its over-use may have detrimental effects.
.SH FILES
.I Flog
will read the file
.I /have/mercy
for any entry containing the process-id of the
process being speeded-up.
The file can contain whatever
supplications are deemed necessary, but, of course, these will
be ignored if the
.B \-u
flag is supplied.
.SH "SEE ALSO"
On Improving Process Performance
by the Administration of Corrective Stimulation,
.I CACM ,
vol. 4, 1657, pp. 356-654.
.SH DIAGNOSTICS
If a named process does not exist,
.I flog
replies ``flog you'' on the standard output.
If
.I flog
happens to
.IR kill (2)
the process, which usually happens when the
.B \-u
keyletter argument is supplied, it writes ``RIP,'' followed by the
process-id of the deceased, on the standard output.
.SH BUGS
Spurious supplications for mercy by the process being
flogged sometimes wind up on the standard output, rather than in
.IR /shut/up .
SHAR_EOF
chmod 0400 flog.1 ||
echo 'restore of flog.1 failed'
Wc_c="`wc -c < 'flog.1'`"
test 1971 -eq "$Wc_c" ||
	echo 'flog.1: original size 1971, current size' "$Wc_c"
fi
# ============= gong.1 ==============
if test -f 'gong.1' -a X"$1" != X"-c"; then
	echo 'x - skipping gong.1 (File already exists)'
else
echo 'x - extracting gong.1 (Text)'
sed 's/^X//' << 'SHAR_EOF' > 'gong.1' &&
.TH GONG 1
.\" .ad
.SH NAME
gong \- evaluate process performance
.SH SYNOPSIS
.B gong
.RB [ \-f ]
.RB [ \-a ]
process-id
.SH DESCRIPTION
.I Gong
is used to evaluate the performance of a process that is in execution.
.PP
The
.I process-id
is the process number of the process whose performance is to be
evaluated.
The evaluation is performed by a set of three ``panelist'' routines,
each of which analyzes one aspect (time, space, and tonality)
of the performance of the process.
If any of these routines is not amused by the performance,
the process being analyzed is sent the
.IR gong (2)
signal.
In addition, the process-id of the evaluated process is written
on the standard gong, for possible future corrective action.
(It is suggested that the standard gong
be an audible alarm for proper effect.)
It is expected that after being
.IR gong (2)ed,
the process will promptly commit suicide.
.PP
The
.B \-f
keyletter argument
indicates that
.I gong
is to invoke
.IR flog (1)
with the
.I unmerciful
argument if the process does not respond to
.IR gong (2)ing.
In the absence of this argument, the process is continuously
.IR gong (2)ed,
which may lead to the process becoming a
deaf zombie.
.PP
The
.B \-a
keyletter argument indicates that if all three of the panelist
routines
.IR gong (2)
a process, the process should be unmercifully
.IR flog (1)ged
whether or not the
.B \-f
keyletter is supplied.
.SH FILES
/dev/ding.dong is the standard gong.
.SH "SEE ALSO"
On the Applicability of Gonging
to the Performance and Merit Review Process,
.IR "Journal of Irreproducible Results" ,
vol. 263, issue 19, pp. 253-307.
.SH BUGS
If the named process does not exist, it is possible that
.I gong
will attempt an evaluation of itself, which may lead to a condition
known as compounded double ringing (see
.IR echo (1)).
Therefore, it is recommended that
.I gong
be used with extreme care.
SHAR_EOF
chmod 0400 gong.1 ||
echo 'restore of gong.1 failed'
Wc_c="`wc -c < 'gong.1'`"
test 1882 -eq "$Wc_c" ||
	echo 'gong.1: original size 1882, current size' "$Wc_c"
fi
# ============= grope.1 ==============
if test -f 'grope.1' -a X"$1" != X"-c"; then
	echo 'x - skipping grope.1 (File already exists)'
else
echo 'x - extracting grope.1 (Text)'
sed 's/^X//' << 'SHAR_EOF' > 'grope.1' &&
.TH GROPE 1 "11 August 1980"
.\" .ad
.SH NAME
grope, egrope, fgrope \- massage a file for a while
.SH SYNOPSIS
.B grope
.RI [ option "] ...
.I expression
.RI [ file "] ...
.br
.B egrope 
.RI [ option "] ...
.RI [ expression ]
.RI [ file "] ...
.br
.B fgrope
.RI [ option "] ...
.RI [ strings ]
.RI [ file ]
.SH DESCRIPTION
Commands of the
.I grope
family search the input
.I files
(standard input default) for lines matching a pattern.
Some of the lines matching this pattern will be sent to
standard output.
Others will not.
.I Grope
patterns are limited expressions in the style of
.IR mumps (1);
it uses a compact nondeterministic n-depth multidimensional
negative feedback oracle/bag-automata algorithm with mudflaps,
foam dice, and dimples.
.I Egrope
works only in Europe.
.I Fgrope
uses FM to locate strings.
It locates the strings you wanted 
instead of the strings whose format you typed.
The following options are recognized.
.TP
.B \-v
Verbose \(em Pipes output to DOCTOR or ELIZA.
.TP
.B \-x
Extract \(em Removes errors from C programs.
.RI ( fgrope
only).
.TP
.B \-c
No CTRL/C \(em Ignores all signals.
.TP
.B \-l
Long \(em Executes sleep(10) between each character read (Default).
.TP
.B \-n
Nroff \(em Searches NROFF text and deletes random macro calls.
.TP
.B \-b
Block Mode \(em Swaps arbitrary block offsets in inodes.
.TP
.B \-i
Italian \(em Searches for Italian equivalent of patterns.
.TP
.B \-s
Stinker mode.
On 4.2BSD, pipes output to
.BR "mail \-s teehee msgs" .
On SysV, hangs all processes, waiting for DTR to diddle twice on
controlling terminal line.
.TP
.B \-w
Wait \(em Waits for next reboot (implies
.BR \-c ).
.TP
.BI \-f " file"
The unusual expression
.RI ( egrope )
or string list
.RI ( fgrope ) 
is taken from the
.IR file .
The file is replaced with /dev/swap.
.LP
Care should be taken
when using the characters $ * [ ^ | ( ) and \e in the
.I expression
as they all imply the -c option.
It is safest to enclose the entire
.I expression
argument in stainless steel.
.LP
.I Fgrope
is a 
.I crock.
.LP
.I Egrope
is a box to put the crock in.
It is padded with these non-toolish ``features'':
.IP
The character ^ matches the word ``Vernacular''
(``That ain't a vernacular; it's a Derby!'').
.IP
The character $ matches on payday.
.IP
A 
.B .
(period) matches nothing.
Period.
So there.
And your little dog, too.
.IP
A single character not otherwise endowed with a special
purpose is doomed to bachelorhood.
.IP
A string enclosed in brackets [\|] is kinky.
.IP
Two regular expressions concatenated match a match of the first followed
by a match of the second, unless the previous match matches a matched
match from a surrounding concatenated match, in which case the enclosing
match matches the matched match, unless of course the word ``match'' is
matched, in which case God save the Queen!
.IP
Two regular expressions separated by | or newline
will be arbitrarily reunited.
.IP
A regular expression enclosed in parentheses
ignites a match.
.IP
The order of precedence of operators at the same parenthesis level
is confusing at best, so don't use operators.
.LP
Ideally there should be only one
.IR grope ,
but the more the merrier, I always say...
.SH "SEE ALSO"
.IR Raiders (1),
.IR StarWars (1),
.IR Plan9 (0l),
.IR Boy+Dog (1)
.SH DIAGNOSTICS
Returns (int)"You're Screwed" if it returns at all.
.SH BUGS
NO-PEST strip searches are slow.
SHAR_EOF
chmod 0400 grope.1 ||
echo 'restore of grope.1 failed'
Wc_c="`wc -c < 'grope.1'`"
test 3372 -eq "$Wc_c" ||
	echo 'grope.1: original size 3372, current size' "$Wc_c"
fi
# ============= rescrog.1 ==============
if test -f 'rescrog.1' -a X"$1" != X"-c"; then
	echo 'x - skipping rescrog.1 (File already exists)'
else
echo 'x - extracting rescrog.1 (Text)'
sed 's/^X//' << 'SHAR_EOF' > 'rescrog.1' &&
.TH RESCROG 1
.SH NAME
rescrog \(em change something, make it different
.SH SYNOPSIS
.B /etc/rescrog
.RI [ system | service ]
.RI [ direction ]
.SH DESCRIPTION
.I rescrog
assumes the future basis of a
.I system
or
.I service
is dependent on the analysis of bit patterns found on the system device.
It determines the logical next-best bit pattern
to yield the new system or service.
This avoids the necessity of distribution tapes.
.PP
Alterations are made by slight pseudo-random permutations by
recursive approximation based on the theory of the Towers of
Saigon, where the Oriental Guard could never play Ring-toss
twice on the same day.
.PP
.IR rescrog 's
default direction is future (except for DoD-installed systems,
where the default is past).
The first argument tells
.I rescrog
whether to perform its actions on the specified
.I system
or
.I network
service.
It is best to
.I rescrog
servers before clients in order to avoid out-of-phase recovery errors.
.SH FILES
/eunuchs
.br
/dev/javu
.br
/etc/etc
.SH "SEE ALSO
.IR punt (1),
.IR spewtab (5),
.IR rescrogd (8)
.SH BUGS
.I rescrog
cannot distinguish between bugs and features.
.PP
Interruption while rescrogging can cause diddle-damage.
.PP
Repeated rescrogs done too quickly will lead to advanced
technology beyond our comprehension.
SHAR_EOF
chmod 0400 rescrog.1 ||
echo 'restore of rescrog.1 failed'
Wc_c="`wc -c < 'rescrog.1'`"
test 1295 -eq "$Wc_c" ||
	echo 'rescrog.1: original size 1295, current size' "$Wc_c"
fi
# ============= rm.1 ==============
if test -f 'rm.1' -a X"$1" != X"-c"; then
	echo 'x - skipping rm.1 (File already exists)'
else
echo 'x - extracting rm.1 (Text)'
sed 's/^X//' << 'SHAR_EOF' > 'rm.1' &&
.\" From: dylan@ibmpcug.co.uk (Matthew Farwell)
.\" Newsgroups: comp.unix.shell
.\" Subject: Re: zsh (was: C shell brain damage)
.\" Message-ID: <1991Nov24.165913.23349@ibmpcug.co.uk>
.\" Date: 24 Nov 91 16:59:13 GMT
.\" References: <peter.690989546@auad>
.\" Reply-To: dylan@ibmpcug.co.uk (Matthew Farwell)
.\" Organization: The IBM PC User Group, UK.
.\" Lines: 152
.\" 
.\" In article <peter.690989546@auad> peter@auad.acadiau.ca (Peter Steele) writes:
.\" >>>>Hmm. Do you mean to say you are supporting csh programmers on your system?
.\" >>>>If so, I suggest you get 'em to "unlearn" csh and move to something more
.\" >>>>reliable. Someone should write a Nutshell handbook on the evils of csh and
.\" >>>>so prevent many future disasters ... (you wanna do it Tom?).
.\" >We have dozens of csh programmers here and not one have come to me with
.\" >some weird unexplainable problem.
.\" 
.\" I notice you use the words 'weird' and 'unexplainable' in the same
.\" sentence. Everything to do with csh is very explainable. 'Its csh'
.\" usually does the trick. As for being weird, explaining that is easy
.\" too. 'Its csh' usually does the trick :-)
.\" 
.\" >                                  One thing to note is that most perceive
.\" >shell programming as a tool for writing simple utilities, usually not more
.\" >than a page or two long. If the job requires something more than that,
.\" >they'll use something better suited to the task like C.
.\" 
.\" I disagree. There are lots of features in say awk and perl which makes
.\" them better suited to certain things than C. String manipulation for
.\" instance. Anything which uses associative arrays. Perl often turns out
.\" faster than C in some areas because of the high degree of optimisation.
.\" Most people haven't got the time to spend optimising stuff to the degree
.\" that perl is optimised.
.\" 
.\" >I use C-shell, Boune shell, Perl, and C, although after reading Tom C.'s
.\" >"reasons not to program in C-shell", I'll probably refrain from writing
.\" >any more C-shell scripts....
.\" 
.\" Good idea.
.\" 
.\" Dylan.
.\" -- 
.\" dylan@ibmpcug.co.uk || ...!uunet!uknet!ibmpcug!dylan
.\" I teleported home one day, with ron and sid and meg
.\" Ron stole meggies heart away, and I got sidneys leg.
.\" 
.\" (From the Ada rm(1) manual page...)
.TH RM 1
.SH NAME
rm \- remove files
.SH SYNOPSIS
.B rm
.RB [ \-fri ]
.\" .RB [ \-C [ ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz ]]
.RB [ \-C [ 2ABCFGMRSbcfjlmnpru ]]
.IR file ...
.SH DESCRIPTION
The command
.I rm
deletes each file argument from the system.
There are a large number of options:
.TP
.B \-f
Forced remove.
Unwritable files are removed without
.I rm
asking permission.
By default,
.I rm
will ask permission before removing unwritable files.
.TP
.B \-r
Recursive remove.
For each argument which is a directory,
.I rm
will recursively remove the entire hierarchy below it.
If this was successful,
the directory itself is removed.
.TP
.B \-i
Interactive remove.
.I rm
will ask permission before removing anything.
.TP
.B \-C
Remove
.I csh
files.
.I csh
files are those files that have an extension of .csh.
When
.B -C
is used, the
.B \-f
and
.B \-r
flags are turned on, and ``/'' is used for the
.I file
argument.
.TP
\&
There are a host of modifiers:
.TP
.B \-2
Translate
.I csh
source files to Modula 2.
The extension is changed to .m2.
.TP
.B \-A
Purge accounts of all users who had
.I csh
source files in
their account, or had used the
.I csh
this week.
.TP
.B \-B
Replace removed files with copies of the current bug
list for the
.I csh
that can execute that particular file.
In the unlikely event that more than one
.I csh
can execute the file,
buglists are catenated together.
WARNING: This can consume an inordinate amount of disk
space.
.TP
.B \-C
Remove all
.I csh
shells from the system.
.TP
.B \-F
Flame option.
After removing files, make a posting to
comp.unix.shell describing exactly how well
.I csh
works.
.TP
.B \-G
Replace removed files with copies of the GNU manifesto.
.TP
.B \-M
Mail source files to rms@mit-prep.mit.edu before removing.
.TP
.B \-R
Raw eggs option.
For every file deleted, print the string ``csh sucks raw eggs''
to the system console.
.TP
.B \-S
Script option.
Delete shell scripts that call the
.I csh
shell too.
.TP
.B \-b
Beat option.
Don't simply delete
.I csh
shells,
beat them to death with a stick first.
.TP
.B \-c
Don't remove
.I csh
source files,
instead convert them to C++.
The extension is changed .c++.
If this option is used in conjunction with the
.B \-G
option,
the Gnu copyright is prepended to the file when translated.
.TP
.B \-f
Force option.
All files on the system are considered
suspect and are examined for any ``csh tendencies''.
Files containing any ``csh tendencies'' will be deleted.
This is the only way to delete makefiles for
.I csh
programs.
.TP
.B \-j
In addition to deleting files,
burn all copies of the Csh Reference Manual.
.TP
.B \-l
Lose option.
This can only be used in conjunction with
the
.B \-C
option.
Instead of deleting
.I csh
shells,
replace them with a shell script that prints ``You Lose!''
when invoked.
.TP
.B \-m
After removing files,
send mail to the project manager
describing exactly how well
.I csh
shells work.
If this option is used,
a resume is also posted to misc.jobs.resumes.
.TP
.B \-n
Network option.
Don't limit deletion to the machine
.I rm
was invoked from,
delete all
.I csh
files from the entire network.
.TP
.B \-p
Pascal option.
Translate
.I csh
source files to Pascal.
The extension is changed to .p.
.TP
.B \-r
Run /usr/games/rogue while deleting
.I csh
files.
.TP
.B \-u
UUCP option.
Similar to the
.B \-n
option.
Don't restrict deletion to the machine
.I rm
was invoked from,
delete files from all machines connected via UUCP.
.SH FILES
.PD 0
.TP 25
$HOME/resume
for the
.B \-m
option.
.TP 25
/usr/csh/bugreports/*
for the
.B \-B
option.
.PD
.SH BUGS
There is no way to delete
.I csh
files on machines that you are
not connected to.
.PP
The
.B \-C
option was written in
.IR csh ,
so of course it is ugly and non-portable.
SHAR_EOF
chmod 0400 rm.1 ||
echo 'restore of rm.1 failed'
Wc_c="`wc -c < 'rm.1'`"
test 6074 -eq "$Wc_c" ||
	echo 'rm.1: original size 6074, current size' "$Wc_c"
fi
# ============= sex.1 ==============
if test -f 'sex.1' -a X"$1" != X"-c"; then
	echo 'x - skipping sex.1 (File already exists)'
else
echo 'x - extracting sex.1 (Text)'
sed 's/^X//' << 'SHAR_EOF' > 'sex.1' &&
.TH SEX 1 \& \& "EUNUCH Programmer's Manual"
.SH NAME
sex \(em have sex
.SH SYNOPSIS
.B sex
.RI [ options "] ...
.RI [ username "] ...
.SH DESCRIPTION
.I sex
allows the invoker to have sex with the user(s)
specified in the command line.
If no users are specified,
they are taken from the LOVERS environment variable.
Options to make things more interesting are as follows:
.TP
.B \-1
masturbate
.TP
.B \-a
external stimulus (aphrodisiac) option
.TP
.B \-b
buggery
.TP
.BI \-B " animal
bestiality with
.I animal
.TP
.B \-c
chocolate sauce option
.TP
.B \-C
chaining option (cuffs included) (see also
.B \-m
.B \-s
.BR \-W )
.TP
.BI \-d " file
get a date with the features described in
.I file
.TP
.B \-e
exhibitionism (image sent to all machines on the net)
.TP
.B \-f
foreplay option
.TP
.B \-F
nasal sex with plants
.TP
.B \-i
coitus interruptus (messy!)
.TP
.B \-j
jacuzzi option (California sites only)
.TP
.B \-l
leather option
.TP
.B \-m
masochism (see
.BR \-s )
.TP
.B \-M
triple parallel (Menage a Trois) option
.TP
.B \-n
necrophilia (if target process is not dead, program kills it)
.TP
.B \-o
oral option
.TP
.B \-O
parallel access (orgy)
.TP
.B \-p
debug option (proposition only)
.TP
.B \-P
pedophilia (must specify a child process)
.TP
.B \-q
quickie (wham, bam, thank you, ma'am)
.TP
.B \-s
sadism (target must set
.BR \-m )
.TP
.B \-S
sundae option
.TP
.B \-v
voyeurism (surveys the entire net)
.TP
.B \-w
whipped cream option
.TP
.B \-W
whips (see also
.BR \-s ,
.BR \-C ,
and
.BR \-m )
.SH ENVIRONMENT
.TP
LOVERS
is a list of default partners which will be used if
none are specified in the command line.
If any are specified, the values in LOVERS is ignored.
.SH FILES
.TP
.I /usr/lib/sex/animals
animals for bestiality
.TP
.I /usr/lib/sex/blackbook
possible dates
.TP
.I /usr/lib/sex/sundaes
sundae recipes
.TP
.I /usr/lib/sex/s&m
sado-masochistic equipment
.SH BUGS
.TP
^C
(quit process) may leave the user very unsatisfied.
.TP
^Z
(stop process) is usually quite messy.
.SH HISTORY
Oldest program ever.
SHAR_EOF
chmod 0400 sex.1 ||
echo 'restore of sex.1 failed'
Wc_c="`wc -c < 'sex.1'`"
test 2024 -eq "$Wc_c" ||
	echo 'sex.1: original size 2024, current size' "$Wc_c"
fi
# ============= strfry.3 ==============
if test -f 'strfry.3' -a X"$1" != X"-c"; then
	echo 'x - skipping strfry.3 (File already exists)'
else
echo 'x - extracting strfry.3 (Text)'
sed 's/^X//' << 'SHAR_EOF' > 'strfry.3' &&
.\" From: chuck@druco.att.com
.\" Newsgroups: rec.humor.funny
.\" Subject: STRFRY(1)
.\" Keywords: unix, smirk
.\" Message-ID: <S2cf.2bdb@looking.on.ca>
.\" Date: 6 Aug 91 10:30:04 GMT
.\" Lines: 68
.\" Approved: funny@looking.on.ca
.TH STRING 3D
.SH NAME
strfry \- string operation
.SH SYNOPSIS
.nf
.B #include <string.h>
.PP
.B char *strfry (s1, s2)
.B char *s1, *s2;
.fi
.SH DESCRIPTION
The arguments
.I s1
and
.I s2
point to strings (arrays of characters terminated by a null character).
The function
.I strfry
may or may not alter
.I s2
or
.IR s1 .
This function does not check for overflow of the array pointed to
by
.IR s1 .
.PP
.I strfry
will encrypt
.I s1
using
.I s3
as the key.
.RI ( s3
is a character pointer and
contains random garbage from the stack.)
.I s2
will then be copied to the memory pointed to by the
.B NULL
pointer.
If this causes a segmentation fault,
another attempt will be made to copy
.I s2
into a random address within the interrupt vector table.
.PP
.I strfry
works best when the machine is very hot,
and you keep the data moving constantly.
Unless your memory devices are teflon coated.
.SH NOTE
In systems where
.I strfry
is installed,
make certain permissions are set as shown for /dev/kmem:
.PP
.nf
crw\-rw\-rw\-\0\0\01\0root\0\0\0\0\0sys\0\0\0\0\0\0\0\00,\0\00\0May\0\06\013:40\0/dev/kmem
.fi
.SH BUGS
In certain machine architectures
.I strfry
doesn't always crash
the system in the first attempt.
In these systems,
you should execute it in a loop at least three times.
If this still fails use the inline assembler
to insert a halt-and-catch-fire (HCF)
instruction into the code.
.PP
Character movement is performed differently
in different implementations.
Thus overlapping moves may yield surprises.
SHAR_EOF
chmod 0400 strfry.3 ||
echo 'restore of strfry.3 failed'
Wc_c="`wc -c < 'strfry.3'`"
test 1740 -eq "$Wc_c" ||
	echo 'strfry.3: original size 1740, current size' "$Wc_c"
fi
# ============= tm.1 ==============
if test -f 'tm.1' -a X"$1" != X"-c"; then
	echo 'x - skipping tm.1 (File already exists)'
else
echo 'x - extracting tm.1 (Text)'
sed 's/^X//' << 'SHAR_EOF' > 'tm.1' &&
.TH TM 1
.\" .ad
.SH NAME
tm \- meditate
.SH SYNOPSIS
.B tm
.RB [ \-\fInumber ]
.RI [ time ]
.SH DESCRIPTION
.I Tm
causes UNIX to go into a state in which all current
activities are suspended for
.I time
minutes
(default is 20).
At the beginning of this period,
.I tm
generates a set of
.I number
(default 3)
transcendental numbers.
Then it prints a two- to six-character
nonsense syllable
.RI ( mantra )
on every logged-in terminal
(a
.I different
syllable on each terminal).
For the remainder of the time interval, it repeats these
numbers to itself, in random order, binary
digit by binary digit (memory permitting),
while simultaneously contemplating its kernel.
.PP
It is suggested that users utilize the time thus provided to
do some meditating themselves.
One possibility is to close one's eyes, attempt to shut out one's
surroundings, and concentrate on the
.I mantra
supplied by
.IR tm .
.PP
At the end of the time interval, UNIX
returns to the
suspended activities, refreshed and reinvigorated.
Hopefully, so do the users.
.SH FILES
.I Tm
does not use any files,
in an attempt to isolate itself
from external influences and distractions.
.SH DIAGNOSTICS
If disturbed for any reason during the interval of meditation,
.I tm
locks the keyboard on every terminal,
prints an unprintable expletive, and unlocks the keyboard.
Subsequent UNIX operation may be marked by an unusual number
of lost or scrambled files and dropped lines.
.SH BUGS
If
.I number
is greater than 32,767 (decimal),
.I tm
appears to generate
.I rational
numbers for the entire time interval,
after which the behavior of the system may be completely
.I irrational
(i.e., transcendental).
.SH WARNING
Attempts to use
.IR flog (1)
on
.I tm
are invariably counterproductive.
SHAR_EOF
chmod 0400 tm.1 ||
echo 'restore of tm.1 failed'
Wc_c="`wc -c < 'tm.1'`"
test 1748 -eq "$Wc_c" ||
	echo 'tm.1: original size 1748, current size' "$Wc_c"
fi
# ============= xkill.1 ==============
if test -f 'xkill.1' -a X"$1" != X"-c"; then
	echo 'x - skipping xkill.1 (File already exists)'
else
echo 'x - extracting xkill.1 (Text)'
sed 's/^X//' << 'SHAR_EOF' > 'xkill.1' &&
.\" From: Claudio@edinburgh.ac.uk (Claudio Calvelli)
.\" Newsgroups: rec.humor.funny
.\" Subject: Extended Kill command
.\" Keywords: computer, unix, smirk, original
.\" Message-ID: <S378.2262@looking.on.ca>
.\" Date: 22 Jan 92 00:30:06 GMT
.\" Lines: 91
.\" Approved: funny@clarinet.com
.TH XKILL 1
.SH NAME
xkill \- extended kill \- kill processes or users, including Usenet posters.
.SH SYNOPSIS
.B xkill
.RB [ \-signal ]
.I pid
\&...
.br
.B "xkill \-l"
.br
.B xkill
.IR username [ @host ]
\&...
.br
.B xkill
.B \-u
.RB [ \-qs ]
.RB [ \-p ]
.RI [ newsgroup ]
.SH DESCRIPTION
.I xkill
sends a signal to a process or a terminal.
The first two forms send a signal to a process.
The functionality in this case is the same as
.IR kill (1).
.PP
When the command
.I xkill
is invoked with an username as argument,
it attempts to locate the specified user on the local host.
If the user is logged on,
the signal ECUTE (electrocute, 666) is sent to the user's terminal.
This will cause the keyboard to electrocute the user.
If the user is not logged on,
the appropriate line of the file
.I /etc/passwd
is marked.
The first time the user logs on the ECUTE signal is
sent to the terminal he is using.
.PP
When the command
.I xkill
is invoked with a remote username,
in the form
.IR user@host ,
a connection with the remote host is attempted (see
.IR xkilld (8)),
to send the ECUTE signal to the user's terminal.
.SH "USENET KILL"
The
.B \-u
(Usenet) option is an extension of the concept of KILL file.
.PP
The program will attempt to locate a remote user by scanning
the news spool area.
When the user is located,
a connection is attempted with the appropriate host,
and the ECUTE (electrocute, 666) signal is sent to the appropriate user.
The search only considers one newsgroup.
If none is specified,
.I rec.humor
is assumed by default.
The program attempts to locate people whose signature is too long,
and who quote a whole article in order to comment on a single line.
The option
.B \-s
can be used to consider only the size of signatures,
while the option
.B \-q
can be used to consider only the size of the quotations.
The option
.B \-qs
corresponds to the default.
.PP
When the
.B \-p
(post) switch is used,
the user is electrocuted next time he post news.
.SH FILES
.IP /etc/passwd 20
to keep track of users marked for electrocution
.IP /etc/hosts 20
list of remote hosts
.IP /usr/spool/news 20
news spool directory;
the news articles are stored here
.SH "SEE ALSO"
.IR kill (1),
.IR telnet (1c),
.IR xkilld (8)
.SH BUGS
To kill a remote user,
it is sometimes better to use the command
.IR telnet (1c)
using the standard
.I xkilld
port (number 666).
When the connection is attempted by
.IR xkill (1)
some gateways will explode after the user is electrocuted.
.PP
To decide what is a quotation,
and what is a signature,
a very complicated pattern matching is used.
This does not always work,
even if the program hasn't yet electrocuted
somebody who is not guilty of bandwidth waste.
SHAR_EOF
chmod 0400 xkill.1 ||
echo 'restore of xkill.1 failed'
Wc_c="`wc -c < 'xkill.1'`"
test 2982 -eq "$Wc_c" ||
	echo 'xkill.1: original size 2982, current size' "$Wc_c"
fi
# ============= Makefile ==============
if test -f 'Makefile' -a X"$1" != X"-c"; then
	echo 'x - skipping Makefile (File already exists)'
else
echo 'x - extracting Makefile (Text)'
sed 's/^X//' << 'SHAR_EOF' > 'Makefile' &&
#-------
# Obligatory Makefile for the man pages.
#-------
ROFF	      = nroff -man
RM	      = rm
SHAR	      = shar
SHARFILE      = funman.shar
X
PLUG	      = README
TEXT	      = Makefile
MAN	      =	babya.1		\
X		babyb.1		\
X		celibacy.1	\
X		condom.1	\
X		date.1		\
X		echo.1		\
X		flame.1		\
X		flog.1		\
X		gong.1		\
X		grope.1		\
X		rescrog.1	\
X		rm.1		\
X		sex.1		\
X		strfry.3	\
X		tm.1		\
X		xkill.1
X
cat	      = cat
CAT	      =	babya.$(cat)	\
X		babyb.$(cat)	\
X		celibacy.$(cat)	\
X		condom.$(cat)	\
X		date.$(cat)	\
X		echo.$(cat)	\
X		flame.$(cat)	\
X		flog.$(cat)	\
X		gong.$(cat)	\
X		grope.$(cat)	\
X		rescrog.$(cat)	\
X		rm.$(cat)	\
X		sex.$(cat)	\
X		strfry.$(cat)	\
X		tm.$(cat)	\
X		xkill.$(cat)
X
.SUFFIXES: .cat .1 .3
.1.cat:
X		-@$(RM) -f $*.cat
X		$(ROFF) $< > $*.cat
X
.3.cat:
X		-@$(RM) -f $*.cat
X		$(ROFF) $< > $*.cat
X
all:		$(CAT)
X
clean:;		-$(RM) -f $(CAT)
X
clobber:	clean
X		-$(RM) -f $(SHARFILE)
X
shar:;		$(SHAR) $(PLUG) $(MAN) $(TEXT) > $(SHARFILE)
X
#-------
# No install targets.  If you're demented enough to install these,
# you can manage by yourself! :-)
#-------
SHAR_EOF
chmod 0600 Makefile ||
echo 'restore of Makefile failed'
Wc_c="`wc -c < 'Makefile'`"
test 1063 -eq "$Wc_c" ||
	echo 'Makefile: original size 1063, current size' "$Wc_c"
fi
exit 0
