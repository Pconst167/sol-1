#include <stdio.h>
#include "float.h"
#asm
;
;	return -(floor(-x))
QCEIL:	CALL	ODD
;
;	return largest integer not greater than
QFLOOR:	LD	HL,FA+5
	LD	A,(HL)	;fetch exponent
	CP	0A8H
	LD	A,(FA)
	RET	NC	;nc => binary point is right of lsb
	LD	A,(HL)
	CALL	INT2
	LD	(HL),0A8H  ;place binary pt at end of fraction
	LD	A,E
	PUSH	AF
	LD	A,C
	RLA
	CALL	NORMA
	POP	AF
	RET
;
	LD	HL,FA+5
	LD	(HL),0A8H
	INC	HL
	LD	(HL),80H
	LD	A,C
	RLA
	JP	NORMA
#endasm
