; --- FILENAME: float
.include "lib/kernel.exp"
.include "lib/bios.exp"
.org text_org

; --- BEGIN TEXT BLOCK
main:
  mov bp, $FFE0 ;
  mov sp, $FFE0 ; Make space for argc(2 bytes) and for 10 pointers in argv (local variables)
; $a 
; $b 
; $sum 
  sub sp, 9
;; a.mantissa = 1234; 
  lea d, [bp + -2] ; $a
  add d, 0
  clb
  push d
  mov b, $4d2
  pop d
  mov [d], b
;; a.exponent = 1 ; 
  lea d, [bp + -2] ; $a
  add d, 2
  clb
  push d
  mov b, $1
  pop d
  mov [d], bl
;; b.mantissa = 1789; 
  lea d, [bp + -5] ; $b
  add d, 0
  clb
  push d
  mov b, $6fd
  pop d
  mov [d], b
;; b.exponent = 2; 
  lea d, [bp + -5] ; $b
  add d, 2
  clb
  push d
  mov b, $2
  pop d
  mov [d], bl
;; puts("Starting...\n\r"); 
  mov b, __s0 ; "Starting...\n\r"
  swp b
  push b
  call puts
  add sp, 2
;; sum = add(a, b); 
  lea d, [bp + -8] ; $sum
  push d
  lea d, [bp + -2] ; $a
  mov b, d
  sub sp, 3
  mov si, b
  lea d, [sp + 1]
  mov di, d
  mov c, 3
  rep movsb
  lea d, [bp + -5] ; $b
  mov b, d
  sub sp, 3
  mov si, b
  lea d, [sp + 1]
  mov di, d
  mov c, 3
  rep movsb
  call add
  add sp, 6
  pop d
  mov si, b
  mov di, d
  mov c, 3
  rep movsb
;; puts("Sum mantissa: "); 
  mov b, __s1 ; "Sum mantissa: "
  swp b
  push b
  call puts
  add sp, 2
;; prints(sum.mantissa); 
  lea d, [bp + -8] ; $sum
  add d, 0
  clb
  mov b, [d]
  swp b
  push b
  call prints
  add sp, 2
;; puts("Sum exponent:"); 
  mov b, __s2 ; "Sum exponent:"
  swp b
  push b
  call puts
  add sp, 2
;; prints(sum.exponent); 
  lea d, [bp + -8] ; $sum
  add d, 2
  clb
  mov bl, [d]
  mov bh, 0
  swp b
  push b
  call prints
  add sp, 2
  syscall sys_terminate_proc

strcpy:
  enter 0 ; (push bp; mov bp, sp)
; $psrc 
; $pdest 
  sub sp, 4
;; psrc = src; 
  lea d, [bp + -1] ; $psrc
  push d
  lea d, [bp + 5] ; $src
  mov b, [d]
  pop d
  mov [d], b
;; pdest = dest; 
  lea d, [bp + -3] ; $pdest
  push d
  lea d, [bp + 7] ; $dest
  mov b, [d]
  pop d
  mov [d], b
;; while(*psrc) *pdest++ = *psrc++; 
_while1_cond:
  lea d, [bp + -1] ; $psrc
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
  cmp b, 0
  je _while1_exit
_while1_block:
;; *pdest++ = *psrc++; 
  lea d, [bp + -3] ; $pdest
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -3] ; $pdest
  mov [d], b
  mov b, g
  push b
  lea d, [bp + -1] ; $psrc
  mov b, [d]
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
  jmp _while1_cond
_while1_exit:
;; *pdest = '\0'; 
  lea d, [bp + -3] ; $pdest
  mov b, [d]
  push b
  mov b, $0
  pop d
  mov [d], bl
  leave
  ret

strcmp:
  enter 0 ; (push bp; mov bp, sp)
;; while (*s1 && (*s1 == *s2)) { 
_while2_cond:
  lea d, [bp + 7] ; $s1
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
  push a
  mov a, b
  lea d, [bp + 7] ; $s1
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  lea d, [bp + 5] ; $s2
  mov b, [d]
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
  je _while2_exit
_while2_block:
;; s1++; 
  lea d, [bp + 7] ; $s1
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + 7] ; $s1
  mov [d], b
  mov b, g
;; s2++; 
  lea d, [bp + 5] ; $s2
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + 5] ; $s2
  mov [d], b
  mov b, g
  jmp _while2_cond
_while2_exit:
;; return *s1 - *s2; 
  lea d, [bp + 7] ; $s1
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START TERMS
  push a
  mov a, b
  lea d, [bp + 5] ; $s2
  mov b, [d]
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
  lea d, [bp + 7] ; $dest
  mov b, [d]
  swp b
  push b
  call strlen
  add sp, 2
  pop d
  mov [d], b
;; for (i = 0; src[i] != 0; i=i+1) { 
_for3_init:
  lea d, [bp + -3] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
_for3_cond:
  lea d, [bp + 5] ; $src
  mov d, [d]
  push a
  push d
  lea d, [bp + -3] ; $i
  mov b, [d]
  pop d
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
  je _for3_exit
_for3_block:
;; dest[dest_len + i] = src[i]; 
  lea d, [bp + 7] ; $dest
  mov d, [d]
  push a
  push d
  lea d, [bp + -1] ; $dest_len
  mov b, [d]
; START TERMS
  push a
  mov a, b
  lea d, [bp + -3] ; $i
  mov b, [d]
  add a, b
  mov b, a
  pop a
; END TERMS
  pop d
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  push d
  lea d, [bp + 5] ; $src
  mov d, [d]
  push a
  push d
  lea d, [bp + -3] ; $i
  mov b, [d]
  pop d
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
_for3_update:
  lea d, [bp + -3] ; $i
  push d
  lea d, [bp + -3] ; $i
  mov b, [d]
; START TERMS
  push a
  mov a, b
  mov b, $1
  add a, b
  mov b, a
  pop a
; END TERMS
  pop d
  mov [d], b
  jmp _for3_cond
_for3_exit:
;; dest[dest_len + i] = 0; 
  lea d, [bp + 7] ; $dest
  mov d, [d]
  push a
  push d
  lea d, [bp + -1] ; $dest_len
  mov b, [d]
; START TERMS
  push a
  mov a, b
  lea d, [bp + -3] ; $i
  mov b, [d]
  add a, b
  mov b, a
  pop a
; END TERMS
  pop d
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  push d
  mov b, $0
  pop d
  mov [d], bl
;; return dest; 
  lea d, [bp + 7] ; $dest
  mov b, [d]
  leave
  ret

strlen:
  enter 0 ; (push bp; mov bp, sp)
; $length 
  sub sp, 2
;; length = 0; 
  lea d, [bp + -1] ; $length
  push d
  mov b, $0
  pop d
  mov [d], b
;; while (str[length] != 0) { 
_while4_cond:
  lea d, [bp + 5] ; $str
  mov d, [d]
  push a
  push d
  lea d, [bp + -1] ; $length
  mov b, [d]
  pop d
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
  je _while4_exit
_while4_block:
;; length++; 
  lea d, [bp + -1] ; $length
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -1] ; $length
  mov [d], b
  mov b, g
  jmp _while4_cond
_while4_exit:
;; return length; 
  lea d, [bp + -1] ; $length
  mov b, [d]
  leave
  ret

va_arg:
  enter 0 ; (push bp; mov bp, sp)
; $val 
  sub sp, 2
;; if(size == 1){ 
_if5_cond:
  lea d, [bp + 5] ; $size
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $1
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if5_else
_if5_true:
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
  jmp _if5_exit
_if5_else:
;; if(size == 2){ 
_if6_cond:
  lea d, [bp + 5] ; $size
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $2
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if6_else
_if6_true:
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
  jmp _if6_exit
_if6_else:
;; print("Unknown type size in va_arg() call. Size needs to be either 1 or 2."); 
  mov b, __s3 ; "Unknown type size in va_arg() call. Size needs to be either 1 or 2."
  swp b
  push b
  call print
  add sp, 2
_if6_exit:
_if5_exit:
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
  lea d, [bp + 5] ; $size
  mov b, [d]
  add a, b
  mov b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; return val; 
  lea d, [bp + -1] ; $val
  mov b, [d]
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
  push d
  lea d, [bp + 5] ; $format
  mov b, [d]
  pop d
  mov [d], b
;; p = &format; 
  lea d, [bp + -1] ; $p
  push d
  lea d, [bp + 5] ; $format
  mov b, d
  pop d
  mov [d], b
;; for(;;){ 
_for7_init:
_for7_cond:
_for7_block:
;; if(!*fp) break; 
_if8_cond:
  lea d, [bp + -3] ; $fp
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
  cmp b, 0
  seq ; !
  cmp b, 0
  je _if8_exit
_if8_true:
;; break; 
  jmp _for7_exit ; for break
  jmp _if8_exit
_if8_exit:
;; if(*fp == '%'){ 
_if9_cond:
  lea d, [bp + -3] ; $fp
  mov b, [d]
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
  je _if9_else
_if9_true:
;; fp++; 
  lea d, [bp + -3] ; $fp
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -3] ; $fp
  mov [d], b
  mov b, g
;; switch(*fp){ 
_switch10_expr:
  lea d, [bp + -3] ; $fp
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
_switch10_comparisons:
  cmp bl, $64
  je _switch10_case0
  cmp bl, $69
  je _switch10_case1
  cmp bl, $75
  je _switch10_case2
  cmp bl, $78
  je _switch10_case3
  cmp bl, $63
  je _switch10_case4
  cmp bl, $73
  je _switch10_case5
  jmp _switch10_default
  jmp _switch10_exit
_switch10_case0:
_switch10_case1:
;; p = p - 2; 
  lea d, [bp + -1] ; $p
  push d
  lea d, [bp + -1] ; $p
  mov b, [d]
; START TERMS
  push a
  mov a, b
  mov b, $2
  sub a, b
  mov b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; prints(*(int*)p); 
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov d, b
  mov b, [d]
  swp b
  push b
  call prints
  add sp, 2
;; break; 
  jmp _switch10_exit ; case break
_switch10_case2:
;; p = p - 2; 
  lea d, [bp + -1] ; $p
  push d
  lea d, [bp + -1] ; $p
  mov b, [d]
; START TERMS
  push a
  mov a, b
  mov b, $2
  sub a, b
  mov b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; printu(*(unsigned int*)p); 
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov d, b
  mov b, [d]
  swp b
  push b
  call printu
  add sp, 2
;; break; 
  jmp _switch10_exit ; case break
_switch10_case3:
;; p = p - 2; 
  lea d, [bp + -1] ; $p
  push d
  lea d, [bp + -1] ; $p
  mov b, [d]
; START TERMS
  push a
  mov a, b
  mov b, $2
  sub a, b
  mov b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; printx16(*(unsigned int*)p); 
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov d, b
  mov b, [d]
  swp b
  push b
  call printx16
  add sp, 2
;; break; 
  jmp _switch10_exit ; case break
_switch10_case4:
;; p = p - 2; 
  lea d, [bp + -1] ; $p
  push d
  lea d, [bp + -1] ; $p
  mov b, [d]
; START TERMS
  push a
  mov a, b
  mov b, $2
  sub a, b
  mov b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; putchar(*(char*)p); 
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
  push bl
  call putchar
  add sp, 1
;; break; 
  jmp _switch10_exit ; case break
_switch10_case5:
;; p = p - 2; 
  lea d, [bp + -1] ; $p
  push d
  lea d, [bp + -1] ; $p
  mov b, [d]
; START TERMS
  push a
  mov a, b
  mov b, $2
  sub a, b
  mov b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; print(*(char**)p); 
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov d, b
  mov b, [d]
  swp b
  push b
  call print
  add sp, 2
;; break; 
  jmp _switch10_exit ; case break
_switch10_default:
;; print("Error: Unknown argument type.\n"); 
  mov b, __s4 ; "Error: Unknown argument type.\n"
  swp b
  push b
  call print
  add sp, 2
_switch10_exit:
;; fp++; 
  lea d, [bp + -3] ; $fp
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -3] ; $fp
  mov [d], b
  mov b, g
  jmp _if9_exit
_if9_else:
;; putchar(*fp); 
  lea d, [bp + -3] ; $fp
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
  push bl
  call putchar
  add sp, 1
;; fp++; 
  lea d, [bp + -3] ; $fp
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -3] ; $fp
  mov [d], b
  mov b, g
_if9_exit:
_for7_update:
  jmp _for7_cond
_for7_exit:
  leave
  ret

printx16:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM BLOCK
  lea d, [bp + 5] ; $hex
  mov b, [d]
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
  lea d, [bp + 5] ; $hex_string
  mov b, [d]
  swp b
  push b
  call strlen
  add sp, 2
  pop d
  mov [d], b
;; for (i = 0; i < len; i++) { 
_for11_init:
  lea d, [bp + -3] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
_for11_cond:
  lea d, [bp + -3] ; $i
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -6] ; $len
  mov b, [d]
  cmp a, b
  slt ; < 
  pop a
; END RELATIONAL
  cmp b, 0
  je _for11_exit
_for11_block:
;; hex_char = hex_string[i]; 
  lea d, [bp + -4] ; $hex_char
  push d
  lea d, [bp + 5] ; $hex_string
  mov d, [d]
  push a
  push d
  lea d, [bp + -3] ; $i
  mov b, [d]
  pop d
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; if (hex_char >= 'a' && hex_char <= 'f')  
_if12_cond:
  lea d, [bp + -4] ; $hex_char
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
  lea d, [bp + -4] ; $hex_char
  mov bl, [d]
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
  je _if12_else
_if12_true:
;; value = (value * 16) + (hex_char - 'a' + 10); 
  lea d, [bp + -1] ; $value
  push d
  lea d, [bp + -1] ; $value
  mov b, [d]
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
  lea d, [bp + -4] ; $hex_char
  mov bl, [d]
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
  pop d
  mov [d], b
  jmp _if12_exit
_if12_else:
;; if (hex_char >= 'A' && hex_char <= 'F')  
_if13_cond:
  lea d, [bp + -4] ; $hex_char
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
  lea d, [bp + -4] ; $hex_char
  mov bl, [d]
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
  je _if13_else
_if13_true:
;; value = (value * 16) + (hex_char - 'A' + 10); 
  lea d, [bp + -1] ; $value
  push d
  lea d, [bp + -1] ; $value
  mov b, [d]
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
  lea d, [bp + -4] ; $hex_char
  mov bl, [d]
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
  pop d
  mov [d], b
  jmp _if13_exit
_if13_else:
;; value = (value * 16) + (hex_char - '0'); 
  lea d, [bp + -1] ; $value
  push d
  lea d, [bp + -1] ; $value
  mov b, [d]
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
  lea d, [bp + -4] ; $hex_char
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
_if13_exit:
_if12_exit:
_for11_update:
  lea d, [bp + -3] ; $i
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -3] ; $i
  mov [d], b
  mov b, g
  jmp _for11_cond
_for11_exit:
;; return value; 
  lea d, [bp + -1] ; $value
  mov b, [d]
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
_while14_cond:
  lea d, [bp + 5] ; $str
  mov b, [d]
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
  je _while14_exit
_while14_block:
;; str++; 
  lea d, [bp + 5] ; $str
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + 5] ; $str
  mov [d], b
  mov b, g
  jmp _while14_cond
_while14_exit:
;; if (*str == '-' || *str == '+') { 
_if15_cond:
  lea d, [bp + 5] ; $str
  mov b, [d]
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
  lea d, [bp + 5] ; $str
  mov b, [d]
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
  je _if15_exit
_if15_true:
;; if (*str == '-') sign = -1; 
_if16_cond:
  lea d, [bp + 5] ; $str
  mov b, [d]
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
  je _if16_exit
_if16_true:
;; sign = -1; 
  lea d, [bp + -3] ; $sign
  push d
  mov b, $1
  neg b
  pop d
  mov [d], b
  jmp _if16_exit
_if16_exit:
;; str++; 
  lea d, [bp + 5] ; $str
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + 5] ; $str
  mov [d], b
  mov b, g
  jmp _if15_exit
_if15_exit:
;; while (*str >= '0' && *str <= '9') { 
_while17_cond:
  lea d, [bp + 5] ; $str
  mov b, [d]
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
  lea d, [bp + 5] ; $str
  mov b, [d]
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
  je _while17_exit
_while17_block:
;; result = result * 10 + (*str - '0'); 
  lea d, [bp + -1] ; $result
  push d
  lea d, [bp + -1] ; $result
  mov b, [d]
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
  lea d, [bp + 5] ; $str
  mov b, [d]
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
  lea d, [bp + 5] ; $str
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + 5] ; $str
  mov [d], b
  mov b, g
  jmp _while17_cond
_while17_exit:
;; return sign * result; 
  lea d, [bp + -3] ; $sign
  mov b, [d]
; START FACTORS
  push a
  mov a, b
  lea d, [bp + -1] ; $result
  mov b, [d]
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
  lea d, [bp + 5] ; $s
  mov a, [d]
  mov d, a
  call _gets
; --- END INLINE ASM BLOCK

;; return strlen(s); 
  lea d, [bp + 5] ; $s
  mov b, [d]
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
_if18_cond:
  lea d, [bp + 5] ; $num
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  slt ; < 
  pop a
; END RELATIONAL
  cmp b, 0
  je _if18_else
_if18_true:
;; putchar('-'); 
  mov b, $2d
  push bl
  call putchar
  add sp, 1
;; num = -num; 
  lea d, [bp + 5] ; $num
  push d
  lea d, [bp + 5] ; $num
  mov b, [d]
  neg b
  pop d
  mov [d], b
  jmp _if18_exit
_if18_else:
;; if (num == 0) { 
_if19_cond:
  lea d, [bp + 5] ; $num
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if19_exit
_if19_true:
;; putchar('0'); 
  mov b, $30
  push bl
  call putchar
  add sp, 1
;; return; 
  leave
  ret
  jmp _if19_exit
_if19_exit:
_if18_exit:
;; while (num > 0) { 
_while20_cond:
  lea d, [bp + 5] ; $num
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  sgt ; >
  pop a
; END RELATIONAL
  cmp b, 0
  je _while20_exit
_while20_block:
;; digits[i] = '0' + (num % 10); 
  lea d, [bp + -4] ; $digits
  push a
  push d
  lea d, [bp + -6] ; $i
  mov b, [d]
  pop d
  add d, b
  pop a
  push d
  mov b, $30
; START TERMS
  push a
  mov a, b
  lea d, [bp + 5] ; $num
  mov b, [d]
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
  pop d
  mov [d], bl
;; num = num / 10; 
  lea d, [bp + 5] ; $num
  push d
  lea d, [bp + 5] ; $num
  mov b, [d]
; START FACTORS
  push a
  mov a, b
  mov b, $a
  div a, b
  mov b, a
  pop a
; END FACTORS
  pop d
  mov [d], b
;; i++; 
  lea d, [bp + -6] ; $i
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -6] ; $i
  mov [d], b
  mov b, g
  jmp _while20_cond
_while20_exit:
;; while (i > 0) { 
_while21_cond:
  lea d, [bp + -6] ; $i
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  sgt ; >
  pop a
; END RELATIONAL
  cmp b, 0
  je _while21_exit
_while21_block:
;; i--; 
  lea d, [bp + -6] ; $i
  mov b, [d]
  mov g, b
  dec b
  lea d, [bp + -6] ; $i
  mov [d], b
  mov b, g
;; putchar(digits[i]); 
  lea d, [bp + -4] ; $digits
  push a
  push d
  lea d, [bp + -6] ; $i
  mov b, [d]
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  push bl
  call putchar
  add sp, 1
  jmp _while21_cond
_while21_exit:
  leave
  ret

printu:
  enter 0 ; (push bp; mov bp, sp)
; $digits 
; $i 
  sub sp, 7
;; i = 0; 
  lea d, [bp + -6] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
;; if(num == 0){ 
_if22_cond:
  lea d, [bp + 5] ; $num
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if22_exit
_if22_true:
;; putchar('0'); 
  mov b, $30
  push bl
  call putchar
  add sp, 1
;; return; 
  leave
  ret
  jmp _if22_exit
_if22_exit:
;; while (num > 0) { 
_while23_cond:
  lea d, [bp + 5] ; $num
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  sgu ; > (unsigned)
  pop a
; END RELATIONAL
  cmp b, 0
  je _while23_exit
_while23_block:
;; digits[i] = '0' + (num % 10); 
  lea d, [bp + -4] ; $digits
  push a
  push d
  lea d, [bp + -6] ; $i
  mov b, [d]
  pop d
  add d, b
  pop a
  push d
  mov b, $30
; START TERMS
  push a
  mov a, b
  lea d, [bp + 5] ; $num
  mov b, [d]
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
  pop d
  mov [d], bl
;; num = num / 10; 
  lea d, [bp + 5] ; $num
  push d
  lea d, [bp + 5] ; $num
  mov b, [d]
; START FACTORS
  push a
  mov a, b
  mov b, $a
  div a, b
  mov b, a
  pop a
; END FACTORS
  pop d
  mov [d], b
;; i++; 
  lea d, [bp + -6] ; $i
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -6] ; $i
  mov [d], b
  mov b, g
  jmp _while23_cond
_while23_exit:
;; while (i > 0) { 
_while24_cond:
  lea d, [bp + -6] ; $i
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  sgt ; >
  pop a
; END RELATIONAL
  cmp b, 0
  je _while24_exit
_while24_block:
;; i--; 
  lea d, [bp + -6] ; $i
  mov b, [d]
  mov g, b
  dec b
  lea d, [bp + -6] ; $i
  mov [d], b
  mov b, g
;; putchar(digits[i]); 
  lea d, [bp + -4] ; $digits
  push a
  push d
  lea d, [bp + -6] ; $i
  mov b, [d]
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  push bl
  call putchar
  add sp, 1
  jmp _while24_cond
_while24_exit:
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
  lea d, [bp + 0] ; $sec
  mov al, [d]
; --- END INLINE ASM BLOCK

;; return sec; 
  lea d, [bp + 0] ; $sec
  mov bl, [d]
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
  lea d, [bp + 5] ; $c
  mov al, [d]
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
  lea d, [bp + 0] ; $c
  mov bl, [d]
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
  lea d, [bp + -1] ; $m
  mov b, [d]
  leave
  ret

puts:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM BLOCK
  lea d, [bp + 5] ; $s
  mov a, [d]
  mov d, a
  call _puts
  mov a, $0A00
  syscall sys_io
; --- END INLINE ASM BLOCK

  leave
  ret

print:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM BLOCK
  lea d, [bp + 5] ; $s
  mov d, [d]
  call _puts
; --- END INLINE ASM BLOCK

  leave
  ret

loadfile:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM BLOCK
  lea d, [bp + 5] ; $destination
  mov a, [d]
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
  push d
  mov d, _heap_top ; $heap_top
  mov b, [d]
; START TERMS
  push a
  mov a, b
  lea d, [bp + 5] ; $bytes
  mov b, [d]
  add a, b
  mov b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; return heap_top - bytes; 
  mov d, _heap_top ; $heap_top
  mov b, [d]
; START TERMS
  push a
  mov a, b
  lea d, [bp + 5] ; $bytes
  mov b, [d]
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
  push d
  mov d, _heap_top ; $heap_top
  mov b, [d]
; START TERMS
  push a
  mov a, b
  lea d, [bp + 5] ; $bytes
  mov b, [d]
  sub a, b
  mov b, a
  pop a
; END TERMS
  pop d
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

getparam:
  enter 0 ; (push bp; mov bp, sp)
; $data 
  sub sp, 1

; --- BEGIN INLINE ASM BLOCK
  mov al, 4
  lea d, [bp + 5] ; $address
  mov d, [d]
  syscall sys_system
  lea d, [bp + 0] ; $data
  mov [d], bl
; --- END INLINE ASM BLOCK

;; return data; 
  lea d, [bp + 0] ; $data
  mov bl, [d]
  mov bh, 0
  leave
  ret

clear:
  enter 0 ; (push bp; mov bp, sp)
;; print("\033[2J\033[H"); 
  mov b, __s5 ; "\033[2J\033[H"
  swp b
  push b
  call print
  add sp, 2
  leave
  ret

printun:
  enter 0 ; (push bp; mov bp, sp)
;; print(prompt); 
  lea d, [bp + 7] ; $prompt
  mov b, [d]
  swp b
  push b
  call print
  add sp, 2
;; printu(n); 
  lea d, [bp + 5] ; $n
  mov b, [d]
  swp b
  push b
  call printu
  add sp, 2
;; print("\n"); 
  mov b, __s6 ; "\n"
  swp b
  push b
  call print
  add sp, 2
  leave
  ret

printsn:
  enter 0 ; (push bp; mov bp, sp)
;; print(prompt); 
  lea d, [bp + 7] ; $prompt
  mov b, [d]
  swp b
  push b
  call print
  add sp, 2
;; prints(n); 
  lea d, [bp + 5] ; $n
  mov b, [d]
  swp b
  push b
  call prints
  add sp, 2
;; print("\n"); 
  mov b, __s6 ; "\n"
  swp b
  push b
  call print
  add sp, 2
  leave
  ret

include_stdio_asm:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM BLOCK
.include "lib/stdio.asm"
; --- END INLINE ASM BLOCK

  leave
  ret

add:
  enter 0 ; (push bp; mov bp, sp)
; $result 
  sub sp, 3
;; while (a.exponent < b.exponent) { 
_while25_cond:
  lea d, [bp + 8] ; $a
  add d, 2
  clb
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  lea d, [bp + 5] ; $b
  add d, 2
  clb
  mov bl, [d]
  mov bh, 0
  cmp a, b
  slt ; < 
  pop a
; END RELATIONAL
  cmp b, 0
  je _while25_exit
_while25_block:
;; a.mantissa = a.mantissa / 2; 
  lea d, [bp + 8] ; $a
  add d, 0
  clb
  push d
  lea d, [bp + 8] ; $a
  add d, 0
  clb
  mov b, [d]
; START FACTORS
  push a
  mov a, b
  mov b, $2
  div a, b
  mov b, a
  pop a
; END FACTORS
  pop d
  mov [d], b
;; a.exponent = a.exponent + 1; 
  lea d, [bp + 8] ; $a
  add d, 2
  clb
  push d
  lea d, [bp + 8] ; $a
  add d, 2
  clb
  mov bl, [d]
  mov bh, 0
; START TERMS
  push a
  mov a, b
  mov b, $1
  add a, b
  mov b, a
  pop a
; END TERMS
  pop d
  mov [d], bl
;; puts("Loop1"); 
  mov b, __s7 ; "Loop1"
  swp b
  push b
  call puts
  add sp, 2
  jmp _while25_cond
_while25_exit:
;; while (b.exponent < a.exponent) { 
_while26_cond:
  lea d, [bp + 5] ; $b
  add d, 2
  clb
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  lea d, [bp + 8] ; $a
  add d, 2
  clb
  mov bl, [d]
  mov bh, 0
  cmp a, b
  slt ; < 
  pop a
; END RELATIONAL
  cmp b, 0
  je _while26_exit
_while26_block:
;; b.mantissa = b.mantissa / 2; 
  lea d, [bp + 5] ; $b
  add d, 0
  clb
  push d
  lea d, [bp + 5] ; $b
  add d, 0
  clb
  mov b, [d]
; START FACTORS
  push a
  mov a, b
  mov b, $2
  div a, b
  mov b, a
  pop a
; END FACTORS
  pop d
  mov [d], b
;; b.exponent = b.exponent + 1; 
  lea d, [bp + 5] ; $b
  add d, 2
  clb
  push d
  lea d, [bp + 5] ; $b
  add d, 2
  clb
  mov bl, [d]
  mov bh, 0
; START TERMS
  push a
  mov a, b
  mov b, $1
  add a, b
  mov b, a
  pop a
; END TERMS
  pop d
  mov [d], bl
;; printx8(b.exponent); 
  lea d, [bp + 5] ; $b
  add d, 2
  clb
  mov bl, [d]
  mov bh, 0
  push bl
  call printx8
  add sp, 1
;; puts("\n\r"); 
  mov b, __s8 ; "\n\r"
  swp b
  push b
  call puts
  add sp, 2
  jmp _while26_cond
_while26_exit:
;; result.mantissa = a.mantissa + b.mantissa; 
  lea d, [bp + -2] ; $result
  add d, 0
  clb
  push d
  lea d, [bp + 8] ; $a
  add d, 0
  clb
  mov b, [d]
; START TERMS
  push a
  mov a, b
  lea d, [bp + 5] ; $b
  add d, 0
  clb
  mov b, [d]
  add a, b
  mov b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; result.exponent = a.exponent; 
  lea d, [bp + -2] ; $result
  add d, 2
  clb
  push d
  lea d, [bp + 8] ; $a
  add d, 2
  clb
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; while (result.mantissa > 32767 || result.mantissa < -32767) { 
_while27_cond:
  lea d, [bp + -2] ; $result
  add d, 0
  clb
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $7fff
  cmp a, b
  sgt ; >
  pop a
; END RELATIONAL
  push a
  mov a, b
  lea d, [bp + -2] ; $result
  add d, 0
  clb
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $7fff
  neg b
  cmp a, b
  slt ; < 
  pop a
; END RELATIONAL
  sor a, b ; ||
  pop a
  cmp b, 0
  je _while27_exit
_while27_block:
;; result.mantissa = result.mantissa / 2; 
  lea d, [bp + -2] ; $result
  add d, 0
  clb
  push d
  lea d, [bp + -2] ; $result
  add d, 0
  clb
  mov b, [d]
; START FACTORS
  push a
  mov a, b
  mov b, $2
  div a, b
  mov b, a
  pop a
; END FACTORS
  pop d
  mov [d], b
;; result.exponent++; 
  lea d, [bp + -2] ; $result
  add d, 2
  clb
  mov bl, [d]
  mov bh, 0
  mov g, b
  inc b
  lea d, [bp + -2] ; $result
  mov [d], b
  mov b, g
;; puts("Loop3"); 
  mov b, __s9 ; "Loop3"
  swp b
  push b
  call puts
  add sp, 2
  jmp _while27_cond
_while27_exit:
;; return result; 
  lea d, [bp + -2] ; $result
  mov b, d
  leave
  ret

subtract:
  enter 0 ; (push bp; mov bp, sp)
; $result 
  sub sp, 3
;; while (a.exponent < b.exponent) { 
_while28_cond:
  lea d, [bp + 8] ; $a
  add d, 2
  clb
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  lea d, [bp + 5] ; $b
  add d, 2
  clb
  mov bl, [d]
  mov bh, 0
  cmp a, b
  slt ; < 
  pop a
; END RELATIONAL
  cmp b, 0
  je _while28_exit
_while28_block:
;; a.mantissa = a.mantissa / 2; 
  lea d, [bp + 8] ; $a
  add d, 0
  clb
  push d
  lea d, [bp + 8] ; $a
  add d, 0
  clb
  mov b, [d]
; START FACTORS
  push a
  mov a, b
  mov b, $2
  div a, b
  mov b, a
  pop a
; END FACTORS
  pop d
  mov [d], b
;; a.exponent++; 
  lea d, [bp + 8] ; $a
  add d, 2
  clb
  mov bl, [d]
  mov bh, 0
  mov g, b
  inc b
  lea d, [bp + 8] ; $a
  mov [d], b
  mov b, g
  jmp _while28_cond
_while28_exit:
;; while (b.exponent < a.exponent) { 
_while29_cond:
  lea d, [bp + 5] ; $b
  add d, 2
  clb
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  lea d, [bp + 8] ; $a
  add d, 2
  clb
  mov bl, [d]
  mov bh, 0
  cmp a, b
  slt ; < 
  pop a
; END RELATIONAL
  cmp b, 0
  je _while29_exit
_while29_block:
;; b.mantissa = b.mantissa / 2; 
  lea d, [bp + 5] ; $b
  add d, 0
  clb
  push d
  lea d, [bp + 5] ; $b
  add d, 0
  clb
  mov b, [d]
; START FACTORS
  push a
  mov a, b
  mov b, $2
  div a, b
  mov b, a
  pop a
; END FACTORS
  pop d
  mov [d], b
;; b.exponent++; 
  lea d, [bp + 5] ; $b
  add d, 2
  clb
  mov bl, [d]
  mov bh, 0
  mov g, b
  inc b
  lea d, [bp + 5] ; $b
  mov [d], b
  mov b, g
  jmp _while29_cond
_while29_exit:
;; result.mantissa = a.mantissa - b.mantissa; 
  lea d, [bp + -2] ; $result
  add d, 0
  clb
  push d
  lea d, [bp + 8] ; $a
  add d, 0
  clb
  mov b, [d]
; START TERMS
  push a
  mov a, b
  lea d, [bp + 5] ; $b
  add d, 0
  clb
  mov b, [d]
  sub a, b
  mov b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; result.exponent = a.exponent; 
  lea d, [bp + -2] ; $result
  add d, 2
  clb
  push d
  lea d, [bp + 8] ; $a
  add d, 2
  clb
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; while (result.mantissa > 32767 || result.mantissa < -32767) { 
_while30_cond:
  lea d, [bp + -2] ; $result
  add d, 0
  clb
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $7fff
  cmp a, b
  sgt ; >
  pop a
; END RELATIONAL
  push a
  mov a, b
  lea d, [bp + -2] ; $result
  add d, 0
  clb
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $7fff
  neg b
  cmp a, b
  slt ; < 
  pop a
; END RELATIONAL
  sor a, b ; ||
  pop a
  cmp b, 0
  je _while30_exit
_while30_block:
;; result.mantissa = result.mantissa / 2; 
  lea d, [bp + -2] ; $result
  add d, 0
  clb
  push d
  lea d, [bp + -2] ; $result
  add d, 0
  clb
  mov b, [d]
; START FACTORS
  push a
  mov a, b
  mov b, $2
  div a, b
  mov b, a
  pop a
; END FACTORS
  pop d
  mov [d], b
;; result.exponent++; 
  lea d, [bp + -2] ; $result
  add d, 2
  clb
  mov bl, [d]
  mov bh, 0
  mov g, b
  inc b
  lea d, [bp + -2] ; $result
  mov [d], b
  mov b, g
  jmp _while30_cond
_while30_exit:
;; return result; 
  lea d, [bp + -2] ; $result
  mov b, d
  leave
  ret
; --- END TEXT BLOCK

; --- BEGIN DATA BLOCK
__s0: .db "Starting...\n\r", 0
__s1: .db "Sum mantissa: ", 0
__s2: .db "Sum exponent:", 0
__s3: .db "Unknown type size in va_arg() call. Size needs to be either 1 or 2.", 0
__s4: .db "Error: Unknown argument type.\n", 0
__s5: .db "\033[2J\033[H", 0
__s6: .db "\n", 0
__s7: .db "Loop1", 0
__s8: .db "\n\r", 0
__s9: .db "Loop3", 0

_heap_top: .dw _heap
_heap: .db 0
; --- END DATA BLOCK

.end