/*
 *	STRING FUNCTIONS FOR SMALL C
 * 	BASED ON CORRESPONDING UNIX FUNCTIONS
 */

#include <stdio.h>
#include <string.h>

/*
 *  strncat - concatenate n bytes max from from to end of to
 *            to must be long enough
 */
strncat( to, from, n )
char *to, *from ;
int n ;
{
	char *temp ;

	temp = to ;
	--to ;
	while( *++to ) ;
	while( n-- ) {
		if( *to++ = *from++ ) continue ;
		return temp ;
	}
	*to = 0 ;
	return temp ;
}
