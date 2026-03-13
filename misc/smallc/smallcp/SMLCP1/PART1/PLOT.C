#asm
;
;   PLOT ROUTINES FOR SMALL C
;
;   This package includes the following routines:
;
;   plot( x, y, action )     					plot at x,y
;   cursor( row, column )						position cursor
;   viewport( toprow, leftcol, height, width )	set viewport
;   line( x1, y1, x2, y2, action )				draw line (x1,y1) -> (x2,y2)
;   box( x1, y1, x2, y2, action )				draw box: (x1,y1) is top left
;						          				(x2,y2) is bottom right
;
;
	global qplot
qplot:	LD	HL,7	;put SP+7 in HL
	ADD	HL,SP
	LD	D,(HL)	;fetch msb of x
	DEC	HL
	LD	E,(HL)	;fetch lsb of x
	DEC	HL
	DEC	HL
	LD	A,(HL)	;fetch y to A
	CPL
	DEC	HL
	DEC	HL
	LD	H,(HL)
	LD	L,A		;put -y in L
	LD	C,76	;call plot RSX
	JP	5		;no need to sign extend
;
;
#endasm
