#include <stdio.h>
#include <math.h>
#include "float.h"

#asm
;
;	transcendental floating point routines
;
QATAN:	CALL	SGN	
	CALL	M,ODD		;negate argument & answer
	LD	A,(FA+5)
	CP	81H
	JR	C,ATAN5		;c => argument less than 1
	LD	BC,8100H	;1.0
	LD	IX,0
	LD	D,C
	LD	E,C
	CALL	FDIV	
	LD	HL,HLSUB
	PUSH	HL	;will subtract answer from pi/2
ATAN5:	LD	HL,ATNCOEF
	CALL	EVENPOL
	LD	HL,QHALFPI	;may use for subtraction
	RET	
;
ATNCOEF: DB	13
	DB	14H,7H,0BAH,0FEH,62H,75H
	DB	51H,16H,0CEH,0D8H,0D6H,78H
	DB	4CH,0BDH,7DH,0D1H,3EH,7AH
	DB	1,0CBH,23H,0C4H,0D7H,7BH
	DB	0DCH,3AH,0AH,17H,34H,7CH
	DB	36H,0C1H,0A3H,81H,0F7H,7CH
	DB	0EBH,16H,61H,0AEH,19H,7DH
	DB	5DH,78H,8FH,60H,0B9H,7DH
	DB	0A2H,44H,12H,72H,63H,7DH
	DB	16H,62H,0FBH,47H,92H,7EH
	DB	0C0H,0F0H,0BFH,0CCH,4CH,7EH
	DB	7EH,8EH,0AAH,0AAH,0AAH,7FH
	DB	0F6H,0FFH,0FFH,0FFH,07FH,80H
#endasm
