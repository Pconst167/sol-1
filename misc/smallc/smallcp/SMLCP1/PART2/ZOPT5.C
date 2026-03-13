/*
 * zopt - five pass optimiser for small-C  (fifth pass)
 *        v2.0 - uses independent processes
 *
 */

#include <stdio.h>
#include <string.h>
#include "zopt.h"

char *l1, *l2, *l3, *l4, *l5, *l6, *l7, *l8, *l9, *l10 ;

pass5()
{
	int saved[2] ;
	int i ;
	char *tail, *tail2, *temp ;

	saved[0] = saved[1] = 0 ;

	l1 = alloc(LINELEN) ;
	l2 = alloc(LINELEN) ;
	l3 = alloc(LINELEN) ;
	l4 = alloc(LINELEN) ;
	l5 = alloc(LINELEN) ;
	l6 = alloc(LINELEN) ;
	l7 = alloc(LINELEN) ;
	l8 = alloc(LINELEN) ;
	l9 = alloc(LINELEN) ;
	l10 = alloc(LINELEN) ;

	p_read(l1) ;
	p_read(l2) ;
	p_read(l3) ;
	p_read(l4) ;
	p_read(l5) ;
	p_read(l6) ;
	p_read(l7) ;
	p_read(l8) ;
	p_read(l9) ;

	while ( p_read(l10) ) {

		/* JP Z around unconditional return */
		saved[0] += jp_ret("\tJP Z,", "\tRET NZ") ;

		/* JP NZ around unconditional return */
		saved[0] += jp_ret("\tJP NZ,", "\tRET Z") ;

		/* change small forward jump to relative jump */
		if ( (tail=match("\tJP Z,", l1)) || (tail=match("\tJP NZ,", l1)) ||
					(tail=match("\tJP ", l1)) ) {
		  if ( (tail2=match(tail, l3)) || (tail2=match(tail, l4)) ||
				(tail2=match(tail, l5)) || (tail2=match(tail, l6)) ||
				(tail2=match(tail, l7)) || (tail2=match(tail, l8)) ||
				(tail2=match(tail, l9)) || (tail2=match(tail, l10)) ) {
			if ( tail2[0] == ':' ) {
			  l1[2] = 'R' ;
			  ++saved[1] ;
			}
		  }
		}

		/* change small backward jump to relative jump */
		if ( (tail=match("\tJP Z,", l10)) || (tail=match("\tJP NZ,", l10)) ||
					(tail=match("\tJP ", l10)) ) {
		  if ( (tail2=match(tail, l8)) || (tail2=match(tail, l7)) ||
				(tail2=match(tail, l6)) || (tail2=match(tail, l5)) ||
				(tail2=match(tail, l4)) || (tail2=match(tail, l3)) ||
				(tail2=match(tail, l2)) || (tail2=match(tail, l1)) ) {
			if ( tail2[0] == ':' ) {
			  l10[2] = 'R' ;
			  ++saved[1] ;
			}
		  }
		}

		putline(l1);	
		temp = l1;
		l1 = l2;
		l2 = l3;
		l3 = l4;
		l4 = l5;
		l5 = l6;
		l6 = l7;
		l7 = l8;
		l8 = l9;
		l9 = l10;
		l10 = temp;
		if (cpm(CONIN, 255) == CTRLC) exit() ;
	}
	putline(l1);
	putline(l2);
	putline(l3);
	putline(l4);
	putline(l5);
	putline(l6);
	putline(l7);
	putline(l8);
	putline(l9);

	puts("Cond JP round uncond RET      "); putdec(saved[0]) ;
	putchar('\n') ;
	puts("Relative jump                 "); putdec(saved[1]) ;
	putchar('\n') ;
	putchar('\n') ;
	i = saved[0]*3 + saved[1] ;
	pr_total(i);

	Total += i ;
}

/*
 * change conditional jump around uncontional return
 * to conditional return
 * return 1 if substitution made, else 0
 */
jp_ret(jump, rtn)
char *jump, *rtn ;
{
	char *temp, *tail, *tail2 ;

	if ( (tail=match(jump, l8)) ) {
	  if ( (tail2=match(tail, l10)) && tail2[0] == ':' ) {
		if ( strcmp(Ret, l9) == 0 ) {
		  strcpy(l8, rtn) ;
		  temp = l9 ;
		  l9 = l10 ;
		  l10 = temp ;
		  p_read(l10) ;
		  return 1 ;
		}
	  }
	}
	return 0 ;
}
