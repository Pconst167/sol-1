/*
 * zopt - five pass optimiser for small-C  (third pass)
 *        v2.0 - uses independent processes
 *
 */

#include <stdio.h>
#include <string.h>
#include "zopt.h"

pass3()
{
	int i, saved[9] ;
	char *temp, *tail ;
	char *last, *this, *next ;

	/* start pass 4 */
	switch_down(1) ;

	saved[0] = saved[1] = saved[2] = saved[3] = saved[4] = 0 ;
	saved[5] = saved[6] = saved[7] = saved[8] = i = 0 ;

	last = alloc(LINELEN) ;
	this = alloc(LINELEN) ;
	next = alloc(LINELEN) ;

	p_read(last) ;
	p_read(this) ;

	while ( p_read(next) ) {

		/* arithmetic shifts by constants */
		if ( strcmp(Exdehl,last) == 0 ) {
		  if ( tail=match(Ldhl,this) ) {
			if ( strcmp("\tCALL ccasl", next) == 0 ) {
			  if ( strlen(tail) == 1 && allnum(tail) ) {
				switch ( *tail ) {
					case '7' :	c_write(Addhlhl) ;
								--saved[1] ;
					case '6' :	c_write(Addhlhl) ;
								--saved[1] ;
					case '5' :	c_write(Addhlhl) ;
								--saved[1] ;
					case '4' :	c_write(Addhlhl) ;
								--saved[1] ;
					case '3' :	c_write(Addhlhl) ;
								--saved[1] ;
					case '2' :	c_write(Addhlhl) ;
								--saved[1] ;
					case '1' :	strcpy(last,Addhlhl) ;
								saved[1] += 6 ;
								++i ;
								p_read(this) ;
								p_read(next) ;
								break ;
					case '9' :	c_write(Addhlhl) ;
								--saved[1] ;
					case '8' :	strcpy(last,"\tLD H,L") ;
								strcpy(this,"\tLD L,0") ;
								p_read(next) ;
								++i ;
								saved[1] += 4 ;
								break ;
					case '0' :	p_read(last) ;
								p_read(this) ;
								p_read(next) ;
								saved[1] += 7 ;
								++i ;
								break ;
				}
			  }
			}
			else if (strcmp("\tCALL ccasr",next) == 0 &&
			 			strcmp("8",tail) == 0 ) {
				strcpy(last,"\tLD A,H") ;
				strcpy(this,"\tCALL ccsxt") ;
				p_read(next) ;
				saved[1] += 3 ;
				++i ;
			}
		  }
		}

		/* double EX DE,HL */
		if ( strcmp( Exdehl,last) == 0 ) {
		  if ( strcmp( Exdehl,this) == 0 ) {
		    temp = last ;
		    last = next ;
		    next = temp ;
		    p_read( this ) ;
		    p_read( next ) ;
		    ++saved[0] ;
		  }
		}


		/* ccgint to DE expanded */
		if ( strcmp("\tCALL ccgint",last) == 0 ) {
		  if ( strcmp(Exdehl,this) == 0 ) {
		    if ( match(Ldhl,next) |
				 strcmp(Pophl,next) == 0 ) {
			c_write( "\tLD E,(HL)" ) ;
			strcpy( last, Inchl ) ;
			strcpy( this, "\tLD D,(HL)" ) ;
			++saved[3] ;
		    }
		  }
		}

		/* skip in-line expansions if compact code wanted */
		if ( Compact == 0 ) {

			/* expand ccgint */
			if( strcmp("\tCALL ccgint", last) == 0 ) {
				c_write( "\tLD A,(HL)" ) ;
				c_write( Inchl ) ;
				c_write( "\tLD H,(HL)" ) ;
				strcpy( last, "\tLD L,A" ) ;
				--saved[4] ;
			}

			/* expand ccgchar to DE */
			if ( strcmp("\tCALL ccgchar",last) == 0 ) {
			  if ( strcmp(Exdehl,this) == 0 ) {
			    if ( match(Ldhl,next) ||
					 strcmp(Pophl,next) == 0 ) {
				c_write( "\tLD A,(HL)" ) ;
				c_write( "\tLD E,A" ) ;
				c_write( "\tRLCA" ) ;
				strcpy( last, "\tSBC A,A" ) ;
				strcpy( this, "\tLD D,A" ) ;
				--saved[6] ;
			    }
			  }
			}

			/* expand ccgchar */
			if ( strcmp("\tCALL ccgchar",last) == 0 ) {
				c_write( "\tLD A,(HL)" ) ;
				c_write( "\tLD L,A" ) ;
				c_write( "\tRLCA" ) ;
				c_write( "\tSBC A,A" ) ;
				strcpy( last, "\tLD H,A" ) ;
				--saved[7] ;
			}
		}

		c_write( last ) ;
		temp = last ;
		last = this ;
		this = next ;
		next = temp ;
		if (cpm(CONIN, 255) == CTRLC) exit() ;
	}
	c_write( last ) ;
	c_write( this ) ;

	puts("Double EX DE,HL:              "); putdec(saved[0]) ;
	putchar('\n') ;
	puts("Expand ccgint to DE:          "); putdec(saved[3]) ;
	putchar('\n') ;
	if ( Compact == FALSE ) {
		puts("Expand ccgint:                "); putdec(saved[4]) ;
		putchar('\n') ;
		puts("Expand ccgchar to DE:         "); putdec(saved[6]) ;
		putchar('\n') ;
		puts("Expand ccgchar:               "); putdec(saved[7]) ;
		putchar('\n') ;
	}
	puts("Shift by constant:            "); putdec(i) ;
	putchar('\n') ;
	putchar('\n') ;
	i = saved[0]*2 + saved[1] + saved[2] + saved[3] + saved[4] ;
	i += saved[6] + saved[7]*2 + saved[8] ;
	pr_total(i);

	Total += i ;
}
