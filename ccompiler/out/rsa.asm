; --- FILENAME: programs/rsa.c
; --- DATE:     08-07-2025 at 23:49:40
.include "lib/asm/kernel.exp"
.include "lib/asm/bios.exp"

; --- BEGIN TEXT SEGMENT
.org text_org
main:
  mov bp, $FFE0 ;
  mov sp, $FFE0 ; Make space for argc(2 bytes) and for 10 pointers in argv (local variables)
; int p, q, n, phi, e, d; 
  sub sp, 2
  sub sp, 2
  sub sp, 2
  sub sp, 2
  sub sp, 2
  sub sp, 2
; int i; 
  sub sp, 2
; char input_str[100]; 
  sub sp, 100
; int encrypted_chars[100]; 
  sub sp, 200
; int encrypted_chars_len ; 
  sub sp, 2
; int decrypted_char; 
  sub sp, 2
; char c; 
  sub sp, 1
; p = 13; 
  lea d, [bp + -1] ; $p
  push d
  mov32 cb, $0000000d
  pop d
  mov [d], b
; q = 11; 
  lea d, [bp + -3] ; $q
  push d
  mov32 cb, $0000000b
  pop d
  mov [d], b
; n = p * q; 
  lea d, [bp + -5] ; $n
  push d
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov c, 0
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  lea d, [bp + -3] ; $q
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
  pop d
  mov [d], b
; phi = (p - 1) * (q - 1); 
  lea d, [bp + -7] ; $phi
  push d
  lea d, [bp + -1] ; $p
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
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  lea d, [bp + -3] ; $q
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
  push a     ; save left operand
  xor a, b   ; xor sign bits
  swp a      ; swap bytes
  mov cl, al ; save result of xor into 'dl'
  pop a      ; restore left side operator
  push cl    ; save result of xor above
  swp a  
  test al, $80  
  swp a  
  jz skip_invert_a_4  
  neg a 
skip_invert_a_4:   
  swp b
  test bl, $80  
  swp b
  jz skip_invert_b_4  
  neg b 
skip_invert_b_4:   
  mul a, b ; *
  mov g, a
  mov a, b
  pop bl
  test bl, $80
  jz _same_signs_4
  mov bl, al
  not a
  neg b
  adc a, 0
  mov g, a
  mov a, b
_same_signs_4:
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  pop d
  mov [d], b
; e = find_e(phi); 
  lea d, [bp + -9] ; $e
  push d
; --- START FUNCTION CALL
  lea d, [bp + -7] ; $phi
  mov b, [d]
  mov c, 0
  swp b
  push b
  call find_e
  add sp, 2
; --- END FUNCTION CALL
  pop d
  mov [d], b
; d = find_d(e, phi); 
  lea d, [bp + -11] ; $d
  push d
; --- START FUNCTION CALL
  lea d, [bp + -7] ; $phi
  mov b, [d]
  mov c, 0
  swp b
  push b
  lea d, [bp + -9] ; $e
  mov b, [d]
  mov c, 0
  swp b
  push b
  call find_d
  add sp, 4
; --- END FUNCTION CALL
  pop d
  mov [d], b
; printf("Public Key: %d, %d\n", n, e); 
; --- START FUNCTION CALL
  lea d, [bp + -9] ; $e
  mov b, [d]
  mov c, 0
  swp b
  push b
  lea d, [bp + -5] ; $n
  mov b, [d]
  mov c, 0
  swp b
  push b
  mov b, _s0 ; "Public Key: %d, %d\n"
  swp b
  push b
  call printf
  add sp, 6
; --- END FUNCTION CALL
; printf("Private Key: %d, %d\n", n, d); 
; --- START FUNCTION CALL
  lea d, [bp + -11] ; $d
  mov b, [d]
  mov c, 0
  swp b
  push b
  lea d, [bp + -5] ; $n
  mov b, [d]
  mov c, 0
  swp b
  push b
  mov b, _s1 ; "Private Key: %d, %d\n"
  swp b
  push b
  call printf
  add sp, 6
; --- END FUNCTION CALL
; printf("Enter a string: "); 
; --- START FUNCTION CALL
  mov b, _s2 ; "Enter a string: "
  swp b
  push b
  call printf
  add sp, 2
; --- END FUNCTION CALL
; gets(input_str); 
; --- START FUNCTION CALL
  lea d, [bp + -113] ; $input_str
  mov b, d
  mov c, 0
  swp b
  push b
  call gets
  add sp, 2
; --- END FUNCTION CALL
; encrypted_chars_len = 0; 
  lea d, [bp + -315] ; $encrypted_chars_len
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
; printf("\nEncrypted text: "); 
; --- START FUNCTION CALL
  mov b, _s3 ; "\nEncrypted text: "
  swp b
  push b
  call printf
  add sp, 2
; --- END FUNCTION CALL
; for (i = 0; input_str[i] != '\0' && input_str[i] != '\n'; i++) { 
_for5_init:
  lea d, [bp + -13] ; $i
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
_for5_cond:
  lea d, [bp + -113] ; $input_str
  push a
  push d
  lea d, [bp + -13] ; $i
  mov b, [d]
  mov c, 0
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
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + -113] ; $input_str
  push a
  push d
  lea d, [bp + -13] ; $i
  mov b, [d]
  mov c, 0
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $0000000a
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  cmp b, 0
  je _for5_exit
_for5_block:
; encrypted_chars[i] = mod_exp(input_str[i], e, n); 
  lea d, [bp + -313] ; $encrypted_chars
  push a
  push d
  lea d, [bp + -13] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
; --- START FUNCTION CALL
  lea d, [bp + -5] ; $n
  mov b, [d]
  mov c, 0
  swp b
  push b
  lea d, [bp + -9] ; $e
  mov b, [d]
  mov c, 0
  swp b
  push b
  lea d, [bp + -113] ; $input_str
  push a
  push d
  lea d, [bp + -13] ; $i
  mov b, [d]
  mov c, 0
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
  snex b
  swp b
  push b
  call mod_exp
  add sp, 6
; --- END FUNCTION CALL
  pop d
  mov [d], b
; printf("%d ", encrypted_chars[i]); 
; --- START FUNCTION CALL
  lea d, [bp + -313] ; $encrypted_chars
  push a
  push d
  lea d, [bp + -13] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  swp b
  push b
  mov b, _s4 ; "%d "
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
; encrypted_chars_len++; 
  lea d, [bp + -315] ; $encrypted_chars_len
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -315] ; $encrypted_chars_len
  mov [d], b
  mov b, a
_for5_update:
  lea d, [bp + -13] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -13] ; $i
  mov [d], b
  mov b, a
  jmp _for5_cond
_for5_exit:
; printf("\nDecrypted text: "); 
; --- START FUNCTION CALL
  mov b, _s5 ; "\nDecrypted text: "
  swp b
  push b
  call printf
  add sp, 2
; --- END FUNCTION CALL
; for (i = 0; i < encrypted_chars_len; i++) { 
_for6_init:
  lea d, [bp + -13] ; $i
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
_for6_cond:
  lea d, [bp + -13] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -315] ; $encrypted_chars_len
  mov b, [d]
  mov c, 0
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for6_exit
_for6_block:
; decrypted_char = mod_exp(encrypted_chars[i], d, n); 
  lea d, [bp + -317] ; $decrypted_char
  push d
; --- START FUNCTION CALL
  lea d, [bp + -5] ; $n
  mov b, [d]
  mov c, 0
  swp b
  push b
  lea d, [bp + -11] ; $d
  mov b, [d]
  mov c, 0
  swp b
  push b
  lea d, [bp + -313] ; $encrypted_chars
  push a
  push d
  lea d, [bp + -13] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  swp b
  push b
  call mod_exp
  add sp, 6
; --- END FUNCTION CALL
  pop d
  mov [d], b
; c = decrypted_char; 
  lea d, [bp + -318] ; $c
  push d
  lea d, [bp + -317] ; $decrypted_char
  mov b, [d]
  mov c, 0
  pop d
  mov [d], bl
; putchar(c); 
; --- START FUNCTION CALL
  lea d, [bp + -318] ; $c
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push bl
  call putchar
  add sp, 1
; --- END FUNCTION CALL
_for6_update:
  lea d, [bp + -13] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -13] ; $i
  mov [d], b
  mov b, a
  jmp _for6_cond
_for6_exit:
; printf("\n"); 
; --- START FUNCTION CALL
  mov b, _s6 ; "\n"
  swp b
  push b
  call printf
  add sp, 2
; --- END FUNCTION CALL
; return 0; 
  mov32 cb, $00000000
  leave
  syscall sys_terminate_proc

gcd:
  enter 0 ; (push bp; mov bp, sp)
; if (b == 0) { 
_if7_cond:
  lea d, [bp + 7] ; $b
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
  je _if7_exit
_if7_TRUE:
; return a; 
  lea d, [bp + 5] ; $a
  mov b, [d]
  mov c, 0
  leave
  ret
  jmp _if7_exit
_if7_exit:
; return gcd(b, a % b); 
; --- START FUNCTION CALL
  lea d, [bp + 5] ; $a
  mov b, [d]
  mov c, 0
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  lea d, [bp + 7] ; $b
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
  swp b
  push b
  lea d, [bp + 7] ; $b
  mov b, [d]
  mov c, 0
  swp b
  push b
  call gcd
  add sp, 4
; --- END FUNCTION CALL
  leave
  ret

mod_exp:
  enter 0 ; (push bp; mov bp, sp)
; int result; 
  sub sp, 2
; result = 1; 
  lea d, [bp + -1] ; $result
  push d
  mov32 cb, $00000001
  pop d
  mov [d], b
; while (exp > 0) { 
_while12_cond:
  lea d, [bp + 7] ; $exp
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
  je _while12_exit
_while12_block:
; if (exp & 1) { 
_if13_cond:
  lea d, [bp + 7] ; $exp
  mov b, [d]
  mov c, 0
  push a
  mov a, b
  mov32 cb, $00000001
  and b, a ; &
  pop a
  cmp b, 0
  je _if13_exit
_if13_TRUE:
; result = (result * base) % mod; 
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
  lea d, [bp + 5] ; $base
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
  jz skip_invert_a_18  
  neg a 
skip_invert_a_18:   
  swp b
  test bl, $80  
  swp b
  jz skip_invert_b_18  
  neg b 
skip_invert_b_18:   
  mul a, b ; *
  mov g, a
  mov a, b
  pop bl
  test bl, $80
  jz _same_signs_18
  mov bl, al
  not a
  neg b
  adc a, 0
  mov g, a
  mov a, b
_same_signs_18:
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
  lea d, [bp + 9] ; $mod
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
  pop d
  mov [d], b
  jmp _if13_exit
_if13_exit:
; exp = exp >> 1; 
  lea d, [bp + 7] ; $exp
  push d
  lea d, [bp + 7] ; $exp
  mov b, [d]
  mov c, 0
; --- START SHIFT
  push a
  mov a, b
  mov32 cb, $00000001
  mov c, b
  ashr a, cl
  mov b, a
  pop a
; --- END SHIFT
  pop d
  mov [d], b
; base = (base * base) % mod; 
  lea d, [bp + 5] ; $base
  push d
  lea d, [bp + 5] ; $base
  mov b, [d]
  mov c, 0
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  lea d, [bp + 5] ; $base
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
  jz skip_invert_a_24  
  neg a 
skip_invert_a_24:   
  swp b
  test bl, $80  
  swp b
  jz skip_invert_b_24  
  neg b 
skip_invert_b_24:   
  mul a, b ; *
  mov g, a
  mov a, b
  pop bl
  test bl, $80
  jz _same_signs_24
  mov bl, al
  not a
  neg b
  adc a, 0
  mov g, a
  mov a, b
_same_signs_24:
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
  lea d, [bp + 9] ; $mod
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
  pop d
  mov [d], b
  jmp _while12_cond
_while12_exit:
; return result; 
  lea d, [bp + -1] ; $result
  mov b, [d]
  mov c, 0
  leave
  ret

find_e:
  enter 0 ; (push bp; mov bp, sp)
; int e; 
  sub sp, 2
; for (e = 2; e < phi; e++) { 
_for26_init:
  lea d, [bp + -1] ; $e
  push d
  mov32 cb, $00000002
  pop d
  mov [d], b
_for26_cond:
  lea d, [bp + -1] ; $e
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  lea d, [bp + 5] ; $phi
  mov b, [d]
  mov c, 0
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for26_exit
_for26_block:
; if (gcd(e, phi) == 1) { 
_if27_cond:
; --- START FUNCTION CALL
  lea d, [bp + 5] ; $phi
  mov b, [d]
  mov c, 0
  swp b
  push b
  lea d, [bp + -1] ; $e
  mov b, [d]
  mov c, 0
  swp b
  push b
  call gcd
  add sp, 4
; --- END FUNCTION CALL
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000001
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if27_exit
_if27_TRUE:
; return e; 
  lea d, [bp + -1] ; $e
  mov b, [d]
  mov c, 0
  leave
  ret
  jmp _if27_exit
_if27_exit:
_for26_update:
  lea d, [bp + -1] ; $e
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -1] ; $e
  mov [d], b
  mov b, a
  jmp _for26_cond
_for26_exit:
; return 0; 
  mov32 cb, $00000000
  leave
  ret

find_d:
  enter 0 ; (push bp; mov bp, sp)
; int d; 
  sub sp, 2
; for (d = 2; d < phi; d++) { 
_for28_init:
  lea d, [bp + -1] ; $d
  push d
  mov32 cb, $00000002
  pop d
  mov [d], b
_for28_cond:
  lea d, [bp + -1] ; $d
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  lea d, [bp + 7] ; $phi
  mov b, [d]
  mov c, 0
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for28_exit
_for28_block:
; if ((d * e) % phi == 1) {   
_if29_cond:
  lea d, [bp + -1] ; $d
  mov b, [d]
  mov c, 0
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  lea d, [bp + 5] ; $e
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
  jz skip_invert_a_34  
  neg a 
skip_invert_a_34:   
  swp b
  test bl, $80  
  swp b
  jz skip_invert_b_34  
  neg b 
skip_invert_b_34:   
  mul a, b ; *
  mov g, a
  mov a, b
  pop bl
  test bl, $80
  jz _same_signs_34
  mov bl, al
  not a
  neg b
  adc a, 0
  mov g, a
  mov a, b
_same_signs_34:
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
  lea d, [bp + 7] ; $phi
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
; --- START RELATIONAL
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $00000001
  mov c, 0
  cmp32 ga, cb
  seq ; ==
  pop g
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if29_exit
_if29_TRUE:
; return d; 
  lea d, [bp + -1] ; $d
  mov b, [d]
  mov c, 0
  leave
  ret
  jmp _if29_exit
_if29_exit:
_for28_update:
  lea d, [bp + -1] ; $d
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -1] ; $d
  mov [d], b
  mov b, a
  jmp _for28_cond
_for28_exit:
; return 0; 
  mov32 cb, $00000000
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
_for36_init:
_for36_cond:
_for36_block:
; if(!*format_p) break; 
_if37_cond:
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
  je _if37_else
_if37_TRUE:
; break; 
  jmp _for36_exit ; for break
  jmp _if37_exit
_if37_else:
; if(*format_p == '%'){ 
_if38_cond:
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
  je _if38_else
_if38_TRUE:
; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  dec b
; switch(*format_p){ 
_switch39_expr:
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
_switch39_comparisons:
  cmp bl, $6c
  je _switch39_case0
  cmp bl, $4c
  je _switch39_case1
  cmp bl, $64
  je _switch39_case2
  cmp bl, $69
  je _switch39_case3
  cmp bl, $75
  je _switch39_case4
  cmp bl, $78
  je _switch39_case5
  cmp bl, $63
  je _switch39_case6
  cmp bl, $73
  je _switch39_case7
  jmp _switch39_default
  jmp _switch39_exit
_switch39_case0:
_switch39_case1:
; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  dec b
; if(*format_p == 'd' || *format_p == 'i') 
_if40_cond:
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
  je _if40_else
_if40_TRUE:
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
  jmp _if40_exit
_if40_else:
; if(*format_p == 'u') 
_if41_cond:
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
  je _if41_else
_if41_TRUE:
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
  jmp _if41_exit
_if41_else:
; if(*format_p == 'x') 
_if42_cond:
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
  je _if42_else
_if42_TRUE:
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
  jmp _if42_exit
_if42_else:
; err("Unexpected format in printf."); 
; --- START FUNCTION CALL
  mov b, _s7 ; "Unexpected format in printf."
  swp b
  push b
  call err
  add sp, 2
; --- END FUNCTION CALL
_if42_exit:
_if41_exit:
_if40_exit:
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
  jmp _switch39_exit ; case break
_switch39_case2:
_switch39_case3:
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
  jmp _switch39_exit ; case break
_switch39_case4:
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
  jmp _switch39_exit ; case break
_switch39_case5:
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
  jmp _switch39_exit ; case break
_switch39_case6:
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
  jmp _switch39_exit ; case break
_switch39_case7:
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
  jmp _switch39_exit ; case break
_switch39_default:
; print("Error: Unknown argument type.\n"); 
; --- START FUNCTION CALL
  mov b, _s8 ; "Error: Unknown argument type.\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
_switch39_exit:
  jmp _if38_exit
_if38_else:
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
_if38_exit:
_if37_exit:
; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  dec b
_for36_update:
  jmp _for36_cond
_for36_exit:
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
_if43_cond:
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
  je _if43_else
_if43_TRUE:
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
  jmp _if43_exit
_if43_else:
; if (num == 0) { 
_if44_cond:
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
  je _if44_exit
_if44_TRUE:
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
  jmp _if44_exit
_if44_exit:
_if43_exit:
; while (num > 0) { 
_while45_cond:
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
  je _while45_exit
_while45_block:
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
  jmp _while45_cond
_while45_exit:
; while (i > 0) { 
_while52_cond:
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
  je _while52_exit
_while52_block:
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
  jmp _while52_cond
_while52_exit:
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
_if53_cond:
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
  je _if53_exit
_if53_TRUE:
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
  jmp _if53_exit
_if53_exit:
; while (num > 0) { 
_while54_cond:
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
  je _while54_exit
_while54_block:
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
  jmp _while54_cond
_while54_exit:
; while (i > 0) { 
_while61_cond:
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
  je _while61_exit
_while61_block:
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
  jmp _while61_cond
_while61_exit:
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
_if62_cond:
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
  je _if62_else
_if62_TRUE:
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
  jmp _if62_exit
_if62_else:
; if (num == 0) { 
_if63_cond:
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
  je _if63_exit
_if63_TRUE:
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
  jmp _if63_exit
_if63_exit:
_if62_exit:
; while (num > 0) { 
_while64_cond:
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
  je _while64_exit
_while64_block:
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
  jmp _while64_cond
_while64_exit:
; while (i > 0) { 
_while71_cond:
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
  je _while71_exit
_while71_block:
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
  jmp _while71_cond
_while71_exit:
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
_if72_cond:
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
  je _if72_exit
_if72_TRUE:
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
  jmp _if72_exit
_if72_exit:
; while (num > 0) { 
_while73_cond:
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
  je _while73_exit
_while73_block:
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
  jmp _while73_cond
_while73_exit:
; while (i > 0) { 
_while80_cond:
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
  je _while80_exit
_while80_block:
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
  jmp _while80_cond
_while80_exit:
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

gets:
  enter 0 ; (push bp; mov bp, sp)
; --- BEGIN INLINE ASM SEGMENT
  lea d, [bp + 5] ; $s
  mov a, [d]
  mov d, a
  call _gets_gets
; --- END INLINE ASM SEGMENT
; return strlen(s); 
; --- START FUNCTION CALL
  lea d, [bp + 5] ; $s
  mov b, [d]
  mov c, 0
  swp b
  push b
  call strlen
  add sp, 2
; --- END FUNCTION CALL
  leave
  ret
; --- BEGIN INLINE ASM SEGMENT
_gets_gets:
  push a
  push d
_gets_loop_gets:
  mov al, 1
  syscall sys_io      ; receive in AH
  cmp al, 0        ; check error code (AL)
  je _gets_loop_gets      ; if no char received, retry
  cmp ah, 27
  je _gets_ansi_esc_gets
  cmp ah, $0A        ; LF
  je _gets_end_gets
  cmp ah, $0D        ; CR
  je _gets_end_gets
  cmp ah, $5C        ; '\\'
  je _gets_escape_gets
  cmp ah, $08      ; check for backspace
  je _gets_backspace_gets
  mov al, ah
  mov [d], al
  inc d
  jmp _gets_loop_gets
_gets_backspace_gets:
  dec d
  jmp _gets_loop_gets
_gets_ansi_esc_gets:
  mov al, 1
  syscall sys_io        ; receive in AH without echo
  cmp al, 0          ; check error code (AL)
  je _gets_ansi_esc_gets    ; if no char received, retry
  cmp ah, '['
  jne _gets_loop_gets
_gets_ansi_esc_2_gets:
  mov al, 1
  syscall sys_io          ; receive in AH without echo
  cmp al, 0            ; check error code (AL)
  je _gets_ansi_esc_2_gets  ; if no char received, retry
  cmp ah, 'D'
  je _gets_left_arrow_gets
  cmp ah, 'C'
  je _gets_right_arrow_gets
  jmp _gets_loop_gets
_gets_left_arrow_gets:
  dec d
  jmp _gets_loop_gets
_gets_right_arrow_gets:
  inc d
  jmp _gets_loop_gets
_gets_escape_gets:
  mov al, 1
  syscall sys_io      ; receive in AH
  cmp al, 0        ; check error code (AL)
  je _gets_escape_gets      ; if no char received, retry
  cmp ah, 'n'
  je _gets_LF_gets
  cmp ah, 'r'
  je _gets_CR_gets
  cmp ah, '0'
  je _gets_NULL_gets
  cmp ah, $5C  
  je _gets_slash_gets
  mov al, ah        ; if not a known escape, it is just a normal letter
  mov [d], al
  inc d
  jmp _gets_loop_gets
_gets_slash_gets:
  mov al, $5C
  mov [d], al
  inc d
  jmp _gets_loop_gets
_gets_LF_gets:
  mov al, $0A
  mov [d], al
  inc d
  jmp _gets_loop_gets
_gets_CR_gets:
  mov al, $0D
  mov [d], al
  inc d
  jmp _gets_loop_gets
_gets_NULL_gets:
  mov al, $00
  mov [d], al
  inc d
  jmp _gets_loop_gets
_gets_end_gets:
  mov al, 0
  mov [d], al        ; terminate string
  pop d
  pop a
  ret
; --- END INLINE ASM SEGMENT
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
_while81_cond:
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
  je _while81_exit
_while81_block:
; length++; 
  lea d, [bp + -1] ; $length
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -1] ; $length
  mov [d], b
  mov b, a
  jmp _while81_cond
_while81_exit:
; return length; 
  lea d, [bp + -1] ; $length
  mov b, [d]
  mov c, 0
  leave
  ret
; --- END TEXT SEGMENT

; --- BEGIN DATA SEGMENT
_s0: .db "Public Key: %d, %d\n", 0
_s1: .db "Private Key: %d, %d\n", 0
_s2: .db "Enter a string: ", 0
_s3: .db "\nEncrypted text: ", 0
_s4: .db "%d ", 0
_s5: .db "\nDecrypted text: ", 0
_s6: .db "\n", 0
_s7: .db "Unexpected format in printf.", 0
_s8: .db "Error: Unknown argument type.\n", 0

_heap_top: .dw _heap
_heap: .db 0
; --- END DATA SEGMENT

.end
