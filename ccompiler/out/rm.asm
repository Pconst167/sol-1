; --- FILENAME: ../solarium/usr/bin/rm
.include "lib/kernel.exp"
.include "lib/bios.exp"
.org text_org

; --- BEGIN TEXT BLOCK
main:
  mov bp, $FFE0 ;
  mov sp, $FFE0 ; Make space for argc(2 bytes) and for 10 pointers in argv (local variables)
; $filename 
; $p 
; $prog 
  sub sp, 68
;; prog = 0; 
  lea d, [bp + -67] ; $prog         
  mov b, $0        
  mov [d], b
;; while(is_space(*prog)) prog++; 
_while1_cond:
  mov b, [bp + -67] ; $prog             
  mov d, b
  mov bl, [d]
  mov bh, 0
  push bl
  call is_space
  add sp, 1
  cmp b, 0
  je _while1_exit
_while1_block:
;; prog++; 
  mov b, [bp + -67] ; $prog             
  mov g, b
  inc b
  lea d, [bp + -67] ; $prog
  mov [d], b
  mov b, g
  jmp _while1_cond
_while1_exit:
;; for(;;){ 
_for2_init:
_for2_cond:
_for2_block:
;; p = filename; 
  lea d, [bp + -65] ; $p
  push d
  lea d, [bp + -63] ; $filename
  mov b, d
  pop d
  mov [d], b
;; while(*prog != ' ' && *prog != ';' && *prog) *p++ = *prog++; 
_while3_cond:
  mov b, [bp + -67] ; $prog             
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
  push a
  mov a, b
  mov b, [bp + -67] ; $prog             
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
  mov a, b
  mov b, [bp + -67] ; $prog             
  mov d, b
  mov bl, [d]
  mov bh, 0
  sand a, b ; &&
  pop a
  cmp b, 0
  je _while3_exit
_while3_block:
;; *p++ = *prog++; 
  mov b, [bp + -65] ; $p             
  mov g, b
  inc b
  lea d, [bp + -65] ; $p
  mov [d], b
  mov b, g
  push b
  mov b, [bp + -67] ; $prog             
  mov g, b
  inc b
  lea d, [bp + -67] ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
  jmp _while3_cond
_while3_exit:
;; *p = '\0'; 
  mov b, [bp + -65] ; $p             
  push b
  mov b, $0
  pop d
  mov [d], bl
;; if(*prog == ' ') prog++; 
_if4_cond:
  mov b, [bp + -67] ; $prog             
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
  je _if4_exit
_if4_true:
;; prog++; 
  mov b, [bp + -67] ; $prog             
  mov g, b
  inc b
  lea d, [bp + -67] ; $prog
  mov [d], b
  mov b, g
  jmp _if4_exit
_if4_exit:

; --- BEGIN INLINE ASM BLOCK
  lea d, [bp + -63] ; $filename
  mov al, 10
  syscall sys_filesystem
; --- END INLINE ASM BLOCK

;; if(*prog == ';' || !*prog){ 
_if5_cond:
  mov b, [bp + -67] ; $prog             
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
  push a
  mov a, b
  mov b, [bp + -67] ; $prog             
  mov d, b
  mov bl, [d]
  mov bh, 0
  cmp b, 0
  seq ; !
  sor a, b ; ||
  pop a
  cmp b, 0
  je _if5_exit
_if5_true:
;; break; 
  jmp _for2_exit ; for break
  jmp _if5_exit
_if5_exit:
_for2_update:
  jmp _for2_cond
_for2_exit:
  syscall sys_terminate_proc

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
_while6_cond:
  mov b, [bp + -1] ; $psrc             
  mov d, b
  mov bl, [d]
  mov bh, 0
  cmp b, 0
  je _while6_exit
_while6_block:
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
  jmp _while6_cond
_while6_exit:
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
_while7_cond:
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
  je _while7_exit
_while7_block:
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
  jmp _while7_cond
_while7_exit:
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
_for8_init:
  lea d, [bp + -3] ; $i         
  mov b, $0        
  mov [d], b
_for8_cond:
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
  je _for8_exit
_for8_block:
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
_for8_update:
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
  jmp _for8_cond
_for8_exit:
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
_while9_cond:
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
  je _while9_exit
_while9_block:
;; length++; 
  mov b, [bp + -1] ; $length             
  mov g, b
  inc b
  lea d, [bp + -1] ; $length
  mov [d], b
  mov b, g
  jmp _while9_cond
_while9_exit:
;; return length; 
  mov b, [bp + -1] ; $length             
  leave
  ret

va_arg:
  enter 0 ; (push bp; mov bp, sp)
; $val 
  sub sp, 2
;; if(size == 1){ 
_if10_cond:
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
  je _if10_else
_if10_true:
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
  jmp _if10_exit
_if10_else:
;; if(size == 2){ 
_if11_cond:
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
  je _if11_else
_if11_true:
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
  jmp _if11_exit
_if11_else:
;; print("Unknown type size in va_arg() call. Size needs to be either 1 or 2."); 
  mov b, __s0 ; "Unknown type size in va_arg() call. Size needs to be either 1 or 2."
  swp b
  push b
  call print
  add sp, 2
_if11_exit:
_if10_exit:
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
_for12_init:
_for12_cond:
_for12_block:
;; if(!*fp) break; 
_if13_cond:
  mov b, [bp + -3] ; $fp             
  mov d, b
  mov bl, [d]
  mov bh, 0
  cmp b, 0
  seq ; !
  cmp b, 0
  je _if13_exit
_if13_true:
;; break; 
  jmp _for12_exit ; for break
  jmp _if13_exit
_if13_exit:
;; if(*fp == '%'){ 
_if14_cond:
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
  je _if14_else
_if14_true:
;; fp++; 
  mov b, [bp + -3] ; $fp             
  mov g, b
  inc b
  lea d, [bp + -3] ; $fp
  mov [d], b
  mov b, g
;; switch(*fp){ 
_switch15_expr:
  mov b, [bp + -3] ; $fp             
  mov d, b
  mov bl, [d]
  mov bh, 0
_switch15_comparisons:
  cmp bl, $64
  je _switch15_case0
  cmp bl, $69
  je _switch15_case1
  cmp bl, $75
  je _switch15_case2
  cmp bl, $78
  je _switch15_case3
  cmp bl, $63
  je _switch15_case4
  cmp bl, $73
  je _switch15_case5
  jmp _switch15_default
  jmp _switch15_exit
_switch15_case0:
_switch15_case1:
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
  jmp _switch15_exit ; case break
_switch15_case2:
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
  jmp _switch15_exit ; case break
_switch15_case3:
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
  jmp _switch15_exit ; case break
_switch15_case4:
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
  jmp _switch15_exit ; case break
_switch15_case5:
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
  jmp _switch15_exit ; case break
_switch15_default:
;; print("Error: Unknown argument type.\n"); 
  mov b, __s1 ; "Error: Unknown argument type.\n"
  swp b
  push b
  call print
  add sp, 2
_switch15_exit:
;; fp++; 
  mov b, [bp + -3] ; $fp             
  mov g, b
  inc b
  lea d, [bp + -3] ; $fp
  mov [d], b
  mov b, g
  jmp _if14_exit
_if14_else:
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
_if14_exit:
_for12_update:
  jmp _for12_cond
_for12_exit:
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
_for16_init:
  lea d, [bp + -3] ; $i         
  mov b, $0        
  mov [d], b
_for16_cond:
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
  je _for16_exit
_for16_block:
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
_if17_cond:
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
  je _if17_else
_if17_true:
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
  jmp _if17_exit
_if17_else:
;; if (hex_char >= 'A' && hex_char <= 'F')  
_if18_cond:
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
  je _if18_else
_if18_true:
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
  jmp _if18_exit
_if18_else:
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
_if18_exit:
_if17_exit:
_for16_update:
  mov b, [bp + -3] ; $i             
  mov g, b
  inc b
  lea d, [bp + -3] ; $i
  mov [d], b
  mov b, g
  jmp _for16_cond
_for16_exit:
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
_while19_cond:
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
  je _while19_exit
_while19_block:
;; str++; 
  mov b, [bp + 5] ; $str             
  mov g, b
  inc b
  lea d, [bp + 5] ; $str
  mov [d], b
  mov b, g
  jmp _while19_cond
_while19_exit:
;; if (*str == '-' || *str == '+') { 
_if20_cond:
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
  je _if20_exit
_if20_true:
;; if (*str == '-') sign = -1; 
_if21_cond:
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
  je _if21_exit
_if21_true:
;; sign = -1; 
  lea d, [bp + -3] ; $sign         
  mov b, $1
  neg b        
  mov [d], b
  jmp _if21_exit
_if21_exit:
;; str++; 
  mov b, [bp + 5] ; $str             
  mov g, b
  inc b
  lea d, [bp + 5] ; $str
  mov [d], b
  mov b, g
  jmp _if20_exit
_if20_exit:
;; while (*str >= '0' && *str <= '9') { 
_while22_cond:
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
  je _while22_exit
_while22_block:
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
  jmp _while22_cond
_while22_exit:
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
_if23_cond:
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
  je _if23_else
_if23_true:
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
  jmp _if23_exit
_if23_else:
;; if (num == 0) { 
_if24_cond:
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
  je _if24_exit
_if24_true:
;; putchar('0'); 
  mov b, $30
  push bl
  call putchar
  add sp, 1
;; return; 
  leave
  ret
  jmp _if24_exit
_if24_exit:
_if23_exit:
;; while (num > 0) { 
_while25_cond:
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
  je _while25_exit
_while25_block:
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
  jmp _while25_cond
_while25_exit:
;; while (i > 0) { 
_while26_cond:
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
  je _while26_exit
_while26_block:
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
  jmp _while26_cond
_while26_exit:
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
_if27_cond:
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
  je _if27_exit
_if27_true:
;; putchar('0'); 
  mov b, $30
  push bl
  call putchar
  add sp, 1
;; return; 
  leave
  ret
  jmp _if27_exit
_if27_exit:
;; while (num > 0) { 
_while28_cond:
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
  je _while28_exit
_while28_block:
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
  jmp _while28_cond
_while28_exit:
;; while (i > 0) { 
_while29_cond:
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
  je _while29_exit
_while29_block:
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
  jmp _while29_cond
_while29_exit:
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
_if30_cond:
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
  je _if30_else
_if30_true:
;; return 1; 
  mov b, $1
  leave
  ret
  jmp _if30_exit
_if30_else:
;; return 0; 
  mov b, $0
  leave
  ret
_if30_exit:
  leave
  ret
; --- END TEXT BLOCK

; --- BEGIN DATA BLOCK
__s0: .db "Unknown type size in va_arg() call. Size needs to be either 1 or 2.", 0
__s1: .db "Error: Unknown argument type.\n", 0

_heap_top: .dw _heap
_heap: .db 0
; --- END DATA BLOCK

.end
