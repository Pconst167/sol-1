/*
 * Main interface to scanf-type routines, independent of integer/float
 *
 * scanf(controlstring, arg, arg, ...)  or 
 * sscanf(string, controlstring, arg, arg, ...) or
 * fscanf(file, controlstring, arg, arg, ...) --  formatted read
 *        operates as described by Kernighan & Ritchie
 */


#include <stdio.h>
#include <ctype.h>

#define NULL 0
#define ERR (-1)


char *_String1 ;
int _Oldch ;

scanf(args)
int args ;
{
	_String1 = NULL ;
	return( _scanf(stdin, _argcnt() + &args - 1) ) ;
}

fscanf(args)
int args ;
{
	int *nxtarg ;

	_String1 = NULL ;
	nxtarg = _argcnt() + &args ;
	return( _scanf( *(--nxtarg), --nxtarg ) ) ;
}

sscanf(args)
int args ;
{
	int *nxtarg ;

	nxtarg = _argcnt() + &args - 1 ;
	_String1 = *nxtarg ;
	return( _scanf( stdout, --nxtarg ) ) ;
}


/*
 * _getc - fetch a single character from file
 *         if _String1 is not null fetch from a string instead
 */
_getc(fd)
int fd ;
{
	int c ;

	if ( _Oldch != EOF ) {
		c = _Oldch ;
		_Oldch = EOF ;
		return c ;
	}
	else {
		if ( _String1 != NULL ) {
			if ( (c=*_String1++) ) return c ;
			else {
				--_String1 ;
				return EOF ;
			}
		}
		else {
			return getc(fd) ;
		}
	}
}

/*
 * unget character assume only one source of characters
 * i.e. does not require file descriptor
 */
_ungetc(ch)
int ch ;
{
	_Oldch = ch ;
}
