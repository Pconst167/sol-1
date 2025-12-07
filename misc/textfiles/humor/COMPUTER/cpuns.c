Article 432 of comp.sources.misc:
>From: mjs@tropix.UUCP (Michael J Shon)
Newsgroups: comp.sources.misc
Subject: v02i099: a little joke in C
Message-ID: <303@tropix.UUCP>
Date: 18 Apr 88 19:35:35 GMT
Approved: allbery@ncoast.UUCP

comp.sources.misc: Volume 2, Issue 99
Submitted-By: "Michael J Shon" <mjs@tropix.UUCP>
Archive-Name: c_puns

Well...
I lost my mind one day when I saw a piece of code like
	long time();	/* know C */
and this was the result.  I think that it lints ok. (I haven't really checked)
It compiles and runs, but it's really intended for very careful reading.
(I like to think that there are a few subtle jokes in it.)
					mike shon
---------------------------cut here------------------------------------------
/*
 * find the important things in Life, the Universe, and Everything
 */

typedef short	some;		/* some things are short */
typedef some	very;		/* some things are very short */

#define A			/* The first letter of the English Alphabet */
#define LINE	2		/* 2 points define a line */

#define TRUTH	BEAUTY		/* truth is beauty */
#define BEAUTY	10		/* and beauty is a 10 */

#define bad	char		/* burnt on both sides */
#define old	char		/* the great Chicago Fire */

#define	get	strlen		/* during your life, try to get some sterling */
#define youmake	float		/* you make it, I'll drink it */


#define		yourgoals	in terms you can understand
/*
#include	"yourdreams"	/* for the future */


	/* everyone needs goals */

short	term;
double	yourpleasure();
double	yourfun;

long	Term, play(), agame;

	/* everyone needs diversions */

old *joke = "Why did the chicken cross the road?\n\tTo get to the other side!\n\t\tWocka Wocka Wocka!\n";
	

tell(joke)
bad	*joke;		/* wait- you haven't heard it yet! */
{
	short laugh;	/* please */

	laugh = get(joke);
	write(1, joke, laugh);	/* write it down- don't say it */

}

	/* most folks like music */

long play(record)
long record;
{
	very pleasant = TRUTH;		/* if you like music */

	while (record == pleasant)
		play(record--);

	return( pleasant );		/* music soothes the savage */
}


double	yourpleasure(one, way)		/* this is necessary if */
some	one;				/* is watching ,or if you have a */
long	way;				/* to go  */
{
		/* this can change one while maintaining one's identity */
	one = one * one;
	return( one );		/* after all, it should have at least doubled */
}

hold(temper)			/* good advice */
A short temper;			/* is a dangerous thing */
{
	A long	time;		/* is what you need */
	very calm;		/* is how you should be */

	calm = temper, temper;

	while (calm--)
		wait(&time);

	return(calm);		/* if possible */
}


	/* now, on to the main thing */

main(thing, mustbe)		/* to balance work, play, and goals */
some thing, mustbe;		/* important, or we wouldn't be here */
{

	long	time();		/* know C */
	very	bored;		/* the result of too few goals */

	short	hours;		/* make */
	long	yourwork;	/* which makes for */
	short	tempers;	/* which can be improved by */
	long	laughing;


	/* first, set priorities */
	yourwork = 0;
	yourfun = 1.0e+38;

	if (yourpleasure( mustbe, yourwork ))
		yourfun = yourwork;
	else
		yourfun = play( agame );

	bored = yourfun - yourwork;  	/* nothing to do? */
					/* reach out and touch someone! */

	switch ( bored ) {	/* connects all of this together */
	default:
		hours = hold(LINE); /* no way to avoid it, take a */
		break;
	}

		/* take a music break */
	while ( thing-- ) {	/* you make my heart sing */
		youmake everything;
		very groovy;
	}

		/* focus on what is important to you */
	while ( yourfun < 0 ) {
		yourpleasure( mustbe, agame);
		yourfun = play( agame );
	}

	tell(joke);

	exit( laughing );
}
 