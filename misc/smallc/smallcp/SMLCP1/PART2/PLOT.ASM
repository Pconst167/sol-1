;
; RSX to set/test bit in screen memory
;  H contains action byte:  0  set bit
;                           1  clear bit
;                           2  toggle bit
;							3  fetch bit
;							4  fetch byte
;  L contains y coordinate (0 <=  L <= 255 )
; DE contains x coordinate (0 <= DE <= 719 )
;
; The plot RSX is built using the sequence of commands:
;
;	rmac plot
;	link plot[op
;	era plot.rsx
;	ren plot.rsx=plot.prl
;
;
;
wboot:	equ	1
scrrun:	equ	000e9h
;
	cseg
	db	0,0,0,0,0,0
	jmp	start
next:	db	0c3h
	dw	0
prev:	dw	0
remov:	db	0ffh
nbank:	db	0
	db	'SCRSETXY'
loader:	db	0
	db	0,0
start:
	mov	a,c
	cpi	76
	jz	begin
	jmp	next
begin:
	push	h
	lhld	wboot	;form firmware exec address
	lxi	b,87
	dad	b
	shld	cjfirm
	pop	h
	lxi	b,code
	call	entfw
	dw	scrrun
	ret
;
code:			;perform operation in screen memory
	mvi	a,3	;restrict range of x to 0..1023
	ana	d
	mov	d,a
	push	h	;save action byte
	mvi	h,0	;restrict range of y to 0..255
	dad	h	;fetch roll table pointer
	lxi	b,0b600h
	dad	b
	mov	c,m	;get address from table
	inx	h
	mov	b,m	;BC contains pixel row pointer
;
	mov	a,c	;mask off low order bits of pointer
	ani	0f8h
	mov	l,a
	mov	h,b	;put it in HL
	dad	h	;shift masked pointer left
	dad	d	;add x to masked pointer
	mov	a,l	;mask off low order bits from x
	ani	0f8h
	mov	l,a
;
	mov	a,c	;get low order bits of pixel row pointer
	ani	7
	ora	l	;add low order bits into HL
	mov	l,a	;HL now contains memory address of bit
;
	mov	a,e	;get low order bits of x
	ani	7
	inr	a
	mov	b,a	;B contains rotate count
;
	xra	a	;clear A
	stc		;set carry bit
loop:	rar		;form mask by shifting carry
	db	010h	;djnz loop
	db	0fdh	;(not available in this assembler)
;
			;mask in A, address in HL
;
	pop	b	;fetch action byte
	mov	c,a	;save mask in C
	mov	a,b
	cpi	0	;check action byte
	jnz	not0
	mov	a,c	;action byte = 0
	ora	m	;set bit in memory
	mov	m,a
	ret
;
not0:
	cpi	1
	jnz	not1
	mov	a,c	;action byte = 1
	cma		;clear bit in memory
	ana	m
	mov	m,a
	ret
;
not1:
	cpi	2
	jnz not2
	mov	a,c	;action byte = 2
	xra	m	;toggle bit in memory
	mov	m,a
	ret
;
not2:
	cpi 3
	jnz not3
	mov a,c	;action byte = 3
	ana m	;test bit in memory
	mov l,a
	mvi h,0
	ret
;
not3:
	cpi 4
	rnz		;unknown action, return
	mov l,m	;action byte = 4
	mvi h,0	;return byte from screen memory
	ret
;
entfw:	db	0c3h
cjfirm:	dw	0
	end
