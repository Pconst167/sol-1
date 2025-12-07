#include <stdio.h>
#include <math.h>
#include "float.h"

#asm
;
;	transcendental floating point routines: polynomial evaluation
;
EVENPOL: CALL	PUSHFA	
	LD	DE,L265F
	PUSH	DE
	PUSH	HL
	CALL	LDBCFA	
	CALL	FMUL	
	POP	HL
;
POLY:	CALL	PUSHFA	
	LD	A,(HL)
	INC	HL
	CALL	DLOAD	
	DB	0FEH	;"ignore next byte"
POL3:	POP	AF
	POP	BC
	POP	IX
	POP	DE
	DEC	A
	RET	Z
	PUSH	DE
	PUSH	IX
	PUSH	BC
	PUSH	AF
	PUSH	HL
	CALL	FMUL	
	POP	HL
	CALL	LDBCHL	
	PUSH	HL
	CALL	FADD	
	POP	HL
	JR	POL3	
;
;
L265F:	POP	BC
	POP	IX
	POP	DE
	JP	FMUL
;
;
ADDHALF: LD	HL,HALF
HLADD:	CALL	LDBCHL
	JP	FADD
HALF:	DEFB	0,0,0,0,0,80H	;0.5
;
HLSUB:	CALL	LDBCHL
	JP	FSUB
;
#endasm
