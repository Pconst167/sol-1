
	PAGE
* ---------------------------------------------------------------------------
* MAIN LOOP, DISPATCHING
* ---------------------------------------------------------------------------

* OPERATORS WHICH ACCEPT A VARIABLE NUMBER OF ARGUMENTS (OPQEQU, OPCALL, ETC)
* ARE IDENTIFIED BY AN INITIAL NOP.  THEIR ARGUMENTS ARE PASSED IN AN ARGUMENT
* BLOCK, WITH THE NUMBER OF ARGUMENTS AS THE FIRST ENTRY.  ALL OTHER OPERATORS
* RECEIVE THEIR ARGUMENTS IN REGISTERS.

NOOP	EQU	$4E71		* MARKS ROUTINES WHICH TAKE OPTIONAL ARGS

*** Alternate NXTINS dispatch mechanism.  Would require that all entries in
*** dispatch table (ZIPOPS) be relative to ZIPOPS.

***	LEA	ZIPOPS,A1
***	MOVE.W  xxxOPS-ZIPOPS(A1,D0.W),D2   * GET THE OPx ROUTINE OFFSET
***	JSR	0(A1,D2.W)		    * CALL THE OPERATOR ROUTINE
***	BRA	NXTINS

* ----------------------
* NXTINS
* ----------------------

NXTINS	BSR	GAMINT		* CHECK FOR GAME INTERRUPT (SOUND, ETC)
	BSR	NXTBYT		* GET THE NEXT INSTRUCTION BYTE

    IFEQ DEBUG
	BSR	DBTEST
    ENDC
	CMPI.B  #$80,D0		* IS IT A 2 OP?
	BCS	NXT2	* BLO	* YES

	CMPI.B  #$B0,D0		* IS IT A 1 OP?
	BCS	NXT1	* BLO	* YES

	CMPI.B  #$C0,D0		* IS IT A 0 OP?
	BCC	NXT4	* BHS	* NO, MUST BE AN EXTENDED OP

*** HANDLE A ZERO-OP

NXT0	CMPI.B	#190,D0		* SPECIAL "EXTOP" OPCODE?
	BEQ.S	N0X1		* YES

	ANDI.W  #$0F,D0		* 0 OP, EXTRACT OPERATOR CODE, "xxxx oooo"
	ADD.W	D0,D0		* WORD OFFSET

	LEA	ZEROPS,A1
	MOVE.W  0(A1,D0.W),D2	* GET THE OPx ROUTINE OFFSET
	LEA	ZBASE,A1

	JSR	0(A1,D2.W)	* CALL THE OPERATOR ROUTINE
	BRA	NXTINS

N0X1	BSR	NXTBYT		* NEXT BYTE IS SPECIAL "EXTOP"
	ANDI.W	#$3F,D0		* EXTRACT OPERATOR CODE, "xxoo oooo"
	MOVEQ	#64,D2		* MAXIMUM 2OPS/XOPS
	ADD.W	D0,D2		* ADJUST OPCODE INTO "EXTOP" RANGE
	BRA	NXT4A		* THEN HANDLE AS AN XOP

*** HANDLE A ONE-OP

NXT1	MOVE.W  D0,D2		* 1 OP, MAKE A COPY, "xxmm oooo"
	ANDI.W  #$0F,D2		* EXTRACT OPERATOR CODE
	ADD.W	D2,D2		* WORD OFFSET

	LSR.W	#4,D0		* EXTRACT MODE BITS
	ANDI.W  #3,D0
	BSR	GETARG		* GET THE ARGUMENT

	LEA	ONEOPS,A1
	MOVE.W  0(A1,D2.W),D2	* GET THE OPx ROUTINE OFFSET
	LEA	ZBASE,A1

	JSR	0(A1,D2.W)	* CALL THE OPERATOR ROUTINE
	BRA	NXTINS

*** HANDLE A TWO-OP

NXT2	MOVE.W  D0,D2		* 2 OP, MAKE A COPY, "xmmo oooo"

	MOVEQ	#1,D0		* ASSUME FIRST ARG IS AN IMMEDIATE
	BTST	#6,D2		* IS IT INSTEAD A VARIABLE?
	BEQ.S	N2X1		* NO
	MOVEQ	#2,D0		* YES, CHANGE MODE
N2X1	BSR	GETARG		* GET THE FIRST ARG
	MOVE.W  D0,D1

	MOVEQ	#1,D0		* ASSUME SECOND ARG IS AN IMMEDIATE
	BTST	#5,D2		* IS IT INSTEAD A VAR?
	BEQ.S	N2X2		* NO
	MOVEQ	#2,D0		* YES, CHANGE MODE
N2X2	BSR	GETARG		* GET THE SECOND ARG
	EXG	D0,D1		* POSITION THE ARGS

	ANDI.W  #$1F,D2		* EXTRACT OPERATOR CODE
	ADD.W	D2,D2		* WORD OFFSET

	LEA	TWOOPS,A1
	MOVE.W  0(A1,D2.W),D2	* GET THE OPx ROUTINE OFFSET
	LEA	ZBASE,A1
	LEA	0(A1,D2.W),A1	* CALCULATE THE OPx ROUTINE ADDRESS

	CMPI.W  #NOOP,(A1)	* BUT DOES THE OPERATOR EXPECT AN ARGBLK?
	BNE.S	N2X3		* NO

	LEA	ARGBLK+6(A6),A0 * YES, MOVE ARGS TO ARGBLK
	MOVE.W  D1,-(A0)
	MOVE.W  D0,-(A0)
	MOVE.W  #2,-(A0)	* ALWAYS 2 ARGS

N2X3	JSR	(A1)		* CALL THE OPERATOR ROUTINE
	BRA	NXTINS

*** HANDLE AN EXTENDED-OP ...

NXT4	MOVE.W  D0,D2		* EXTENDED OP, SAVE A COPY, "xxoo oooo"
	ANDI.W  #$3F,D2		* EXTRACT OPERATOR CODE

	CMPI.B  #236,D0		* IS THIS AN XCALL ($EC)?
	BEQ.S	N4X1		* YES
	CMPI.B  #250,D0		* IS THIS AN IXCALL ($FA)?
	BNE.S	NXT4A		* NO

* GET THE 4 (OR 8) MODE SPECIFIERS, EXTRACT AND STACK THEM ...

N4X1	MOVEQ	#8,D3		* SPECIAL XOP, 8 MODE SPECIFIERS
	BSR	NXTBYT		* GET THE FIRST MODE BYTE, "aabb ccdd"
	MOVE.W  D0,D1
	BSR	NXTBYT		* GET THE SECOND MODE BYTE, "eeff gghh"

	MOVE.W  D0,-(SP)	* SAVE hh
	LSR.W	#2,D0
	MOVE.W  D0,-(SP)	* SAVE gg
	LSR.W	#2,D0
	MOVE.W  D0,-(SP)	* SAVE ff
	LSR.W	#2,D0
	MOVE.W  D0,-(SP)	* SAVE ee

	MOVE.W  D1,D0
	BRA.S	N4X2

* ENTRY POINT TO DECODE SPECIAL "EXTOP"
*   D2 = STRIPPED OPCODE (MAY BE 64+)

NXT4A	MOVEQ	#4,D3		* 4 MODE SPECIFIERS
	BSR	NXTBYT		* GET THE MODE BYTE, "aabb ccdd"

N4X2	MOVE.W  D0,-(SP)	* SAVE dd
	LSR.W	#2,D0
	MOVE.W  D0,-(SP)	* SAVE cc
	LSR.W	#2,D0
	MOVE.W  D0,-(SP)	* SAVE bb
	LSR.W	#2,D0
	MOVE.W  D0,-(SP)	* SAVE aa

* DECODE ARGUMENTS, STORE IN ARGBLK

	CLR.W	D4		* KEEP A COUNT OF ACTUAL ARGUMENTS
	LEA	ARGBLK+2(A6),A1 * ARGUMENT BLOCK, SKIP OVER COUNT SLOT

N4X3	MOVE.W  (SP)+,D0	* POP NEXT MODE SPECIFIER
	ANDI.W  #3,D0		* EXTRACT MODE BITS
	CMPI.W  #3,D0		* ARE THERE ANY MORE ARGUMENTS?
	BEQ.S	N4X4		* NO

	ADDQ.W  #1,D4		* YES, COUNT THIS ONE
	BSR	GETARG		* DECODE AND FETCH IT
	MOVE.W  D0,(A1)+	* STORE IT IN ARGUMENT BLOCK

	SUBQ.W  #1,D3		* GO FOR MORE
	BNE	N4X3
	BRA.S	N4X5

N4X4	SUBQ.W  #1,D3		* NUMBER OF EXTRA MODE SPECIFIERS
	ADD.W	D3,D3
	ADDA.W  D3,SP		* FLUSH THEM

N4X5	LEA	ARGBLK(A6),A0	* PASS ARGBLK POINTER TO THE OPERATOR HERE ...
	MOVE.W  D4,(A0)		* STORE NUMBER OF ARGUMENTS

* CALCULATE THE OPERATOR ROUTINE ADDRESS

	ADD.W	D2,D2		* WORD OFFSET
	LEA	EXTOPS,A1
	MOVE.W  0(A1,D2.W),D2	* GET THE OPx ROUTINE OFFSET
	LEA	ZBASE,A1
	LEA	0(A1,D2.W),A1	* CALCULATE THE OPx ROUTINE ADDRESS

	CMPI.W  #NOOP,(A1)	* BUT DOES THE OPERATOR EXPECT AN ARGBLK?
	BEQ.S	N4X6		* YES

	ADDQ.L  #2,A0		* NO, PASS ARGS IN REGISTERS
	MOVE.W  (A0)+,D0
	MOVE.W  (A0)+,D1
	MOVE.W  (A0)+,D2
	MOVE.W  (A0)+,D3	* MAXIMUM OF FOUR

N4X6	JSR	(A1)		* CALL THE OPERATOR ROUTINE
	BRA	NXTINS

* ----------------------
* SETDEF
* ----------------------

* SET UP DEFAULT ARGS IN ARGBLK[], USING VALUES FROM DEFBLK[]
* CALLED BY INDIVIDUAL OPERATORS, SINCE DEFAULT COUNT/VALUES MAY VARY
* CALLED AT BEGINNING OF OPS, SO NEED NOT SAVE REGISTERS
* GIVEN A0 -> ARGBLK, A1 -> DEFBLK, (A1) = MAX ARGS,  RETURN A0 -> ARGBLK

SETDEF	MOVE.L	A0,A2
	MOVE.W	(A0)+,D0	* ACTUAL # ARGS PASSED (REQS PLUS OPTS)
	MOVE.W	(A1)+,D1	* MAX # ARGS POSSIBLE
	SUB.W	D0,D1		* DIFFERENCE IS # DEFAULTS TO SET
	BLE.S	SDFX4		* NONE

	ADD.W	D0,D0		* SKIP THIS MANY BYTES
	ADDA.W	D0,A0
	ADDA.W	D0,A1
SDFX2	MOVE.W	(A1)+,(A0)+	* COPY A DEFAULT VALUE
	SUBQ.W	#1,D1
	BNE.S	SDFX2

SDFX4	MOVE.L	A2,A0		* RETURN ARGBLK PTR INTACT
	RTS

	PAGE
* ---------------------------------------------------------------------------
* DISPATCH TABLES
* ---------------------------------------------------------------------------

* UNIMPLEMENTED OPCODES DISPATCH TO HERE ...

OPERR	CLR.W	D0
	LEA	MSGBAD,A0
	BRA	FATAL		* 'Bad operation'

    SECTION ZDATA
MSGBAD	DC.B	'Bad operation',0
    SECTION ZCODE

    SECTION ZDATA
ZEROPS  DC.W	OPRTRU-ZBASE	* 176
	DC.W	OPRFAL-ZBASE	* 177
	DC.W	OPPRNI-ZBASE	* 178
	DC.W	OPPRNR-ZBASE	* 179
	DC.W	OPNOOP-ZBASE	* 180
	DC.W	OPERR-ZBASE
	DC.W	OPERR-ZBASE
	DC.W	OPRSTT-ZBASE	* 183
	DC.W	OPRSTA-ZBASE	* 184
	DC.W	OPCATCH-ZBASE	* 185 XZIP
	DC.W	OPQUIT-ZBASE	* 186
	DC.W	OPCRLF-ZBASE	* 187
	DC.W	OPUSL-ZBASE	* 188
	DC.W	OPVERI-ZBASE	* 189
	DC.W	OPERR-ZBASE	* 190 XZIP ("EXTOP")
	DC.W	OPORIG-ZBASE	* 191 XZIP

ONEOPS  DC.W	OPQZER-ZBASE	* 128
	DC.W	OPQNEX-ZBASE	* 129
	DC.W	OPQFIR-ZBASE	* 130
	DC.W	OPLOC-ZBASE	* 131
	DC.W	OPPTSI-ZBASE	* 132
	DC.W	OPINC-ZBASE	* 133
	DC.W	OPDEC-ZBASE	* 134
	DC.W	OPPRNB-ZBASE	* 135
	DC.W	OPCAL1-ZBASE	* 136 EZIP
	DC.W	OPREMO-ZBASE	* 137
	DC.W	OPPRND-ZBASE	* 138
	DC.W	OPRETU-ZBASE	* 139
	DC.W	OPJUMP-ZBASE	* 140
	DC.W	OPPRIN-ZBASE	* 141
	DC.W	OPVALU-ZBASE	* 142
	DC.W	OPICAL1-ZBASE	* 143 XZIP

TWOOPS:
EXTOPS:	DC.W	OPERR-ZBASE	* 0 (OR 192+0)
	DC.W	OPQEQU-ZBASE	* 1
	DC.W	OPQLES-ZBASE	* 2
	DC.W	OPQGRT-ZBASE	* 3
	DC.W	OPQDLE-ZBASE	* 4
	DC.W	OPQIGR-ZBASE	* 5
	DC.W	OPQIN-ZBASE	* 6
	DC.W	OPBTST-ZBASE	* 7
	DC.W	OPBOR-ZBASE	* 8
	DC.W	OPBAND-ZBASE	* 9
	DC.W	OPQFSE-ZBASE	* 10
	DC.W	OPFSET-ZBASE	* 11
	DC.W	OPFCLE-ZBASE	* 12
	DC.W	OPSET-ZBASE	* 13
	DC.W	OPMOVE-ZBASE	* 14
	DC.W	OPGET-ZBASE	* 15
	DC.W	OPGETB-ZBASE	* 16
	DC.W	OPGETP-ZBASE	* 17
	DC.W	OPGTPT-ZBASE	* 18
	DC.W	OPNEXT-ZBASE	* 19
	DC.W	OPADD-ZBASE	* 20
	DC.W	OPSUB-ZBASE	* 21
	DC.W	OPMUL-ZBASE	* 22
	DC.W	OPDIV-ZBASE	* 23
	DC.W	OPMOD-ZBASE	* 24
	DC.W	OPCAL2-ZBASE	* 25 EZIP
	DC.W	OPICAL2-ZBASE	* 26 XZIP
	DC.W	OPCOLOR-ZBASE	* 27 XZIP
	DC.W	OPTHROW-ZBASE	* 28 XZIP
	DC.W	OPERR-ZBASE
	DC.W	OPERR-ZBASE
	DC.W	OPERR-ZBASE

	DC.W	OPCALL-ZBASE	* 224 (192+32)
	DC.W	OPPUT-ZBASE	* 225
	DC.W	OPPUTB-ZBASE	* 226
	DC.W	OPPUTP-ZBASE	* 227
	DC.W	OPREAD-ZBASE	* 228
	DC.W	OPPRNC-ZBASE	* 229
	DC.W	OPPRNN-ZBASE	* 230
	DC.W	OPRAND-ZBASE	* 231
	DC.W	OPPUSH-ZBASE	* 232
	DC.W	OPPOP-ZBASE	* 233
	DC.W	OPSPLT-ZBASE	* 234
	DC.W	OPSCRN-ZBASE	* 235
	DC.W	OPXCAL-ZBASE	* 236 EZIP
	DC.W	OPCLEAR-ZBASE	* 237 EZIP
	DC.W	OPERASE-ZBASE	* 238 EZIP
	DC.W	OPCURS-ZBASE	* 239 EZIP
	DC.W	OPCURG-ZBASE	* 240  XZIP 
	DC.W	OPATTR-ZBASE	* 241 EZIP
	DC.W	OPBUFO-ZBASE	* 242 EZIP
	DC.W	OPDIRO-ZBASE	* 243 EZIP
	DC.W	OPDIRI-ZBASE	* 244 EZIP
	DC.W	OPSOUND-ZBASE	* 245 EZIP
	DC.W	OPINPUT-ZBASE	* 246 EZIP
	DC.W	OPINTBL-ZBASE	* 247 EZIP
	DC.W	OPBCOM-ZBASE	* 248  XZIP
	DC.W	OPICALL-ZBASE	* 249 XZIP
	DC.W	OPIXCAL-ZBASE	* 250 XZIP
	DC.W	OPLEX-ZBASE	* 251 XZIP
	DC.W	OPZWSTR-ZBASE	* 252 XZIP
	DC.W	OPCOPYT-ZBASE	* 253 XZIP
	DC.W	OPPRNT-ZBASE	* 254 XZIP
	DC.W	OPASSN-ZBASE	* 255 XZIP

* "EXTOPS" (XZIP)

	DC.W	OPSAVE-ZBASE	* 256 (192+64)
	DC.W	OPREST-ZBASE	* 257
	DC.W	OPSHIFT-ZBASE	* 258 XZIP
	DC.W	OPASHIFT-ZBASE	* 259 XZIP
	DC.W	OPFONT-ZBASE	* 260 XZIP
	DC.W	OPDISP-ZBASE	* 261 XZIP
	DC.W	OPPICI-ZBASE	* 262 XZIP
	DC.W	OPDCLR-ZBASE	* 263 XZIP
	DC.W	OPMARG-ZBASE	* 264 XZIP
	DC.W	OPISAV-ZBASE	* 265 XZIP
	DC.W	OPIRES-ZBASE	* 266 XZIP
	DC.W	OPERR-ZBASE
	DC.W	OPERR-ZBASE
	DC.W	OPERR-ZBASE
	DC.W	OPERR-ZBASE
	DC.W	OPERR-ZBASE
	DC.W	OPERR-ZBASE

    SECTION ZCODE

	PAGE
* ----------------------------------------------------------------------------
* STRING FUNCTIONS
* ----------------------------------------------------------------------------

* ZSTR CHARACTER CONVERSION VECTOR

    SECTION ZDATA
ZCHRS	DC.B	'abcdefghijklmnopqrstuvwxyz'	* CHAR SET 1
	DC.B	'ABCDEFGHIJKLMNOPQRSTUVWXYZ'	* CHAR SET 2
	DC.B	'  0123456789.,!?_#'		* CHAR SET 3

	DC.B	$27,$22		* <'>,<">
	DC.B	'/\-:()'
	DC.B	0		* ASCIZ
    SECTION ZCODE

* ----------------------
* PUTSTR
* ----------------------

* OUTPUT A ZSTR, BLOCK-POINTER IN D0, BYTE-POINTER IN D1
* RETURN UPDATED POINTER

PUTSTR  MOVEM.L D2-D5,-(SP)
	CLR.W	D4		* TEMP CS STARTS AT 0
	CLR.W	D5		* PERM CS STARTS AT 0

PSX1	BSR	GETWRD		* GET NEXT STRING WORD
	MOVEM.W D0-D2,-(SP)	* SAVE POINTER & COPY OF STRING WORD

	MOVEQ	#2,D3		* 3 BYTES IN WORD
PSX2	MOVE.W  D2,-(SP)	* PUSH CURRENT BYTE
	ASR.W	#5,D2		* SHIFT TO NEXT BYTE
	DBF	D3,PSX2		* LOOP UNTIL DONE

	MOVEQ	#2,D3		* RETRIEVE THE 3 BYTES ...
PSX3	MOVE.W  (SP)+,D2	* GET NEXT BYTE
	ANDI.W  #$001F,D2	* CLEAR UNWANTED BITS
	TST.W	D4		* IN WORD MODE? (NEGATIVE D4)
	BPL.S	PSX4		* NO

	ASL.W	#1,D2		* YES, CALCULATE WORD OFFSET
	MOVE.L  WRDTAB(A6),A0	* GET WORD TABLE POINTER
	ADD.W	WRDOFF(A6),D2	* USE PROPER 32 WORD BLOCK
	ADDA.W  D2,A0		* INDEX INTO WORD TABLE
	BSR	GTAWRD		* GET A POINTER TO THE WORD ITSELF
	BSR	BSPLIT		* SPLIT IT
	BSR	PUTSTR		* AND PRINT IT
	BRA	PSX15		* CONTINUE WHERE WE LEFT OFF WITH TEMP CS RESET

PSX4	CMPI.W  #3,D4		* CS 3 (ASCII MODE) SELECTED?
	BLT.S	PSX6		* NO, NORMAL CS
	BGT.S	PSX5		* NO, BUT WE'RE ALREADY IN ASCII MODE
	BSET	#14,D4		* YES (MAKE D4 LARGE POSITIVE)
	MOVE.B  D2,D4		* SAVE HIGH-ORDER ASCII BITS (3!) HERE
	BRA.S	PSX16		* AND GO GET NEXT BYTE
PSX5	ANDI.W  #$0007,D4	* EXTRACT PREVIOUSLY SAVED HIGH-ORDER BITS
	ASL.W	#5,D4		* POSITION THEM
	OR.W	D2,D4		* OR IN LOW-ORDER BITS
	MOVE.W  D4,D0
	BRA.S	PSX14		* GO PRINT THE CHARACTER

PSX6	CMPI.W  #6,D2		* SPECIAL CODE (0 TO 5)?
	BLT.S	PSX9		* YES, SPACE, WORD, OR SHIFT
	CMPI.W  #2,D4		* MIGHT ALSO BE SPECIAL IF IN CS 2
	BNE.S	PSX8		* BUT WE'RE NOT

	CMPI.W  #7,D2		* CS 2, SPECIAL CODE FOR CRLF?
	BEQ.S	PSX7		* YES
	BGT.S	PSX8		* NO, NOT ASCII MODE, EITHER?
	ADDQ.W  #1,D4		* YES IT IS, SWITCH TO ASCII MODE (CS 3)
	BRA.S	PSX16		* AND GO GET NEXT BYTE
PSX7	BSR	PUTNEW		* CRLF REQUESTED, DO A NEWLINE
	BRA.S	PSX15

PSX8	MOVE.W  D4,D1		* NORMAL CHARACTER, GET CS
	MULU	#26,D1		* CALCULATE OFFSET FOR THIS CS
	ADD.W	D2,D1		* ADD IN CHARACTER OFFSET (+6)

	LEA	ZCHRS,A0
	MOVE.B  -6(A0,D1.W),D0  * GET THE CHARACTER FROM CONVERSION VECTOR
	BRA.S	PSX14		* GO PRINT IT

PSX9	TST.W	D2		* IS IT A SPACE?
	BNE.S	PSX10		* NO
	MOVEQ	#32,D0		* YES, GO PRINT A SPACE
	BRA.S	PSX14

PSX10	CMPI.W  #3,D2		* IS IT A WORD?
	BGT.S	PSX11		* NO, MUST BE A SHIFT
	BSET	#15,D4		* SWITCH TO WORD MODE (NEG D4) FOR NEXT BYTE
	SUBQ.W  #1,D2		* CALCULATE WORD-TABLE BLOCK OFFSET
	ASL.W	#6,D2		* 64 BYTES IN A BLOCK
	MOVE.W  D2,WRDOFF(A6)	* SAVE IT AND LOOP
	BRA.S	PSX16

PSX11	SUBQ.W  #3,D2		* CALCULATE NEW CS
	TST.W	D4		* TEMPORARY SHIFT (FROM CS 0)?
	BNE.S	PSX12		* NO
	MOVE.W  D2,D4		* YES, JUST SAVE NEW TEMP CS
	BRA.S	PSX16

PSX12	CMP.W	D2,D4		* IS THIS THE CURRENT CS?
	BEQ.S	PSX13		* YES, DO A PERM SHIFT TO IT
	CLR.W	D4		* OTHERWISE, PERM SHIFT TO CS 0
PSX13	MOVE.W  D4,D5		* TEMP AND PERM CS'S ARE THE SAME NOW
	BRA.S	PSX16

PSX14	BSR	PUTCHR		* OUTPUT THE CHARACTER
PSX15	MOVE.W  D5,D4		* RESET TEMP CS TO PERM CS
PSX16	DBF	D3,PSX3		* LOOP FOR NEXT BYTE

	MOVEM.W (SP)+,D0-D2	* RESTORE POINTERS & ORIGINAL STRING WORD
	TST.W	D2		* END-OF-STRING (HIGH BIT SET)?
	BPL	PSX1		* NO, GO GET NEXT WORD
	MOVEM.L (SP)+,D2-D5	* YES, CLEAN UP & RETURN UPDATED POINTER
	RTS

* ----------------------
* CHRCS
* ----------------------

* GIVEN AN ASCII CHARACTER IN D0, RETURN THE CHARACTER SET # IN D0

CHRCS	TST.B	D0		* IS THIS A NULL?
	BNE.S	CHRCX1		* NO
	MOVEQ	#3,D0		* YES, RETURN DUMMY CS NUMBER
	BRA.S	CHRCX4

CHRCX1	CMPI.B  #'a',D0		* LOWERCASE CHAR?
	BLT.S	CHRCX2		* NO
	CMPI.B  #'z',D0
	BGT.S	CHRCX2		* NO
	CLR.W	D0		* YES, RETURN CS 0
	BRA.S	CHRCX4

CHRCX2	CMPI.B  #'A',D0		* UPPERCASE CHAR?
	BLT.S	CHRCX3		* NO
	CMPI.B  #'Z',D0
	BGT.S	CHRCX3		* NO
	MOVEQ	#1,D0		* YES, RETURN CS 1
	BRA.S	CHRCX4

CHRCX3	MOVEQ	#2,D0		* OTHERWISE CALL IT CS 2
CHRCX4	RTS

* ----------------------
* CHRBYT
* ----------------------

* GIVEN AN ASCII CHARACTER IN D0, RETURN ZSTR BYTE VALUE IN D0 (6 TO 31, OR 0)

CHRBYT  LEA	ZCHRS,A0	* POINT TO CONVERSION VECTOR

CHRBX1	CMP.B	(A0)+,D0	* FOUND THE CHARACTER?
	BEQ.S	CHRBX2		* YES
	TST.B	(A0)		* END OF STRING?
	BNE	CHRBX1		* NO, CONTINUE SEARCH
	CLR.W	D0		* YES, RETURN ZERO FOR FAILURE
	BRA.S	CHRBX4

CHRBX2	MOVE.L  A0,D0		* CALCULATE OFFSET OF CHAR INTO VECTOR
	LEA	ZCHRS,A0
	SUB.L	A0,D0
	ADDQ.W  #5,D0		* ADJUST OFFSET SO FIRST CHAR IS 6

CHRBX3	CMPI.W  #32,D0		* IN BASE CODE RANGE (6-31)?
	BLT.S	CHRBX4		* YES
	SUBI.W  #26,D0		* SUBTRACT MULTIPLES OF 26 UNTIL BASE CODE
	BRA	CHRBX3
CHRBX4	RTS

* ----------------------
* ZWORD
* ----------------------

* GIVEN UP TO 6 (EZIP 9) ASCIZ CHARACTERS, BUFFER POINTER IN A1,
*   CONVERT THEM TO A TWO (EZIP THREE) WORD ZSTR, BUFFER POINTER IN A0

PADCHR  EQU	5		* ZSTR PADDING CHAR (SHIFT 2)

ZWORD	MOVEM.L D1-D2/A2,-(SP)
	MOVE.L  A0,A2
	MOVE.W  #VCHARS,D2	* NUMBER OF PACKED CHARS IN A ZSTR (6 OR 9)

ZWX1	CLR.W	D1
	MOVE.B  (A1)+,D1	* GET NEXT CHARACTER, END-OF-STRING?
	BEQ.S	ZWX4		* YES

	MOVE.W  D1,D0
	BSR	CHRCS		* FIND THE CS NUMBER FOR THIS CHAR
	TST.W	D0		* CS 0?
	BEQ.S	ZWX2		* YES
	ADDQ.W  #3,D0		* NO, CALCULATE TEMP SHIFT BYTE
	MOVE.W  D0,-(SP)	* SAVE THE SHIFT BYTE
	SUBQ.W  #1,D2		* REDUCE BYTE COUNT, DONE YET?
	BEQ.S	ZWX6		* YES

ZWX2	MOVE.W  D1,D0
	BSR	CHRBYT		* FIND THE PROPER BYTE VALUE FOR THIS CHAR
	TST.W	D0		* IN NORMAL CS'S?
	BNE.S	ZWX3		* YES

	MOVEQ	#6,D0		* NO, USE ASCII SHIFT
	MOVE.W  D0,-(SP)
	SUBQ.W  #1,D2		* DONE YET?
	BEQ.S	ZWX6		* YES

	MOVE.W  D1,D0		* NO, SAVE HIGH-ORDER ASCII BITS (3)
	ASR.W	#5,D0
	MOVE.W  D0,-(SP)
	SUBQ.W  #1,D2		* DONE YET?
	BEQ.S	ZWX6		* YES

	MOVE.W  D1,D0		* NO, SAVE LOW-ORDER ASCII BITS (5)
	ANDI.W  #$001F,D0
ZWX3	MOVE.W  D0,-(SP)	* SAVE THIS BYTE

	SUBQ.W  #1,D2		* AND LOOP UNTIL ZWORD FULL
	BNE	ZWX1
	BRA.S	ZWX6

ZWX4	MOVE.W  #PADCHR,-(SP)	* END OF STRING, SAVE A PAD BYTE
	SUBQ.W  #1,D2		* LOOP UNTIL ZSTR FULL
	BNE	ZWX4

*** BUILD A ZSTR FROM THE SAVED BYTES ...

ZWX6	MOVE.W  #VCHARS*2,D2	* 6 OR 9 CHARS (WORDS) ON STACK
	MOVE.L  SP,A0		* DON'T DISTURB SP YET (IN CASE OF INTERRUPTS)
	ADDA.W  D2,A0
	MOVE.W	#VCHARS/3,D1	* 2 OR 3 TIMES THROUGH LOOP

ZWX7	MOVE.W  -(A0),D0
	ASL.W	#5,D0
	OR.W	-(A0),D0
	ASL.W	#5,D0
	OR.W	-(A0),D0
	MOVE.W  D0,(A2)+	* STORE A PACKED ZWORD IN RETURN BUFFER

	SUBQ.W	#1,D1
	BNE	ZWX7		* GO FOR NEXT

	BSET	#7,-2(A2)	* SET HIGH-ORDER BIT IN LAST ZWORD
	ADDA.W  D2,SP		* AND FLUSH THE STACK

	MOVEM.L (SP)+,D1-D2/A2
	RTS


	PAGE
*--------------------------------------------------------------------------
* GENERALIZED OUTPUT FOLDING ROUTINE
*--------------------------------------------------------------------------

* ----------------------
* INITQP
* ----------------------

* ALLOCATE AND INITIALIZE A QUEUE PARAMETER BLOCK,
*   D1 IS MAXIMUM SIZE OF BUFFER (IN BYTES), D2 IS INITIAL UNIT SIZE
*   A1 -> LINE OUTPUT FUNCTION, A2 -> UNIT SIZE FUNCTION
*   RETURN A0 -> PARAMETER BLOCK

INITQP	MOVE.W	D1,D0
	ADD.W	#QPLEN,D0	* TOTAL SPACE TO ALLOCATE
	EXT.L	D0
	BSR	GETMEM		* GET IT

	MOVE.L	A0,D0		* PARAMETERS BLOCK WILL START HERE
	ADD.L	#QPLEN,D0
	MOVE.L	D0,BUFPTR(A0)	* LINE BUFFER STARTS HERE
	MOVE.L	D0,NXTPTR(A0)	* ALSO CURRENT POINTER

	MOVE.L	A1,OUTFUN(A0)	* INITIALIZE LINE OUTPUT FUNCTION
	MOVE.L	A2,SIZFUN(A0)	* INITIALIZE CHAR SIZE FUNCTION

	CLR.W	CURSIZ(A0)	* ALWAYS EMPTY INITIALLY
	CLR.B	DUMPED(A0)	* THIS ONE IS SET ONLY BY PUTLIN
	MOVE.W	D2,D0		* UNIT CAPACITY OF BUFFER ...  [FALL THRU]

* CHANGE THE LINE WRAP POINT, A0 -> PARAMETER BLOCK, DO = NEW LENGTH (UNITS)
*   RETURN A0 -> PARAMETER BLOCK

SIZEQP	
*** IN THE FUTURE, IF EXTRA ROOM IS NEEDED FOR ITALICS, CALLER SHOULD  
*** (TEMPORARILY) INCREMENT CURSIZ.  MUST LEAVE BUFSIZ AT MAX SO BUFFERING 
*** CAN WORK CORRECTLY IN SCREEN 1, IF USED.
***	SUBQ.W    #1,D0		* >>> ALLOW FOR ATARI ITALICS HACK <<<

	MOVE.W	D0,BUFSIZ(A0)	* STORE IT
	RTS

* ----------------------
* QUECHR
* ----------------------

* QUEUE THE CHAR IN D0 FOR OUTPUT, A0 POINTS TO QUEUE-PARAMETERS BLOCK

QUECHR	MOVEM.L	D4/A1-A4,-(SP)
	MOVE.W	D0,D4
	MOVE.L	A0,A4

	MOVE.W	CURSIZ(A4),D0
	CMP.W	BUFSIZ(A4),D0	* BUFFER FULL YET?
	BLT	QCX8		* NO
***	BGT	QCX0		* OVERFULL (DEQUE THE LAST CHAR AND REENTER)

	CMPI.B  #32,D4		* YES, BUT DID A SPACE CAUSE OVERFLOW?
	BNE.S	QCX1		* NO

	MOVE.L  NXTPTR(A4),D0	* YES, JUST PRINT THE WHOLE BUFFER
	MOVE.L	BUFPTR(A4),A0

	MOVE.L	OUTFUN(A4),A3	
	JSR	(A3)

	CLR.W	CURSIZ(A4)		* RESET LENGTH COUNTER
	MOVE.L  BUFPTR(A4),NXTPTR(A4)	* RESET CURRENT CHAR POINTER
	CLR.B	DUMPED(A4)		* STARTING A FRESH LINE
	BRA.S	QCX9			* EXIT, IGNORING SPACE

* FOLDING ROUTINE, SEARCH FOR MOST-RECENT SPACE ...

QCX1	MOVE.L  BUFPTR(A4),A1	* BEGINNING OF BUFFER
	MOVE.L  NXTPTR(A4),A2	* END OF BUFFER (+1)
	BRA.S	QCX2A		* ALLOW FOR EMPTY [DUMPED] BUFFER 

QCX2	CMPI.B  #32,-(A2)	* SEARCH FOR SPACE BACKWARDS FROM END
	BEQ.S	QCX4		* FOUND ONE
QCX2A	CMPA.L  A1,A2		* REACHED BEGINNING OF BUFFER?
	BGT	QCX2		* NOT YET

* NO SPACES FOUND, DUMP WHOLE BUFFER ...

QCX3	TST.B	DUMPED(A4)	* BUT WAS THIS BUFFER ALREADY PARTLY EMPTIED?
	BNE.S	QCX5		* YES, CARRY EVERYTHING OVER TO NEXT LINE

	MOVE.L	NXTPTR(A4),A2	* OTHERWISE, OUTPUT EVERYTHING
	BRA.S	QCX5

* SPACE WAS FOUND, DUMP THE BUFFER (THROUGH SPACE) ...

QCX4	MOVE.L	A2,A0		* POINTER TO THE SPACE
	ADDQ.L	#1,A2		* POINTER PAST THE SPACE

	CMPA.L  A1,A0		* DEGENERATE CASE WITH SPACE AT BUFPTR?
	BEQ	QCX3		* YES, OUTPUT WHOLE LINE

QCX5	MOVE.L  A2,D0		* LAST CHAR TO PRINT (+1)
	MOVE.L	A1,A0		* START OF BUFFER

	MOVE.L	OUTFUN(A4),A3	* GO DUMP IT, ADDING A CR
	JSR	(A3)

* SHIFT ANY REMAINING CHARS TO FRONT OF BUFFER ...

	CLR.W	CURSIZ(A4)	* ZERO THE UNIT COUNT
	CLR.B	DUMPED(A4)	* START WITH A FRESH BUFFER
	BRA.S	QCX7

QCX6	MOVE.B  (A2)+,D0
	MOVE.B	D0,(A1)+	* COPY NEXT CHAR TO BEGINNING OF BUF

	MOVE.L	SIZFUN(A4),A0	* CHAR STILL IN D0
	JSR	(A0)
	ADD.W	D0,CURSIZ(A4)	* UPDATE THE UNIT COUNT

QCX7	CMPA.L  NXTPTR(A4),A2	* ANY MORE CHARS AFTER SPACE?
	BLT	QCX6		* YES
	MOVE.L  A1,NXTPTR(A4)	* NO, STORE NEW CURRENT POINTER HERE

* FINALLY, STORE THE NEW CHAR AND EXIT ...

QCX8	MOVE.L	NXTPTR(A4),A0
	MOVE.B  D4,(A0)+	* STORE THE NEW CHARACTER IN BUFFER
	MOVE.L  A0,NXTPTR(A4)	* AND UPDATE POINTER

	MOVE.W	D4,D0
	MOVE.L	SIZFUN(A4),A0
	JSR	(A0)		* GET UNIT SIZE OF NEW CHAR
	ADD.W	D0,CURSIZ(A4)	* AND UPDATE COUNTER

QCX9	MOVEM.L (SP)+,D4/A1-A4
	RTS

*--------------------------------------------------------------------------
* MAIN OUTPUT HANDLER
*--------------------------------------------------------------------------

* !ALL! OUTPUT GENERATED BY THE GAME (AND THE USER) SHOULD BE CHANNELED 
*   THROUGH THE FOLLOWING TWO ROUTINES, WHICH REDIRECT IT APPROPRIATELY.

* CALL GERMAN-CHAR CHECK HERE, SINCE ALL THE PRINTx OPCODES (8 OR SO)
* ARE CHANNELED THROUGH HERE.

* ----------------------
* PUTNEW
* ----------------------

* OUTPUT A NEWLINE

PUTNEW	MOVEQ	#13,D0		* JUST FALL THROUGH WITH A CR

* ----------------------
* PUTCHR
* ----------------------

* OUTPUT THE CHAR IN D0 (TO THE REQUESTED DEVICES)

PUTCHR	CMPI.B	#9,D0		* TAB? (OLD ZORK BUG, DISPLAYS GARBAGE)
	BNE.S	PCX1
	MOVEQ	#32,D0		* YES, MAP TO A SPACE

PCX1	BSR	GERCHR		* IF GERMAN CHAR, CONVERT TO KEYCODE

*** STATUS LINE OUTPUT (ZIP INTERNAL FUNCTION ONLY) ...

    IFEQ CZIP
	TST.W	VOSTAT(A6)	* SPECIAL OUTPUT TO SL HANDLER?
	BNE	PUTSL		* YES (ABORT PUTCHR)
    ENDC

*** TABLE OUTPUT ...

    IFEQ EZIP
	TST.W	VOTABL(A6)	* TABLE OUTPUT?
	BNE	TABCHR		* YES (ABORT PUTCHR PER "DIROUT" SPEC)
    ENDC

	MOVE.W	D0,-(SP)	* OTHERWISE, SAVE THE CHAR HERE

*** SCRIPT (BEFORE SCREEN, SO "OPEN" ERROR DISPLAYS IN CORRECT SEQUENCE)

    IFEQ EZIP
	TST.W	VOPRNT(A6)	* SCRIPTING ACTIVE?
    ENDC
    IFEQ CZIP
	BSR	TSTSCR		* CHECK FOR SCRIPTING REQUEST -- ACTIVE?
    ENDC
	BEQ.S	PCX2		* NO

	MOVE.W	(SP),D0		* SCRIPT THIS CHAR
	BSR	SCRCHR

*** SCREEN DISPLAY ...

PCX2	TST.W	VOCONS(A6)	* CONSOLE OUTPUT ACTIVE?
	BEQ.S	PCX3		* NO

	MOVE.W	(SP),D0		* YES, DISPLAY THE CHAR
	BSR	QDCHR

*** FILE OUTPUT ...

PCX3	NOP			* NOT IMPLEMENTED

	TST.W	(SP)+		* FLUSH CHAR FROM STACK
	RTS

*--------------------------------------------------------------------------
* TERMINAL DISPLAY FUNCTIONS
*--------------------------------------------------------------------------

* ----------------------
* QDCHR
* ----------------------

* QUEUE/DISPLAY THE CHAR IN D0

QDCHR	TST.W	VOBUFF(A6)	* IS BUFFERING TURNED OFF?
	BEQ	OUTCHR		* YES, GO TO SCREEN (THIS HANDLES CR'S ALSO)

	CMPI.B	#13,D0		* CR?
	BEQ	NEWLIN		* YES, DUMP THE BUFFER

	MOVE.L	DQUE(A6),A0	* OTHERWISE, GO QUEUE IT
	BRA	QUECHR	

* ----------------------
* NEWLIN
* ----------------------

* GO TO NEW LINE, OUTPUTTING CURRENT BUFFER
*   (THIS ROUTINE NOW CALLED ONLY FROM THE PRECEEDING ROUTINE)

NEWLIN	MOVE.L	A4,-(SP)
	MOVE.L	DQUE(A6),A4	* SCREEN BUFFER

	MOVE.L	BUFPTR(A4),A0	* START OF LINE
	MOVE.L  NXTPTR(A4),D0	* END OF CURRENT LINE
	BSR	LINOUT		* CHECK "MORE", OUTPUT LINE, ADD A CR

	MOVE.L  BUFPTR(A4),NXTPTR(A4)	* RESET CHARACTER POINTER
	CLR.W	CURSIZ(A4)		* RESET UNIT COUNT
	CLR.B	DUMPED(A4)		* NO OUTPUT ON NEW LINE YET

	MOVE.L	(SP)+,A4
	RTS

* ----------------------
* PUTLIN
* ----------------------

* OUTPUT CURRENT BUFFER, WITHOUT A NEWLINE
*   (ASSUMES SOMETHING LIKE OPREAD WILL SUPPLY THE NEWLINE)

PUTLIN1  MOVE.L	DQUE(A6),A0
	CLR.W	CURSIZ(A0)	* RESET UNIT COUNT (BUFFER EMPTY)

* ENTER HERE IF BUFFERING WILL LATER RESUME FROM CURRENT POINT

PUTLIN	MOVE.L	A4,-(SP)
	MOVE.L	DQUE(A6),A4	* SCREEN BUFFER

	MOVE.L	BUFPTR(A4),A0	* START OF LINE
	MOVE.L  NXTPTR(A4),D0	* END OF CURRENT LINE
	BSR	BUFOUT		* OUTPUT IT (NO CR, BUT DOES CHECK [MORE])

	MOVE.L  BUFPTR(A4),NXTPTR(A4)	* RESET CHARACTER POINTER
	MOVE.B	#1,DUMPED(A4)		* REMEMBER BUFFER IS PARTLY DUMPED
	MOVE.L	(SP)+,A4
	RTS

*--------------------------------------------------------------------------
* SCRIPT BUFFERING
*--------------------------------------------------------------------------

* ----------------------
* SCRCHR
* ----------------------

* /ALL/ SCRIPT OUTPUT IS CHANNELED THROUGH HERE

* QUEUE THE CHAR IN D0 FOR SCRIPTING  (UNLESS SCREEN 1 IS ACTIVE; IF SO, 
* TEMPORARILY SUPPRESS SCRIPTING)

SCRCHR	MOVEM.W	D0,-(SP)	* SAVE CHAR, BUT DON'T DISTURB FLAGS
	BSR	GETSCRN		* ARE WE IN WINDOW 1?
	MOVEM.W	(SP)+,D0	
	BEQ.S	SCRCX1		* NO
	RTS			* YES, AVOID SCRIPTING

SCRCX1	CMPI.B	#13,D0		* CR?
	BEQ.S	SCRLIN		* YES, DUMP SCRIPT BUFFER

	MOVE.L	SQUE(A6),A0	* SCRIPTING PARAMETERS BLOCK
	BRA	QUECHR		* GO QUEUE CHAR

* GOT A NEWLINE -- SCRIPT THE CURRENT BUFFER

SCRLIN	MOVE.L	A4,-(SP)
	MOVE.L	SQUE(A6),A4	* SCRIPTING PARAMETERS BLOCK

	MOVE.L	BUFPTR(A4),A0	* START OF LINE
	MOVE.L  NXTPTR(A4),D0	* END OF CURRENT LINE
	BSR	SCROUT		* OUTPUT LINE, ADD A CR ...

	MOVE.L  BUFPTR(A4),NXTPTR(A4)	* RESET CHARACTER POINTER
	CLR.W	CURSIZ(A4)		* RESET UNIT COUNT

	MOVE.L	(SP)+,A4
	RTS

* ----------------------
* SCRINP
* ----------------------

* OUTPUT A USER INPUT LINE TO THE TRANSCRIPT (IF SCRIPTING)
*   START IN A0, LENGTH IN D0, FLAG IN D1 (NONZERO) FOR CR

SCRINP  MOVEM.L	A2/D2,-(SP)
	MOVE.L	A0,A2		* PROTECT ARGS
	MOVE.W	D0,D2

    IFEQ EZIP
	TST.W	VOPRNT(A6)	* SCRIPTING?
    ENDC
    IFEQ CZIP
	BSR	TSTSCR		* CHECK FOR SCRIPT REQUEST -- ACTIVE?
    ENDC
	BEQ.S	SCRIX3		* NO, EXIT

	TST.W	D2		* LENGTH OF INPUT
	BEQ.S	SCRIX2		* ZERO, JUST DO THE CR

SCRIX1	MOVE.B  (A2)+,D0	* SCRIPT NEXT CHAR
	BSR	SCRCHR		*   (USE BUFFERING, SO WRAP IS CORRECT)
	SUBQ.W	#1,D2
	BNE.S	SCRIX1

SCRIX2	TST.W	D1		* CR REQUESTED?
	BEQ.S	SCRIX3		* NO
	MOVEQ	#13,D0		* YES, ADD THE CR
	BSR	SCRCHR

SCRIX3	MOVEM.L (SP)+,D2/A2
	RTS

* ----------------------
* SCRNAM
* ----------------------

* ECHO THE SAVE/RESTORE FILENAME TO THE TRANSCRIPT (IF SCRIPTING)
*   (USER SELECTED IT THRU A SPECIAL DIALOG)
*   A0 -> NAME, D0 = LEN

SCRNAM	TST.W	VOPRNT(A6)	* SCRIPTING?
	BEQ.S	SCNMX1		* NO, EXIT
	MOVE.L	D1,-(SP)
	MOVEM.L	A0/D0,-(SP)

	LEA	MSGSCN,A0	* 'File: '
	BSR	STRLEN		* LEAVE LENGTH OF STRING IN D0
	CLR.W	D1		* NO CR YET
	BSR	SCRINP
    SECTION ZDATA
MSGSCN	DC.B	'File: ',0	* (PHRASE OKAY FOR BOTH SAVE & RESTORE)
    SECTION ZCODE

	MOVEM.L	(SP)+,A0/D0	* NAME & LEN
	MOVEQ	#1,D1		* END WITH CR
	BSR	SCRINP

	MOVE.L	(SP)+,D1
SCNMX1	RTS

	PAGE
* ----------------------------------------------------------------------------
* PAGING ROUTINES
* ----------------------------------------------------------------------------

* ----------------------
* NEWZPC
* ----------------------

* NORMALIZE ZPC & (IF NECESSARY) GET PROPER PAGE

NEWZPC  MOVE.W	ZPC2(A6),D0	* LOW ORDER ZPC
	ASR.W	#8,D0		* EXTRACT REQUIRED BLOCK ADJUSTMENT (+ OR -)
	ASR.W	#1,D0

	ADD.W	D0,ZPC1(A6)	* AND ADJUST HIGH ORDER ZPC
	ANDI.W	#$01FF,ZPC2(A6)	* NORMALIZE LOW ORDER ZPC

* GET THE INDICATED PAGE

	MOVE.W	ZPC1(A6),D0
	CMP.W	CURBLK(A6),D0	* HAS THE BLOCK CHANGED?
	BEQ.S	NZX4		* NO, EXIT
	MOVE.W  D0,CURBLK(A6)	* YES, REMEMBER NEW BLOCK

	TST.L	CURTAB(A6)	* IS OLD PAGE PRELOADED?
	BEQ.S	NZX2		* YES
	MOVE.L  CURTAB(A6),A0	* NO, RESTORE CURRENT REF TIME FOR OLD PAGE
	MOVE.L  RTIME(A6),2(A0)

NZX2	CMP.W	ENDLOD(A6),D0	* IS NEW PAGE PRELOADED?
	BLT.S	NZX3		* YES
	BSR	GETPAG		* NO, GET THE NEW PAGE
	MOVE.L  A0,CURPAG(A6)	* REMEMBER NEW PAGE POINTER

	MOVE.L  LPTAB(A6),A0	* GET NEW TABLE POINTER
	MOVE.L  A0,CURTAB(A6)	* SAVE THIS POINTER FOR LATER
	MOVE.L  #-1,2(A0)	* FAKE A HIGH RTIME TO PROTECT ZPC PAGE FOR US
	BRA.S	NZX4

NZX3	BSR	BLKBYT		* CALCULATE PRELOAD PAGE ADDRESS
	ADD.L	BUFFER(A6),D0	* ABSOLUTIZE
	MOVE.L  D0,CURPAG(A6)	* REMEMBER NEW PAGE POINTER
	CLR.L	CURTAB(A6)	* ZERO TABLE POINTER MEANS PAGE IS PRELOADED

NZX4	RTS

* ----------------------
* GETPAG
* ----------------------

* GET THE PAGE WHOSE NUMBER IS IN D0, RETURN A POINTER TO IT IN A0

GETPAG  CMP.W	LPAGE(A6),D0	* IS THIS THE SAME PAGE AS LAST REFERENCED?
	BEQ.S	GPX4		* YES, RETURN ITS LOCATION

	MOVE.W  D0,LPAGE(A6)	* SAVE NEW PAGE NUMBER
	ADDQ.L  #1,RTIME(A6)	* UPDATE REFERENCE COUNT
	MOVE.L  PAGTAB(A6),A0	* PAGE INFORMATION TABLE

GPX1	CMP.W	(A0),D0		* SEARCH FOR DESIRED BLOCK
	BNE.S	GPX3		* NOT IT

	CMP.W	CURBLK(A6),D0	* FOUND IT, BUT IS IT THE CURRENT ZPC PAGE?
	BEQ.S	GPX2		* YES, DON'T TOUCH REF TIME (PAGE IS PROTECTED)
	MOVE.L  RTIME(A6),2(A0)	* NO, UPDATE ITS REFERENCE TIME

GPX2	MOVE.L  A0,LPTAB(A6)	* SAVE THE TABLE POINTER
	MOVE.L  A0,D0
	SUB.L	PAGTAB(A6),D0	* BUFFER NUMBER x8
	ASL.L	#6,D0		* CALCULATE CORE ADDRESS OF PAGE
	ADD.L	PAGES(A6),D0
	MOVE.L  D0,LPLOC(A6)	* SAVE IT
	BRA.S	GPX4		* AND RETURN IT

GPX3	ADDQ.L  #8,A0		* SKIP OVER REFERENCE TIME, ETC.
	CMPI.W  #-1,(A0)	* END OF TABLE?
	BNE	GPX1		* NO, CONTINUE SEARCH

* DESIRED PAGE NOT RESIDENT, MUST READ IT FROM DISK

	MOVE.L  A1,-(SP)
	BSR	FINDPG		* FIND AN OLD PAGE
	MOVE.L  A0,LPLOC(A6)	* SAVE ITS PAGE POINTER
	MOVE.L  A1,LPTAB(A6)	* SAVE ITS PAGTAB POINTER

	MOVE.W  LPAGE(A6),D0	* NEW PAGE NUMBER FOR GETBLK
	MOVE.W  D0,(A1)+	* SAVE PAGE NUMBER IN FIRST SLOT
	MOVE.L  RTIME(A6),(A1)  * SAVE CURRENT REF TIME

	BSR	GETBLK		* GET THE BLOCK
	MOVE.L  (SP)+,A1	* CLEAN UP

GPX4	MOVE.L  LPLOC(A6),A0	* RETURN THE PAGE POINTER
	RTS

* ----------------------
* FINDPG
* ----------------------

* FIND A GOOD (LRU) PAGE, RETURN PAGE POINTER IN A0 & PAGTAB POINTER IN A1

FINDPG  MOVE.L  PAGTAB(A6),A0
	ADDQ.L  #2,A0		* SKIP OVER FIRST PAGE NUMBER
	MOVE.L  #-1,D0		* FAKE A BEST-CASE REFERENCE COUNT

FDPGX1	CMP.L	(A0),D0		* COMPARE PREV OLDEST REF TIME WITH THIS ONE
	BLS.S	FDPGX2		* STILL THE OLDEST

	MOVE.L  (A0),D0		* NEW OLDEST, SAVE THIS REFERENCE COUNT
	MOVE.L  A0,A1		* AND PAGTAB LOCATION (+2)

FDPGX2	ADDQ.L  #6,A0		* SKIP OVER REF TIME, ETC.
	CMPI.W  #-1,(A0)+	* END OF TABLE?
	BNE	FDPGX1		* NO

	SUBQ.L  #2,A1		* RETURN THE PAGTAB LOCATION HERE
	MOVE.L  A1,D0
	SUB.L	PAGTAB(A6),D0	* BUFFER NUMBER x8
	ASL.L	#6,D0		* CALCULATE CORE ADDRESS OF PAGE
	ADD.L	PAGES(A6),D0
	MOVE.L  D0,A0		* AND RETURN IT HERE
	RTS
