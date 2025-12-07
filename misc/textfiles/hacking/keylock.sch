                  SCHEMATIC FOR AN OPTOELECTRONIC KEY LOCK
                  BY JOE SCHARF
                  * DENOTES A CONNECTED WIRE OR A FOOTNOTE
_______________________________________________________________________________
o------*------------------------------------------------------------------+
       |      +-----*---*---*---*-----------*----------------*----*-----  |
       |     ---   ---  |   |   |           |                |    |       |
       |      ^     ^   |+  |   |           |              R5>    |       | *
       | T1   |D1-D4|C1---  >   >           |   R4        10K> Q2 |       |
       )||(---*     |  ^^^  >   >           +---^^^-*----+   >  E/        )||
       )||(   |     |   | R1> R2>                   |    |   *--[B        )||
       )||(---|-----*   |   |   |                   |    | R6>  C\        )||
       |      |     |   |   |   *-----+             |    |   >    |       |
       |     ---   ---  |   |   |     |             |    |   >    |       |
       |      ^     ^   |   |   +---+ |             | PC3v  C/    |   +---+
       |      |     |   |   v     C/  |             |   --- [B    |   *-----+
115V   |      |     |   |  ---PC1 [B  |         Q1 C/    |  E\    o   o     |
60 Hz  |      +-----*---*   |     E\--|--+  +--*---[B    |   |    |SSR|   R7>
       |                |   v        C/  |  |  |   E\ PC4v  C/    o  ---    >
       |                |  ---PC2    [B  |  |R3>     |  --- [B    |  ---    >
       |                |   |        E\--*--+  >     |   |  E\    o   |  C2 |
       |                |   |                  >     |   |    |   |   o    ---
       |                |   |                  |     |PC5v   C/   |   |    ---
       |                |   |                  |     |  ---  [B   |   |     |
       |                |   |                  |     |   |   E\   |   |     |
       |                |   |                  |     |   |        |   *-----+
       |                |   |                  |     |   |        |   |     |
       |                |   |                  |     |   |        |   |     |
       |                +---*------------------*-----*---*--------*---+     |
       |                                                                    |
 o-----+--------------------------------------------------------------------+

_______________________________________________________________________________
                            PARTS LIST

T1: 115 TO 6.3V,.6A:STANCOR P-6465 OR TRIAD F-13X
D1-D4: 1N4000 OR SIMILAR
C1: 500 uF/10V ELECTROLYTIC
C2: .05 uF/200V
SSR (Solid State Relay): CRYDOM D1202 OR EQUIVALENT
R1,R4: 120 OHM,.50W
R3,R5: 10K,.50W
R2,R6: 6.8K,.50W
R7: 470 OHM, .50W
Q1: 2N5172 OR ANY GENERAL PURPOSE NPN
Q2: 2N5354 OR ANY GENERAL PURPOSE PNP
PHOTOCOUPLERS: (PC):GE H13A1 OR EQUIVALENT
SOLENOID: ANY 120V UNIT UP YO 1A COIL CURRENT SUCH AS GUARDIAN 2HD-120VAC
              FOOTNOTE---
* - SOLENOID - JUST MAKING SURE YOU KNOW WHAT THIS PART IS.

        NOTE:  THE NUMBER OF PHOTOCOUPLERS CAN BE FROM TWO TO SIX. SEE BELOW.
_______________________________________________________________________________
THIS PROJECT USES A SOLID STATE RELAY TO DRIVE A SOLENOID. IT IS CONTROLLED BY
A PHOTOCOUPLER TRANSISTOR CIRCUIT.  THE PHOTOCOUPLERS (PC'S) USED ARE OF
INERRUPTER TYPE. HEY HAVE A .12 BY .30-INCH SLOT BETWEEN LED EMITTER
AND TRANSISTOR DETECTOR.  WHEN THE SLOT IS EMPTY OR FILLED WITH AN
INFRARED TRANSMISSIVE MATERIAL, THE PHOTOTRANSISTOR WILL CONDUCT CURRENT IN
RESPONSE TO THE LIGHT OF THE LED. IF THE SLOT IS FILLED WITH AN OPAQUE, THE
TRANSISITOR WILL REMAIN OFF.  THE ENTIRE SLOT IS NOT SENSITIVE.  THE SENSITIVE
PART IS ONLY A SMALL SIXTY-MIL AREA WITHIN THE GAP.  IF AN OBJECT IS PLACED
IN THE SLOT WITH A SIXTY-MIL HOLE IN THE CORRECT LOCATION, THE LED LIGHT WILL
GET THROUGH TO THE TRANSISTOR.  THE KEY LOCK USES AN ARRAY OF THESE
INTERRUPTER PC'S WHICH ARE MIXED SO THAT ONLY THE CORRECT "LIGHT COMBINATION"
WILL OPEN THE LOCK.  WITH 4 PC'S THERE ARE 16 COMBINATIONS 5 GIVES 32 AND
SO ON.  THE CIRCUIT AS SHOWN CONTAINS 5 PC'S THE CIRCUIT WITHOUT CHANGING
RESISTOR VALUES CAN ACCOMODATE FROM FOUR TO SIX PC'S WITH TWO OR THREE USED
THE OPEN (NO LIGHT AS IN PC1 AND PC2) OR THE CLOSED MODE (LIGHT ON THE
TRANSISTOR DETECTOR AS IN PC3-PC5) TO EXPAND THE OPEN TO FOUR COUPLERS
R1 SHOULD BE REDUCED TO 82 OHMS AND ALL FOUR EMITTERS CONNECTED IN SERIES
AND THE DETECTORS IN PARALLEL.  TO EXPAND THE CLOSED COUPLERS TO FOUR,
R4 MUST BE REDUCED TO 82 OHMS AND R2 AND R6 TO 5.6K

TO ASSEMBLE THE ARRAY THE COUPLERS SHOULD BE CAREFULLY GLUED TOGETHER
A SMALL AMOUNT OF EPOXY OR ONE OF THE SUPER GLUES ON ADJACENT SIDES
WILL HOLD THIS ARRAY ANY EXCESS PLASTIC SHOULD BE TRIMMED WITH A SMALL BLADE
 TO INSURE THAT THE CENTERS ARE AT CONSTANT SPACINGS ALSO THE SLOTS MUST BE
KEPT IN LINE ALONG BOTH THE TOPS AND SIDES OR PROBLAMS WILL RESULT LATER ON
  CARE MUST BE TAKES THAT NO GLUE GETS IN THE SLOTS ON THE DETECTORS OR
EMITTERS. A SMALL PIECE OF PLASTIC OR METAL IS GLUED ON ONE ENDTO ACT AS A STOP
FOR THE KEY, AND A COVER IS GLUED TO THE TOP OF THE SOUPLERS. THIS FORMS A
TUNNEL OR KEYWAY.
     THE KEY CAN BE BUILT OUT OF PLASTIC OR METAL.  THE LENGTH IS DETERMINED
BY THE NUMBERS OF PC'S USED IN THE LOCK.  ALLOW ONE-QUARTER INCH OF THE ENTIRE
FOR EACH PC PLUS TWO INCHES FOR A HANDLE.  IF THE KEY IS CUT PRECISELY, IT
WILL SLIDE INTO THE TUNNEL WITHOUT MUCH UP AND DOWN PLAY. AT THIS POINT
THE COMBINATION IS DETERMINED.  DRILL A 1/16-INCH DIAMETER HOLE (ONLY AT
THE CENTERS CORRESPONDING TO THE PC'S USED IN THE CLOSED MODE) THE HOLE
PLACEMENT MUST BE ACCURATE.  IF YOU DO NOT HAVE THE PROPER TOOLS
TO ACCURATELY LOCATE THE HOLES, USE A LARGER DRILL BIT TO INSURE
THAT THE LIGHT PATH IS CLEAR.
     THE ELECTRONICS CAN BE ASSEMBLED WITHIN A 4X5X6-INCH BOX
THE PHOTOCOUPLER ARRAY CAN BE MOUNTED ON A PREFORATED CIRCUIT BOARD
USING SEVERAL OF THE HOLES ON THE PC'S THE OPEN END OF THE PC TUNNEL SHOULD
BE PLACED AT THE EDGE OF THE BOX WITH A HOLE LARGE ENOUGH FOR THE KEYTO ENTER
THE TUNNEL.  WHEN MAKING THE PC DISPLAY, MAKE SURE THAT THE CONNECTORS OF
OF THE NORMALLY OPEN AND NORMALLY CLOSED COUPLERS ARE NOT INTERCHANGED
ONCE THE UNIT IS ASSEMBLED, INSERTING THE KEY SHOULD ENERGISE THE SOLENOID
IF NOT CHECK THE COLLECTOR VOLTAGE OF Q1.
_______________________________________________________________________________

      WELL, THIS IS IT I GOT IT OUT OF A BOOK CALLED OPTOELECTRONICS GUIDEBOOK
IF YOU HAVE ANY QUESTIONS LEAVE E-MAIL ON CHUCKS PLACE (304-776-7078)
TO JOE SCHARF  HOPE YOU ENJOY THIS AND IF YOU HAVE ANY UPLOAD THEM TO THE
BOARD.
_______________________________________________________________________________
