; --- FILENAME: ../solarium/usr/bin/wget
.include "lib/kernel.exp"
.include "lib/bios.exp"
.org text_org

; --- BEGIN TEXT BLOCK
main:
  mov bp, $FFE0 ;
  mov sp, $FFE0 ; Make space for argc(2 bytes) and for 10 pointers in argv (local variables)
; $status 
; $p 
  sub sp, 3
;; p = url; 
  lea d, [bp + -2] ; $p         
  mov b, _url_data ; $url                   
  mov [d], b
;; prog = 0; 
  mov d, _prog ; $prog         
  mov b, $0        
  mov [d], b
;; while(*prog && *prog != ' ') *p++ = *prog++; 
_while1_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
  push a
  mov a, b
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $20
  cmp a, b
  sneq ; !=
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  cmp b, 0
  je _while1_exit
_while1_block:
;; *p++ = *prog++; 
  mov b, [bp + -2] ; $p             
  mov g, b
  inc b
  lea d, [bp + -2] ; $p
  mov [d], b
  mov b, g
  push b
  mov b, [_prog] ; $prog           
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
  jmp _while1_cond
_while1_exit:
;; *p = '\0'; 
  mov b, [bp + -2] ; $p             
  push b
  mov b, $0
  pop d
  mov [d], bl
;; if(!*prog){ 
_if2_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
  cmp b, 0
  seq ; !
  cmp b, 0
  je _if2_exit
_if2_true:
;; printf("\nusage: hget <url> <filename>"); 
  mov b, __s0 ; "\nusage: hget <url> <filename>"
  swp b
  push b
  call printf
  add sp, 2
;; exit(); 
  call exit
  jmp _if2_exit
_if2_exit:
;; while(*prog == ' ') prog++; 
_while3_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $20
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _while3_exit
_while3_block:
;; prog++; 
  mov b, [_prog] ; $prog           
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  jmp _while3_cond
_while3_exit:
;; if(!*prog){ 
_if4_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
  cmp b, 0
  seq ; !
  cmp b, 0
  je _if4_exit
_if4_true:
;; printf("\nusage: hget <url> <filename>"); 
  mov b, __s0 ; "\nusage: hget <url> <filename>"
  swp b
  push b
  call printf
  add sp, 2
;; exit(); 
  call exit
  jmp _if4_exit
_if4_exit:
;; p = filename; 
  lea d, [bp + -2] ; $p         
  mov b, _filename_data ; $filename                   
  mov [d], b
;; while(*prog && *prog != ' ' && *prog != ';') *p++ = *prog++; 
_while5_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
  push a
  mov a, b
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $20
  cmp a, b
  sneq ; !=
  pop a
; END RELATIONAL
  sand a, b ; &&
  mov a, b
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $3b
  cmp a, b
  sneq ; !=
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  cmp b, 0
  je _while5_exit
_while5_block:
;; *p++ = *prog++; 
  mov b, [bp + -2] ; $p             
  mov g, b
  inc b
  lea d, [bp + -2] ; $p
  mov [d], b
  mov b, g
  push b
  mov b, [_prog] ; $prog           
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
  jmp _while5_cond
_while5_exit:
;; *p = '\0'; 
  mov b, [bp + -2] ; $p             
  push b
  mov b, $0
  pop d
  mov [d], bl
;; printf("Filename: "); printf(filename); printf("\n"); 
  mov b, __s1 ; "Filename: "
  swp b
  push b
  call printf
  add sp, 2
;; printf(filename); printf("\n"); 
  mov b, _filename_data ; $filename           
  swp b
  push b
  call printf
  add sp, 2
;; printf("\n"); 
  mov b, __s2 ; "\n"
  swp b
  push b
  call printf
  add sp, 2
;; printf("Url: "); printf(url); printf("\n"); 
  mov b, __s3 ; "Url: "
  swp b
  push b
  call printf
  add sp, 2
;; printf(url); printf("\n"); 
  mov b, _url_data ; $url           
  swp b
  push b
  call printf
  add sp, 2
;; printf("\n"); 
  mov b, __s2 ; "\n"
  swp b
  push b
  call printf
  add sp, 2
;; status = http(2, url); // Request ESP to download file 
  lea d, [bp + 0] ; $status
  push d
  mov b, $2
  push bl
  mov b, _url_data ; $url           
  swp b
  push b
  call http
  add sp, 3
  pop d
  mov [d], bl
;; if(status >= 100 && status <= 299){ 
_if6_cond:
  mov bl, [bp + 0] ; $status
  mov bh, 0             
; START RELATIONAL
  push a
  mov a, b
  mov b, $64
  cmp a, b
  sge ; >=
  pop a
; END RELATIONAL
  push a
  mov a, b
  mov bl, [bp + 0] ; $status
  mov bh, 0             
; START RELATIONAL
  push a
  mov a, b
  mov b, $12b
  cmp a, b
  sle ; <=
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  cmp b, 0
  je _if6_else
_if6_true:
;; printf("Now creating file...\n"); 
  mov b, __s4 ; "Now creating file...\n"
  swp b
  push b
  call printf
  add sp, 2
;; http(3, url); // Request ESP to send the file 
  mov b, $3
  push bl
  mov b, _url_data ; $url           
  swp b
  push b
  call http
  add sp, 3

; --- BEGIN INLINE ASM BLOCK
  mov d, _filename_data ; $filename
  mov al, 11
  syscall sys_filesystem
; --- END INLINE ASM BLOCK

;; printf("OK.\n"); 
  mov b, __s5 ; "OK.\n"
  swp b
  push b
  call printf
  add sp, 2
  jmp _if6_exit
_if6_else:
;; printf("Bad code, aborting...\n"); 
  mov b, __s6 ; "Bad code, aborting...\n"
  swp b
  push b
  call printf
  add sp, 2
_if6_exit:
  syscall sys_terminate_proc

include_ctype_lib:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM BLOCK
.include "lib/ctype.asm"
; --- END INLINE ASM BLOCK

  leave
  ret

is_space:
  enter 0 ; (push bp; mov bp, sp)
;; return c == ' ' || c == '\t' || c == '\n' || c == '\r'; 
  mov bl, [bp + 5] ; $c
  mov bh, 0             
; START RELATIONAL
  push a
  mov a, b
  mov b, $20
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  push a
  mov a, b
  mov bl, [bp + 5] ; $c
  mov bh, 0             
; START RELATIONAL
  push a
  mov a, b
  mov b, $9
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  mov bl, [bp + 5] ; $c
  mov bh, 0             
; START RELATIONAL
  push a
  mov a, b
  mov b, $a
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  mov bl, [bp + 5] ; $c
  mov bh, 0             
; START RELATIONAL
  push a
  mov a, b
  mov b, $d
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  pop a
  leave
  ret

is_digit:
  enter 0 ; (push bp; mov bp, sp)
;; return c >= '0' && c <= '9'; 
  mov bl, [bp + 5] ; $c
  mov bh, 0             
; START RELATIONAL
  push a
  mov a, b
  mov b, $30
  cmp a, b
  sge ; >=
  pop a
; END RELATIONAL
  push a
  mov a, b
  mov bl, [bp + 5] ; $c
  mov bh, 0             
; START RELATIONAL
  push a
  mov a, b
  mov b, $39
  cmp a, b
  sle ; <=
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  leave
  ret

is_alpha:
  enter 0 ; (push bp; mov bp, sp)
;; return(c >= 'a' && c <= 'z' || c >= 'A' && c <= 'Z' || c == '_'); 
  mov bl, [bp + 5] ; $c
  mov bh, 0             
; START RELATIONAL
  push a
  mov a, b
  mov b, $61
  cmp a, b
  sge ; >=
  pop a
; END RELATIONAL
  push a
  mov a, b
  mov bl, [bp + 5] ; $c
  mov bh, 0             
; START RELATIONAL
  push a
  mov a, b
  mov b, $7a
  cmp a, b
  sle ; <=
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  push a
  mov a, b
  mov bl, [bp + 5] ; $c
  mov bh, 0             
; START RELATIONAL
  push a
  mov a, b
  mov b, $41
  cmp a, b
  sge ; >=
  pop a
; END RELATIONAL
  push a
  mov a, b
  mov bl, [bp + 5] ; $c
  mov bh, 0             
; START RELATIONAL
  push a
  mov a, b
  mov b, $5a
  cmp a, b
  sle ; <=
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  sor a, b ; ||
  mov a, b
  mov bl, [bp + 5] ; $c
  mov bh, 0             
; START RELATIONAL
  push a
  mov a, b
  mov b, $5f
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  pop a
  leave
  ret

is_delimiter:
  enter 0 ; (push bp; mov bp, sp)
;; if( 
_if7_cond:
  mov bl, [bp + 5] ; $c
  mov bh, 0             
; START RELATIONAL
  push a
  mov a, b
  mov b, $40
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  push a
  mov a, b
  mov bl, [bp + 5] ; $c
  mov bh, 0             
; START RELATIONAL
  push a
  mov a, b
  mov b, $23
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  mov bl, [bp + 5] ; $c
  mov bh, 0             
; START RELATIONAL
  push a
  mov a, b
  mov b, $24
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  mov bl, [bp + 5] ; $c
  mov bh, 0             
; START RELATIONAL
  push a
  mov a, b
  mov b, $2b
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  mov bl, [bp + 5] ; $c
  mov bh, 0             
; START RELATIONAL
  push a
  mov a, b
  mov b, $2d
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  mov bl, [bp + 5] ; $c
  mov bh, 0             
; START RELATIONAL
  push a
  mov a, b
  mov b, $2a
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  mov bl, [bp + 5] ; $c
  mov bh, 0             
; START RELATIONAL
  push a
  mov a, b
  mov b, $2f
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  mov bl, [bp + 5] ; $c
  mov bh, 0             
; START RELATIONAL
  push a
  mov a, b
  mov b, $25
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  mov bl, [bp + 5] ; $c
  mov bh, 0             
; START RELATIONAL
  push a
  mov a, b
  mov b, $5b
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  mov bl, [bp + 5] ; $c
  mov bh, 0             
; START RELATIONAL
  push a
  mov a, b
  mov b, $5d
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  mov bl, [bp + 5] ; $c
  mov bh, 0             
; START RELATIONAL
  push a
  mov a, b
  mov b, $28
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  mov bl, [bp + 5] ; $c
  mov bh, 0             
; START RELATIONAL
  push a
  mov a, b
  mov b, $29
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  mov bl, [bp + 5] ; $c
  mov bh, 0             
; START RELATIONAL
  push a
  mov a, b
  mov b, $7b
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  mov bl, [bp + 5] ; $c
  mov bh, 0             
; START RELATIONAL
  push a
  mov a, b
  mov b, $7d
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  mov bl, [bp + 5] ; $c
  mov bh, 0             
; START RELATIONAL
  push a
  mov a, b
  mov b, $3a
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  mov bl, [bp + 5] ; $c
  mov bh, 0             
; START RELATIONAL
  push a
  mov a, b
  mov b, $3b
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  mov bl, [bp + 5] ; $c
  mov bh, 0             
; START RELATIONAL
  push a
  mov a, b
  mov b, $3c
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  mov bl, [bp + 5] ; $c
  mov bh, 0             
; START RELATIONAL
  push a
  mov a, b
  mov b, $3e
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  mov bl, [bp + 5] ; $c
  mov bh, 0             
; START RELATIONAL
  push a
  mov a, b
  mov b, $3d
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  mov bl, [bp + 5] ; $c
  mov bh, 0             
; START RELATIONAL
  push a
  mov a, b
  mov b, $21
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  mov bl, [bp + 5] ; $c
  mov bh, 0             
; START RELATIONAL
  push a
  mov a, b
  mov b, $5e
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  mov bl, [bp + 5] ; $c
  mov bh, 0             
; START RELATIONAL
  push a
  mov a, b
  mov b, $26
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  mov bl, [bp + 5] ; $c
  mov bh, 0             
; START RELATIONAL
  push a
  mov a, b
  mov b, $7c
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  mov bl, [bp + 5] ; $c
  mov bh, 0             
; START RELATIONAL
  push a
  mov a, b
  mov b, $7e
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  mov bl, [bp + 5] ; $c
  mov bh, 0             
; START RELATIONAL
  push a
  mov a, b
  mov b, $2e
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  pop a
  cmp b, 0
  je _if7_else
_if7_true:
;; return 1; 
  mov b, $1
  leave
  ret
  jmp _if7_exit
_if7_else:
;; return 0; 
  mov b, $0
  leave
  ret
_if7_exit:
  leave
  ret

strcpy:
  enter 0 ; (push bp; mov bp, sp)
; $psrc 
; $pdest 
  sub sp, 4
;; psrc = src; 
  lea d, [bp + -1] ; $psrc         
  mov b, [bp + 5] ; $src                     
  mov [d], b
;; pdest = dest; 
  lea d, [bp + -3] ; $pdest         
  mov b, [bp + 7] ; $dest                     
  mov [d], b
;; while(*psrc) *pdest++ = *psrc++; 
_while8_cond:
  mov b, [bp + -1] ; $psrc             
  mov d, b
  mov bl, [d]
  mov bh, 0
  cmp b, 0
  je _while8_exit
_while8_block:
;; *pdest++ = *psrc++; 
  mov b, [bp + -3] ; $pdest             
  mov g, b
  inc b
  lea d, [bp + -3] ; $pdest
  mov [d], b
  mov b, g
  push b
  mov b, [bp + -1] ; $psrc             
  mov g, b
  inc b
  lea d, [bp + -1] ; $psrc
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
  jmp _while8_cond
_while8_exit:
;; *pdest = '\0'; 
  mov b, [bp + -3] ; $pdest             
  push b
  mov b, $0
  pop d
  mov [d], bl
  leave
  ret

strcmp:
  enter 0 ; (push bp; mov bp, sp)
;; while (*s1 && (*s1 == *s2)) { 
_while9_cond:
  mov b, [bp + 7] ; $s1             
  mov d, b
  mov bl, [d]
  mov bh, 0
  push a
  mov a, b
  mov b, [bp + 7] ; $s1             
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, [bp + 5] ; $s2             
  mov d, b
  mov bl, [d]
  mov bh, 0
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  cmp b, 0
  je _while9_exit
_while9_block:
;; s1++; 
  mov b, [bp + 7] ; $s1             
  mov g, b
  inc b
  lea d, [bp + 7] ; $s1
  mov [d], b
  mov b, g
;; s2++; 
  mov b, [bp + 5] ; $s2             
  mov g, b
  inc b
  lea d, [bp + 5] ; $s2
  mov [d], b
  mov b, g
  jmp _while9_cond
_while9_exit:
;; return *s1 - *s2; 
  mov b, [bp + 7] ; $s1             
  mov d, b
  mov bl, [d]
  mov bh, 0
; START TERMS
  push a
  mov a, b
  mov b, [bp + 5] ; $s2             
  mov d, b
  mov bl, [d]
  mov bh, 0
  sub a, b
  mov b, a
  pop a
; END TERMS
  leave
  ret

strcat:
  enter 0 ; (push bp; mov bp, sp)
; $dest_len 
; $i 
  sub sp, 4
;; dest_len = strlen(dest); 
  lea d, [bp + -1] ; $dest_len
  push d
  mov b, [bp + 7] ; $dest             
  swp b
  push b
  call strlen
  add sp, 2
  pop d
  mov [d], b
;; for (i = 0; src[i] != 0; i=i+1) { 
_for10_init:
  lea d, [bp + -3] ; $i         
  mov b, $0        
  mov [d], b
_for10_cond:
  lea d, [bp + 5] ; $src
  mov d, [d]
  push a         
  mov b, [bp + -3] ; $i                     
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  sneq ; !=
  pop a
; END RELATIONAL
  cmp b, 0
  je _for10_exit
_for10_block:
;; dest[dest_len + i] = src[i]; 
  lea d, [bp + 7] ; $dest
  mov d, [d]
  push a         
  mov b, [bp + -1] ; $dest_len             
; START TERMS
  push a
  mov a, b
  mov b, [bp + -3] ; $i             
  add a, b
  mov b, a
  pop a
; END TERMS        
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  push d
  lea d, [bp + 5] ; $src
  mov d, [d]
  push a         
  mov b, [bp + -3] ; $i                     
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
_for10_update:
  lea d, [bp + -3] ; $i         
  mov b, [bp + -3] ; $i             
; START TERMS
  push a
  mov a, b
  mov b, $1
  add a, b
  mov b, a
  pop a
; END TERMS        
  mov [d], b
  jmp _for10_cond
_for10_exit:
;; dest[dest_len + i] = 0; 
  lea d, [bp + 7] ; $dest
  mov d, [d]
  push a         
  mov b, [bp + -1] ; $dest_len             
; START TERMS
  push a
  mov a, b
  mov b, [bp + -3] ; $i             
  add a, b
  mov b, a
  pop a
; END TERMS        
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a         
  mov b, $0        
  mov [d], bl
;; return dest; 
  mov b, [bp + 7] ; $dest             
  leave
  ret

strlen:
  enter 0 ; (push bp; mov bp, sp)
; $length 
  sub sp, 2
;; length = 0; 
  lea d, [bp + -1] ; $length         
  mov b, $0        
  mov [d], b
;; while (str[length] != 0) { 
_while11_cond:
  lea d, [bp + 5] ; $str
  mov d, [d]
  push a         
  mov b, [bp + -1] ; $length                     
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  sneq ; !=
  pop a
; END RELATIONAL
  cmp b, 0
  je _while11_exit
_while11_block:
;; length++; 
  mov b, [bp + -1] ; $length             
  mov g, b
  inc b
  lea d, [bp + -1] ; $length
  mov [d], b
  mov b, g
  jmp _while11_cond
_while11_exit:
;; return length; 
  mov b, [bp + -1] ; $length             
  leave
  ret

va_arg:
  enter 0 ; (push bp; mov bp, sp)
; $val 
  sub sp, 2
;; if(size == 1){ 
_if12_cond:
  mov b, [bp + 5] ; $size             
; START RELATIONAL
  push a
  mov a, b
  mov b, $1
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if12_else
_if12_true:
;; val = *(char*)arg->p; 
  lea d, [bp + -1] ; $val
  push d
  lea d, [bp + 7] ; $arg
  mov d, [d]
  add d, 0
  clb
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], b
  jmp _if12_exit
_if12_else:
;; if(size == 2){ 
_if13_cond:
  mov b, [bp + 5] ; $size             
; START RELATIONAL
  push a
  mov a, b
  mov b, $2
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if13_else
_if13_true:
;; val = *(int*)arg->p; 
  lea d, [bp + -1] ; $val
  push d
  lea d, [bp + 7] ; $arg
  mov d, [d]
  add d, 0
  clb
  mov b, [d]
  mov d, b
  mov b, [d]
  pop d
  mov [d], b
  jmp _if13_exit
_if13_else:
;; print("Unknown type size in va_arg() call. Size needs to be either 1 or 2."); 
  mov b, __s7 ; "Unknown type size in va_arg() call. Size needs to be either 1 or 2."
  swp b
  push b
  call print
  add sp, 2
_if13_exit:
_if12_exit:
;; arg->p = arg->p + size; 
  lea d, [bp + 7] ; $arg
  mov d, [d]
  add d, 0
  clb
  push d
  lea d, [bp + 7] ; $arg
  mov d, [d]
  add d, 0
  clb
  mov b, [d]
; START TERMS
  push a
  mov a, b
  mov b, [bp + 5] ; $size             
  add a, b
  mov b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; return val; 
  mov b, [bp + -1] ; $val             
  leave
  ret

printf:
  enter 0 ; (push bp; mov bp, sp)
; $p 
; $fp 
; $i 
  sub sp, 6
;; fp = format; 
  lea d, [bp + -3] ; $fp         
  mov b, [bp + 5] ; $format                     
  mov [d], b
;; p = &format; 
  lea d, [bp + -1] ; $p
  push d
  lea d, [bp + 5] ; $format
  mov b, d
  pop d
  mov [d], b
;; for(;;){ 
_for14_init:
_for14_cond:
_for14_block:
;; if(!*fp) break; 
_if15_cond:
  mov b, [bp + -3] ; $fp             
  mov d, b
  mov bl, [d]
  mov bh, 0
  cmp b, 0
  seq ; !
  cmp b, 0
  je _if15_exit
_if15_true:
;; break; 
  jmp _for14_exit ; for break
  jmp _if15_exit
_if15_exit:
;; if(*fp == '%'){ 
_if16_cond:
  mov b, [bp + -3] ; $fp             
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $25
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if16_else
_if16_true:
;; fp++; 
  mov b, [bp + -3] ; $fp             
  mov g, b
  inc b
  lea d, [bp + -3] ; $fp
  mov [d], b
  mov b, g
;; switch(*fp){ 
_switch17_expr:
  mov b, [bp + -3] ; $fp             
  mov d, b
  mov bl, [d]
  mov bh, 0
_switch17_comparisons:
  cmp bl, $64
  je _switch17_case0
  cmp bl, $69
  je _switch17_case1
  cmp bl, $75
  je _switch17_case2
  cmp bl, $78
  je _switch17_case3
  cmp bl, $63
  je _switch17_case4
  cmp bl, $73
  je _switch17_case5
  jmp _switch17_default
  jmp _switch17_exit
_switch17_case0:
_switch17_case1:
;; p = p - 2; 
  lea d, [bp + -1] ; $p         
  mov b, [bp + -1] ; $p             
; START TERMS
  push a
  mov a, b
  mov b, $2
  sub a, b
  mov b, a
  pop a
; END TERMS        
  mov [d], b
;; prints(*(int*)p); 
  mov b, [bp + -1] ; $p             
  mov d, b
  mov b, [d]
  swp b
  push b
  call prints
  add sp, 2
;; break; 
  jmp _switch17_exit ; case break
_switch17_case2:
;; p = p - 2; 
  lea d, [bp + -1] ; $p         
  mov b, [bp + -1] ; $p             
; START TERMS
  push a
  mov a, b
  mov b, $2
  sub a, b
  mov b, a
  pop a
; END TERMS        
  mov [d], b
;; printu(*(unsigned int*)p); 
  mov b, [bp + -1] ; $p             
  mov d, b
  mov b, [d]
  swp b
  push b
  call printu
  add sp, 2
;; break; 
  jmp _switch17_exit ; case break
_switch17_case3:
;; p = p - 2; 
  lea d, [bp + -1] ; $p         
  mov b, [bp + -1] ; $p             
; START TERMS
  push a
  mov a, b
  mov b, $2
  sub a, b
  mov b, a
  pop a
; END TERMS        
  mov [d], b
;; printx16(*(unsigned int*)p); 
  mov b, [bp + -1] ; $p             
  mov d, b
  mov b, [d]
  swp b
  push b
  call printx16
  add sp, 2
;; break; 
  jmp _switch17_exit ; case break
_switch17_case4:
;; p = p - 2; 
  lea d, [bp + -1] ; $p         
  mov b, [bp + -1] ; $p             
; START TERMS
  push a
  mov a, b
  mov b, $2
  sub a, b
  mov b, a
  pop a
; END TERMS        
  mov [d], b
;; putchar(*(char*)p); 
  mov b, [bp + -1] ; $p             
  mov d, b
  mov bl, [d]
  mov bh, 0
  push bl
  call putchar
  add sp, 1
;; break; 
  jmp _switch17_exit ; case break
_switch17_case5:
;; p = p - 2; 
  lea d, [bp + -1] ; $p         
  mov b, [bp + -1] ; $p             
; START TERMS
  push a
  mov a, b
  mov b, $2
  sub a, b
  mov b, a
  pop a
; END TERMS        
  mov [d], b
;; print(*(char**)p); 
  mov b, [bp + -1] ; $p             
  mov d, b
  mov b, [d]
  swp b
  push b
  call print
  add sp, 2
;; break; 
  jmp _switch17_exit ; case break
_switch17_default:
;; print("Error: Unknown argument type.\n"); 
  mov b, __s8 ; "Error: Unknown argument type.\n"
  swp b
  push b
  call print
  add sp, 2
_switch17_exit:
;; fp++; 
  mov b, [bp + -3] ; $fp             
  mov g, b
  inc b
  lea d, [bp + -3] ; $fp
  mov [d], b
  mov b, g
  jmp _if16_exit
_if16_else:
;; putchar(*fp); 
  mov b, [bp + -3] ; $fp             
  mov d, b
  mov bl, [d]
  mov bh, 0
  push bl
  call putchar
  add sp, 1
;; fp++; 
  mov b, [bp + -3] ; $fp             
  mov g, b
  inc b
  lea d, [bp + -3] ; $fp
  mov [d], b
  mov b, g
_if16_exit:
_for14_update:
  jmp _for14_cond
_for14_exit:
  leave
  ret

printx16:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM BLOCK
  mov b, [bp + 5] ; $hex             
  call print_u16x
; --- END INLINE ASM BLOCK

  leave
  ret

printx8:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM BLOCK
  lea d, [bp + 5] ; $hex
  mov bl, [d]
  call print_u8x
; --- END INLINE ASM BLOCK

  leave
  ret

hex_to_int:
  enter 0 ; (push bp; mov bp, sp)
; $value 
  mov a, $0
  mov [bp + -1], a
; $i 
; $hex_char 
; $len 
  sub sp, 7
;; len = strlen(hex_string); 
  lea d, [bp + -6] ; $len
  push d
  mov b, [bp + 5] ; $hex_string             
  swp b
  push b
  call strlen
  add sp, 2
  pop d
  mov [d], b
;; for (i = 0; i < len; i++) { 
_for18_init:
  lea d, [bp + -3] ; $i         
  mov b, $0        
  mov [d], b
_for18_cond:
  mov b, [bp + -3] ; $i             
; START RELATIONAL
  push a
  mov a, b
  mov b, [bp + -6] ; $len             
  cmp a, b
  slt ; < 
  pop a
; END RELATIONAL
  cmp b, 0
  je _for18_exit
_for18_block:
;; hex_char = hex_string[i]; 
  lea d, [bp + -4] ; $hex_char
  push d
  lea d, [bp + 5] ; $hex_string
  mov d, [d]
  push a         
  mov b, [bp + -3] ; $i                     
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; if (hex_char >= 'a' && hex_char <= 'f')  
_if19_cond:
  mov bl, [bp + -4] ; $hex_char
  mov bh, 0             
; START RELATIONAL
  push a
  mov a, b
  mov b, $61
  cmp a, b
  sge ; >=
  pop a
; END RELATIONAL
  push a
  mov a, b
  mov bl, [bp + -4] ; $hex_char
  mov bh, 0             
; START RELATIONAL
  push a
  mov a, b
  mov b, $66
  cmp a, b
  sle ; <=
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  cmp b, 0
  je _if19_else
_if19_true:
;; value = (value * 16) + (hex_char - 'a' + 10); 
  lea d, [bp + -1] ; $value         
  mov b, [bp + -1] ; $value             
; START FACTORS
  push a
  mov a, b
  mov b, $10
  mul a, b ; *
  mov a, b
  mov b, a
  pop a
; END FACTORS
; START TERMS
  push a
  mov a, b
  mov bl, [bp + -4] ; $hex_char
  mov bh, 0             
; START TERMS
  push a
  mov a, b
  mov b, $61
  sub a, b
  mov b, $a
  add a, b
  mov b, a
  pop a
; END TERMS
  add a, b
  mov b, a
  pop a
; END TERMS        
  mov [d], b
  jmp _if19_exit
_if19_else:
;; if (hex_char >= 'A' && hex_char <= 'F')  
_if20_cond:
  mov bl, [bp + -4] ; $hex_char
  mov bh, 0             
; START RELATIONAL
  push a
  mov a, b
  mov b, $41
  cmp a, b
  sge ; >=
  pop a
; END RELATIONAL
  push a
  mov a, b
  mov bl, [bp + -4] ; $hex_char
  mov bh, 0             
; START RELATIONAL
  push a
  mov a, b
  mov b, $46
  cmp a, b
  sle ; <=
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  cmp b, 0
  je _if20_else
_if20_true:
;; value = (value * 16) + (hex_char - 'A' + 10); 
  lea d, [bp + -1] ; $value         
  mov b, [bp + -1] ; $value             
; START FACTORS
  push a
  mov a, b
  mov b, $10
  mul a, b ; *
  mov a, b
  mov b, a
  pop a
; END FACTORS
; START TERMS
  push a
  mov a, b
  mov bl, [bp + -4] ; $hex_char
  mov bh, 0             
; START TERMS
  push a
  mov a, b
  mov b, $41
  sub a, b
  mov b, $a
  add a, b
  mov b, a
  pop a
; END TERMS
  add a, b
  mov b, a
  pop a
; END TERMS        
  mov [d], b
  jmp _if20_exit
_if20_else:
;; value = (value * 16) + (hex_char - '0'); 
  lea d, [bp + -1] ; $value         
  mov b, [bp + -1] ; $value             
; START FACTORS
  push a
  mov a, b
  mov b, $10
  mul a, b ; *
  mov a, b
  mov b, a
  pop a
; END FACTORS
; START TERMS
  push a
  mov a, b
  mov bl, [bp + -4] ; $hex_char
  mov bh, 0             
; START TERMS
  push a
  mov a, b
  mov b, $30
  sub a, b
  mov b, a
  pop a
; END TERMS
  add a, b
  mov b, a
  pop a
; END TERMS        
  mov [d], b
_if20_exit:
_if19_exit:
_for18_update:
  mov b, [bp + -3] ; $i             
  mov g, b
  inc b
  lea d, [bp + -3] ; $i
  mov [d], b
  mov b, g
  jmp _for18_cond
_for18_exit:
;; return value; 
  mov b, [bp + -1] ; $value             
  leave
  ret

atoi:
  enter 0 ; (push bp; mov bp, sp)
; $result 
  mov a, $0
  mov [bp + -1], a
; $sign 
  mov a, $1
  mov [bp + -3], a
  sub sp, 4
;; while (*str == ' ') str++; 
_while21_cond:
  mov b, [bp + 5] ; $str             
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $20
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _while21_exit
_while21_block:
;; str++; 
  mov b, [bp + 5] ; $str             
  mov g, b
  inc b
  lea d, [bp + 5] ; $str
  mov [d], b
  mov b, g
  jmp _while21_cond
_while21_exit:
;; if (*str == '-' || *str == '+') { 
_if22_cond:
  mov b, [bp + 5] ; $str             
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $2d
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  push a
  mov a, b
  mov b, [bp + 5] ; $str             
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $2b
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  pop a
  cmp b, 0
  je _if22_exit
_if22_true:
;; if (*str == '-') sign = -1; 
_if23_cond:
  mov b, [bp + 5] ; $str             
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $2d
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if23_exit
_if23_true:
;; sign = -1; 
  lea d, [bp + -3] ; $sign         
  mov b, $1
  neg b        
  mov [d], b
  jmp _if23_exit
_if23_exit:
;; str++; 
  mov b, [bp + 5] ; $str             
  mov g, b
  inc b
  lea d, [bp + 5] ; $str
  mov [d], b
  mov b, g
  jmp _if22_exit
_if22_exit:
;; while (*str >= '0' && *str <= '9') { 
_while24_cond:
  mov b, [bp + 5] ; $str             
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $30
  cmp a, b
  sge ; >=
  pop a
; END RELATIONAL
  push a
  mov a, b
  mov b, [bp + 5] ; $str             
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $39
  cmp a, b
  sle ; <=
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  cmp b, 0
  je _while24_exit
_while24_block:
;; result = result * 10 + (*str - '0'); 
  lea d, [bp + -1] ; $result
  push d
  mov b, [bp + -1] ; $result             
; START FACTORS
  push a
  mov a, b
  mov b, $a
  mul a, b ; *
  mov a, b
  mov b, a
  pop a
; END FACTORS
; START TERMS
  push a
  mov a, b
  mov b, [bp + 5] ; $str             
  mov d, b
  mov bl, [d]
  mov bh, 0
; START TERMS
  push a
  mov a, b
  mov b, $30
  sub a, b
  mov b, a
  pop a
; END TERMS
  add a, b
  mov b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; str++; 
  mov b, [bp + 5] ; $str             
  mov g, b
  inc b
  lea d, [bp + 5] ; $str
  mov [d], b
  mov b, g
  jmp _while24_cond
_while24_exit:
;; return sign * result; 
  mov b, [bp + -3] ; $sign             
; START FACTORS
  push a
  mov a, b
  mov b, [bp + -1] ; $result             
  mul a, b ; *
  mov a, b
  mov b, a
  pop a
; END FACTORS
  leave
  ret

gets:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM BLOCK
  mov a, [bp + 5] ; $s             
  mov d, a
  call _gets
; --- END INLINE ASM BLOCK

;; return strlen(s); 
  mov b, [bp + 5] ; $s             
  swp b
  push b
  call strlen
  add sp, 2
  leave
  ret

prints:
  enter 0 ; (push bp; mov bp, sp)
; $digits 
; $i 
  mov a, $0
  mov [bp + -6], a
  sub sp, 7
;; if (num < 0) { 
_if25_cond:
  mov b, [bp + 5] ; $num             
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  slt ; < 
  pop a
; END RELATIONAL
  cmp b, 0
  je _if25_else
_if25_true:
;; putchar('-'); 
  mov b, $2d
  push bl
  call putchar
  add sp, 1
;; num = -num; 
  lea d, [bp + 5] ; $num         
  mov b, [bp + 5] ; $num             
  neg b        
  mov [d], b
  jmp _if25_exit
_if25_else:
;; if (num == 0) { 
_if26_cond:
  mov b, [bp + 5] ; $num             
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if26_exit
_if26_true:
;; putchar('0'); 
  mov b, $30
  push bl
  call putchar
  add sp, 1
;; return; 
  leave
  ret
  jmp _if26_exit
_if26_exit:
_if25_exit:
;; while (num > 0) { 
_while27_cond:
  mov b, [bp + 5] ; $num             
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  sgt ; >
  pop a
; END RELATIONAL
  cmp b, 0
  je _while27_exit
_while27_block:
;; digits[i] = '0' + (num % 10); 
  lea d, [bp + -4] ; $digits
  push a         
  mov b, [bp + -6] ; $i                     
  add d, b
  pop a         
  mov b, $30
; START TERMS
  push a
  mov a, b
  mov b, [bp + 5] ; $num             
; START FACTORS
  push a
  mov a, b
  mov b, $a
  div a, b ; 
  mov a, b
  mov b, a
  pop a
; END FACTORS
  add a, b
  mov b, a
  pop a
; END TERMS        
  mov [d], bl
;; num = num / 10; 
  lea d, [bp + 5] ; $num         
  mov b, [bp + 5] ; $num             
; START FACTORS
  push a
  mov a, b
  mov b, $a
  div a, b
  mov b, a
  pop a
; END FACTORS        
  mov [d], b
;; i++; 
  mov b, [bp + -6] ; $i             
  mov g, b
  inc b
  lea d, [bp + -6] ; $i
  mov [d], b
  mov b, g
  jmp _while27_cond
_while27_exit:
;; while (i > 0) { 
_while28_cond:
  mov b, [bp + -6] ; $i             
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  sgt ; >
  pop a
; END RELATIONAL
  cmp b, 0
  je _while28_exit
_while28_block:
;; i--; 
  mov b, [bp + -6] ; $i             
  mov g, b
  dec b
  lea d, [bp + -6] ; $i
  mov [d], b
  mov b, g
;; putchar(digits[i]); 
  lea d, [bp + -4] ; $digits
  push a         
  mov b, [bp + -6] ; $i                     
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  push bl
  call putchar
  add sp, 1
  jmp _while28_cond
_while28_exit:
  leave
  ret

printu:
  enter 0 ; (push bp; mov bp, sp)
; $digits 
; $i 
  sub sp, 7
;; i = 0; 
  lea d, [bp + -6] ; $i         
  mov b, $0        
  mov [d], b
;; if(num == 0){ 
_if29_cond:
  mov b, [bp + 5] ; $num             
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if29_exit
_if29_true:
;; putchar('0'); 
  mov b, $30
  push bl
  call putchar
  add sp, 1
;; return; 
  leave
  ret
  jmp _if29_exit
_if29_exit:
;; while (num > 0) { 
_while30_cond:
  mov b, [bp + 5] ; $num             
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  sgu ; > (unsigned)
  pop a
; END RELATIONAL
  cmp b, 0
  je _while30_exit
_while30_block:
;; digits[i] = '0' + (num % 10); 
  lea d, [bp + -4] ; $digits
  push a         
  mov b, [bp + -6] ; $i                     
  add d, b
  pop a         
  mov b, $30
; START TERMS
  push a
  mov a, b
  mov b, [bp + 5] ; $num             
; START FACTORS
  push a
  mov a, b
  mov b, $a
  div a, b ; 
  mov a, b
  mov b, a
  pop a
; END FACTORS
  add a, b
  mov b, a
  pop a
; END TERMS        
  mov [d], bl
;; num = num / 10; 
  lea d, [bp + 5] ; $num         
  mov b, [bp + 5] ; $num             
; START FACTORS
  push a
  mov a, b
  mov b, $a
  div a, b
  mov b, a
  pop a
; END FACTORS        
  mov [d], b
;; i++; 
  mov b, [bp + -6] ; $i             
  mov g, b
  inc b
  lea d, [bp + -6] ; $i
  mov [d], b
  mov b, g
  jmp _while30_cond
_while30_exit:
;; while (i > 0) { 
_while31_cond:
  mov b, [bp + -6] ; $i             
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  sgt ; >
  pop a
; END RELATIONAL
  cmp b, 0
  je _while31_exit
_while31_block:
;; i--; 
  mov b, [bp + -6] ; $i             
  mov g, b
  dec b
  lea d, [bp + -6] ; $i
  mov [d], b
  mov b, g
;; putchar(digits[i]); 
  lea d, [bp + -4] ; $digits
  push a         
  mov b, [bp + -6] ; $i                     
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  push bl
  call putchar
  add sp, 1
  jmp _while31_cond
_while31_exit:
  leave
  ret

rand:
  enter 0 ; (push bp; mov bp, sp)
; $sec 
  sub sp, 1

; --- BEGIN INLINE ASM BLOCK
  mov al, 0
  syscall sys_rtc					
  mov al, ah
  mov al, [bp + 0] ; $sec
            
; --- END INLINE ASM BLOCK

;; return sec; 
  mov bl, [bp + 0] ; $sec
  mov bh, 0             
  leave
  ret

date:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM BLOCK
  mov al, 0 
  syscall sys_datetime
; --- END INLINE ASM BLOCK

  leave
  ret

putchar:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM BLOCK
  mov al, [bp + 5] ; $c
            
  mov ah, al
  call _putchar
; --- END INLINE ASM BLOCK

  leave
  ret

getchar:
  enter 0 ; (push bp; mov bp, sp)
; $c 
  sub sp, 1

; --- BEGIN INLINE ASM BLOCK
  call getch
  mov al, ah
  lea d, [bp + 0] ; $c
  mov [d], al
; --- END INLINE ASM BLOCK

;; return c; 
  mov bl, [bp + 0] ; $c
  mov bh, 0             
  leave
  ret

scann:
  enter 0 ; (push bp; mov bp, sp)
; $m 
  sub sp, 2

; --- BEGIN INLINE ASM BLOCK
  call scan_u16d
  lea d, [bp + -1] ; $m
  mov [d], a
; --- END INLINE ASM BLOCK

;; return m; 
  mov b, [bp + -1] ; $m             
  leave
  ret

puts:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM BLOCK
  mov a, [bp + 5] ; $s             
  mov d, a
  call _puts
  mov ah, $0A
  mov al, 0
  syscall sys_io
; --- END INLINE ASM BLOCK

  leave
  ret

print:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM BLOCK
  mov a, [bp + 5] ; $s             
  mov d, a
  call _puts
; --- END INLINE ASM BLOCK

  leave
  ret

loadfile:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM BLOCK
  mov a, [bp + 5] ; $destination             
  mov di, a
  lea d, [bp + 7] ; $filename
  mov d, [d]
  mov al, 20
  syscall sys_filesystem
; --- END INLINE ASM BLOCK

  leave
  ret

create_file:
  enter 0 ; (push bp; mov bp, sp)
  leave
  ret

delete_file:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM BLOCK
  lea d, [bp + 5] ; $filename
  mov al, 10
  syscall sys_filesystem
; --- END INLINE ASM BLOCK

  leave
  ret

fopen:
  enter 0 ; (push bp; mov bp, sp)
  leave
  ret

fclose:
  enter 0 ; (push bp; mov bp, sp)
  leave
  ret

alloc:
  enter 0 ; (push bp; mov bp, sp)
;; heap_top = heap_top + bytes; 
  mov d, _heap_top ; $heap_top         
  mov b, [_heap_top] ; $heap_top           
; START TERMS
  push a
  mov a, b
  mov b, [bp + 5] ; $bytes             
  add a, b
  mov b, a
  pop a
; END TERMS        
  mov [d], b
;; return heap_top - bytes; 
  mov b, [_heap_top] ; $heap_top           
; START TERMS
  push a
  mov a, b
  mov b, [bp + 5] ; $bytes             
  sub a, b
  mov b, a
  pop a
; END TERMS
  leave
  ret

free:
  enter 0 ; (push bp; mov bp, sp)
;; return heap_top = heap_top - bytes; 
  mov d, _heap_top ; $heap_top         
  mov b, [_heap_top] ; $heap_top           
; START TERMS
  push a
  mov a, b
  mov b, [bp + 5] ; $bytes             
  sub a, b
  mov b, a
  pop a
; END TERMS        
  mov [d], b
  leave
  ret

exit:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM BLOCK
  syscall sys_terminate_proc
; --- END INLINE ASM BLOCK

  leave
  ret

load_hex:
  enter 0 ; (push bp; mov bp, sp)
; $temp 
  sub sp, 2
;; temp = alloc(32768); 
  lea d, [bp + -1] ; $temp
  push d
  mov b, $8000
  swp b
  push b
  call alloc
  add sp, 2
  pop d
  mov [d], b

; --- BEGIN INLINE ASM BLOCK
  
  
  
  
  
_load_hex:
  push a
  push b
  push d
  push si
  push di
  sub sp, $8000      
  mov c, 0
  mov a, sp
  inc a
  mov d, a          
  call _gets        
  mov si, a
__load_hex_loop:
  lodsb             
  cmp al, 0         
  jz __load_hex_ret
  mov bh, al
  lodsb
  mov bl, al
  call _atoi        
  stosb             
  inc c
  jmp __load_hex_loop
__load_hex_ret:
  add sp, $8000
  pop di
  pop si
  pop d
  pop b
  pop a
; --- END INLINE ASM BLOCK

  leave
  ret

include_stdio_asm:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM BLOCK
.include "lib/stdio.asm"
; --- END INLINE ASM BLOCK

  leave
  ret

back:
  enter 0 ; (push bp; mov bp, sp)
; $t 
  sub sp, 2
;; t = token; 
  lea d, [bp + -1] ; $t         
  mov b, _token_data ; $token                   
  mov [d], b
;; while(*t++) prog--; 
_while32_cond:
  mov b, [bp + -1] ; $t             
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  cmp b, 0
  je _while32_exit
_while32_block:
;; prog--; 
  mov b, [_prog] ; $prog           
  mov g, b
  dec b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  jmp _while32_cond
_while32_exit:
;; tok = TOK_UNDEF; 
  mov d, _tok ; $tok         
  mov b, 0; TOK_UNDEF        
  mov [d], b
;; toktype = TYPE_UNDEF; 
  mov d, _toktype ; $toktype         
  mov b, 0; TYPE_UNDEF        
  mov [d], b
;; token[0] = '\0'; 
  mov d, _token_data ; $token
  push a         
  mov b, $0        
  add d, b
  pop a         
  mov b, $0        
  mov [d], bl
  leave
  ret

get_path:
  enter 0 ; (push bp; mov bp, sp)
; $t 
  sub sp, 2
;; *token = '\0'; 
  mov b, _token_data ; $token           
  push b
  mov b, $0
  pop d
  mov [d], bl
;; t = token; 
  lea d, [bp + -1] ; $t         
  mov b, _token_data ; $token                   
  mov [d], b
;; while(is_space(*prog)) prog++; 
_while33_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
  push bl
  call is_space
  add sp, 1
  cmp b, 0
  je _while33_exit
_while33_block:
;; prog++; 
  mov b, [_prog] ; $prog           
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  jmp _while33_cond
_while33_exit:
;; if(*prog == '\0'){ 
_if34_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if34_exit
_if34_true:
;; return; 
  leave
  ret
  jmp _if34_exit
_if34_exit:
;; while( 
_while35_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $61
  cmp a, b
  sge ; >=
  pop a
; END RELATIONAL
  push a
  mov a, b
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $7a
  cmp a, b
  sle ; <=
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  push a
  mov a, b
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $41
  cmp a, b
  sge ; >=
  pop a
; END RELATIONAL
  push a
  mov a, b
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $5a
  cmp a, b
  sle ; <=
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  sor a, b ; ||
  mov a, b
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $30
  cmp a, b
  sge ; >=
  pop a
; END RELATIONAL
  push a
  mov a, b
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $39
  cmp a, b
  sle ; <=
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  sor a, b ; ||
  mov a, b
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $2f
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $5f
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $2d
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $2e
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  pop a
  cmp b, 0
  je _while35_exit
_while35_block:
;; *t++ = *prog++; 
  mov b, [bp + -1] ; $t             
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov b, [_prog] ; $prog           
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
  jmp _while35_cond
_while35_exit:
;; *t = '\0'; 
  mov b, [bp + -1] ; $t             
  push b
  mov b, $0
  pop d
  mov [d], bl
  leave
  ret

get:
  enter 0 ; (push bp; mov bp, sp)
; $t 
  sub sp, 2
;; *token = '\0'; 
  mov b, _token_data ; $token           
  push b
  mov b, $0
  pop d
  mov [d], bl
;; tok = 0; 
  mov d, _tok ; $tok         
  mov b, $0        
  mov [d], b
;; toktype = 0; 
  mov d, _toktype ; $toktype         
  mov b, $0        
  mov [d], b
;; t = token; 
  lea d, [bp + -1] ; $t         
  mov b, _token_data ; $token                   
  mov [d], b
;; while(is_space(*prog)) prog++; 
_while36_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
  push bl
  call is_space
  add sp, 1
  cmp b, 0
  je _while36_exit
_while36_block:
;; prog++; 
  mov b, [_prog] ; $prog           
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  jmp _while36_cond
_while36_exit:
;; if(*prog == '\0'){ 
_if37_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if37_exit
_if37_true:
;; toktype = END; 
  mov d, _toktype ; $toktype         
  mov b, 6; END        
  mov [d], b
;; return; 
  leave
  ret
  jmp _if37_exit
_if37_exit:
;; if(is_digit(*prog)){ 
_if38_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
  push bl
  call is_digit
  add sp, 1
  cmp b, 0
  je _if38_else
_if38_true:
;; while(is_digit(*prog)){ 
_while39_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
  push bl
  call is_digit
  add sp, 1
  cmp b, 0
  je _while39_exit
_while39_block:
;; *t++ = *prog++; 
  mov b, [bp + -1] ; $t             
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov b, [_prog] ; $prog           
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
  jmp _while39_cond
_while39_exit:
;; *t = '\0'; 
  mov b, [bp + -1] ; $t             
  push b
  mov b, $0
  pop d
  mov [d], bl
;; toktype = INTEGER_CONST; 
  mov d, _toktype ; $toktype         
  mov b, 4; INTEGER_CONST        
  mov [d], b
;; return; // return to avoid *t = '\0' line at the end of function 
  leave
  ret
  jmp _if38_exit
_if38_else:
;; if(is_alpha(*prog)){ 
_if40_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
  push bl
  call is_alpha
  add sp, 1
  cmp b, 0
  je _if40_else
_if40_true:
;; while(is_alpha(*prog) || is_digit(*prog)){ 
_while41_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
  push bl
  call is_alpha
  add sp, 1
  push a
  mov a, b
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
  push bl
  call is_digit
  add sp, 1
  sor a, b ; ||
  pop a
  cmp b, 0
  je _while41_exit
_while41_block:
;; *t++ = *prog++; 
  mov b, [bp + -1] ; $t             
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov b, [_prog] ; $prog           
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
  jmp _while41_cond
_while41_exit:
;; *t = '\0'; 
  mov b, [bp + -1] ; $t             
  push b
  mov b, $0
  pop d
  mov [d], bl
;; toktype = IDENTIFIER; 
  mov d, _toktype ; $toktype         
  mov b, 5; IDENTIFIER        
  mov [d], b
  jmp _if40_exit
_if40_else:
;; if(*prog == '\"'){ 
_if42_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $22
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if42_else
_if42_true:
;; *t++ = '\"'; 
  mov b, [bp + -1] ; $t             
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov b, $22
  pop d
  mov [d], bl
;; prog++; 
  mov b, [_prog] ; $prog           
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
;; while(*prog != '\"' && *prog){ 
_while43_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $22
  cmp a, b
  sneq ; !=
  pop a
; END RELATIONAL
  push a
  mov a, b
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
  sand a, b ; &&
  pop a
  cmp b, 0
  je _while43_exit
_while43_block:
;; *t++ = *prog++; 
  mov b, [bp + -1] ; $t             
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov b, [_prog] ; $prog           
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
  jmp _while43_cond
_while43_exit:
;; if(*prog != '\"') error("Double quotes expected"); 
_if44_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $22
  cmp a, b
  sneq ; !=
  pop a
; END RELATIONAL
  cmp b, 0
  je _if44_exit
_if44_true:
;; error("Double quotes expected"); 
  mov b, __s9 ; "Double quotes expected"
  swp b
  push b
  call error
  add sp, 2
  jmp _if44_exit
_if44_exit:
;; *t++ = '\"'; 
  mov b, [bp + -1] ; $t             
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov b, $22
  pop d
  mov [d], bl
;; prog++; 
  mov b, [_prog] ; $prog           
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
;; toktype = STRING_CONST; 
  mov d, _toktype ; $toktype         
  mov b, 3; STRING_CONST        
  mov [d], b
;; *t = '\0'; 
  mov b, [bp + -1] ; $t             
  push b
  mov b, $0
  pop d
  mov [d], bl
;; convert_constant(); // converts this string token qith quotation marks to a non quotation marks string, and also converts escape sequences to their real bytes 
  call convert_constant
  jmp _if42_exit
_if42_else:
;; if(*prog == '#'){ 
_if45_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $23
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if45_else
_if45_true:
;; *t++ = *prog++; 
  mov b, [bp + -1] ; $t             
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov b, [_prog] ; $prog           
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = HASH; 
  mov d, _tok ; $tok         
  mov b, 21; HASH        
  mov [d], b
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype         
  mov b, 1; DELIMITER        
  mov [d], b
  jmp _if45_exit
_if45_else:
;; if(*prog == '{'){ 
_if46_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $7b
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if46_else
_if46_true:
;; *t++ = *prog++; 
  mov b, [bp + -1] ; $t             
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov b, [_prog] ; $prog           
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = OPENING_BRACE; 
  mov d, _tok ; $tok         
  mov b, 30; OPENING_BRACE        
  mov [d], b
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype         
  mov b, 1; DELIMITER        
  mov [d], b
  jmp _if46_exit
_if46_else:
;; if(*prog == '}'){ 
_if47_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $7d
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if47_else
_if47_true:
;; *t++ = *prog++; 
  mov b, [bp + -1] ; $t             
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov b, [_prog] ; $prog           
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = CLOSING_BRACE; 
  mov d, _tok ; $tok         
  mov b, 31; CLOSING_BRACE        
  mov [d], b
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype         
  mov b, 1; DELIMITER        
  mov [d], b
  jmp _if47_exit
_if47_else:
;; if(*prog == '['){ 
_if48_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $5b
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if48_else
_if48_true:
;; *t++ = *prog++; 
  mov b, [bp + -1] ; $t             
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov b, [_prog] ; $prog           
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = OPENING_BRACKET; 
  mov d, _tok ; $tok         
  mov b, 32; OPENING_BRACKET        
  mov [d], b
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype         
  mov b, 1; DELIMITER        
  mov [d], b
  jmp _if48_exit
_if48_else:
;; if(*prog == ']'){ 
_if49_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $5d
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if49_else
_if49_true:
;; *t++ = *prog++; 
  mov b, [bp + -1] ; $t             
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov b, [_prog] ; $prog           
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = CLOSING_BRACKET; 
  mov d, _tok ; $tok         
  mov b, 33; CLOSING_BRACKET        
  mov [d], b
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype         
  mov b, 1; DELIMITER        
  mov [d], b
  jmp _if49_exit
_if49_else:
;; if(*prog == '='){ 
_if50_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $3d
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if50_else
_if50_true:
;; *t++ = *prog++; 
  mov b, [bp + -1] ; $t             
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov b, [_prog] ; $prog           
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; if (*prog == '='){ 
_if51_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $3d
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if51_else
_if51_true:
;; *t++ = *prog++; 
  mov b, [bp + -1] ; $t             
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov b, [_prog] ; $prog           
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = EQUAL; 
  mov d, _tok ; $tok         
  mov b, 8; EQUAL        
  mov [d], b
  jmp _if51_exit
_if51_else:
;; tok = ASSIGNMENT; 
  mov d, _tok ; $tok         
  mov b, 17; ASSIGNMENT        
  mov [d], b
_if51_exit:
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype         
  mov b, 1; DELIMITER        
  mov [d], b
  jmp _if50_exit
_if50_else:
;; if(*prog == '&'){ 
_if52_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $26
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if52_else
_if52_true:
;; *t++ = *prog++; 
  mov b, [bp + -1] ; $t             
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov b, [_prog] ; $prog           
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; if(*prog == '&'){ 
_if53_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $26
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if53_else
_if53_true:
;; *t++ = *prog++; 
  mov b, [bp + -1] ; $t             
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov b, [_prog] ; $prog           
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = LOGICAL_AND; 
  mov d, _tok ; $tok         
  mov b, 14; LOGICAL_AND        
  mov [d], b
  jmp _if53_exit
_if53_else:
;; tok = AMPERSAND; 
  mov d, _tok ; $tok         
  mov b, 22; AMPERSAND        
  mov [d], b
_if53_exit:
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype         
  mov b, 1; DELIMITER        
  mov [d], b
  jmp _if52_exit
_if52_else:
;; if(*prog == '|'){ 
_if54_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $7c
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if54_else
_if54_true:
;; *t++ = *prog++; 
  mov b, [bp + -1] ; $t             
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov b, [_prog] ; $prog           
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; if (*prog == '|'){ 
_if55_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $7c
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if55_else
_if55_true:
;; *t++ = *prog++; 
  mov b, [bp + -1] ; $t             
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov b, [_prog] ; $prog           
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = LOGICAL_OR; 
  mov d, _tok ; $tok         
  mov b, 15; LOGICAL_OR        
  mov [d], b
  jmp _if55_exit
_if55_else:
;; tok = BITWISE_OR; 
  mov d, _tok ; $tok         
  mov b, 24; BITWISE_OR        
  mov [d], b
_if55_exit:
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype         
  mov b, 1; DELIMITER        
  mov [d], b
  jmp _if54_exit
_if54_else:
;; if(*prog == '~'){ 
_if56_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $7e
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if56_else
_if56_true:
;; *t++ = *prog++; 
  mov b, [bp + -1] ; $t             
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov b, [_prog] ; $prog           
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = BITWISE_NOT; 
  mov d, _tok ; $tok         
  mov b, 25; BITWISE_NOT        
  mov [d], b
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype         
  mov b, 1; DELIMITER        
  mov [d], b
  jmp _if56_exit
_if56_else:
;; if(*prog == '<'){ 
_if57_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $3c
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if57_else
_if57_true:
;; *t++ = *prog++; 
  mov b, [bp + -1] ; $t             
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov b, [_prog] ; $prog           
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; if (*prog == '='){ 
_if58_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $3d
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if58_else
_if58_true:
;; *t++ = *prog++; 
  mov b, [bp + -1] ; $t             
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov b, [_prog] ; $prog           
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = LESS_THAN_OR_EQUAL; 
  mov d, _tok ; $tok         
  mov b, 11; LESS_THAN_OR_EQUAL        
  mov [d], b
  jmp _if58_exit
_if58_else:
;; if (*prog == '<'){ 
_if59_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $3c
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if59_else
_if59_true:
;; *t++ = *prog++; 
  mov b, [bp + -1] ; $t             
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov b, [_prog] ; $prog           
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = BITWISE_SHL; 
  mov d, _tok ; $tok         
  mov b, 26; BITWISE_SHL        
  mov [d], b
  jmp _if59_exit
_if59_else:
;; tok = LESS_THAN; 
  mov d, _tok ; $tok         
  mov b, 10; LESS_THAN        
  mov [d], b
_if59_exit:
_if58_exit:
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype         
  mov b, 1; DELIMITER        
  mov [d], b
  jmp _if57_exit
_if57_else:
;; if(*prog == '>'){ 
_if60_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $3e
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if60_else
_if60_true:
;; *t++ = *prog++; 
  mov b, [bp + -1] ; $t             
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov b, [_prog] ; $prog           
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; if (*prog == '='){ 
_if61_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $3d
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if61_else
_if61_true:
;; *t++ = *prog++; 
  mov b, [bp + -1] ; $t             
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov b, [_prog] ; $prog           
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = GREATER_THAN_OR_EQUAL; 
  mov d, _tok ; $tok         
  mov b, 13; GREATER_THAN_OR_EQUAL        
  mov [d], b
  jmp _if61_exit
_if61_else:
;; if (*prog == '>'){ 
_if62_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $3e
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if62_else
_if62_true:
;; *t++ = *prog++; 
  mov b, [bp + -1] ; $t             
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov b, [_prog] ; $prog           
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = BITWISE_SHR; 
  mov d, _tok ; $tok         
  mov b, 27; BITWISE_SHR        
  mov [d], b
  jmp _if62_exit
_if62_else:
;; tok = GREATER_THAN; 
  mov d, _tok ; $tok         
  mov b, 12; GREATER_THAN        
  mov [d], b
_if62_exit:
_if61_exit:
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype         
  mov b, 1; DELIMITER        
  mov [d], b
  jmp _if60_exit
_if60_else:
;; if(*prog == '!'){ 
_if63_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $21
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if63_else
_if63_true:
;; *t++ = *prog++; 
  mov b, [bp + -1] ; $t             
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov b, [_prog] ; $prog           
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; if(*prog == '='){ 
_if64_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $3d
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if64_else
_if64_true:
;; *t++ = *prog++; 
  mov b, [bp + -1] ; $t             
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov b, [_prog] ; $prog           
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = NOT_EQUAL; 
  mov d, _tok ; $tok         
  mov b, 9; NOT_EQUAL        
  mov [d], b
  jmp _if64_exit
_if64_else:
;; tok = LOGICAL_NOT; 
  mov d, _tok ; $tok         
  mov b, 16; LOGICAL_NOT        
  mov [d], b
_if64_exit:
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype         
  mov b, 1; DELIMITER        
  mov [d], b
  jmp _if63_exit
_if63_else:
;; if(*prog == '+'){ 
_if65_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $2b
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if65_else
_if65_true:
;; *t++ = *prog++; 
  mov b, [bp + -1] ; $t             
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov b, [_prog] ; $prog           
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; if(*prog == '+'){ 
_if66_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $2b
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if66_else
_if66_true:
;; *t++ = *prog++; 
  mov b, [bp + -1] ; $t             
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov b, [_prog] ; $prog           
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = INCREMENT; 
  mov d, _tok ; $tok         
  mov b, 5; INCREMENT        
  mov [d], b
  jmp _if66_exit
_if66_else:
;; tok = PLUS; 
  mov d, _tok ; $tok         
  mov b, 1; PLUS        
  mov [d], b
_if66_exit:
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype         
  mov b, 1; DELIMITER        
  mov [d], b
  jmp _if65_exit
_if65_else:
;; if(*prog == '-'){ 
_if67_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $2d
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if67_else
_if67_true:
;; *t++ = *prog++; 
  mov b, [bp + -1] ; $t             
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov b, [_prog] ; $prog           
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; if(*prog == '-'){ 
_if68_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $2d
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if68_else
_if68_true:
;; *t++ = *prog++; 
  mov b, [bp + -1] ; $t             
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov b, [_prog] ; $prog           
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = DECREMENT; 
  mov d, _tok ; $tok         
  mov b, 6; DECREMENT        
  mov [d], b
  jmp _if68_exit
_if68_else:
;; tok = MINUS; 
  mov d, _tok ; $tok         
  mov b, 2; MINUS        
  mov [d], b
_if68_exit:
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype         
  mov b, 1; DELIMITER        
  mov [d], b
  jmp _if67_exit
_if67_else:
;; if(*prog == '$'){ 
_if69_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $24
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if69_else
_if69_true:
;; *t++ = *prog++; 
  mov b, [bp + -1] ; $t             
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov b, [_prog] ; $prog           
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = DOLLAR; 
  mov d, _tok ; $tok         
  mov b, 18; DOLLAR        
  mov [d], b
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype         
  mov b, 1; DELIMITER        
  mov [d], b
  jmp _if69_exit
_if69_else:
;; if(*prog == '^'){ 
_if70_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $5e
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if70_else
_if70_true:
;; *t++ = *prog++; 
  mov b, [bp + -1] ; $t             
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov b, [_prog] ; $prog           
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = BITWISE_XOR; 
  mov d, _tok ; $tok         
  mov b, 23; BITWISE_XOR        
  mov [d], b
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype         
  mov b, 1; DELIMITER        
  mov [d], b
  jmp _if70_exit
_if70_else:
;; if(*prog == '@'){ 
_if71_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $40
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if71_else
_if71_true:
;; *t++ = *prog++; 
  mov b, [bp + -1] ; $t             
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov b, [_prog] ; $prog           
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = AT; 
  mov d, _tok ; $tok         
  mov b, 20; AT        
  mov [d], b
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype         
  mov b, 1; DELIMITER        
  mov [d], b
  jmp _if71_exit
_if71_else:
;; if(*prog == '*'){ 
_if72_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $2a
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if72_else
_if72_true:
;; *t++ = *prog++; 
  mov b, [bp + -1] ; $t             
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov b, [_prog] ; $prog           
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = STAR; 
  mov d, _tok ; $tok         
  mov b, 3; STAR        
  mov [d], b
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype         
  mov b, 1; DELIMITER        
  mov [d], b
  jmp _if72_exit
_if72_else:
;; if(*prog == '/'){ 
_if73_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $2f
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if73_else
_if73_true:
;; *t++ = *prog++; 
  mov b, [bp + -1] ; $t             
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov b, [_prog] ; $prog           
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = FSLASH; 
  mov d, _tok ; $tok         
  mov b, 4; FSLASH        
  mov [d], b
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype         
  mov b, 1; DELIMITER        
  mov [d], b
  jmp _if73_exit
_if73_else:
;; if(*prog == '%'){ 
_if74_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $25
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if74_else
_if74_true:
;; *t++ = *prog++; 
  mov b, [bp + -1] ; $t             
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov b, [_prog] ; $prog           
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = MOD; 
  mov d, _tok ; $tok         
  mov b, 7; MOD        
  mov [d], b
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype         
  mov b, 1; DELIMITER        
  mov [d], b
  jmp _if74_exit
_if74_else:
;; if(*prog == '('){ 
_if75_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $28
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if75_else
_if75_true:
;; *t++ = *prog++; 
  mov b, [bp + -1] ; $t             
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov b, [_prog] ; $prog           
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = OPENING_PAREN; 
  mov d, _tok ; $tok         
  mov b, 28; OPENING_PAREN        
  mov [d], b
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype         
  mov b, 1; DELIMITER        
  mov [d], b
  jmp _if75_exit
_if75_else:
;; if(*prog == ')'){ 
_if76_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $29
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if76_else
_if76_true:
;; *t++ = *prog++; 
  mov b, [bp + -1] ; $t             
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov b, [_prog] ; $prog           
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = CLOSING_PAREN; 
  mov d, _tok ; $tok         
  mov b, 29; CLOSING_PAREN        
  mov [d], b
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype         
  mov b, 1; DELIMITER        
  mov [d], b
  jmp _if76_exit
_if76_else:
;; if(*prog == ';'){ 
_if77_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $3b
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if77_else
_if77_true:
;; *t++ = *prog++; 
  mov b, [bp + -1] ; $t             
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov b, [_prog] ; $prog           
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = SEMICOLON; 
  mov d, _tok ; $tok         
  mov b, 35; SEMICOLON        
  mov [d], b
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype         
  mov b, 1; DELIMITER        
  mov [d], b
  jmp _if77_exit
_if77_else:
;; if(*prog == ':'){ 
_if78_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $3a
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if78_else
_if78_true:
;; *t++ = *prog++; 
  mov b, [bp + -1] ; $t             
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov b, [_prog] ; $prog           
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = COLON; 
  mov d, _tok ; $tok         
  mov b, 34; COLON        
  mov [d], b
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype         
  mov b, 1; DELIMITER        
  mov [d], b
  jmp _if78_exit
_if78_else:
;; if(*prog == ','){ 
_if79_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $2c
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if79_else
_if79_true:
;; *t++ = *prog++; 
  mov b, [bp + -1] ; $t             
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov b, [_prog] ; $prog           
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = COMMA; 
  mov d, _tok ; $tok         
  mov b, 36; COMMA        
  mov [d], b
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype         
  mov b, 1; DELIMITER        
  mov [d], b
  jmp _if79_exit
_if79_else:
;; if(*prog == '.'){ 
_if80_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $2e
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if80_exit
_if80_true:
;; *t++ = *prog++; 
  mov b, [bp + -1] ; $t             
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov b, [_prog] ; $prog           
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = DOT; 
  mov d, _tok ; $tok         
  mov b, 37; DOT        
  mov [d], b
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype         
  mov b, 1; DELIMITER        
  mov [d], b
  jmp _if80_exit
_if80_exit:
_if79_exit:
_if78_exit:
_if77_exit:
_if76_exit:
_if75_exit:
_if74_exit:
_if73_exit:
_if72_exit:
_if71_exit:
_if70_exit:
_if69_exit:
_if67_exit:
_if65_exit:
_if63_exit:
_if60_exit:
_if57_exit:
_if56_exit:
_if54_exit:
_if52_exit:
_if50_exit:
_if49_exit:
_if48_exit:
_if47_exit:
_if46_exit:
_if45_exit:
_if42_exit:
_if40_exit:
_if38_exit:
;; *t = '\0'; 
  mov b, [bp + -1] ; $t             
  push b
  mov b, $0
  pop d
  mov [d], bl
  leave
  ret

convert_constant:
  enter 0 ; (push bp; mov bp, sp)
; $s 
; $t 
  sub sp, 4
;; t = token; 
  lea d, [bp + -3] ; $t         
  mov b, _token_data ; $token                   
  mov [d], b
;; s = string_const; 
  lea d, [bp + -1] ; $s         
  mov b, _string_const_data ; $string_const                   
  mov [d], b
;; if(toktype == CHAR_CONST){ 
_if81_cond:
  mov b, [_toktype] ; $toktype           
; START RELATIONAL
  push a
  mov a, b
  mov b, 2; CHAR_CONST
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if81_else
_if81_true:
;; t++; 
  mov b, [bp + -3] ; $t             
  mov g, b
  inc b
  lea d, [bp + -3] ; $t
  mov [d], b
  mov b, g
;; if(*t == '\\'){ 
_if82_cond:
  mov b, [bp + -3] ; $t             
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $5c
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if82_else
_if82_true:
;; t++; 
  mov b, [bp + -3] ; $t             
  mov g, b
  inc b
  lea d, [bp + -3] ; $t
  mov [d], b
  mov b, g
;; switch(*t){ 
_switch83_expr:
  mov b, [bp + -3] ; $t             
  mov d, b
  mov bl, [d]
  mov bh, 0
_switch83_comparisons:
  cmp bl, $30
  je _switch83_case0
  cmp bl, $61
  je _switch83_case1
  cmp bl, $62
  je _switch83_case2
  cmp bl, $66
  je _switch83_case3
  cmp bl, $6e
  je _switch83_case4
  cmp bl, $72
  je _switch83_case5
  cmp bl, $74
  je _switch83_case6
  cmp bl, $76
  je _switch83_case7
  cmp bl, $5c
  je _switch83_case8
  cmp bl, $27
  je _switch83_case9
  cmp bl, $22
  je _switch83_case10
  jmp _switch83_exit
_switch83_case0:
;; *s++ = '\0'; 
  mov b, [bp + -1] ; $s             
  mov g, b
  inc b
  lea d, [bp + -1] ; $s
  mov [d], b
  mov b, g
  push b
  mov b, $0
  pop d
  mov [d], bl
;; break; 
  jmp _switch83_exit ; case break
_switch83_case1:
;; *s++ = '\a'; 
  mov b, [bp + -1] ; $s             
  mov g, b
  inc b
  lea d, [bp + -1] ; $s
  mov [d], b
  mov b, g
  push b
  mov b, $7
  pop d
  mov [d], bl
;; break; 
  jmp _switch83_exit ; case break
_switch83_case2:
;; *s++ = '\b'; 
  mov b, [bp + -1] ; $s             
  mov g, b
  inc b
  lea d, [bp + -1] ; $s
  mov [d], b
  mov b, g
  push b
  mov b, $8
  pop d
  mov [d], bl
;; break;   
  jmp _switch83_exit ; case break
_switch83_case3:
;; *s++ = '\f'; 
  mov b, [bp + -1] ; $s             
  mov g, b
  inc b
  lea d, [bp + -1] ; $s
  mov [d], b
  mov b, g
  push b
  mov b, $c
  pop d
  mov [d], bl
;; break; 
  jmp _switch83_exit ; case break
_switch83_case4:
;; *s++ = '\n'; 
  mov b, [bp + -1] ; $s             
  mov g, b
  inc b
  lea d, [bp + -1] ; $s
  mov [d], b
  mov b, g
  push b
  mov b, $a
  pop d
  mov [d], bl
;; break; 
  jmp _switch83_exit ; case break
_switch83_case5:
;; *s++ = '\r'; 
  mov b, [bp + -1] ; $s             
  mov g, b
  inc b
  lea d, [bp + -1] ; $s
  mov [d], b
  mov b, g
  push b
  mov b, $d
  pop d
  mov [d], bl
;; break; 
  jmp _switch83_exit ; case break
_switch83_case6:
;; *s++ = '\t'; 
  mov b, [bp + -1] ; $s             
  mov g, b
  inc b
  lea d, [bp + -1] ; $s
  mov [d], b
  mov b, g
  push b
  mov b, $9
  pop d
  mov [d], bl
;; break; 
  jmp _switch83_exit ; case break
_switch83_case7:
;; *s++ = '\v'; 
  mov b, [bp + -1] ; $s             
  mov g, b
  inc b
  lea d, [bp + -1] ; $s
  mov [d], b
  mov b, g
  push b
  mov b, $b
  pop d
  mov [d], bl
;; break; 
  jmp _switch83_exit ; case break
_switch83_case8:
;; *s++ = '\\'; 
  mov b, [bp + -1] ; $s             
  mov g, b
  inc b
  lea d, [bp + -1] ; $s
  mov [d], b
  mov b, g
  push b
  mov b, $5c
  pop d
  mov [d], bl
;; break; 
  jmp _switch83_exit ; case break
_switch83_case9:
;; *s++ = '\''; 
  mov b, [bp + -1] ; $s             
  mov g, b
  inc b
  lea d, [bp + -1] ; $s
  mov [d], b
  mov b, g
  push b
  mov b, $27
  pop d
  mov [d], bl
;; break; 
  jmp _switch83_exit ; case break
_switch83_case10:
;; *s++ = '\"'; 
  mov b, [bp + -1] ; $s             
  mov g, b
  inc b
  lea d, [bp + -1] ; $s
  mov [d], b
  mov b, g
  push b
  mov b, $22
  pop d
  mov [d], bl
_switch83_exit:
  jmp _if82_exit
_if82_else:
;; *s++ = *t; 
  mov b, [bp + -1] ; $s             
  mov g, b
  inc b
  lea d, [bp + -1] ; $s
  mov [d], b
  mov b, g
  push b
  mov b, [bp + -3] ; $t             
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
_if82_exit:
  jmp _if81_exit
_if81_else:
;; if(toktype == STRING_CONST){ 
_if84_cond:
  mov b, [_toktype] ; $toktype           
; START RELATIONAL
  push a
  mov a, b
  mov b, 3; STRING_CONST
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if84_exit
_if84_true:
;; t++; 
  mov b, [bp + -3] ; $t             
  mov g, b
  inc b
  lea d, [bp + -3] ; $t
  mov [d], b
  mov b, g
;; while(*t != '\"' && *t){ 
_while85_cond:
  mov b, [bp + -3] ; $t             
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $22
  cmp a, b
  sneq ; !=
  pop a
; END RELATIONAL
  push a
  mov a, b
  mov b, [bp + -3] ; $t             
  mov d, b
  mov bl, [d]
  mov bh, 0
  sand a, b ; &&
  pop a
  cmp b, 0
  je _while85_exit
_while85_block:
;; *s++ = *t++; 
  mov b, [bp + -1] ; $s             
  mov g, b
  inc b
  lea d, [bp + -1] ; $s
  mov [d], b
  mov b, g
  push b
  mov b, [bp + -3] ; $t             
  mov g, b
  inc b
  lea d, [bp + -3] ; $t
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
  jmp _while85_cond
_while85_exit:
  jmp _if84_exit
_if84_exit:
_if81_exit:
;; *s = '\0'; 
  mov b, [bp + -1] ; $s             
  push b
  mov b, $0
  pop d
  mov [d], bl
  leave
  ret

error:
  enter 0 ; (push bp; mov bp, sp)
;; printf("\nError: "); 
  mov b, __s10 ; "\nError: "
  swp b
  push b
  call printf
  add sp, 2
;; printf(msg); 
  mov b, [bp + 5] ; $msg             
  swp b
  push b
  call printf
  add sp, 2
;; printf("\n"); 
  mov b, __s2 ; "\n"
  swp b
  push b
  call printf
  add sp, 2
  leave
  ret

http:
  enter 0 ; (push bp; mov bp, sp)
; $i 
; $command 
; $response 
  sub sp, 194
;; switch(cmd){ 
_switch86_expr:
  mov bl, [bp + 7] ; $cmd
  mov bh, 0             
_switch86_comparisons:
  cmp b, 0
  je _switch86_case0
  cmp b, 1
  je _switch86_case1
  cmp b, 2
  je _switch86_case2
  cmp b, 3
  je _switch86_case3
  cmp b, 4
  je _switch86_case4
  jmp _switch86_default
  jmp _switch86_exit
_switch86_case0:
;; break; 
  jmp _switch86_exit ; case break
_switch86_case1:
;; strcpy(command, "~1("); 
  lea d, [bp + -129] ; $command
  mov b, d
  swp b
  push b
  mov b, __s11 ; "~1("
  swp b
  push b
  call strcpy
  add sp, 4
;; for(i = 3; i < strlen(arg) + 3; i++){ 
_for87_init:
  lea d, [bp + -1] ; $i         
  mov b, $3        
  mov [d], b
_for87_cond:
  mov b, [bp + -1] ; $i             
; START RELATIONAL
  push a
  mov a, b
  mov b, [bp + 5] ; $arg             
  swp b
  push b
  call strlen
  add sp, 2
; START TERMS
  push a
  mov a, b
  mov b, $3
  add a, b
  mov b, a
  pop a
; END TERMS
  cmp a, b
  slt ; < 
  pop a
; END RELATIONAL
  cmp b, 0
  je _for87_exit
_for87_block:
;; command[i] = arg[i-3]; 
  lea d, [bp + -129] ; $command
  push a         
  mov b, [bp + -1] ; $i                     
  add d, b
  pop a
  push d
  lea d, [bp + 5] ; $arg
  mov d, [d]
  push a         
  mov b, [bp + -1] ; $i             
; START TERMS
  push a
  mov a, b
  mov b, $3
  sub a, b
  mov b, a
  pop a
; END TERMS        
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
_for87_update:
  mov b, [bp + -1] ; $i             
  mov g, b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  mov b, g
  jmp _for87_cond
_for87_exit:
;; command[strlen(arg) + 3] = ')'; 
  lea d, [bp + -129] ; $command
  push a
  push d
  mov b, [bp + 5] ; $arg             
  swp b
  push b
  call strlen
  add sp, 2
; START TERMS
  push a
  mov a, b
  mov b, $3
  add a, b
  mov b, a
  pop a
; END TERMS
  pop d
  add d, b
  pop a         
  mov b, $29        
  mov [d], bl
;; command[strlen(arg) + 4] = '\n'; 
  lea d, [bp + -129] ; $command
  push a
  push d
  mov b, [bp + 5] ; $arg             
  swp b
  push b
  call strlen
  add sp, 2
; START TERMS
  push a
  mov a, b
  mov b, $4
  add a, b
  mov b, a
  pop a
; END TERMS
  pop d
  add d, b
  pop a         
  mov b, $a        
  mov [d], bl
;; command[strlen(arg) + 5] = '\0'; 
  lea d, [bp + -129] ; $command
  push a
  push d
  mov b, [bp + 5] ; $arg             
  swp b
  push b
  call strlen
  add sp, 2
; START TERMS
  push a
  mov a, b
  mov b, $5
  add a, b
  mov b, a
  pop a
; END TERMS
  pop d
  add d, b
  pop a         
  mov b, $0        
  mov [d], bl
;; printf(command); 
  lea d, [bp + -129] ; $command
  mov b, d
  swp b
  push b
  call printf
  add sp, 2
;; break; 
  jmp _switch86_exit ; case break
_switch86_case2:
;; strcpy(command, "~2("); 
  lea d, [bp + -129] ; $command
  mov b, d
  swp b
  push b
  mov b, __s12 ; "~2("
  swp b
  push b
  call strcpy
  add sp, 4
;; for(i = 3; i < strlen(arg) + 3; i++){ 
_for88_init:
  lea d, [bp + -1] ; $i         
  mov b, $3        
  mov [d], b
_for88_cond:
  mov b, [bp + -1] ; $i             
; START RELATIONAL
  push a
  mov a, b
  mov b, [bp + 5] ; $arg             
  swp b
  push b
  call strlen
  add sp, 2
; START TERMS
  push a
  mov a, b
  mov b, $3
  add a, b
  mov b, a
  pop a
; END TERMS
  cmp a, b
  slt ; < 
  pop a
; END RELATIONAL
  cmp b, 0
  je _for88_exit
_for88_block:
;; command[i] = arg[i-3]; 
  lea d, [bp + -129] ; $command
  push a         
  mov b, [bp + -1] ; $i                     
  add d, b
  pop a
  push d
  lea d, [bp + 5] ; $arg
  mov d, [d]
  push a         
  mov b, [bp + -1] ; $i             
; START TERMS
  push a
  mov a, b
  mov b, $3
  sub a, b
  mov b, a
  pop a
; END TERMS        
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
_for88_update:
  mov b, [bp + -1] ; $i             
  mov g, b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  mov b, g
  jmp _for88_cond
_for88_exit:
;; command[strlen(arg) + 3] = ')'; 
  lea d, [bp + -129] ; $command
  push a
  push d
  mov b, [bp + 5] ; $arg             
  swp b
  push b
  call strlen
  add sp, 2
; START TERMS
  push a
  mov a, b
  mov b, $3
  add a, b
  mov b, a
  pop a
; END TERMS
  pop d
  add d, b
  pop a         
  mov b, $29        
  mov [d], bl
;; command[strlen(arg) + 4] = '\n'; 
  lea d, [bp + -129] ; $command
  push a
  push d
  mov b, [bp + 5] ; $arg             
  swp b
  push b
  call strlen
  add sp, 2
; START TERMS
  push a
  mov a, b
  mov b, $4
  add a, b
  mov b, a
  pop a
; END TERMS
  pop d
  add d, b
  pop a         
  mov b, $a        
  mov [d], bl
;; command[strlen(arg) + 5] = '\0'; 
  lea d, [bp + -129] ; $command
  push a
  push d
  mov b, [bp + 5] ; $arg             
  swp b
  push b
  call strlen
  add sp, 2
; START TERMS
  push a
  mov a, b
  mov b, $5
  add a, b
  mov b, a
  pop a
; END TERMS
  pop d
  add d, b
  pop a         
  mov b, $0        
  mov [d], bl
;; printf(command); 
  lea d, [bp + -129] ; $command
  mov b, d
  swp b
  push b
  call printf
  add sp, 2
;; gets(response); // Read status response. 
  lea d, [bp + -193] ; $response
  mov b, d
  swp b
  push b
  call gets
  add sp, 2
;; return atoi(response); 
  lea d, [bp + -193] ; $response
  mov b, d
  swp b
  push b
  call atoi
  add sp, 2
  leave
  ret
_switch86_case3:
;; printf("~3\n"); // Command sent to ESP8266. ESP will wait 3 seconds before sending the file. 
  mov b, __s13 ; "~3\n"
  swp b
  push b
  call printf
  add sp, 2
;; break; 
  jmp _switch86_exit ; case break
_switch86_case4:
;; strcpy(command, "~4("); 
  lea d, [bp + -129] ; $command
  mov b, d
  swp b
  push b
  mov b, __s14 ; "~4("
  swp b
  push b
  call strcpy
  add sp, 4
;; for(i = 3; i < strlen(arg) + 3; i++){ 
_for89_init:
  lea d, [bp + -1] ; $i         
  mov b, $3        
  mov [d], b
_for89_cond:
  mov b, [bp + -1] ; $i             
; START RELATIONAL
  push a
  mov a, b
  mov b, [bp + 5] ; $arg             
  swp b
  push b
  call strlen
  add sp, 2
; START TERMS
  push a
  mov a, b
  mov b, $3
  add a, b
  mov b, a
  pop a
; END TERMS
  cmp a, b
  slt ; < 
  pop a
; END RELATIONAL
  cmp b, 0
  je _for89_exit
_for89_block:
;; command[i] = arg[i-3]; 
  lea d, [bp + -129] ; $command
  push a         
  mov b, [bp + -1] ; $i                     
  add d, b
  pop a
  push d
  lea d, [bp + 5] ; $arg
  mov d, [d]
  push a         
  mov b, [bp + -1] ; $i             
; START TERMS
  push a
  mov a, b
  mov b, $3
  sub a, b
  mov b, a
  pop a
; END TERMS        
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
_for89_update:
  mov b, [bp + -1] ; $i             
  mov g, b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  mov b, g
  jmp _for89_cond
_for89_exit:
;; command[strlen(arg) + 3] = ')'; 
  lea d, [bp + -129] ; $command
  push a
  push d
  mov b, [bp + 5] ; $arg             
  swp b
  push b
  call strlen
  add sp, 2
; START TERMS
  push a
  mov a, b
  mov b, $3
  add a, b
  mov b, a
  pop a
; END TERMS
  pop d
  add d, b
  pop a         
  mov b, $29        
  mov [d], bl
;; command[strlen(arg) + 4] = '\n'; 
  lea d, [bp + -129] ; $command
  push a
  push d
  mov b, [bp + 5] ; $arg             
  swp b
  push b
  call strlen
  add sp, 2
; START TERMS
  push a
  mov a, b
  mov b, $4
  add a, b
  mov b, a
  pop a
; END TERMS
  pop d
  add d, b
  pop a         
  mov b, $a        
  mov [d], bl
;; command[strlen(arg) + 5] = '\0'; 
  lea d, [bp + -129] ; $command
  push a
  push d
  mov b, [bp + 5] ; $arg             
  swp b
  push b
  call strlen
  add sp, 2
; START TERMS
  push a
  mov a, b
  mov b, $5
  add a, b
  mov b, a
  pop a
; END TERMS
  pop d
  add d, b
  pop a         
  mov b, $0        
  mov [d], bl
;; printf(command); 
  lea d, [bp + -129] ; $command
  mov b, d
  swp b
  push b
  call printf
  add sp, 2
;; break; 
  jmp _switch86_exit ; case break
_switch86_default:
_switch86_exit:
  leave
  ret
; --- END TEXT BLOCK

; --- BEGIN DATA BLOCK
_tok: .fill 2, 0
_toktype: .fill 2, 0
_prog: .fill 2, 0
_token_data: .fill 256, 0
_string_const_data: .fill 256, 0
_url_data: .fill 128, 0
_filename_data: .fill 64, 0
__s0: .db "\nusage: hget <url> <filename>", 0
__s1: .db "Filename: ", 0
__s2: .db "\n", 0
__s3: .db "Url: ", 0
__s4: .db "Now creating file...\n", 0
__s5: .db "OK.\n", 0
__s6: .db "Bad code, aborting...\n", 0
__s7: .db "Unknown type size in va_arg() call. Size needs to be either 1 or 2.", 0
__s8: .db "Error: Unknown argument type.\n", 0
__s9: .db "Double quotes expected", 0
__s10: .db "\nError: ", 0
__s11: .db "~1(", 0
__s12: .db "~2(", 0
__s13: .db "~3\n", 0
__s14: .db "~4(", 0

_heap_top: .dw _heap
_heap: .db 0
; --- END DATA BLOCK

.end
