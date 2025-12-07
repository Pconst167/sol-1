/*
 * cc3.c - third part of Small-C/Plus compiler
 */

#include <stdio.h>
#include <string.h>
#include "ccdefs.h"
#include "ccfunc.h"

extern SYMBOL *symtab, *glbptr, *loctab, *locptr ;
extern int glbcnt ;
extern TAG_SYMBOL *tagtab, *tagptr ;
extern SYMBOL *membtab, *membptr ;
extern WHILE_TAB *wqueue, *wqptr ;
extern char macq[] ;
extern int macptr ;
extern char *stage, *stagenext, *stagelast ;
extern char line[], mline[] ;
extern int skiplevel, iflevel ;
extern int lptr, mptr ;
extern int nxtlab, Zsp, errcnt, errstop, eof ;
extern int ctext, cmode, fnstart, lineno, infunc ;
extern SYMBOL *currfn ;
extern FILE *inpt2, *input, *output, *saveout ;

#ifdef SMALL_C
extern int minavail ;
#endif


/*
 *	Perform a function call
 *
 * called from heirb, this routine will either call
 *	the named function, or if the supplied ptr is
 *	zero, will call the contents of HL
 */
callfunction(ptr)
SYMBOL *ptr;	/* symbol table entry (or 0) */
{
	int nargs, const, val ;

	nargs=0;
	blanks();	/* already saw open paren */

	while ( ch() != ')' ) {
		if(endst())break;
		if ( ptr ) {
			/* ordinary call */
			if(expression(&const, &val)==DOUBLE) {
				dpush();
				nargs += 6;
			}
			else {
				zpush();
				nargs += 2;
			}
		}
		else { /* call to address in HL */
			zpush();	/* push argument */
			if(expression(&const, &val)==DOUBLE) {
				dpush2();
				nargs += 6;
			}
			else {
				nargs += 2;
			}
			swapstk();
		}
		if (cmatch(',')==0) break;
	}
	needchar(')');
	if ( ptr ) {
		if ( nospread(ptr->name) ) {
			loadargc(nargs) ;
		}
		zcall(ptr) ;
	}
	else callstk(nargs);
	Zsp=modstk(Zsp+nargs,YES);	/* clean up arguments */
}

nospread(sym)
char *sym ;
{
	if ( strcmp(sym,"printf") == 0 ) return 1;
	if ( strcmp(sym,"fprintf") == 0 ) return 1;
	if ( strcmp(sym,"sprintf") == 0 ) return 1;
	if ( strcmp(sym,"scanf") == 0 ) return 1;
	if ( strcmp(sym,"fscanf") == 0 ) return 1;
	if ( strcmp(sym,"sscanf") == 0 ) return 1;
	return 0;
}

junk()
{
	if(an(inbyte()))
		while(an(ch()))gch();
	else while(an(ch())==0) {
		if(ch()==0)break;
		gch();
	}
	blanks();
}

endst()
{
	blanks();
	return ( ch() == ';' || ch() == 0 );
}

illname()
{
	error("illegal symbol name");junk();
}

multidef()
{
	error("already defined");
}

char missing[] = "missing token" ;

needtoken(str)
char *str;
{
	if ( match(str) == 0 )
		error(missing);
}

needchar(c)
char c ;
{
	if ( cmatch(c) == 0 )
		error(missing) ;
}

needlval()
{
	error("must be lvalue");
}

hash(sname)
char *sname;
{
	int c, h ;

	h = *sname;
	while(c = *(++sname)) h=(h<<1)+c;
	return (h & MASKGLBS) ;
}

/*
 * find entry in global symbol table,
 * glbptr is set to relevant entry
 * return pointer if match is found,
 * else return zero and glbptr points to empty slot
 */

#ifndef SMALL_C
SYMBOL *
#endif

findglb(sname)
char *sname ;
{
	glbptr = STARTGLB + hash(sname) ;
	while ( strcmp(sname, glbptr->name) ) {
		if ( glbptr->name[0] == 0 ) return 0 ;
		++glbptr ;
		if (glbptr == ENDGLB) glbptr = STARTGLB;
	}
	return glbptr ;
}

#ifndef SMALL_C
SYMBOL *
#endif

findloc(sname)
char *sname ;
{
	SYMBOL *ptr ;

	ptr = STARTLOC ;
	while ( ptr != locptr ) {
		if ( strcmp(sname, ptr->name) == 0 )
			return ptr;
		++ptr ;
	}
	return 0;
}

/*
 * find symbol in structure tag symbol table, return 0 if not found
 */

#ifndef SMALL_C
TAG_SYMBOL *
#endif

findtag(sname)
char *sname ;
{
	TAG_SYMBOL *ptr ;

	ptr = STARTTAG ;
	while ( ptr != tagptr ) {
		if ( strcmp(ptr->name, sname) == 0 )
			return ptr ;
		++ptr ;
	}
	return 0 ;
}

/*
 * determine if 'sname' is a member of the struct with tag 'tag'
 * return pointer to member symbol if it is, else 0
 */

#ifndef SMALL_C
SYMBOL *
#endif

findmemb(tag, sname)
TAG_SYMBOL *tag ;
char *sname ;
{
	SYMBOL *ptr ;

	ptr = tag->ptr ;

	while ( ptr < tag->end ) {
		if ( strcmp(ptr->name, sname) == 0 )
			return ptr ;
		++ptr ;
	}
	return 0 ;
}

char Overflow[] = "symbol table overflow" ;

#ifndef SMALL_C
SYMBOL *
#endif

addglb(sname, id, typ, value, storage, more, itag)
char *sname, id, typ ;
int value, storage, more, itag ;
{
	if ( findglb(sname) ) {
		multidef() ;
		return glbptr ;
	}
	if ( id != MACRO && *sname != '0' ) {
		/* declare exported name */
		ot("global ");
		outname(sname); nl();
	}
	if ( glbcnt >= NUMGLBS-1 ) {
		error(Overflow);
		return 0;
	}
	addsym(glbptr, sname, id, typ, storage, more, itag) ;
	glbptr->offset.i = value ;
	++glbcnt ;
	return glbptr;
}

#ifndef SMALL_C
SYMBOL *
#endif

addloc(sname, id, typ, more, itag)
char *sname, id, typ ;
int more, itag ;
{
	SYMBOL *cptr ;

	if ( cptr=findloc(sname) ) {
		multidef() ;
		return cptr;
	}
	if ( locptr >= ENDLOC ) {
		error(Overflow);
		return 0;
	}
	cptr = locptr++ ;
	addsym(cptr, sname, id, typ, STKLOC, more, itag) ;
	return cptr ;
}

/*
 * add new structure member to table
 */
addmemb(sname, id, typ, value, storage, more, itag)
char *sname, id, typ ;
int value, storage, more, itag ;
{
	if ( membptr >= ENDMEMB ) {
		error(Overflow) ;
		ccabort() ;
	}
	addsym(membptr, sname, id, typ, storage, more, itag) ;
	membptr->offset.i = value ;
	++membptr ;
}

/*
 * insert values into symbol table
 */
addsym(ptr, sname, id, typ, storage, more, itag)
SYMBOL *ptr ;
char *sname, id, typ ;
int storage, more, itag ;
{
	strcpy(ptr->name, sname) ;
	ptr->ident = id ;
	ptr->type = typ ;
	ptr->storage = storage ;
	ptr->more = more ;
	ptr->tag_idx = itag ;
}

/*
 * get integer of length len bytes from address addr
 */
getint(addr, len)
char *addr ;
int len ;
{
	int i ;

	i = *(addr + --len) ;	/* high order byte sign extended */
	while (len--) i = (i << 8) | ( *(addr+len) & 255 ) ;
	return i ;
}

/*
 * put integer of length len bytes into address addr
 * (low byte first)
 */
putint(i, addr, len)
char *addr ;
int i, len ;
{
	while (len--) {
		*addr++ = i ;
		i >>= 8 ;
	}
}

/*
 * Test if next input string is legal symbol name
 * if it is, truncate it and copy it to sname
 */
symname(sname)
char *sname;
{
	int k ;

#ifdef SMALL_C
	{
		char *p ;
		char c ;

		/* this is about as deep as nesting goes, check memory left */
		p = alloc(1) ;
		/* &c is top of stack, p is end of heap */
		if ( (k=&c-p) < minavail )
			minavail = k ;
		free(p) ;
	}
#endif

	blanks();
	if ( alpha(ch()) == 0 )
		return (*sname=0) ;
	k = 0 ;
	while ( an(ch()) ) {
		sname[k] = gch();
		if ( k < NAMEMAX ) ++k ;
	}
	sname[k] = 0;
	return 1;
}

/* Return next avail internal label number */
getlabel()
{
	return(++nxtlab);
}

/* Print specified number as label */
printlabel(label)
int label;
{
	outstr("cc");
	outdec(label);
}

/* print label with colon and newline */
postlabel(label)
int label;
{
	printlabel(label) ;
	col();
	nl();
}

#ifndef Z80

/* Test if given character is alpha */
alpha(c)
char c;
{
	if(c>='a') return (c<='z');
	if(c<='Z') return (c>='A');
	return (c=='_');
}

#else

#asm
	global qalpha
qalpha:
	pop bc
	pop de
	push de
	push bc
;
	ld hl,1		;prime hl as true
	ld a,e		;get character to a
	cp 123		;compare against 'z'+1
	jp nc,isa2	;goto next stage if >= 'z'+1
	cp 97		;compare against 'a'
	ret nc		;return true if >= 'a'
isa2:
	cp 95		;compare against '_'
	ret z		;return true
;
	cp 91		;compare against 'Z'+1
	jp nc,isa3	;goto return false if >= 'Z'+1
	cp 65		;compare against 'A'
	ret nc		;return true if > 'A'
isa3:
	dec hl		;make hl false
	ret
#endasm

#endif

/* Test if given character is numeric */
numeric(c)
char c;
{
	if(c<='9') return(c>='0');
	return 0;
}

/* Test if given character is alphanumeric */
an(c)
char c ;
{
	if ( alpha(c) ) return 1 ;
	return numeric(c) ;
}

/* Print a carriage return and a string only to console */
pl(str)
char *str;
{
	putchar('\n');
	while(*str)putchar(*str++);
}

addwhile(ptr)
WHILE_TAB *ptr ;
{
	wqptr->sp = ptr->sp = Zsp ;				/* record stk ptr */
	wqptr->loop = ptr->loop = getlabel() ;	/* and looping label */
	wqptr->exit = ptr->exit = getlabel() ;	/* and exit label */
	if ( wqptr >= WQMAX ) {
		error("too many active whiles");
		return;
	}
	++wqptr ;
}

delwhile()
{
	if ( wqptr > wqueue ) --wqptr ;
}

#ifndef SMALL_C
WHILE_TAB *
#endif

readwhile(ptr)
WHILE_TAB *ptr ;
{
	if ( ptr <= wqueue ) {
		error("out of context");
		return 0;
	}
	else return (ptr-1) ;
}

#ifndef Z80

ch()
{
	return line[lptr] ;
}

nch()
{
	if ( ch() )
		return line[lptr+1] ;
	return 0;
}

gch()
{
	if ( ch() )
		return line[lptr++] ;
	return 0;
}

#else

#asm
;quick fetch of character (no sign extend)
	global qch
qch:
	ld de,qline
	ld hl,(qlptr)
	add hl,de
	ld l,(hl)
	ld h,0
	ret
;
;
	global qnch
qnch:
	ld de,qline
	ld hl,(qlptr)
	add hl,de
	ld a,(hl)
	or a
	jr z,gch1
	inc hl
	ld l,(hl)
	ld h,0
	ret
;
;
	global qgch
qgch:
	ld hl,qline
	ld de,(qlptr)
	add hl,de
	ld a,(hl)
	or a
	jr z,gch1
	inc de
	ld (qlptr),de
gch1:
	ld l,a
	ld h,0
	ret
#endasm

#endif

clear()
{
	lptr = 0 ;
	line[0] = 0 ;
}

inbyte()
{
	while(ch()==0) {
		if (eof) return 0;
		preprocess();
	}
	return gch();
}

inline()
{
	FILE *unit ;
	int k ;

	while(1) {
		if ( input == NULL_FD ) openin() ;
		if ( eof ) return ;
		if( (unit=inpt2) == NULL_FD ) unit = input ;
		clear() ;
		while ( (k=getc(unit)) > 0 ) {
			if ( k == '\n' || lptr >= LINEMAX ) break;
			line[lptr++]=k;
		}
		line[lptr] = 0 ;	/* append null */
		++lineno ;	/* read one more line */
		if ( k <= 0 ) {
			fclose(unit);
			if ( inpt2  != NULL_FD ) endinclude() ;
				else input = 0 ;
		}
		if ( lptr ) {
			if( ctext && cmode ) {
				comment();
				outstr(line);
				nl();
			}
			lptr=0;
			return;
		}
	}
}

/*
 * ifline - part of preprocessor to handle #ifdef, etc
 */
ifline()
{
	char sname[NAMESIZE] ;

	while ( 1 ) {

		inline() ;
		if ( eof ) return ;

		if ( ch() == '#' ) {

			if ( match("#undef") ) {
				delmac() ;
				continue ;
			}

			if ( match("#ifdef") ) {
				++iflevel ;
				if ( skiplevel ) continue ;
				symname(sname) ;
				if ( findmac(sname) == 0 )
					skiplevel = iflevel ;
				continue ;
			}

			if ( match("#ifndef") ) {
				++iflevel ;
				if ( skiplevel ) continue ;
				symname(sname) ;
				if ( findmac(sname) )
					skiplevel = iflevel ;
				continue ;
			}

			if ( match("#else") ) {
				if ( iflevel ) {
					if ( skiplevel == iflevel )
						skiplevel = 0 ;
					else if ( skiplevel == 0 )
						skiplevel = iflevel ;
				}
				else
					noiferr() ;
				continue ;
			}

			if ( match("#endif") ) {
				if ( iflevel ) {
					if ( skiplevel == iflevel )
						skiplevel = 0 ;
					--iflevel ;
				}
				else
					noiferr() ;
				continue ;
			}
		}

		if ( skiplevel )
			continue ;

		if ( ch() == 0 )
			continue ;

		break ;
	}
}

noiferr()
{
	error("no matching #if") ;
}

keepch(c)
char c ;
{
	mline[mptr] = c ;
	if ( mptr < MPMAX ) ++mptr ;
}

preprocess()
{
	char c,sname[NAMESIZE];
	int k;

	ifline() ;
	if ( eof || cmode == 0 ) {
		/* while passing through assembler, only do #if, etc */
		return ;
	}
	mptr = lptr = 0 ;
	while ( ch() ) {
		if ( ch()==' ' || ch()=='\t' ) {
			keepch(' ');
			while ( ch()==' ' || ch()=='\t' )
				gch();
		}
		else if(ch()=='"') {
			keepch(ch());
			gch();
			while ( ch()!='"' || (line[lptr-1]==92 && line[lptr-2]!=92) ) {
				if(ch()==0) {
					error("missing quote");
					break;
				}
				keepch(gch());
			}
			gch();
			keepch('"');
		}
		else if(ch()==39) {
			keepch(39);
			gch();
			while ( ch()!=39 || (line[lptr-1]==92 && line[lptr-2]!=92) ) {
				if(ch()==0) {
					error("missing apostrophe");
					break;
				}
				keepch(gch());
			}
			gch();
			keepch(39);
		}
		else if ( ch()=='/' && nch()=='*' ) {
			lptr += 2;
			while ( ch()!='*' || nch()!='/' ) {
				if ( ch() ) {
					++lptr;
				}
				else {
					inline() ;
					if(eof)break;
				}
			}
			lptr += 2;
		}
		else if ( alpha(ch()) ) {
			k = 0 ;
			while ( an(ch()) ) {
				if ( k < NAMEMAX )
					sname[k++] = ch() ;
				gch();
			}
			sname[k]=0;
			if(k=findmac(sname))
				while(c=macq[k++])
					keepch(c);
			else {
				k=0;
				while(c=sname[k++])
					keepch(c);
			}
		}
		else keepch(gch());
	}
	keepch(0);
	if ( mptr >= MPMAX ) error("line too long") ;
	strcpy(line, mline) ;
	lptr = 0 ;
}

addmac()
{
	char sname[NAMESIZE];

	if ( symname(sname) == 0 ) {
		illname();
		clear();
		return;
	}
	addglb(sname, MACRO, 0, macptr, STATIK, 0, 0) ;
	while ( ch()==' ' || ch()=='\t' ) gch() ;
	while ( putmac(gch()) ) ;
	if ( macptr >= MACMAX ) error("macro table full") ;
}

/*
 * delete macro from symbol table, but leave entry so hashing still works
 */
delmac()
{
	char sname[NAMESIZE] ;
	SYMBOL *ptr ;

	if ( symname(sname) ) {
		if ( (ptr=findglb(sname)) ) {
			/* invalidate name */
			ptr->name[0] = '0' ;
		}
	}
}

putmac(c)
char c ;
{
	macq[macptr] = c ;
	if ( macptr < MACMAX ) ++macptr ;
	return c ;
}

findmac(sname)
char *sname;
{
	if( findglb(sname) != 0 && glbptr->ident == MACRO ) {
		return glbptr->offset.i ;
	}
	return 0 ;
}

/*
 * defmac - takes macro definition of form name[=value] and enters
 *          it in table.  If value is not present, set value to 1.
 *          Uses some shady manipulation of the line buffer to set
 *          up conditions for addmac().
 */
defmac(text)
char *text ;
{
	char *p ;

	/* copy macro name into line buffer */
	p = line ;
	while ( *text != '=' && *text ) {
		*p++ = *text++ ;
	}
	*p++ = ' ' ;
	/* copy value or "1" into line buffer */
	strcpy(p, (*text++) ? text : "1") ;
	/* make addition to table */
	lptr = 0 ;
	addmac() ;
}
 
/* initialise staging buffer */

setstage( before, start )
char **before, **start ;
{
	if ( (*before=stagenext) == 0 )
		stagenext = stage ;
	*start = stagenext ;
}

/* flush or clear staging buffer */

clearstage( before, start )
char *before, *start ;
{
	*stagenext = 0 ;
	if (stagenext=before) return ;
	if ( start ) {
		if ( output != NULL_FD ) {
			if ( fputs(start, output) == -1 ) {
				fabort() ;
			}
		}
		else {
			puts(start) ;
		}
	}
}

fabort()
{
	closeout();
	error("Output file error");
	ccabort();
}

/* direct output to console */
toconsole()
{
	saveout = output;
	output = 0;
}

/* direct output back to file */
tofile()
{
	if(saveout)
		output = saveout;
	saveout = 0;
}

#ifndef Z80

outbyte(c)
char c;
{
	if(c) {
		if ( output != NULL_FD ) {
			if (stagenext) {
				return(outstage(c)) ;
			}
			else {
				if((putc(c,output))<=0) {
					fabort() ;
				}
			}
		}
		else putchar(c);
	}
	return c;
}

#else

#asm
	global qoutbyte
qoutbyte:
	pop bc
	pop hl		;hl is c
	push hl
	push bc
;
	ld a,h		;if(c==0)
	or l
	ret z		;  return c
;
	ld de,(qoutput)	;if(output==0)
	ld a,d
	or e
	jp nz,out1
	push hl			;  putchar(c)
	push hl
	call qputchar
	pop bc
	pop hl
	ret				;  return c
out1:
	ld bc,(qstagenex)	; if(stagenext==0)
	ld a,b
	or c
	jp nz,out2
	push hl				;  if(putc(c,output)<=0)
	push de
	call qputc
	pop bc
	pop bc
	xor a
	or h
	global qfabort		;    fabort()
	jp m,qfabort
	or l
	jp z,qfabort
	pop bc				;    else return c
	pop hl
	push hl
	push bc
	ret
out2:
	push hl				; (stagenext.ne.0) return(outstage(c))
	global qoutstage
	call qoutstage
	pop bc
	ret
#endasm

#endif

/* output character to staging buffer */

outstage(c)
char c;
{
	if (stagenext == stagelast) {
		error("staging buffer overflow") ;
		return 0 ;
	}
	*stagenext++ = c ;
	return c ;
}

outstr(ptr)
char ptr[];
{
	while(outbyte(*ptr++));
}

nl()
{
	outbyte('\n');
}

tab()
{
	outbyte('\t');
}

col()
{
	outbyte(58);
}

bell()
{
	outbyte(7);
}

error(ptr)
char ptr[];
{
	int k;

	toconsole();
	bell();
	outstr("Line "); outdec(lineno); outstr(", ");
	if ( infunc == 0 )
		outbyte('(');
	if ( currfn == NULL )
		outstr("start of File") ;
	else
		outstr(currfn->name) ;
	if ( infunc == 0 )
		outbyte(')') ;
	outstr(" + ");
	outdec(lineno-fnstart);
	outstr(": ");  outstr(ptr);  nl();

	outstr(line); nl();

	k = 0 ;	/* skip to error position */
	while ( k < lptr ) {
		if ( line[k++] == '\t' )
			tab() ;
		else
			outbyte(' ') ;
	}
	outbyte('^');  nl();
	++errcnt;

	if ( errstop ) {
		pl("Continue (Y/N) ? ");
		if ( raise(getchar()) == 'N' )
			ccabort() ;
	}
	tofile();
}

ol(ptr)
char *ptr ;
{
	ot(ptr);
	nl();
}

ot(ptr)
char *ptr ;
{
	tab();
	outstr(ptr);
}

#ifndef Z80

blanks()
{
	while(1) {
		while(ch()==0) {
			preprocess();
			if(eof)break;
		}
		if(ch()==' ')gch();
		else if(ch()==9)gch();
		else return;
	}
}

streq(str1,str2)
char str1[],str2[];
{
	int k;
	k=0;
	while (*str2) {
		if ((*str1++)!=(*str2++)) return 0;
		++k;
	}
	return k;
}

#else

#asm
	global qblanks
qblanks:			;while(1)
	call qch		;  while(ch()==0)
	ld a,l
	or a
	jp nz,bl1
	call qpreproce	;    preprocess()
	ld hl,(qeof)	;    if(eof)break
	ld a,h
	or l
	jp z,qblanks	;  end-while
	call qch
	ld a,l
bl1:
	cp 32			;  if(ch()==32)
	jp nz,bl2
	call qgch		;    gch()
	jp qblanks		;end-while
bl2:
	cp 9			;  if(ch().ne.9)
	ret nz			;    return
	call qgch		;  else gch()
	jp qblanks		;end-while
;
;
	global qstreq
qstreq:
	pop bc
	pop de		;de is str2
	pop hl		;hl is str1
	push hl
	push de
	push bc
;
	ld bc,0		;bc is k
st3:
	ld a,(de)	;if *str2 is zero, return k
	or a
	jp z,st2
	cp (hl)		;if *str2 not equal *str1, return 0
	jp nz,st1
	inc hl
	inc de
	inc bc
	jp st3
st1:
	ld hl,0
	ret
st2:
	ld h,b
	ld l,c
	ret
#endasm

#endif

/*
 * compare strings
 * match only if we reach end of both strings or if, at end of one of the
 * strings, the other one has reached a non-alphanumeric character
 * (so that, for example, astreq("if", "ifline") is not a match)
 */
astreq(str1, str2)
char *str1, *str2 ;
{
	int k;

	k=0;
	while ( *str1 && *str2 ) {
		if ( *str1 != *str2 ) break ;
		++str1 ;
		++str2 ;
		++k ;
	}
	if ( an(*str1) || an(*str2) ) return 0;
	return k;
}

match(lit)
char *lit;
{
	int k;

	blanks();
	if ( k=streq(line+lptr,lit) ) {
		lptr += k;
		return 1;
	}
 	return 0;
}

cmatch(lit)
char lit ;
{
	blanks() ;
	if ( line[lptr] == lit ) {
		++lptr ;
		return 1 ;
	}
	return 0 ;
}

amatch(lit)
char *lit;
{
	int k;

	blanks();
	if ( k=astreq(line+lptr,lit) ) {
		lptr += k;
		return 1;
	}
	return 0;
}

outdec(number)
int number;
{
	if ( number < 0 ) {
		number = (-number) ;
		outbyte('-');
	}
	outd2(number);
}

outd2(n)
int n ;
{
	if ( n > 9 ) {
		outd2(n/10) ;
		n %= 10 ;
	}
	outbyte('0'+n) ;
}

/* convert lower case to upper */
raise(c)
char c ;
{
	if ( c >= 'a' ) {
		if ( c <= 'z' )
			c -= 32; /* 'a'-'A'=32 */
	}
	return c ;
}
