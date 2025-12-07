/*
 *	STRING FUNCTIONS FOR SMALL C
 * 	BASED ON CORRESPONDING UNIX FUNCTIONS
 */

#include <stdio.h>
#include <string.h>

/*
 *  strrchr - search string for rightmost occurrence of c
 *           returns pointer to rightmost c or NULL
 */
strrchr( string, c )
char *string, c ;
{
	char *ptr ;

	ptr = 0 ;
	while( *string ) {
		if( *string == c ) ptr = string ;
		++string ;
	}
	return ptr ;
}
