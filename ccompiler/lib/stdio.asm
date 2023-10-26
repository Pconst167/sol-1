;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; stdio.s
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.include "lib/string.asm"


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; CONVERT ASCII 'O'..'F' TO INTEGER 0..15
; ASCII in BL
; result in AL
; ascii for F = 0100 0110
; ascii for 9 = 0011 1001
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
hex_ascii_encode:
  mov al, bl
  test al, $40        ; test if letter or number
  jnz hex_letter
  and al, $0F        ; get number
  ret
hex_letter:
  and al, $0F        ; get letter
  add al, 9
  ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ATOI
; 2 letter hex string in B
; 8bit integer returned in AL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_atoi:
  push b
  call hex_ascii_encode      ; convert BL to 4bit code in AL
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
; ITOA
; 8bit value in BL
; 2 byte ASCII result in A
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
  and bl, $0F
  mov d, b
  mov al, [d + s_hex_digits]
  pop b
  pop d
  ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; HEX STRING TO BINARY
; di = destination address
; si = source
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_hex_to_int:
_hex_to_int_L1:
  lodsb          ; load from [SI] to AL
  cmp al, 0        ; check if ASCII 0
  jz _hex_to_int_ret
  mov bh, al
  lodsb
  mov bl, al
  call _atoi        ; convert ASCII byte in B to int (to AL)
  stosb          ; store AL to [DI]
  jmp _hex_to_int_L1
_hex_to_int_ret:
  ret    



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; GETCHAR
; char in ah
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
getch:
  push al
getch_retry:
  mov al, 1
  syscall sys_io      ; receive in AH
  pop al
  ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; PUTCHAR
; char in ah
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_putchar:
  push a
  mov al, 0
  syscall sys_io      ; char in AH
  pop a
  ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; INPUT A STRING
;; terminates with null
;; pointer in D
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_gets:
  push a
  push d
_gets_loop:
  mov al, 1
  syscall sys_io      ; receive in AH
  cmp al, 0        ; check error code (AL)
  je _gets_loop      ; if no char received, retry

  cmp ah, 27
  je _gets_ansi_esc
  cmp ah, $0A        ; LF
  je _gets_end
  cmp ah, $0D        ; CR
  je _gets_end
  cmp ah, $5C        ; '\\'
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
  syscall sys_io        ; receive in AH without echo
  cmp al, 0          ; check error code (AL)
  je _gets_ansi_esc    ; if no char received, retry
  cmp ah, '['
  jne _gets_loop
_gets_ansi_esc_2:
  mov al, 1
  syscall sys_io          ; receive in AH without echo
  cmp al, 0            ; check error code (AL)
  je _gets_ansi_esc_2  ; if no char received, retry
  cmp ah, 'D'
  je _gets_left_arrow
  cmp ah, 'C'
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
  syscall sys_io      ; receive in AH
  cmp al, 0        ; check error code (AL)
  je _gets_escape      ; if no char received, retry
  cmp ah, 'n'
  je _gets_LF
  cmp ah, 'r'
  je _gets_CR
  cmp ah, '0'
  je _gets_NULL
  cmp ah, $5C  ; '\'
  je _gets_slash
  mov al, ah        ; if not a known escape, it is just a normal letter
  mov [d], al
  inc d
  jmp _gets_loop
_gets_slash:
  mov al, $5C
  mov [d], al
  inc d
  jmp _gets_loop
_gets_LF:
  mov al, $0A
  mov [d], al
  inc d
  jmp _gets_loop
_gets_CR:
  mov al, $0D
  mov [d], al
  inc d
  jmp _gets_loop
_gets_NULL:
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
;; INPUT TEXT
;; terminated with CTRL+D
;; pointer in D
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_gettxt:
  push a
  push d
_gettxt_loop:
  mov al, 1
  syscall sys_io      ; receive in AH
  cmp al, 0        ; check error code (AL)
  je _gettxt_loop    ; if no char received, retry
  cmp ah, 4      ; EOT
  je _gettxt_end
  cmp ah, $08      ; check for backspace
  je _gettxt_backspace
  cmp ah, $5C        ; '\'
  je _gettxt_escape
  mov al, ah
  mov [d], al
  inc d
  jmp _gettxt_loop
_gettxt_escape:
  mov al, 1
  syscall sys_io      ; receive in AH
  cmp al, 0        ; check error code (AL)
  je _gettxt_escape    ; if no char received, retry
  cmp ah, 'n'
  je _gettxt_LF
  cmp ah, 'r'
  je _gettxt_CR
  mov al, ah        ; if not a known escape, it is just a normal letter
  mov [d], al
  inc d
  jmp _gettxt_loop
_gettxt_LF:
  mov al, $0A
  mov [d], al
  inc d
  jmp _gettxt_loop
_gettxt_CR:
  mov al, $0D
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
; PRINT NEW LINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
printnl:
  push a
  mov a, $0A00
  syscall sys_io
  mov a, $0D00
  syscall sys_io
  pop a
  ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; _strtoint
; 4 digit hex string number in d
; integer returned in A
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_strtointx:
  push b
  mov bl, [d]
  mov bh, bl
  mov bl, [d + 1]
  call _atoi        ; convert to int in AL
  mov ah, al        ; move to AH
  mov bl, [d + 2]
  mov bh, bl
  mov bl, [d + 3]
  call _atoi        ; convert to int in AL
  pop b
  ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; _strtoint
; 5 digit base10 string number in d
; integer returned in A
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_strtoint:
  push si
  push b
  push c
  push d
  call _strlen      ; get string length in C
  dec c
  mov si, d
  mov a, c
  shl a
  mov d, table_power
  add d, a
  mov c, 0
_strtoint_L0:
  lodsb      ; load ASCII to al
  cmp al, 0
  je _strtoint_end
  sub al, $30    ; make into integer
  mov ah, 0
  mov b, [d]
  mul a, b      ; result in B since it fits in 16bits
  mov a, b
  mov b, c
  add a, b
  mov c, a
  sub d, 2
  jmp _strtoint_L0
_strtoint_end:
  mov a, c
  pop d
  pop c
  pop b
  pop si
  ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; PRINT NULL TERMINATED STRING
; pointer in D
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_puts:
  push a
  push d
_puts_L1:
  mov al, [d]
  cmp al, 0
  jz _puts_END
  mov ah, al
  mov al, 0
  syscall sys_io
  inc d
  jmp _puts_L1
_puts_END:
  pop d
  pop a
  ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; PRINT N SIZE STRING
; pointer in D
; size in C
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_putsn:
  push al
  push d
  push c
_putsn_L0:
  mov al, [d]
  mov ah, al
  mov al, 0
  syscall sys_io
  inc d
  dec c  
  cmp c, 0
  jne _putsn_L0
_putsn_end:
  pop c
  pop d
  pop al
  ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; print 16bit decimal number
; input number in A
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
print_u16d:
  push a
  push b
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
  pop b
  pop a
  ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; print AL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
print_number:
  add al, $30
  mov ah, al
  call _putchar
  ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; PRINT 16BIT HEX INTEGER
; integer value in reg B
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
print_u16x:
  push a
  push b
  push bl
  mov bl, bh
  call _itoa        ; convert bh to char in A
  mov bl, al        ; save al
  mov al, 0
  syscall sys_io        ; display AH
  mov ah, bl        ; retrieve al
  mov al, 0
  syscall sys_io        ; display AL

  pop bl
  call _itoa        ; convert bh to char in A
  mov bl, al        ; save al
  mov al, 0
  syscall sys_io        ; display AH
  mov ah, bl        ; retrieve al
  mov al, 0
  syscall sys_io        ; display AL

  pop b
  pop a
  ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; INPUT 16BIT HEX INTEGER
; read 16bit integer into A
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
  call _atoi        ; convert to int in AL
  mov ah, al        ; move to AH

  mov bl, [d + 2]
  mov bh, bl
  mov bl, [d + 3]
  call _atoi        ; convert to int in AL

  pop d
  pop b
  leave
  ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; PRINT 8bit HEX INTEGER
; integer value in reg bl
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
print_u8x:
  push a
  push bl

  call _itoa        ; convert bl to char in A
  mov bl, al        ; save al
  mov al, 0
  syscall sys_io        ; display AH
  mov ah, bl        ; retrieve al
  mov al, 0
  syscall sys_io        ; display AL

  pop bl
  pop a
  ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; print 8bit decimal unsigned number
; input number in AL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
print_u8d:
  push a
  push b

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
  pop b
  pop a
  ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; INPUT 8BIT HEX INTEGER
; read 8bit integer into AL
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
  call _atoi        ; convert to int in AL

  pop d
  pop b
  leave
  ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; input decimal number
; result in A
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
  call _strlen      ; get string length in C
  dec c
  mov si, d
  mov a, c
  shl a
  mov d, table_power
  add d, a
  mov c, 0
mul_loop:
  lodsb      ; load ASCII to al
  cmp al, 0
  je mul_exit
  sub al, $30    ; make into integer
  mov ah, 0
  mov b, [d]
  mul a, b      ; result in B since it fits in 16bits
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


s_hex_digits:    .db "0123456789ABCDEF"  
s_telnet_clear:  .db "\033[2J\033[H", 0

table_power:
  .dw 1
  .dw 10
  .dw 100
  .dw 1000
  .dw 10000