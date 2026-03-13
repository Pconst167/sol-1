; Various utilities from N8VEM project RomWBW
; Modifications to work with zasm, and to separate it from the rest of N8VEM
;
; Original Readme Banner:
;
; ************************************************************
; ***                     R o m W B W                      ***
; ***                                                      ***
; ***       System Software for N8VEM Z80 Projects         ***
; ************************************************************
;
; Builders: Wayne Warthen (wwarthen@gmail.com)
;           Douglas Goodall (douglas_goodall@mac.com)
;           David Giles (vk5dg@internode.on.net)
;
; Updated: 2015-04-07
; Version: 2.7.1
;
; Original Copyright Notice:
;
; Copyright 2015, Wayne Warthen, GNU GPL v3

CHR_CR          .EQU    0DH
CHR_LF          .EQU    0AH
CHR_BS          .EQU    08H
CHR_ESC         .EQU    1BH

PANIC:          call    printInline
		.DB CR,LF
		.TEXT "Panic!"
		.DB CR,LF,0
		RET

DELAY:                                  ; 17 T STATES (FOR CALL)
        PUSH    BC                      ; 11 T STATES
        LD      B, 12                       ;((CPUMHZ * 2)  - 4)   ; 8 T STATES
        DJNZ    $                       ; (B*13) - 5 T STATES
        POP     BC                      ; 10 T STATES
        RET                             ; 10 T STATES
;
; DELAY 25us * VALUE IN DE (VARIABLE DELAY)
;
VDELAY:
        CALL    DELAY
        DEC     DE
        LD      A,D
        OR      E
        JP      NZ,VDELAY
        RET
;
; DELAY ABOUT 0.5 SECONDS = 25us * 20,000
;
LDELAY:
        PUSH    DE
        LD      DE,20000
        CALL    VDELAY
        POP     DE
        RET

JPHL:   JP      (HL)

WRITESTR:
        PUSH    AF
WRITESTR1:
        LD      A,(DE)
        CP      '$'                     ; TEST FOR STRING TERMINATOR
        JP      Z,WRITESTR2
#if ( CONSOLE_MONITOR )
        RST     08H
#else
        PUSH    BC
        LD      C,A
        CALL    conout
        POP     BC
#endif
        INC     DE
        JP      WRITESTR1
WRITESTR2:
        POP     AF
        RET

PC_SPACE:
        PUSH    AF
        LD      A,' '
        JR      PC_PRTCHR

PC_PERIOD:
        PUSH    AF
        LD      A,'.'
        JR      PC_PRTCHR

PC_COLON:
        PUSH    AF
        LD      A,':'
        JR      PC_PRTCHR

PC_COMMA:
        PUSH    AF
        LD      A,','
        JR      PC_PRTCHR

PC_LBKT:
        PUSH    AF
        LD      A,'['
        JR      PC_PRTCHR

PC_RBKT:
        PUSH    AF
        LD      A,']'
        JR      PC_PRTCHR

PC_LT:
        PUSH    AF
        LD      A,'<'
        JR      PC_PRTCHR

PC_GT:
        PUSH    AF
        LD      A,'>'
        JR      PC_PRTCHR

PC_LPAREN:
        PUSH    AF
        LD      A,'('
        JR      PC_PRTCHR

PC_RPAREN:
        PUSH    AF
        LD      A,')'
        JR      PC_PRTCHR

PC_ASTERISK:
        PUSH    AF
        LD      A,'*'
        JR      PC_PRTCHR

PC_CR:
        PUSH    AF
        LD      A,CHR_CR
        JR      PC_PRTCHR

PC_LF:
        PUSH    AF
        LD      A,CHR_LF
        JR      PC_PRTCHR

PC_PRTCHR:
#if ( CONSOLE_MONITOR )
        RST     08H
#else
        PUSH    BC
        LD      C,A
        CALL    conout
        POP     BC
#endif
        POP     AF
        RET

NEWLINE:
        CALL    PC_CR
        CALL    PC_LF
        RET

;
; PRINT THE HEX BYTE VALUE IN A
;
PRTHEXBYTE:
        PUSH    AF
        PUSH    DE
        CALL    HEXASCII
        LD      A,D
#if ( CONSOLE_MONITOR )
        RST     08H
#else
        PUSH    BC
        LD      C,A
        CALL    conout
        POP     BC
#endif
        LD      A,E
#if ( CONSOLE_MONITOR )
        RST     08H
#else
        PUSH    BC
        LD      C,A
        CALL    conout
        POP     BC
#endif
        POP     DE
        POP     AF
        RET
;
; PRINT THE HEX WORD VALUE IN BC
;
PRTHEXWORD:
        PUSH    AF
        LD      A,B
        CALL    PRTHEXBYTE
        LD      A,C
        CALL    PRTHEXBYTE
        POP     AF
        RET

;
; CONVERT BINARY VALUE IN A TO ASCII HEX CHARACTERS IN DE
;
HEXASCII:
        LD      D,A
        CALL    HEXCONV
        LD      E,A
        LD      A,D
        RLCA
        RLCA
        RLCA
        RLCA
        CALL    HEXCONV
        LD      D,A
        RET
;
; CONVERT LOW NIBBLE OF A TO ASCII HEX
;
HEXCONV:
        AND     0FH          ;LOW NIBBLE ONLY
        ADD     A,90H
        DAA
        ADC     A,40H
        DAA
        RET
;

PRTHEXBUF:
        CP      0               ; EMPTY BUFFER?
        JP      Z,PRTHEXBUF2

        LD      B,A
PRTHEXBUF1:
        CALL    PC_SPACE
        LD      A,(DE)
        CALL    PRTHEXBYTE
        INC     DE
        DJNZ    PRTHEXBUF1
        JP      PRTHEXBUFX

PRTHEXBUF2:
        CALL    PC_SPACE
        LD      DE,STR_EMPTY
        CALL    WRITESTR

PRTHEXBUFX:
        RET

STR_EMPTY       .TEXT   "<EMPTY>$"

