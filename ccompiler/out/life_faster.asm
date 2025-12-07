; --- FILENAME: programs/life_faster.c
; --- DATE:     11-11-2025 at 18:59:29
.include "lib/asm/kernel.exp"
.include "lib/asm/bios.exp"

; --- BEGIN TEXT SEGMENT
.org text_org
main:
  mov bp, $FFE0 ;
  mov sp, $FFE0 ; Make space for argc(2 bytes) and for 10 pointers in argv (local variables)
; int i, j, n; 
  sub sp, 2
  sub sp, 2
  sub sp, 2
; printf(clear);  // clear the screen once at start 
; --- START FUNCTION CALL
  mov d, _clear_data ; $clear
  mov b, d
  mov c, 0
  swp b
  push b
  call printf
  add sp, 2
; --- END FUNCTION CALL
; for (i = 0; i <  50      ; i++) 
_for1_init:
  lea d, [bp + -1] ; $i
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
_for1_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000032
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for1_exit
_for1_block:
; for (j = 0; j <   60     ; j++) 
_for2_init:
  lea d, [bp + -3] ; $j
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
_for2_cond:
  lea d, [bp + -3] ; $j
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $0000003c
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for2_exit
_for2_block:
; nextState[i][j] = currState[i][j]; 
  mov d, _nextState_data ; $nextState
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 60 ; mov a, 60; mul a, b; add d, b
  push d
  lea d, [bp + -3] ; $j
  mov b, [d]
  mov c, 0
  pop d
  add d, b
  pop a
  push d
  mov d, _currState_data ; $currState
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 60 ; mov a, 60; mul a, b; add d, b
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
  mov [d], bl
_for2_update:
  lea d, [bp + -3] ; $j
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -3] ; $j
  mov [d], b
  mov b, a
  jmp _for2_cond
_for2_exit:
_for1_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  mov b, a
  jmp _for1_cond
_for1_exit:
; for (;;) { 
_for3_init:
_for3_cond:
_for3_block:
; int min_i =  50      , max_i = 0, min_j =   60     , max_j = 0; 
  sub sp, 2
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -7] ; $min_i
  push d
  mov32 cb, $00000032
  pop d
  mov [d], b
; --- END LOCAL VAR INITIALIZATION
  sub sp, 2
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -9] ; $max_i
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
; --- END LOCAL VAR INITIALIZATION
  sub sp, 2
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -11] ; $min_j
  push d
  mov32 cb, $0000003c
  pop d
  mov [d], b
; --- END LOCAL VAR INITIALIZATION
  sub sp, 2
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -13] ; $max_j
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
; --- END LOCAL VAR INITIALIZATION
; for (i = 1; i <  50       - 1; i++) { 
_for4_init:
  lea d, [bp + -1] ; $i
  push d
  mov32 cb, $00000001
  pop d
  mov [d], b
_for4_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000032
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000001
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for4_exit
_for4_block:
; for (j = 1; j <   60      - 1; j++) { 
_for5_init:
  lea d, [bp + -3] ; $j
  push d
  mov32 cb, $00000001
  pop d
  mov [d], b
_for5_cond:
  lea d, [bp + -3] ; $j
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $0000003c
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000001
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for5_exit
_for5_block:
; if (currState[i][j] == '@') { 
_if6_cond:
  mov d, _currState_data ; $currState
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 60 ; mov a, 60; mul a, b; add d, b
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
  mov32 cb, $00000040
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if6_exit
_if6_TRUE:
; if (i < min_i) min_i = i; 
_if7_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -7] ; $min_i
  mov b, [d]
  mov c, 0
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if7_exit
_if7_TRUE:
; min_i = i; 
  lea d, [bp + -7] ; $min_i
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
  jmp _if7_exit
_if7_exit:
; if (i > max_i) max_i = i; 
_if8_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -9] ; $max_i
  mov b, [d]
  mov c, 0
  cmp a, b
  sgt ; >
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if8_exit
_if8_TRUE:
; max_i = i; 
  lea d, [bp + -9] ; $max_i
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
  jmp _if8_exit
_if8_exit:
; if (j < min_j) min_j = j; 
_if9_cond:
  lea d, [bp + -3] ; $j
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -11] ; $min_j
  mov b, [d]
  mov c, 0
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if9_exit
_if9_TRUE:
; min_j = j; 
  lea d, [bp + -11] ; $min_j
  push d
  lea d, [bp + -3] ; $j
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
  jmp _if9_exit
_if9_exit:
; if (j > max_j) max_j = j; 
_if10_cond:
  lea d, [bp + -3] ; $j
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -13] ; $max_j
  mov b, [d]
  mov c, 0
  cmp a, b
  sgt ; >
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if10_exit
_if10_TRUE:
; max_j = j; 
  lea d, [bp + -13] ; $max_j
  push d
  lea d, [bp + -3] ; $j
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
  jmp _if10_exit
_if10_exit:
  jmp _if6_exit
_if6_exit:
_for5_update:
  lea d, [bp + -3] ; $j
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -3] ; $j
  mov [d], b
  mov b, a
  jmp _for5_cond
_for5_exit:
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
; if (min_i > max_i || min_j > max_j) { 
_if11_cond:
  lea d, [bp + -7] ; $min_i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -9] ; $max_i
  mov b, [d]
  mov c, 0
  cmp a, b
  sgt ; >
  pop a
; --- END RELATIONAL
; --- START LOGICAL OR
  push a
  mov a, b
  lea d, [bp + -11] ; $min_j
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -13] ; $max_j
  mov b, [d]
  mov c, 0
  cmp a, b
  sgt ; >
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  cmp b, 0
  je _if11_exit
_if11_TRUE:
; moveCursor( 50       + 1, 0); 
; --- START FUNCTION CALL
  mov32 cb, $00000000
  swp b
  push b
  mov32 cb, $00000032
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000001
  add b, a
  pop a
; --- END TERMS
  swp b
  push b
  call moveCursor
  add sp, 4
; --- END FUNCTION CALL
; puts("All cells dead. Press CTRL+C to quit."); 
; --- START FUNCTION CALL
  mov b, _s0 ; "All cells dead. Press CTRL+C to quit."
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
; continue; 
  jmp _for3_update ; for continue
  jmp _if11_exit
_if11_exit:
; if (min_i > 1) min_i--; 
_if12_cond:
  lea d, [bp + -7] ; $min_i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000001
  cmp a, b
  sgt ; >
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if12_exit
_if12_TRUE:
; min_i--; 
  lea d, [bp + -7] ; $min_i
  mov b, [d]
  mov c, 0
  mov a, b
  dec b
  lea d, [bp + -7] ; $min_i
  mov [d], b
  mov b, a
  jmp _if12_exit
_if12_exit:
; if (max_i <  50       - 2) max_i++; 
_if13_cond:
  lea d, [bp + -9] ; $max_i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000032
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000002
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if13_exit
_if13_TRUE:
; max_i++; 
  lea d, [bp + -9] ; $max_i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -9] ; $max_i
  mov [d], b
  mov b, a
  jmp _if13_exit
_if13_exit:
; if (min_j > 1) min_j--; 
_if14_cond:
  lea d, [bp + -11] ; $min_j
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000001
  cmp a, b
  sgt ; >
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if14_exit
_if14_TRUE:
; min_j--; 
  lea d, [bp + -11] ; $min_j
  mov b, [d]
  mov c, 0
  mov a, b
  dec b
  lea d, [bp + -11] ; $min_j
  mov [d], b
  mov b, a
  jmp _if14_exit
_if14_exit:
; if (max_j <   60      - 2) max_j++; 
_if15_cond:
  lea d, [bp + -13] ; $max_j
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $0000003c
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000002
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if15_exit
_if15_TRUE:
; max_j++; 
  lea d, [bp + -13] ; $max_j
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -13] ; $max_j
  mov [d], b
  mov b, a
  jmp _if15_exit
_if15_exit:
; for (i = min_i; i <= max_i; i++) { 
_for16_init:
  lea d, [bp + -1] ; $i
  push d
  lea d, [bp + -7] ; $min_i
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
_for16_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -9] ; $max_i
  mov b, [d]
  mov c, 0
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for16_exit
_for16_block:
; for (j = min_j; j <= max_j; j++) { 
_for17_init:
  lea d, [bp + -3] ; $j
  push d
  lea d, [bp + -11] ; $min_j
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
_for17_cond:
  lea d, [bp + -3] ; $j
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -13] ; $max_j
  mov b, [d]
  mov c, 0
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for17_exit
_for17_block:
; n = 0; 
  lea d, [bp + -5] ; $n
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
; if (currState[i - 1][j - 1] == '@') n++; 
_if18_cond:
  mov d, _currState_data ; $currState
  push a
  push d
  lea d, [bp + -1] ; $i
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
  mma 60 ; mov a, 60; mul a, b; add d, b
  push d
  lea d, [bp + -3] ; $j
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
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000040
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if18_exit
_if18_TRUE:
; n++; 
  lea d, [bp + -5] ; $n
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -5] ; $n
  mov [d], b
  mov b, a
  jmp _if18_exit
_if18_exit:
; if (currState[i - 1][j    ] == '@') n++; 
_if19_cond:
  mov d, _currState_data ; $currState
  push a
  push d
  lea d, [bp + -1] ; $i
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
  mma 60 ; mov a, 60; mul a, b; add d, b
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
  mov32 cb, $00000040
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if19_exit
_if19_TRUE:
; n++; 
  lea d, [bp + -5] ; $n
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -5] ; $n
  mov [d], b
  mov b, a
  jmp _if19_exit
_if19_exit:
; if (currState[i - 1][j + 1] == '@') n++; 
_if20_cond:
  mov d, _currState_data ; $currState
  push a
  push d
  lea d, [bp + -1] ; $i
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
  mma 60 ; mov a, 60; mul a, b; add d, b
  push d
  lea d, [bp + -3] ; $j
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
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000040
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if20_exit
_if20_TRUE:
; n++; 
  lea d, [bp + -5] ; $n
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -5] ; $n
  mov [d], b
  mov b, a
  jmp _if20_exit
_if20_exit:
; if (currState[i    ][j - 1] == '@') n++; 
_if21_cond:
  mov d, _currState_data ; $currState
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 60 ; mov a, 60; mul a, b; add d, b
  push d
  lea d, [bp + -3] ; $j
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
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000040
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if21_exit
_if21_TRUE:
; n++; 
  lea d, [bp + -5] ; $n
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -5] ; $n
  mov [d], b
  mov b, a
  jmp _if21_exit
_if21_exit:
; if (currState[i    ][j + 1] == '@') n++; 
_if22_cond:
  mov d, _currState_data ; $currState
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 60 ; mov a, 60; mul a, b; add d, b
  push d
  lea d, [bp + -3] ; $j
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
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000040
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if22_exit
_if22_TRUE:
; n++; 
  lea d, [bp + -5] ; $n
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -5] ; $n
  mov [d], b
  mov b, a
  jmp _if22_exit
_if22_exit:
; if (currState[i + 1][j - 1] == '@') n++; 
_if23_cond:
  mov d, _currState_data ; $currState
  push a
  push d
  lea d, [bp + -1] ; $i
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
  mma 60 ; mov a, 60; mul a, b; add d, b
  push d
  lea d, [bp + -3] ; $j
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
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000040
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if23_exit
_if23_TRUE:
; n++; 
  lea d, [bp + -5] ; $n
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -5] ; $n
  mov [d], b
  mov b, a
  jmp _if23_exit
_if23_exit:
; if (currState[i + 1][j    ] == '@') n++; 
_if24_cond:
  mov d, _currState_data ; $currState
  push a
  push d
  lea d, [bp + -1] ; $i
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
  mma 60 ; mov a, 60; mul a, b; add d, b
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
  mov32 cb, $00000040
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if24_exit
_if24_TRUE:
; n++; 
  lea d, [bp + -5] ; $n
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -5] ; $n
  mov [d], b
  mov b, a
  jmp _if24_exit
_if24_exit:
; if (currState[i + 1][j + 1] == '@') n++; 
_if25_cond:
  mov d, _currState_data ; $currState
  push a
  push d
  lea d, [bp + -1] ; $i
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
  mma 60 ; mov a, 60; mul a, b; add d, b
  push d
  lea d, [bp + -3] ; $j
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
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000040
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if25_exit
_if25_TRUE:
; n++; 
  lea d, [bp + -5] ; $n
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -5] ; $n
  mov [d], b
  mov b, a
  jmp _if25_exit
_if25_exit:
; if (currState[i][j] == '@') { 
_if26_cond:
  mov d, _currState_data ; $currState
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 60 ; mov a, 60; mul a, b; add d, b
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
  mov32 cb, $00000040
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if26_else
_if26_TRUE:
; nextState[i][j] = (n < 2 || n > 3) ? ' ' : '@'; 
  mov d, _nextState_data ; $nextState
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 60 ; mov a, 60; mul a, b; add d, b
  push d
  lea d, [bp + -3] ; $j
  mov b, [d]
  mov c, 0
  pop d
  add d, b
  pop a
  push d
_ternary27_cond:
  lea d, [bp + -5] ; $n
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000002
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
; --- START LOGICAL OR
  push a
  mov a, b
  lea d, [bp + -5] ; $n
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000003
  cmp a, b
  sgt ; >
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  cmp b, 0
  je _ternary27_FALSE
_ternary27_TRUE:
  mov32 cb, $00000020
  jmp _ternary27_exit
_ternary27_FALSE:
  mov32 cb, $00000040
_ternary27_exit:
  pop d
  mov [d], bl
  jmp _if26_exit
_if26_else:
; nextState[i][j] = (n == 3) ? '@' : ' '; 
  mov d, _nextState_data ; $nextState
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 60 ; mov a, 60; mul a, b; add d, b
  push d
  lea d, [bp + -3] ; $j
  mov b, [d]
  mov c, 0
  pop d
  add d, b
  pop a
  push d
_ternary28_cond:
  lea d, [bp + -5] ; $n
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
  je _ternary28_FALSE
_ternary28_TRUE:
  mov32 cb, $00000040
  jmp _ternary28_exit
_ternary28_FALSE:
  mov32 cb, $00000020
_ternary28_exit:
  pop d
  mov [d], bl
_if26_exit:
_for17_update:
  lea d, [bp + -3] ; $j
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -3] ; $j
  mov [d], b
  mov b, a
  jmp _for17_cond
_for17_exit:
_for16_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  mov b, a
  jmp _for16_cond
_for16_exit:
; for (i = min_i; i <= max_i; i++) { 
_for29_init:
  lea d, [bp + -1] ; $i
  push d
  lea d, [bp + -7] ; $min_i
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
_for29_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -9] ; $max_i
  mov b, [d]
  mov c, 0
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for29_exit
_for29_block:
; int row_changed = 0; 
  sub sp, 2
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -15] ; $row_changed
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
; --- END LOCAL VAR INITIALIZATION
; for (j = min_j; j <= max_j; j++) { 
_for30_init:
  lea d, [bp + -3] ; $j
  push d
  lea d, [bp + -11] ; $min_j
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
_for30_cond:
  lea d, [bp + -3] ; $j
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -13] ; $max_j
  mov b, [d]
  mov c, 0
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for30_exit
_for30_block:
; if (currState[i][j] != nextState[i][j]) { 
_if31_cond:
  mov d, _currState_data ; $currState
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 60 ; mov a, 60; mul a, b; add d, b
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
  mov d, _nextState_data ; $nextState
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 60 ; mov a, 60; mul a, b; add d, b
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
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if31_else
_if31_TRUE:
; if (!row_changed) { 
_if32_cond:
  lea d, [bp + -15] ; $row_changed
  mov b, [d]
  mov c, 0
  cmp b, 0
  je _if32_exit
_if32_TRUE:
; moveCursor(i, min_j); 
; --- START FUNCTION CALL
  lea d, [bp + -11] ; $min_j
  mov b, [d]
  mov c, 0
  swp b
  push b
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  swp b
  push b
  call moveCursor
  add sp, 4
; --- END FUNCTION CALL
; row_changed = 1; 
  lea d, [bp + -15] ; $row_changed
  push d
  mov32 cb, $00000001
  pop d
  mov [d], b
  jmp _if32_exit
_if32_exit:
; putchar(nextState[i][j] == '@' ? '@' : ' '); 
; --- START FUNCTION CALL
_ternary34_cond:
  mov d, _nextState_data ; $nextState
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 60 ; mov a, 60; mul a, b; add d, b
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
  mov32 cb, $00000040
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _ternary34_FALSE
_ternary34_TRUE:
  mov32 cb, $00000040
  jmp _ternary34_exit
_ternary34_FALSE:
  mov32 cb, $00000020
_ternary34_exit:
  push bl
  call putchar
  add sp, 1
; --- END FUNCTION CALL
; putchar(' '); 
; --- START FUNCTION CALL
  mov32 cb, $00000020
  push bl
  call putchar
  add sp, 1
; --- END FUNCTION CALL
  jmp _if31_exit
_if31_else:
; if (row_changed) { 
_if35_cond:
  lea d, [bp + -15] ; $row_changed
  mov b, [d]
  mov c, 0
  cmp b, 0
  je _if35_exit
_if35_TRUE:
; putchar(' '); 
; --- START FUNCTION CALL
  mov32 cb, $00000020
  push bl
  call putchar
  add sp, 1
; --- END FUNCTION CALL
; putchar(' '); 
; --- START FUNCTION CALL
  mov32 cb, $00000020
  push bl
  call putchar
  add sp, 1
; --- END FUNCTION CALL
  jmp _if35_exit
_if35_exit:
_if31_exit:
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
; for (i = min_i; i <= max_i; i++) 
_for36_init:
  lea d, [bp + -1] ; $i
  push d
  lea d, [bp + -7] ; $min_i
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
_for36_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -9] ; $max_i
  mov b, [d]
  mov c, 0
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for36_exit
_for36_block:
; for (j = min_j; j <= max_j; j++) 
_for37_init:
  lea d, [bp + -3] ; $j
  push d
  lea d, [bp + -11] ; $min_j
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
_for37_cond:
  lea d, [bp + -3] ; $j
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -13] ; $max_j
  mov b, [d]
  mov c, 0
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for37_exit
_for37_block:
; currState[i][j] = nextState[i][j]; 
  mov d, _currState_data ; $currState
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 60 ; mov a, 60; mul a, b; add d, b
  push d
  lea d, [bp + -3] ; $j
  mov b, [d]
  mov c, 0
  pop d
  add d, b
  pop a
  push d
  mov d, _nextState_data ; $nextState
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 60 ; mov a, 60; mul a, b; add d, b
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
  mov [d], bl
_for37_update:
  lea d, [bp + -3] ; $j
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -3] ; $j
  mov [d], b
  mov b, a
  jmp _for37_cond
_for37_exit:
_for36_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  mov b, a
  jmp _for36_cond
_for36_exit:
; moveCursor( 50       + 1, 0); 
; --- START FUNCTION CALL
  mov32 cb, $00000000
  swp b
  push b
  mov32 cb, $00000032
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000001
  add b, a
  pop a
; --- END TERMS
  swp b
  push b
  call moveCursor
  add sp, 4
; --- END FUNCTION CALL
; puts("Press CTRL+C to quit."); 
; --- START FUNCTION CALL
  mov b, _s1 ; "Press CTRL+C to quit."
  swp b
  push b
  call puts
  add sp, 2
; --- END FUNCTION CALL
_for3_update:
  jmp _for3_cond
_for3_exit:
; return 0; 
  mov32 cb, $00000000
  leave
  syscall sys_terminate_proc

moveCursor:
  enter 0 ; (push bp; mov bp, sp)
; printf("\033[%d;%dH", row + 1, col * 2 + 1);  // 1-based ANSI cursor 
; --- START FUNCTION CALL
  lea d, [bp + 7] ; $col
  mov b, [d]
  mov c, 0
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
  jz skip_invert_a_41  
  neg a 
skip_invert_a_41:   
  swp b
  test bl, $80  
  swp b
  jz skip_invert_b_41  
  neg b 
skip_invert_b_41:   
  mul a, b ; *
  mov g, a
  mov a, b
  pop bl
  test bl, $80
  jz _same_signs_41
  mov bl, al
  not a
  neg b
  adc a, 0
  mov g, a
  mov a, b
_same_signs_41:
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
  mov32 cb, $00000001
  mov c, 0
  add32 cb, ga
  pop g
  pop a
; --- END TERMS
  mov a, c
  swp a
  push a
  swp b
  push b
  lea d, [bp + 5] ; $row
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000001
  add b, a
  pop a
; --- END TERMS
  swp b
  push b
  mov b, _s2 ; "\033[%d;%dH"
  swp b
  push b
  call printf
  add sp, 8
; --- END FUNCTION CALL
  leave
  ret

printf:
  enter 0 ; (push bp; mov bp, sp)
; char *p, *format_p; 
  sub sp, 1
  sub sp, 2
; format_p = format; 
  lea d, [bp + -2] ; $format_p
  push d
  lea d, [bp + 5] ; $format
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
; p = &format + 2; 
  lea d, [bp + 0] ; $p
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
  mov [d], bl
; for(;;){ 
_for42_init:
_for42_cond:
_for42_block:
; if(!*format_p) break; 
_if43_cond:
  lea d, [bp + -2] ; $format_p
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  cmp b, 0
  seq ; !
  cmp b, 0
  je _if43_else
_if43_TRUE:
; break; 
  jmp _for42_exit ; for break
  jmp _if43_exit
_if43_else:
; if(*format_p == '%'){ 
_if44_cond:
  lea d, [bp + -2] ; $format_p
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
  je _if44_else
_if44_TRUE:
; format_p++; 
  lea d, [bp + -2] ; $format_p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -2] ; $format_p
  mov [d], b
  dec b
; switch(*format_p){ 
_switch45_expr:
  lea d, [bp + -2] ; $format_p
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
_switch45_comparisons:
  cmp bl, $6c
  je _switch45_case0
  cmp bl, $4c
  je _switch45_case1
  cmp bl, $64
  je _switch45_case2
  cmp bl, $69
  je _switch45_case3
  cmp bl, $75
  je _switch45_case4
  cmp bl, $78
  je _switch45_case5
  cmp bl, $70
  je _switch45_case6
  cmp bl, $63
  je _switch45_case7
  cmp bl, $73
  je _switch45_case8
  jmp _switch45_default
  jmp _switch45_exit
_switch45_case0:
_switch45_case1:
; format_p++; 
  lea d, [bp + -2] ; $format_p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -2] ; $format_p
  mov [d], b
  dec b
; if(*format_p == 'd' || *format_p == 'i') 
_if46_cond:
  lea d, [bp + -2] ; $format_p
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
  lea d, [bp + -2] ; $format_p
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
  je _if46_else
_if46_TRUE:
; print_signed_long(*(long int*)p); 
; --- START FUNCTION CALL
  lea d, [bp + 0] ; $p
  mov bl, [d]
  mov bh, 0
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
  jmp _if46_exit
_if46_else:
; if(*format_p == 'u') 
_if47_cond:
  lea d, [bp + -2] ; $format_p
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
  je _if47_else
_if47_TRUE:
; print_unsigned_long(*(unsigned long int*)p); 
; --- START FUNCTION CALL
  lea d, [bp + 0] ; $p
  mov bl, [d]
  mov bh, 0
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
  jmp _if47_exit
_if47_else:
; if(*format_p == 'x') 
_if48_cond:
  lea d, [bp + -2] ; $format_p
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
  je _if48_else
_if48_TRUE:
; printx32(*(long int *)p); 
; --- START FUNCTION CALL
  lea d, [bp + 0] ; $p
  mov bl, [d]
  mov bh, 0
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
  jmp _if48_exit
_if48_else:
; err("Unexpected format in printf."); 
; --- START FUNCTION CALL
  mov b, _s3 ; "Unexpected format in printf."
  swp b
  push b
  call err
  add sp, 2
; --- END FUNCTION CALL
_if48_exit:
_if47_exit:
_if46_exit:
; p = p + 4; 
  lea d, [bp + 0] ; $p
  push d
  lea d, [bp + 0] ; $p
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000004
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], bl
; break; 
  jmp _switch45_exit ; case break
_switch45_case2:
_switch45_case3:
; print_signed(*(int*)p); 
; --- START FUNCTION CALL
  lea d, [bp + 0] ; $p
  mov bl, [d]
  mov bh, 0
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
  lea d, [bp + 0] ; $p
  push d
  lea d, [bp + 0] ; $p
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000002
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], bl
; break; 
  jmp _switch45_exit ; case break
_switch45_case4:
; print_unsigned(*(unsigned int*)p); 
; --- START FUNCTION CALL
  lea d, [bp + 0] ; $p
  mov bl, [d]
  mov bh, 0
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
  lea d, [bp + 0] ; $p
  push d
  lea d, [bp + 0] ; $p
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000002
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], bl
; break; 
  jmp _switch45_exit ; case break
_switch45_case5:
_switch45_case6:
; printx16(*(int*)p); 
; --- START FUNCTION CALL
  lea d, [bp + 0] ; $p
  mov bl, [d]
  mov bh, 0
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
  lea d, [bp + 0] ; $p
  push d
  lea d, [bp + 0] ; $p
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000002
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], bl
; break; 
  jmp _switch45_exit ; case break
_switch45_case7:
; putchar(*(char*)p); 
; --- START FUNCTION CALL
  lea d, [bp + 0] ; $p
  mov bl, [d]
  mov bh, 0
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
  lea d, [bp + 0] ; $p
  push d
  lea d, [bp + 0] ; $p
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000002
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], bl
; break; 
  jmp _switch45_exit ; case break
_switch45_case8:
; print(*(char**)p); 
; --- START FUNCTION CALL
  lea d, [bp + 0] ; $p
  mov bl, [d]
  mov bh, 0
  mov c, 0
  mov d, b
  mov b, [d]
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; p = p + 2; 
  lea d, [bp + 0] ; $p
  push d
  lea d, [bp + 0] ; $p
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000002
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], bl
; break; 
  jmp _switch45_exit ; case break
_switch45_default:
; print("Error: Unknown argument type.\n"); 
; --- START FUNCTION CALL
  mov b, _s4 ; "Error: Unknown argument type.\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
_switch45_exit:
  jmp _if44_exit
_if44_else:
; putchar(*format_p); 
; --- START FUNCTION CALL
  lea d, [bp + -2] ; $format_p
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
_if44_exit:
_if43_exit:
; format_p++; 
  lea d, [bp + -2] ; $format_p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -2] ; $format_p
  mov [d], b
  dec b
_for42_update:
  jmp _for42_cond
_for42_exit:
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
_if49_cond:
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
  je _if49_else
_if49_TRUE:
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
  jmp _if49_exit
_if49_else:
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
_if49_exit:
; if (absval == 0) { 
_if50_cond:
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
  je _if50_exit
_if50_TRUE:
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
  jmp _if50_exit
_if50_exit:
; while (absval > 0) { 
_while51_cond:
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
  je _while51_exit
_while51_block:
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
  jmp _while51_cond
_while51_exit:
; while (i > 0) { 
_while58_cond:
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
  je _while58_exit
_while58_block:
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
  jmp _while58_cond
_while58_exit:
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
_if59_cond:
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
  je _if59_exit
_if59_TRUE:
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
  jmp _if59_exit
_if59_exit:
; while (num > 0) { 
_while60_cond:
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
  je _while60_exit
_while60_block:
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
  jmp _while60_cond
_while60_exit:
; while (i > 0) { 
_while67_cond:
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
  je _while67_exit
_while67_block:
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
  jmp _while67_cond
_while67_exit:
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
_if68_cond:
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
  je _if68_else
_if68_TRUE:
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
  jmp _if68_exit
_if68_else:
; absval = (unsigned int)num; 
  lea d, [bp + -8] ; $absval
  push d
  lea d, [bp + 5] ; $num
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
_if68_exit:
; if (absval == 0) { 
_if69_cond:
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
  je _if69_exit
_if69_TRUE:
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
  jmp _if69_exit
_if69_exit:
; while (absval > 0) { 
_while70_cond:
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
  je _while70_exit
_while70_block:
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
  jmp _while70_cond
_while70_exit:
; while (i > 0) { 
_while77_cond:
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
  je _while77_exit
_while77_block:
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
  jmp _while77_cond
_while77_exit:
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
_if78_cond:
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
  je _if78_exit
_if78_TRUE:
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
  jmp _if78_exit
_if78_exit:
; while (num > 0) { 
_while79_cond:
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
  je _while79_exit
_while79_block:
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
  jmp _while79_cond
_while79_exit:
; while (i > 0) { 
_while86_cond:
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
  je _while86_exit
_while86_block:
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
  jmp _while86_cond
_while86_exit:
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
; --- END TEXT SEGMENT

; --- BEGIN DATA SEGMENT
_nextState_data: .fill 3000, 0
_currState_data: .db $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,
.db $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,
.db $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,
.db $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,
.db $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,
.db $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,
.db $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,
.db $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,
.db $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,
.db $20,$20,$20,$20,$40,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,
.db $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,
.db $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$40,$20,$40,$20,$20,$20,
.db $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,
.db $20,$20,$20,$20,$20,$20,$20,$20,$40,$40,$20,$20,$20,$20,$20,$20,
.db $40,$40,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$40,$40,
.db $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$40,
.db $20,$20,$20,$40,$20,$20,$20,$20,$40,$40,$20,$20,$20,$20,$20,$20,
.db $20,$20,$20,$20,$20,$20,$40,$40,$20,$20,$20,$20,$40,$40,$20,$20,
.db $20,$20,$20,$20,$20,$20,$40,$20,$20,$20,$20,$20,$40,$20,$20,$20,
.db $40,$40,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,
.db $20,$20,$20,$20,$40,$40,$20,$20,$20,$20,$20,$20,$20,$20,$40,$20,
.db $20,$20,$40,$20,$40,$40,$20,$20,$20,$20,$40,$20,$40,$20,$20,$20,
.db $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,
.db $20,$20,$20,$20,$20,$20,$40,$20,$20,$20,$20,$20,$40,$20,$20,$20,
.db $20,$20,$20,$20,$40,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,
.db $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$40,
.db $20,$20,$20,$40,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,
.db $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,
.db $20,$20,$20,$20,$20,$20,$20,$20,$40,$40,$20,$20,$20,$20,$20,$20,
.db $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,
.db $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,
.db $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,
.db $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,
.db $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,
.db $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,
.db $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,
.db $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,
.db $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,
.db $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,
.db $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,
.db $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,
.db $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,
.db $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,
.db $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,
.db $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,
.db $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,
.db $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,
.db $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,
.db $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,
.db $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,
.db $20,

.fill 2200, 0
_clear_data: .db $1b,$5b,$32,$4a,$00,

.fill 2, 0
_s0: .db "All cells dead. Press CTRL+C to quit.", 0
_s1: .db "Press CTRL+C to quit.", 0
_s2: .db "\033[%d;%dH", 0
_s3: .db "Unexpected format in printf.", 0
_s4: .db "Error: Unknown argument type.\n", 0

_heap_top: .dw _heap
_heap: .db 0
; --- END DATA SEGMENT

.end
