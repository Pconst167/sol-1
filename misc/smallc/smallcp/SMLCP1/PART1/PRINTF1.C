/*
 *	printf1 - generic _printf routine for integer-only operation
 *
 *	Compile with -m option
 *
 *	R M Yorston 1987
 */


#include <stdio.h>

#define NULL 0
#define ERR -1

extern char *_String ;
extern int _Count ;
extern utoi(), itod(), itou(), itox(), _outc() ;


_printf(fd, nxtarg)
int fd ;
int *nxtarg ;
{
	int i, prec, preclen, len ;
	char c, right, str[7], pad;
	int width ;
	char *sptr, *ctl, *cx ;

	_Count = 0 ;
	ctl = *nxtarg ;
	while ( c = *ctl++ ) {
		if (c != '%' ) {
			_outc(c, fd) ;
			continue ;
		}
		if ( *ctl == '%' ) {
			_outc(*ctl++, fd) ;
			continue ;
		}
		cx = ctl ;
		if ( *cx == '-' ) {
			right = 0 ;
			++cx ;
		}
		else
			right = 1 ;
		if ( *cx == '0' ) {
			pad = '0' ;
			++cx ;
		}
		else
			pad = ' ' ;
		if ( (i=utoi(cx, &width)) >= 0 )
			cx += i ;
		else
			continue  ;
		if (*cx=='.') {
			if ( (preclen=utoi(++cx, &prec)) >= 0 )
				cx += preclen ;
			else
				continue ;
		}
		else
			preclen = 0 ;
		sptr = str ;
		c = *cx++ ;
		i = *(--nxtarg) ;
		switch(c) {
			case 'd' :
				itod(i, str, 7) ;
				break ;
			case 'x' :
				itox(i, str, 7) ;
				break ;
			case 'c' :
				str[0] = i ;
				str[1] = NULL ;
				break ;
			case 's' :
				sptr = i ;
				break ;
			case 'u' :
				itou(i, str, 7) ;
				break ;
			default:
				continue ;
		}
		ctl = cx ; /* accept conversion spec */
		if ( c != 's' )
			while ( *sptr == ' ' )
				++sptr ;
		len = -1 ;
		while ( sptr[++len] )
			; /* get length */
		if ( c == 's' && len>prec && preclen>0 )
			len = prec ;
		if (right)
			while ( ((width--)-len) > 0 )
				_outc(pad, fd) ;
		while ( len ) {
			_outc(*sptr++, fd) ;
			--len ;
			--width ;
		}
		while ( ((width--)-len) > 0 )
			_outc(pad, fd) ;
	}
	if (_String != 0) *_String = '\000' ;
	return(_Count) ;
}
