#include <stdio.h>
#include <math.h>
#include "float.h"

#asm
;
;	transcendental functions: log
;
;
L0F2E:	DEFB	0
;
ONE:	DW	0
	DW	0
	DW	8100H
;
LOGCOEF: DB	6
	DB	23H,85H,0ACH,0C3H,11H,7FH
	DB	53H,0CBH,9EH,0B7H,23H,7FH
	DB	0CCH,0FEH,0A6H,0DH,53H,7FH
	DB	0CBH,5CH,60H,0BBH,13H,80H
	DB	0DDH,0E3H,4EH,38H,76H,80H
	DB	5CH,29H,3BH,0AAH,38H,82H
;
QLOG10:	CALL	QLOG	
	LD	BC,7F5EH	; 1/ln(10)
	LD	IX,5BD8H
	LD	DE,0A938H
	JP	FMUL	
;
QLOG:	CALL	SGN	
	OR	A
	JP	PE,ILLFCT
	LD	HL,FA+5	
	LD	A,(HL)
	LD	BC,8035H	; 1/sqrt(2)
	LD	IX,04F3H
	LD	DE,33FAH
	SUB	B
	PUSH	AF
	LD	(HL),B
	PUSH	DE
	PUSH	IX
	PUSH	BC
	CALL	FADD	
	POP	BC
	POP	IX
	POP	DE
	INC	B
	CALL	FDIV	
	LD	HL,ONE	
	CALL	HLSUB	
	LD	HL,LOGCOEF
	CALL	EVENPOL
	LD	BC,8080H	; -0.5
	LD	IX,0
	LD	DE,0
	CALL	FADD	
	POP	AF
	CALL	L247E	
	LD	BC,8031H	; ln(2)
	LD	IX,7217H
	LD	DE,0F7D2H
	JP	FMUL	
;
;
; don't know what this is, it seems to be part of log()
;
L247E:	CALL	PUSHFA
	CALL	L27EC
	POP	BC
	POP	IX
	POP	DE
	JP	FADD
;
;
L27EC:	LD	B,88H	; 128.
	LD	DE,0
L27F1:	LD	HL,FA+5
	LD	C,A
	PUSH	DE
	POP	IX
	LD	DE,0
	LD	(HL),B	;store exponent
	LD	B,0
	INC	HL
	LD	(HL),80H	;store minus sign
	RLA
	JP	NORMA
;
	EX	DE,HL
	XOR	A
	LD	B,98H
	JR	L27F1
	LD	B,C
L280C:	LD	D,B
	LD	E,0
	LD	HL,L0F2E
	LD	(HL),E
	LD	B,90H
	JR	L27F1
	LD	B,A
	XOR	A
	JR	L280C
;
ILLFCT:	CALL	GRIPE
	DEFB	'Illegal function',0
;
#endasm
