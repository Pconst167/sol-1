; --- FILENAME: programs/wireworld.c
; --- DATE:     04-07-2025 at 00:37:38
.include "lib/asm/kernel.exp"
.include "lib/asm/bios.exp"

; --- BEGIN TEXT SEGMENT
.org text_org
main:
  mov bp, $FFE0 ;
  mov sp, $FFE0 ; Make space for argc(2 bytes) and for 10 pointers in argv (local variables)
; int i; 
  sub sp, 2
; grid[5][5] = CONDUCTOR; 
  mov d, _grid_data ; $grid
  push a
  push d
  mov32 cb, $00000005
  pop d
  mma 80 ; mov a, 80; mul a, b; add d, b
  push d
  mov32 cb, $00000005
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov32 cb, $1 ; enum element: CONDUCTOR
  pop d
  mov [d], b
; grid[6][5] = ELECTRON_HEAD; 
  mov d, _grid_data ; $grid
  push a
  push d
  mov32 cb, $00000006
  pop d
  mma 80 ; mov a, 80; mul a, b; add d, b
  push d
  mov32 cb, $00000005
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov32 cb, $2 ; enum element: ELECTRON_HEAD
  pop d
  mov [d], b
; grid[7][5] = CONDUCTOR; 
  mov d, _grid_data ; $grid
  push a
  push d
  mov32 cb, $00000007
  pop d
  mma 80 ; mov a, 80; mul a, b; add d, b
  push d
  mov32 cb, $00000005
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov32 cb, $1 ; enum element: CONDUCTOR
  pop d
  mov [d], b
; grid[6][6] = ELECTRON_TAIL; 
  mov d, _grid_data ; $grid
  push a
  push d
  mov32 cb, $00000006
  pop d
  mma 80 ; mov a, 80; mul a, b; add d, b
  push d
  mov32 cb, $00000006
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov32 cb, $3 ; enum element: ELECTRON_TAIL
  pop d
  mov [d], b
; grid[6][7] = CONDUCTOR; 
  mov d, _grid_data ; $grid
  push a
  push d
  mov32 cb, $00000006
  pop d
  mma 80 ; mov a, 80; mul a, b; add d, b
  push d
  mov32 cb, $00000007
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov32 cb, $1 ; enum element: CONDUCTOR
  pop d
  mov [d], b
; grid[5][10] = CONDUCTOR; 
  mov d, _grid_data ; $grid
  push a
  push d
  mov32 cb, $00000005
  pop d
  mma 80 ; mov a, 80; mul a, b; add d, b
  push d
  mov32 cb, $0000000a
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov32 cb, $1 ; enum element: CONDUCTOR
  pop d
  mov [d], b
; grid[6][10] = ELECTRON_HEAD; 
  mov d, _grid_data ; $grid
  push a
  push d
  mov32 cb, $00000006
  pop d
  mma 80 ; mov a, 80; mul a, b; add d, b
  push d
  mov32 cb, $0000000a
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov32 cb, $2 ; enum element: ELECTRON_HEAD
  pop d
  mov [d], b
; grid[7][10] = CONDUCTOR; 
  mov d, _grid_data ; $grid
  push a
  push d
  mov32 cb, $00000007
  pop d
  mma 80 ; mov a, 80; mul a, b; add d, b
  push d
  mov32 cb, $0000000a
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov32 cb, $1 ; enum element: CONDUCTOR
  pop d
  mov [d], b
; grid[6][11] = ELECTRON_TAIL; 
  mov d, _grid_data ; $grid
  push a
  push d
  mov32 cb, $00000006
  pop d
  mma 80 ; mov a, 80; mul a, b; add d, b
  push d
  mov32 cb, $0000000b
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov32 cb, $3 ; enum element: ELECTRON_TAIL
  pop d
  mov [d], b
; grid[6][12] = CONDUCTOR; 
  mov d, _grid_data ; $grid
  push a
  push d
  mov32 cb, $00000006
  pop d
  mma 80 ; mov a, 80; mul a, b; add d, b
  push d
  mov32 cb, $0000000c
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov32 cb, $1 ; enum element: CONDUCTOR
  pop d
  mov [d], b
; for (i = 8; i <= 14; i++) { 
_for1_init:
  lea d, [bp + -1] ; $i
  push d
  mov32 cb, $00000008
  pop d
  mov [d], b
_for1_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $0000000e
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for1_exit
_for1_block:
; grid[7][i] = CONDUCTOR; 
  mov d, _grid_data ; $grid
  push a
  push d
  mov32 cb, $00000007
  pop d
  mma 80 ; mov a, 80; mul a, b; add d, b
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov32 cb, $1 ; enum element: CONDUCTOR
  pop d
  mov [d], b
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
; grid[7][15] = CONDUCTOR; 
  mov d, _grid_data ; $grid
  push a
  push d
  mov32 cb, $00000007
  pop d
  mma 80 ; mov a, 80; mul a, b; add d, b
  push d
  mov32 cb, $0000000f
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov32 cb, $1 ; enum element: CONDUCTOR
  pop d
  mov [d], b
; grid[6][15] = ELECTRON_TAIL; 
  mov d, _grid_data ; $grid
  push a
  push d
  mov32 cb, $00000006
  pop d
  mma 80 ; mov a, 80; mul a, b; add d, b
  push d
  mov32 cb, $0000000f
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov32 cb, $3 ; enum element: ELECTRON_TAIL
  pop d
  mov [d], b
; grid[8][15] = ELECTRON_TAIL; 
  mov d, _grid_data ; $grid
  push a
  push d
  mov32 cb, $00000008
  pop d
  mma 80 ; mov a, 80; mul a, b; add d, b
  push d
  mov32 cb, $0000000f
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov32 cb, $3 ; enum element: ELECTRON_TAIL
  pop d
  mov [d], b
; grid[6][16] = CONDUCTOR; 
  mov d, _grid_data ; $grid
  push a
  push d
  mov32 cb, $00000006
  pop d
  mma 80 ; mov a, 80; mul a, b; add d, b
  push d
  mov32 cb, $00000010
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov32 cb, $1 ; enum element: CONDUCTOR
  pop d
  mov [d], b
; grid[8][16] = CONDUCTOR; 
  mov d, _grid_data ; $grid
  push a
  push d
  mov32 cb, $00000008
  pop d
  mma 80 ; mov a, 80; mul a, b; add d, b
  push d
  mov32 cb, $00000010
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov32 cb, $1 ; enum element: CONDUCTOR
  pop d
  mov [d], b
; for (i = 17; i <= 25; i++) { 
_for2_init:
  lea d, [bp + -1] ; $i
  push d
  mov32 cb, $00000011
  pop d
  mov [d], b
_for2_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000019
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for2_exit
_for2_block:
; grid[7][i] = CONDUCTOR; 
  mov d, _grid_data ; $grid
  push a
  push d
  mov32 cb, $00000007
  pop d
  mma 80 ; mov a, 80; mul a, b; add d, b
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov32 cb, $1 ; enum element: CONDUCTOR
  pop d
  mov [d], b
_for2_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  mov b, a
  jmp _for2_cond
_for2_exit:
; while (1) { 
_while3_cond:
  mov32 cb, $00000001
  cmp b, 0
  je _while3_exit
_while3_block:
; print_grid(); 
; --- START FUNCTION CALL
  call print_grid
; iterate(); 
; --- START FUNCTION CALL
  call iterate
  jmp _while3_cond
_while3_exit:
; return 0; 
  mov32 cb, $00000000
  leave
  syscall sys_terminate_proc

print_grid:
  enter 0 ; (push bp; mov bp, sp)
; for (y = 0; y < 20; ++y) { 
_for4_init:
  mov d, _y ; $y
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
_for4_cond:
  mov d, _y ; $y
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000014
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for4_exit
_for4_block:
; for (x = 0; x < 40; ++x) { 
_for5_init:
  mov d, _x ; $x
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
_for5_cond:
  mov d, _x ; $x
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000028
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for5_exit
_for5_block:
; switch (grid[y][x]) { 
_switch6_expr:
  mov d, _grid_data ; $grid
  push a
  push d
  mov d, _y ; $y
  mov b, [d]
  mov c, 0
  pop d
  mma 80 ; mov a, 80; mul a, b; add d, b
  push d
  mov d, _x ; $x
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
_switch6_comparisons:
  cmp b, 0
  je _switch6_case0
  cmp b, 1
  je _switch6_case1
  cmp b, 2
  je _switch6_case2
  cmp b, 3
  je _switch6_case3
  jmp _switch6_exit
_switch6_case0:
; c = ' '; break; 
  mov d, _c ; $c
  push d
  mov32 cb, $00000020
  pop d
  mov [d], bl
; break; 
  jmp _switch6_exit ; case break
_switch6_case1:
; c = '*'; break; 
  mov d, _c ; $c
  push d
  mov32 cb, $0000002a
  pop d
  mov [d], bl
; break; 
  jmp _switch6_exit ; case break
_switch6_case2:
; c = 'H'; break; 
  mov d, _c ; $c
  push d
  mov32 cb, $00000048
  pop d
  mov [d], bl
; break; 
  jmp _switch6_exit ; case break
_switch6_case3:
; c = 'T'; break; 
  mov d, _c ; $c
  push d
  mov32 cb, $00000054
  pop d
  mov [d], bl
; break; 
  jmp _switch6_exit ; case break
_switch6_exit:
; putchar(c); 
; --- START FUNCTION CALL
  mov d, _c ; $c
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push bl
  call putchar
  add sp, 1
; --- END FUNCTION CALL
_for5_update:
  mov d, _x ; $x
  mov b, [d]
  inc b
  mov d, _x ; $x
  mov [d], b
  jmp _for5_cond
_for5_exit:
; putchar('\n'); 
; --- START FUNCTION CALL
  mov32 cb, $0000000a
  push bl
  call putchar
  add sp, 1
; --- END FUNCTION CALL
_for4_update:
  mov d, _y ; $y
  mov b, [d]
  inc b
  mov d, _y ; $y
  mov [d], b
  jmp _for4_cond
_for4_exit:
; return; 
  leave
  ret

iterate:
  enter 0 ; (push bp; mov bp, sp)
; for (y = 0; y < 20; ++y){ 
_for7_init:
  mov d, _y ; $y
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
_for7_cond:
  mov d, _y ; $y
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000014
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for7_exit
_for7_block:
; for (x = 0; x < 40; ++x){ 
_for8_init:
  mov d, _x ; $x
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
_for8_cond:
  mov d, _x ; $x
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000028
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for8_exit
_for8_block:
; head_count = 0; 
  mov d, _head_count ; $head_count
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
; for (dy = -1; dy <= 1; dy++){ 
_for9_init:
  mov d, _dy ; $dy
  push d
  mov32 cb, $ffffffff
  pop d
  mov [d], b
_for9_cond:
  mov d, _dy ; $dy
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000001
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for9_exit
_for9_block:
; for (dx = -1; dx <= 1; dx++) { 
_for10_init:
  mov d, _dx ; $dx
  push d
  mov32 cb, $ffffffff
  pop d
  mov [d], b
_for10_cond:
  mov d, _dx ; $dx
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000001
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for10_exit
_for10_block:
; if (dx == 0 && dy == 0) continue; 
_if11_cond:
  mov d, _dx ; $dx
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
; --- START LOGICAL AND
  push a
  mov a, b
  mov d, _dy ; $dy
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
  cmp b, 0
  je _if11_exit
_if11_TRUE:
; continue; 
  jmp _for10_update ; for continue
  jmp _if11_exit
_if11_exit:
; nx = x + dx; 
  mov d, _nx ; $nx
  push d
  mov d, _x ; $x
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov d, _dx ; $dx
  mov b, [d]
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; ny = y + dy; 
  mov d, _ny ; $ny
  push d
  mov d, _y ; $y
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov d, _dy ; $dy
  mov b, [d]
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; if (nx >= 0 && nx < 40 && ny >= 0 && ny < 20 && grid[ny][nx] == ELECTRON_HEAD){ 
_if12_cond:
  mov d, _nx ; $nx
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
; --- START LOGICAL AND
  push a
  mov a, b
  mov d, _nx ; $nx
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000028
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  sand a, b
  mov a, b
  mov d, _ny ; $ny
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
  mov a, b
  mov d, _ny ; $ny
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000014
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  sand a, b
  mov a, b
  mov d, _grid_data ; $grid
  push a
  push d
  mov d, _ny ; $ny
  mov b, [d]
  mov c, 0
  pop d
  mma 80 ; mov a, 80; mul a, b; add d, b
  push d
  mov d, _nx ; $nx
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
  mov32 cb, $2 ; enum element: ELECTRON_HEAD
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  cmp b, 0
  je _if12_exit
_if12_TRUE:
; head_count++; 
  mov d, _head_count ; $head_count
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  mov d, _head_count ; $head_count
  mov [d], b
  mov b, a
  jmp _if12_exit
_if12_exit:
_for10_update:
  mov d, _dx ; $dx
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  mov d, _dx ; $dx
  mov [d], b
  mov b, a
  jmp _for10_cond
_for10_exit:
_for9_update:
  mov d, _dy ; $dy
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  mov d, _dy ; $dy
  mov [d], b
  mov b, a
  jmp _for9_cond
_for9_exit:
; switch (grid[y][x]) { 
_switch13_expr:
  mov d, _grid_data ; $grid
  push a
  push d
  mov d, _y ; $y
  mov b, [d]
  mov c, 0
  pop d
  mma 80 ; mov a, 80; mul a, b; add d, b
  push d
  mov d, _x ; $x
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
_switch13_comparisons:
  cmp b, 0
  je _switch13_case0
  cmp b, 1
  je _switch13_case1
  cmp b, 2
  je _switch13_case2
  cmp b, 3
  je _switch13_case3
  jmp _switch13_exit
_switch13_case0:
; new_grid[y][x] = EMPTY; break; 
  mov d, _new_grid_data ; $new_grid
  push a
  push d
  mov d, _y ; $y
  mov b, [d]
  mov c, 0
  pop d
  mma 80 ; mov a, 80; mul a, b; add d, b
  push d
  mov d, _x ; $x
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov32 cb, $0 ; enum element: EMPTY
  pop d
  mov [d], b
; break; 
  jmp _switch13_exit ; case break
_switch13_case1:
; new_grid[y][x] = (head_count == 1 || head_count == 2) ? ELECTRON_HEAD : CONDUCTOR; break; 
  mov d, _new_grid_data ; $new_grid
  push a
  push d
  mov d, _y ; $y
  mov b, [d]
  mov c, 0
  pop d
  mma 80 ; mov a, 80; mul a, b; add d, b
  push d
  mov d, _x ; $x
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
_ternary14_cond:
  mov d, _head_count ; $head_count
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
; --- START LOGICAL OR
  push a
  mov a, b
  mov d, _head_count ; $head_count
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
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  cmp b, 0
  je _ternary14_FALSE
_ternary14_TRUE:
  mov32 cb, $2 ; enum element: ELECTRON_HEAD
  jmp _ternary14_exit
_ternary14_FALSE:
  mov32 cb, $1 ; enum element: CONDUCTOR
_ternary14_exit:
  pop d
  mov [d], b
; break; 
  jmp _switch13_exit ; case break
_switch13_case2:
; new_grid[y][x] = ELECTRON_TAIL; break; 
  mov d, _new_grid_data ; $new_grid
  push a
  push d
  mov d, _y ; $y
  mov b, [d]
  mov c, 0
  pop d
  mma 80 ; mov a, 80; mul a, b; add d, b
  push d
  mov d, _x ; $x
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov32 cb, $3 ; enum element: ELECTRON_TAIL
  pop d
  mov [d], b
; break; 
  jmp _switch13_exit ; case break
_switch13_case3:
; new_grid[y][x] = CONDUCTOR; break; 
  mov d, _new_grid_data ; $new_grid
  push a
  push d
  mov d, _y ; $y
  mov b, [d]
  mov c, 0
  pop d
  mma 80 ; mov a, 80; mul a, b; add d, b
  push d
  mov d, _x ; $x
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov32 cb, $1 ; enum element: CONDUCTOR
  pop d
  mov [d], b
; break; 
  jmp _switch13_exit ; case break
_switch13_exit:
_for8_update:
  mov d, _x ; $x
  mov b, [d]
  inc b
  mov d, _x ; $x
  mov [d], b
  jmp _for8_cond
_for8_exit:
_for7_update:
  mov d, _y ; $y
  mov b, [d]
  inc b
  mov d, _y ; $y
  mov [d], b
  jmp _for7_cond
_for7_exit:
; for (y = 0; y < 20; ++y) { 
_for15_init:
  mov d, _y ; $y
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
_for15_cond:
  mov d, _y ; $y
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000014
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for15_exit
_for15_block:
; for (x = 0; x < 40; ++x) { 
_for16_init:
  mov d, _x ; $x
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
_for16_cond:
  mov d, _x ; $x
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000028
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for16_exit
_for16_block:
; grid[y][x] = new_grid[y][x]; 
  mov d, _grid_data ; $grid
  push a
  push d
  mov d, _y ; $y
  mov b, [d]
  mov c, 0
  pop d
  mma 80 ; mov a, 80; mul a, b; add d, b
  push d
  mov d, _x ; $x
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov d, _new_grid_data ; $new_grid
  push a
  push d
  mov d, _y ; $y
  mov b, [d]
  mov c, 0
  pop d
  mma 80 ; mov a, 80; mul a, b; add d, b
  push d
  mov d, _x ; $x
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
_for16_update:
  mov d, _x ; $x
  mov b, [d]
  inc b
  mov d, _x ; $x
  mov [d], b
  jmp _for16_cond
_for16_exit:
_for15_update:
  mov d, _y ; $y
  mov b, [d]
  inc b
  mov d, _y ; $y
  mov [d], b
  jmp _for15_cond
_for15_exit:
; return; 
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
; --- END TEXT SEGMENT

; --- BEGIN DATA SEGMENT
_grid_data: .fill 1600, 0
_new_grid_data: .fill 1600, 0
_x: .fill 2, 0
_y: .fill 2, 0
_dx: .fill 2, 0
_dy: .fill 2, 0
_nx: .fill 2, 0
_ny: .fill 2, 0
_head_count: .fill 2, 0
_c: .fill 1, 0

_heap_top: .dw _heap
_heap: .db 0
; --- END DATA SEGMENT

.end
