;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; stdio.s
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.include "lib/string.asm"


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; convert ascii 'o'..'f' to integer 0..15
; ascii in bl
; result in al
; ascii for f = 0100 0110
; ascii for 9 = 0011 1001
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
hex_ascii_encode:
  mov al, bl
  test al, $40        ; test if letter or number
  jnz hex_letter
  and al, $0f        ; get number
  ret
hex_letter:
  and al, $0f        ; get letter
  add al, 9
  ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; atoi
; 2 letter hex string in b
; 8bit integer returned in al
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_atoi:
  push b
  call hex_ascii_encode      ; convert bl to 4bit code in al
  mov bl, bh
  push al          ; save a
  call hex_ascii_encode
  pop bl  
  shl al, 4
  or al, bl
  pop b
  ret  


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; scanf
; no need for explanations!
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
scanf:
  ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; itoa
; 8bit value in bl
; 2 byte ascii result in a
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_itoa:
  push d
  push b
  mov bh, 0
  shr bl, 4  
  mov d, b
  mov al, [d + s_hex_digits]
  mov ah, al
  
  pop b
  push b
  mov bh, 0
  and bl, $0f
  mov d, b
  mov al, [d + s_hex_digits]
  pop b
  pop d
  ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; hex string to binary
; di = destination address
; si = source
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_hex_to_int:
_hex_to_int_l1:
  lodsb          ; load from [si] to al
  cmp al, 0        ; check if ascii 0
  jz _hex_to_int_ret
  mov bh, al
  lodsb
  mov bl, al
  call _atoi        ; convert ascii byte in b to int (to al)
  stosb          ; store al to [di]
  jmp _hex_to_int_l1
_hex_to_int_ret:
  ret    



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; getchar
; char in ah
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
getch:
  push al
getch_retry:
  mov al, 1
  syscall sys_io      ; receive in ah
  pop al
  ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; putchar
; char in ah
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_putchar:
  push al
  mov al, 0
  syscall sys_io      ; char in ah
  pop al
  ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; input a string
;; terminates with null
;; pointer in d
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_gets:
  push a
  push d
_gets_loop:
  mov al, 1
  syscall sys_io      ; receive in ah
  cmp ah, 27
  je _gets_ansi_esc
  cmp ah, $0a        ; lf
  je _gets_end
  cmp ah, $0d        ; cr
  je _gets_end
  cmp ah, $5c        ; '\\'
  je _gets_escape
  cmp ah, $08      ; check for backspace
  je _gets_backspace
  mov al, ah
  mov [d], al
  inc d
  jmp _gets_loop
_gets_backspace:
  dec d
  jmp _gets_loop
_gets_ansi_esc:
  mov al, 1
  syscall sys_io        ; receive in ah without echo
  cmp ah, '['
  jne _gets_loop
  mov al, 1
  syscall sys_io          ; receive in ah without echo
  cmp ah, 'd'
  je _gets_left_arrow
  cmp ah, 'c'
  je _gets_right_arrow
  jmp _gets_loop
_gets_left_arrow:
  dec d
  jmp _gets_loop
_gets_right_arrow:
  inc d
  jmp _gets_loop
_gets_escape:
  mov al, 1
  syscall sys_io      ; receive in ah
  cmp ah, 'n'
  je _gets_lf
  cmp ah, 'r'
  je _gets_cr
  cmp ah, '0'
  je _gets_null
  cmp ah, $5c  ; '\'
  je _gets_slash
  mov al, ah        ; if not a known escape, it is just a normal letter
  mov [d], al
  inc d
  jmp _gets_loop
_gets_slash:
  mov al, $5c
  mov [d], al
  inc d
  jmp _gets_loop
_gets_lf:
  mov al, $0a
  mov [d], al
  inc d
  jmp _gets_loop
_gets_cr:
  mov al, $0d
  mov [d], al
  inc d
  jmp _gets_loop
_gets_null:
  mov al, $00
  mov [d], al
  inc d
  jmp _gets_loop
_gets_end:
  mov al, 0
  mov [d], al        ; terminate string
  pop d
  pop a
  ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; input text
;; terminated with ctrl+d
;; pointer in d
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_gettxt:
  push a
  push d
_gettxt_loop:
  mov al, 1
  syscall sys_io      ; receive in ah
  cmp ah, 4      ; eot
  je _gettxt_end
  cmp ah, $08      ; check for backspace
  je _gettxt_backspace
  cmp ah, $5c        ; '\'
  je _gettxt_escape
  mov al, ah
  mov [d], al
  inc d
  jmp _gettxt_loop
_gettxt_escape:
  mov al, 1
  syscall sys_io      ; receive in ah
  cmp ah, 'n'
  je _gettxt_lf
  cmp ah, 'r'
  je _gettxt_cr
  mov al, ah        ; if not a known escape, it is just a normal letter
  mov [d], al
  inc d
  jmp _gettxt_loop
_gettxt_lf:
  mov al, $0a
  mov [d], al
  inc d
  jmp _gettxt_loop
_gettxt_cr:
  mov al, $0d
  mov [d], al
  inc d
  jmp _gettxt_loop
_gettxt_backspace:
  dec d
  jmp _gettxt_loop
_gettxt_end:
  mov al, 0
  mov [d], al        ; terminate string
  pop d
  pop a
  ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; print new line
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
printnl:
  push a
  mov a, $0a00
  syscall sys_io
  mov a, $0d00
  syscall sys_io
  pop a
  ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; _strtoint
; 4 digit hex string number in d
; integer returned in a
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_strtointx:
  push b
  mov bl, [d]
  mov bh, bl
  mov bl, [d + 1]
  call _atoi        ; convert to int in al
  mov ah, al        ; move to ah
  mov bl, [d + 2]
  mov bh, bl
  mov bl, [d + 3]
  call _atoi        ; convert to int in al
  pop b
  ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; _strtoint
; 5 digit base10 string number in d
; integer returned in a
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_strtoint:
  push si
  push b
  push c
  push d
  call _strlen      ; get string length in c
  dec c
  mov si, d
  mov a, c
  shl a
  mov d, table_power
  add d, a
  mov c, 0
_strtoint_l0:
  lodsb      ; load ascii to al
  cmp al, 0
  je _strtoint_end
  sub al, $30    ; make into integer
  mov ah, 0
  mov b, [d]
  mul a, b      ; result in b since it fits in 16bits
  mov a, b
  mov b, c
  add a, b
  mov c, a
  sub d, 2
  jmp _strtoint_l0
_strtoint_end:
  mov a, c
  pop d
  pop c
  pop b
  pop si
  ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; print null terminated string
; pointer in d
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_puts:
  push a
  push d
_puts_l1:
  mov al, [d]
  cmp al, 0
  jz _puts_end
  mov ah, al
  mov al, 0
  syscall sys_io
  inc d
  jmp _puts_l1
_puts_end:
  pop d
  pop a
  ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; print n size string
; pointer in d
; size in c
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_putsn:
  push al
  push d
  push c
_putsn_l0:
  mov al, [d]
  mov ah, al
  mov al, 0
  syscall sys_io
  inc d
  dec c  
  cmp c, 0
  jne _putsn_l0
_putsn_end:
  pop c
  pop d
  pop al
  ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; print 16bit decimal number
; input number in a
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
print_u16d:
  push a
  push b
  push g
  mov b, 10000
  div a, b      ; get 10000's coeff.
  call print_number
  mov a, b
  mov b, 1000
  div a, b      ; get 1000's coeff.
  call print_number
  mov a, b
  mov b, 100
  div a, b
  call print_number
  mov a, b
  mov b, 10
  div a, b
  call print_number
  mov al, bl      ; 1's coeff in bl
  call print_number
  pop g
  pop b
  pop a
  ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; print al
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
print_number:
  add al, $30
  mov ah, al
  call _putchar
  ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; print 16bit hex integer
; integer value in reg b
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
print_u16x:
  push a
  push b
  push bl
  mov bl, bh
  call _itoa        ; convert bh to char in a
  mov bl, al        ; save al
  mov al, 0
  syscall sys_io        ; display ah
  mov ah, bl        ; retrieve al
  mov al, 0
  syscall sys_io        ; display al

  pop bl
  call _itoa        ; convert bh to char in a
  mov bl, al        ; save al
  mov al, 0
  syscall sys_io        ; display ah
  mov ah, bl        ; retrieve al
  mov al, 0
  syscall sys_io        ; display al

  pop b
  pop a
  ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; input 16bit hex integer
; read 16bit integer into a
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
scan_u16x:
  enter 16
  push b
  push d

  lea d, [bp + -15]
  call _gets        ; get number

  mov bl, [d]
  mov bh, bl
  mov bl, [d + 1]
  call _atoi        ; convert to int in al
  mov ah, al        ; move to ah

  mov bl, [d + 2]
  mov bh, bl
  mov bl, [d + 3]
  call _atoi        ; convert to int in al

  pop d
  pop b
  leave
  ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; print 8bit hex integer
; integer value in reg bl
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
print_u8x:
  push a
  push bl

  call _itoa        ; convert bl to char in a
  mov bl, al        ; save al
  mov al, 0
  syscall sys_io        ; display ah
  mov ah, bl        ; retrieve al
  mov al, 0
  syscall sys_io        ; display al

  pop bl
  pop a
  ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; print 8bit decimal unsigned number
; input number in al
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
print_u8d:
  push a
  push b
  push g
  mov ah, 0
  mov b, 100
  div a, b
  push b      ; save remainder
  cmp al, 0
  je skip100
  add al, $30
  mov ah, al
  mov al, 0
  syscall sys_io  ; print coeff
skip100:
  pop a
  mov ah, 0
  mov b, 10
  div a, b
  push b      ; save remainder
  cmp al, 0
  je skip10
  add al, $30
  mov ah, al
  mov al, 0
  syscall sys_io  ; print coeff
skip10:
  pop a
  mov al, bl
  add al, $30
  mov ah, al
  mov al, 0
  syscall sys_io  ; print coeff
  pop g
  pop b
  pop a
  ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; input 8bit hex integer
; read 8bit integer into al
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
scan_u8x:
  enter 4
  push b
  push d

  lea d, [bp + -3]
  call _gets        ; get number

  mov bl, [d]
  mov bh, bl
  mov bl, [d + 1]
  call _atoi        ; convert to int in al

  pop d
  pop b
  leave
  ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; input decimal number
; result in a
; 655'\0'
; low--------high
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
scan_u16d:
  enter 8
  push si
  push b
  push c
  push d
  lea d, [bp +- 7]
  call _gets
  call _strlen      ; get string length in c
  dec c
  mov si, d
  mov a, c
  shl a
  mov d, table_power
  add d, a
  mov c, 0
mul_loop:
  lodsb      ; load ascii to al
  cmp al, 0
  je mul_exit
  sub al, $30    ; make into integer
  mov ah, 0
  mov b, [d]
  mul a, b      ; result in b since it fits in 16bits
  mov a, b
  mov b, c
  add a, b
  mov c, a
  sub d, 2
  jmp mul_loop
mul_exit:
  mov a, c
  pop d
  pop c
  pop b
  pop si
  leave
  ret


s_hex_digits:    .db "0123456789abcdef"  
s_telnet_clear:  .db "\033[2j\033[h", 0

table_power:
  .dw 1
  .dw 10
  .dw 100
  .dw 1000
  .dw 10000