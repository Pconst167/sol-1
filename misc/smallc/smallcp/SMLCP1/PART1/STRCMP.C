/*
 *	STRING FUNCTIONS FOR SMALL C
 * 	BASED ON CORRESPONDING UNIX FUNCTIONS
 */

#include <stdio.h>
#include <string.h>

/*
strcmp( s1, s2 )
char *s1, *s2 ;
{
	while( *s1 == *s2 ) {
		if( *s1 == 0 )
			return 0 ;
		s1++ ;
		s2++ ;
	}
	return *s1 - *s2 ;
}
*/

#asm
qstrcmp:
	POP BC
	POP HL		;HL is s2
	POP DE		;DE is s1
	PUSH DE
	PUSH HL
	PUSH BC
ccstr1:
	LD A,(DE)	;fetch *s1
	CP (HL)
	JP NZ,ccstr6	;quit if *s1 != *s2
	OR A		;check *s1 for zero
	INC DE
	INC HL
	JP NZ,ccstr1	;loop if *s1 != 0
	LD HL,0
	RET
ccstr6:
	SUB (HL)
	JP ccsxt	;else return *s1-*s2
#endasm
