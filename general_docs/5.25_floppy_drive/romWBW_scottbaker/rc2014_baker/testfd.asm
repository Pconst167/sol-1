;==================================================================================
; Floppy Tester
; http://www.smbaker.com/
;
;==================================================================================

LF		.EQU	0AH		;line feed
FF		.EQU	0CH		;form feed
CR		.EQU	0DH		;carriage RETurn

;====================================================================================

		.ORG	8100H		; Format program origin.

INIT            LD        HL,$F000        ;  lets get lots of stack space...
                LD        SP,HL           ; Set up a temporary stack

                LD        HL, $E000         ; Reserve some space for disk buf
                LD        (DIOBUF), HL

		CALL	printInline
		.TEXT "1.44 MB floppy tester"
		.DB CR,LF,0

                CALL    FD_INIT

                LD      C, 0  ; XXX added this
                LD      B, DOP_READID
                CALL    FD_DISPATCH

                CALL    printInline
                .TEXT   "Media ",0
                CALL    OUTHXA
                CALL    printInline
                .TEXT   CR, LF, 0

SeekTest:      CALL    printInline
                .TEXT   "Seek Test",CR,LF,0

                LD      HL, 1
                LD      (HSTTRK), HL
                LD      HL, 0
                LD      (HSTSEC), HL

SeekTestA:
                ; There isn't a seek disk op, so instead write the first
                ; sector of each track

                ; C = disk num
                ; HL = track
                ; DE = sec
                ; B = function

                LD      C, 0
                LD      B, DOP_WRITE

                LD      HL, (HSTTRK)
                LD      DE, (HSTSEC)
                call    PRINTOP

                call    FD_DISPATCH

                call    PRINTRES

                ; increment track number
                LD      HL, (HSTTRK)
                INC     HL
                LD      (HSTTRK), HL

                ; check for done
                LD      HL, (HSTTRK)
                LD      A, L
                CP      160
                JR      NZ, SeekTestA


WriteTest:      CALL    printInline
                .TEXT   "Write Test",CR,LF,0

                LD      HL, 1
                LD      (HSTTRK), HL
                LD      HL, 0
                LD      (HSTSEC), HL

WriteTestA:
                ; write the sector

                CALL    setupSampleData

                ; C = disk num
                ; HL = track
                ; DE = sec
                ; B = function

                LD      C, 0
                LD      HL, (HSTTRK)
                LD      DE, (HSTSEC)
                LD      B, DOP_WRITE

                call    PRINTOP

                call    FD_DISPATCH

                call    PRINTRES

                ; increment sector

                LD      DE, (HSTSEC)
                INC     DE
                LD      A, E
                CP      18
                JR      C, WT_NOWRAP
                LD      DE, 0
                LD      HL, (HSTTRK)
                INC     HL
                LD      (HSTTRK), HL
WT_NOWRAP:
                LD      (HSTSEC), DE

                ; check for done
                LD      HL, (HSTTRK)
                LD      A, L
                CP      160
                JR      NZ, WriteTestA

		CALL	printInline
		.DB CR,LF
		.TEXT "Formatting complete"
		.DB CR,LF,0

ReadTest:      CALL    printInline
                .TEXT   "Read Test",CR,LF,0

                LD      HL, 1
                LD      (HSTTRK), HL
                LD      HL, 0
                LD      (HSTSEC), HL

ReadTestA:
                ; write the sector

                ; C = disk num
                ; HL = track
                ; DE = sec
                ; B = function

                LD      C, 0
                LD      HL, (HSTTRK)
                LD      DE, (HSTSEC)
                LD      B, DOP_READ

                call    PRINTOP

                call    FD_DISPATCH

                call    PRINTRES

                call    testSampleData

                ; increment sector

                LD      DE, (HSTSEC)
                INC     DE
                LD      A, E
                CP      18
                JR      C, RT_NOWRAP
                LD      DE, 0
                LD      HL, (HSTTRK)
                INC     HL
                LD      (HSTTRK), HL
RT_NOWRAP:
                LD      (HSTSEC), DE

                ; check for done
                LD      HL, (HSTTRK)
                LD      A, L
                CP      160
                JR      NZ, ReadTestA

		CALL	printInline
		.DB CR,LF
		.TEXT "Testing complete"
		.DB CR,LF,0

HANG:           JP      HANG

setupSampleData:                 ; setup some sample data
                PUSH   HL
                PUSH   DE
                LD     HL, (DIOBUF)
                LD     DE, (HSTTRK)
                LD     (HL), DE
                INC    HL
                INC    HL
                LD     DE, (HSTSEC)
                LD     (HL), DE
                POP    DE
                POP    HL
                RET

testSampleData:
                PUSH   HL
                PUSH   DE
                PUSH   AF
                PUSH   BC
                LD     HL, (DIOBUF)
                LD     DE, HSTTRK
                LD     A, (HL)
                PUSH   HL
                LD     HL, DE
                LD     B, (HL)
                POP    HL
                CP     B
                JR     NZ, mismatch

                INC    HL
                INC    DE
                LD     A, (HL)
                PUSH   HL
                LD     HL, DE
                LD     B, (HL)
                POP    HL
                CP     B
                JR     NZ, mismatch

                INC    HL
                LD     DE, HSTSEC
                LD     A, (HL)
                PUSH   HL
                LD     HL, DE
                LD     B, (HL)
                POP    HL
                CP     B
                JR     NZ, mismatch

                INC    HL
                INC    DE
                LD     A, (HL)
                PUSH   HL
                LD     HL, DE
                LD     B, (HL)
                POP    HL
                CP     B
                JR     NZ, mismatch

                JP     okay

mismatch:
                CALL   printInline
                .TEXT  "   mismatch ",0
                CALL   OUTHXHL
                CALL   printInline
                .TEXT  " ",0
                CALL   OUTHXDE
                CALL   printInline
                .TEXT  " ",0
                CALL   OUTHXA
                CALL   printInline
                .TEXT  " ",0
                CALL   OUTHXB
                call   printInline
                .TEXT  CR, LF, 0
okay:
                POP    BC
                POP    AF
                POP    DE
                POP    HL
                RET

#define CONSOLE_MONITOR 1

#include "fdstd.asm"
#include "fdconfig.asm"
#include "utils.asm"
#include "fdutil.asm"
#include "fd.asm"
#include "fdvars.asm"

                .END
