; --- FILENAME: ctestsuite/testsuite2
.include "lib/asm/kernel.exp"
.include "lib/asm/bios.exp"
.org text_org

; --- BEGIN TEXT BLOCK
main:
  mov bp, $FFE0 ;
  mov sp, $FFE0 ; Make space for argc(2 bytes) and for 10 pointers in argv (local variables)
; $pass 
; $i 
; $nbr_tests 
  mov a, $a
  mov [bp + -23], a
  sub sp, 24
;; for(i = 0; i < nbr_tests; i++){ 
_for1_init:
  lea d, [bp + -21] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
_for1_cond:
  lea d, [bp + -21] ; $i
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -23] ; $nbr_tests
  mov b, [d]
  cmp a, b
  slt ; <= (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _for1_exit
_for1_block:
;; pass[i] = -1; 
  lea d, [bp + -19] ; $pass
  push a
  push d
  lea d, [bp + -21] ; $i
  mov b, [d]
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov b, $ffff
  pop d
  mov [d], b
_for1_update:
  lea d, [bp + -21] ; $i
  mov b, [d]
  push b
  inc b
  lea d, [bp + -21] ; $i
  mov [d], b
  pop b
  jmp _for1_cond
_for1_exit:
;; pass[0] = test0(); 
  lea d, [bp + -19] ; $pass
  push a
  push d
  mov b, $0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  call test0
  pop d
  mov [d], b
;; pass[1] = test1(); 
  lea d, [bp + -19] ; $pass
  push a
  push d
  mov b, $1
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  call test1
  pop d
  mov [d], b
;; pass[2] = test2(); 
  lea d, [bp + -19] ; $pass
  push a
  push d
  mov b, $2
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  call test2
  pop d
  mov [d], b
;; pass[3] = test3(st1); 
  lea d, [bp + -19] ; $pass
  push a
  push d
  mov b, $3
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov d, _st1_data ; $st1
  mov b, d
  sub sp, 13
  mov si, b
  lea d, [sp + 1]
  mov di, d
  mov c, 13
  rep movsb
  call test3
  add sp, 13
  pop d
  mov [d], b
;; for(i = 0; i < nbr_tests; i++){ 
_for2_init:
  lea d, [bp + -21] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
_for2_cond:
  lea d, [bp + -21] ; $i
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -23] ; $nbr_tests
  mov b, [d]
  cmp a, b
  slt ; <= (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _for2_exit
_for2_block:
;; printf("Test %d, Result: %d\n", i, pass[i]); 
  lea d, [bp + -19] ; $pass
  push a
  push d
  lea d, [bp + -21] ; $i
  mov b, [d]
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  swp b
  push b
  lea d, [bp + -21] ; $i
  mov b, [d]
  swp b
  push b
  mov b, __s0 ; "Test %d, Result: %d\n"
  swp b
  push b
  call printf
  add sp, 6
_for2_update:
  lea d, [bp + -21] ; $i
  mov b, [d]
  push b
  inc b
  lea d, [bp + -21] ; $i
  mov [d], b
  pop b
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
  push d
  lea d, [bp + 7] ; $src
  mov b, [d]
  pop d
  mov [d], b
;; pdest = dest; 
  lea d, [bp + -3] ; $pdest
  push d
  lea d, [bp + 5] ; $dest
  mov b, [d]
  pop d
  mov [d], b
;; while(*psrc) *pdest++ = *psrc++; 
_while3_cond:
  lea d, [bp + -1] ; $psrc
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
  cmp b, 0
  je _while3_exit
_while3_block:
;; *pdest++ = *psrc++; 
  lea d, [bp + -3] ; $pdest
  mov b, [d]
  push b
  inc b
  lea d, [bp + -3] ; $pdest
  mov [d], b
  pop b
  push b
  lea d, [bp + -1] ; $psrc
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $psrc
  mov [d], b
  pop b
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
  jmp _while3_cond
_while3_exit:
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
_while4_cond:
  lea d, [bp + 5] ; $s1
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
  push a
  mov a, b
  lea d, [bp + 5] ; $s1
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  lea d, [bp + 7] ; $s2
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
  je _while4_exit
_while4_block:
;; s1++; 
  lea d, [bp + 5] ; $s1
  mov b, [d]
  push b
  inc b
  lea d, [bp + 5] ; $s1
  mov [d], b
  pop b
;; s2++; 
  lea d, [bp + 7] ; $s2
  mov b, [d]
  push b
  inc b
  lea d, [bp + 7] ; $s2
  mov [d], b
  pop b
  jmp _while4_cond
_while4_exit:
;; return *s1 - *s2; 
  lea d, [bp + 5] ; $s1
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START TERMS
  push a
  mov a, b
  lea d, [bp + 7] ; $s2
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
  lea d, [bp + 5] ; $dest
  mov b, [d]
  swp b
  push b
  call strlen
  add sp, 2
  pop d
  mov [d], b
;; for (i = 0; src[i] != 0; i=i+1) { 
_for5_init:
  lea d, [bp + -3] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
_for5_cond:
  lea d, [bp + 7] ; $src
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
  je _for5_exit
_for5_block:
;; dest[dest_len + i] = src[i]; 
  lea d, [bp + 5] ; $dest
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
  add b, a
  pop a
; END TERMS
  pop d
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  push d
  lea d, [bp + 7] ; $src
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
_for5_update:
  lea d, [bp + -3] ; $i
  push d
  lea d, [bp + -3] ; $i
  mov b, [d]
; START TERMS
  push a
  mov a, b
  mov b, $1
  add b, a
  pop a
; END TERMS
  pop d
  mov [d], b
  jmp _for5_cond
_for5_exit:
;; dest[dest_len + i] = 0; 
  lea d, [bp + 5] ; $dest
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
  add b, a
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
  lea d, [bp + 5] ; $dest
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
_while6_cond:
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
  je _while6_exit
_while6_block:
;; length++; 
  lea d, [bp + -1] ; $length
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $length
  mov [d], b
  pop b
  jmp _while6_cond
_while6_exit:
;; return length; 
  lea d, [bp + -1] ; $length
  mov b, [d]
  leave
  ret

exit:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM BLOCK
  syscall sys_terminate_proc
; --- END INLINE ASM BLOCK

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
_while7_cond:
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
  je _while7_exit
_while7_block:
;; str++; 
  lea d, [bp + 5] ; $str
  mov b, [d]
  push b
  inc b
  lea d, [bp + 5] ; $str
  mov [d], b
  pop b
  jmp _while7_cond
_while7_exit:
;; if (*str == '-' || *str == '+') { 
_if8_cond:
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
  je _if8_exit
_if8_true:
;; if (*str == '-') sign = -1; 
_if9_cond:
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
  je _if9_exit
_if9_true:
;; sign = -1; 
  lea d, [bp + -3] ; $sign
  push d
  mov b, $ffff
  pop d
  mov [d], b
  jmp _if9_exit
_if9_exit:
;; str++; 
  lea d, [bp + 5] ; $str
  mov b, [d]
  push b
  inc b
  lea d, [bp + 5] ; $str
  mov [d], b
  pop b
  jmp _if8_exit
_if8_exit:
;; while (*str >= '0' && *str <= '9') { 
_while10_cond:
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
  sgeu ; >= (unsigned)
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
  sleu ; <= (unsigned)
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  cmp b, 0
  je _while10_exit
_while10_block:
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
  add b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; str++; 
  lea d, [bp + 5] ; $str
  mov b, [d]
  push b
  inc b
  lea d, [bp + 5] ; $str
  mov [d], b
  pop b
  jmp _while10_cond
_while10_exit:
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

rand:
  enter 0 ; (push bp; mov bp, sp)
; $sec 
  sub sp, 2

; --- BEGIN INLINE ASM BLOCK
  mov al, 0
  syscall sys_rtc					
  mov al, ah
  lea d, [bp + -1] ; $sec
  mov al, [d]
  mov ah, 0
; --- END INLINE ASM BLOCK

;; return sec; 
  lea d, [bp + -1] ; $sec
  mov b, [d]
  leave
  ret

srand:
  enter 0 ; (push bp; mov bp, sp)
  leave
  ret

malloc:
  enter 0 ; (push bp; mov bp, sp)
  leave
  ret

calloc:
  enter 0 ; (push bp; mov bp, sp)
  leave
  ret

realloc:
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
  add b, a
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

base64_encode:
  enter 0 ; (push bp; mov bp, sp)
; $i 
  mov a, $0
  mov [bp + -1], a
; $j 
  mov a, $0
  mov [bp + -3], a
; $k 
; $input_len 
; $input_buffer 
; $output_buffer 
  sub sp, 15
;; input_len = strlen(input); 
  lea d, [bp + -7] ; $input_len
  push d
  lea d, [bp + 5] ; $input
  mov b, [d]
  swp b
  push b
  call strlen
  add sp, 2
  pop d
  mov [d], b
;; while (input_len--) { 
_while11_cond:
  lea d, [bp + -7] ; $input_len
  mov b, [d]
  push b
  dec b
  lea d, [bp + -7] ; $input_len
  mov [d], b
  pop b
  cmp b, 0
  je _while11_exit
_while11_block:
;; input_buffer[i++] = *(input++); 
  lea d, [bp + -10] ; $input_buffer
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  pop b
  pop d
  add d, b
  pop a
  push d
  lea d, [bp + 5] ; $input
  mov b, [d]
  push b
  inc b
  lea d, [bp + 5] ; $input
  mov [d], b
  pop b
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; if (i == 3) { 
_if12_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $3
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if12_exit
_if12_true:
;; output_buffer[0] = (input_buffer[0] & 0xFC) >> 2; 
  lea d, [bp + -14] ; $output_buffer
  push a
  push d
  mov b, $0
  pop d
  add d, b
  pop a
  push d
  lea d, [bp + -10] ; $input_buffer
  push a
  push d
  mov b, $0
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  push a
  mov a, b
  mov b, $fc
  and a, b ; &
  mov b, a
  pop a
; START SHIFT
  push a
  mov a, b
  mov b, $2
  mov c, b
  ashr a, cl
  mov b, a
  pop a
; END SHIFT
  pop d
  mov [d], bl
;; output_buffer[1] = ((input_buffer[0] & 0x03) << 4) + ((input_buffer[1] & 0xF0) >> 4); 
  lea d, [bp + -14] ; $output_buffer
  push a
  push d
  mov b, $1
  pop d
  add d, b
  pop a
  push d
  lea d, [bp + -10] ; $input_buffer
  push a
  push d
  mov b, $0
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  push a
  mov a, b
  mov b, $3
  and a, b ; &
  mov b, a
  pop a
; START SHIFT
  push a
  mov a, b
  mov b, $4
  mov c, b
  shl a, cl
  mov b, a
  pop a
; END SHIFT
; START TERMS
  push a
  mov a, b
  lea d, [bp + -10] ; $input_buffer
  push a
  push d
  mov b, $1
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  push a
  mov a, b
  mov b, $f0
  and a, b ; &
  mov b, a
  pop a
; START SHIFT
  push a
  mov a, b
  mov b, $4
  mov c, b
  ashr a, cl
  mov b, a
  pop a
; END SHIFT
  add b, a
  pop a
; END TERMS
  pop d
  mov [d], bl
;; output_buffer[2] = ((input_buffer[1] & 0x0F) << 2) + ((input_buffer[2] & 0xC0) >> 6); 
  lea d, [bp + -14] ; $output_buffer
  push a
  push d
  mov b, $2
  pop d
  add d, b
  pop a
  push d
  lea d, [bp + -10] ; $input_buffer
  push a
  push d
  mov b, $1
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  push a
  mov a, b
  mov b, $f
  and a, b ; &
  mov b, a
  pop a
; START SHIFT
  push a
  mov a, b
  mov b, $2
  mov c, b
  shl a, cl
  mov b, a
  pop a
; END SHIFT
; START TERMS
  push a
  mov a, b
  lea d, [bp + -10] ; $input_buffer
  push a
  push d
  mov b, $2
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  push a
  mov a, b
  mov b, $c0
  and a, b ; &
  mov b, a
  pop a
; START SHIFT
  push a
  mov a, b
  mov b, $6
  mov c, b
  ashr a, cl
  mov b, a
  pop a
; END SHIFT
  add b, a
  pop a
; END TERMS
  pop d
  mov [d], bl
;; output_buffer[3] = input_buffer[2] & 0x3F; 
  lea d, [bp + -14] ; $output_buffer
  push a
  push d
  mov b, $3
  pop d
  add d, b
  pop a
  push d
  lea d, [bp + -10] ; $input_buffer
  push a
  push d
  mov b, $2
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  push a
  mov a, b
  mov b, $3f
  and a, b ; &
  mov b, a
  pop a
  pop d
  mov [d], bl
;; for (i = 0; i < 4; i++) { 
_for13_init:
  lea d, [bp + -1] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
_for13_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $4
  cmp a, b
  slt ; <= (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _for13_exit
_for13_block:
;; output[j++] = base64_table[output_buffer[i]]; 
  lea d, [bp + 7] ; $output
  mov d, [d]
  push a
  push d
  lea d, [bp + -3] ; $j
  mov b, [d]
  push b
  inc b
  lea d, [bp + -3] ; $j
  mov [d], b
  pop b
  pop d
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  push d
  mov d, _base64_table ; $base64_table
  mov d, [d]
  push a
  push d
  lea d, [bp + -14] ; $output_buffer
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  pop d
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
_for13_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  pop b
  jmp _for13_cond
_for13_exit:
;; i = 0; 
  lea d, [bp + -1] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
  jmp _if12_exit
_if12_exit:
  jmp _while11_cond
_while11_exit:
;; if (i) { 
_if14_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
  cmp b, 0
  je _if14_exit
_if14_true:
;; for (k = i; k < 3; k++) { 
_for15_init:
  lea d, [bp + -5] ; $k
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  pop d
  mov [d], b
_for15_cond:
  lea d, [bp + -5] ; $k
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $3
  cmp a, b
  slt ; <= (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _for15_exit
_for15_block:
;; input_buffer[k] = '\0'; 
  lea d, [bp + -10] ; $input_buffer
  push a
  push d
  lea d, [bp + -5] ; $k
  mov b, [d]
  pop d
  add d, b
  pop a
  push d
  mov b, $0
  pop d
  mov [d], bl
_for15_update:
  lea d, [bp + -5] ; $k
  mov b, [d]
  push b
  inc b
  lea d, [bp + -5] ; $k
  mov [d], b
  pop b
  jmp _for15_cond
_for15_exit:
;; output_buffer[0] = (input_buffer[0] & 0xFC) >> 2; 
  lea d, [bp + -14] ; $output_buffer
  push a
  push d
  mov b, $0
  pop d
  add d, b
  pop a
  push d
  lea d, [bp + -10] ; $input_buffer
  push a
  push d
  mov b, $0
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  push a
  mov a, b
  mov b, $fc
  and a, b ; &
  mov b, a
  pop a
; START SHIFT
  push a
  mov a, b
  mov b, $2
  mov c, b
  ashr a, cl
  mov b, a
  pop a
; END SHIFT
  pop d
  mov [d], bl
;; output_buffer[1] = ((input_buffer[0] & 0x03) << 4) + ((input_buffer[1] & 0xF0) >> 4); 
  lea d, [bp + -14] ; $output_buffer
  push a
  push d
  mov b, $1
  pop d
  add d, b
  pop a
  push d
  lea d, [bp + -10] ; $input_buffer
  push a
  push d
  mov b, $0
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  push a
  mov a, b
  mov b, $3
  and a, b ; &
  mov b, a
  pop a
; START SHIFT
  push a
  mov a, b
  mov b, $4
  mov c, b
  shl a, cl
  mov b, a
  pop a
; END SHIFT
; START TERMS
  push a
  mov a, b
  lea d, [bp + -10] ; $input_buffer
  push a
  push d
  mov b, $1
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  push a
  mov a, b
  mov b, $f0
  and a, b ; &
  mov b, a
  pop a
; START SHIFT
  push a
  mov a, b
  mov b, $4
  mov c, b
  ashr a, cl
  mov b, a
  pop a
; END SHIFT
  add b, a
  pop a
; END TERMS
  pop d
  mov [d], bl
;; output_buffer[2] = ((input_buffer[1] & 0x0F) << 2) + ((input_buffer[2] & 0xC0) >> 6); 
  lea d, [bp + -14] ; $output_buffer
  push a
  push d
  mov b, $2
  pop d
  add d, b
  pop a
  push d
  lea d, [bp + -10] ; $input_buffer
  push a
  push d
  mov b, $1
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  push a
  mov a, b
  mov b, $f
  and a, b ; &
  mov b, a
  pop a
; START SHIFT
  push a
  mov a, b
  mov b, $2
  mov c, b
  shl a, cl
  mov b, a
  pop a
; END SHIFT
; START TERMS
  push a
  mov a, b
  lea d, [bp + -10] ; $input_buffer
  push a
  push d
  mov b, $2
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  push a
  mov a, b
  mov b, $c0
  and a, b ; &
  mov b, a
  pop a
; START SHIFT
  push a
  mov a, b
  mov b, $6
  mov c, b
  ashr a, cl
  mov b, a
  pop a
; END SHIFT
  add b, a
  pop a
; END TERMS
  pop d
  mov [d], bl
;; for (k = 0; k < i + 1; k++) { 
_for16_init:
  lea d, [bp + -5] ; $k
  push d
  mov b, $0
  pop d
  mov [d], b
_for16_cond:
  lea d, [bp + -5] ; $k
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -1] ; $i
  mov b, [d]
; START TERMS
  push a
  mov a, b
  mov b, $1
  add b, a
  pop a
; END TERMS
  cmp a, b
  slt ; <= (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _for16_exit
_for16_block:
;; output[j++] = base64_table[output_buffer[k]]; 
  lea d, [bp + 7] ; $output
  mov d, [d]
  push a
  push d
  lea d, [bp + -3] ; $j
  mov b, [d]
  push b
  inc b
  lea d, [bp + -3] ; $j
  mov [d], b
  pop b
  pop d
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  push d
  mov d, _base64_table ; $base64_table
  mov d, [d]
  push a
  push d
  lea d, [bp + -14] ; $output_buffer
  push a
  push d
  lea d, [bp + -5] ; $k
  mov b, [d]
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  pop d
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
_for16_update:
  lea d, [bp + -5] ; $k
  mov b, [d]
  push b
  inc b
  lea d, [bp + -5] ; $k
  mov [d], b
  pop b
  jmp _for16_cond
_for16_exit:
;; while (i++ < 3) { 
_while17_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  pop b
; START RELATIONAL
  push a
  mov a, b
  mov b, $3
  cmp a, b
  slt ; <= (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _while17_exit
_while17_block:
;; output[j++] = '='; 
  lea d, [bp + 7] ; $output
  mov d, [d]
  push a
  push d
  lea d, [bp + -3] ; $j
  mov b, [d]
  push b
  inc b
  lea d, [bp + -3] ; $j
  mov [d], b
  pop b
  pop d
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  push d
  mov b, $3d
  pop d
  mov [d], bl
  jmp _while17_cond
_while17_exit:
  jmp _if14_exit
_if14_exit:
;; output[j] = '\0'; 
  lea d, [bp + 7] ; $output
  mov d, [d]
  push a
  push d
  lea d, [bp + -3] ; $j
  mov b, [d]
  pop d
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  push d
  mov b, $0
  pop d
  mov [d], bl
  leave
  ret

base64_char_value:
  enter 0 ; (push bp; mov bp, sp)
;; if (c >= 'A' && c <= 'Z') return c - 'A'; 
_if18_cond:
  lea d, [bp + 5] ; $c
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
  lea d, [bp + 5] ; $c
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
  cmp b, 0
  je _if18_exit
_if18_true:
;; return c - 'A'; 
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
; START TERMS
  push a
  mov a, b
  mov b, $41
  sub a, b
  mov b, a
  pop a
; END TERMS
  leave
  ret
  jmp _if18_exit
_if18_exit:
;; if (c >= 'a' && c <= 'z') return c - 'a' + 26; 
_if19_cond:
  lea d, [bp + 5] ; $c
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
  lea d, [bp + 5] ; $c
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
  cmp b, 0
  je _if19_exit
_if19_true:
;; return c - 'a' + 26; 
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
; START TERMS
  push a
  mov a, b
  mov b, $61
  sub a, b
  mov b, a
  mov a, b
  mov b, $1a
  add b, a
  pop a
; END TERMS
  leave
  ret
  jmp _if19_exit
_if19_exit:
;; if (c >= '0' && c <= '9') return c - '0' + 52; 
_if20_cond:
  lea d, [bp + 5] ; $c
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
  lea d, [bp + 5] ; $c
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
  je _if20_exit
_if20_true:
;; return c - '0' + 52; 
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
; START TERMS
  push a
  mov a, b
  mov b, $30
  sub a, b
  mov b, a
  mov a, b
  mov b, $34
  add b, a
  pop a
; END TERMS
  leave
  ret
  jmp _if20_exit
_if20_exit:
;; if (c == '+') return 62; 
_if21_cond:
  lea d, [bp + 5] ; $c
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
  je _if21_exit
_if21_true:
;; return 62; 
  mov b, $3e
  leave
  ret
  jmp _if21_exit
_if21_exit:
;; if (c == '/') return 63; 
_if22_cond:
  lea d, [bp + 5] ; $c
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
  je _if22_exit
_if22_true:
;; return 63; 
  mov b, $3f
  leave
  ret
  jmp _if22_exit
_if22_exit:
;; return -1; 
  mov b, $ffff
  leave
  ret

base64_decode:
  enter 0 ; (push bp; mov bp, sp)
; $i 
  mov a, $0
  mov [bp + -1], a
; $j 
  mov a, $0
  mov [bp + -3], a
; $k 
  mov a, $0
  mov [bp + -5], a
; $input_len 
; $input_buffer 
; $output_buffer 
  sub sp, 15
;; input_len = strlen(input); 
  lea d, [bp + -7] ; $input_len
  push d
  lea d, [bp + 5] ; $input
  mov b, [d]
  swp b
  push b
  call strlen
  add sp, 2
  pop d
  mov [d], b
;; while (input_len-- && (input[k] != '=') && base64_char_value(input[k]) != -1) { 
_while23_cond:
  lea d, [bp + -7] ; $input_len
  mov b, [d]
  push b
  dec b
  lea d, [bp + -7] ; $input_len
  mov [d], b
  pop b
  push a
  mov a, b
  lea d, [bp + 5] ; $input
  mov d, [d]
  push a
  push d
  lea d, [bp + -5] ; $k
  mov b, [d]
  pop d
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $3d
  cmp a, b
  sneq ; !=
  pop a
; END RELATIONAL
  sand a, b ; &&
  mov a, b
  lea d, [bp + 5] ; $input
  mov d, [d]
  push a
  push d
  lea d, [bp + -5] ; $k
  mov b, [d]
  pop d
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  push bl
  call base64_char_value
  add sp, 1
; START RELATIONAL
  push a
  mov a, b
  mov b, $ffff
  cmp a, b
  sneq ; !=
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  cmp b, 0
  je _while23_exit
_while23_block:
;; input_buffer[i++] = input[k++]; 
  lea d, [bp + -11] ; $input_buffer
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  pop b
  pop d
  add d, b
  pop a
  push d
  lea d, [bp + 5] ; $input
  mov d, [d]
  push a
  push d
  lea d, [bp + -5] ; $k
  mov b, [d]
  push b
  inc b
  lea d, [bp + -5] ; $k
  mov [d], b
  pop b
  pop d
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; if (i == 4) { 
_if24_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $4
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if24_exit
_if24_true:
;; for (i = 0; i < 4; i++) { 
_for25_init:
  lea d, [bp + -1] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
_for25_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $4
  cmp a, b
  slt ; <= (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _for25_exit
_for25_block:
;; input_buffer[i] = base64_char_value(input_buffer[i]); 
  lea d, [bp + -11] ; $input_buffer
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  pop d
  add d, b
  pop a
  push d
  lea d, [bp + -11] ; $input_buffer
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  push bl
  call base64_char_value
  add sp, 1
  pop d
  mov [d], bl
_for25_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  pop b
  jmp _for25_cond
_for25_exit:
;; output_buffer[0] = (input_buffer[0] << 2) + ((input_buffer[1] & 0x30) >> 4); 
  lea d, [bp + -14] ; $output_buffer
  push a
  push d
  mov b, $0
  pop d
  add d, b
  pop a
  push d
  lea d, [bp + -11] ; $input_buffer
  push a
  push d
  mov b, $0
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
; START SHIFT
  push a
  mov a, b
  mov b, $2
  mov c, b
  shl a, cl
  mov b, a
  pop a
; END SHIFT
; START TERMS
  push a
  mov a, b
  lea d, [bp + -11] ; $input_buffer
  push a
  push d
  mov b, $1
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  push a
  mov a, b
  mov b, $30
  and a, b ; &
  mov b, a
  pop a
; START SHIFT
  push a
  mov a, b
  mov b, $4
  mov c, b
  ashr a, cl
  mov b, a
  pop a
; END SHIFT
  add b, a
  pop a
; END TERMS
  pop d
  mov [d], bl
;; output_buffer[1] = ((input_buffer[1] & 0x0F) << 4) + ((input_buffer[2] & 0x3C) >> 2); 
  lea d, [bp + -14] ; $output_buffer
  push a
  push d
  mov b, $1
  pop d
  add d, b
  pop a
  push d
  lea d, [bp + -11] ; $input_buffer
  push a
  push d
  mov b, $1
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  push a
  mov a, b
  mov b, $f
  and a, b ; &
  mov b, a
  pop a
; START SHIFT
  push a
  mov a, b
  mov b, $4
  mov c, b
  shl a, cl
  mov b, a
  pop a
; END SHIFT
; START TERMS
  push a
  mov a, b
  lea d, [bp + -11] ; $input_buffer
  push a
  push d
  mov b, $2
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  push a
  mov a, b
  mov b, $3c
  and a, b ; &
  mov b, a
  pop a
; START SHIFT
  push a
  mov a, b
  mov b, $2
  mov c, b
  ashr a, cl
  mov b, a
  pop a
; END SHIFT
  add b, a
  pop a
; END TERMS
  pop d
  mov [d], bl
;; output_buffer[2] = ((input_buffer[2] & 0x03) << 6) + input_buffer[3]; 
  lea d, [bp + -14] ; $output_buffer
  push a
  push d
  mov b, $2
  pop d
  add d, b
  pop a
  push d
  lea d, [bp + -11] ; $input_buffer
  push a
  push d
  mov b, $2
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  push a
  mov a, b
  mov b, $3
  and a, b ; &
  mov b, a
  pop a
; START SHIFT
  push a
  mov a, b
  mov b, $6
  mov c, b
  shl a, cl
  mov b, a
  pop a
; END SHIFT
; START TERMS
  push a
  mov a, b
  lea d, [bp + -11] ; $input_buffer
  push a
  push d
  mov b, $3
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  add b, a
  pop a
; END TERMS
  pop d
  mov [d], bl
;; for (i = 0; i < 3; i++) { 
_for26_init:
  lea d, [bp + -1] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
_for26_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $3
  cmp a, b
  slt ; <= (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _for26_exit
_for26_block:
;; output[j++] = output_buffer[i]; 
  lea d, [bp + 7] ; $output
  mov d, [d]
  push a
  push d
  lea d, [bp + -3] ; $j
  mov b, [d]
  push b
  inc b
  lea d, [bp + -3] ; $j
  mov [d], b
  pop b
  pop d
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  push d
  lea d, [bp + -14] ; $output_buffer
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
_for26_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  push b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  pop b
  jmp _for26_cond
_for26_exit:
;; i = 0; 
  lea d, [bp + -1] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
  jmp _if24_exit
_if24_exit:
  jmp _while23_cond
_while23_exit:
;; if (i) { 
_if27_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
  cmp b, 0
  je _if27_exit
_if27_true:
;; for (k = i; k < 4; k++) { 
_for28_init:
  lea d, [bp + -5] ; $k
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  pop d
  mov [d], b
_for28_cond:
  lea d, [bp + -5] ; $k
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $4
  cmp a, b
  slt ; <= (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _for28_exit
_for28_block:
;; input_buffer[k] = 0; 
  lea d, [bp + -11] ; $input_buffer
  push a
  push d
  lea d, [bp + -5] ; $k
  mov b, [d]
  pop d
  add d, b
  pop a
  push d
  mov b, $0
  pop d
  mov [d], bl
_for28_update:
  lea d, [bp + -5] ; $k
  mov b, [d]
  push b
  inc b
  lea d, [bp + -5] ; $k
  mov [d], b
  pop b
  jmp _for28_cond
_for28_exit:
;; for (k = 0; k < 4; k++) { 
_for29_init:
  lea d, [bp + -5] ; $k
  push d
  mov b, $0
  pop d
  mov [d], b
_for29_cond:
  lea d, [bp + -5] ; $k
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $4
  cmp a, b
  slt ; <= (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _for29_exit
_for29_block:
;; input_buffer[k] = base64_char_value(input_buffer[k]); 
  lea d, [bp + -11] ; $input_buffer
  push a
  push d
  lea d, [bp + -5] ; $k
  mov b, [d]
  pop d
  add d, b
  pop a
  push d
  lea d, [bp + -11] ; $input_buffer
  push a
  push d
  lea d, [bp + -5] ; $k
  mov b, [d]
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  push bl
  call base64_char_value
  add sp, 1
  pop d
  mov [d], bl
_for29_update:
  lea d, [bp + -5] ; $k
  mov b, [d]
  push b
  inc b
  lea d, [bp + -5] ; $k
  mov [d], b
  pop b
  jmp _for29_cond
_for29_exit:
;; output_buffer[0] = (input_buffer[0] << 2) + ((input_buffer[1] & 0x30) >> 4); 
  lea d, [bp + -14] ; $output_buffer
  push a
  push d
  mov b, $0
  pop d
  add d, b
  pop a
  push d
  lea d, [bp + -11] ; $input_buffer
  push a
  push d
  mov b, $0
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
; START SHIFT
  push a
  mov a, b
  mov b, $2
  mov c, b
  shl a, cl
  mov b, a
  pop a
; END SHIFT
; START TERMS
  push a
  mov a, b
  lea d, [bp + -11] ; $input_buffer
  push a
  push d
  mov b, $1
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  push a
  mov a, b
  mov b, $30
  and a, b ; &
  mov b, a
  pop a
; START SHIFT
  push a
  mov a, b
  mov b, $4
  mov c, b
  ashr a, cl
  mov b, a
  pop a
; END SHIFT
  add b, a
  pop a
; END TERMS
  pop d
  mov [d], bl
;; output_buffer[1] = ((input_buffer[1] & 0x0F) << 4) + ((input_buffer[2] & 0x3C) >> 2); 
  lea d, [bp + -14] ; $output_buffer
  push a
  push d
  mov b, $1
  pop d
  add d, b
  pop a
  push d
  lea d, [bp + -11] ; $input_buffer
  push a
  push d
  mov b, $1
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  push a
  mov a, b
  mov b, $f
  and a, b ; &
  mov b, a
  pop a
; START SHIFT
  push a
  mov a, b
  mov b, $4
  mov c, b
  shl a, cl
  mov b, a
  pop a
; END SHIFT
; START TERMS
  push a
  mov a, b
  lea d, [bp + -11] ; $input_buffer
  push a
  push d
  mov b, $2
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  push a
  mov a, b
  mov b, $3c
  and a, b ; &
  mov b, a
  pop a
; START SHIFT
  push a
  mov a, b
  mov b, $2
  mov c, b
  ashr a, cl
  mov b, a
  pop a
; END SHIFT
  add b, a
  pop a
; END TERMS
  pop d
  mov [d], bl
;; for (k = 0; k < i - 1; k++) { 
_for30_init:
  lea d, [bp + -5] ; $k
  push d
  mov b, $0
  pop d
  mov [d], b
_for30_cond:
  lea d, [bp + -5] ; $k
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -1] ; $i
  mov b, [d]
; START TERMS
  push a
  mov a, b
  mov b, $1
  sub a, b
  mov b, a
  pop a
; END TERMS
  cmp a, b
  slt ; <= (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _for30_exit
_for30_block:
;; output[j++] = output_buffer[k]; 
  lea d, [bp + 7] ; $output
  mov d, [d]
  push a
  push d
  lea d, [bp + -3] ; $j
  mov b, [d]
  push b
  inc b
  lea d, [bp + -3] ; $j
  mov [d], b
  pop b
  pop d
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  push d
  lea d, [bp + -14] ; $output_buffer
  push a
  push d
  lea d, [bp + -5] ; $k
  mov b, [d]
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
_for30_update:
  lea d, [bp + -5] ; $k
  mov b, [d]
  push b
  inc b
  lea d, [bp + -5] ; $k
  mov [d], b
  pop b
  jmp _for30_cond
_for30_exit:
  jmp _if27_exit
_if27_exit:
;; output[j] = '\0'; 
  lea d, [bp + 7] ; $output
  mov d, [d]
  push a
  push d
  lea d, [bp + -3] ; $j
  mov b, [d]
  pop d
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  push d
  mov b, $0
  pop d
  mov [d], bl
  leave
  ret

va_start:
  enter 0 ; (push bp; mov bp, sp)
;; argp->current_arg = first_fixed_param + sizeof(first_fixed_param); 
  lea d, [bp + 5] ; $argp
  mov d, [d]
  add d, 0
  push d
  lea d, [bp + 7] ; $first_fixed_param
  mov b, [d]
; START TERMS
  push a
  mov a, b
  mov b, 2
  add b, a
  pop a
; END TERMS
  pop d
  mov [d], b
  leave
  ret

va_arg:
  enter 0 ; (push bp; mov bp, sp)
; $p 
  sub sp, 2
;; p = argp->current_arg; 
  lea d, [bp + -1] ; $p
  push d
  lea d, [bp + 5] ; $argp
  mov d, [d]
  add d, 0
  mov b, [d]
  pop d
  mov [d], b
;; argp->current_arg = argp->current_arg + size; 
  lea d, [bp + 5] ; $argp
  mov d, [d]
  add d, 0
  push d
  lea d, [bp + 5] ; $argp
  mov d, [d]
  add d, 0
  mov b, [d]
; START TERMS
  push a
  mov a, b
  lea d, [bp + 7] ; $size
  mov b, [d]
  add b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; return p; 
  lea d, [bp + -1] ; $p
  mov b, [d]
  leave
  ret

va_end:
  enter 0 ; (push bp; mov bp, sp)
;; argp->current_arg =   0   ; 
  lea d, [bp + 5] ; $argp
  mov d, [d]
  add d, 0
  push d
  mov b, $0
  pop d
  mov [d], b
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
;; p = &format + 2; 
  lea d, [bp + -1] ; $p
  push d
  lea d, [bp + 5] ; $format
  mov b, d
; START TERMS
  push a
  mov a, b
  mov b, $2
  add b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; for(;;){ 
_for31_init:
_for31_cond:
_for31_block:
;; if(!*fp) break; 
_if32_cond:
  lea d, [bp + -3] ; $fp
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
  cmp b, 0
  seq ; !
  cmp b, 0
  je _if32_else
_if32_true:
;; break; 
  jmp _for31_exit ; for break
  jmp _if32_exit
_if32_else:
;; if(*fp == '%'){ 
_if33_cond:
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
  je _if33_else
_if33_true:
;; fp++; 
  lea d, [bp + -3] ; $fp
  mov b, [d]
  push b
  inc b
  lea d, [bp + -3] ; $fp
  mov [d], b
  pop b
;; switch(*fp){ 
_switch34_expr:
  lea d, [bp + -3] ; $fp
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
_switch34_comparisons:
  cmp bl, $6c
  je _switch34_case0
  cmp bl, $4c
  je _switch34_case1
  cmp bl, $64
  je _switch34_case2
  cmp bl, $69
  je _switch34_case3
  cmp bl, $75
  je _switch34_case4
  cmp bl, $78
  je _switch34_case5
  cmp bl, $63
  je _switch34_case6
  cmp bl, $73
  je _switch34_case7
  jmp _switch34_default
  jmp _switch34_exit
_switch34_case0:
_switch34_case1:
;; fp++; 
  lea d, [bp + -3] ; $fp
  mov b, [d]
  push b
  inc b
  lea d, [bp + -3] ; $fp
  mov [d], b
  pop b
;; if(*fp == 'd' || *fp == 'i') 
_if35_cond:
  lea d, [bp + -3] ; $fp
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $64
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  push a
  mov a, b
  lea d, [bp + -3] ; $fp
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $69
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  pop a
  cmp b, 0
  je _if35_else
_if35_true:
;; print_signed_long(*(long *)p); 
  mov g, b
  mov b, c
  swp b
  push b
  mov b, g
  swp b
  push b
  call print_signed_long
  add sp, 4
  jmp _if35_exit
_if35_else:
;; if(*fp == 'u') 
_if36_cond:
  lea d, [bp + -3] ; $fp
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $75
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if36_else
_if36_true:
;; print_unsigned_long(*(unsigned long *)p); 
  mov g, b
  mov b, c
  swp b
  push b
  mov b, g
  swp b
  push b
  call print_unsigned_long
  add sp, 4
  jmp _if36_exit
_if36_else:
;; if(*fp == 'x') 
_if37_cond:
  lea d, [bp + -3] ; $fp
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $78
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if37_else
_if37_true:
;; printx32(*(long int *)p); 
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov d, b
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
  mov g, b
  mov b, c
  swp b
  push b
  mov b, g
  swp b
  push b
  call printx32
  add sp, 4
  jmp _if37_exit
_if37_else:
;; err("Unexpected format in printf."); 
  mov b, __s1 ; "Unexpected format in printf."
  swp b
  push b
  call err
  add sp, 2
_if37_exit:
_if36_exit:
_if35_exit:
;; p = p + 4; 
  lea d, [bp + -1] ; $p
  push d
  lea d, [bp + -1] ; $p
  mov b, [d]
; START TERMS
  push a
  mov a, b
  mov b, $4
  add b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; break; 
  jmp _switch34_exit ; case break
_switch34_case2:
_switch34_case3:
;; print_signed(*(int*)p); 
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov d, b
  mov b, [d]
  swp b
  push b
  call print_signed
  add sp, 2
;; p = p + 2; 
  lea d, [bp + -1] ; $p
  push d
  lea d, [bp + -1] ; $p
  mov b, [d]
; START TERMS
  push a
  mov a, b
  mov b, $2
  add b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; break; 
  jmp _switch34_exit ; case break
_switch34_case4:
;; print_unsigned(*(unsigned int*)p); 
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov d, b
  mov b, [d]
  swp b
  push b
  call print_unsigned
  add sp, 2
;; p = p + 2; 
  lea d, [bp + -1] ; $p
  push d
  lea d, [bp + -1] ; $p
  mov b, [d]
; START TERMS
  push a
  mov a, b
  mov b, $2
  add b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; break; 
  jmp _switch34_exit ; case break
_switch34_case5:

; --- BEGIN INLINE ASM BLOCK
  lea d, [bp + -1] ; $p
  mov d, [d]
  mov b, [d]
  call print_u16x
; --- END INLINE ASM BLOCK

;; p = p + 2; 
  lea d, [bp + -1] ; $p
  push d
  lea d, [bp + -1] ; $p
  mov b, [d]
; START TERMS
  push a
  mov a, b
  mov b, $2
  add b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; break; 
  jmp _switch34_exit ; case break
_switch34_case6:

; --- BEGIN INLINE ASM BLOCK
  lea d, [bp + -1] ; $p
  mov d, [d]
  mov al, [d]
  mov ah, al
  call _putchar
; --- END INLINE ASM BLOCK

;; p = p + 2; 
  lea d, [bp + -1] ; $p
  push d
  lea d, [bp + -1] ; $p
  mov b, [d]
; START TERMS
  push a
  mov a, b
  mov b, $2
  add b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; break; 
  jmp _switch34_exit ; case break
_switch34_case7:

; --- BEGIN INLINE ASM BLOCK
  lea d, [bp + -1] ; $p
  mov d, [d]
  mov d, [d]
  call _puts
; --- END INLINE ASM BLOCK

;; p = p + 2; 
  lea d, [bp + -1] ; $p
  push d
  lea d, [bp + -1] ; $p
  mov b, [d]
; START TERMS
  push a
  mov a, b
  mov b, $2
  add b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; break; 
  jmp _switch34_exit ; case break
_switch34_default:
;; print("Error: Unknown argument type.\n"); 
  mov b, __s2 ; "Error: Unknown argument type.\n"
  swp b
  push b
  call print
  add sp, 2
_switch34_exit:
;; fp++; 
  lea d, [bp + -3] ; $fp
  mov b, [d]
  push b
  inc b
  lea d, [bp + -3] ; $fp
  mov [d], b
  pop b
  jmp _if33_exit
_if33_else:
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
  push b
  inc b
  lea d, [bp + -3] ; $fp
  mov [d], b
  pop b
_if33_exit:
_if32_exit:
_for31_update:
  jmp _for31_cond
_for31_exit:
  leave
  ret

err:
  enter 0 ; (push bp; mov bp, sp)
;; print(e); 
  lea d, [bp + 5] ; $e
  mov b, [d]
  swp b
  push b
  call print
  add sp, 2
;; exit(); 
  call exit
  leave
  ret

printx32:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM BLOCK
  lea d, [bp + 5] ; $hex
  mov b, [d+2]
  call print_u16x
  mov b, [d]
  call print_u16x
; --- END INLINE ASM BLOCK

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
_for38_init:
  lea d, [bp + -3] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
_for38_cond:
  lea d, [bp + -3] ; $i
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -6] ; $len
  mov b, [d]
  cmp a, b
  slt ; <= (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _for38_exit
_for38_block:
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
_if39_cond:
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
  je _if39_else
_if39_true:
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
  mov b, a
  mov a, b
  mov b, $a
  add b, a
  pop a
; END TERMS
  add b, a
  pop a
; END TERMS
  pop d
  mov [d], b
  jmp _if39_exit
_if39_else:
;; if (hex_char >= 'A' && hex_char <= 'F')  
_if40_cond:
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
  je _if40_else
_if40_true:
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
  mov b, a
  mov a, b
  mov b, $a
  add b, a
  pop a
; END TERMS
  add b, a
  pop a
; END TERMS
  pop d
  mov [d], b
  jmp _if40_exit
_if40_else:
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
  add b, a
  pop a
; END TERMS
  pop d
  mov [d], b
_if40_exit:
_if39_exit:
_for38_update:
  lea d, [bp + -3] ; $i
  mov b, [d]
  push b
  inc b
  lea d, [bp + -3] ; $i
  mov [d], b
  pop b
  jmp _for38_cond
_for38_exit:
;; return value; 
  lea d, [bp + -1] ; $value
  mov b, [d]
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

print_signed:
  enter 0 ; (push bp; mov bp, sp)
; $digits 
; $i 
  mov a, $0
  mov [bp + -6], a
  sub sp, 7
;; if (num < 0) { 
_if41_cond:
  lea d, [bp + 5] ; $num
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  slt ; <= (signed)
  pop a
; END RELATIONAL
  cmp b, 0
  je _if41_else
_if41_true:
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
  jmp _if41_exit
_if41_else:
;; if (num == 0) { 
_if42_cond:
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
  je _if42_exit
_if42_true:
;; putchar('0'); 
  mov b, $30
  push bl
  call putchar
  add sp, 1
;; return; 
  leave
  ret
  jmp _if42_exit
_if42_exit:
_if41_exit:
;; while (num > 0) { 
_while43_cond:
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
  je _while43_exit
_while43_block:
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
  add b, a
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
  push b
  inc b
  lea d, [bp + -6] ; $i
  mov [d], b
  pop b
  jmp _while43_cond
_while43_exit:
;; while (i > 0) { 
_while44_cond:
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
  je _while44_exit
_while44_block:
;; i--; 
  lea d, [bp + -6] ; $i
  mov b, [d]
  push b
  dec b
  lea d, [bp + -6] ; $i
  mov [d], b
  pop b
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
  jmp _while44_cond
_while44_exit:
  leave
  ret

print_signed_long:
  enter 0 ; (push bp; mov bp, sp)
; $digits 
; $i 
  mov a, $0
  mov [bp + -11], a
  sub sp, 12
;; if (num < 0) { 
_if45_cond:
  lea d, [bp + 5] ; $num
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; START RELATIONAL
  push a
  push g
  mov a, b
  mov g, c
  mov b, $0
  mov si, a
  mov a, b
  mov di, a
  mov a, g
  mov b, c
  cmp a, b
  slu ; <
  push b
  mov b, c
  seq ; ==
  push b
  mov a, di
  mov b, a
  mov a, si
  cmp a, b
  slu ; <
  pop a
  and b, a
  pop a
  or b, a
  
  pop g
  pop a
; END RELATIONAL
  cmp b, 0
  je _if45_else
_if45_true:
;; putchar('-'); 
  mov b, $2d
  push bl
  call putchar
  add sp, 1
;; num = -num; 
  lea d, [bp + 5] ; $num
  push d
  lea d, [bp + 5] ; $num
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
  neg b
  pop d
  mov [d], b
  mov b, c
  mov [d + 2], b
  jmp _if45_exit
_if45_else:
;; if (num == 0) { 
_if46_cond:
  lea d, [bp + 5] ; $num
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; START RELATIONAL
  push a
  push g
  mov a, b
  mov g, c
  mov b, $0
  cmp a, b
  seq ; ==
  push b
  mov a, c
  mov b, g
  cmp a, b
  seq ; ==
  pop a
  sand a, b
  pop g
  pop a
; END RELATIONAL
  cmp b, 0
  je _if46_exit
_if46_true:
;; putchar('0'); 
  mov b, $30
  push bl
  call putchar
  add sp, 1
;; return; 
  leave
  ret
  jmp _if46_exit
_if46_exit:
_if45_exit:
;; while (num > 0) { 
_while47_cond:
  lea d, [bp + 5] ; $num
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; START RELATIONAL
  push a
  push g
  mov a, b
  mov g, c
  mov b, $0
  cmp a, b
  sgt ; >
  pop g
  pop a
; END RELATIONAL
  cmp b, 0
  je _while47_exit
_while47_block:
;; digits[i] = '0' + (num % 10); 
  lea d, [bp + -9] ; $digits
  push a
  push d
  lea d, [bp + -11] ; $i
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
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
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
  push a
  mov a, g
  mov b, c
  adc a, b
  mov c, a
  pop b
  pop a
; END TERMS
  pop d
  mov [d], bl
;; num = num / 10; 
  lea d, [bp + 5] ; $num
  push d
  lea d, [bp + 5] ; $num
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
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
  mov b, c
  mov [d + 2], b
;; i++; 
  lea d, [bp + -11] ; $i
  mov b, [d]
  push b
  inc b
  lea d, [bp + -11] ; $i
  mov [d], b
  pop b
  jmp _while47_cond
_while47_exit:
;; while (i > 0) { 
_while48_cond:
  lea d, [bp + -11] ; $i
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
  je _while48_exit
_while48_block:
;; i--; 
  lea d, [bp + -11] ; $i
  mov b, [d]
  push b
  dec b
  lea d, [bp + -11] ; $i
  mov [d], b
  pop b
;; putchar(digits[i]); 
  lea d, [bp + -9] ; $digits
  push a
  push d
  lea d, [bp + -11] ; $i
  mov b, [d]
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  push bl
  call putchar
  add sp, 1
  jmp _while48_cond
_while48_exit:
  leave
  ret

print_unsigned_long:
  enter 0 ; (push bp; mov bp, sp)
; $digits 
; $i 
  sub sp, 12
;; i = 0; 
  lea d, [bp + -11] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
;; if(num == 0){ 
_if49_cond:
  lea d, [bp + 5] ; $num
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; START RELATIONAL
  push a
  push g
  mov a, b
  mov g, c
  mov b, $0
  cmp a, b
  seq ; ==
  push b
  mov a, c
  mov b, g
  cmp a, b
  seq ; ==
  pop a
  sand a, b
  pop g
  pop a
; END RELATIONAL
  cmp b, 0
  je _if49_exit
_if49_true:
;; putchar('0'); 
  mov b, $30
  push bl
  call putchar
  add sp, 1
;; return; 
  leave
  ret
  jmp _if49_exit
_if49_exit:
;; while (num > 0) { 
_while50_cond:
  lea d, [bp + 5] ; $num
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; START RELATIONAL
  push a
  push g
  mov a, b
  mov g, c
  mov b, $0
  cmp a, b
  sgu ; > (unsigned)
  pop g
  pop a
; END RELATIONAL
  cmp b, 0
  je _while50_exit
_while50_block:
;; digits[i] = '0' + (num % 10); 
  lea d, [bp + -9] ; $digits
  push a
  push d
  lea d, [bp + -11] ; $i
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
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
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
  push a
  mov a, g
  mov b, c
  adc a, b
  mov c, a
  pop b
  pop a
; END TERMS
  pop d
  mov [d], bl
;; num = num / 10; 
  lea d, [bp + 5] ; $num
  push d
  lea d, [bp + 5] ; $num
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
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
  mov b, c
  mov [d + 2], b
;; i++; 
  lea d, [bp + -11] ; $i
  mov b, [d]
  push b
  inc b
  lea d, [bp + -11] ; $i
  mov [d], b
  pop b
  jmp _while50_cond
_while50_exit:
;; while (i > 0) { 
_while51_cond:
  lea d, [bp + -11] ; $i
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
  je _while51_exit
_while51_block:
;; i--; 
  lea d, [bp + -11] ; $i
  mov b, [d]
  push b
  dec b
  lea d, [bp + -11] ; $i
  mov [d], b
  pop b
;; putchar(digits[i]); 
  lea d, [bp + -9] ; $digits
  push a
  push d
  lea d, [bp + -11] ; $i
  mov b, [d]
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  push bl
  call putchar
  add sp, 1
  jmp _while51_cond
_while51_exit:
  leave
  ret

print_unsigned:
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
_if52_cond:
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
  je _if52_exit
_if52_true:
;; putchar('0'); 
  mov b, $30
  push bl
  call putchar
  add sp, 1
;; return; 
  leave
  ret
  jmp _if52_exit
_if52_exit:
;; while (num > 0) { 
_while53_cond:
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
  je _while53_exit
_while53_block:
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
  add b, a
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
  push b
  inc b
  lea d, [bp + -6] ; $i
  mov [d], b
  pop b
  jmp _while53_cond
_while53_exit:
;; while (i > 0) { 
_while54_cond:
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
  je _while54_exit
_while54_block:
;; i--; 
  lea d, [bp + -6] ; $i
  mov b, [d]
  push b
  dec b
  lea d, [bp + -6] ; $i
  mov [d], b
  pop b
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
  jmp _while54_cond
_while54_exit:
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
  lea d, [bp + 7] ; $destination
  mov a, [d]
  mov di, a
  lea d, [bp + 5] ; $filename
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
  mov b, __s3 ; "\033[2J\033[H"
  swp b
  push b
  call print
  add sp, 2
  leave
  ret

include_stdio_asm:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM BLOCK
.include "lib/asm/stdio.asm"
; --- END INLINE ASM BLOCK

  leave
  ret

test0:
  enter 0 ; (push bp; mov bp, sp)
; $result 
; $pass 
  mov a, $1
  mov [bp + -3], a
; $c 
; $i 
; $ca 
; $ia 
  sub sp, 22
;; c = 'A'; 
  lea d, [bp + -4] ; $c
  push d
  mov b, $41
  pop d
  mov [d], bl
;; i = 55; 
  lea d, [bp + -6] ; $i
  push d
  mov b, $37
  pop d
  mov [d], b
;; ca[0] = 'A'; 
  lea d, [bp + -11] ; $ca
  push a
  push d
  mov b, $0
  pop d
  add d, b
  pop a
  push d
  mov b, $41
  pop d
  mov [d], bl
;; ca[1] = 'B'; 
  lea d, [bp + -11] ; $ca
  push a
  push d
  mov b, $1
  pop d
  add d, b
  pop a
  push d
  mov b, $42
  pop d
  mov [d], bl
;; ca[2] = 'C'; 
  lea d, [bp + -11] ; $ca
  push a
  push d
  mov b, $2
  pop d
  add d, b
  pop a
  push d
  mov b, $43
  pop d
  mov [d], bl
;; ca[3] = 'D'; 
  lea d, [bp + -11] ; $ca
  push a
  push d
  mov b, $3
  pop d
  add d, b
  pop a
  push d
  mov b, $44
  pop d
  mov [d], bl
;; ca[4] = 'E'; 
  lea d, [bp + -11] ; $ca
  push a
  push d
  mov b, $4
  pop d
  add d, b
  pop a
  push d
  mov b, $45
  pop d
  mov [d], bl
;; ia[0] = 0; 
  lea d, [bp + -21] ; $ia
  push a
  push d
  mov b, $0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov b, $0
  pop d
  mov [d], b
;; ia[1] = 1; 
  lea d, [bp + -21] ; $ia
  push a
  push d
  mov b, $1
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov b, $1
  pop d
  mov [d], b
;; ia[2] = 2; 
  lea d, [bp + -21] ; $ia
  push a
  push d
  mov b, $2
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov b, $2
  pop d
  mov [d], b
;; ia[3] = 3; 
  lea d, [bp + -21] ; $ia
  push a
  push d
  mov b, $3
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov b, $3
  pop d
  mov [d], b
;; ia[4] = 4; 
  lea d, [bp + -21] ; $ia
  push a
  push d
  mov b, $4
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov b, $4
  pop d
  mov [d], b
;; pass = pass && test0_subTest0(c, i, ca, ia); 
  lea d, [bp + -3] ; $pass
  push d
  lea d, [bp + -3] ; $pass
  mov b, [d]
  push a
  mov a, b
  lea d, [bp + -21] ; $ia
  mov b, d
  swp b
  push b
  lea d, [bp + -11] ; $ca
  mov b, d
  swp b
  push b
  lea d, [bp + -6] ; $i
  mov b, [d]
  swp b
  push b
  lea d, [bp + -4] ; $c
  mov bl, [d]
  mov bh, 0
  push bl
  call test0_subTest0
  add sp, 7
  sand a, b ; &&
  pop a
  pop d
  mov [d], b
;; return pass; 
  lea d, [bp + -3] ; $pass
  mov b, [d]
  leave
  ret

test0_subTest0:
  enter 0 ; (push bp; mov bp, sp)
; $pass 
  mov a, $1
  mov [bp + -1], a
  sub sp, 2
;; pass = pass && c == 'A'; 
  lea d, [bp + -1] ; $pass
  push d
  lea d, [bp + -1] ; $pass
  mov b, [d]
  push a
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $41
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  pop d
  mov [d], b
;; pass = pass && i == 55; 
  lea d, [bp + -1] ; $pass
  push d
  lea d, [bp + -1] ; $pass
  mov b, [d]
  push a
  mov a, b
  lea d, [bp + 6] ; $i
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $37
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  pop d
  mov [d], b
;; pass = pass && ca[0] == 'A'; 
  lea d, [bp + -1] ; $pass
  push d
  lea d, [bp + -1] ; $pass
  mov b, [d]
  push a
  mov a, b
  mov b, [bp + 8] ; $ca
  mov d, b
  push a
  push d
  mov b, $0
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $41
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  pop d
  mov [d], b
;; pass = pass && ca[1] == 'B'; 
  lea d, [bp + -1] ; $pass
  push d
  lea d, [bp + -1] ; $pass
  mov b, [d]
  push a
  mov a, b
  mov b, [bp + 8] ; $ca
  mov d, b
  push a
  push d
  mov b, $1
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $42
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  pop d
  mov [d], b
;; pass = pass && ca[2] == 'C'; 
  lea d, [bp + -1] ; $pass
  push d
  lea d, [bp + -1] ; $pass
  mov b, [d]
  push a
  mov a, b
  mov b, [bp + 8] ; $ca
  mov d, b
  push a
  push d
  mov b, $2
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $43
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  pop d
  mov [d], b
;; pass = pass && ca[3] == 'D'; 
  lea d, [bp + -1] ; $pass
  push d
  lea d, [bp + -1] ; $pass
  mov b, [d]
  push a
  mov a, b
  mov b, [bp + 8] ; $ca
  mov d, b
  push a
  push d
  mov b, $3
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $44
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  pop d
  mov [d], b
;; pass = pass && ca[4] == 'E'; 
  lea d, [bp + -1] ; $pass
  push d
  lea d, [bp + -1] ; $pass
  mov b, [d]
  push a
  mov a, b
  mov b, [bp + 8] ; $ca
  mov d, b
  push a
  push d
  mov b, $4
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $45
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  pop d
  mov [d], b
;; pass = pass && ia[0] == 0; 
  lea d, [bp + -1] ; $pass
  push d
  lea d, [bp + -1] ; $pass
  mov b, [d]
  push a
  mov a, b
  mov b, [bp + 10] ; $ia
  mov d, b
  push a
  push d
  mov b, $0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  pop d
  mov [d], b
;; pass = pass && ia[1] == 1; 
  lea d, [bp + -1] ; $pass
  push d
  lea d, [bp + -1] ; $pass
  mov b, [d]
  push a
  mov a, b
  mov b, [bp + 10] ; $ia
  mov d, b
  push a
  push d
  mov b, $1
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $1
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  pop d
  mov [d], b
;; pass = pass && ia[2] == 2; 
  lea d, [bp + -1] ; $pass
  push d
  lea d, [bp + -1] ; $pass
  mov b, [d]
  push a
  mov a, b
  mov b, [bp + 10] ; $ia
  mov d, b
  push a
  push d
  mov b, $2
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $2
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  pop d
  mov [d], b
;; pass = pass && ia[3] == 3; 
  lea d, [bp + -1] ; $pass
  push d
  lea d, [bp + -1] ; $pass
  mov b, [d]
  push a
  mov a, b
  mov b, [bp + 10] ; $ia
  mov d, b
  push a
  push d
  mov b, $3
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $3
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  pop d
  mov [d], b
;; pass = pass && ia[4] == 4; 
  lea d, [bp + -1] ; $pass
  push d
  lea d, [bp + -1] ; $pass
  mov b, [d]
  push a
  mov a, b
  mov b, [bp + 10] ; $ia
  mov d, b
  push a
  push d
  mov b, $4
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $4
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  pop d
  mov [d], b
;; return pass; 
  lea d, [bp + -1] ; $pass
  mov b, [d]
  leave
  ret

test1:
  enter 0 ; (push bp; mov bp, sp)
; $pass 
  mov a, $1
  mov [bp + -1], a
; $ca 
; $p 
  sub sp, 9
;; p = ca; 
  lea d, [bp + -8] ; $p
  push d
  lea d, [bp + -6] ; $ca
  mov b, d
  pop d
  mov [d], b
;; ca[0] = 'A'; 
  lea d, [bp + -6] ; $ca
  push a
  push d
  mov b, $0
  pop d
  add d, b
  pop a
  push d
  mov b, $41
  pop d
  mov [d], bl
;; ca[1] = 'B'; 
  lea d, [bp + -6] ; $ca
  push a
  push d
  mov b, $1
  pop d
  add d, b
  pop a
  push d
  mov b, $42
  pop d
  mov [d], bl
;; ca[2] = 'C'; 
  lea d, [bp + -6] ; $ca
  push a
  push d
  mov b, $2
  pop d
  add d, b
  pop a
  push d
  mov b, $43
  pop d
  mov [d], bl
;; ca[3] = 'D'; 
  lea d, [bp + -6] ; $ca
  push a
  push d
  mov b, $3
  pop d
  add d, b
  pop a
  push d
  mov b, $44
  pop d
  mov [d], bl
;; ca[4] = 'E'; 
  lea d, [bp + -6] ; $ca
  push a
  push d
  mov b, $4
  pop d
  add d, b
  pop a
  push d
  mov b, $45
  pop d
  mov [d], bl
;; pass = pass && *p == 'A'; 
  lea d, [bp + -1] ; $pass
  push d
  lea d, [bp + -1] ; $pass
  mov b, [d]
  push a
  mov a, b
  lea d, [bp + -8] ; $p
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $41
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  pop d
  mov [d], b
;; pass = pass && *(p + 1) == 'B'; 
  lea d, [bp + -1] ; $pass
  push d
  lea d, [bp + -1] ; $pass
  mov b, [d]
  push a
  mov a, b
  lea d, [bp + -8] ; $p
  mov b, [d]
; START TERMS
  push a
  mov a, b
  mov b, $1
  add b, a
  pop a
; END TERMS
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $42
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  pop d
  mov [d], b
;; pass = pass && *(p + 2) == 'C'; 
  lea d, [bp + -1] ; $pass
  push d
  lea d, [bp + -1] ; $pass
  mov b, [d]
  push a
  mov a, b
  lea d, [bp + -8] ; $p
  mov b, [d]
; START TERMS
  push a
  mov a, b
  mov b, $2
  add b, a
  pop a
; END TERMS
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $43
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  pop d
  mov [d], b
;; pass = pass && *(p + 3) == 'D'; 
  lea d, [bp + -1] ; $pass
  push d
  lea d, [bp + -1] ; $pass
  mov b, [d]
  push a
  mov a, b
  lea d, [bp + -8] ; $p
  mov b, [d]
; START TERMS
  push a
  mov a, b
  mov b, $3
  add b, a
  pop a
; END TERMS
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $44
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  pop d
  mov [d], b
;; pass = pass && *(p + 4) == 'E'; 
  lea d, [bp + -1] ; $pass
  push d
  lea d, [bp + -1] ; $pass
  mov b, [d]
  push a
  mov a, b
  lea d, [bp + -8] ; $p
  mov b, [d]
; START TERMS
  push a
  mov a, b
  mov b, $4
  add b, a
  pop a
; END TERMS
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $45
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  pop d
  mov [d], b
;; return pass; 
  lea d, [bp + -1] ; $pass
  mov b, [d]
  leave
  ret

test2:
  enter 0 ; (push bp; mov bp, sp)
; $pass 
  mov a, $1
  mov [bp + -1], a
; $ca 
; $indices 
; $p 
  sub sp, 19
;; p = ca; 
  lea d, [bp + -18] ; $p
  push d
  lea d, [bp + -6] ; $ca
  mov b, d
  pop d
  mov [d], b
;; ca[0] = 'A'; 
  lea d, [bp + -6] ; $ca
  push a
  push d
  mov b, $0
  pop d
  add d, b
  pop a
  push d
  mov b, $41
  pop d
  mov [d], bl
;; ca[1] = 'B'; 
  lea d, [bp + -6] ; $ca
  push a
  push d
  mov b, $1
  pop d
  add d, b
  pop a
  push d
  mov b, $42
  pop d
  mov [d], bl
;; ca[2] = 'C'; 
  lea d, [bp + -6] ; $ca
  push a
  push d
  mov b, $2
  pop d
  add d, b
  pop a
  push d
  mov b, $43
  pop d
  mov [d], bl
;; ca[3] = 'D'; 
  lea d, [bp + -6] ; $ca
  push a
  push d
  mov b, $3
  pop d
  add d, b
  pop a
  push d
  mov b, $44
  pop d
  mov [d], bl
;; ca[4] = 'E'; 
  lea d, [bp + -6] ; $ca
  push a
  push d
  mov b, $4
  pop d
  add d, b
  pop a
  push d
  mov b, $45
  pop d
  mov [d], bl
;; indices[0] = 0; 
  lea d, [bp + -16] ; $indices
  push a
  push d
  mov b, $0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov b, $0
  pop d
  mov [d], b
;; indices[1] = 1; 
  lea d, [bp + -16] ; $indices
  push a
  push d
  mov b, $1
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov b, $1
  pop d
  mov [d], b
;; indices[2] = 2; 
  lea d, [bp + -16] ; $indices
  push a
  push d
  mov b, $2
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov b, $2
  pop d
  mov [d], b
;; indices[3] = 3; 
  lea d, [bp + -16] ; $indices
  push a
  push d
  mov b, $3
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov b, $3
  pop d
  mov [d], b
;; indices[4] = 4; 
  lea d, [bp + -16] ; $indices
  push a
  push d
  mov b, $4
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov b, $4
  pop d
  mov [d], b
;; pass = pass && *(p + indices[0]) == 'A'; 
  lea d, [bp + -1] ; $pass
  push d
  lea d, [bp + -1] ; $pass
  mov b, [d]
  push a
  mov a, b
  lea d, [bp + -18] ; $p
  mov b, [d]
; START TERMS
  push a
  mov a, b
  lea d, [bp + -16] ; $indices
  push a
  push d
  mov b, $0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  add b, a
  pop a
; END TERMS
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $41
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  pop d
  mov [d], b
;; pass = pass && *(p + indices[1]) == 'B'; 
  lea d, [bp + -1] ; $pass
  push d
  lea d, [bp + -1] ; $pass
  mov b, [d]
  push a
  mov a, b
  lea d, [bp + -18] ; $p
  mov b, [d]
; START TERMS
  push a
  mov a, b
  lea d, [bp + -16] ; $indices
  push a
  push d
  mov b, $1
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  add b, a
  pop a
; END TERMS
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $42
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  pop d
  mov [d], b
;; pass = pass && *(p + indices[2]) == 'C'; 
  lea d, [bp + -1] ; $pass
  push d
  lea d, [bp + -1] ; $pass
  mov b, [d]
  push a
  mov a, b
  lea d, [bp + -18] ; $p
  mov b, [d]
; START TERMS
  push a
  mov a, b
  lea d, [bp + -16] ; $indices
  push a
  push d
  mov b, $2
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  add b, a
  pop a
; END TERMS
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $43
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  pop d
  mov [d], b
;; pass = pass && *(p + indices[3]) == 'D'; 
  lea d, [bp + -1] ; $pass
  push d
  lea d, [bp + -1] ; $pass
  mov b, [d]
  push a
  mov a, b
  lea d, [bp + -18] ; $p
  mov b, [d]
; START TERMS
  push a
  mov a, b
  lea d, [bp + -16] ; $indices
  push a
  push d
  mov b, $3
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  add b, a
  pop a
; END TERMS
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $44
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  pop d
  mov [d], b
;; pass = pass && *(p + indices[4]) == 'E'; 
  lea d, [bp + -1] ; $pass
  push d
  lea d, [bp + -1] ; $pass
  mov b, [d]
  push a
  mov a, b
  lea d, [bp + -18] ; $p
  mov b, [d]
; START TERMS
  push a
  mov a, b
  lea d, [bp + -16] ; $indices
  push a
  push d
  mov b, $4
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  add b, a
  pop a
; END TERMS
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $45
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  pop d
  mov [d], b
;; return pass; 
  lea d, [bp + -1] ; $pass
  mov b, [d]
  leave
  ret

test3:
  enter 0 ; (push bp; mov bp, sp)
; $pass 
  mov a, $1
  mov [bp + -1], a
  sub sp, 2
;; st.c = 'A'; 
  lea d, [bp + 5] ; $st
  add d, 0
  push d
  mov b, $41
  pop d
  mov [d], bl
;; st.i = 277; 
  lea d, [bp + 5] ; $st
  add d, 1
  push d
  mov b, $115
  pop d
  mov [d], b
;; st.m[0] = 0; 
  lea d, [bp + 5] ; $st
  add d, 3
  push a
  push d
  mov b, $0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov b, $0
  pop d
  mov [d], b
;; st.m[1] = 1; 
  lea d, [bp + 5] ; $st
  add d, 3
  push a
  push d
  mov b, $1
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov b, $1
  pop d
  mov [d], b
;; st.m[2] = 2; 
  lea d, [bp + 5] ; $st
  add d, 3
  push a
  push d
  mov b, $2
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov b, $2
  pop d
  mov [d], b
;; st.m[3] = 3; 
  lea d, [bp + 5] ; $st
  add d, 3
  push a
  push d
  mov b, $3
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov b, $3
  pop d
  mov [d], b
;; st.m[4] = 4; 
  lea d, [bp + 5] ; $st
  add d, 3
  push a
  push d
  mov b, $4
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov b, $4
  pop d
  mov [d], b
;; pass = pass && st.c == 'A'; 
  lea d, [bp + -1] ; $pass
  push d
  lea d, [bp + -1] ; $pass
  mov b, [d]
  push a
  mov a, b
  lea d, [bp + 5] ; $st
  add d, 0
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $41
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  pop d
  mov [d], b
;; pass = pass && st.i == 277; 
  lea d, [bp + -1] ; $pass
  push d
  lea d, [bp + -1] ; $pass
  mov b, [d]
  push a
  mov a, b
  lea d, [bp + 5] ; $st
  add d, 1
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $115
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  pop d
  mov [d], b
;; pass = pass && st.m[0] == 0; 
  lea d, [bp + -1] ; $pass
  push d
  lea d, [bp + -1] ; $pass
  mov b, [d]
  push a
  mov a, b
  lea d, [bp + 5] ; $st
  add d, 3
  push a
  push d
  mov b, $0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  pop d
  mov [d], b
;; pass = pass && st.m[1] == 1; 
  lea d, [bp + -1] ; $pass
  push d
  lea d, [bp + -1] ; $pass
  mov b, [d]
  push a
  mov a, b
  lea d, [bp + 5] ; $st
  add d, 3
  push a
  push d
  mov b, $1
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $1
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  pop d
  mov [d], b
;; pass = pass && st.m[2] == 2; 
  lea d, [bp + -1] ; $pass
  push d
  lea d, [bp + -1] ; $pass
  mov b, [d]
  push a
  mov a, b
  lea d, [bp + 5] ; $st
  add d, 3
  push a
  push d
  mov b, $2
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $2
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  pop d
  mov [d], b
;; pass = pass && st.m[3] == 3; 
  lea d, [bp + -1] ; $pass
  push d
  lea d, [bp + -1] ; $pass
  mov b, [d]
  push a
  mov a, b
  lea d, [bp + 5] ; $st
  add d, 3
  push a
  push d
  mov b, $3
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $3
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  pop d
  mov [d], b
;; pass = pass && st.m[4] == 4; 
  lea d, [bp + -1] ; $pass
  push d
  lea d, [bp + -1] ; $pass
  mov b, [d]
  push a
  mov a, b
  lea d, [bp + 5] ; $st
  add d, 3
  push a
  push d
  mov b, $4
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $4
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  pop d
  mov [d], b
;; return pass; 
  lea d, [bp + -1] ; $pass
  mov b, [d]
  leave
  ret
; --- END TEXT BLOCK

; --- BEGIN DATA BLOCK
_base64_table_data: .db "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/", 0
_base64_table: .dw _base64_table_data
_st1_data: .fill 13, 0
__s0: .db "Test %d, Result: %d\n", 0
__s1: .db "Unexpected format in printf.", 0
__s2: .db "Error: Unknown argument type.\n", 0
__s3: .db "\033[2J\033[H", 0

_heap_top: .dw _heap
_heap: .db 0
; --- END DATA BLOCK

.end