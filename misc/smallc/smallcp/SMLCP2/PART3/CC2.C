/*
 * cc2.c - second part of Small-C/Plus compiler
 *         routines to compile statements
 */

#include <stdio.h>
#include <string.h>
#include "ccdefs.h"
#include "ccfunc.h"

extern SYMBOL *locptr ;
extern WHILE_TAB *wqptr ;
extern int lastst, Zsp, eof ;
extern int ncmp, declared, trace ;
extern int swdefault, swactive ;
extern SW_TAB *swnext, *swend ;
extern char line[] ;
extern int cmode ;
extern SYMBOL *currfn ;
extern FILE *output ;

/*
 *	Statement parser
 *
 * called whenever syntax requires a statement.
 * this routine performs that statement
 * and returns a number telling which one
 */
statement()
{
	char sname[NAMESIZE] ;
	TAG_SYMBOL *otag ;
	int sflag, st ;

#ifdef CPM
	if ( cpm(11,0) & 1 )	/* check for ctrl-C */
		if ( getchar() == 3 )
			ccabort() ;
#endif

	blanks() ;
	if ( ch()==0 && eof )
		return (lastst=STEXP) ;
	else {
		switch ( ch() ) {
		case 'c' :
			if ( amatch("char") ) {
				declloc(CCHAR, NULL_TAG) ;
				return lastst ;
			}
			break ;
		case 'i' :
			if ( amatch("int") ) {
				declloc(CINT, NULL_TAG) ;
				return lastst ;
			}
			break ;
		case 'd' :
			if ( amatch("double") ) {
				declloc(DOUBLE, NULL_TAG) ;
				return lastst ;
			}
			break ;
		case 's' :
			if ( (sflag=amatch("struct")) || amatch("union") ) {
				if ( symname(sname) == 0 )
					illname() ;
				if ( (otag=findtag(sname)) == 0 ) {
					/* structure not previously defined */
					otag = defstruct(sname, STATIK, sflag) ;
				}
				declloc(STRUCT, otag) ;
				return lastst ;
			}
			break ;
		}
		/* not a definition */
		if ( declared >= 0 ) {
			Zsp = modstk(Zsp-declared, NO) ;
			declared = -1 ;
		}
		st = -1 ;
		switch ( ch() ) {
		case '{' :
			inbyte() ;
			compound() ;
			st = lastst ;
			break ;
		case 'i' :
			if ( amatch("if") ) {
				doif() ;
				st = STIF ;
			}
			break ;
		case 'w' :
			if ( amatch("while") ) {
				dowhile() ;
				st = STWHILE;
			}
			break ;
		case 'd' :
			if ( amatch("do") ) {
				dodo() ;
				st = STDO ;
			}
			else if ( amatch("default") ) {
				dodefault() ;
				st = STDEF ;
			}
			break ;
		case 'f' :
			if ( amatch("for") ) {
				dofor() ;
				st = STFOR ;
			}
			break ;
		case 's' :
			if ( amatch("switch") ) {
				doswitch() ;
				st = STSWITCH ;
			}
			break ;
		case 'c' :
			if ( amatch("case") ) {
				docase() ;
				st = STCASE;
			}
			else if ( amatch("continue") ) {
				docont() ;
				ns() ;
				st = STCONT ;
			}
			break ;
		case 'r' :
			if ( amatch("return") ) {
				doreturn() ;
				ns() ;
				st = STRETURN ;
			}
			break ;
		case 'b' :
			if ( amatch("break") ) {
				dobreak() ;
				ns() ;
				st = STBREAK ;
			}
			break ;
		case ';' :
			inbyte() ;
			st = lastst ;
			break ;
		case '#' :
			if ( match("#asm") ) {
				doasm() ;
				st = STASM;
			}
			break ;
		}
		if ( st == -1 ) {
			/* if nothing else, assume it's an expression */
			doexpr() ;
			ns() ;
			st = STEXP ;
		}
	}
	return (lastst = st) ;
}

/*
 *	Semicolon enforcer
 *
 * called whenever syntax requires a semicolon
 */
ns()
{
	if ( cmatch(';') == 0 )
		error("missing semicolon");
}

/*
 *	Compound statement
 *
 * allow any number of statements to fall between "{}"
 */
compound()
{
	SYMBOL *savloc ;
	int savcsp ;

	savcsp = Zsp ;
	savloc = locptr ;
	declared = 0 ;		/* may declare local variables */
	++ncmp;				/* new level open */
	while (cmatch('}')==0) statement(); /* do one */
	--ncmp;				/* close current level */
	if ( lastst != STRETURN ) {
		modstk(savcsp,NO) ;		/* delete local variable space */
	}
	Zsp = savcsp ;
	locptr = savloc ;	/* delete local symbols */
	declared = -1 ;
}

/*
 *		"if" statement
 */
doif()
{
	int flab1,flab2;

	flab1=getlabel();	/* get label for false branch */
	test(flab1,YES);	/* get expression, and branch false */
	statement();		/* if true, do a statement */
	if ( amatch("else") == 0 ) {
		/* no else, print false label and exit  */
		postlabel(flab1);
		return;
	}
	/* an "if...else" statement. */
	flab2 = getlabel() ;
	if ( lastst != STRETURN ) {
		/* if last statement of 'if' was 'return' we needn't skip 'else' code */
		jump(flab2);
	}
	postlabel(flab1);				/* print false label */
	statement();					/* and do 'else' clause */
	postlabel(flab2);				/* print true label */
}

/*
 * perform expression (including commas)
 */
doexpr()
{
	char *before, *start ;
	int type, const, val ;

	while (1) {
		setstage(&before, &start) ;
		type = expression(&const, &val) ;
		clearstage( before, start ) ;
		if ( ch() != ',' ) return type ;
		inbyte() ;
	}
}

/*
 *	"while" statement
 */
dowhile()
{
	WHILE_TAB wq ;		/* allocate local queue */

	addwhile(&wq) ;			/* add entry to queue */
							/* (for "break" statement) */
	postlabel(wq.loop) ;	/* loop label */
	test(wq.exit, YES) ;	/* see if true */
	statement() ;			/* if so, do a statement */
	jump(wq.loop) ;			/* loop to label */
	postlabel(wq.exit) ;	/* exit label */
	delwhile() ;			/* delete queue entry */
}

/*
 * "do - while" statement
 */
dodo()
{
	WHILE_TAB wq ;
	int top ;

	addwhile(&wq) ;
	postlabel(top=getlabel()) ;
	statement() ;
	needtoken("while") ;
	postlabel(wq.loop) ;
	test(wq.exit, YES) ;
	jump(top);
	postlabel(wq.exit) ;
	delwhile() ;
	ns() ;
}

/*
 * "for" statement
 */
dofor()
{
	WHILE_TAB wq ;
	int lab1, lab2 ;

	addwhile(&wq) ;
	lab1 = getlabel() ;
	lab2 = getlabel() ;
	needchar('(') ;
	if (cmatch(';') == 0 ) {
		doexpr() ;				/* expr 1 */
		ns() ;
	}
	postlabel(lab1) ;
	if ( cmatch(';') == 0 ) {
		test(wq.exit, NO ) ;	/* expr 2 */
		ns() ;
	}
	jump(lab2) ;
	postlabel(wq.loop) ;
	if ( cmatch(')') == 0 ) {
		doexpr() ;				/* expr 3 */
		needchar(')') ;
	}
	jump(lab1) ;
	postlabel(lab2) ;
	statement() ;
	jump(wq.loop) ;
	postlabel(wq.exit) ;
	delwhile() ;
}

/*
 * "switch" statement
 */
doswitch()
{
	WHILE_TAB wq ;
	int endlab, swact, swdef ;
	SW_TAB *swnex, *swptr ;

	swact = swactive ;
	swdef = swdefault ;
	swnex = swptr = swnext ;
	addwhile(&wq) ;
	(wqptr-1)->loop = 0 ;
	needchar('(') ;
	doexpr() ;			/* evaluate switch expression */
	needchar(')') ;
	swdefault = 0 ;
	swactive = 1 ;
	jump(endlab=getlabel()) ;
	statement() ;		/* cases, etc. */
	jump(wq.exit) ;
	postlabel(endlab) ;
	sw() ;				/* insert code to match cases */
	while ( swptr < swnext ) {
		defword() ;
		printlabel(swptr->label) ;		/* case label */
		outbyte(',') ;
		outdec(swptr->value) ;			/* case value */
		nl() ;
		++swptr ;
	}
	defword() ;
	outdec(0) ;
	nl() ;
	if (swdefault) jump(swdefault) ;
	postlabel(wq.exit) ;
	delwhile() ;
	swnext = swnex ;
	swdefault = swdef ;
	swactive = swact ;
}

/*
 * "case" statement
 */
docase()
{
	if (swactive == 0) error("not in switch") ;
	if (swnext > swend ) {
		error("too many cases") ;
		return ;
	}
	postlabel(swnext->label = getlabel()) ;
	constexpr(&swnext->value) ;
	needchar(':') ;
	++swnext ;
}

dodefault()
{
	if (swactive) {
		if (swdefault) error("multiple defaults") ;
	}
	else error("not in switch") ;
	needchar(':') ;
	postlabel(swdefault=getlabel()) ;
}
	

/*
 *	"return" statement
 */
doreturn()
{
	/* if not end of statement, get an expression */
	if ( endst() == 0 ) {
		if ( currfn->more ) {
			/* return pointer to value */
			force(CINT, doexpr()) ;
		}
		else {
			/* return actual value */
			force(currfn->type, doexpr()) ;
		}
		leave(YES);
	}
	else leave(NO) ;
}

/*
 * leave a function
 * preserve primary register if save is TRUE
 */
leave(save)
int save ;
{
	if ( trace )
		callrts("ccleavi");
	modstk(0,save);	/* clean up stk */
	zret();		/* and exit function */
}

/*
 *	"break" statement
 */
dobreak()
{
	WHILE_TAB *ptr ;

	/* see if any "whiles" are open */
	if ((ptr=readwhile(wqptr))==0) return;	/* no */
	modstk(ptr->sp, NO);	/* else clean up stk ptr */
	jump(ptr->exit) ;		/* jump to exit label */
}

/*
 *	"continue" statement
 */
docont()
{
	WHILE_TAB *ptr;

	/* see if any "whiles" are open */
	ptr = wqptr ;
	while (1) {
		if ((ptr=readwhile(ptr))==0) return ;
		/* try again if loop is zero (that's a switch statement) */
		if ( ptr->loop ) break ;
	}
	modstk(ptr->sp, NO) ;	/* else clean up stk ptr */
	jump(ptr->loop) ;		/* jump to loop label */
}

/*
 *	"asm" pseudo-statement
 *	enters mode where assembly language statement are
 *	passed intact through parser
 */
doasm()
{
	cmode=0;			/* mark mode as "asm" */
	while (1) {
		preprocess();	/* get and print lines */
		if ( match("#endasm") || eof )
			break ;
		if ( output != NULL_FD ) {
			if ( fputs(line, output) == -1 ) {
				fabort() ;
			}
		}
		else {
			puts(line) ;
		}
		nl();
	}
	clear() ;		/* invalidate line */
	cmode=1 ;		/* then back to parse level */
}
