; --- FILENAME: programs/menu
.include "lib/kernel.exp"
.include "lib/bios.exp"
.org text_org

; --- BEGIN TEXT BLOCK
main:
  mov bp, $FFE0 ;
  mov sp, $FFE0 ; Make space for argc(2 bytes) and for 10 pointers in argv (local variables)
; $selected 
  mov a, $1
  mov [bp + -1], a
; $previously_selected 
  mov a, $1
  mov [bp + -3], a
; $ch 
; $i 
  sub sp, 7
;; guestbook_data = alloc(5000); 
  mov d, _guestbook_data ; $guestbook_data
  push d
  mov b, $1388
  swp b
  push b
  call alloc
  add sp, 2
  pop d
  mov [d], b
;; print_with_escape("\033[2J"); 
  mov b, __s3 ; "\033[2J"
  swp b
  push b
  call print_with_escape
  add sp, 2
;; move_cursor_to_line(1); 
  mov b, $1
  swp b
  push b
  call move_cursor_to_line
  add sp, 2
;; printf("**** Sol-1 Guestbook ****\n"); 
  mov b, __s4 ; "**** Sol-1 Guestbook ****\n"
  swp b
  push b
  call printf
  add sp, 2
;; print_with_escape("\033[?25l"); 
  mov b, __s5 ; "\033[?25l"
  swp b
  push b
  call print_with_escape
  add sp, 2
;; for (i = 0; i < 3; ++i) { 
_for1_init:
  lea d, [bp + -6] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
_for1_cond:
  lea d, [bp + -6] ; $i
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $3
  cmp a, b
  slt ; < 
  pop a
; END RELATIONAL
  cmp b, 0
  je _for1_exit
_for1_block:
;; move_cursor_to_line(i); 
  lea d, [bp + -6] ; $i
  mov b, [d]
  swp b
  push b
  call move_cursor_to_line
  add sp, 2
;; display_option(options[i], i == selected); 
  lea d, [bp + -6] ; $i
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -1] ; $selected
  mov b, [d]
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  swp b
  push b
  mov d, _options_data ; $options
  push a
  push d
  lea d, [bp + -6] ; $i
  mov b, [d]
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  swp b
  push b
  call display_option
  add sp, 4
_for1_update:
  lea d, [bp + -6] ; $i
  mov b, [d]
  inc b
  lea d, [bp + -6] ; $i
  mov [d], b
  jmp _for1_cond
_for1_exit:
;; while (1) { 
_while2_cond:
  mov b, $1
  cmp b, 0
  je _while2_exit
_while2_block:
;; ch = getchar();  // Implement this function based on your OS 
  lea d, [bp + -4] ; $ch
  push d
  call getchar
  pop d
  mov [d], bl
;; previously_selected = selected; 
  lea d, [bp + -3] ; $previously_selected
  push d
  lea d, [bp + -1] ; $selected
  mov b, [d]
  pop d
  mov [d], b
;; if (ch == 27) {  // Escape sequence 
_if3_cond:
  lea d, [bp + -4] ; $ch
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $1b
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if3_else
_if3_true:
;; ch = getchar(); 
  lea d, [bp + -4] ; $ch
  push d
  call getchar
  pop d
  mov [d], bl
;; if (ch == '[') { 
_if4_cond:
  lea d, [bp + -4] ; $ch
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $5b
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if4_exit
_if4_true:
;; ch = getchar(); 
  lea d, [bp + -4] ; $ch
  push d
  call getchar
  pop d
  mov [d], bl
;; if (ch == 'A' && selected > 0) {  // Up arrow 
_if5_cond:
  lea d, [bp + -4] ; $ch
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $41
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  push a
  mov a, b
  lea d, [bp + -1] ; $selected
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  sgt ; >
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  cmp b, 0
  je _if5_else
_if5_true:
;; selected--; 
  lea d, [bp + -1] ; $selected
  mov b, [d]
  mov g, b
  dec b
  lea d, [bp + -1] ; $selected
  mov [d], b
  mov b, g
  jmp _if5_exit
_if5_else:
;; if (ch == 'B' && selected < 4) {  // Down arrow 
_if6_cond:
  lea d, [bp + -4] ; $ch
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $42
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  push a
  mov a, b
  lea d, [bp + -1] ; $selected
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $4
  cmp a, b
  slt ; < 
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  cmp b, 0
  je _if6_exit
_if6_true:
;; selected++; 
  lea d, [bp + -1] ; $selected
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -1] ; $selected
  mov [d], b
  mov b, g
  jmp _if6_exit
_if6_exit:
_if5_exit:
  jmp _if4_exit
_if4_exit:
  jmp _if3_exit
_if3_else:
;; if (ch == '\n' || ch == '\r') {  // Enter key 
_if7_cond:
  lea d, [bp + -4] ; $ch
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $a
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  push a
  mov a, b
  lea d, [bp + -4] ; $ch
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $d
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  pop a
  cmp b, 0
  je _if7_exit
_if7_true:
;; switch(selected){ 
_switch8_expr:
  lea d, [bp + -1] ; $selected
  mov b, [d]
_switch8_comparisons:
  cmp b, 0
  je _switch8_case0
  cmp b, 1
  je _switch8_case1
  cmp b, 2
  je _switch8_case2
  jmp _switch8_exit
_switch8_case0:
;; move_cursor_to_line(6); 
  mov b, $6
  swp b
  push b
  call move_cursor_to_line
  add sp, 2

; --- BEGIN INLINE ASM BLOCK
  mov d, _guestbook_data ; $guestbook_data
  mov d, [d]
  mov di, d
  mov d, _filename ; $filename
  mov d, [d]
  mov al, 20
  syscall sys_filesystem				
; --- END INLINE ASM BLOCK

;; printf(guestbook_data); 
  mov d, _guestbook_data ; $guestbook_data
  mov b, [d]
  swp b
  push b
  call printf
  add sp, 2
;; print_with_escape("\033[7m"); // highlight 
  mov b, __s6 ; "\033[7m"
  swp b
  push b
  call print_with_escape
  add sp, 2
;; printf("Press Return to exit."); 
  mov b, __s7 ; "Press Return to exit."
  swp b
  push b
  call printf
  add sp, 2
;; print_with_escape("\033[0m"); 
  mov b, __s8 ; "\033[0m"
  swp b
  push b
  call print_with_escape
  add sp, 2
;; while(1){ 
_while9_cond:
  mov b, $1
  cmp b, 0
  je _while9_exit
_while9_block:
;; ch = getchar(); 
  lea d, [bp + -4] ; $ch
  push d
  call getchar
  pop d
  mov [d], bl
;; if(ch == 0x0A || ch == 0x0D){ 
_if10_cond:
  lea d, [bp + -4] ; $ch
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $a
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  push a
  mov a, b
  lea d, [bp + -4] ; $ch
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $d
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  pop a
  cmp b, 0
  je _if10_exit
_if10_true:
;; print_with_escape("\033[2J"); // clear 
  mov b, __s3 ; "\033[2J"
  swp b
  push b
  call print_with_escape
  add sp, 2
;; for (i = 0; i < 3; ++i) { 
_for11_init:
  lea d, [bp + -6] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
_for11_cond:
  lea d, [bp + -6] ; $i
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $3
  cmp a, b
  slt ; < 
  pop a
; END RELATIONAL
  cmp b, 0
  je _for11_exit
_for11_block:
;; move_cursor_to_line(i); 
  lea d, [bp + -6] ; $i
  mov b, [d]
  swp b
  push b
  call move_cursor_to_line
  add sp, 2
;; display_option(options[i], i == selected); 
  lea d, [bp + -6] ; $i
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -1] ; $selected
  mov b, [d]
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  swp b
  push b
  mov d, _options_data ; $options
  push a
  push d
  lea d, [bp + -6] ; $i
  mov b, [d]
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  swp b
  push b
  call display_option
  add sp, 4
_for11_update:
  lea d, [bp + -6] ; $i
  mov b, [d]
  inc b
  lea d, [bp + -6] ; $i
  mov [d], b
  jmp _for11_cond
_for11_exit:
;; continue; 
  jmp _while9_cond ; while continue
  jmp _if10_exit
_if10_exit:
  jmp _while9_cond
_while9_exit:
;; break; 
  jmp _switch8_exit ; case break
_switch8_case1:
;; move_cursor_to_line(6); 
  mov b, $6
  swp b
  push b
  call move_cursor_to_line
  add sp, 2
;; printf("Soon!!"); 
  mov b, __s9 ; "Soon!!"
  swp b
  push b
  call printf
  add sp, 2
;; break; 
  jmp _switch8_exit ; case break
_switch8_case2:
;; print_with_escape("\033[?25h"); 
  mov b, __s10 ; "\033[?25h"
  swp b
  push b
  call print_with_escape
  add sp, 2
;; return; 
  leave
  syscall sys_terminate_proc
_switch8_exit:
  jmp _if7_exit
_if7_exit:
_if3_exit:
;; move_cursor_to_line(previously_selected); 
  lea d, [bp + -3] ; $previously_selected
  mov b, [d]
  swp b
  push b
  call move_cursor_to_line
  add sp, 2
;; display_option(options[previously_selected], 0); 
  mov b, $0
  swp b
  push b
  mov d, _options_data ; $options
  push a
  push d
  lea d, [bp + -3] ; $previously_selected
  mov b, [d]
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  swp b
  push b
  call display_option
  add sp, 4
;; move_cursor_to_line(selected); 
  lea d, [bp + -1] ; $selected
  mov b, [d]
  swp b
  push b
  call move_cursor_to_line
  add sp, 2
;; display_option(options[selected], 1); 
  mov b, $1
  swp b
  push b
  mov d, _options_data ; $options
  push a
  push d
  lea d, [bp + -1] ; $selected
  mov b, [d]
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  swp b
  push b
  call display_option
  add sp, 4
  jmp _while2_cond
_while2_exit:
;; print_with_escape("\033[?25h"); 
  mov b, __s10 ; "\033[?25h"
  swp b
  push b
  call print_with_escape
  add sp, 2
  syscall sys_terminate_proc

strcpy:
  enter 0 ; (push bp; mov bp, sp)
; $psrc 
; $pdest 
  sub sp, 4
;; psrc = src; 
  lea d, [bp + -1] ; $psrc
  push d
  lea d, [bp + 7] ; $src
  mov b, [d]
  pop d
  mov [d], b
;; pdest = dest; 
  lea d, [bp + -3] ; $pdest
  push d
  lea d, [bp + 5] ; $dest
  mov b, [d]
  pop d
  mov [d], b
;; while(*psrc) *pdest++ = *psrc++; 
_while12_cond:
  lea d, [bp + -1] ; $psrc
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
  cmp b, 0
  je _while12_exit
_while12_block:
;; *pdest++ = *psrc++; 
  lea d, [bp + -3] ; $pdest
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -3] ; $pdest
  mov [d], b
  mov b, g
  push b
  lea d, [bp + -1] ; $psrc
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -1] ; $psrc
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
  jmp _while12_cond
_while12_exit:
;; *pdest = '\0'; 
  lea d, [bp + -3] ; $pdest
  mov b, [d]
  push b
  mov b, $0
  pop d
  mov [d], bl
  leave
  ret

strcmp:
  enter 0 ; (push bp; mov bp, sp)
;; while (*s1 && (*s1 == *s2)) { 
_while13_cond:
  lea d, [bp + 5] ; $s1
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
  push a
  mov a, b
  lea d, [bp + 5] ; $s1
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  lea d, [bp + 7] ; $s2
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  cmp b, 0
  je _while13_exit
_while13_block:
;; s1++; 
  lea d, [bp + 5] ; $s1
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + 5] ; $s1
  mov [d], b
  mov b, g
;; s2++; 
  lea d, [bp + 7] ; $s2
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + 7] ; $s2
  mov [d], b
  mov b, g
  jmp _while13_cond
_while13_exit:
;; return *s1 - *s2; 
  lea d, [bp + 5] ; $s1
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START TERMS
  push a
  mov a, b
  lea d, [bp + 7] ; $s2
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
  sub a, b
  mov b, a
  pop a
; END TERMS
  leave
  ret

strcat:
  enter 0 ; (push bp; mov bp, sp)
; $dest_len 
; $i 
  sub sp, 4
;; dest_len = strlen(dest); 
  lea d, [bp + -1] ; $dest_len
  push d
  lea d, [bp + 5] ; $dest
  mov b, [d]
  swp b
  push b
  call strlen
  add sp, 2
  pop d
  mov [d], b
;; for (i = 0; src[i] != 0; i=i+1) { 
_for14_init:
  lea d, [bp + -3] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
_for14_cond:
  lea d, [bp + 7] ; $src
  mov d, [d]
  push a
  push d
  lea d, [bp + -3] ; $i
  mov b, [d]
  pop d
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  sneq ; !=
  pop a
; END RELATIONAL
  cmp b, 0
  je _for14_exit
_for14_block:
;; dest[dest_len + i] = src[i]; 
  lea d, [bp + 5] ; $dest
  mov d, [d]
  push a
  push d
  lea d, [bp + -1] ; $dest_len
  mov b, [d]
; START TERMS
  push a
  mov a, b
  lea d, [bp + -3] ; $i
  mov b, [d]
  add a, b
  mov b, a
  pop a
; END TERMS
  pop d
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  push d
  lea d, [bp + 7] ; $src
  mov d, [d]
  push a
  push d
  lea d, [bp + -3] ; $i
  mov b, [d]
  pop d
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
_for14_update:
  lea d, [bp + -3] ; $i
  push d
  lea d, [bp + -3] ; $i
  mov b, [d]
; START TERMS
  push a
  mov a, b
  mov b, $1
  add a, b
  mov b, a
  pop a
; END TERMS
  pop d
  mov [d], b
  jmp _for14_cond
_for14_exit:
;; dest[dest_len + i] = 0; 
  lea d, [bp + 5] ; $dest
  mov d, [d]
  push a
  push d
  lea d, [bp + -1] ; $dest_len
  mov b, [d]
; START TERMS
  push a
  mov a, b
  lea d, [bp + -3] ; $i
  mov b, [d]
  add a, b
  mov b, a
  pop a
; END TERMS
  pop d
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  push d
  mov b, $0
  pop d
  mov [d], bl
;; return dest; 
  lea d, [bp + 5] ; $dest
  mov b, [d]
  leave
  ret

strlen:
  enter 0 ; (push bp; mov bp, sp)
; $length 
  sub sp, 2
;; length = 0; 
  lea d, [bp + -1] ; $length
  push d
  mov b, $0
  pop d
  mov [d], b
;; while (str[length] != 0) { 
_while15_cond:
  lea d, [bp + 5] ; $str
  mov d, [d]
  push a
  push d
  lea d, [bp + -1] ; $length
  mov b, [d]
  pop d
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  sneq ; !=
  pop a
; END RELATIONAL
  cmp b, 0
  je _while15_exit
_while15_block:
;; length++; 
  lea d, [bp + -1] ; $length
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -1] ; $length
  mov [d], b
  mov b, g
  jmp _while15_cond
_while15_exit:
;; return length; 
  lea d, [bp + -1] ; $length
  mov b, [d]
  leave
  ret

printf:
  enter 0 ; (push bp; mov bp, sp)
; $p 
; $fp 
; $i 
  sub sp, 6
;; fp = format; 
  lea d, [bp + -3] ; $fp
  push d
  lea d, [bp + 5] ; $format
  mov b, [d]
  pop d
  mov [d], b
;; p = &format + 2; 
  lea d, [bp + -1] ; $p
  push d
  lea d, [bp + 5] ; $format
  mov b, d
; START TERMS
  push a
  mov a, b
  mov b, $2
  add a, b
  mov b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; for(;;){ 
_for16_init:
_for16_cond:
_for16_block:
;; if(!*fp) break; 
_if17_cond:
  lea d, [bp + -3] ; $fp
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
  cmp b, 0
  seq ; !
  cmp b, 0
  je _if17_else
_if17_true:
;; break; 
  jmp _for16_exit ; for break
  jmp _if17_exit
_if17_else:
;; if(*fp == '%'){ 
_if18_cond:
  lea d, [bp + -3] ; $fp
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $25
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if18_else
_if18_true:
;; fp++; 
  lea d, [bp + -3] ; $fp
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -3] ; $fp
  mov [d], b
  mov b, g
;; switch(*fp){ 
_switch19_expr:
  lea d, [bp + -3] ; $fp
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
_switch19_comparisons:
  cmp bl, $64
  je _switch19_case0
  cmp bl, $69
  je _switch19_case1
  cmp bl, $75
  je _switch19_case2
  cmp bl, $78
  je _switch19_case3
  cmp bl, $63
  je _switch19_case4
  cmp bl, $73
  je _switch19_case5
  jmp _switch19_default
  jmp _switch19_exit
_switch19_case0:
_switch19_case1:
;; prints(*(int*)p); 
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov d, b
  mov b, [d]
  swp b
  push b
  call prints
  add sp, 2
;; p = p + 2; 
  lea d, [bp + -1] ; $p
  push d
  lea d, [bp + -1] ; $p
  mov b, [d]
; START TERMS
  push a
  mov a, b
  mov b, $2
  add a, b
  mov b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; break; 
  jmp _switch19_exit ; case break
_switch19_case2:
;; printu(*(unsigned int*)p); 
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov d, b
  mov b, [d]
  swp b
  push b
  call printu
  add sp, 2
;; p = p + 2; 
  lea d, [bp + -1] ; $p
  push d
  lea d, [bp + -1] ; $p
  mov b, [d]
; START TERMS
  push a
  mov a, b
  mov b, $2
  add a, b
  mov b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; break; 
  jmp _switch19_exit ; case break
_switch19_case3:
;; printx16(*(unsigned int*)p); 
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov d, b
  mov b, [d]
  swp b
  push b
  call printx16
  add sp, 2
;; p = p + 2; 
  lea d, [bp + -1] ; $p
  push d
  lea d, [bp + -1] ; $p
  mov b, [d]
; START TERMS
  push a
  mov a, b
  mov b, $2
  add a, b
  mov b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; break; 
  jmp _switch19_exit ; case break
_switch19_case4:
;; putchar(*(char*)p); 
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
  push bl
  call putchar
  add sp, 1
;; p = p + 2; 
  lea d, [bp + -1] ; $p
  push d
  lea d, [bp + -1] ; $p
  mov b, [d]
; START TERMS
  push a
  mov a, b
  mov b, $2
  add a, b
  mov b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; break; 
  jmp _switch19_exit ; case break
_switch19_case5:
;; print(*(char**)p); 
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov d, b
  mov b, [d]
  swp b
  push b
  call print
  add sp, 2
;; p = p + 2; 
  lea d, [bp + -1] ; $p
  push d
  lea d, [bp + -1] ; $p
  mov b, [d]
; START TERMS
  push a
  mov a, b
  mov b, $2
  add a, b
  mov b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; break; 
  jmp _switch19_exit ; case break
_switch19_default:
;; print("Error: Unknown argument type.\n"); 
  mov b, __s11 ; "Error: Unknown argument type.\n"
  swp b
  push b
  call print
  add sp, 2
_switch19_exit:
;; fp++; 
  lea d, [bp + -3] ; $fp
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -3] ; $fp
  mov [d], b
  mov b, g
  jmp _if18_exit
_if18_else:
;; putchar(*fp); 
  lea d, [bp + -3] ; $fp
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
  push bl
  call putchar
  add sp, 1
;; fp++; 
  lea d, [bp + -3] ; $fp
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -3] ; $fp
  mov [d], b
  mov b, g
_if18_exit:
_if17_exit:
_for16_update:
  jmp _for16_cond
_for16_exit:
  leave
  ret

printx16:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM BLOCK
  lea d, [bp + 5] ; $hex
  mov b, [d]
  call print_u16x
; --- END INLINE ASM BLOCK

  leave
  ret

printx8:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM BLOCK
  lea d, [bp + 5] ; $hex
  mov bl, [d]
  call print_u8x
; --- END INLINE ASM BLOCK

  leave
  ret

hex_to_int:
  enter 0 ; (push bp; mov bp, sp)
; $value 
  mov a, $0
  mov [bp + -1], a
; $i 
; $hex_char 
; $len 
  sub sp, 7
;; len = strlen(hex_string); 
  lea d, [bp + -6] ; $len
  push d
  lea d, [bp + 5] ; $hex_string
  mov b, [d]
  swp b
  push b
  call strlen
  add sp, 2
  pop d
  mov [d], b
;; for (i = 0; i < len; i++) { 
_for20_init:
  lea d, [bp + -3] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
_for20_cond:
  lea d, [bp + -3] ; $i
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -6] ; $len
  mov b, [d]
  cmp a, b
  slt ; < 
  pop a
; END RELATIONAL
  cmp b, 0
  je _for20_exit
_for20_block:
;; hex_char = hex_string[i]; 
  lea d, [bp + -4] ; $hex_char
  push d
  lea d, [bp + 5] ; $hex_string
  mov d, [d]
  push a
  push d
  lea d, [bp + -3] ; $i
  mov b, [d]
  pop d
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; if (hex_char >= 'a' && hex_char <= 'f')  
_if21_cond:
  lea d, [bp + -4] ; $hex_char
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $61
  cmp a, b
  sge ; >=
  pop a
; END RELATIONAL
  push a
  mov a, b
  lea d, [bp + -4] ; $hex_char
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $66
  cmp a, b
  sle ; <=
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  cmp b, 0
  je _if21_else
_if21_true:
;; value = (value * 16) + (hex_char - 'a' + 10); 
  lea d, [bp + -1] ; $value
  push d
  lea d, [bp + -1] ; $value
  mov b, [d]
; START FACTORS
  push a
  mov a, b
  mov b, $10
  mul a, b ; *
  mov a, b
  mov b, a
  pop a
; END FACTORS
; START TERMS
  push a
  mov a, b
  lea d, [bp + -4] ; $hex_char
  mov bl, [d]
  mov bh, 0
; START TERMS
  push a
  mov a, b
  mov b, $61
  sub a, b
  mov b, $a
  add a, b
  mov b, a
  pop a
; END TERMS
  add a, b
  mov b, a
  pop a
; END TERMS
  pop d
  mov [d], b
  jmp _if21_exit
_if21_else:
;; if (hex_char >= 'A' && hex_char <= 'F')  
_if22_cond:
  lea d, [bp + -4] ; $hex_char
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $41
  cmp a, b
  sge ; >=
  pop a
; END RELATIONAL
  push a
  mov a, b
  lea d, [bp + -4] ; $hex_char
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $46
  cmp a, b
  sle ; <=
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  cmp b, 0
  je _if22_else
_if22_true:
;; value = (value * 16) + (hex_char - 'A' + 10); 
  lea d, [bp + -1] ; $value
  push d
  lea d, [bp + -1] ; $value
  mov b, [d]
; START FACTORS
  push a
  mov a, b
  mov b, $10
  mul a, b ; *
  mov a, b
  mov b, a
  pop a
; END FACTORS
; START TERMS
  push a
  mov a, b
  lea d, [bp + -4] ; $hex_char
  mov bl, [d]
  mov bh, 0
; START TERMS
  push a
  mov a, b
  mov b, $41
  sub a, b
  mov b, $a
  add a, b
  mov b, a
  pop a
; END TERMS
  add a, b
  mov b, a
  pop a
; END TERMS
  pop d
  mov [d], b
  jmp _if22_exit
_if22_else:
;; value = (value * 16) + (hex_char - '0'); 
  lea d, [bp + -1] ; $value
  push d
  lea d, [bp + -1] ; $value
  mov b, [d]
; START FACTORS
  push a
  mov a, b
  mov b, $10
  mul a, b ; *
  mov a, b
  mov b, a
  pop a
; END FACTORS
; START TERMS
  push a
  mov a, b
  lea d, [bp + -4] ; $hex_char
  mov bl, [d]
  mov bh, 0
; START TERMS
  push a
  mov a, b
  mov b, $30
  sub a, b
  mov b, a
  pop a
; END TERMS
  add a, b
  mov b, a
  pop a
; END TERMS
  pop d
  mov [d], b
_if22_exit:
_if21_exit:
_for20_update:
  lea d, [bp + -3] ; $i
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -3] ; $i
  mov [d], b
  mov b, g
  jmp _for20_cond
_for20_exit:
;; return value; 
  lea d, [bp + -1] ; $value
  mov b, [d]
  leave
  ret

atoi:
  enter 0 ; (push bp; mov bp, sp)
; $result 
  mov a, $0
  mov [bp + -1], a
; $sign 
  mov a, $1
  mov [bp + -3], a
  sub sp, 4
;; while (*str == ' ') str++; 
_while23_cond:
  lea d, [bp + 5] ; $str
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $20
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _while23_exit
_while23_block:
;; str++; 
  lea d, [bp + 5] ; $str
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + 5] ; $str
  mov [d], b
  mov b, g
  jmp _while23_cond
_while23_exit:
;; if (*str == '-' || *str == '+') { 
_if24_cond:
  lea d, [bp + 5] ; $str
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $2d
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  push a
  mov a, b
  lea d, [bp + 5] ; $str
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $2b
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  pop a
  cmp b, 0
  je _if24_exit
_if24_true:
;; if (*str == '-') sign = -1; 
_if25_cond:
  lea d, [bp + 5] ; $str
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $2d
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if25_exit
_if25_true:
;; sign = -1; 
  lea d, [bp + -3] ; $sign
  push d
  mov b, $1
  neg b
  pop d
  mov [d], b
  jmp _if25_exit
_if25_exit:
;; str++; 
  lea d, [bp + 5] ; $str
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + 5] ; $str
  mov [d], b
  mov b, g
  jmp _if24_exit
_if24_exit:
;; while (*str >= '0' && *str <= '9') { 
_while26_cond:
  lea d, [bp + 5] ; $str
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $30
  cmp a, b
  sge ; >=
  pop a
; END RELATIONAL
  push a
  mov a, b
  lea d, [bp + 5] ; $str
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $39
  cmp a, b
  sle ; <=
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  cmp b, 0
  je _while26_exit
_while26_block:
;; result = result * 10 + (*str - '0'); 
  lea d, [bp + -1] ; $result
  push d
  lea d, [bp + -1] ; $result
  mov b, [d]
; START FACTORS
  push a
  mov a, b
  mov b, $a
  mul a, b ; *
  mov a, b
  mov b, a
  pop a
; END FACTORS
; START TERMS
  push a
  mov a, b
  lea d, [bp + 5] ; $str
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
; START TERMS
  push a
  mov a, b
  mov b, $30
  sub a, b
  mov b, a
  pop a
; END TERMS
  add a, b
  mov b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; str++; 
  lea d, [bp + 5] ; $str
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + 5] ; $str
  mov [d], b
  mov b, g
  jmp _while26_cond
_while26_exit:
;; return sign * result; 
  lea d, [bp + -3] ; $sign
  mov b, [d]
; START FACTORS
  push a
  mov a, b
  lea d, [bp + -1] ; $result
  mov b, [d]
  mul a, b ; *
  mov a, b
  mov b, a
  pop a
; END FACTORS
  leave
  ret

gets:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM BLOCK
  lea d, [bp + 5] ; $s
  mov a, [d]
  mov d, a
  call _gets
; --- END INLINE ASM BLOCK

;; return strlen(s); 
  lea d, [bp + 5] ; $s
  mov b, [d]
  swp b
  push b
  call strlen
  add sp, 2
  leave
  ret

prints:
  enter 0 ; (push bp; mov bp, sp)
; $digits 
; $i 
  mov a, $0
  mov [bp + -6], a
  sub sp, 7
;; if (num < 0) { 
_if27_cond:
  lea d, [bp + 5] ; $num
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  slt ; < 
  pop a
; END RELATIONAL
  cmp b, 0
  je _if27_else
_if27_true:
;; putchar('-'); 
  mov b, $2d
  push bl
  call putchar
  add sp, 1
;; num = -num; 
  lea d, [bp + 5] ; $num
  push d
  lea d, [bp + 5] ; $num
  mov b, [d]
  neg b
  pop d
  mov [d], b
  jmp _if27_exit
_if27_else:
;; if (num == 0) { 
_if28_cond:
  lea d, [bp + 5] ; $num
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if28_exit
_if28_true:
;; putchar('0'); 
  mov b, $30
  push bl
  call putchar
  add sp, 1
;; return; 
  leave
  ret
  jmp _if28_exit
_if28_exit:
_if27_exit:
;; while (num > 0) { 
_while29_cond:
  lea d, [bp + 5] ; $num
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  sgt ; >
  pop a
; END RELATIONAL
  cmp b, 0
  je _while29_exit
_while29_block:
;; digits[i] = '0' + (num % 10); 
  lea d, [bp + -4] ; $digits
  push a
  push d
  lea d, [bp + -6] ; $i
  mov b, [d]
  pop d
  add d, b
  pop a
  push d
  mov b, $30
; START TERMS
  push a
  mov a, b
  lea d, [bp + 5] ; $num
  mov b, [d]
; START FACTORS
  push a
  mov a, b
  mov b, $a
  div a, b ; 
  mov a, b
  mov b, a
  pop a
; END FACTORS
  add a, b
  mov b, a
  pop a
; END TERMS
  pop d
  mov [d], bl
;; num = num / 10; 
  lea d, [bp + 5] ; $num
  push d
  lea d, [bp + 5] ; $num
  mov b, [d]
; START FACTORS
  push a
  mov a, b
  mov b, $a
  div a, b
  mov b, a
  pop a
; END FACTORS
  pop d
  mov [d], b
;; i++; 
  lea d, [bp + -6] ; $i
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -6] ; $i
  mov [d], b
  mov b, g
  jmp _while29_cond
_while29_exit:
;; while (i > 0) { 
_while30_cond:
  lea d, [bp + -6] ; $i
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  sgt ; >
  pop a
; END RELATIONAL
  cmp b, 0
  je _while30_exit
_while30_block:
;; i--; 
  lea d, [bp + -6] ; $i
  mov b, [d]
  mov g, b
  dec b
  lea d, [bp + -6] ; $i
  mov [d], b
  mov b, g
;; putchar(digits[i]); 
  lea d, [bp + -4] ; $digits
  push a
  push d
  lea d, [bp + -6] ; $i
  mov b, [d]
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  push bl
  call putchar
  add sp, 1
  jmp _while30_cond
_while30_exit:
  leave
  ret

printu:
  enter 0 ; (push bp; mov bp, sp)
; $digits 
; $i 
  sub sp, 7
;; i = 0; 
  lea d, [bp + -6] ; $i
  push d
  mov b, $0
  pop d
  mov [d], b
;; if(num == 0){ 
_if31_cond:
  lea d, [bp + 5] ; $num
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if31_exit
_if31_true:
;; putchar('0'); 
  mov b, $30
  push bl
  call putchar
  add sp, 1
;; return; 
  leave
  ret
  jmp _if31_exit
_if31_exit:
;; while (num > 0) { 
_while32_cond:
  lea d, [bp + 5] ; $num
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  sgu ; > (unsigned)
  pop a
; END RELATIONAL
  cmp b, 0
  je _while32_exit
_while32_block:
;; digits[i] = '0' + (num % 10); 
  lea d, [bp + -4] ; $digits
  push a
  push d
  lea d, [bp + -6] ; $i
  mov b, [d]
  pop d
  add d, b
  pop a
  push d
  mov b, $30
; START TERMS
  push a
  mov a, b
  lea d, [bp + 5] ; $num
  mov b, [d]
; START FACTORS
  push a
  mov a, b
  mov b, $a
  div a, b ; 
  mov a, b
  mov b, a
  pop a
; END FACTORS
  add a, b
  mov b, a
  pop a
; END TERMS
  pop d
  mov [d], bl
;; num = num / 10; 
  lea d, [bp + 5] ; $num
  push d
  lea d, [bp + 5] ; $num
  mov b, [d]
; START FACTORS
  push a
  mov a, b
  mov b, $a
  div a, b
  mov b, a
  pop a
; END FACTORS
  pop d
  mov [d], b
;; i++; 
  lea d, [bp + -6] ; $i
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + -6] ; $i
  mov [d], b
  mov b, g
  jmp _while32_cond
_while32_exit:
;; while (i > 0) { 
_while33_cond:
  lea d, [bp + -6] ; $i
  mov b, [d]
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  sgt ; >
  pop a
; END RELATIONAL
  cmp b, 0
  je _while33_exit
_while33_block:
;; i--; 
  lea d, [bp + -6] ; $i
  mov b, [d]
  mov g, b
  dec b
  lea d, [bp + -6] ; $i
  mov [d], b
  mov b, g
;; putchar(digits[i]); 
  lea d, [bp + -4] ; $digits
  push a
  push d
  lea d, [bp + -6] ; $i
  mov b, [d]
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  push bl
  call putchar
  add sp, 1
  jmp _while33_cond
_while33_exit:
  leave
  ret

rand:
  enter 0 ; (push bp; mov bp, sp)
; $sec 
  sub sp, 1

; --- BEGIN INLINE ASM BLOCK
  mov al, 0
  syscall sys_rtc					
  mov al, ah
  lea d, [bp + 0] ; $sec
  mov al, [d]
; --- END INLINE ASM BLOCK

;; return sec; 
  lea d, [bp + 0] ; $sec
  mov bl, [d]
  mov bh, 0
  leave
  ret

date:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM BLOCK
  mov al, 0 
  syscall sys_datetime
; --- END INLINE ASM BLOCK

  leave
  ret

putchar:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM BLOCK
  lea d, [bp + 5] ; $c
  mov al, [d]
  mov ah, al
  call _putchar
; --- END INLINE ASM BLOCK

  leave
  ret

getchar:
  enter 0 ; (push bp; mov bp, sp)
; $c 
  sub sp, 1

; --- BEGIN INLINE ASM BLOCK
  call getch
  mov al, ah
  lea d, [bp + 0] ; $c
  mov [d], al
; --- END INLINE ASM BLOCK

;; return c; 
  lea d, [bp + 0] ; $c
  mov bl, [d]
  mov bh, 0
  leave
  ret

scann:
  enter 0 ; (push bp; mov bp, sp)
; $m 
  sub sp, 2

; --- BEGIN INLINE ASM BLOCK
  call scan_u16d
  lea d, [bp + -1] ; $m
  mov [d], a
; --- END INLINE ASM BLOCK

;; return m; 
  lea d, [bp + -1] ; $m
  mov b, [d]
  leave
  ret

puts:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM BLOCK
  lea d, [bp + 5] ; $s
  mov a, [d]
  mov d, a
  call _puts
  mov a, $0A00
  syscall sys_io
; --- END INLINE ASM BLOCK

  leave
  ret

print:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM BLOCK
  lea d, [bp + 5] ; $s
  mov d, [d]
  call _puts
; --- END INLINE ASM BLOCK

  leave
  ret

loadfile:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM BLOCK
  lea d, [bp + 7] ; $destination
  mov a, [d]
  mov di, a
  lea d, [bp + 5] ; $filename
  mov d, [d]
  mov al, 20
  syscall sys_filesystem
; --- END INLINE ASM BLOCK

  leave
  ret

create_file:
  enter 0 ; (push bp; mov bp, sp)
  leave
  ret

delete_file:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM BLOCK
  lea d, [bp + 5] ; $filename
  mov al, 10
  syscall sys_filesystem
; --- END INLINE ASM BLOCK

  leave
  ret

fopen:
  enter 0 ; (push bp; mov bp, sp)
  leave
  ret

fclose:
  enter 0 ; (push bp; mov bp, sp)
  leave
  ret

alloc:
  enter 0 ; (push bp; mov bp, sp)
;; heap_top = heap_top + bytes; 
  mov d, _heap_top ; $heap_top
  push d
  mov d, _heap_top ; $heap_top
  mov b, [d]
; START TERMS
  push a
  mov a, b
  lea d, [bp + 5] ; $bytes
  mov b, [d]
  add a, b
  mov b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; return heap_top - bytes; 
  mov d, _heap_top ; $heap_top
  mov b, [d]
; START TERMS
  push a
  mov a, b
  lea d, [bp + 5] ; $bytes
  mov b, [d]
  sub a, b
  mov b, a
  pop a
; END TERMS
  leave
  ret

free:
  enter 0 ; (push bp; mov bp, sp)
;; return heap_top = heap_top - bytes; 
  mov d, _heap_top ; $heap_top
  push d
  mov d, _heap_top ; $heap_top
  mov b, [d]
; START TERMS
  push a
  mov a, b
  lea d, [bp + 5] ; $bytes
  mov b, [d]
  sub a, b
  mov b, a
  pop a
; END TERMS
  pop d
  mov [d], b
  leave
  ret

exit:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM BLOCK
  syscall sys_terminate_proc
; --- END INLINE ASM BLOCK

  leave
  ret

load_hex:
  enter 0 ; (push bp; mov bp, sp)
; $temp 
  sub sp, 2
;; temp = alloc(32768); 
  lea d, [bp + -1] ; $temp
  push d
  mov b, $8000
  swp b
  push b
  call alloc
  add sp, 2
  pop d
  mov [d], b

; --- BEGIN INLINE ASM BLOCK
  
  
  
  
  
_load_hex:
  push a
  push b
  push d
  push si
  push di
  sub sp, $8000      
  mov c, 0
  mov a, sp
  inc a
  mov d, a          
  call _gets        
  mov si, a
__load_hex_loop:
  lodsb             
  cmp al, 0         
  jz __load_hex_ret
  mov bh, al
  lodsb
  mov bl, al
  call _atoi        
  stosb             
  inc c
  jmp __load_hex_loop
__load_hex_ret:
  add sp, $8000
  pop di
  pop si
  pop d
  pop b
  pop a
; --- END INLINE ASM BLOCK

  leave
  ret

getparam:
  enter 0 ; (push bp; mov bp, sp)
; $data 
  sub sp, 1

; --- BEGIN INLINE ASM BLOCK
  mov al, 4
  lea d, [bp + 5] ; $address
  mov d, [d]
  syscall sys_system
  lea d, [bp + 0] ; $data
  mov [d], bl
; --- END INLINE ASM BLOCK

;; return data; 
  lea d, [bp + 0] ; $data
  mov bl, [d]
  mov bh, 0
  leave
  ret

clear:
  enter 0 ; (push bp; mov bp, sp)
;; print("\033[2J\033[H"); 
  mov b, __s12 ; "\033[2J\033[H"
  swp b
  push b
  call print
  add sp, 2
  leave
  ret

printun:
  enter 0 ; (push bp; mov bp, sp)
;; print(prompt); 
  lea d, [bp + 5] ; $prompt
  mov b, [d]
  swp b
  push b
  call print
  add sp, 2
;; printu(n); 
  lea d, [bp + 7] ; $n
  mov b, [d]
  swp b
  push b
  call printu
  add sp, 2
;; print("\n"); 
  mov b, __s13 ; "\n"
  swp b
  push b
  call print
  add sp, 2
  leave
  ret

printsn:
  enter 0 ; (push bp; mov bp, sp)
;; print(prompt); 
  lea d, [bp + 5] ; $prompt
  mov b, [d]
  swp b
  push b
  call print
  add sp, 2
;; prints(n); 
  lea d, [bp + 7] ; $n
  mov b, [d]
  swp b
  push b
  call prints
  add sp, 2
;; print("\n"); 
  mov b, __s13 ; "\n"
  swp b
  push b
  call print
  add sp, 2
  leave
  ret

include_stdio_asm:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM BLOCK
.include "lib/stdio.asm"
; --- END INLINE ASM BLOCK

  leave
  ret

print_with_escape:
  enter 0 ; (push bp; mov bp, sp)
;; while (*str) { 
_while34_cond:
  lea d, [bp + 5] ; $str
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
  cmp b, 0
  je _while34_exit
_while34_block:
;; putchar(*str++); 
  lea d, [bp + 5] ; $str
  mov b, [d]
  mov g, b
  inc b
  lea d, [bp + 5] ; $str
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  push bl
  call putchar
  add sp, 1
  jmp _while34_cond
_while34_exit:
  leave
  ret

move_cursor_to_line:
  enter 0 ; (push bp; mov bp, sp)
;; printf("\033["); 
  mov b, __s14 ; "\033["
  swp b
  push b
  call printf
  add sp, 2
;; printu(line + 3); 
  lea d, [bp + 5] ; $line
  mov b, [d]
; START TERMS
  push a
  mov a, b
  mov b, $3
  add a, b
  mov b, a
  pop a
; END TERMS
  swp b
  push b
  call printu
  add sp, 2
;; printf(";0H"); 
  mov b, __s15 ; ";0H"
  swp b
  push b
  call printf
  add sp, 2
  leave
  ret

display_option:
  enter 0 ; (push bp; mov bp, sp)
;; if (highlighted) { 
_if35_cond:
  lea d, [bp + 7] ; $highlighted
  mov b, [d]
  cmp b, 0
  je _if35_exit
_if35_true:
;; print_with_escape("\033[7m"); 
  mov b, __s6 ; "\033[7m"
  swp b
  push b
  call print_with_escape
  add sp, 2
  jmp _if35_exit
_if35_exit:
;; print_with_escape(option); 
  lea d, [bp + 5] ; $option
  mov b, [d]
  swp b
  push b
  call print_with_escape
  add sp, 2
;; print_with_escape("\033[0m"); 
  mov b, __s8 ; "\033[0m"
  swp b
  push b
  call print_with_escape
  add sp, 2
;; print_with_escape("\033[K"); 
  mov b, __s16 ; "\033[K"
  swp b
  push b
  call print_with_escape
  add sp, 2
  leave
  ret
; --- END TEXT BLOCK

; --- BEGIN DATA BLOCK
_options_data: 
.dw __s0, __s1, __s2, 
.fill 6, 0
_filename_data: .db "/home/guest/data.txt", 0
_filename: .dw _filename_data
_guestbook_data: .fill 2, 0
__s0: .db "List Guestbook", 0
__s1: .db "Sign Guestbook", 0
__s2: .db "Exit", 0
__s3: .db "\033[2J", 0
__s4: .db "**** Sol-1 Guestbook ****\n", 0
__s5: .db "\033[?25l", 0
__s6: .db "\033[7m", 0
__s7: .db "Press Return to exit.", 0
__s8: .db "\033[0m", 0
__s9: .db "Soon!!", 0
__s10: .db "\033[?25h", 0
__s11: .db "Error: Unknown argument type.\n", 0
__s12: .db "\033[2J\033[H", 0
__s13: .db "\n", 0
__s14: .db "\033[", 0
__s15: .db ";0H", 0
__s16: .db "\033[K", 0

_heap_top: .dw _heap
_heap: .db 0
; --- END DATA BLOCK

.end
