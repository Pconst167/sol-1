; ------------------------------------------------------------------------------------------------------------------;
; Solarium - Sol-1 Homebrew Minicomputer Operating System Kernel.
; ------------------------------------------------------------------------------------------------------------------;

; memory map
; ------------------------------------------------------------------------------------------------------------------;
; 0000 ... 7fff - rom space
; 8000 ... f7ff - ram space
; f7ff          - stack root

; i/o map
; ------------------------------------------------------------------------------------------------------------------;
; ff80 - uart 0 (16550)
; ff88 - uart 1 (16550)
; ffa0 - rtc    (m48t02)
; ffb0 - pio 0  (8255)
; ffc0 - fdd    (5.25" floppy drive block)
;   - ffc0      output port (377 flip-flop)                  
;   - ffc1      input port  (244 buffer)                     
;   - ffc8      wd1770 status/command    
;   - ffc9      wd1770 track register
;   - ffca      wd1770 sector register
;   - ffcb      wd1770 data register
;      
; ffd0 - ide    (compact flash / pata)
; ffe0 - timer  (8253)
; fff0 - bios configuration nv-ram store area
; ------------------------------------------------------------------------------------------------------------------;

; ------------------------------------------------------------------------------------------------------------------;
; system constants
; ------------------------------------------------------------------------------------------------------------------;
_uart0_data       .equ $ff80         ; data
_uart0_dlab_0     .equ $ff80         ; divisor latch low byte
_uart0_dlab_1     .equ $ff81         ; divisor latch high byte
_uart0_ier        .equ $ff81         ; interrupt enable register
_uart0_fcr        .equ $ff82         ; fifo control register
_uart0_lcr        .equ $ff83         ; line control register
_uart0_lsr        .equ $ff85         ; line status register

_uart1_data       .equ $ff88         ; data
_uart1_dlab_0     .equ $ff88         ; divisor latch low byte
_uart1_dlab_1     .equ $ff89         ; divisor latch high byte
_uart1_ier        .equ $ff89         ; interrupt enable register
_uart1_fcr        .equ $ff8A         ; fifo control register
_uart1_lcr        .equ $ff8B         ; line control register
_uart1_lsr        .equ $ff8D         ; line status register

_ide_base         .equ $ffd0         ; ide base
_ide_r0           .equ _ide_base + 0 ; data port
_ide_r1           .equ _ide_base + 1 ; read: error code, write: feature
_ide_r2           .equ _ide_base + 2 ; number of sectors to transfer
_ide_r3           .equ _ide_base + 3 ; sector address lba 0 [0:7]
_ide_r4           .equ _ide_base + 4 ; sector address lba 1 [8:15]
_ide_r5           .equ _ide_base + 5 ; sector address lba 2 [16:23]
_ide_r6           .equ _ide_base + 6 ; sector address lba 3 [24:27 (lsb)]
_ide_r7           .equ _ide_base + 7 ; read: status, write: command       

_til311_display   .equ $ffb0         ; bios post code hex display (2 digits) (connected to pio a)
_bios_post_ctrl   .equ $ffb3         ; bios post display control register, 80h = as output
_pio_a            .equ $ffb0    
_pio_b            .equ $ffb1
_pio_c            .equ $ffb2
_pio_control      .equ $ffb3         ; pio control port

_fdc_config       .equ $ffc0         ; 0 = select_0, 1 = select_1, 2 = side_select, 3 = dden, 4 = in_use_or_head_load, 5 = wd1770_rst
_fdc_status_0     .equ $ffc1         ; 0 = drq, 1 = ready
_fdc_stat_cmd     .equ $ffc8         ; status / command register
_fdc_track        .equ $ffc9         ; track register
_fdc_sector       .equ $ffca         ; sector register
_fdc_data         .equ $ffcb         ; data register

_timer_c_0        .equ $ffe0         ; timer counter 0
_timer_c_1        .equ $ffe1         ; timer counter 1
_timer_c_2        .equ $ffe2         ; timer counter 2
_timer_ctrl       .equ $ffe3         ; timer control register

_stack_begin      .equ $f7ff         ; beginning of stack
_fifo_size        .equ 4096

_mbr                     .equ 446
_superblock              .equ 1024
_block_group_descriptor  .equ 2048

text_org          .equ $400          ; code origin address for all user processes


;  ------------------------------------------------------------------------------------------------------------------;
;  DISK LAYOUT:
;  Metadata               | Size (bytes)      | Blocks (2048 bytes)              |Start Block |  Comment
;  ---------------------- | ----------------- | -------------------------------- |------------|-----------------------------------
;  Bootloader/MBR         | 512 bytes         | 0.25 (1 sector)                  |  0         |
;  Superblock             | 1024 bytes        | 1 block (2048 bytes, must align) |  0         |
;                         |                   | 1 block (2048 bytes)             |  1         | reserved
;  Block Bitmap           | 8,192 bytes       | 4 blocks                         |  2         | 4*2048*8 = 4*16384 = 65536 raw data blocks.  65536*2048 bytes = 134217728 bytes of disk space = 128MB
;  Inode Bitmap           | 2,048 bytes       | 1 block                          |  6         | 2048*8=16384. total of 16384 bits, meaning 16384 inodes, which is 1 inode per 8KB of disk space
;  Inode Table            | 2,097,152 bytes   | 1024 blocks                      |  7         | 128bytes per inode entry. 2097152 / 128 = 16384 inodes
;  Data Blocks            | 134,217,728 bytes | 65528 blocks                     | 1031       | 65528 blocks = 134,201,344 bytes
;  
;  first 512 bytes: bootloader from 0 to 445, MBR partition table from 446 to 511 (64 bytes)
;  up to 4 partitions, each 16 bytes long
;  MBR:
;  Byte | Description
;  -----|----------------------------
;  0    | Boot flag (0x80 active, 0x00 inactive)
;  1-3  | Start CHS (head, sector, cylinder)
;  4    | Partition type (filesystem ID)
;    0x83 = Linux native (ext2/3/4)
;    0x07 = NTFS/exFAT
;    0x0B = FAT32 CHS
;    0x0C = FAT32 LBA
;    0x05 = Extended partition
;    0x86 = Sol-1 partition
;  5-7  | End CHS
;  8-11 | Start LBA (little endian)
;  12-15| Size in sectors (little endian)
;  
;  
;  the superblock describers the filesystem as a whole such as inode count, free inode count, location of the raw data bitmap, inode table, etc.  
;  SUPERBLOCK:
;  | Field               | Description                               | Typical Size (bytes) | Notes                           |
;  | ------------------- | ----------------------------------------- | -------------------- | ------------------------------- |
;  | inodes_count        | Total number of inodes in the filesystem  | 2                    | 16-bit unsigned int             |
;  | blocks_count        | Total number of data blocks               | 2                    | 16-bit unsigned int             |
;  | free_inodes_count   | Number of free inodes                     | 2                    | 16-bit unsigned int             |
;  | free_blocks_count   | Number of free blocks                     | 2                    | 16-bit unsigned int             |
;  | block_bitmap        | Block ID of the **block bitmap**          | 2                    | 16-bit unsigned int
;  | inode_bitmap        | Block ID of the **inode bitmap**          | 2                    | 16-bit unsigned int
;  | inode_table         | Starting block of **inode table**         | 2                    | 16-bit unsigned int
;  | first_data_block    | Block number of the first data block      | 2                    | 16-bit unsigned int             |
;  | used_dirs_count     | Number of inodes allocated to directories | 2
;  | log_block_size      | Block size = 1024 << `s_log_block_size    | 2                    | 16-bit unsigned int             |
;  | mtime               | Last mount time                           | 4                    | 32-bit unsigned int (Unix time) |
;  | wtime               | Last write time                           | 4                    | 32-bit unsigned int (Unix time) |
;  | uuid                | Unique ID of the filesystem               | 16                   | 128-bit UUID                    |
;  | volume_name         | Label of the filesystem                   | 16                   | Usually ASCII, padded           |
;  | feature_flags       | Compatibility flags                       | 4                    | 32-bit unsigned int             |
;  
;  inode for root dir is #2, #0 and #1 not used
;  raw data block #0 is not used. because 0 as a block ID means not used
;  block size: 2048
;  inode-table format:
;  | Field         | Size (bytes) | Description                                                                                  |
;  | ------------- | ------------ | -------------------------------------------------------------------------------------------- |
;  | `mode`        | 2            | File type and permissions                                                                    |
;  | `uid`         | 2            | Owner user ID                                                                                |
;  | `size`        | 4            | Size of the file in bytes                                                                    |
;  | `atime`       | 4            | Last access time (timestamp)                                                                 |
;  | `ctime`       | 4            | Creation time (timestamp)                                                                    |
;  | `mtime`       | 4            | Last modification time (timestamp)                                                           |
;  | `dtime`       | 4            | Deletion time (timestamp)                                                                    |
;  | `gid`         | 2            | Group ID                                                                                     |
;  | `links_count` | 2            | Number of hard links                                                                         |
;  | `blocks`      | 2            | Number of 2048-byte blocks allocated                                                         |
;  | `flags`       | 4            | File flags                                                                                   |
;  | `block`       | 47 * 2 = 94  | Pointers to data blocks (47 direct only) 
;
;
;  DIRECTORY ENTRY
;  this is the structure for file entries inside a directory.
;  2048 / 64 = 32 entries
;
;  each entry is 64 bytes wide
;  uint16_t inode;      // Inode number (0 if entry is unused)
;  char     name[62];   // File name (null terminated)


; file entry attributes
; filename (24)
; attributes (1)       :|0|0|file_type(3bits)|x|w|r|
; lba (2)              : location of raw data for file entry, or dirid for directory entry
; size (2)             : filesize
; day (1)           
; month (1)
; year (1)
; packet size = 32 bytes  : total packet size in bytes

fst_entry_size      .equ 32  ; bytes
fst_files_per_sect  .equ (512 / fst_entry_size)
fst_files_per_dir   .equ (512 / fst_entry_size)
fst_nbr_directories .equ 64
                    ; 1 sector for header, the rest is for the list of files/dirs
fst_sectors_per_dir .equ (1 + (fst_entry_size * fst_files_per_dir / 512))    
fst_total_sectors   .equ (fst_sectors_per_dir * fst_nbr_directories)
fst_lba_start       .equ 32
fst_lba_end         .equ (fst_lba_start + fst_total_sectors - 1)

fs_nbr_files        .equ (fst_nbr_directories * fst_files_per_dir)
fs_sectors_per_file .equ 32 ; the first sector is always a header with a null parameter (first byte)
                            ; so that we know which blocks are free or taken
fs_file_size        .equ (fs_sectors_per_file * 512)                  
fs_total_sectors    .equ (fs_nbr_files * fs_sectors_per_file)
fs_lba_start        .equ (fst_lba_end + 1)
fs_lba_end          .equ (fs_lba_start + fs_total_sectors - 1)

root_id:            .equ fst_lba_start

; ------------------------------------------------------------------------------------------------------------------;
; global system variables
; ------------------------------------------------------------------------------------------------------------------;

; ------------------------------------------------------------------------------------------------------------------;
; irq table
; highest priority at lowest address
; ------------------------------------------------------------------------------------------------------------------;
.dw int_0_fdc
.dw int_1
.dw int_2
.dw int_3
.dw int_4
.dw int_5_uart1
.dw int_6_timer
.dw int_7_uart0

; ------------------------------------------------------------------------------------------------------------------;
; kernel reset vector
; ------------------------------------------------------------------------------------------------------------------;
.dw kernel_reset_vector

; ------------------------------------------------------------------------------------------------------------------;
; exception vector table
; total of 7 entries, starting at address $0012
; ------------------------------------------------------------------------------------------------------------------;
.dw trap_privilege
.dw trap_div_zero
.dw trap_undef_opcode
.dw 0
.dw 0
.dw 0
.dw 0

; ------------------------------------------------------------------------------------------------------------------;
; system call vector table
; starts at address $0020
; ------------------------------------------------------------------------------------------------------------------;
.dw syscall_break
.dw syscall_rtc
.dw syscall_ide
.dw syscall_io
.dw syscall_file_system
.dw syscall_create_proc
.dw syscall_list_procs
.dw syscall_datetime
.dw syscall_reboot
.dw syscall_pause_proc
.dw syscall_resume_proc
.dw syscall_terminate_proc
.dw syscall_system
.dw syscall_fdc

; ------------------------------------------------------------------------------------------------------------------;
; system call aliases
; ------------------------------------------------------------------------------------------------------------------;
sys_break            .equ 0
sys_rtc              .equ 1
sys_ide              .equ 2
sys_io               .equ 3
sys_filesystem       .equ 4
sys_create_proc      .equ 5
sys_list_proc        .equ 6
sys_datetime         .equ 7
sys_reboot           .equ 8
sys_pause_proc       .equ 9
sys_resume_proc      .equ 10
sys_terminate_proc   .equ 11
sys_system           .equ 12
sys_fdc              .equ 13

; aliases for individual 'al' options for FDC system calls
fdc_al_restore      .equ 0
fdc_al_step         .equ 1
fdc_al_step_in      .equ 2
fdc_al_step_out     .equ 3
fdc_al_seek         .equ 4
fdc_al_format_128   .equ 5
fdc_al_formatdisk_128   .equ 6
fdc_al_format_512   .equ 7
fdc_al_formatdisk_512   .equ 8
fdc_al_read_addr    .equ 9
fdc_al_read_track   .equ 10
fdc_al_read_sect    .equ 11
fdc_al_write_sect   .equ 12
fdc_al_force_int    .equ 13
fdc_al_status0      .equ 14
fdc_al_status1      .equ 15

; ------------------------------------------------------------------------------------------------------------------;
; alias exports
; ------------------------------------------------------------------------------------------------------------------;
.export text_org
.export sys_break
.export sys_rtc
.export sys_ide
.export sys_io
.export sys_filesystem
.export sys_create_proc
.export sys_list_proc
.export sys_datetime
.export sys_reboot
.export sys_pause_proc
.export sys_resume_proc
.export sys_terminate_proc
.export sys_system
.export sys_fdc

.export _til311_display

.export _fdc_config        
.export _fdc_status_0      
.export _fdc_stat_cmd     

; exports of aliases for individual 'al' options for FDC system calls
.export fdc_al_restore
.export fdc_al_step
.export fdc_al_step_in
.export fdc_al_step_out
.export fdc_al_seek
.export fdc_al_format_128
.export fdc_al_formatdisk_128
.export fdc_al_format_512
.export fdc_al_formatdisk_512
.export fdc_al_read_addr
.export fdc_al_read_track
.export fdc_al_read_sect
.export fdc_al_write_sect
.export fdc_al_force_int
.export fdc_al_status0
.export fdc_al_status1

; ------------------------------------------------------------------------------------------------------------------;
; irqs' code block
; ------------------------------------------------------------------------------------------------------------------;
; 5.25" floppy drive controller irq
int_0_fdc:
  mov d, s_fdc_irq
  call _puts
  sysret
int_1:
  sysret
int_2:
  sysret
int_3:
  sysret
int_4:
  sysret

; ------------------------------------------------------------------------------------------------------------------;
; uart1 interrupt
; ------------------------------------------------------------------------------------------------------------------;
int_5_uart1:
  push a
  push d
  pushf
  mov al, [_uart1_data]       ; get character
  cmp al, $03                 ; ctrl-c
  je ctrlc
  cmp al, $1a                 ; ctrl-z
  je ctrlz
  ;mov [[d]], al              ; TODO: implement this double indirection instruction
  mov d, fifo_in
  mov d, [d]
  mov [d], al                 ; add to fifo
  mov a, d
  inc a
  cmp a, fifo + _fifo_size     ; check if pointer reached the end of the fifo
  jne int_5_continue
  mov a, fifo  
int_5_continue:  
  mov [fifo_in], a            ; update fifo pointer
  mov al, ah
  mov [_til311_display], al
  popf
  pop d
  pop a  
  sysret

; ------------------------------------------------------------------------------------------------------------------;
; timer irq
; ------------------------------------------------------------------------------------------------------------------;
int_6_timer:  
  sysret

; ------------------------------------------------------------------------------------------------------------------;
; uart0 interrupt
; ------------------------------------------------------------------------------------------------------------------;
int_7_uart0:
  push a
  push d
  pushf
  mov al, [_uart0_data]       ; get character
  cmp al, $03                 ; ctrl-c
  je ctrlc
  cmp al, $1a                 ; ctrl-z
  je ctrlz
  ;mov [[d]], al              ; TODO: implement this double indirection instruction
  mov d, fifo_in
  mov d, [d]
  mov [d], al                 ; add to fifo
  mov a, d
  inc a
  cmp a, fifo + _fifo_size     ; check if pointer reached the end of the fifo
  jne int_7_continue
  mov a, fifo  
int_7_continue:  
  mov [fifo_in], a            ; update fifo pointer
  mov al, ah
  mov [_til311_display], al
  popf
  pop d
  pop a  
  sysret

ctrlc:
  add sp, 5
  jmp syscall_terminate_proc
ctrlz:
  add sp, 5
  jmp syscall_pause_proc      ; pause current process and go back to the shell

sys_mkfs:
  sysret

; ------------------------------------------------------------------------------------------------------------------;
; floppy drive syscalls
; ------------------------------------------------------------------------------------------------------------------;
; data for formatting a floppy drive in single density mode (128 bytes per sector):
; fdc_40_ff:
;   .fill 40,  $ff    ; or 00                                                                                
; fdc_128_format_inner:
;   .fill 6,   $00    ;                                                                            <--|        
;   .fill 1,   $fe    ; id address mark                                                               |        
;   .fill 1,   $00    ; track number  0 thru 39                                                       |                    
;   .fill 1,   $00    ; side number 00 or 01                                                          |                
;   .fill 1,   $01    ; sector number  0x01 through 0x10                                              |                              
;   .fill 1,   $00    ; sector length                                                                 |                        
;   .fill 1,   $f7    ; 2 crc's written                                                               | write 16 times                 
;   .fill 11,  $ff    ; or 00                                                                         |                      
;   .fill 6,   $00    ;                                                                               |                        
;   .fill 1,   $fb    ; data address mark                                                             |                                  
;   .fill 128, $e5    ; data (ibm uses e5)                                                            |                                      
;   .fill 1,   $f7    ; 2 crc's written                                                               |                                                        
;   .fill 10,  $ff    ; or 00                                                                      <--|                                                  
; fdc_128_format_end:
;   .fill 369, $ff    ; or 00. continue writing until wd1770 interrupts out. approx 369 bytes.                                                                
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
fdc_jmptbl:
  .dw syscall_fdc_restore
  .dw syscall_fdc_step
  .dw syscall_fdc_step_in
  .dw syscall_fdc_step_out
  .dw syscall_fdc_seek
  .dw syscall_fdc_format_128
  .dw syscall_fdc_formatdisk_128
  .dw syscall_fdc_format_512
  .dw syscall_fdc_formatdisk_512
  .dw syscall_fdc_read_addr
  .dw syscall_fdc_read_track
  .dw syscall_fdc_read_sect
  .dw syscall_fdc_write_sect
  .dw syscall_fdc_force_int
  .dw syscall_fdc_status0
  .dw syscall_fdc_status1
syscall_fdc:
  jmp [fdc_jmptbl + al]

syscall_fdc_status0:
  mov al, [_fdc_status_0]
  sysret

syscall_fdc_status1:
  mov al, [_fdc_stat_cmd]
  sysret

syscall_fdc_restore:
  call fdc_wait_not_busy
  mov byte [_fdc_stat_cmd], %00001011
  mov byte [_fdc_track], $00 ; reset track
  sysret

syscall_fdc_step:
  call fdc_wait_not_busy
  mov byte [_fdc_stat_cmd], %00111011
  sysret

syscall_fdc_step_in:
  call fdc_wait_not_busy
  mov byte [_fdc_stat_cmd], %01010011
  sysret

syscall_fdc_step_out:
  call fdc_wait_not_busy
  mov byte [_fdc_stat_cmd], %01111011
  sysret

; bl: desired track
syscall_fdc_seek:
  call fdc_wait_not_busy
  mov [_fdc_data], bl ; set desired track to bl
  mov byte [_fdc_stat_cmd], %00011011 ; seek command
  sysret

syscall_fdc_read_addr:
  sysret

syscall_fdc_force_int:
  sysret

; when writing the actual code for formatting multiple tracks, remember to change the track number byte
; in the ram formatting block because they are all set as 00 right now
; bl: track number
syscall_fdc_format_128:
  call fdc_format_mem_128
  call fdc_wait_not_busy
  mov [_fdc_track], bl
  mov si, transient_area
  mov byte [_fdc_stat_cmd], %11111010 ; write track command: {1111, 0: enable spin-up seq, 1: settling delay, 1: no write precompensation, 0}
  call fdc_wait_64us
fdc_format_drq_128:
  mov al, [_fdc_stat_cmd]     ; 10
  test al, $01                ; 4
  jz fdc_format_end_128           ; 8
  test al, $02                ; 4
  jz fdc_format_drq_128           ; 8
  lodsb                       ; 7
  mov [_fdc_data], al         ; 10   
  jmp fdc_format_drq_128
fdc_format_end_128:
  sysret

; when writing the actual code for formatting multiple tracks, remember to change the track number byte
; in the ram formatting block because they are all set as 00 right now
; bl: track number
syscall_fdc_format_512:
  call fdc_format_mem_512
  call fdc_wait_not_busy
  mov [_fdc_track], bl
  mov si, transient_area
  mov byte [_fdc_stat_cmd], %11111010 ; write track command: {1111, 0: enable spin-up seq, 1: settling delay, 1: no write precompensation, 0}
  call fdc_wait_64us
fdc_format_drq_512:
  mov al, [_fdc_stat_cmd]     ; 10
  test al, $01                ; 4
  jz fdc_format_end_512           ; 8
  test al, $02                ; 4
  jz fdc_format_drq_512           ; 8
  lodsb                       ; 7
  mov [_fdc_data], al         ; 10   
  jmp fdc_format_drq_512
fdc_format_end_512:
  sysret

syscall_fdc_formatdisk_128:
  mov bl, 0
fdc_formatdisk128_l0:
  call fdc_format_mem_128
  call fdc_wait_not_busy
  mov [_fdc_track], bl
  mov si, transient_area
  mov byte [_fdc_stat_cmd], %11111010 ; write track command
  call fdc_wait_64us
fdc_formatdisk_drq_128:
  mov al, [_fdc_stat_cmd]     ; 10
  test al, $01                ; 4
  jz fdc_formatdisk_end_128           ; 8
  test al, $02                ; 4
  jz fdc_formatdisk_drq_128           ; 8
  lodsb                       ; 7
  mov [_fdc_data], al         ; 10   
  jmp fdc_formatdisk_drq_128
fdc_formatdisk_end_128:
  call fdc_wait_not_busy
  push b
  mov b, 8
  call wait_xs
  mov byte [_fdc_stat_cmd], %01010011  ; step in
  pop b
  add bl, 1
  cmp bl, 40
  jne fdc_formatdisk128_l0
  sysret

syscall_fdc_formatdisk_512:
  mov bl, 0
fdc_formatdisk512_l0:
  call fdc_format_mem_512
  call fdc_wait_not_busy
  mov [_fdc_track], bl
  mov si, transient_area
  mov byte [_fdc_stat_cmd], %11110010 ; write track command
  call fdc_wait_64us
fdc_formatdisk_drq_512:
  mov al, [_fdc_stat_cmd]     ; 10
  test al, $01                ; 4
  jz fdc_formatdisk_end_512           ; 8
  test al, $02                ; 4
  jz fdc_formatdisk_drq_512           ; 8
  lodsb                       ; 7
  mov [_fdc_data], al         ; 10   
  jmp fdc_formatdisk_drq_512
fdc_formatdisk_end_512:
  call fdc_wait_not_busy
  push b
  mov b, 8
  call wait_xs
  mov byte [_fdc_stat_cmd], %01010011   ; step in
  pop b
  add bl, 1
  cmp bl, 40
  jne fdc_formatdisk512_l0
  sysret

; di : destination in user space
; a  : returns number of read bytes
syscall_fdc_read_track:
  call fdc_wait_not_busy
  push di
  mov di, transient_area
  mov byte [_fdc_stat_cmd], %11101000
  call fdc_wait_64us
fdc_read_track_l0: ; for each byte, we need to wait for drq to be high
  mov al, [_fdc_stat_cmd]      ; 
  test al, $01                ; check busy bit
  jz fdc_read_track_end
  test al, $02                ; check drq bit
  jz fdc_read_track_l0
  mov al, [_fdc_data]     ; 
  stosb
  jmp fdc_read_track_l0
;we need to check if writing to data reg causes a spurious read. so lets check inside the writing loop, how many times we actually write the bytes
;say the 40 byte loop. if we find that we only write ~20 times, then this indcates this problem.
;because for every write, if it also reads, then that clears drq, so we need to wait for next drq.
fdc_read_track_end:
  mov a, di
  sub a, transient_area
  pop di
  mov si, transient_area
  mov c, a  ; copy track over to user space
  store
  sysret

; sector in bl
; track in bh
; di = user space destination
syscall_fdc_read_sect:
  call fdc_wait_not_busy
  push di
  mov [_fdc_sector], bl
  mov bl, bh
  mov [_fdc_track], bl
  mov byte [_fdc_stat_cmd], %10001000
  call fdc_wait_64us
  mov di, transient_area
fdc_read_sect_l0: ; for each byte, we need to wait for drq to be high
  mov al, [_fdc_stat_cmd]      ; read lost data flag 10+3+5+8+5+8
  test al, $01                ; check drq bit
  jz fdc_read_sect_end
  test al, $02                ; check drq bit
  jz fdc_read_sect_l0
  mov al, [_fdc_data]     ; 
  stosb
  jmp fdc_read_sect_l0
fdc_read_sect_end:
  mov a, di
  sub a, transient_area
  pop di
  mov si, transient_area
  mov c, a  ; copy sector over to user space
  store
  sysret

; sector size in c
; sector in bl
; track in bh
; data pointer in si
syscall_fdc_write_sect:
  call fdc_wait_not_busy
  mov [_fdc_sector], bl
  mov bl, bh
  mov [_fdc_track], bl
  mov di, transient_area    ; si = data source, di = destination 
  load                    ; transfer data to kernel space!
  mov si, transient_area
  mov byte [_fdc_stat_cmd], %10101010            ; 101, 0:single sector, 1: disable spinup, 0: no delay, 1: no precomp, 0: normal data mark
  call fdc_wait_64us
fdc_write_sect_l0: ; for each byte, we need to wait for drq to be high
  mov al, [_fdc_stat_cmd]         ; 10
  test al, $01                    ; 4
  jz fdc_write_sect_end           ; 8
  test al, $02                    ; 4
  jz fdc_write_sect_l0            ; 8
  lodsb                           ; 7
  mov [_fdc_data], al             ; 10   
  jmp fdc_write_sect_l0
fdc_write_sect_end:
  sysret

fdc_wait_not_busy:
  push al
fdc_wait_not_busy_l0:
  mov al, [_fdc_stat_cmd]   
  test al, $01               
  jnz fdc_wait_not_busy_l0          
  pop al
  ret

; track number in bl
fdc_format_mem_128:
  mov d, 1
  mov di, transient_area
; 40 * FF
  mov c, 40
  mov al, $ff
fdc_l0: 
  stosb
  dec c
  jnz fdc_l0
; 6 * 00
fdc_inner_loop:
  mov c, 6
  mov al, $00
fdc_l1:
  stosb
  dec c
  jnz fdc_l1
; FE address mark
fdc_l2:
  mov al, $fe
  stosb
; track number
fdc_l3:
  mov al, bl  ; track number in bl
  stosb
; side number
fdc_l4:
  mov al, $00
  stosb
; sector number
fdc_l5:
  mov a, d
  stosb
; sector length 128 bytes
fdc_l6:
  mov al, $00
  stosb
; 2 crc's
fdc_l7:
  mov al, $f7
  stosb
; 11 times $ff
  mov c, 11
  mov al, $ff
fdc_l8:
  stosb
  dec c
  jnz fdc_l8
; 6 times 00
  mov c, 6
  mov al, $00
fdc_l9:
  stosb
  dec c
  jnz fdc_l9
; FB data address mark
  mov al, $fb
fdc_l10:
  stosb
; 128 bytes sector data
  mov c, 128
  mov al, $E5
fdc_l11:
  stosb
  dec c
  jnz fdc_l11
; 2 crc's
fdc_l12:
  mov al, $f7
  stosb
; 10 * $FF
  mov c, 10
  mov al, $ff
fdc_l13:
  stosb
  dec c
  jnz fdc_l13
; check whether we did this 16 times
  inc d
  cmp d, 17
  jne fdc_inner_loop
; 500 bytes of FF for end filler. wd1770 writes these until it finishes, so the number varies. usually it writes ~450 bytes
  mov c, 500
  mov al, $ff
fdc_format_footer:
fdc_footer_drq_loop:
  stosb
  dec c
  jnz fdc_footer_drq_loop
  ret

; track number in bl
fdc_format_mem_512:
  mov d, 1
  mov di, transient_area
; 40 * FF
  mov c, 40
  mov al, $ff
fdc_512_l0: 
  stosb
  dec c
  jnz fdc_512_l0
; 6 * 00
fdc_512_inner_loop:
  mov c, 6
  mov al, $00
fdc_512_l1:
  stosb
  dec c
  jnz fdc_512_l1
; FE address mark
fdc_512_l2:
  mov al, $fe
  stosb
; track number
fdc_512_l3:
  mov al, bl ; track number was in bl
  stosb
; side number
fdc_512_l4:
  mov al, $00
  stosb
; sector number
fdc_512_l5:
  mov a, d
  stosb
; sector length 512 bytes
fdc_512_l6:
  mov al, $02
  stosb
; 2 crc's
fdc_512_l7:
  mov al, $f7
  stosb
; 11 times $ff
  mov c, 11
  mov al, $ff
fdc_512_l8:
  stosb
  dec c
  jnz fdc_512_l8
; 6 times 00
  mov c, 6
  mov al, $00
fdc_512_l9:
  stosb
  dec c
  jnz fdc_512_l9
; FB data address mark
  mov al, $fb
fdc_512_l10:
  stosb
; 128 bytes sector data
  mov c, 512
  mov al, $E5
fdc_512_l11:
  stosb
  dec c
  jnz fdc_512_l11
; 2 crc's
fdc_512_l12:
  mov al, $f7
  stosb
; 10 * $FF
  mov c, 10
  mov al, $ff
fdc_512_l13:
  stosb
  dec c
  jnz fdc_512_l13
; check whether we did this 16 times
  inc d
  cmp d, 6
  jne fdc_512_inner_loop
; 500 bytes of FF for end filler. wd1770 writes these until it finishes, so the number varies. usually it writes ~450 bytes
  mov c, 500
  mov al, $ff
fdc_512_format_footer:
fdc_512_footer_drq_loop:
  stosb
  dec c
  jnz fdc_512_footer_drq_loop
  ret

; fetch is 2 cycles long when 'display_reg_load' is false.
; 64us amounts to 160 cycles of the 2.5mhz clock
; call u16 is 14 cycles long
; 160 - 5 - 14 = 
fdc_wait_64us:
  mov cl, 13                       ; 5 cycles
fdc_wait_64_loop:
  dec cl                           ; 3 cycles
  jnz fdc_wait_64_loop             ; 8 cycles
  ret

; number of seconds in b
wait_xs:
  cmp b, 0
  je wait_xs_end
  call wait_1s
  dec b
  jmp wait_xs
wait_xs_end:
  ret

wait_1s:
  push al
  push c
  mov al, 3
wait_1s_l0:
  mov c, 65535                       
wait_1s_l1:
  dec c        ; 4
  jnz wait_1s_l1   ; 8
  dec al
  jnz wait_1s_l0
  pop c
  pop al
  ret

; ------------------------------------------------------------------------------------------------------------------;
; system syscalls
; ------------------------------------------------------------------------------------------------------------------;
system_jmptbl:
  .dw system_uname
  .dw system_whoami
  .dw system_poke
  .dw system_bootloader_install
  .dw system_peek
syscall_system:
  jmp [system_jmptbl + al]

; param register address in register d
; param value in register bl
system_peek:
  mov bl, [d]
  sysret

; param register address in register d
; param value in register bl
system_poke:
  mov [d], bl
  sysret

; kernel LBA address in 'b'
system_bootloader_install:
  push b
  mov b, 0
  mov c, 0
  mov ah, $01                 ; 1 sector
  mov d, transient_area
  call ide_read_sect          ; read sector
  pop b
  mov [d + 510], b            ; update LBA address
  mov b, 0
  mov c, 0
  mov ah, $01                 ; 1 sector
  mov d, transient_area
  call ide_write_sect         ; write sector
  sysret

system_uname:
  mov d, s_uname
  call _puts
  sysret

system_whoami:
  sysret

; reboot system
syscall_reboot:
  push word $ffff 
  push byte %00000000             ; dma_ack = 0, interrupts disabled, mode = supervisor, paging = off, halt=0, display_reg_load=0, dir=0
  push word bios_reset_vector     ; and then push reset vector of the shell to the stack
  sysret

;------------------------------------------------------------------------------------------------------;;
; switch to another process
; inputs:
; al = new process number
;------------------------------------------------------------------------------------------------------;;
syscall_resume_proc:
  mov g, a                            ; save the process number
  pusha                               ; save all registers into kernel stack
  mov ah, 0
  mov al, [active_proc_index]
  shl a              ; x2
  mov a, [proc_table_convert + a]     ; get process state start index
  mov di, a
  mov a, sp
  inc a
  mov si, a
  mov c, 20
  rep movsb                           ; save process state!
; restore kernel stack position to point before interrupt arrived
  add sp, 20
; now load the new process number!
  mov a, g                            ; retrieve the process number argument that was saved in the beginning
  mov [active_proc_index], al         ; set new active proc
; calculate lut entry for next process
  mov ah, 0
  shl a                               ; x2
  mov a, [proc_table_convert + a]     ; get process state start index  
  mov si, a                           ; source is proc state block
  mov a, sp
  sub a, 19
  mov di, a                           ; destination is kernel stack
; restore sp
  dec a
  mov sp, a
  mov c, 20
  rep movsb
; set vm process
  mov al, [active_proc_index]
  setptb
  popa
  sysret

;------------------------------------------------------------------------------------------------------;;
; list processes
;------------------------------------------------------------------------------------------------------;;
syscall_list_procs:
  mov d, s_ps_header
  call _puts
  mov d, proc_availab_table + 1
  mov c, 1
list_procs_l0:  
  cmp byte[d], 1
  jne list_procs_next
  mov b, d
  sub b, proc_availab_table
  shl b, 5
  push d
  push b
  mov b, c
  call print_u8x
  mov ah, ' '
  call _putchar
  call _putchar
  pop b
  mov d, b
  add d, proc_names
  call _puts
  call printnl
  pop d
list_procs_next:
  inc d
  inc c
  cmp c, 9
  jne list_procs_l0
list_procs_end:
  sysret

; ------------------------------------------------------------------------------------------------------------------;
; exceptions code block
; ------------------------------------------------------------------------------------------------------------------;
; privilege exception
; ------------------------------------------------------------------------------------------------------------------;
trap_privilege:
  jmp syscall_reboot
  push d
  mov d, s_priviledge
  call _puts
  pop d
  sysret

; ------------------------------------------------------------------------------------------------------------------;
; breakpoint
; important: values in the stack are being pushed in big endian. i.e.: msb at low address
; and lsb at high address. *** need to correct this in the microcode and make it little endian again ***
; ------------------------------------------------------------------------------------------------------------------;
syscall_break:
  pusha
syscall_break_prompt:
  mov d, s_break1
  call _puts
  call printnl
  call scan_u16d
  cmp a, 0
  je syscall_break_regs
  cmp a, 1
  je syscall_break_mem
syscall_break_end:  
  popa
  sysret
syscall_break_regs:
  mov a, sp
  add a, 14               ; back-track 7 registers
  mov d, a
  mov cl, 7
syscall_regs_l0:
  mov b, [d]
  swp b
  call print_u16x         ; print register value
  call printnl
  sub d, 2
  sub cl, 1
  cmp cl, 0
  jne syscall_regs_l0
  jmp syscall_break_prompt
  call printnl
  jmp syscall_break_prompt
syscall_break_mem:
  call printnl
  call scan_u16x
  mov si, a               ; data source from user space
  mov di, scrap_sector    ; destination in kernel space
  mov c, 512
  load                    ; transfer data to kernel space!
  mov d, scrap_sector     ; dump pointer in d
  mov c, 0
dump_loop:
  mov al, cl
  and al, $0f
  jz print_base
back:
  mov al, [d]             ; read byte
  mov bl, al
  call print_u8x
  mov a, $2000
  syscall sys_io          ; space
  mov al, cl
  and al, $0f
  cmp al, $0f
  je print_ascii
back1:
  inc d
  inc c
  cmp c, 512
  jne dump_loop
  call printnl
  jmp syscall_break_prompt  ; go to syscall_break return point
print_ascii:
  mov a, $2000
  syscall sys_io
  sub d, 16
  mov b, 16
print_ascii_l:
  inc d
  mov al, [d]               ; read byte
  cmp al, $20
  jlu dot
  cmp al, $7e
  jleu ascii
dot:
  mov a, $2e00
  syscall sys_io
  jmp ascii_continue
ascii:
  mov ah, al
  mov al, 0
  syscall sys_io
ascii_continue:
  loopb print_ascii_l
  jmp back1
print_base:
  call printnl
  mov b, d
  sub b, scrap_sector      ; remove this later and fix address bases which display incorrectly
  call print_u16x          ; display row
  mov a, $3a00
  syscall sys_io
  mov a, $2000
  syscall sys_io
  jmp back

s_break1:  
  .db "\ndebugger entry point.\n"
  .db "0. show registers\n"
  .db "1. show 512b ram block\n"
  .db "2. continue execution", 0

; ------------------------------------------------------------------------------------------------------------------;
; divide by zero exception
; ------------------------------------------------------------------------------------------------------------------;
trap_div_zero:
  push a
  push d
  pushf
  mov d, s_divzero
  call _puts
  popf
  pop d
  pop a
  sysret ; enable interrupts

; ------------------------------------------------------------------------------------------------------------------;
; undefined opcode exception
; ------------------------------------------------------------------------------------------------------------------;
trap_undef_opcode:
  sysret

; ------------------------------------------------------------------------------------------------------------------;
; real-time clock services syscall
; rtc i/o bank = ffa0 to ffaf
; ffa0 to ffa7 is scratch ram
; control register at $ffa8 [ w | r | s | cal4..cal0 ]
; al = 0..6 -> get
; al = 7..d -> set
; ------------------------------------------------------------------------------------------------------------------;
syscall_rtc:
  push al
  push d
  cmp al, 6
  jgu syscall_rtc_set
syscall_rtc_get:
  add al, $a9             ; generate rtc address to get to address a9 of clock
  mov ah, $ff    
  mov d, a                ; get to ffa9 + offset
  mov byte[$ffa8], $40    ; set r bit to 1
  mov al, [d]             ; get data
  mov byte[$ffa8], 0      ; reset r bit
  mov ah, al
  pop d
  pop al
  sysret
syscall_rtc_set:
  push bl
  mov bl, ah              ; set data aside
  add al, $a2             ; generate rtc address to get to address a9 of clock
  mov ah, $ff    
  mov d, a                ; get to ffa9 + offset
  mov al, bl              ; get data back
  mov byte[$ffa8], $80    ; set w bit to 1
  mov [d], al             ; set data
  mov byte[$ffa8], 0      ; reset write bit
  pop bl
  pop d
  pop al
  sysret

datetime_serv_tbl:
  .dw print_date
  .dw set_date
syscall_datetime:
  jmp [datetime_serv_tbl + al]      
print_date:
  mov a, $0d00           ; print carriage return char
  mov al, 3
  syscall sys_rtc        ; get week
  mov al, ah
  mov ah, 0
  shl a, 2          
  mov d, s_week
  add d, a
  call _puts
  mov a, $2000
  syscall sys_io         ; display ' '
  mov al, 4
  syscall sys_rtc        ; get day
  mov bl, ah
  call print_u8x
  mov a, $2000
  syscall sys_io         ; display ' '
; there is a problem with the month displaying
; the month is stored as bcd. so when retrieving the month, the value will be in binary
; even though it is to be understood as bcd.
; when retrieving the value and adding the string table address offset the value will go overboard!  
  mov al, 05
  syscall sys_rtc        ; get month
  mov al, ah
  mov ah, 0
  shl a, 2          
  mov d, s_months
  add d, a
  call _puts
  mov a, $2000
  syscall sys_io         ; display ' '
  mov bl, $20
  call print_u8x         ; print 20 for year prefix
  mov al, 06
  syscall sys_rtc        ; get year
  mov bl, ah
  call print_u8x
  mov a, $2000  
  syscall sys_io         ; display ' '
  mov al, 2
  syscall sys_rtc        ; get hours
  mov bl, ah
  call print_u8x
  mov a, $3a00    
  syscall sys_io         ; display ':'
  mov al, 01
  syscall sys_rtc        ; get minutes
  mov bl, ah
  call print_u8x
  mov a, $3a00  
  syscall sys_io         ; display ':'
  mov al, 0
  syscall sys_rtc        ; get seconds
  mov bl, ah
  call print_u8x
  call printnl
  sysret
set_date:
  mov d, s_set_year
  call _puts
  call scan_u8x          ; read integer into a
  shl a, 8               ; only al used, move to ah
  mov al, 0dh            ; set rtc year
  syscall sys_rtc        ; set rtc
  mov d, s_set_month
  call _puts
  call scan_u8x          ; read integer into a
  shl a, 8               ; only al used, move to ah
  mov al, 0ch            ; set rtc month
  syscall sys_rtc        ; set rtc
  mov d, s_set_day
  call _puts
  call scan_u8x          ; read integer into a
  shl a, 8               ; only al used, move to ah
  mov al, 0bh            ; set rtc month
  syscall sys_rtc        ; set rtc
  mov d, s_set_week
  call _puts
  call scan_u8x          ; read integer into a
  shl a, 8               ; only al used, move to ah
  mov al, 0ah            ; set rtc month
  syscall sys_rtc        ; set rtc
  mov d, s_set_hours
  call _puts
  call scan_u8x          ; read integer into a
  shl a, 8               ; only al used, move to ah
  mov al, 09h            ; set rtc month
  syscall sys_rtc        ; set rtc
  mov d, s_set_minutes
  call _puts
  call scan_u8x          ; read integer into a
  shl a, 8               ; only al used, move to ah
  mov al, 08h            ; set rtc month
  syscall sys_rtc        ; set rtc
  mov d, s_set_seconds
  call _puts
  call scan_u8x          ; read integer into a
  shl a, 8               ; only al used, move to ah
  mov al, 07h            ; set rtc month
  syscall sys_rtc        ; set rtc
  sysret

; ------------------------------------------------------------------------------------------------------------------;
; ide services syscall
; al = option
; 0 = ide reset, 1 = ide sleep, 2 = read sector, 3 = write sector
; ide read/write sector
; 512 bytes
; user buffer pointer in d
; ah = number of sectors
; cb = lba bytes 3..0
; ------------------------------------------------------------------------------------------------------------------;
ide_serv_tbl:
  .dw ide_reset
  .dw ide_sleep
  .dw ide_read_sect_wrapper
  .dw ide_write_sect_wrapper
syscall_ide:
  jmp [ide_serv_tbl + al]    

ide_reset:      
  mov byte[_ide_r7], 4            ; reset ide
  call ide_wait                   ; wait for ide ready             
  mov byte[_ide_r6], $e0          ; lba3= 0, master, mode= lba        
  mov byte[_ide_r1], 1            ; 8-bit transfers      
  mov byte[_ide_r7], $ef          ; set feature command
  sysret
ide_sleep:
  call ide_wait                   ; wait for ide ready             
  mov byte [_ide_r6], %01000000   ; lba[3:0](reserved), bit 6=1
  mov byte [_ide_r7], $e6         ; sleep command
  call ide_wait                   ; wait for ide ready
  sysret
ide_read_sect_wrapper:
  call ide_read_sect
  sysret
ide_write_sect_wrapper:
  call ide_write_sect
  sysret
ide_read_sect:
  mov al, ah
  mov ah, bl
  mov [_ide_r2], a                ; number of sectors (0..255)
  mov al, bh
  mov [_ide_r4], al
  mov a, c
  mov [_ide_r5], al
  mov al, ah
  and al, %00001111
  or al, %11100000                ; mode lba, master
  mov [_ide_r6], al
ide_read_sect_wait:
  mov al, [_ide_r7]  
  and al, $80                     ; busy flag
  jnz ide_read_sect_wait
  mov al, $20
  mov [_ide_r7], al               ; read sector cmd
  call ide_read  
  ret
ide_write_sect:
  mov al, ah
  mov ah, bl
  mov [_ide_r2], a                ; number of sectors (0..255)
  mov al, bh
  mov [_ide_r4], al
  mov a, c
  mov [_ide_r5], al
  mov al, ah
  and al, %00001111
  or al, %11100000                ; mode lba, master
  mov [_ide_r6], al
ide_write_sect_wait:
  mov al, [_ide_r7]  
  and al, $80                     ; busy flag
  jnz ide_write_sect_wait
  mov al, $30
  mov [_ide_r7], al               ; write sector cmd
  call ide_write      
  ret

;----------------------------------------------------------------------------------------------------;
; read ide data
; pointer in d
;----------------------------------------------------------------------------------------------------;
ide_read:
  push d
ide_read_loop:
  mov al, [_ide_r7]  
  and al, 80h                     ; busy flag
  jnz ide_read_loop               ; wait loop
  mov al, [_ide_r7]
  and al, %00001000               ; drq flag
  jz ide_read_end
  mov al, [_ide_r0]
  mov [d], al
  inc d
  jmp ide_read_loop
ide_read_end:
  pop d
  ret

;----------------------------------------------------------------------------------------------------;
; write ide data
; data pointer in d
;----------------------------------------------------------------------------------------------------;
ide_write:
  push d
ide_write_loop:
  mov al, [_ide_r7]  
  and al, 80h             ; busy flag
  jnz ide_write_loop      ; wait loop
  mov al, [_ide_r7]
  and al, %00001000       ; drq flag
  jz ide_write_end
  mov al, [d]
  mov [_ide_r0], al
  inc d 
  jmp ide_write_loop
ide_write_end:
  pop d
  ret

;----------------------------------------------------------------------------------------------------;
; wait for ide to be ready
;----------------------------------------------------------------------------------------------------;
ide_wait:
  mov al, [_ide_r7]  
  and al, 80h        ; busy flag
  jnz ide_wait
  ret

;----------------------------------------------------------------------------------------------------;
; io syscall
;----------------------------------------------------------------------------------------------------;
; baud  divisor
; 50    2304
; 110   1047
; 300    384
; 600    192
; 1200    96
; 9600    12
; 19200    6
; 38400    3
syscall_io_jmp:
  .dw syscall_io_putchar
  .dw syscall_io_getch
  .dw syscall_io_uart_setup
syscall_io:
  jmp [syscall_io_jmp + al]
; bit7 is the divisor latch access bit (dlab). it must be set high (logic 1) to access the divisor latches
; of the baud generator during a read or write operation. it must be set low (logic 0) to access the receiver
; buffer, the transmitter holding register, or the interrupt enable register.
syscall_io_uart_setup:
  mov al, [sys_uart0_lcr]
  or al, $80                ; set dlab access bit
  mov [_uart0_lcr], al      ; 8 data, 2 stop, no parity by default
  mov al, [sys_uart0_div0]
  mov [_uart0_dlab_0], al   ; divisor latch byte 0
  mov al, [sys_uart0_div1]
  mov [_uart0_dlab_1], al   ; divisor latch byte 1      
  mov al, [sys_uart0_lcr]
  and al, $7f               ; clear dlab access bit 
  mov [_uart0_lcr], al
  mov al, [sys_uart0_inten]
  mov [_uart0_ier], al      ; interrupts
  mov al, [sys_uart0_fifoen]
  mov [_uart0_fcr], al      ; fifo control
; uart1:
  mov al, [sys_uart1_lcr]
  or al, $80                ; set dlab access bit
  mov [_uart1_lcr], al      ; 8 data, 2 stop, no parity by default
  mov al, [sys_uart1_div0]
  mov [_uart1_dlab_0], al   ; divisor latch byte 0
  mov al, [sys_uart1_div1]
  mov [_uart1_dlab_1], al   ; divisor latch byte 1      
  mov al, [sys_uart1_lcr]
  and al, $7f               ; clear dlab access bit 
  mov [_uart1_lcr], al
  mov al, [sys_uart1_inten]
  mov [_uart1_ier], al      ; interrupts
  mov al, [sys_uart1_fifoen]
  mov [_uart1_fcr], al      ; fifo control
  sysret

; char in ah
syscall_io_putchar:
syscall_io_putchar_l0:
  mov al, [_uart0_lsr]         ; read line status register
  and al, $20
  jz syscall_io_putchar_l0    
  mov al, ah
  mov [_uart0_data], al        ; write char to transmitter holding register
; write to uart1
syscall_io_putchar_l1:
  mov al, [_uart1_lsr]         ; read line status register
  and al, $20
  jz syscall_io_putchar_l1
  mov al, ah
  mov [_uart1_data], al        ; write char to transmitter holding register
  sysret

; char in ah
; al = sucess code
syscall_io_getch:
  push b
  push d
  sti
syscall_io_getch_l0:  
  mov a, [fifo_out]
  mov b, [fifo_in]
  cmp a, b
  je syscall_io_getch_l0
  mov d, a
  inc a
  cmp a, fifo + _fifo_size      ; check if pointer reached the end of the fifo
  jne syscall_io_getch_cont
  mov a, fifo  
syscall_io_getch_cont:  
  mov [fifo_out], a             ; update fifo pointer
  mov al, [d]                   ; get char
  mov ah, al
; here we just echo the char back to the console
syscall_io_getch_echo_l0:
  mov al, [_uart0_lsr]         ; read line status register
  and al, $20                 ; isolate transmitter empty
  jz syscall_io_getch_echo_l0
  mov al, ah
  mov [_uart0_data], al        ; write char to transmitter holding register
syscall_io_getch_echo_l1:
  mov al, [_uart1_lsr]         ; read line status register
  and al, $20                 ; isolate transmitter empty
  jz syscall_io_getch_echo_l1
  mov al, ah
  mov [_uart1_data], al        ; write char to transmitter holding register
syscall_io_getch_noecho:
  mov al, 1                    ; al = 1 means a char successfully received
  pop d
  pop b
  sysret

;------------------------------------------------------------------------------------------------------;
; file system data
;------------------------------------------------------------------------------------------------------;
; infor for : ide services interrupt
; ide read/write 512-byte sector
; al = option
; user buffer pointer in d
; ah = number of sectors
; cb = lba bytes 3..0  
;------------------------------------------------------------------------------------------------------;
; file system data structure
;------------------------------------------------------------------------------------------------------;
; for a directory we have the header first, followed by metadata
; header 1 sector (512 bytes)
; metadata 1 sector (512 bytes)
; header entries:
; filename (64)
; parent dir lba (2) -  to be used for faster backwards navigation...
;
; metadata entries:
; filename (24)
; attributes (1)  |_|_|file_type(3bits)|x|w|r| types: file, directory, character device
; lba (2)
; size (2)
; day (1)
; month (1)
; year (1)
; packet size = 32 bytes
;
; first directory on disk is the root directory '/'
file_system_jmptbl:
  .dw 0                         ; 0
  .dw 0                         ; 1
  .dw fs_mkdir                  ; 2
  .dw fs_cd                     ; 3
  .dw fs_ls                     ; 4
  .dw fs_mktxt                  ; 5
  .dw fs_mkbin                  ; 6
  .dw fs_pwd                    ; 7
  .dw fs_cat                    ; 8
  .dw fs_rmdir                  ; 9
  .dw fs_rm                     ; 10
  .dw 0                         ; 11
  .dw 0                         ; 12
  .dw 0                         ; 13
  .dw fs_chmod                  ; 14
  .dw fs_mv                     ; 15
  .dw fs_cd_root                ; 16
  .dw fs_get_curr_dirid         ; 17
  .dw fs_dir_id_to_path         ; 18
  .dw fs_path_to_dir_id_user    ; 19
  .dw fs_load_from_path_user    ; 20  
  .dw fs_filepath_exists_user   ; 21

s_syscall_fs_dbg0: .db "\n> syscall_file_system called: ", 0
syscall_file_system:
  push bl
  mov bl, [sys_debug_mode]
  ; debug block
  cmp bl, 0
  pop bl
  je syscall_filesystem_jmp
  push d
  push bl
  mov d, s_syscall_fs_dbg0
  call _puts
  mov bl, al
  call print_u8x
  call printnl
  pop bl
  pop d
syscall_filesystem_jmp:
  jmp [file_system_jmptbl + al]
  
fs_cd_root:
  mov a, root_id
  mov [current_dir_id], a      ; set current directory lba to root
  sysret  

; filename in d (userspace data)
; permission in bl
fs_chmod:
  push bl
  mov si, d
  mov di, user_data
  mov c, 128
  load                        ; load filename from user-space
  mov a, [current_dir_id]
  inc a                       ; metadata sector
  mov b, a
  mov c, 0                    ; upper lba = 0
  mov ah, $01                  ; 1 sector
  mov d, transient_area
  call ide_read_sect          ; read directory
  cla
  mov [index], a              ; reset file counter
fs_chmod_l1:
  mov si, d
  mov di, user_data
  call _strcmp
  je fs_chmod_found_entry
  add d, 32
  mov a, [index]
  inc a
  mov [index], a
  cmp a, fst_files_per_dir
  jne fs_chmod_l1
  pop bl
  jmp fs_chmod_not_found
fs_chmod_found_entry:  
  mov g, b                    ; save lba
  pop bl                      ; retrieve saved permission value
  mov al, [d + 24]            ; read file permissions
  and al, %11111000           ; remove all permissions, keep other flags
  or al, bl                   ; set new permissions
  mov [d + 24], al            ; write new permissions
  mov c, 0
  mov d, transient_area
  mov ah, $01                 ; disk write 1 sect
  mov b, g                    ; retrieve lba
  call ide_write_sect         ; write sector
fs_chmod_not_found:
  sysret

;------------------------------------------------------------------------------------------------------;
; create new directory
;------------------------------------------------------------------------------------------------------;
; search list for null name entry. add new directory to list
fs_mkdir:
  mov si, d
  mov di, user_data
  mov c, 512
  load                        ; load data from user-space
  mov b, fst_lba_start + 2    ; start at 2 because lba  0 is root (this would also cause issues                 
                              ; when checking for null name, since root has a null name)
  mov c, 0                    ; upper lba = 0
fs_mkdir_l1:  
  mov ah, $01                  ; 1 sector
  mov d, transient_area
  call ide_read_sect          ; read sector
  cmp byte[d], 0              ; check for null
  je fs_mkdir_found_null
  add b, fst_sectors_per_dir  ; skip directory
  jmp fs_mkdir_l1
fs_mkdir_found_null:
;create header file by grabbing dir name from parameter
  push b                      ; save new directory's lba
  mov c, 64
  mov si, user_data
  mov di, transient_area
  rep movsb                   ; copy dirname from user_data to transient_area
  mov a, [current_dir_id]
  mov [transient_area + 64], a    ; store parent directory lba
  mov al, 0
  mov di, transient_area + 512
  mov c, 512
  rep stosb                       ; clean buffer
  mov c, 0                        ; reset lba(c) to 0
; write directory entry sectors
  mov d, transient_area
  mov ah, $02                     ; disk write, 2 sectors
  call ide_write_sect             ; write sector
; now we need to add the new directory to the list, inside the current directory
  mov a, [current_dir_id]
  add a, 1
  mov b, a                        ; metadata sector
  mov c, 0
  mov g, b                        ; save lba
  mov d, transient_area
  mov ah, $01                  ; 1 sector
  call ide_read_sect              ; read metadata sector
fs_mkdir_l2:
  cmp byte[d], 0
  je fs_mkdir_found_null2
  add d, fst_entry_size
  jmp fs_mkdir_l2                ; we look for a null entry here but dont check for limits. care needed when adding too many files to a directory
fs_mkdir_found_null2:
  mov si, user_data
  mov di, d
  call _strcpy                    ; copy directory name
  add d, 24                       ; goto attributes
  mov al, %00001011               ; directory, no execute, write, read
  mov [d], al      
  inc d
  pop b
  push b                          ; push lba back
  mov [d], b                      ; save lba
; set file creation date  
  add d, 4
  mov al, 4
  syscall sys_rtc
  mov al, ah
  mov [d], al                     ; set day
  inc d
  mov al, 5
  syscall sys_rtc
  mov al, ah
  mov [d], al                     ; set month
  inc d
  mov al, 6
  syscall sys_rtc
  mov al, ah
  mov [d], al                     ; set year
; write sector into disk for new directory entry
  mov b, g
  mov c, 0
  mov d, transient_area
  mov ah, $01                     ; disk write, 1 sector
  call ide_write_sect             ; write sector

; after adding the new directory's information to its parent directory's list
; we need to now enter the new directory, and to it add two new directories!
; which directories do we need to add ? '..' and '.' are the directories needed.
; importantly, note that these two new directories are only entries in the list
; and do not have actual physical entries in the disk as real directories.
; i.e. they only exist as list entries in the new directory created so that
; the new directory can reference its parent and itself.
; we need to add both '..' and '.'
; this first section is for '..' and on the section below we do the same for '.'
  pop a                         ; retrieve the new directory's lba  
  push a                        ; and save again
  add a, 1
  mov b, a                      ; metadata sector
  mov c, 0
  mov g, b                      ; save lba
  mov d, transient_area
  mov ah, $01                  ; 1 sector
  call ide_read_sect            ; read metadata sector
fs_mkdir_l3:
  cmp byte[d], 0
  je fs_mkdir_found_null3
  add d, fst_entry_size
  jmp fs_mkdir_l3              ; we look for a null entry here but dont check for limits. care needed when adding too many files to a directory
fs_mkdir_found_null3:
  mov si, s_parent_dir
  mov di, d
  call _strcpy                  ; copy directory name
  add d, 24                     ; goto attributes
  mov al, %00001011             ; directory, no execute, write, read, 
  mov [d], al      
  inc d
  mov b, [current_dir_id]        ; retrieve the parent directorys lba
  mov [d], b                    ; save lba
; set file creation date  
  add d, 4
  mov al, 4
  syscall sys_rtc
  mov al, ah
  mov [d], al                   ; set day
  inc d
  mov al, 5
  syscall sys_rtc
  mov al, ah
  mov [d], al                   ; set month
  inc d
  mov al, 6
  syscall sys_rtc
  mov al, ah
  mov [d], al                   ; set year
; write sector into disk for new directory entry
  mov b, g
  mov c, 0
  mov d, transient_area
  mov ah, $01                   ; disk write, 1 sector
  call ide_write_sect           ; write sector
;;;;;;;;;;;;;
; like we did above for '..', we need to now add the '.' directory to the list.
;------------------------------------------------------------------------------------------------------;
  pop a                         ; retrieve the new directory's lba  
  push a
  add a, 1
  mov b, a                      ; metadata sector
  mov c, 0
  mov g, b                      ; save lba
  mov d, transient_area
  mov ah, $01                  ; 1 sector
  call ide_read_sect            ; read metadata sector
fs_mkdir_l4:
  cmp byte[d], 0
  je fs_mkdir_found_null4
  add d, fst_entry_size
  jmp fs_mkdir_l4              ; we look for a null entry here but dont check for limits. care needed when adding too many files to a directory
fs_mkdir_found_null4:
  mov si, s_current_dir
  mov di, d
  call _strcpy                  ; copy directory name
  add d, 24                     ; goto attributes
  mov al, %00001011             ; directory, no execute, write, read, 
  mov [d], al      
  inc d
  pop b                         ; new directory's lba itself. for self-referential directory entry '.'
  mov [d], b                    ; save lba
; set file creation date  
  add d, 4
  mov al, 4
  syscall sys_rtc
  mov al, ah
  mov [d], al                   ; set day
  inc d
  mov al, 5
  syscall sys_rtc
  mov al, ah
  mov [d], al                   ; set month
  inc d
  mov al, 6
  syscall sys_rtc
  mov al, ah
  mov [d], al                   ; set year
; write sector into disk for new directory entry
  mov b, g
  mov c, 0
  mov d, transient_area
  mov ah, $01                   ; disk write, 1 sector
  call ide_write_sect           ; write sector
fs_mkdir_end:
  sysret

;------------------------------------------------------------------------------------------------------;
; get path from a given directory dirid
; pseudo code:
;  fs_dir_id_to_path(int dirid, char *d){
;    if(dirid == 0){
;      reverse path in d;
;      return;
;    }
;    else{
;      copy directory name to end of d;
;      add '/' to end of d;
;      parentid = get parent directory id;
;      fs_dir_id_to_path(parentid, d);
;    }
;  }
; a = dirid
; d = generated path string pointer
;------------------------------------------------------------------------------------------------------;
; sample path: /usr/bin
fs_dir_id_to_path:
  mov d, filename
  mov al, 0
  mov [d], al                     ; initialize path string 
  mov a, [current_dir_id]
  call fs_dir_id_to_path_e0
  mov d, filename
  call _strrev
  call _puts
  sysret
fs_dir_id_to_path_e0:
  call get_dirname_from_dirid
  mov si, s_fslash
  mov di, d
  call _strcat                    ; add '/' to end of path
  cmp a, root_id               ; check if we are at the root directory
  je fs_dir_id_to_path_root
  call get_parentid_from_dirid    ; use current id (a) to find parentid (into a)
  cmp a, root_id               ; check if we are at the root directory
  je fs_dir_id_to_path_root
  call fs_dir_id_to_path_e0     ; recursively call itself
fs_dir_id_to_path_root:
  ret

;------------------------------------------------------------------------------------------------------;
; in_puts:
; a = directory id
; out_puts:
; d = pointer to directory name string
;------------------------------------------------------------------------------------------------------;
get_dirname_from_dirid:
  push a
  push b
  push d
  mov b, a
  mov c, 0                      ; upper lba = 0
  mov ah, $01                  ; 1 sector
  mov d, transient_area - 512
  call ide_read_sect            ; read directory
  call _strrev                  ; reverse dir name before copying
  mov si, d
  pop d                         ; destination address = d value pushed at beginning
  mov di, d
  call _strcat                  ; copy filename to d
  pop b
  pop a
  ret

;------------------------------------------------------------------------------------------------------;
; in_puts:
; a = directory id
; out_puts:
; a = parent directory id
;------------------------------------------------------------------------------------------------------;
get_parentid_from_dirid:
  push b
  push d
  mov b, a
  mov c, 0                      ; upper lba = 0
  mov ah, $01                  ; 1 sector
  mov d, transient_area - 512
  call ide_read_sect            ; read directory
  mov a, [d + 64]               ; copy parent id value to a
  pop d
  pop b
  ret

;------------------------------------------------------------------------------------------------------;
; get dirid from a given path string
; in_puts:
; d = path pointer 
; out_puts:
; a = dirid
; if dir non existent, a = ffff (fail code)
; /usr/local/bin    - absolute
; local/bin/games    - relative
;------------------------------------------------------------------------------------------------------;
fs_path_to_dir_id_user:
  mov si, d
  mov di, user_data
  mov c, 512
  load
  call get_dirid_from_path
  sysret
get_dirid_from_path:
  mov b, user_data
  mov [prog], b                  ; token pointer set to path string
  call get_token
  mov bl, [tok]
  cmp bl, tok_fslash
  je get_dirid_from_path_abs 
  mov a, [current_dir_id]
  call _putback
  jmp get_dirid_from_path_e0
get_dirid_from_path_abs:
  mov a, root_id
get_dirid_from_path_e0:
  call get_token
  mov bl, [toktyp]
  cmp bl, toktyp_identifier
  jne get_dirid_from_path_end   ; check if there are tokens after '/'. i.e. is this a 'cd /' command?

  mov si, tokstr
  mov di, filename
  call _strcpy        
  inc a                         ; metadata sector
  mov b, a
  mov c, 0                      ; upper lba = 0
  mov ah, $01                  ; 1 sector
  mov d, transient_area
  call ide_read_sect            ; read directory
  cla
  mov [index], a
get_dirid_from_path_l1:
  mov si, d
  mov di, filename
  call _strcmp
  je get_dirid_from_path_name_equal  
  add d, 32
  mov a, [index]
  inc a
  mov [index], a
  cmp a, fst_files_per_dir
  je get_dirid_from_path_fail
  jmp get_dirid_from_path_l1
get_dirid_from_path_name_equal:
  add d, 25           
  mov a, [d]                    ; set result register a = dirid
  call get_token
  mov bl, [tok]
  cmp bl, tok_fslash            ; check if there are more elements in the path
  je get_dirid_from_path_e0
  call _putback
get_dirid_from_path_end:
  ret
get_dirid_from_path_fail:
  mov a, $ffff
  ret


;------------------------------------------------------------------------------------------------------;
; check if file exists by a given path string
; in_puts:
; d = path pointer 
; outputs:
; a = success code, if file exists gives lba, else, give 0
; /usr/local/bin/ed
;------------------------------------------------------------------------------------------------------;
fs_filepath_exists_user:
  mov si, d
  mov di, user_data
  mov c, 512
  load
  call file_exists_by_path
  sysret
file_exists_by_path:
  mov b, user_data
  mov [prog], b                   ; token pointer set to path string
  call get_token
  mov bl, [tok]
  cmp bl, tok_fslash
  je  file_exists_by_path_abs
  mov a, [current_dir_id]
  call _putback
  jmp file_exists_by_path_e0
file_exists_by_path_abs:
  mov a, root_id
file_exists_by_path_e0:
  call get_token
  mov bl, [toktyp]
  cmp bl, toktyp_identifier
  jne file_exists_by_path_end     ; check if there are tokens after '/'
  mov si, tokstr
  mov di, filename
  call _strcpy        
  inc a                           ; metadata sector
  mov b, a
  mov c, 0                        ; upper lba = 0
  mov ah, $01                  ; 1 sector
  mov d, transient_area
  call ide_read_sect              ; read directory
  cla
  mov [index], a
file_exists_by_path_l1:
  mov si, d
  mov di, filename
  call _strcmp
  je   file_exists_by_path_name_equal
  add d, 32
  mov a, [index]
  inc a
  mov [index], a
  cmp a, fst_files_per_dir
  je file_exists_by_path_end
  jmp file_exists_by_path_l1
file_exists_by_path_name_equal:
  mov bl, [d + 24]
  and bl, %00111000               ; directory flag
  cmp bl, %00001000               ; is dir?
  je file_exists_by_path_isdir;
; entry is a file
  mov a, [d + 25]                 ; get and return lba of file
  ret
file_exists_by_path_isdir:
  add d, 25           
  mov a, [d]                      ; set result register a = dirid
  call get_token
  jmp file_exists_by_path_e0
file_exists_by_path_end:
  mov a, 0                        ; return 0 because file was not found
  ret

;------------------------------------------------------------------------------------------------------;
; load file data from a given path string
; inputs:
; d = path pointer 
; di = userspace program data destination
; /usr/local/bin/ed
; ./ed
;------------------------------------------------------------------------------------------------------;
fs_load_from_path_user:
  push di
  mov si, d
  mov di, user_data
  mov c, 512
  load
  call loadfile_from_path
  pop di
  mov si, transient_area
  mov c, 512 * (fs_sectors_per_file-1)
  store
  sysret
loadfile_from_path:
  mov b, user_data
  mov [prog], b                 ; token pointer set to path string
  call get_token
  mov bl, [tok]
  cmp bl, tok_fslash
  je loadfile_from_path_abs 
  mov a, [current_dir_id]
  call _putback
  jmp loadfile_from_path_e0
loadfile_from_path_abs:
  mov a, root_id
loadfile_from_path_e0:
  call get_token
  mov bl, [toktyp]
  cmp bl, toktyp_identifier
  jne loadfile_from_path_end    ; check if there are tokens after '/'. i.e. is this a 'cd /' command?
  mov si, tokstr
  mov di, filename
  call _strcpy        
  inc a                         ; metadata sector
  mov b, a
  mov c, 0                      ; upper lba = 0
  mov ah, $01                  ; 1 sector
  mov d, transient_area
  call ide_read_sect            ; read directory
  cla
  mov [index], a
loadfile_from_path_l1:
  mov si, d
  mov di, filename
  call _strcmp
  je loadfile_from_path_name_equal  
  add d, 32
  mov a, [index]
  inc a
  mov [index], a
  cmp a, fst_files_per_dir
  je loadfile_from_path_end
  jmp loadfile_from_path_l1
loadfile_from_path_name_equal:
  mov bl, [d + 24]
  and bl, %00111000             ; directory flag
  cmp bl, %00001000             ; is dir?
  je loadfile_isdirectory  
; entry is a file
  mov b, [d + 25]               ; get lba
  inc b                         ; add 1 to b because the lba for data comes after the header sector
  mov d, transient_area
  mov c, 0
  mov ah, fs_sectors_per_file-1 ; number of sectors
  call ide_read_sect            ; read sector
  ret
loadfile_isdirectory:
  add d, 25           
  mov a, [d]                    ; set result register a = dirid
  call get_token
  jmp loadfile_from_path_e0
loadfile_from_path_end:
  ret

;------------------------------------------------------------------------------------------------------;
; return the id of the current directory
; id returned in b
;------------------------------------------------------------------------------------------------------;
fs_get_curr_dirid:
  mov b, [current_dir_id]
  sysret

;------------------------------------------------------------------------------------------------------;
; cd
;------------------------------------------------------------------------------------------------------;
; new dirid in b
fs_cd:
  mov [current_dir_id], b
  sysret  

;------------------------------------------------------------------------------------------------------;
; ls
; dirid in b
;------------------------------------------------------------------------------------------------------;
ls_count:       .dw 0
fs_ls:
  inc b                        ; metadata sector
  mov c, 0                     ; upper lba = 0
  mov ah, $01                  ; 1 sector
  mov d, transient_area
  call ide_read_sect           ; read directory
  cla
  mov [index], a               ; reset entry index
  mov [ls_count], al           ; reset item count
fs_ls_l1:
  cmp byte [d], 0              ; check for null
  je fs_ls_next
fs_ls_non_null:
  mov al, [ls_count]
  inc al
  mov [ls_count], al           ; increment item count
  mov al, [d + 24]
  and al, %00111000
  shr al, 3
  mov ah, 0                    ; file type
  mov a, [a + file_type]      
  mov ah, al
  call _putchar
  mov al, [d + 24]
  and al, %00000001
  mov ah, 0
  mov a, [a + file_attrib]     ; read
  mov ah, al
  call _putchar
  mov al, [d + 24]
  and al, %00000010
  mov ah, 0
  mov a, [a + file_attrib]     ; write
  mov ah, al
  call _putchar
  mov al, [d + 24]
  and al, %00000100
  mov ah, 0
  mov a, [a + file_attrib]     ; execute
  mov ah, al
  call _putchar
  mov ah, $20
  call _putchar  
  mov b, [d + 27]
  call print_u16x              ; filesize
  mov ah, $20
  call _putchar  
  mov b, [d + 25]
  call print_u16x              ; dirid / lba
  mov ah, $20
  call _putchar
; print date
  mov bl, [d + 29]             ; day
  call print_u8x
  mov ah, $20
  call _putchar  
  mov al, [d + 30]             ; month
  shl al, 2
  push d
  mov d, s_months
  mov ah, 0
  add d, a
  call _puts
  pop d
  mov ah, $20
  call _putchar
  mov bl, $20
  call print_u8x
  mov bl, [d + 31]             ; year
  call print_u8x  
  mov ah, $20
  call _putchar  
  call _puts                   ; print filename  
  call printnl
fs_ls_next:
  mov a, [index]
  inc a
  mov [index], a
  cmp a, fst_files_per_dir
  je fs_ls_end
  add d, 32      
  jmp fs_ls_l1  
fs_ls_end:
  mov d, s_ls_total
  call _puts
  mov al, [ls_count]
  call print_u8d
  call printnl
  sysret

;------------------------------------------------------------------------------------------------------;
; finds an empty data block
; block lba returned in b
;------------------------------------------------------------------------------------------------------;
fs_find_empty_block:
  mov b, fs_lba_start     ; raw files starting block
  mov c, 0                ; upper lba = 0
fs_find_empty_block_l1:  
  mov ah, $01                  ; 1 sector
  mov d, transient_area - 512
  call ide_read_sect      ; read sector
  cmp byte [d], 0
  je fs_find_empty_block_found_null
  add b, fs_sectors_per_file
  jmp fs_find_empty_block_l1
fs_find_empty_block_found_null:
  ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; create new textfile
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; search for first null block
fs_mktxt:
	mov si, d
	mov di, user_data
	mov c, 256
	load					; load data from user-space
	
	mov b, fs_lba_start		; raw files starting block
	mov c, 0						; reset lba to 0
fs_mktxt_l1:	
	mov a, $0102			; disk read
	mov d, transient_area
	syscall sys_ide ; read sector
	mov al, [d]
	cmp al, 0			; check for null
	je fs_mktxt_found_null
	add b, fs_sectors_per_file
	jmp fs_mktxt_l1
fs_mktxt_found_null:
	push b				; save lba
;create header file by grabbing file name from parameter	
	mov d, s_dataentry
	call _puts
	mov d, transient_area + 512			; pointer to file contents
	call _gettxt
	call _strlen						; get length of file
	push c							; save length
	mov al, 1
	mov [transient_area], al					; mark sectors as used (not null)
	mov a, 0
	mov [index], a
	mov d, transient_area
	mov a, d
	mov [buffer_addr], a
fs_mktxt_l2:
	mov c, 0
	mov a, $0103			; disk write, 1 sector
	syscall sys_ide		; write sector
	mov a, [index]
	inc a
	mov [index], a
	cmp a, fs_sectors_per_file
	je fs_mktxt_add_to_dir
	inc b
	mov a, [buffer_addr]
	add a, 512
	mov [buffer_addr], a
	mov d, a
	jmp fs_mktxt_l2
; now we add the file to the current directory!
fs_mktxt_add_to_dir:	
	mov a, [current_dir_id]
	inc a
	mov b, a					; metadata sector
	mov c, 0
	mov g, b					; save lba
	mov d, transient_area
	mov a, $0102			; disk read
	syscall sys_ide		; read metadata sector
fs_mktxt_add_to_dir_l2:
	mov al, [d]
	cmp al, 0
	je fs_mktxt_add_to_dir_null
	add d, fst_entry_size
	jmp fs_mktxt_add_to_dir_l2					; we look for a null entry here but dont check for limits. care needed when adding too many files to a directory
fs_mktxt_add_to_dir_null:
	mov si, user_data
	mov di, d
	call _strcpy			; copy file name
	add d, 24			; skip name
	mov al, %00000110		; no execute, write, read, not directory
	mov [d], al			
	add d, 3
	pop a
	mov [d], a
	sub d, 2
	pop b				; get file lba
	mov [d], b			; save lba	
	
	; set file creation date	
	add d, 4
	mov al, 4
	syscall sys_rtc
	mov al, ah
	mov [d], al			; set day
	
	inc d
	mov al, 5
	syscall sys_rtc
	mov al, ah
	mov [d], al			; set month
	
	inc d
	mov al, 6
	syscall sys_rtc
	mov al, ah
	mov [d], al			; set year
	
; write sector into disk for new directory entry
	mov b, g
	mov c, 0
	mov d, transient_area
	mov a, $0103			; disk write, 1 sector
	syscall sys_ide		; write sector
	call printnl
	sysret

;------------------------------------------------------------------------------------------------------;
; create new binary file
;------------------------------------------------------------------------------------------------------;
; search for first null block
fs_mkbin:
  mov al, 0
  mov [sys_echo_on], al ; disable echo
  mov si, d
  mov di, user_data
  mov c, 512
  load                          ; load data from user-space
  mov b, fs_lba_start           ; files start when directories end
  mov c, 0                      ; upper lba = 0
fs_mkbin_l1:  
  mov ah, $01                  ; 1 sector
  mov d, transient_area
  call ide_read_sect            ; read sector
  cmp byte[d], 0                ; check for null
  je fs_mkbin_found_null
  add b, fs_sectors_per_file
  jmp fs_mkbin_l1
fs_mkbin_found_null:
  push b                        ; save lba
;create header file by grabbing file name from parameter
  mov di, transient_area + 512  ; pointer to file contents
  call _load_hex                ; load binary hex
  push c                        ; save size (nbr of bytes)
  mov al, 1
  mov [transient_area], al      ; mark sectors as used (not null)
  cla
  mov [index], a
  mov d, transient_area
  mov a, d
  mov [buffer_addr], a
fs_mkbin_l2:
  mov c, 0
  mov ah, $01                   ; disk write, 1 sector
  call ide_write_sect           ; write sector
  mov a, [index]
  inc a
  mov [index], a
  cmp a, fs_sectors_per_file    ; remove 1 from this because we dont count the header sector
  je fs_mkbin_add_to_dir
  inc b
  mov a, [buffer_addr]
  add a, 512
  mov [buffer_addr], a
  mov d, a
  jmp fs_mkbin_l2
; now we add the file to the current directory!
fs_mkbin_add_to_dir:  
  mov a, [current_dir_id]
  inc a
  mov b, a                      ; metadata sector
  mov c, 0
  mov g, b                      ; save lba
  mov d, transient_area
  mov ah, $01                  ; 1 sector
  call ide_read_sect            ; read metadata sector
fs_mkbin_add_to_dir_l2:
  cmp byte[d], 0
  je fs_mkbin_add_to_dir_null
  add d, fst_entry_size
  jmp fs_mkbin_add_to_dir_l2   ; we look for a null entry here but dont check for limits. care needed when adding too many files to a directory
fs_mkbin_add_to_dir_null:
  mov si, user_data
  mov di, d
  call _strcpy                  ; copy file name
  add d, 24                     ; skip name
  mov al, %00000011             ; type=file, no execute, write, read, 
  mov [d], al
  add d, 3
  pop a
  mov [d], a
  sub d, 2
  pop b                         ; get file lba
  mov [d], b                    ; save lba
  ; set file creation date  
  add d, 4
  mov al, 4
  syscall sys_rtc
  mov al, ah
  mov [d], al                   ; set day
  inc d
  mov al, 5
  syscall sys_rtc
  mov al, ah
  mov [d], al                   ; set month
  inc d
  mov al, 6
  syscall sys_rtc
  mov al, ah
  mov [d], al                   ; set year
; write sector into disk for new directory entry
  mov b, g
  mov c, 0
  mov d, transient_area
  mov ah, $01                   ; disk write, 1 sector
  call ide_write_sect           ; write sector
  mov al, 1
  mov [sys_echo_on], al ; enable echo
  sysret

;------------------------------------------------------------------------------------------------------;
; pwd - print working directory
;------------------------------------------------------------------------------------------------------;    
fs_pwd:
  mov d, filename
  mov al, 0
  mov [d], al                   ; initialize path string 
  mov a, [current_dir_id]
  call fs_dir_id_to_path_e0
  mov d, filename
  call _strrev
  call _puts
  call printnl
  sysret

;------------------------------------------------------------------------------------------------------;
; get current directory lba
; a: returned lba
;------------------------------------------------------------------------------------------------------;
cmd_get_curr_dir_lba:
  mov a, [current_dir_id]
  sysret

;------------------------------------------------------------------------------------------------------;
; cat
; userspace destination data pointer in d
; filename starts at d, but is overwritten after the read is made
;------------------------------------------------------------------------------------------------------;:
fs_cat:
  push d                              ; save userspace file data destination
  mov si, d
  mov di, user_data
  mov c, 512
  load                                ; copy filename from user-space
  mov b, [current_dir_id]
  inc b                               ; metadata sector
  mov c, 0                            ; upper lba = 0
  mov ah, $01                  ; 1 sector
  mov d, transient_area-512
  call ide_read_sect                  ; read directory
  cla
  mov [index], a                      ; reset file counter
fs_cat_l1:
  mov si, d
  mov di, user_data
  call _strcmp
  je fs_cat_found_entry
  add d, 32
  mov a, [index]
  inc a
  mov [index], a
  cmp a, fst_files_per_dir
  je fs_cat_not_found
  jmp fs_cat_l1
fs_cat_found_entry:
  add d, 25                           ; get to dirid of file in disk
  mov b, [d]                          ; get lba
  inc b                               ; add 1 to b because the lba for data comes after the header sector 
  mov d, transient_area  
  mov c, 0
  mov ah, fs_sectors_per_file-1       ; nbr sectors
  call ide_read_sect                  ; read sectors
  pop di                              ; write userspace file data destination to di
  mov si, transient_area              ; data origin
  mov c, 512*(fs_sectors_per_file-1)
  store
  sysret
fs_cat_not_found:
  pop d
  sysret

;------------------------------------------------------------------------------------------------------;
; rmdir - remove dir by dirid
;------------------------------------------------------------------------------------------------------;
; deletes a directory entry in the given directory's file list 
; also deletes the actual directory entry in the fst
; synopsis: rmdir /usr/local/testdir
; b = dirid
fs_rmdir:
  mov g, b
  mov a, b
  call get_parentid_from_dirid  ; now get the directory's parent, in a
  push a                        ; save dirid
; search for directory's entry in the parent's directory then and delete it
  inc a                         ; metadata sector
  mov b, a
  mov c, 0                      ; upper lba = 0
  mov ah, $01          ;
  mov d, transient_area
  call ide_read_sect            ; read directory
  cla
  mov [index], a                ; reset file counter
  mov b, g                      ; retrieve directory's dirid
fs_rmdir_l1:
  mov a, [d + 25]               ; get entry's dirid/lba value
  cmp a, b                      ; compare dirid's to find the directory
  je fs_rmdir_found_entry
  add d, 32
  mov a, [index]
  inc a
  mov [index], a
  cmp a, fst_files_per_dir
  je fs_rmdir_not_found
  jmp fs_rmdir_l1
fs_rmdir_found_entry:
  cla
  mov [d], al                   ; make filename null
  mov [d + 25], a               ; clear dirid/lba as well not to generate problems with previously deleted directories
  pop b
  inc b                         ; metadata sector
  mov c, 0                      ; upper lba = 0
  mov ah, $01          ; 
  mov d, transient_area
  call ide_write_sect           ; write sector and erase file's entry in the current dir

  mov b, g
  mov d, transient_area  
  cla
  mov [d], al                   ; make directory's name header null for re-use
  mov c, 0
  mov ah, $01                   ; disk write 1 sect
  call ide_write_sect           ; delete directory given by dirid in b
  sysret
fs_rmdir_not_found:
  pop b
  sysret

;------------------------------------------------------------------------------------------------------;
; rm - remove file
;------------------------------------------------------------------------------------------------------;
; frees up the data sectors for the file further down the disk
; deletes file entry in the directory's file list 
fs_rm:
  mov si, d
  mov di, user_data
  mov c, 512
  load                          ; load data from user-space
  mov a, [current_dir_id]
  inc a                         ; metadata sector
  mov b, a
  mov c, 0                      ; upper lba = 0
  mov ah, $01                  ; 1 sector
  mov d, transient_area
  call ide_read_sect            ; read directory
  mov a, 0
  mov [index], a                ; reset file counter
fs_rm_l1:
  mov si, d
  mov di, user_data
  call _strcmp
  je fs_rm_found_entry
  add d, 32
  mov a, [index]
  inc a
  mov [index], a
  cmp a, fst_files_per_dir
  je fs_rm_not_found
  jmp fs_rm_l1
fs_rm_found_entry:
  mov b, [d + 25]               ; get lba
  mov g, b                      ; save lba
  mov al, 0
  mov [d], al                   ; make file entry null
  mov a, [current_dir_id]
  inc a                         ; metadata sector
  mov b, a
  mov c, 0                      ; upper lba = 0
  mov ah, $01                   ; disk write
  mov d, transient_area
  call ide_write_sect           ; write sector and erase file's entry in the current dir
  mov d, transient_area  
  mov al, 0
  mov [d], al                   ; make file's data header null for re-use
  mov c, 0
  mov b, g                      ; get data header lba
  mov ah, $01                   ; disk write 1 sect
  call ide_write_sect           ; write sector
fs_rm_not_found:  
  sysret  

;------------------------------------------------------------------------------------------------------;
; mv - move / change file name
;------------------------------------------------------------------------------------------------------;
fs_mv:
  mov si, d
  mov di, user_data
  mov c, 512
  load                          ; load data from user-space
  mov a, [current_dir_id]
  inc a                         ; metadata sector
  mov b, a  
  mov c, 0                      ; upper lba = 0
  mov ah, $01                  ; 1 sector
  mov d, transient_area
  call ide_read_sect            ; read directory
  cla
  mov [index], a                ; reset file counter
fs_mv_l1:
  mov si, d
  mov di, user_data
  call _strcmp
  je fs_mv_found_entry
  add d, 32
  mov a, [index]
  inc a
  mov [index], a
  cmp a, fst_files_per_dir
  je fs_mv_not_found
  jmp fs_mv_l1
fs_mv_found_entry:  
  push d
  mov si, user_data + 128       ; (0...127) = original filename , (128...255) = new name
  mov di, d
  call _strcpy  
  mov c, 0
  mov d, transient_area
  mov ah, $01                   ; disk write 1 sect
  call ide_write_sect           ; write sector
  pop d
;; need to check whether its a dir or a file here ;;;
  mov b, [d + 25]               ; get the dirid of the directory so we can locate its own entry in the list
  mov ah, $01
  mov d, transient_area
  mov c, 0
  call ide_read_sect            ; read directory entry
  mov si, user_data + 128
  mov di, d
  call _strcpy                  ; change directory's name
  mov ah, $01
  call ide_write_sect           ; rewrite directory back to disk
fs_mv_not_found:
  sysret


;----------------------------------------------------------------------------------------------------;
; process index in a
;----------------------------------------------------------------------------------------------------;
find_free_proc:
  mov si, proc_availab_table + 1      ; skip process 0 (kernel)
find_free_proc_l0:
  lodsb                               ; get process state
  cmp al, 0
  je find_free_proc_free              ; if free, jump
  jmp find_free_proc_l0               ; else, goto next
find_free_proc_free:
  mov a, si
  sub a, 1 + proc_availab_table       ; get process index
  ret
  

;----------------------------------------------------------------------------------------------------;
; process index in al
;----------------------------------------------------------------------------------------------------;
proc_memory_map:
  mov ah, 0
  mov b, a                      ; page in bl, 0 in bh
  shl a, 5                      ; multiply by 32
  mov c, a                      ; save in c
  add c, 32
proc_memory_map_l0:
  pagemap
  add b, $0800                  ; increase page number (msb 5 bits of bh only)
  add a, 1                      ; increase both 
  cmp a, c                      ; check to see if we reached the end of memory
  jne proc_memory_map_l0
  ret
  

;----------------------------------------------------------------------------------------------------;
; terminate process
;----------------------------------------------------------------------------------------------------;
syscall_terminate_proc:
  add sp, 5                            ; clear stack of the values that were pushed by the interrupt (sp, status, pc)
                                       ; since they will not be used for anything here.
  mov al, [active_proc_index]
  mov ah, 0  
  shl a, 5                             ; x32
  add a, proc_names
  mov d, a
  mov al, 0
  mov [d], al                           ; nullify process name

  mov al, [active_proc_index]
  mov ah, 0  
  mov d, a
  mov al, 0
  mov [d + proc_availab_table], al    ; make process empty again
  
  mov al, [nbr_active_procs]          ; decrease nbr of active processes
  dec al
  mov [nbr_active_procs], al

; now load the shell process again
  mov al, 2                           ; next process = process 2 = shell
  mov [active_proc_index], al         ; set next active proc

; calculate lut entry for next process
  mov ah, 0
  shl a                               ; x2
  mov a, [proc_table_convert + a]     ; get process state start index  
  
  mov si, a                           ; source is proc state block
  mov a, sp
  sub a, 19
  mov di, a                           ; destination is kernel stack
; restore sp
  dec a
  mov sp, a
  mov c, 20
  rep movsb
; set vm process
  mov al, [active_proc_index]
  setptb
    
  popa
  sysret

;----------------------------------------------------------------------------------------------------;
; pause process
;----------------------------------------------------------------------------------------------------;
syscall_pause_proc:
; save all registers into kernel stack
  pusha
  mov ah, 0
  mov al, [active_proc_index]
  shl a              ; x2
  mov a, [proc_table_convert + a]   ; get process state start index
    
  mov di, a
  mov a, sp
  inc a
  mov si, a
  mov c, 20
  rep movsb                         ; save process state!
; restore kernel stack position to point before interrupt arrived
  add sp, 20
; now load the shell process again
  mov al, 2                         ; next process = process 2 = shell
  mov [active_proc_index], al       ; set next active proc

; calculate lut entry for next process
  mov ah, 0
  shl a                             ; x2
  mov a, [proc_table_convert + a]   ; get process state start index  
  
  mov si, a                         ; source is proc state block
  mov a, sp
  sub a, 19
  mov di, a                         ; destination is kernel stack
; restore sp
  dec a
  mov sp, a
  mov c, 20
  rep movsb
; set vm process
  mov al, [active_proc_index]
  setptb
    
  popa
  sysret

;----------------------------------------------------------------------------------------------------;
; create a new process
; d = path of the process file to be createed
; b = arguments ptr
;----------------------------------------------------------------------------------------------------;
syscall_create_proc:
; we save the active process first  
  pusha
  mov ah, 0
  mov al, [active_proc_index]
  shl a              ; x2
  mov a, [proc_table_convert + a]    ; get process state table's start index
  
  mov di, a
  mov a, sp
  inc a
  mov si, a
  mov c, 20
  rep movsb                          ; save process state!
; restore kernel stack position to point before interrupt arrived
  add sp, 20
  
  mov si, d                          ; copy the file path
  mov di, user_data
  mov c, 512
  load
  mov a, b
  mov si, a                          ; copy the arguments
  mov di, scrap_sector
  mov c, 512
  load
  call loadfile_from_path            ; load the process file from disk by path (path is in user_data)
                                     ; the file data is loaded into transient_area
; now we allocate a new process  
  call find_free_proc                ; index in a
  setptb 
  call proc_memory_map               ; map process memory pages
; copy arguments into process's memory
  mov si, scrap_sector
  mov di, 0
  mov c, 512
  store
; now copy process binary data into process's memory
  mov si, transient_area
  mov di, text_org                   ; code origin address for all user processes
  mov c, fs_file_size                ; size of memory space to copy, which is equal to the max file size in disk (for now)
  store                              ; copy process data
    
  call find_free_proc                ; index in a
  mov [active_proc_index], al        ; set new active process
  shl a, 5                           ; x32
  add a, proc_names
  mov di, a
  mov si, user_data                  ; copy and store process filename
  call _strcpy
  
  call find_free_proc                ; index in a
  mov d, a
  mov al, 1
  mov [d + proc_availab_table], al   ; make process busy
  
  mov al, [nbr_active_procs]         ; increase nbr of active processes
  inc al
  mov [nbr_active_procs], al
; launch process
  push word $ffff 
  push byte %00001110                ; dma_ack = 0, interrupts enabled = 1, mode = user, paging = on, halt=0, display_reg_load=0, dir=0
  push word text_org
  sysret

proc_table_convert:
  .dw proc_state_table + 0
  .dw proc_state_table + 20
  .dw proc_state_table + 40
  .dw proc_state_table + 60
  .dw proc_state_table + 80
  .dw proc_state_table + 100
  .dw proc_state_table + 120
  .dw proc_state_table + 140
  
;----------------------------------------------------------------------------------------------;
; get hex file
; di = destination address
; return length in bytes in c
;----------------------------------------------------------------------------------------------;
_load_hex:
  push a
  push b
  push d
  push si
  push di
  mov c, 0
  mov a, di
  mov d, a          ; start of string data block
  call _gets        ; get program string
  mov si, a
__load_hex_loop:
  lodsb             ; load from [si] to al
  cmp al, 0         ; check if ascii 0
  jz __load_hex_ret
  mov bh, al
  lodsb
  mov bl, al
  call _atoi        ; convert ascii byte in b to int (to al)
  stosb             ; store al to [di]
  inc c
  jmp __load_hex_loop
__load_hex_ret:
  pop di
  pop si
  pop d
  pop b
  pop a
  ret

; synopsis: look inside a certain directory for files/directories
; before calling this function, cd into required directory
; for each entry inside directory:
;  if entry is a file:
;    compare filename to searched filename
;    if filenames are the same, print filename
;  else if entry is a directory:
;    cd to the given directory
;    recursively call cmd_find
;    cd outside previous directory
;  if current entry == last entry, return
; endfor
f_find:
  ret


; ---------------------------------------------------------------------
; kernel reset vector
; ---------------------------------------------------------------------
kernel_reset_vector:  
  mov bp, _stack_begin
  mov sp, _stack_begin
  
  mov al, %10100001             ; mask out timer interrupt for now - enable uarts and fdc irqs 
  stomsk                        
  sti  

  lodstat
  and al, %11011111             ; disable display register loading
  stostat
  
; reset fifo pointers
  mov a, fifo
  mov d, fifo_in
  mov [d], a
  mov d, fifo_out
  mov [d], a  
  mov al, 2
  syscall sys_io                ; enable uart in interrupt mode

  mov d, s_kernel_welcome
  call _puts

  mov d, s_fdc_config
  call _puts
  mov byte [_fdc_config], %00001101  ; %00001001 : turn led on / head load, disable double density, select side 0, select drive 0, do not select drive 1
  mov byte [_fdc_stat_cmd], %00001011     ; leave this restore command in order to clear BUSY flag
  mov byte [_fdc_track], $00 ; reset track

  mov al, 16
  syscall sys_filesystem        ; set root dirid

  mov d, s_prompt_init
  call _puts
  mov d, s_init_path
  syscall sys_create_proc       ; launch init as a new process

; file includes
.include "bios.exp"         ; to obtain the bios_reset_vector location (for reboots)
.include "lib/stdio.asm"
.include "lib/ctype.asm"
.include "lib/token.asm"

; kernel parameters
sys_debug_mode:
  .db 0   ; debug modes: 0=normal mode, 1=debug mode
sys_echo_on:
  .db 1
sys_uart0_lcr:
  .db %00001111 ; 8 data bits, 2 stop bits, enable parity, odd parity
sys_uart0_inten:
  .db 1
sys_uart0_fifoen:
  .db 0
sys_uart0_div0:
  .db 3
sys_uart0_div1:
  .db 0   ; default baud = 38400
; baud  divisor
; 50    2304
; 110   1047
; 300    384
; 600    192
; 1200    96
; 9600    12
; 19200    6
; 38400    3
sys_uart1_lcr:
  .db %00001111 ; 8 data bits, 2 stop bits, enable parity, odd parity
sys_uart1_inten:
  .db 1
sys_uart1_fifoen:
  .db 0
sys_uart1_div0:
  .db 3
sys_uart1_div1:
  .db 0   ; default baud = 38400

nbr_active_procs:
  .db 0
active_proc_index:
  .db 1

index:
  .dw 0
buffer_addr:
  .dw 0

fifo_in:
  .dw fifo
fifo_out:
  .dw fifo

; file system variables
current_dir_id:
  .dw 0     ; keep dirid of current directory
s_init_path:
  .db "/sbin/init", 0

s_uname:
  .db "solarium v.1.0", 0
s_dataentry:
  .db "> ", 0
s_parent_dir:
  .db "..", 0
s_current_dir:
  .db ".", 0
s_fslash:
  .db "/", 0
file_attrib:
  .db "-rw x"      ; chars at powers of 2
file_type:
  .db "-dc"
s_ps_header:
  .db "pid command\n", 0
s_ls_total:
  .db "total: ", 0

s_int_en:
  .db "irqs enabled\n", 0
s_kernel_welcome:
  .db "************************************************\n"
  .db "*** Welcome to Solarium OS - Kernel ver. 1.0 ***\n"
  .db "*** type help for more information           ***\n"
  .db "************************************************\n"
s_prompt_init:
  .db "starting init\n", 0
s_priviledge:
  .db "\nexception: privilege\n", 0
s_divzero:
  .db "\nexception: zero division\n", 0

s_set_year:
  .db "year: ", 0
s_set_month:
  .db "month: ", 0
s_set_day:
  .db "day: ", 0
s_set_week:
  .db "weekday: ", 0
s_set_hours:
  .db "hours: ", 0
s_set_minutes:
  .db "minutes: ", 0
s_set_seconds:
  .db "seconds: ", 0
s_months:      
  .db "   ", 0
  .db "jan", 0
  .db "feb", 0
  .db "mar", 0
  .db "apr", 0
  .db "may", 0
  .db "jun", 0
  .db "jul", 0
  .db "aug", 0
  .db "sep", 0
  .db "oct", 0
  .db "nov", 0
  .db "dec", 0

s_week:        
  .db "sun", 0 
  .db "mon", 0 
  .db "tue", 0 
  .db "wed", 0 
  .db "thu", 0 
  .db "fri", 0 
  .db "sat", 0

s_fdc_irq: .db "\nIRQ0 Executed.\n", 0
s_fdc_config:
  .db "selecting diskette drive 0, side 0, single density, head loaded\n", 0

proc_state_table:   
  .fill 16 * 20, 0  ; for 15 processes max
proc_availab_table: 
  .fill 16, 0       ; space for 15 processes. 0 = process empty, 1 = process taken
proc_names:
  .fill 16 * 32, 0  ; process names
filename:
  .fill 128, 0      ; holds a path for file search
user_data:
  .fill 512, 0      ;  user space data
fifo:
  .fill _fifo_size

scrap_sector:
  .fill 512         ; scrap sector
transient_area:
  .db 0             ; beginning of the transient memory area. used for disk reads and other purposes    

.end
