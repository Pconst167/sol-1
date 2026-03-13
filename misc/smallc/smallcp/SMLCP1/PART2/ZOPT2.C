/*
 * zopt - five pass optimiser for small-C  (second pass)
 *        v2.0 - uses independent processes
 *
 */

#include <stdio.h>
#include <string.h>
#include "zopt.h"

char *ln1, *ln2, *ln3, *ln4, *ln5, *ln6 ;

pass2()
{
	int saved[12] ;
	int i ;
	char line[LINELEN] ;
	char *tail, *arg, *temp, *temp2, *temp3 ;

	/* start pass 3 */
	switch_down(1) ;

	saved[0] = saved[1] = saved[2] = saved[3] = 0 ;
	saved[4] = saved[5] = saved[6] = saved[7] = saved[8] = 0 ;
	saved[9] = saved[10] = saved[11] = 0 ;

	ln1 = alloc(LINELEN) ;
	ln2 = alloc(LINELEN) ;
	ln3 = alloc(LINELEN) ;
	ln4 = alloc(LINELEN) ;
	ln5 = alloc(LINELEN) ;
	ln6 = alloc(LINELEN) ;

	p_read(ln1) ;
	p_read(ln2) ;
	p_read(ln3) ;
	p_read(ln4) ;
	p_read(ln5) ;

	while ( p_read(ln6) ) {

		/* inc or dec top or second on stack */
		if ( strcmp(Ldhl0,ln1) == 0 ||
			 strcmp(Ldhl2,ln1) == 0 ||
			 strcmp(Ldhl4,ln1) == 0 ||
			 strcmp(Ldhl6,ln1) == 0 ) {

			if ( strcmp("\tADD HL,SP",ln2) == 0 &&
				 strcmp(Pushhl,ln3) == 0 &&
				 strcmp("\tCALL ccgint",ln4) == 0 &&
				 (strcmp(Inchl,ln5) == 0 || strcmp(Dechl,ln5) == 0) &&
				 strcmp("\tCALL ccpint",ln6) == 0 ) {

				if ( strcmp(Ldhl6,ln1) == 0 ) {
					c_write(Popix);
					c_write(Popde);
					c_write(Popbc);
				}
				else if ( strcmp(Ldhl4,ln1) == 0 ) {
					c_write(Popde);
					c_write(Popbc);
				}
				else if ( strcmp(Ldhl2,ln1) == 0 ) {
					c_write(Popbc);
				}
				c_write(Pophl);
				c_write(ln5);
				if ( strcmp(Ldhl6,ln1) == 0 ) {
					c_write(Pushhl);
					c_write(Pushbc);
					c_write(Pushde);
					strcpy(ln1,Pushix);
					++saved[3];
				}
				else if ( strcmp(Ldhl4,ln1) == 0 ) {
					c_write(Pushhl);
					c_write(Pushbc);
					strcpy(ln1,Pushde);
					++saved[2];
				}
				else if ( strcmp(Ldhl2,ln1) == 0 ) {
					c_write(Pushhl);
					strcpy(ln1,Pushbc);
					++saved[1];
				}
				else {
					strcpy(ln1,Pushhl);
					++saved[0] ;
				}
				p_read(ln2);
				p_read(ln3);
				p_read(ln4);
				p_read(ln5);
				p_read(ln6);
			}
		}

		/* check for comparison against small constant and jump */
		if ( strcmp(Exdehl, ln1) == 0 &&
			 (arg=match(Ldhl, ln2)) && 
			(strcmp("\tCALL cceq",ln3) == 0 || strcmp("\tCALL ccne",ln3) == 0) )

		  if ( strcmp("\tLD A,H", ln4) == 0 &&
			 strcmp("\tOR L", ln5) == 0 &&
			((tail=match("\tJP NZ,",ln6)) || (tail=match("\tJP Z,",ln6)))) {

			  if ( (i=chk_arg(arg)) != 0 ) {
				if ( strcmp("\tCALL cceq",ln3) == 0 ) {
					if ( match("\tJP NZ,",ln6 ) ) {
						strcpy(line, "\tJP Z,") ;
					}
					else {
						strcpy(line, "\tJP NZ,") ;
					}
					strcat(line, tail) ;
					strcpy(ln6, line) ;
				}
				temp = ln1 ;
				temp2 = ln2 ;
				temp3 = ln3 ;
				ln1 = ln4 ;
				ln2 = ln5 ;
				ln3 = ln6 ;
				ln4 = temp ;
				ln5 = temp2 ;
				ln6 = temp3 ;
				p_read(ln4) ;
				p_read(ln5) ;
				p_read(ln6) ;
				++saved[3+i] ;
			}
		}

		/* lh hl,0 after test has ensured hl is zero */
		if ( strcmp("\tLD A,H", ln1) == 0 ) {
		  if ( strcmp("\tOR L", ln2) == 0 ) {
			if ( match("\tJP NZ,", ln3) ) {
			  if ( strcmp(Ldhl0, ln4) == 0 ) {
				temp = ln4 ;
				ln4 = ln5 ;
				ln5 = ln6 ;
				ln6 = temp ;
				p_read(ln6) ;
				++saved[9] ;
			  }
			}
		  }
		}

		/* return TOS, one item on stack */
		if ( strcmp(Pophl, ln3) == 0 ) {
		  if ( strcmp(Pushhl, ln4) == 0 ) {
			if ( strcmp(Popbc, ln5) == 0 ) {
			  if ( strcmp(Ret, ln6) == 0 ) {
				strcpy(ln4, Ret) ;
				p_read(ln5) ;
				p_read(ln6) ;
				++saved[10] ;
			  }
			}
		  }
		}

		/* return TOS, two items on stack */
		if ( strcmp(Pophl, ln2) == 0 ) {
		  if ( strcmp(Pushhl, ln3) == 0 ) {
			if ( strcmp(Popbc, ln4) == 0 ) {
			  if ( strcmp(Popbc, ln5) == 0 ) {
				if ( strcmp(Ret, ln6) == 0 ) {
				  strcpy(ln3, Popbc) ;
				  strcpy(ln4, Ret) ;
				  p_read(ln5) ;
				  p_read(ln6) ;
				  ++saved[11] ;
				}
			  }
			}
		  }
		}

		c_write(ln1);	
		temp = ln1;
		ln1 = ln2;
		ln2 = ln3;
		ln3 = ln4;
		ln4 = ln5;
		ln5 = ln6;
		ln6 = temp;
		if (cpm(CONIN, 255) == CTRLC) exit() ;
	}
	c_write(ln1);
	c_write(ln2);
	c_write(ln3);
	c_write(ln4);
	c_write(ln5);

	puts("INC or DEC top of stack       "); putdec(saved[0]) ;
	putchar('\n') ;
	puts("INC or DEC 2nd top of stack   "); putdec(saved[1]) ;
	putchar('\n') ;
	puts("INC or DEC 3rd top of stack   "); putdec(saved[2]) ;
	putchar('\n') ;
	puts("INC or DEC 4th top of stack   "); putdec(saved[3]) ;
	putchar('\n') ;
	puts("Test for == or != zero        "); putdec(saved[4]) ;
	putchar('\n') ;
	puts("Test for == or != +/-1        "); putdec(saved[5]) ;
	putchar('\n') ;
	puts("Test for == or != +/-2        "); putdec(saved[6]) ;
	putchar('\n') ;
	puts("Test for == or != +/-3        "); putdec(saved[7]) ;
	putchar('\n') ;
	puts("Test for == or != constant    "); putdec(saved[8]) ;
	putchar('\n') ;
	puts("LD HL,0 when HL is zero       "); putdec(saved[9]) ;
	putchar('\n') ;
	puts("Return TOS, one item on stack "); putdec(saved[10]) ;
	putchar('\n') ;
	puts("Return TOS, two on stack      "); putdec(saved[11]) ;
	putchar('\n') ;
	putchar('\n') ;
	i = saved[0]*9 + saved[1]*7  + saved[2]*5 + saved[3] ;
	i += saved[4]*7 + saved[5]*6 + saved[6]*5 + saved[7]*4 ;
	i += saved[8]*3 + saved[9]*3 + saved[10]*2 + saved[11]*2 ;
	pr_total(i);

	Total += i ;
}

/*
 * check that argument of LD HL is a constant
 * if it is, subtract it from contents of primary register
 * return 1 if integer was 0
 *        2                1
 *        3                2
 *        4                3
 *        5                anything else
 */
chk_arg(arg)
char *arg ;
{
	char temp[80], *sign ;
	int i ;

	i = 0 ;
	if ( arg[1] == 0 ) {
		switch ( arg[0] ) {
		case '3' :
			++i ;
			c_write(Dechl) ;
		case '2' :
			++i ;
			c_write(Dechl) ;
		case '1' :
			++i ;
			c_write(Dechl) ;
		case '0' :
			++i ;
			return i ;
		}
	}
	else if ( arg[0] == '-' && arg[2] == 0 ) {
		switch ( arg[1] ) {
		case '3' :
			++i ;
			c_write(Inchl) ;
		case '2' :
			++i ;
			c_write(Inchl) ;
		case '1' :
			i += 2;
			c_write(Inchl) ;
			return i ;
		}
	}

	/* not a *very* small integer, is it an integer at all? */

	/* prepare to change sign of argument */
	sign = "-" ;
	if ( arg[0] == '-' ) {
		/* negative number changed to positive */
		sign = "" ;
		++arg ;
	}
	if ( allnum(arg) ) {
		strcpy(temp, Ldde) ;
		strcat(temp, sign) ;
		strcat(temp, arg) ;
		c_write(temp) ;
		c_write(Addhlde) ;
		return 5 ;
	}
	return 0 ;
}
