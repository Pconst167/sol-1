            AM LIGHTWAVE TRANSMITTER AND RECEIVER BY JOE SCHARF
-------------------------------------------------------------------------------
                   SCHEMATIC 1  [TRANSMITTER]
-------------------------------------------------------------------------------
            

                        MIC*     C1
                         ()     + .1 uF
              |---------(OO)-----|(--------|      +9V
              |          ()                |       ^
              |    R3              R4      |      /|\
              |     5.6K            5.6K   |       |
              *---/\/\/\-------*---/\/\/\--|-------*-------*------|
              |                |           |       |       |      |
              |                |           >R1     |       |      |
              |                |    |---->>>50K    |       >R5    >R8
              |              __|3___|2_    >VAR    |       >1K    >220
              |              \ +   -  /    |RESIST |       >      >
              |               \OP AMP/-----|--------       |      |
              *----------------\741 /7     |               |      |         **
              |               4 \  /       >R2             |     C/NPN    Q1
              |                  \/        >1M        |---------B| TRANSISTOR
              |                  |6        >          |    |     E\ 2N2222
              |                  |         |     C2   |    |      |
              |                  |         |  + 10 uF |    >R6    |
              |                  ----------*---|(-----*-->>>50K   |
              |                                            >VAR   |
              |                                            |RESIST|       LENS
              |                                            |    __|___***  ^
              |                                            |    \LED /    (|)
              |                                            |     \  /    ( | )
              |                                          R7>      \/      (|)
              |                                          1K>  -----|----   \/
              |                                            >       |       LENS
              |                                            |       |      OPT.
              |                                            |       |
              |                                            |       |
              |--------------------------------------------*-------|
                                                           |
                                                           |
                                                        --------
                                                          ----
                                                           --
_______________________________________________________________________________

R1-GAIN CONTROL
R6-LED BIAS CONTROL ADJUST R6 FOR BEST SOUND QUALITY
R8-LIMITS CURRENT APPLIED TO LED

* - MIC- USE CRYSTAL MICROPHONE OR ELECTRET UNIT (CONNECT RED LEAD TO 9V)
** - TRANSISTOR - USE A 2N2222 NPN TRANSISTOR.
*** - LED - USE A HIGH-BRIGHTNESS RED OR HIGH POWERED INFRARED LED FOR BEST
            RESULTS
_______________________________________________________________________________

THE 741 AMPLIFIES VOICE SIGNALS FROM THE MICROPHONE AND COUPLES THEM THROUGH C2
TO MODULATOR TRANSISTOR Q1.  FOR A FREE-SPACE RANGE OF UP TO 1000 FEET
(AT NIGHT), USE A LENS TO COLLIMATE THE LED BEAM OR USE THIS CIRCUIT AS
AN OPTICAL FIBER TRANSMITTER.
_______________________________________________________________________________

                SCHEMATIC 2 --- AM LIGHTWAVE RECEIVER
_______________________________________________________________________________

              |-----------------------------------------|
              |                                         |
              |                                         |
              |                                         |
              |                                         |
              >R1                                       |
              >100K                                     |
              >                                         |
   LENS       |   C1 .1uF                               |
     ^        *----|(---------*-------|                 |
    (|)      C|               |       |                 |
   ( | )     /Q1              |       |                 |        +9V
   ( | )   B|PHOTOTRANSISTOR  |       |                 |         ^
    (|)     E\       |-----|  |       |                 |        /|\
     \/      |       |   __|3_|2_     |                 |         |
   LENS      |       |  4\ +  - /7    |                 |         |
             *-------*----\ 741/------|-----------------*---------*
             |             \  /       |                 |         |
             |              \/6       |                 |         |
             |               |        >R2               |       ------  C2
             |               |        >100K             |         ^^    .1 uF
             |               |        >                 |        ^ |^
             |               |        |                 |          |
             |               |--------*                 |          |
             |                        |                 |       --------
             |                        |                 |         ----
             |                        |             3|\ |           -
             |                        |       |------|+\|6
             |                        |       |      |* \--------------|
             |                      R3<       |      |  /5        C3   | +
             |                     10K<<------| |----|-/|      100uF -----
             |                     VAR<         |   2|/4|              ^
             |                  RESIST|         |       |              |
             |                        |         |       |       8 OHM|---/|
             |                        |         |       |     SPEAKER|   ||
             |                        |         |       |            |---\|
             |                        |         |       |              |
             |------------------------*---------*-------*--------------|
                                                |
                                                |
                                            ----------
                                              ------
                                                --
_______________________________________________________________________________

R2-GAIN CONTROL
R3-VOLUME CONTROL
C2-PREVENTS OSCILLATION KEEP LEADS TO BATTERY SHORT.

* --- OP AMP --- THIS MAY NOT LOOK LIKE AN OP-AMP BUT IT IS  (VERY HARD TO
                 DRAW THEM ON THE COMPUTER.  USE A 386 OP AMP FOR THIS ONE
_______________________________________________________________________________

THIS RECEIVER WORKS BEST IN SUBDUED LIGHT OR AT NIGHT WHEN USED FOR
FREE-SPACE COMMUNICATIONS ALWAYS PLACE A SHIELD OVER THE DETECTOR IF SUNLIGHT
OR BRIGHT ARTIFICIAL LIGHT IS PRESENT.  AN INFRARED FILTER SHOULD BE USED
FOR BEST RESULTS (DEVELOPED COLOR FILM WORKS WELL) UNLESS THE TRANSMITER
LED EMITS VISIBLE LIGHT.

CAUTION : THIS CIRCUIT CAN PRODUCE LOUD SOUNDS. DO NOT PLACE SPEAKER CLOSE
TO YOUR EAR.
_______________________________________________________________________________

FEEL FREE TO PASS THIS CIRCUIT AROUND AND IF YOU HAVE ANY QUESTIONS OR
PROBLEMS YOU CAN CONTACT ME ON CHUCKS PLACE (304)-776-7078 BY LEAVING E-MAIL
TO:   JOE SCHARF
_______________________________________________________________________________
