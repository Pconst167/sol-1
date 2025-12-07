.include bios.exp

.org boot_origin
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; system constants / equations
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_uart0_data      .equ $ff80            ; data
_uart0_dlab_0    .equ $ff80            ; divisor latch low byte
_uart0_dlab_1    .equ $ff81            ; divisor latch high byte
_uart0_ier       .equ $ff81            ; interrupt enable register
_uart0_fcr       .equ $ff82            ; fifo control register
_uart0_lcr       .equ $ff83            ; line control register
_uart0_lsr       .equ $ff85            ; line status register

_ide_base        .equ $ffd0            ; ide base
_ide_r0          .equ _ide_base + 0    ; data port
_ide_r1          .equ _ide_base + 1    ; read: error code, write: feature
_ide_r2          .equ _ide_base + 2    ; number of sectors to transfer
_ide_r3          .equ _ide_base + 3    ; sector address lba 0 [0:7]
_ide_r4          .equ _ide_base + 4    ; sector address lba 1 [8:15]
_ide_r5          .equ _ide_base + 5    ; sector address lba 2 [16:23]
_ide_r6          .equ _ide_base + 6    ; sector address lba 3 [24:27 (lsb)]
_ide_r7          .equ _ide_base + 7    ; read: status, write: command

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; setting up kernel process.
; map kernel memory to bios 64kb
; 32 pages of 2kb = 64kb
; bl = ptb
; bh = page number (5bits)
; a = physical address
; for kernel, a goes from 0 to 31, but for the last page, bit '11' must be 1 for device space
; bl = 0
; bh(ms 5 bits) = 0 to 31
; a = 0000_1000_000_00000
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
setup_kernel_mem:
  mov d, s_boot1
  call _puts
  
  mov d, s_kernel_setup
  call _puts
; map pages 0 to 30 to normal kernel ram memory.
  mov bl, 0             ; set ptb = 0 for kernel
  mov bh, 0             ; start at page 0
  mov a, 0              ; set mem/io bit to memory.  this means physical address starting at 0, but in memory space as opposed to device space.
map_kernel_mem_l1:
  pagemap               ; write page table entry
  add b, $0800          ; increase page number (msb 5 bits of bh only)
  inc al                ; increase both 
  cmp al, 31            ; check to see if we reached the end of memory for kernel
  jne map_kernel_mem_l1
  
; here we map the last page of kernel memory, to device space, or the last 2kb of bios memory so that the kernel has access to io devices.
  or a, $0800           ; set mem/io bit to device, for physical address
  pagemap               ; write page table entry
  
  mov al, 0
  setptb                ; set process number to 0 (strictly not needed since we are in supervisor mode)
                        ; which forces the page number to 0
  mov d, s_boot
  call _puts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  
; we read sector 0, in order to obtain the lba location of the kernel in the disk
; this kernel lba is actually the second sector because the first sector is the usual file block
; header and has no useful kernel data.
  mov c, 0
  mov b, 0                   ; start at disk sector 1
  mov d, ide_buffer          ; we read into the bios ide buffer
  mov a, $0102               ; disk read, 1 sector
  syscall bios_ide           ; read sector
  mov a, [ide_buffer + 510]  ; here we now have the kernel's lba location in disk
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  mov b, a                   ; transfer the sector number into register b for use below
  push a                     ; also, save the lba value for later
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  
; having obtained the first kernel sector address,
; we read the first kernel sector, in order to obtain the reset vector at location $10
  mov c, 0
  mov d, ide_buffer           ; we read into the bios ide buffer
  mov a, $0102                ; disk read, 1 sector
  syscall bios_ide            ; read sector
  mov a, [ide_buffer + $10]   ; here we now have the kernel reset vector
  mov g, a                    ; save reset vector in g  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
; read operating system into kernel memory
  pop b                       ; pop the kernel's starting lba address that we pushed into the stack earlier
                              ; as we now need to load the kernel from disk, from that lba address
  mov c, 0
  mov d, ide_buffer           ; we read into the bios ide buffer
  mov a, $3102                ; disk read, 31 sectors. 31 sectors because the first sector of the kernel is just a file block header
                              ; used to tell whether that block is taken. so the file really has 31 sectors 
                              ; in this current file system (which is a hack and is temporary)
  syscall bios_ide            ; read sector
  mov c, 512 * 31             ; 31 sectors to copy
  mov si, ide_buffer
  mov di, 0                   ; start at kernel memory address 0
  supcpy                      ; now copy data from bios mem to kernel mem

; interrupt masks  
  mov al, $ff
  stomsk                      ; store masks
  mov d, s_masks
  call _puts
  
  mov d, s_bios2
  call _puts

; now we start the kernel.
  mov a, g                    ; retrieve kernel reset vector

  push word $ffff             ; stack. dummy value since the real value is set in the kernel code
  push byte %00001000         ; mode =supervisor, paging=on
  push a                      ; pc
  sysret

  
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
  test al, $20              ; isolate transmitter empty
  jz _puts_l2    
  mov al, [d]
  mov [_uart0_data], al     ; write char to transmitter holding register
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
  mov al, [_uart0_lsr]    ; read line status register
  test al, 20h            ; isolate transmitter empty
  jz _putchar_l1    
  mov al, ah
  mov [_uart0_data], al   ; write char to transmitter holding register
  popf
  pop a
  ret

s_boot1:         .db "executing bootloader\n\r", 0
s_kernel_setup:  .db "mapping kernel page-table to physical RAM\n\r", 0
s_masks:         .db "\n\rinterrupt masks register set to 0xFF\n\r", 0
s_boot:          .db "loading kernel from disk ", 0
s_bios2:         .db "entering protected-mode\n\r"
                 .db "starting kernel\n\r", 0

.end
