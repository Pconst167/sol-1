/*	Define system dependent parameters	*/

/*	Stand-alone definitions			*/

#define NULL	0
#define NO		0
#define YES		1

#ifdef SMALL_C
#define NULL_FD 0
#define NULL_FN 0
#define NULL_CHAR 0
#else
#define NULL_FD (FILE *)0
typedef int (*FUNC)() ;
#define NULL_FN (FUNC)0
#define NULL_CHAR (char *)0
#define alloc malloc
#endif

/*	System wide name size (for symbols)	*/

#define	NAMESIZE 9
#define NAMEMAX  8

/*	Define the symbol table parameters	*/

#define NUMGLBS		512
#define MASKGLBS	511
#define	STARTGLB	symtab
#define	ENDGLB		(STARTGLB+NUMGLBS)

#define NUMLOC		55
#define	STARTLOC	loctab
#define	ENDLOC		(STARTLOC+NUMLOC)

/*	Define symbol table entry format	*/

#define SYMBOL struct symb

SYMBOL {
	char name[NAMESIZE] ;
	char ident ;		/* VARIABLE, ARRAY, POINTER, FUNCTION, MACRO */
	char type ;			/* DOUBLE, CINT, CCHAR, STRUCT */
	char storage ;		/* STATIK, STKLOC, EXTERNAL */
	union xx  {			/* offset has a number of interpretations:           */
		int i ;			/* local symbol:  offset into stack                  */
						/* struct member: offset into struct                 */
						/* global symbol: FUNCTION if symbol is declared fn  */
						/*                or offset into macro table, else 0 */
		SYMBOL *p ;		/* also used to form linked list of fn args          */
	} offset ;
	char more ;			/* index of linked entry in dummy_sym */
	char tag_idx ;		/* index of struct tag in tag table */
} ;

#ifdef SMALL_C
#define NULL_SYM 0
#else
#define NULL_SYM (SYMBOL *)0
#endif

/*	Define possible entries for "ident"	*/

#define	VARIABLE	1
#define	ARRAY		2
#define	POINTER		3
#define	FUNCTION	4
#define MACRO		5
/* the following only used in processing, not in symbol table */
#define PTR_TO_FN	6
#define PTR_TO_PTR	7

/*	Define possible entries for "type"	*/

#define DOUBLE	1
#define	CINT	2
#define	CCHAR	3
#define STRUCT	4

/* number of types to which pointers to pointers can be defined */
#define NTYPE	3

/*	Define possible entries for "storage"	*/

#define	STATIK	1
#define	STKLOC	2
#define EXTERNAL 3

/*	Define the structure tag table parameters */

#define NUMTAG		10
#define STARTTAG	tagtab
#define ENDTAG		tagtab+NUMTAG

struct tag_symbol {
	char name[NAMESIZE] ;		/* structure tag name */
	int size ;					/* size of struct in bytes */
	SYMBOL *ptr ;				/* pointer to first member */
	SYMBOL *end ;				/* pointer to beyond end of members */
} ;

#define TAG_SYMBOL struct tag_symbol

#ifdef SMALL_C
#define NULL_TAG 0
#else
#define NULL_TAG (TAG_SYMBOL *)0
#endif

/*	Define the structure member table parameters */

#define NUMMEMB		30
#define STARTMEMB	membtab
#define ENDMEMB		(membtab+NUMMEMB)

/* switch table */

#define NUMCASE	80

struct sw_tab {
	int label ;		/* label for start of case */
	int value ;		/* value associated with case */
} ;

#define SW_TAB struct sw_tab

/*	Define the "while" statement queue	*/

#define	NUMWHILE	20
#define	WQMAX		wqueue+(NUMWHILE-1)

struct while_tab {
	int sp ;		/* stack pointer */
	int loop ;		/* label for top of loop */
	int exit ;		/* label at end of loop */
} ;

#define WHILE_TAB struct while_tab

/*	Define the literal pool			*/

#define	LITABSZ 950
#define	LITMAX	LITABSZ-1

/*	Define the input line			*/

#define	LINESIZE	128
#define	LINEMAX		(LINESIZE-1)
#define	MPMAX		LINEMAX

/*  Output staging buffer size */

#define STAGESIZE	1450
#define STAGELIMIT	(STAGESIZE-1)

/*	Define the macro (define) pool		*/

#define	MACQSIZE	500
#define	MACMAX		MACQSIZE-1

/*	Define statement types (tokens)		*/

#define	STIF		1
#define	STWHILE		2
#define	STRETURN	3
#define	STBREAK		4
#define	STCONT		5
#define	STASM		6
#define	STEXP		7
#define STDO		8
#define STFOR		9
#define STSWITCH	10
#define STCASE		11
#define STDEF		12

/* define length of names for assembler */

#define ASMLEN	8

#ifdef SMALL_C
#define SYM_CAST
#define TAG_CAST
#define WQ_CAST
#define SW_CAST
#else
#define SYM_CAST (SYMBOL *)
#define TAG_CAST (TAG_SYMBOL *)
#define WQ_CAST (WHILE_TAB *)
#define SW_CAST (SW_TAB *)
#endif
