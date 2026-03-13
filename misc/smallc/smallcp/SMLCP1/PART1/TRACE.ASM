; NAME...
;	TRACE
;
; PURPOSE...
;	enable walkback trace on errors.
;
;
	MODULE	TRACE
;
;	Exported symbols...
;
	GLOBAL	CCREGIS		;entering a function
	GLOBAL	CCLEAVI		;leaving a function
;
;	Imported symbols...
;
	GLOBAL	CURRENT		;points to stack frame for
;						current function
;
;	Entering new function...add a link to the previous one
;
CCREGIS: POP	DE
	LD	HL,(CURRENT)
	PUSH	HL
	LD	HL,0
	ADD	HL,SP
	LD	(CURRENT),HL
	EX	DE,HL
	JP	(HL)
;
;	leaving a function...remove a link
;
CCLEAVI: EX	DE,HL		     ;save function value if any
	LD	HL,(CURRENT)
	LD	A,(HL)
	INC	HL
	LD	H,(HL)
	LD	L,A
	LD	(CURRENT),HL
	EX	DE,HL			 ;restore function value
	RET
