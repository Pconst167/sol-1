#include <stdio.h>

#define MWRITE 17325

#define CR 13
#define LF 10

extern int _fnext[], _flast[] ;

/*
 * fputs - write string c to file fd
 *
 * uses knowledge of buffering internals to
 * write without going through putb, so avoiding repeated _fchk's
 * return -1 on error, or number of characters sent to file
 */
fputs(c,fd)
char *c ;
FILE *fd ;
{
	int last, index ;
	char *s, *next ;

	s = c-- ;
	if ( fd == 1 ) {
		while ( *++c ) {
			if ( putchar(*c) != *c ) {
				return -1 ;
			}
		}
		return c-s ;
	}

	index = fd-5;
	if ( _fchk(index) != MWRITE ) {
		err("CAN\'T WRITE TO INFILE") ;
		exit() ;
	}

	next = _fnext[index] ;
	last = _flast[index] ;

	while ( *++c ) {
		if( next == last ) {
			_fnext[index] = next ;
			if ( fflush(fd) ) 
				return -1 ;
			next = _fnext[index] ;
		}
		*next++ = *c ;

		if ( *c == CR ) {
			/* output LF after CR */
			if ( next == last ) {
				_fnext[index] = next ;
				if ( fflush(fd) )
					return -1 ;
				next = _fnext[index] ;
			}
			*next++ = LF ;
		}

	}
	_fnext[index] = next ;
	return c-s ;
}
