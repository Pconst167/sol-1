;	movcpm patch for cp/m 2.0  10/4/79
;
;	the BDOS system reset function, number 0,
;	previously executed a cold start, rather
;	than a warm start.
;
;	assembly language source change:
;	0844	DW	WBOOTF, FUNC1, FUNC2, FUNC3
;
;	assembly language patch
bias	equ	0a00h		;bias within movcpm
wbootf	equ	1603h		;relative wbootf addr
	org	0844h+bias
	dw	wbootf
	end
