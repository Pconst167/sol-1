; --- FILENAME: programs/pascal.c
; --- DATE:     24-07-2025 at 19:22:17
.include "lib/asm/kernel.exp"
.include "lib/asm/bios.exp"

; --- BEGIN TEXT SEGMENT
.org text_org
main:
  mov bp, $FFE0 ;
  mov sp, $FFE0 ; Make space for argc(2 bytes) and for 10 pointers in argv (local variables)
; coef = 1; 
  mov d, _coef ; $coef
  push d
  mov32 cb, $00000001
  pop d
  mov [d], b
; print("Enter the number of rows: "); 
; --- START FUNCTION CALL
  mov b, _s0 ; "Enter the number of rows: "
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; scanf("%d", &rows); 
; --- START FUNCTION CALL
  mov d, _rows ; $rows
  mov b, d
  swp b
  push b
  mov b, _s1 ; "%d"
  swp b
  push b
  call scanf
  add sp, 4
; --- END FUNCTION CALL
; for (i = 0; i < rows; i=i+1) { 
_for1_init:
  mov d, _i ; $i
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
_for1_cond:
  mov d, _i ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov d, _rows ; $rows
  mov b, [d]
  mov c, 0
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for1_exit
_for1_block:
; for (space = 1; space <= rows - i; space=space+1) print("\n"); 
_for2_init:
  mov d, _space ; $space
  push d
  mov32 cb, $00000001
  pop d
  mov [d], b
_for2_cond:
  mov d, _space ; $space
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov d, _rows ; $rows
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov d, _i ; $i
  mov b, [d]
  mov c, 0
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for2_exit
_for2_block:
; print("\n"); 
; --- START FUNCTION CALL
  mov b, _s2 ; "\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
_for2_update:
  mov d, _space ; $space
  push d
  mov d, _space ; $space
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
  jmp _for2_cond
_for2_exit:
; for (j = 0; j <= i; j=j+1){ 
_for3_init:
  mov d, _j ; $j
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
_for3_cond:
  mov d, _j ; $j
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov d, _i ; $i
  mov b, [d]
  mov c, 0
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for3_exit
_for3_block:
; if (j == 0 || i == 0) 
_if4_cond:
  mov d, _j ; $j
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
; --- START LOGICAL OR
  push a
  mov a, b
  mov d, _i ; $i
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
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  cmp b, 0
  je _if4_else
_if4_TRUE:
; coef = 1; 
  mov d, _coef ; $coef
  push d
  mov32 cb, $00000001
  pop d
  mov [d], b
  jmp _if4_exit
_if4_else:
; coef = coef * (i - j + 1) / j; 
  mov d, _coef ; $coef
  push d
  mov d, _coef ; $coef
  mov b, [d]
  mov c, 0
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov d, _i ; $i
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov d, _j ; $j
  mov b, [d]
  mov c, 0
  sub a, b
  mov b, a
  mov a, b
  mov32 cb, $00000001
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
  jz skip_invert_a_7  
  neg a 
skip_invert_a_7:   
  swp b
  test bl, $80  
  swp b
  jz skip_invert_b_7  
  neg b 
skip_invert_b_7:   
  mul a, b ; *
  mov g, a
  mov a, b
  pop bl
  test bl, $80
  jz _same_signs_7
  mov bl, al
  not a
  neg b
  adc a, 0
  mov g, a
  mov a, b
_same_signs_7:
  mov d, _j ; $j
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
_if4_exit:
; printf("%u", coef); 
; --- START FUNCTION CALL
  mov d, _coef ; $coef
  mov b, [d]
  mov c, 0
  swp b
  push b
  mov b, _s3 ; "%u"
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
; printf(" "); 
; --- START FUNCTION CALL
  mov b, _s4 ; " "
  swp b
  push b
  call printf
  add sp, 2
; --- END FUNCTION CALL
_for3_update:
  mov d, _j ; $j
  push d
  mov d, _j ; $j
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
  jmp _for3_cond
_for3_exit:
_for1_update:
  mov d, _i ; $i
  push d
  mov d, _i ; $i
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
  jmp _for1_cond
_for1_exit:
; return; 
  leave
  syscall sys_terminate_proc

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

scanf:
  enter 0 ; (push bp; mov bp, sp)
; char *p, *format_p; 
  sub sp, 2
  sub sp, 2
; char c; 
  sub sp, 1
; int i; 
  sub sp, 2
; char input_string[ 512                     ]; 
  sub sp, 512
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
_for9_init:
_for9_cond:
_for9_block:
; if(!*format_p) break; 
_if10_cond:
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
  je _if10_else
_if10_TRUE:
; break; 
  jmp _for9_exit ; for break
  jmp _if10_exit
_if10_else:
; if(*format_p == '%'){ 
_if11_cond:
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
  je _if11_else
_if11_TRUE:
; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  dec b
; switch(*format_p){ 
_switch12_expr:
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
_switch12_comparisons:
  cmp bl, $6c
  je _switch12_case0
  cmp bl, $4c
  je _switch12_case1
  cmp bl, $64
  je _switch12_case2
  cmp bl, $69
  je _switch12_case3
  cmp bl, $75
  je _switch12_case4
  cmp bl, $78
  je _switch12_case5
  cmp bl, $63
  je _switch12_case6
  cmp bl, $73
  je _switch12_case7
  jmp _switch12_default
  jmp _switch12_exit
_switch12_case0:
_switch12_case1:
; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  dec b
; if(*format_p == 'd' || *format_p == 'i'); 
_if13_cond:
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
  je _if13_else
_if13_TRUE:
; ; 
  jmp _if13_exit
_if13_else:
; if(*format_p == 'u'); 
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
  mov32 cb, $00000075
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if14_else
_if14_TRUE:
; ; 
  jmp _if14_exit
_if14_else:
; if(*format_p == 'x'); 
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
  mov32 cb, $00000078
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if15_else
_if15_TRUE:
; ; 
  jmp _if15_exit
_if15_else:
; err("Unexpected format in printf."); 
; --- START FUNCTION CALL
  mov b, _s5 ; "Unexpected format in printf."
  swp b
  push b
  call err
  add sp, 2
; --- END FUNCTION CALL
_if15_exit:
_if14_exit:
_if13_exit:
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
  jmp _switch12_exit ; case break
_switch12_case2:
_switch12_case3:
; i = scann(); 
  lea d, [bp + -6] ; $i
  push d
; --- START FUNCTION CALL
  call scann
  pop d
  mov [d], b
; **(int **)p = i; 
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov c, 0
  mov d, b
  mov b, [d]
  push b
  lea d, [bp + -6] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
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
  jmp _switch12_exit ; case break
_switch12_case4:
; i = scann(); 
  lea d, [bp + -6] ; $i
  push d
; --- START FUNCTION CALL
  call scann
  pop d
  mov [d], b
; **(int **)p = i; 
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov c, 0
  mov d, b
  mov b, [d]
  push b
  lea d, [bp + -6] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
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
  jmp _switch12_exit ; case break
_switch12_case5:
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
  jmp _switch12_exit ; case break
_switch12_case6:
; c = getchar(); 
  lea d, [bp + -4] ; $c
  push d
; --- START FUNCTION CALL
  call getchar
  pop d
  mov [d], bl
; **(char **)p = *(char *)c; 
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov c, 0
  mov d, b
  mov b, [d]
  push b
  lea d, [bp + -4] ; $c
  mov bl, [d]
  mov bh, 0
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mov [d], b
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
  jmp _switch12_exit ; case break
_switch12_case7:
; gets(input_string); 
; --- START FUNCTION CALL
  lea d, [bp + -518] ; $input_string
  mov b, d
  mov c, 0
  swp b
  push b
  call gets
  add sp, 2
; --- END FUNCTION CALL
; strcpy(*(char **)p, input_string); 
; --- START FUNCTION CALL
  lea d, [bp + -518] ; $input_string
  mov b, d
  mov c, 0
  swp b
  push b
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov c, 0
  mov d, b
  mov b, [d]
  swp b
  push b
  call strcpy
  add sp, 4
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
  jmp _switch12_exit ; case break
_switch12_default:
; print("Error: Unknown argument type.\n"); 
; --- START FUNCTION CALL
  mov b, _s6 ; "Error: Unknown argument type.\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
_switch12_exit:
; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  dec b
  jmp _if11_exit
_if11_else:
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
_if11_exit:
_if10_exit:
_for9_update:
  jmp _for9_cond
_for9_exit:
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
_while16_cond:
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
  je _while16_exit
_while16_block:
; length++; 
  lea d, [bp + -1] ; $length
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -1] ; $length
  mov [d], b
  mov b, a
  jmp _while16_cond
_while16_exit:
; return length; 
  lea d, [bp + -1] ; $length
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
_while17_cond:
  lea d, [bp + -1] ; $psrc
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  cmp b, 0
  je _while17_exit
_while17_block:
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
  jmp _while17_cond
_while17_exit:
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
_for18_init:
_for18_cond:
_for18_block:
; if(!*format_p) break; 
_if19_cond:
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
  je _if19_else
_if19_TRUE:
; break; 
  jmp _for18_exit ; for break
  jmp _if19_exit
_if19_else:
; if(*format_p == '%'){ 
_if20_cond:
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
  je _if20_else
_if20_TRUE:
; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  dec b
; switch(*format_p){ 
_switch21_expr:
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
_switch21_comparisons:
  cmp bl, $6c
  je _switch21_case0
  cmp bl, $4c
  je _switch21_case1
  cmp bl, $64
  je _switch21_case2
  cmp bl, $69
  je _switch21_case3
  cmp bl, $75
  je _switch21_case4
  cmp bl, $78
  je _switch21_case5
  cmp bl, $63
  je _switch21_case6
  cmp bl, $73
  je _switch21_case7
  jmp _switch21_default
  jmp _switch21_exit
_switch21_case0:
_switch21_case1:
; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  dec b
; if(*format_p == 'd' || *format_p == 'i') 
_if22_cond:
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
  je _if22_else
_if22_TRUE:
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
  jmp _if22_exit
_if22_else:
; if(*format_p == 'u') 
_if23_cond:
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
  je _if23_else
_if23_TRUE:
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
  jmp _if23_exit
_if23_else:
; if(*format_p == 'x') 
_if24_cond:
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
  je _if24_else
_if24_TRUE:
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
  jmp _if24_exit
_if24_else:
; err("Unexpected format in printf."); 
; --- START FUNCTION CALL
  mov b, _s5 ; "Unexpected format in printf."
  swp b
  push b
  call err
  add sp, 2
; --- END FUNCTION CALL
_if24_exit:
_if23_exit:
_if22_exit:
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
  jmp _switch21_exit ; case break
_switch21_case2:
_switch21_case3:
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
  jmp _switch21_exit ; case break
_switch21_case4:
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
  jmp _switch21_exit ; case break
_switch21_case5:
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
  jmp _switch21_exit ; case break
_switch21_case6:
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
  jmp _switch21_exit ; case break
_switch21_case7:
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
  jmp _switch21_exit ; case break
_switch21_default:
; print("Error: Unknown argument type.\n"); 
; --- START FUNCTION CALL
  mov b, _s6 ; "Error: Unknown argument type.\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
_switch21_exit:
  jmp _if20_exit
_if20_else:
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
_if20_exit:
_if19_exit:
; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  dec b
_for18_update:
  jmp _for18_cond
_for18_exit:
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
_if25_cond:
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
  je _if25_else
_if25_TRUE:
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
  jmp _if25_exit
_if25_else:
; if (num == 0) { 
_if26_cond:
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
  je _if26_exit
_if26_TRUE:
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
  jmp _if26_exit
_if26_exit:
_if25_exit:
; while (num > 0) { 
_while27_cond:
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
  je _while27_exit
_while27_block:
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
  jmp _while27_cond
_while27_exit:
; while (i > 0) { 
_while34_cond:
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
  je _while34_exit
_while34_block:
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
  jmp _while34_cond
_while34_exit:
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
_if35_cond:
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
  je _if35_exit
_if35_TRUE:
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
  jmp _if35_exit
_if35_exit:
; while (num > 0) { 
_while36_cond:
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
  je _while36_exit
_while36_block:
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
  jmp _while36_cond
_while36_exit:
; while (i > 0) { 
_while43_cond:
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
  je _while43_exit
_while43_block:
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
  jmp _while43_cond
_while43_exit:
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
_if44_cond:
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
  je _if44_else
_if44_TRUE:
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
  jmp _if44_exit
_if44_else:
; if (num == 0) { 
_if45_cond:
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
  je _if45_exit
_if45_TRUE:
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
  jmp _if45_exit
_if45_exit:
_if44_exit:
; while (num > 0) { 
_while46_cond:
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
  je _while46_exit
_while46_block:
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
  jmp _while46_cond
_while46_exit:
; while (i > 0) { 
_while53_cond:
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
  je _while53_exit
_while53_block:
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
  jmp _while53_cond
_while53_exit:
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
_if54_cond:
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
  je _if54_exit
_if54_TRUE:
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
  jmp _if54_exit
_if54_exit:
; while (num > 0) { 
_while55_cond:
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
  je _while55_exit
_while55_block:
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
  jmp _while55_cond
_while55_exit:
; while (i > 0) { 
_while62_cond:
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
  je _while62_exit
_while62_block:
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
  jmp _while62_cond
_while62_exit:
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
_ss_data: .db "     ", 0
_ss: .dw _ss_data
_coef: .fill 2, 0
_rows: .fill 2, 0
_space: .fill 2, 0
_i: .fill 2, 0
_j: .fill 2, 0
_nl_data: .db "\n\r", 0
_nl: .dw _nl_data
_s0: .db "Enter the number of rows: ", 0
_s1: .db "%d", 0
_s2: .db "\n", 0
_s3: .db "%u", 0
_s4: .db " ", 0
_s5: .db "Unexpected format in printf.", 0
_s6: .db "Error: Unknown argument type.\n", 0

_heap_top: .dw _heap
_heap: .db 0
; --- END DATA SEGMENT

.end
