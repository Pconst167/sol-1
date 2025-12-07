
/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
/*    >>>>>  R E D  <<<<<    THE EDWARD K. REAM FULL SCREEN C EDITOR     */
/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
/* >>>>> THIS HAS BEEN MODIFIED TO CONFORM TO EDITOR V. 3.00 (RDK) <<<<< */
/*                >>>>> VERSION 4.11-RDK-HEATH-H19 <<<<<                 */
/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */

/*
	Copyright (C) 1983 by

		Edward K. Ream
		1850 Summit Ave.
		Madison, WI 53705
		(608) 231 - 2952

	      Permission  to  copy  without  fee  all  or part of this
	 program is granted provided that the copies are not made  for
	 direct  commercial  advantage, this copyright notice appears,
	 and notice is given that copying is by permission  of  Edward
	 K.   Ream.   To copy otherwise requires a fee and/or specific
	 permission.
*/

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
/*    USER DEFINABLE CONSTANTS THAT CAN BE CHANGED TO SUIT YOUR NEEDS    */
/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */

/* Define global constants */

#define VERS   "Small-C Version 4.11-RDK-HEATH-H19-Heathmode."

/* tpa size = 40k + slot-size (RDK) */
#define VERS2  "This version requires 52k of user memory (TPA)."
#define VERS3  "Modified to conform to EDITOR V.3.00 structure."
#define VERS4  "(Note: This uses 3 slot x 4k/slot buffering.)"

/* IF YOU CHANGE NSLOTS YOU MUST ADJUST SLOT-SIZE BELOW (RDK) */
#define NSLOTS 3
#define SLOTSIZE 12288	/* NSLOTS x DATASIZE (3 x 4096) (RDK) */

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */

/* Define buffer globals */

/*
	You may tune these constants for better performance.

	DATASIZE:  The size of struct BLOCK.
		    Make sure that DATASIZE is a multiple
		    of the size of your disk sectors.
		    (for CP/M, a multiple of 128)

	READSIZE:   Make sure that the READSIZE constant
		    is DATASIZE / 128 (i.e., DATASIZE/CPMSIZE).

	BUFFSIZE:   Make sure that BUFFSIZE is (DATASIZE-HEADERSIZE).

	NSLOTS:     The number of BLOCKS resident in memory.
		    The code assumes this number is AT LEAST 3.

	DATAFILE:  The name of the work file. Note the double
		    quotes.  Pick a name you never use.
*/
	
#define DATASIZE 4096		/* a multiple of your sector size */
#define READSIZE 32		/* DATASIZE divided by CPMSIZE */

#define HEADERSIZE 8		/* size of first 4 fields  */
#define BUFFSIZE 4088		/* DATASIZE - HEADERSIZE */

#define DATAFILE "@@DATA@@.TMP"


/* Do not touch this constant. */

#define CPMSIZE 128

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */

/* Define constants describing a text line */

#define MAXLEN	200	/* max chars per line		*/
#define MAXLEN1	201	/* MAXLEN + 1			*/

/*
Define length and width of screen and printer.
*/

#define SCRNW 80        /* master screen width */
#define SCRNW1 79
#define SCRNL 24        /* master screen length */
#define SCRNL1 23
#define SCRNL2 22
#define LISTW 80        /* master printer width */



/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
/*            CONSTANTS THAT SHOULD NOT GENERALLY BE CHANGED             */
/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */

/* Define operating system constants */

#define SYSFNMAX 15	/* CP/M file name length + 1	*/
#define CPMEOF 26

/* Define misc. constants */

#define COPYRIGHT "Copyright (C) 1983 by Edward K. Ream."
#define CPYRIGHT2 "(Modifications Copyright 1986,1995 by R. D. Keys.)"
#define SIGNON    "Welcome to RED, the Full-Screen C-Language Editor."
#define SHOWHELP  "Type '?' in COMMAND or EDIT modes for help."

#define EOS	0	/* code sometimes assumes \0	*/
#define OK	1
#define ERR	-1	/* error.  must be <0		*/
#define ERROR	-1	/* error.  must be <0		*/
#define EOF	-2	/* end of file.  must be <0	*/
#define YES	1	/* must be nonzero		*/
#define NO	0
#define CR	13	/* carriage return		*/
#define LF	10	/* line feed			*/
#define TAB	9	/* tab character		*/
#define FF	12	/* form feed CTRL-L (insert mode only) (RDK) */
#define BELL	7	/* bell CTRL-G (insert mode only) (RDK) */
#define HUGE	32000	/* practical infinity		*/


/* Define which keys are used for special edit functions
   as in EDITOR V.3.00. */

#define UP1     21              /* ctrlU -- Insert up    */
#define DOWN1   13              /* RETURN -- Insert down  */
#define UP2     11              /* ctrlK -- cursor up    */
#define DOWN2   10              /* ctrlJ -- cursor down  */
#define DOWN2A  22              /* for TELEVIDEO 802 only (RDK) */
#define LEFT1   8               /* ctrlH -- cursor left  */
#define RIGHT1  12              /* ctrlL -- cursor right */
#define INS1    9               /* ctrl-i -- insert mode  */
#define EDIT1   5               /* ctrl-e -- edit mode    */
#define ESC1    27              /* ESCAPE -- command mode */
#define DEL1    127             /* DELETE -- delete char  */
#define ZAP1    26              /* ctrlZ -- delete line  */
#define ABT1    24              /* ctrlX -- undo         */
#define SPLT1   19              /* ctrlS -- split line   */
#define JOIN1   1               /* ctrlA -- append (join) 2 lines */
#define REP1    18              /* from original RED file (RDK) */


/* Define the disk recovery point. */

char DERROR [6];


/* Define the various editing modes. */

#define CMNDMODE 1	/* enter command mode flag */
#define INSMODE  2	/* enter insert modes flag */
#define EDITMODE 3	/* enter edit mode flag */
#define EXITMODE 4	/* exit editor flag */


/* Define the resident status table.
   There is one entry for each slot. */

#define FREE	1	/* status:  block is available	*/
#define FULL	2	/* status:  block is allocated	*/
#define DIRTY	3	/* status:  must swap out	*/



/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
/*         DEFINE THE VARIOUS GLOBAL SYSTEM AND BUFFER DATA TYPES        */
/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */


/* Define system and buffer global data types */

char sysinbuf[128];	/* file buffer */
int  sysincnt;		/* buffer count */

char syscbuf[MAXLEN];	/* console type ahead buffer */
int  sysccnt;

int sysrcnt;		/* repeat count */
int syslastc;		/* last character (may be repeated) */

int  systopl,systopy,sysnl;	/* interrupt information */


/*
	Partially define the format of a block.  The data
	field is organized as a singly linked list of lines;
	that is, each line is preceded by a two-byte length
	field.

	The dback and dnext fields in the header are used
	to doubly-link the disk blocks so that stepping
	through the blocks either forward or backwards is
	efficient.  -1 denotes the end of each list.

	When blocks become totally empty they are entered
	on a list of free blocks.  The links of this list
	are kept in the blocks themselves in the dnext field.
	The bfree variable is the head of this list.

	Also define the in-core block table.  This table
	contains the blocks that have been swapped into
	memory.  Each entry in this table is called a slot.
*/

/*
	Boundary conditions:

	1.  Only bufins() can extend the buffer, NOT
	    bufgo() and bufdn().

	2.  bufatbot() is true when the current line is
	    PASSED the last line of the buffer.  Both
	    bufgo() and bufdn() can cause bufatbot() to
	    become true.  bufgetln() returns a zero length
	    line if bufatbot() is true.

	3.  bmaxline is the number of lines in the buffer.
	    However, bline == bmaxline + 1 is valid and
	    it means that bline points at a null line.

	4.  All buffer routines assume that the variables
            bslot, bline and bstart describe the
	    current line when the routine is called.  Thus,
	    any routine which changes the current line must
	    update these variables.
*/

int	bfatal;	/* erase buffer on disk error	*/
int	bcflag;	/* buffer changed flag		*/

int	bline;		/* current line number		*/
int	bmaxline;	/* highest line number		*/
char *	blinep;	/* pointer to line (local var)	*/

int	bslot;		/* current block's slot number	*/
int	bstart;	/* first line of current block	*/

int	bhead;		/* first block's disk pointer	*/
int	btail;		/* last block's disk pointer	*/

/* error this line (RDK) bmaxdisp is correct spelling... */
/* int	bmaxdiskp; */	/* last sector allocated	*/
int	bmaxdisp;	/* last sector allocated	*/

int	bdatafd;	/* file descriptor of data file	*/
int	buserfd;	/* file descriptor of user file	*/
int	bfree;		/* head of list of free blocks	*/

char	bbuff [DATASIZE];	/* temporary buffer. 	*/

int  dback  [NSLOTS];		/* # of previous block	*/
int  dnext  [NSLOTS];		/* # of next block	*/
int  davail [NSLOTS];		/* # of data bytes free	*/
int  dlines [NSLOTS];		/* # of lines on block	*/
char ddata  [SLOTSIZE];		/* resident blocks	*/

int	dlru    [NSLOTS];	/* lru count		*/
int	dstatus [NSLOTS];	/* FULL, FREE or DIRTY	*/
int	ddiskp  [NSLOTS];	/* disk pointer		*/

char filename [SYSFNMAX];

char	editbuf[MAXLEN];	/* the edit buffer	*/
int	editp;			/* cursor: buffer index	*/
int	editpmax;		/* length of buffer	*/
int	edcflag;		/* buffer change flag	*/


/* define maximal length of a tab character */

int fmttab;


/* define the current device and device width */

int fmtdev;		/* device -- YES/NO = LIST/CONSOLE */
int fmtwidth;		/* devide width.  LISTW/SCRNW1 */


/*
     fmtcol[i] is the first column at which
     buf[i] will be printed.
     fmtsub() and fmtlen() assume fmtcol[] is valid on entry.
*/

int fmtcol[MAXLEN1];


/*
Define the current coordinates of the cursor.
*/

int outx, outy;


/* Define the prompt line data. */

char pmtln[MAXLEN];	/* mode */
char pmtfn[SYSFNMAX];	/* file name */



/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
/*             INCLUDE THE LIBRARY ASSEMBLER SOURCE MODULE               */
/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */


/*  #include redlib */		/* RED LIBRARY MODULE (RDK)	*/

#asm
CCGCHAR: MOV	A,M
CCSXT:	MOV	L,A
	RLC
	SBB	A
	MOV	H,A
	RET
CCGINT:	MOV	A,M
	INX	H
	MOV	H,M
	MOV	L,A
	RET
CCPCHAR: MOV	A,L
	STAX	D
	RET
CCPINT:	MOV	A,L
	STAX	D
	INX	D
	MOV	A,H
	STAX	D
	RET
CCOR:	MOV	A,L
	ORA	E
	MOV	L,A
	MOV	A,H
	ORA	D
	MOV	H,A
	RET
CCXOR:	MOV	A,L
	XRA	E
	MOV	L,A
	MOV	A,H
	XRA	D
	MOV	H,A
	RET
CCAND:	MOV	A,L
	ANA	E
	MOV	L,A
	MOV	A,H
	ANA	D
	MOV	H,A
	RET
CCEQ:	CALL	CCCMP
	RZ
	DCX	H
	RET
CCNE:	CALL	CCCMP
	RNZ
	DCX	H
	RET
CCGT:	XCHG
	CALL	CCCMP
	RC
	DCX	H
	RET
CCLE:	CALL	CCCMP
	RZ
	RC
	DCX	H
	RET
CCGE:	CALL	CCCMP
	RNC
	DCX	H
	RET
CCLT:	CALL	CCCMP
	RC
	DCX	H
	RET
CCCMP:	MOV	A,E
	SUB	L
	MOV	E,A
	MOV	A,D
	SBB	H
	LXI	H,1
	JM	CCCMP1
	ORA	E
	RET
CCCMP1:	ORA	E
	STC
	RET
CCUGE:	CALL	CCUCMP
	RNC
	DCX	H
	RET
CCULT:	CALL	CCUCMP
	RC
	DCX	H
	RET
CCUGT:	XCHG
	CALL	CCUCMP
	RC
	DCX	H
	RET
CCULE:	CALL	CCUCMP
	RZ
	RC
	DCX	H
	RET
CCUCMP:	MOV	A,D
	CMP	H
	JNZ	$+5
	MOV	A,E
	CMP	L
	LXI	H,1
	RET
CCASR:	XCHG
	MOV	A,H
	RAL
	MOV	A,H
	RAR
	MOV	H,A
	MOV	A,L
	RAR
	MOV	L,A
	DCR	E
	JNZ	CCASR+1
	RET
CCASL:	XCHG
	DAD	H
	DCR	E
	JNZ	CCASL+1
	RET
CCSUB:	MOV	A,E
	SUB	L
	MOV	L,A
	MOV	A,D
	SBB	H
	MOV	H,A
	RET
cmh:
CCNEG:	CALL	CCCOM
	INX	H
	RET
CCCOM:	MOV	A,H
	CMA
	MOV	H,A
	MOV	A,L
	CMA
	MOV	L,A
	RET
CCMULT:	MOV	B,H
	MOV	C,L
	LXI	H,0
CCMULT1: MOV	A,C
	RRC
	JNC	$+4
	DAD	D
	XRA	A
	MOV	A,B
	RAR
	MOV	B,A
	MOV	A,C
	RAR
	MOV	C,A
	ORA	B
	RZ
	XRA	A
	MOV	A,E
	RAL
	MOV	E,A
	MOV	A,D
	RAL
	MOV	D,A
	ORA	E
	RZ
	JMP	CCMULT1
CCDIV:	MOV	B,H
	MOV	C,L
	MOV	A,D
	XRA	B
	PUSH	PSW
	MOV	A,D
	ORA	A
	CM	CCDENEG
	MOV	A,B
	ORA	A
	CM	CCBCNEG
	MVI	A,16
	PUSH	PSW
	XCHG
	LXI	D,0
CCDIV1:	DAD	H
	CALL	CCRDEL
	JZ	CCDIV2
	CALL	CCCMPBCDE
	JM	CCDIV2
	MOV	A,L
	ORI	1
	MOV	L,A
	MOV	A,E
	SUB	C
	MOV	E,A
	MOV	A,D
	SBB	B
	MOV	D,A
CCDIV2:	POP	PSW
	DCR	A
	JZ	CCDIV3
	PUSH	PSW
	JMP	CCDIV1
CCDIV3:	POP	PSW
	RP
	CALL	CCDENEG
	XCHG
	CALL	CCDENEG
	XCHG
	RET
CCDENEG: MOV	A,D
	CMA
	MOV	D,A
	MOV	A,E
	CMA
	MOV	E,A
	INX	D
	RET
CCBCNEG: MOV	A,B
	CMA
	MOV	B,A
	MOV	A,C
	CMA
	MOV	C,A
	INX	B
	RET
CCRDEL:	MOV	A,E
	RAL
	MOV	E,A
	MOV	A,D
	RAL
	MOV	D,A
	ORA	E
	RET
CCCMPBCDE: MOV	A,E
	SUB	C
	MOV	A,D
	SBB	B
	RET
#endasm
#asm
base:	equ	0
bdos:	equ	base+5
tpa:	equ	base+100h
fcb:	equ	base+5ch
nfcbs:	equ	8
tbuff:	equ	base+80h
origin:	equ	tpa
exitad:	equ	base
cr:	equ 0dh
lf:	equ 0ah
newlin:	equ lf
tab:	equ 9
bs:	equ 08h
cntrlc:	equ 3
errorv	equ 255
conin:	equ 1
conout:	equ 2
lstout:	equ 5
dconio:	equ 6
pstrng:	equ 9
getlin:	equ 10
cstat:	equ 11
select:	equ 14
openc:	equ 15
closec:	equ 16
delc:	equ 19
reads:	equ 20
writs:	equ 21
creatc:	equ 22
renc:	equ 23
sdma:	equ 26
readr:	equ 33
writr:	equ 34
cfsizc:	equ 35
srrecc:	equ 36
args:	ds	14
arg1	equ	args
arg2	equ	args+2
arg3	equ	args+4
arg4	equ	args+6
arg5	equ	args+8
arg6	equ	args+10
arg7	equ	args+12
iohack:	ds	6
rseed	ds	8
tmp:	ds	1
tmp1:	ds	2
tmp2:	ds	2
tmp2a:	ds	2
ungetl:	ds	1
lastc:	ds	1
allocp:	ds	2
alocmx:	ds	2
fcbt:	ds	36*nfcbs
fdt:	ds	nfcbs
comlin:	ds	131
arglst:	ds	60
get3args:	lxi	h,4
		dad	sp
		push	h
		mov	a,m
		inx	h
		mov	h,m
		mov	l,a
		shld	arg3
		pop	h
		inx	h
		inx	h
		jmp	get2next
get2args:	lxi	h,4
		dad	sp
get2next:	push	h
		mov	a,m
		inx	h
		mov	h,m
		mov	l,a
		shld	arg2
		pop	h
		inx	h
		inx	h
		jmp	get1next
get1arg:	lxi	h,4
		dad	sp
get1next:	mov	a,m
		inx	h
		mov	h,m
		mov	l,a
		shld	arg1
		ret
ma1toh:		lhld	arg1
		mov	a,l
		ret
ma2toh:		lhld	arg2
		mov	a,l
		ret
ma3toh:		lhld	arg3
		mov	a,l
		ret
ccgo:
init:	pop	h
	shld	tmp2
	lxi	h,59dch
	shld	rseed
	mvi	a,0dbh
	sta	iohack
	mvi	a,0d3h
	sta	iohack+3
	mvi	a,0c9h
	sta	iohack+2
	sta	iohack+5
	mvi	c,11
	call	bdos
	ora	a
	nop
	jz	initzz
	mvi	c,1
	call	bdos
initzz:	lxi	h,tbuff
	lxi	d,comlin
	mov	b,m
	inx	h
	mov	a,b
	ora	a
	jnz	initl
	lxi	d,1
	jmp	i5
initl:	mov	a,m
	stax	d
	inx	h
	inx	d
	dcr	b
	jnz	initl
	xra	a
	stax	d
	lxi	h,comlin
	lxi	d,1
	lxi	b,arglst
	xra	a
	sta	tmp1
i2:	mov	a,m
	inx	h
	cpi	' '
	jz	i2
	ora	a
	jz	i5
	cpi	'"'
	jnz	i2a
	sta	tmp1
	jmp	i2b
i2a:	dcx	h
i2b:	mov	a,l
	stax	b
	inx	b
	mov	a,h
	stax	b
	inx	b
	inx	d
i3:	mov	a,m
	inx	h
	ora	a
	jz	i5
	push	b
	mov	b,a
	lda	tmp1
	ora	a
	mov	a,b
	pop	b
	jz	i3a
	cpi	'"'
	jnz	i3
	xra	a
	sta	tmp1
	dcx	h
	mov	m,a
	inx	h
i3a:	cpi	' '
	jnz	i3
	dcx	h
	mvi	m,0
	inx	h
	jmp	i2
i5:	push	d
	lxi	h,arglst-2
	push	h
	mvi	b,nfcbs
	lxi	h,fdt
i6:	mvi	m,0
	inx	h
	dcr	b
	jnz	i6
	xra	a
	sta	ungetl
	sta	lastc
	lhld	tmp2
	pchl
error:	lxi	h,-1
	ret
qzexit:
exit:
	mvi	a,7+nfcbs
exit1:	push	psw
	call	fgfd
	jc	exit2
	mov	l,a
	mvi	h,0
	push	h
	call	close
	pop	h
exit2:	pop	psw
	dcr	a
	cpi	7
	jnz	exit1
	jmp	exitad
qzclose:
close:
	call	get1arg
	call	setdma
	call	ma1toh
	call	fgfd
	jc	error
	mov	a,m
	ani	4
	jz	close2
	push	h
	call	ma1toh
	push	b
	call	fgfcb
	xchg
	mvi	c,16
	call	bdos
	pop	b
	pop	h
close2:	mvi	m,0
	cpi	255
	lxi	h,0
	rnz
	dcx	h
	ret
fgfd:	call	setdma
	mov	d,a
	sui	8
	rc
	cpi	nfcbs
	cmc
	rc
	push	d
	mov	e,a
	mvi	d,0
	lxi	h,fdt
	dad	d
	mov	a,m
	ani	1
	stc
	pop	d
	mov	a,d
	rz
	cmc
	ret
setfcb:
	call	setdma
	push	b
	call	igwsp
	mvi	b,8
	push	h
	inx	d
	ldax	d
	dcx	d
	cpi	':'
	mvi	a,0
	jnz	setf1
	ldax	d
	call	mapuc
	sui	'@'
	inx	d
	inx	d
setf1:	mov	m,a
	inx	h
	call	patchnm
	ldax	d
	cpi	'.'
	jnz	setfcb2
	inx	d
setfcb2 mvi	b,3
	call	setnm
	xra	a
	mov	m,a
	lxi	d,20
	dad	d
	mov	m,a
	inx	h
	mov	m,a
	inx	h
	mov	m,a
	inx	h
	mov	m,a
	pop	d
	pop	b
	ret
patchnm:
	call	setnm
	jmp	setnm3
setnm:	push	b
setnm1:	ldax	d
	cpi	'*'
	mvi	a,'?'
	jz	pad2
setnm2:	ldax	d
	call	legfc
	jc	pad
	mov	m,a
	inx	h
	inx	d
	dcr	b
	jnz	setnm1
	pop	b
setnm3:	ldax	d
	call	legfc
	rc
	inx	d
	jmp	setnm3
pad:	mvi	a,' '
pad2:	mov	m,a
	inx	h
	dcr	b
	jnz	pad2
	pop	b
	ret
legfc:	call	mapuc
	cpi	'.'
	stc
	rz
	cpi	':'
	stc
	rz
	cpi	7fh
	stc
	rz
	cpi	'!'
	ret
mapuc:	cpi	'a'
	rc
	cpi	'z'+1
	rnc
	sui	32
	ret
igwsp:	dcx	d
igwsp1:	inx	d
	ldax	d
	cpi	' '
	jz	igwsp1
	cpi	9
	jz	igwsp1
	ret
fgfcb:	push	b
	call	setdma
	ora	a
	mov	c,a
	jnz	fgfc2
	mvi	b,nfcbs
	lxi	d,fdt
	lxi	h,fcbt
	mvi	c,8
fgfc1:	ldax	d
	ani	1
	mov	a,c
	jnz	fgfc1a
	pop	b
	ret
fgfc1a:	push	d
	lxi	d,36
	dad	d
	pop	d
	inx	d
	inr	c
	dcr	b
	jnz	fgfc1
fgfc1b:	stc
	pop	b
	ret
fgfc2:	call	fgfd
	jc	fgfc1b
	sui	8
	mov	l,a
	mvi	h,0
	dad	h
	dad	h
	mov	d,h
	mov	e,l
	dad	h
	dad	h
	dad	h
	dad	d
	xchg
	lxi	h,fcbt
	dad	d
	mov	a,c
	pop	b
	ret
setdma:	push	d
	push	b
	push	psw
	push	h
	mvi	c,26
	lxi	d,tbuff
	call	bdos
	pop	h
	pop	psw
	pop	b
	pop	d
	ret
#endasm
#asm
qzgetchar:
getchar:
	lda	ungetl
	ora	a
	mov	l,a
	jz	gch2
	xra	a
	sta	ungetl
	mvi	h,0
	ret
gch2:	push	b
	mvi	c,conin
	call	bdos
	pop	b
	cpi	cntrlc
	jz	base
	cpi	1ah
	lxi	h,-1
	rz
	mov	l,a
	cpi	cr
	jnz	gch3
	push	b
	mvi	c,conout
	mvi	e,lf
	call	bdos
	pop	b
	mvi	l,newlin
gch3:	mvi	h,0
	ret
qzkbhit:
kbhit:
	lda	ungetl
	mvi	h,0
	mov	l,a
	ora	a
	rnz
	push	b
	mvi	c,cstat
	call	bdos
	pop	b
	ora	a
	lxi	h,0
	rz
	inr	l
	ret
qzungetch:
ungetch:
	call	get1arg
	lda	ungetl
	mov	l,a
	push	h
	call	ma1toh
	sta	ungetl
	pop	h
	mvi	h,0
	ret
qzputs:
puts:
	call	get1arg
	call	ma1toh
	push	b
	call	puts1
	pop	b
	ret
puts1:	mov	a,m
	cpi	0
	rz
	push	h
	mov	l,a
	push	h
	call	putchar
	pop	h
	pop	h
	inx	h
	jmp	puts1
qzputchar:
putchar:
	call	get1arg
	call	ma1toh
	push	b
	mvi	c,conout
	cpi	newlin
	jnz	put1
	mvi	e,cr
	call	bdos
	mvi	c,conout
	mvi	a,lf
put1:	mov	e,a
	call	bdos
put2:	mvi	c,cstat
	call	bdos
	ora	a
	jnz	put3
	pop	b
	ret
put3:	mvi	c,conin
	call	bdos
	cpi	cntrlc
	jz	base
	pop	b
	ret
qzputch:
putch:
	call	get1arg
	call	ma1toh
	push	b
	mvi	c,conout
	mov	e,a
	cpi	newlin
	jnz	putch1
	mvi	e,cr
	call	bdos
	mvi	c,conout
	mvi	e,lf
putch1:	call	bdos
	pop	b
	ret
qzgets:
gets:
	call	get1arg
	call	ma1toh
	push	b
	push	h
	push	h
	lxi	h,-150
	dad	sp
	push	h
	mvi	m,88h
	mvi	c,getlin
	xchg
	call	bdos
	mvi	c,conout
	mvi	e,lf
	call	bdos
	pop	h
	inx	h
	mov	b,m
	inx	h
	pop	d
copyl:	mov	a,b
	ora	a
	jz	gets2
	mov	a,m
	stax	d
	inx	h
	inx	d
	dcr	b
	jmp	copyl
gets2:	xra	a
	stax	d
	pop	h
	pop	b
	ret
qzsetfcb:
	call	get2args
	push	b
	lhld	arg2
igsp:	mov	a,m
	inx	h
	cpi	' '
	jz	igsp
	cpi	tab
	jz	igsp
	dcx	h
	xchg
	lhld	arg1
	call	setfcb
	lxi	h,0
	pop	b
	ret
qzread:
read:
	call	get3args
	lda	arg1
	call	fgfd
	jc	error
	mov	a,m
	ani	2
	jz	error
	push	b
	lda	arg1
	call	fgfcb
	shld	tmp2
	lxi	h,0
	shld	tmp2a
read2:	lhld	arg3
	mov	a,h
	ora	l
	jz	read4
read2a:	lhld	arg2
	xchg
	mvi	c,sdma
	call	bdos
	lhld	tmp2
	xchg
	mvi	c,reads
	push	d
	call	bdos
	pop	d
	cpi	2
	pop	b
	jz	error
	push	b
	cpi	1
	jnz	read6
read3:	lxi	h,32
	dad	d
	mov	a,m
	cpi	80h
	jnz	read4
	mvi	m,0
read4:	lhld	tmp2a
read5:	pop	b
	ret
read6:	lhld	arg3
	dcx	h
	shld	arg3
	lhld	arg2
	lxi	d,128
	dad	d
	shld	arg2
	lhld	tmp2a
	inx	h
	shld	tmp2a
	jmp	read2
qzwrite:
write:
	call	get3args
	lda	arg1
	call	fgfd
	jc	error
	mov	a,m
	ani	4
	jz	error
	push	b
	lda	arg1
	call	fgfcb
	shld	tmp2
	lxi	h,0
	shld	tmp2a
	lxi	d,tbuff
	mvi	c,sdma
	call	bdos
writ1:	lhld	arg3
	mov	a,h
	ora	l
	lhld	tmp2a
	jz	writ3
	lhld	arg2
	lxi	d,tbuff
	mvi	b,128
writ2:	mov	a,m
	stax	d
	inx	h
	inx	d
	dcr	b
	jnz	writ2
	shld	arg2
	lhld	tmp2
	xchg
	mvi	c,writs
	call	bdos
	ora	a
	lhld	tmp2a
	jnz	writ3
	inx	h
	shld	tmp2a
	lhld	arg3
	dcx	h
	shld	arg3
	jmp	writ1
writ3:	pop	b
	ret
qzopen:
open:
	call	get2args
	xra	a
	call	fgfcb
	jc	error
	sta	tmp
	xchg
	lhld	arg1
	xchg
	push	b
	call	setfcb
	mvi	c,openc
	call	bdos
	cpi	errorv
	pop	b
	jz	error
	lda	tmp
	call	fgfd
	lda	arg2
	ora	a
	mvi	d,3
	jz	open1
	dcr	a
	mvi	d,5
	jz	open1
	dcr	a
	jnz	error
	mvi	d,7
open1:	mov	m,d
	lda	tmp
	mov	l,a
	mvi	h,0
	ret
qzcreat:
creat:
	call	get1arg
	lhld	arg1
	push	b
	push	h
	call	unlink
	pop	d
	mvi	c,creatc
	lxi	d,fcb
	call	bdos
	cpi	errorv
	pop	b
	jz	error
	lhld	arg1
	push	h
	lxi	h,2
	push	h
	call	open
	pop	d
	pop	d
	ret
qzunlink:
unlink:
	call	get1arg
	call	ma1toh
	push	b
	xchg
	lxi	h,fcb
	call	setfcb
	mvi	c,delc
	call	bdos
	lxi	h,0
	pop	b
	ret
qzseek:
seek:
	call	get3args
	lda	arg1
	call	fgfcb
	jc	error
	push	b
	push	h
	lhld	arg1
	push	h
	call	tell
	pop	d
	xchg
	lda	arg3
	lhld	arg2
	ora	a
	jz	seek2
	dad	d
seek2:	mov	a,l
	rlc
	mov	a,h
	ral
	ani	7fh
	sta	tmp
	xthl
	lxi	d,12
	push	h
	dad	d
	cmp	m
	jz	seek5
	xthl
	xchg
	mvi	c,closec
	push	d
	call	bdos
	pop	d
	pop	h
	cpi	errorv
	jnz	seek4
seek3:	pop	d
	pop	b
	jmp	error
seek4:	lda	tmp
	mov	m,a
	push	d
	mvi	c,openc
	call	bdos
seek5:	pop	d
	cpi	errorv
	jz	seek3
	lxi	h,32
	dad	d
	pop	d
	mov	a,e
	ani	7fh
	mov	m,a
	xchg
	pop	b
	ret
qztell:
tell:
	call	get1arg
	call	ma1toh
	call	fgfcb
	jc	error
	push	b
	lxi	d,12
	dad	d
	mov	b,m
	lxi	d,20
	dad	d
	mov	c,m
	xra	a
	mov	a,b
	rar
	mov	h,a
	mvi	a,0
	rar
	mov	b,a
	add	c
	mov	l,a
	mov	a,c
	ana	b
	jp	tell2
	inr	h
tell2:	pop	b
	ret
qzrename:
rename:
	call	get2args
	push	b
renam:	lhld	arg1
	xchg
	lxi	h,wfcb
	call	setfcb
	lhld	arg2
	xchg
	lxi	h,wfcb+16
	call	setfcb
	lxi	d,wfcb
	mvi	c,renc
	call	bdos
	pop	b
	cpi	errorv
	jz	error
	lxi	h,0
	ret
wfcb:	ds 53
qzfabort:
fabort:
	call	get1arg
	call	ma1toh
	call	fgfd
	jc	error
	mvi	m,0
	lxi	h,0
	ret
qzfcbaddr:
fcbaddr:
	call	get1arg
	call	ma1toh
	call	fgfd
	jc	error
	call	ma1toh
	call	fgfcb
	ret
bdos	equ	5
qzbdos:
	call	get2args
	push	b
	lda	arg1
	mov	c,a
	lhld	arg2
	xchg
	call	bdos
	pop	b
	ret
qzbios:
bios:
	call	get2args
	push	b
	lhld	base+1
	dcx	h
	dcx	h
	dcx	h
	lda	arg1
	mov	b,a
	add	a
	add	b
	mov	e,a
	mvi	d,0
	dad	d
	push	h
	lhld	arg2
	mov	b,h
	mov	c,l
	lxi	h,retadd
	xthl
	pchl
retadd:	mov	l,a
	mvi	h,0
	pop	b
	ret
#endasm
#asm
qzsetjmp:
	call	get1arg
	call	ma1toh
	mov	m,c
	inx	h
	mov	m,b
	inx	h
	xchg
	lxi	h,0
	dad	sp
	xchg
	mov	m,e
	inx	h
	mov	m,d
	inx	h
	pop	d
	push	d
	mov	m,e
	inx	h
	mov	m,d
	lxi	h,0
	ret
qzlongjmp:
	call	get2args
	call	ma1toh
	mov	c,m
	inx	h
	mov	b,m
	inx	h
	mov	e,m
	inx	h
	mov	d,m
	inx	h
	shld	temp
	call	ma2toh
	xchg
	sphl
	pop	h
	lhld	temp
	mov	a,m
	inx	h
	mov	h,m
	mov	l,a
	xchg
	push	d
	ret
temp:	ds 2
#endasm



/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
/*                    BEGIN THE MAIN PROGRAM SOURCE                      */
/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */




/* the main program dispatches the routines that
 * handle the various modes.
 */

main()
{
	int mode;

	/* ready the system module */
	sysinit();
	/* clear the main buffer */
	bufnew();
	/* fmt output by default goes to screen */
	fmtassn(NO);
	/* set tabs, clear the screen and sign on */
	fmtset(8);
	outclr();
	outxy(0,SCRNL1);
	message(SIGNON);
	message(VERS);
	message(VERS2);
        message(VERS3);
        message(VERS4);
	message("");
	message(COPYRIGHT);
        message(CPYRIGHT2);
	message("");
	message(SHOWHELP);
	outxy(0,1);
	/* clear filename [] for save(), resave() */
	pmtclr();
	/* start off in command mode */
	mode=CMNDMODE;
	/* get null line 1 for edit() */
	edgetln();
	while(1){
		if (mode == EXITMODE) {
			break;
		}
		else if (mode == CMNDMODE) {
			mode=command();
		}
		else if (mode == EDITMODE) {
			mode=edit();
		}
		else if (mode == INSMODE) {
			mode=insert();
		}
		else {
			syserr("MAIN: no mode");
			mode=EDITMODE;
		}
	}
}

/*
 * handle edit mode.
 * dispatch the proper routine based on one-character commands.
 */

edit()
{
char buffer [SCRNW1];
int v;
int x,y, topline;
char c;
	/* we can't do edgetln() or edgo() here because
	 * those calls reset the cursor.
	 */

	/* Set disk error recovery point. */
	setjmp(DERROR);

	pmtedit();
	while(1){
		/* get command */
		c=tolower(syscin());

		if (c == ESC1) {
			/* enter command mode. */
			return CMNDMODE;
		}
		else if ( (c == INS1) | (c=='i') ) {
			/* enter insert mode */
			return INSMODE;
		}
		else if (special(c) == YES) {
			if (c == UP1) {
				return INSMODE;
			}
			else {
				continue;
			}
		}
		else if (control(c) == YES) {
			continue;
		}
		else if (c == ' ') {
			edright();
			pmtcol();
		}
		else if (c == DOWN1) {
			/* cursor down using CR (RDK) */
			eddn();
			pmtline();
			edbegin();
			pmtcol();
		}
		else if (c == 'b') {
			edbegin();
			pmtcol();
		}
		else if (c == 'd') {
			/* scroll down */
			pmtmode("EDIT: scroll");
			syswait();
			while (bufnrbot() == NO) {
				if (chkkey() == YES) {
					break;
				}
				eddn();
			}
			pmtedit();
		}
		else if (c == 'e') {
			edend();
			pmtcol();
		}
		else if (c == 'g') {
			/* save x,y in case don't get number */
			x=outgetx();
			y=outgety();
			pmtcmnd("EDIT: goto: ",buffer);
			if(number(buffer,&v)) {
				edgo(v,0);
			}
			else {
				outxy(x,y);
			}
			pmtedit();
		}

		else if (c == '?') {
			/* remember how screen was drawn */
			x=outgetx();
			y=outgety();
			topline=bufln()-y+1;

			/* output the help message */
			outclr();
			outxy(0,SCRNL1);
			edithelp();

			/* redraw the screen */
			bufout(topline,1,SCRNL1);
			outxy(x,y);
			pmtedit();
		}

		else if (c == 'k') {
			pmtmode("EDIT: kill");
			c=syscin();
			if ( (special(c) == NO) &
			     (control(c) == NO)
			   ) {
				edkill(c);
			}
			pmtedit();
		}
		else if (c == 's') {
			pmtmode("EDIT: search");
			c=syscin();
			if ( (special(c) == NO) &
			     (control(c) == NO)
			    ) {
				edsrch(c);
			}
			pmtedit();
		}
		else if (c == 'u') {
			/* scroll up */
			pmtmode("EDIT: scroll");
			syswait();
			while (bufattop() == NO) {
				if (chkkey() == YES) {
					break;
				}
				edup();
			}
			pmtedit();
		}
                else if (c == 'x') {
                        pmtmode("EDIT: eXchange") ;
                        while (c != ESC1) {
                           c=syscin() ;
                           if (c == ESC1) {
                                        return (EDITMODE) ;
                           }

        /* Make sure you have only printing characters plus space */
        /* and tab characters that may be exchanged, to prevent   */
        /* confusion.  This is done only in the exchange mode.    */
        /* All of the characters are active in the insert mode.   */

                           if (c == FF) {
                                        return (EDITMODE) ;
                           }
                           if (c == BELL) {
                                        return (EDITMODE) ;
                           }
                           if (c == CR) {
                                        return (EDITMODE) ;
                           }
                           if (control(c) == YES) {
                                        return (EDITMODE) ;
                           }
                           if (special(c) == YES) {
                                        return (EDITMODE) ;
                           }
                           edchng(c) ;
                        }
                        pmtedit() ;
                }
		/* do nothing if command not found */
	}
}

/*
 * Insert mode.
 */

insert()
{
char c ;

	/* Set disk error recovery point. */
	setjmp(DERROR);

        pmtmode("insert") ;

        while (1) {
                /* get command */
                c=syscin() ;
                if (c == ESC1) {
                        /* enter edit mode */
                        return (EDITMODE) ;
                }
                else if (c == DEL1) {
                        /* delete a character using delete key */
                        eddel() ;
                        pmtcol() ;
                        continue ;
                }
                else if (c == DOWN1) {
                        /* insert down using carriage return */
                        ednewdn() ;
                        pmtline() ;
                        continue ;
                }
                else if (control(c) == YES) {
                        /* ignore non-special control characters */
                        continue ;
                }
                else {
                        /* insert one char in line */
                        edins(c) ;
                        pmtcol() ;
                }
        }
}

/* Return YES if c is a control char */

control(c)
char c ;
{
        if (c == TAB) {
                return (NO) ;           /* tab is regular */
        }
        else if (c == CR) {
                return (NO) ;           /* return CTRL-M is regular */
        }
        else if (c == FF) {
                return (NO) ;           /* form feed CTRL-L is regular */
        }
        else if (c == BELL) {
                return (NO) ;           /* ASCII Bell is regular */
        }
        else if (c >= 127) {
                return (YES) ;          /* del or high bit on */
        }
        else if (c < 32) {
                return (YES) ;
        }
        else {
                return (NO) ;           /* normal */
        }
}

/*
 * handle the default actions of all special keys.
 * return YES if c is one of the keys.
 */

special(c) char c;
{
int k;
	if (c == JOIN1) {
		edjoin();
		pmtline();
		return YES;
	}
	if (c == SPLT1) {
		edsplit();
		pmtline();
		return YES;
	}
	if (c == ABT1) {
		edabt();
		pmtcol();
		return YES;
	}
	else if (c == DEL1) {
		eddel();
		pmtcol();
		return YES;
	}
	else if (c == ZAP1) {
		edzap();
		pmtline();
		return YES;
	}
	else if (c == UP2) {
		/* move up */
		edup();
		pmtline();
		return YES;
	}
	else if (c == UP1) {
		/* insert up */
		ednewup();
		pmtline();
		return YES;
	}

        /* use down2a only with televideo ts802 or tv925-950 terminals (RDK) */
        /* remove it for anything else (RDK) */
/*	else if ((c == DOWN2) | (c == DOWN2A)) { */
	else if (c == DOWN2) {
		/* move down */
		eddn();
		pmtline();
		return YES;
	}

	else if (c == LEFT1) {
		edleft();
		pmtcol();
		return YES;
	}
	else if (c == RIGHT1) {
		edright();
		pmtcol();
		return YES;
	}
	else {
		return NO;
	}
}

/*
 * command() dispatches command routines while
 * in command mode.
 */

command()
{
int v;
char c;
char args [SCRNW1];
char *argp;
int topline;
int ypos;
int oldline;
int k;
	/* command mode commands may move the current line.
	 * command mode must save the current line on entry
	 * and restore it on exit.
	 */
	edrepl();
	/* remember how the screen was drawn on entry */
	oldline=bufln();
	ypos=outgety();
	topline=oldline-ypos+1;

	/* Set disk error recovery point. */
	setjmp(DERROR);

	while(1) {
		syswait();
		outxy(0,SCRNL1);
		fmtcrlf();
		pmtmode("COMMAND:");
		getcmnd(args,0);
		fmtcrlf();
		pmtline();
		c=args [0];
		if ( (c == EDIT1) | (c==INS1) ) {
			/* redraw screen */
			if (oldline == bufln()) {
				/* get current line */
				edgetln();
				/* redraw old screen */
				bufout(topline,1,SCRNL1);
				outxy(0,ypos);
				syswait();
			}
			else {
				/* update line and screen */
				edgo(bufln(),0);
				syswait();
			}
			if (c == EDIT1) {
				return (EDITMODE);
			}
			else {
				return (INSMODE);
			}
		}
		else if (tolower(args [0]) == 'g'){
			argp=skipbl(args+1);
			if (argp [0] == EOS) {
				edgo(oldline,0); 
				return EDITMODE;
			}
			else if (number(argp,&v) == YES) {
				edgo(v,0);
				return EDITMODE;
			}
			else {
				message(">>>>> Bad Line Number. <<<<<");
			}
		}
		else if (lookup(args,"append")) {
			append(args);
		}
		else if (lookup(args,"change")) {
			change(args);
		}
		else if (lookup(args,"clear")) {
			clear();
		}
		else if (lookup(args, "copy")) {
			copy(args);
		}
		else if (lookup(args,"delete")) {
			delete(args);
		}
		else if (lookup(args,"dos")) {
			if (chkbuf() == YES) {
				/* clean up any temp files. */
				bufend();
	message(">>>>> Returning to the Disk Operating System. <<<<<");
				return (EXITMODE);
			}
		}
		else if (lookup(args,"find")) {
			if ((k = find()) >= 0) {
				edgo(bufln(),k);
				return EDITMODE;
			}
			else {
				/* get current line */
				bufgo(oldline);
				edgetln();
				/* stay in command mode */
			message(">>>>> FIND Pattern Not Found. <<<<<");
			}
		}
		else if (lookup(args, "?")) {
			help();
		}
		else if (lookup(args,"list")) {
			list(args);
		}
		else if (lookup(args,"load")) {
			load(args);
		}
		else if (lookup(args,"move")) {
			move(args);
		}
		else if (lookup(args,"name")) {
			name(args);
		}
		else if (lookup(args,"resave")) {
			resave();
		}
		else if (lookup(args,"save")) {
			save();
		}
		else if (lookup(args,"search")) {
			search(args);
		}
		else if (lookup(args,"tabs")) {
			tabs(args);
		}
		else if (lookup(args,"")) {
			;
		}
		else {
			message(">>>>> Command Not Found. <<<<<");
		}
	}
}

/* return YES if line starts with command */

lookup(line,command) char *line, *command;
{
	while(*command) {
		if (tolower(*line++) != *command++) {
			return NO;
		}
	}
	if((*line == EOS) | (*line == ' ') | (*line == TAB)) {
		return YES;
	}
	else {
		return NO;
	}
}

/* get next command into argument buffer */

getcmnd(args,offset) char *args; int offset;
{
int j,k;
char c;
	outxy(offset,outgety());
	outdeol();
	k=0;
	while ((c=syscin()) != CR) {
		if ( (c == EDIT1) | (c == INS1) ) {
			args [0]=c;
			return;
		}
		if ( (c == DEL1) | (c == LEFT1) ) {
			if (k>0) {
				outxy(offset,outgety());
				outdeol();
				k--;
				j=0;
				while (j < k) {
					outchar(args [j++]);
				}
			}
		}
		else if (c == ABT1) {
			outxy(offset,outgety());
			outdeol();
			k=0;
		}
		else if ((c != TAB) & ((c < 32)|(c == 127))) {
			/* do nothing */
			continue;
		}
		else {
			if (k+offset < SCRNW1) {
				args [k++]=c;
				outchar(c);
			}
		}
	}
	args [k]=EOS;
}


/*
	Append command.
	Load a file into main buffer at current location.
	This command does NOT change the current file name.
*/

append(args)
char *args;
{
	char buffer [MAXLEN];	/* disk line buffer */
	int file;
	int n;
	int topline;
	char locfn [SYSFNMAX];	/* local file name */

	/* Get file name which follows command. */
	if (name1(args,locfn) == ERR) {
		return;
	}
	if (locfn [0] == EOS) {
		message(">>>>> ERROR - No File Argument. <<<<<");
		return;
	}

	/* Open the new file. */
	if ((file = sysopen(locfn, 0)) == ERR) {
		message(">>>>> ERROR - Named File Not Found. <<<<<");
		return;
	}

	/* Read the file into the buffer. */
	message(">>>>> File Append Cycle in Progress, Please Wait... <<<<<");
	while ((n=sysrdln(file,buffer,MAXLEN)) >= 0) {
		if (n > MAXLEN) {
			message(
		">>>>> ERROR - One or More Lines Were Truncated. <<<<<");
			exit();
			n=MAXLEN;
		}
		bufins(buffer,n);
		bufdn();
	}

	/* Close the file. */
	sysclose(file);

	/*
		Redraw the screen so topline will be at top
		of the screen after command() does a CR/LF.
	*/
	topline=max(1,bufln()-SCRNL2);
	bufout(topline,2,SCRNL2);
	bufgo(topline);
	fmtcrlf();
	message(">>>>> File Append Cycle Completed. <<<<<");
}


/* Global change command. */

change(args)
char *args;
{
	char oldline [MAXLEN1];	/* reserve space for EOS */
	char newline [MAXLEN1];
	char oldpat [MAXLEN1];
	char newpat [MAXLEN1];
	int from, to, col, n, k;

	/* Check the arguments. */
	if (get2args(args,&from,&to) == ERR) {
		return;
	}

	/* get search and change masks into oldpat, newpat */
	fmtsout("Pattern to Search For...  ",0);
	getcmnd(oldpat,30);
	fmtcrlf();
	if (oldpat [0] == EOS) {
		return;
	}
	pmtline();
	fmtsout("Pattern to Change To....  ",0);
	getcmnd(newpat,30);
	fmtcrlf();

	/* make substitution for lines between from, to */
	message(">>>>> Global Change Cycle in Progress, Please Wait... <<<<<");
	while (from <= to) {
		if (chkkey() == YES) {
			break;
		}
		bufgo(from++);
		if (bufatbot() == YES) {
			break;
		}
		n=bufgetln(oldline,MAXLEN);
		n=min(n,MAXLEN);
		oldline [n]=EOS;

		/* '^' anchors search */
		if (oldpat [0] == '^') {
			if (amatch(oldline,oldpat+1,0) == YES) {
				k=replace(oldline,newline,
					oldpat+1,newpat,0);
				if (k == ERR) {
					return;
				}
				fmtcrlf();
				putdec(bufln(),5);
				fmtsout(newline,5);
				outdeol();
				bufrepl(newline,k);
			}
			continue;
		}

		/* search oldline for oldpat */
		col=0;
		while (col < n) {
			if (amatch(oldline,oldpat,col++) == YES){
				k=replace(oldline,newline,
					oldpat,newpat,col-1);
				if (k == ERR) {
					return;
				}
				fmtcrlf();
				putdec(bufln(),5);
				fmtsout(newline,5);
				outdeol();
				bufrepl(newline,k);
				break;
			}
		}
	}
	fmtcrlf();
	message(">>>>> Global Change Cycle Completed. <<<<<");
}


/* clear main buffer and file name */

clear()
{
	/* make sure it is ok to clear buffer */
	if (chkbuf() == YES) {
		filename [0]=0;
		pmtfile("");
		outclr();
		outxy(0,SCRNL1);
		bufnew();
		message(">>>>> The Buffer is Now Cleared. <<<<<");
	}
}


/* Block copy command. */

copy(args)
char * args;
{
	int i, k;
	int last;
	int fstart, fend, tstart;
	char buffer [MAXLEN1];

	/* Get exactly three args. */
	if (get3args(args, &fstart, &fend, &tstart) == ERR) {
		return;
	}

	/*
		The 'to' and 'from' blocks must not overlap.
		Fstart must be > 0, tstart must be >= 0.
	*/
	if ( (fend < fstart) |
	     (fstart <= 0)   |
	     (tstart < 0)    |
	     ( (tstart >= fstart) & (tstart < fend) )
	   ) {
		message(
	">>>>> ERROR - Check The Copy Line Number Parameters. <<<<<");
		return;
	}

	/* Make sure the last line exists. */
	last = max(tstart, fstart);

	bufgo(last);
	if (bufln() != last) {
		message(
	">>>>> ERROR - That Last Line Does Not Exist. <<<<<");
		return;
	}		
	
	/*
		Move the 'from block' to the 'to block'.
		Move one line at a time.
	*/
	message(">>>>> Copy Cycle in Progress, Please Wait... <<<<<");
	i = 0;
	while (i <= fend - fstart) {

		/* Go to next line of 'from block'. */
		if (fstart < tstart) {
			bufgo(fstart + i);
		}
		else {
			bufgo(fstart + i + i);
		}

		if (bufatbot()) {
			/* end of 'from block' */
			break;
		}

		/* Get line of 'from block' into buffer. */
		k = bufgetln(buffer, MAXLEN);

		/* Go to next line of 'to block'. */
		bufgo(tstart + i + 1);

		/* Insert next line into 'to block'. */
		bufins(buffer, k);

		/* Bump the count. */
		i++;
	}
	message(">>>>> Copy Cycle Completed. <<<<<");
}


/* multiple line delete command */

delete(args)
char *args;
{
	int from, to;

	/* Check the request. */
	if (get2args(args,&from,&to) == ERR) {
		return;
	}
	if (from > to) {
		return;
	}

	/* go to first line to be deleted */
	bufgo(from);

	/* delete all lines between from and to */
	message(">>>>> Delete Cycle in Progress, Please Wait... <<<<<");
	bufdeln(to-from+1);

	/* redraw the screen */
	bufout(bufln(),1,SCRNL1);
	fmtcrlf();
	message(">>>>> Delete Cycle Completed. <<<<<");
}


/* Edit mode help screen  */

edithelp()
{

message(
"Here is a list of the commands that you can use in the EDIT mode."
); message(
"Control characters (^L form feed and ^G bell) may be used in INSERT mode."
); message(
"Type ? when in COMMAND mode for a list of COMMAND mode commands."
); message(
"---------------------------------------------------------------------------"
); message(
"ESC - enter command mode from edit mode, or edit mode from insert mode"
); message(
"DEL - delete character         RET - move cursor down to start of next line"
); message(
"---------------------------------------------------------------------------"
); message(
"B - go to the beginning of the line        E - go to the end of the line"
); message(
"D - scroll down through the text           U - scroll up through the text"
); message(
"G <n> - go to line <n>                     ? - display this help screen"
); message(
"I or ^I - enter insert mode                K <let> - delete to letter <let>"
); message(
"S <let> - set cursor to letter <let>       X - eXchange text at cursor"
); message(
"---------------------------------------------------------------------------"
); message(
"^A - append (join) 2 lines (if room)       ^S - split line at cursor"
); message(
"^U - insert line above current line, enter insert mode"
); message(
"^X - undo changes to the current line      ^Z - delete the current line"
); message(
"---------------------------------------------------------------------------"
); message(
"^K - move cursor up                        ^J - move cursor down"
); message(
"^H - move cursor left                      ^L - move cursor right"
); message(
"---------------------------------------------------------------------------"
); message(
">>>>>   Type any character to continue editing...   <<<<<"
);
        pmtedit();
        syscin();
}

/* Edit mode help screen end  */




/* search all lines below the current line for a pattern
 * return -1 if pattern not found.
 * otherwise, return column number of start of pattern.
 */

find()
{
	return search1(bufln() + 1, HUGE, YES);
}


/* Command mode help screen  */

help()
{
message(
"Here is a list of commands you can use in the COMMAND mode."
); message(
"Type ? when in EDIT mode for more help."
); message(
"---------------------------------------------------------------------------"
); message(
"append <filename>      append a file after the current line"
); message(
"change <n1> <n2>       change all lines in <n1> to <n2> line range"
); message(
"clear                  reset the editor"
); message(
"copy <n1> <n2> <n3>    copy lines <n1> through <n2> after <n3>"
); message(
"delete <n1> <n2>       delete all lines in <n1> to <n2> line range"
); message(
"dos                    exit from the editor"
); message(
"find                   search for a pattern;  enter edit mode if found"
); message(
"g <n>                  enter edit mode at line <n>"
); message(
"g or ^e (^i)           enter edit (or insert) mode at the current line"
); message(
"?                      display this help screen"
); message(
"list <n1> <n2>         list lines <n1> through <n2> to the printer"
); message(
"load <filename>        replace the buffer with <filename>"
); message(
"move <n1> <n2> <n3>    move lines <n1> through <n2> after <n3>"
); message(
"name <filename>        set the filename for the save and resave commands"
); message(
"resave                 save the buffer to the already existing file"
); message(
"save                   save the buffer to a new file"
); message(
"search                 list all lines which contain a pattern"
); message(
"tabs <n>               set tabs to every <n> columns"
);

}

/* Command mode help screen end */




/* list lines to list device */

list(args)
char *args;
{
	char linebuf [MAXLEN1];
	int n;
	int from, to, line, oldline;

	/* save the buffer's current line */
	oldline=bufln();

	/* get starting, ending lines to print */
	if (get2args(args,&from,&to) == ERR) {
		return;
	}

	/* print lines one at a time to list device */
	message(">>>>> Listing Cycle in Progress, Please Wait... <<<<<");
	line=from;
	while (line <= to) {

		/* make sure prompt goes to console */
		fmtassn(NO);

		/* check for interrupt */
		if (chkkey() == YES) {
			break;
		}

		/* print line to list device */
		fmtassn(YES);

		bufgo(line++);
		if (bufatbot()) {
			break;
		}
		n=bufgetln(linebuf,MAXLEN1);
		n=min(n,MAXLEN);
		linebuf [n]=CR;
		fmtsout(linebuf,0);
		fmtcrlf();
	}

	/* redirect output to console */
	fmtassn(NO);

	/* restore cursor */
	bufgo(oldline);
	fmtcrlf();
	message(">>>>> Listing Cycle Completed. <<<<<");
}


/* Load file into buffer. */

load (args)
char *args;
{
	char buffer [MAXLEN];	/* disk line buffer */
	char locfn  [SYSFNMAX];  /* file name */
	int n;
	int topline;

	/* Get filename following command. */
	if (name1(args,locfn) == ERR) {
		return;
	}

	if (locfn [0] == EOS) {
		message(">>>>> ERROR - No File Argument. <<<<<");
		return;
	}

	/* Give user a chance to save the buffer. */
	if (chkbuf() == NO) {
		return;
	}

	/* Open the new file. */
	if (sysexists(locfn) == NO) {
		message(">>>>> ERROR - Named File Not Found. <<<<<");
		return;
	}

	message(">>>>> Load Cycle in Progress, Please Wait... <<<<<");

	/* Update file name. */
	syscopfn(locfn, filename);
	pmtfile(filename);

	/* Clear the buffer. */
	bufnew();

	/* Read the whole file into the buffer. */
	bufrfile(filename);

	/* indicate that the buffer is fresh */
	bufsaved();

	/* set current line to line 1 */
	bufgo(1);

	/*
		Redraw the screen so that topline will be
		on line 1 after command() does a CR/LF.
	*/
	topline=max(1,bufln()-SCRNL2);
	bufout(topline,2,SCRNL2);
	bufgo(topline);
}


/* Block move command. */

move(args)
char * args;
{
	int c, i, k;
	int last;
	int fstart, fend, tstart;
	char buffer [MAXLEN1];

	/* Get exactly three args. */
	if (get3args(args, &fstart, &fend, &tstart) == ERR) {
		return;
	}

	/*
		The 'to' and 'from' blocks must not overlap.
		Fstart must be > 0, tstart must be >= 0.
	*/
	if ( (fend < fstart) |
	     (fstart <= 0)   |
	     (tstart < 0)    |
	     ( (tstart >= fstart) & (tstart <= fend) )
	   ) {
		message(
	">>>>> ERROR - Check The Move Line Number Parameters. <<<<<");
		return;
	}

	/* Make sure the last line exists. */
	if (tstart < fstart) {
		last = fstart;
	}
	else {
		last = tstart;
	}

	bufgo(last);
	if (bufln() != last) {
		return;
	}		
	
	/*
		Move the 'from block' to the 'to block'.
		Move one line at a time.
	*/
	message(">>>>> Move Cycle in Progress, Please Wait... <<<<<");
	i = c = 0;
	while (c++ <= fend - fstart) {

		/* Go to next line of 'from block'. */
		bufgo(fstart + i);

		if (bufatbot()) {
			/* end of 'from block' */
			break;
		}

		/* Get line of 'from block' into buffer. */
		k = bufgetln(buffer, MAXLEN);

		/* Delete this line. */
		bufdeln(1);

		/* Go to next line of 'to block'. */
		if (tstart < fstart) {

			/* Delete leaves 'to block' numbers. */
			bufgo(tstart + i + 1);
		}
		else {

			/* Delete decreased numbers by one. */
			bufgo(tstart + i);
		}

		/* Insert next line into 'to block'. */
		bufins(buffer, k);

		/* Adjust line numbers if needed. */
		if (tstart < fstart) {

			/* Line numbers increase. */
			i++;
		}
	}
	message(">>>>> Move Cycle Completed. <<<<<");
}


/* change current file name */

name(args)
char *args;
{
	name1(args,filename);
	pmtfile(filename);
}


/* check syntax of args.
 * copy to filename.
 * return OK if the name is valid.
 */

name1(args,filename)
char *args, *filename;
{
	/* skip command */
	args=skiparg(args);
	args=skipbl(args);

	/* check file name syntax */
	if (syschkfn(args) == ERR) {
		return ERR;
	}

	/* copy filename */
	syscopfn(args,filename);
	return OK;
}


/* Save the buffer in an already existing file. */

resave()
{
	int n, oldline;

	/* Save line number. */
	oldline = bufln();

	/* Make sure file has a name. */
	if (filename [0] == EOS) {
		message(">>>>> ERROR - Resave File Not Named. <<<<<");
		return;
	}

	/* The file must exist for resave. */
	if (sysexists(filename) == NO) {
		message(
		">>>>> ERROR - Named Resave File Not Found. <<<<<");
		return;
	}

	message(">>>>> Resave Cycle in Progress, Please Wait... <<<<<");

	/* Write out the whole buffer. */
	bufwfile(filename);

	/* Indicate that the buffer has been saved. */
	bufsaved();

	/* Restore line number. */
	bufgo(oldline);
	message(">>>>> Resave Cycle Completed. <<<<<");
}


/* Save the buffer in a new file. */

save()
{
	int file, n, oldline;

	/* Save current line number. */
	oldline = bufln();

	/* Make sure the file is named. */
	if (filename [0] == EOS) {
		message(">>>>> ERROR - Save File Not Named. <<<<<");
		return;
	}

	/* File must NOT exist for save. */
	if (sysexists(filename) == YES) {
		message(
	">>>>> ERROR - Named Save File Already Exists.  To Save The <<<<<");
		message(
	">>>>> Buffer to an Existing File, Use the RESAVE Command.  <<<<<");
		return;
	}

	message(">>>>> Save Cycle in Progress, Please Wait... <<<<<");

	/* Write out the whole buffer. */
	bufwfile(filename);

	/* Indicate buffer saved. */
	bufsaved();

	/* Restore line number. */
	bufgo(oldline);
	message(">>>>> Save Cycle Completed. <<<<<");
}


/* global search command */

search(args)
char *args;
{
int from, to;

	/* Check the request. */
	if (get2args(args,&from,&to) == ERR) {
		return;
	}
	search1(from, to, NO);
}


/* search lines for a pattern.
 * if flag  ==  YES: stop at the first match.
 *                 return -1 if no match.
 *                 otherwise return column number of match.
 * if flag  ==  NO:  print all matches found.
 */

search1(from, to, flag)
int from, to, flag;
{
	char pat   [MAXLEN1];	/* reserve space for EOS */
	char line  [MAXLEN1];
	int col, n;

	/* get search mask into pat */
	fmtsout("Pattern to Search For...  ",0);
	getcmnd(pat,30);
	fmtcrlf();

	if (pat [0] == EOS) {
		return -1;	/* bug fix */
	}

	/* search all lines between from and to for pat */
	message(">>>>> Search Cycle in Progress, Please Wait... <<<<<");
	while (from <= to) {
		if (chkkey() == YES) {
			break;
		}
		bufgo(from++);
		if (bufatbot() == YES) {
			break;
		}
		n=bufgetln(line,MAXLEN);
		n=min(n,MAXLEN);
		line [n]=EOS;

		/* ^ anchors search */
		if (pat [0] == '^') {
			if (amatch(line,pat+1,0) == YES) {
				if (flag == NO) {
					fmtcrlf();
					putdec(bufln(),5);
					fmtsout(line,5);
					outdeol();
				}
				else {
					return 0;
				}
			}
			continue;
		}

		/* search whole line for match */
		col=0;
		while (col < n) {
			if (amatch(line,pat,col++) == YES) {
				if (flag == NO) {
					fmtcrlf();
					putdec(bufln(),5);
					fmtsout(line,5);
					outdeol();
					break;
				}
				else {
					return col-1;
				}
			}
		}
	}

	/* all searching is finished */
	if (flag == YES) {
		return -1;
	}
	else {
		fmtcrlf();
	}
	message(">>>>> Search Cycle Completed. <<<<<");
}

/* set tab stops for fmt routines */

tabs(args)
char *args;
{
	int n, junk;

	if (get2args(args,&n,&junk) == ERR) {
		return;
	}
	fmtset(n);
}


/* return YES if buffer may be drastically changed */

chkbuf()
{
	if (bufchng() == NO) {

		/* buffer not changed. no problem */
		return YES;
	}

	fmtsout(
	">>>>> WARNING - The Buffer Was Not Saved.  Proceed (y/n): ",0);
	pmtline();

	if (tolower(syscout(syscin())) != 'y') {
		fmtcrlf();
		message("  Command Cancelled.");
		return NO;
	}
	else {
		message("  Proceeding...");
		fmtcrlf();
		return YES;
	}
}


/* print message from a command */

message(s)
char *s;
{
	fmtsout(s,0);
	fmtcrlf();
}


/* get two arguments the argument line args.
 * no arguments imply 1 HUGE.
 * one argument implies both args the same.
 */

get2args(args,val1,val2)
char *args;
int *val1, *val2;
{
	/* skip over the command */
	args=skiparg(args);
	args=skipbl(args);

	if (*args == EOS) {
		*val1=1;
		*val2=HUGE;
		return OK;
	}

	/* check first argument */
	if (number(args,val1) == NO) {
		message(">>>>> ERROR - Bad Argument. <<<<<");
		return ERR;
	}

	/* skip over first argument */
	args=skiparg(args);
	args=skipbl(args);

	/* 1 arg: arg 2 is HUGE */
	if (*args == EOS) {
		*val2=HUGE;
		return OK;
	}

	/* check second argument */
	if (number(args,val2) == NO) {
		message(">>>>> ERROR - Bad Argument. <<<<<");
		return ERR;
	}
	else {
		return OK;
	}
}


/* Get exactly three arguments. */

get3args(args, val1, val2, val3)
char *args;
int *val1, *val2, *val3;
{
	/* Skip the command. */
	args = skiparg (args);
	args = skipbl (args);

	/* Check first arg. */
	if (*args == EOS) {
		message(">>>>> ERROR - Missing Arguments. <<<<<");
		return ERR;
	}

	if (number (args, val1) == NO) {
		message(">>>>> ERROR - Bad Argument. <<<<<");
		return ERR;
	}

	/* Skip over first argument. */
	args = skiparg(args);
	args = skipbl(args);

	/* Check second argument. */
	if (*args == EOS) {
		message(">>>>> ERROR - Missing Arguments. <<<<<");
		return ERR;
	}

	if (number(args, val2) == NO) {
		message(">>>>> ERROR - Bad Argument. <<<<<");
		return ERR;
	}

	/* Skip over third argument. */
	args = skiparg(args);
	args = skipbl(args);

	/* Check third argument. */
	if (*args == EOS) {
		message(">>>>> ERROR - Missing Arguments. <<<<<");
		return ERR;
	}

	if (number (args, val3) == NO) {
		message(">>>>> ERROR - Bad Argument. <<<<<");
		return ERR;
	}
	else {
		return OK;
	}
}


/* skip over all except EOS, and blanks */

skiparg(args) char *args;
{
	while ( (*args != EOS) & (*args!=' ') ) {
		args++;
	}
	return args;
}


/* skip over all blanks */

skipbl(args) char *args;
{
	while (*args == ' ') {
		args++;
	}
	return args;
}


/* return YES if the user has pressed any key.
 * blanks cause a transparent pause.
 */

chkkey()
{
	int c;

	c=syscstat();
	if (c == -1) {		/* bug fix */

		/* no character at keyboard */
		return NO;
	}
	else if (c == ' ') {

		/* pause.  another blank ends pause */
		pmtline();
		if (syscin() == ' ') {
			return NO;
		}
	}

	/* we got a nonblank character */
	return YES;
}


/* anchored search for pattern in text line at column col.
 * return YES if the pattern starts at col.
 */

amatch(line,pat,col)
char *line, *pat;
int col;
{
	int k;

	k=0;
	while (pat [k] != EOS) {
		if (pat [k] == line[col]) {
			k++;
			col++;
		}
		else if ((pat [k] == '?')&(line[col] != EOS)) {

			/* question mark matches any char */
			k++;
			col++;
		}
		else {
			return NO;
		}
	}

	/* the entire pattern matches */
	return YES;
}


/* replace oldpat in oldline by newpat starting at col.
 * put result in newline.
 * return number of characters in newline.
 */

replace(oldline,newline,oldpat,newpat,col)
char *oldline, *newline, *oldpat, *newpat;
int col;
{
	int k;
	char *tail, *pat;

	/* copy oldline preceding col to newline */
	k=0;
	while (k < col) {
		newline [k++]=*oldline++;
	}

	/* remember where end of oldpat in oldline is */
	tail=oldline;
	pat=oldpat;
	while (*pat++ != EOS) {
		tail++;
	}

	/* copy newpat to newline.
	 * use oldline and oldpat to resolve question marks
	 * in newpat.
	 */
	while (*newpat != EOS) {
		if (k > MAXLEN-1) {
			message(">>>>> ERROR - New Line Too Long. <<<<<");
			return ERR;
		}
		if (*newpat != '?') {
			/* copy newpat to newline */
			newline [k++]=*newpat++;
			continue;
		}

		/* scan for '?' in oldpat */
		while (*oldpat != '?') {
			if (*oldpat == EOS) {
				message(
		">>>>> ERROR - Too Many ?'s in Change Pattern. <<<<<");
				return ERR;
			}
			oldpat++;
			oldline++;
		}

		/* copy char from oldline to newline */
		newline [k++]=*oldline++;
		oldpat++;
		newpat++;
	}

	/* copy oldline after oldpat to newline */
	while (*tail != EOS) {
		if (k >= MAXLEN-1) {
			message(">>>>> ERROR - New Line Too Long. <<<<<");
			return ERR;
		}
		newline [k++]=*tail++;
	}
	newline [k]=EOS;
	return k;
}


/* abort any changes made to current line */

edabt()
{
	/* get unchanged line and reset cursor */
	edgetln();
	edredraw();
	edbegin();
	edcflag = NO;
}


/* put cursor at beginning of current line */

edbegin()
{
	editp = 0;
	outxy(0,outgety());
}


/* change editbuf[editp] to c
 * don't make change if line would become to long
 */

edchng(c) char c;
{
	char oldc;
	int k;

	/* if at right margin then insert char */
	if (editp >= editpmax) {
		edins(c);
		return;
	}

	/* change char and print length of line */
	oldc = editbuf[editp];
	editbuf[editp] = c;
	fmtadj(editbuf,editp,editpmax);
	k = fmtlen(editbuf,editp+1);
	if (k > SCRNW1) {

		/* line would become too long */
		/* undo the change */
		editbuf[editp] = oldc;
		fmtadj(editbuf,editp,editpmax);
	}
	else {

		/* set change flag, redraw line */
		edcflag = YES;
		editp++;
		edadj();
		edredraw();
	}
}

/* delete the char to left of cursor if it exists */

eddel()
{
	int k;

	/* just move left one column if past end of line */
	if (edxpos() < outgetx()) {
		outxy(outgetx()-1, outgety());
		return;
	}

	/* do nothing if cursor is at left margin */
	if (editp == 0) {
		return;
	}
	edcflag = YES;

	/* compress buffer (delete char) */
	k = editp;
	while (k < editpmax) {
		editbuf[k-1] = editbuf[k];
		k++;
	}

	/* update pointers, redraw line */
	editp--;
	editpmax--;
	edredraw();
}

/* edit the next line.  do not go to end of buffer */

eddn()
{
	int oldx;

	/* save visual position of cursor */
	oldx = outgetx();

	/* replace current edit line */
	edrepl();

	/* do not go past last non-null line */
	if (bufnrbot()) {
		return;
	}

	/* move down one line in buffer */
	bufdn();
	edgetln();

	/* put cursor as close as possible on this
	 * new line to where it was on the old line.
	 */

	editp = edscan(oldx);

	/* update screen */
	if (edatbot()) {
		edsup(bufln()-SCRNL2);
		outxy(oldx, SCRNL1);
	}
	else {
		outxy(oldx, outgety()+1);
	}
	return;
}

/* put cursor at the end of the current line */

edend()
{
	editp = editpmax;
	edadj();
	outxy(edxpos(),outgety());
}


/* start editing line n
 * redraw the screen with cursor at position p
 */

edgo(n, p) int n, p;
{
	/* replace current line */
	edrepl();

	/* go to new line */
	bufgo(n);

	/* prevent going past end of buffer */
	if (bufatbot()) {
		bufup();
	}

	/* redraw the screen */
	bufout(bufln(),1,SCRNL1);
	edgetln();
	editp = min(p, editpmax);
	outxy(edxpos(), 1);
	return;
}


/* insert c into the buffer if possible */

edins(c)
char c;
{
	int k;

	/* do nothing if edit buffer is full */
	if (editpmax >= MAXLEN) {
		return;
	}

	/* fill out line if we are past its end */
	if ((editp == editpmax) & (edxpos() < outgetx())) {
		k = outgetx() - edxpos();
		editpmax = editpmax + k;
		while (k-- > 0) {
			editbuf [editp++] = ' ';
		}
		editp = editpmax;
	}

	/* make room for inserted character */
	k = editpmax;
	while (k > editp) {
		editbuf[k] = editbuf[k-1];
		k--;
	}

	/* insert character. update pointers */
	editbuf[editp] = c;
	editp++;
	editpmax++;

	/* recalculate print length of line  */
	fmtadj(editbuf,editp-1,editpmax);
	k = fmtlen(editbuf,editp);
	if ( (k > SCRNW1) & (editp == editpmax) ) {
		/* auto-split the line (line wrap) */

		/* scan for the start of the current word */
		k = editp - 1;
		while ( (k >= 0) &
			(editbuf[k] != ' ') &
			(editbuf[k] != TAB)
		      ) {
			k--;
		}

		/* never split a word */
		if (k < 0) {
			eddel();
			return;
		}

		/* split the line at the current word */
		editp = k + 1;
		edsplit();
		edend();
	}
	else if (k > SCRNW1) {

		/* line would become too long */
		/* delete what we just inserted */
		eddel();
	}
	else {
		/* set change flag, redraw line */
		edcflag = YES;
		edredraw();
	}
}


/* join (concatenate) the current line with the one above it */

edjoin()
{
	int k, k1, k2;

	/* do nothing if at top of file */
	if (bufattop()) {
		return;
	}

	/* replace lower line temporarily */
	edrepl();

	/* get upper line into buffer */
	bufup();
	k1 = bufgetln(editbuf, MAXLEN);

	/* append lower line to buffer */
	bufdn();
	k2 = bufgetln(editbuf+k1, MAXLEN-k1);

	/* abort if the screen isn't wide enough */
	if (k1 + k2 > SCRNW1) {

		/* bug fix */
		bufgetln(editbuf,MAXLEN);
		return;
	}

	/* replace upper line */
	bufup();
	editpmax = k1 + k2;
	editp = k1 + editp;
	edadj();
	edcflag = YES;
	edrepl();

	/* delete the lower line */
	bufdn();
	bufdel();
	bufup();

	/* update the screen */
	if (edattop()) {
 		edredraw();
	}
	else {
		k = outgety() - 1;
		bufout(bufln(),k,SCRNL-k);
		outxy(0,k);
		edredraw();
	}
}


/* delete chars until end of line or c found */

edkill(c) char c;
{
	int k,p;

	/* do nothing if at right margin */
	if (editp == editpmax) {
		return;
	}
	edcflag = YES;

	/* count number of deleted chars */
	k = 1;
	while ((editp+k) < editpmax) {
		if (editbuf[editp+k] == c) {
			break;
		}
		else {
			k++;
		}
	}

	/* compress buffer (delete chars) */
	p = editp+k;
	while (p < editpmax) {
		editbuf[p-k] = editbuf[p];
		p++;
	}

	/* update buffer size, redraw line */
	editpmax = editpmax-k;
	edredraw();
}

/* move cursor left one column.
 * never move the cursor off the current line.
 */

edleft()
{
int k;

	/* if past right margin, move left one column */
	if (edxpos() < outgetx()) {
		outxy(max(0, outgetx()-1), outgety());
	}

	/* inside the line.  move left one character */
	else if (editp != 0) {
		editp--;
		outxy(edxpos(),outgety());
	}
}


/* insert a new blank line below the current line */

ednewdn()
{
	int k;

	/* make sure there is a current line and 
	 * put the current line back into the buffer.
	 */
	if (bufatbot()) {
		bufins(editbuf,editpmax);
	}
	edrepl();

	/* move past current line */
	bufdn();

	/* insert place holder:  zero length line */
	bufins(editbuf,0);

	/* start editing the zero length line */
	edgetln();

	/* update the screen */
	if (edatbot()) {

		/* note: bufln()  >= SCRNL */
		edsup(bufln()-SCRNL2);
		outxy(edxpos(),SCRNL1);
	}
	else {
		k = outgety();
		bufout(bufln(),k+1,SCRNL1-k);
		outxy(edxpos(),k+1);
	}
}


/* insert a new blank line above the current line */

ednewup()
{
int k;
	/* put current line back in buffer */
	edrepl();

	/* insert zero length line at current line */
	bufins(editbuf,0);

	/* start editing the zero length line */
	edgetln();

	/* update the screen */
	if (edattop()) {
		edsdn(bufln());
		outxy(edxpos(),1);
	}
	else {
		k = outgety();
		bufout(bufln(),k,SCRNL-k);
		outxy(edxpos(),k);
	}
}


/* move cursor right one character.
 * never move the cursor off the current line.
 */

edright()
{
	/* if we are outside the line move right one column */
	if (edxpos() < outgetx()) {
		outxy (min(SCRNW1, outgetx()+1), outgety());
	}

	/* if we are inside a tab move to the end of it */
	else if (edxpos() > outgetx()) {
		outxy (edxpos(), outgety());
	}

	/* move right one character if inside line */
	else if (editp < editpmax) {
		editp++;
		edadj();
		outxy(edxpos(),outgety());
	}

	/* else move past end of line */
	else {
		outxy (min(SCRNW1, outgetx()+1), outgety());
	}
}


/* split the current line into two parts.
 * scroll the first half of the old line up.
 */

edsplit()
{
	int p, q;
	int k;

	/* indicate that edit buffer has been saved */
	edcflag = NO;

	/* replace current line by the first half of line */
	if (bufatbot()) {
		bufins(editbuf, editp);
	}
	else {
		bufrepl(editbuf, editp);
	}

	/* redraw the first half of the line */
	p = editpmax;
	q = editp;
	editpmax = editp;
	editp = 0;
	edredraw();

	/* move the second half of the line down */
	editp = 0;
	while (q < p) {
		editbuf [editp++] = editbuf [q++];
	}
	editpmax = editp;
	editp = 0;

	/* insert second half of the line below the first */
	bufdn();
	bufins(editbuf, editpmax);

	/* scroll the screen up and draw the second half */
	if (edatbot()) {
		edsup(bufln()-SCRNL2);
		outxy(1,SCRNL1);
		edredraw();
	}
	else {
		k = outgety();
		bufout(bufln(), k+1, SCRNL1-k);
		outxy(1, k+1);
		edredraw();
	}
}


/* move cursor right until end of line or
 * character c found.
 */

edsrch(c) char c;
{
	/* do nothing if at right margin */
	if (editp == editpmax) {
		return;
	}

	/* scan for search character */
	editp++;
	while (editp < editpmax) {
		if (editbuf[editp] == c) {
			break;
		}
		else {
			editp++;
		}
	}

	/* reset cursor */
	edadj();
	outxy(edxpos(),outgety());
}


/* move cursor up one line if possible */

edup()
{
	int oldx;

	/* save visual position of cursor */
	oldx = outgetx();

	/* put current line back in buffer */
	edrepl();

	/* done if at top of buffer */
	if (bufattop()) {
		return;
	}

	/* start editing the previous line */
	bufup();
	edgetln();

	/* put cursor on this new line as close as
	 * possible to where it was on the old line.
	 */
	editp = edscan(oldx);

	/* update screen */
	if (edattop()) {
		edsdn(bufln());
		outxy(oldx, 1);
	}
	else {
		outxy(oldx, outgety()-1);
	}
	return;
}

/* delete the current line */

edzap()
{
	int k;

	/* delete the line in the buffer */
	bufdel();

	/* move up one line if now at bottom */
	if (bufatbot()) {
		bufup();
		edgetln();

		/* update screen */
		if (edattop()) {
			edredraw();
		}
		else {
			outdelln();
			outxy(0,outgety()-1);
		}
		return;
	}

	/* start editing new line */
	edgetln();

	/* update screen */
	if (edattop()) {
		edsup(bufln());
		outxy(0,1);
	}
	else {
		k = outgety();
		bufout(bufln(),k,SCRNL-k);
		outxy(0,k);
	}
}


/* ----- utility routines (not used outside this file) ----- */


/* adjust the cursor so it stays on the screen.
 * call this routine whenever the cursor could move right.
 */

edadj()
{
	while (fmtlen(editbuf, editp) > SCRNW1) {
		editp--;
	}
}


/* return true if the current edit line is being
 * displayed on the bottom line of the screen.
 */

edatbot()
{
	return outgety() == SCRNL1;
}


/* return true if the current edit line is being
 * displayed on the bottom line of the screen.
 */

edattop()
{
	return outgety() == 1;
}


/* redraw edit line from index to end of line */
/* reposition cursor */

edredraw()
{
	fmtadj(editbuf,0,editpmax);
	fmtsubs(editbuf,max(0,editp-1),editpmax);
	outxy(edxpos(),outgety());
}


/* return the x position of the cursor on screen */

edxpos()
{
	return fmtlen(editbuf, editp);
}


/* fill edit buffer from current main buffer line.
 * the caller must check to make sure the main
 * buffer is available.
 */

edgetln()
{
	int k;

	/* put cursor on left margin, reset flag */
	editp = 0;
	edcflag = NO;

	/* get edit line from main buffer */
	k = bufgetln(editbuf,MAXLEN);
	if (k > MAXLEN) {
		error("line truncated");
		editpmax = MAXLEN;
	}
	else {
		editpmax = k;
	}
	fmtadj(editbuf,0,editpmax);
}


/* Replace current main buffer line by edit buffer.
 * The edit buffer is NOT changed or cleared.
 */

edrepl()
{
	/* do nothing if nothing has changed */
	if (edcflag == NO) {
		return;
	}

	/* make sure we don't replace the line twice */
	edcflag = NO;

	/* insert instead of replace if at bottom of file */
	if (bufatbot()) {
		bufins(editbuf,editpmax);
	}
	else {
		bufrepl(editbuf,editpmax);
	}
}


/* set editp to the largest index such that
 * buf[editp] will be printed <= xpos
 */

edscan(xpos) int xpos;
{
	editp = 0;
	while (editp < editpmax) {
		if (fmtlen(editbuf,editp) < xpos) {
			editp++;
		}
		else {
			break;
		}
	}
	return editp;
}


/* scroll the screen up.  topline will be new top line */

edsup(topline) int topline;
{
	if (outhasup() == YES) {

		/* hardware scroll */
		outsup();

		/* redraw bottom line */
		bufout(topline+SCRNL2,SCRNL1,1);
	}
	else {

		/* redraw whole screen */
		bufout(topline,1,SCRNL1);
	}
}


/* scroll screen down.  topline will be new top line */

edsdn(topline) int topline;
{
	if (outhasdn() == YES) {

		/* hardware scroll */
		outsdn();

		/* redraw top line */
		bufout(topline,1,1);
	}
	else {

		/* redraw whole screen */
		bufout(topline,1,SCRNL1);
	}
}


/*
	Direct output from this module to either the console or
	the list device.
*/

fmtassn(listflag) int listflag;
{
	if (listflag==YES) {
		fmtdev=YES;
		fmtwidth=LISTW;
	}
	else {
		fmtdev=NO;
		fmtwidth=SCRNW1;
	}
}


/*
	Adjust fmtcol[] to prepare for calls on
	fmtout() and fmtlen().

	NOTE:  this routine is needed as an efficiency
	       measure.  Without fmtadj(), calls on
	       fmtlen() become too slow.
*/

fmtadj(buf,minind,maxind) char *buf; int minind,maxind;
{
int k;
	/* line always starts at left margin */
	fmtcol[0]=0;
	/* start scanning at minind */
	k=minind;
	while (k<maxind) {
		fmtcol[k+1]=fmtcol[k]+fmtlench(buf[k],fmtcol[k]);
		k++;
	}
}


/* return column at which at which buf[i] will be printed */

fmtlen(buf,i) char *buf; int i;
{
	return(fmtcol[i]);
}


/*
	Print buf[i] ... buf[j-1] on current device so long as
	characters will not be printed in last column.
*/

fmtsubs(buf,i,j) char *buf; int i, j;
{
int k;
	if (fmtcol[i]>=fmtwidth) {
		return;
	}
	outxy(fmtcol[i],outgety());	/* position cursor */
	while (i<j) {

		if (fmtcol[i+1]>fmtwidth) {
			break;
		}
		fmtoutch(buf[i],fmtcol[i]);
		i++;
	}
	outdeol();	/* clear rest of line */
}


/*
    Print string which ends with CR or EOS to current device.
    Truncate the string if it is too long.
*/

fmtsout(buf,offset) char *buf; int offset;
{
char c;
int col,k;
	col=0;
	while (c=*buf++) {
		if (c==CR) {
			break;
		}
		k=fmtlench(c,col);
		if ((col+k+offset)>fmtwidth) {
			break;
		}
		fmtoutch(c,col);
		col=col+k;
	}
}


/* Return length of char c at column col. */

fmtlench(c,col) char c; int col;
{
	if (c==TAB) {
		/* tab every fmttab columns */
		return(fmttab-(col%fmttab));
	}
	else if (c<32) {
		/* control char */
		return(2);
	}
	else {
		return(1);
	}
}


/*
	Output one character to current device.
	Convert tabs to blanks.
*/

fmtoutch(c,col) char c; int col;
{
int k;
	if (c==TAB) {
		k=fmtlench(TAB,col);
		while ((k--)>0) {
			fmtdevch(' ');
		}
	}
	else if (c<32) {
		fmtdevch('^');
		fmtdevch(c+64);
	}
	else {
		fmtdevch(c);
	}
}


/* Output character to current device. */

fmtdevch(c) char c;
{
	if (fmtdev==YES) {
		syslout(c & 127);
	}
	else {
		outchar(c & 127);
	}
}


/* Output a CR and LF to the current device. */

fmtcrlf()
{
	if (fmtdev==YES) {
		syslout(CR);
		syslout(LF);
	}
	else {
		/* kludge: this should be in out module */
		/* make sure out module knows position */
		outxy(0,SCRNL1);
		syscout(CR);
		syscout(LF);
	}
}


/* Set tabs at every n columns. */

fmtset(n) int n;
{
	fmttab=max(1,n);
}


/*
Return the current coordinates of the cursor.
*/

outgetx()
{
	return(outx);
}

outgety()
{
	return(outy);
}

/*
Output one printable character to the screen.
*/

outchar(c) char c;
{
	syscout(c);
	outx++;
	return(c);
}

/* CHANGE HERE (RDK) */

/*
Position cursor to position x,y on screen.
0,0 is the top left corner.
*/

outxy(x,y) int x,y;
{
	outx=x;
	outy=y;
	syscout(27);
/* ADM-31 or TELEVIDEO use ESC-= y+32 x+32 for cursor positioning (RDK) */
/* BEEHIVE B100 uses ESC-F y+32 x+32 for cursor positioning (RDK) */
/* INFOTON I-100 uses ESC-f x+32 y+32 for cursor positioning (RDK) */
/* HEATH H-19 Heath Mode uses ESC-Y y+32 x+32 for cursor positioning (RDK) */
	syscout('Y');
	syscout(y+32);
	syscout(x+32);
}

/*
Erase the entire screen.
Make sure the rightmost column is erased.
*/

outclr()
{
/* original routine that will kludge just about any type
   of clear screen for any terminal (RDK) */

/* commented out for INFOTON use (RDK) .....
int k;
	k=0;
	while (k<SCRNL) {
		outxy(0,k++);
		outdelln();
	}
 .....end comment out */

/* ADM-31 TERMINALS use an ESC-* sequence (RDK) */
/* BEEHIVE TERMINALS REQUIRE ESC-H ESC-E SEQUENCE (RDK) */
/* INFOTON TERMINALS USE JUST A CTRL-L (12D) SEQUENCE (RDK) */
/* TELEVIDEO 920 uses a home (CTRL-^)(30D)
   followed by a cleos (ESC-Y) sequence (RDK) */
/* HEATH H-19 uses ESC-H ESC-J sequence (RDK) */

        syscout(27);
        syscout('H');
        syscout(27);
        syscout('J');
/* with a few nulls for delay timing (RDK) */
/* with a few nulls for delay timing (RDK) */
/* with a few nulls for delay timing (RDK) */
/* with a few nulls for delay timing (RDK) */
/* with a few nulls for delay timing (RDK) */
        syscout(0);
        syscout(0);
        syscout(0);
        syscout(0);
        syscout(0);
        syscout(0);

	outxy(0,0);
}

/*
Delete the line on which the cursor rests.
Leave the cursor at the left margin.
*/

outdelln()
{
	outxy(0,outy);
	outdeol();
}

/*
Delete to end of line.
Assume tke last column is blank.
HEATH H-19 and INFOTON I-100 and BEEHIVE B100 use ESC-K
ADM-31 and TELEVIDEO use ESC-T
*/

outdeol()
{
	syscout(27);
	syscout('K');
}

/*
Return yes if terminal has indicated hardware scroll.
*/

outhasup()
{
	return(YES);
}

outhasdn()
{
/* ADM-31, TELEVIDEO, and INFOTON terminals have down scroll (RDK) */
/* comment out one or the other here ..... */
	return(YES);

/* BEEHIVE doesnt have the capability so use NO feature (RDK) */
/*	return(NO); */
}

/*
Scroll the screen up.
Assume the cursor is on the bottom line.
*/

outsup()
{
	/* auto scroll */
	outxy(0,SCRNL1);
	syscout(10);
}

/*
Scroll screen down.
Assume the cursor is on the top line.
*/

outsdn()
{
/* ADM-31 and TELEVIDEO use ESC-E PLUS DELAYS TO SCROLL UP.
   INFOTON USES ESC-L PLUS DELAYS TO SCROLL UP.
   HEATH H-19 uses ESC-H ESC-I plus delays to scroll up. (RDK) */
/* BEEHIVE doesnt use it so just comment it out..... */

int k;
	outxy(0,0);
	syscout(27);
	syscout('H');
	syscout(27);
	syscout('I');
	k=0;
	while (k<100) {
                ++k;
	}

}


/* Initialize the mode and file name. */

pmtclr()
{
	pmtln [0] = 0;
	pmtfn [0] = 0;
}


/*
	Put error message on prompt line.
	Wait for response.
*/

pmtmess(s1,s2)
char *s1, *s2;
{
	int x,y;

	/* save cursor */
	x=outgetx();
	y=outgety();
	outxy(0,0);
	/* make sure line is correct */
	outdelln();
	pmtline1();
	pmtcol1(x);
	/* output error message */
	fmtsout(s1,outgetx());
	fmtsout(s2,outgetx());
	/* wait for input from console */
	syscin();
	/* redraw prompt line */
	pmtline1();
	pmtcol1(x);
	pmtfile1(pmtfn);
	pmtmode1(pmtln);
	/* restore cursor */
	outxy(x,y);
}


/* Write new mode message on prompt line. */

pmtmode(s)
char *s;
{
	int x,y;		/* save cursor on entry */

	/* save cursor */
	x=outgetx();
	y=outgety();

	/* redraw whole line */
	outxy(0,0);
	outdelln();
	pmtline1();
	pmtcol1(x);
	pmtfile1(pmtfn);
	pmtmode1(s);
	/* restore cursor */
	outxy(x,y);
}


/* Update file name on prompt line. */

pmtfile(s)
char *s;
{
	int x, y;

	/* save cursor */
	x=outgetx();
	y=outgety();
	/* update whole line */
	outxy(0,0);
	outdelln();
	pmtline1();
	pmtcol1(x);		/* bug fix -- 1/28/82 */
	pmtfile1(s);
	pmtmode1(pmtln);
	/* restore cursor */
	outxy(x,y);
}


/* Change mode on prompt line to EDIT: */

pmtedit()
{
	pmtmode("EDIT:");
}


/* Update line and column numbers on prompt line. */

pmtline()
{
	int x,y;

	/* save cursor */
	x=outgetx();
	y=outgety();
	/* redraw whole line */
	outxy(0,0);
	outdelln();
	pmtline1();
	pmtcol1(x);
	pmtfile1(pmtfn);
	pmtmode1(pmtln);
	/* restore cursor */
	outxy(x,y);
}


/* Update just the column number on prompt line. */

pmtcol()
{
	int x,y;

	/* save cursor */
	x=outgetx();
	y=outgety();
	/* update column number */
	pmtcol1(x);
	/* update cursor */
	outxy(x,y);
}


/* Update mode.  call getcmnd() to write on prompt line. */

pmtcmnd(mode,buffer)
char *mode, *buffer;
{
	int x,y;

	/* save cursor */
	x=outgetx();
	y=outgety();
	pmtmode1(mode);
	/* user types command on prompt line */
	getcmnd(buffer,outgetx());

	/* restore cursor */
	/* --- new ---
	outxy(x,y);
	----- end comment out */

}


/* Update and print mode. */

pmtmode1(s)
char *s;
{
	int i;

	outxy(40,0);
	fmtsout(s,40);
	i=0;
	while (pmtln[i++]=*s++) {
		;
	}
}


/* Print the file name on the prompt line. */

pmtfile1(s)
char *s;
{
	int i;

	outxy(25,0);
	if (*s==EOS) {
		fmtsout("no file",25);
	}
	else {
		fmtsout(s,25);
	}
	i=0;
	while (pmtfn[i++]=*s++) {
		;
	}
}


/* Print the line number on the prompt line. */

pmtline1()
{
	outxy(0,0);
	fmtsout("LINE: ",0);
	putdec(bufln(),5);
}


/* Print column number of the cursor. */

pmtcol1(x)
int x;
{

	/* comment out all the following code if you do not
	 * want column numbers to be drawn on the screen.
	 * some people complain of too much flicker.
	 */

	outxy(12,0);
	fmtsout("COLUMN: ",12);
	/* kludge fix to keep column number > 0 (RDK) */
	x=x+1;
	putdec(x,3);
	/* restore original column number for internal use (RDK) */
	x=x-1;
}


/*	Initialize the system module. */

sysinit()
{
	sysnl    = 0;
	sysccnt  = 0;
	sysrcnt  = 0;
	syslastc = 0;
}


/*	Save info for interrupted screen update. */

sysintr(systl, systy, sysn)
int systl, systy, sysn;
{
	systopl = systl;
	systopy = systy;
	sysnl   = max(0,sysn);
}


/*
	Return -1 if no character is ready from the keyboard.
	Otherwise, return the character.

	This routine handles typeahead and the repeat key.
*/

syscstat()
{
	int c, i;

	/* Always look for another character. */
	c = bdos(6,-1);

	if ( (c == REP1) & (syslastc != 0) ) {
		sysrcnt = max(1, 2*sysrcnt);
		i = 0;
		while ( (i++ < sysrcnt) & (sysccnt < MAXLEN) ) {
			syscbuf [sysccnt++] = syslastc;
		}
	}
	else if (c != 0) {
		syslastc = c;
		sysrcnt  = 0;
		syscbuf [sysccnt++] = c;
	}

	if (sysccnt > 0) {
		return syscbuf [--sysccnt];
	}
	else {
		return -1;
	}
}


/*
	Wait for next character from the console.
	Do not echo it.
	This routine prints any waiting lines if there is no input ready.
*/

syscin()
{
	int c;

	while ((c=syscstat()) == -1) {

		/* Output queued ? */
		if (sysnl > 0) {
			bufout(systopl, systopy, sysnl);
		}
	}
	return c;
}


/*
	Wait for all console output to be finished.
*/

syswait()
{
	while (sysnl > 0) {
		bufout(systopl, systopy, sysnl);
	}
}


/* Print character on the console. */

syscout(c)
char c;
{
	bdos(6,c);
	return(c);
}


/* Print one character on the printer. */

syslout(c) char c;
{
	bdos(5,c);
	return(c);
}


/* Close a file which was opened by sysopen() or syscreat(). */

sysclose(file)
int file;
{
	return close(file);
}


/*
	Create a file.  Erase it if it exists.
	Leave the file open for read/write access.
*/

syscreat(filename)
char * filename;
{
	return creat(filename);
}


/* Return YES if the file exists. */

sysexists(filename)
char * filename;
{
	int file;

	if ((file = open(filename, 0)) != ERROR) {
		close(file);
		return YES;
	}
	else {
		return NO;
	}
}


/*
	Open a file which already exists.
	Mode 0 -- read only.
	Mode 1 -- write only.
	Mode 2 -- read/write.
*/

sysopen(name, mode)
char *name;
int mode;
{
	/* Kludge:  set count for sysgetc(). */
	if (mode == 0) {
		sysincnt = 128;
	}

	return open(name, mode);
}


/*
	Read next line from a file.
	End the line with a zero byte.
	Only one file at a time may use this routine.
*/

sysrdln(file, buffer, maxlength)
int file;
char *buffer;
int maxlength;
{
	int c, count;

	count = 0;
	while(1) {
		c = sysgetc(file);
		if (c == CR) {
			continue;
		}
		else if (c == CPMEOF) {
			buffer [count = EOS];
			return ERROR;
		}
		else if (c == LF) {
			buffer [count] = EOS;
			return count;
		}
		else if (count < maxlength - 1) {
			buffer [count++] = c;
		}
		else {
			count++;
		}
	}
}


/*
	Get one character from the input file.
	Only one file at a time may use this routine.
*/

sysgetc(file)
int file;
{
	int n;

	if (sysincnt == 128) {	
		n = read(file, sysinbuf, 1);
		if (n == ERROR) {
			diskerror("FILE READ ERROR");
			return CPMEOF;
		}
		else if (n == 0) {
			/* End of file. */
			return CPMEOF;
		}
		else {
			sysincnt = 0;
		}
	}
	return sysinbuf [sysincnt++];
}


/*
	Read one block (READSIZE sectors) into the buffer.
*/

sysread(file, buffer)
int file;
char * buffer;
{
	return read(file, buffer, READSIZE);
}


/*	Write n sectors from the buffer to the file. */

syswrite(file, buffer, n)
int file;
char * buffer;
int n;
{
	return write(file, buffer, n);
}


/* Seek to a specified block of an open file. */

sysseek(file, block)
int file, block;
{
	return seek(file, block * READSIZE, 0);
}


/* Remove the file from the file system. */

sysunlink(filename)
char * filename;
{
	return unlink(filename);
}


/* Check file name for syntax. */

syschkfn(args) char *args;
{
	return(OK);
}


/* Copy file name from args to buffer. */

syscopfn(args,buffer) char *args, *buffer;
{
int n;
	n=0;
	while (n<(SYSFNMAX-1)) {
		if (args[n]==EOS) {
			break;
		}
		else {
			buffer[n]=args[n];
			n++;
		}
	}
	buffer[n]=EOS;
}


/*	Return larger of two numbers.	*/

max(a, b)
int a, b;
{
	if (a >= b) {
		return a;
	}
	else {
		return b;
	}
}


/*	Return smaller of two numbers.	*/

min(a, b)
int a, b;
{
	if (a <= b) {
		return a;
	}
	else {
		return b;
	}
}


/*	Return the absolute value of a number.	*/

abs(n)
int n;
{
	if (n < 0) {
		return -n;
	}
	else {
		return n;
	}
}


/*	Convert a character to lower case.	*/

tolower(c)
char c;
{
	if ( (c >= 'A') & (c <= 'Z') ) {
		return c - 'A' + 'a';
	}
	else {
		return c;
	}
}


/*
	return: is first token in args a number ?
	return value of number in *val
*/

number(args,val) char *args; int *val;
{
char c;
	c=*args++;
	if ((c<'0')|(c>'9')) {
		return(NO);
	}
	*val=c-'0';
	while (c=*args++) {
		if ((c<'0')|(c>'9')) {
			break;
		}
		*val=(*val*10)+c-'0';
	}
	return(YES);
}


/* Convert character buffer to numeric. */

ctoi(buf,index) char *buf; int index;
{
int k;
	while ( (buf[index]==' ') |
		(buf[index]==TAB) ) {
		index++;
	}
	k=0;
	while ((buf[index]>='0')&(buf[index]<='9')) {
		k=(k*10)+buf[index]-'0';
		index++;
	}
	return(k);
}


/*
	Put decimal integer n in field width >= w.
	Left justify the number in the field.
*/

putdec(n,w) int n,w;
{
char chars[10];
int i,nd;
	nd=itoc(n,chars,10);
	i=0;
	while (i<nd) {
		syscout(chars[i++]);
	}
	i=nd;
	while (i++<w) {
		syscout(' ');
	}
}


/* Convert integer n to character string in str. */

itoc(n,str,size) int n; char *str; int size;
{
int absval;
int len;
int i,j,k;
	absval=abs(n);
	/* generate digits */
	str[0]=0;
	i=1;
	while (i<size) {
		str[i++]=(absval%10)+'0';
		absval=absval/10;
		if (absval==0) {
			break;
		}
	}
	/* generate sign */
	if ((i<size)&(n<0)) {
		str[i++]='-';
	}
	len=i-1;
	/* reverse sign, digits */
	i--;
	j=0;
	while (j<i) {
		k=str[i];
		str[i]=str[j];
		str[j]=k;
		i--;
		j++;
	}
	return(len);
}


/* System error routine. */

syserr(s) char *s;
{
	pmtmess("SYSTEM ERROR: ",s);
}


/* User error routine. */

error(s) char *s;
{
	pmtmess("ERROR: ",s);
}


/* Return YES if at bottom of buffer (past the last line). */

bufatbot()
{
	return (bline > bmaxline);
}


/* Return YES if at top of buffer. */

bufattop()
{
	return (bline == 1);
}


/* Return YES if the buffer has been changed. */

bufchng()
{
	return bcflag;
}


/* Move towards end of buffer. */

bufdn()
{
	/* The call to bufgofw() instead of bufgo()
	 * is made purely to increase speed slightly.
	 */
	if (bufatbot()) {
		return;
	}
	else {
		bline++;
		bufgofw();
	}
}


/* Clean up any temporary files. */

bufend()
{
	sysunlink(DATAFILE);
}


/*
	Go to line n.
	Set bslot, bline, bstart.
*/

bufgo(n)
int n;
{
	int distance, oldline;

	/* Put the request in range. */
	oldline = bline;
	bline = min (n, bmaxline + 1);
	bline = max (1, bline);
	distance = bline - oldline;

	if (distance == 0) {

		/* We are already at the requested line. */
		return;
	}
	else if (distance == 1) {

		/* Go forward from here. */
		bufgofw();
		return;
	}
	else if (distance == -1) {

		/* Go back from here. */
		bufgobk();
		return;
	}
	else if (distance > 0) {
		if ( bline >
		     oldline + ((bmaxline - oldline) / 2)
		   ) {

			/* Search back from end of file. */
			swapin(btail, &bslot);
			bstart =
			    1 + bmaxline - dlines [bslot];
			bufgobk();
			return;
		}
		else {

			/* Search forward from here. */
			bufgofw();
			return;
		}
	}
	else {
		if (bline < oldline / 2) {

			/* Search from start of file. */
			swapin(bhead, &bslot);
			bstart = 1;
			bufgofw();
			return;
		}
		else {

			/* Search back from here. */
			bufgobk();
			return;
		}
	}
}


/*
	Search backwards from block for bline.
	The starting line number of the block is bstart.
	Set bslot and bstart.
 */

bufgobk ()
{
	int diskp;

	if ( (bslot == ERROR) |
	     (bstart < 1)     | (bstart > bmaxline) |
	     (bline  < 1)     | (bline  > bmaxline + 1)
	   ) {
		exit();
	}

	/* Scan backward for the proper block. */
	while (bstart > bline) {

		/* Get the previous block in memory. */
		diskp = dback [bslot];
		if (diskp == ERROR) {
			exit();
		}
		swapin(diskp, &bslot);

		/* Calculate the start of the next block. */
		bstart = bstart - dlines [bslot];
		if (bstart <= 0) {
			exit();
		}
	}
}


/*
	Search forward from parcel par for line n.
	Set bslot and bstart.
 */

bufgofw ()
{
	int diskp;

	/* The last line is always null. */
	if (bufatbot()) {
		return;
	}

	if ( (bslot == ERROR) | (bstart < bstart) |
	     (bstart < 1)     | (bstart > bmaxline) |
	     (bline  < 1)     | (bline  > bmaxline + 1)
	   ) {
		exit();
	}

	/* Scan forward to the proper block. */
	while (bstart + dlines [bslot] <= bline) {

		/* Get the start of the next block. */
		bstart = bstart + dlines [bslot];

		/* Swap in the next block. */
		diskp = dnext [bslot];
		if ((diskp == ERROR) | (bstart > bmaxline)){
			exit();
		}
		swapin(diskp, &bslot);
	}
}


/* Return the current line number. */

bufln()
{
	return bline;
}


/* Initialize the buffer module. */

bufnew()
{
	int i;
	char * static;

	/*
		Initialize bdatafd on the first call
		to this routine.  A kludge is required
		because small-C has neither real static
		variables nor initializers.
	*/

	static = "";
	if (*static == 0) {
		*static = 1;
		bdatafd = ERROR;
	}
		
	/* The free list is empty. */
	bfree = ERROR;

	/* Free all slots. */
	i = 0;
	while (i < NSLOTS) {
		dstatus [i] = FREE;
		dlru    [i] = i;
		ddiskp  [i] = ERROR;
		i++;
	}

	/* Allocate the first slot. */
	bslot = bhead = btail = 0;
	bmaxdisp = 1;
	ddiskp  [bslot] = 0;
	dstatus [bslot] = DIRTY;
	dback   [bslot] = dnext [bslot] = ERROR;

	/* The first slot is empty. */
	dlines [bslot] = 0;
	davail [bslot] = BUFFSIZE;
	
	/* Make sure temp file is erased. */
	if (bdatafd != ERROR) {
		sysclose(bdatafd);
		bdatafd = ERROR;
		sysunlink(DATAFILE);
	}

	/* Set the current and last line counts. */
	bline = 1;
	bmaxline = 0;
	bstart = 1;

	/* Indicate that the buffer has not been changed. */
	bcflag = NO;

	/* Do not erase the work file on a disk error. */
	bfatal = NO;
}


/* Return YES if buffer is near the bottom line */

bufnrbot()
{
	return (bline >= bmaxline);
}


/* Put nlines lines from buffer starting with line topline at
 * position topy of the screen.
 */

bufout(topline, topy, nlines)
int topline, topy, nlines;
{
	int l, x, y;

	x = outgetx();
	y = outgety();
	l = bline;
	while (nlines > 0) {
		outxy(0, topy++);
		bufoutln(topline++);
		nlines--;
		sysintr(topline, topy, nlines);
		break;
	}
	outxy(x,y);
	bufgo(l);
}
	

/* Print one line on screen. */

bufoutln(line)
int line;
{
	char buffer [MAXLEN1];
	int n;

	bufgo(line);
	if (bufatbot()) {
		outdeol();
	}
	else {
		n = bufgetln(buffer, MAXLEN);
		n = min(n, MAXLEN);
		buffer [n] = CR;
		fmtsout(buffer, 0);
		outdeol();
	}
}



/* Replace current line with the line that p points to.
 * The new line is of length n.
 */

bufrepl(line, n)
char line [];
int n;
{
	/* Do not replace null line.  Just insert. */
	if (bufatbot()) {
		bufins(line, n);
		return;
	}
	bufdel();
	bufins(line, n);
}


/* Indicate that the file has been saved. */

bufsaved()
{
	bcflag = NO;
}


/* Move towards the head of the file. */

bufup()
{
	/* The call to bufgobk() instead of bufgo()
	 * is made purely to increase speed slightly.
	 */

	if (bufattop()) {
		return;
	}
	else {
		bline--;
		bufgobk();
	}
}


/*
	Scan for the start of the current line.
	Return *count  = the # of characters in the line.
	Return *prefix = the # of characters before the line.
*/

bscan(pointer, count, prefix)
int	*pointer;	/* Kludge -- should be char ** */
int	*count;
int	*prefix;
{
	char	*cp;
	int	i, limit, count1;

	/* The last line is always null. */
	if (bufatbot()) {
		*prefix  = BUFFSIZE - davail [bslot];
		*pointer = dataaddr(bslot) + *prefix;
		*count   = 0;
		return;
	}

	/* Limit is the starting line # of the next block. */
	limit = bstart + dlines [bslot];

	/* Point pointer at the start of the first line. */
	cp = dataaddr (bslot);

	/* Keep track of characters before the line. */
	*prefix = 0;

	i = bstart;
	while (1) {
		
		if (i == limit) {
			exit();
		}

		/* Get length of the line. */
		count1   = bgetnum(cp);

		if ( (count1 < 0) | (*prefix >= BUFFSIZE) ) {
			exit();
		}

		/* At the requested line? */
		if (i == bline) {
			break;
		}

		/* Step over the count and the line. */
		cp      = cp + count1 + 2;		
		*prefix = *prefix + count1 + 2;

		i++;
	}

	/* Point past the line length. */
	cp = cp + 2;

	/* Set values in the calling routines. */
	*pointer = cp;
	*count = count1;
}

/*
	Get and put a 2-byte line number.
	These are machine independent substitutes for casts:
*/

bgetnum(cp)
char *cp;
{
	/*	simulate:  ip = (*int) cp; return *ip;	*/

	return (*cp << 8) | *(cp+1);
}

bputnum(cp, num)
char *cp;
int num;
{
	/*	simulate:  ip = (*int) cp; *ip = num;	*/

	*cp     = (num & (255 << 8)) >> 8;
	*(cp+1) = num & 255;
}


/* Delete the current line. */

bufdel()
{
	char	*p, *p1, *q;
	int	length, junk;
	int	endp;
	int	back, current, next;

	/* Do nothing if the buffer is empty. */
	if (bufatbot()) {
		return;
	}

	/* The current block will become dirty. */
	isdirty(bslot);
	bcflag = YES;

	/*
		Point p  at the line # of the deleted line.
		Point p1 at the line # of the following line.
		Point q  passed the last byte of the block.
	*/

	bscan(&p, &length, &junk);
	endp = BUFFSIZE - davail [bslot];
	q  = dataaddr (bslot) + endp;
	p1 = p + length;
	p  = p - 2;

	/* Compress the block. */
	while (p1 != q) {
		*p++ = *p1++;
	}

	/* Adjust the avail and line counts in the block. */
	davail [bslot] = davail [bslot] + length + 2;
	dlines [bslot]--;

	/* Decrease the overall line count. */
	bmaxline--;

	/* Point to the previous, current and next blocks. */
	back    = dback  [bslot];
	current = ddiskp [bslot];
	next    = dnext  [bslot];

	/* Move to the correct block. */

	if ( (next == ERROR) & (dlines [bslot] == 0) ) {
		/* The last block is empty.  Move back. */
		if (back != ERROR) {
			swapin(back, &bslot);
			bstart = bmaxline -
					dlines [bslot] + 1;
		}
	}

	else if (bstart + dlines [bslot] == bline) {
		/* The line moves to the next block. */
		if (next != ERROR) {
			swapin(next, &bslot);
			bstart = bline;
		}
	}

	/*
		Combine blocks if possible.
		This is tricky code because combine() causes
		side effects.  Do not try to pre-compute the
		arguments for the second call to combine().
	*/

	combine(dback  [bslot], ddiskp [bslot]);
	combine(ddiskp [bslot], dnext  [bslot]);


	/* ----- check code ----- */
}


/* Delete n lines starting at the current line. */

bufdeln(n)
int n;
{
	int i;

	i = 0;
	while( (i < n) & (bufatbot() == NO) ) {
		bufdel();
		i++;
	}
}


/*
	Copy the current line from the buffer to line [].
	The size of line [] is linelen.
	Return k = the length of the line.
	If k > linelen then truncate k - linelen characters.
 */

bufgetln(line, linelen)
char	*line;
int	linelen;
{
	int	count, i, junk, limit;
	char	*cp;

	/* Return null line at the bottom of the buffer. */
	if (bufatbot()) {
		line [0] = CR;
		return 0;
	}

	/* Scan forward to start of the line. */
	bscan(&cp, &count, &junk);

	/* Copy line to buffer */
	limit = min(count, linelen);
	i = 0;
	while (i < limit) {
		line [i] = cp [i];
		i++;
	}

	/* End with zero. */
	line [min (count, linelen - 1)] = EOS;

	/* Return the number of characters in the line. */
	return count;
}


/*
	Insert line before the current line.  Thus, the line
	number of the current line does not change.  The line
	ends with a zero byte but not with a CR.

	This is fairly crude code, as it can end up splitting
	the current block into up to three blocks.  However,
	the combine() routine does an effective job of keeping
	the size of the average block big enough.
*/

bufins(line, linelen)
char line [];
int linelen;
{
	char	*p, *q;
	int	junk;
	int	length1;    /* # of chars before break point */
	int	length2;    /* # of chars after  break point */
	int	i;

	if (linelen > BUFFSIZE) {
		exit();
	}

	/* Point p at the start of the current line. */
	bscan(&p, &junk, &length1);
	p = p - 2;

	/* Calculate # of characters after break point. */
	length2 = BUFFSIZE - davail [bslot] - length1;

	/* The current slot is now dirty. */
	isdirty(bslot);

	/* Allow for 2-byte line length. */
	if (length1 + linelen + 2 > BUFFSIZE) {

		splitblock(length1, length2, YES);
		length1 = 0;
		length2 = BUFFSIZE - davail [bslot];
	}

	/*
		At this point we know that the new line will
		fit on the current block at position length1.
	*/

	if (linelen + 2 > davail [bslot]) {

		splitblock(length1, length2, NO);

		/* Copy line to the end of the old block. */
		p = dataaddr (bslot) + length1;
		i = 0;
		while (i < linelen) {
			p [2 + i] = line [i];
			i++;
		}

		/* Insert line length. */
		bputnum(p, linelen);

		/* Adjust header. */
		davail[bslot] = davail[bslot]-linelen-2;
		dlines[bslot]++;
	}
	else {
		/* Make a hole in the block. */
		p = dataaddr (bslot) + length1;
		q = p + linelen + 2;

		i = length2 - 1;
		while (i >= 0) {
			q [i] = p [i];
			i--;
		}

		/* Put the line length in the hole. */
		bputnum(p, linelen);

		/* Copy the new line into the hole. */
		p = p + 2;
		i = 0;
		while (i < linelen) {
			p [i] = line [i];
			i++;
		}

		/* Adjust the header. */
		davail[bslot] = davail[bslot]-linelen-2;
		dlines[bslot]++;
	}
		
	/*
		Special case: inserting a null line at the
	 	end of the file is not a significant change.
	 */

	if ( (linelen != 0) | (bufnrbot() == 0) ) {
		bcflag = YES;
	}

	/* Bump the number of the last line. */
	bmaxline++;

	/* ----- check code ----- */
}


/*
	Combine two blocks into one if possible.
	Make the new block the current block.
 */

combine(diskp1, diskp2)
int diskp1, diskp2;
{
	char		*p1,	*p2;
	int		slot1,	slot2,	slot3;
	int		len1,	len2;
	int		i;

	/* Make sure the call makes sense. */
	if ( (diskp1 == ERROR) | (diskp2 == ERROR) ) {
		return;
	}

	/* Get the two blocks. */
	swapin(diskp1, &slot1);
	swapin(diskp2, &slot2);

	if ( (dnext [slot1] != diskp2) |
	     (dback [slot2] != diskp1)
	   ) {
		exit();
	}
	
	/* Do nothing if the blocks are too large. */
	len1 = BUFFSIZE - davail [slot1];
	len2 = BUFFSIZE - davail [slot2];

	if ( (len1 > BUFFSIZE) | (len2 > BUFFSIZE) ) {
		exit();
	}

	if (len1 + len2 > BUFFSIZE) {
		return;
	}

	/* Copy buffer 2 to end of buffer 1. */
	p1 = dataaddr (slot1) + len1;
	p2 = dataaddr (slot2);

	i = 0;
	while (i < len2) {
		p1 [i] = p2 [i];
		i++;
	}

	/* Both blocks are now dirty. */
	isdirty(slot1);
	isdirty(slot2);

	/* Adjust the back pointer of the next block. */
	if (dnext [slot2] != ERROR) {
		swapin(dnext [slot2], &slot3);
		dback [slot3] = ddiskp [slot1];
		isdirty(slot3);
	}

	/*
		Adjust the current block if needed.
	 	The value of bstart must be decremented
	 	by the OLD value of dlines [slot1].
	 */

	if (bslot == slot2) {
		bslot  = slot1;
		bstart = bstart - dlines [slot1];
	}

	/* Adjust the header for block 1. */
	dlines [slot1] = dlines [slot1] + dlines [slot2];
	davail [slot1] = BUFFSIZE - len1 - len2;
	dnext  [slot1] = dnext [slot2];

	/* Adjust the pointers to the last block. */
	if (diskp2 == btail) {
		btail = diskp1;
	}

	/* Slot 2 must remain in core until this point. */
	freeblock(slot2);

	/* ----- check code ----- */
}


/* Put the block in the slot on the free list. */

freeblock(slot)
int slot;
{
	/* Link the block into the free list. */
	dnext [slot] = bfree;
	bfree = ddiskp [slot];

	/* Erase the block. */
	dlines [slot] = 0;
	davail [slot] = BUFFSIZE;
	isdirty(slot);
}


/*
	Create a new block linked after the current block.
	Return the slot number and a pointer to the new block.
*/

/* int */
newblock (slotp)
int	*slotp;
{
	int	slot1,	slot2;
	int	diskp;

	/* Get a free disk sector. */
	if (bfree != ERROR) {

		/* Take the first block on the free list. */
		diskp = bfree;

		/* Put the block in a free slot. */
		swapin(diskp, &slot1);

		/* Adjust the head of the free list. */
		bfree = dnext [slot1];
	}	
	else {
		/* Get a free slot. */
		diskp = ++bmaxdisp;
		swapnew(diskp, &slot1);
	}

	/* Link the new block after the current block. */
	dnext [slot1] = dnext  [bslot];
	dback [slot1] = ddiskp [bslot];
	dnext [bslot] = diskp;
	if (dnext [slot1] != ERROR) {
		swapin(dnext [slot1], &slot2);
		dback [slot2] = diskp;
		isdirty(slot2);
	}
	
	/* The block is empty. */
	dlines [slot1] = 0;
	davail [slot1] = BUFFSIZE;
	isdirty(slot1);

	/* Set the user's field. */
	*slotp  = slot1;
}


/*
	Split the current block in two pieces.
	Length1 is the number of chars before the break point.
	Length2 is the number of chars after  the break point.
	If flag == YES, make the new block the current block.
*/

splitblock(length1, length2, flag)
int length1, length2, flag;
{
	char		*p, *q;
	int		slot2;
	int		i;

	/* Create a new block. */
	newblock(&slot2);

	/* Mark both blocks as dirty. */
	isdirty(bslot);
	isdirty(slot2);

	/* Copy end of the old block to start of the new. */
	p = dataaddr (bslot) + length1;
	q = dataaddr (slot2);

	i = 0;
	while (i < length2) {
		q [i] = p [i];
		i++;
	}

	/* Adjust the headers. */
	dlines [slot2] = dlines [bslot] - (bline-bstart);
	davail [slot2] = BUFFSIZE - length2;
	dlines [bslot] = bline - bstart;
	davail [bslot] = BUFFSIZE - length1;;

	/* Adjust the pointer to the last block. */
	if (ddiskp [bslot] == btail) {
		btail = ddiskp [slot2];
	}

	if (flag == YES) {

		/* Make the new block the current block. */
		bstart = bstart + dlines [bslot];
		bslot  = slot2;
	}
}


/* Return the address of the data area for the slot. */

/* char * */
dataaddr(slot)
int slot;
{
	return ddata + (slot * DATASIZE) + HEADERSIZE;
}


/* Open the data file. */

/* int */
dataopen()
{
	int fd;

	/* Erase the data file if it exists. */
	sysunlink(DATAFILE);

	/* Create the data file. */
	bdatafd = syscreat(DATAFILE);
	if (bdatafd == ERROR) {
		diskerror("CAN NOT OPEN SWAP FILE.");
	}

	/* Close the file, reopen it for read/write access. */
	sysclose(bdatafd);
	bdatafd = sysopen(DATAFILE, 2);
	return bdatafd;
}


/* Make the slot the MOST recently used slot. */

dolru(slot)
int slot;
{
	int i, lru;
	
	/*
		Change the relative ordering of all slots
	 	which have changed more recently than slot.
	 */

	lru = dlru [slot];
	i = 0;
	while (i < NSLOTS) {
		if (dlru [i] < lru) {
			dlru [i]++;
		}
		i++;
	}

	/* The slot is the most recently used. */
	dlru [slot] = 0;
}


/*
	Print an error message and abort.
	It would be unwise to try to recover from here
	because the state of the work file is unknown.
	However, the work file is left intact so that it
	may be examined and the original file reconstituted.
*/

diskerror(message)
char *message;
{
	error(message);

	/* Erase the buffer for fatal errors. */
	if (bfatal == YES) {
		bufnew();
	}

	/* Jump to the error recovery point. */
	longjmp(DERROR, ERROR);
}


/* Indicate that a slot must be saved on the disk. */

isdirty(slot)
int slot;
{
	dstatus [slot] = DIRTY;
}


/* Put out the block-sized buffer to the disk sector. */

putblock(buffer, sector)
char *buffer;
int sector;
{
	int s;

	/* Seek to the correct sector of the data file. */
	s = sysseek(bdatafd, sector);
	if (s == -1) {
		diskerror("SEEK FAILED IN PUTBLOCK.");
	}

	/* Write the block to the data file. */
	if (syswrite( bdatafd, buffer, READSIZE)
	    != READSIZE) {
		diskerror("WRITE FAILED IN PUTBLOCK.");
	}
}


/*
	Fill in the header fields of the output buffer and
	write it to the disk.
*/

/* char * */
putbuf(n)
int n;
{
	int	*p;

	if (n == 0) {
		exit();
	}

	/*
		Fill in the back and next links immediately.
		This can be done because we are not waiting
		for the LRU algorithm to allocated disk blocks.
		The last block that putbuf() writes will have
		an incorrect next link.  Readfile() will make
		the correction.

		The davail field calculation allows for the
		line length in the line just built.
	*/

	p = bbuff;
	*p++ = bmaxdisp - 1;		/* dback field  */
	*p++ = bmaxdisp + 1;		/* dnext field  */
	*p++ = BUFFSIZE - n;		/* davail field */
	*p++ = bline - bstart;	/* dlines field */

	/* Update block and line counts. */
	bmaxdisp++;
	bstart = bline;

	/* Write the block. */
	putblock(bbuff, bmaxdisp - 1);
}


/*
	Write out the slot to the data file.
 */

/* int */
putslot(slot)
int slot;
{
	int	*p;

	if (ddiskp [slot] == ERROR) {
		exit();
	}

	/* Copy header information back to the block. */
	p    = ddata + (slot * DATASIZE);
	*p++ = dback  [slot];
	*p++ = dnext  [slot];
	*p++ = davail [slot];
	*p++ = dlines [slot];

	/* Write the block to the disk. */
	putblock(ddata + (slot * DATASIZE), ddiskp [slot]);
}


/* Read a file into the buffer. */

bufrfile(filename)
char filename [];
{
	int	i, j;
	char	*outbuf;	/* the output buffer	*/
	int	in;		/* input buffer index	*/
	int	out;		/* output buffer index	*/
	int	outsave;	/* line starts here	*/
	int	count;		/* chars in line	*/
	int	c;		/* current char		*/
	int	*ip;		/* integer pointer	*/

	/* Clear the swapping buffers and the files. */
	bufnew();
	dstatus [bslot] = FREE;

	/* Open the user file for reading only. */
	buserfd = sysopen(filename, 0);
	if (buserfd == ERROR) {
		diskerror("NAMED FILE NOT FOUND");
	}

	/* Open the data file. */
	dataopen();

	/* Erase the buffer on a disk error. */
	bfatal = YES;

	/* The file starts with line 1. */
	bline = 1;
	bstart = 1;

	/* There are no blocks in the file yet. */
	bhead = btail = ERROR;
	bmaxdisp = 0;

	in = DATASIZE;		/* Force an initial read. */
	out = 2;
	outsave = 0;
	bline = bstart = 1;
	outbuf = bbuff + HEADERSIZE;
	count = 0;

	while (1) {

		if ((out >= BUFFSIZE) & (outsave == 0)) {

			/* The line is too long. */
			error ("LINE SPLIT - TOO LONG");

			/* End the line. */
			bputnum(outbuf, count);
			bline++;
			count = 0;

			/* Clear the output buffer. */
			putbuf(out);
			out = 2;
			outsave = 0;
		}

		else if (out >= BUFFSIZE) {

			/* Write out the buffer. */
			putbuf(outsave);

			/* Move the remainder to the front. */
			i = 2;
			j = outsave + 2;
			while (j < out) {
				outbuf [i++] = outbuf [j++];
			}

			/* Reset restart point. */
			count = out - outsave - 2;
			outsave = 0;
			out = count + 2;
		}

		c = read1(&in);

		if (c == CPMEOF) {

			if (count != 0) {

				/* Finish the last line. */
				bputnum(outbuf + outsave, count);
				bline++;
				outsave = out;
			}

			if (outsave != 0) {
				putbuf(outsave);
			}
			break;
		}

		else if (c == LF) {

			/* Ignore LF's */
			continue;
		}

		else if (c == CR) {

			/* Finish the line. */
			bputnum(outbuf + outsave, count);

			/* Set restart point. */
			bline++;
			outsave = out;
			out = out + 2;
			count = 0;
		}

		else {

			/* Copy normal character. */
			outbuf [out++] = c;
			count++;
		}
	}

	/* Close the user' file. */
	sysclose(buserfd);

	/* Special case:  null file */
	if (bmaxdisp == 0) {
		bufnew();
		return;
	}

	/* Rewrite the last block with correct next field. */
	ip = bbuff;
	ip++;
	*ip = ERROR;
	putblock(bbuff, bmaxdisp - 1);

	/* Set the pointers to the first and last blocks. */
	bmaxdisp--;
	bhead = 0;
	btail = bmaxdisp;

	/* Move to the start of the file. */
	bmaxline = bline - 1;
	bline = 1;
	bstart = 1;
	swapin(bhead, &bslot);
	bfatal = NO;
}


/* Get one character from the input file. */

read1(in)
int *in;
{
	char	*inbuf;
	int	s;

	/* Put the input buffer in the first slot. */
	inbuf = ddata;

	if (*in == DATASIZE) {

		/* Read the next sector. */
		s = sysread (buserfd, inbuf);
		if (s == ERROR) {
			diskerror("DISK READ FAILED");
		}

		/* Force a CPM end of file mark. */
		if (s < READSIZE) {
			inbuf [s * CPMSIZE] = CPMEOF;
		}

		*in = 0;
	}

	/* Return the next character of the buffer. */
	return inbuf [(*in)++];
}


/*
	Put the block from the disk into a slot in memory.
	Return the slot number and a pointer to the block.
 */

/* int */
swapin(diskp, slotp)
int diskp;
int *slotp;
{
	int	slot, s;
	int	*p;

	if ( (diskp < 0) | (diskp > bmaxdisp) ) {
		exit();
	}

	/* See whether the block is already in a slot. */
	slot = 0;
	while (slot < NSLOTS) {
		if ( (dstatus [slot] != FREE) &
		     (ddiskp  [slot] == diskp)
		   ) {

			/* Reference the block. */
			dolru(slot);

			/* Set the caller's field. */
			*slotp  = slot;
			return;
		}
		slot++;
	}

	/* Clear a slot for the block. */
	swapnew(diskp, slotp);

	/* Seek to the proper place. */
	s = sysseek(bdatafd, diskp);
	if (s == -1) {
		diskerror("SWAPIN:  DISK IS FULL");
	}

	/* Read the block into the slot. */
	s = sysread(bdatafd, ddata + (*slotp * DATASIZE));
	if (s == ERROR) {
		diskerror("SWAPIN:  DISK NOT READY");
	}

	/* Copy information to arrays for easy access. */
	p = ddata + (*slotp * DATASIZE);
	dback  [*slotp] = *p++;
	dnext  [*slotp] = *p++;
	davail [*slotp] = *p++;
	dlines [*slotp] = *p++;

	/* Swapnew() has already called dolru(). */
}


/*
	Free a slot for a block located at diskp.
	Swap out the least recently used block if required.
	Return slotp.
 */

/* int */
swapnew (diskp, slotp)
int diskp;
int *slotp;
{
	int slot;

	/* Search for an available slot. */
	slot = 0;
	while (slot < NSLOTS) {
		if (dstatus [slot] == FREE) {
			break;
		}
		slot++;
	}

	/* Swap out a block if all blocks are full. */
	if (slot == NSLOTS) {
		slot = swapout();
	}

	/* Make sure the block will be written. */
	dstatus [slot] = FULL;
	ddiskp  [slot] = diskp;

	/* Reference the slot. */
	dolru(slot);

	/* Return slotp. */
	*slotp = slot;
}


/*
	Swap out the least recently used (LRU) slot.
	Return the index of the slot that becomes free.
 */

/* int */
swapout()
{
	int slot;

	/* Open the temp file if it has not been opened. */
	if (bdatafd == ERROR) {
		bdatafd = dataopen();
	}

	/* Find the least recently used slot. */
	slot = 0;
	while (dlru [slot] != NSLOTS - 1) {
		slot++;
	}

	/* Do the actual swapping out if memory is dirty. */
	if (dstatus [slot] == DIRTY) {
		putslot(slot);
		return slot;
	}

	/* ddiskp is not ERROR if status is not DIRTY. */
	if (ddiskp [slot] == ERROR) {
		exit();
	}

	/* Indicate that the slot is available. */
	dstatus [slot] = FREE;
	ddiskp  [slot] = ERROR;

	/* Return the slot number. */
	return slot;
}


/* Write the entire buffer to file. */

bufwfile(filename)
char *filename;
{
	char *data;
	int out, slot, lines, length, next, count;
	int c;

	/* Open the user file.  Erase it if it exists. */
	buserfd = syscreat(filename);
	if (buserfd == ERROR) {
		diskerror("FILE CREATE FAILED");
	}

	/* Copy each block of the file. */
	out = 0;
	next = bhead;
	while (next != ERROR) {

		/* Swap in the next block. */
		swapin(next, &slot);

		/* Get data from the header of the block. */
		next  = dnext [slot];
		lines = dlines [slot];
		data  = dataaddr (slot);
		
		/* Copy each line of the block. */
		count = 0;
		while (lines--) {

			/* Get length of the line. */
			length = bgetnum(data + count);
			
			/* Skip over length field. */
			count = count + 2;

			/* Copy each char of the line. */
			while (length--) {
				c = data [count++];
				write1(c, &out);
			}

			/* Add CR and LF at end. */
			write1(CR, &out);
			write1(LF, &out);
		}
	}

	/* Force an end of file mark. */
	write1(CPMEOF, &out);

	/* Flush the buffer and close the file. */
	writeflush(out);
	sysclose(buserfd);

	/* Kludge:  go to line 1 for a reference point. */
	swapin(bhead, &bslot);
	bline = bstart = 1;
}


/*
	Write one character to the user's file.
	i is the current position in the file buffer.
*/

/* int */
write1(c, i)
char c;
int *i;
{
	bbuff [(*i)++] = c;
	if (*i == CPMSIZE) {
		if (syswrite(buserfd, bbuff, 1) != 1) {
			diskerror("DISK WRITE FAILED");
		}
		*i = 0;
	}
}


/*
	Flush bbuff to the user's file.
*/

writeflush(i)
int i;
{
	if (i == 0) {
		return;
	}
	if (syswrite(buserfd, bbuff, 1) != 1) {
		diskerror("FILE FLUSH FAILED");
	}
}


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
/*    >>>>>  R E D  <<<<<    THE EDWARD K. REAM FULL SCREEN C EDITOR     */
/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
/*                        >>>>> END SOURCE  <<<<<                        */
/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */

    