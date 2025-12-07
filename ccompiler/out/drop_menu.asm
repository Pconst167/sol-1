; --- FILENAME: programs/drop_menu.c
; --- DATE:     04-07-2025 at 00:54:22
.include "lib/asm/kernel.exp"
.include "lib/asm/bios.exp"

; --- BEGIN TEXT SEGMENT
.org text_org
main:
  mov bp, $FFE0 ;
  mov sp, $FFE0 ; Make space for argc(2 bytes) and for 10 pointers in argv (local variables)
; int main_selected = 0, sub_selected = 0; 
  sub sp, 2
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -1] ; $main_selected
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
; --- END LOCAL VAR INITIALIZATION
  sub sp, 2
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -3] ; $sub_selected
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
; --- END LOCAL VAR INITIALIZATION
; int is_submenu_open = 0; 
  sub sp, 2
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -5] ; $is_submenu_open
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
; --- END LOCAL VAR INITIALIZATION
; char ch; 
  sub sp, 1
; int i; 
  sub sp, 2
; print_with_escape("\033[2J");     // Clear screen 
; --- START FUNCTION CALL
  mov b, _s4 ; "\033[2J"
  swp b
  push b
  call print_with_escape
  add sp, 2
; --- END FUNCTION CALL
; print_with_escape("\033[?25l");   // Hide cursor 
; --- START FUNCTION CALL
  mov b, _s5 ; "\033[?25l"
  swp b
  push b
  call print_with_escape
  add sp, 2
; --- END FUNCTION CALL
; while (1) { 
_while1_cond:
  mov32 cb, $00000001
  cmp b, 0
  je _while1_exit
_while1_block:
; move_cursor_to_line(1); 
; --- START FUNCTION CALL
  mov32 cb, $00000001
  swp b
  push b
  call move_cursor_to_line
  add sp, 2
; --- END FUNCTION CALL
; for (i = 0; i < 2; ++i) { 
_for2_init:
  lea d, [bp + -8] ; $i
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
_for2_cond:
  lea d, [bp + -8] ; $i
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
  cmp b, 0
  je _for2_exit
_for2_block:
; display_option(main_options[i], i == main_selected); 
; --- START FUNCTION CALL
  lea d, [bp + -8] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -1] ; $main_selected
  mov b, [d]
  mov c, 0
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  swp b
  push b
  mov d, _main_options_data ; $main_options
  push a
  push d
  lea d, [bp + -8] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  swp b
  push b
  call display_option
  add sp, 4
; --- END FUNCTION CALL
_for2_update:
  lea d, [bp + -8] ; $i
  mov b, [d]
  inc b
  lea d, [bp + -8] ; $i
  mov [d], b
  jmp _for2_cond
_for2_exit:
; if (is_submenu_open) { 
_if3_cond:
  lea d, [bp + -5] ; $is_submenu_open
  mov b, [d]
  mov c, 0
  cmp b, 0
  je _if3_else
_if3_TRUE:
; move_cursor_to_line(4); 
; --- START FUNCTION CALL
  mov32 cb, $00000004
  swp b
  push b
  call move_cursor_to_line
  add sp, 2
; --- END FUNCTION CALL
; for (i = 0; i < 2; ++i) { 
_for4_init:
  lea d, [bp + -8] ; $i
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
_for4_cond:
  lea d, [bp + -8] ; $i
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
  cmp b, 0
  je _for4_exit
_for4_block:
; display_option(sub_options[i], i == sub_selected); 
; --- START FUNCTION CALL
  lea d, [bp + -8] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -3] ; $sub_selected
  mov b, [d]
  mov c, 0
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  swp b
  push b
  mov d, _sub_options_data ; $sub_options
  push a
  push d
  lea d, [bp + -8] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  swp b
  push b
  call display_option
  add sp, 4
; --- END FUNCTION CALL
_for4_update:
  lea d, [bp + -8] ; $i
  mov b, [d]
  inc b
  lea d, [bp + -8] ; $i
  mov [d], b
  jmp _for4_cond
_for4_exit:
  jmp _if3_exit
_if3_else:
; move_cursor_to_line(4); 
; --- START FUNCTION CALL
  mov32 cb, $00000004
  swp b
  push b
  call move_cursor_to_line
  add sp, 2
; --- END FUNCTION CALL
; print_with_escape("\033[K"); // Clear line 4 
; --- START FUNCTION CALL
  mov b, _s6 ; "\033[K"
  swp b
  push b
  call print_with_escape
  add sp, 2
; --- END FUNCTION CALL
; move_cursor_to_line(5); 
; --- START FUNCTION CALL
  mov32 cb, $00000005
  swp b
  push b
  call move_cursor_to_line
  add sp, 2
; --- END FUNCTION CALL
; print_with_escape("\033[K"); // Clear line 5 
; --- START FUNCTION CALL
  mov b, _s6 ; "\033[K"
  swp b
  push b
  call print_with_escape
  add sp, 2
; --- END FUNCTION CALL
_if3_exit:
; ch = read_char_from_telnet(); 
  lea d, [bp + -6] ; $ch
  push d
; --- START FUNCTION CALL
  call read_char_from_telnet
  pop d
  mov [d], bl
; if (ch == 27) {  // ESC sequence 
_if5_cond:
  lea d, [bp + -6] ; $ch
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $0000001b
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if5_else
_if5_TRUE:
; char seq1 = read_char_from_telnet(); 
  sub sp, 1
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -9] ; $seq1
  push d
; --- START FUNCTION CALL
  call read_char_from_telnet
  pop d
  mov [d], bl
; --- END LOCAL VAR INITIALIZATION
; char seq2 = read_char_from_telnet(); 
  sub sp, 1
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -10] ; $seq2
  push d
; --- START FUNCTION CALL
  call read_char_from_telnet
  pop d
  mov [d], bl
; --- END LOCAL VAR INITIALIZATION
; if (seq1 == '[') { 
_if6_cond:
  lea d, [bp + -9] ; $seq1
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $0000005b
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if6_exit
_if6_TRUE:
; if (is_submenu_open) { 
_if7_cond:
  lea d, [bp + -5] ; $is_submenu_open
  mov b, [d]
  mov c, 0
  cmp b, 0
  je _if7_else
_if7_TRUE:
; if (seq2 == 'A' && sub_selected > 0) sub_selected--; 
_if8_cond:
  lea d, [bp + -10] ; $seq2
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
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + -3] ; $sub_selected
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
  pop a
; --- END LOGICAL AND
  cmp b, 0
  je _if8_else
_if8_TRUE:
; sub_selected--; 
  lea d, [bp + -3] ; $sub_selected
  mov b, [d]
  mov c, 0
  mov a, b
  dec b
  lea d, [bp + -3] ; $sub_selected
  mov [d], b
  mov b, a
  jmp _if8_exit
_if8_else:
; if (seq2 == 'B' && sub_selected < 1) sub_selected++; 
_if9_cond:
  lea d, [bp + -10] ; $seq2
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
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + -3] ; $sub_selected
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
  sand a, b
  pop a
; --- END LOGICAL AND
  cmp b, 0
  je _if9_exit
_if9_TRUE:
; sub_selected++; 
  lea d, [bp + -3] ; $sub_selected
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -3] ; $sub_selected
  mov [d], b
  mov b, a
  jmp _if9_exit
_if9_exit:
_if8_exit:
  jmp _if7_exit
_if7_else:
; if (seq2 == 'A' && main_selected > 0) main_selected--; 
_if10_cond:
  lea d, [bp + -10] ; $seq2
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
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + -1] ; $main_selected
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
  pop a
; --- END LOGICAL AND
  cmp b, 0
  je _if10_else
_if10_TRUE:
; main_selected--; 
  lea d, [bp + -1] ; $main_selected
  mov b, [d]
  mov c, 0
  mov a, b
  dec b
  lea d, [bp + -1] ; $main_selected
  mov [d], b
  mov b, a
  jmp _if10_exit
_if10_else:
; if (seq2 == 'B' && main_selected < 1) main_selected++; 
_if11_cond:
  lea d, [bp + -10] ; $seq2
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
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + -1] ; $main_selected
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
  sand a, b
  pop a
; --- END LOGICAL AND
  cmp b, 0
  je _if11_exit
_if11_TRUE:
; main_selected++; 
  lea d, [bp + -1] ; $main_selected
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -1] ; $main_selected
  mov [d], b
  mov b, a
  jmp _if11_exit
_if11_exit:
_if10_exit:
_if7_exit:
  jmp _if6_exit
_if6_exit:
  jmp _if5_exit
_if5_else:
; if (ch == ' ') { 
_if12_cond:
  lea d, [bp + -6] ; $ch
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
  je _if12_else
_if12_TRUE:
; if (main_selected == 0 && !is_submenu_open) { 
_if13_cond:
  lea d, [bp + -1] ; $main_selected
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
  lea d, [bp + -5] ; $is_submenu_open
  mov b, [d]
  mov c, 0
  sand a, b
  pop a
; --- END LOGICAL AND
  cmp b, 0
  je _if13_else
_if13_TRUE:
; is_submenu_open = 1; 
  lea d, [bp + -5] ; $is_submenu_open
  push d
  mov32 cb, $00000001
  pop d
  mov [d], b
; sub_selected = 0; 
  lea d, [bp + -3] ; $sub_selected
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
  jmp _if13_exit
_if13_else:
; is_submenu_open = 0; 
  lea d, [bp + -5] ; $is_submenu_open
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
_if13_exit:
  jmp _if12_exit
_if12_else:
; if (ch == '\n' || ch == '\r') { 
_if14_cond:
  lea d, [bp + -6] ; $ch
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $0000000a
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
; --- START LOGICAL OR
  push a
  mov a, b
  lea d, [bp + -6] ; $ch
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $0000000d
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  cmp b, 0
  je _if14_exit
_if14_TRUE:
; break; 
  jmp _while1_exit ; while break
  jmp _if14_exit
_if14_exit:
_if12_exit:
_if5_exit:
  jmp _while1_cond
_while1_exit:
; print_with_escape("\033[?25h");  // Show cursor 
; --- START FUNCTION CALL
  mov b, _s7 ; "\033[?25h"
  swp b
  push b
  call print_with_escape
  add sp, 2
; --- END FUNCTION CALL
; return 0; 
  mov32 cb, $00000000
  leave
  syscall sys_terminate_proc

print_with_escape:
  enter 0 ; (push bp; mov bp, sp)
; while (*str) { 
_while15_cond:
  lea d, [bp + 5] ; $str
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  cmp b, 0
  je _while15_exit
_while15_block:
; putchar(*str++); 
; --- START FUNCTION CALL
  lea d, [bp + 5] ; $str
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + 5] ; $str
  mov [d], b
  dec b
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push bl
  call putchar
  add sp, 1
; --- END FUNCTION CALL
  jmp _while15_cond
_while15_exit:
  leave
  ret

move_cursor_to_line:
  enter 0 ; (push bp; mov bp, sp)
; printf("\033[%d;1H", line); 
; --- START FUNCTION CALL
  lea d, [bp + 5] ; $line
  mov b, [d]
  mov c, 0
  swp b
  push b
  mov b, _s8 ; "\033[%d;1H"
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
  leave
  ret

display_option:
  enter 0 ; (push bp; mov bp, sp)
; if (highlighted) { 
_if16_cond:
  lea d, [bp + 7] ; $highlighted
  mov b, [d]
  mov c, 0
  cmp b, 0
  je _if16_exit
_if16_TRUE:
; print_with_escape("\033[7m"); // Inverse (highlight) 
; --- START FUNCTION CALL
  mov b, _s9 ; "\033[7m"
  swp b
  push b
  call print_with_escape
  add sp, 2
; --- END FUNCTION CALL
  jmp _if16_exit
_if16_exit:
; printf("%s", option); 
; --- START FUNCTION CALL
  lea d, [bp + 5] ; $option
  mov b, [d]
  mov c, 0
  swp b
  push b
  mov b, _s10 ; "%s"
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
; print_with_escape("\033[0m"); // Reset attributes 
; --- START FUNCTION CALL
  mov b, _s11 ; "\033[0m"
  swp b
  push b
  call print_with_escape
  add sp, 2
; --- END FUNCTION CALL
; print_with_escape("\033[K");  // Clear to end of line 
; --- START FUNCTION CALL
  mov b, _s6 ; "\033[K"
  swp b
  push b
  call print_with_escape
  add sp, 2
; --- END FUNCTION CALL
; putchar('\n'); 
; --- START FUNCTION CALL
  mov32 cb, $0000000a
  push bl
  call putchar
  add sp, 1
; --- END FUNCTION CALL
  leave
  ret

read_char_from_telnet:
  enter 0 ; (push bp; mov bp, sp)
; return getchar(); 
; --- START FUNCTION CALL
  call getchar
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
_for17_init:
_for17_cond:
_for17_block:
; if(!*format_p) break; 
_if18_cond:
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
  je _if18_else
_if18_TRUE:
; break; 
  jmp _for17_exit ; for break
  jmp _if18_exit
_if18_else:
; if(*format_p == '%'){ 
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
  mov32 cb, $00000025
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if19_else
_if19_TRUE:
; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  dec b
; switch(*format_p){ 
_switch20_expr:
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
_switch20_comparisons:
  cmp bl, $6c
  je _switch20_case0
  cmp bl, $4c
  je _switch20_case1
  cmp bl, $64
  je _switch20_case2
  cmp bl, $69
  je _switch20_case3
  cmp bl, $75
  je _switch20_case4
  cmp bl, $78
  je _switch20_case5
  cmp bl, $63
  je _switch20_case6
  cmp bl, $73
  je _switch20_case7
  jmp _switch20_default
  jmp _switch20_exit
_switch20_case0:
_switch20_case1:
; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  dec b
; if(*format_p == 'd' || *format_p == 'i') 
_if21_cond:
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
  je _if21_else
_if21_TRUE:
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
  jmp _if21_exit
_if21_else:
; if(*format_p == 'u') 
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
  mov32 cb, $00000075
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if22_else
_if22_TRUE:
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
  jmp _if22_exit
_if22_else:
; if(*format_p == 'x') 
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
  mov32 cb, $00000078
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if23_else
_if23_TRUE:
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
  jmp _if23_exit
_if23_else:
; err("Unexpected format in printf."); 
; --- START FUNCTION CALL
  mov b, _s12 ; "Unexpected format in printf."
  swp b
  push b
  call err
  add sp, 2
; --- END FUNCTION CALL
_if23_exit:
_if22_exit:
_if21_exit:
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
  jmp _switch20_exit ; case break
_switch20_case2:
_switch20_case3:
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
  jmp _switch20_exit ; case break
_switch20_case4:
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
  jmp _switch20_exit ; case break
_switch20_case5:
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
  jmp _switch20_exit ; case break
_switch20_case6:
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
  jmp _switch20_exit ; case break
_switch20_case7:
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
  jmp _switch20_exit ; case break
_switch20_default:
; print("Error: Unknown argument type.\n"); 
; --- START FUNCTION CALL
  mov b, _s13 ; "Error: Unknown argument type.\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
_switch20_exit:
  jmp _if19_exit
_if19_else:
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
_if19_exit:
_if18_exit:
; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  dec b
_for17_update:
  jmp _for17_cond
_for17_exit:
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
_if24_cond:
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
  je _if24_else
_if24_TRUE:
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
  jmp _if24_exit
_if24_else:
; if (num == 0) { 
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
  seq ; ==
  pop g
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if25_exit
_if25_TRUE:
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
  jmp _if25_exit
_if25_exit:
_if24_exit:
; while (num > 0) { 
_while26_cond:
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
  je _while26_exit
_while26_block:
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
  jmp _while26_cond
_while26_exit:
; while (i > 0) { 
_while33_cond:
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
  je _while33_exit
_while33_block:
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
  jmp _while33_cond
_while33_exit:
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
_if34_cond:
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
  je _if34_exit
_if34_TRUE:
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
  jmp _if34_exit
_if34_exit:
; while (num > 0) { 
_while35_cond:
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
  je _while35_exit
_while35_block:
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
  jmp _while35_cond
_while35_exit:
; while (i > 0) { 
_while42_cond:
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
  je _while42_exit
_while42_block:
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
  jmp _while42_cond
_while42_exit:
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
_if43_cond:
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
  mov b, [d]
  mov c, 0
  neg b
  pop d
  mov [d], b
  jmp _if43_exit
_if43_else:
; if (num == 0) { 
_if44_cond:
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
  je _while45_exit
_while45_block:
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
  jmp _while45_cond
_while45_exit:
; while (i > 0) { 
_while52_cond:
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
  je _while52_exit
_while52_block:
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
  jmp _while52_cond
_while52_exit:
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
_if53_cond:
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
  je _while54_exit
_while54_block:
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
  jmp _while54_cond
_while54_exit:
; while (i > 0) { 
_while61_cond:
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
  je _while61_exit
_while61_block:
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
  jmp _while61_cond
_while61_exit:
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
_main_options_data: .dw _s0, _s1, 
_sub_options_data: .dw _s2, _s3, 
_s0: .db "Main Option 1", 0
_s1: .db "Main Option 2", 0
_s2: .db "Sub Option 1", 0
_s3: .db "Sub Option 2", 0
_s4: .db "\033[2J", 0
_s5: .db "\033[?25l", 0
_s6: .db "\033[K", 0
_s7: .db "\033[?25h", 0
_s8: .db "\033[%d;1H", 0
_s9: .db "\033[7m", 0
_s10: .db "%s", 0
_s11: .db "\033[0m", 0
_s12: .db "Unexpected format in printf.", 0
_s13: .db "Error: Unknown argument type.\n", 0

_heap_top: .dw _heap
_heap: .db 0
; --- END DATA SEGMENT

.end
