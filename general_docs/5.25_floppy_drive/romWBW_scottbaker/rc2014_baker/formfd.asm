;==================================================================================
; Floppy Tester
; http://www.smbaker.com/
;
; Portions based on original source of Grant Searle (http://searle.hostei.com/grant/index.html)
;
;==================================================================================

LF		.EQU	0AH		;line feed
FF		.EQU	0CH		;form feed
CR		.EQU	0DH		;carriage RETurn

;====================================================================================

		.ORG	8100H		; Format program origin.

INIT            LD        HL,$F000        ;  lets get lots of stack space...
                LD        SP,HL           ; Set up a temporary stack

		CALL	printInline
		.TEXT "CP/M Formatter for 1.44 floppy"
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

                ; point disk buffer to directory entries
                LD      HL, dirData
                LD      (DIOBUF), HL

; There are 512 directory entries per disk, 4 DIR entries per sector
; So 128 x 128 byte sectors are to be initialised
; The drive uses 512 byte sectors, so 32 x 512 byte sectors per disk
; require initialisation

;Drive 0 (A:) is slightly different due to reserved track, so DIR sector starts at $24
		LD	A,$24
		LD	(secNo),A

                ; start at block $24, which is Track 3 Sector 0
                ;    (track numbers start at 1, sectors start at 0)
                LD      HL, 2
                LD      (HSTTRK), HL
                LD      HL, $0
                LD      (HSTSEC), HL

processSectorA:
                ; write the sector

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
                JR      C, NOWRAP
                LD      DE, 0
                LD      HL, (HSTTRK)
                INC     HL
                LD      (HSTTRK), HL
NOWRAP:
                LD      (HSTSEC), DE

		LD	A,(secNo)
		INC	A
		LD	(secNo),A
		CP	$2C   ; $24 + 8
		JR	NZ, processSectorA

		CALL	printInline
		.DB CR,LF
		.TEXT "Formatting complete"
		.DB CR,LF,0

HANG:           JP      HANG

secNo:          .DB 0

; Directory data for 1 x 128 byte sector
dirData:
		.DB $E5,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$00,$00,$00,$00
		.DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

		.DB $E5,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$00,$00,$00,$00
		.DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

		.DB $E5,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$00,$00,$00,$00
		.DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

		.DB $E5,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$00,$00,$00,$00
		.DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

; Directory data for 1 x 128 byte sector
dirData1:
		.DB $E5,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$00,$00,$00,$00
		.DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

		.DB $E5,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$00,$00,$00,$00
		.DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

		.DB $E5,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$00,$00,$00,$00
		.DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

		.DB $E5,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$00,$00,$00,$00
		.DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

; Directory data for 1 x 128 byte sector
dirData2:
		.DB $E5,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$00,$00,$00,$00
		.DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

		.DB $E5,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$00,$00,$00,$00
		.DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

		.DB $E5,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$00,$00,$00,$00
		.DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

		.DB $E5,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$00,$00,$00,$00
		.DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

; Directory data for 1 x 128 byte sector
dirData3:
		.DB $E5,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$00,$00,$00,$00
		.DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

		.DB $E5,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$00,$00,$00,$00
		.DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

		.DB $E5,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$00,$00,$00,$00
		.DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

		.DB $E5,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$00,$00,$00,$00
		.DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

#define CONSOLE_MONITOR 1

#include "fdstd.asm"
#include "fdconfig.asm"
#include "utils.asm"
#include "fdutil.asm"
#include "fd.asm"
#include "fdvars.asm"

                .END
