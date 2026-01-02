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

boot_start:
  mov d, s_read_super
  call _puts

; read Superblock
  mov b, 2
  mov c, 0                    ; LBA = 2 = byte 1024
  mov d, ide_buffer           ; we read into the bios ide buffer
  mov a, $0202                ; disk read, 2 sectors. Superblock
  syscall bios_ide            ; read sector

;  SUPERBLOCK:
;  | Field               | Description                               | Typical Size (bytes) | Notes                           |
;  | ------------------- | ----------------------------------------- | -------------------- | ------------------------------- |
;  | inodes_count        | Total number of inodes in the filesystem  | 2                    | 16-bit unsigned int             |
;  | blocks_count        | Total number of data blocks               | 2                    | 16-bit unsigned int             |
;  | free_inodes_count   | Number of free inodes                     | 2                    | 16-bit unsigned int             |
;  | free_blocks_count   | Number of free blocks                     | 2                    | 16-bit unsigned int             |
;  | block_bitmap        | Block ID of the **block bitmap**          | 2                    | 16-bit unsigned int
;  | inode_bitmap        | Block ID of the **inode bitmap**          | 2                    | 16-bit unsigned int
;  | inode_table         | Block ID of **inode table**               | 2                    | 16-bit unsigned int
;  | first_data_block    | Block ID of the data blocks area          | 2                    | 16-bit unsigned int             |
;  | used_dirs_count     | Number of inodes allocated to directories | 2
;  | log_block_size      | Block size = 1024 << `s_log_block_size    | 2                    | 16-bit unsigned int             |
;  | mtime               | Last mount time                           | 4                    | 32-bit unsigned int (Unix time) |
;  | wtime               | Last write time                           | 4                    | 32-bit unsigned int (Unix time) |
;  | uuid                | Unique ID of the filesystem               | 16                   | 128-bit UUID                    |
;  | volume_name         | Label of the filesystem                   | 16                   | Usually ASCII, padded           |
;  | feature_flags       | Compatibility flags                       | 4                    | 32-bit unsigned int             |
; print Superblock information
  mov d, s_total_inodes
  call _puts
  mov d, ide_buffer
  mov a, [d]
  call print_u16d

  mov d, s_total_blocks
  call _puts
  mov d, ide_buffer + 2
  mov a, [d]
  call print_u16d

  mov d, s_free_inodes
  call _puts
  mov d, ide_buffer + 4
  mov a, [d]
  call print_u16d

  mov d, s_free_blocks
  call _puts
  mov d, ide_buffer + 6
  mov a, [d]
  call print_u16d

  mov d, s_block_bitmap
  call _puts
  mov d, ide_buffer + 8
  mov a, [d]
  call print_u16d

  mov d, s_inode_bitmap
  call _puts
  mov d, ide_buffer + 10
  mov a, [d]
  call print_u16d

  mov d, s_inode_table
  call _puts
  mov d, ide_buffer + 12
  mov a, [d]
  call print_u16d

;  mov d, s_first_data_block
;  call _puts
;  mov d, ide_buffer + 14
;  mov a, [d]
;  call print_u16d

  mov d, s_used_dirs
  call _puts
  mov d, ide_buffer + 16
  mov a, [d]
  call print_u16d

;  mov d, s_uuid
;  call _puts
;  mov d, ide_buffer + 28
;  mov bl, [d]
;  call xput_u8

  mov d, s_vol_name
  call _puts
  mov d, ide_buffer + 44
  call _puts


loop1:
  jmp loop1

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

s_boot1:         .db "executing bootloader\n", 0
s_kernel_setup:  .db "mapping kernel page-table to physical RAM\n", 0
s_masks:         .db "\n\rinterrupt masks register set to 0xFF\n", 0
s_boot:          .db "loading kernel from disk", 0
s_bios2:         .db "entering protected-mode\n"
                 .db "starting kernel\n", 0

s_hex_digits:   .db "0123456789ABCDEF"

s_read_super:      .db "\nreading superblock\n", 0
s_total_inodes:    .db "\ntotal inodes: ", 0
s_total_blocks:    .db "\ntotal blocks: ", 0
s_free_inodes:     .db "\nfree inodes: ", 0
s_free_blocks:     .db "\nfree blocks: ", 0
s_block_bitmap:    .db "\nblock bitmap: ", 0
s_inode_bitmap:    .db "\ninode bitmap: ", 0
s_inode_table:     .db "\ninode table: ", 0
s_used_dirs:       .db "\nnumber of used directories: ", 0
s_used_dirs_count: .db "\nused dirs count: ", 0
s_uuid:            .db "\nuuid: ", 0
s_vol_name:        .db "\nvolume name: ", 0

.end
