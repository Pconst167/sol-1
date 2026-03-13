;      ====================================================================
;        DR  6502    AER 201S Engineering Design 6502 Execution Simulator
;      ====================================================================
;
;      Supplementary Notes                                   By: M.J.Malone
;
;
;                         Project Board Test Program
;                         ==========================
;  This program sets Port A to input and Port B to output on both VIAs.
;  The program reads from Port A and writes to Port B making the computer
;  act as a giant wire.  If you connect Port A, bit 0 to ground, bit 0 of
;  Port B will go to ground.  If you connect bit 0 of Port A to 5 volts or do
;  not connect it to anything then Port B bit 0 will be 5 volts.  Note that if
;  an input port (Port A in this case) is not connected to anything then it
;  will default to being 5 volts because of an internal pull up resistor in
;  the VIA.
;
;  Note that the data read from Port A is written to memory and read back
;  to test the RAM as well.
;
;  If a board completes this test then the following components are known to
;  work for the following reasons.
;    Proven
;  Component:    Reason:
;     6502       It could not be running the code if it were not working
;     6522s      The ports would not read or write correctly otherwise
;     EPROM      If the program is in EPROM and is running then the EPROM is OK
;     RAM        Because the data read on Port A is reflected correctly on B
;     74HC74     Necessary to the system clock and therefore functioning
;     74HC139    Necessary to the address select of VIA, EPROM and RAM
;     74xx04     Necessary to the clock, R/W and address select functions
;     Reset      The system must be resetting properly if the program runs.
;
;  If the test fails then the above can be used in reverse for troubleshooting.
;
.ORG $E000
	   SEI             ; INITIALIZING THE STACK POINTER
	   LDX #$FF
	   TXS
;
	   LDX #$00        ; Initial delay to allow Spurious Resets to
	   LDY #$00        ; subside.
Delay      DEX
	   BNE Delay
	   DEY
	   BNE Delay
;
PORTA1 = $A001
PORTB1 = $A000
DDRA1  = $A003
DDRB1  = $A002
;
PORTA2 = $8001
PORTB2 = $8000
DDRA2  = $8003
DDRB2  = $8002
;
 
 
 
 
 
 
 
 
 
                                                            page 2 
 
	   lda #%11111111    ; Port Bs to outputs
	   sta DDRB1
	   sta DDRB2
	   lda #%00000000    ; Port As to inputs
	   sta DDRA1
	   sta DDRA2
Top        lda PORTA1    ;  VIA 1:  Port A ==> RAM ==> Port B
	   sta $ab
	   lda $ab
	   sta PORTB1
;
	   lda PORTA2    ;  VIA 2:  Port A ==> RAM ==> Port B
	   sta $ae
	   lda $ae
	   sta PORTB2
;
	   jmp Top
;
.ORG $FFFC
.WORD $E000
.END
