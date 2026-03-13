;================================================================================================
; Utilities
;================================================================================================

printInline:
		EX 	(SP),HL 	; PUSH HL and put RET ADDress into HL
		PUSH 	AF
		PUSH 	BC
nextILChar:	LD 	A,(HL)
		CP	0
		JR	Z,endOfPrint
#if ( CONSOLE_MONITOR )
		RST 	08H
#else
                LD      C,A
                CALL    conout
#endif
		INC 	HL
		JR	nextILChar
endOfPrint:	INC 	HL 		; Get past "null" terminator
		POP 	BC
		POP 	AF
		EX 	(SP),HL 	; PUSH new RET ADDress on stack and restore HL
		RET

OUTHXA: PUSH BC
        LD C, A
        CALL OUTHX
        POP BC
        RET

OUTHXB: PUSH BC
        LD C, B
        CALL OUTHX
        POP BC
        RET

OUTHXHL: PUSH AF
        LD      A, H
        CALL    OUTHXA
        LD      A, L
        CALL    OUTHXA
        POP     AF
        RET

OUTHXDE: PUSH AF
        LD      A, D
        CALL    OUTHXA
        LD      A, E
        CALL    OUTHXA
        POP     AF
        RET

OUTHX:  PUSH    AF
        LD      A, C
        RRA             ;ROTATE
        RRA             ; FOUR
        RRA             ; BITS TO
        RRA             ; RIGHT
        CALL    HEX1    ;UPPER CHAR
        LD     A,C     ;LOWER CHAR
        CALL    HEX1
        POP     AF
        ret

HEX1:   push    BC
        push    AF
        AND     0FH     ;TAKE 4 BITS
        ADD     A,90H
        DAA             ;DAA TRICK
        ADC     A, 40H
        DAA
#if ( CONSOLE_MONITOR )
		RST 	08H
#else
                LD      C,A
                CALL    conout
#endif
        pop     AF
        pop     BC
        ret

PRINTOP:        PUSH    HL
                PUSH    DE
                LD      HL, (HSTTRK)
                LD      DE, (HSTSEC)
                CALL    printInline
                .DB     " Track ", 0
                CALL    OUTHXHL
                CALL    printInline
                .DB     " Sector ",0
                CALL    OUTHXDE
                LD      HL, (DIOBUF)
                CALL    printInline
                .DB     " Dest ",0
                CALL    OUTHXHL
                POP     DE
                POP     HL
                RET

PRINTRES:       CALL    printInline
                .DB     " Result ", 0
                CALL    OUTHXA
                CALL    printInline
                .DB     " Bytes ", 0

                PUSH    HL
                PUSH    AF
                PUSH    BC

                ; print some bytes
                LD      HL, (DIOBUF)
                LD      A, (HL)
                CALL    OUTHXA
                INC     HL
                LD      A, (HL)
                CALL    OUTHXA
                INC     HL
                LD      A, (HL)
                CALL    OUTHXA
                INC     HL
                LD      A, (HL)
                CALL    OUTHXA
                INC     HL
                LD      A, (HL)

                LD      HL, (DIOBUF)
                LD      B, 0
                LD      A, 0
ckloop1:
                LD      C, (HL)
                ADD     A, C
                INC     HL
                djnz    ckloop1
                LD      B,0
ckloop2:
                LD      C, (HL)
                ADD     A, C
                INC     HL
                djnz    ckloop2

                CALL    printInline
                .DB     " CK ", 0
                CALL    OUTHXA

                POP     BC
                POP     AF
                POP     HL

                CALL    printInline
                .DB     CR, LF, 0
                RET
