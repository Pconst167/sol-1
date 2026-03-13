#include <stdio.h>
#include "float.h"
#asm
;
;	convert the integer in hl to
;	a floating point number in FA
;
QFLOAT:	LD	A,H	;fetch MSB
	CPL		;reverse sign bit
	LD	(FASIGN),A ;save sign (msb)
	RLA		;move sign into cy
	JR	C,FL4	;c => nonnegative number
	EX	DE,HL
	SBC	HL,HL	;clear hl
	SBC	HL,DE	;get positive number into hl
FL4:	LD	A,L
	DEFB	0DDH
	LD	H,A	;move LSB to hx
	LD	C,H	;move MSB to c
	LD	DE,0	;clear rest of registers
	LD	B,D
	DEFB	0DDH
	LD	L,D	;clear lx
	LD	A,16+128
	LD	(FA+5),A ;preset exponent
	JP	NORM	;go normalize c ix de b
#endasm
