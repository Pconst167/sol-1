/*	name...
 *		iolib
 *
 *	purpose...
 *		to provide a "standard" interface between c
 *		programs and the CPM I/O system.
 *
 *	notes...
 *		Compile using -M option.
 *
 */

#include <stdio.h>

/* #define INT_OFF		/* turn off interrupts, except during BDOS calls */
						/* programs will run faster, but interrupts will be missed */
						/* to keep interrupts on, comment out this define */
						/* only do this if you understand the consequences */

#asm
BDOS	=	5
CR	=	13
;	cpm(bc,de) int bc,de;   BDOS call */
QCPM:	POP	HL
	POP	DE
	POP	BC
	PUSH	BC
	PUSH	DE
	PUSH	HL
#ifdef INT_OFF
	EI
	CALL BDOS
	DI
#else
	CALL	BDOS
#endif
	JP	CCSXT	;move A to HL & sign extend
;
;	/* return address of a block of memory */
;	alloc(b)
;	int b;		/* # bytes desired */
;
QALLOC:	POP	HL	;return addr
	POP	DE	;block size
	PUSH	DE
	PUSH	HL
	LD	HL,(HEAPTOP) ;current top of heap
	EX	DE,HL
	ADD	HL,DE	;hl=new top of heap
	LD	(HEAPTOP),HL
	EX	DE,HL	;hl=old top of heap
	RET
HEAPTOP: DEFW	_END
;
;	/* reset the top of heap pointer to addr* */
;
;	free(addr)
;	int addr;
;
QFREE:	POP	DE
	POP	HL	;addr
	PUSH	HL
	PUSH	DE
	LD	(HEAPTOP),HL
	RET
;
;	/* return number of bytes between top of heap
;	and end of TPA.  Remember that this includes
;	the stack! */
;
;	avail()
;
QAVAIL:	LD	DE,(6)	;end of TPA
	LD	HL,(HEAPTOP)	;top of heap
	JP	CCSUB	;find (6)-HEAPTOP
;
;	error...print message & walkback trace (if available)
;
;			err(s) char *s;
;			{	int str;
;				puts("\nERROR ");
QERR:	LD	HL,(QSTDOUT)
	LD	(ERR6),HL
	LD	HL,1
	LD	(QSTDOUT),HL
	LD	HL,MSGE
	PUSH	HL
	CALL	QPUTS
	POP	HL
;				puts(s);
	POP	DE
	POP	HL
	PUSH	HL
	PUSH	DE
	PUSH	HL
	CALL	QPUTS
	POP	HL
;				str=current;
	LD	HL,(CURRENT)
;				while(str)
ERR4:	LD	(ERR2),HL
	LD	A,H
	OR	L
	JR	Z,ERR5
;					{puts("\ncalled by ");
	LD	HL,MSGE2
	PUSH	HL
	CALL	QPUTS
	POP	HL
;					puts(*(str+1));
	LD	HL,(ERR2)
	INC	HL
	INC	HL
	CALL	CCGINT
	PUSH	HL
	CALL	QPUTS
	POP	HL
;					str=*str;
	LD	HL,(ERR2)
	CALL	CCGINT
;					}
	JR	ERR4
;			}
ERR5:	LD	HL,(ERR6)
	LD	(QSTDOUT),HL
	RET
;
MSGE:	DB	CR,'ERR: ',0
MSGE2:	DB	CR,'CALLER: ',0
ERR2:	DW	0
ERR6:	DW	0	;temporary storage for STDOUT
CURRENT: DW	0
#endasm
#define LF 10

int _dfltdsk;	/* "current disk" at beginning of execution */
#asm
QSTDIN:	DW	0			; 0 initially, or unit number for input file
						; if input has been redirected by args()
QSTDOUT: DW	1			; 1 initially, or unit number for output file
						; if output has been redirected by args()
#endasm

getchar()
{
	return getc(stdin);
}

putchar(c)
char c;
{
	return(putc(c,stdout));
}

/* print a null-terminated string */

puts(buf)
char *buf;
{
	char c;

	while (c=*buf++) putchar(c);
}

#define NBUFS 5
	/*	= number of files which can be open at once */
	/*  though buffers are only allocated as files are opened */
#define LGH 1024
	/*	length of each file buffer		*/
	/*	= some multiple of 128: 128, 256, 384, 512... */
#define BUFLGH (LGH+36)
	/*	includes fcb associated with buffer */

#define MFREE 11387
#define MREAD 22489
#define MWRITE 17325

#asm
NBUFS	= 5
MFREE	= 11387
MREAD	= 22489
MWRITE	= 17325
#endasm

int	_ffcb[NBUFS],	/* pointers to the fcb's
					   if zero, no memory has been allocated */
	_fnext[NBUFS],	/* pointers to the next char to be fed
					   to the program (for an input file) or
					   the next free byte in the buffer (for
					   an output file)			*/
	_ffirst[NBUFS],	/* ptrs to the starts of the buffers */
	_flast[NBUFS];	/* ptrs to the ends of the buffers */

int _fmode[NBUFS] = { MFREE, MFREE, MFREE, MFREE, MFREE };
					/* MFREE => buffer is free
					   MREAD => open for reading
			   		   MWRITE => open for writing */

int _ex,_cr;		/* extent & current record at beginning
						of this buffer full (used for "A" access) */

/*
 * _newfcb - create CP/M file control block for named file
 *
 *           returns 0 on failure, 1 on success
 */
_newfcb(name, fcb)
char *name ;
char *fcb ;
{
	char *c ;
	int i ;

	/* clear file name */
	i=11;
	while(i) fcb[i--] = ' ';
	/* clear rest of fcb */
	i = 12 ;
	while ( i < 36 ) {
		fcb[i++] = 0 ;
	}
	if ( name[1] == ':' ) {		/* transfer disk */
		fcb[0] = *name & 0xf ;
		name += 2;
	}
	else
		fcb[0] = _dfltdsk;

	if ( *name == 0 ) return 0 ;	/* error if no filename */

	/* transfer name */
	i = 0 ;
	while (c=_upper(*name++)) {
		if(c == '.') break;
		fcb[++i] = c;
	}
	if(c=='.') {		/* transfer extension */
		i=9;
		while ( (c=_upper(*name++)) && i < 12) {
			fcb[i++] = c;
		}
	}
	if ( c == 0 ) return 1 ;		/* OK if last char is NULL */
	return 0 ;
}

/* open file in fmode "r", "w", or "a" (upper or lower case)	*/

fopen(name,mode)
char *name,*mode;
{
	char c,*fcb;
	int index,i,unit;

	index = NBUFS;
	while(index--) {		/* search for free buffer */
		if(_fmode[index]==MFREE)break;
	}
	if(index==-1) {
		err("NO BUFFERS");
		exit();
	}
	unit = index+5;

	/* allocate memory if required */
	if ( _ffcb[index] == 0 )
		_ffcb[index] = alloc(BUFLGH) ;
	
	_ffirst[index] = _ffcb[index]+36;
	_flast[index] = _ffirst[index]+LGH;

	fcb = _ffcb[index];

	/* initialise file control block */
	if ( _newfcb(name, fcb) == 0 ) {
		/* invalid file name */
		return 0 ;
	}
	if ( (c=_upper(*mode)) == 'R' || c == 'A' ) {
		if (cpm(15,fcb) < 0) {
			return 0; /* file not found */
		}
		/* open for reading -  forces immed. read */
		_fmode[index] = MREAD;
		_fnext[index] = _flast[index];
				
		if (c == 'A') {	/* append mode requested? */
			while(getc(unit)!=-1)
				;  /* read to EOF */
			fcb[12] = _ex; /* reset to values at...*/
			cpm(15,fcb);   /* ...beginning of buffer */
			fcb[32] = _cr;
			_fmode[index] = MWRITE;
		}
		return unit;
	}
	else if (c == 'W') {
		cpm(19,fcb);							/* delete file */
		if ( cpm(22,fcb) < 0 )					/* create file */
			return 0;							/* creation failure */
		_fmode[index] = MWRITE;					/* open for writing */
		_fnext[index] = _ffirst[index];			/* buffer is empty */
		return unit;
	}
	return 0;
}

/* close a file */

fclose(unit)
int unit;
{
	int index, werror;
	char *end, *ptr ;

	index = unit-5;
	if ( _fchk(index) == MREAD ) {
		/* don't close read files */
		_fmode[index]=MFREE;
		return 1;	/* success */
	}

	putb(26,unit);	/* append ^Z (CP/M EOF) */
	/* pad buffer out with ^Z */
	ptr = _fnext[index] ;
	end = _flast[index] ;
	while ( ptr < end )
		*ptr++ = 26 ;

	werror = fflush(unit);
	_fmode[index] = MFREE;
	if ( (cpm(16,_ffcb[index]) < 0) || werror )
		return 0; /* failure */
	/* if free() worked properly we could do the following
	free(_ffcb[index]) ;
	_ffcb[index] = 0 ; */
	return 1;	/* success */
}

/* check for legal index */

/*
_fchk(index)
int index;
{
	int i;

	if ( (index >= 0) & ( index < NBUFS ) ) {
		i = _fmode[index] ;
		if ( (i==MREAD)|(i==MWRITE) )
			return i;
	}
	err("INVALID UNIT NUMBER");
	exit();
}
*/

#asm
q_fchk:
	POP BC				; if ( index >= 0 )
	POP HL
	PUSH HL
	PUSH BC
	LD A,H
	AND 080H
	JR NZ,xfchk1
	PUSH HL				; (save index on stack)
	LD DE,NBUFS			;    if ( index < NBUFS )
	OR A
	SBC HL,DE
	POP HL
	JP P,xfchk1
	ADD HL,HL
	LD DE,q_fmode		;       DE = i = _fmode[index]
	ADD HL,DE
	LD E,(HL)
	INC HL
	LD D,(HL)
	PUSH DE				;       if ( i == MREAD )
	LD HL,MREAD
	OR A
	SBC HL,DE
	POP HL
	RET Z				;          return i
	PUSH HL				;       if ( i == MWRITE )
	LD DE,MWRITE
	OR A
	SBC HL,DE
	POP HL
	RET Z				;          return i
xfchk1:
	LD HL,xfchkms		; err(invalid unit number)
	PUSH HL
	CALL qerr
	CALL qexit			; exit()
xfchkms:
	DB "INVALID UNIT"
	DB 0
#endasm

/* get character from file (return -1 at EOF)  */

/*
getc(unit)
int unit;
{
	int c;

	while ((c=getb(unit)) == LF) {}	 discard LF 
	if(c==26) {
		 CP/M EOF? 
		if(unit>=5) {
			 leave _fnext[index] pointing at the ^Z 
			--_fnext[unit-5];
		}
		return -1;
	}
	return c;
}
*/

#asm
qgetc:
	POP BC				; while ( (HL=c=getb(unit)) == LF ) {}
	POP HL
	PUSH HL
	PUSH BC
	PUSH HL
	CALL qgetb
	POP BC
	PUSH HL
	LD DE,10
	OR A
	SBC HL,DE
	POP HL
	JR Z,qgetc
	PUSH HL				; if ( c ~= 26 )
	LD DE,26
	OR A
	SBC HL,DE
	POP HL
	RET NZ				;    return c
	POP BC				; else
	POP HL				;    HL = index = unit - 5
	PUSH HL
	PUSH BC
	LD DE,-5
	ADD HL,DE
	BIT 7,H				;    if ( index >= 0 )
	JR NZ,xgetc1
	ADD HL,HL			;       --_fnext[index]
	LD DE,q_fnext
	ADD HL,DE
	LD E,(HL)
	INC HL
	LD D,(HL)
	DEC DE
	LD (HL),D
	DEC HL
	LD (HL),E
xgetc1:
	LD HL,-1			;    return -1
	RET
#endasm

/*
 * _getbuf - fetch new buffer from disk
 *           this routine introduced rmy 31/8/86
 */

_getbuf(index)
int index ;
{
	char *fcb, *last, *next; 

	fcb=_ffcb[index];
	_ex=fcb[12];
	_cr=fcb[32]; /* save for fopen() */
	next=_ffirst[index];
	last=next+LGH;
	while(next<last) {
		cpm(26,next);	/* set DMA */
		if(cpm(20,fcb))break;
		next += 128;
	}
	cpm(26,128);		/* reset DMA */
	if(next==_ffirst[index]) {	/* no records read? */
		return -1;
	}
	_flast[index]=next;
	return(_ffirst[index]);
}

/*
 * getb - get byte from file (return -1 at EOF)
 */

/*
getb(unit)
int unit;
{
	int c;
	int index ;
	char *next ;

	if(unit==0) {					 STDIN 
		c=cpm(1,0);
		if (c=='\n') cpm(2,LF);		 add LF after CR 
		return c ;
	}
	index = unit-5;
	if (_fchk(index) != MREAD) {
		err("CAN\'T READ OUTFILE");
		exit();
	}
	next = _fnext[index];
	if(next == _flast[index]) {		 empty buffer? 
		next = _getbuf(index);
		if ( next == -1 ) {
			return -1 ;
		}
	}
	c = (*next++) & 0xff ;
	_fnext[index] = next;
	return c;
}
*/

#asm
qgetb:
	POP BC			; if ( unit == 0 )
	POP HL
	PUSH HL
	PUSH BC
	LD A,H
	OR L
	JR NZ,xgetb1
	LD C,1			;    A = c = cpm(1,0)
#ifdef INT_OFF
	EI
	CALL BDOS
	DI
#else
	CALL BDOS
#endif
	CP 13			;    if ( c ~= CR )
	JP NZ,ccsxt		;       return c
	LD C,2			;    else
	LD E,10			;       cpm(2,LF)
#ifdef INT_OFF
	EI
	CALL BDOS
	DI
#else
	CALL BDOS
#endif
	LD A,13			;       return c
	JP ccsxt
xgetb1:
	LD DE,-5		; HL = index = unit - 5
	ADD HL,DE
	PUSH HL			; (save index in IX)
	POP IX
	PUSH HL			; if (_fchk(index) != MREAD)
	CALL q_fchk
	POP BC
	LD DE,MREAD
	OR A
	SBC HL,DE
	JR Z,xgetb3
	LD HL,xgetbms	;    err(cant write to infile)
	PUSH HL
	CALL qerr
	CALL qexit		;    exit()
xgetbms:
	DB "CAN'T READ OUTFILE"
	DB 0
xgetb3:
	PUSH IX			; HL = next = _fnext[index]
	POP HL
	ADD HL,HL
	LD DE,q_fnext
	ADD HL,DE
	PUSH HL			; (save &_fnext[index] on stack)
	LD A,(HL)		; (CALL ccgint)
	INC HL
	LD H,(HL)
	LD L,A
	PUSH HL			; (save next on stack)
	PUSH HL			; if ( next == _flast[index] )
	PUSH IX
	POP HL
	ADD HL,HL
	LD DE,q_flast
	ADD HL,DE
	LD A,(HL)		; (CALL ccgint)
	INC HL
	LD H,(HL)
	LD L,A
	POP DE
	OR A
	SBC HL,DE
	POP HL			; (get next from stack)
	JR NZ,xgetb4
	PUSH IX			;    next = _getbuf(index)
	CALL q_getbuf
	POP BC
	LD A,H			;    if ( next == -1 )
	AND L
	CP 0FFH
	JR NZ,xgetb4
	POP BC			;       return -1
	RET
xgetb4:
	LD A,(HL)		; A = c = *next
	LD C,A			; (save c in C)
	INC HL			; ++next
	POP DE			; (get &_flast[index] from stack)
	LD A,L			; _fnext[index] = next
	LD (DE),A
	INC DE
	LD A,H
	LD (DE),A
	LD L,C			; return c
	LD H,0			; note, return is int, not sign extended char
	RET
#endasm

/*
 * write a character to a file - add LF after CR
 * return last character sent or -1 on write error
 */

/*
putc(c,unit)
char c;
int unit;
{
	int ret ;

	ret = putb(c,unit);
	if ( ret == '\n' ) ret = putb(LF, unit);
	return ret ;
}
*/

#asm
qputc:
	POP HL			; putb(c,unit)
	POP BC
	POP DE
	PUSH DE
	PUSH BC
	PUSH HL
	PUSH DE
	PUSH BC
	CALL qputb
	POP BC
	POP DE
	LD A,H			; if ( ret ~= CR )
	CP 0
	RET NZ			;  return ret
	LD A,L
	CP 13
	RET NZ			;  return ret
	LD DE,10		; else ret = qputb(LF,unit)
	PUSH DE
	PUSH BC			; (NB assumes qputb doesn't change unit)
	CALL qputb
	POP BC
	POP BC
	RET				; return ret
#endasm

/* write a byte to a file */

/*
putb(c,unit)
char c;
int unit;
{
	int werror, index ;
	char *next ;

	if(unit==1) {
		cpm(2,c);
		return c;
	}
	index=unit-5;
	if(_fchk(index)!=MWRITE) {
		err("CAN\'T WRITE TO INFILE");
		exit();
	}
	if(_fnext[index]==_flast[index]) {
		werror=fflush(unit);
	}
	else {
		werror=0;
	}
	next=_fnext[index];
	*next++=c;
	_fnext[index]=next;
	if(werror)
		return werror;
	return c;
}
*/

#asm
qputb:
	POP BC			; if ( unit == 1 )
	POP HL
	POP DE
	PUSH DE
	PUSH HL
	PUSH BC
	DEC HL
	LD A,H
	OR L
	JR NZ,xputb1
	PUSH DE
	LD C,2			;    cpm(2,c)
#ifdef INT_OFF
	EI
	CALL BDOS
	DI
#else
	CALL BDOS
#endif
	POP HL			;    return c
	RET
xputb1:
	PUSH DE			; (save c on stack)
	DEC HL			; HL = index = unit-5
	DEC HL
	DEC HL
	DEC HL
	PUSH HL			; (save index in IX)
	POP IX
	PUSH HL			; if ( _fchk(index) ~= MWRITE )
	CALL q_fchk
	POP BC
	LD DE,MWRITE
	OR A
	SBC HL,DE
	JR Z,xputb2
	LD HL,xputbms	;    err(cant read infile)
	PUSH HL
	CALL qerr
	CALL qexit		;    exit()
xputbms:
	DB "CAN'T WRITE INFILE"
	DB 0
xputb2:
	LD HL,0			; IY = werror = 0
	PUSH HL
	POP IY
	PUSH IX			; if ( _fnext[index] == _flast[index] )
	POP HL
	ADD HL,HL
	EX DE,HL
	LD HL,q_fnext
	ADD HL,DE
	PUSH HL
	LD HL,q_flast
	ADD HL,DE
	LD E,(HL)
	INC HL
	LD D,(HL)
	POP HL
	PUSH HL			; (save &_fnext[index] on stack)
	LD A,(HL)
	INC HL
	LD H,(HL)
	LD L,A
	PUSH HL			; (save _fnext[index] on stack)
	OR A
	SBC HL,DE
	JR NZ,xputb3
	PUSH IX			;    werror = fflush(unit)
	POP HL
	LD DE,5
	ADD HL,DE
	PUSH HL
	CALL qfflush
	EX (SP),HL		;    (save werror in IY)
	POP IY
	POP HL			;    (fflush changes _fnext[index])
	POP HL			;    (throw away old one)
	PUSH HL			;    (save &_fnext[index])
	LD E,(HL)		;    (fetch new _fnext[index])
	INC HL
	LD D,(HL)
	PUSH DE
xputb3:
	POP HL			; HL = next = _fnext[index]
	POP BC			; (fetch &_fnext[index to BC)
	POP DE			; (fetch c to DE)
	LD (HL),E		; *next = c
	INC HL			; ++next
	LD A,L			; _fnext[index] = next
	LD (BC),A
	INC BC
	LD A,H
	LD (BC),A
	EX DE,HL		; (fetch werror to DE, c in HL)
	PUSH IY
	POP DE
	LD A,E			; if ( werror == 0 )
	OR D
	RET Z			;    return c
	EX DE,HL		; else
	RET				;    return werror
#endasm

/* flush buffer to disk (on error returns nonzero) */

fflush(unit)
int unit;
{
	int index,i;
	char *next,*going;

	index = unit-5;
	if ( _fchk(index) != MWRITE ) {
		err("CAN\'T FLUSH");
		exit();
	}

	next = _fnext[index];
	going = _fnext[index] = _ffirst[index];
	while ( going < next ) {
		cpm(26,going); /* set DMA */
		if ( cpm(21,_ffcb[index]) ) return -1; /* error? */
		going += 128;
	}
	cpm(26,128); /* reset DMA */
	return 0;	/* no error */
}

_upper(c) int c;		/* converts to upper case */
{
	if (c >= 'a' ) return c-32;
	return c;
}

exit()
{
	int index ;

	/* ensure that all files open for write have their buffers flushed */
	index = NBUFS ;
	while ( index-- ) {
		if ( _fmode[index] == MWRITE )
			fclose(index+5) ;
	}
#asm
#ifdef INT_OFF
	EI		; turn interrupts back on again
#endif
	JP	0
#endasm
}

#define NULL 0
#define SPACE 32

int _argc;		/* # arguments on command line */
char **_argv;	/* pointers to arguments in alloc'ed area */

/* fetch arguments */

_setargs()
{
	char *inname,*outname ;	/* file names from command line */
	char *count ;			/* *count is # characters in command line */
	char *lastc ;			/* points to last character in command line */
	char *mode ;			/* mode for output file */
	char *next ;			/* where the next byte goes into alloc'ed area */
	char *ptr ;				/* *ptr is next character in command line */

	count = 128 ;			/* CP/M command buffer */
	ptr = 128 ;
	lastc = 129 + *count ;
	*lastc = SPACE ;					/* place a sentinel */
	_argv = alloc(30) ;					/* space for 15 arg pointers */
	_argv[0] = next = alloc(*count+2) ;	/* allocate the buffer */
	*next++ = NULL ;					/* place 0-th argument */
	_argc = 1 ;
	inname = outname = NULL ;
	while ( ++ptr < lastc ) {
		if ( *ptr == SPACE )
			continue ;
		if ( *ptr  == '<' ) {		/* redirect input */
			while ( *++ptr == SPACE )
				;
			inname = next ;
		}
		else if ( *ptr  ==  '>' ) {	/* redirect output */
			if ( ptr[1] == '>' ) {
				++ptr ;
				mode = "a" ;
			}
			else {
				mode = "w" ;
			}
			while ( *++ptr == SPACE )
				;
			outname = next ;
		}
		else {			/* argument */
			_argv[_argc++] = next ;
		}
		while ( *ptr != SPACE ) {
			*next++ = *ptr++ ;
		}
		*next++ = NULL ;
	}
	_argv[_argc] = 0 ;
	_redirect( inname, "r", &stdin ) ;
	_redirect( outname, mode, &stdout ) ;
}

/*
 * _redirect - open file for redirected i/o
 *             (if filename pointer is non-NULL)
 */
_redirect( filename, mode, std )
char *filename ;
char *mode ;
int *std ;
{
	if ( filename ) {
		if ( (*std=fopen(filename,mode))  == 0 ) {
			err( "CAN'T REDIRECT" ) ;
			exit() ;
		}
	}
}

#asm
;
; Runtime library initialization.
; Set up default drive for CP/M.
CCGO:	LD	C,25     ;get current disk
#ifdef INT_OFF
	EI
	CALL	BDOS
	DI
#else
	CALL	BDOS
#endif
	INC	A	;now in range 1...16
	LD	(Q_DFLTDSK),A
	CALL q_setargs		;get arguments for main
	POP DE				;save return address
	LD HL,(q_argc)
	PUSH HL
	LD HL,(q_argv)
	PUSH HL
	EX DE,HL			;return via HL
;
; call via HL
CCDCAL:
	JP (HL)
;
;Fetch a single byte from the address in HL and
; sign extend into HL
CCGCHAR: LD	A,(HL)
Q_ARGCNT:
CCSXT:	LD	L,A
	RLCA	
	SBC	A,A
	LD	H,A
	RET	
;Fetch integer from (HL+2)
CCCDR:	INC	HL
	INC	HL
;Fetch a full 16-bit integer from the address in HL
CCCAR:
CCGINT:	LD	A,(HL)
	INC	HL
	LD	H,(HL)
	LD	L,A
	RET	
;Store a 16-bit integer in HL at the address in TOS
CCPINT:	POP	BC
	POP	DE
	PUSH	BC
	LD	A,L
	LD	(DE),A
	INC	DE
	LD	A,H
	LD	(DE),A
	RET	
;Inclusive "or" HL and DE into HL
CCOR:
	LD	A,L
	OR	E
	LD	L,A
	LD	A,H
	OR	D
	LD	H,A
	RET	
;Exclusive "or" HL and DE into HL
CCXOR:
	LD	A,L
	XOR	E
	LD	L,A
	LD	A,H
	XOR	D
	LD	H,A
	RET	
;"And" HL and DE into HL
CCAND:
	LD	A,L
	AND	E
	LD	L,A
	LD	A,H
	AND	D
	LD	H,A
	RET	
;Test if HL = DE and set HL = 1 if true else 0
CCEQ:
	CALL	CCCMP
	RET	Z
	DEC	HL
	RET	
;Test if DE ~= HL
CCNE:
	CALL	CCCMP
	RET	NZ
	DEC	HL
	RET	
;Test if DE > HL (signed)
CCGT:
	EX	DE,HL
	CALL	CCCMP
	RET	C
	DEC	HL
	RET	
;Test if DE <= HL (signed)
CCLE:
	CALL	CCCMP
	RET	Z
	RET	C
	DEC	HL
	RET	
;Test if DE >= HL (signed)
CCGE:
	CALL	CCCMP
	RET	NC
	DEC	HL
	RET	
;Test if DE < HL (signed)
CCLT:
	CALL	CCCMP
	RET	C
	DEC	HL
	RET	
;Common routine to perform a signed compare
; of DE and HL
;This routine performs DE - HL and sets the conditions:
;	Carry reflects sign of difference (set means DE < HL)
;	Zero/non-zero set according to equality.
CCCMP:	LD	A,E
	SUB	L
	LD	E,A
	LD	A,D
	SBC	A,H
	LD	HL,1	     ;preset true condition
	JP	M,CCCMP1
	OR	E	     ;"OR" resets carry
	RET	
CCCMP1:	OR	E
	SCF		     ;set carry to signal minus
	RET	
;
;Test if DE >= HL (unsigned)
CCUGE:
	CALL	CCUCMP
	RET	NC
	DEC	HL
	RET	
;
;Test if DE < HL (unsigned)
CCULT:
	CALL	CCUCMP
	RET	C
	DEC	HL
	RET	
;
;Test if DE > HL (unsigned)
CCUGT:
	EX	DE,HL
	CALL	CCUCMP
	RET	C
	DEC	HL
	RET	
;
;Test if DE <= HL (unsigned)
CCULE:
	CALL	CCUCMP
	RET	Z
	RET	C
	DEC	HL
	RET	
;
;Common routine to perform unsigned compare
;carry set if DE < HL
;zero/nonzero set accordingly
CCUCMP:	LD	A,D
	CP	H
	JR	NZ,CUCMP1
	LD	A,E
	CP	L
CUCMP1:	LD	HL,1
	RET	
;
;Shift DE arithmetically right by HL and return in HL
CCASR:	EX	DE,HL
	DEC	E
	RET	M	     ;			7/2/82  jrvz
	LD	A,H
	RLA	
	LD	A,H
	RRA	
	LD	H,A
	LD	A,L
	RRA	
	LD	L,A
	JR	CCASR+1
;Shift DE arithmetically left by HL and return in HL
CCASL:	EX	DE,HL
CCASL4:	DEC	E
	RET	M	     ;		jrvz 7/2/82
	ADD	HL,HL
	JR	CCASL4
;Subtract HL from DE and return in HL
CCSUB:
	EX DE,HL
	OR A
	SBC HL,DE
	RET	
;return absolute value of argument on stack (under return address)
QABS:
	POP BC
	POP HL
	PUSH HL
	PUSH BC
	LD A,H
	AND A
	RET P
;Form the two's complement of HL
CCNEG:	CALL	CCCOM
	INC	HL
	RET	
;Form the one's complement of HL
CCCOM:	LD	A,H
	CPL	
	LD	H,A
	LD	A,L
	CPL	
	LD	L,A
	RET	
;Multiply DE by HL and return in HL
CCMULT:
	LD	B,H
	LD	C,L
	LD	HL,0
CCMLT1:	LD	A,C
	RRCA	
	JR	NC,CMLT2
	ADD	HL,DE
CMLT2:	XOR	A
	LD	A,B
	RRA	
	LD	B,A
	LD	A,C
	RRA	
	LD	C,A
	OR	B
	RET	Z
	XOR	A
	LD	A,E
	RLA	
	LD	E,A
	LD	A,D
	RLA	
	LD	D,A
	OR	E
	RET	Z
	JR	CCMLT1
;Divide DE by HL and return quotient in HL, remainder in DE
CCDIV:	LD	B,H
	LD	C,L
	LD	A,D
	XOR	B
	PUSH	AF
	LD	A,D
	OR	A
	CALL	M,CCDENEG
	LD	A,B
	OR	A
	CALL	M,CCBCNEG
	LD	A,16
	PUSH	AF
	EX	DE,HL
	LD	DE,0
CCDIV1:	ADD	HL,HL
	CALL	CCRDEL
	JR	Z,CCDIV2
	CALL	CCPBCDE
	JP	M,CCDIV2
	LD	A,L
	OR	1
	LD	L,A
	LD	A,E
	SUB	C
	LD	E,A
	LD	A,D
	SBC	A,B
	LD	D,A
CCDIV2:	POP	AF
	DEC	A
	JR	Z,CCDIV3
	PUSH	AF
	JR	CCDIV1
CCDIV3:	POP	AF
	RET	P
	CALL	CCDENEG
	EX	DE,HL
	CALL	CCDENEG
	EX	DE,HL
	RET	
CCDENEG: LD	A,D
	CPL	
	LD	D,A
	LD	A,E
	CPL	
	LD	E,A
	INC	DE
	RET	
CCBCNEG: LD	A,B
	CPL	
	LD	B,A
	LD	A,C
	CPL	
	LD	C,A
	INC	BC
	RET	
CCRDEL:	LD	A,E
	RLA	
	LD	E,A
	LD	A,D
	RLA	
	LD	D,A
	OR	E
	RET	
CCPBCDE: LD	A,E
	SUB	C
	LD	A,D
	SBC	A,B
	RET	
;logical negation
CCLNEG:
	LD A,H
	OR L
	JR NZ,$+5
	LD L,1
	RET
	LD HL,0
	RET
;
; EXECUTE SWITCH STATEMENT
;
; HL  =  SWITCH VALUE
;(SP) -> SWITCH TABLE
;        DW ADDR1, VALUE1
;        DW ADDR2, VALUE2
;        ...
;        DW 0
;       [JMP DEFAULT]
;
CCSWITCH:
	EX DE,HL		;DE = SWITCH VALUE
	POP HL			;HL -> SWITCH TABLE
SWLOOP:
	LD C,(HL)
	INC HL
	LD B,(HL)		;BC -> CASE ADDR, ELSE 0
	INC HL
	LD A,B
	OR C
	JR Z,SWEND		;DEFAULT OR CONTINUATION CODE
	LD A,(HL)
	INC HL
	CP E
	LD A,(HL)
	INC HL
	JR NZ,SWLOOP
	CP D
	JR NZ,SWLOOP
	LD H,B			;CASES MATCHED
	LD L,C
SWEND:
	JP (HL)
#endasm
