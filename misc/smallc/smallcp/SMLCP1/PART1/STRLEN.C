/*
 *	STRING FUNCTIONS FOR SMALL C
 * 	BASED ON CORRESPONDING UNIX FUNCTIONS
 */

#include <stdio.h>
#include <string.h>

/*
strlen( string )
char *string ;
{
	int counter ;

	counter = 0 ;
	while( *string++ )
		counter++ ;
	return counter ;
}
*/

#asm
qstrlen:
	POP HL
	POP BC
	PUSH BC
	PUSH HL
	LD HL,0
ccstr3:
	LD A,(BC)
	OR A
	RET Z
	INC BC
	INC HL
	JP ccstr3
#endasm
