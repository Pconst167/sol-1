	PAGE
	STTL "--- HARDWARE EQUATES: CBM64 ---"


	; ---------
	; CONSTANTS
	; ---------

EZIPID	EQU	7	; ID BYTE STATING THIS IS A COMMODORE EZIP

AUX	EQU	0
MAIN	EQU	1


; THE FIRST 86K (SIDE1) MUST
; BE RAM RESIDENT (344=$158 PAGES)
;
; BANK 1 IS MAIN, BANK 0 IS AUX !!!!
; PAGES V$0 TO ($FE-VBEGIN) ARE IN MAIN
; PAGES ($FF-VBEGIN) TO V$139 ARE IN AUX
; PAGENG BUFFERS ARE IN AUX AT END OF PRELOAD



VTOTAL	EQU	256*4		;TOTAL # PAGES IN EZIP
PSIDE1	EQU	86*4		;# PAGES ON SIDE 1 OF DISK (90K)
PSIDE2	EQU	VTOTAL-PSIDE1	;# PAGES ON DISK SIDE 2

AUXSTART EQU	$1C		;FIRST RAM PAGE IN AUX MEM
AUXEND	EQU	$BF		;LAST PAGE USABLE IN AUXMEM
MAINSTRT EQU	ZBEGIN/$100	;FIRST FREE PAGE IN MAIN
MAINEND	EQU	$FE		;LAST USABLE PAGE IN MAIN
VAUX	EQU	MAINEND-MAINSTRT+1	;FIRST V-PAGE IN AUXMEM


; PBEGIN IS FIRST RAM PAGENG BUFFER IN AUX MEM
; PBEGIN IS FIRST PAGENG BUFFER (RAM PAGE IN AUX MEM)

PBEGIN	EQU	PSIDE1-VAUX+AUXSTART
NUMBUFS	EQU	AUXEND-PBEGIN+1	;# PAGENG BUFFER (RAM PAGES IN AUX)

EOL	EQU	$0D		; EOL CHAR
SPACE	EQU	$20		; SPACE CHAR
BACKSP	EQU	$14		; BACKSPACE
LF	EQU	$0A		; LINE FEED
CLS	EQU	$93		; CLEAR SCREEN, HOME CURSOR

	; -----------------
	; MONITOR VARIABLES
	; -----------------

WLEFT	EQU	$E6		; LEFT MARGIN (0)
WWIDTH	EQU	$E7		; RIGHT MARGIN (40 OR 80)
WTOP	EQU	$E5		; TOP LINE (0-23)
WBOTM	EQU	$E4		; BOTTOM LINE (1-24)
LINES	EQU	$ED		; # LINES ON SCREEN
COLMODE EQU	$D7		; WHAT COLUMN MODE ARE WE IN (40/80)
QUOTMOD	EQU	$F4		; QUOTES SENT TO SCREEN TURN ON STRANGE
				; MODE, THIS FLAG SET TO 0 SHOULD
				; TURN THAT MODE OFF

	; ---------
	; ZERO-PAGE
	; ---------

D6510	EQU	$00		; 6510 DATA DIRECTION REGISTER
R6510	EQU	$01		; 6510 I/O PORT
FAST	EQU	$02		; FAST-READ AVAILABLE FLAG
STKEY	EQU	$91		; STOP KEY FLAG
MSGFLG	EQU	$9D		; KERNAL MESSAGE CONTROL FLAG
TIME	EQU	$A2		; SYSTEM JIFFY TIMER
LSTX	EQU	$C5		; LAST KEY PRESSED
NDX	EQU	$D0		; # CHARS IN KEYBOARD BUFFER
RVS	EQU	$C7		; REVERSE CHARACTER FLAG
SFDX	EQU	$CB		; CURRENT KEYPRESS
BLNSW	EQU	$CC		; CURSOR BLINK SWITCH
PNTR	EQU	$D3		; CURSOR COLUMN IN LOGICAL LINE
TBLX	EQU	$D6		; CURRENT CURSOR ROW
LDTB1	EQU	$D9		; 25-BYTE LINE LINK TABLE
KEYTAB	EQU	$F5		; KEYBOARD DECODE TABLE VECTOR

FDATA	EQU	$FB		; FAST-READ DATA BUFFER
FINDEX	EQU	$FC		; FAST-READ BUFFER INDEX
FASTEN	EQU	$FD		; FAST-READ ENABLED FLAG

	; -----------
	; PAGES 2 & 3
	; -----------

LBUFF	EQU	$0200		; 89-BYTE LINE BUFFER
KEYD	EQU	$0277		; KEYBOARD QUEUE
RPTFLG	EQU	$028A		; KEY REPEAT FLAG
SHFLAG	EQU	$028D		; SHIFT KEY FLAG
KEYLOG	EQU	$028F		; VECTOR TO KEY-TABLE SETUP ROUTINE
MODE	EQU	$0291		; CHARSET MODE SWITCH
CINV	EQU	$0314		; SYSTEM 60HZ IRQ VECTOR
CBINV	EQU	$0316		; BRK INSTRUCTION VECTOR
NMINV	EQU	$0318		; NMI INTERRUPT VECTOR

	; -----
	; COLOR
	; -----

COLRAM	EQU	$D800		; COLOR RAM
EXTCOL	EQU	$D020		; BORDER COLOR
BGCOLO	EQU	$D021		; BACKGRND COLOR
FRCOLO	EQU	$F1		; FOREGRND COLOR REG

	; ----
	; MISC
	; ----

SHARED	EQU	$400		; MEMORY LOCATION OF RTNS AVAILABLE
				; TO BOTH BANKS
RASTER	EQU	$D012		; RASTER COMPARE (WILL IT BE AFFECTED?)

	; --------------
	; MEMORY CONTROL
	; --------------

LCRA	EQU	$FF01
LCRB	EQU	$FF02

CR	EQU	$FF00		; MAIN CONFIGURATION REGISTER
PCRA	EQU	$D501
PCRB	EQU	$D502
MCR	EQU	$D505		; MODE CONFIG REG (6502/128)
RCR	EQU	$D506		; RAM CONFIG REG (SHARED/WHERE)


	; ---
	; SID
	; ---

	; VOICE #1 REGISTERS

FRELO1	EQU	$D400		; FREQ
FREHI1	EQU	$D401		; FREQ HIGH BIT
PWLO1	EQU	$D402		; PULSE WIDTH
PWHI1	EQU	$D403		; PULSE WIDTH HIGH NIBBLE
VCREG1	EQU	$D404		; CONTROL
ATDCY1	EQU	$D405		; ATTACK/DECAY
SUREL1	EQU	$D406		; SUSTAIN/RELEASE


	; VOICE #2 REGISTERS

FRELO2	EQU	$D407		; FREQ
FREHI2	EQU	$D408		; FREQ HIGH BIT
PWLO2	EQU	$D409		; PULSE WIDTH
PWHI2	EQU	$D40A		; PULSE WIDTH HIGH NIBBLE
VCREG2	EQU	$D40B		; CONTROL
ATDCY2	EQU	$D40C		; ATTACK/DECAY
SUREL2	EQU	$D40D		; SUSTAIN/RELEASE

	; VOICE #3 REGISTERS

FRELO3	EQU	$D40E		; FREQ
FREHI3	EQU	$D40F		; FREQ HIGH BIT
PWLO3	EQU	$D410		; PULSE WIDTH
PWHI3	EQU	$D411		; PULSE WIDTH HIGH NIBBLE
VCREG3	EQU	$D412		; VOICE CONTROL
ATDCY3	EQU	$D413		; ATTACK/DECAY
SUREL3	EQU	$D414		; SUSTAIN/RELEASE

	; MISCELLANEOUS REGISTERS

CUTLO	EQU	$D415		; FILTER CUTOFF, LOW BITS
CUTHI	EQU	$D416		; FILTER CUTOFF, HIGH BYTE
RESON	EQU	$D417		; RESONANCE CONTROL
SIGVOL	EQU	$D418		; VOLUME/FILTER CONTROL
RAND	EQU	$D41B		; RANDOM NUMBER
CI2PRA	EQU	$DD00		; DATA PORT A

	; -------------------
	; KERNAL JUMP VECTORS
	; -------------------

RCHKIN	EQU	$FFC6		; OPEN CHANNEL FOR INPUT
RCHKOUT	EQU	$FFC9		; OPEN CHANNEL FOR OUTPUT
RCHRIN	EQU	$FFCF		; INPUT CHARACTER FROM CHANNEL
RCHROUT	EQU	$FFD2		; OUTPUT CHARACTER TO CHANNEL
RCINT	EQU	$FF81		; INIT SCREEN EDITOR
RCLALL	EQU	$FFE7		; CLOSE ALL CHANNELS & FILES
RCLOSE	EQU	$FFC3		; CLOSE A FILE
RCLRCHN	EQU	$FFCC		; CLEAR CHANNEL
RGETIN	EQU	$FFE4		; GET CHAR FROM KEYBOARD QUEUE
RIOINIT	EQU	$FF84		; INIT I/O
ROPEN	EQU	$FFC0		; OPEN A FILE
RPLOT	EQU	$FFF0		; READ/SET CURSOR POSITION
RRAMTAS	EQU	$FF87		; INIT RAM
RREADST	EQU	$FFB7		; READ I/O STATUS
RSCNKEY	EQU	$FF9F		; SCAN KEYBOARD
RSETLFS	EQU	$FFBA		; SET FILE ATTRIBUTES
RSETMSG	EQU	$FF90		; SET KERNAL MESSAGES
RSETNAM	EQU	$FFBD		; SET FILENAME
SWAPPER	EQU	$FF5F		; SWAP TO ALTERNATE DISPLAY DEVICE

	END
