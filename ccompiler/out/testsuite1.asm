; --- FILENAME: ctestsuite/testsuite1.c
; --- DATE:     24-10-2025 at 19:58:22
.include "lib/asm/kernel.exp"
.include "lib/asm/bios.exp"

; --- BEGIN TEXT SEGMENT
.org text_org
main:
  mov bp, $FFE0 ;
  mov sp, $FFE0 ; Make space for argc(2 bytes) and for 10 pointers in argv (local variables)
; int pass[10]; 
  sub sp, 20
; int i; 
  sub sp, 2
; int nbr_tests = 10; 
  sub sp, 2
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -23] ; $nbr_tests
  push d
  mov32 cb, $0000000a
  pop d
  mov [d], b
; --- END LOCAL VAR INITIALIZATION
; for(i = 0; i < nbr_tests; i++){ 
_for1_init:
  lea d, [bp + -21] ; $i
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
_for1_cond:
  lea d, [bp + -21] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -23] ; $nbr_tests
  mov b, [d]
  mov c, 0
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for1_exit
_for1_block:
; pass[i] = -1; 
  lea d, [bp + -19] ; $pass
  push a
  push d
  lea d, [bp + -21] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov32 cb, $ffffffff
  pop d
  mov [d], b
_for1_update:
  lea d, [bp + -21] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -21] ; $i
  mov [d], b
  mov b, a
  jmp _for1_cond
_for1_exit:
; pass[0] = test0(); 
  lea d, [bp + -19] ; $pass
  push a
  push d
  mov32 cb, $00000000
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
; --- START FUNCTION CALL
  call test0
  pop d
  mov [d], b
; pass[1] = test1(); 
  lea d, [bp + -19] ; $pass
  push a
  push d
  mov32 cb, $00000001
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
; --- START FUNCTION CALL
  call test1
  pop d
  mov [d], b
; pass[2] = test2(); 
  lea d, [bp + -19] ; $pass
  push a
  push d
  mov32 cb, $00000002
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
; --- START FUNCTION CALL
  call test2
  pop d
  mov [d], b
; pass[3] = test3(); 
  lea d, [bp + -19] ; $pass
  push a
  push d
  mov32 cb, $00000003
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
; --- START FUNCTION CALL
  call test3
  pop d
  mov [d], b
; pass[4] = test4(); 
  lea d, [bp + -19] ; $pass
  push a
  push d
  mov32 cb, $00000004
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
; --- START FUNCTION CALL
  call test4
  pop d
  mov [d], b
; pass[5] = test5(); 
  lea d, [bp + -19] ; $pass
  push a
  push d
  mov32 cb, $00000005
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
; --- START FUNCTION CALL
  call test5
  pop d
  mov [d], b
; pass[6] = test6(); 
  lea d, [bp + -19] ; $pass
  push a
  push d
  mov32 cb, $00000006
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
; --- START FUNCTION CALL
  call test6
  pop d
  mov [d], b
; pass[7] = test7(); 
  lea d, [bp + -19] ; $pass
  push a
  push d
  mov32 cb, $00000007
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
; --- START FUNCTION CALL
  call test7
  pop d
  mov [d], b
; pass[8] = test8(); 
  lea d, [bp + -19] ; $pass
  push a
  push d
  mov32 cb, $00000008
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
; --- START FUNCTION CALL
  call test8
  pop d
  mov [d], b
; pass[9] = test9(); 
  lea d, [bp + -19] ; $pass
  push a
  push d
  mov32 cb, $00000009
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
; --- START FUNCTION CALL
  call test9
  pop d
  mov [d], b
; for(i = 0; i < nbr_tests; i++) 
_for2_init:
  lea d, [bp + -21] ; $i
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
_for2_cond:
  lea d, [bp + -21] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -23] ; $nbr_tests
  mov b, [d]
  mov c, 0
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for2_exit
_for2_block:
; printf("Test %d, Result: %d\n", i, pass[i]); 
; --- START FUNCTION CALL
  lea d, [bp + -19] ; $pass
  push a
  push d
  lea d, [bp + -21] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  swp b
  push b
  lea d, [bp + -21] ; $i
  mov b, [d]
  mov c, 0
  swp b
  push b
  mov b, _s0 ; "Test %d, Result: %d\n"
  swp b
  push b
  call printf
  add sp, 6
; --- END FUNCTION CALL
_for2_update:
  lea d, [bp + -21] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -21] ; $i
  mov [d], b
  mov b, a
  jmp _for2_cond
_for2_exit:
  syscall sys_terminate_proc

test0:
  enter 0 ; (push bp; mov bp, sp)
; int i; 
  sub sp, 2
; int pass = 1; 
  sub sp, 2
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -3] ; $pass
  push d
  mov32 cb, $00000001
  pop d
  mov [d], b
; --- END LOCAL VAR INITIALIZATION
; for (i = 0; i < 5; i++){ 
_for3_init:
  lea d, [bp + -1] ; $i
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
_for3_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000005
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for3_exit
_for3_block:
; gca1[i] = 'A' + i; 
  mov d, _gca1_data ; $gca1
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  add d, b
  pop a
  push d
  mov32 cb, $00000041
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], bl
; gia1[i] = i; 
  mov d, _gia1_data ; $gia1
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
_for3_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  mov b, a
  jmp _for3_cond
_for3_exit:
; for (i = 0; i < 5; i++){ 
_for4_init:
  lea d, [bp + -1] ; $i
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
_for4_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000005
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for4_exit
_for4_block:
; if(gca1[i] != 'A' + i){ 
_if5_cond:
  mov d, _gca1_data ; $gca1
  push a
  push d
  lea d, [bp + -1] ; $i
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
  mov32 cb, $00000041
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if5_exit
_if5_TRUE:
; pass = 0; 
  lea d, [bp + -3] ; $pass
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
; break; 
  jmp _for4_exit ; for break
  jmp _if5_exit
_if5_exit:
; if(gia1[i] != i){ 
_if6_cond:
  mov d, _gia1_data ; $gia1
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
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if6_exit
_if6_TRUE:
; pass = 0; 
  lea d, [bp + -3] ; $pass
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
; break; 
  jmp _for4_exit ; for break
  jmp _if6_exit
_if6_exit:
_for4_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  mov b, a
  jmp _for4_cond
_for4_exit:
; return pass; 
  lea d, [bp + -3] ; $pass
  mov b, [d]
  mov c, 0
  leave
  ret

test1:
  enter 0 ; (push bp; mov bp, sp)
; int i, j; 
  sub sp, 2
  sub sp, 2
; int pass = 1; 
  sub sp, 2
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -5] ; $pass
  push d
  mov32 cb, $00000001
  pop d
  mov [d], b
; --- END LOCAL VAR INITIALIZATION
; for (i = 0; i < 5; i++){ 
_for7_init:
  lea d, [bp + -1] ; $i
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
_for7_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000005
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for7_exit
_for7_block:
; for (j = 0; j < 5; j++){ 
_for8_init:
  lea d, [bp + -3] ; $j
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
_for8_cond:
  lea d, [bp + -3] ; $j
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000005
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for8_exit
_for8_block:
; gca2[i][j] = 'A' + i + j; 
  mov d, _gca2_data ; $gca2
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 5 ; mov a, 5; mul a, b; add d, b
  push d
  lea d, [bp + -3] ; $j
  mov b, [d]
  mov c, 0
  pop d
  add d, b
  pop a
  push d
  mov32 cb, $00000041
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  add b, a
  mov a, b
  lea d, [bp + -3] ; $j
  mov b, [d]
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], bl
; gia2[i][j] = i * j; 
  mov d, _gia2_data ; $gia2
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 10 ; mov a, 10; mul a, b; add d, b
  push d
  lea d, [bp + -3] ; $j
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  lea d, [bp + -3] ; $j
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
  jz skip_invert_a_10  
  neg a 
skip_invert_a_10:   
  swp b
  test bl, $80  
  swp b
  jz skip_invert_b_10  
  neg b 
skip_invert_b_10:   
  mul a, b ; *
  mov g, a
  mov a, b
  pop bl
  test bl, $80
  jz _same_signs_10
  mov bl, al
  not a
  neg b
  adc a, 0
  mov g, a
  mov a, b
_same_signs_10:
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  pop d
  mov [d], b
_for8_update:
  lea d, [bp + -3] ; $j
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -3] ; $j
  mov [d], b
  mov b, a
  jmp _for8_cond
_for8_exit:
_for7_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  mov b, a
  jmp _for7_cond
_for7_exit:
; for (i = 0; i < 5; i++){ 
_for11_init:
  lea d, [bp + -1] ; $i
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
_for11_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000005
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for11_exit
_for11_block:
; for (j = 0; j < 5; j++){ 
_for12_init:
  lea d, [bp + -3] ; $j
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
_for12_cond:
  lea d, [bp + -3] ; $j
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000005
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for12_exit
_for12_block:
; if(gca2[i][j] != 'A' + i + j){ 
_if13_cond:
  mov d, _gca2_data ; $gca2
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 5 ; mov a, 5; mul a, b; add d, b
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
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000041
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  add b, a
  mov a, b
  lea d, [bp + -3] ; $j
  mov b, [d]
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if13_exit
_if13_TRUE:
; pass = 0; 
  lea d, [bp + -5] ; $pass
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
; break; 
  jmp _for12_exit ; for break
  jmp _if13_exit
_if13_exit:
; if(gia2[i][j] != i * j){ 
_if14_cond:
  mov d, _gia2_data ; $gia2
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 10 ; mov a, 10; mul a, b; add d, b
  push d
  lea d, [bp + -3] ; $j
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
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  lea d, [bp + -3] ; $j
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
  jz skip_invert_a_16  
  neg a 
skip_invert_a_16:   
  swp b
  test bl, $80  
  swp b
  jz skip_invert_b_16  
  neg b 
skip_invert_b_16:   
  mul a, b ; *
  mov g, a
  mov a, b
  pop bl
  test bl, $80
  jz _same_signs_16
  mov bl, al
  not a
  neg b
  adc a, 0
  mov g, a
  mov a, b
_same_signs_16:
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  mov g, 0
  cmp32 ga, cb
  sneq ; !=
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if14_exit
_if14_TRUE:
; pass = 0; 
  lea d, [bp + -5] ; $pass
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
; break; 
  jmp _for12_exit ; for break
  jmp _if14_exit
_if14_exit:
_for12_update:
  lea d, [bp + -3] ; $j
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -3] ; $j
  mov [d], b
  mov b, a
  jmp _for12_cond
_for12_exit:
_for11_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  mov b, a
  jmp _for11_cond
_for11_exit:
; return pass; 
  lea d, [bp + -5] ; $pass
  mov b, [d]
  mov c, 0
  leave
  ret

test2:
  enter 0 ; (push bp; mov bp, sp)
; int i, j; 
  sub sp, 2
  sub sp, 2
; char lca[5]; 
  sub sp, 5
; int lia[5]; 
  sub sp, 10
; int pass = 1; 
  sub sp, 2
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -20] ; $pass
  push d
  mov32 cb, $00000001
  pop d
  mov [d], b
; --- END LOCAL VAR INITIALIZATION
; for (i = 0; i < 5; i++){ 
_for17_init:
  lea d, [bp + -1] ; $i
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
_for17_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000005
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for17_exit
_for17_block:
; lca[i] = 'A' + i + j; 
  lea d, [bp + -8] ; $lca
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  add d, b
  pop a
  push d
  mov32 cb, $00000041
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  add b, a
  mov a, b
  lea d, [bp + -3] ; $j
  mov b, [d]
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], bl
; lia[i] = i * j; 
  lea d, [bp + -18] ; $lia
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  lea d, [bp + -3] ; $j
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
  jz skip_invert_a_19  
  neg a 
skip_invert_a_19:   
  swp b
  test bl, $80  
  swp b
  jz skip_invert_b_19  
  neg b 
skip_invert_b_19:   
  mul a, b ; *
  mov g, a
  mov a, b
  pop bl
  test bl, $80
  jz _same_signs_19
  mov bl, al
  not a
  neg b
  adc a, 0
  mov g, a
  mov a, b
_same_signs_19:
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  pop d
  mov [d], b
_for17_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  mov b, a
  jmp _for17_cond
_for17_exit:
; for (i = 0; i < 5; i++){ 
_for20_init:
  lea d, [bp + -1] ; $i
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
_for20_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000005
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for20_exit
_for20_block:
; if(lca[i] != 'A' + i + j){ 
_if21_cond:
  lea d, [bp + -8] ; $lca
  push a
  push d
  lea d, [bp + -1] ; $i
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
  mov32 cb, $00000041
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  add b, a
  mov a, b
  lea d, [bp + -3] ; $j
  mov b, [d]
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if21_exit
_if21_TRUE:
; pass = 0; 
  lea d, [bp + -20] ; $pass
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
; break; 
  jmp _for20_exit ; for break
  jmp _if21_exit
_if21_exit:
; if(lia[i] != i * j){ 
_if22_cond:
  lea d, [bp + -18] ; $lia
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
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  lea d, [bp + -3] ; $j
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
  mov g, 0
  cmp32 ga, cb
  sneq ; !=
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if22_exit
_if22_TRUE:
; pass = 0; 
  lea d, [bp + -20] ; $pass
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
; break; 
  jmp _for20_exit ; for break
  jmp _if22_exit
_if22_exit:
_for20_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  mov b, a
  jmp _for20_cond
_for20_exit:
; return pass; 
  lea d, [bp + -20] ; $pass
  mov b, [d]
  mov c, 0
  leave
  ret

test3:
  enter 0 ; (push bp; mov bp, sp)
; int i, j; 
  sub sp, 2
  sub sp, 2
; char lca[5][5]; 
  sub sp, 25
; int lia[5][5]; 
  sub sp, 50
; int pass = 1; 
  sub sp, 2
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -80] ; $pass
  push d
  mov32 cb, $00000001
  pop d
  mov [d], b
; --- END LOCAL VAR INITIALIZATION
; for (i = 0; i < 5; i++){ 
_for25_init:
  lea d, [bp + -1] ; $i
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
_for25_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000005
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for25_exit
_for25_block:
; for (j = 0; j < 5; j++){ 
_for26_init:
  lea d, [bp + -3] ; $j
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
_for26_cond:
  lea d, [bp + -3] ; $j
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000005
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for26_exit
_for26_block:
; lca[i][j] = 'A' + i + j; 
  lea d, [bp + -28] ; $lca
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 5 ; mov a, 5; mul a, b; add d, b
  push d
  lea d, [bp + -3] ; $j
  mov b, [d]
  mov c, 0
  pop d
  add d, b
  pop a
  push d
  mov32 cb, $00000041
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  add b, a
  mov a, b
  lea d, [bp + -3] ; $j
  mov b, [d]
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], bl
; lia[i][j] = i * j; 
  lea d, [bp + -78] ; $lia
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 10 ; mov a, 10; mul a, b; add d, b
  push d
  lea d, [bp + -3] ; $j
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  lea d, [bp + -3] ; $j
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
  jz skip_invert_a_28  
  neg a 
skip_invert_a_28:   
  swp b
  test bl, $80  
  swp b
  jz skip_invert_b_28  
  neg b 
skip_invert_b_28:   
  mul a, b ; *
  mov g, a
  mov a, b
  pop bl
  test bl, $80
  jz _same_signs_28
  mov bl, al
  not a
  neg b
  adc a, 0
  mov g, a
  mov a, b
_same_signs_28:
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  pop d
  mov [d], b
_for26_update:
  lea d, [bp + -3] ; $j
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -3] ; $j
  mov [d], b
  mov b, a
  jmp _for26_cond
_for26_exit:
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
; for (i = 0; i < 5; i++){ 
_for29_init:
  lea d, [bp + -1] ; $i
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
_for29_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000005
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for29_exit
_for29_block:
; for (j = 0; j < 5; j++){ 
_for30_init:
  lea d, [bp + -3] ; $j
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
_for30_cond:
  lea d, [bp + -3] ; $j
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000005
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for30_exit
_for30_block:
; if(lca[i][j] != 'A' + i + j){ 
_if31_cond:
  lea d, [bp + -28] ; $lca
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 5 ; mov a, 5; mul a, b; add d, b
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
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000041
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  add b, a
  mov a, b
  lea d, [bp + -3] ; $j
  mov b, [d]
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if31_exit
_if31_TRUE:
; pass = 0; 
  lea d, [bp + -80] ; $pass
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
; break; 
  jmp _for30_exit ; for break
  jmp _if31_exit
_if31_exit:
; if(lia[i][j] != i * j){ 
_if32_cond:
  lea d, [bp + -78] ; $lia
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 10 ; mov a, 10; mul a, b; add d, b
  push d
  lea d, [bp + -3] ; $j
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
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  lea d, [bp + -3] ; $j
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
  mov g, 0
  cmp32 ga, cb
  sneq ; !=
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if32_exit
_if32_TRUE:
; pass = 0; 
  lea d, [bp + -80] ; $pass
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
; break; 
  jmp _for30_exit ; for break
  jmp _if32_exit
_if32_exit:
_for30_update:
  lea d, [bp + -3] ; $j
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -3] ; $j
  mov [d], b
  mov b, a
  jmp _for30_cond
_for30_exit:
_for29_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  mov b, a
  jmp _for29_cond
_for29_exit:
; return pass; 
  lea d, [bp + -80] ; $pass
  mov b, [d]
  mov c, 0
  leave
  ret

test4:
  enter 0 ; (push bp; mov bp, sp)
; int a, b, c; 
  sub sp, 2
  sub sp, 2
  sub sp, 2
; int result; 
  sub sp, 2
; int pass = 1; 
  sub sp, 2
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -9] ; $pass
  push d
  mov32 cb, $00000001
  pop d
  mov [d], b
; --- END LOCAL VAR INITIALIZATION
; result = 1 && 1 && 1; 
  lea d, [bp + -7] ; $result
  push d
  mov32 cb, $00000001
; --- START LOGICAL AND
  push a
  mov a, b
  mov32 cb, $00000001
  sand a, b
  mov a, b
  mov32 cb, $00000001
  sand a, b
  pop a
; --- END LOGICAL AND
  pop d
  mov [d], b
; pass = pass && result == 1; 
  lea d, [bp + -9] ; $pass
  push d
  lea d, [bp + -9] ; $pass
  mov b, [d]
  mov c, 0
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + -7] ; $result
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
  sand a, b
  pop a
; --- END LOGICAL AND
  pop d
  mov [d], b
; result = 1 && 0 && 1; 
  lea d, [bp + -7] ; $result
  push d
  mov32 cb, $00000001
; --- START LOGICAL AND
  push a
  mov a, b
  mov32 cb, $00000000
  sand a, b
  mov a, b
  mov32 cb, $00000001
  sand a, b
  pop a
; --- END LOGICAL AND
  pop d
  mov [d], b
; pass = pass && result == 0; 
  lea d, [bp + -9] ; $pass
  push d
  lea d, [bp + -9] ; $pass
  mov b, [d]
  mov c, 0
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + -7] ; $result
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
  sand a, b
  pop a
; --- END LOGICAL AND
  pop d
  mov [d], b
; result = 1 || 1 || 1; 
  lea d, [bp + -7] ; $result
  push d
  mov32 cb, $00000001
; --- START LOGICAL OR
  push a
  mov a, b
  mov32 cb, $00000001
  sor a, b ; ||
  mov a, b
  mov32 cb, $00000001
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  pop d
  mov [d], b
; pass = pass && result == 1; 
  lea d, [bp + -9] ; $pass
  push d
  lea d, [bp + -9] ; $pass
  mov b, [d]
  mov c, 0
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + -7] ; $result
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
  sand a, b
  pop a
; --- END LOGICAL AND
  pop d
  mov [d], b
; result = 0 || 1 || 0; 
  lea d, [bp + -7] ; $result
  push d
  mov32 cb, $00000000
; --- START LOGICAL OR
  push a
  mov a, b
  mov32 cb, $00000001
  sor a, b ; ||
  mov a, b
  mov32 cb, $00000000
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  pop d
  mov [d], b
; pass = pass && result == 1; 
  lea d, [bp + -9] ; $pass
  push d
  lea d, [bp + -9] ; $pass
  mov b, [d]
  mov c, 0
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + -7] ; $result
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
  sand a, b
  pop a
; --- END LOGICAL AND
  pop d
  mov [d], b
; result = 1 || 0 && 1; 
  lea d, [bp + -7] ; $result
  push d
  mov32 cb, $00000001
; --- START LOGICAL OR
  push a
  mov a, b
  mov32 cb, $00000000
; --- START LOGICAL AND
  push a
  mov a, b
  mov32 cb, $00000001
  sand a, b
  pop a
; --- END LOGICAL AND
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  pop d
  mov [d], b
; pass = pass && result == 1; 
  lea d, [bp + -9] ; $pass
  push d
  lea d, [bp + -9] ; $pass
  mov b, [d]
  mov c, 0
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + -7] ; $result
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
  sand a, b
  pop a
; --- END LOGICAL AND
  pop d
  mov [d], b
; result = 0 || 0 || 0; 
  lea d, [bp + -7] ; $result
  push d
  mov32 cb, $00000000
; --- START LOGICAL OR
  push a
  mov a, b
  mov32 cb, $00000000
  sor a, b ; ||
  mov a, b
  mov32 cb, $00000000
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  pop d
  mov [d], b
; pass = pass && result == 0; 
  lea d, [bp + -9] ; $pass
  push d
  lea d, [bp + -9] ; $pass
  mov b, [d]
  mov c, 0
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + -7] ; $result
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
  sand a, b
  pop a
; --- END LOGICAL AND
  pop d
  mov [d], b
; a = 1; b = 1; c = 1; 
  lea d, [bp + -1] ; $a
  push d
  mov32 cb, $00000001
  pop d
  mov [d], b
; b = 1; c = 1; 
  lea d, [bp + -3] ; $b
  push d
  mov32 cb, $00000001
  pop d
  mov [d], b
; c = 1; 
  lea d, [bp + -5] ; $c
  push d
  mov32 cb, $00000001
  pop d
  mov [d], b
; result = a && b && c; 
  lea d, [bp + -7] ; $result
  push d
  lea d, [bp + -1] ; $a
  mov b, [d]
  mov c, 0
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + -3] ; $b
  mov b, [d]
  mov c, 0
  sand a, b
  mov a, b
  lea d, [bp + -5] ; $c
  mov b, [d]
  mov c, 0
  sand a, b
  pop a
; --- END LOGICAL AND
  pop d
  mov [d], b
; pass = pass && result == 1; 
  lea d, [bp + -9] ; $pass
  push d
  lea d, [bp + -9] ; $pass
  mov b, [d]
  mov c, 0
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + -7] ; $result
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
  sand a, b
  pop a
; --- END LOGICAL AND
  pop d
  mov [d], b
; a = 1; b = 0; c = 1; 
  lea d, [bp + -1] ; $a
  push d
  mov32 cb, $00000001
  pop d
  mov [d], b
; b = 0; c = 1; 
  lea d, [bp + -3] ; $b
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
; c = 1; 
  lea d, [bp + -5] ; $c
  push d
  mov32 cb, $00000001
  pop d
  mov [d], b
; result = a && b && c; 
  lea d, [bp + -7] ; $result
  push d
  lea d, [bp + -1] ; $a
  mov b, [d]
  mov c, 0
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + -3] ; $b
  mov b, [d]
  mov c, 0
  sand a, b
  mov a, b
  lea d, [bp + -5] ; $c
  mov b, [d]
  mov c, 0
  sand a, b
  pop a
; --- END LOGICAL AND
  pop d
  mov [d], b
; pass = pass && result == 0; 
  lea d, [bp + -9] ; $pass
  push d
  lea d, [bp + -9] ; $pass
  mov b, [d]
  mov c, 0
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + -7] ; $result
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
  sand a, b
  pop a
; --- END LOGICAL AND
  pop d
  mov [d], b
; a = 1; b = 1; c = 1; 
  lea d, [bp + -1] ; $a
  push d
  mov32 cb, $00000001
  pop d
  mov [d], b
; b = 1; c = 1; 
  lea d, [bp + -3] ; $b
  push d
  mov32 cb, $00000001
  pop d
  mov [d], b
; c = 1; 
  lea d, [bp + -5] ; $c
  push d
  mov32 cb, $00000001
  pop d
  mov [d], b
; result = a || b || b; 
  lea d, [bp + -7] ; $result
  push d
  lea d, [bp + -1] ; $a
  mov b, [d]
  mov c, 0
; --- START LOGICAL OR
  push a
  mov a, b
  lea d, [bp + -3] ; $b
  mov b, [d]
  mov c, 0
  sor a, b ; ||
  mov a, b
  lea d, [bp + -3] ; $b
  mov b, [d]
  mov c, 0
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  pop d
  mov [d], b
; pass = pass && result == 1; 
  lea d, [bp + -9] ; $pass
  push d
  lea d, [bp + -9] ; $pass
  mov b, [d]
  mov c, 0
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + -7] ; $result
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
  sand a, b
  pop a
; --- END LOGICAL AND
  pop d
  mov [d], b
; a = 0; b = 1; c = 0; 
  lea d, [bp + -1] ; $a
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
; b = 1; c = 0; 
  lea d, [bp + -3] ; $b
  push d
  mov32 cb, $00000001
  pop d
  mov [d], b
; c = 0; 
  lea d, [bp + -5] ; $c
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
; result = a || b || b; 
  lea d, [bp + -7] ; $result
  push d
  lea d, [bp + -1] ; $a
  mov b, [d]
  mov c, 0
; --- START LOGICAL OR
  push a
  mov a, b
  lea d, [bp + -3] ; $b
  mov b, [d]
  mov c, 0
  sor a, b ; ||
  mov a, b
  lea d, [bp + -3] ; $b
  mov b, [d]
  mov c, 0
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  pop d
  mov [d], b
; pass = pass && result == 1; 
  lea d, [bp + -9] ; $pass
  push d
  lea d, [bp + -9] ; $pass
  mov b, [d]
  mov c, 0
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + -7] ; $result
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
  sand a, b
  pop a
; --- END LOGICAL AND
  pop d
  mov [d], b
; a = 1; b = 0; c = 1; 
  lea d, [bp + -1] ; $a
  push d
  mov32 cb, $00000001
  pop d
  mov [d], b
; b = 0; c = 1; 
  lea d, [bp + -3] ; $b
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
; c = 1; 
  lea d, [bp + -5] ; $c
  push d
  mov32 cb, $00000001
  pop d
  mov [d], b
; result = a || b && b; 
  lea d, [bp + -7] ; $result
  push d
  lea d, [bp + -1] ; $a
  mov b, [d]
  mov c, 0
; --- START LOGICAL OR
  push a
  mov a, b
  lea d, [bp + -3] ; $b
  mov b, [d]
  mov c, 0
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + -3] ; $b
  mov b, [d]
  mov c, 0
  sand a, b
  pop a
; --- END LOGICAL AND
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  pop d
  mov [d], b
; pass = pass && result == 1; 
  lea d, [bp + -9] ; $pass
  push d
  lea d, [bp + -9] ; $pass
  mov b, [d]
  mov c, 0
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + -7] ; $result
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
  sand a, b
  pop a
; --- END LOGICAL AND
  pop d
  mov [d], b
; a = 0; b = 0; c = 0; 
  lea d, [bp + -1] ; $a
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
; b = 0; c = 0; 
  lea d, [bp + -3] ; $b
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
; c = 0; 
  lea d, [bp + -5] ; $c
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
; result = a || b || b; 
  lea d, [bp + -7] ; $result
  push d
  lea d, [bp + -1] ; $a
  mov b, [d]
  mov c, 0
; --- START LOGICAL OR
  push a
  mov a, b
  lea d, [bp + -3] ; $b
  mov b, [d]
  mov c, 0
  sor a, b ; ||
  mov a, b
  lea d, [bp + -3] ; $b
  mov b, [d]
  mov c, 0
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  pop d
  mov [d], b
; pass = pass && result == 0; 
  lea d, [bp + -9] ; $pass
  push d
  lea d, [bp + -9] ; $pass
  mov b, [d]
  mov c, 0
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + -7] ; $result
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
  sand a, b
  pop a
; --- END LOGICAL AND
  pop d
  mov [d], b
; return pass; 
  lea d, [bp + -9] ; $pass
  mov b, [d]
  mov c, 0
  leave
  ret

test5:
  enter 0 ; (push bp; mov bp, sp)
; int pass; 
  sub sp, 2
; int i, j, k; 
  sub sp, 2
  sub sp, 2
  sub sp, 2
; int a1[5]; 
  sub sp, 10
; int a2[5]; 
  sub sp, 10
; int a3[5]; 
  sub sp, 10
; i = 1; 
  lea d, [bp + -3] ; $i
  push d
  mov32 cb, $00000001
  pop d
  mov [d], b
; j = 1; 
  lea d, [bp + -5] ; $j
  push d
  mov32 cb, $00000001
  pop d
  mov [d], b
; k = 1; 
  lea d, [bp + -7] ; $k
  push d
  mov32 cb, $00000001
  pop d
  mov [d], b
; a1[3] = 1; 
  lea d, [bp + -17] ; $a1
  push a
  push d
  mov32 cb, $00000003
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov32 cb, $00000001
  pop d
  mov [d], b
; a2[2] = 1; 
  lea d, [bp + -27] ; $a2
  push a
  push d
  mov32 cb, $00000002
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov32 cb, $00000001
  pop d
  mov [d], b
; a3[a2[a1[i + j + (k && 1) + (1 && 0)] + (i && 1)] + (0 || j)] = 56; 
  lea d, [bp + -37] ; $a3
  push a
  push d
  lea d, [bp + -27] ; $a2
  push a
  push d
  lea d, [bp + -17] ; $a1
  push a
  push d
  lea d, [bp + -3] ; $i
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -5] ; $j
  mov b, [d]
  mov c, 0
  add b, a
  mov a, b
  lea d, [bp + -7] ; $k
  mov b, [d]
  mov c, 0
; --- START LOGICAL AND
  push a
  mov a, b
  mov32 cb, $00000001
  sand a, b
  pop a
; --- END LOGICAL AND
  add b, a
  mov a, b
  mov32 cb, $00000001
; --- START LOGICAL AND
  push a
  mov a, b
  mov32 cb, $00000000
  sand a, b
  pop a
; --- END LOGICAL AND
  add b, a
  pop a
; --- END TERMS
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -3] ; $i
  mov b, [d]
  mov c, 0
; --- START LOGICAL AND
  push a
  mov a, b
  mov32 cb, $00000001
  sand a, b
  pop a
; --- END LOGICAL AND
  add b, a
  pop a
; --- END TERMS
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000000
; --- START LOGICAL OR
  push a
  mov a, b
  lea d, [bp + -5] ; $j
  mov b, [d]
  mov c, 0
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  add b, a
  pop a
; --- END TERMS
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov32 cb, $00000038
  pop d
  mov [d], b
; pass = a3[2] == 56; 
  lea d, [bp + -1] ; $pass
  push d
  lea d, [bp + -37] ; $a3
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
  mov32 cb, $00000038
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  pop d
  mov [d], b
; return pass; 
  lea d, [bp + -1] ; $pass
  mov b, [d]
  mov c, 0
  leave
  ret

test6:
  enter 0 ; (push bp; mov bp, sp)
; int pass = 1; 
  sub sp, 2
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -1] ; $pass
  push d
  mov32 cb, $00000001
  pop d
  mov [d], b
; --- END LOCAL VAR INITIALIZATION
; int i, j, k; 
  sub sp, 2
  sub sp, 2
  sub sp, 2
; test6_struct.c1 = 'A'; 
  mov d, _test6_struct_data ; $test6_struct
  add d, 0
  push d
  mov32 cb, $00000041
  pop d
  mov [d], bl
; pass = pass && test6_struct.c1 == 'A'; 
  lea d, [bp + -1] ; $pass
  push d
  lea d, [bp + -1] ; $pass
  mov b, [d]
  mov c, 0
; --- START LOGICAL AND
  push a
  mov a, b
  mov d, _test6_struct_data ; $test6_struct
  add d, 0
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000041
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  pop d
  mov [d], b
; for(i = 0; i < 5; i++){ 
_for35_init:
  lea d, [bp + -3] ; $i
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
_for35_cond:
  lea d, [bp + -3] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000005
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for35_exit
_for35_block:
; test6_struct.ca[i] = i; 
  mov d, _test6_struct_data ; $test6_struct
  add d, 1
  push a
  push d
  lea d, [bp + -3] ; $i
  mov b, [d]
  mov c, 0
  pop d
  add d, b
  pop a
  push d
  lea d, [bp + -3] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mov [d], bl
; pass = pass && test6_struct.ca[i] == i; 
  lea d, [bp + -1] ; $pass
  push d
  lea d, [bp + -1] ; $pass
  mov b, [d]
  mov c, 0
; --- START LOGICAL AND
  push a
  mov a, b
  mov d, _test6_struct_data ; $test6_struct
  add d, 1
  push a
  push d
  lea d, [bp + -3] ; $i
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
  lea d, [bp + -3] ; $i
  mov b, [d]
  mov c, 0
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  pop d
  mov [d], b
_for35_update:
  lea d, [bp + -3] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -3] ; $i
  mov [d], b
  mov b, a
  jmp _for35_cond
_for35_exit:
; test6_struct.i1 = 55555; 
  mov d, _test6_struct_data ; $test6_struct
  add d, 6
  push d
  mov32 cb, $0000d903
  pop d
  mov [d], b
; pass = pass && test6_struct.i1 == 55555; 
  lea d, [bp + -1] ; $pass
  push d
  lea d, [bp + -1] ; $pass
  mov b, [d]
  mov c, 0
; --- START LOGICAL AND
  push a
  mov a, b
  mov d, _test6_struct_data ; $test6_struct
  add d, 6
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $0000d903
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  pop d
  mov [d], b
; for(i = 0; i < 5; i++){ 
_for36_init:
  lea d, [bp + -3] ; $i
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
_for36_cond:
  lea d, [bp + -3] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000005
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for36_exit
_for36_block:
; test6_struct.ia[i] = i; 
  mov d, _test6_struct_data ; $test6_struct
  add d, 8
  push a
  push d
  lea d, [bp + -3] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  lea d, [bp + -3] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
; pass = pass && test6_struct.ia[i] == i; 
  lea d, [bp + -1] ; $pass
  push d
  lea d, [bp + -1] ; $pass
  mov b, [d]
  mov c, 0
; --- START LOGICAL AND
  push a
  mov a, b
  mov d, _test6_struct_data ; $test6_struct
  add d, 8
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
  lea d, [bp + -3] ; $i
  mov b, [d]
  mov c, 0
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  pop d
  mov [d], b
_for36_update:
  lea d, [bp + -3] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -3] ; $i
  mov [d], b
  mov b, a
  jmp _for36_cond
_for36_exit:
; return pass; 
  lea d, [bp + -1] ; $pass
  mov b, [d]
  mov c, 0
  leave
  ret

test7:
  enter 0 ; (push bp; mov bp, sp)
; int pass = 1; 
  sub sp, 2
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -1] ; $pass
  push d
  mov32 cb, $00000001
  pop d
  mov [d], b
; --- END LOCAL VAR INITIALIZATION
; int i, j, k; 
  sub sp, 2
  sub sp, 2
  sub sp, 2
; test7_struct.test7_substruct.c1 = 'A'; 
  mov d, _test7_struct_data ; $test7_struct
  add d, 6
  add d, 0
  push d
  mov32 cb, $00000041
  pop d
  mov [d], bl
; pass = pass && test7_struct.test7_substruct.c1 == 'A'; 
  lea d, [bp + -1] ; $pass
  push d
  lea d, [bp + -1] ; $pass
  mov b, [d]
  mov c, 0
; --- START LOGICAL AND
  push a
  mov a, b
  mov d, _test7_struct_data ; $test7_struct
  add d, 6
  add d, 0
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000041
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  pop d
  mov [d], b
; for(i = 0; i < 5; i++){ 
_for37_init:
  lea d, [bp + -3] ; $i
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
_for37_cond:
  lea d, [bp + -3] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000005
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for37_exit
_for37_block:
; test7_struct.test7_substruct.ca[i] = i; 
  mov d, _test7_struct_data ; $test7_struct
  add d, 6
  add d, 1
  push a
  push d
  lea d, [bp + -3] ; $i
  mov b, [d]
  mov c, 0
  pop d
  add d, b
  pop a
  push d
  lea d, [bp + -3] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mov [d], bl
; pass = pass && test7_struct.test7_substruct.ca[i] == i; 
  lea d, [bp + -1] ; $pass
  push d
  lea d, [bp + -1] ; $pass
  mov b, [d]
  mov c, 0
; --- START LOGICAL AND
  push a
  mov a, b
  mov d, _test7_struct_data ; $test7_struct
  add d, 6
  add d, 1
  push a
  push d
  lea d, [bp + -3] ; $i
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
  lea d, [bp + -3] ; $i
  mov b, [d]
  mov c, 0
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  pop d
  mov [d], b
_for37_update:
  lea d, [bp + -3] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -3] ; $i
  mov [d], b
  mov b, a
  jmp _for37_cond
_for37_exit:
; test7_struct.test7_substruct.i1 = 55555; 
  mov d, _test7_struct_data ; $test7_struct
  add d, 6
  add d, 6
  push d
  mov32 cb, $0000d903
  pop d
  mov [d], b
; pass = pass && test7_struct.test7_substruct.i1 == 55555; 
  lea d, [bp + -1] ; $pass
  push d
  lea d, [bp + -1] ; $pass
  mov b, [d]
  mov c, 0
; --- START LOGICAL AND
  push a
  mov a, b
  mov d, _test7_struct_data ; $test7_struct
  add d, 6
  add d, 6
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $0000d903
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  pop d
  mov [d], b
; for(i = 0; i < 5; i++){ 
_for38_init:
  lea d, [bp + -3] ; $i
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
_for38_cond:
  lea d, [bp + -3] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000005
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for38_exit
_for38_block:
; test7_struct.test7_substruct.ia[i] = i; 
  mov d, _test7_struct_data ; $test7_struct
  add d, 6
  add d, 8
  push a
  push d
  lea d, [bp + -3] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  lea d, [bp + -3] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
; pass = pass && test7_struct.test7_substruct.ia[i] == i; 
  lea d, [bp + -1] ; $pass
  push d
  lea d, [bp + -1] ; $pass
  mov b, [d]
  mov c, 0
; --- START LOGICAL AND
  push a
  mov a, b
  mov d, _test7_struct_data ; $test7_struct
  add d, 6
  add d, 8
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
  lea d, [bp + -3] ; $i
  mov b, [d]
  mov c, 0
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  pop d
  mov [d], b
_for38_update:
  lea d, [bp + -3] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -3] ; $i
  mov [d], b
  mov b, a
  jmp _for38_cond
_for38_exit:
; return pass; 
  lea d, [bp + -1] ; $pass
  mov b, [d]
  mov c, 0
  leave
  ret

test8:
  enter 0 ; (push bp; mov bp, sp)
; int pass = 1; 
  sub sp, 2
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -1] ; $pass
  push d
  mov32 cb, $00000001
  pop d
  mov [d], b
; --- END LOCAL VAR INITIALIZATION
; int i, j, k; 
  sub sp, 2
  sub sp, 2
  sub sp, 2
; struct t_test8_struct test8_struct; 
  sub sp, 18
; test8_struct.c1 = 'A'; 
  lea d, [bp + -25] ; $test8_struct
  add d, 0
  push d
  mov32 cb, $00000041
  pop d
  mov [d], bl
; pass = pass && test8_struct.c1 == 'A'; 
  lea d, [bp + -1] ; $pass
  push d
  lea d, [bp + -1] ; $pass
  mov b, [d]
  mov c, 0
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + -25] ; $test8_struct
  add d, 0
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000041
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  pop d
  mov [d], b
; for(i = 0; i < 5; i++){ 
_for39_init:
  lea d, [bp + -3] ; $i
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
_for39_cond:
  lea d, [bp + -3] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000005
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for39_exit
_for39_block:
; test8_struct.ca[i] = i; 
  lea d, [bp + -25] ; $test8_struct
  add d, 1
  push a
  push d
  lea d, [bp + -3] ; $i
  mov b, [d]
  mov c, 0
  pop d
  add d, b
  pop a
  push d
  lea d, [bp + -3] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mov [d], bl
; pass = pass && test8_struct.ca[i] == i; 
  lea d, [bp + -1] ; $pass
  push d
  lea d, [bp + -1] ; $pass
  mov b, [d]
  mov c, 0
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + -25] ; $test8_struct
  add d, 1
  push a
  push d
  lea d, [bp + -3] ; $i
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
  lea d, [bp + -3] ; $i
  mov b, [d]
  mov c, 0
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  pop d
  mov [d], b
_for39_update:
  lea d, [bp + -3] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -3] ; $i
  mov [d], b
  mov b, a
  jmp _for39_cond
_for39_exit:
; test8_struct.i1 = 55555; 
  lea d, [bp + -25] ; $test8_struct
  add d, 6
  push d
  mov32 cb, $0000d903
  pop d
  mov [d], b
; pass = pass && test8_struct.i1 == 55555; 
  lea d, [bp + -1] ; $pass
  push d
  lea d, [bp + -1] ; $pass
  mov b, [d]
  mov c, 0
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + -25] ; $test8_struct
  add d, 6
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $0000d903
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  pop d
  mov [d], b
; for(i = 0; i < 5; i++){ 
_for40_init:
  lea d, [bp + -3] ; $i
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
_for40_cond:
  lea d, [bp + -3] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000005
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for40_exit
_for40_block:
; test8_struct.ia[i] = i; 
  lea d, [bp + -25] ; $test8_struct
  add d, 8
  push a
  push d
  lea d, [bp + -3] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  lea d, [bp + -3] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
; pass = pass && test8_struct.ia[i] == i; 
  lea d, [bp + -1] ; $pass
  push d
  lea d, [bp + -1] ; $pass
  mov b, [d]
  mov c, 0
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + -25] ; $test8_struct
  add d, 8
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
  lea d, [bp + -3] ; $i
  mov b, [d]
  mov c, 0
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  pop d
  mov [d], b
_for40_update:
  lea d, [bp + -3] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -3] ; $i
  mov [d], b
  mov b, a
  jmp _for40_cond
_for40_exit:
; return pass; 
  lea d, [bp + -1] ; $pass
  mov b, [d]
  mov c, 0
  leave
  ret

test9:
  enter 0 ; (push bp; mov bp, sp)
; int pass = 1; 
  sub sp, 2
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -1] ; $pass
  push d
  mov32 cb, $00000001
  pop d
  mov [d], b
; --- END LOCAL VAR INITIALIZATION
; int i, j, k; 
  sub sp, 2
  sub sp, 2
  sub sp, 2
; struct t_test9_struct test9_struct; 
  sub sp, 36
; test9_struct.test9_substruct.c1 = 'A'; 
  lea d, [bp + -43] ; $test9_struct
  add d, 6
  add d, 0
  push d
  mov32 cb, $00000041
  pop d
  mov [d], bl
; pass = pass && test9_struct.test9_substruct.c1 == 'A'; 
  lea d, [bp + -1] ; $pass
  push d
  lea d, [bp + -1] ; $pass
  mov b, [d]
  mov c, 0
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + -43] ; $test9_struct
  add d, 6
  add d, 0
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000041
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  pop d
  mov [d], b
; for(i = 0; i < 5; i++){ 
_for41_init:
  lea d, [bp + -3] ; $i
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
_for41_cond:
  lea d, [bp + -3] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000005
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for41_exit
_for41_block:
; test9_struct.test9_substruct.ca[i] = i; 
  lea d, [bp + -43] ; $test9_struct
  add d, 6
  add d, 1
  push a
  push d
  lea d, [bp + -3] ; $i
  mov b, [d]
  mov c, 0
  pop d
  add d, b
  pop a
  push d
  lea d, [bp + -3] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mov [d], bl
; pass = pass && test9_struct.test9_substruct.ca[i] == i; 
  lea d, [bp + -1] ; $pass
  push d
  lea d, [bp + -1] ; $pass
  mov b, [d]
  mov c, 0
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + -43] ; $test9_struct
  add d, 6
  add d, 1
  push a
  push d
  lea d, [bp + -3] ; $i
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
  lea d, [bp + -3] ; $i
  mov b, [d]
  mov c, 0
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  pop d
  mov [d], b
_for41_update:
  lea d, [bp + -3] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -3] ; $i
  mov [d], b
  mov b, a
  jmp _for41_cond
_for41_exit:
; test9_struct.test9_substruct.i1 = 55555; 
  lea d, [bp + -43] ; $test9_struct
  add d, 6
  add d, 6
  push d
  mov32 cb, $0000d903
  pop d
  mov [d], b
; pass = pass && test9_struct.test9_substruct.i1 == 55555; 
  lea d, [bp + -1] ; $pass
  push d
  lea d, [bp + -1] ; $pass
  mov b, [d]
  mov c, 0
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + -43] ; $test9_struct
  add d, 6
  add d, 6
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $0000d903
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  pop d
  mov [d], b
; for(i = 0; i < 5; i++){ 
_for42_init:
  lea d, [bp + -3] ; $i
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
_for42_cond:
  lea d, [bp + -3] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000005
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for42_exit
_for42_block:
; test9_struct.test9_substruct.ia[i] = i; 
  lea d, [bp + -43] ; $test9_struct
  add d, 6
  add d, 8
  push a
  push d
  lea d, [bp + -3] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  lea d, [bp + -3] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
; pass = pass && test9_struct.test9_substruct.ia[i] == i; 
  lea d, [bp + -1] ; $pass
  push d
  lea d, [bp + -1] ; $pass
  mov b, [d]
  mov c, 0
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + -43] ; $test9_struct
  add d, 6
  add d, 8
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
  lea d, [bp + -3] ; $i
  mov b, [d]
  mov c, 0
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  pop d
  mov [d], b
_for42_update:
  lea d, [bp + -3] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -3] ; $i
  mov [d], b
  mov b, a
  jmp _for42_cond
_for42_exit:
; return pass; 
  lea d, [bp + -1] ; $pass
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
_for43_init:
_for43_cond:
_for43_block:
; if(!*format_p) break; 
_if44_cond:
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
  je _if44_else
_if44_TRUE:
; break; 
  jmp _for43_exit ; for break
  jmp _if44_exit
_if44_else:
; if(*format_p == '%'){ 
_if45_cond:
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
  je _if45_else
_if45_TRUE:
; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  dec b
; switch(*format_p){ 
_switch46_expr:
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
_switch46_comparisons:
  cmp bl, $6c
  je _switch46_case0
  cmp bl, $4c
  je _switch46_case1
  cmp bl, $64
  je _switch46_case2
  cmp bl, $69
  je _switch46_case3
  cmp bl, $75
  je _switch46_case4
  cmp bl, $78
  je _switch46_case5
  cmp bl, $70
  je _switch46_case6
  cmp bl, $63
  je _switch46_case7
  cmp bl, $73
  je _switch46_case8
  jmp _switch46_default
  jmp _switch46_exit
_switch46_case0:
_switch46_case1:
; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  dec b
; if(*format_p == 'd' || *format_p == 'i') 
_if47_cond:
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
  je _if47_else
_if47_TRUE:
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
  jmp _if47_exit
_if47_else:
; if(*format_p == 'u') 
_if48_cond:
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
  je _if48_else
_if48_TRUE:
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
  jmp _if48_exit
_if48_else:
; if(*format_p == 'x') 
_if49_cond:
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
  je _if49_else
_if49_TRUE:
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
  jmp _if49_exit
_if49_else:
; err("Unexpected format in printf."); 
; --- START FUNCTION CALL
  mov b, _s1 ; "Unexpected format in printf."
  swp b
  push b
  call err
  add sp, 2
; --- END FUNCTION CALL
_if49_exit:
_if48_exit:
_if47_exit:
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
  jmp _switch46_exit ; case break
_switch46_case2:
_switch46_case3:
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
  jmp _switch46_exit ; case break
_switch46_case4:
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
  jmp _switch46_exit ; case break
_switch46_case5:
_switch46_case6:
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
  jmp _switch46_exit ; case break
_switch46_case7:
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
  jmp _switch46_exit ; case break
_switch46_case8:
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
  jmp _switch46_exit ; case break
_switch46_default:
; print("Error: Unknown argument type.\n"); 
; --- START FUNCTION CALL
  mov b, _s2 ; "Error: Unknown argument type.\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
_switch46_exit:
  jmp _if45_exit
_if45_else:
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
_if45_exit:
_if44_exit:
; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  dec b
_for43_update:
  jmp _for43_cond
_for43_exit:
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
_if50_cond:
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
  je _if50_else
_if50_TRUE:
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
  jmp _if50_exit
_if50_else:
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
_if50_exit:
; if (absval == 0) { 
_if51_cond:
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
  je _if51_exit
_if51_TRUE:
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
  jmp _if51_exit
_if51_exit:
; while (absval > 0) { 
_while52_cond:
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
  je _while52_exit
_while52_block:
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
  jmp _while52_cond
_while52_exit:
; while (i > 0) { 
_while59_cond:
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
  je _while59_exit
_while59_block:
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
  jmp _while59_cond
_while59_exit:
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
_if60_cond:
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
  je _if60_exit
_if60_TRUE:
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
  jmp _if60_exit
_if60_exit:
; while (num > 0) { 
_while61_cond:
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
  je _while61_exit
_while61_block:
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
  jmp _while61_cond
_while61_exit:
; while (i > 0) { 
_while68_cond:
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
  je _while68_exit
_while68_block:
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
  jmp _while68_cond
_while68_exit:
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
_if69_cond:
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
  je _if69_else
_if69_TRUE:
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
  jmp _if69_exit
_if69_else:
; absval = (unsigned int)num; 
  lea d, [bp + -8] ; $absval
  push d
  lea d, [bp + 5] ; $num
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
_if69_exit:
; if (absval == 0) { 
_if70_cond:
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
  je _if70_exit
_if70_TRUE:
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
  jmp _if70_exit
_if70_exit:
; while (absval > 0) { 
_while71_cond:
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
  je _while71_exit
_while71_block:
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
  jmp _while71_cond
_while71_exit:
; while (i > 0) { 
_while78_cond:
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
  je _while78_exit
_while78_block:
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
  jmp _while78_cond
_while78_exit:
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
_if79_cond:
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
  je _if79_exit
_if79_TRUE:
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
  jmp _if79_exit
_if79_exit:
; while (num > 0) { 
_while80_cond:
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
  je _while80_exit
_while80_block:
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
  jmp _while80_cond
_while80_exit:
; while (i > 0) { 
_while87_cond:
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
  je _while87_exit
_while87_block:
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
  jmp _while87_cond
_while87_exit:
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
; --- END TEXT SEGMENT

; --- BEGIN DATA SEGMENT
_gca1_data: .db $30,$31,$32,$33,$34,
_gia1_data: .dw $0000,$0001,$0002,$0003,$0004,
_gca2_data: .fill 25, 0
_gia2_data: .fill 50, 0
_test6_struct_data: .fill 18, 0
_test7_struct_data: .fill 36, 0
_s0: .db "Test %d, Result: %d\n", 0
_s1: .db "Unexpected format in printf.", 0
_s2: .db "Error: Unknown argument type.\n", 0

_heap_top: .dw _heap
_heap: .db 0
; --- END DATA SEGMENT

.end
