; --- FILENAME: games/startrek.c
; --- DATE:     08-07-2025 at 11:41:51
.include "lib/asm/kernel.exp"
.include "lib/asm/bios.exp"

; --- BEGIN TEXT SEGMENT
.org text_org
main:
  mov bp, $FFE0 ;
  mov sp, $FFE0 ; Make space for argc(2 bytes) and for 10 pointers in argv (local variables)
; intro(); 
; --- START FUNCTION CALL
  call intro
; new_game(); 
; --- START FUNCTION CALL
  call new_game
; return 0; 
  mov32 cb, $00000000
  leave
  syscall sys_terminate_proc

TO_FIXED:
  enter 0 ; (push bp; mov bp, sp)
; return x * 10; 
  lea d, [bp + 5] ; $x
  mov b, [d]
  mov c, 0
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $0000000a
  push a     ; save left operand
  xor a, b   ; xor sign bits
  swp a      ; swap bytes
  mov cl, al ; save result of xor into 'dl'
  pop a      ; restore left side operator
  push cl    ; save result of xor above
  swp a  
  test al, $80  
  swp a  
  jz skip_invert_a_2  
  neg a 
skip_invert_a_2:   
  swp b
  test bl, $80  
  swp b
  jz skip_invert_b_2  
  neg b 
skip_invert_b_2:   
  mul a, b ; *
  mov g, a
  mov a, b
  pop bl
  test bl, $80
  jz _same_signs_2
  mov bl, al
  not a
  neg b
  adc a, 0
  mov g, a
  mov a, b
_same_signs_2:
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  leave
  ret

FROM_FIXED:
  enter 0 ; (push bp; mov bp, sp)
; return x / 10; 
  lea d, [bp + 5] ; $x
  mov b, [d]
  mov c, 0
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $0000000a
  push g ; save 'g' as the div instruction uses it
  div a, b ; /, a: quotient, b: remainder
  pop g
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  leave
  ret

TO_FIXED00:
  enter 0 ; (push bp; mov bp, sp)
; return x * 100; 
  lea d, [bp + 5] ; $x
  mov b, [d]
  mov c, 0
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $00000064
  push a     ; save left operand
  xor a, b   ; xor sign bits
  swp a      ; swap bytes
  mov cl, al ; save result of xor into 'dl'
  pop a      ; restore left side operator
  push cl    ; save result of xor above
  swp a  
  test al, $80  
  swp a  
  jz skip_invert_a_6  
  neg a 
skip_invert_a_6:   
  swp b
  test bl, $80  
  swp b
  jz skip_invert_b_6  
  neg b 
skip_invert_b_6:   
  mul a, b ; *
  mov g, a
  mov a, b
  pop bl
  test bl, $80
  jz _same_signs_6
  mov bl, al
  not a
  neg b
  adc a, 0
  mov g, a
  mov a, b
_same_signs_6:
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  leave
  ret

FROM_FIXED00:
  enter 0 ; (push bp; mov bp, sp)
; return x / 100; 
  lea d, [bp + 5] ; $x
  mov b, [d]
  mov c, 0
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $00000064
  push g ; save 'g' as the div instruction uses it
  div a, b ; /, a: quotient, b: remainder
  pop g
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  leave
  ret

get_rand:
  enter 0 ; (push bp; mov bp, sp)
; unsigned int         r ; 
  sub sp, 2
; r = rand(); 
  lea d, [bp + -1] ; $r
  push d
; --- START FUNCTION CALL
  call rand
  pop d
  mov [d], b
; r = (r >> 8) | (r << 8); 
  lea d, [bp + -1] ; $r
  push d
  lea d, [bp + -1] ; $r
  mov b, [d]
  mov c, 0
; --- START SHIFT
  push a
  mov a, b
  mov32 cb, $00000008
  mov c, b
  shr a, cl
  mov b, a
  pop a
; --- END SHIFT
  push a
  mov a, b
  lea d, [bp + -1] ; $r
  mov b, [d]
  mov c, 0
; --- START SHIFT
  push a
  mov a, b
  mov32 cb, $00000008
  mov c, b
  shl a, cl
  mov b, a
  pop a
; --- END SHIFT
  or b, a ; |
  pop a
  pop d
  mov [d], b
; return ((r % spread) + 1); 
  lea d, [bp + -1] ; $r
  mov b, [d]
  mov c, 0
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  lea d, [bp + 5] ; $spread
  mov b, [d]
  mov c, 0
  push g ; save 'g' as the div instruction uses it
  div a, b ; %, a: quotient, b: remainder
  mov a, b
  pop g
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000001
  add b, a
  pop a
; --- END TERMS
  leave
  ret

rand8:
  enter 0 ; (push bp; mov bp, sp)
; return (get_rand(8)); 
; --- START FUNCTION CALL
  mov32 cb, $00000008
  swp b
  push b
  call get_rand
  add sp, 2
; --- END FUNCTION CALL
  leave
  ret

input:
  enter 0 ; (push bp; mov bp, sp)
; int c; 
  sub sp, 2
; while((c = getchar()) != '\n') { 
_while17_cond:
  lea d, [bp + -1] ; $c
  push d
; --- START FUNCTION CALL
  call getchar
  pop d
  mov [d], b
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $0000000a
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _while17_exit
_while17_block:
; if (c == -1) 
_if18_cond:
  lea d, [bp + -1] ; $c
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $ffffffff
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if18_exit
_if18_TRUE:
; exit(1); 
; --- START FUNCTION CALL
  mov32 cb, $00000001
  swp b
  push b
  call exit
  add sp, 2
; --- END FUNCTION CALL
  jmp _if18_exit
_if18_exit:
; if (l > 1) { 
_if19_cond:
  lea d, [bp + 7] ; $l
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000001
  cmp a, b
  sgu ; > (unsigned)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if19_exit
_if19_TRUE:
; *b++ = c; 
  lea d, [bp + 5] ; $b
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + 5] ; $b
  mov [d], b
  dec b
  push b
  lea d, [bp + -1] ; $c
  mov b, [d]
  mov c, 0
  pop d
  mov [d], bl
; l--; 
  lea d, [bp + 7] ; $l
  mov bl, [d]
  mov bh, 0
  mov c, 0
  dec b
  lea d, [bp + 7] ; $l
  mov [d], bl
  inc b
  jmp _if19_exit
_if19_exit:
  jmp _while17_cond
_while17_exit:
; *b = 0; 
  lea d, [bp + 5] ; $b
  mov b, [d]
  mov c, 0
  push b
  mov32 cb, $00000000
  pop d
  mov [d], bl
  leave
  ret

yesno:
  enter 0 ; (push bp; mov bp, sp)
; char b[2]; 
  sub sp, 2
; input(b,2); 
; --- START FUNCTION CALL
  mov32 cb, $00000002
  push bl
  lea d, [bp + -1] ; $b
  mov b, d
  mov c, 0
  swp b
  push b
  call input
  add sp, 3
; --- END FUNCTION CALL
; tolower(*b); 
; --- START FUNCTION CALL
  lea d, [bp + -1] ; $b
  mov b, d
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push bl
  call tolower
  add sp, 1
; --- END FUNCTION CALL
; return 1; 
  mov32 cb, $00000001
  leave
  ret
; return 0; 
  mov32 cb, $00000000
  leave
  ret

input_f00:
  enter 0 ; (push bp; mov bp, sp)
; int        v; 
  sub sp, 2
; char buf[8]; 
  sub sp, 8
; char *x; 
  sub sp, 2
; input(buf, 8); 
; --- START FUNCTION CALL
  mov32 cb, $00000008
  push bl
  lea d, [bp + -9] ; $buf
  mov b, d
  mov c, 0
  swp b
  push b
  call input
  add sp, 3
; --- END FUNCTION CALL
; x = buf; 
  lea d, [bp + -11] ; $x
  push d
  lea d, [bp + -9] ; $buf
  mov b, d
  mov c, 0
  pop d
  mov [d], b
; if (!is_digit(*x)) 
_if20_cond:
; --- START FUNCTION CALL
  lea d, [bp + -11] ; $x
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push bl
  call is_digit
  add sp, 1
; --- END FUNCTION CALL
  cmp b, 0
  je _if20_exit
_if20_TRUE:
; return -1; 
  mov32 cb, $ffffffff
  leave
  ret
  jmp _if20_exit
_if20_exit:
; v = 100 * (*x++ - '0'); 
  lea d, [bp + -1] ; $v
  push d
  mov32 cb, $00000064
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  lea d, [bp + -11] ; $x
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -11] ; $x
  mov [d], b
  dec b
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000030
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  push a     ; save left operand
  xor a, b   ; xor sign bits
  swp a      ; swap bytes
  mov cl, al ; save result of xor into 'dl'
  pop a      ; restore left side operator
  push cl    ; save result of xor above
  swp a  
  test al, $80  
  swp a  
  jz skip_invert_a_22  
  neg a 
skip_invert_a_22:   
  swp b
  test bl, $80  
  swp b
  jz skip_invert_b_22  
  neg b 
skip_invert_b_22:   
  mul a, b ; *
  mov g, a
  mov a, b
  pop bl
  test bl, $80
  jz _same_signs_22
  mov bl, al
  not a
  neg b
  adc a, 0
  mov g, a
  mov a, b
_same_signs_22:
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  pop d
  mov [d], b
; if (*x == 0) 
_if23_cond:
  lea d, [bp + -11] ; $x
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if23_exit
_if23_TRUE:
; return v; 
  lea d, [bp + -1] ; $v
  mov b, [d]
  mov c, 0
  leave
  ret
  jmp _if23_exit
_if23_exit:
; if (*x++ != '.') 
_if24_cond:
  lea d, [bp + -11] ; $x
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -11] ; $x
  mov [d], b
  dec b
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $0000002e
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if24_exit
_if24_TRUE:
; return -1; 
  mov32 cb, $ffffffff
  leave
  ret
  jmp _if24_exit
_if24_exit:
; if (!is_digit(*x)) 
_if25_cond:
; --- START FUNCTION CALL
  lea d, [bp + -11] ; $x
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push bl
  call is_digit
  add sp, 1
; --- END FUNCTION CALL
  cmp b, 0
  je _if25_exit
_if25_TRUE:
; return -1; 
  mov32 cb, $ffffffff
  leave
  ret
  jmp _if25_exit
_if25_exit:
; v = v + 10 * (*x++ - '0'); 
  lea d, [bp + -1] ; $v
  push d
  lea d, [bp + -1] ; $v
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $0000000a
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  lea d, [bp + -11] ; $x
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -11] ; $x
  mov [d], b
  dec b
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000030
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  push a     ; save left operand
  xor a, b   ; xor sign bits
  swp a      ; swap bytes
  mov cl, al ; save result of xor into 'dl'
  pop a      ; restore left side operator
  push cl    ; save result of xor above
  swp a  
  test al, $80  
  swp a  
  jz skip_invert_a_27  
  neg a 
skip_invert_a_27:   
  swp b
  test bl, $80  
  swp b
  jz skip_invert_b_27  
  neg b 
skip_invert_b_27:   
  mul a, b ; *
  mov g, a
  mov a, b
  pop bl
  test bl, $80
  jz _same_signs_27
  mov bl, al
  not a
  neg b
  adc a, 0
  mov g, a
  mov a, b
_same_signs_27:
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; if (!*x) 
_if28_cond:
  lea d, [bp + -11] ; $x
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  cmp b, 0
  seq ; !
  cmp b, 0
  je _if28_exit
_if28_TRUE:
; return v; 
  lea d, [bp + -1] ; $v
  mov b, [d]
  mov c, 0
  leave
  ret
  jmp _if28_exit
_if28_exit:
; if (!is_digit(*x)) 
_if29_cond:
; --- START FUNCTION CALL
  lea d, [bp + -11] ; $x
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push bl
  call is_digit
  add sp, 1
; --- END FUNCTION CALL
  cmp b, 0
  je _if29_exit
_if29_TRUE:
; return -1; 
  mov32 cb, $ffffffff
  leave
  ret
  jmp _if29_exit
_if29_exit:
; v = v + *x++ - '0'; 
  lea d, [bp + -1] ; $v
  push d
  lea d, [bp + -1] ; $v
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -11] ; $x
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -11] ; $x
  mov [d], b
  dec b
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  add b, a
  mov a, b
  mov32 cb, $00000030
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; return v; 
  lea d, [bp + -1] ; $v
  mov b, [d]
  mov c, 0
  leave
  ret

input_int:
  enter 0 ; (push bp; mov bp, sp)
; char x[8]; 
  sub sp, 8
; input(x, 8); 
; --- START FUNCTION CALL
  mov32 cb, $00000008
  push bl
  lea d, [bp + -7] ; $x
  mov b, d
  mov c, 0
  swp b
  push b
  call input
  add sp, 3
; --- END FUNCTION CALL
; if (!is_digit(*x)) 
_if30_cond:
; --- START FUNCTION CALL
  lea d, [bp + -7] ; $x
  mov b, d
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push bl
  call is_digit
  add sp, 1
; --- END FUNCTION CALL
  cmp b, 0
  je _if30_exit
_if30_TRUE:
; return -1; 
  mov32 cb, $ffffffff
  leave
  ret
  jmp _if30_exit
_if30_exit:
; return atoi(x); 
; --- START FUNCTION CALL
  lea d, [bp + -7] ; $x
  mov b, d
  mov c, 0
  swp b
  push b
  call atoi
  add sp, 2
; --- END FUNCTION CALL
  leave
  ret

print100:
  enter 0 ; (push bp; mov bp, sp)
; static char buf[16]; 
  sub sp, 16
; char *p; 
  sub sp, 2
; *p = buf; 
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov c, 0
  push b
  mov d, st_print100_buf_dt ; static buf
  mov b, d
  mov c, 0
  pop d
  mov [d], bl
; if (v < 0) { 
_if31_cond:
  lea d, [bp + 5] ; $v
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if31_exit
_if31_TRUE:
; v = -v; 
  lea d, [bp + 5] ; $v
  push d
  lea d, [bp + 5] ; $v
  mov b, [d]
  mov c, 0
  neg b
  pop d
  mov [d], b
; *p++ = '-'; 
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -1] ; $p
  mov [d], b
  dec b
  push b
  mov32 cb, $0000002d
  pop d
  mov [d], bl
  jmp _if31_exit
_if31_exit:
; return buf; 
  mov d, st_print100_buf_dt ; static buf
  mov b, d
  mov c, 0
  leave
  ret

inoperable:
  enter 0 ; (push bp; mov bp, sp)
; if (damage[u] < 0) { 
_if32_cond:
  mov d, _damage_data ; $damage
  push a
  push d
  lea d, [bp + 5] ; $u
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if32_exit
_if32_TRUE:
; printf("%s %s inoperable.\n", 
; --- START FUNCTION CALL
_ternary34_cond:
  lea d, [bp + 5] ; $u
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000005
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _ternary34_FALSE
_ternary34_TRUE:
  mov b, _s30 ; "are"
  jmp _ternary34_exit
_ternary34_FALSE:
  mov b, _s31 ; "is"
_ternary34_exit:
  swp b
  push b
; --- START FUNCTION CALL
  lea d, [bp + 5] ; $u
  mov bl, [d]
  mov bh, 0
  mov c, 0
  snex b
  swp b
  push b
  call get_device_name
  add sp, 2
; --- END FUNCTION CALL
  swp b
  push b
  mov b, _s32 ; "%s %s inoperable.\n"
  swp b
  push b
  call printf
  add sp, 6
; --- END FUNCTION CALL
; return 1; 
  mov32 cb, $00000001
  leave
  ret
  jmp _if32_exit
_if32_exit:
; return 0; 
  mov32 cb, $00000000
  leave
  ret

intro:
  enter 0 ; (push bp; mov bp, sp)
; showfile("startrek.intro"); 
; --- START FUNCTION CALL
  mov b, _s33 ; "startrek.intro"
  swp b
  push b
  call showfile
  add sp, 2
; --- END FUNCTION CALL
; if (yesno()) 
_if35_cond:
; --- START FUNCTION CALL
  call yesno
  cmp b, 0
  je _if35_exit
_if35_TRUE:
; showfile("startrek.doc"); 
; --- START FUNCTION CALL
  mov b, _s34 ; "startrek.doc"
  swp b
  push b
  call showfile
  add sp, 2
; --- END FUNCTION CALL
  jmp _if35_exit
_if35_exit:
; showfile("startrek.logo"); 
; --- START FUNCTION CALL
  mov b, _s35 ; "startrek.logo"
  swp b
  push b
  call showfile
  add sp, 2
; --- END FUNCTION CALL
; stardate = TO_FIXED((get_rand(20) + 20) * 100); 
  mov d, _stardate ; $stardate
  push d
; --- START FUNCTION CALL
; --- START FUNCTION CALL
  mov32 cb, $00000014
  swp b
  push b
  call get_rand
  add sp, 2
; --- END FUNCTION CALL
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000014
  add b, a
  pop a
; --- END TERMS
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $00000064
  push a     ; save left operand
  xor a, b   ; xor sign bits
  swp a      ; swap bytes
  mov cl, al ; save result of xor into 'dl'
  pop a      ; restore left side operator
  push cl    ; save result of xor above
  swp a  
  test al, $80  
  swp a  
  jz skip_invert_a_39  
  neg a 
skip_invert_a_39:   
  swp b
  test bl, $80  
  swp b
  jz skip_invert_b_39  
  neg b 
skip_invert_b_39:   
  mul a, b ; *
  mov g, a
  mov a, b
  pop bl
  test bl, $80
  jz _same_signs_39
  mov bl, al
  not a
  neg b
  adc a, 0
  mov g, a
  mov a, b
_same_signs_39:
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  swp b
  push b
  call TO_FIXED
  add sp, 2
; --- END FUNCTION CALL
  pop d
  mov [d], b
  leave
  ret

new_game:
  enter 0 ; (push bp; mov bp, sp)
; char cmd[4]; 
  sub sp, 4
; initialize(); 
; --- START FUNCTION CALL
  call initialize
; new_quadrant(); 
; --- START FUNCTION CALL
  call new_quadrant
; short_range_scan(); 
; --- START FUNCTION CALL
  call short_range_scan
; while (1) { 
_while40_cond:
  mov32 cb, $00000001
  cmp b, 0
  je _while40_exit
_while40_block:
; if (shield + energy <= 10 && (energy < 10 || damage[7] < 0)) { 
_if41_cond:
  mov d, _shield ; $shield
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov d, _energy ; $energy
  mov b, [d]
  mov c, 0
  add b, a
  pop a
; --- END TERMS
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $0000000a
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
; --- START LOGICAL AND
  push a
  mov a, b
  mov d, _energy ; $energy
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $0000000a
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
; --- START LOGICAL OR
  push a
  mov a, b
  mov d, _damage_data ; $damage
  push a
  push d
  mov32 cb, $00000007
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  sand a, b
  pop a
; --- END LOGICAL AND
  cmp b, 0
  je _if41_exit
_if41_TRUE:
; showfile("startrek.fatal"); 
; --- START FUNCTION CALL
  mov b, _s36 ; "startrek.fatal"
  swp b
  push b
  call showfile
  add sp, 2
; --- END FUNCTION CALL
; end_of_time(); 
; --- START FUNCTION CALL
  call end_of_time
  jmp _if41_exit
_if41_exit:
; puts("Command? "); 
; --- START FUNCTION CALL
  mov b, _s37 ; "Command? "
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; input(cmd, 4); 
; --- START FUNCTION CALL
  mov32 cb, $00000004
  push bl
  lea d, [bp + -3] ; $cmd
  mov b, d
  mov c, 0
  swp b
  push b
  call input
  add sp, 3
; --- END FUNCTION CALL
; putchar('\n'); 
; --- START FUNCTION CALL
  mov32 cb, $0000000a
  push bl
  call putchar
  add sp, 1
; --- END FUNCTION CALL
; if (!strncmp(cmd, "nav", 3)) 
_if42_cond:
; --- START FUNCTION CALL
  mov32 cb, $00000003
  swp b
  push b
  mov b, _s38 ; "nav"
  swp b
  push b
  lea d, [bp + -3] ; $cmd
  mov b, d
  mov c, 0
  swp b
  push b
  call strncmp
  add sp, 6
; --- END FUNCTION CALL
  cmp b, 0
  je _if42_else
_if42_TRUE:
; course_control(); 
; --- START FUNCTION CALL
  call course_control
  jmp _if42_exit
_if42_else:
; if (!strncmp(cmd, "srs", 3)) 
_if43_cond:
; --- START FUNCTION CALL
  mov32 cb, $00000003
  swp b
  push b
  mov b, _s39 ; "srs"
  swp b
  push b
  lea d, [bp + -3] ; $cmd
  mov b, d
  mov c, 0
  swp b
  push b
  call strncmp
  add sp, 6
; --- END FUNCTION CALL
  cmp b, 0
  je _if43_else
_if43_TRUE:
; short_range_scan(); 
; --- START FUNCTION CALL
  call short_range_scan
  jmp _if43_exit
_if43_else:
; if (!strncmp(cmd, "lrs", 3)) 
_if44_cond:
; --- START FUNCTION CALL
  mov32 cb, $00000003
  swp b
  push b
  mov b, _s40 ; "lrs"
  swp b
  push b
  lea d, [bp + -3] ; $cmd
  mov b, d
  mov c, 0
  swp b
  push b
  call strncmp
  add sp, 6
; --- END FUNCTION CALL
  cmp b, 0
  je _if44_else
_if44_TRUE:
; long_range_scan(); 
; --- START FUNCTION CALL
  call long_range_scan
  jmp _if44_exit
_if44_else:
; if (!strncmp(cmd, "pha", 3)) 
_if45_cond:
; --- START FUNCTION CALL
  mov32 cb, $00000003
  swp b
  push b
  mov b, _s41 ; "pha"
  swp b
  push b
  lea d, [bp + -3] ; $cmd
  mov b, d
  mov c, 0
  swp b
  push b
  call strncmp
  add sp, 6
; --- END FUNCTION CALL
  cmp b, 0
  je _if45_else
_if45_TRUE:
; phaser_control(); 
; --- START FUNCTION CALL
  call phaser_control
  jmp _if45_exit
_if45_else:
; if (!strncmp(cmd, "tor", 3)) 
_if46_cond:
; --- START FUNCTION CALL
  mov32 cb, $00000003
  swp b
  push b
  mov b, _s42 ; "tor"
  swp b
  push b
  lea d, [bp + -3] ; $cmd
  mov b, d
  mov c, 0
  swp b
  push b
  call strncmp
  add sp, 6
; --- END FUNCTION CALL
  cmp b, 0
  je _if46_else
_if46_TRUE:
; photon_torpedoes(); 
; --- START FUNCTION CALL
  call photon_torpedoes
  jmp _if46_exit
_if46_else:
; if (!strncmp(cmd, "shi", 3)) 
_if47_cond:
; --- START FUNCTION CALL
  mov32 cb, $00000003
  swp b
  push b
  mov b, _s43 ; "shi"
  swp b
  push b
  lea d, [bp + -3] ; $cmd
  mov b, d
  mov c, 0
  swp b
  push b
  call strncmp
  add sp, 6
; --- END FUNCTION CALL
  cmp b, 0
  je _if47_else
_if47_TRUE:
; shield_control(); 
; --- START FUNCTION CALL
  call shield_control
  jmp _if47_exit
_if47_else:
; if (!strncmp(cmd, "dam", 3)) 
_if48_cond:
; --- START FUNCTION CALL
  mov32 cb, $00000003
  swp b
  push b
  mov b, _s44 ; "dam"
  swp b
  push b
  lea d, [bp + -3] ; $cmd
  mov b, d
  mov c, 0
  swp b
  push b
  call strncmp
  add sp, 6
; --- END FUNCTION CALL
  cmp b, 0
  je _if48_else
_if48_TRUE:
; damage_control(); 
; --- START FUNCTION CALL
  call damage_control
  jmp _if48_exit
_if48_else:
; if (!strncmp(cmd, "com", 3)) 
_if49_cond:
; --- START FUNCTION CALL
  mov32 cb, $00000003
  swp b
  push b
  mov b, _s45 ; "com"
  swp b
  push b
  lea d, [bp + -3] ; $cmd
  mov b, d
  mov c, 0
  swp b
  push b
  call strncmp
  add sp, 6
; --- END FUNCTION CALL
  cmp b, 0
  je _if49_else
_if49_TRUE:
; library_computer(); 
; --- START FUNCTION CALL
  call library_computer
  jmp _if49_exit
_if49_else:
; if (!strncmp(cmd, "xxx", 3)) 
_if50_cond:
; --- START FUNCTION CALL
  mov32 cb, $00000003
  swp b
  push b
  mov b, _s46 ; "xxx"
  swp b
  push b
  lea d, [bp + -3] ; $cmd
  mov b, d
  mov c, 0
  swp b
  push b
  call strncmp
  add sp, 6
; --- END FUNCTION CALL
  cmp b, 0
  je _if50_else
_if50_TRUE:
; resign_commision(); 
; --- START FUNCTION CALL
  call resign_commision
  jmp _if50_exit
_if50_else:
; puts("Enter one of the following:\n"); 
; --- START FUNCTION CALL
  mov b, _s47 ; "Enter one of the following:\n"
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; puts("  nav - To Set Course"); 
; --- START FUNCTION CALL
  mov b, _s48 ; "  nav - To Set Course"
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; puts("  srs - Short Range Sensors"); 
; --- START FUNCTION CALL
  mov b, _s49 ; "  srs - Short Range Sensors"
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; puts("  lrs - Long Range Sensors"); 
; --- START FUNCTION CALL
  mov b, _s50 ; "  lrs - Long Range Sensors"
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; puts("  pha - Phasers"); 
; --- START FUNCTION CALL
  mov b, _s51 ; "  pha - Phasers"
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; puts("  tor - Photon Torpedoes"); 
; --- START FUNCTION CALL
  mov b, _s52 ; "  tor - Photon Torpedoes"
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; puts("  shi - Shield Control"); 
; --- START FUNCTION CALL
  mov b, _s53 ; "  shi - Shield Control"
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; puts("  dam - Damage Control"); 
; --- START FUNCTION CALL
  mov b, _s54 ; "  dam - Damage Control"
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; puts("  com - Library Computer"); 
; --- START FUNCTION CALL
  mov b, _s55 ; "  com - Library Computer"
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; puts("  xxx - Resign Command\n"); 
; --- START FUNCTION CALL
  mov b, _s56 ; "  xxx - Resign Command\n"
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
_if50_exit:
_if49_exit:
_if48_exit:
_if47_exit:
_if46_exit:
_if45_exit:
_if44_exit:
_if43_exit:
_if42_exit:
  jmp _while40_cond
_while40_exit:
  leave
  ret

initialize:
  enter 0 ; (push bp; mov bp, sp)
; int i, j; 
  sub sp, 2
  sub sp, 2
; unsigned char        yp, xp; 
  sub sp, 1
  sub sp, 1
; unsigned char        r; 
  sub sp, 1
; time_start = FROM_FIXED(stardate); 
  mov d, _time_start ; $time_start
  push d
; --- START FUNCTION CALL
  mov d, _stardate ; $stardate
  mov b, [d]
  mov c, 0
  swp b
  push b
  call FROM_FIXED
  add sp, 2
; --- END FUNCTION CALL
  pop d
  mov [d], b
; time_up = 25 + get_rand(10); 
  mov d, _time_up ; $time_up
  push d
  mov32 cb, $00000019
; --- START TERMS
  push a
  mov a, b
; --- START FUNCTION CALL
  mov32 cb, $0000000a
  swp b
  push b
  call get_rand
  add sp, 2
; --- END FUNCTION CALL
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; docked = 0; 
  mov d, _docked ; $docked
  push d
  mov32 cb, $00000000
  pop d
  mov [d], bl
; energy = energy0; 
  mov d, _energy ; $energy
  push d
  mov d, _energy0 ; $energy0
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
; torps = torps0; 
  mov d, _torps ; $torps
  push d
  mov d, _torps0 ; $torps0
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mov [d], bl
; shield = 0; 
  mov d, _shield ; $shield
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
; quad_y = rand8(); 
  mov d, _quad_y ; $quad_y
  push d
; --- START FUNCTION CALL
  call rand8
  pop d
  mov [d], b
; quad_x = rand8(); 
  mov d, _quad_x ; $quad_x
  push d
; --- START FUNCTION CALL
  call rand8
  pop d
  mov [d], b
; ship_y = TO_FIXED00(rand8()); 
  mov d, _ship_y ; $ship_y
  push d
; --- START FUNCTION CALL
; --- START FUNCTION CALL
  call rand8
  snex b
  swp b
  push b
  call TO_FIXED00
  add sp, 2
; --- END FUNCTION CALL
  pop d
  mov [d], b
; ship_x = TO_FIXED00(rand8()); 
  mov d, _ship_x ; $ship_x
  push d
; --- START FUNCTION CALL
; --- START FUNCTION CALL
  call rand8
  snex b
  swp b
  push b
  call TO_FIXED00
  add sp, 2
; --- END FUNCTION CALL
  pop d
  mov [d], b
; for (i = 1; i <= 8; i++) 
_for51_init:
  lea d, [bp + -1] ; $i
  push d
  mov32 cb, $00000001
  pop d
  mov [d], b
_for51_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000008
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for51_exit
_for51_block:
; damage[i] = 0; 
  mov d, _damage_data ; $damage
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
_for51_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  mov b, a
  jmp _for51_cond
_for51_exit:
; for (i = 1; i <= 8; i++) { 
_for52_init:
  lea d, [bp + -1] ; $i
  push d
  mov32 cb, $00000001
  pop d
  mov [d], b
_for52_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000008
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for52_exit
_for52_block:
; for (j = 1; j <= 8; j++) { 
_for53_init:
  lea d, [bp + -3] ; $j
  push d
  mov32 cb, $00000001
  pop d
  mov [d], b
_for53_cond:
  lea d, [bp + -3] ; $j
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000008
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for53_exit
_for53_block:
; r = get_rand(100); 
  lea d, [bp + -6] ; $r
  push d
; --- START FUNCTION CALL
  mov32 cb, $00000064
  swp b
  push b
  call get_rand
  add sp, 2
; --- END FUNCTION CALL
  pop d
  mov [d], bl
; klingons = 0; 
  mov d, _klingons ; $klingons
  push d
  mov32 cb, $00000000
  pop d
  mov [d], bl
; if (r > 98) 
_if54_cond:
  lea d, [bp + -6] ; $r
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000062
  cmp a, b
  sgu ; > (unsigned)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if54_else
_if54_TRUE:
; klingons = 3; 
  mov d, _klingons ; $klingons
  push d
  mov32 cb, $00000003
  pop d
  mov [d], bl
  jmp _if54_exit
_if54_else:
; if (r > 95) 
_if55_cond:
  lea d, [bp + -6] ; $r
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $0000005f
  cmp a, b
  sgu ; > (unsigned)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if55_else
_if55_TRUE:
; klingons = 2; 
  mov d, _klingons ; $klingons
  push d
  mov32 cb, $00000002
  pop d
  mov [d], bl
  jmp _if55_exit
_if55_else:
; if (r > 80) 
_if56_cond:
  lea d, [bp + -6] ; $r
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000050
  cmp a, b
  sgu ; > (unsigned)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if56_exit
_if56_TRUE:
; klingons = 1; 
  mov d, _klingons ; $klingons
  push d
  mov32 cb, $00000001
  pop d
  mov [d], bl
  jmp _if56_exit
_if56_exit:
_if55_exit:
_if54_exit:
; klingons_left = klingons_left + klingons; 
  mov d, _klingons_left ; $klingons_left
  push d
  mov d, _klingons_left ; $klingons_left
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov d, _klingons ; $klingons
  mov bl, [d]
  mov bh, 0
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], bl
; starbases = 0; 
  mov d, _starbases ; $starbases
  push d
  mov32 cb, $00000000
  pop d
  mov [d], bl
; if (get_rand(100) > 96) 
_if57_cond:
; --- START FUNCTION CALL
  mov32 cb, $00000064
  swp b
  push b
  call get_rand
  add sp, 2
; --- END FUNCTION CALL
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000060
  cmp a, b
  sgt ; >
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if57_exit
_if57_TRUE:
; starbases = 1; 
  mov d, _starbases ; $starbases
  push d
  mov32 cb, $00000001
  pop d
  mov [d], bl
  jmp _if57_exit
_if57_exit:
; starbases_left = starbases_left + starbases; 
  mov d, _starbases_left ; $starbases_left
  push d
  mov d, _starbases_left ; $starbases_left
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov d, _starbases ; $starbases
  mov bl, [d]
  mov bh, 0
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], bl
; map[i][j] = (klingons << 8) + (starbases << 4) + rand8(); 
  mov d, _map_data ; $map
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 18 ; mov a, 18; mul a, b; add d, b
  push d
  lea d, [bp + -3] ; $j
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov d, _klingons ; $klingons
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START SHIFT
  push a
  mov a, b
  mov32 cb, $00000008
  mov c, b
  shl a, cl
  mov b, a
  pop a
; --- END SHIFT
; --- START TERMS
  push a
  mov a, b
  mov d, _starbases ; $starbases
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START SHIFT
  push a
  mov a, b
  mov32 cb, $00000004
  mov c, b
  shl a, cl
  mov b, a
  pop a
; --- END SHIFT
  add b, a
  mov a, b
; --- START FUNCTION CALL
  call rand8
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
_for53_update:
  lea d, [bp + -3] ; $j
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -3] ; $j
  mov [d], b
  mov b, a
  jmp _for53_cond
_for53_exit:
_for52_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  mov b, a
  jmp _for52_cond
_for52_exit:
; if (klingons_left > time_up) 
_if58_cond:
  mov d, _klingons_left ; $klingons_left
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov d, _time_up ; $time_up
  mov b, [d]
  mov c, 0
  cmp a, b
  sgu ; > (unsigned)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if58_exit
_if58_TRUE:
; time_up = klingons_left + 1; 
  mov d, _time_up ; $time_up
  push d
  mov d, _klingons_left ; $klingons_left
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000001
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
  jmp _if58_exit
_if58_exit:
; if (starbases_left == 0) { 
_if59_cond:
  mov d, _starbases_left ; $starbases_left
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if59_exit
_if59_TRUE:
; yp = rand8(); 
  lea d, [bp + -4] ; $yp
  push d
; --- START FUNCTION CALL
  call rand8
  pop d
  mov [d], bl
; xp = rand8(); 
  lea d, [bp + -5] ; $xp
  push d
; --- START FUNCTION CALL
  call rand8
  pop d
  mov [d], bl
; if (map[yp][xp] < 0x200) { 
_if60_cond:
  mov d, _map_data ; $map
  push a
  push d
  lea d, [bp + -4] ; $yp
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mma 18 ; mov a, 18; mul a, b; add d, b
  push d
  lea d, [bp + -5] ; $xp
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000200
  cmp a, b
  slu ; < (unsigned)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if60_exit
_if60_TRUE:
; map[yp][xp] = map[yp][xp] + (1 << 8); 
  mov d, _map_data ; $map
  push a
  push d
  lea d, [bp + -4] ; $yp
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mma 18 ; mov a, 18; mul a, b; add d, b
  push d
  lea d, [bp + -5] ; $xp
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov d, _map_data ; $map
  push a
  push d
  lea d, [bp + -4] ; $yp
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mma 18 ; mov a, 18; mul a, b; add d, b
  push d
  lea d, [bp + -5] ; $xp
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000001
; --- START SHIFT
  push a
  mov a, b
  mov32 cb, $00000008
  mov c, b
  shl a, cl
  mov b, a
  pop a
; --- END SHIFT
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; klingons_left++; 
  mov d, _klingons_left ; $klingons_left
  mov bl, [d]
  mov bh, 0
  mov c, 0
  inc b
  mov d, _klingons_left ; $klingons_left
  mov [d], bl
  dec b
  jmp _if60_exit
_if60_exit:
; map[yp][xp] = map[yp][xp] + (1 << 4); 
  mov d, _map_data ; $map
  push a
  push d
  lea d, [bp + -4] ; $yp
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mma 18 ; mov a, 18; mul a, b; add d, b
  push d
  lea d, [bp + -5] ; $xp
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov d, _map_data ; $map
  push a
  push d
  lea d, [bp + -4] ; $yp
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mma 18 ; mov a, 18; mul a, b; add d, b
  push d
  lea d, [bp + -5] ; $xp
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000001
; --- START SHIFT
  push a
  mov a, b
  mov32 cb, $00000004
  mov c, b
  shl a, cl
  mov b, a
  pop a
; --- END SHIFT
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; starbases_left++; 
  mov d, _starbases_left ; $starbases_left
  mov bl, [d]
  mov bh, 0
  mov c, 0
  inc b
  mov d, _starbases_left ; $starbases_left
  mov [d], bl
  dec b
  jmp _if59_exit
_if59_exit:
; total_klingons = klingons_left; 
  mov d, _total_klingons ; $total_klingons
  push d
  mov d, _klingons_left ; $klingons_left
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mov [d], bl
; if (starbases_left != 1) { 
_if61_cond:
  mov d, _starbases_left ; $starbases_left
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000001
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if61_exit
_if61_TRUE:
; strcpy(plural_2, "s"); 
; --- START FUNCTION CALL
  mov b, _s57 ; "s"
  swp b
  push b
  mov d, _plural_2_data ; $plural_2
  mov b, d
  mov c, 0
  swp b
  push b
  call strcpy
  add sp, 4
; --- END FUNCTION CALL
; strcpy(plural, "are"); 
; --- START FUNCTION CALL
  mov b, _s30 ; "are"
  swp b
  push b
  mov d, _plural_data ; $plural
  mov b, d
  mov c, 0
  swp b
  push b
  call strcpy
  add sp, 4
; --- END FUNCTION CALL
  jmp _if61_exit
_if61_exit:
; getchar(); 
; --- START FUNCTION CALL
  call getchar
  leave
  ret

place_ship:
  enter 0 ; (push bp; mov bp, sp)
; quad[FROM_FIXED00(ship_y) - 1][FROM_FIXED00(ship_x) - 1] = 		4      ; 
  mov d, _quad_data ; $quad
  push a
  push d
; --- START FUNCTION CALL
  mov d, _ship_y ; $ship_y
  mov b, [d]
  mov c, 0
  swp b
  push b
  call FROM_FIXED00
  add sp, 2
; --- END FUNCTION CALL
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000001
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  mma 8 ; mov a, 8; mul a, b; add d, b
  push d
; --- START FUNCTION CALL
  mov d, _ship_x ; $ship_x
  mov b, [d]
  mov c, 0
  swp b
  push b
  call FROM_FIXED00
  add sp, 2
; --- END FUNCTION CALL
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000001
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  add d, b
  pop a
  push d
  mov32 cb, $00000004
  pop d
  mov [d], bl
  leave
  ret

new_quadrant:
  enter 0 ; (push bp; mov bp, sp)
; int i; 
  sub sp, 2
; unsigned int         tmp; 
  sub sp, 2
; struct klingon *k; 
  sub sp, 2
; k = &kdata; 
  lea d, [bp + -5] ; $k
  push d
  mov d, _kdata_data ; $kdata
  mov b, d
  pop d
  mov [d], b
; klingons = 0; 
  mov d, _klingons ; $klingons
  push d
  mov32 cb, $00000000
  pop d
  mov [d], bl
; starbases = 0; 
  mov d, _starbases ; $starbases
  push d
  mov32 cb, $00000000
  pop d
  mov [d], bl
; stars = 0; 
  mov d, _stars ; $stars
  push d
  mov32 cb, $00000000
  pop d
  mov [d], bl
; d4 = get_rand(50) - 1; 
  mov d, _d4 ; $d4
  push d
; --- START FUNCTION CALL
  mov32 cb, $00000032
  swp b
  push b
  call get_rand
  add sp, 2
; --- END FUNCTION CALL
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000001
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; map[quad_y][quad_x] = map[quad_y][quad_x] |  0x1000		           ; 
  mov d, _map_data ; $map
  push a
  push d
  mov d, _quad_y ; $quad_y
  mov b, [d]
  mov c, 0
  pop d
  mma 18 ; mov a, 18; mul a, b; add d, b
  push d
  mov d, _quad_x ; $quad_x
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov d, _map_data ; $map
  push a
  push d
  mov d, _quad_y ; $quad_y
  mov b, [d]
  mov c, 0
  pop d
  mma 18 ; mov a, 18; mul a, b; add d, b
  push d
  mov d, _quad_x ; $quad_x
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  push a
  mov a, b
  mov32 cb, $00001000
  or b, a ; |
  pop a
  pop d
  mov [d], b
; if (quad_y >= 1 && quad_y <= 8 && quad_x >= 1 && quad_x <= 8) { 
_if62_cond:
  mov d, _quad_y ; $quad_y
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000001
  cmp a, b
  sge ; >=
  pop a
; --- END RELATIONAL
; --- START LOGICAL AND
  push a
  mov a, b
  mov d, _quad_y ; $quad_y
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000008
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  sand a, b
  mov a, b
  mov d, _quad_x ; $quad_x
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000001
  cmp a, b
  sge ; >=
  pop a
; --- END RELATIONAL
  sand a, b
  mov a, b
  mov d, _quad_x ; $quad_x
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000008
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  cmp b, 0
  je _if62_exit
_if62_TRUE:
; quadrant_name(0, quad_y, quad_x); 
; --- START FUNCTION CALL
  mov d, _quad_x ; $quad_x
  mov b, [d]
  mov c, 0
  push bl
  mov d, _quad_y ; $quad_y
  mov b, [d]
  mov c, 0
  push bl
  mov32 cb, $00000000
  push bl
  call quadrant_name
  add sp, 3
; --- END FUNCTION CALL
; if (TO_FIXED(time_start) != stardate) 
_if63_cond:
; --- START FUNCTION CALL
  mov d, _time_start ; $time_start
  mov b, [d]
  mov c, 0
  swp b
  push b
  call TO_FIXED
  add sp, 2
; --- END FUNCTION CALL
; --- START RELATIONAL
  push a
  mov a, b
  mov d, _stardate ; $stardate
  mov b, [d]
  mov c, 0
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if63_else
_if63_TRUE:
; printf("Now entering %s quadrant...\n\n", quadname); 
; --- START FUNCTION CALL
  mov d, _quadname_data ; $quadname
  mov b, d
  mov c, 0
  swp b
  push b
  mov b, _s58 ; "Now entering %s quadrant...\n\n"
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
  jmp _if63_exit
_if63_else:
; puts("\nYour mission begins with your starship located"); 
; --- START FUNCTION CALL
  mov b, _s59 ; "\nYour mission begins with your starship located"
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; printf("in the galactic quadrant %s.\n\n", quadname); 
; --- START FUNCTION CALL
  mov d, _quadname_data ; $quadname
  mov b, d
  mov c, 0
  swp b
  push b
  mov b, _s60 ; "in the galactic quadrant %s.\n\n"
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
_if63_exit:
  jmp _if62_exit
_if62_exit:
; tmp = map[quad_y][quad_x]; 
  lea d, [bp + -3] ; $tmp
  push d
  mov d, _map_data ; $map
  push a
  push d
  mov d, _quad_y ; $quad_y
  mov b, [d]
  mov c, 0
  pop d
  mma 18 ; mov a, 18; mul a, b; add d, b
  push d
  mov d, _quad_x ; $quad_x
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
; klingons = (tmp >> 8) & 0x0F; 
  mov d, _klingons ; $klingons
  push d
  lea d, [bp + -3] ; $tmp
  mov b, [d]
  mov c, 0
; --- START SHIFT
  push a
  mov a, b
  mov32 cb, $00000008
  mov c, b
  shr a, cl
  mov b, a
  pop a
; --- END SHIFT
  push a
  mov a, b
  mov32 cb, $0000000f
  and b, a ; &
  pop a
  pop d
  mov [d], bl
; starbases = (tmp >> 4) & 0x0F; 
  mov d, _starbases ; $starbases
  push d
  lea d, [bp + -3] ; $tmp
  mov b, [d]
  mov c, 0
; --- START SHIFT
  push a
  mov a, b
  mov32 cb, $00000004
  mov c, b
  shr a, cl
  mov b, a
  pop a
; --- END SHIFT
  push a
  mov a, b
  mov32 cb, $0000000f
  and b, a ; &
  pop a
  pop d
  mov [d], bl
; stars = tmp & 0x0F; 
  mov d, _stars ; $stars
  push d
  lea d, [bp + -3] ; $tmp
  mov b, [d]
  mov c, 0
  push a
  mov a, b
  mov32 cb, $0000000f
  and b, a ; &
  pop a
  pop d
  mov [d], bl
; if (klingons > 0) { 
_if64_cond:
  mov d, _klingons ; $klingons
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  sgu ; > (unsigned)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if64_exit
_if64_TRUE:
; printf("Combat Area  Condition Red\n"); 
; --- START FUNCTION CALL
  mov b, _s61 ; "Combat Area  Condition Red\n"
  swp b
  push b
  call printf
  add sp, 2
; --- END FUNCTION CALL
; if (shield < 200) 
_if65_cond:
  mov d, _shield ; $shield
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $000000c8
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if65_exit
_if65_TRUE:
; printf("Shields Dangerously Low\n"); 
; --- START FUNCTION CALL
  mov b, _s62 ; "Shields Dangerously Low\n"
  swp b
  push b
  call printf
  add sp, 2
; --- END FUNCTION CALL
  jmp _if65_exit
_if65_exit:
  jmp _if64_exit
_if64_exit:
; for (i = 1; i <= 3; i++) { 
_for66_init:
  lea d, [bp + -1] ; $i
  push d
  mov32 cb, $00000001
  pop d
  mov [d], b
_for66_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000003
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for66_exit
_for66_block:
; k->y = 0; 
  lea d, [bp + -5] ; $k
  mov d, [d]
  add d, 0
  push d
  mov32 cb, $00000000
  pop d
  mov [d], bl
; k->x = 0; 
  lea d, [bp + -5] ; $k
  mov d, [d]
  add d, 1
  push d
  mov32 cb, $00000000
  pop d
  mov [d], bl
; k->energy = 0; 
  lea d, [bp + -5] ; $k
  mov d, [d]
  add d, 2
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
; k++; 
  lea d, [bp + -5] ; $k
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  inc b
  lea d, [bp + -5] ; $k
  mov [d], b
  mov b, a
_for66_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  mov b, a
  jmp _for66_cond
_for66_exit:
; memset(quad, 		0       , 64); 
; --- START FUNCTION CALL
  mov32 cb, $00000040
  swp b
  push b
  mov32 cb, $00000000
  push bl
  mov d, _quad_data ; $quad
  mov b, d
  mov c, 0
  swp b
  push b
  call memset
  add sp, 5
; --- END FUNCTION CALL
; place_ship(); 
; --- START FUNCTION CALL
  call place_ship
; if (klingons > 0) { 
_if67_cond:
  mov d, _klingons ; $klingons
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  sgu ; > (unsigned)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if67_exit
_if67_TRUE:
; k = kdata; 
  lea d, [bp + -5] ; $k
  push d
  mov d, _kdata_data ; $kdata
  mov b, d
  mov c, 0
  pop d
  mov [d], b
; for (i = 0; i < klingons; i++) { 
_for68_init:
  lea d, [bp + -1] ; $i
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
_for68_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov d, _klingons ; $klingons
  mov bl, [d]
  mov bh, 0
  mov c, 0
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for68_exit
_for68_block:
; find_set_empty_place(	3         , k->y, k->x); 
; --- START FUNCTION CALL
  lea d, [bp + -5] ; $k
  mov d, [d]
  add d, 1
  mov bl, [d]
  mov bh, 0
  mov c, 0
  swp b
  push b
  lea d, [bp + -5] ; $k
  mov d, [d]
  add d, 0
  mov bl, [d]
  mov bh, 0
  mov c, 0
  swp b
  push b
  mov32 cb, $00000003
  push bl
  call find_set_empty_place
  add sp, 5
; --- END FUNCTION CALL
; k->energy = 100 + get_rand(200); 
  lea d, [bp + -5] ; $k
  mov d, [d]
  add d, 2
  push d
  mov32 cb, $00000064
; --- START TERMS
  push a
  mov a, b
; --- START FUNCTION CALL
  mov32 cb, $000000c8
  swp b
  push b
  call get_rand
  add sp, 2
; --- END FUNCTION CALL
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; k++; 
  lea d, [bp + -5] ; $k
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  inc b
  lea d, [bp + -5] ; $k
  mov [d], b
  mov b, a
_for68_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  mov b, a
  jmp _for68_cond
_for68_exit:
  jmp _if67_exit
_if67_exit:
; if (starbases > 0) 
_if69_cond:
  mov d, _starbases ; $starbases
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  sgt ; >
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if69_exit
_if69_TRUE:
; find_set_empty_place(		2      , &base_y, &base_x); 
; --- START FUNCTION CALL
  mov d, _base_x ; $base_x
  mov b, d
  swp b
  push b
  mov d, _base_y ; $base_y
  mov b, d
  swp b
  push b
  mov32 cb, $00000002
  push bl
  call find_set_empty_place
  add sp, 5
; --- END FUNCTION CALL
  jmp _if69_exit
_if69_exit:
; for (i = 1; i <= stars; i++) 
_for70_init:
  lea d, [bp + -1] ; $i
  push d
  mov32 cb, $00000001
  pop d
  mov [d], b
_for70_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov d, _stars ; $stars
  mov bl, [d]
  mov bh, 0
  mov c, 0
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for70_exit
_for70_block:
; find_set_empty_place(		1      ,  0    ,  0    ); 
; --- START FUNCTION CALL
  mov32 cb, $00000000
  swp b
  push b
  mov32 cb, $00000000
  swp b
  push b
  mov32 cb, $00000001
  push bl
  call find_set_empty_place
  add sp, 5
; --- END FUNCTION CALL
_for70_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  mov b, a
  jmp _for70_cond
_for70_exit:
  leave
  ret

course_control:
  enter 0 ; (push bp; mov bp, sp)
; int i; 
  sub sp, 2
; int        c1; 
  sub sp, 2
; int        warp; 
  sub sp, 2
; unsigned int         n; 
  sub sp, 2
; int c2, c3, c4; 
  sub sp, 2
  sub sp, 2
  sub sp, 2
; int        z1, z2; 
  sub sp, 2
  sub sp, 2
; int        x1, x2; 
  sub sp, 2
  sub sp, 2
; int        x, y; 
  sub sp, 2
  sub sp, 2
; unsigned char        outside = 0;		/* Outside galaxy flag */ 
  sub sp, 1
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -26] ; $outside
  push d
  mov32 cb, $00000000
  pop d
  mov [d], bl
; --- END LOCAL VAR INITIALIZATION
; unsigned char        quad_y_old; 
  sub sp, 1
; unsigned char        quad_x_old; 
  sub sp, 1
; puts("Course (0-9): " ); 
; --- START FUNCTION CALL
  mov b, _s63 ; "Course (0-9): "
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; c1 = input_f00(); 
  lea d, [bp + -3] ; $c1
  push d
; --- START FUNCTION CALL
  call input_f00
  pop d
  mov [d], b
; if (c1 == 900) 
_if71_cond:
  lea d, [bp + -3] ; $c1
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000384
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if71_exit
_if71_TRUE:
; c1 = 100; 
  lea d, [bp + -3] ; $c1
  push d
  mov32 cb, $00000064
  pop d
  mov [d], b
  jmp _if71_exit
_if71_exit:
; if (c1 < 0 || c1 > 900) { 
_if72_cond:
  lea d, [bp + -3] ; $c1
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
; --- START LOGICAL OR
  push a
  mov a, b
  lea d, [bp + -3] ; $c1
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000384
  cmp a, b
  sgt ; >
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  cmp b, 0
  je _if72_exit
_if72_TRUE:
; printf("Lt. Sulu%s", inc_1); 
; --- START FUNCTION CALL
  mov d, _inc_1 ; $inc_1
  mov b, [d]
  mov c, 0
  swp b
  push b
  mov b, _s64 ; "Lt. Sulu%s"
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
; return; 
  leave
  ret
  jmp _if72_exit
_if72_exit:
; if (damage[1] < 0) 
_if73_cond:
  mov d, _damage_data ; $damage
  push a
  push d
  mov32 cb, $00000001
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if73_exit
_if73_TRUE:
; strcpy(warpmax, "0.2"); 
; --- START FUNCTION CALL
  mov b, _s65 ; "0.2"
  swp b
  push b
  mov d, _warpmax_data ; $warpmax
  mov b, d
  mov c, 0
  swp b
  push b
  call strcpy
  add sp, 4
; --- END FUNCTION CALL
  jmp _if73_exit
_if73_exit:
; printf("Warp Factor (0-%s): ", warpmax); 
; --- START FUNCTION CALL
  mov d, _warpmax_data ; $warpmax
  mov b, d
  mov c, 0
  swp b
  push b
  mov b, _s66 ; "Warp Factor (0-%s): "
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
; warp = input_f00(); 
  lea d, [bp + -5] ; $warp
  push d
; --- START FUNCTION CALL
  call input_f00
  pop d
  mov [d], b
; if (damage[1] < 0 && warp > 20) { 
_if74_cond:
  mov d, _damage_data ; $damage
  push a
  push d
  mov32 cb, $00000001
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + -5] ; $warp
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000014
  cmp a, b
  sgt ; >
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  cmp b, 0
  je _if74_exit
_if74_TRUE:
; printf("Warp Engines are damaged. Maximum speed = Warp 0.2.\n\n"); 
; --- START FUNCTION CALL
  mov b, _s67 ; "Warp Engines are damaged. Maximum speed = Warp 0.2.\n\n"
  swp b
  push b
  call printf
  add sp, 2
; --- END FUNCTION CALL
; return; 
  leave
  ret
  jmp _if74_exit
_if74_exit:
; if (warp <= 0) 
_if75_cond:
  lea d, [bp + -5] ; $warp
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if75_exit
_if75_TRUE:
; return; 
  leave
  ret
  jmp _if75_exit
_if75_exit:
; if (warp > 800) { 
_if76_cond:
  lea d, [bp + -5] ; $warp
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000320
  cmp a, b
  sgt ; >
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if76_exit
_if76_TRUE:
; printf("Chief Engineer Scott reports:\n  The engines won't take warp %s!\n\n", print100(warp)); 
; --- START FUNCTION CALL
; --- START FUNCTION CALL
  lea d, [bp + -5] ; $warp
  mov b, [d]
  mov c, 0
  swp b
  push b
  call print100
  add sp, 2
; --- END FUNCTION CALL
  swp b
  push b
  mov b, _s68 ; "Chief Engineer Scott reports:\n  The engines won't take warp %s!\n\n"
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
; return; 
  leave
  ret
  jmp _if76_exit
_if76_exit:
; n = warp * 8; 
  lea d, [bp + -7] ; $n
  push d
  lea d, [bp + -5] ; $warp
  mov b, [d]
  mov c, 0
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $00000008
  push a     ; save left operand
  xor a, b   ; xor sign bits
  swp a      ; swap bytes
  mov cl, al ; save result of xor into 'dl'
  pop a      ; restore left side operator
  push cl    ; save result of xor above
  swp a  
  test al, $80  
  swp a  
  jz skip_invert_a_78  
  neg a 
skip_invert_a_78:   
  swp b
  test bl, $80  
  swp b
  jz skip_invert_b_78  
  neg b 
skip_invert_b_78:   
  mul a, b ; *
  mov g, a
  mov a, b
  pop bl
  test bl, $80
  jz _same_signs_78
  mov bl, al
  not a
  neg b
  adc a, 0
  mov g, a
  mov a, b
_same_signs_78:
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  pop d
  mov [d], b
; n = cint100(n);	 
  lea d, [bp + -7] ; $n
  push d
; --- START FUNCTION CALL
  lea d, [bp + -7] ; $n
  mov b, [d]
  mov c, 0
  swp b
  push b
  call cint100
  add sp, 2
; --- END FUNCTION CALL
  pop d
  mov [d], b
; if (energy - n < 0) { 
_if79_cond:
  mov d, _energy ; $energy
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -7] ; $n
  mov b, [d]
  mov c, 0
  sub a, b
  mov b, a
  pop a
; --- END TERMS
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  slu ; < (unsigned)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if79_exit
_if79_TRUE:
; printf("Engineering reports:\n  Insufficient energy available for maneuvering at warp %s!\n\n", print100(warp)); 
; --- START FUNCTION CALL
; --- START FUNCTION CALL
  lea d, [bp + -5] ; $warp
  mov b, [d]
  mov c, 0
  swp b
  push b
  call print100
  add sp, 2
; --- END FUNCTION CALL
  swp b
  push b
  mov b, _s69 ; "Engineering reports:\n  Insufficient energy available for maneuvering at warp %s!\n\n"
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
; if (shield >= n && damage[7] >= 0) { 
_if80_cond:
  mov d, _shield ; $shield
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -7] ; $n
  mov b, [d]
  mov c, 0
  cmp a, b
  sge ; >=
  pop a
; --- END RELATIONAL
; --- START LOGICAL AND
  push a
  mov a, b
  mov d, _damage_data ; $damage
  push a
  push d
  mov32 cb, $00000007
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  sge ; >=
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  cmp b, 0
  je _if80_exit
_if80_TRUE:
; printf("Deflector Control Room acknowledges:\n  %d units of energy presently deployed to shields.\n", shield); 
; --- START FUNCTION CALL
  mov d, _shield ; $shield
  mov b, [d]
  mov c, 0
  swp b
  push b
  mov b, _s70 ; "Deflector Control Room acknowledges:\n  %d units of energy presently deployed to shields.\n"
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
  jmp _if80_exit
_if80_exit:
; return; 
  leave
  ret
  jmp _if79_exit
_if79_exit:
; klingons_move(); 
; --- START FUNCTION CALL
  call klingons_move
; repair_damage(warp); 
; --- START FUNCTION CALL
  lea d, [bp + -5] ; $warp
  mov b, [d]
  mov c, 0
  swp b
  push b
  call repair_damage
  add sp, 2
; --- END FUNCTION CALL
; z1 = FROM_FIXED00(ship_y); 
  lea d, [bp + -15] ; $z1
  push d
; --- START FUNCTION CALL
  mov d, _ship_y ; $ship_y
  mov b, [d]
  mov c, 0
  swp b
  push b
  call FROM_FIXED00
  add sp, 2
; --- END FUNCTION CALL
  pop d
  mov [d], b
; z2 = FROM_FIXED00(ship_x); 
  lea d, [bp + -17] ; $z2
  push d
; --- START FUNCTION CALL
  mov d, _ship_x ; $ship_x
  mov b, [d]
  mov c, 0
  swp b
  push b
  call FROM_FIXED00
  add sp, 2
; --- END FUNCTION CALL
  pop d
  mov [d], b
; quad[z1+-1][z2+-1] = 		0       ; 
  mov d, _quad_data ; $quad
  push a
  push d
  lea d, [bp + -15] ; $z1
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $ffffffff
  add b, a
  pop a
; --- END TERMS
  pop d
  mma 8 ; mov a, 8; mul a, b; add d, b
  push d
  lea d, [bp + -17] ; $z2
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $ffffffff
  add b, a
  pop a
; --- END TERMS
  pop d
  add d, b
  pop a
  push d
  mov32 cb, $00000000
  pop d
  mov [d], bl
; c2 = FROM_FIXED00(c1);	/* Integer part */ 
  lea d, [bp + -9] ; $c2
  push d
; --- START FUNCTION CALL
  lea d, [bp + -3] ; $c1
  mov b, [d]
  mov c, 0
  swp b
  push b
  call FROM_FIXED00
  add sp, 2
; --- END FUNCTION CALL
  pop d
  mov [d], b
; c3 = c2 + 1;		/* Next integer part */ 
  lea d, [bp + -11] ; $c3
  push d
  lea d, [bp + -9] ; $c2
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000001
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; c4 = (c1 - TO_FIXED00(c2));	/* Fractional element in fixed point */ 
  lea d, [bp + -13] ; $c4
  push d
  lea d, [bp + -3] ; $c1
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
; --- START FUNCTION CALL
  lea d, [bp + -9] ; $c2
  mov b, [d]
  mov c, 0
  swp b
  push b
  call TO_FIXED00
  add sp, 2
; --- END FUNCTION CALL
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; x1 = 100 * c[1][c2] + (c[1][c3] - c[1][c2]) * c4; 
  lea d, [bp + -19] ; $x1
  push d
  mov32 cb, $00000064
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov d, _c_data ; $c
  push a
  push d
  mov32 cb, $00000001
  pop d
  mma 10 ; mov a, 10; mul a, b; add d, b
  push d
  lea d, [bp + -9] ; $c2
  mov b, [d]
  mov c, 0
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push a     ; save left operand
  xor a, b   ; xor sign bits
  swp a      ; swap bytes
  mov cl, al ; save result of xor into 'dl'
  pop a      ; restore left side operator
  push cl    ; save result of xor above
  swp a  
  test al, $80  
  swp a  
  jz skip_invert_a_83  
  neg a 
skip_invert_a_83:   
  swp b
  test bl, $80  
  swp b
  jz skip_invert_b_83  
  neg b 
skip_invert_b_83:   
  mul a, b ; *
  mov g, a
  mov a, b
  pop bl
  test bl, $80
  jz _same_signs_83
  mov bl, al
  not a
  neg b
  adc a, 0
  mov g, a
  mov a, b
_same_signs_83:
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
; --- START TERMS
  push a
  push g
  mov a, b
  mov g, c
  mov d, _c_data ; $c
  push a
  push d
  mov32 cb, $00000001
  pop d
  mma 10 ; mov a, 10; mul a, b; add d, b
  push d
  lea d, [bp + -11] ; $c3
  mov b, [d]
  mov c, 0
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov d, _c_data ; $c
  push a
  push d
  mov32 cb, $00000001
  pop d
  mma 10 ; mov a, 10; mul a, b; add d, b
  push d
  lea d, [bp + -9] ; $c2
  mov b, [d]
  mov c, 0
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
  sub a, b
  mov b, a
  pop a
; --- END TERMS
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  lea d, [bp + -13] ; $c4
  mov b, [d]
  mov c, 0
  push a     ; save left operand
  xor a, b   ; xor sign bits
  swp a      ; swap bytes
  mov cl, al ; save result of xor into 'dl'
  pop a      ; restore left side operator
  push cl    ; save result of xor above
  swp a  
  test al, $80  
  swp a  
  jz skip_invert_a_84  
  neg a 
skip_invert_a_84:   
  swp b
  test bl, $80  
  swp b
  jz skip_invert_b_84  
  neg b 
skip_invert_b_84:   
  mul a, b ; *
  mov g, a
  mov a, b
  pop bl
  test bl, $80
  jz _same_signs_84
  mov bl, al
  not a
  neg b
  adc a, 0
  mov g, a
  mov a, b
_same_signs_84:
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  add32 cb, ga
  pop g
  pop a
; --- END TERMS
  pop d
  mov [d], b
; x2 = 100 * c[2][c2] + (c[2][c3] - c[2][c2]) * c4; 
  lea d, [bp + -21] ; $x2
  push d
  mov32 cb, $00000064
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov d, _c_data ; $c
  push a
  push d
  mov32 cb, $00000002
  pop d
  mma 10 ; mov a, 10; mul a, b; add d, b
  push d
  lea d, [bp + -9] ; $c2
  mov b, [d]
  mov c, 0
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push a     ; save left operand
  xor a, b   ; xor sign bits
  swp a      ; swap bytes
  mov cl, al ; save result of xor into 'dl'
  pop a      ; restore left side operator
  push cl    ; save result of xor above
  swp a  
  test al, $80  
  swp a  
  jz skip_invert_a_87  
  neg a 
skip_invert_a_87:   
  swp b
  test bl, $80  
  swp b
  jz skip_invert_b_87  
  neg b 
skip_invert_b_87:   
  mul a, b ; *
  mov g, a
  mov a, b
  pop bl
  test bl, $80
  jz _same_signs_87
  mov bl, al
  not a
  neg b
  adc a, 0
  mov g, a
  mov a, b
_same_signs_87:
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
; --- START TERMS
  push a
  push g
  mov a, b
  mov g, c
  mov d, _c_data ; $c
  push a
  push d
  mov32 cb, $00000002
  pop d
  mma 10 ; mov a, 10; mul a, b; add d, b
  push d
  lea d, [bp + -11] ; $c3
  mov b, [d]
  mov c, 0
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov d, _c_data ; $c
  push a
  push d
  mov32 cb, $00000002
  pop d
  mma 10 ; mov a, 10; mul a, b; add d, b
  push d
  lea d, [bp + -9] ; $c2
  mov b, [d]
  mov c, 0
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
  sub a, b
  mov b, a
  pop a
; --- END TERMS
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  lea d, [bp + -13] ; $c4
  mov b, [d]
  mov c, 0
  push a     ; save left operand
  xor a, b   ; xor sign bits
  swp a      ; swap bytes
  mov cl, al ; save result of xor into 'dl'
  pop a      ; restore left side operator
  push cl    ; save result of xor above
  swp a  
  test al, $80  
  swp a  
  jz skip_invert_a_88  
  neg a 
skip_invert_a_88:   
  swp b
  test bl, $80  
  swp b
  jz skip_invert_b_88  
  neg b 
skip_invert_b_88:   
  mul a, b ; *
  mov g, a
  mov a, b
  pop bl
  test bl, $80
  jz _same_signs_88
  mov bl, al
  not a
  neg b
  adc a, 0
  mov g, a
  mov a, b
_same_signs_88:
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  add32 cb, ga
  pop g
  pop a
; --- END TERMS
  pop d
  mov [d], b
; x = ship_y; 
  lea d, [bp + -23] ; $x
  push d
  mov d, _ship_y ; $ship_y
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
; y = ship_x; 
  lea d, [bp + -25] ; $y
  push d
  mov d, _ship_x ; $ship_x
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
; for (i = 1; i <= n; i++) { 
_for89_init:
  lea d, [bp + -1] ; $i
  push d
  mov32 cb, $00000001
  pop d
  mov [d], b
_for89_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -7] ; $n
  mov b, [d]
  mov c, 0
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for89_exit
_for89_block:
; ship_y = ship_y + x1; 
  mov d, _ship_y ; $ship_y
  push d
  mov d, _ship_y ; $ship_y
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -19] ; $x1
  mov b, [d]
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; ship_x = ship_x + x2; 
  mov d, _ship_x ; $ship_x
  push d
  mov d, _ship_x ; $ship_x
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -21] ; $x2
  mov b, [d]
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; z1 = FROM_FIXED00(ship_y); 
  lea d, [bp + -15] ; $z1
  push d
; --- START FUNCTION CALL
  mov d, _ship_y ; $ship_y
  mov b, [d]
  mov c, 0
  swp b
  push b
  call FROM_FIXED00
  add sp, 2
; --- END FUNCTION CALL
  pop d
  mov [d], b
; z2 = FROM_FIXED00(ship_x);	/* ?? cint100 ?? */ 
  lea d, [bp + -17] ; $z2
  push d
; --- START FUNCTION CALL
  mov d, _ship_x ; $ship_x
  mov b, [d]
  mov c, 0
  swp b
  push b
  call FROM_FIXED00
  add sp, 2
; --- END FUNCTION CALL
  pop d
  mov [d], b
; if (z1 < 1 || z1 >= 9 || z2 < 1 || z2 >= 9) { 
_if90_cond:
  lea d, [bp + -15] ; $z1
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000001
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
; --- START LOGICAL OR
  push a
  mov a, b
  lea d, [bp + -15] ; $z1
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000009
  cmp a, b
  sge ; >=
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  mov a, b
  lea d, [bp + -17] ; $z2
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000001
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  mov a, b
  lea d, [bp + -17] ; $z2
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000009
  cmp a, b
  sge ; >=
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  cmp b, 0
  je _if90_exit
_if90_TRUE:
; outside = 0;		/* Outside galaxy flag */ 
  lea d, [bp + -26] ; $outside
  push d
  mov32 cb, $00000000
  pop d
  mov [d], bl
; quad_y_old = quad_y; 
  lea d, [bp + -27] ; $quad_y_old
  push d
  mov d, _quad_y ; $quad_y
  mov b, [d]
  mov c, 0
  pop d
  mov [d], bl
; quad_x_old = quad_x; 
  lea d, [bp + -28] ; $quad_x_old
  push d
  mov d, _quad_x ; $quad_x
  mov b, [d]
  mov c, 0
  pop d
  mov [d], bl
; x = (800 * quad_y) + x + (n * x1); 
  lea d, [bp + -23] ; $x
  push d
  mov32 cb, $00000320
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov d, _quad_y ; $quad_y
  mov b, [d]
  mov c, 0
  push a     ; save left operand
  xor a, b   ; xor sign bits
  swp a      ; swap bytes
  mov cl, al ; save result of xor into 'dl'
  pop a      ; restore left side operator
  push cl    ; save result of xor above
  swp a  
  test al, $80  
  swp a  
  jz skip_invert_a_96  
  neg a 
skip_invert_a_96:   
  swp b
  test bl, $80  
  swp b
  jz skip_invert_b_96  
  neg b 
skip_invert_b_96:   
  mul a, b ; *
  mov g, a
  mov a, b
  pop bl
  test bl, $80
  jz _same_signs_96
  mov bl, al
  not a
  neg b
  adc a, 0
  mov g, a
  mov a, b
_same_signs_96:
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
; --- START TERMS
  push a
  push g
  mov a, b
  mov g, c
  lea d, [bp + -23] ; $x
  mov b, [d]
  mov c, 0
  mov c, 0
  add32 cb, ga
  mov a, b
  mov g, c
  lea d, [bp + -7] ; $n
  mov b, [d]
  mov c, 0
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  lea d, [bp + -19] ; $x1
  mov b, [d]
  mov c, 0
  push a     ; save left operand
  xor a, b   ; xor sign bits
  swp a      ; swap bytes
  mov cl, al ; save result of xor into 'dl'
  pop a      ; restore left side operator
  push cl    ; save result of xor above
  swp a  
  test al, $80  
  swp a  
  jz skip_invert_a_98  
  neg a 
skip_invert_a_98:   
  swp b
  test bl, $80  
  swp b
  jz skip_invert_b_98  
  neg b 
skip_invert_b_98:   
  mul a, b ; *
  mov g, a
  mov a, b
  pop bl
  test bl, $80
  jz _same_signs_98
  mov bl, al
  not a
  neg b
  adc a, 0
  mov g, a
  mov a, b
_same_signs_98:
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  add32 cb, ga
  pop g
  pop a
; --- END TERMS
  pop d
  mov [d], b
; y = (800 * quad_x) + y + (n * x2); 
  lea d, [bp + -25] ; $y
  push d
  mov32 cb, $00000320
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov d, _quad_x ; $quad_x
  mov b, [d]
  mov c, 0
  push a     ; save left operand
  xor a, b   ; xor sign bits
  swp a      ; swap bytes
  mov cl, al ; save result of xor into 'dl'
  pop a      ; restore left side operator
  push cl    ; save result of xor above
  swp a  
  test al, $80  
  swp a  
  jz skip_invert_a_104  
  neg a 
skip_invert_a_104:   
  swp b
  test bl, $80  
  swp b
  jz skip_invert_b_104  
  neg b 
skip_invert_b_104:   
  mul a, b ; *
  mov g, a
  mov a, b
  pop bl
  test bl, $80
  jz _same_signs_104
  mov bl, al
  not a
  neg b
  adc a, 0
  mov g, a
  mov a, b
_same_signs_104:
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
; --- START TERMS
  push a
  push g
  mov a, b
  mov g, c
  lea d, [bp + -25] ; $y
  mov b, [d]
  mov c, 0
  mov c, 0
  add32 cb, ga
  mov a, b
  mov g, c
  lea d, [bp + -7] ; $n
  mov b, [d]
  mov c, 0
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  lea d, [bp + -21] ; $x2
  mov b, [d]
  mov c, 0
  push a     ; save left operand
  xor a, b   ; xor sign bits
  swp a      ; swap bytes
  mov cl, al ; save result of xor into 'dl'
  pop a      ; restore left side operator
  push cl    ; save result of xor above
  swp a  
  test al, $80  
  swp a  
  jz skip_invert_a_106  
  neg a 
skip_invert_a_106:   
  swp b
  test bl, $80  
  swp b
  jz skip_invert_b_106  
  neg b 
skip_invert_b_106:   
  mul a, b ; *
  mov g, a
  mov a, b
  pop bl
  test bl, $80
  jz _same_signs_106
  mov bl, al
  not a
  neg b
  adc a, 0
  mov g, a
  mov a, b
_same_signs_106:
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  add32 cb, ga
  pop g
  pop a
; --- END TERMS
  pop d
  mov [d], b
; quad_y = x / 800;	/* Fixed point to int and divide by 8 */ 
  mov d, _quad_y ; $quad_y
  push d
  lea d, [bp + -23] ; $x
  mov b, [d]
  mov c, 0
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $00000320
  push g ; save 'g' as the div instruction uses it
  div a, b ; /, a: quotient, b: remainder
  pop g
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  pop d
  mov [d], b
; quad_x = y / 800;	/* Ditto */ 
  mov d, _quad_x ; $quad_x
  push d
  lea d, [bp + -25] ; $y
  mov b, [d]
  mov c, 0
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $00000320
  push g ; save 'g' as the div instruction uses it
  div a, b ; /, a: quotient, b: remainder
  pop g
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  pop d
  mov [d], b
; ship_y = x - (quad_y * 800); 
  mov d, _ship_y ; $ship_y
  push d
  lea d, [bp + -23] ; $x
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov d, _quad_y ; $quad_y
  mov b, [d]
  mov c, 0
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $00000320
  push a     ; save left operand
  xor a, b   ; xor sign bits
  swp a      ; swap bytes
  mov cl, al ; save result of xor into 'dl'
  pop a      ; restore left side operator
  push cl    ; save result of xor above
  swp a  
  test al, $80  
  swp a  
  jz skip_invert_a_114  
  neg a 
skip_invert_a_114:   
  swp b
  test bl, $80  
  swp b
  jz skip_invert_b_114  
  neg b 
skip_invert_b_114:   
  mul a, b ; *
  mov g, a
  mov a, b
  pop bl
  test bl, $80
  jz _same_signs_114
  mov bl, al
  not a
  neg b
  adc a, 0
  mov g, a
  mov a, b
_same_signs_114:
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  mov g, 0
  sub32 ga, cb
  mov b, a
  mov c, g
  pop a
; --- END TERMS
  pop d
  mov [d], b
; ship_x = y - (quad_x * 800); 
  mov d, _ship_x ; $ship_x
  push d
  lea d, [bp + -25] ; $y
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov d, _quad_x ; $quad_x
  mov b, [d]
  mov c, 0
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $00000320
  push a     ; save left operand
  xor a, b   ; xor sign bits
  swp a      ; swap bytes
  mov cl, al ; save result of xor into 'dl'
  pop a      ; restore left side operator
  push cl    ; save result of xor above
  swp a  
  test al, $80  
  swp a  
  jz skip_invert_a_118  
  neg a 
skip_invert_a_118:   
  swp b
  test bl, $80  
  swp b
  jz skip_invert_b_118  
  neg b 
skip_invert_b_118:   
  mul a, b ; *
  mov g, a
  mov a, b
  pop bl
  test bl, $80
  jz _same_signs_118
  mov bl, al
  not a
  neg b
  adc a, 0
  mov g, a
  mov a, b
_same_signs_118:
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  mov g, 0
  sub32 ga, cb
  mov b, a
  mov c, g
  pop a
; --- END TERMS
  pop d
  mov [d], b
; if (ship_y < 100) { 
_if119_cond:
  mov d, _ship_y ; $ship_y
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000064
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if119_exit
_if119_TRUE:
; quad_y = quad_y - 1; 
  mov d, _quad_y ; $quad_y
  push d
  mov d, _quad_y ; $quad_y
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000001
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; ship_y = ship_y + 800; 
  mov d, _ship_y ; $ship_y
  push d
  mov d, _ship_y ; $ship_y
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000320
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
  jmp _if119_exit
_if119_exit:
; if (ship_x < 100) { 
_if120_cond:
  mov d, _ship_x ; $ship_x
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000064
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if120_exit
_if120_TRUE:
; quad_x = quad_x - 1; 
  mov d, _quad_x ; $quad_x
  push d
  mov d, _quad_x ; $quad_x
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000001
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; ship_x = ship_x + 800; 
  mov d, _ship_x ; $ship_x
  push d
  mov d, _ship_x ; $ship_x
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000320
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
  jmp _if120_exit
_if120_exit:
; if (quad_y < 1) { 
_if121_cond:
  mov d, _quad_y ; $quad_y
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000001
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if121_exit
_if121_TRUE:
; outside = 1; 
  lea d, [bp + -26] ; $outside
  push d
  mov32 cb, $00000001
  pop d
  mov [d], bl
; quad_y = 1; 
  mov d, _quad_y ; $quad_y
  push d
  mov32 cb, $00000001
  pop d
  mov [d], b
; ship_y = 100; 
  mov d, _ship_y ; $ship_y
  push d
  mov32 cb, $00000064
  pop d
  mov [d], b
  jmp _if121_exit
_if121_exit:
; if (quad_y > 8) { 
_if122_cond:
  mov d, _quad_y ; $quad_y
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000008
  cmp a, b
  sgt ; >
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if122_exit
_if122_TRUE:
; outside = 1; 
  lea d, [bp + -26] ; $outside
  push d
  mov32 cb, $00000001
  pop d
  mov [d], bl
; quad_y = 8; 
  mov d, _quad_y ; $quad_y
  push d
  mov32 cb, $00000008
  pop d
  mov [d], b
; ship_y = 800; 
  mov d, _ship_y ; $ship_y
  push d
  mov32 cb, $00000320
  pop d
  mov [d], b
  jmp _if122_exit
_if122_exit:
; if (quad_x < 1) { 
_if123_cond:
  mov d, _quad_x ; $quad_x
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000001
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if123_exit
_if123_TRUE:
; outside = 1; 
  lea d, [bp + -26] ; $outside
  push d
  mov32 cb, $00000001
  pop d
  mov [d], bl
; quad_x = 1; 
  mov d, _quad_x ; $quad_x
  push d
  mov32 cb, $00000001
  pop d
  mov [d], b
; ship_x = 100; 
  mov d, _ship_x ; $ship_x
  push d
  mov32 cb, $00000064
  pop d
  mov [d], b
  jmp _if123_exit
_if123_exit:
; if (quad_x > 8) { 
_if124_cond:
  mov d, _quad_x ; $quad_x
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000008
  cmp a, b
  sgt ; >
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if124_exit
_if124_TRUE:
; outside = 1; 
  lea d, [bp + -26] ; $outside
  push d
  mov32 cb, $00000001
  pop d
  mov [d], bl
; quad_x = 8; 
  mov d, _quad_x ; $quad_x
  push d
  mov32 cb, $00000008
  pop d
  mov [d], b
; ship_x = 800; 
  mov d, _ship_x ; $ship_x
  push d
  mov32 cb, $00000320
  pop d
  mov [d], b
  jmp _if124_exit
_if124_exit:
; if (outside == 1) { 
_if125_cond:
  lea d, [bp + -26] ; $outside
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000001
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if125_exit
_if125_TRUE:
; printf("LT. Uhura reports:\n Message from Starfleet Command:\n\n Permission to attempt crossing of galactic perimeter\n is hereby *denied*. Shut down your engines.\n\n Chief Engineer Scott reports:\n Warp Engines shut down at sector %d, %d of quadrant %d, %d.\n\n", FROM_FIXED00(ship_y), 
; --- START FUNCTION CALL
  mov d, _quad_x ; $quad_x
  mov b, [d]
  mov c, 0
  swp b
  push b
  mov d, _quad_y ; $quad_y
  mov b, [d]
  mov c, 0
  swp b
  push b
; --- START FUNCTION CALL
  mov d, _ship_x ; $ship_x
  mov b, [d]
  mov c, 0
  swp b
  push b
  call FROM_FIXED00
  add sp, 2
; --- END FUNCTION CALL
  swp b
  push b
; --- START FUNCTION CALL
  mov d, _ship_y ; $ship_y
  mov b, [d]
  mov c, 0
  swp b
  push b
  call FROM_FIXED00
  add sp, 2
; --- END FUNCTION CALL
  swp b
  push b
  mov b, _s71 ; "LT. Uhura reports:\n Message from Starfleet Command:\n\n Permission to attempt crossing of galactic perimeter\n is hereby *denied*. Shut down your engines.\n\n Chief Engineer Scott reports:\n Warp Engines shut down at sector %d, %d of quadrant %d, %d.\n\n"
  swp b
  push b
  call printf
  add sp, 10
; --- END FUNCTION CALL
  jmp _if125_exit
_if125_exit:
; maneuver_energy(n); 
; --- START FUNCTION CALL
  lea d, [bp + -7] ; $n
  mov b, [d]
  mov c, 0
  swp b
  push b
  call maneuver_energy
  add sp, 2
; --- END FUNCTION CALL
; if (FROM_FIXED(stardate) > time_start + time_up) 
_if126_cond:
; --- START FUNCTION CALL
  mov d, _stardate ; $stardate
  mov b, [d]
  mov c, 0
  swp b
  push b
  call FROM_FIXED
  add sp, 2
; --- END FUNCTION CALL
; --- START RELATIONAL
  push a
  mov a, b
  mov d, _time_start ; $time_start
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov d, _time_up ; $time_up
  mov b, [d]
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  cmp a, b
  sgt ; >
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if126_exit
_if126_TRUE:
; end_of_time(); 
; --- START FUNCTION CALL
  call end_of_time
  jmp _if126_exit
_if126_exit:
; if (quad_y != quad_y_old || quad_x != quad_x_old) { 
_if127_cond:
  mov d, _quad_y ; $quad_y
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -27] ; $quad_y_old
  mov bl, [d]
  mov bh, 0
  mov c, 0
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
; --- START LOGICAL OR
  push a
  mov a, b
  mov d, _quad_x ; $quad_x
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -28] ; $quad_x_old
  mov bl, [d]
  mov bh, 0
  mov c, 0
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  cmp b, 0
  je _if127_exit
_if127_TRUE:
; stardate = stardate + TO_FIXED(1); 
  mov d, _stardate ; $stardate
  push d
  mov d, _stardate ; $stardate
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
; --- START FUNCTION CALL
  mov32 cb, $00000001
  swp b
  push b
  call TO_FIXED
  add sp, 2
; --- END FUNCTION CALL
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; new_quadrant(); 
; --- START FUNCTION CALL
  call new_quadrant
  jmp _if127_exit
_if127_exit:
; complete_maneuver(warp, n); 
; --- START FUNCTION CALL
  lea d, [bp + -7] ; $n
  mov b, [d]
  mov c, 0
  swp b
  push b
  lea d, [bp + -5] ; $warp
  mov b, [d]
  mov c, 0
  swp b
  push b
  call complete_maneuver
  add sp, 4
; --- END FUNCTION CALL
; return; 
  leave
  ret
  jmp _if90_exit
_if90_exit:
; if (quad[z1+-1][z2+-1] != 		0       ) {	/* Sector not empty */ 
_if128_cond:
  mov d, _quad_data ; $quad
  push a
  push d
  lea d, [bp + -15] ; $z1
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $ffffffff
  add b, a
  pop a
; --- END TERMS
  pop d
  mma 8 ; mov a, 8; mul a, b; add d, b
  push d
  lea d, [bp + -17] ; $z2
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $ffffffff
  add b, a
  pop a
; --- END TERMS
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if128_exit
_if128_TRUE:
; ship_y = ship_y - x1; 
  mov d, _ship_y ; $ship_y
  push d
  mov d, _ship_y ; $ship_y
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -19] ; $x1
  mov b, [d]
  mov c, 0
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; ship_x = ship_x - x2; 
  mov d, _ship_x ; $ship_x
  push d
  mov d, _ship_x ; $ship_x
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -21] ; $x2
  mov b, [d]
  mov c, 0
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; printf("Warp Engines shut down at sector %d, %d due to bad navigation.\n\n", z1, z2); 
; --- START FUNCTION CALL
  lea d, [bp + -17] ; $z2
  mov b, [d]
  mov c, 0
  swp b
  push b
  lea d, [bp + -15] ; $z1
  mov b, [d]
  mov c, 0
  swp b
  push b
  mov b, _s72 ; "Warp Engines shut down at sector %d, %d due to bad navigation.\n\n"
  swp b
  push b
  call printf
  add sp, 6
; --- END FUNCTION CALL
; i = n + 1; 
  lea d, [bp + -1] ; $i
  push d
  lea d, [bp + -7] ; $n
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000001
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
  jmp _if128_exit
_if128_exit:
_for89_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  mov b, a
  jmp _for89_cond
_for89_exit:
; complete_maneuver(warp, n); 
; --- START FUNCTION CALL
  lea d, [bp + -7] ; $n
  mov b, [d]
  mov c, 0
  swp b
  push b
  lea d, [bp + -5] ; $warp
  mov b, [d]
  mov c, 0
  swp b
  push b
  call complete_maneuver
  add sp, 4
; --- END FUNCTION CALL
  leave
  ret

complete_maneuver:
  enter 0 ; (push bp; mov bp, sp)
; unsigned int         time_used; 
  sub sp, 2
; place_ship(); 
; --- START FUNCTION CALL
  call place_ship
; maneuver_energy(n); 
; --- START FUNCTION CALL
  lea d, [bp + 7] ; $n
  mov b, [d]
  mov c, 0
  swp b
  push b
  call maneuver_energy
  add sp, 2
; --- END FUNCTION CALL
; time_used = TO_FIXED(1); 
  lea d, [bp + -1] ; $time_used
  push d
; --- START FUNCTION CALL
  mov32 cb, $00000001
  swp b
  push b
  call TO_FIXED
  add sp, 2
; --- END FUNCTION CALL
  pop d
  mov [d], b
; if (warp < 100) 
_if129_cond:
  lea d, [bp + 5] ; $warp
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000064
  cmp a, b
  slu ; < (unsigned)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if129_exit
_if129_TRUE:
; time_used = TO_FIXED(FROM_FIXED00(warp)); 
  lea d, [bp + -1] ; $time_used
  push d
; --- START FUNCTION CALL
; --- START FUNCTION CALL
  lea d, [bp + 5] ; $warp
  mov b, [d]
  mov c, 0
  swp b
  push b
  call FROM_FIXED00
  add sp, 2
; --- END FUNCTION CALL
  swp b
  push b
  call TO_FIXED
  add sp, 2
; --- END FUNCTION CALL
  pop d
  mov [d], b
  jmp _if129_exit
_if129_exit:
; stardate = stardate + time_used; 
  mov d, _stardate ; $stardate
  push d
  mov d, _stardate ; $stardate
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -1] ; $time_used
  mov b, [d]
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; if (FROM_FIXED(stardate) > time_start + time_up) 
_if130_cond:
; --- START FUNCTION CALL
  mov d, _stardate ; $stardate
  mov b, [d]
  mov c, 0
  swp b
  push b
  call FROM_FIXED
  add sp, 2
; --- END FUNCTION CALL
; --- START RELATIONAL
  push a
  mov a, b
  mov d, _time_start ; $time_start
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov d, _time_up ; $time_up
  mov b, [d]
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  cmp a, b
  sgt ; >
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if130_exit
_if130_TRUE:
; end_of_time(); 
; --- START FUNCTION CALL
  call end_of_time
  jmp _if130_exit
_if130_exit:
; short_range_scan(); 
; --- START FUNCTION CALL
  call short_range_scan
  leave
  ret

maneuver_energy:
  enter 0 ; (push bp; mov bp, sp)
; energy = energy - n + 10; 
  mov d, _energy ; $energy
  push d
  mov d, _energy ; $energy
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + 5] ; $n
  mov b, [d]
  mov c, 0
  sub a, b
  mov b, a
  mov a, b
  mov32 cb, $0000000a
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; if (energy >= 0) 
_if131_cond:
  mov d, _energy ; $energy
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  sge ; >=
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if131_exit
_if131_TRUE:
; return; 
  leave
  ret
  jmp _if131_exit
_if131_exit:
; puts("Shield Control supplies energy to complete maneuver.\n"); 
; --- START FUNCTION CALL
  mov b, _s73 ; "Shield Control supplies energy to complete maneuver.\n"
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; shield = shield + energy; 
  mov d, _shield ; $shield
  push d
  mov d, _shield ; $shield
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov d, _energy ; $energy
  mov b, [d]
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; energy = 0; 
  mov d, _energy ; $energy
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
; if (shield <= 0) 
_if132_cond:
  mov d, _shield ; $shield
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if132_exit
_if132_TRUE:
; shield = 0; 
  mov d, _shield ; $shield
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
  jmp _if132_exit
_if132_exit:
  leave
  ret

short_range_scan:
  enter 0 ; (push bp; mov bp, sp)
; int i, j; 
  sub sp, 2
  sub sp, 2
; char *sC = "GREEN"; 
  sub sp, 2
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -5] ; $sC
  push d
  mov b, _s74 ; "GREEN"
  pop d
  mov [d], b
; --- END LOCAL VAR INITIALIZATION
; if (energy < energy0 / 10) 
_if133_cond:
  mov d, _energy ; $energy
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov d, _energy0 ; $energy0
  mov b, [d]
  mov c, 0
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $0000000a
  push g ; save 'g' as the div instruction uses it
  div a, b ; /, a: quotient, b: remainder
  pop g
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if133_exit
_if133_TRUE:
; sC = "YELLOW"; 
  lea d, [bp + -5] ; $sC
  push d
  mov b, _s75 ; "YELLOW"
  pop d
  mov [d], b
  jmp _if133_exit
_if133_exit:
; if (klingons > 0) 
_if136_cond:
  mov d, _klingons ; $klingons
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  sgu ; > (unsigned)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if136_exit
_if136_TRUE:
; sC = "*RED*"; 
  lea d, [bp + -5] ; $sC
  push d
  mov b, _s76 ; "*RED*"
  pop d
  mov [d], b
  jmp _if136_exit
_if136_exit:
; docked = 0; 
  mov d, _docked ; $docked
  push d
  mov32 cb, $00000000
  pop d
  mov [d], bl
; for (i = (int) (FROM_FIXED00(ship_y) - 1); i <= (int) (FROM_FIXED00(ship_y) + 1); i++) 
_for137_init:
  lea d, [bp + -1] ; $i
  push d
; --- START FUNCTION CALL
  mov d, _ship_y ; $ship_y
  mov b, [d]
  mov c, 0
  swp b
  push b
  call FROM_FIXED00
  add sp, 2
; --- END FUNCTION CALL
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000001
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
_for137_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
; --- START FUNCTION CALL
  mov d, _ship_y ; $ship_y
  mov b, [d]
  mov c, 0
  swp b
  push b
  call FROM_FIXED00
  add sp, 2
; --- END FUNCTION CALL
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000001
  add b, a
  pop a
; --- END TERMS
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for137_exit
_for137_block:
; for (j = (int) (FROM_FIXED00(ship_x) - 1); j <= (int) (FROM_FIXED00(ship_x) + 1); j++) 
_for138_init:
  lea d, [bp + -3] ; $j
  push d
; --- START FUNCTION CALL
  mov d, _ship_x ; $ship_x
  mov b, [d]
  mov c, 0
  swp b
  push b
  call FROM_FIXED00
  add sp, 2
; --- END FUNCTION CALL
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000001
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
_for138_cond:
  lea d, [bp + -3] ; $j
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
; --- START FUNCTION CALL
  mov d, _ship_x ; $ship_x
  mov b, [d]
  mov c, 0
  swp b
  push b
  call FROM_FIXED00
  add sp, 2
; --- END FUNCTION CALL
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000001
  add b, a
  pop a
; --- END TERMS
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for138_exit
_for138_block:
; if (i >= 1 && i <= 8 && j >= 1 && j <= 8) { 
_if139_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000001
  cmp a, b
  sge ; >=
  pop a
; --- END RELATIONAL
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000008
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  sand a, b
  mov a, b
  lea d, [bp + -3] ; $j
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000001
  cmp a, b
  sge ; >=
  pop a
; --- END RELATIONAL
  sand a, b
  mov a, b
  lea d, [bp + -3] ; $j
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000008
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  cmp b, 0
  je _if139_exit
_if139_TRUE:
; if (quad[i+-1][j+-1] == 		2      ) { 
_if140_cond:
  mov d, _quad_data ; $quad
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $ffffffff
  add b, a
  pop a
; --- END TERMS
  pop d
  mma 8 ; mov a, 8; mul a, b; add d, b
  push d
  lea d, [bp + -3] ; $j
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $ffffffff
  add b, a
  pop a
; --- END TERMS
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000002
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if140_exit
_if140_TRUE:
; docked = 1; 
  mov d, _docked ; $docked
  push d
  mov32 cb, $00000001
  pop d
  mov [d], bl
; sC = "DOCKED"; 
  lea d, [bp + -5] ; $sC
  push d
  mov b, _s77 ; "DOCKED"
  pop d
  mov [d], b
; energy = energy0; 
  mov d, _energy ; $energy
  push d
  mov d, _energy0 ; $energy0
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
; torps = torps0; 
  mov d, _torps ; $torps
  push d
  mov d, _torps0 ; $torps0
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mov [d], bl
; puts("Shields dropped for docking purposes."); 
; --- START FUNCTION CALL
  mov b, _s78 ; "Shields dropped for docking purposes."
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; shield = 0; 
  mov d, _shield ; $shield
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
  jmp _if140_exit
_if140_exit:
  jmp _if139_exit
_if139_exit:
_for138_update:
  lea d, [bp + -3] ; $j
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -3] ; $j
  mov [d], b
  mov b, a
  jmp _for138_cond
_for138_exit:
_for137_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  mov b, a
  jmp _for137_cond
_for137_exit:
; if (damage[2] < 0) { 
_if141_cond:
  mov d, _damage_data ; $damage
  push a
  push d
  mov32 cb, $00000002
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if141_exit
_if141_TRUE:
; puts("\n*** Short Range Sensors are out ***"); 
; --- START FUNCTION CALL
  mov b, _s79 ; "\n*** Short Range Sensors are out ***"
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; return; 
  leave
  ret
  jmp _if141_exit
_if141_exit:
; puts(srs_1); 
; --- START FUNCTION CALL
  mov d, _srs_1 ; $srs_1
  mov b, [d]
  mov c, 0
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; for (i = 0; i < 8; i++) { 
_for142_init:
  lea d, [bp + -1] ; $i
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
_for142_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000008
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for142_exit
_for142_block:
; for (j = 0; j < 8; j++) 
_for143_init:
  lea d, [bp + -3] ; $j
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
_for143_cond:
  lea d, [bp + -3] ; $j
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000008
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for143_exit
_for143_block:
; puts(tilestr[quad[i][j]]); 
; --- START FUNCTION CALL
  mov d, _tilestr_data ; $tilestr
  push a
  push d
  mov d, _quad_data ; $quad
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 8 ; mov a, 8; mul a, b; add d, b
  push d
  lea d, [bp + -3] ; $j
  mov b, [d]
  mov c, 0
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
_for143_update:
  lea d, [bp + -3] ; $j
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -3] ; $j
  mov [d], b
  mov b, a
  jmp _for143_cond
_for143_exit:
; if (i == 0) 
_if144_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if144_exit
_if144_TRUE:
; printf("    Stardate            %d\n", FROM_FIXED(stardate)); 
; --- START FUNCTION CALL
; --- START FUNCTION CALL
  mov d, _stardate ; $stardate
  mov b, [d]
  mov c, 0
  swp b
  push b
  call FROM_FIXED
  add sp, 2
; --- END FUNCTION CALL
  swp b
  push b
  mov b, _s80 ; "    Stardate            %d\n"
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
  jmp _if144_exit
_if144_exit:
; if (i == 1) 
_if145_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000001
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if145_exit
_if145_TRUE:
; printf("    Condition           %s\n", sC); 
; --- START FUNCTION CALL
  lea d, [bp + -5] ; $sC
  mov b, [d]
  mov c, 0
  swp b
  push b
  mov b, _s81 ; "    Condition           %s\n"
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
  jmp _if145_exit
_if145_exit:
; if (i == 2) 
_if146_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000002
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if146_exit
_if146_TRUE:
; printf("    Quadrant            %d, %d\n", quad_y, quad_x); 
; --- START FUNCTION CALL
  mov d, _quad_x ; $quad_x
  mov b, [d]
  mov c, 0
  swp b
  push b
  mov d, _quad_y ; $quad_y
  mov b, [d]
  mov c, 0
  swp b
  push b
  mov b, _s82 ; "    Quadrant            %d, %d\n"
  swp b
  push b
  call printf
  add sp, 6
; --- END FUNCTION CALL
  jmp _if146_exit
_if146_exit:
; if (i == 3) 
_if147_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000003
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if147_exit
_if147_TRUE:
; printf("    Sector              %d, %d\n", FROM_FIXED00(ship_y), FROM_FIXED00(ship_x)); 
; --- START FUNCTION CALL
; --- START FUNCTION CALL
  mov d, _ship_x ; $ship_x
  mov b, [d]
  mov c, 0
  swp b
  push b
  call FROM_FIXED00
  add sp, 2
; --- END FUNCTION CALL
  swp b
  push b
; --- START FUNCTION CALL
  mov d, _ship_y ; $ship_y
  mov b, [d]
  mov c, 0
  swp b
  push b
  call FROM_FIXED00
  add sp, 2
; --- END FUNCTION CALL
  swp b
  push b
  mov b, _s83 ; "    Sector              %d, %d\n"
  swp b
  push b
  call printf
  add sp, 6
; --- END FUNCTION CALL
  jmp _if147_exit
_if147_exit:
; if (i == 4) 
_if148_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000004
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if148_exit
_if148_TRUE:
; printf("    Photon Torpedoes    %d\n", torps); 
; --- START FUNCTION CALL
  mov d, _torps ; $torps
  mov bl, [d]
  mov bh, 0
  mov c, 0
  swp b
  push b
  mov b, _s84 ; "    Photon Torpedoes    %d\n"
  swp b
  push b
  call printf
  add sp, 3
; --- END FUNCTION CALL
  jmp _if148_exit
_if148_exit:
; if (i == 5) 
_if149_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000005
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if149_exit
_if149_TRUE:
; printf("    Total Energy        %d\n", energy + shield); 
; --- START FUNCTION CALL
  mov d, _energy ; $energy
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov d, _shield ; $shield
  mov b, [d]
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  swp b
  push b
  mov b, _s85 ; "    Total Energy        %d\n"
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
  jmp _if149_exit
_if149_exit:
; if (i == 6) 
_if150_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000006
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if150_exit
_if150_TRUE:
; printf("    Shields             %d\n", shield); 
; --- START FUNCTION CALL
  mov d, _shield ; $shield
  mov b, [d]
  mov c, 0
  swp b
  push b
  mov b, _s86 ; "    Shields             %d\n"
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
  jmp _if150_exit
_if150_exit:
; if (i == 7) 
_if151_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000007
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if151_exit
_if151_TRUE:
; printf("    Klingons Remaining  %d\n", klingons_left); 
; --- START FUNCTION CALL
  mov d, _klingons_left ; $klingons_left
  mov bl, [d]
  mov bh, 0
  mov c, 0
  swp b
  push b
  mov b, _s87 ; "    Klingons Remaining  %d\n"
  swp b
  push b
  call printf
  add sp, 3
; --- END FUNCTION CALL
  jmp _if151_exit
_if151_exit:
_for142_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  mov b, a
  jmp _for142_cond
_for142_exit:
; puts(srs_1); 
; --- START FUNCTION CALL
  mov d, _srs_1 ; $srs_1
  mov b, [d]
  mov c, 0
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; putchar('\n'); 
; --- START FUNCTION CALL
  mov32 cb, $0000000a
  push bl
  call putchar
  add sp, 1
; --- END FUNCTION CALL
; return; 
  leave
  ret

put1bcd:
  enter 0 ; (push bp; mov bp, sp)
; v = v & 0x0F; 
  lea d, [bp + 5] ; $v
  push d
  lea d, [bp + 5] ; $v
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push a
  mov a, b
  mov32 cb, $0000000f
  and b, a ; &
  pop a
  pop d
  mov [d], bl
; putchar('0' + v); 
; --- START FUNCTION CALL
  mov32 cb, $00000030
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + 5] ; $v
  mov bl, [d]
  mov bh, 0
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  push bl
  call putchar
  add sp, 1
; --- END FUNCTION CALL
  leave
  ret

putbcd:
  enter 0 ; (push bp; mov bp, sp)
; put1bcd(x >> 8); 
; --- START FUNCTION CALL
  lea d, [bp + 5] ; $x
  mov b, [d]
  mov c, 0
; --- START SHIFT
  push a
  mov a, b
  mov32 cb, $00000008
  mov c, b
  shr a, cl
  mov b, a
  pop a
; --- END SHIFT
  push bl
  call put1bcd
  add sp, 1
; --- END FUNCTION CALL
; put1bcd(x >> 4); 
; --- START FUNCTION CALL
  lea d, [bp + 5] ; $x
  mov b, [d]
  mov c, 0
; --- START SHIFT
  push a
  mov a, b
  mov32 cb, $00000004
  mov c, b
  shr a, cl
  mov b, a
  pop a
; --- END SHIFT
  push bl
  call put1bcd
  add sp, 1
; --- END FUNCTION CALL
; put1bcd(x); 
; --- START FUNCTION CALL
  lea d, [bp + 5] ; $x
  mov b, [d]
  mov c, 0
  push bl
  call put1bcd
  add sp, 1
; --- END FUNCTION CALL
  leave
  ret

long_range_scan:
  enter 0 ; (push bp; mov bp, sp)
; int i, j; 
  sub sp, 2
  sub sp, 2
; if (inoperable(3)) 
_if152_cond:
; --- START FUNCTION CALL
  mov32 cb, $00000003
  push bl
  call inoperable
  add sp, 1
; --- END FUNCTION CALL
  cmp b, 0
  je _if152_exit
_if152_TRUE:
; return; 
  leave
  ret
  jmp _if152_exit
_if152_exit:
; printf("Long Range Scan for Quadrant %d, %d\n\n", quad_y, quad_x); 
; --- START FUNCTION CALL
  mov d, _quad_x ; $quad_x
  mov b, [d]
  mov c, 0
  swp b
  push b
  mov d, _quad_y ; $quad_y
  mov b, [d]
  mov c, 0
  swp b
  push b
  mov b, _s88 ; "Long Range Scan for Quadrant %d, %d\n\n"
  swp b
  push b
  call printf
  add sp, 6
; --- END FUNCTION CALL
; for (i = quad_y - 1; i <= quad_y + 1; i++) { 
_for153_init:
  lea d, [bp + -1] ; $i
  push d
  mov d, _quad_y ; $quad_y
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000001
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
_for153_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov d, _quad_y ; $quad_y
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000001
  add b, a
  pop a
; --- END TERMS
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for153_exit
_for153_block:
; printf("%s:", lrs_1); 
; --- START FUNCTION CALL
  mov d, _lrs_1 ; $lrs_1
  mov b, [d]
  mov c, 0
  swp b
  push b
  mov b, _s89 ; "%s:"
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
; for (j = quad_x - 1; j <= quad_x + 1; j++) { 
_for154_init:
  lea d, [bp + -3] ; $j
  push d
  mov d, _quad_x ; $quad_x
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000001
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
_for154_cond:
  lea d, [bp + -3] ; $j
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov d, _quad_x ; $quad_x
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000001
  add b, a
  pop a
; --- END TERMS
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for154_exit
_for154_block:
; putchar(' '); 
; --- START FUNCTION CALL
  mov32 cb, $00000020
  push bl
  call putchar
  add sp, 1
; --- END FUNCTION CALL
; if (i > 0 && i <= 8 && j > 0 && j <= 8) { 
_if155_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  sgt ; >
  pop a
; --- END RELATIONAL
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000008
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  sand a, b
  mov a, b
  lea d, [bp + -3] ; $j
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  sgt ; >
  pop a
; --- END RELATIONAL
  sand a, b
  mov a, b
  lea d, [bp + -3] ; $j
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000008
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  cmp b, 0
  je _if155_else
_if155_TRUE:
; map[i][j] = map[i][j] |  0x1000		           ; 
  mov d, _map_data ; $map
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 18 ; mov a, 18; mul a, b; add d, b
  push d
  lea d, [bp + -3] ; $j
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov d, _map_data ; $map
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 18 ; mov a, 18; mul a, b; add d, b
  push d
  lea d, [bp + -3] ; $j
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  push a
  mov a, b
  mov32 cb, $00001000
  or b, a ; |
  pop a
  pop d
  mov [d], b
; putbcd(map[i][j]); 
; --- START FUNCTION CALL
  mov d, _map_data ; $map
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 18 ; mov a, 18; mul a, b; add d, b
  push d
  lea d, [bp + -3] ; $j
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  swp b
  push b
  call putbcd
  add sp, 2
; --- END FUNCTION CALL
  jmp _if155_exit
_if155_else:
; puts("***"); 
; --- START FUNCTION CALL
  mov b, _s90 ; "***"
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
_if155_exit:
; puts(" :"); 
; --- START FUNCTION CALL
  mov b, _s91 ; " :"
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
_for154_update:
  lea d, [bp + -3] ; $j
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -3] ; $j
  mov [d], b
  mov b, a
  jmp _for154_cond
_for154_exit:
; putchar('\n'); 
; --- START FUNCTION CALL
  mov32 cb, $0000000a
  push bl
  call putchar
  add sp, 1
; --- END FUNCTION CALL
_for153_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  mov b, a
  jmp _for153_cond
_for153_exit:
; printf("%s\n", lrs_1); 
; --- START FUNCTION CALL
  mov d, _lrs_1 ; $lrs_1
  mov b, [d]
  mov c, 0
  swp b
  push b
  mov b, _s92 ; "%s\n"
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
  leave
  ret

no_klingon:
  enter 0 ; (push bp; mov bp, sp)
; if (klingons <= 0) { 
_if156_cond:
  mov d, _klingons ; $klingons
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  sleu ; <= (unsigned)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if156_exit
_if156_TRUE:
; puts("Science Officer Spock reports:\n  'Sensors show no enemy ships in this quadrant'\n"); 
; --- START FUNCTION CALL
  mov b, _s93 ; "Science Officer Spock reports:\n  'Sensors show no enemy ships in this quadrant'\n"
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; return 1; 
  mov32 cb, $00000001
  leave
  ret
  jmp _if156_exit
_if156_exit:
; return 0; 
  mov32 cb, $00000000
  leave
  ret

wipe_klingon:
  enter 0 ; (push bp; mov bp, sp)
; quad[k->y+-1][k->x+-1] = 		0       ; 
  mov d, _quad_data ; $quad
  push a
  push d
  lea d, [bp + 5] ; $k
  mov d, [d]
  add d, 0
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $ffffffff
  add b, a
  pop a
; --- END TERMS
  pop d
  mma 8 ; mov a, 8; mul a, b; add d, b
  push d
  lea d, [bp + 5] ; $k
  mov d, [d]
  add d, 1
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $ffffffff
  add b, a
  pop a
; --- END TERMS
  pop d
  add d, b
  pop a
  push d
  mov32 cb, $00000000
  pop d
  mov [d], bl
  leave
  ret

phaser_control:
  enter 0 ; (push bp; mov bp, sp)
; int i; 
  sub sp, 2
; long int        phaser_energy; 
  sub sp, 4
; long unsigned int         h1; 
  sub sp, 4
; int h; 
  sub sp, 2
; struct klingon *k; 
  sub sp, 2
; k = &kdata; 
  lea d, [bp + -13] ; $k
  push d
  mov d, _kdata_data ; $kdata
  mov b, d
  pop d
  mov [d], b
; if (inoperable(4)) 
_if157_cond:
; --- START FUNCTION CALL
  mov32 cb, $00000004
  push bl
  call inoperable
  add sp, 1
; --- END FUNCTION CALL
  cmp b, 0
  je _if157_exit
_if157_TRUE:
; return; 
  leave
  ret
  jmp _if157_exit
_if157_exit:
; if (no_klingon()) 
_if158_cond:
; --- START FUNCTION CALL
  call no_klingon
  cmp b, 0
  je _if158_exit
_if158_TRUE:
; return; 
  leave
  ret
  jmp _if158_exit
_if158_exit:
; if (damage[8] < 0) 
_if159_cond:
  mov d, _damage_data ; $damage
  push a
  push d
  mov32 cb, $00000008
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if159_exit
_if159_TRUE:
; puts("Computer failure hampers accuracy."); 
; --- START FUNCTION CALL
  mov b, _s94 ; "Computer failure hampers accuracy."
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
  jmp _if159_exit
_if159_exit:
; printf("Phasers locked on target;\n Energy available = %d units\n\n Number of units to fire: ", energy); 
; --- START FUNCTION CALL
  mov d, _energy ; $energy
  mov b, [d]
  mov c, 0
  swp b
  push b
  mov b, _s95 ; "Phasers locked on target;\n Energy available = %d units\n\n Number of units to fire: "
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
; phaser_energy = input_int(); 
  lea d, [bp + -5] ; $phaser_energy
  push d
; --- START FUNCTION CALL
  call input_int
  pop d
  mov [d], b
  mov b, 0
  mov [d + 2], b
; if (phaser_energy <= 0) 
_if160_cond:
  lea d, [bp + -5] ; $phaser_energy
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; --- START RELATIONAL
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $00000000
  mov c, 0
  cmp32 ga, cb
  sle
  pop g
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if160_exit
_if160_TRUE:
; return; 
  leave
  ret
  jmp _if160_exit
_if160_exit:
; if (energy - phaser_energy < 0) { 
_if161_cond:
  mov d, _energy ; $energy
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -5] ; $phaser_energy
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
  mov g, 0
  sub32 ga, cb
  mov b, a
  mov c, g
  pop a
; --- END TERMS
; --- START RELATIONAL
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $00000000
  mov c, 0
  cmp32 ga, cb
  slt ; <
  pop g
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if161_exit
_if161_TRUE:
; puts("Not enough energy available.\n"); 
; --- START FUNCTION CALL
  mov b, _s96 ; "Not enough energy available.\n"
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; return; 
  leave
  ret
  jmp _if161_exit
_if161_exit:
; energy = energy -  phaser_energy; 
  mov d, _energy ; $energy
  push d
  mov d, _energy ; $energy
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -5] ; $phaser_energy
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
  mov g, 0
  sub32 ga, cb
  mov b, a
  mov c, g
  pop a
; --- END TERMS
  pop d
  mov [d], b
; if (damage[8] < 0) 
_if162_cond:
  mov d, _damage_data ; $damage
  push a
  push d
  mov32 cb, $00000008
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if162_else
_if162_TRUE:
; phaser_energy =phaser_energy * get_rand(100); 
  lea d, [bp + -5] ; $phaser_energy
  push d
  lea d, [bp + -5] ; $phaser_energy
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
; --- START FUNCTION CALL
  mov32 cb, $00000064
  swp b
  push b
  call get_rand
  add sp, 2
; --- END FUNCTION CALL
  push a     ; save left operand
  xor a, b   ; xor sign bits
  swp a      ; swap bytes
  mov cl, al ; save result of xor into 'dl'
  pop a      ; restore left side operator
  push cl    ; save result of xor above
  swp a  
  test al, $80  
  swp a  
  jz skip_invert_a_164  
  neg a 
skip_invert_a_164:   
  swp b
  test bl, $80  
  swp b
  jz skip_invert_b_164  
  neg b 
skip_invert_b_164:   
  mul a, b ; *
  mov g, a
  mov a, b
  pop bl
  test bl, $80
  jz _same_signs_164
  mov bl, al
  not a
  neg b
  adc a, 0
  mov g, a
  mov a, b
_same_signs_164:
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  pop d
  mov [d], b
  mov b, c
  mov [d + 2], b
  jmp _if162_exit
_if162_else:
; phaser_energy = phaser_energy* 100; 
  lea d, [bp + -5] ; $phaser_energy
  push d
  lea d, [bp + -5] ; $phaser_energy
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $00000064
  push a     ; save left operand
  xor a, b   ; xor sign bits
  swp a      ; swap bytes
  mov cl, al ; save result of xor into 'dl'
  pop a      ; restore left side operator
  push cl    ; save result of xor above
  swp a  
  test al, $80  
  swp a  
  jz skip_invert_a_166  
  neg a 
skip_invert_a_166:   
  swp b
  test bl, $80  
  swp b
  jz skip_invert_b_166  
  neg b 
skip_invert_b_166:   
  mul a, b ; *
  mov g, a
  mov a, b
  pop bl
  test bl, $80
  jz _same_signs_166
  mov bl, al
  not a
  neg b
  adc a, 0
  mov g, a
  mov a, b
_same_signs_166:
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  pop d
  mov [d], b
  mov b, c
  mov [d + 2], b
_if162_exit:
; h1 = phaser_energy / klingons; 
  lea d, [bp + -9] ; $h1
  push d
  lea d, [bp + -5] ; $phaser_energy
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov d, _klingons ; $klingons
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push g ; save 'g' as the div instruction uses it
  div a, b ; /, a: quotient, b: remainder
  pop g
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  pop d
  mov [d], b
  mov b, c
  mov [d + 2], b
; for (i = 0; i <= 2; i++) { 
_for169_init:
  lea d, [bp + -1] ; $i
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
_for169_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000002
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for169_exit
_for169_block:
; if (k->energy > 0) { 
_if170_cond:
  lea d, [bp + -13] ; $k
  mov d, [d]
  add d, 2
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  sgt ; >
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if170_exit
_if170_TRUE:
; h1 = h1 * (get_rand(100) + 200); 
  lea d, [bp + -9] ; $h1
  push d
  lea d, [bp + -9] ; $h1
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
; --- START FUNCTION CALL
  mov32 cb, $00000064
  swp b
  push b
  call get_rand
  add sp, 2
; --- END FUNCTION CALL
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $000000c8
  add b, a
  pop a
; --- END TERMS
  push a     ; save left operand
  xor a, b   ; xor sign bits
  swp a      ; swap bytes
  mov cl, al ; save result of xor into 'dl'
  pop a      ; restore left side operator
  push cl    ; save result of xor above
  swp a  
  test al, $80  
  swp a  
  jz skip_invert_a_172  
  neg a 
skip_invert_a_172:   
  swp b
  test bl, $80  
  swp b
  jz skip_invert_b_172  
  neg b 
skip_invert_b_172:   
  mul a, b ; *
  mov g, a
  mov a, b
  pop bl
  test bl, $80
  jz _same_signs_172
  mov bl, al
  not a
  neg b
  adc a, 0
  mov g, a
  mov a, b
_same_signs_172:
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  pop d
  mov [d], b
  mov b, c
  mov [d + 2], b
; h1 =h1/ distance_to(k); 
  lea d, [bp + -9] ; $h1
  push d
  lea d, [bp + -9] ; $h1
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
; --- START FUNCTION CALL
  lea d, [bp + -13] ; $k
  mov b, [d]
  mov c, 0
  swp b
  push b
  call distance_to
  add sp, 2
; --- END FUNCTION CALL
  push g ; save 'g' as the div instruction uses it
  div a, b ; /, a: quotient, b: remainder
  pop g
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  pop d
  mov [d], b
  mov b, c
  mov [d + 2], b
; if (h1 <= 15 * k->energy) {	/* was 0.15 */ 
_if175_cond:
  lea d, [bp + -9] ; $h1
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; --- START RELATIONAL
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $0000000f
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  lea d, [bp + -13] ; $k
  mov d, [d]
  add d, 2
  mov b, [d]
  mov c, 0
  push a     ; save left operand
  xor a, b   ; xor sign bits
  swp a      ; swap bytes
  mov cl, al ; save result of xor into 'dl'
  pop a      ; restore left side operator
  push cl    ; save result of xor above
  swp a  
  test al, $80  
  swp a  
  jz skip_invert_a_177  
  neg a 
skip_invert_a_177:   
  swp b
  test bl, $80  
  swp b
  jz skip_invert_b_177  
  neg b 
skip_invert_b_177:   
  mul a, b ; *
  mov g, a
  mov a, b
  pop bl
  test bl, $80
  jz _same_signs_177
  mov bl, al
  not a
  neg b
  adc a, 0
  mov g, a
  mov a, b
_same_signs_177:
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  cmp32 ga, cb
  sleu
  pop g
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if175_else
_if175_TRUE:
; printf("Sensors show no damage to enemy at %d, %d\n\n", k->y, k->x); 
; --- START FUNCTION CALL
  lea d, [bp + -13] ; $k
  mov d, [d]
  add d, 1
  mov bl, [d]
  mov bh, 0
  mov c, 0
  swp b
  push b
  lea d, [bp + -13] ; $k
  mov d, [d]
  add d, 0
  mov bl, [d]
  mov bh, 0
  mov c, 0
  swp b
  push b
  mov b, _s97 ; "Sensors show no damage to enemy at %d, %d\n\n"
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
  jmp _if175_exit
_if175_else:
; h = FROM_FIXED00(h1); 
  lea d, [bp + -11] ; $h
  push d
; --- START FUNCTION CALL
  lea d, [bp + -9] ; $h1
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
  swp b
  push b
  call FROM_FIXED00
  add sp, 2
; --- END FUNCTION CALL
  pop d
  mov [d], b
; k->energy = k->energy - h; 
  lea d, [bp + -13] ; $k
  mov d, [d]
  add d, 2
  push d
  lea d, [bp + -13] ; $k
  mov d, [d]
  add d, 2
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -11] ; $h
  mov b, [d]
  mov c, 0
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; printf("%d unit hit on Klingon at sector %d, %d\n", 
; --- START FUNCTION CALL
  lea d, [bp + -13] ; $k
  mov d, [d]
  add d, 1
  mov bl, [d]
  mov bh, 0
  mov c, 0
  swp b
  push b
  lea d, [bp + -13] ; $k
  mov d, [d]
  add d, 0
  mov bl, [d]
  mov bh, 0
  mov c, 0
  swp b
  push b
  lea d, [bp + -11] ; $h
  mov b, [d]
  mov c, 0
  swp b
  push b
  mov b, _s98 ; "%d unit hit on Klingon at sector %d, %d\n"
  swp b
  push b
  call printf
  add sp, 6
; --- END FUNCTION CALL
; if (k->energy <= 0) { 
_if178_cond:
  lea d, [bp + -13] ; $k
  mov d, [d]
  add d, 2
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if178_else
_if178_TRUE:
; puts("*** Klingon Destroyed ***\n"); 
; --- START FUNCTION CALL
  mov b, _s99 ; "*** Klingon Destroyed ***\n"
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; klingons--; 
  mov d, _klingons ; $klingons
  mov bl, [d]
  mov bh, 0
  mov c, 0
  dec b
  mov d, _klingons ; $klingons
  mov [d], bl
  inc b
; klingons_left--; 
  mov d, _klingons_left ; $klingons_left
  mov bl, [d]
  mov bh, 0
  mov c, 0
  dec b
  mov d, _klingons_left ; $klingons_left
  mov [d], bl
  inc b
; wipe_klingon(k); 
; --- START FUNCTION CALL
  lea d, [bp + -13] ; $k
  mov b, [d]
  mov c, 0
  swp b
  push b
  call wipe_klingon
  add sp, 2
; --- END FUNCTION CALL
; k->energy = 0; 
  lea d, [bp + -13] ; $k
  mov d, [d]
  add d, 2
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
; map[quad_y][quad_x] = map[quad_y][quad_x] - 0x100; 
  mov d, _map_data ; $map
  push a
  push d
  mov d, _quad_y ; $quad_y
  mov b, [d]
  mov c, 0
  pop d
  mma 18 ; mov a, 18; mul a, b; add d, b
  push d
  mov d, _quad_x ; $quad_x
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov d, _map_data ; $map
  push a
  push d
  mov d, _quad_y ; $quad_y
  mov b, [d]
  mov c, 0
  pop d
  mma 18 ; mov a, 18; mul a, b; add d, b
  push d
  mov d, _quad_x ; $quad_x
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000100
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; if (klingons_left <= 0) 
_if179_cond:
  mov d, _klingons_left ; $klingons_left
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  sleu ; <= (unsigned)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if179_exit
_if179_TRUE:
; won_game(); 
; --- START FUNCTION CALL
  call won_game
  jmp _if179_exit
_if179_exit:
  jmp _if178_exit
_if178_else:
; printf("   (Sensors show %d units remaining.)\n\n", k->energy); 
; --- START FUNCTION CALL
  lea d, [bp + -13] ; $k
  mov d, [d]
  add d, 2
  mov b, [d]
  mov c, 0
  swp b
  push b
  mov b, _s100 ; "   (Sensors show %d units remaining.)\n\n"
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
_if178_exit:
_if175_exit:
  jmp _if170_exit
_if170_exit:
; k++; 
  lea d, [bp + -13] ; $k
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  inc b
  lea d, [bp + -13] ; $k
  mov [d], b
  mov b, a
_for169_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  mov b, a
  jmp _for169_cond
_for169_exit:
; klingons_shoot(); 
; --- START FUNCTION CALL
  call klingons_shoot
  leave
  ret

photon_torpedoes:
  enter 0 ; (push bp; mov bp, sp)
; int x3, y3; 
  sub sp, 2
  sub sp, 2
; int        c1; 
  sub sp, 2
; int c2, c3, c4; 
  sub sp, 2
  sub sp, 2
  sub sp, 2
; int        x, y, x1, x2; 
  sub sp, 2
  sub sp, 2
  sub sp, 2
  sub sp, 2
; if (torps <= 0) { 
_if180_cond:
  mov d, _torps ; $torps
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  sleu ; <= (unsigned)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if180_exit
_if180_TRUE:
; puts("All photon torpedoes expended"); 
; --- START FUNCTION CALL
  mov b, _s101 ; "All photon torpedoes expended"
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; return; 
  leave
  ret
  jmp _if180_exit
_if180_exit:
; if (inoperable(5)) 
_if181_cond:
; --- START FUNCTION CALL
  mov32 cb, $00000005
  push bl
  call inoperable
  add sp, 1
; --- END FUNCTION CALL
  cmp b, 0
  je _if181_exit
_if181_TRUE:
; return; 
  leave
  ret
  jmp _if181_exit
_if181_exit:
; puts("Course (0-9): "); 
; --- START FUNCTION CALL
  mov b, _s63 ; "Course (0-9): "
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; c1 = input_f00(); 
  lea d, [bp + -5] ; $c1
  push d
; --- START FUNCTION CALL
  call input_f00
  pop d
  mov [d], b
; if (c1 == 900) 
_if182_cond:
  lea d, [bp + -5] ; $c1
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000384
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if182_exit
_if182_TRUE:
; c1 = 100; 
  lea d, [bp + -5] ; $c1
  push d
  mov32 cb, $00000064
  pop d
  mov [d], b
  jmp _if182_exit
_if182_exit:
; if (c1 < 100 || c1 >= 900) { 
_if183_cond:
  lea d, [bp + -5] ; $c1
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000064
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
; --- START LOGICAL OR
  push a
  mov a, b
  lea d, [bp + -5] ; $c1
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000384
  cmp a, b
  sge ; >=
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  cmp b, 0
  je _if183_exit
_if183_TRUE:
; printf("Ensign Chekov%s", inc_1); 
; --- START FUNCTION CALL
  mov d, _inc_1 ; $inc_1
  mov b, [d]
  mov c, 0
  swp b
  push b
  mov b, _s102 ; "Ensign Chekov%s"
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
; return; 
  leave
  ret
  jmp _if183_exit
_if183_exit:
; energy = energy - 2; 
  mov d, _energy ; $energy
  push d
  mov d, _energy ; $energy
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000002
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; torps--; 
  mov d, _torps ; $torps
  mov bl, [d]
  mov bh, 0
  mov c, 0
  dec b
  mov d, _torps ; $torps
  mov [d], bl
  inc b
; c2 = FROM_FIXED00(c1);	/* Integer part */ 
  lea d, [bp + -7] ; $c2
  push d
; --- START FUNCTION CALL
  lea d, [bp + -5] ; $c1
  mov b, [d]
  mov c, 0
  swp b
  push b
  call FROM_FIXED00
  add sp, 2
; --- END FUNCTION CALL
  pop d
  mov [d], b
; c3 = c2 + 1;		/* Next integer part */ 
  lea d, [bp + -9] ; $c3
  push d
  lea d, [bp + -7] ; $c2
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000001
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; c4 = (c1 - TO_FIXED00(c2));	/* Fractional element in fixed point */ 
  lea d, [bp + -11] ; $c4
  push d
  lea d, [bp + -5] ; $c1
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
; --- START FUNCTION CALL
  lea d, [bp + -7] ; $c2
  mov b, [d]
  mov c, 0
  swp b
  push b
  call TO_FIXED00
  add sp, 2
; --- END FUNCTION CALL
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; x1 = 100 * c[1][c2] + (c[1][c3] - c[1][c2]) * c4; 
  lea d, [bp + -17] ; $x1
  push d
  mov32 cb, $00000064
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov d, _c_data ; $c
  push a
  push d
  mov32 cb, $00000001
  pop d
  mma 10 ; mov a, 10; mul a, b; add d, b
  push d
  lea d, [bp + -7] ; $c2
  mov b, [d]
  mov c, 0
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push a     ; save left operand
  xor a, b   ; xor sign bits
  swp a      ; swap bytes
  mov cl, al ; save result of xor into 'dl'
  pop a      ; restore left side operator
  push cl    ; save result of xor above
  swp a  
  test al, $80  
  swp a  
  jz skip_invert_a_186  
  neg a 
skip_invert_a_186:   
  swp b
  test bl, $80  
  swp b
  jz skip_invert_b_186  
  neg b 
skip_invert_b_186:   
  mul a, b ; *
  mov g, a
  mov a, b
  pop bl
  test bl, $80
  jz _same_signs_186
  mov bl, al
  not a
  neg b
  adc a, 0
  mov g, a
  mov a, b
_same_signs_186:
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
; --- START TERMS
  push a
  push g
  mov a, b
  mov g, c
  mov d, _c_data ; $c
  push a
  push d
  mov32 cb, $00000001
  pop d
  mma 10 ; mov a, 10; mul a, b; add d, b
  push d
  lea d, [bp + -9] ; $c3
  mov b, [d]
  mov c, 0
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov d, _c_data ; $c
  push a
  push d
  mov32 cb, $00000001
  pop d
  mma 10 ; mov a, 10; mul a, b; add d, b
  push d
  lea d, [bp + -7] ; $c2
  mov b, [d]
  mov c, 0
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
  sub a, b
  mov b, a
  pop a
; --- END TERMS
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  lea d, [bp + -11] ; $c4
  mov b, [d]
  mov c, 0
  push a     ; save left operand
  xor a, b   ; xor sign bits
  swp a      ; swap bytes
  mov cl, al ; save result of xor into 'dl'
  pop a      ; restore left side operator
  push cl    ; save result of xor above
  swp a  
  test al, $80  
  swp a  
  jz skip_invert_a_187  
  neg a 
skip_invert_a_187:   
  swp b
  test bl, $80  
  swp b
  jz skip_invert_b_187  
  neg b 
skip_invert_b_187:   
  mul a, b ; *
  mov g, a
  mov a, b
  pop bl
  test bl, $80
  jz _same_signs_187
  mov bl, al
  not a
  neg b
  adc a, 0
  mov g, a
  mov a, b
_same_signs_187:
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  add32 cb, ga
  pop g
  pop a
; --- END TERMS
  pop d
  mov [d], b
; x2 = 100 * c[2][c2] + (c[2][c3] - c[2][c2]) * c4; 
  lea d, [bp + -19] ; $x2
  push d
  mov32 cb, $00000064
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov d, _c_data ; $c
  push a
  push d
  mov32 cb, $00000002
  pop d
  mma 10 ; mov a, 10; mul a, b; add d, b
  push d
  lea d, [bp + -7] ; $c2
  mov b, [d]
  mov c, 0
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push a     ; save left operand
  xor a, b   ; xor sign bits
  swp a      ; swap bytes
  mov cl, al ; save result of xor into 'dl'
  pop a      ; restore left side operator
  push cl    ; save result of xor above
  swp a  
  test al, $80  
  swp a  
  jz skip_invert_a_190  
  neg a 
skip_invert_a_190:   
  swp b
  test bl, $80  
  swp b
  jz skip_invert_b_190  
  neg b 
skip_invert_b_190:   
  mul a, b ; *
  mov g, a
  mov a, b
  pop bl
  test bl, $80
  jz _same_signs_190
  mov bl, al
  not a
  neg b
  adc a, 0
  mov g, a
  mov a, b
_same_signs_190:
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
; --- START TERMS
  push a
  push g
  mov a, b
  mov g, c
  mov d, _c_data ; $c
  push a
  push d
  mov32 cb, $00000002
  pop d
  mma 10 ; mov a, 10; mul a, b; add d, b
  push d
  lea d, [bp + -9] ; $c3
  mov b, [d]
  mov c, 0
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov d, _c_data ; $c
  push a
  push d
  mov32 cb, $00000002
  pop d
  mma 10 ; mov a, 10; mul a, b; add d, b
  push d
  lea d, [bp + -7] ; $c2
  mov b, [d]
  mov c, 0
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
  sub a, b
  mov b, a
  pop a
; --- END TERMS
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  lea d, [bp + -11] ; $c4
  mov b, [d]
  mov c, 0
  push a     ; save left operand
  xor a, b   ; xor sign bits
  swp a      ; swap bytes
  mov cl, al ; save result of xor into 'dl'
  pop a      ; restore left side operator
  push cl    ; save result of xor above
  swp a  
  test al, $80  
  swp a  
  jz skip_invert_a_191  
  neg a 
skip_invert_a_191:   
  swp b
  test bl, $80  
  swp b
  jz skip_invert_b_191  
  neg b 
skip_invert_b_191:   
  mul a, b ; *
  mov g, a
  mov a, b
  pop bl
  test bl, $80
  jz _same_signs_191
  mov bl, al
  not a
  neg b
  adc a, 0
  mov g, a
  mov a, b
_same_signs_191:
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  add32 cb, ga
  pop g
  pop a
; --- END TERMS
  pop d
  mov [d], b
; x = ship_y + x1; 
  lea d, [bp + -13] ; $x
  push d
  mov d, _ship_y ; $ship_y
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -17] ; $x1
  mov b, [d]
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; y = ship_x + x2; 
  lea d, [bp + -15] ; $y
  push d
  mov d, _ship_x ; $ship_x
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -19] ; $x2
  mov b, [d]
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; x3 = FROM_FIXED00(x); 
  lea d, [bp + -1] ; $x3
  push d
; --- START FUNCTION CALL
  lea d, [bp + -13] ; $x
  mov b, [d]
  mov c, 0
  swp b
  push b
  call FROM_FIXED00
  add sp, 2
; --- END FUNCTION CALL
  pop d
  mov [d], b
; y3 = FROM_FIXED00(y); 
  lea d, [bp + -3] ; $y3
  push d
; --- START FUNCTION CALL
  lea d, [bp + -15] ; $y
  mov b, [d]
  mov c, 0
  swp b
  push b
  call FROM_FIXED00
  add sp, 2
; --- END FUNCTION CALL
  pop d
  mov [d], b
; puts("Torpedo Track:"); 
; --- START FUNCTION CALL
  mov b, _s103 ; "Torpedo Track:"
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; while (x3 >= 1 && x3 <= 8 && y3 >= 1 && y3 <= 8) { 
_while192_cond:
  lea d, [bp + -1] ; $x3
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000001
  cmp a, b
  sge ; >=
  pop a
; --- END RELATIONAL
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + -1] ; $x3
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000008
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  sand a, b
  mov a, b
  lea d, [bp + -3] ; $y3
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000001
  cmp a, b
  sge ; >=
  pop a
; --- END RELATIONAL
  sand a, b
  mov a, b
  lea d, [bp + -3] ; $y3
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000008
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  cmp b, 0
  je _while192_exit
_while192_block:
; unsigned char        p; 
  sub sp, 1
; printf("    %d, %d\n", x3, y3); 
; --- START FUNCTION CALL
  lea d, [bp + -3] ; $y3
  mov b, [d]
  mov c, 0
  swp b
  push b
  lea d, [bp + -1] ; $x3
  mov b, [d]
  mov c, 0
  swp b
  push b
  mov b, _s104 ; "    %d, %d\n"
  swp b
  push b
  call printf
  add sp, 6
; --- END FUNCTION CALL
; p = quad[x3+-1][y3+-1]; 
  lea d, [bp + -20] ; $p
  push d
  mov d, _quad_data ; $quad
  push a
  push d
  lea d, [bp + -1] ; $x3
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $ffffffff
  add b, a
  pop a
; --- END TERMS
  pop d
  mma 8 ; mov a, 8; mul a, b; add d, b
  push d
  lea d, [bp + -3] ; $y3
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $ffffffff
  add b, a
  pop a
; --- END TERMS
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mov [d], bl
; if (p != 		0        && p != 		4      ) { 
_if193_cond:
  lea d, [bp + -20] ; $p
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + -20] ; $p
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000004
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  cmp b, 0
  je _if193_exit
_if193_TRUE:
; torpedo_hit(x3, y3); 
; --- START FUNCTION CALL
  lea d, [bp + -3] ; $y3
  mov b, [d]
  mov c, 0
  push bl
  lea d, [bp + -1] ; $x3
  mov b, [d]
  mov c, 0
  push bl
  call torpedo_hit
  add sp, 2
; --- END FUNCTION CALL
; klingons_shoot(); 
; --- START FUNCTION CALL
  call klingons_shoot
; return; 
  leave
  ret
  jmp _if193_exit
_if193_exit:
; x = x + x1; 
  lea d, [bp + -13] ; $x
  push d
  lea d, [bp + -13] ; $x
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -17] ; $x1
  mov b, [d]
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; y = y + x2; 
  lea d, [bp + -15] ; $y
  push d
  lea d, [bp + -15] ; $y
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -19] ; $x2
  mov b, [d]
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; x3 = FROM_FIXED00(x); 
  lea d, [bp + -1] ; $x3
  push d
; --- START FUNCTION CALL
  lea d, [bp + -13] ; $x
  mov b, [d]
  mov c, 0
  swp b
  push b
  call FROM_FIXED00
  add sp, 2
; --- END FUNCTION CALL
  pop d
  mov [d], b
; y3 = FROM_FIXED00(y); 
  lea d, [bp + -3] ; $y3
  push d
; --- START FUNCTION CALL
  lea d, [bp + -15] ; $y
  mov b, [d]
  mov c, 0
  swp b
  push b
  call FROM_FIXED00
  add sp, 2
; --- END FUNCTION CALL
  pop d
  mov [d], b
  jmp _while192_cond
_while192_exit:
; puts("Torpedo Missed\n"); 
; --- START FUNCTION CALL
  mov b, _s105 ; "Torpedo Missed\n"
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; klingons_shoot(); 
; --- START FUNCTION CALL
  call klingons_shoot
  leave
  ret

torpedo_hit:
  enter 0 ; (push bp; mov bp, sp)
; int i; 
  sub sp, 2
; struct klingon *k; 
  sub sp, 2
; switch(quad[yp+-1][xp+-1]) { 
_switch194_expr:
  mov d, _quad_data ; $quad
  push a
  push d
  lea d, [bp + 5] ; $yp
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $ffffffff
  add b, a
  pop a
; --- END TERMS
  pop d
  mma 8 ; mov a, 8; mul a, b; add d, b
  push d
  lea d, [bp + 6] ; $xp
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $ffffffff
  add b, a
  pop a
; --- END TERMS
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
_switch194_comparisons:
  cmp b, 1
  je _switch194_case0
  cmp b, 3
  je _switch194_case1
  cmp b, 2
  je _switch194_case2
  jmp _switch194_exit
_switch194_case0:
; printf("Star at %d, %d absorbed torpedo energy.\n\n", yp, xp); 
; --- START FUNCTION CALL
  lea d, [bp + 6] ; $xp
  mov bl, [d]
  mov bh, 0
  mov c, 0
  swp b
  push b
  lea d, [bp + 5] ; $yp
  mov bl, [d]
  mov bh, 0
  mov c, 0
  swp b
  push b
  mov b, _s106 ; "Star at %d, %d absorbed torpedo energy.\n\n"
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
; return; 
  leave
  ret
_switch194_case1:
; puts("*** Klingon Destroyed ***\n"); 
; --- START FUNCTION CALL
  mov b, _s99 ; "*** Klingon Destroyed ***\n"
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; klingons--; 
  mov d, _klingons ; $klingons
  mov bl, [d]
  mov bh, 0
  mov c, 0
  dec b
  mov d, _klingons ; $klingons
  mov [d], bl
  inc b
; klingons_left--; 
  mov d, _klingons_left ; $klingons_left
  mov bl, [d]
  mov bh, 0
  mov c, 0
  dec b
  mov d, _klingons_left ; $klingons_left
  mov [d], bl
  inc b
; if (klingons_left <= 0) 
_if195_cond:
  mov d, _klingons_left ; $klingons_left
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  sleu ; <= (unsigned)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if195_exit
_if195_TRUE:
; won_game(); 
; --- START FUNCTION CALL
  call won_game
  jmp _if195_exit
_if195_exit:
; k = kdata; 
  lea d, [bp + -3] ; $k
  push d
  mov d, _kdata_data ; $kdata
  mov b, d
  mov c, 0
  pop d
  mov [d], b
; for (i = 0; i <= 2; i++) { 
_for196_init:
  lea d, [bp + -1] ; $i
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
_for196_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000002
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for196_exit
_for196_block:
; if (yp == k->y && xp == k->x) 
_if197_cond:
  lea d, [bp + 5] ; $yp
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -3] ; $k
  mov d, [d]
  add d, 0
  mov bl, [d]
  mov bh, 0
  mov c, 0
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + 6] ; $xp
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -3] ; $k
  mov d, [d]
  add d, 1
  mov bl, [d]
  mov bh, 0
  mov c, 0
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  cmp b, 0
  je _if197_exit
_if197_TRUE:
; k->energy = 0; 
  lea d, [bp + -3] ; $k
  mov d, [d]
  add d, 2
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
  jmp _if197_exit
_if197_exit:
; k++; 
  lea d, [bp + -3] ; $k
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  inc b
  lea d, [bp + -3] ; $k
  mov [d], b
  mov b, a
_for196_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  mov b, a
  jmp _for196_cond
_for196_exit:
; map[quad_y][quad_x] =map[quad_y][quad_x] - 0x100; 
  mov d, _map_data ; $map
  push a
  push d
  mov d, _quad_y ; $quad_y
  mov b, [d]
  mov c, 0
  pop d
  mma 18 ; mov a, 18; mul a, b; add d, b
  push d
  mov d, _quad_x ; $quad_x
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov d, _map_data ; $map
  push a
  push d
  mov d, _quad_y ; $quad_y
  mov b, [d]
  mov c, 0
  pop d
  mma 18 ; mov a, 18; mul a, b; add d, b
  push d
  mov d, _quad_x ; $quad_x
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000100
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; break; 
  jmp _switch194_exit ; case break
_switch194_case2:
; puts("*** Starbase Destroyed ***"); 
; --- START FUNCTION CALL
  mov b, _s107 ; "*** Starbase Destroyed ***"
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; starbases--; 
  mov d, _starbases ; $starbases
  mov bl, [d]
  mov bh, 0
  mov c, 0
  dec b
  mov d, _starbases ; $starbases
  mov [d], bl
  inc b
; starbases_left--; 
  mov d, _starbases_left ; $starbases_left
  mov bl, [d]
  mov bh, 0
  mov c, 0
  dec b
  mov d, _starbases_left ; $starbases_left
  mov [d], bl
  inc b
; if (starbases_left <= 0 && klingons_left <= FROM_FIXED(stardate) - time_start - time_up) { 
_if198_cond:
  mov d, _starbases_left ; $starbases_left
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
; --- START LOGICAL AND
  push a
  mov a, b
  mov d, _klingons_left ; $klingons_left
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
; --- START FUNCTION CALL
  mov d, _stardate ; $stardate
  mov b, [d]
  mov c, 0
  swp b
  push b
  call FROM_FIXED
  add sp, 2
; --- END FUNCTION CALL
; --- START TERMS
  push a
  mov a, b
  mov d, _time_start ; $time_start
  mov b, [d]
  mov c, 0
  sub a, b
  mov b, a
  mov a, b
  mov d, _time_up ; $time_up
  mov b, [d]
  mov c, 0
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  cmp a, b
  sleu ; <= (unsigned)
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  cmp b, 0
  je _if198_exit
_if198_TRUE:
; puts("That does it, Captain!!"); 
; --- START FUNCTION CALL
  mov b, _s108 ; "That does it, Captain!!"
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; puts("You are hereby relieved of command\n"); 
; --- START FUNCTION CALL
  mov b, _s109 ; "You are hereby relieved of command\n"
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; puts("and sentenced to 99 stardates of hard"); 
; --- START FUNCTION CALL
  mov b, _s110 ; "and sentenced to 99 stardates of hard"
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; puts("labor on Cygnus 12!!\n"); 
; --- START FUNCTION CALL
  mov b, _s111 ; "labor on Cygnus 12!!\n"
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; resign_commision(); 
; --- START FUNCTION CALL
  call resign_commision
  jmp _if198_exit
_if198_exit:
; puts("Starfleet Command reviewing your record to consider\n court martial!\n"); 
; --- START FUNCTION CALL
  mov b, _s112 ; "Starfleet Command reviewing your record to consider\n court martial!\n"
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; docked = 0;		/* Undock */ 
  mov d, _docked ; $docked
  push d
  mov32 cb, $00000000
  pop d
  mov [d], bl
; map[quad_y][quad_x] =map[quad_y][quad_x] - 0x10; 
  mov d, _map_data ; $map
  push a
  push d
  mov d, _quad_y ; $quad_y
  mov b, [d]
  mov c, 0
  pop d
  mma 18 ; mov a, 18; mul a, b; add d, b
  push d
  mov d, _quad_x ; $quad_x
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov d, _map_data ; $map
  push a
  push d
  mov d, _quad_y ; $quad_y
  mov b, [d]
  mov c, 0
  pop d
  mma 18 ; mov a, 18; mul a, b; add d, b
  push d
  mov d, _quad_x ; $quad_x
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000010
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; break; 
  jmp _switch194_exit ; case break
_switch194_exit:
; quad[yp+-1][xp+-1] = 		0       ; 
  mov d, _quad_data ; $quad
  push a
  push d
  lea d, [bp + 5] ; $yp
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $ffffffff
  add b, a
  pop a
; --- END TERMS
  pop d
  mma 8 ; mov a, 8; mul a, b; add d, b
  push d
  lea d, [bp + 6] ; $xp
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $ffffffff
  add b, a
  pop a
; --- END TERMS
  pop d
  add d, b
  pop a
  push d
  mov32 cb, $00000000
  pop d
  mov [d], bl
  leave
  ret

damage_control:
  enter 0 ; (push bp; mov bp, sp)
; int        repair_cost = 0; 
  sub sp, 2
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -1] ; $repair_cost
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
; --- END LOCAL VAR INITIALIZATION
; int i; 
  sub sp, 2
; if (damage[6] < 0) 
_if199_cond:
  mov d, _damage_data ; $damage
  push a
  push d
  mov32 cb, $00000006
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if199_exit
_if199_TRUE:
; puts("Damage Control report not available."); 
; --- START FUNCTION CALL
  mov b, _s113 ; "Damage Control report not available."
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
  jmp _if199_exit
_if199_exit:
; if (docked) { 
_if200_cond:
  mov d, _docked ; $docked
  mov bl, [d]
  mov bh, 0
  mov c, 0
  cmp b, 0
  je _if200_exit
_if200_TRUE:
; repair_cost = 0; 
  lea d, [bp + -1] ; $repair_cost
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
; for (i = 1; i <= 8; i++) 
_for201_init:
  lea d, [bp + -3] ; $i
  push d
  mov32 cb, $00000001
  pop d
  mov [d], b
_for201_cond:
  lea d, [bp + -3] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000008
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for201_exit
_for201_block:
; if (damage[i] < 0) 
_if202_cond:
  mov d, _damage_data ; $damage
  push a
  push d
  lea d, [bp + -3] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if202_exit
_if202_TRUE:
; repair_cost = repair_cost + 10; 
  lea d, [bp + -1] ; $repair_cost
  push d
  lea d, [bp + -1] ; $repair_cost
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $0000000a
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
  jmp _if202_exit
_if202_exit:
_for201_update:
  lea d, [bp + -3] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -3] ; $i
  mov [d], b
  mov b, a
  jmp _for201_cond
_for201_exit:
; if (repair_cost) { 
_if203_cond:
  lea d, [bp + -1] ; $repair_cost
  mov b, [d]
  mov c, 0
  cmp b, 0
  je _if203_exit
_if203_TRUE:
; repair_cost = repair_cost + d4; 
  lea d, [bp + -1] ; $repair_cost
  push d
  lea d, [bp + -1] ; $repair_cost
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov d, _d4 ; $d4
  mov b, [d]
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; if (repair_cost >= 100) 
_if204_cond:
  lea d, [bp + -1] ; $repair_cost
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000064
  cmp a, b
  sge ; >=
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if204_exit
_if204_TRUE:
; repair_cost = 90;	/* 0.9 */ 
  lea d, [bp + -1] ; $repair_cost
  push d
  mov32 cb, $0000005a
  pop d
  mov [d], b
  jmp _if204_exit
_if204_exit:
; printf("\nTechnicians standing by to effect repairs to your ship;\nEstimated time to repair: %s stardates.\n Will you authorize the repair order (y/N)? ", print100(repair_cost)); 
; --- START FUNCTION CALL
; --- START FUNCTION CALL
  lea d, [bp + -1] ; $repair_cost
  mov b, [d]
  mov c, 0
  swp b
  push b
  call print100
  add sp, 2
; --- END FUNCTION CALL
  swp b
  push b
  mov b, _s114 ; "\nTechnicians standing by to effect repairs to your ship;\nEstimated time to repair: %s stardates.\n Will you authorize the repair order (y/N)? "
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
; if (yesno()) { 
_if205_cond:
; --- START FUNCTION CALL
  call yesno
  cmp b, 0
  je _if205_exit
_if205_TRUE:
; for (i = 1; i <= 8; i++) 
_for206_init:
  lea d, [bp + -3] ; $i
  push d
  mov32 cb, $00000001
  pop d
  mov [d], b
_for206_cond:
  lea d, [bp + -3] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000008
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for206_exit
_for206_block:
; if (damage[i] < 0) 
_if207_cond:
  mov d, _damage_data ; $damage
  push a
  push d
  lea d, [bp + -3] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if207_exit
_if207_TRUE:
; damage[i] = 0; 
  mov d, _damage_data ; $damage
  push a
  push d
  lea d, [bp + -3] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
  jmp _if207_exit
_if207_exit:
_for206_update:
  lea d, [bp + -3] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -3] ; $i
  mov [d], b
  mov b, a
  jmp _for206_cond
_for206_exit:
; stardate = stardate + (repair_cost + 5)/10 + 1; 
  mov d, _stardate ; $stardate
  push d
  mov d, _stardate ; $stardate
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -1] ; $repair_cost
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000005
  add b, a
  pop a
; --- END TERMS
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $0000000a
  push g ; save 'g' as the div instruction uses it
  div a, b ; /, a: quotient, b: remainder
  pop g
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  add b, a
  mov a, b
  mov32 cb, $00000001
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
  jmp _if205_exit
_if205_exit:
; return; 
  leave
  ret
  jmp _if203_exit
_if203_exit:
  jmp _if200_exit
_if200_exit:
; if (damage[6] < 0) 
_if210_cond:
  mov d, _damage_data ; $damage
  push a
  push d
  mov32 cb, $00000006
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if210_exit
_if210_TRUE:
; return; 
  leave
  ret
  jmp _if210_exit
_if210_exit:
; puts("Device            State of Repair"); 
; --- START FUNCTION CALL
  mov b, _s115 ; "Device            State of Repair"
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; for (i = 1; i <= 8; i++) 
_for211_init:
  lea d, [bp + -3] ; $i
  push d
  mov32 cb, $00000001
  pop d
  mov [d], b
_for211_cond:
  lea d, [bp + -3] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000008
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for211_exit
_for211_block:
; printf("%-25s%6s\n", get_device_name(i), print100(damage[i])); 
; --- START FUNCTION CALL
; --- START FUNCTION CALL
  mov d, _damage_data ; $damage
  push a
  push d
  lea d, [bp + -3] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  swp b
  push b
  call print100
  add sp, 2
; --- END FUNCTION CALL
  swp b
  push b
; --- START FUNCTION CALL
  lea d, [bp + -3] ; $i
  mov b, [d]
  mov c, 0
  swp b
  push b
  call get_device_name
  add sp, 2
; --- END FUNCTION CALL
  swp b
  push b
  mov b, _s116 ; "%-25s%6s\n"
  swp b
  push b
  call printf
  add sp, 6
; --- END FUNCTION CALL
_for211_update:
  lea d, [bp + -3] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -3] ; $i
  mov [d], b
  mov b, a
  jmp _for211_cond
_for211_exit:
; printf("\n"); 
; --- START FUNCTION CALL
  mov b, _s117 ; "\n"
  swp b
  push b
  call printf
  add sp, 2
; --- END FUNCTION CALL
  leave
  ret

shield_control:
  enter 0 ; (push bp; mov bp, sp)
; int i; 
  sub sp, 2
; if (inoperable(7)) 
_if212_cond:
; --- START FUNCTION CALL
  mov32 cb, $00000007
  push bl
  call inoperable
  add sp, 1
; --- END FUNCTION CALL
  cmp b, 0
  je _if212_exit
_if212_TRUE:
; return; 
  leave
  ret
  jmp _if212_exit
_if212_exit:
; printf("Energy available = %d\n\n Input number of units to shields: ", energy + shield); 
; --- START FUNCTION CALL
  mov d, _energy ; $energy
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov d, _shield ; $shield
  mov b, [d]
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  swp b
  push b
  mov b, _s118 ; "Energy available = %d\n\n Input number of units to shields: "
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
; i = input_int(); 
  lea d, [bp + -1] ; $i
  push d
; --- START FUNCTION CALL
  call input_int
  pop d
  mov [d], b
; if (i < 0 || shield == i) { 
_if213_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
; --- START LOGICAL OR
  push a
  mov a, b
  mov d, _shield ; $shield
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  cmp b, 0
  je _if213_exit
_if213_TRUE:
; puts("<Shields Unchanged>\n"); 
; --- START FUNCTION CALL
  mov b, _s119 ; "<Shields Unchanged>\n"
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; return; 
  leave
  ret
  jmp _if213_exit
_if213_exit:
; if (i >= energy + shield) { 
_if214_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov d, _energy ; $energy
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov d, _shield ; $shield
  mov b, [d]
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  cmp a, b
  sge ; >=
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if214_exit
_if214_TRUE:
; puts("Shield Control Reports:\n  'This is not the Federation Treasury.'"); 
; --- START FUNCTION CALL
  mov b, _s120 ; "Shield Control Reports:\n  'This is not the Federation Treasury.'"
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
  jmp _if214_exit
_if214_exit:
; energy = energy + shield - i; 
  mov d, _energy ; $energy
  push d
  mov d, _energy ; $energy
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov d, _shield ; $shield
  mov b, [d]
  mov c, 0
  add b, a
  mov a, b
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; shield = i; 
  mov d, _shield ; $shield
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
; printf("Deflector Control Room report:\n  'Shields now at %d units per your command.'\n\n", shield); 
; --- START FUNCTION CALL
  mov d, _shield ; $shield
  mov b, [d]
  mov c, 0
  swp b
  push b
  mov b, _s121 ; "Deflector Control Room report:\n  'Shields now at %d units per your command.'\n\n"
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
  leave
  ret

library_computer:
  enter 0 ; (push bp; mov bp, sp)
; if (inoperable(8)) 
_if215_cond:
; --- START FUNCTION CALL
  mov32 cb, $00000008
  push bl
  call inoperable
  add sp, 1
; --- END FUNCTION CALL
  cmp b, 0
  je _if215_exit
_if215_TRUE:
; return; 
  leave
  ret
  jmp _if215_exit
_if215_exit:
; puts("Computer active and awating command: "); 
; --- START FUNCTION CALL
  mov b, _s122 ; "Computer active and awating command: "
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; switch(input_int()) { 
_switch216_expr:
; --- START FUNCTION CALL
  call input_int
_switch216_comparisons:
  cmp b, -1
  je _switch216_case0
  cmp b, 0
  je _switch216_case1
  cmp b, 1
  je _switch216_case2
  cmp b, 2
  je _switch216_case3
  cmp b, 3
  je _switch216_case4
  cmp b, 4
  je _switch216_case5
  cmp b, 5
  je _switch216_case6
  jmp _switch216_default
  jmp _switch216_exit
_switch216_case0:
; break; 
  jmp _switch216_exit ; case break
_switch216_case1:
; galactic_record(); 
; --- START FUNCTION CALL
  call galactic_record
; break; 
  jmp _switch216_exit ; case break
_switch216_case2:
; status_report(); 
; --- START FUNCTION CALL
  call status_report
; break; 
  jmp _switch216_exit ; case break
_switch216_case3:
; torpedo_data(); 
; --- START FUNCTION CALL
  call torpedo_data
; break; 
  jmp _switch216_exit ; case break
_switch216_case4:
; nav_data(); 
; --- START FUNCTION CALL
  call nav_data
; break; 
  jmp _switch216_exit ; case break
_switch216_case5:
; dirdist_calc(); 
; --- START FUNCTION CALL
  call dirdist_calc
; break; 
  jmp _switch216_exit ; case break
_switch216_case6:
; galaxy_map(); 
; --- START FUNCTION CALL
  call galaxy_map
; break; 
  jmp _switch216_exit ; case break
_switch216_default:
; puts("Functions available from Library-Computer:\n\n"); 
; --- START FUNCTION CALL
  mov b, _s123 ; "Functions available from Library-Computer:\n\n"
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; puts("   0 = Cumulative Galactic Record\n"); 
; --- START FUNCTION CALL
  mov b, _s124 ; "   0 = Cumulative Galactic Record\n"
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; puts("   1 = Status Report\n"); 
; --- START FUNCTION CALL
  mov b, _s125 ; "   1 = Status Report\n"
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; puts("   2 = Photon Torpedo Data\n"); 
; --- START FUNCTION CALL
  mov b, _s126 ; "   2 = Photon Torpedo Data\n"
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; puts("   3 = Starbase Nav Data\n"); 
; --- START FUNCTION CALL
  mov b, _s127 ; "   3 = Starbase Nav Data\n"
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; puts("   4 = Direction/Distance Calculator\n"); 
; --- START FUNCTION CALL
  mov b, _s128 ; "   4 = Direction/Distance Calculator\n"
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; puts("   5 = Galaxy 'Region Name' Map\n"); 
; --- START FUNCTION CALL
  mov b, _s129 ; "   5 = Galaxy 'Region Name' Map\n"
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
_switch216_exit:
  leave
  ret

galactic_record:
  enter 0 ; (push bp; mov bp, sp)
; int i, j; 
  sub sp, 2
  sub sp, 2
; printf("\n     Computer Record of Galaxy for Quadrant %d,%d\n\n", quad_y, quad_x); 
; --- START FUNCTION CALL
  mov d, _quad_x ; $quad_x
  mov b, [d]
  mov c, 0
  swp b
  push b
  mov d, _quad_y ; $quad_y
  mov b, [d]
  mov c, 0
  swp b
  push b
  mov b, _s130 ; "\n     Computer Record of Galaxy for Quadrant %d,%d\n\n"
  swp b
  push b
  call printf
  add sp, 6
; --- END FUNCTION CALL
; puts("     1     2     3     4     5     6     7     8"); 
; --- START FUNCTION CALL
  mov b, _s131 ; "     1     2     3     4     5     6     7     8"
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; for (i = 1; i <= 8; i++) { 
_for217_init:
  lea d, [bp + -1] ; $i
  push d
  mov32 cb, $00000001
  pop d
  mov [d], b
_for217_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000008
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for217_exit
_for217_block:
; printf("%s%d", gr_1, i); 
; --- START FUNCTION CALL
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  swp b
  push b
  mov d, _gr_1 ; $gr_1
  mov b, [d]
  mov c, 0
  swp b
  push b
  mov b, _s132 ; "%s%d"
  swp b
  push b
  call printf
  add sp, 6
; --- END FUNCTION CALL
; for (j = 1; j <= 8; j++) { 
_for218_init:
  lea d, [bp + -3] ; $j
  push d
  mov32 cb, $00000001
  pop d
  mov [d], b
_for218_cond:
  lea d, [bp + -3] ; $j
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000008
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for218_exit
_for218_block:
; printf("   "); 
; --- START FUNCTION CALL
  mov b, _s25 ; "   "
  swp b
  push b
  call printf
  add sp, 2
; --- END FUNCTION CALL
; if (map[i][j] &  0x1000		           ) 
_if219_cond:
  mov d, _map_data ; $map
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 18 ; mov a, 18; mul a, b; add d, b
  push d
  lea d, [bp + -3] ; $j
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  push a
  mov a, b
  mov32 cb, $00001000
  and b, a ; &
  pop a
  cmp b, 0
  je _if219_else
_if219_TRUE:
; putbcd(map[i][j]); 
; --- START FUNCTION CALL
  mov d, _map_data ; $map
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 18 ; mov a, 18; mul a, b; add d, b
  push d
  lea d, [bp + -3] ; $j
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  swp b
  push b
  call putbcd
  add sp, 2
; --- END FUNCTION CALL
  jmp _if219_exit
_if219_else:
; printf("***"); 
; --- START FUNCTION CALL
  mov b, _s90 ; "***"
  swp b
  push b
  call printf
  add sp, 2
; --- END FUNCTION CALL
_if219_exit:
_for218_update:
  lea d, [bp + -3] ; $j
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -3] ; $j
  mov [d], b
  mov b, a
  jmp _for218_cond
_for218_exit:
; putchar('\n'); 
; --- START FUNCTION CALL
  mov32 cb, $0000000a
  push bl
  call putchar
  add sp, 1
; --- END FUNCTION CALL
_for217_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  mov b, a
  jmp _for217_cond
_for217_exit:
; printf("%s\n", gr_1); 
; --- START FUNCTION CALL
  mov d, _gr_1 ; $gr_1
  mov b, [d]
  mov c, 0
  swp b
  push b
  mov b, _s92 ; "%s\n"
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
  leave
  ret

status_report:
  enter 0 ; (push bp; mov bp, sp)
; char *plural; 
  sub sp, 2
; plural = str_s + 1; 
  lea d, [bp + -1] ; $plural
  push d
  mov d, _str_s ; $str_s
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000001
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; unsigned int         left; 
  sub sp, 2
; left = TO_FIXED(time_start + time_up) - stardate; 
  lea d, [bp + -3] ; $left
  push d
; --- START FUNCTION CALL
  mov d, _time_start ; $time_start
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov d, _time_up ; $time_up
  mov b, [d]
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  swp b
  push b
  call TO_FIXED
  add sp, 2
; --- END FUNCTION CALL
; --- START TERMS
  push a
  mov a, b
  mov d, _stardate ; $stardate
  mov b, [d]
  mov c, 0
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; puts("   Status Report:\n"); 
; --- START FUNCTION CALL
  mov b, _s133 ; "   Status Report:\n"
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; if (klingons_left > 1) 
_if220_cond:
  mov d, _klingons_left ; $klingons_left
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000001
  cmp a, b
  sgu ; > (unsigned)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if220_exit
_if220_TRUE:
; plural = str_s; 
  lea d, [bp + -1] ; $plural
  push d
  mov d, _str_s ; $str_s
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
  jmp _if220_exit
_if220_exit:
; printf("Klingon%s Left: %d\n Mission must be completed in %d.%d stardates\n", 
; --- START FUNCTION CALL
  lea d, [bp + -3] ; $left
  mov b, [d]
  mov c, 0
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $0000000a
  push g ; save 'g' as the div instruction uses it
  div a, b ; %, a: quotient, b: remainder
  mov a, b
  pop g
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  swp b
  push b
; --- START FUNCTION CALL
  lea d, [bp + -3] ; $left
  mov b, [d]
  mov c, 0
  swp b
  push b
  call FROM_FIXED
  add sp, 2
; --- END FUNCTION CALL
  swp b
  push b
  mov d, _klingons_left ; $klingons_left
  mov bl, [d]
  mov bh, 0
  mov c, 0
  swp b
  push b
  lea d, [bp + -1] ; $plural
  mov b, [d]
  mov c, 0
  swp b
  push b
  mov b, _s134 ; "Klingon%s Left: %d\n Mission must be completed in %d.%d stardates\n"
  swp b
  push b
  call printf
  add sp, 9
; --- END FUNCTION CALL
; if (starbases_left < 1) { 
_if225_cond:
  mov d, _starbases_left ; $starbases_left
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000001
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if225_else
_if225_TRUE:
; puts("Your stupidity has left you on your own in the galaxy\n -- you have no starbases left!\n"); 
; --- START FUNCTION CALL
  mov b, _s135 ; "Your stupidity has left you on your own in the galaxy\n -- you have no starbases left!\n"
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
  jmp _if225_exit
_if225_else:
; plural = str_s; 
  lea d, [bp + -1] ; $plural
  push d
  mov d, _str_s ; $str_s
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
; if (starbases_left < 2) 
_if226_cond:
  mov d, _starbases_left ; $starbases_left
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000002
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if226_exit
_if226_TRUE:
; plural++; 
  lea d, [bp + -1] ; $plural
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -1] ; $plural
  mov [d], b
  dec b
  jmp _if226_exit
_if226_exit:
; printf("The Federation is maintaining %d starbase%s in the galaxy\n\n", starbases_left, plural); 
; --- START FUNCTION CALL
  lea d, [bp + -1] ; $plural
  mov b, [d]
  mov c, 0
  swp b
  push b
  mov d, _starbases_left ; $starbases_left
  mov bl, [d]
  mov bh, 0
  mov c, 0
  swp b
  push b
  mov b, _s136 ; "The Federation is maintaining %d starbase%s in the galaxy\n\n"
  swp b
  push b
  call printf
  add sp, 5
; --- END FUNCTION CALL
_if225_exit:
  leave
  ret

torpedo_data:
  enter 0 ; (push bp; mov bp, sp)
; int i; 
  sub sp, 2
; char *plural; 
  sub sp, 2
; plural = str_s + 1; 
  lea d, [bp + -3] ; $plural
  push d
  mov d, _str_s ; $str_s
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000001
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; struct klingon *k; 
  sub sp, 2
; if (no_klingon()) 
_if227_cond:
; --- START FUNCTION CALL
  call no_klingon
  cmp b, 0
  je _if227_exit
_if227_TRUE:
; return; 
  leave
  ret
  jmp _if227_exit
_if227_exit:
; if (klingons > 1) 
_if228_cond:
  mov d, _klingons ; $klingons
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000001
  cmp a, b
  sgu ; > (unsigned)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if228_exit
_if228_TRUE:
; plural--; 
  lea d, [bp + -3] ; $plural
  mov b, [d]
  mov c, 0
  dec b
  lea d, [bp + -3] ; $plural
  mov [d], b
  inc b
  jmp _if228_exit
_if228_exit:
; printf("From Enterprise to Klingon battlecriuser%s:\n\n", plural); 
; --- START FUNCTION CALL
  lea d, [bp + -3] ; $plural
  mov b, [d]
  mov c, 0
  swp b
  push b
  mov b, _s137 ; "From Enterprise to Klingon battlecriuser%s:\n\n"
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
; k = kdata; 
  lea d, [bp + -5] ; $k
  push d
  mov d, _kdata_data ; $kdata
  mov b, d
  mov c, 0
  pop d
  mov [d], b
; for (i = 0; i <= 2; i++) { 
_for229_init:
  lea d, [bp + -1] ; $i
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
_for229_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000002
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for229_exit
_for229_block:
; if (k->energy > 0) { 
_if230_cond:
  lea d, [bp + -5] ; $k
  mov d, [d]
  add d, 2
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  sgt ; >
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if230_exit
_if230_TRUE:
; compute_vector(TO_FIXED00(k->y), 
; --- START FUNCTION CALL
  mov d, _ship_x ; $ship_x
  mov b, [d]
  mov c, 0
  swp b
  push b
  mov d, _ship_y ; $ship_y
  mov b, [d]
  mov c, 0
  swp b
  push b
; --- START FUNCTION CALL
  lea d, [bp + -5] ; $k
  mov d, [d]
  add d, 1
  mov bl, [d]
  mov bh, 0
  mov c, 0
  snex b
  swp b
  push b
  call TO_FIXED00
  add sp, 2
; --- END FUNCTION CALL
  swp b
  push b
; --- START FUNCTION CALL
  lea d, [bp + -5] ; $k
  mov d, [d]
  add d, 0
  mov bl, [d]
  mov bh, 0
  mov c, 0
  snex b
  swp b
  push b
  call TO_FIXED00
  add sp, 2
; --- END FUNCTION CALL
  swp b
  push b
  call compute_vector
  add sp, 8
; --- END FUNCTION CALL
  jmp _if230_exit
_if230_exit:
; k++; 
  lea d, [bp + -5] ; $k
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  inc b
  lea d, [bp + -5] ; $k
  mov [d], b
  mov b, a
_for229_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  mov b, a
  jmp _for229_cond
_for229_exit:
  leave
  ret

nav_data:
  enter 0 ; (push bp; mov bp, sp)
; if (starbases <= 0) { 
_if231_cond:
  mov d, _starbases ; $starbases
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if231_exit
_if231_TRUE:
; puts("Mr. Spock reports,\n  'Sensors show no starbases in this quadrant.'\n"); 
; --- START FUNCTION CALL
  mov b, _s138 ; "Mr. Spock reports,\n  'Sensors show no starbases in this quadrant.'\n"
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; return; 
  leave
  ret
  jmp _if231_exit
_if231_exit:
; compute_vector(TO_FIXED00(base_y), TO_FIXED00(base_x), ship_y, ship_x); 
; --- START FUNCTION CALL
  mov d, _ship_x ; $ship_x
  mov b, [d]
  mov c, 0
  swp b
  push b
  mov d, _ship_y ; $ship_y
  mov b, [d]
  mov c, 0
  swp b
  push b
; --- START FUNCTION CALL
  mov d, _base_x ; $base_x
  mov bl, [d]
  mov bh, 0
  mov c, 0
  snex b
  swp b
  push b
  call TO_FIXED00
  add sp, 2
; --- END FUNCTION CALL
  swp b
  push b
; --- START FUNCTION CALL
  mov d, _base_y ; $base_y
  mov bl, [d]
  mov bh, 0
  mov c, 0
  snex b
  swp b
  push b
  call TO_FIXED00
  add sp, 2
; --- END FUNCTION CALL
  swp b
  push b
  call compute_vector
  add sp, 8
; --- END FUNCTION CALL
  leave
  ret

dirdist_calc:
  enter 0 ; (push bp; mov bp, sp)
; int        c1, a, w1, x; 
  sub sp, 2
  sub sp, 2
  sub sp, 2
  sub sp, 2
; printf("Direction/Distance Calculator\n You are at quadrant %d,%d sector %d,%d\n\n Please enter initial X coordinate: ", 
; --- START FUNCTION CALL
; --- START FUNCTION CALL
  mov d, _ship_x ; $ship_x
  mov b, [d]
  mov c, 0
  swp b
  push b
  call FROM_FIXED00
  add sp, 2
; --- END FUNCTION CALL
  swp b
  push b
; --- START FUNCTION CALL
  mov d, _ship_y ; $ship_y
  mov b, [d]
  mov c, 0
  swp b
  push b
  call FROM_FIXED00
  add sp, 2
; --- END FUNCTION CALL
  swp b
  push b
  mov d, _quad_x ; $quad_x
  mov b, [d]
  mov c, 0
  swp b
  push b
  mov d, _quad_y ; $quad_y
  mov b, [d]
  mov c, 0
  swp b
  push b
  mov b, _s139 ; "Direction/Distance Calculator\n You are at quadrant %d,%d sector %d,%d\n\n Please enter initial X coordinate: "
  swp b
  push b
  call printf
  add sp, 10
; --- END FUNCTION CALL
; c1 = TO_FIXED00(input_int()); 
  lea d, [bp + -1] ; $c1
  push d
; --- START FUNCTION CALL
; --- START FUNCTION CALL
  call input_int
  swp b
  push b
  call TO_FIXED00
  add sp, 2
; --- END FUNCTION CALL
  pop d
  mov [d], b
; if (c1 < 0 || c1 > 900 ) 
_if232_cond:
  lea d, [bp + -1] ; $c1
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
; --- START LOGICAL OR
  push a
  mov a, b
  lea d, [bp + -1] ; $c1
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000384
  cmp a, b
  sgt ; >
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  cmp b, 0
  je _if232_exit
_if232_TRUE:
; return; 
  leave
  ret
  jmp _if232_exit
_if232_exit:
; puts("Please enter initial Y coordinate: "); 
; --- START FUNCTION CALL
  mov b, _s140 ; "Please enter initial Y coordinate: "
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; a = TO_FIXED00(input_int()); 
  lea d, [bp + -3] ; $a
  push d
; --- START FUNCTION CALL
; --- START FUNCTION CALL
  call input_int
  swp b
  push b
  call TO_FIXED00
  add sp, 2
; --- END FUNCTION CALL
  pop d
  mov [d], b
; if (a < 0 || a > 900) 
_if233_cond:
  lea d, [bp + -3] ; $a
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
; --- START LOGICAL OR
  push a
  mov a, b
  lea d, [bp + -3] ; $a
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000384
  cmp a, b
  sgt ; >
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  cmp b, 0
  je _if233_exit
_if233_TRUE:
; return; 
  leave
  ret
  jmp _if233_exit
_if233_exit:
; puts("Please enter final X coordinate: "); 
; --- START FUNCTION CALL
  mov b, _s141 ; "Please enter final X coordinate: "
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; w1 = TO_FIXED00(input_int()); 
  lea d, [bp + -5] ; $w1
  push d
; --- START FUNCTION CALL
; --- START FUNCTION CALL
  call input_int
  swp b
  push b
  call TO_FIXED00
  add sp, 2
; --- END FUNCTION CALL
  pop d
  mov [d], b
; if (w1 < 0 || w1 > 900) 
_if234_cond:
  lea d, [bp + -5] ; $w1
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
; --- START LOGICAL OR
  push a
  mov a, b
  lea d, [bp + -5] ; $w1
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000384
  cmp a, b
  sgt ; >
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  cmp b, 0
  je _if234_exit
_if234_TRUE:
; return; 
  leave
  ret
  jmp _if234_exit
_if234_exit:
; puts("Please enter final Y coordinate: "); 
; --- START FUNCTION CALL
  mov b, _s142 ; "Please enter final Y coordinate: "
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; x = TO_FIXED00(input_int()); 
  lea d, [bp + -7] ; $x
  push d
; --- START FUNCTION CALL
; --- START FUNCTION CALL
  call input_int
  swp b
  push b
  call TO_FIXED00
  add sp, 2
; --- END FUNCTION CALL
  pop d
  mov [d], b
; if (x < 0 || x > 900) 
_if235_cond:
  lea d, [bp + -7] ; $x
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
; --- START LOGICAL OR
  push a
  mov a, b
  lea d, [bp + -7] ; $x
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000384
  cmp a, b
  sgt ; >
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  cmp b, 0
  je _if235_exit
_if235_TRUE:
; return; 
  leave
  ret
  jmp _if235_exit
_if235_exit:
; compute_vector(w1, x, c1, a); 
; --- START FUNCTION CALL
  lea d, [bp + -3] ; $a
  mov b, [d]
  mov c, 0
  swp b
  push b
  lea d, [bp + -1] ; $c1
  mov b, [d]
  mov c, 0
  swp b
  push b
  lea d, [bp + -7] ; $x
  mov b, [d]
  mov c, 0
  swp b
  push b
  lea d, [bp + -5] ; $w1
  mov b, [d]
  mov c, 0
  swp b
  push b
  call compute_vector
  add sp, 8
; --- END FUNCTION CALL
  leave
  ret

galaxy_map:
  enter 0 ; (push bp; mov bp, sp)
; int i, j, j0; 
  sub sp, 2
  sub sp, 2
  sub sp, 2
; printf("\n                   The Galaxy\n\n"); 
; --- START FUNCTION CALL
  mov b, _s143 ; "\n                   The Galaxy\n\n"
  swp b
  push b
  call printf
  add sp, 2
; --- END FUNCTION CALL
; printf("    1     2     3     4     5     6     7     8\n"); 
; --- START FUNCTION CALL
  mov b, _s144 ; "    1     2     3     4     5     6     7     8\n"
  swp b
  push b
  call printf
  add sp, 2
; --- END FUNCTION CALL
; for (i = 1; i <= 8; i++) { 
_for236_init:
  lea d, [bp + -1] ; $i
  push d
  mov32 cb, $00000001
  pop d
  mov [d], b
_for236_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000008
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for236_exit
_for236_block:
; printf("%s%d ", gm_1, i); 
; --- START FUNCTION CALL
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  swp b
  push b
  mov d, _gm_1 ; $gm_1
  mov b, [d]
  mov c, 0
  swp b
  push b
  mov b, _s145 ; "%s%d "
  swp b
  push b
  call printf
  add sp, 6
; --- END FUNCTION CALL
; quadrant_name(1, i, 1); 
; --- START FUNCTION CALL
  mov32 cb, $00000001
  push bl
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  push bl
  mov32 cb, $00000001
  push bl
  call quadrant_name
  add sp, 3
; --- END FUNCTION CALL
; j0 = (int) (11 - (strlen(quadname) / 2)); 
  lea d, [bp + -5] ; $j0
  push d
  mov32 cb, $0000000b
; --- START TERMS
  push a
  mov a, b
; --- START FUNCTION CALL
  mov d, _quadname_data ; $quadname
  mov b, d
  mov c, 0
  swp b
  push b
  call strlen
  add sp, 2
; --- END FUNCTION CALL
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $00000002
  push g ; save 'g' as the div instruction uses it
  div a, b ; /, a: quotient, b: remainder
  pop g
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; for (j = 0; j < j0; j++) 
_for245_init:
  lea d, [bp + -3] ; $j
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
_for245_cond:
  lea d, [bp + -3] ; $j
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -5] ; $j0
  mov b, [d]
  mov c, 0
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for245_exit
_for245_block:
; putchar(' '); 
; --- START FUNCTION CALL
  mov32 cb, $00000020
  push bl
  call putchar
  add sp, 1
; --- END FUNCTION CALL
_for245_update:
  lea d, [bp + -3] ; $j
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -3] ; $j
  mov [d], b
  mov b, a
  jmp _for245_cond
_for245_exit:
; puts(quadname); 
; --- START FUNCTION CALL
  mov d, _quadname_data ; $quadname
  mov b, d
  mov c, 0
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; for (j = 0; j < j0; j++) 
_for246_init:
  lea d, [bp + -3] ; $j
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
_for246_cond:
  lea d, [bp + -3] ; $j
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -5] ; $j0
  mov b, [d]
  mov c, 0
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for246_exit
_for246_block:
; putchar(' '); 
; --- START FUNCTION CALL
  mov32 cb, $00000020
  push bl
  call putchar
  add sp, 1
; --- END FUNCTION CALL
_for246_update:
  lea d, [bp + -3] ; $j
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -3] ; $j
  mov [d], b
  mov b, a
  jmp _for246_cond
_for246_exit:
; if (!(strlen(quadname) % 2)) 
_if247_cond:
; --- START FUNCTION CALL
  mov d, _quadname_data ; $quadname
  mov b, d
  mov c, 0
  swp b
  push b
  call strlen
  add sp, 2
; --- END FUNCTION CALL
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $00000002
  push g ; save 'g' as the div instruction uses it
  div a, b ; %, a: quotient, b: remainder
  mov a, b
  pop g
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  cmp b, 0
  je _if247_exit
_if247_TRUE:
; putchar(' '); 
; --- START FUNCTION CALL
  mov32 cb, $00000020
  push bl
  call putchar
  add sp, 1
; --- END FUNCTION CALL
  jmp _if247_exit
_if247_exit:
; quadrant_name(1, i, 5); 
; --- START FUNCTION CALL
  mov32 cb, $00000005
  push bl
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  push bl
  mov32 cb, $00000001
  push bl
  call quadrant_name
  add sp, 3
; --- END FUNCTION CALL
; j0 = (int) (12 - (strlen(quadname) / 2)); 
  lea d, [bp + -5] ; $j0
  push d
  mov32 cb, $0000000c
; --- START TERMS
  push a
  mov a, b
; --- START FUNCTION CALL
  mov d, _quadname_data ; $quadname
  mov b, d
  mov c, 0
  swp b
  push b
  call strlen
  add sp, 2
; --- END FUNCTION CALL
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $00000002
  push g ; save 'g' as the div instruction uses it
  div a, b ; /, a: quotient, b: remainder
  pop g
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; for (j = 0; j < j0; j++) 
_for260_init:
  lea d, [bp + -3] ; $j
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
_for260_cond:
  lea d, [bp + -3] ; $j
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -5] ; $j0
  mov b, [d]
  mov c, 0
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for260_exit
_for260_block:
; putchar(' '); 
; --- START FUNCTION CALL
  mov32 cb, $00000020
  push bl
  call putchar
  add sp, 1
; --- END FUNCTION CALL
_for260_update:
  lea d, [bp + -3] ; $j
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -3] ; $j
  mov [d], b
  mov b, a
  jmp _for260_cond
_for260_exit:
; puts(quadname); 
; --- START FUNCTION CALL
  mov d, _quadname_data ; $quadname
  mov b, d
  mov c, 0
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
_for236_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  mov b, a
  jmp _for236_cond
_for236_exit:
; puts(gm_1); 
; --- START FUNCTION CALL
  mov d, _gm_1 ; $gm_1
  mov b, [d]
  mov c, 0
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
  leave
  ret

compute_vector:
  enter 0 ; (push bp; mov bp, sp)
; long unsigned int         xl, al; 
  sub sp, 4
  sub sp, 4
; puts("  DIRECTION = "); 
; --- START FUNCTION CALL
  mov b, _s146 ; "  DIRECTION = "
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; x = x - a; 
  lea d, [bp + 7] ; $x
  push d
  lea d, [bp + 7] ; $x
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + 11] ; $a
  mov b, [d]
  mov c, 0
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; a = c1 - w1; 
  lea d, [bp + 11] ; $a
  push d
  lea d, [bp + 9] ; $c1
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + 5] ; $w1
  mov b, [d]
  mov c, 0
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; xl = abs(x); 
  lea d, [bp + -3] ; $xl
  push d
; --- START FUNCTION CALL
  lea d, [bp + 7] ; $x
  mov b, [d]
  mov c, 0
  swp b
  push b
  call abs
  add sp, 2
; --- END FUNCTION CALL
  pop d
  mov [d], b
  mov b, 0
  mov [d + 2], b
; al = abs(a); 
  lea d, [bp + -7] ; $al
  push d
; --- START FUNCTION CALL
  lea d, [bp + 11] ; $a
  mov b, [d]
  mov c, 0
  swp b
  push b
  call abs
  add sp, 2
; --- END FUNCTION CALL
  pop d
  mov [d], b
  mov b, 0
  mov [d + 2], b
; if (x < 0) { 
_if261_cond:
  lea d, [bp + 7] ; $x
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if261_else
_if261_TRUE:
; if (a > 0) { 
_if262_cond:
  lea d, [bp + 11] ; $a
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  sgt ; >
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if262_else
_if262_TRUE:
; c1 = 300; 
  lea d, [bp + 9] ; $c1
  push d
  mov32 cb, $0000012c
  pop d
  mov [d], b
; if (al >= xl) 
_if263_cond:
  lea d, [bp + -7] ; $al
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; --- START RELATIONAL
  push a
  push g
  mov a, b
  mov g, c
  lea d, [bp + -3] ; $xl
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
  cmp32 ga, cb
  sgeu
  pop g
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if263_else
_if263_TRUE:
; printf("%s", print100(c1 + ((xl * 100) / al))); 
; --- START FUNCTION CALL
; --- START FUNCTION CALL
  lea d, [bp + 9] ; $c1
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -3] ; $xl
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $00000064
  push a     ; save left operand
  xor a, b   ; xor sign bits
  swp a      ; swap bytes
  mov cl, al ; save result of xor into 'dl'
  pop a      ; restore left side operator
  push cl    ; save result of xor above
  swp a  
  test al, $80  
  swp a  
  jz skip_invert_a_310  
  neg a 
skip_invert_a_310:   
  swp b
  test bl, $80  
  swp b
  jz skip_invert_b_310  
  neg b 
skip_invert_b_310:   
  mul a, b ; *
  mov g, a
  mov a, b
  pop bl
  test bl, $80
  jz _same_signs_310
  mov bl, al
  not a
  neg b
  adc a, 0
  mov g, a
  mov a, b
_same_signs_310:
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  lea d, [bp + -7] ; $al
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
  push g ; save 'g' as the div instruction uses it
  div a, b ; /, a: quotient, b: remainder
  pop g
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  mov g, 0
  add32 cb, ga
  pop a
; --- END TERMS
  swp b
  push b
  call print100
  add sp, 2
; --- END FUNCTION CALL
  swp b
  push b
  mov b, _s147 ; "%s"
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
  jmp _if263_exit
_if263_else:
; printf("%s", print100(c1 + ((((xl * 2) - al) * 100)  / xl))); 
; --- START FUNCTION CALL
; --- START FUNCTION CALL
  lea d, [bp + 9] ; $c1
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -3] ; $xl
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $00000002
  push a     ; save left operand
  xor a, b   ; xor sign bits
  swp a      ; swap bytes
  mov cl, al ; save result of xor into 'dl'
  pop a      ; restore left side operator
  push cl    ; save result of xor above
  swp a  
  test al, $80  
  swp a  
  jz skip_invert_a_485  
  neg a 
skip_invert_a_485:   
  swp b
  test bl, $80  
  swp b
  jz skip_invert_b_485  
  neg b 
skip_invert_b_485:   
  mul a, b ; *
  mov g, a
  mov a, b
  pop bl
  test bl, $80
  jz _same_signs_485
  mov bl, al
  not a
  neg b
  adc a, 0
  mov g, a
  mov a, b
_same_signs_485:
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
; --- START TERMS
  push a
  push g
  mov a, b
  mov g, c
  lea d, [bp + -7] ; $al
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
  sub32 ga, cb
  mov b, a
  mov c, g
  pop g
  pop a
; --- END TERMS
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $00000064
  push a     ; save left operand
  xor a, b   ; xor sign bits
  swp a      ; swap bytes
  mov cl, al ; save result of xor into 'dl'
  pop a      ; restore left side operator
  push cl    ; save result of xor above
  swp a  
  test al, $80  
  swp a  
  jz skip_invert_a_486  
  neg a 
skip_invert_a_486:   
  swp b
  test bl, $80  
  swp b
  jz skip_invert_b_486  
  neg b 
skip_invert_b_486:   
  mul a, b ; *
  mov g, a
  mov a, b
  pop bl
  test bl, $80
  jz _same_signs_486
  mov bl, al
  not a
  neg b
  adc a, 0
  mov g, a
  mov a, b
_same_signs_486:
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  lea d, [bp + -3] ; $xl
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
  push g ; save 'g' as the div instruction uses it
  div a, b ; /, a: quotient, b: remainder
  pop g
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  mov g, 0
  add32 cb, ga
  pop a
; --- END TERMS
  swp b
  push b
  call print100
  add sp, 2
; --- END FUNCTION CALL
  swp b
  push b
  mov b, _s147 ; "%s"
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
_if263_exit:
; printf(dist_1, print100((x > a) ? x : a)); 
; --- START FUNCTION CALL
; --- START FUNCTION CALL
_ternary491_cond:
  lea d, [bp + 7] ; $x
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  lea d, [bp + 11] ; $a
  mov b, [d]
  mov c, 0
  cmp a, b
  sgt ; >
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _ternary491_FALSE
_ternary491_TRUE:
  lea d, [bp + 7] ; $x
  mov b, [d]
  mov c, 0
  jmp _ternary491_exit
_ternary491_FALSE:
  lea d, [bp + 11] ; $a
  mov b, [d]
  mov c, 0
_ternary491_exit:
  swp b
  push b
  call print100
  add sp, 2
; --- END FUNCTION CALL
  swp b
  push b
  mov d, _dist_1 ; $dist_1
  mov b, [d]
  mov c, 0
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
; return; 
  leave
  ret
  jmp _if262_exit
_if262_else:
; if (x != 0){ 
_if492_cond:
  lea d, [bp + 7] ; $x
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if492_else
_if492_TRUE:
; c1 = 500; 
  lea d, [bp + 9] ; $c1
  push d
  mov32 cb, $000001f4
  pop d
  mov [d], b
; return; 
  leave
  ret
  jmp _if492_exit
_if492_else:
; c1 = 700; 
  lea d, [bp + 9] ; $c1
  push d
  mov32 cb, $000002bc
  pop d
  mov [d], b
_if492_exit:
_if262_exit:
  jmp _if261_exit
_if261_else:
; if (a < 0) { 
_if493_cond:
  lea d, [bp + 11] ; $a
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if493_else
_if493_TRUE:
; c1 = 700; 
  lea d, [bp + 9] ; $c1
  push d
  mov32 cb, $000002bc
  pop d
  mov [d], b
  jmp _if493_exit
_if493_else:
; if (x > 0) { 
_if494_cond:
  lea d, [bp + 7] ; $x
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  sgt ; >
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if494_else
_if494_TRUE:
; c1 = 100; 
  lea d, [bp + 9] ; $c1
  push d
  mov32 cb, $00000064
  pop d
  mov [d], b
  jmp _if494_exit
_if494_else:
; if (a == 0) { 
_if495_cond:
  lea d, [bp + 11] ; $a
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if495_else
_if495_TRUE:
; c1 = 500; 
  lea d, [bp + 9] ; $c1
  push d
  mov32 cb, $000001f4
  pop d
  mov [d], b
  jmp _if495_exit
_if495_else:
; c1 = 100; 
  lea d, [bp + 9] ; $c1
  push d
  mov32 cb, $00000064
  pop d
  mov [d], b
; if (al <= xl) 
_if496_cond:
  lea d, [bp + -7] ; $al
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; --- START RELATIONAL
  push a
  push g
  mov a, b
  mov g, c
  lea d, [bp + -3] ; $xl
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
  cmp32 ga, cb
  sleu
  pop g
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if496_else
_if496_TRUE:
; printf("%s", print100(c1 + ((al * 100) / xl))); 
; --- START FUNCTION CALL
; --- START FUNCTION CALL
  lea d, [bp + 9] ; $c1
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -7] ; $al
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $00000064
  push a     ; save left operand
  xor a, b   ; xor sign bits
  swp a      ; swap bytes
  mov cl, al ; save result of xor into 'dl'
  pop a      ; restore left side operator
  push cl    ; save result of xor above
  swp a  
  test al, $80  
  swp a  
  jz skip_invert_a_543  
  neg a 
skip_invert_a_543:   
  swp b
  test bl, $80  
  swp b
  jz skip_invert_b_543  
  neg b 
skip_invert_b_543:   
  mul a, b ; *
  mov g, a
  mov a, b
  pop bl
  test bl, $80
  jz _same_signs_543
  mov bl, al
  not a
  neg b
  adc a, 0
  mov g, a
  mov a, b
_same_signs_543:
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  lea d, [bp + -3] ; $xl
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
  push g ; save 'g' as the div instruction uses it
  div a, b ; /, a: quotient, b: remainder
  pop g
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  mov g, 0
  add32 cb, ga
  pop a
; --- END TERMS
  swp b
  push b
  call print100
  add sp, 2
; --- END FUNCTION CALL
  swp b
  push b
  mov b, _s147 ; "%s"
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
  jmp _if496_exit
_if496_else:
; printf("%s", print100(c1 + ((((al * 2) - xl) * 100) / al))); 
; --- START FUNCTION CALL
; --- START FUNCTION CALL
  lea d, [bp + 9] ; $c1
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -7] ; $al
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $00000002
  push a     ; save left operand
  xor a, b   ; xor sign bits
  swp a      ; swap bytes
  mov cl, al ; save result of xor into 'dl'
  pop a      ; restore left side operator
  push cl    ; save result of xor above
  swp a  
  test al, $80  
  swp a  
  jz skip_invert_a_718  
  neg a 
skip_invert_a_718:   
  swp b
  test bl, $80  
  swp b
  jz skip_invert_b_718  
  neg b 
skip_invert_b_718:   
  mul a, b ; *
  mov g, a
  mov a, b
  pop bl
  test bl, $80
  jz _same_signs_718
  mov bl, al
  not a
  neg b
  adc a, 0
  mov g, a
  mov a, b
_same_signs_718:
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
; --- START TERMS
  push a
  push g
  mov a, b
  mov g, c
  lea d, [bp + -3] ; $xl
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
  sub32 ga, cb
  mov b, a
  mov c, g
  pop g
  pop a
; --- END TERMS
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $00000064
  push a     ; save left operand
  xor a, b   ; xor sign bits
  swp a      ; swap bytes
  mov cl, al ; save result of xor into 'dl'
  pop a      ; restore left side operator
  push cl    ; save result of xor above
  swp a  
  test al, $80  
  swp a  
  jz skip_invert_a_719  
  neg a 
skip_invert_a_719:   
  swp b
  test bl, $80  
  swp b
  jz skip_invert_b_719  
  neg b 
skip_invert_b_719:   
  mul a, b ; *
  mov g, a
  mov a, b
  pop bl
  test bl, $80
  jz _same_signs_719
  mov bl, al
  not a
  neg b
  adc a, 0
  mov g, a
  mov a, b
_same_signs_719:
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  lea d, [bp + -7] ; $al
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
  push g ; save 'g' as the div instruction uses it
  div a, b ; /, a: quotient, b: remainder
  pop g
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  mov g, 0
  add32 cb, ga
  pop a
; --- END TERMS
  swp b
  push b
  call print100
  add sp, 2
; --- END FUNCTION CALL
  swp b
  push b
  mov b, _s147 ; "%s"
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
_if496_exit:
; printf(dist_1, print100((xl > al) ? xl : al)); 
; --- START FUNCTION CALL
; --- START FUNCTION CALL
_ternary724_cond:
  lea d, [bp + -3] ; $xl
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; --- START RELATIONAL
  push a
  push g
  mov a, b
  mov g, c
  lea d, [bp + -7] ; $al
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
  cmp32 ga, cb
  sgu
  pop g
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _ternary724_FALSE
_ternary724_TRUE:
  lea d, [bp + -3] ; $xl
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
  jmp _ternary724_exit
_ternary724_FALSE:
  lea d, [bp + -7] ; $al
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
_ternary724_exit:
  swp b
  push b
  call print100
  add sp, 2
; --- END FUNCTION CALL
  swp b
  push b
  mov d, _dist_1 ; $dist_1
  mov b, [d]
  mov c, 0
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
_if495_exit:
_if494_exit:
_if493_exit:
_if261_exit:
  leave
  ret

ship_destroyed:
  enter 0 ; (push bp; mov bp, sp)
; puts("The Enterprise has been destroyed. The Federation will be conquered.\n"); 
; --- START FUNCTION CALL
  mov b, _s148 ; "The Enterprise has been destroyed. The Federation will be conquered.\n"
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; end_of_time(); 
; --- START FUNCTION CALL
  call end_of_time
  leave
  ret

end_of_time:
  enter 0 ; (push bp; mov bp, sp)
; printf("It is stardate %d.\n\n",  FROM_FIXED(stardate)); 
; --- START FUNCTION CALL
; --- START FUNCTION CALL
  mov d, _stardate ; $stardate
  mov b, [d]
  mov c, 0
  swp b
  push b
  call FROM_FIXED
  add sp, 2
; --- END FUNCTION CALL
  swp b
  push b
  mov b, _s149 ; "It is stardate %d.\n\n"
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
; resign_commision(); 
; --- START FUNCTION CALL
  call resign_commision
  leave
  ret

resign_commision:
  enter 0 ; (push bp; mov bp, sp)
; printf("There were %d Klingon Battlecruisers left at the end of your mission.\n\n", klingons_left); 
; --- START FUNCTION CALL
  mov d, _klingons_left ; $klingons_left
  mov bl, [d]
  mov bh, 0
  mov c, 0
  swp b
  push b
  mov b, _s150 ; "There were %d Klingon Battlecruisers left at the end of your mission.\n\n"
  swp b
  push b
  call printf
  add sp, 3
; --- END FUNCTION CALL
; end_of_game(); 
; --- START FUNCTION CALL
  call end_of_game
  leave
  ret

won_game:
  enter 0 ; (push bp; mov bp, sp)
; puts("Congratulations, Captain!  The last Klingon Battle Cruiser\n menacing the Federation has been destoyed.\n"); 
; --- START FUNCTION CALL
  mov b, _s151 ; "Congratulations, Captain!  The last Klingon Battle Cruiser\n menacing the Federation has been destoyed.\n"
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; if (FROM_FIXED(stardate) - time_start > 0) 
_if725_cond:
; --- START FUNCTION CALL
  mov d, _stardate ; $stardate
  mov b, [d]
  mov c, 0
  swp b
  push b
  call FROM_FIXED
  add sp, 2
; --- END FUNCTION CALL
; --- START TERMS
  push a
  mov a, b
  mov d, _time_start ; $time_start
  mov b, [d]
  mov c, 0
  sub a, b
  mov b, a
  pop a
; --- END TERMS
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  sgu ; > (unsigned)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if725_exit
_if725_TRUE:
; printf("Your efficiency rating is %s\n", 
; --- START FUNCTION CALL
; --- START FUNCTION CALL
; --- START FUNCTION CALL
; --- START FUNCTION CALL
  mov d, _total_klingons ; $total_klingons
  mov bl, [d]
  mov bh, 0
  mov c, 0
  snex b
  swp b
  push b
  call TO_FIXED00
  add sp, 2
; --- END FUNCTION CALL
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
; --- START FUNCTION CALL
  mov d, _stardate ; $stardate
  mov b, [d]
  mov c, 0
  swp b
  push b
  call FROM_FIXED
  add sp, 2
; --- END FUNCTION CALL
; --- START TERMS
  push a
  mov a, b
  mov d, _time_start ; $time_start
  mov b, [d]
  mov c, 0
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  push g ; save 'g' as the div instruction uses it
  div a, b ; /, a: quotient, b: remainder
  pop g
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  swp b
  push b
  call square00
  add sp, 2
; --- END FUNCTION CALL
  swp b
  push b
  call print100
  add sp, 2
; --- END FUNCTION CALL
  swp b
  push b
  mov b, _s152 ; "Your efficiency rating is %s\n"
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
  jmp _if725_exit
_if725_exit:
; end_of_game(); 
; --- START FUNCTION CALL
  call end_of_game
  leave
  ret

end_of_game:
  enter 0 ; (push bp; mov bp, sp)
; char x[4]; 
  sub sp, 4
; if (starbases_left > 0) { 
_if742_cond:
  mov d, _starbases_left ; $starbases_left
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  sgt ; >
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if742_exit
_if742_TRUE:
; puts("The Federation is in need of a new starship commander"); 
; --- START FUNCTION CALL
  mov b, _s153 ; "The Federation is in need of a new starship commander"
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; puts(" for a similar mission.\n"); 
; --- START FUNCTION CALL
  mov b, _s154 ; " for a similar mission.\n"
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; puts("If there is a volunteer, let him step forward and"); 
; --- START FUNCTION CALL
  mov b, _s155 ; "If there is a volunteer, let him step forward and"
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; puts(" enter 'aye': "); 
; --- START FUNCTION CALL
  mov b, _s156 ; " enter 'aye': "
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; input(x,4); 
; --- START FUNCTION CALL
  mov32 cb, $00000004
  push bl
  lea d, [bp + -3] ; $x
  mov b, d
  mov c, 0
  swp b
  push b
  call input
  add sp, 3
; --- END FUNCTION CALL
  jmp _if742_exit
_if742_exit:
; exit(1); 
; --- START FUNCTION CALL
  mov32 cb, $00000001
  swp b
  push b
  call exit
  add sp, 2
; --- END FUNCTION CALL
  leave
  ret

klingons_move:
  enter 0 ; (push bp; mov bp, sp)
; int i; 
  sub sp, 2
; struct klingon *k; 
  sub sp, 2
; k = &kdata; 
  lea d, [bp + -3] ; $k
  push d
  mov d, _kdata_data ; $kdata
  mov b, d
  pop d
  mov [d], b
; for (i = 0; i <= 2; i++) { 
_for743_init:
  lea d, [bp + -1] ; $i
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
_for743_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000002
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for743_exit
_for743_block:
; if (k->energy > 0) { 
_if744_cond:
  lea d, [bp + -3] ; $k
  mov d, [d]
  add d, 2
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  sgt ; >
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if744_exit
_if744_TRUE:
; wipe_klingon(k); 
; --- START FUNCTION CALL
  lea d, [bp + -3] ; $k
  mov b, [d]
  mov c, 0
  swp b
  push b
  call wipe_klingon
  add sp, 2
; --- END FUNCTION CALL
; find_set_empty_place(	3         , k->y, k->x); 
; --- START FUNCTION CALL
  lea d, [bp + -3] ; $k
  mov d, [d]
  add d, 1
  mov bl, [d]
  mov bh, 0
  mov c, 0
  swp b
  push b
  lea d, [bp + -3] ; $k
  mov d, [d]
  add d, 0
  mov bl, [d]
  mov bh, 0
  mov c, 0
  swp b
  push b
  mov32 cb, $00000003
  push bl
  call find_set_empty_place
  add sp, 5
; --- END FUNCTION CALL
  jmp _if744_exit
_if744_exit:
; k++; 
  lea d, [bp + -3] ; $k
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  inc b
  lea d, [bp + -3] ; $k
  mov [d], b
  mov b, a
_for743_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  mov b, a
  jmp _for743_cond
_for743_exit:
; klingons_shoot(); 
; --- START FUNCTION CALL
  call klingons_shoot
  leave
  ret

klingons_shoot:
  enter 0 ; (push bp; mov bp, sp)
; unsigned char        r; 
  sub sp, 1
; long unsigned int         h; 
  sub sp, 4
; unsigned char        i; 
  sub sp, 1
; struct klingon *k; 
  sub sp, 2
; long unsigned int         ratio; 
  sub sp, 4
; k = &kdata; 
  lea d, [bp + -7] ; $k
  push d
  mov d, _kdata_data ; $kdata
  mov b, d
  pop d
  mov [d], b
; if (klingons <= 0) 
_if745_cond:
  mov d, _klingons ; $klingons
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  sleu ; <= (unsigned)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if745_exit
_if745_TRUE:
; return; 
  leave
  ret
  jmp _if745_exit
_if745_exit:
; if (docked) { 
_if746_cond:
  mov d, _docked ; $docked
  mov bl, [d]
  mov bh, 0
  mov c, 0
  cmp b, 0
  je _if746_exit
_if746_TRUE:
; puts("Starbase shields protect the Enterprise\n"); 
; --- START FUNCTION CALL
  mov b, _s157 ; "Starbase shields protect the Enterprise\n"
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; return; 
  leave
  ret
  jmp _if746_exit
_if746_exit:
; for (i = 0; i <= 2; i++) { 
_for747_init:
  lea d, [bp + -5] ; $i
  push d
  mov32 cb, $00000000
  pop d
  mov [d], bl
_for747_cond:
  lea d, [bp + -5] ; $i
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000002
  cmp a, b
  sleu ; <= (unsigned)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for747_exit
_for747_block:
; if (k->energy > 0) { 
_if748_cond:
  lea d, [bp + -7] ; $k
  mov d, [d]
  add d, 2
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  sgt ; >
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if748_exit
_if748_TRUE:
; h = k->energy * (200UL + get_rand(100)); 
  lea d, [bp + -4] ; $h
  push d
  lea d, [bp + -7] ; $k
  mov d, [d]
  add d, 2
  mov b, [d]
  mov c, 0
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $000000c8
; --- START TERMS
  push a
  push g
  mov a, b
  mov g, c
; --- START FUNCTION CALL
  mov32 cb, $00000064
  swp b
  push b
  call get_rand
  add sp, 2
; --- END FUNCTION CALL
  mov c, 0
  add32 cb, ga
  pop g
  pop a
; --- END TERMS
  push a     ; save left operand
  xor a, b   ; xor sign bits
  swp a      ; swap bytes
  mov cl, al ; save result of xor into 'dl'
  pop a      ; restore left side operator
  push cl    ; save result of xor above
  swp a  
  test al, $80  
  swp a  
  jz skip_invert_a_750  
  neg a 
skip_invert_a_750:   
  swp b
  test bl, $80  
  swp b
  jz skip_invert_b_750  
  neg b 
skip_invert_b_750:   
  mul a, b ; *
  mov g, a
  mov a, b
  pop bl
  test bl, $80
  jz _same_signs_750
  mov bl, al
  not a
  neg b
  adc a, 0
  mov g, a
  mov a, b
_same_signs_750:
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  pop d
  mov [d], b
  mov b, c
  mov [d + 2], b
; h =h* 100;	/* Ready for division in fixed */ 
  lea d, [bp + -4] ; $h
  push d
  lea d, [bp + -4] ; $h
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $00000064
  push a     ; save left operand
  xor a, b   ; xor sign bits
  swp a      ; swap bytes
  mov cl, al ; save result of xor into 'dl'
  pop a      ; restore left side operator
  push cl    ; save result of xor above
  swp a  
  test al, $80  
  swp a  
  jz skip_invert_a_752  
  neg a 
skip_invert_a_752:   
  swp b
  test bl, $80  
  swp b
  jz skip_invert_b_752  
  neg b 
skip_invert_b_752:   
  mul a, b ; *
  mov g, a
  mov a, b
  pop bl
  test bl, $80
  jz _same_signs_752
  mov bl, al
  not a
  neg b
  adc a, 0
  mov g, a
  mov a, b
_same_signs_752:
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  pop d
  mov [d], b
  mov b, c
  mov [d + 2], b
; h =h/ distance_to(k); 
  lea d, [bp + -4] ; $h
  push d
  lea d, [bp + -4] ; $h
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
; --- START FUNCTION CALL
  lea d, [bp + -7] ; $k
  mov b, [d]
  mov c, 0
  swp b
  push b
  call distance_to
  add sp, 2
; --- END FUNCTION CALL
  push g ; save 'g' as the div instruction uses it
  div a, b ; /, a: quotient, b: remainder
  pop g
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  pop d
  mov [d], b
  mov b, c
  mov [d + 2], b
; shield = shield - FROM_FIXED00(h); 
  mov d, _shield ; $shield
  push d
  mov d, _shield ; $shield
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
; --- START FUNCTION CALL
  lea d, [bp + -4] ; $h
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
  swp b
  push b
  call FROM_FIXED00
  add sp, 2
; --- END FUNCTION CALL
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; k->energy = (k->energy * 100) / (300 + get_rand(100)); 
  lea d, [bp + -7] ; $k
  mov d, [d]
  add d, 2
  push d
  lea d, [bp + -7] ; $k
  mov d, [d]
  add d, 2
  mov b, [d]
  mov c, 0
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $00000064
  push a     ; save left operand
  xor a, b   ; xor sign bits
  swp a      ; swap bytes
  mov cl, al ; save result of xor into 'dl'
  pop a      ; restore left side operator
  push cl    ; save result of xor above
  swp a  
  test al, $80  
  swp a  
  jz skip_invert_a_759  
  neg a 
skip_invert_a_759:   
  swp b
  test bl, $80  
  swp b
  jz skip_invert_b_759  
  neg b 
skip_invert_b_759:   
  mul a, b ; *
  mov g, a
  mov a, b
  pop bl
  test bl, $80
  jz _same_signs_759
  mov bl, al
  not a
  neg b
  adc a, 0
  mov g, a
  mov a, b
_same_signs_759:
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $0000012c
; --- START TERMS
  push a
  mov a, b
; --- START FUNCTION CALL
  mov32 cb, $00000064
  swp b
  push b
  call get_rand
  add sp, 2
; --- END FUNCTION CALL
  add b, a
  pop a
; --- END TERMS
  push g ; save 'g' as the div instruction uses it
  div a, b ; /, a: quotient, b: remainder
  pop g
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  pop d
  mov [d], b
; printf("%d unit hit on Enterprise from sector %d, %d\n", (unsigned)FROM_FIXED00(h), k->y, k->x); 
; --- START FUNCTION CALL
  lea d, [bp + -7] ; $k
  mov d, [d]
  add d, 1
  mov bl, [d]
  mov bh, 0
  mov c, 0
  swp b
  push b
  lea d, [bp + -7] ; $k
  mov d, [d]
  add d, 0
  mov bl, [d]
  mov bh, 0
  mov c, 0
  swp b
  push b
  lea d, [bp + -4] ; $h
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
  swp b
  push b
  mov b, _s158 ; "%d unit hit on Enterprise from sector %d, %d\n"
  swp b
  push b
  call printf
  add sp, 6
; --- END FUNCTION CALL
; if (shield <= 0) { 
_if761_cond:
  mov d, _shield ; $shield
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if761_exit
_if761_TRUE:
; putchar('\n'); 
; --- START FUNCTION CALL
  mov32 cb, $0000000a
  push bl
  call putchar
  add sp, 1
; --- END FUNCTION CALL
; ship_destroyed(); 
; --- START FUNCTION CALL
  call ship_destroyed
  jmp _if761_exit
_if761_exit:
; printf("    <Shields down to %d units>\n\n", shield); 
; --- START FUNCTION CALL
  mov d, _shield ; $shield
  mov b, [d]
  mov c, 0
  swp b
  push b
  mov b, _s159 ; "    <Shields down to %d units>\n\n"
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
; if (h >= 20) { 
_if762_cond:
  lea d, [bp + -4] ; $h
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; --- START RELATIONAL
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $00000014
  mov c, 0
  cmp32 ga, cb
  sgeu
  pop g
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if762_exit
_if762_TRUE:
; ratio = ((int)h)/shield; 
  lea d, [bp + -11] ; $ratio
  push d
  lea d, [bp + -4] ; $h
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov d, _shield ; $shield
  mov b, [d]
  mov c, 0
  push g ; save 'g' as the div instruction uses it
  div a, b ; /, a: quotient, b: remainder
  pop g
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  pop d
  mov [d], b
  mov b, 0
  mov [d + 2], b
; if (get_rand(10) <= 6 && ratio > 2) { 
_if765_cond:
; --- START FUNCTION CALL
  mov32 cb, $0000000a
  swp b
  push b
  call get_rand
  add sp, 2
; --- END FUNCTION CALL
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000006
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + -11] ; $ratio
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; --- START RELATIONAL
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $00000002
  mov c, 0
  cmp32 ga, cb
  sgu
  pop g
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  cmp b, 0
  je _if765_exit
_if765_TRUE:
; r = rand8(); 
  lea d, [bp + 0] ; $r
  push d
; --- START FUNCTION CALL
  call rand8
  pop d
  mov [d], bl
; damage[r] =damage[r] - ratio + get_rand(50); 
  mov d, _damage_data ; $damage
  push a
  push d
  lea d, [bp + 0] ; $r
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov d, _damage_data ; $damage
  push a
  push d
  lea d, [bp + 0] ; $r
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -11] ; $ratio
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
  mov g, 0
  sub32 ga, cb
  mov b, a
  mov c, g
  mov a, b
  mov g, c
; --- START FUNCTION CALL
  mov32 cb, $00000032
  swp b
  push b
  call get_rand
  add sp, 2
; --- END FUNCTION CALL
  mov c, 0
  add32 cb, ga
  pop a
; --- END TERMS
  pop d
  mov [d], b
; printf("Damage Control reports\n'%s' damaged by hit\n\n", get_device_name(r)); 
; --- START FUNCTION CALL
; --- START FUNCTION CALL
  lea d, [bp + 0] ; $r
  mov bl, [d]
  mov bh, 0
  mov c, 0
  snex b
  swp b
  push b
  call get_device_name
  add sp, 2
; --- END FUNCTION CALL
  swp b
  push b
  mov b, _s160 ; "Damage Control reports\n'%s' damaged by hit\n\n"
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
  jmp _if765_exit
_if765_exit:
  jmp _if762_exit
_if762_exit:
  jmp _if748_exit
_if748_exit:
; k++; 
  lea d, [bp + -7] ; $k
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  inc b
  lea d, [bp + -7] ; $k
  mov [d], b
  mov b, a
_for747_update:
  lea d, [bp + -5] ; $i
  mov bl, [d]
  mov bh, 0
  mov c, 0
  inc b
  lea d, [bp + -5] ; $i
  mov [d], bl
  dec b
  jmp _for747_cond
_for747_exit:
  leave
  ret

repair_damage:
  enter 0 ; (push bp; mov bp, sp)
; int i; 
  sub sp, 2
; int d1; 
  sub sp, 2
; unsigned int         repair_factor;		/* Repair Factor */ 
  sub sp, 2
; repair_factor = warp; 
  lea d, [bp + -5] ; $repair_factor
  push d
  lea d, [bp + 5] ; $warp
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
; if (warp >= 100) 
_if766_cond:
  lea d, [bp + 5] ; $warp
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000064
  cmp a, b
  sgeu ; >= (unsigned)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if766_exit
_if766_TRUE:
; repair_factor = TO_FIXED00(1); 
  lea d, [bp + -5] ; $repair_factor
  push d
; --- START FUNCTION CALL
  mov32 cb, $00000001
  swp b
  push b
  call TO_FIXED00
  add sp, 2
; --- END FUNCTION CALL
  pop d
  mov [d], b
  jmp _if766_exit
_if766_exit:
; for (i = 1; i <= 8; i++) { 
_for767_init:
  lea d, [bp + -1] ; $i
  push d
  mov32 cb, $00000001
  pop d
  mov [d], b
_for767_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000008
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for767_exit
_for767_block:
; if (damage[i] < 0) { 
_if768_cond:
  mov d, _damage_data ; $damage
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if768_exit
_if768_TRUE:
; damage[i] = damage[i] + repair_factor; 
  mov d, _damage_data ; $damage
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov d, _damage_data ; $damage
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -5] ; $repair_factor
  mov b, [d]
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; if (damage[i] > -10 && damage[i] < 0)	/* -0.1 */ 
_if769_cond:
  mov d, _damage_data ; $damage
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $fffffff6
  cmp a, b
  sgt ; >
  pop a
; --- END RELATIONAL
; --- START LOGICAL AND
  push a
  mov a, b
  mov d, _damage_data ; $damage
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  cmp b, 0
  je _if769_else
_if769_TRUE:
; damage[i] = -10; 
  mov d, _damage_data ; $damage
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov32 cb, $fffffff6
  pop d
  mov [d], b
  jmp _if769_exit
_if769_else:
; if (damage[i] >= 0) { 
_if770_cond:
  mov d, _damage_data ; $damage
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  sge ; >=
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if770_exit
_if770_TRUE:
; if (d1 != 1) { 
_if771_cond:
  lea d, [bp + -3] ; $d1
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000001
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if771_exit
_if771_TRUE:
; d1 = 1; 
  lea d, [bp + -3] ; $d1
  push d
  mov32 cb, $00000001
  pop d
  mov [d], b
; puts(dcr_1); 
; --- START FUNCTION CALL
  mov d, _dcr_1 ; $dcr_1
  mov b, [d]
  mov c, 0
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
  jmp _if771_exit
_if771_exit:
; printf("    %s repair completed\n\n", 
; --- START FUNCTION CALL
; --- START FUNCTION CALL
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  swp b
  push b
  call get_device_name
  add sp, 2
; --- END FUNCTION CALL
  swp b
  push b
  mov b, _s161 ; "    %s repair completed\n\n"
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
; damage[i] = 0; 
  mov d, _damage_data ; $damage
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
  jmp _if770_exit
_if770_exit:
_if769_exit:
  jmp _if768_exit
_if768_exit:
_for767_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  mov b, a
  jmp _for767_cond
_for767_exit:
; unsigned char        r; 
  sub sp, 1
; if (get_rand(10) <= 2) { 
_if772_cond:
; --- START FUNCTION CALL
  mov32 cb, $0000000a
  swp b
  push b
  call get_rand
  add sp, 2
; --- END FUNCTION CALL
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000002
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if772_exit
_if772_TRUE:
; r = rand8(); 
  lea d, [bp + -6] ; $r
  push d
; --- START FUNCTION CALL
  call rand8
  pop d
  mov [d], bl
; if (get_rand(10) < 6) { 
_if773_cond:
; --- START FUNCTION CALL
  mov32 cb, $0000000a
  swp b
  push b
  call get_rand
  add sp, 2
; --- END FUNCTION CALL
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000006
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if773_else
_if773_TRUE:
; damage[r] =damage[r]- (get_rand(500) + 100); 
  mov d, _damage_data ; $damage
  push a
  push d
  lea d, [bp + -6] ; $r
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov d, _damage_data ; $damage
  push a
  push d
  lea d, [bp + -6] ; $r
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
; --- START FUNCTION CALL
  mov32 cb, $000001f4
  swp b
  push b
  call get_rand
  add sp, 2
; --- END FUNCTION CALL
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000064
  add b, a
  pop a
; --- END TERMS
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; puts(dcr_1); 
; --- START FUNCTION CALL
  mov d, _dcr_1 ; $dcr_1
  mov b, [d]
  mov c, 0
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; printf("    %s damaged\n\n", get_device_name(r)); 
; --- START FUNCTION CALL
; --- START FUNCTION CALL
  lea d, [bp + -6] ; $r
  mov bl, [d]
  mov bh, 0
  mov c, 0
  snex b
  swp b
  push b
  call get_device_name
  add sp, 2
; --- END FUNCTION CALL
  swp b
  push b
  mov b, _s162 ; "    %s damaged\n\n"
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
  jmp _if773_exit
_if773_else:
; damage[r] = damage[r] + get_rand(300) + 100; 
  mov d, _damage_data ; $damage
  push a
  push d
  lea d, [bp + -6] ; $r
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov d, _damage_data ; $damage
  push a
  push d
  lea d, [bp + -6] ; $r
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
; --- START FUNCTION CALL
  mov32 cb, $0000012c
  swp b
  push b
  call get_rand
  add sp, 2
; --- END FUNCTION CALL
  add b, a
  mov a, b
  mov32 cb, $00000064
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; puts(dcr_1); 
; --- START FUNCTION CALL
  mov d, _dcr_1 ; $dcr_1
  mov b, [d]
  mov c, 0
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; printf("    %s state of repair improved\n\n", 
; --- START FUNCTION CALL
; --- START FUNCTION CALL
  lea d, [bp + -6] ; $r
  mov bl, [d]
  mov bh, 0
  mov c, 0
  snex b
  swp b
  push b
  call get_device_name
  add sp, 2
; --- END FUNCTION CALL
  swp b
  push b
  mov b, _s163 ; "    %s state of repair improved\n\n"
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
_if773_exit:
  jmp _if772_exit
_if772_exit:
  leave
  ret

find_set_empty_place:
  enter 0 ; (push bp; mov bp, sp)
; unsigned char        r1, r2; 
  sub sp, 1
  sub sp, 1
; do { 
_do774_block:
; r1 = rand8(); 
  lea d, [bp + 0] ; $r1
  push d
; --- START FUNCTION CALL
  call rand8
  pop d
  mov [d], bl
; r2 = rand8(); 
  lea d, [bp + -1] ; $r2
  push d
; --- START FUNCTION CALL
  call rand8
  pop d
  mov [d], bl
; } while (quad[r1+-1][r2+-1] != 		0        ); 
_do774_cond:
  mov d, _quad_data ; $quad
  push a
  push d
  lea d, [bp + 0] ; $r1
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $ffffffff
  add b, a
  pop a
; --- END TERMS
  pop d
  mma 8 ; mov a, 8; mul a, b; add d, b
  push d
  lea d, [bp + -1] ; $r2
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $ffffffff
  add b, a
  pop a
; --- END TERMS
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
  cmp b, 1
  je _do774_block
_do774_exit:
; quad[r1+-1][r2+-1] = t; 
  mov d, _quad_data ; $quad
  push a
  push d
  lea d, [bp + 0] ; $r1
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $ffffffff
  add b, a
  pop a
; --- END TERMS
  pop d
  mma 8 ; mov a, 8; mul a, b; add d, b
  push d
  lea d, [bp + -1] ; $r2
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $ffffffff
  add b, a
  pop a
; --- END TERMS
  pop d
  add d, b
  pop a
  push d
  lea d, [bp + 5] ; $t
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mov [d], bl
; if (z1) 
_if775_cond:
  lea d, [bp + 6] ; $z1
  mov b, [d]
  mov c, 0
  cmp b, 0
  je _if775_exit
_if775_TRUE:
; *z1 = r1; 
  lea d, [bp + 6] ; $z1
  mov b, [d]
  mov c, 0
  push b
  lea d, [bp + 0] ; $r1
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mov [d], bl
  jmp _if775_exit
_if775_exit:
; if (z2) 
_if776_cond:
  lea d, [bp + 8] ; $z2
  mov b, [d]
  mov c, 0
  cmp b, 0
  je _if776_exit
_if776_TRUE:
; *z2 = r2; 
  lea d, [bp + 8] ; $z2
  mov b, [d]
  mov c, 0
  push b
  lea d, [bp + -1] ; $r2
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mov [d], bl
  jmp _if776_exit
_if776_exit:
  leave
  ret

get_device_name:
  enter 0 ; (push bp; mov bp, sp)
; if (n < 0 || n > 8) 
_if777_cond:
  lea d, [bp + 5] ; $n
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
; --- START LOGICAL OR
  push a
  mov a, b
  lea d, [bp + 5] ; $n
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000008
  cmp a, b
  sgt ; >
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  cmp b, 0
  je _if777_exit
_if777_TRUE:
; n = 0; 
  lea d, [bp + 5] ; $n
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
  jmp _if777_exit
_if777_exit:
; return device_name[n]; 
  mov d, _device_name_data ; $device_name
  push a
  push d
  lea d, [bp + 5] ; $n
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  leave
  ret

quadrant_name:
  enter 0 ; (push bp; mov bp, sp)
; static char *sect_name[] = { "", " I", " II", " III", " IV" }; 
  sub sp, 20
; if (y < 1 || y > 8 || x < 1 || x > 8) 
_if778_cond:
  lea d, [bp + 6] ; $y
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000001
  cmp a, b
  slu ; < (unsigned)
  pop a
; --- END RELATIONAL
; --- START LOGICAL OR
  push a
  mov a, b
  lea d, [bp + 6] ; $y
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000008
  cmp a, b
  sgu ; > (unsigned)
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  mov a, b
  lea d, [bp + 7] ; $x
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000001
  cmp a, b
  slu ; < (unsigned)
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  mov a, b
  lea d, [bp + 7] ; $x
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000008
  cmp a, b
  sgu ; > (unsigned)
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  cmp b, 0
  je _if778_exit
_if778_TRUE:
; strcpy(quadname, "Unknown"); 
; --- START FUNCTION CALL
  mov b, _s168 ; "Unknown"
  swp b
  push b
  mov d, _quadname_data ; $quadname
  mov b, d
  mov c, 0
  swp b
  push b
  call strcpy
  add sp, 4
; --- END FUNCTION CALL
  jmp _if778_exit
_if778_exit:
; if (x <= 4) 
_if779_cond:
  lea d, [bp + 7] ; $x
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000004
  cmp a, b
  sleu ; <= (unsigned)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if779_else
_if779_TRUE:
; strcpy(quadname, quad_name[y]); 
; --- START FUNCTION CALL
  mov d, _quad_name_data ; $quad_name
  push a
  push d
  lea d, [bp + 6] ; $y
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  swp b
  push b
  mov d, _quadname_data ; $quadname
  mov b, d
  mov c, 0
  swp b
  push b
  call strcpy
  add sp, 4
; --- END FUNCTION CALL
  jmp _if779_exit
_if779_else:
; strcpy(quadname, quad_name[y + 8]); 
; --- START FUNCTION CALL
  mov d, _quad_name_data ; $quad_name
  push a
  push d
  lea d, [bp + 6] ; $y
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000008
  add b, a
  pop a
; --- END TERMS
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  swp b
  push b
  mov d, _quadname_data ; $quadname
  mov b, d
  mov c, 0
  swp b
  push b
  call strcpy
  add sp, 4
; --- END FUNCTION CALL
_if779_exit:
; if (small != 1) { 
_if780_cond:
  lea d, [bp + 5] ; $small
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000001
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if780_exit
_if780_TRUE:
; if (x > 4) 
_if781_cond:
  lea d, [bp + 7] ; $x
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000004
  cmp a, b
  sgu ; > (unsigned)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if781_exit
_if781_TRUE:
; x = x - 4; 
  lea d, [bp + 7] ; $x
  push d
  lea d, [bp + 7] ; $x
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000004
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  mov [d], bl
  jmp _if781_exit
_if781_exit:
; strcat(quadname, sect_name[x]); 
; --- START FUNCTION CALL
  mov d, st_quadrant_name_sect_name_dt ; static sect_name
  push a
  push d
  lea d, [bp + 7] ; $x
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  swp b
  push b
  mov d, _quadname_data ; $quadname
  mov b, d
  mov c, 0
  swp b
  push b
  call strcat
  add sp, 4
; --- END FUNCTION CALL
  jmp _if780_exit
_if780_exit:
; return; 
  leave
  ret

isqrt:
  enter 0 ; (push bp; mov bp, sp)
; unsigned int         b, q, r, t; 
  sub sp, 2
  sub sp, 2
  sub sp, 2
  sub sp, 2
; b = 0x4000; 
  lea d, [bp + -1] ; $b
  push d
  mov32 cb, $00004000
  pop d
  mov [d], b
; q = 0; 
  lea d, [bp + -3] ; $q
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
; r = i; 
  lea d, [bp + -5] ; $r
  push d
  lea d, [bp + 5] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
; while (b) { 
_while782_cond:
  lea d, [bp + -1] ; $b
  mov b, [d]
  mov c, 0
  cmp b, 0
  je _while782_exit
_while782_block:
; t = q + b; 
  lea d, [bp + -7] ; $t
  push d
  lea d, [bp + -3] ; $q
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -1] ; $b
  mov b, [d]
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; q =q>> 1; 
  lea d, [bp + -3] ; $q
  push d
  lea d, [bp + -3] ; $q
  mov b, [d]
  mov c, 0
; --- START SHIFT
  push a
  mov a, b
  mov32 cb, $00000001
  mov c, b
  shr a, cl
  mov b, a
  pop a
; --- END SHIFT
  pop d
  mov [d], b
; if (r >= t) { 
_if783_cond:
  lea d, [bp + -5] ; $r
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -7] ; $t
  mov b, [d]
  mov c, 0
  cmp a, b
  sgeu ; >= (unsigned)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if783_exit
_if783_TRUE:
; r =r- t; 
  lea d, [bp + -5] ; $r
  push d
  lea d, [bp + -5] ; $r
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -7] ; $t
  mov b, [d]
  mov c, 0
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; q = q + b; 
  lea d, [bp + -3] ; $q
  push d
  lea d, [bp + -3] ; $q
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -1] ; $b
  mov b, [d]
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
  jmp _if783_exit
_if783_exit:
; b =b>> 2; 
  lea d, [bp + -1] ; $b
  push d
  lea d, [bp + -1] ; $b
  mov b, [d]
  mov c, 0
; --- START SHIFT
  push a
  mov a, b
  mov32 cb, $00000002
  mov c, b
  shr a, cl
  mov b, a
  pop a
; --- END SHIFT
  pop d
  mov [d], b
  jmp _while782_cond
_while782_exit:
; return q; 
  lea d, [bp + -3] ; $q
  mov b, [d]
  mov c, 0
  leave
  ret

square00:
  enter 0 ; (push bp; mov bp, sp)
; if (abs(t) > 181) { 
_if784_cond:
; --- START FUNCTION CALL
  lea d, [bp + 5] ; $t
  mov b, [d]
  mov c, 0
  swp b
  push b
  call abs
  add sp, 2
; --- END FUNCTION CALL
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $000000b5
  cmp a, b
  sgt ; >
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if784_else
_if784_TRUE:
; t =t/ 10; 
  lea d, [bp + 5] ; $t
  push d
  lea d, [bp + 5] ; $t
  mov b, [d]
  mov c, 0
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $0000000a
  push g ; save 'g' as the div instruction uses it
  div a, b ; /, a: quotient, b: remainder
  pop g
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  pop d
  mov [d], b
; t =t* t; 
  lea d, [bp + 5] ; $t
  push d
  lea d, [bp + 5] ; $t
  mov b, [d]
  mov c, 0
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  lea d, [bp + 5] ; $t
  mov b, [d]
  mov c, 0
  push a     ; save left operand
  xor a, b   ; xor sign bits
  swp a      ; swap bytes
  mov cl, al ; save result of xor into 'dl'
  pop a      ; restore left side operator
  push cl    ; save result of xor above
  swp a  
  test al, $80  
  swp a  
  jz skip_invert_a_788  
  neg a 
skip_invert_a_788:   
  swp b
  test bl, $80  
  swp b
  jz skip_invert_b_788  
  neg b 
skip_invert_b_788:   
  mul a, b ; *
  mov g, a
  mov a, b
  pop bl
  test bl, $80
  jz _same_signs_788
  mov bl, al
  not a
  neg b
  adc a, 0
  mov g, a
  mov a, b
_same_signs_788:
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  pop d
  mov [d], b
  jmp _if784_exit
_if784_else:
; t =t* t; 
  lea d, [bp + 5] ; $t
  push d
  lea d, [bp + 5] ; $t
  mov b, [d]
  mov c, 0
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  lea d, [bp + 5] ; $t
  mov b, [d]
  mov c, 0
  push a     ; save left operand
  xor a, b   ; xor sign bits
  swp a      ; swap bytes
  mov cl, al ; save result of xor into 'dl'
  pop a      ; restore left side operator
  push cl    ; save result of xor above
  swp a  
  test al, $80  
  swp a  
  jz skip_invert_a_790  
  neg a 
skip_invert_a_790:   
  swp b
  test bl, $80  
  swp b
  jz skip_invert_b_790  
  neg b 
skip_invert_b_790:   
  mul a, b ; *
  mov g, a
  mov a, b
  pop bl
  test bl, $80
  jz _same_signs_790
  mov bl, al
  not a
  neg b
  adc a, 0
  mov g, a
  mov a, b
_same_signs_790:
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  pop d
  mov [d], b
; t =t/ 100; 
  lea d, [bp + 5] ; $t
  push d
  lea d, [bp + 5] ; $t
  mov b, [d]
  mov c, 0
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $00000064
  push g ; save 'g' as the div instruction uses it
  div a, b ; /, a: quotient, b: remainder
  pop g
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  pop d
  mov [d], b
_if784_exit:
; return t; 
  lea d, [bp + 5] ; $t
  mov b, [d]
  mov c, 0
  leave
  ret

distance_to:
  enter 0 ; (push bp; mov bp, sp)
; unsigned int         j; 
  sub sp, 2
; j = square00(TO_FIXED00(k->y) - ship_y); 
  lea d, [bp + -1] ; $j
  push d
; --- START FUNCTION CALL
; --- START FUNCTION CALL
  lea d, [bp + 5] ; $k
  mov d, [d]
  add d, 0
  mov bl, [d]
  mov bh, 0
  mov c, 0
  snex b
  swp b
  push b
  call TO_FIXED00
  add sp, 2
; --- END FUNCTION CALL
; --- START TERMS
  push a
  mov a, b
  mov d, _ship_y ; $ship_y
  mov b, [d]
  mov c, 0
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  swp b
  push b
  call square00
  add sp, 2
; --- END FUNCTION CALL
  pop d
  mov [d], b
; j = j + square00(TO_FIXED00(k->x) - ship_x); 
  lea d, [bp + -1] ; $j
  push d
  lea d, [bp + -1] ; $j
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
; --- START FUNCTION CALL
; --- START FUNCTION CALL
  lea d, [bp + 5] ; $k
  mov d, [d]
  add d, 1
  mov bl, [d]
  mov bh, 0
  mov c, 0
  snex b
  swp b
  push b
  call TO_FIXED00
  add sp, 2
; --- END FUNCTION CALL
; --- START TERMS
  push a
  mov a, b
  mov d, _ship_x ; $ship_x
  mov b, [d]
  mov c, 0
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  swp b
  push b
  call square00
  add sp, 2
; --- END FUNCTION CALL
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; j = isqrt(j); 
  lea d, [bp + -1] ; $j
  push d
; --- START FUNCTION CALL
  lea d, [bp + -1] ; $j
  mov b, [d]
  mov c, 0
  swp b
  push b
  call isqrt
  add sp, 2
; --- END FUNCTION CALL
  pop d
  mov [d], b
  leave
  ret

cint100:
  enter 0 ; (push bp; mov bp, sp)
; return (d + 50) / 100; 
  lea d, [bp + 5] ; $d
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000032
  add b, a
  pop a
; --- END TERMS
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $00000064
  push g ; save 'g' as the div instruction uses it
  div a, b ; /, a: quotient, b: remainder
  pop g
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  leave
  ret

showfile:
  enter 0 ; (push bp; mov bp, sp)
  leave
  ret

getchar:
  enter 0 ; (push bp; mov bp, sp)
; char c; 
  sub sp, 1
; --- BEGIN INLINE ASM SEGMENT
  mov al, 1
  syscall sys_io      ; receive in AH
  mov al, ah
  lea d, [bp + 0] ; $c
  mov [d], al
; --- END INLINE ASM SEGMENT
; return c; 
  lea d, [bp + 0] ; $c
  mov bl, [d]
  mov bh, 0
  mov c, 0
  leave
  ret

exit:
  enter 0 ; (push bp; mov bp, sp)
; --- BEGIN INLINE ASM SEGMENT
  lea d, [bp + 5] ; $status
  mov b, [d] ; return value
  syscall sys_terminate_proc
; --- END INLINE ASM SEGMENT
  leave
  ret

tolower:
  enter 0 ; (push bp; mov bp, sp)
; if (ch >= 'A' && ch <= 'Z')  
_if795_cond:
  lea d, [bp + 5] ; $ch
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000041
  cmp a, b
  sge ; >=
  pop a
; --- END RELATIONAL
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + 5] ; $ch
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $0000005a
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  cmp b, 0
  je _if795_else
_if795_TRUE:
; return ch - 'A' + 'a'; 
  lea d, [bp + 5] ; $ch
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000041
  sub a, b
  mov b, a
  mov a, b
  mov32 cb, $00000061
  add b, a
  pop a
; --- END TERMS
  leave
  ret
  jmp _if795_exit
_if795_else:
; return ch; 
  lea d, [bp + 5] ; $ch
  mov bl, [d]
  mov bh, 0
  mov c, 0
  leave
  ret
_if795_exit:
  leave
  ret

rand:
  enter 0 ; (push bp; mov bp, sp)
; int  sec; 
  sub sp, 2
; --- BEGIN INLINE ASM SEGMENT
  mov al, 0
  syscall sys_rtc					; get seconds
  mov al, ah
  lea d, [bp + -1] ; $sec
  mov al, [d]
  mov ah, 0
; --- END INLINE ASM SEGMENT
; return sec; 
  lea d, [bp + -1] ; $sec
  mov b, [d]
  mov c, 0
  leave
  ret

strcpy:
  enter 0 ; (push bp; mov bp, sp)
; char *psrc; 
  sub sp, 2
; char *pdest; 
  sub sp, 2
; psrc = src; 
  lea d, [bp + -1] ; $psrc
  push d
  lea d, [bp + 7] ; $src
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
; pdest = dest; 
  lea d, [bp + -3] ; $pdest
  push d
  lea d, [bp + 5] ; $dest
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
; while(*psrc) *pdest++ = *psrc++; 
_while796_cond:
  lea d, [bp + -1] ; $psrc
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  cmp b, 0
  je _while796_exit
_while796_block:
; *pdest++ = *psrc++; 
  lea d, [bp + -3] ; $pdest
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -3] ; $pdest
  mov [d], b
  dec b
  push b
  lea d, [bp + -1] ; $psrc
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -1] ; $psrc
  mov [d], b
  dec b
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mov [d], bl
  jmp _while796_cond
_while796_exit:
; *pdest = '\0'; 
  lea d, [bp + -3] ; $pdest
  mov b, [d]
  mov c, 0
  push b
  mov32 cb, $00000000
  pop d
  mov [d], bl
  leave
  ret

strcat:
  enter 0 ; (push bp; mov bp, sp)
; int dest_len; 
  sub sp, 2
; int i; 
  sub sp, 2
; dest_len = strlen(dest); 
  lea d, [bp + -1] ; $dest_len
  push d
; --- START FUNCTION CALL
  lea d, [bp + 5] ; $dest
  mov b, [d]
  mov c, 0
  swp b
  push b
  call strlen
  add sp, 2
; --- END FUNCTION CALL
  pop d
  mov [d], b
; for (i = 0; src[i] != 0; i=i+1) { 
_for797_init:
  lea d, [bp + -3] ; $i
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
_for797_cond:
  lea d, [bp + 7] ; $src
  mov d, [d]
  push a
  push d
  lea d, [bp + -3] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for797_exit
_for797_block:
; dest[dest_len + i] = src[i]; 
  lea d, [bp + 5] ; $dest
  mov d, [d]
  push a
  push d
  lea d, [bp + -1] ; $dest_len
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -3] ; $i
  mov b, [d]
  mov c, 0
  add b, a
  pop a
; --- END TERMS
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
  mov c, 0
  pop d
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mov [d], bl
_for797_update:
  lea d, [bp + -3] ; $i
  push d
  lea d, [bp + -3] ; $i
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000001
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
  jmp _for797_cond
_for797_exit:
; dest[dest_len + i] = 0; 
  lea d, [bp + 5] ; $dest
  mov d, [d]
  push a
  push d
  lea d, [bp + -1] ; $dest_len
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -3] ; $i
  mov b, [d]
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  pop d
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  push d
  mov32 cb, $00000000
  pop d
  mov [d], bl
; return dest; 
  lea d, [bp + 5] ; $dest
  mov b, [d]
  mov c, 0
  leave
  ret

strlen:
  enter 0 ; (push bp; mov bp, sp)
; int length; 
  sub sp, 2
; length = 0; 
  lea d, [bp + -1] ; $length
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
; while (str[length] != 0) { 
_while798_cond:
  lea d, [bp + 5] ; $str
  mov d, [d]
  push a
  push d
  lea d, [bp + -1] ; $length
  mov b, [d]
  mov c, 0
  pop d
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _while798_exit
_while798_block:
; length++; 
  lea d, [bp + -1] ; $length
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -1] ; $length
  mov [d], b
  mov b, a
  jmp _while798_cond
_while798_exit:
; return length; 
  lea d, [bp + -1] ; $length
  mov b, [d]
  mov c, 0
  leave
  ret

printf:
  enter 0 ; (push bp; mov bp, sp)
; char *p, *format_p; 
  sub sp, 2
  sub sp, 2
; format_p = format; 
  lea d, [bp + -3] ; $format_p
  push d
  lea d, [bp + 5] ; $format
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
; p = &format + 2; 
  lea d, [bp + -1] ; $p
  push d
  lea d, [bp + 5] ; $format
  mov b, d
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000002
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; for(;;){ 
_for799_init:
_for799_cond:
_for799_block:
; if(!*format_p) break; 
_if800_cond:
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  cmp b, 0
  seq ; !
  cmp b, 0
  je _if800_else
_if800_TRUE:
; break; 
  jmp _for799_exit ; for break
  jmp _if800_exit
_if800_else:
; if(*format_p == '%'){ 
_if801_cond:
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000025
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if801_else
_if801_TRUE:
; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  dec b
; switch(*format_p){ 
_switch802_expr:
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
_switch802_comparisons:
  cmp bl, $6c
  je _switch802_case0
  cmp bl, $4c
  je _switch802_case1
  cmp bl, $64
  je _switch802_case2
  cmp bl, $69
  je _switch802_case3
  cmp bl, $75
  je _switch802_case4
  cmp bl, $78
  je _switch802_case5
  cmp bl, $63
  je _switch802_case6
  cmp bl, $73
  je _switch802_case7
  jmp _switch802_default
  jmp _switch802_exit
_switch802_case0:
_switch802_case1:
; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  dec b
; if(*format_p == 'd' || *format_p == 'i') 
_if803_cond:
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000064
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
; --- START LOGICAL OR
  push a
  mov a, b
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000069
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  cmp b, 0
  je _if803_else
_if803_TRUE:
; print_signed_long(*(long *)p); 
; --- START FUNCTION CALL
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov c, 0
  mov d, b
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
  mov a, c
  swp a
  push a
  swp b
  push b
  call print_signed_long
  add sp, 4
; --- END FUNCTION CALL
  jmp _if803_exit
_if803_else:
; if(*format_p == 'u') 
_if804_cond:
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000075
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if804_else
_if804_TRUE:
; print_unsigned_long(*(unsigned long *)p); 
; --- START FUNCTION CALL
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov c, 0
  mov d, b
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
  mov a, c
  swp a
  push a
  swp b
  push b
  call print_unsigned_long
  add sp, 4
; --- END FUNCTION CALL
  jmp _if804_exit
_if804_else:
; if(*format_p == 'x') 
_if805_cond:
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000078
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if805_else
_if805_TRUE:
; printx32(*(long int *)p); 
; --- START FUNCTION CALL
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov c, 0
  mov d, b
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
  mov a, c
  swp a
  push a
  swp b
  push b
  call printx32
  add sp, 4
; --- END FUNCTION CALL
  jmp _if805_exit
_if805_else:
; err("Unexpected format in printf."); 
; --- START FUNCTION CALL
  mov b, _s169 ; "Unexpected format in printf."
  swp b
  push b
  call err
  add sp, 2
; --- END FUNCTION CALL
_if805_exit:
_if804_exit:
_if803_exit:
; p = p + 4; 
  lea d, [bp + -1] ; $p
  push d
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000004
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; break; 
  jmp _switch802_exit ; case break
_switch802_case2:
_switch802_case3:
; print_signed(*(int*)p); 
; --- START FUNCTION CALL
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov c, 0
  mov d, b
  mov b, [d]
  mov c, 0
  swp b
  push b
  call print_signed
  add sp, 2
; --- END FUNCTION CALL
; p = p + 2; 
  lea d, [bp + -1] ; $p
  push d
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000002
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; break; 
  jmp _switch802_exit ; case break
_switch802_case4:
; print_unsigned(*(unsigned int*)p); 
; --- START FUNCTION CALL
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov c, 0
  mov d, b
  mov b, [d]
  mov c, 0
  swp b
  push b
  call print_unsigned
  add sp, 2
; --- END FUNCTION CALL
; p = p + 2; 
  lea d, [bp + -1] ; $p
  push d
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000002
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; break; 
  jmp _switch802_exit ; case break
_switch802_case5:
; printx16(*(int*)p); 
; --- START FUNCTION CALL
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov c, 0
  mov d, b
  mov b, [d]
  mov c, 0
  swp b
  push b
  call printx16
  add sp, 2
; --- END FUNCTION CALL
; p = p + 2; 
  lea d, [bp + -1] ; $p
  push d
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000002
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; break; 
  jmp _switch802_exit ; case break
_switch802_case6:
; putchar(*(char*)p); 
; --- START FUNCTION CALL
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push bl
  call putchar
  add sp, 1
; --- END FUNCTION CALL
; p = p + 2; 
  lea d, [bp + -1] ; $p
  push d
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000002
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; break; 
  jmp _switch802_exit ; case break
_switch802_case7:
; print(*(char**)p); 
; --- START FUNCTION CALL
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov c, 0
  mov d, b
  mov b, [d]
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; p = p + 2; 
  lea d, [bp + -1] ; $p
  push d
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000002
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; break; 
  jmp _switch802_exit ; case break
_switch802_default:
; print("Error: Unknown argument type.\n"); 
; --- START FUNCTION CALL
  mov b, _s170 ; "Error: Unknown argument type.\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
_switch802_exit:
  jmp _if801_exit
_if801_else:
; putchar(*format_p); 
; --- START FUNCTION CALL
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push bl
  call putchar
  add sp, 1
; --- END FUNCTION CALL
_if801_exit:
_if800_exit:
; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  dec b
_for799_update:
  jmp _for799_cond
_for799_exit:
  leave
  ret

print_signed_long:
  enter 0 ; (push bp; mov bp, sp)
; char digits[10]; 
  sub sp, 10
; int i = 0; 
  sub sp, 2
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -11] ; $i
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
; --- END LOCAL VAR INITIALIZATION
; if (num < 0) { 
_if806_cond:
  lea d, [bp + 5] ; $num
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; --- START RELATIONAL
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $00000000
  mov c, 0
  cmp32 ga, cb
  slt ; <
  pop g
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if806_else
_if806_TRUE:
; putchar('-'); 
; --- START FUNCTION CALL
  mov32 cb, $0000002d
  push bl
  call putchar
  add sp, 1
; --- END FUNCTION CALL
; num = -num; 
  lea d, [bp + 5] ; $num
  push d
  lea d, [bp + 5] ; $num
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
  mov a, c
  not a
  not b
  add b, 1
  adc a, 0
  mov c, a
  pop d
  mov [d], b
  mov b, c
  mov [d + 2], b
  jmp _if806_exit
_if806_else:
; if (num == 0) { 
_if807_cond:
  lea d, [bp + 5] ; $num
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; --- START RELATIONAL
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $00000000
  mov c, 0
  cmp32 ga, cb
  seq ; ==
  pop g
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if807_exit
_if807_TRUE:
; putchar('0'); 
; --- START FUNCTION CALL
  mov32 cb, $00000030
  push bl
  call putchar
  add sp, 1
; --- END FUNCTION CALL
; return; 
  leave
  ret
  jmp _if807_exit
_if807_exit:
_if806_exit:
; while (num > 0) { 
_while808_cond:
  lea d, [bp + 5] ; $num
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; --- START RELATIONAL
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $00000000
  mov c, 0
  cmp32 ga, cb
  sgt
  pop g
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _while808_exit
_while808_block:
; digits[i] = '0' + (num % 10); 
  lea d, [bp + -9] ; $digits
  push a
  push d
  lea d, [bp + -11] ; $i
  mov b, [d]
  mov c, 0
  pop d
  add d, b
  pop a
  push d
  mov32 cb, $00000030
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + 5] ; $num
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $0000000a
  push g ; save 'g' as the div instruction uses it
  div a, b ; %, a: quotient, b: remainder
  mov a, b
  pop g
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  mov g, 0
  add32 cb, ga
  pop a
; --- END TERMS
  pop d
  mov [d], bl
; num = num / 10; 
  lea d, [bp + 5] ; $num
  push d
  lea d, [bp + 5] ; $num
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $0000000a
  push g ; save 'g' as the div instruction uses it
  div a, b ; /, a: quotient, b: remainder
  pop g
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  pop d
  mov [d], b
  mov b, c
  mov [d + 2], b
; i++; 
  lea d, [bp + -11] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -11] ; $i
  mov [d], b
  mov b, a
  jmp _while808_cond
_while808_exit:
; while (i > 0) { 
_while815_cond:
  lea d, [bp + -11] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  sgt ; >
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _while815_exit
_while815_block:
; i--; 
  lea d, [bp + -11] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  dec b
  lea d, [bp + -11] ; $i
  mov [d], b
  mov b, a
; putchar(digits[i]); 
; --- START FUNCTION CALL
  lea d, [bp + -9] ; $digits
  push a
  push d
  lea d, [bp + -11] ; $i
  mov b, [d]
  mov c, 0
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push bl
  call putchar
  add sp, 1
; --- END FUNCTION CALL
  jmp _while815_cond
_while815_exit:
  leave
  ret

putchar:
  enter 0 ; (push bp; mov bp, sp)
; --- BEGIN INLINE ASM SEGMENT
  lea d, [bp + 5] ; $c
  mov al, [d]
  mov ah, al
  mov al, 0
  syscall sys_io      ; char in AH
; --- END INLINE ASM SEGMENT
  leave
  ret

print_unsigned_long:
  enter 0 ; (push bp; mov bp, sp)
; char digits[10]; 
  sub sp, 10
; int i; 
  sub sp, 2
; i = 0; 
  lea d, [bp + -11] ; $i
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
; if(num == 0){ 
_if816_cond:
  lea d, [bp + 5] ; $num
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; --- START RELATIONAL
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $00000000
  mov c, 0
  cmp32 ga, cb
  seq ; ==
  pop g
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if816_exit
_if816_TRUE:
; putchar('0'); 
; --- START FUNCTION CALL
  mov32 cb, $00000030
  push bl
  call putchar
  add sp, 1
; --- END FUNCTION CALL
; return; 
  leave
  ret
  jmp _if816_exit
_if816_exit:
; while (num > 0) { 
_while817_cond:
  lea d, [bp + 5] ; $num
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; --- START RELATIONAL
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $00000000
  mov c, 0
  cmp32 ga, cb
  sgu
  pop g
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _while817_exit
_while817_block:
; digits[i] = '0' + (num % 10); 
  lea d, [bp + -9] ; $digits
  push a
  push d
  lea d, [bp + -11] ; $i
  mov b, [d]
  mov c, 0
  pop d
  add d, b
  pop a
  push d
  mov32 cb, $00000030
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + 5] ; $num
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $0000000a
  push g ; save 'g' as the div instruction uses it
  div a, b ; %, a: quotient, b: remainder
  mov a, b
  pop g
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  mov g, 0
  add32 cb, ga
  pop a
; --- END TERMS
  pop d
  mov [d], bl
; num = num / 10; 
  lea d, [bp + 5] ; $num
  push d
  lea d, [bp + 5] ; $num
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $0000000a
  push g ; save 'g' as the div instruction uses it
  div a, b ; /, a: quotient, b: remainder
  pop g
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  pop d
  mov [d], b
  mov b, c
  mov [d + 2], b
; i++; 
  lea d, [bp + -11] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -11] ; $i
  mov [d], b
  mov b, a
  jmp _while817_cond
_while817_exit:
; while (i > 0) { 
_while824_cond:
  lea d, [bp + -11] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  sgt ; >
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _while824_exit
_while824_block:
; i--; 
  lea d, [bp + -11] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  dec b
  lea d, [bp + -11] ; $i
  mov [d], b
  mov b, a
; putchar(digits[i]); 
; --- START FUNCTION CALL
  lea d, [bp + -9] ; $digits
  push a
  push d
  lea d, [bp + -11] ; $i
  mov b, [d]
  mov c, 0
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push bl
  call putchar
  add sp, 1
; --- END FUNCTION CALL
  jmp _while824_cond
_while824_exit:
  leave
  ret

printx32:
  enter 0 ; (push bp; mov bp, sp)
; --- BEGIN INLINE ASM SEGMENT
  lea d, [bp + 5] ; $hex
  mov b, [d+2]
  call print_u16x_printx32
  mov b, [d]
  call print_u16x_printx32
; --- END INLINE ASM SEGMENT
; return; 
  leave
  ret
; --- BEGIN INLINE ASM SEGMENT
print_u16x_printx32:
  push a
  push b
  push bl
  mov bl, bh
  call _itoa_printx32        ; convert bh to char in A
  mov bl, al        ; save al
  mov al, 0
  syscall sys_io        ; display AH
  mov ah, bl        ; retrieve al
  mov al, 0
  syscall sys_io        ; display AL
  pop bl
  call _itoa_printx32        ; convert bh to char in A
  mov bl, al        ; save al
  mov al, 0
  syscall sys_io        ; display AH
  mov ah, bl        ; retrieve al
  mov al, 0
  syscall sys_io        ; display AL
  pop b
  pop a
  ret
_itoa_printx32:
  push d
  push b
  mov bh, 0
  shr bl, 4  
  mov d, b
  mov al, [d + s_hex_digits_printx32]
  mov ah, al
  pop b
  push b
  mov bh, 0
  and bl, $0F
  mov d, b
  mov al, [d + s_hex_digits_printx32]
  pop b
  pop d
  ret
s_hex_digits_printx32: .db "0123456789ABCDEF"  
; --- END INLINE ASM SEGMENT
  leave
  ret

err:
  enter 0 ; (push bp; mov bp, sp)
; print(e); 
; --- START FUNCTION CALL
  lea d, [bp + 5] ; $e
  mov b, [d]
  mov c, 0
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
  leave
  ret

print:
  enter 0 ; (push bp; mov bp, sp)
; --- BEGIN INLINE ASM SEGMENT
  lea d, [bp + 5] ; $s
  mov d, [d]
_puts_L1_print:
  mov al, [d]
  cmp al, 0
  jz _puts_END_print
  mov ah, al
  mov al, 0
  syscall sys_io
  inc d
  jmp _puts_L1_print
_puts_END_print:
; --- END INLINE ASM SEGMENT
  leave
  ret

print_signed:
  enter 0 ; (push bp; mov bp, sp)
; char digits[5]; 
  sub sp, 5
; int i = 0; 
  sub sp, 2
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -6] ; $i
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
; --- END LOCAL VAR INITIALIZATION
; if (num < 0) { 
_if825_cond:
  lea d, [bp + 5] ; $num
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if825_else
_if825_TRUE:
; putchar('-'); 
; --- START FUNCTION CALL
  mov32 cb, $0000002d
  push bl
  call putchar
  add sp, 1
; --- END FUNCTION CALL
; num = -num; 
  lea d, [bp + 5] ; $num
  push d
  lea d, [bp + 5] ; $num
  mov b, [d]
  mov c, 0
  neg b
  pop d
  mov [d], b
  jmp _if825_exit
_if825_else:
; if (num == 0) { 
_if826_cond:
  lea d, [bp + 5] ; $num
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if826_exit
_if826_TRUE:
; putchar('0'); 
; --- START FUNCTION CALL
  mov32 cb, $00000030
  push bl
  call putchar
  add sp, 1
; --- END FUNCTION CALL
; return; 
  leave
  ret
  jmp _if826_exit
_if826_exit:
_if825_exit:
; while (num > 0) { 
_while827_cond:
  lea d, [bp + 5] ; $num
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  sgt ; >
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _while827_exit
_while827_block:
; digits[i] = '0' + (num % 10); 
  lea d, [bp + -4] ; $digits
  push a
  push d
  lea d, [bp + -6] ; $i
  mov b, [d]
  mov c, 0
  pop d
  add d, b
  pop a
  push d
  mov32 cb, $00000030
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + 5] ; $num
  mov b, [d]
  mov c, 0
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $0000000a
  push g ; save 'g' as the div instruction uses it
  div a, b ; %, a: quotient, b: remainder
  mov a, b
  pop g
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], bl
; num = num / 10; 
  lea d, [bp + 5] ; $num
  push d
  lea d, [bp + 5] ; $num
  mov b, [d]
  mov c, 0
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $0000000a
  push g ; save 'g' as the div instruction uses it
  div a, b ; /, a: quotient, b: remainder
  pop g
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  pop d
  mov [d], b
; i++; 
  lea d, [bp + -6] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -6] ; $i
  mov [d], b
  mov b, a
  jmp _while827_cond
_while827_exit:
; while (i > 0) { 
_while834_cond:
  lea d, [bp + -6] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  sgt ; >
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _while834_exit
_while834_block:
; i--; 
  lea d, [bp + -6] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  dec b
  lea d, [bp + -6] ; $i
  mov [d], b
  mov b, a
; putchar(digits[i]); 
; --- START FUNCTION CALL
  lea d, [bp + -4] ; $digits
  push a
  push d
  lea d, [bp + -6] ; $i
  mov b, [d]
  mov c, 0
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push bl
  call putchar
  add sp, 1
; --- END FUNCTION CALL
  jmp _while834_cond
_while834_exit:
  leave
  ret

print_unsigned:
  enter 0 ; (push bp; mov bp, sp)
; char digits[5]; 
  sub sp, 5
; int i; 
  sub sp, 2
; i = 0; 
  lea d, [bp + -6] ; $i
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
; if(num == 0){ 
_if835_cond:
  lea d, [bp + 5] ; $num
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if835_exit
_if835_TRUE:
; putchar('0'); 
; --- START FUNCTION CALL
  mov32 cb, $00000030
  push bl
  call putchar
  add sp, 1
; --- END FUNCTION CALL
; return; 
  leave
  ret
  jmp _if835_exit
_if835_exit:
; while (num > 0) { 
_while836_cond:
  lea d, [bp + 5] ; $num
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  sgu ; > (unsigned)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _while836_exit
_while836_block:
; digits[i] = '0' + (num % 10); 
  lea d, [bp + -4] ; $digits
  push a
  push d
  lea d, [bp + -6] ; $i
  mov b, [d]
  mov c, 0
  pop d
  add d, b
  pop a
  push d
  mov32 cb, $00000030
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + 5] ; $num
  mov b, [d]
  mov c, 0
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $0000000a
  push g ; save 'g' as the div instruction uses it
  div a, b ; %, a: quotient, b: remainder
  mov a, b
  pop g
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], bl
; num = num / 10; 
  lea d, [bp + 5] ; $num
  push d
  lea d, [bp + 5] ; $num
  mov b, [d]
  mov c, 0
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $0000000a
  push g ; save 'g' as the div instruction uses it
  div a, b ; /, a: quotient, b: remainder
  pop g
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  pop d
  mov [d], b
; i++; 
  lea d, [bp + -6] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -6] ; $i
  mov [d], b
  mov b, a
  jmp _while836_cond
_while836_exit:
; while (i > 0) { 
_while843_cond:
  lea d, [bp + -6] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  sgt ; >
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _while843_exit
_while843_block:
; i--; 
  lea d, [bp + -6] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  dec b
  lea d, [bp + -6] ; $i
  mov [d], b
  mov b, a
; putchar(digits[i]); 
; --- START FUNCTION CALL
  lea d, [bp + -4] ; $digits
  push a
  push d
  lea d, [bp + -6] ; $i
  mov b, [d]
  mov c, 0
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push bl
  call putchar
  add sp, 1
; --- END FUNCTION CALL
  jmp _while843_cond
_while843_exit:
  leave
  ret

printx16:
  enter 0 ; (push bp; mov bp, sp)
; --- BEGIN INLINE ASM SEGMENT
  lea d, [bp + 5] ; $hex
  mov b, [d]
print_u16x_printx16:
  push bl
  mov bl, bh
  call _itoa_printx16        ; convert bh to char in A
  mov bl, al        ; save al
  mov al, 0
  syscall sys_io        ; display AH
  mov ah, bl        ; retrieve al
  mov al, 0
  syscall sys_io        ; display AL
  pop bl
  call _itoa_printx16        ; convert bh to char in A
  mov bl, al        ; save al
  mov al, 0
  syscall sys_io        ; display AH
  mov ah, bl        ; retrieve al
  mov al, 0
  syscall sys_io        ; display AL
; --- END INLINE ASM SEGMENT
; return; 
  leave
  ret
; --- BEGIN INLINE ASM SEGMENT
_itoa_printx16:
  push d
  push b
  mov bh, 0
  shr bl, 4  
  mov d, b
  mov al, [d + s_hex_digits_printx16]
  mov ah, al
  pop b
  push b
  mov bh, 0
  and bl, $0F
  mov d, b
  mov al, [d + s_hex_digits_printx16]
  pop b
  pop d
  ret
s_hex_digits_printx16:    .db "0123456789ABCDEF"  
; --- END INLINE ASM SEGMENT
  leave
  ret

puts:
  enter 0 ; (push bp; mov bp, sp)
; --- BEGIN INLINE ASM SEGMENT
  lea d, [bp + 5] ; $s
  mov d, [d]
_puts_L1_puts:
  mov al, [d]
  cmp al, 0
  jz _puts_END_puts
  mov ah, al
  mov al, 0
  syscall sys_io
  inc d
  jmp _puts_L1_puts
_puts_END_puts:
  mov a, $0A00
  syscall sys_io
; --- END INLINE ASM SEGMENT
  leave
  ret

memset:
  enter 0 ; (push bp; mov bp, sp)
; int i; 
  sub sp, 2
; for(i = 0; i < size; i++){ 
_for844_init:
  lea d, [bp + -1] ; $i
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
_for844_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  lea d, [bp + 8] ; $size
  mov b, [d]
  mov c, 0
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for844_exit
_for844_block:
; *(s+i) = c; 
  lea d, [bp + 5] ; $s
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  push b
  lea d, [bp + 7] ; $c
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mov [d], bl
_for844_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  mov b, a
  jmp _for844_cond
_for844_exit:
; return s; 
  lea d, [bp + 5] ; $s
  mov b, [d]
  mov c, 0
  leave
  ret

strncmp:
  enter 0 ; (push bp; mov bp, sp)
; int i; 
  sub sp, 2
; for (i = 0; i < n; i++) { 
_for845_init:
  lea d, [bp + -1] ; $i
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
_for845_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  lea d, [bp + 9] ; $n
  mov b, [d]
  mov c, 0
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for845_exit
_for845_block:
; if (str1[i] != str2[i]) { 
_if846_cond:
  lea d, [bp + 5] ; $str1
  mov d, [d]
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  lea d, [bp + 7] ; $str2
  mov d, [d]
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if846_exit
_if846_TRUE:
; return (unsigned char)str1[i] - (unsigned char)str2[i]; 
  lea d, [bp + 5] ; $str1
  mov d, [d]
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
  mov bh, 0
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + 7] ; $str2
  mov d, [d]
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
  mov bh, 0
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  leave
  ret
  jmp _if846_exit
_if846_exit:
; if (str1[i] == '\0' || str2[i] == '\0') { 
_if847_cond:
  lea d, [bp + 5] ; $str1
  mov d, [d]
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
; --- START LOGICAL OR
  push a
  mov a, b
  lea d, [bp + 7] ; $str2
  mov d, [d]
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  cmp b, 0
  je _if847_exit
_if847_TRUE:
; break; 
  jmp _for845_exit ; for break
  jmp _if847_exit
_if847_exit:
_for845_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  mov b, a
  jmp _for845_cond
_for845_exit:
; return 0; 
  mov32 cb, $00000000
  leave
  ret

is_digit:
  enter 0 ; (push bp; mov bp, sp)
; return c >= '0' && c <= '9'; 
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000030
  cmp a, b
  sge ; >=
  pop a
; --- END RELATIONAL
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000039
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  leave
  ret

abs:
  enter 0 ; (push bp; mov bp, sp)
; return i < 0 ? -i : i; 
_ternary848_cond:
  lea d, [bp + 5] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _ternary848_FALSE
_ternary848_TRUE:
  lea d, [bp + 5] ; $i
  mov b, [d]
  mov c, 0
  neg b
  jmp _ternary848_exit
_ternary848_FALSE:
  lea d, [bp + 5] ; $i
  mov b, [d]
  mov c, 0
_ternary848_exit:
  leave
  ret

atoi:
  enter 0 ; (push bp; mov bp, sp)
; int result = 0;  // Initialize result 
  sub sp, 2
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -1] ; $result
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
; --- END LOCAL VAR INITIALIZATION
; int sign = 1;    // Initialize sign as positive 
  sub sp, 2
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -3] ; $sign
  push d
  mov32 cb, $00000001
  pop d
  mov [d], b
; --- END LOCAL VAR INITIALIZATION
; while (*str == ' ') str++; 
_while849_cond:
  lea d, [bp + 5] ; $str
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000020
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _while849_exit
_while849_block:
; str++; 
  lea d, [bp + 5] ; $str
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + 5] ; $str
  mov [d], b
  dec b
  jmp _while849_cond
_while849_exit:
; if (*str == '-' || *str == '+') { 
_if850_cond:
  lea d, [bp + 5] ; $str
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $0000002d
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
; --- START LOGICAL OR
  push a
  mov a, b
  lea d, [bp + 5] ; $str
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $0000002b
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  cmp b, 0
  je _if850_exit
_if850_TRUE:
; if (*str == '-') sign = -1; 
_if851_cond:
  lea d, [bp + 5] ; $str
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $0000002d
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if851_exit
_if851_TRUE:
; sign = -1; 
  lea d, [bp + -3] ; $sign
  push d
  mov32 cb, $ffffffff
  pop d
  mov [d], b
  jmp _if851_exit
_if851_exit:
; str++; 
  lea d, [bp + 5] ; $str
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + 5] ; $str
  mov [d], b
  dec b
  jmp _if850_exit
_if850_exit:
; while (*str >= '0' && *str <= '9') { 
_while852_cond:
  lea d, [bp + 5] ; $str
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000030
  cmp a, b
  sgeu ; >= (unsigned)
  pop a
; --- END RELATIONAL
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + 5] ; $str
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000039
  cmp a, b
  sleu ; <= (unsigned)
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  cmp b, 0
  je _while852_exit
_while852_block:
; result = result * 10 + (*str - '0'); 
  lea d, [bp + -1] ; $result
  push d
  lea d, [bp + -1] ; $result
  mov b, [d]
  mov c, 0
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $0000000a
  push a     ; save left operand
  xor a, b   ; xor sign bits
  swp a      ; swap bytes
  mov cl, al ; save result of xor into 'dl'
  pop a      ; restore left side operator
  push cl    ; save result of xor above
  swp a  
  test al, $80  
  swp a  
  jz skip_invert_a_854  
  neg a 
skip_invert_a_854:   
  swp b
  test bl, $80  
  swp b
  jz skip_invert_b_854  
  neg b 
skip_invert_b_854:   
  mul a, b ; *
  mov g, a
  mov a, b
  pop bl
  test bl, $80
  jz _same_signs_854
  mov bl, al
  not a
  neg b
  adc a, 0
  mov g, a
  mov a, b
_same_signs_854:
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
; --- START TERMS
  push a
  push g
  mov a, b
  mov g, c
  lea d, [bp + 5] ; $str
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000030
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  add b, a
  pop g
  pop a
; --- END TERMS
  pop d
  mov [d], b
; str++; 
  lea d, [bp + 5] ; $str
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + 5] ; $str
  mov [d], b
  dec b
  jmp _while852_cond
_while852_exit:
; return sign * result; 
  lea d, [bp + -3] ; $sign
  mov b, [d]
  mov c, 0
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  lea d, [bp + -1] ; $result
  mov b, [d]
  mov c, 0
  push a     ; save left operand
  xor a, b   ; xor sign bits
  swp a      ; swap bytes
  mov cl, al ; save result of xor into 'dl'
  pop a      ; restore left side operator
  push cl    ; save result of xor above
  swp a  
  test al, $80  
  swp a  
  jz skip_invert_a_856  
  neg a 
skip_invert_a_856:   
  swp b
  test bl, $80  
  swp b
  jz skip_invert_b_856  
  neg b 
skip_invert_b_856:   
  mul a, b ; *
  mov g, a
  mov a, b
  pop bl
  test bl, $80
  jz _same_signs_856
  mov bl, al
  not a
  neg b
  adc a, 0
  mov g, a
  mov a, b
_same_signs_856:
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  leave
  ret
; --- END TEXT SEGMENT

; --- BEGIN DATA SEGMENT
_starbases: .fill 1, 0
_base_y: .fill 1, 0
_base_x: .fill 1, 0
_starbases_left: .fill 1, 0
_c_data: .db $00,$00,$00,$ff,$ff,$ff,$00,$01,$01,$01,$00,$01,$01,$01,$00,
.db $ff,$ff,$ff,$00,$01,$01,

.fill 9, 0
_docked: .fill 1, 0
_energy: .fill 2, 0
_energy0: .dw $0bb8
_map_data: .fill 162, 0
_kdata_data: .fill 12, 0
_klingons: .fill 1, 0
_total_klingons: .fill 1, 0
_klingons_left: .fill 1, 0
_torps: .fill 1, 0
_torps0: .db $0a
_quad_y: .fill 2, 0
_quad_x: .fill 2, 0
_shield: .fill 2, 0
_stars: .fill 1, 0
_time_start: .fill 2, 0
_time_up: .fill 2, 0
_damage_data: .fill 18, 0
_d4: .fill 2, 0
_ship_y: .fill 2, 0
_ship_x: .fill 2, 0
_stardate: .fill 2, 0
_quad_data: .fill 64, 0
_quadname_data: .fill 12, 0
_inc_1_data: .db "reports:\n  Incorrect course data, sir!\n", 0
_inc_1: .dw _inc_1_data
_quad_name_data: .dw _s0, _s1, _s2, _s3, _s4, _s5, _s6, _s7, _s8, _s9, _s10, _s11, _s12, _s13, _s14, 
.dw _s15, _s16, 

.fill 34, 0
_device_name_data: .dw _s0, _s17, _s18, _s19, _s20, _s21, _s22, _s23, _s24, 

.fill 18, 0
_dcr_1_data: .db "Damage Control report:", 0
_dcr_1: .dw _dcr_1_data
_plural_2_data: .db $00,$00,
_plural_data: .db $69,$73,$00,

.fill 1, 0
_warpmax_data: .db $08,

.fill 3, 0
_srs_1_data: .db "------------------------", 0
_srs_1: .dw _srs_1_data
_tilestr_data: .dw _s25, _s26, _s27, _s28, _s29, 

.fill 10, 0
_lrs_1_data: .db "-------------------\n", 0
_lrs_1: .dw _lrs_1_data
_gr_1_data: .db "   ----- ----- ----- ----- ----- ----- ----- -----\n", 0
_gr_1: .dw _gr_1_data
_str_s_data: .db "s", 0
_str_s: .dw _str_s_data
_gm_1_data: .db "  ----- ----- ----- ----- ----- ----- ----- -----\n", 0
_gm_1: .dw _gm_1_data
_dist_1_data: .db "  DISTANCE = %s\n\n", 0
_dist_1: .dw _dist_1_data
st_print100_buf_dt: .fill 16, 0

st_quadrant_name_sect_name_dt: 
.dw _s0, _s164, _s165, _s166, _s167, 
.fill 10, 0
_s0: .db "", 0
_s1: .db "Antares", 0
_s2: .db "Rigel", 0
_s3: .db "Procyon", 0
_s4: .db "Vega", 0
_s5: .db "Canopus", 0
_s6: .db "Altair", 0
_s7: .db "Sagittarius", 0
_s8: .db "Pollux", 0
_s9: .db "Sirius", 0
_s10: .db "Deneb", 0
_s11: .db "Capella", 0
_s12: .db "Betelgeuse", 0
_s13: .db "Aldebaran", 0
_s14: .db "Regulus", 0
_s15: .db "Arcturus", 0
_s16: .db "Spica", 0
_s17: .db "Warp engines", 0
_s18: .db "Short range sensors", 0
_s19: .db "Long range sensors", 0
_s20: .db "Phaser control", 0
_s21: .db "Photon tubes", 0
_s22: .db "Damage control", 0
_s23: .db "Shield control", 0
_s24: .db "Library computer", 0
_s25: .db "   ", 0
_s26: .db " * ", 0
_s27: .db ">!<", 0
_s28: .db "+K+", 0
_s29: .db "<*>", 0
_s30: .db "are", 0
_s31: .db "is", 0
_s32: .db "%s %s inoperable.\n", 0
_s33: .db "startrek.intro", 0
_s34: .db "startrek.doc", 0
_s35: .db "startrek.logo", 0
_s36: .db "startrek.fatal", 0
_s37: .db "Command? ", 0
_s38: .db "nav", 0
_s39: .db "srs", 0
_s40: .db "lrs", 0
_s41: .db "pha", 0
_s42: .db "tor", 0
_s43: .db "shi", 0
_s44: .db "dam", 0
_s45: .db "com", 0
_s46: .db "xxx", 0
_s47: .db "Enter one of the following:\n", 0
_s48: .db "  nav - To Set Course", 0
_s49: .db "  srs - Short Range Sensors", 0
_s50: .db "  lrs - Long Range Sensors", 0
_s51: .db "  pha - Phasers", 0
_s52: .db "  tor - Photon Torpedoes", 0
_s53: .db "  shi - Shield Control", 0
_s54: .db "  dam - Damage Control", 0
_s55: .db "  com - Library Computer", 0
_s56: .db "  xxx - Resign Command\n", 0
_s57: .db "s", 0
_s58: .db "Now entering %s quadrant...\n\n", 0
_s59: .db "\nYour mission begins with your starship located", 0
_s60: .db "in the galactic quadrant %s.\n\n", 0
_s61: .db "Combat Area  Condition Red\n", 0
_s62: .db "Shields Dangerously Low\n", 0
_s63: .db "Course (0-9): ", 0
_s64: .db "Lt. Sulu%s", 0
_s65: .db "0.2", 0
_s66: .db "Warp Factor (0-%s): ", 0
_s67: .db "Warp Engines are damaged. Maximum speed = Warp 0.2.\n\n", 0
_s68: .db "Chief Engineer Scott reports:\n  The engines won't take warp %s!\n\n", 0
_s69: .db "Engineering reports:\n  Insufficient energy available for maneuvering at warp %s!\n\n", 0
_s70: .db "Deflector Control Room acknowledges:\n  %d units of energy presently deployed to shields.\n", 0
_s71: .db "LT. Uhura reports:\n Message from Starfleet Command:\n\n Permission to attempt crossing of galactic perimeter\n is hereby *denie"
.db "d*. Shut down your engines.\n\n Chief Engineer Scott reports:\n Warp Engines shut down at sector %d, %d of quadrant %d, %d.\n\n", 0
_s72: .db "Warp Engines shut down at sector %d, %d due to bad navigation.\n\n", 0
_s73: .db "Shield Control supplies energy to complete maneuver.\n", 0
_s74: .db "GREEN", 0
_s75: .db "YELLOW", 0
_s76: .db "*RED*", 0
_s77: .db "DOCKED", 0
_s78: .db "Shields dropped for docking purposes.", 0
_s79: .db "\n*** Short Range Sensors are out ***", 0
_s80: .db "    Stardate            %d\n", 0
_s81: .db "    Condition           %s\n", 0
_s82: .db "    Quadrant            %d, %d\n", 0
_s83: .db "    Sector              %d, %d\n", 0
_s84: .db "    Photon Torpedoes    %d\n", 0
_s85: .db "    Total Energy        %d\n", 0
_s86: .db "    Shields             %d\n", 0
_s87: .db "    Klingons Remaining  %d\n", 0
_s88: .db "Long Range Scan for Quadrant %d, %d\n\n", 0
_s89: .db "%s:", 0
_s90: .db "***", 0
_s91: .db " :", 0
_s92: .db "%s\n", 0
_s93: .db "Science Officer Spock reports:\n  'Sensors show no enemy ships in this quadrant'\n", 0
_s94: .db "Computer failure hampers accuracy.", 0
_s95: .db "Phasers locked on target;\n Energy available = %d units\n\n Number of units to fire: ", 0
_s96: .db "Not enough energy available.\n", 0
_s97: .db "Sensors show no damage to enemy at %d, %d\n\n", 0
_s98: .db "%d unit hit on Klingon at sector %d, %d\n", 0
_s99: .db "*** Klingon Destroyed ***\n", 0
_s100: .db "   (Sensors show %d units remaining.)\n\n", 0
_s101: .db "All photon torpedoes expended", 0
_s102: .db "Ensign Chekov%s", 0
_s103: .db "Torpedo Track:", 0
_s104: .db "    %d, %d\n", 0
_s105: .db "Torpedo Missed\n", 0
_s106: .db "Star at %d, %d absorbed torpedo energy.\n\n", 0
_s107: .db "*** Starbase Destroyed ***", 0
_s108: .db "That does it, Captain!!", 0
_s109: .db "You are hereby relieved of command\n", 0
_s110: .db "and sentenced to 99 stardates of hard", 0
_s111: .db "labor on Cygnus 12!!\n", 0
_s112: .db "Starfleet Command reviewing your record to consider\n court martial!\n", 0
_s113: .db "Damage Control report not available.", 0
_s114: .db "\nTechnicians standing by to effect repairs to your ship;\nEstimated time to repair: %s stardates.\n Will you authorize the repa"
.db "ir order (y/N)? ", 0
_s115: .db "Device            State of Repair", 0
_s116: .db "%-25s%6s\n", 0
_s117: .db "\n", 0
_s118: .db "Energy available = %d\n\n Input number of units to shields: ", 0
_s119: .db "<Shields Unchanged>\n", 0
_s120: .db "Shield Control Reports:\n  'This is not the Federation Treasury.'", 0
_s121: .db "Deflector Control Room report:\n  'Shields now at %d units per your command.'\n\n", 0
_s122: .db "Computer active and awating command: ", 0
_s123: .db "Functions available from Library-Computer:\n\n", 0
_s124: .db "   0 = Cumulative Galactic Record\n", 0
_s125: .db "   1 = Status Report\n", 0
_s126: .db "   2 = Photon Torpedo Data\n", 0
_s127: .db "   3 = Starbase Nav Data\n", 0
_s128: .db "   4 = Direction/Distance Calculator\n", 0
_s129: .db "   5 = Galaxy 'Region Name' Map\n", 0
_s130: .db "\n     Computer Record of Galaxy for Quadrant %d,%d\n\n", 0
_s131: .db "     1     2     3     4     5     6     7     8", 0
_s132: .db "%s%d", 0
_s133: .db "   Status Report:\n", 0
_s134: .db "Klingon%s Left: %d\n Mission must be completed in %d.%d stardates\n", 0
_s135: .db "Your stupidity has left you on your own in the galaxy\n -- you have no starbases left!\n", 0
_s136: .db "The Federation is maintaining %d starbase%s in the galaxy\n\n", 0
_s137: .db "From Enterprise to Klingon battlecriuser%s:\n\n", 0
_s138: .db "Mr. Spock reports,\n  'Sensors show no starbases in this quadrant.'\n", 0
_s139: .db "Direction/Distance Calculator\n You are at quadrant %d,%d sector %d,%d\n\n Please enter initial X coordinate: ", 0
_s140: .db "Please enter initial Y coordinate: ", 0
_s141: .db "Please enter final X coordinate: ", 0
_s142: .db "Please enter final Y coordinate: ", 0
_s143: .db "\n                   The Galaxy\n\n", 0
_s144: .db "    1     2     3     4     5     6     7     8\n", 0
_s145: .db "%s%d ", 0
_s146: .db "  DIRECTION = ", 0
_s147: .db "%s", 0
_s148: .db "The Enterprise has been destroyed. The Federation will be conquered.\n", 0
_s149: .db "It is stardate %d.\n\n", 0
_s150: .db "There were %d Klingon Battlecruisers left at the end of your mission.\n\n", 0
_s151: .db "Congratulations, Captain!  The last Klingon Battle Cruiser\n menacing the Federation has been destoyed.\n", 0
_s152: .db "Your efficiency rating is %s\n", 0
_s153: .db "The Federation is in need of a new starship commander", 0
_s154: .db " for a similar mission.\n", 0
_s155: .db "If there is a volunteer, let him step forward and", 0
_s156: .db " enter 'aye': ", 0
_s157: .db "Starbase shields protect the Enterprise\n", 0
_s158: .db "%d unit hit on Enterprise from sector %d, %d\n", 0
_s159: .db "    <Shields down to %d units>\n\n", 0
_s160: .db "Damage Control reports\n'%s' damaged by hit\n\n", 0
_s161: .db "    %s repair completed\n\n", 0
_s162: .db "    %s damaged\n\n", 0
_s163: .db "    %s state of repair improved\n\n", 0
_s164: .db " I", 0
_s165: .db " II", 0
_s166: .db " III", 0
_s167: .db " IV", 0
_s168: .db "Unknown", 0
_s169: .db "Unexpected format in printf.", 0
_s170: .db "Error: Unknown argument type.\n", 0

_heap_top: .dw _heap
_heap: .db 0
; --- END DATA SEGMENT

.end
