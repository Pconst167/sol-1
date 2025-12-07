/*
 *	STRING FUNCTIONS FOR SMALL C
 * 	BASED ON CORRESPONDING UNIX FUNCTIONS
 */

#include <stdio.h>
#include <string.h>

/*
 * strchr - return pointer to first occurrence of c in string, else 0
 */
strchr( string, c )
char *string, c ;
{
	while( *string ) {
		if( *string == c ) return string ;
		++string ;
	}
	return 0 ;
}
