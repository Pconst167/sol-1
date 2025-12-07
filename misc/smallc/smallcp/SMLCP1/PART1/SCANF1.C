/*
 * Core routine for integer-only scanf-type functions
 *        only d, o, x, c, s, and u specs are supported.
 */


#include <ctype.h>
#include <stdio.h>

#define NULL 0
#define ERR (-1)


extern int _Oldch ;
extern _getc(), _ungetc(), utoi() ;


_scanf(fd, nxtarg)
int fd, *nxtarg ;
{
	char *carg, *ctl, *unsigned ;
	int *narg, wast, ac, width, ch, cnv, base, ovfl, sign ;

	_Oldch = EOF ;
	ac = 0 ;
	ctl = *nxtarg-- ;
	while ( *ctl) {
		if ( isspace(*ctl) ) { ++ctl; continue; }
		if ( *ctl++ != '%' ) continue ;
		if ( *ctl == '*' ) { narg = carg = &wast; ++ctl; }
		else                 narg = carg = *nxtarg-- ;
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
