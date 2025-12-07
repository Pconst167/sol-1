; --- FILENAME: programs/primes.c
; --- DATE:     21-11-2025 at 08:25:47
.include "lib/asm/kernel.exp"
.include "lib/asm/bios.exp"

; --- BEGIN TEXT SEGMENT
.org text_org
main:
  mov bp, $FFE0 ;
  mov sp, $FFE0 ; Make space for argc(2 bytes) and for 10 pointers in argv (local variables)
; unsigned int N, i; 
  sub sp, 2
  sub sp, 2
; printf("Find primes up to: "); 
; --- START FUNCTION CALL
  mov b, _s0 ; "Find primes up to: "
  swp b
  push b
  call printf
  add sp, 2
; --- END FUNCTION CALL
; N = scann(); 
  lea d, [bp + -1] ; $N
  push d
; --- START FUNCTION CALL
  call scann
  pop d
  mov [d], b
; printf("\n"); 
; --- START FUNCTION CALL
  mov b, _s1 ; "\n"
  swp b
  push b
  call printf
  add sp, 2
; --- END FUNCTION CALL
; for (i = 2; i <= N; i++) { 
_for1_init:
  lea d, [bp + -3] ; $i
  push d
  mov32 cb, $00000002
  pop d
  mov [d], b
_for1_cond:
  lea d, [bp + -3] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -1] ; $N
  mov b, [d]
  mov c, 0
  cmp a, b
  sleu ; <= (unsigned)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for1_exit
_for1_block:
; if (isPrime(i)) { 
_if2_cond:
; --- START FUNCTION CALL
  lea d, [bp + -3] ; $i
  mov b, [d]
  mov c, 0
  swp b
  push b
  call isPrime
  add sp, 2
; --- END FUNCTION CALL
  cmp b, 0
  je _if2_exit
_if2_TRUE:
; printf("%u\n", i); 
; --- START FUNCTION CALL
  lea d, [bp + -3] ; $i
  mov b, [d]
  mov c, 0
  swp b
  push b
  mov b, _s2 ; "%u\n"
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
  jmp _if2_exit
_if2_exit:
_for1_update:
  lea d, [bp + -3] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -3] ; $i
  mov [d], b
  mov b, a
  jmp _for1_cond
_for1_exit:
; return 0; 
  mov32 cb, $00000000
  leave
  syscall sys_terminate_proc

sqrt:
  enter 0 ; (push bp; mov bp, sp)
; if (n <= 1) { 
_if3_cond:
  lea d, [bp + 5] ; $n
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000001
  cmp a, b
  sleu ; <= (unsigned)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if3_exit
_if3_TRUE:
; return n; 
  lea d, [bp + 5] ; $n
  mov b, [d]
  mov c, 0
  leave
  ret
  jmp _if3_exit
_if3_exit:
; unsigned int x; 
  sub sp, 2
; unsigned int y; 
  sub sp, 2
; x = n; 
  lea d, [bp + -1] ; $x
  push d
  lea d, [bp + 5] ; $n
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
; y = (x + n / x) / 2; 
  lea d, [bp + -3] ; $y
  push d
  lea d, [bp + -1] ; $x
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + 5] ; $n
  mov b, [d]
  mov c, 0
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  lea d, [bp + -1] ; $x
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
  add b, a
  pop a
; --- END TERMS
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
  pop d
  mov [d], b
; while (y < x) { 
_while10_cond:
  lea d, [bp + -3] ; $y
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -1] ; $x
  mov b, [d]
  mov c, 0
  cmp a, b
  slu ; < (unsigned)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _while10_exit
_while10_block:
; x = y; 
  lea d, [bp + -1] ; $x
  push d
  lea d, [bp + -3] ; $y
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
; y = (x + n / x) / 2; 
  lea d, [bp + -3] ; $y
  push d
  lea d, [bp + -1] ; $x
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + 5] ; $n
  mov b, [d]
  mov c, 0
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  lea d, [bp + -1] ; $x
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
  add b, a
  pop a
; --- END TERMS
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
  pop d
  mov [d], b
  jmp _while10_cond
_while10_exit:
; return x; 
  lea d, [bp + -1] ; $x
  mov b, [d]
  mov c, 0
  leave
  ret

primes1:
  enter 0 ; (push bp; mov bp, sp)
; unsigned int n, i, s, count, divides; 
  sub sp, 2
  sub sp, 2
  sub sp, 2
  sub sp, 2
  sub sp, 2
; n = 2; 
  lea d, [bp + -1] ; $n
  push d
  mov32 cb, $00000002
  pop d
  mov [d], b
; while(n < top){ 
_while17_cond:
  lea d, [bp + -1] ; $n
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov d, _top ; $top
  mov b, [d]
  mov c, 0
  cmp a, b
  slu ; < (unsigned)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _while17_exit
_while17_block:
; s = sqrt(n); 
  lea d, [bp + -5] ; $s
  push d
; --- START FUNCTION CALL
  lea d, [bp + -1] ; $n
  mov b, [d]
  mov c, 0
  swp b
  push b
  call sqrt
  add sp, 2
; --- END FUNCTION CALL
  pop d
  mov [d], b
; divides = 0; 
  lea d, [bp + -9] ; $divides
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
; i = 2; 
  lea d, [bp + -3] ; $i
  push d
  mov32 cb, $00000002
  pop d
  mov [d], b
; while(i <= s){ 
_while18_cond:
  lea d, [bp + -3] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -5] ; $s
  mov b, [d]
  mov c, 0
  cmp a, b
  sleu ; <= (unsigned)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _while18_exit
_while18_block:
; if(n % i == 0){ 
_if19_cond:
  lea d, [bp + -1] ; $n
  mov b, [d]
  mov c, 0
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  lea d, [bp + -3] ; $i
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
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if19_exit
_if19_TRUE:
; divides = 1; 
  lea d, [bp + -9] ; $divides
  push d
  mov32 cb, $00000001
  pop d
  mov [d], b
; break; 
  jmp _while18_exit ; while break
  jmp _if19_exit
_if19_exit:
; i = i + 1; 
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
; if(i >= s) break; 
_if22_cond:
  lea d, [bp + -3] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -5] ; $s
  mov b, [d]
  mov c, 0
  cmp a, b
  sgeu ; >= (unsigned)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if22_exit
_if22_TRUE:
; break; 
  jmp _while18_exit ; while break
  jmp _if22_exit
_if22_exit:
  jmp _while18_cond
_while18_exit:
; if(divides == 0){ 
_if23_cond:
  lea d, [bp + -9] ; $divides
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
  je _if23_exit
_if23_TRUE:
; count = count + 1;	 
  lea d, [bp + -7] ; $count
  push d
  lea d, [bp + -7] ; $count
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
; printf("%d\n", n); 
; --- START FUNCTION CALL
  lea d, [bp + -1] ; $n
  mov b, [d]
  mov c, 0
  swp b
  push b
  mov b, _s3 ; "%d\n"
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
  jmp _if23_exit
_if23_exit:
; n = n + 1; 
  lea d, [bp + -1] ; $n
  push d
  lea d, [bp + -1] ; $n
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
  jmp _while17_cond
_while17_exit:
; return; 
  leave
  ret

isPrime:
  enter 0 ; (push bp; mov bp, sp)
; unsigned int i; 
  sub sp, 2
; if (num <= 1) return 0; 
_if24_cond:
  lea d, [bp + 5] ; $num
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000001
  cmp a, b
  sleu ; <= (unsigned)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if24_exit
_if24_TRUE:
; return 0; 
  mov32 cb, $00000000
  leave
  ret
  jmp _if24_exit
_if24_exit:
; for (i = 2; i * i <= num; i++) { 
_for25_init:
  lea d, [bp + -1] ; $i
  push d
  mov32 cb, $00000002
  pop d
  mov [d], b
_for25_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  lea d, [bp + -1] ; $i
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
; --- START RELATIONAL
  push a
  push g
  mov a, b
  mov g, c
  lea d, [bp + 5] ; $num
  mov b, [d]
  mov c, 0
  mov c, 0
  cmp32 ga, cb
  sleu
  pop g
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for25_exit
_for25_block:
; if (num % i == 0) return 0; 
_if28_cond:
  lea d, [bp + 5] ; $num
  mov b, [d]
  mov c, 0
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  lea d, [bp + -1] ; $i
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
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if28_exit
_if28_TRUE:
; return 0; 
  mov32 cb, $00000000
  leave
  ret
  jmp _if28_exit
_if28_exit:
_for25_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  mov b, a
  jmp _for25_cond
_for25_exit:
; return 1; 
  mov32 cb, $00000001
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
_for31_init:
_for31_cond:
_for31_block:
; if(!*format_p) break; 
_if32_cond:
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
  je _if32_else
_if32_TRUE:
; break; 
  jmp _for31_exit ; for break
  jmp _if32_exit
_if32_else:
; if(*format_p == '%'){ 
_if33_cond:
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
  je _if33_else
_if33_TRUE:
; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  dec b
; switch(*format_p){ 
_switch34_expr:
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
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
  cmp bl, $70
  je _switch34_case6
  cmp bl, $63
  je _switch34_case7
  cmp bl, $73
  je _switch34_case8
  jmp _switch34_default
  jmp _switch34_exit
_switch34_case0:
_switch34_case1:
; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  dec b
; if(*format_p == 'd' || *format_p == 'i') 
_if35_cond:
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
  je _if35_else
_if35_TRUE:
; print_signed_long(*(long int*)p); 
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
  jmp _if35_exit
_if35_else:
; if(*format_p == 'u') 
_if36_cond:
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
  je _if36_else
_if36_TRUE:
; print_unsigned_long(*(unsigned long int*)p); 
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
  jmp _if36_exit
_if36_else:
; if(*format_p == 'x') 
_if37_cond:
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
  je _if37_else
_if37_TRUE:
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
  jmp _if37_exit
_if37_else:
; err("Unexpected format in printf."); 
; --- START FUNCTION CALL
  mov b, _s4 ; "Unexpected format in printf."
  swp b
  push b
  call err
  add sp, 2
; --- END FUNCTION CALL
_if37_exit:
_if36_exit:
_if35_exit:
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
  jmp _switch34_exit ; case break
_switch34_case2:
_switch34_case3:
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
  jmp _switch34_exit ; case break
_switch34_case4:
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
  jmp _switch34_exit ; case break
_switch34_case5:
_switch34_case6:
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
  jmp _switch34_exit ; case break
_switch34_case7:
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
  jmp _switch34_exit ; case break
_switch34_case8:
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
  jmp _switch34_exit ; case break
_switch34_default:
; print("Error: Unknown argument type.\n"); 
; --- START FUNCTION CALL
  mov b, _s5 ; "Error: Unknown argument type.\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
_switch34_exit:
  jmp _if33_exit
_if33_else:
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
_if33_exit:
_if32_exit:
; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  dec b
_for31_update:
  jmp _for31_cond
_for31_exit:
  leave
  ret

print_signed_long:
  enter 0 ; (push bp; mov bp, sp)
; char digits[10];  // fits 2,147,483,647 
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
; unsigned long int absval; 
  sub sp, 4
; if (num < 0) { 
_if38_cond:
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
  je _if38_else
_if38_TRUE:
; putchar('-'); 
; --- START FUNCTION CALL
  mov32 cb, $0000002d
  push bl
  call putchar
  add sp, 1
; --- END FUNCTION CALL
; absval = (unsigned long int)(-(num + 1)) + 1; 
  lea d, [bp + -15] ; $absval
  push d
  lea d, [bp + 5] ; $num
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; --- START TERMS
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $00000001
  mov c, 0
  add32 cb, ga
  pop g
  pop a
; --- END TERMS
  mov a, c
  not a
  not b
  add b, 1
  adc a, 0
  mov c, a
  mov bh, 0
  mov c, 0
; --- START TERMS
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $00000001
  mov c, 0
  add32 cb, ga
  pop g
  pop a
; --- END TERMS
  pop d
  mov [d], b
  mov b, c
  mov [d + 2], b
  jmp _if38_exit
_if38_else:
; absval = (unsigned long int)num; 
  lea d, [bp + -15] ; $absval
  push d
  lea d, [bp + 5] ; $num
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
  mov bh, 0
  mov c, 0
  pop d
  mov [d], b
  mov b, c
  mov [d + 2], b
_if38_exit:
; if (absval == 0) { 
_if39_cond:
  lea d, [bp + -15] ; $absval
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
  je _if39_exit
_if39_TRUE:
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
  jmp _if39_exit
_if39_exit:
; while (absval > 0) { 
_while40_cond:
  lea d, [bp + -15] ; $absval
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
  je _while40_exit
_while40_block:
; digits[i++] = '0' + (absval % 10); 
  lea d, [bp + -9] ; $digits
  push a
  push d
  lea d, [bp + -11] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -11] ; $i
  mov [d], b
  mov b, a
  pop d
  add d, b
  pop a
  push d
  mov32 cb, $00000030
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -15] ; $absval
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
; absval = absval / 10; 
  lea d, [bp + -15] ; $absval
  push d
  lea d, [bp + -15] ; $absval
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
  jmp _while40_cond
_while40_exit:
; while (i > 0) { 
_while47_cond:
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
  je _while47_exit
_while47_block:
; putchar(digits[--i]); 
; --- START FUNCTION CALL
  lea d, [bp + -9] ; $digits
  push a
  push d
  lea d, [bp + -11] ; $i
  mov b, [d]
  dec b
  lea d, [bp + -11] ; $i
  mov [d], b
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
  jmp _while47_cond
_while47_exit:
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
; int i = 0; 
  sub sp, 2
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -11] ; $i
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
; --- END LOCAL VAR INITIALIZATION
; if(num == 0){ 
_if48_cond:
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
  je _if48_exit
_if48_TRUE:
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
  jmp _if48_exit
_if48_exit:
; while (num > 0) { 
_while49_cond:
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
  je _while49_exit
_while49_block:
; digits[i++] = '0' + (num % 10); 
  lea d, [bp + -9] ; $digits
  push a
  push d
  lea d, [bp + -11] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -11] ; $i
  mov [d], b
  mov b, a
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
  jmp _while49_cond
_while49_exit:
; while (i > 0) { 
_while56_cond:
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
  je _while56_exit
_while56_block:
; putchar(digits[--i]); 
; --- START FUNCTION CALL
  lea d, [bp + -9] ; $digits
  push a
  push d
  lea d, [bp + -11] ; $i
  mov b, [d]
  dec b
  lea d, [bp + -11] ; $i
  mov [d], b
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
  jmp _while56_cond
_while56_exit:
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
; char digits[5];  // enough for "-32768" 
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
; unsigned int absval; 
  sub sp, 2
; if (num < 0) { 
_if57_cond:
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
  je _if57_else
_if57_TRUE:
; putchar('-'); 
; --- START FUNCTION CALL
  mov32 cb, $0000002d
  push bl
  call putchar
  add sp, 1
; --- END FUNCTION CALL
; absval = (unsigned int)(-(num + 1)) + 1;  // safe for -32768 
  lea d, [bp + -8] ; $absval
  push d
  lea d, [bp + 5] ; $num
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000001
  add b, a
  pop a
; --- END TERMS
  neg b
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000001
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
  jmp _if57_exit
_if57_else:
; absval = (unsigned int)num; 
  lea d, [bp + -8] ; $absval
  push d
  lea d, [bp + 5] ; $num
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
_if57_exit:
; if (absval == 0) { 
_if58_cond:
  lea d, [bp + -8] ; $absval
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
  je _if58_exit
_if58_TRUE:
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
  jmp _if58_exit
_if58_exit:
; while (absval > 0) { 
_while59_cond:
  lea d, [bp + -8] ; $absval
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
  je _while59_exit
_while59_block:
; digits[i++] = '0' + (absval % 10); 
  lea d, [bp + -4] ; $digits
  push a
  push d
  lea d, [bp + -6] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -6] ; $i
  mov [d], b
  mov b, a
  pop d
  add d, b
  pop a
  push d
  mov32 cb, $00000030
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -8] ; $absval
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
; absval = absval / 10; 
  lea d, [bp + -8] ; $absval
  push d
  lea d, [bp + -8] ; $absval
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
  jmp _while59_cond
_while59_exit:
; while (i > 0) { 
_while66_cond:
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
  je _while66_exit
_while66_block:
; putchar(digits[--i]); 
; --- START FUNCTION CALL
  lea d, [bp + -4] ; $digits
  push a
  push d
  lea d, [bp + -6] ; $i
  mov b, [d]
  dec b
  lea d, [bp + -6] ; $i
  mov [d], b
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
  jmp _while66_cond
_while66_exit:
  leave
  ret

print_unsigned:
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
; if(num == 0){ 
_if67_cond:
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
  je _if67_exit
_if67_TRUE:
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
  jmp _if67_exit
_if67_exit:
; while (num > 0) { 
_while68_cond:
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
  je _while68_exit
_while68_block:
; digits[i++] = '0' + (num % 10); 
  lea d, [bp + -4] ; $digits
  push a
  push d
  lea d, [bp + -6] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -6] ; $i
  mov [d], b
  mov b, a
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
  jmp _while68_cond
_while68_exit:
; while (i > 0) { 
_while75_cond:
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
  je _while75_exit
_while75_block:
; putchar(digits[--i]); 
; --- START FUNCTION CALL
  lea d, [bp + -4] ; $digits
  push a
  push d
  lea d, [bp + -6] ; $i
  mov b, [d]
  dec b
  lea d, [bp + -6] ; $i
  mov [d], b
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
  jmp _while75_cond
_while75_exit:
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

scann:
  enter 0 ; (push bp; mov bp, sp)
; int m; 
  sub sp, 2
; --- BEGIN INLINE ASM SEGMENT
  enter 8
  lea d, [bp +- 7]
  call _gets_scann
  call _strlen_scann      ; get string length in C
  dec c
  mov si, d
  mov a, c
  shl a
  mov d, table_power_scann
  add d, a
  mov c, 0
mul_loop_scann:
  lodsb      ; load ASCII to al
  cmp al, 0
  je mul_exit_scann
  sub al, $30    ; make into integer
  mov ah, 0
  mov b, [d]
  mul a, b      ; result in B since it fits in 16bits
  mov a, b
  mov b, c
  add a, b
  mov c, a
  sub d, 2
  jmp mul_loop_scann
mul_exit_scann:
  mov a, c
  leave
  lea d, [bp + -1] ; $m
  mov [d], a
; --- END INLINE ASM SEGMENT
; return m; 
  lea d, [bp + -1] ; $m
  mov b, [d]
  mov c, 0
  leave
  ret
; --- BEGIN INLINE ASM SEGMENT
_strlen_scann:
  push d
  mov c, 0
_strlen_L1_scann:
  cmp byte [d], 0
  je _strlen_ret_scann
  inc d
  inc c
  jmp _strlen_L1_scann
_strlen_ret_scann:
  pop d
  ret
_gets_scann:
  push d
_gets_loop_scann:
  mov al, 1
  syscall sys_io      ; receive in AH
  cmp al, 0        ; check error code (AL)
  je _gets_loop_scann      ; if no char received, retry
  cmp ah, 27
  je _gets_ansi_esc_scann
  cmp ah, $0A        ; LF
  je _gets_end_scann
  cmp ah, $0D        ; CR
  je _gets_end_scann
  cmp ah, $5C        ; '\\'
  je _gets_escape_scann
  cmp ah, $08      ; check for backspace
  je _gets_backspace_scann
  mov al, ah
  mov [d], al
  inc d
  jmp _gets_loop_scann
_gets_backspace_scann:
  dec d
  jmp _gets_loop_scann
_gets_ansi_esc_scann:
  mov al, 1
  syscall sys_io        ; receive in AH without echo
  cmp al, 0          ; check error code (AL)
  je _gets_ansi_esc_scann    ; if no char received, retry
  cmp ah, '['
  jne _gets_loop_scann
_gets_ansi_esc_2_scann:
  mov al, 1
  syscall sys_io          ; receive in AH without echo
  cmp al, 0            ; check error code (AL)
  je _gets_ansi_esc_2_scann  ; if no char received, retry
  cmp ah, 'D'
  je _gets_left_arrow_scann
  cmp ah, 'C'
  je _gets_right_arrow_scann
  jmp _gets_loop_scann
_gets_left_arrow_scann:
  dec d
  jmp _gets_loop_scann
_gets_right_arrow_scann:
  inc d
  jmp _gets_loop_scann
_gets_escape_scann:
  mov al, 1
  syscall sys_io      ; receive in AH
  cmp al, 0        ; check error code (AL)
  je _gets_escape_scann      ; if no char received, retry
  cmp ah, 'n'
  je _gets_LF_scann
  cmp ah, 'r'
  je _gets_CR_scann
  cmp ah, '0'
  je _gets_NULL_scann
  cmp ah, $5C  
  je _gets_slash_scann
  mov al, ah        ; if not a known escape, it is just a normal letter
  mov [d], al
  inc d
  jmp _gets_loop_scann
_gets_slash_scann:
  mov al, $5C
  mov [d], al
  inc d
  jmp _gets_loop_scann
_gets_LF_scann:
  mov al, $0A
  mov [d], al
  inc d
  jmp _gets_loop_scann
_gets_CR_scann:
  mov al, $0D
  mov [d], al
  inc d
  jmp _gets_loop_scann
_gets_NULL_scann:
  mov al, $00
  mov [d], al
  inc d
  jmp _gets_loop_scann
_gets_end_scann:
  mov al, 0
  mov [d], al        ; terminate string
  pop d
  ret
table_power_scann:
.dw 1              ; 1
.dw $A             ; 10
.dw $64            ; 100
.dw $3E8           ; 1000
.dw $2710          ; 10000
.dw $86A0, $1      ; 100000
.dw $4240, $F      ; 1000000
.dw $9680, $98     ; 10000000
.dw $E100, $5F5    ; 100000000
.dw $CA00, $3B9A   ; 1000000000
; --- END INLINE ASM SEGMENT
  leave
  ret
; --- END TEXT SEGMENT

; --- BEGIN DATA SEGMENT
_top: .fill 2, 0
_s0: .db "Find primes up to: ", 0
_s1: .db "\n", 0
_s2: .db "%u\n", 0
_s3: .db "%d\n", 0
_s4: .db "Unexpected format in printf.", 0
_s5: .db "Error: Unknown argument type.\n", 0

_heap_top: .dw _heap
_heap: .db 0
; --- END DATA SEGMENT

.end
