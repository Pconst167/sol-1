/*
 * zopt - five pass optimiser for small-C  (general routines)
 *        v2.0 - uses independent processes
 *
 * usage: zopt [-c] source-file
 *        source-file is assumed to have extension .asm
 *
 *        -c  generate compact code by not expanding library routines
 *
 *
 * Bug reports, bug fixes and comments should be addressed to the author:
 *
 *    R M Yorston
 *    1 Church Terrace
 *    Lower Field Road
 *    Reading
 *    RG1 6AS
 *
 */

#include <stdio.h>
#include <string.h>

#define TRUE	1
#define FALSE	0

#define NULL	0
#define CTRLC	3
#define TAB		9
#define SPACE	32

#define CONIN	6

#define LINELEN 128

extern int getopt() ;
extern int optind ;

int Ichan, Ochan ;
int Total ;
int Compact ;


/* pointers to strings to be matched */
char Pophl[] = "\tPOP HL";
char Pushhl[] = "\tPUSH HL";
char Popde[] = "\tPOP DE";
char Pushde[] = "\tPUSH DE";
char Popbc[] = "\tPOP BC";
char Pushbc[] = "\tPUSH BC";
char Ret[] = "\tRET";
char Ldde[] = "\tLD DE," ;
char Ldhl[] = "\tLD HL,";
char Ldhl0[] = "\tLD HL,0";
char Ldhl2[] = "\tLD HL,2";
char Ldhl4[] = "\tLD HL,4";
char Ldhl6[] = "\tLD HL,6";
char Inchl[] = "\tINC HL";
char Dechl[] = "\tDEC HL";
char Popix[] = "\tPOP IX";
char Pushix[] = "\tPUSH IX";
char Exdehl[] = "\tEX DE,HL";
char Addhlde[] = "\tADD HL,DE";
char Addhlhl[] = "\tADD HL,HL";


usage()
{
	puts( "usage: zopt [-c] file\n" ) ;
	exit() ;
}

main( argc, argv )
int argc ;
char **argv ;
{
	char file1[20], file2[20] ;
	int i, c ;

	if ( argc == 1 || argc > 3 ) {
		usage() ;
	}
	Compact = FALSE ;
	while ( (c=getopt(argc, argv, "C")) != EOF ) {
		switch ( c ) {
		case 'C' :
			Compact = TRUE ;
			break ;
		default :
			usage() ;
		}
	}
	if ( argc-optind != 1 ) {
		usage() ;
	}
	strcpy( file1, argv[optind] ) ;
	strcat( file1, ".asm" ) ;
	strcpy( file2, argv[optind] ) ;
	strcat( file2, ".$$$") ;

	if ( (Ichan=fopen(file1, "r")) == 0 ) {
		err("cannot open input file");
		exit() ;
	}

	if ( (Ochan=fopen(file2, "w")) == 0 ) {
		err("cannot open output file");
		exit() ;
	}

	Total = 0 ;

	/* start processing */
	init() ;
	
	fclose(Ichan) ;
	fclose(Ochan) ;

	puts("Grand total bytes saved: ") ; putdec(Total) ;
	putchar('\n') ; putchar('\n') ;

	unlink(file1) ;
	rename(file2, file1) ;

}

extern _newfcb() ;

/*
 * rename - rename a named file
 *
 *          return NULL on success, -1 on failure
 */
rename(oldname, newname)
char *oldname, *newname ;
{
	char fcb[56] ;

	if ( _newfcb(oldname, fcb) == 0 )
		return -1 ;
	if ( _newfcb(newname, &fcb[16]) == 0 )
		return -1 ;
	if ( cpm(23, fcb) != 0 )
		return -1 ;
	return 0 ;
}

/*
 * getline - fetch line from input channel
 *           puts line at pointer, returns FALSE on end of file
 *           returns TRUE for successful get
 *           'global' lines are passed through at once
 */
getline(pointer)
char *pointer ;
{
	int ch ;
	char *ptr ;

	ptr = pointer ;
	while ( (ch=getc(Ichan)) != EOF ) {
		if( ch == '\n' ) {
			*pointer = NULL ;
			if ( match("\tglobal", ptr) ) {
				/* line is 'global' statement, pass it through at once */
				putline(ptr) ;
				return getline(ptr) ;
			}
			return TRUE ;
		}
		else
			*pointer++ = ch ;
	}
	*pointer = NULL ;
	return FALSE ;
}

/*
 * putline - send line to output file
 */
putline(pointer)
char *pointer ;
{
	if ( fputs(pointer, Ochan) == EOF ) {
		err( "write error in putline, disk full?" ) ;
		exit() ;
	}
	putc('\n', Ochan) ;
}

/*
 * Output a signed decimal number
 */
putdec(n)
int n;
{
	if ( n < 0 ) {
		n = -n ;
		putchar('-') ;
	}
	if ( (n/10) != 0 )
		putdec(n/10) ;
	putchar(n%10+'0') ;
}

/*
 * allnum - checks if string consists entirely of decimal numbers
 *          returns TRUE if it does
 */
allnum(string)
char *string ;
{
	while ( *string ) {
		if ( (*string<'0') || (*string>'9') ) {
			return FALSE ;
		}
		++string ;
	}
	return TRUE ;
}

/* print total bytes saved */

pr_total(i)
int i;
{
	puts("Total bytes saved: ") ; putdec(i) ;
	putchar('\n') ; putchar('\n') ;
}

/*
 * islower - returns TRUE if character is lower case, else FALSE
 */
islower(ch)
char ch ;
{
	return (ch >= 'a') & (ch <= 'z') ;
}

#ifndef Z80

/*
 * match - match token against string
 *         returns NULL if no match
 *         else returns pointer to tail of string
 */
match(token, input)
char *token, *input ;
{
	while ( *input++ == *token++ ) ;
	--token ;
	if ( *token == NULL )
		return --input ;
	else
		return NULL ;
}

#else

#asm
qmatch:
	POP BC
	POP HL		;HL is input
	POP DE		;DE is token
	PUSH DE
	PUSH HL
	PUSH BC
match1:
	LD A,(DE)	;fetch *token
	CP (HL)
	JR NZ,match2	;return if *token != *input
	INC HL
	INC DE
	JR match1
match2:
	OR A
	RET Z		;return input if *token == NULL
	LD HL,0		;else return 0
	RET
#endasm

#endif

/***************************************************************************************/
/*                                                                                     */
/* context switching routines                                                          */
/*                                                                                     */
/***************************************************************************************/

/* there are six contexts: original, passes 1, 2, 3, 4, 5 */
#define NUMCONTEXT 6

/* stack size for processes */
#define STACKSIZE 1024

int switch_up(), switch_down() ;

int *sp[NUMCONTEXT+1] ;		/* last SP value for each context, zero for last */
int current ;				/* current context */

/*
 * switch_up - move up a context level
 *             the argument str is the return value passed to the parent
 *             str may not be zero
 */
switch_up(str)
char *str ;
{
#asm
	ld hl,(qcurrent)		; sp[current--] = SP
	dec hl
	ld (qcurrent),hl
	inc hl
	add hl,hl
	ex de,hl
	ld ix,qsp
	add ix,de				; (IX = &sp[current])
	ld hl,0
	add hl,sp
	ld (ix),l
	ld (ix+1),h
	inc hl					; (DE = str) need to get this before switch
	inc hl
	ld e,(hl)
	inc hl
	ld d,(hl)
	ld h,(ix-1)				; SP = sp[current]
	ld l,(ix-2)
	ld sp,hl
	ex de,hl				; return str
	ret
#endasm
}


/*
 * switch_down - move down a context level
 *               the argument str is the return value passed to the child
 *               str may not be zero
 */
switch_down(str)
char *str ;
{
	if ( sp[current+1] == 0 )
		return 0 ;
#asm
	ld hl,(qcurrent)		; sp[current++] = SP
	inc hl
	ld (qcurrent),hl
	dec hl
	add hl,hl
	ex de,hl
	ld ix,qsp
	add ix,de				; (IX = &sp[current])
	ld hl,0
	add hl,sp
	ld (ix),l
	ld (ix+1),h
	inc hl					; (DE = str) need to get this before switch
	inc hl
	ld e,(hl)
	inc hl
	ld d,(hl)
	ld l,(ix+2)				; SP = sp[current]
	ld h,(ix+3)
	ld sp,hl
	ex de,hl				; return str
	ret
#endasm
}

/*
 * die - routine to force proper termination of a process when it
 *       falls out of its closing brace
 *       makes repeated calls to its child with an argument of 0
 *       until child returns 0 too, to indicate its death
 *       then set remembered SP for this level to zero and switches up
 *       with a zero return value
 */
die()
{
	while ( switch_down(0) )
		;
	sp[current] = 0 ;
	switch_up(0) ;
}

/*
 * read data from parent process to string t
 * returns 0 on end of file, puts null string in t
 */
char *p_read() ;
p_read(t)
char *t ;
{
	char *s ;

	if ( (s=switch_up(1)) == 0 ) {
		*t = '\000' ;
		return 0 ;
	}
	strcpy(t, s) ;
}

/*
 * write data to child process
 */
c_write(s)
char *s ;
{
	switch_down(s) ;
}

init()
{
	/* sp[0] will be set up by first context switch */

	/* make space for process 1's stack */
	sp[1] = alloc(STACKSIZE) + (STACKSIZE-2*sizeof(int)) ;
	/* initialise stack for process 1 */
	sp[1][0] = pass1 ;
	sp[1][1] = die ;

	/* make space for process 2's stack */
	sp[2] = alloc(STACKSIZE) + (STACKSIZE-2*sizeof(int)) ;
	/* initialise stack for process 2 */
	sp[2][0] = pass2 ;
	sp[2][1] = die ;

	/* make space for process 3's stack */
	sp[3] = alloc(STACKSIZE) + (STACKSIZE-2*sizeof(int)) ;
	/* initialise stack for process 3 */
	sp[3][0] = pass3 ;
	sp[3][1] = die ;

	/* make space for process 4's stack */
	sp[4] = alloc(STACKSIZE) + (STACKSIZE-2*sizeof(int)) ;
	/* initialise stack for process 4 */
	sp[4][0] = pass4 ;
	sp[4][1] = die ;

	/* make space for process 5's stack */
	sp[5] = alloc(STACKSIZE) + (STACKSIZE-2*sizeof(int)) ;
	/* initialise stack for process 5 */
	sp[5][0] = pass5 ;
	sp[5][1] = die ;

	/* mark end of processes */
	sp[6] = 0 ;

	/* get the show on the road */
	switch_down(1) ;
}
