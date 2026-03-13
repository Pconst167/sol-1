/*
 *	STRING FUNCTIONS FOR SMALL C
 * 	BASED ON CORRESPONDING UNIX FUNCTIONS
 */

#include <stdio.h>
#include <string.h>

/*
strcat( to, from )
char *to, *from ;
{
	char *temp ;

	temp = to ;
	while( *to++ ) ;
	to-- ;
	while( *to++ = *from++ ) ;
	return temp ;
}
*/

#asm
qstrcat:
	POP HL
	POP BC		;BC is from
	POP DE		;DE is to
	PUSH DE
	PUSH BC
	PUSH HL
	LD H,D		;return to
	LD L,E
ccstr4:
	LD A,(DE)
	OR A
	INC DE
	JP NZ,ccstr4
	DEC DE
ccstr5:
	LD A,(BC)
	LD (DE),A
	INC DE
	INC BC
	OR A
	RET Z
	JP ccstr5
#endasm
