;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 74 series minicomputer bios version 1.0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; memory map
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 0000    rom begin
; ....
; 7fff    rom end
;
; 8000    ram begin
; ....
; f7ff    stack root

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; i/o map
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ff80    uart 0    (16550)
; ff90    uart 1    (16550)
; ffa0    rtc       (m48t02)
; ffb0    pio 0     (8255)
; ffc0    pio 1     (8255)
; ffd0    ide       (compact flash / pata)
; ffe0    timer     (8253)
; fff0    bios configuration nv-ram store area

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; system constants / equations
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_uart0_data      .equ $ff80        		 ; data
_uart0_dlab_0    .equ $ff80        		 ; divisor latch low byte
_uart0_dlab_1    .equ $ff81        		 ; divisor latch high byte
_uart0_ier       .equ $ff81        		 ; interrupt enable register
_uart0_fcr       .equ $ff82        		 ; fifo control register
_uart0_lcr       .equ $ff83        		 ; line control register
_uart0_lsr       .equ $ff85        		 ; line status register

_ide_base        .equ $ffd0        		 ; ide base
_ide_r0          .equ _ide_base + 0    ; data port
_ide_r1          .equ _ide_base + 1    ; read: error code, write: feature
_ide_r2          .equ _ide_base + 2    ; number of sectors to transfer
_ide_r3          .equ _ide_base + 3    ; sector address lba 0 [0:7]
_ide_r4          .equ _ide_base + 4    ; sector address lba 1 [8:15]
_ide_r5          .equ _ide_base + 5    ; sector address lba 2 [16:23]
_ide_r6          .equ _ide_base + 6    ; sector address lba 3 [24:27 (lsb)]
_ide_r7          .equ _ide_base + 7    ; read: status, write: command

_7seg_display    .equ $ffb0        		 ; bios post code hex display (2 digits)
_bios_post_ctrl  .equ $ffb3        		 ; bios post display control register, 80h = as output
_pio_a           .equ $ffb0    
_pio_b           .equ $ffb1
_pio_c           .equ $ffb2
_pio_control     .equ $ffb3        		 ; pio control port

_timer_c_0       .equ $ffe0        		 ; timer counter 0
_timer_c_1       .equ $ffe1        		 ; timer counter 1
_timer_c_2       .equ $ffe2        		 ; timer counter 2
_timer_ctrl      .equ $ffe3        		 ; timer control register

_stack_begin     .equ $f7ff       		 ; beginning of stack
_global_base     .equ $8000       		 ; base of global variable block


boot_origin:     .equ _global_base + 2 + 2

ide_buffer:      .equ _global_base + 2 + 2 + 512

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; global system variables
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; external interrupt table
; highest priority at lowest address
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.dw int_0
.dw int_1
.dw int_2
.dw int_3
.dw int_4
.dw int_5
.dw int_6
.dw int_7

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; reset vector declaration
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.dw bios_reset_vector

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; exception vector table
;; total of 7 entries, starting at address $0012
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.dw trap_privilege  
.dw trap_div_zero  
.dw undefined_opcode
.dw 0
.dw 0
.dw 0
.dw 0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; system call vector table
;; starts at address $0020
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.dw trap_breakpoint
.dw rtc_services        
.dw uart_services        
.dw ide_services  
.dw 0
.dw 0
.dw 0
.dw 0
.dw 0
.dw 0  

bios_bkpt  .equ 0
bios_rtc   .equ 1
bios_uart  .equ 2
bios_ide   .equ 3

.export bios_reset_vector
.export ide_buffer
.export boot_origin
.export bios_uart
.export bios_ide
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; external interrupts' code block
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
int_0:
  sysret
int_1:
  sysret
int_2:
  sysret
int_3:
  sysret
int_4:
  sysret
int_5:
  sysret
int_6:  
  sysret
int_7:
  sysret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; exceptions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; privilege exception
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
trap_privilege:
  push d
  mov d, s_priv1
  call _puts
  pop d
              ; enable interrupts
  sysret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; breakpoint exception
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
trap_breakpoint:
  push a
  push d
  pushf
  
  mov d, s_bkpt
  call _puts
  
  popf
  pop d
  pop a
              ; enable interrupts
  sysret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; divide by zero exception
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
trap_div_zero:
  push a
  push d
  pushf
  
  mov d, s_divzero
  call _puts
  
  popf
  pop d
  pop a
              ; enable interrupts
  sysret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; undefined opcode exception
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
undefined_opcode:
  sysret
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; rtc services interrupt
; rtc i/o bank = ffa0 to ffaf
; ffa0 to ffa7 is scratch ram
; control register at $ffa8 [ w | r | s | cal4..cal0 ]
; al = 0..6 -> get
; al = 7..d -> set
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
rtc_services:
  push al
  push d
  cmp al, 6
  jgu rtc_set
rtc_get:
  add al, $a9      ; generate rtc address to get to address a9 of clock
  mov ah, $ff    
  mov d, a        ; get to ffa9 + offset
  mov byte[$ffa8], $40    ; set r bit to 1
  mov al, [d]      ; get data
  mov byte[$ffa8], 0    ; reset r bit
  mov ah, al
  pop d
  pop al
  sysret
rtc_set:
  push bl
  mov bl, ah    ; set data aside
  add al, $a2    ; generate rtc address to get to address a9 of clock
  mov ah, $ff    
  mov d, a    ; get to ffa9 + offset
  mov al, bl    ; get data back
  mov byte[$ffa8], $80  ; set w bit to 1
  mov [d], al    ; set data
  mov byte[$ffa8], 0    ; reset write bit
  pop bl
  pop d
  pop al
  sysret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; int 4
; uart services interrupt
; al = option
; ah = data
; 0 = init, 1 = send, 2 = receive, 3 = receive with echo
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
uart_serv_tbl:
  .dw uart_init
  .dw uart_send
  .dw uart_receive
  .dw uart_receive_e
uart_services:
  jmp [uart_serv_tbl + al]

uart_init:
  mov byte[_uart0_lcr], %10001111      ; 8 data, 2 stop, odd parity, divisor latch = 1, uart address 3 = line control register
  mov byte[_uart0_dlab_0], 3      ; baud = 38400
  mov byte[_uart0_dlab_1], 0      ; divisor latch high byte = 0      
  mov byte[_uart0_lcr], %00001111      ; divisor latch = 0, uart address 3 = line control register
  mov byte[_uart0_ier], 0      ; disable all uart interrupts
  mov byte[_uart0_fcr], 0      ; disable fifo
  sysret

uart_send:
  mov al, [_uart0_lsr]      ; read line status register
  test al, 20h          ; isolate transmitter empty
  jz uart_send    
  mov al, ah
  mov [_uart0_data], al      ; write char to transmitter holding register
  sysret

uart_receive:
  mov al, [_uart0_lsr]      ; read line status register
  test al, 1          ; isolate data ready
  jz uart_receive
  mov al, [_uart0_data]      ; get character
  mov ah, al
  sysret

uart_receive_e:
  mov al, [_uart0_lsr]      ; read line status register
  test al, 1          ; isolate data ready
  jz uart_receive_e
  mov al, [_uart0_data]      ; get character
  mov ah, al
uart_receive_e_loop:
  mov al, [_uart0_lsr]      ; read line status register
  test al, 20h          ; isolate transmitter empty
  jz uart_receive_e_loop
  mov al, ah
  mov [_uart0_data], al      ; write char to transmitter holding register
  sysret
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ide services interrupt
; al = option
; 0 = ide reset, 1 = ide sleep, 2 = read sector, 3 = write sector
; ide read/write sector
; 512 bytes
; user buffer pointer in d
; kernel buffer pointer = ide_buffer
; ah = number of sectors
; cb = lba bytes 3..0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ide_serv_tbl:
  .dw ide_reset
  .dw ide_sleep
  .dw ide_read_sect
  .dw ide_write_sect
ide_services:
  jmp [ide_serv_tbl + al]  
ide_reset:      
  mov byte[_ide_r7], 4    ; reset ide
  call ide_wait        ; wait for ide ready             
  mov byte[_ide_r6], $e0    ; lba3= 0, master, mode= lba        
  mov byte[_ide_r1], 1    ; 8-bit transfers      
  mov byte[_ide_r7], $ef    ; set feature command
  sysret
ide_sleep:
  call ide_wait          ; wait for ide ready             
  mov byte [_ide_r6], %01000000  ; lba[3:0](reserved), bit 6=1
  mov byte [_ide_r7], $e6    ; sleep command
  call ide_wait          ; wait for ide ready
  sysret
ide_read_sect:
  mov al, ah
  mov ah, bl
  mov [_ide_r2], a      ; number of sectors (0..255)
  mov al, bh
  mov [_ide_r4], al
  mov a, c
  mov [_ide_r5], al
  mov al, ah
  and al, %00001111
  or al, %11100000      ; mode lba, master
  mov [_ide_r6], al
  call ide_wait
  mov al, 20h
  mov [_ide_r7], al      ; read sector cmd
  call ide_read  
  sysret
ide_write_sect:
  mov al, ah
  mov ah, bl
  mov [_ide_r2], a      ; number of sectors (0..255)
  mov al, bh
  mov [_ide_r4], al
  mov a, c
  mov [_ide_r5], al
  mov al, ah
  and al, %00001111
  or al, %11100000      ; mode lba, master
  mov [_ide_r6], al
  call ide_wait
  mov al, 30h
  mov [_ide_r7], al      ; write sector cmd
  call ide_write      
  sysret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; read ide data
; pointer in d
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ide_read:
  push al
  push d
ide_read_loop:
  call ide_wait
  mov al, [_ide_r7]
  and al, %00001000      ; drq flag
  jz ide_read_end
  mov al, [_ide_r0]
  mov [d], al
  inc d
  jmp ide_read_loop
ide_read_end:
  pop d
  pop al
  ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; write ide data
; data pointer in d
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ide_write:
  push al
  push d
ide_write_loop:
  call ide_wait
  mov al, [_ide_r7]
  and al, %00001000      ; drq flag
  jz ide_write_end
  mov al, [d]
  mov [_ide_r0], al
  inc d 
  jmp ide_write_loop
ide_write_end:
  pop d
  pop al
  ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; wait for ide to be ready
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ide_wait:
  mov al, [_ide_r7]  
  and al, 80h        ; busy flag
  jnz ide_wait
  ret

; ************************************************************
; get hex file
; di = destination address
; return length in bytes in c
; ************************************************************
_load_hex:
  push bp
  mov bp, sp
  push a
  push b
  push d
  push si
  push di
  sub sp, $6000        ; string data block
  mov c, 0
  
  mov a, sp
  inc a
  mov d, a        ; start of string data block
  call _getse        ; get program string
  mov si, a

__load_hex_loop:
  lodsb          ; load from [SI] to AL
  cmp al, 0        ; check if ASCII 0
  jz __load_hex_ret
  mov bh, al
  lodsb
  mov bl, al
  call _atoi        ; convert ASCII byte in B to int (to AL)
  stosb          ; store AL to [DI]
  inc c
  jmp __load_hex_loop
__load_hex_ret:
  add sp, $6000
  pop di
  pop si
  pop d
  pop b
  pop a
  mov sp, bp
  pop bp
  ret
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; bios entry point
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
bios_reset_vector:
  mov al, %00000000        ; interrupts = off, mode = sup, paging = off, halt-flag = off, display_load = on
  stostat
  
  mov a, _stack_begin
  mov sp, a
  mov bp, a      ; setup stack and frame

  mov al, 0
  syscall bios_uart
  
  mov d, s_welcome
  call _puts          ; print welcome msg

  call bios_peripherals_setup
  
  mov d, s_boot1
  call _puts
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  
  mov c, 0
  mov b, 0          ; start at disk sector 0
  mov d, boot_origin    ; we read into the bios ide buffer
  mov a, $0102        ; disk read, 1 sector
  syscall bios_ide      ; read sector  
  
  mov d, s_boot2
  call _puts

  jmp boot_origin

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

bios_peripherals_setup:
  mov d, s_init
  call _puts
  
  mov d, s_bios3
  call _puts
  mov al, 0            ; reset ide
  syscall bios_ide  
  
  mov d, s_bios4
  call _puts
  
  mov al, %00110000          ; counter 0, load both bytes, mode 0, binary
  mov [_timer_ctrl], al
  mov al, $ff
  mov [_timer_c_0], al        ; load counter 0 low byte
  mov [_timer_c_0], al        ; load counter 0 high byte
  
  mov d, s_bios5
  call _puts
  mov al, $80
  mov [_bios_post_ctrl], al      ; set pio_a to output mode
  mov al, 0
  mov [_7seg_display], al      ; post code = 00
  ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; print 16bit hex integer
; integer value in reg b
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
print_u16x:
  pushf
  push a
  push b
  push bl
  mov bl, bh
  call _itoa        ; convert bh to char in a
  mov bl, al        ; save al  
  mov al, 1
  syscall bios_uart        ; display ah
  mov ah, bl        ; retrieve al
  mov al, 1
  syscall bios_uart        ; display al

  pop bl
  call _itoa        ; convert bh to char in a
  mov bl, al        ; save al
  mov al, 1
  syscall bios_uart        ; display ah
  mov ah, bl        ; retrieve al
  mov al, 1
  syscall bios_uart        ; display al

  pop b
  pop a
  popf
  ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; input 16bit hex integer
; read 16bit integer into a
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
scan_u16x:
  enter 16
  pushf
  push b
  push d

  lea d, [bp + -15]
  call _getse        ; get number

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
  popf
  leave
  ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; print 8bit hex integer
; byte value in reg bl
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
xput_u8:
  push a
  push bl
  pushf

  call _itoa          ; convert bl to char in a
  mov bl, al          ; save al  
  mov al, 1
  syscall bios_uart        ; display ah
  mov ah, bl          ; retrieve al
  mov al, 1
  syscall bios_uart        ; display al
  
  popf
  pop bl
  pop a
  ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; print null terminated string
; pointer in d
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_puts:
  push a
  push d
  pushf
_puts_l1:
  mov al, [d]
  cmp al, 0
  jz _puts_end
_puts_l2:
  mov al, [_uart0_lsr]      ; read line status register
  test al, $20          ; isolate transmitter empty
  jz _puts_l2    
  mov al, [d]
  mov [_uart0_data], al      ; write char to transmitter holding register
  inc d  
  jmp _puts_l1
_puts_end:
  popf
  pop d
  pop a
  ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; _putchar
; char in ah
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_putchar:
  push a
  pushf
_putchar_l1:
  mov al, [_uart0_lsr]      ; read line status register
  test al, 20h          ; isolate transmitter empty
  jz _putchar_l1    
  mov al, ah
  mov [_uart0_data], al      ; write char to transmitter holding register
  popf
  pop a
  ret
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; input a string with no echo
;; terminates with null
;; pointer in d
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_gets:
  pushf
  push a
  push d
_gets_loop:
  mov al, 2
  syscall bios_uart      ; receive in ah
  cmp ah, 0ah        ; lf
  je _gets_end
  cmp ah, 0dh        ; cr
  je _gets_end
  cmp ah, $5c        ; '\\'
  je _gets_escape
  mov al, ah
  mov [d], al
  inc d
  jmp _gets_loop
_gets_escape:
  mov al, 2
  syscall bios_uart      ; receive in ah
  cmp ah, 'n'
  je _gets_lf
  cmp ah, 'r'
  je _gets_cr
  mov al, ah        ; if not a known escape, it is just a normal letter
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
_gets_end:
  mov al, 0
  mov [d], al        ; terminate string
  pop d
  pop a
  popf
  ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; INPUT A STRING with echo
;; terminates with null
;; pointer in D
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_getse:
  pushf
  push a
  push d
_getse_loop:
  mov al, 3
  syscall bios_uart      ; receive in AH
  cmp ah, 0Ah        ; LF
  je _getse_end
  cmp ah, 0Dh        ; CR
  je _getse_end
  cmp ah, $5C        ; '\\'
  je _getse_escape
  mov al, ah
  mov [d], al
  inc d
  jmp _getse_loop
_getse_escape:
  mov al, 3
  syscall bios_uart      ; receive in AH
  cmp ah, 'n'
  je _getse_LF
  cmp ah, 'r'
  je _getse_CR
  mov al, ah        ; if not a known escape, it is just a normal letter
  mov [d], al
  inc d
  jmp _getse_loop
_getse_LF:
  mov al, $0A
  mov [d], al
  inc d
  jmp _getse_loop
_getse_CR:
  mov al, $0D
  mov [d], al
  inc d
  jmp _getse_loop
_getse_end:
  mov al, 0
  mov [d], al        ; terminate string
  pop d
  pop a
  popf
  ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; PRINT NEW LINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
put_nl:
  pushf
  push a
  mov a, $0A01
  syscall bios_uart
  mov a, $0D01
  syscall bios_uart
  pop a
  popf
  ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; CONVERT ASCII 'O'..'F' TO INTEGER 0..15
; ASCII in BL
; result in AL
; ascii for F = 0100 0110
; ascii for 9 = 0011 1001
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
hex_ascii_encode:
  mov al, bl  
  test al, 40h        ; test if letter or number
  jnz hex_letter
  and al, 0Fh        ; get number
  ret
hex_letter:
  push ah
  mov ah, bl
  call _to_upper
  mov al, ah  
  and al, 0Fh        ; get letter
  add al, 9
  pop ah
  ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ATOI
; 2 letter hex string in B
; 8bit integer returned in AL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_atoi:
  pushf
  push b
    
  call hex_ascii_encode      ; convert BL to 4bit code in AL
  mov bl, bh
  push al          ; save a
  call hex_ascii_encode
  pop bl  
  shl al, 4
  or al, bl
  
  pop b
  popf
  ret  

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ITOA
; 8bit value in BL
; 2 byte ASCII result in A
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_itoa:
  pushf
  push d
  push bh
  push bl

  mov bh, 0
  
  and bl, $0F
  mov d, s_hex_digits
  add d, b
  mov al, [d]        ; get ASCII
  pop bl
  sub sp, 1        ; push bl back
  push al
  
  and bl, $F0
  shr bl, 4
  mov d, s_hex_digits
  add d, b
  mov al, [d]        ; get ASCII

  mov ah, al
  pop al  
  
  pop bl
  pop bh
  pop d
  popf
  ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; STRCMP
; compare two strings
; str1 in SI
; str2 in DI
; changes: AL SI DI
; CREATE A STRING COMPAIRON INSTRUCION ?????
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_strcmp:
_strcmp_loop:
  cmpsb          ; compare a byte of the strings
  jne _strcmp_ret
  lea d, [si + -1]
  mov al, [d]
  cmp al, 0        ; check if at end of string (null)
  jne _strcmp_loop        ; equal chars but not at end
_strcmp_ret:        
  ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; TO LOWER
; input in AL
; output in AL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_to_lower:
  pushf
  cmp al, 'Z'
  jgu _to_lower_ret
  add al, 20h        ; convert to lower case
_to_lower_ret:
  popf
  ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; TO UPPER
; input in AL
; output in AL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_to_upper:
  pushf
  cmp al, 'a'
  jlu _to_upper_ret
  sub al, 20h        ; convert to upper case
_to_upper_ret:
  popf
  ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; PRINT DECIMAL INTEGER
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
print_decimal:
  ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; GET HEX FILE
; di = destination address
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
load_hex:
  enter $6000
  
  mov a, $9000          ; destination
  mov di, a  
            ; string data block
  lea d, [bp + -24575]      ; start of string data block
  call _getse          ; get program string
  mov a, d
  mov si, a
load_hex_loop:
  lodsb          ; load from [SI] to AL
  cmp al, 0        ; check if ASCII 0
  jz load_hex_ret
  mov bh, al
  lodsb
  mov bl, al
  call _atoi        ; convert ASCII byte in B to int (to AL)
  stosb          ; store AL to [DI]
  jmp load_hex_loop
load_hex_ret:
  leave
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
; data block
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
s_welcome:      .db "\n\n\rSol-1 74HC HomebrewCPU MiniComputer\n"
                .db "BIOS Version 0.1\n\n\r"
                .db "terminal-1 initialized\n\r", 0
        
s_boot1:        .db "reading boot sector\n\r", 0
s_boot2:        .db "boot-sector read\n\r", 0
        
s_bios3:        .db "resetting IDE-drive\n\r", 0
s_bios4:        .db "configuring Timer-1\n\r", 0
s_bios5:        .db "PIO-A set to output mode\n\r", 0

s_init:         .db "entering real-mode [supervisor on; paging off]\n\r"
                .db "interrupts disabled\n\r"
                .db "display register loading disabled\n\r", 0

s_nl_2:         .db "\n"
s_nl_1:         .db "\n\r", 0

s_enter_prog:   .db "data: ", 0
s_origin_addr:  .db "origin address: ", 0

s_ide_serial:   .db "Serial: ", 0
s_ide_firm:     .db "Firmware: ", 0
s_ide_model:    .db "Model: ", 0
s_sectors:      .db "Number of sectors: ", 0
s_lba0:         .db "LBA 0: ", 0
s_lba1:         .db "LBA 1: ", 0
s_lba2:         .db "LBA 2: ", 0
s_lba3:         .db "LBA 3: ", 0
s_error:        .db "\n\rError.\n\r", 0
                
s_hex_digits:   .db "0123456789ABCDEF"
s_bkpt:         .db "this is the breakpoint.", 0
                
s_priv1:        .db "\n\n\rsoftware failure: privilege exception "
                .db "press any key to continue...\n\r", 0
s_divzero:      .db "\n\rexception: zero division\n\r", 0

.end
