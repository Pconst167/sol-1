/*
 *	STRING FUNCTIONS FOR SMALL C
 * 	BASED ON CORRESPONDING UNIX FUNCTIONS
 */

#include <stdio.h>
#include <string.h>

/*
 *  strncmp - compares two strings for at most n characters
 *            and returns an integer >0, =0 or <0 as
 *            s is >t, =t or <t
 */
strncmp( s, t, n )
char *s, *t ;
int n ;
{
	while( n!=0 & *s==*t ) {
		if( *s == 0 ) return 0 ;
		++s ;
		++t ;
		--n ;
	}
	if( n ) return *s - *t ;
	return 0 ;
}
