/*
 * zopt - five pass optimiser for small-C  (fourth pass)
 *        v2.0 - uses independent processes
 *
 *
 */

#include <stdio.h>
#include <string.h>
#include "zopt.h"

/*
 * uncomma - split string with two tokens separated by commas
 */
uncomma(string, token1, token2)
char *string, *token1, *token2 ;
{
	int i;

	while ( *string != ',' )
		*token1++ = *string++ ;
	*token1 = 0 ;
	++string ;
	i = 0 ;
	while ( (*string != NULL) & (i < 19) ) {
		*token2++ = *string++ ;
		++i ;
	}
	*token2 = 0 ;
}

/*
 * process conditional jump round unconditional call/jump
 */
jumps(s1, s2, s3, save, last, this, next)
char *s1 ;			/* conditional */
char *s2 ;			/* unconditional */
char *s3 ;			/* replacement */
int *save ;			/* counter for saved bytes */
char **last ;
char **this ;
char **next ;
{
	char line[LINELEN], *temp, *tail ;

	/* jump on non-zero round unconditional call */
	if ( tail=match(s1, *last) ) {
	  if ( tail=match(tail, *next) ) {
	    if ( *tail == ':' ) {
	      if ( tail=match(s2, *this) ) {
			/* check there isn't a condition after JP/CALL */
			if (islower(*tail)) {
			  strcpy(line, s3) ;
			  strcat(line, tail) ;
			  strcpy(*last, line) ;
			  temp = *this ;
			  *this = *next ;
			  *next = temp ;
			  p_read(*next) ;
			  ++(*save) ;
			}
	      }
	    }
	  }
	}
}

pass4()
{
	int i, saved[7] ;
	char source1[20], source2[20], dest1[20], dest2[20] ;
	char line[LINELEN] ;
	char *tail, *tail2, *temp ;
	char *last, *this, *next ;

	/* start pass 5 */
	switch_down(1) ;

	saved[0] = saved[1] = saved[2] = saved[3] = saved[4] = 0 ;
	saved[5] = saved[6] = 0 ;

	last = alloc(LINELEN) ;
	this = alloc(LINELEN) ;
	next = alloc(LINELEN) ;

	p_read(last) ;
	p_read(this) ;

	while ( p_read(next) ) {


		/* ld hl, ex, ld hl -> ld de, ld hl */
		if ( tail=match(Ldhl,last) ) {
		  if ( strcmp(Exdehl,this) == 0 ) {
		    if ( match(Ldhl,next) ) {
			if ( *tail != '(' ) {
				strcpy( line, Ldde ) ;
				strcat( line, tail ) ;
				strcpy( last, line ) ;
				temp = this ;
				this = next ;
				next = temp ;
				p_read( next ) ;
				++saved[0] ;
			}
		    }
		  }
		}

		/* jump on zero round unconditional jump */
		jumps("\tJP Z,", "\tJP ", "\tJP NZ,", &saved[1], &last, &this, &next) ;

		/* jump on non-zero round unconditional jump */
		jumps("\tJP NZ,", "\tJP ", "\tJP Z,", &saved[1], &last, &this, &next) ;

		/* store followed by load */
		if ( tail=match("\tLD ",this) ) {
		  if ( tail2=match("\tLD ",next) ) {
			uncomma( tail, dest1, source1 ) ;
			uncomma( tail2, dest2, source2 ) ;
			if ( strcmp(dest1,source2) == 0 ) {
			  if ( strcmp(dest2,source1) == 0 ) {
				p_read( next ) ;
				++saved[2] ;
			  }
			}
		  }
		}

		/* jump on zero round unconditional call */
		jumps("\tJP Z,", "\tCALL ", "\tCALL NZ,", &saved[3], &last, &this, &next) ;

		/* jump on non-zero round unconditional call */
		jumps("\tJP NZ,", "\tCALL ", "\tCALL Z,", &saved[3], &last, &this, &next) ;

		/* two succeeding unconditional jumps */
		if ( tail=match("\tJP ",this) ) {
			if (islower(*tail)) {
				if ( match("\tJP ",next) ) {
					if (islower(*tail)) {
						p_read(next) ;
						++saved[4] ;
					}
				}
			}
		}

		/* CALL ; RET ->  JP */
		/* (only for well-behaved routines) */
		if ( tail=match("\tCALL ",this) ) {
		  if ( strcmp("\tRET",next) == 0 ) {
			if ( *tail == 'q' ) {
			  strcpy(line,"\tJP " ) ;
			  strcat(line,tail) ;
			  strcpy(this,line);
			  p_read(next);
			  ++saved[5] ;
			}
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

	puts("LD HL;EX;LD HL > LD DE;LD HL: "); putdec(saved[0]) ;
	putchar('\n') ;
	puts("JP Z/NZ round JP:             "); putdec(saved[1]) ;
	putchar('\n') ;
	puts("JP Z/NZ round CALL:           "); putdec(saved[3]) ;
	putchar('\n') ;
	puts("Store followed by load:       "); putdec(saved[2]) ;
	putchar('\n') ;
	puts("Two unconditional jumps:      "); putdec(saved[4]) ;
	putchar('\n');
	puts("CALL; RET -> JP:              "); putdec(saved[5]) ;
	putchar('\n') ;
	putchar('\n') ;
	i = saved[0] + saved[1]*3 + saved[2]*2 + saved[3]*3 + saved[4]*3 ;
	i += saved[5] ;
	pr_total(i);

	Total += i ;
}
