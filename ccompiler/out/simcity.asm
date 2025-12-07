; --- FILENAME: programs/simcity.c
.include "lib/asm/kernel.exp"
.include "lib/asm/bios.exp"
.org text_org

; --- BEGIN TEXT SEGMENT
main:
  mov bp, $FFE0 ;
  mov sp, $FFE0 ; Make space for argc(2 bytes) and for 10 pointers in argv (local variables)
; char c; 
  sub sp, 1
; initialize_terrain(); 
; --- START FUNCTION CALL
  call initialize_terrain
; for(;;){ 
_for1_init:
_for1_cond:
_for1_block:
; display_map(); 
; --- START FUNCTION CALL
  call display_map
; move_cursor(0, 39); 
; --- START FUNCTION CALL
  mov32 cb, $00000027
  swp b
  push b
  mov32 cb, $00000000
  swp b
  push b
  call move_cursor
  add sp, 4
; --- END FUNCTION CALL
; printf("\nd: display map\nq: quit\nenter choice: "); 
; --- START FUNCTION CALL
  mov b, _s0 ; "\nd: display map\nq: quit\nenter choice: "
  swp b
  push b
  call printf
  add sp, 2
; --- END FUNCTION CALL
; c = getchar(); 
  lea d, [bp + 0] ; $c
  push d
; --- START FUNCTION CALL
  call getchar
  pop d
  mov [d], bl
; if(c == 'q'){ 
_if2_cond:
  lea d, [bp + 0] ; $c
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000071
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if2_exit
_if2_TRUE:
; return; 
  leave
  syscall sys_terminate_proc
  jmp _if2_exit
_if2_exit:
_for1_update:
  jmp _for1_cond
_for1_exit:
  syscall sys_terminate_proc

display_map:
  enter 0 ; (push bp; mov bp, sp)
; int rows, cols; 
  sub sp, 2
  sub sp, 2
; for(rows = 0; rows <  20        ; rows++){ 
_for3_init:
  lea d, [bp + -1] ; $rows
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
_for3_cond:
  lea d, [bp + -1] ; $rows
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
  je _for3_exit
_for3_block:
; for(cols = 0; cols <   38        ; cols++){ 
_for4_init:
  lea d, [bp + -3] ; $cols
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
_for4_cond:
  lea d, [bp + -3] ; $cols
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000026
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for4_exit
_for4_block:
; move_cursor(cols, rows); 
; --- START FUNCTION CALL
  lea d, [bp + -1] ; $rows
  mov b, [d]
  mov c, 0
  swp b
  push b
  lea d, [bp + -3] ; $cols
  mov b, [d]
  mov c, 0
  swp b
  push b
  call move_cursor
  add sp, 4
; --- END FUNCTION CALL
; if(map[rows][cols].zone_type == unzoned){ 
_if5_cond:
  mov d, _map_data ; $map
  push a
  push d
  lea d, [bp + -1] ; $rows
  mov b, [d]
  mov c, 0
  pop d
  mma 228 ; mov a, 228; mul a, b; add d, b
  push d
  lea d, [bp + -3] ; $cols
  mov b, [d]
  mov c, 0
  pop d
  mma 6 ; mov a, 6; mul a, b; add d, b
  pop a
  add d, 2
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $0 ; enum element: unzoned
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if5_else
_if5_TRUE:
; if(map[rows][cols].tile_type == land){ 
_if6_cond:
  mov d, _map_data ; $map
  push a
  push d
  lea d, [bp + -1] ; $rows
  mov b, [d]
  mov c, 0
  pop d
  mma 228 ; mov a, 228; mul a, b; add d, b
  push d
  lea d, [bp + -3] ; $cols
  mov b, [d]
  mov c, 0
  pop d
  mma 6 ; mov a, 6; mul a, b; add d, b
  pop a
  add d, 0
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $0 ; enum element: land
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if6_else
_if6_TRUE:
; putchar('.'); 
; --- START FUNCTION CALL
  mov32 cb, $0000002e
  push bl
  call putchar
  add sp, 1
; --- END FUNCTION CALL
  jmp _if6_exit
_if6_else:
; if(map[rows][cols].tile_type == water){ 
_if7_cond:
  mov d, _map_data ; $map
  push a
  push d
  lea d, [bp + -1] ; $rows
  mov b, [d]
  mov c, 0
  pop d
  mma 228 ; mov a, 228; mul a, b; add d, b
  push d
  lea d, [bp + -3] ; $cols
  mov b, [d]
  mov c, 0
  pop d
  mma 6 ; mov a, 6; mul a, b; add d, b
  pop a
  add d, 0
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $1 ; enum element: water
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if7_exit
_if7_TRUE:
; putchar('~'); 
; --- START FUNCTION CALL
  mov32 cb, $0000007e
  push bl
  call putchar
  add sp, 1
; --- END FUNCTION CALL
  jmp _if7_exit
_if7_exit:
_if6_exit:
  jmp _if5_exit
_if5_else:
; if(map[rows][cols].zone_type == residential){ 
_if8_cond:
  mov d, _map_data ; $map
  push a
  push d
  lea d, [bp + -1] ; $rows
  mov b, [d]
  mov c, 0
  pop d
  mma 228 ; mov a, 228; mul a, b; add d, b
  push d
  lea d, [bp + -3] ; $cols
  mov b, [d]
  mov c, 0
  pop d
  mma 6 ; mov a, 6; mul a, b; add d, b
  pop a
  add d, 2
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $1 ; enum element: residential
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if8_else
_if8_TRUE:
; putchar('R'); 
; --- START FUNCTION CALL
  mov32 cb, $00000052
  push bl
  call putchar
  add sp, 1
; --- END FUNCTION CALL
  jmp _if8_exit
_if8_else:
; if(map[rows][cols].zone_type == commercial){ 
_if9_cond:
  mov d, _map_data ; $map
  push a
  push d
  lea d, [bp + -1] ; $rows
  mov b, [d]
  mov c, 0
  pop d
  mma 228 ; mov a, 228; mul a, b; add d, b
  push d
  lea d, [bp + -3] ; $cols
  mov b, [d]
  mov c, 0
  pop d
  mma 6 ; mov a, 6; mul a, b; add d, b
  pop a
  add d, 2
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $2 ; enum element: commercial
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if9_else
_if9_TRUE:
; putchar('C'); 
; --- START FUNCTION CALL
  mov32 cb, $00000043
  push bl
  call putchar
  add sp, 1
; --- END FUNCTION CALL
  jmp _if9_exit
_if9_else:
; if(map[rows][cols].zone_type == industrial){ 
_if10_cond:
  mov d, _map_data ; $map
  push a
  push d
  lea d, [bp + -1] ; $rows
  mov b, [d]
  mov c, 0
  pop d
  mma 228 ; mov a, 228; mul a, b; add d, b
  push d
  lea d, [bp + -3] ; $cols
  mov b, [d]
  mov c, 0
  pop d
  mma 6 ; mov a, 6; mul a, b; add d, b
  pop a
  add d, 2
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $3 ; enum element: industrial
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if10_exit
_if10_TRUE:
; putchar('I'); 
; --- START FUNCTION CALL
  mov32 cb, $00000049
  push bl
  call putchar
  add sp, 1
; --- END FUNCTION CALL
  jmp _if10_exit
_if10_exit:
_if9_exit:
_if8_exit:
_if5_exit:
_for4_update:
  lea d, [bp + -3] ; $cols
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -3] ; $cols
  mov [d], b
  mov b, a
  jmp _for4_cond
_for4_exit:
; putchar('\n'); 
; --- START FUNCTION CALL
  mov32 cb, $0000000a
  push bl
  call putchar
  add sp, 1
; --- END FUNCTION CALL
_for3_update:
  lea d, [bp + -1] ; $rows
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -1] ; $rows
  mov [d], b
  mov b, a
  jmp _for3_cond
_for3_exit:
  leave
  ret

initialize_terrain:
  enter 0 ; (push bp; mov bp, sp)
; int i, j; 
  sub sp, 2
  sub sp, 2
; for(i = 0; i <  20        ; i++){ 
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
  mov32 cb, $00000014
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for11_exit
_for11_block:
; for(j = 0; j <   38        ; j++){ 
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
  mov32 cb, $00000026
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for12_exit
_for12_block:
; map[i][j].structure_type = -1; 
  mov d, _map_data ; $map
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 228 ; mov a, 228; mul a, b; add d, b
  push d
  lea d, [bp + -3] ; $j
  mov b, [d]
  mov c, 0
  pop d
  mma 6 ; mov a, 6; mul a, b; add d, b
  pop a
  add d, 4
  push d
  mov32 cb, $ffffffff
  pop d
  mov [d], b
; map[i][j].zone_type = unzoned; 
  mov d, _map_data ; $map
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 228 ; mov a, 228; mul a, b; add d, b
  push d
  lea d, [bp + -3] ; $j
  mov b, [d]
  mov c, 0
  pop d
  mma 6 ; mov a, 6; mul a, b; add d, b
  pop a
  add d, 2
  push d
  mov32 cb, $0 ; enum element: unzoned
  pop d
  mov [d], b
; map[i][j].tile_type = land; 
  mov d, _map_data ; $map
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 228 ; mov a, 228; mul a, b; add d, b
  push d
  lea d, [bp + -3] ; $j
  mov b, [d]
  mov c, 0
  pop d
  mma 6 ; mov a, 6; mul a, b; add d, b
  pop a
  add d, 0
  push d
  mov32 cb, $0 ; enum element: land
  pop d
  mov [d], b
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
; map[5][5].zone_type  = residential; 
  mov d, _map_data ; $map
  push a
  push d
  mov32 cb, $00000005
  pop d
  mma 228 ; mov a, 228; mul a, b; add d, b
  push d
  mov32 cb, $00000005
  pop d
  mma 6 ; mov a, 6; mul a, b; add d, b
  pop a
  add d, 2
  push d
  mov32 cb, $1 ; enum element: residential
  pop d
  mov [d], b
; map[5][6].zone_type  = residential; 
  mov d, _map_data ; $map
  push a
  push d
  mov32 cb, $00000005
  pop d
  mma 228 ; mov a, 228; mul a, b; add d, b
  push d
  mov32 cb, $00000006
  pop d
  mma 6 ; mov a, 6; mul a, b; add d, b
  pop a
  add d, 2
  push d
  mov32 cb, $1 ; enum element: residential
  pop d
  mov [d], b
; map[5][7].zone_type  = residential; 
  mov d, _map_data ; $map
  push a
  push d
  mov32 cb, $00000005
  pop d
  mma 228 ; mov a, 228; mul a, b; add d, b
  push d
  mov32 cb, $00000007
  pop d
  mma 6 ; mov a, 6; mul a, b; add d, b
  pop a
  add d, 2
  push d
  mov32 cb, $1 ; enum element: residential
  pop d
  mov [d], b
; map[6][5].zone_type  = commercial; 
  mov d, _map_data ; $map
  push a
  push d
  mov32 cb, $00000006
  pop d
  mma 228 ; mov a, 228; mul a, b; add d, b
  push d
  mov32 cb, $00000005
  pop d
  mma 6 ; mov a, 6; mul a, b; add d, b
  pop a
  add d, 2
  push d
  mov32 cb, $2 ; enum element: commercial
  pop d
  mov [d], b
; map[6][6].zone_type  = commercial; 
  mov d, _map_data ; $map
  push a
  push d
  mov32 cb, $00000006
  pop d
  mma 228 ; mov a, 228; mul a, b; add d, b
  push d
  mov32 cb, $00000006
  pop d
  mma 6 ; mov a, 6; mul a, b; add d, b
  pop a
  add d, 2
  push d
  mov32 cb, $2 ; enum element: commercial
  pop d
  mov [d], b
; map[6][7].zone_type  = commercial; 
  mov d, _map_data ; $map
  push a
  push d
  mov32 cb, $00000006
  pop d
  mma 228 ; mov a, 228; mul a, b; add d, b
  push d
  mov32 cb, $00000007
  pop d
  mma 6 ; mov a, 6; mul a, b; add d, b
  pop a
  add d, 2
  push d
  mov32 cb, $2 ; enum element: commercial
  pop d
  mov [d], b
; map[6][8].zone_type  = commercial; 
  mov d, _map_data ; $map
  push a
  push d
  mov32 cb, $00000006
  pop d
  mma 228 ; mov a, 228; mul a, b; add d, b
  push d
  mov32 cb, $00000008
  pop d
  mma 6 ; mov a, 6; mul a, b; add d, b
  pop a
  add d, 2
  push d
  mov32 cb, $2 ; enum element: commercial
  pop d
  mov [d], b
; map[10][5].zone_type = industrial; 
  mov d, _map_data ; $map
  push a
  push d
  mov32 cb, $0000000a
  pop d
  mma 228 ; mov a, 228; mul a, b; add d, b
  push d
  mov32 cb, $00000005
  pop d
  mma 6 ; mov a, 6; mul a, b; add d, b
  pop a
  add d, 2
  push d
  mov32 cb, $3 ; enum element: industrial
  pop d
  mov [d], b
; map[10][6].zone_type = industrial; 
  mov d, _map_data ; $map
  push a
  push d
  mov32 cb, $0000000a
  pop d
  mma 228 ; mov a, 228; mul a, b; add d, b
  push d
  mov32 cb, $00000006
  pop d
  mma 6 ; mov a, 6; mul a, b; add d, b
  pop a
  add d, 2
  push d
  mov32 cb, $3 ; enum element: industrial
  pop d
  mov [d], b
; map[11][6].zone_type = industrial; 
  mov d, _map_data ; $map
  push a
  push d
  mov32 cb, $0000000b
  pop d
  mma 228 ; mov a, 228; mul a, b; add d, b
  push d
  mov32 cb, $00000006
  pop d
  mma 6 ; mov a, 6; mul a, b; add d, b
  pop a
  add d, 2
  push d
  mov32 cb, $3 ; enum element: industrial
  pop d
  mov [d], b
; map[11][7].zone_type = industrial; 
  mov d, _map_data ; $map
  push a
  push d
  mov32 cb, $0000000b
  pop d
  mma 228 ; mov a, 228; mul a, b; add d, b
  push d
  mov32 cb, $00000007
  pop d
  mma 6 ; mov a, 6; mul a, b; add d, b
  pop a
  add d, 2
  push d
  mov32 cb, $3 ; enum element: industrial
  pop d
  mov [d], b
  leave
  ret

move_cursor:
  enter 0 ; (push bp; mov bp, sp)
; printf("\033[%d;%dH", y, x); 
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
  mov b, _s1 ; "\033[%d;%dH"
  swp b
  push b
  call printf
  add sp, 6
; --- END FUNCTION CALL
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
_for13_init:
_for13_cond:
_for13_block:
; if(!*format_p) break; 
_if14_cond:
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
  je _if14_else
_if14_TRUE:
; break; 
  jmp _for13_exit ; for break
  jmp _if14_exit
_if14_else:
; if(*format_p == '%'){ 
_if15_cond:
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
  je _if15_else
_if15_TRUE:
; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  dec b
; switch(*format_p){ 
_switch16_expr:
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
_switch16_comparisons:
  cmp bl, $6c
  je _switch16_case0
  cmp bl, $4c
  je _switch16_case1
  cmp bl, $64
  je _switch16_case2
  cmp bl, $69
  je _switch16_case3
  cmp bl, $75
  je _switch16_case4
  cmp bl, $78
  je _switch16_case5
  cmp bl, $63
  je _switch16_case6
  cmp bl, $73
  je _switch16_case7
  jmp _switch16_default
  jmp _switch16_exit
_switch16_case0:
_switch16_case1:
; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  dec b
; if(*format_p == 'd' || *format_p == 'i') 
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
  je _if17_else
_if17_TRUE:
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
  jmp _if17_exit
_if17_else:
; if(*format_p == 'u') 
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
  mov32 cb, $00000075
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if18_else
_if18_TRUE:
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
  jmp _if18_exit
_if18_else:
; if(*format_p == 'x') 
_if19_cond:
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
  je _if19_else
_if19_TRUE:
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
  jmp _if19_exit
_if19_else:
; err("Unexpected format in printf."); 
; --- START FUNCTION CALL
  mov b, _s2 ; "Unexpected format in printf."
  swp b
  push b
  call err
  add sp, 2
; --- END FUNCTION CALL
_if19_exit:
_if18_exit:
_if17_exit:
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
  jmp _switch16_exit ; case break
_switch16_case2:
_switch16_case3:
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
  jmp _switch16_exit ; case break
_switch16_case4:
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
  jmp _switch16_exit ; case break
_switch16_case5:
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
  jmp _switch16_exit ; case break
_switch16_case6:
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
; p = p + 1; 
  lea d, [bp + -1] ; $p
  push d
  lea d, [bp + -1] ; $p
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
; break; 
  jmp _switch16_exit ; case break
_switch16_case7:
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
  jmp _switch16_exit ; case break
_switch16_default:
; print("Error: Unknown argument type.\n"); 
; --- START FUNCTION CALL
  mov b, _s3 ; "Error: Unknown argument type.\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
_switch16_exit:
; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  dec b
  jmp _if15_exit
_if15_else:
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
; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  dec b
_if15_exit:
_if14_exit:
_for13_update:
  jmp _for13_cond
_for13_exit:
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
  cmp32 ga, cb
  slt ; <
  pop g
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if20_else
_if20_TRUE:
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
  jmp _if20_exit
_if20_else:
; if (num == 0) { 
_if21_cond:
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
  cmp32 ga, cb
  seq ; ==
  pop g
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if21_exit
_if21_TRUE:
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
  jmp _if21_exit
_if21_exit:
_if20_exit:
; while (num > 0) { 
_while22_cond:
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
  cmp32 ga, cb
  sgt
  pop g
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _while22_exit
_while22_block:
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
  jmp _while22_cond
_while22_exit:
; while (i > 0) { 
_while29_cond:
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
  je _while29_exit
_while29_block:
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
  jmp _while29_cond
_while29_exit:
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
_if30_cond:
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
  cmp32 ga, cb
  seq ; ==
  pop g
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
; while (num > 0) { 
_while31_cond:
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
  cmp32 ga, cb
  sgu
  pop g
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _while31_exit
_while31_block:
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
  jmp _while31_cond
_while31_exit:
; while (i > 0) { 
_while38_cond:
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
  je _while38_exit
_while38_block:
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
  jmp _while38_cond
_while38_exit:
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
_if39_cond:
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
  je _if39_else
_if39_TRUE:
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
  jmp _if39_exit
_if39_else:
; if (num == 0) { 
_if40_cond:
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
  je _if40_exit
_if40_TRUE:
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
  jmp _if40_exit
_if40_exit:
_if39_exit:
; while (num > 0) { 
_while41_cond:
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
  je _while41_exit
_while41_block:
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
  jmp _while41_cond
_while41_exit:
; while (i > 0) { 
_while48_cond:
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
  je _while48_exit
_while48_block:
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
  jmp _while48_cond
_while48_exit:
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
_if49_cond:
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
  je _if49_exit
_if49_TRUE:
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
  jmp _if49_exit
_if49_exit:
; while (num > 0) { 
_while50_cond:
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
  je _while50_exit
_while50_block:
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
  jmp _while50_cond
_while50_exit:
; while (i > 0) { 
_while57_cond:
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
  je _while57_exit
_while57_block:
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
  jmp _while57_cond
_while57_exit:
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
; --- END TEXT SEGMENT

; --- BEGIN DATA SEGMENT
_map_data: .fill 4560, 0
_s0: .db "\nd: display map\nq: quit\nenter choice: ", 0
_s1: .db "\033[%d;%dH", 0
_s2: .db "Unexpected format in printf.", 0
_s3: .db "Error: Unknown argument type.\n", 0

_heap_top: .dw _heap
_heap: .db 0
; --- END DATA SEGMENT

.end
