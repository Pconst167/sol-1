I just stumbled across this on your site.  Here's a little
history about it, in case you are interested.

I was the one who had the idea to run this ad, and
both wrote the code and typeset the camera-ready
copy for the newspaper insertion.  (We did this because
we felt that there was no way that the editors at the
Boston Globe would preserve the correct lisp
indentation which made the function more readable.)

We wanted to hire some Lisp programmers for
a project at DEC (Digital Equipment Corporation
back then), and wanted the very fact of their
knowing what the name of the company was to
be a sort of pre-screening that they did indeed
understand a little about Lisp.

I constructed this ad so that the function would
only reveal the name of the company if you
evaluated a call to it with appropriate arguments
by extracting and combining pieces of the function
definition itself.

(The original version also constructed the phone
number out of pieces, but that both made the code
longer and more obscure, so in the end we decided
against it.)

While someone could have just typed it in to a
suitable PDP-10 installation running a suitable
version of MacLisp and run it with the appropriate
arguments, since such installations were pretty
rare it was much more likely that someone
would "evaluate it by hand" to find out the result
and if they succeeded, they were the sort of candidate
for whom we were looking.

One sticking point in getting the ad run was that the
corporate lawyers had decreed that the phrase
"Digital is an affirmative action employer" had to
appear at the bottom of every ad.   It took a serious
amount of arguing to convince them that this would
defeat the purpose of the ad and that we could change
it to "We are an affirmative action employer."
Typesetting the ad was an effort in itself; Digital had
a brand-new typesetting program (this was long before
laser printers) called Typeset-10, but the program
and the photo typesetter (which was the size of a washing
machine and used photographic paper and chemicals)
were both finicky.  It took a lot longer than I expected (on
the order of days) to get an acceptable typeset version
to be able to send to the newspaper.

We did get some responses to the ad and did interview
some candidates, but I don't recollect that we hired
anyone from it.  One person called, said "It only works
interpreted" and hung up. He was referring to the fact that
MacLisp could compile functions as well as interpret
them, but those compiled functions couldn't manipulate
their own definitions the way the ad function did.

On a trip to the west coast years later, I saw a photocopy
of the ad pinned to a bulletin board.  When I asked about
it I discovered that copies had circulated among Lisp
programmers but they (the ones I talked to at least) didn't
know the name of the company for which the ad was run.

Yours sincerely,

Kalman Reti
Ab Initio Software Corporation
