 page 44,100
 TITLE  ASMXMPLE

Video equ 10h          ;video functions interrupt number
Keyboard equ 16h       ;keyboard functions interrupt number
DOS equ 21h            ;call DOS interrupt number
PrtSc equ 5h           ;Print Screen Bios interrupt
CRTstatus equ 03DAh
CRTmode equ 03D8h
CursOff equ 16134
portb equ 61h          ;I/O port B

STACK  Segment Para Stack 'Stack'
Stak db 64 dup ("stack   ")
STACK EndS

PARMSEG Segment Para 'data'
Asciiz db 63 dup (?)   ;Device ID, path and filespec,
Xasciiz db '$'         ; followed by at least one byte of
                       ; of binary zero.
Handle dw ?            ;Place to put 16 bit handle number
Bufseg dw ?            ;Segment address of buffer
Bufoff dw ?            ;Offset of buffer
Bufsiz dw ?            ;Max bytes to read/write
Actsiz dw ?            ;Actual bytes read
Dskerr dw ?            ;DOS error code, if error occurs
Parmseg EndS

DATASEG Segment Para 'data'
IObuffer db 4096 dup (?)  ;I/O buffer for reading screens
                          ;  from disk.
Pgmstat db 0           ;program status switch
Cover db 'ICOVER.SCN'
      db 0
FileSpec db 'INSTRC**.SCN'
         db 0
PageNbr db 0
NewPage db '  '
Ten db 10
EdgeTab db 7,7,3,0,0,0,0,0
        db 0,0,0,0,7,7,4,0
        db 6,6,3,0,3,6,6,6
        db 7,0,2,5,5,5,3,6
        db 6,6,6,3,6,6,6,6
        db 3,3,11,15,10,0,0,0
StartOff dw 0
Keycodes dw 0
Answer db 256 dup (?)
MaxChars dw 0
Attributes dw 0
Buzzit db 0
Dataseg EndS

ScreenSeg Segment at 0B800h ;location of color screen mem
Page0 db 4096 dup (?)
Page1 db 4096 dup (?)
Page2 db 4096 dup (?)
Page3 db 4096 dup (?)
ScreenSeg EndS

CODE Segment Para 'code'
 assume cs:CODE

MAIN Proc Far

 push ds
 mov ax,0
 push ax
 assume ds:dataseg
 mov ax,dataseg
 mov ds,ax
 mov dl,0              ;set starting page number to zero
 mov PageNbr,dl
 call ShowCover        ;Put instructions cover on screen
 cmp Pgmstat,0
 jne InstructX         ;some was wrong
PageMore:
 call PutScreen        ;Get instruction screen from disk
                       ; and display it.
 call NextNumber       ;get next page number, etc.
 cmp PageNbr,255
 jne PageMore
InstructX:
 mov ah,11             ;set color palette
 mov bh,0              ;set boarder color
 mov bl,0              ;black
 int video             ;call bios video routine
 mov ah,0              ;set mode function
 mov al,3              ;80 x 25 color
 int video             ;bios call to video rom routines
 mov ah,5              ;select active display page
 mov al,0              ;page 0
 int video             ;bios call
 mov ah,1
 mov ch,7
 mov cl,7
 ret                   ;return to dos
MAIN EndP

ShowCover Proc Near
 push ds
 push es
 call Cover1
 assume ds:dataseg
 cmp PageNbr,0
 jne CoverX
AnyKey:
 mov ah,0              ;read next key struck from keyboard
 int keyboard          ;call bios keyboard routine
CoverX:
 pop es
 pop ds
 ret
ShowCover EndP

Cover1 Proc Near
 push ds
 push es
 assume ds:dataseg
 assume es:parmseg
 mov ax,parmseg
 mov es,ax
 cmp PageNbr,0
 jne CoverOk
;Set disk parms, start by moving file spec to Asciiz.
 mov si,offset cover
 mov di,offset asciiz
 mov cx,64
 cld
 rep movsb
 mov es:bufseg,ds      ;set segment address of buffer
 mov ax,offset IObuffer ;set offset of buffer
 mov es:bufoff,ax
 mov ax,4008           ;set size of screen block
 mov es:bufsiz,ax
 call GetFile          ;get screen from disk
 cmp es:DskErr,0
 je CoverOK            ;read was OK
 mov al,1
 mov pgmstat,al
 jmp CoverX
Coverok:
 mov al,3              ;80 x 25 color
 mov ah,0              ;set mode
 int video             ;call bios video routine
 mov ah,5              ;select active display page
 mov al,3              ;active page 3
 int video             ;call bios video routine
 mov ah,11             ;set color palette
 mov bh,0              ;set boarder color
 mov bl,1              ;dark blue
 int video             ;call bios video routine
 mov ah,1              ;make cursor invisible
 mov ch,31
 mov cl,31
 int video
 cmp PageNbr,0
 jne Cover1X
 mov dx,CRTmode        ;turn off the display
 mov al,29h            ;mode byte for 80 column color
 and al,11110111b
 out dx,al
 assume es:screenseg
 mov ax,screenseg
 mov es,ax
 mov si,offset IObuffer+7 ;Move screen from I/O buffer to
 mov di,offset Page3      ; to actual screen memory.
 cld
 mov cx,2000
 rep movsw
 mov dx,CRTmode        ;turn display back on
 mov al,29h            ;80 x 25 color mode byte
 out dx,al
 call beep
Cover1X:
 pop es
 pop ds
 ret
Cover1 EndP

PutScreen Proc Near
 push ds
 push es
ReStart:
 assume ds:dataseg
 mov al,PageNbr        ;get instruction screen page number
 call ConvByte         ;convert to decimal display
 mov FileSpec+6,dh     ;and put it into the file spec
 mov FileSpec+7,dl
 assume es:parmseg
 mov ax,parmseg
 mov es,ax
;Set disk parms, start by moving file spec to Asciiz.
 mov si,offset FileSpec
 mov di,offset asciiz
 mov cx,64
 cld
 rep movsb
 mov es:bufseg,ds      ;set segment address of buffer
 mov ax,offset IObuffer ;set offset of buffer
 mov es:bufoff,ax
 mov ax,4008           ;set size of screen block
 mov es:bufsiz,ax
 call GetFile          ;get screen from disk
 cmp es:DskErr,0
 je ScreenOK           ;read was OK
 jmp NoPage            ;not a valid screen page number
ScreenOK:
 call SetEdge
 mov dx,CRTmode        ;turn off the display
 mov al,29h            ;mode byte for 80 column color
 and al,11110111b
 out dx,al
 assume es:screenseg
 mov ax,screenseg
 mov es,ax
 mov si,offset IObuffer+7 ;Move screen from I/O buffer to
 mov di,offset Page3    ; to actual screen memory.
 cld
 mov cx,2000
 rep movsw
 mov dx,CRTmode        ;turn display back on
 mov al,29h            ;80 x 25 color mode byte
 out dx,al
 call beep
 jmp PSexit
NoPage:
 call buzz
 call ClearAns
 mov al,0
 mov PageNbr,al
 jmp ReStart
PSexit:
 pop es
 pop ds
 ret
PutScreen EndP

NextNumber Proc Near
 push ds
 push es
WaitInput:
 mov si,CursOff        ;offset to cursor position on screen
 mov cx,2              ;max characters in answer
 mov dh,0BCh           ;cursor color atribute
 mov dl,031h           ;answer color atribute
 call Xanswer
 assume es:dataseg
 mov ax,dataseg
 mov es,ax
 cmp dh,1
 je PrevPage           ;go to previous page
 cmp dh,2
 je NextPage           ;go to next page
 cmp cx,0
 je PageZero           ;go to page 0
 cmp cx,01FFh
 je MainMenu           ;escape back to main menu
 push cx
 mov di,offset NewPage ;move answer to local work area
 cld
 mov cx,2
 rep movsb
 pop cx
 cmp cx,1
 jne TwoDigit
OneDigit:
 call ConvOne
 cmp ah,0
 jne BadNumber
 mov es:PageNbr,al
 jmp NNexit
TwoDigit:
 call ConvTwo
 cmp ah,0
 jne BadNumber
 mov es:PageNbr,al
 jmp NNexit
PrevPage:
 cmp es:PageNbr,0
 je BadNumber
 dec es:PageNbr
 jmp NNexit
Nextpage:
 inc es:PageNbr
 jmp NNexit
PageZero:
 mov al,0
 mov es:PageNbr,al
 jmp NNexit
MainMenu:
 mov al,255
 mov es:PageNbr,al
 jmp NNexit
BadNumber:
 call buzz
 call ClearAns
 jmp WaitInput
NNexit:
 pop es
 pop ds
 ret
NextNumber EndP

ConvOne Proc Near
 push ds
 push es
 assume ds:dataseg
 mov ax,dataseg
 mov ds,ax
 mov al,NewPage
 cmp al,30h
 jl NotNumber1
 cmp al,39h
 jg NotNumber1
 sub al,30h            ;convert to binary
 mov ah,0
 jmp COexit
NotNumber1:
 mov ah,1
COexit:
 pop es
 pop ds
 ret
ConvOne EndP

ConvTwo Proc Near
 push ds
 push es
 assume ds:dataseg
 mov ax,dataseg
 mov ds,ax
 mov al,NewPage
 cmp al,30h
 jl NotNumber2
 cmp al,39h
 jg NotNumber2
 sub al,30h            ;convert to binary
 mul Ten               ;multiply by 10
 mov dl,al             ;save in dl
 mov al,NewPage+1
 cmp al,30h
 jl NotNumber2
 cmp al,39h
 jg NotNumber2
 sub al,30h            ;convert to binary
 add al,dl             ;add 10's value
 mov ah,0
 jmp CTexit
NotNumber2:
 mov ah,1
CTexit:
 pop es
 pop ds
 ret
ConvTwo EndP

ClearAns Proc Near
 push ds
 push es
 assume ds:screenseg
 mov ax,screenseg
 mov ds,ax
 mov al,20h
 mov bx,CursOff
 mov [page0 + bx],al
 inc bx
 mov [page0 + bx],al
 inc bx
 mov [page0 + bx],al
 pop es
 pop ds
 ret
ClearAns EndP

SetEdge Proc Near
 push ds
 push es
 assume ds:dataseg
 mov ax,dataseg
 mov ds,ax
 mov bl,PageNbr
 mov bh,0
 mov ch,[EdgeTab + bx]
 mov ah,11
 mov bh,0
 mov bl,ch
 int video
 pop es
 pop ds
 ret
SetEdge EndP

;Subroutine to get a binary block of data from disk.
;It opens file, reads entire file (as one block of data)
;into memory, closes file.
;
;Enter with:
;  - Device, path, filespec and binary zero in Asciiz.
;  - Segment address of buffer in Bufseg.
;  - Offset of buffer in Bufoff.
;  - Max number of bytes to read, in Bufsiz.
;
;On exit:
;  - Handle will contain handle number.
;  - Actsiz will contain actual number of bytes read, or
;    zero if file was not found on disk.
;  - Dskerr will contain the DOS error code, or zero if
;    no error.

Getfile Proc Near
 push ds               ;save registers of calling routine
 push es
 push si
 push di
 push ax
 push bx
 push cx
 push dx
 assume ds:parmseg
 mov ax,parmseg        ;set DS to PARMSEG segment
 mov ds,ax             ; -which sets DS to Asciiz
 mov dx,offset asciiz  ; -set offset to Asciiz
 mov al,0              ;set AL to "open for reading"
 mov ah,3dh            ;set AH to "open a file" function
 int DOS               ;call DOS
 jc gfopenerr          ;error on open
 mov handle,ax         ;save handle
 mov bx,handle         ;load BX with file handle
 mov cx,bufsiz         ;load CX with # of bytes to read
 mov dx,bufoff         ;load DX with offset of buffer
 mov ax,bufseg         ;load DS with segment address
 mov ds,ax             ;  of buffer
 mov ah,3fh            ;"read from a file" function
 int DOS               ;call DOS
 push ax               ;save # of bytes read on stack
 mov ax,parmseg        ;restore DS to diskparms segment
 mov ds,ax             ;
 pop ax                ;get # of bytes read
 jc gfreaderr          ;error on read
 mov actsiz,ax         ;save # of bytes read, in diskparms
 mov bx,handle         ;load BX with file handle
 mov ah,3eh            ;"close a file handle" function
 int DOS               ;call DOS
 jc gfcloserr          ;error on close
 mov dskerr,0          ;set error code to zero (no error)
Gfback:
 pop dx                ;restore registers of calling
 pop cx                ; routine.
 pop bx
 pop ax
 pop di
 pop si
 pop es
 pop ds
 ret                   ;return to calling routine
;ERROR ON OPEN: Possible error returns are:
;  2 - File not found
;  4 - To many open files (no handles left)
;  5 - Access denied
; 12 - Invalid access code
Gfopenerr:
 mov ah,1              ;set AH to 1 for open error,
                       ;AL already contains error code
 mov dskerr,ax         ;put error code in diskparms
 jmp gfback
;ERROR ON READ: Possible error returns are:
;  5 - Access denied
;  6 - Invalid handle
Gfreaderr:
 mov ah,2              ;set AH to 2 for read error
 mov dskerr,ax         ;put error code in diskparms
 jmp gfback
;ERROR ON CLOSE: Possible error return is:
;  6 - Invalid handle
Gfcloserr:
 mov ah,3              ;set AH to 3 for close error
 mov dskerr,ax         ;put error code in diskparms
 jmp gfback
Getfile EndP

Beep Proc Near
 push ax               ;save registers of calling program
 push dx
 push cx
 push bx
 mov ax,0
 mov dx,12h
 mov cx,7d0h
 div cx
 mov bx,ax
 mov al,10110110b
 out 43h,al
 mov ax,bx
 out 42h,al
 mov al,ah
 out 42h,al
 in al,portb
 or al,3
 out portb,al
 mov cx,07fffh         ;set up counter for duration of beep
wait:
 loop wait
 in al,portb
 and al,11111100b
 out portb,al
 pop bx                ;restore registers of calling pgm
 pop cx
 pop dx
 pop ax
 ret
BEEP EndP

BUZZ Proc Near
 push ax               ;save registers of calling program
 mov ax,ds
 push ax
 push bx
 push cx
 push dx
 assume ds:dataseg
 mov ax,dataseg        ;set DS for this routine
 mov ds,ax
 mov buzzit,16         ;set buzz counter
Buzzone:
 mov ax,0
 mov dx,12h
 mov cx,900
 div cx
 mov bx,ax
 mov al,10110110b
 out 43h,al
 mov ax,bx
 out 42h,al
 mov al,ah
 out 42h,al
 in al,portb
 or al,3
 out portb,al
 mov cx,0affh
Buzz1:
 loop buzz1
 in al,portb
 and al,11111100b
 out portb,al
 mov cx,7ffh
Buzz2:
 loop buzz2
 dec buzzit
 jnz buzzone
 pop dx
 pop cx
 pop bx
 pop ax
 mov ds,ax
 pop ax
 ret
BUZZ EndP

;Enter with binary value in AL.
;On return, the result is in: (assume result is 234)
;     AH = 2, DH = 3, DL = 4
Convbyte Proc Near
 push ds
 push es
 mov ah,48
 mov dh,48
 mov dl,48
Test1:
 cmp al,100
 jl test2
 sub al,100
 inc ah
 jmp test1
Test2:
 cmp al,10
 jl test3
 sub al,10
 inc dh
 jmp test2
Test3:
 add dl,al
 pop es
 pop ds
 ret
Convbyte EndP

;Enter with:
;  SI = offset of cursor position in screen memory
;  CX = maximum number of characters in answer
;  DH = color atribute of cursor
;  DL = color atribute of answer
;On return:
;  The answer is on the screen, followed by the cursor.
;  The answer is also in a string pointed to by DS SI,
;  with CX set to the number of characters in the answer.
;  If Escape was pushed CX will = 01FFh.
;  DH will = 0, unless PgUp pushed then DH = 1
;                   or PgDn pushed then DH = 2.
Xanswer Proc Near
 push ds
 push es
 assume ds:screenseg
 mov ax,screenseg
 mov ds,ax
 assume es:dataseg
 mov ax,dataseg
 mov es,ax
 mov es:Attributes,dx  ;save color attributes
 mov es:StartOff,si    ;save beginning offset
 mov es:MaxChars,cx    ;save maximum number of characters
                       ; in answer.
 mov cx,256
 mov bx,0
 mov al,20h
ClearAnswer:
 mov [es:answer + bx],al
 inc bx
 loop ClearAnswer
 mov cx,0              ;initialize character counter
NextChar:
 call PutCursor        ;Put cursor on screen
 mov ah,0
 int keyboard          ;read next keyboard entry
 mov es:keycodes,ax    ;save codes
 cmp al,20h
 jl ChekEdit           ;not a printable character
 cmp al,7Eh
 jg ChekEdit           ;not a printable character
 cmp cx,es:MaxChars
 jge BadChar           ;already have max number of char's
 call PutChar          ;put character on screen
 inc si                ;bump offset to screen by 1 char'
 inc si                ; which is 2 bytes.
 mov bx,cx             ;move counter to pointer
 mov ax,es:keycodes    ;get character code
 mov [es:Answer + bx],al ;and put in answer string
 inc cx                ;bump character counter
 jmp NextChar
ChekEdit:
 cmp ax,0E08h          ;backspace
 je BackUp
 cmp ax,4B00h          ;left arrow
 je BackUp
 cmp ax,1C0Dh          ;return
 je Return
 cmp ax,011Bh          ;escape
 je Escape
 cmp ah,49h            ;PgUp
 je PageUp
 cmp ah,51h            ;PgDn
 je PageDown
BadChar:
 call buzz             ;invalid character or control
 jmp NextChar
BackUp:
 cmp cx,0
 jle BadChar           ;can't back up
 mov es:keycodes,02020h ;set keycodes to space
 call PutChar          ;blank out cursor on screen
 dec cx                ;decrement character counter
 dec si                ;decrement offset pointer
 dec si                ; (2 bytes per character)
 jmp NextChar          ;and start over
Escape:
 mov cx,01FFh
 mov dh,0
 jmp Return2
PageUp:
 mov dh,1
 jmp Return2
PageDown:
 mov dh,2
 jmp Return2
Return:
 mov dh,0
Return2:
 mov es:keycodes,02020h   ;set keycodes to space
 call PutChar          ;blank out cursor on screen
 assume ds:dataseg
 mov ax,dataseg
 mov ds,ax
 mov si,offset answer
 pop es
 pop ds
 ret
Xanswer EndP

PutCursor Proc Near
 assume ds:screenseg
 assume es:dataseg
 mov bx,es:attributes
 mov bl,219
 mov dx,CRTstatus
Wait1:
 in al,dx
 test al,1
 jnz Wait1
Wait2:
 in al,dx
 test al,1
 jz Wait2
 cli
 mov [Page0 + si],bl
 mov [Page0 + 1  + si],bh
 sti
 ret
PutCursor EndP

PutChar Proc Near
 push dx
 assume ds:screenseg
 assume es:dataseg
 mov bx,es:attributes
 mov bh,bl
 mov ax,es:keycodes
 mov bl,al
 mov dx,CRTstatus
WaitA:
 in al,dx
 test al,1
 jnz WaitA
WaitB:
 in al,dx
 test al,1
 jz WaitB
 cli
 mov [Page0 + si],bl
 mov [Page0 + 1  + si],bh
 sti
 pop dx
 ret
PutChar EndP

CODE EndS
END
