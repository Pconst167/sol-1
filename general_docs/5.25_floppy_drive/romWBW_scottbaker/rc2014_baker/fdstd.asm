; Various constants from N8VEM project RomWBW
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

FCD_LEN         .EQU    13

TRUE            .EQU    1
FALSE           .EQU    0

DOP_READ        .EQU    0               ; READ OPERATION
DOP_WRITE       .EQU    1               ; WRITE OPERATION
DOP_FORMAT      .EQU    2               ; FORMAT OPERATION
DOP_READID      .EQU    3               ; READ ID OPERATION

FDM720          .EQU    0               ; 3.5" FLOPPY, 720KB, 2 SIDES, 80 TRKS, 9 SECTORS
FDM144          .EQU    1               ; 3.5" FLOPPY, 1.44MB, 2 SIDES, 80 TRKS, 18 SECTORS
FDM360          .EQU    2               ; 5.25" FLOPPY, 360KB, 2 SIDES, 40 TRKS, 9 SECTORS
FDM120          .EQU    3               ; 5.25" FLOPPY, 1.2MB, 2 SIDES, 80 TRKS, 15 SECTORS
FDM111          .EQU    4               ; 8" FLOPPY, 1.11MB, 2 SIDES, 74 TRKS, 15 SECTORS

;
; MEDIA ID VALUES
;
MID_NONE        .EQU    0
MID_MDROM       .EQU    1
MID_MDRAM       .EQU    2
MID_RF          .EQU    3
MID_HD          .EQU    4
MID_FD720       .EQU    5
MID_FD144       .EQU    6
MID_FD360       .EQU    7
MID_FD120       .EQU    8
MID_FD111       .EQU    9

FDMODE_NONE     .EQU    0               ; FD modes defined in std-*.inc
FDMODE_DIO      .EQU    1               ; DISKIO V1
FDMODE_ZETA     .EQU    2               ; ZETA
FDMODE_ZETA2    .EQU    3               ; ZETA V2
FDMODE_DIDE     .EQU    4               ; DUAL IDE
FDMODE_N8       .EQU    5               ; N8
FDMODE_DIO3     .EQU    6               ; DISKIO V3
FDMODE_SCOTT1   .EQU    7
FDMODE_SCOTT2   .EQU    8
	
