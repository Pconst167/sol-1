/*
 * Core routine for scanf-type functions, including floating point
 *        only e, f, d, o, x, c, s, and u specs are supported.
 *        Also includes atof()
 */


#include <ctype.h>
#include <stdio.h>
#include "float.h"

#define NULL 0
#define ERR (-1)


extern int _Oldch ;
extern int _getc(), _ungetc(), utoi() ;


/* decimal to (double) binary conversion */

atof(s)
char s[];		/* s points to a character string */
{
	double sum,		/* the partial result */
		scale;		/* scale factor for the next digit */
	char *start,	/* copy if input pointer */
		*end,		/* points to end of number */
		c;			/* character from input line */
	int minus,		/* nonzero if number is negative */
		dot,		/* nonzero if *s is decimal point */
		decimal;	/* nonzero if decimal point found */

	if ( *s == '-' ) { minus = 1 ; ++s ; }
	else minus = 0 ;
	start = s ;
	decimal = 0 ;  /* no decimal point seen yet */
	while( (dot=(*s=='.')) || isdigit(*s) ) {
		if ( dot ) ++decimal ;
		++s ;	/* scan to end of string */
	}
	end = s ;
	sum = 0.0 ;		/* initialize answer */
	if ( decimal ) {
		/* handle digits to right of decimal */
		--s ;
		while ( *s != '.' )
			sum = ( sum + float( *(s--) - '0' ) ) / 10.0 ;
	}
	scale = 1.0 ;	/* initialize scale factor */
	while ( --s >= start ) {
		/* handle remaining digits */
		sum += scale * float( *s-'0' ) ;
		scale *= 10.0 ;
	}
	c = *end++ ;
	if( tolower(c)=='e' ) {	/* interpret exponent */
		int neg ;		/* nonzero if exp negative */
		int expon ;		/* absolute value of exp */
		int k ;			/* mask */

		neg = expon = 0 ;
		if ( *end == '-' ) {
			/* negative exponent */
			neg = 1 ;
			++end ;
		}
		while(1) {	/* read an integer */
			if ( (c=*end++) >= '0' ) {
				if ( c <= '9' ) {
					expon = expon * 10 + c - '0' ;
					continue ;
				}
			}
			break;
		}
		if ( expon > 38 ) {
			puts("overflow") ;
			expon = 0 ;
		}
		k = 32 ;	/* set one bit in mask */
		scale = 1.0 ;
		while(k) {
			scale *= scale;
			if ( k & expon ) scale *= 10.0 ;
			k >>= 1 ;
		}
		if(neg) sum /= scale;
		else    sum *= scale;
	}
	if (minus) sum = -sum ;
	return sum ;
}

_scanf(fd, nxtarg)
int fd, *nxtarg ;
{
	char *carg, *ctl, *unsigned, fstr[40] ;
	int *narg, wast, ac, width, ch, cnv, base, ovfl, sign ;
	double *farg ;

	_Oldch = EOF ;
	ac = 0 ;
	ctl = *nxtarg-- ;
	while ( *ctl) {
		if ( isspace(*ctl) ) { ++ctl; continue; }
		if ( *ctl++ != '%' ) continue ;
		if ( *ctl == '*' ) { farg = narg = carg = &wast; ++ctl; }
		else                 farg = narg = carg = *nxtarg-- ;
		ctl += utoi(ctl, &width) ;
		if ( !width ) width = 32767 ;
		if ( !(cnv=*ctl++) ) break ;
		while ( isspace(ch=_getc(fd)) )
			;
		if ( ch == EOF ) {
			if (ac) break ;
			else return EOF ;
		}
		_ungetc(ch) ;
		switch(cnv) {
			case 'c' :
				*carg = _getc(fd) ;
				break ;
			case 's' :
				while ( width-- ) {
					if ( (*carg=_getc(fd)) == EOF ) break ;
					if ( isspace(*carg) ) break ;
					if ( carg != &wast ) ++carg ;
				}
				*carg = 0 ;
				break ;
			case 'e' :
			case 'f' :
				if ( width > 39 ) width = 39 ;
				_getf(fstr, fd, width) ;
				*farg = atof(fstr) ;
				break ;
			default :
				switch(cnv) {
					case 'd' : base = 10 ; sign = 0 ; ovfl = 3276 ; break ;
					case 'o' : base =  8 ; sign = 1 ; ovfl = 8191 ; break ;
					case 'u' : base = 10 ; sign = 1 ; ovfl = 6553 ; break ;
					case 'x' : base = 16 ; sign = 1 ; ovfl = 4095 ; break ;
					default : return ac ;
				}
				*narg = unsigned = 0 ;
				while ( width-- && !isspace(ch=_getc(fd)) && ch!=EOF ) {
					if ( !sign )
						if ( ch == '-' ) { sign = -1; continue; }
						else sign = 1 ;
					if ( ch < '0' ) return ac ;
					if ( ch >= 'a') ch -= 87 ;
					else if ( ch >= 'A' ) ch -= 55 ;
					else ch -= '0' ;
					if ( ch >= base || unsigned > ovfl ) return ac ;
					unsigned = unsigned * base + ch ;
				}
				*narg = sign * unsigned ;
		}
		++ac ;
	}
	return ac ;
}


/*
 * _getf - fetch string representation of floating point number
 *         from file (or string).  Maximum number of characters
 *         examined is width.
 */
_getf(s, fd, width)
char *s ;			/* result string */
int fd ;			/* file descriptor */
int width ;			/* number of characters to be examined */
{
	int i ;

	i = 1 ;
	*s = _getc(fd) ;
	if ( isdigit(*s) || *s == '-' || *s == '.' ) {
		if ( *s != '.' ) {
			/* fetch figures before point */
			while ( isdigit(*++s=_getc(fd)) ) {
				if ( ++i > width ) {
					_ungetc(*s) ;
					*s = NULL ;
					return ;
				}
			}
		}
		if ( *s == '.' ) {
			/* fetch figures after point */
			while ( isdigit(*++s=_getc(fd)) ) {
				if ( ++i > width ) {
					_ungetc(*s) ;
					*s = NULL ;
					return ;
				}
			}
		}
		/* check for exponent */
		if ( tolower(*s) == 'e' ) {
			*++s = _getc(fd) ;
			if ( ++i > width ) {
				_ungetc(*s) ;
				*s = NULL ;
				return ;
			}
			if ( isdigit(*s) || *s == '-' ) {
				/* fetch figures of exponent */
				while ( isdigit(*++s=_getc(fd)) ) {
					if ( ++i > width ) {
						_ungetc(*s) ;
						*s = NULL ;
						return ;
					}
				}
			}
		}
	}
	_ungetc(*s) ;
	*s = NULL ;
}
