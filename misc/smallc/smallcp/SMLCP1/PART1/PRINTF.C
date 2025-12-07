/*
 *	printf - core routines for printf, sprintf, fprintf
 *	         used by both integer and f.p. versions
 *
 *	Compile with -m option
 *
 *	R M Yorston 1987
 */


#include <stdio.h>

#define NULL 0
#define ERR -1

extern utoi() ;

/*
 * printf(controlstring, arg, arg, ...)  or 
 * sprintf(string, controlstring, arg, arg, ...) or
 * fprintf(file, controlstring, arg, arg, ...) -- formatted print
 *        operates as described by Kernighan & Ritchie
 *        only d, x, c, s, and u specs are supported.
 */

char *_String ;
int _Count ;

printf(args)
int args ;
{
	_String = NULL ;
	return( _printf(stdout, _argcnt() + &args - 1) ) ;
}

fprintf(args)
int args ;
{
	int *nxtarg ;

	_String = NULL ;
	nxtarg = _argcnt() + &args ;
	return( _printf( *(--nxtarg), --nxtarg ) ) ;
}

sprintf(args)
int args ;
{
	int *nxtarg ;

	nxtarg = _argcnt() + &args - 1 ;
	_String = *nxtarg ;
	return( _printf( stdin, --nxtarg ) ) ;
}

/*
 * itod -- convert nbr to signed decimal string of width sz
 *	       right adjusted, blank filled ; returns str
 *
 *	      if sz > 0 terminate with null byte
 *	      if sz  =  0 find end of string
 *	      if sz < 0 use last byte for data
 */
itod(nbr, str, sz)
int nbr ;
char str[] ;
int sz ;
{
	char sgn ;

	if ( nbr < 0 ) {
		nbr = -nbr ;
		sgn = '-' ;
	}
	else
		sgn = ' ' ;
	if ( sz > 0 )
		str[--sz] = NULL ;
	else if ( sz < 0 )
			sz = -sz ;
		else
			while ( str[sz] != NULL )
				++sz ;
	while ( sz ) {
		str[--sz] = nbr % 10 + '0' ;
		if ( (nbr/=10) == 0 )
			break ;
	}
	if ( sz )
		str[--sz] = sgn ;
	while ( sz > 0 )
		str[--sz] = ' ' ;
	return str ;
}


/*
 * itou -- convert nbr to unsigned decimal string of width sz
 *	       right adjusted, blank filled ; returns str
 *
 *	      if sz > 0 terminate with null byte
 *	      if sz  =  0 find end of string
 *	      if sz < 0 use last byte for data
 */
itou(nbr, str, sz)
int nbr ;
char str[] ;
int sz ;
{
	int lowbit ;

	if ( sz > 0 )
		str[--sz] = NULL ;
	else if ( sz < 0 )
			sz = -sz ;
		else
			while ( str[sz] != NULL )
				++sz ;
	while ( sz ) {
		lowbit = nbr & 1 ;
		nbr = (nbr >> 1) & 0x7fff ;  /* divide by 2 */
		str[--sz] = ( (nbr%5) << 1 ) + lowbit + '0' ;
		if ( (nbr/=5) == 0 )
			break ;
	}
	while ( sz )
		str[--sz] = ' ' ;
	return str ;
}


/*
 * itox -- converts nbr to hex string of length sz
 *	       right adjusted and blank filled, returns str
 *
 *	      if sz > 0 terminate with null byte
 *	      if sz  =  0 find end of string
 *	      if sz < 0 use last byte for data
 */
itox(nbr, str, sz)
int nbr ;
char str[] ;
int sz ;
{
	int digit, offset ;

	if ( sz > 0 )
		str[--sz] = NULL ;
	else if ( sz < 0 )
		sz = -sz ;
	else
		while ( str[sz] != NULL )
			++sz ;
	while ( sz ) {
		digit = nbr & 15 ;
		nbr = ( nbr >> 4 ) & 0xfff ;
		if ( digit < 10 )
			offset = 48 ;
		else
			offset = 55 ;
		str[--sz] = digit + offset ;
		if ( nbr == 0 )
			break ;
	}
	while ( sz )
		str[--sz] = ' ' ;
	return str ;
}

/*
 * _outc - output a single character
 *         if _String is not null send output to a string instead
 */
_outc(c, fd)
char c ;
int fd ;
{
	if ( _String == NULL )
		putc(c, fd) ;
	else
		*_String++ = c ;
	++_Count ;
}
