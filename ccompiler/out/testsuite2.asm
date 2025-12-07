; --- FILENAME: ctestsuite/testsuite2.c
; --- DATE:     24-10-2025 at 20:02:22
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
; pass[3] = test3(st1); 
  lea d, [bp + -19] ; $pass
  push a
  push d
  mov32 cb, $00000003
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
; --- START FUNCTION CALL
  mov d, _st1_data ; $st1
  mov b, d
  mov c, 0
  sub sp, 13
  mov si, b
  lea d, [sp + 1]
  mov di, d
  mov c, 13
  rep movsb
  call test3
  add sp, 13
; --- END FUNCTION CALL
  pop d
  mov [d], b
; for(i = 0; i < nbr_tests; i++){ 
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
; int result; 
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
; char c; 
  sub sp, 1
; int i; 
  sub sp, 2
; char ca[5]; 
  sub sp, 5
; int ia[5]; 
  sub sp, 10
; c = 'A'; 
  lea d, [bp + -4] ; $c
  push d
  mov32 cb, $00000041
  pop d
  mov [d], bl
; i = 55; 
  lea d, [bp + -6] ; $i
  push d
  mov32 cb, $00000037
  pop d
  mov [d], b
; ca[0] = 'A'; 
  lea d, [bp + -11] ; $ca
  push a
  push d
  mov32 cb, $00000000
  pop d
  add d, b
  pop a
  push d
  mov32 cb, $00000041
  pop d
  mov [d], bl
; ca[1] = 'B'; 
  lea d, [bp + -11] ; $ca
  push a
  push d
  mov32 cb, $00000001
  pop d
  add d, b
  pop a
  push d
  mov32 cb, $00000042
  pop d
  mov [d], bl
; ca[2] = 'C'; 
  lea d, [bp + -11] ; $ca
  push a
  push d
  mov32 cb, $00000002
  pop d
  add d, b
  pop a
  push d
  mov32 cb, $00000043
  pop d
  mov [d], bl
; ca[3] = 'D'; 
  lea d, [bp + -11] ; $ca
  push a
  push d
  mov32 cb, $00000003
  pop d
  add d, b
  pop a
  push d
  mov32 cb, $00000044
  pop d
  mov [d], bl
; ca[4] = 'E'; 
  lea d, [bp + -11] ; $ca
  push a
  push d
  mov32 cb, $00000004
  pop d
  add d, b
  pop a
  push d
  mov32 cb, $00000045
  pop d
  mov [d], bl
; ia[0] = 0; 
  lea d, [bp + -21] ; $ia
  push a
  push d
  mov32 cb, $00000000
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
; ia[1] = 1; 
  lea d, [bp + -21] ; $ia
  push a
  push d
  mov32 cb, $00000001
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov32 cb, $00000001
  pop d
  mov [d], b
; ia[2] = 2; 
  lea d, [bp + -21] ; $ia
  push a
  push d
  mov32 cb, $00000002
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov32 cb, $00000002
  pop d
  mov [d], b
; ia[3] = 3; 
  lea d, [bp + -21] ; $ia
  push a
  push d
  mov32 cb, $00000003
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov32 cb, $00000003
  pop d
  mov [d], b
; ia[4] = 4; 
  lea d, [bp + -21] ; $ia
  push a
  push d
  mov32 cb, $00000004
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov32 cb, $00000004
  pop d
  mov [d], b
; pass = pass && test0_subTest0(c, i, ca, ia); 
  lea d, [bp + -3] ; $pass
  push d
  lea d, [bp + -3] ; $pass
  mov b, [d]
  mov c, 0
; --- START LOGICAL AND
  push a
  mov a, b
; --- START FUNCTION CALL
  lea d, [bp + -21] ; $ia
  mov b, d
  mov c, 0
  swp b
  push b
  lea d, [bp + -11] ; $ca
  mov b, d
  mov c, 0
  swp b
  push b
  lea d, [bp + -6] ; $i
  mov b, [d]
  mov c, 0
  swp b
  push b
  lea d, [bp + -4] ; $c
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push bl
  call test0_subTest0
  add sp, 7
; --- END FUNCTION CALL
  sand a, b
  pop a
; --- END LOGICAL AND
  pop d
  mov [d], b
; return pass; 
  lea d, [bp + -3] ; $pass
  mov b, [d]
  mov c, 0
  leave
  ret

test0_subTest0:
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
; pass = pass && c == 'A'; 
  lea d, [bp + -1] ; $pass
  push d
  lea d, [bp + -1] ; $pass
  mov b, [d]
  mov c, 0
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
; pass = pass && i == 55; 
  lea d, [bp + -1] ; $pass
  push d
  lea d, [bp + -1] ; $pass
  mov b, [d]
  mov c, 0
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + 6] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000037
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  pop d
  mov [d], b
; pass = pass && ca[0] == 'A'; 
  lea d, [bp + -1] ; $pass
  push d
  lea d, [bp + -1] ; $pass
  mov b, [d]
  mov c, 0
; --- START LOGICAL AND
  push a
  mov a, b
  mov b, [bp + 8] ; $ca
  mov d, b
  push a
  push d
  mov32 cb, $00000000
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
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  pop d
  mov [d], b
; pass = pass && ca[1] == 'B'; 
  lea d, [bp + -1] ; $pass
  push d
  lea d, [bp + -1] ; $pass
  mov b, [d]
  mov c, 0
; --- START LOGICAL AND
  push a
  mov a, b
  mov b, [bp + 8] ; $ca
  mov d, b
  push a
  push d
  mov32 cb, $00000001
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000042
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  pop d
  mov [d], b
; pass = pass && ca[2] == 'C'; 
  lea d, [bp + -1] ; $pass
  push d
  lea d, [bp + -1] ; $pass
  mov b, [d]
  mov c, 0
; --- START LOGICAL AND
  push a
  mov a, b
  mov b, [bp + 8] ; $ca
  mov d, b
  push a
  push d
  mov32 cb, $00000002
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000043
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  pop d
  mov [d], b
; pass = pass && ca[3] == 'D'; 
  lea d, [bp + -1] ; $pass
  push d
  lea d, [bp + -1] ; $pass
  mov b, [d]
  mov c, 0
; --- START LOGICAL AND
  push a
  mov a, b
  mov b, [bp + 8] ; $ca
  mov d, b
  push a
  push d
  mov32 cb, $00000003
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000044
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  pop d
  mov [d], b
; pass = pass && ca[4] == 'E'; 
  lea d, [bp + -1] ; $pass
  push d
  lea d, [bp + -1] ; $pass
  mov b, [d]
  mov c, 0
; --- START LOGICAL AND
  push a
  mov a, b
  mov b, [bp + 8] ; $ca
  mov d, b
  push a
  push d
  mov32 cb, $00000004
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000045
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  pop d
  mov [d], b
; pass = pass && ia[0] == 0; 
  lea d, [bp + -1] ; $pass
  push d
  lea d, [bp + -1] ; $pass
  mov b, [d]
  mov c, 0
; --- START LOGICAL AND
  push a
  mov a, b
  mov b, [bp + 10] ; $ia
  mov d, b
  push a
  push d
  mov32 cb, $00000000
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
  seq ; ==
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  pop d
  mov [d], b
; pass = pass && ia[1] == 1; 
  lea d, [bp + -1] ; $pass
  push d
  lea d, [bp + -1] ; $pass
  mov b, [d]
  mov c, 0
; --- START LOGICAL AND
  push a
  mov a, b
  mov b, [bp + 10] ; $ia
  mov d, b
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
; pass = pass && ia[2] == 2; 
  lea d, [bp + -1] ; $pass
  push d
  lea d, [bp + -1] ; $pass
  mov b, [d]
  mov c, 0
; --- START LOGICAL AND
  push a
  mov a, b
  mov b, [bp + 10] ; $ia
  mov d, b
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
  mov32 cb, $00000002
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  pop d
  mov [d], b
; pass = pass && ia[3] == 3; 
  lea d, [bp + -1] ; $pass
  push d
  lea d, [bp + -1] ; $pass
  mov b, [d]
  mov c, 0
; --- START LOGICAL AND
  push a
  mov a, b
  mov b, [bp + 10] ; $ia
  mov d, b
  push a
  push d
  mov32 cb, $00000003
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
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
  sand a, b
  pop a
; --- END LOGICAL AND
  pop d
  mov [d], b
; pass = pass && ia[4] == 4; 
  lea d, [bp + -1] ; $pass
  push d
  lea d, [bp + -1] ; $pass
  mov b, [d]
  mov c, 0
; --- START LOGICAL AND
  push a
  mov a, b
  mov b, [bp + 10] ; $ia
  mov d, b
  push a
  push d
  mov32 cb, $00000004
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
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
  sand a, b
  pop a
; --- END LOGICAL AND
  pop d
  mov [d], b
; return pass; 
  lea d, [bp + -1] ; $pass
  mov b, [d]
  mov c, 0
  leave
  ret

test1:
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
; char ca[5]; 
  sub sp, 5
; char *p; 
  sub sp, 2
; p = ca; 
  lea d, [bp + -8] ; $p
  push d
  lea d, [bp + -6] ; $ca
  mov b, d
  mov c, 0
  pop d
  mov [d], b
; ca[0] = 'A'; 
  lea d, [bp + -6] ; $ca
  push a
  push d
  mov32 cb, $00000000
  pop d
  add d, b
  pop a
  push d
  mov32 cb, $00000041
  pop d
  mov [d], bl
; ca[1] = 'B'; 
  lea d, [bp + -6] ; $ca
  push a
  push d
  mov32 cb, $00000001
  pop d
  add d, b
  pop a
  push d
  mov32 cb, $00000042
  pop d
  mov [d], bl
; ca[2] = 'C'; 
  lea d, [bp + -6] ; $ca
  push a
  push d
  mov32 cb, $00000002
  pop d
  add d, b
  pop a
  push d
  mov32 cb, $00000043
  pop d
  mov [d], bl
; ca[3] = 'D'; 
  lea d, [bp + -6] ; $ca
  push a
  push d
  mov32 cb, $00000003
  pop d
  add d, b
  pop a
  push d
  mov32 cb, $00000044
  pop d
  mov [d], bl
; ca[4] = 'E'; 
  lea d, [bp + -6] ; $ca
  push a
  push d
  mov32 cb, $00000004
  pop d
  add d, b
  pop a
  push d
  mov32 cb, $00000045
  pop d
  mov [d], bl
; pass = pass && *p == 'A'; 
  lea d, [bp + -1] ; $pass
  push d
  lea d, [bp + -1] ; $pass
  mov b, [d]
  mov c, 0
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + -8] ; $p
  mov b, [d]
  mov c, 0
  mov d, b
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
; pass = pass && *(p + 1) == 'B'; 
  lea d, [bp + -1] ; $pass
  push d
  lea d, [bp + -1] ; $pass
  mov b, [d]
  mov c, 0
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + -8] ; $p
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000001
  add b, a
  pop a
; --- END TERMS
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000042
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  pop d
  mov [d], b
; pass = pass && *(p + 2) == 'C'; 
  lea d, [bp + -1] ; $pass
  push d
  lea d, [bp + -1] ; $pass
  mov b, [d]
  mov c, 0
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + -8] ; $p
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000002
  add b, a
  pop a
; --- END TERMS
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000043
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  pop d
  mov [d], b
; pass = pass && *(p + 3) == 'D'; 
  lea d, [bp + -1] ; $pass
  push d
  lea d, [bp + -1] ; $pass
  mov b, [d]
  mov c, 0
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + -8] ; $p
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000003
  add b, a
  pop a
; --- END TERMS
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000044
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  pop d
  mov [d], b
; pass = pass && *(p + 4) == 'E'; 
  lea d, [bp + -1] ; $pass
  push d
  lea d, [bp + -1] ; $pass
  mov b, [d]
  mov c, 0
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + -8] ; $p
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000004
  add b, a
  pop a
; --- END TERMS
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000045
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
  lea d, [bp + -1] ; $pass
  mov b, [d]
  mov c, 0
  leave
  ret

test2:
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
; char ca[5]; 
  sub sp, 5
; int indices[5]; 
  sub sp, 10
; char *p; 
  sub sp, 2
; p = ca; 
  lea d, [bp + -18] ; $p
  push d
  lea d, [bp + -6] ; $ca
  mov b, d
  mov c, 0
  pop d
  mov [d], b
; ca[0] = 'A'; 
  lea d, [bp + -6] ; $ca
  push a
  push d
  mov32 cb, $00000000
  pop d
  add d, b
  pop a
  push d
  mov32 cb, $00000041
  pop d
  mov [d], bl
; ca[1] = 'B'; 
  lea d, [bp + -6] ; $ca
  push a
  push d
  mov32 cb, $00000001
  pop d
  add d, b
  pop a
  push d
  mov32 cb, $00000042
  pop d
  mov [d], bl
; ca[2] = 'C'; 
  lea d, [bp + -6] ; $ca
  push a
  push d
  mov32 cb, $00000002
  pop d
  add d, b
  pop a
  push d
  mov32 cb, $00000043
  pop d
  mov [d], bl
; ca[3] = 'D'; 
  lea d, [bp + -6] ; $ca
  push a
  push d
  mov32 cb, $00000003
  pop d
  add d, b
  pop a
  push d
  mov32 cb, $00000044
  pop d
  mov [d], bl
; ca[4] = 'E'; 
  lea d, [bp + -6] ; $ca
  push a
  push d
  mov32 cb, $00000004
  pop d
  add d, b
  pop a
  push d
  mov32 cb, $00000045
  pop d
  mov [d], bl
; indices[0] = 0; 
  lea d, [bp + -16] ; $indices
  push a
  push d
  mov32 cb, $00000000
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
; indices[1] = 1; 
  lea d, [bp + -16] ; $indices
  push a
  push d
  mov32 cb, $00000001
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov32 cb, $00000001
  pop d
  mov [d], b
; indices[2] = 2; 
  lea d, [bp + -16] ; $indices
  push a
  push d
  mov32 cb, $00000002
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov32 cb, $00000002
  pop d
  mov [d], b
; indices[3] = 3; 
  lea d, [bp + -16] ; $indices
  push a
  push d
  mov32 cb, $00000003
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov32 cb, $00000003
  pop d
  mov [d], b
; indices[4] = 4; 
  lea d, [bp + -16] ; $indices
  push a
  push d
  mov32 cb, $00000004
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov32 cb, $00000004
  pop d
  mov [d], b
; pass = pass && *(p + indices[0]) == 'A'; 
  lea d, [bp + -1] ; $pass
  push d
  lea d, [bp + -1] ; $pass
  mov b, [d]
  mov c, 0
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + -18] ; $p
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -16] ; $indices
  push a
  push d
  mov32 cb, $00000000
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  mov d, b
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
; pass = pass && *(p + indices[1]) == 'B'; 
  lea d, [bp + -1] ; $pass
  push d
  lea d, [bp + -1] ; $pass
  mov b, [d]
  mov c, 0
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + -18] ; $p
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -16] ; $indices
  push a
  push d
  mov32 cb, $00000001
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000042
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  pop d
  mov [d], b
; pass = pass && *(p + indices[2]) == 'C'; 
  lea d, [bp + -1] ; $pass
  push d
  lea d, [bp + -1] ; $pass
  mov b, [d]
  mov c, 0
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + -18] ; $p
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -16] ; $indices
  push a
  push d
  mov32 cb, $00000002
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000043
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  pop d
  mov [d], b
; pass = pass && *(p + indices[3]) == 'D'; 
  lea d, [bp + -1] ; $pass
  push d
  lea d, [bp + -1] ; $pass
  mov b, [d]
  mov c, 0
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + -18] ; $p
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -16] ; $indices
  push a
  push d
  mov32 cb, $00000003
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000044
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  pop d
  mov [d], b
; pass = pass && *(p + indices[4]) == 'E'; 
  lea d, [bp + -1] ; $pass
  push d
  lea d, [bp + -1] ; $pass
  mov b, [d]
  mov c, 0
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + -18] ; $p
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -16] ; $indices
  push a
  push d
  mov32 cb, $00000004
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000045
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
  lea d, [bp + -1] ; $pass
  mov b, [d]
  mov c, 0
  leave
  ret

test3:
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
; st.c = 'A'; 
  lea d, [bp + 5] ; $st
  add d, 0
  push d
  mov32 cb, $00000041
  pop d
  mov [d], bl
; st.i = 277; 
  lea d, [bp + 5] ; $st
  add d, 1
  push d
  mov32 cb, $00000115
  pop d
  mov [d], b
; st.m[0] = 0; 
  lea d, [bp + 5] ; $st
  add d, 3
  push a
  push d
  mov32 cb, $00000000
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
; st.m[1] = 1; 
  lea d, [bp + 5] ; $st
  add d, 3
  push a
  push d
  mov32 cb, $00000001
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov32 cb, $00000001
  pop d
  mov [d], b
; st.m[2] = 2; 
  lea d, [bp + 5] ; $st
  add d, 3
  push a
  push d
  mov32 cb, $00000002
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov32 cb, $00000002
  pop d
  mov [d], b
; st.m[3] = 3; 
  lea d, [bp + 5] ; $st
  add d, 3
  push a
  push d
  mov32 cb, $00000003
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov32 cb, $00000003
  pop d
  mov [d], b
; st.m[4] = 4; 
  lea d, [bp + 5] ; $st
  add d, 3
  push a
  push d
  mov32 cb, $00000004
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov32 cb, $00000004
  pop d
  mov [d], b
; pass = pass && st.c == 'A'; 
  lea d, [bp + -1] ; $pass
  push d
  lea d, [bp + -1] ; $pass
  mov b, [d]
  mov c, 0
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + 5] ; $st
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
; pass = pass && st.i == 277; 
  lea d, [bp + -1] ; $pass
  push d
  lea d, [bp + -1] ; $pass
  mov b, [d]
  mov c, 0
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + 5] ; $st
  add d, 1
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000115
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  pop d
  mov [d], b
; pass = pass && st.m[0] == 0; 
  lea d, [bp + -1] ; $pass
  push d
  lea d, [bp + -1] ; $pass
  mov b, [d]
  mov c, 0
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + 5] ; $st
  add d, 3
  push a
  push d
  mov32 cb, $00000000
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
  seq ; ==
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  pop d
  mov [d], b
; pass = pass && st.m[1] == 1; 
  lea d, [bp + -1] ; $pass
  push d
  lea d, [bp + -1] ; $pass
  mov b, [d]
  mov c, 0
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + 5] ; $st
  add d, 3
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
; pass = pass && st.m[2] == 2; 
  lea d, [bp + -1] ; $pass
  push d
  lea d, [bp + -1] ; $pass
  mov b, [d]
  mov c, 0
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + 5] ; $st
  add d, 3
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
  mov32 cb, $00000002
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  pop d
  mov [d], b
; pass = pass && st.m[3] == 3; 
  lea d, [bp + -1] ; $pass
  push d
  lea d, [bp + -1] ; $pass
  mov b, [d]
  mov c, 0
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + 5] ; $st
  add d, 3
  push a
  push d
  mov32 cb, $00000003
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
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
  sand a, b
  pop a
; --- END LOGICAL AND
  pop d
  mov [d], b
; pass = pass && st.m[4] == 4; 
  lea d, [bp + -1] ; $pass
  push d
  lea d, [bp + -1] ; $pass
  mov b, [d]
  mov c, 0
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + 5] ; $st
  add d, 3
  push a
  push d
  mov32 cb, $00000004
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
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
  sand a, b
  pop a
; --- END LOGICAL AND
  pop d
  mov [d], b
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
_for3_init:
_for3_cond:
_for3_block:
; if(!*format_p) break; 
_if4_cond:
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
  je _if4_else
_if4_TRUE:
; break; 
  jmp _for3_exit ; for break
  jmp _if4_exit
_if4_else:
; if(*format_p == '%'){ 
_if5_cond:
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
  je _if5_else
_if5_TRUE:
; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  dec b
; switch(*format_p){ 
_switch6_expr:
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
_switch6_comparisons:
  cmp bl, $6c
  je _switch6_case0
  cmp bl, $4c
  je _switch6_case1
  cmp bl, $64
  je _switch6_case2
  cmp bl, $69
  je _switch6_case3
  cmp bl, $75
  je _switch6_case4
  cmp bl, $78
  je _switch6_case5
  cmp bl, $70
  je _switch6_case6
  cmp bl, $63
  je _switch6_case7
  cmp bl, $73
  je _switch6_case8
  jmp _switch6_default
  jmp _switch6_exit
_switch6_case0:
_switch6_case1:
; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  dec b
; if(*format_p == 'd' || *format_p == 'i') 
_if7_cond:
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
  je _if7_else
_if7_TRUE:
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
  jmp _if7_exit
_if7_else:
; if(*format_p == 'u') 
_if8_cond:
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
  je _if8_else
_if8_TRUE:
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
  jmp _if8_exit
_if8_else:
; if(*format_p == 'x') 
_if9_cond:
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
  je _if9_else
_if9_TRUE:
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
  jmp _if9_exit
_if9_else:
; err("Unexpected format in printf."); 
; --- START FUNCTION CALL
  mov b, _s1 ; "Unexpected format in printf."
  swp b
  push b
  call err
  add sp, 2
; --- END FUNCTION CALL
_if9_exit:
_if8_exit:
_if7_exit:
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
  jmp _switch6_exit ; case break
_switch6_case2:
_switch6_case3:
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
  jmp _switch6_exit ; case break
_switch6_case4:
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
  jmp _switch6_exit ; case break
_switch6_case5:
_switch6_case6:
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
  jmp _switch6_exit ; case break
_switch6_case7:
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
  jmp _switch6_exit ; case break
_switch6_case8:
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
  jmp _switch6_exit ; case break
_switch6_default:
; print("Error: Unknown argument type.\n"); 
; --- START FUNCTION CALL
  mov b, _s2 ; "Error: Unknown argument type.\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
_switch6_exit:
  jmp _if5_exit
_if5_else:
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
_if5_exit:
_if4_exit:
; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  dec b
_for3_update:
  jmp _for3_cond
_for3_exit:
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
_if10_cond:
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
  je _if10_else
_if10_TRUE:
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
  jmp _if10_exit
_if10_else:
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
_if10_exit:
; if (absval == 0) { 
_if11_cond:
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
  je _if11_exit
_if11_TRUE:
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
  jmp _if11_exit
_if11_exit:
; while (absval > 0) { 
_while12_cond:
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
  je _while12_exit
_while12_block:
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
  jmp _while12_cond
_while12_exit:
; while (i > 0) { 
_while19_cond:
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
  je _while19_exit
_while19_block:
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
  jmp _while19_cond
_while19_exit:
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
_if20_cond:
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
  je _if20_exit
_if20_TRUE:
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
  jmp _if20_exit
_if20_exit:
; while (num > 0) { 
_while21_cond:
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
  je _while21_exit
_while21_block:
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
  jmp _while21_cond
_while21_exit:
; while (i > 0) { 
_while28_cond:
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
  je _while28_exit
_while28_block:
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
  jmp _while28_cond
_while28_exit:
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
_if29_cond:
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
  je _if29_else
_if29_TRUE:
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
  jmp _if29_exit
_if29_else:
; absval = (unsigned int)num; 
  lea d, [bp + -8] ; $absval
  push d
  lea d, [bp + 5] ; $num
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
_if29_exit:
; if (absval == 0) { 
_if30_cond:
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
  je _if30_exit
_if30_TRUE:
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
  jmp _if30_exit
_if30_exit:
; while (absval > 0) { 
_while31_cond:
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
  je _while31_exit
_while31_block:
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
  jmp _while31_cond
_while31_exit:
; while (i > 0) { 
_while38_cond:
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
  je _while38_exit
_while38_block:
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
  jmp _while38_cond
_while38_exit:
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
_if39_cond:
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
; while (num > 0) { 
_while40_cond:
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
  je _while40_exit
_while40_block:
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
  jmp _while40_cond
_while40_exit:
; while (i > 0) { 
_while47_cond:
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
  je _while47_exit
_while47_block:
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
  jmp _while47_cond
_while47_exit:
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
_st1_data: .fill 13, 0
_s0: .db "Test %d, Result: %d\n", 0
_s1: .db "Unexpected format in printf.", 0
_s2: .db "Error: Unknown argument type.\n", 0

_heap_top: .dw _heap
_heap: .db 0
; --- END DATA SEGMENT

.end
