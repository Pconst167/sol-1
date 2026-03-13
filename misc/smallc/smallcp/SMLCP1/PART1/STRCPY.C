/*
 *	STRING FUNCTIONS FOR SMALL C
 * 	BASED ON CORRESPONDING UNIX FUNCTIONS
 */

#include <stdio.h>
#include <string.h>


/*
strcpy( to, from )
char *to, *from ;
{
	char *temp ;

	temp = to ;
	while( *to++ = *from++ ) ;
	return temp ;
}
*/

#asm
qstrcpy:
	POP HL
	POP DE		;DE is from
	POP BC		;BC is to
	PUSH BC
	PUSH DE
	PUSH HL
	LD H,B		;return to
	LD L,C
ccstr2:
	LD A,(DE)
	LD (BC),A
	INC DE
	INC BC
	OR A		;test char for zero
	JP NZ,ccstr2
	RET
#endasm
