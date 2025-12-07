/*
 * ctype - character type classification
 */

#include <stdio.h>

/* upper case */
#define _U	0x1
/* lower case */
#define _L	0x2
/* numeral (digit) */
#define _N	0x4
/* spacing character */
#define _S	0x8
/* punctuation */
#define _P	0x10
/* control character */
#define _C	0x20
/* blank */
#define _B	0x40
/* hexadecimal digit */
#define _X	0x80

char _ctype[] =

{	'\000',
	'\040', '\040', '\040', '\040', '\040', '\040', '\040', '\040',
	'\040', '\050', '\050', '\050', '\050', '\050', '\040', '\040',
	'\040', '\040', '\040', '\040', '\040', '\040', '\040', '\040',
	'\040', '\040', '\040', '\040', '\040', '\040', '\040', '\040',
	'\110', '\020', '\020', '\020', '\020', '\020', '\020', '\020',
	'\020', '\020', '\020', '\020', '\020', '\020', '\020', '\020',
	'\204', '\204', '\204', '\204', '\204', '\204', '\204', '\204',
	'\204', '\204', '\020', '\020', '\020', '\020', '\020', '\020',
	'\020', '\201', '\201', '\201', '\201', '\201', '\201', '\001',
	'\001', '\001', '\001', '\001', '\001', '\001', '\001', '\001',
	'\001', '\001', '\001', '\001', '\001', '\001', '\001', '\001',
	'\001', '\001', '\001', '\020', '\020', '\020', '\020', '\020',
	'\020', '\202', '\202', '\202', '\202', '\202', '\202', '\002',
	'\002', '\002', '\002', '\002', '\002', '\002', '\002', '\002',
	'\002', '\002', '\002', '\002', '\002', '\002', '\002', '\002',
	'\002', '\002', '\002', '\020', '\020', '\020', '\020', '\040' } ;

/* check if char is a decimal digit */
isdigit(c) char c;
{
	return( _ctype[c+1] & _N ) ;
}

/* check if char is upper case */
isupper(c) char c;
{
	return( _ctype[c+1] & _U ) ;
}

/* check if char is lower case */
islower(c) char c;
{
	return( _ctype[c+1] & _L ) ;
}

/* check if character is spacing */
isspace(c) char c;
{
	return( _ctype[c+1] & _S ) ;
}

/* check if char is punctuation */
ispunct(c) char c;
{
	return( _ctype[c+1] & _P ) ;
}

/* check if char is control */
iscntrl(c) char c;
{
	return( _ctype[c+1] & _C ) ;
}

/* check if char is alphanumeric */
isalnum(c) char c ;
{
	return( _ctype[c+1] & (_U | _L | _N) ) ;
}

/* check if char is hex digit */
isxdigit(c) char c ;
{
	return( _ctype[c+1] & _X ) ;
}

/* check if char is alphnumeric */
isalpha(c) char c ;
{
	return( _ctype[c+1] & (_U | _L) ) ;
}

/* check if char is printable */
isprint(c) char c ;
{
	return( _ctype[c+1] & (_P | _U | _L | _N | _B) ) ;
}

/* check if char is graphic */
isgraph(c) char c ;
{
	return( _ctype[c+1] & (_P | _U | _L | _N) ) ;
}

/* check if character is ascii */
isascii(c) char c ;
{
	return( !(c & (~0x7f) ) ) ;
}

/* convert to upper case */
toupper(c) char c ;
{
	if ( islower(c) )
		return( c - ('a' - 'A') ) ;
	else
		return(c) ;
}

/* convert to lower case */
tolower(c) char c ;
{
	if ( isupper(c) )
		return( c - ('A' - 'a') ) ;
	else
		return(c) ;
}

/* convert to ascii */
toascii(c) char c ;
{
	return( c & 0x7f ) ;
}
