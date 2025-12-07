#include <stdio.h>
#include "float.h"
#asm
;
;	amax(a,b)	returns the greater of a and b
QAMAX:	LD	HL,8	;offset for 1st argument
	ADD	HL,SP
	CALL	LDBCHL	;bcixde := 1st argument
	CALL	COMPARE
	JP	M,LDFABC
	RET
;
;	amin(a,b)
QAMIN:	LD	HL,8
	ADD	HL,SP
	CALL	LDBCHL
	CALL	COMPARE
	JP	P,LDFABC
	RET
#endasm
