; --- FILENAME: programs/balls.c
; --- DATE:     29-07-2025 at 00:52:50
.include "lib/asm/kernel.exp"
.include "lib/asm/bios.exp"

; --- BEGIN TEXT SEGMENT
.org text_org
main:
  mov bp, $FFE0 ;
  mov sp, $FFE0 ; Make space for argc(2 bytes) and for 10 pointers in argv (local variables)
; int i; 
  sub sp, 2
; printf("\033[2J"); // clear screen once 
; --- START FUNCTION CALL
  mov b, _s0 ; "\033[2J"
  swp b
  push b
  call printf
  add sp, 2
; --- END FUNCTION CALL
; while (1) { 
_while1_cond:
  mov32 cb, $00000001
  cmp b, 0
  je _while1_exit
_while1_block:
; i = 0; 
  lea d, [bp + -1] ; $i
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
; while (i <  4         ) { 
_while2_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000004
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _while2_exit
_while2_block:
; erase_char(balls[i].old_x, balls[i].old_y); 
; --- START FUNCTION CALL
  mov d, _balls_data ; $balls
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 12 ; mov a, 12; mul a, b; add d, b
  pop a
  add d, 10
  mov b, [d]
  mov c, 0
  swp b
  push b
  mov d, _balls_data ; $balls
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 12 ; mov a, 12; mul a, b; add d, b
  pop a
  add d, 8
  mov b, [d]
  mov c, 0
  swp b
  push b
  call erase_char
  add sp, 4
; --- END FUNCTION CALL
; i = i + 1; 
  lea d, [bp + -1] ; $i
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
  mov [d], b
  jmp _while2_cond
_while2_exit:
; update_positions(); 
; --- START FUNCTION CALL
  call update_positions
; i = 0; 
  lea d, [bp + -1] ; $i
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
; while (i <  4         ) { 
_while3_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000004
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _while3_exit
_while3_block:
; draw_char(balls[i].x, balls[i].y, 'O'); 
; --- START FUNCTION CALL
  mov32 cb, $0000004f
  push bl
  mov d, _balls_data ; $balls
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 12 ; mov a, 12; mul a, b; add d, b
  pop a
  add d, 2
  mov b, [d]
  mov c, 0
  swp b
  push b
  mov d, _balls_data ; $balls
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 12 ; mov a, 12; mul a, b; add d, b
  pop a
  add d, 0
  mov b, [d]
  mov c, 0
  swp b
  push b
  call draw_char
  add sp, 5
; --- END FUNCTION CALL
; i = i + 1; 
  lea d, [bp + -1] ; $i
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
  mov [d], b
  jmp _while3_cond
_while3_exit:
  jmp _while1_cond
_while1_exit:
; return 0; 
  mov32 cb, $00000000
  leave
  syscall sys_terminate_proc

gotoxy:
  enter 0 ; (push bp; mov bp, sp)
; printf("\033[%d;%dH", row + 1, col + 1); 
; --- START FUNCTION CALL
  lea d, [bp + 7] ; $col
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
  mov b, _s1 ; "\033[%d;%dH"
  swp b
  push b
  call printf
  add sp, 6
; --- END FUNCTION CALL
  leave
  ret

erase_char:
  enter 0 ; (push bp; mov bp, sp)
; if (x >= 0 && x <   40      && y >= 0 && y <  40      ) { 
_if4_cond:
  lea d, [bp + 5] ; $x
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
  lea d, [bp + 5] ; $x
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
  lea d, [bp + 7] ; $y
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
  lea d, [bp + 7] ; $y
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
  pop a
; --- END LOGICAL AND
  cmp b, 0
  je _if4_exit
_if4_TRUE:
; gotoxy(y, x); 
; --- START FUNCTION CALL
  lea d, [bp + 5] ; $x
  mov b, [d]
  mov c, 0
  swp b
  push b
  lea d, [bp + 7] ; $y
  mov b, [d]
  mov c, 0
  swp b
  push b
  call gotoxy
  add sp, 4
; --- END FUNCTION CALL
; putchar(' '); 
; --- START FUNCTION CALL
  mov32 cb, $00000020
  push bl
  call putchar
  add sp, 1
; --- END FUNCTION CALL
  jmp _if4_exit
_if4_exit:
  leave
  ret

draw_char:
  enter 0 ; (push bp; mov bp, sp)
; if (x >= 0 && x <   40      && y >= 0 && y <  40      ) { 
_if5_cond:
  lea d, [bp + 5] ; $x
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
  lea d, [bp + 5] ; $x
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
  lea d, [bp + 7] ; $y
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
  lea d, [bp + 7] ; $y
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
  pop a
; --- END LOGICAL AND
  cmp b, 0
  je _if5_exit
_if5_TRUE:
; gotoxy(y, x); 
; --- START FUNCTION CALL
  lea d, [bp + 5] ; $x
  mov b, [d]
  mov c, 0
  swp b
  push b
  lea d, [bp + 7] ; $y
  mov b, [d]
  mov c, 0
  swp b
  push b
  call gotoxy
  add sp, 4
; --- END FUNCTION CALL
; putchar(c); 
; --- START FUNCTION CALL
  lea d, [bp + 9] ; $c
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push bl
  call putchar
  add sp, 1
; --- END FUNCTION CALL
  jmp _if5_exit
_if5_exit:
  leave
  ret

update_positions:
  enter 0 ; (push bp; mov bp, sp)
; int i; 
  sub sp, 2
; int j; 
  sub sp, 2
; i = 0; 
  lea d, [bp + -1] ; $i
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
; while (i <  4         ) { 
_while6_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000004
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _while6_exit
_while6_block:
; balls[i].old_x = balls[i].x; 
  mov d, _balls_data ; $balls
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 12 ; mov a, 12; mul a, b; add d, b
  pop a
  add d, 8
  push d
  mov d, _balls_data ; $balls
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 12 ; mov a, 12; mul a, b; add d, b
  pop a
  add d, 0
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
; balls[i].old_y = balls[i].y; 
  mov d, _balls_data ; $balls
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 12 ; mov a, 12; mul a, b; add d, b
  pop a
  add d, 10
  push d
  mov d, _balls_data ; $balls
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 12 ; mov a, 12; mul a, b; add d, b
  pop a
  add d, 2
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
; balls[i].x = balls[i].x + balls[i].vx; 
  mov d, _balls_data ; $balls
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 12 ; mov a, 12; mul a, b; add d, b
  pop a
  add d, 0
  push d
  mov d, _balls_data ; $balls
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 12 ; mov a, 12; mul a, b; add d, b
  pop a
  add d, 0
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov d, _balls_data ; $balls
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 12 ; mov a, 12; mul a, b; add d, b
  pop a
  add d, 4
  mov b, [d]
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; balls[i].y = balls[i].y + balls[i].vy; 
  mov d, _balls_data ; $balls
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 12 ; mov a, 12; mul a, b; add d, b
  pop a
  add d, 2
  push d
  mov d, _balls_data ; $balls
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 12 ; mov a, 12; mul a, b; add d, b
  pop a
  add d, 2
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov d, _balls_data ; $balls
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 12 ; mov a, 12; mul a, b; add d, b
  pop a
  add d, 6
  mov b, [d]
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; if (balls[i].x <= 0 || balls[i].x >=   40      - 1) { 
_if7_cond:
  mov d, _balls_data ; $balls
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 12 ; mov a, 12; mul a, b; add d, b
  pop a
  add d, 0
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
; --- START LOGICAL OR
  push a
  mov a, b
  mov d, _balls_data ; $balls
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 12 ; mov a, 12; mul a, b; add d, b
  pop a
  add d, 0
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000028
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000001
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  cmp a, b
  sge ; >=
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  cmp b, 0
  je _if7_exit
_if7_TRUE:
; balls[i].vx = 0 - balls[i].vx; 
  mov d, _balls_data ; $balls
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 12 ; mov a, 12; mul a, b; add d, b
  pop a
  add d, 4
  push d
  mov32 cb, $00000000
; --- START TERMS
  push a
  mov a, b
  mov d, _balls_data ; $balls
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 12 ; mov a, 12; mul a, b; add d, b
  pop a
  add d, 4
  mov b, [d]
  mov c, 0
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
  jmp _if7_exit
_if7_exit:
; if (balls[i].y <= 0 || balls[i].y >=  40       - 1) { 
_if8_cond:
  mov d, _balls_data ; $balls
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 12 ; mov a, 12; mul a, b; add d, b
  pop a
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
; --- START LOGICAL OR
  push a
  mov a, b
  mov d, _balls_data ; $balls
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 12 ; mov a, 12; mul a, b; add d, b
  pop a
  add d, 2
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000028
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000001
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  cmp a, b
  sge ; >=
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  cmp b, 0
  je _if8_exit
_if8_TRUE:
; balls[i].vy = 0 - balls[i].vy; 
  mov d, _balls_data ; $balls
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 12 ; mov a, 12; mul a, b; add d, b
  pop a
  add d, 6
  push d
  mov32 cb, $00000000
; --- START TERMS
  push a
  mov a, b
  mov d, _balls_data ; $balls
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 12 ; mov a, 12; mul a, b; add d, b
  pop a
  add d, 6
  mov b, [d]
  mov c, 0
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
  jmp _if8_exit
_if8_exit:
; i = i + 1; 
  lea d, [bp + -1] ; $i
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
  mov [d], b
  jmp _while6_cond
_while6_exit:
; i = 0; 
  lea d, [bp + -1] ; $i
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
; while (i <  4         ) { 
_while9_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000004
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _while9_exit
_while9_block:
; j = i + 1; 
  lea d, [bp + -3] ; $j
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
  mov [d], b
; while (j <  4         ) { 
_while10_cond:
  lea d, [bp + -3] ; $j
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000004
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _while10_exit
_while10_block:
; if (balls[i].x == balls[j].x && balls[i].y == balls[j].y) { 
_if11_cond:
  mov d, _balls_data ; $balls
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 12 ; mov a, 12; mul a, b; add d, b
  pop a
  add d, 0
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov d, _balls_data ; $balls
  push a
  push d
  lea d, [bp + -3] ; $j
  mov b, [d]
  mov c, 0
  pop d
  mma 12 ; mov a, 12; mul a, b; add d, b
  pop a
  add d, 0
  mov b, [d]
  mov c, 0
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
; --- START LOGICAL AND
  push a
  mov a, b
  mov d, _balls_data ; $balls
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 12 ; mov a, 12; mul a, b; add d, b
  pop a
  add d, 2
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov d, _balls_data ; $balls
  push a
  push d
  lea d, [bp + -3] ; $j
  mov b, [d]
  mov c, 0
  pop d
  mma 12 ; mov a, 12; mul a, b; add d, b
  pop a
  add d, 2
  mov b, [d]
  mov c, 0
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
; int temp; 
  sub sp, 2
; temp = balls[i].vx; 
  lea d, [bp + -5] ; $temp
  push d
  mov d, _balls_data ; $balls
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 12 ; mov a, 12; mul a, b; add d, b
  pop a
  add d, 4
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
; balls[i].vx = balls[j].vx; 
  mov d, _balls_data ; $balls
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 12 ; mov a, 12; mul a, b; add d, b
  pop a
  add d, 4
  push d
  mov d, _balls_data ; $balls
  push a
  push d
  lea d, [bp + -3] ; $j
  mov b, [d]
  mov c, 0
  pop d
  mma 12 ; mov a, 12; mul a, b; add d, b
  pop a
  add d, 4
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
; balls[j].vx = temp; 
  mov d, _balls_data ; $balls
  push a
  push d
  lea d, [bp + -3] ; $j
  mov b, [d]
  mov c, 0
  pop d
  mma 12 ; mov a, 12; mul a, b; add d, b
  pop a
  add d, 4
  push d
  lea d, [bp + -5] ; $temp
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
; temp = balls[i].vy; 
  lea d, [bp + -5] ; $temp
  push d
  mov d, _balls_data ; $balls
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 12 ; mov a, 12; mul a, b; add d, b
  pop a
  add d, 6
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
; balls[i].vy = balls[j].vy; 
  mov d, _balls_data ; $balls
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 12 ; mov a, 12; mul a, b; add d, b
  pop a
  add d, 6
  push d
  mov d, _balls_data ; $balls
  push a
  push d
  lea d, [bp + -3] ; $j
  mov b, [d]
  mov c, 0
  pop d
  mma 12 ; mov a, 12; mul a, b; add d, b
  pop a
  add d, 6
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
; balls[j].vy = temp; 
  mov d, _balls_data ; $balls
  push a
  push d
  lea d, [bp + -3] ; $j
  mov b, [d]
  mov c, 0
  pop d
  mma 12 ; mov a, 12; mul a, b; add d, b
  pop a
  add d, 6
  push d
  lea d, [bp + -5] ; $temp
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
  jmp _if11_exit
_if11_exit:
; j = j + 1; 
  lea d, [bp + -3] ; $j
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
  mov [d], b
  jmp _while10_cond
_while10_exit:
; i = i + 1; 
  lea d, [bp + -1] ; $i
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
  mov [d], b
  jmp _while9_cond
_while9_exit:
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
_for12_init:
_for12_cond:
_for12_block:
; if(!*format_p) break; 
_if13_cond:
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
  je _if13_else
_if13_TRUE:
; break; 
  jmp _for12_exit ; for break
  jmp _if13_exit
_if13_else:
; if(*format_p == '%'){ 
_if14_cond:
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
  je _if14_else
_if14_TRUE:
; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  dec b
; switch(*format_p){ 
_switch15_expr:
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
_switch15_comparisons:
  cmp bl, $6c
  je _switch15_case0
  cmp bl, $4c
  je _switch15_case1
  cmp bl, $64
  je _switch15_case2
  cmp bl, $69
  je _switch15_case3
  cmp bl, $75
  je _switch15_case4
  cmp bl, $78
  je _switch15_case5
  cmp bl, $63
  je _switch15_case6
  cmp bl, $73
  je _switch15_case7
  jmp _switch15_default
  jmp _switch15_exit
_switch15_case0:
_switch15_case1:
; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  dec b
; if(*format_p == 'd' || *format_p == 'i') 
_if16_cond:
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
  je _if16_else
_if16_TRUE:
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
  jmp _if16_exit
_if16_else:
; if(*format_p == 'u') 
_if17_cond:
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
  je _if17_else
_if17_TRUE:
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
  jmp _if17_exit
_if17_else:
; if(*format_p == 'x') 
_if18_cond:
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
  je _if18_else
_if18_TRUE:
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
  jmp _if18_exit
_if18_else:
; err("Unexpected format in printf."); 
; --- START FUNCTION CALL
  mov b, _s2 ; "Unexpected format in printf."
  swp b
  push b
  call err
  add sp, 2
; --- END FUNCTION CALL
_if18_exit:
_if17_exit:
_if16_exit:
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
  jmp _switch15_exit ; case break
_switch15_case2:
_switch15_case3:
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
  jmp _switch15_exit ; case break
_switch15_case4:
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
  jmp _switch15_exit ; case break
_switch15_case5:
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
  jmp _switch15_exit ; case break
_switch15_case6:
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
  jmp _switch15_exit ; case break
_switch15_case7:
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
  jmp _switch15_exit ; case break
_switch15_default:
; print("Error: Unknown argument type.\n"); 
; --- START FUNCTION CALL
  mov b, _s3 ; "Error: Unknown argument type.\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
_switch15_exit:
  jmp _if14_exit
_if14_else:
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
_if14_exit:
_if13_exit:
; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  dec b
_for12_update:
  jmp _for12_cond
_for12_exit:
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
_if19_cond:
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
  je _if19_else
_if19_TRUE:
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
  jmp _if19_exit
_if19_else:
; if (num == 0) { 
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
_if19_exit:
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
  sgt
  pop g
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _while21_exit
_while21_block:
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
  jmp _while28_cond
_while28_exit:
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
_if29_cond:
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
  je _if29_exit
_if29_TRUE:
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
  jmp _if29_exit
_if29_exit:
; while (num > 0) { 
_while30_cond:
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
  je _while30_exit
_while30_block:
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
  jmp _while30_cond
_while30_exit:
; while (i > 0) { 
_while37_cond:
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
  je _while37_exit
_while37_block:
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
  jmp _while37_cond
_while37_exit:
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
_if38_cond:
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
  je _if38_else
_if38_TRUE:
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
  jmp _if38_exit
_if38_else:
; if (num == 0) { 
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
_if38_exit:
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
  sgt ; >
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _while40_exit
_while40_block:
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
  jmp _while47_cond
_while47_exit:
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
_if48_cond:
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
  je _while49_exit
_while49_block:
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
  jmp _while49_cond
_while49_exit:
; while (i > 0) { 
_while56_cond:
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
  je _while56_exit
_while56_block:
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
  jmp _while56_cond
_while56_exit:
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
_balls_data: .dw $0005
.dw $0005
.dw $0001
.dw $0001
.dw $0005
.dw $0005
.dw $001e
.dw $0003
.dw $ffff
.dw $0001
.dw $001e
.dw $0003
.dw $000a
.dw $0014
.dw $0001

.db .dw $ffff
.dw $000a
.dw $0014
.dw $0019
.dw $000f
.dw $ffff
.dw $ffff
.dw $0019
.dw $000f

_s0: .db "\033[2J", 0
_s1: .db "\033[%d;%dH", 0
_s2: .db "Unexpected format in printf.", 0
_s3: .db "Error: Unknown argument type.\n", 0

_heap_top: .dw _heap
_heap: .db 0
; --- END DATA SEGMENT

.end
