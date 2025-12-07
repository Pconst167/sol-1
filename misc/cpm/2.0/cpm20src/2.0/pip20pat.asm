;	pip patch for cp/m 2.0 operation 10/4/79
;
;	this patch fixes two errors which occur when
;	pip operates under the cp/m 2.0 release:
;	(1) the operation pip x=x,x previously
;	    resulted in a duplicate file when the
;	    final file size exceeded 16k bytes,
;	(2) the sequence of operations
;	    user 5
;	    pip b:=*.*
;	    resulted in a BDOS disk select error
;
;
;	pl/m source level changes:
;	0931.1   dest(freel) = 0;
;	1055.1   dest(0) = 0;
;	1057.0   (deleted)
;
;	assembly language field patch:
;
	org	01f0h		;patch area in pip
dest	equ	1dd8h		;location of "dest"
freel	equ	12		;constant offset
open	equ	086eh		;local open subroutine
;
p1:	;patch #1 for line 931.1
	lxi	h,freel
	dad	b		;hl=.dest(freel)
	mvi	m,0		;dest(freel)=0
	jmp	open		;open file
;
p2:	;patch #2 for line 1055.1
	lxi	b,dest
	xra	a		;zero to accum
	stax	b		;dest(0)=0
	ret
;
;	code overlays
	org	198ch		;line 931.1
	call	p1		;patch #1
;
	org	1bd5h		;line 1055.1
	call	p2		;patch #2
	end
