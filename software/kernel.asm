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
_uart0_data             .equ $ff80         ; data
_uart0_dlab_0           .equ $ff80         ; divisor latch low byte
_uart0_dlab_1           .equ $ff81         ; divisor latch high byte
_uart0_ier              .equ $ff81         ; interrupt enable register
_uart0_fcr              .equ $ff82         ; fifo control register
_uart0_lcr              .equ $ff83         ; line control register
_uart0_lsr              .equ $ff85         ; line status register
                      
_uart1_data             .equ $ff88         ; data
_uart1_dlab_0           .equ $ff88         ; divisor latch low byte
_uart1_dlab_1           .equ $ff89         ; divisor latch high byte
_uart1_ier              .equ $ff89         ; interrupt enable register
_uart1_fcr              .equ $ff8A         ; fifo control register
_uart1_lcr              .equ $ff8B         ; line control register
_uart1_lsr              .equ $ff8D         ; line status register
                      
_ide_base               .equ $ffd0         ; ide base
_ide_r0                 .equ _ide_base + 0 ; data port
_ide_r1                 .equ _ide_base + 1 ; read: error code, write: feature
_ide_r2                 .equ _ide_base + 2 ; number of sectors to transfer
_ide_r3                 .equ _ide_base + 3 ; sector address lba 0 [0:7]
_ide_r4                 .equ _ide_base + 4 ; sector address lba 1 [8:15]
_ide_r5                 .equ _ide_base + 5 ; sector address lba 2 [16:23]
_ide_r6                 .equ _ide_base + 6 ; sector address lba 3 [24:27 (lsb)]
_ide_r7                 .equ _ide_base + 7 ; read: status, write: command       
                      
_til311_display         .equ $ffb0         ; bios post code hex display (2 digits) (connected to pio a)
_bios_post_ctrl         .equ $ffb3         ; bios post display control register, 80h = as output
_pio_a                  .equ $ffb0    
_pio_b                  .equ $ffb1
_pio_c                  .equ $ffb2
_pio_control            .equ $ffb3         ; pio control port
                      
_fdc_config             .equ $ffc0         ; 0 = select_0, 1 = select_1, 2 = side_select, 3 = dden, 4 = in_use_or_head_load, 5 = wd1770_rst
_fdc_status_0           .equ $ffc1         ; 0 = drq, 1 = ready
_fdc_stat_cmd           .equ $ffc8         ; status / command register
_fdc_track              .equ $ffc9         ; track register
_fdc_sector             .equ $ffca         ; sector register
_fdc_data               .equ $ffcb         ; data register
                      
_timer_c_0              .equ $ffe0         ; timer counter 0
_timer_c_1              .equ $ffe1         ; timer counter 1
_timer_c_2              .equ $ffe2         ; timer counter 2
_timer_ctrl             .equ $ffe3         ; timer control register
                      
_stack_top              .equ $f7ff         ; beginning of stack
_fifo_size              .equ 4096
_scrap_size             .equ 512

_file_type_null         .equ 0
_file_type_reg          .equ 1
_file_type_chardev      .equ 2
_file_type_blockdev     .equ 3

_num_cpu_regs           .equ 10                                     ; A, B, C, D, G, PC, BP, SP, SI, DI
_num_user_proc          .equ 128                                    ; max number of concurrent user processes
_fd_per_proc            .equ 32                                     ; for kernel's file descriptor table per process
_num_file_objs          .equ 128                                    ; for the kernel's file object table
_size_file_obj_entry    .equ 1 + 2 + 1 + 2 + 2 + (4 * 2)            ; refcount, flags, type, target, offset, ops
_size_file_obj_table    .equ _num_file_objs * _size_file_obj_entry  ; kernel's file object table

_size_proc_entry        .equ 1 + 1 + _fd_per_proc * 2 + 2 + _num_cpu_regs * 2 + 1 + 39 ; pid, state, fd_table, tty pointer, context (general regs + flags), 39 bytes padding to reach 128
_size_proc_table        .equ _size_proc_entry * _num_user_proc  ; 16k total


text_org                .equ $400          ; code origin address for all user processes

block_bitmap_start      .equ 2048 * 2
block_bitmap_sec_start  .equ 8
inode_bitmap_start      .equ 2048 * 6
inode_bitmap_sect_start .equ 24
inode_table_start       .equ 2048 * 7
inode_table_sect_start  .equ 28 ; inode table starts at sector 28
data_blocks_start       .equ 2111488
data_blocks_sect_start  .equ 4124

;  ------------------------------------------------------------------------------------------------------------------;
;  DISK LAYOUT:
;  Metadata               | Size (bytes)      | Blocks (2048 bytes)              |Start Block |  Comment
;  ---------------------- | ----------------- | -------------------------------- |------------|-----------------------------------
;  Bootloader/MBR         | 1024 bytes        | 0.5 (1 sector)                   |  0         |
;  Superblock             | 1024 bytes        | 1 block (2048 bytes, must align) |  0         |
;                         |                   | 1 block (2048 bytes)             |  1         | reserved
;  Block Bitmap           | 8,192 bytes       | 4 blocks                         |  2         | 4*2048*8 = 4*16384 = 65536 raw data blocks.  65536*2048 bytes = 134217728 bytes of disk space = 128MB
;  Inode Bitmap           | 2,048 bytes       | 1 block                          |  6         | 2048*8=16384. total of 16384 bits, meaning 16384 inodes, which is 1 inode per 8KB of disk space
;  Inode Table            | 2,097,152 bytes   | 1024 blocks                      |  7         | 128bytes per inode entry. 2097152 / 128 = 16384 inodes
;  Data Blocks            | 134,217,728 bytes | 65528 blocks                     | 1031       | 65528 blocks = 134,201,344 bytes
;  
;  first 1024 bytes: bootloader from 0 to 959, MBR partition table from 960 (64 bytes)
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
.dw syscall_file
.dw syscall_datetime
.dw syscall_reboot
.dw syscall_system
.dw syscall_proc

; ------------------------------------------------------------------------------------------------------------------;
; system call aliases
; ------------------------------------------------------------------------------------------------------------------;
sys_break            .equ 0
sys_rtc              .equ 1
sys_ide              .equ 2
sys_io               .equ 3
sys_file             .equ 4
sys_datetime         .equ 5
sys_reboot           .equ 6
sys_system           .equ 7
sys_proc             .equ 8

; ------------------------------------------------------------------------------------------------------------------;
; alias exports
; ------------------------------------------------------------------------------------------------------------------;
.export text_org
.export sys_break
.export sys_rtc
.export sys_ide
.export sys_io
.export sys_file
.export sys_datetime
.export sys_reboot
.export sys_system

.export _til311_display

.export _fdc_config        
.export _fdc_status_0      
.export _fdc_stat_cmd     

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

sys_mkfs:
  sysret

; ------------------------------------------------------------------------------------------------------------------;
; process syscalls
; ------------------------------------------------------------------------------------------------------------------;
proc_jmptbl:
  .dw proc_creat
syscall_proc:
  jmp [proc_jmptbl + al]

proc_creat:
  sysret

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


; ------------------------------------------------------------------------------------------------------------------;
; exceptions code block
; ------------------------------------------------------------------------------------------------------------------;
; privilege exception
; ------------------------------------------------------------------------------------------------------------------;
trap_privilege:
  push d
  mov d, s_priviledge
  call _puts
  pop d
  jmp syscall_reboot

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
  mov [_uart0_lcr], al      ; 8 data, 2 stop, even parity 
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
  mov [_uart1_lcr], al      ; 8 data, 2 stop, even parity 
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
  test al, $20
  jz syscall_io_putchar_l0    
  mov al, ah
  mov [_uart0_data], al        ; write char to transmitter holding register
; uart1
syscall_io_putchar_l1:
  mov al, [_uart1_lsr]         ; read line status register
  test al, $20
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
; first directory on disk is the root directory '/'
file_system_jmptbl:
  .dw fs_cd                     
  .dw fs_ls                     
  .dw fs_pwd                    
  .dw fs_rmdir                  
  .dw fs_mkdir
  .dw fs_rm                     
  .dw fs_mv                     

syscall_file:
  jmp [file_system_jmptbl + al]

;------------------------------------------------------------------------------------------------------;
; create new directory
;------------------------------------------------------------------------------------------------------;
; search list for null name entry. add new directory to list
fs_mkdir:
  sysret

;------------------------------------------------------------------------------------------------------;
; cd
;------------------------------------------------------------------------------------------------------;
fs_cd:
  sysret  

;------------------------------------------------------------------------------------------------------;
; ls
;------------------------------------------------------------------------------------------------------;
; inode in a
fs_ls:
  mov d, inode_table_sect_start

  sysret

;------------------------------------------------------------------------------------------------------;
; pwd - print working directory
;------------------------------------------------------------------------------------------------------;    
fs_pwd:
  sysret

;------------------------------------------------------------------------------------------------------;
; rmdir - remove dir by dirid
;------------------------------------------------------------------------------------------------------;
fs_rmdir:
  sysret

;------------------------------------------------------------------------------------------------------;
; rm - remove file
;------------------------------------------------------------------------------------------------------;
fs_rm:
  sysret  

;------------------------------------------------------------------------------------------------------;
; mv - move / change file name
;------------------------------------------------------------------------------------------------------;
fs_mv:
  sysret


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

; ---------------------------------------------------------------------
; kernel reset vector
; ---------------------------------------------------------------------
kernel_reset_vector:  
  mov bp, _stack_top
  mov sp, _stack_top
  
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

  mov al, %10100000             ; uart0 | timer | uart1 | 0 | 0 | 0 | 0| fdc
  stomsk                        
  sti  

  mov d, s_kernel_welcome
  call _puts

  mov d, s_fdc_config
  call _puts

  mov byte [_fdc_config], %00001101   ; %00001001 : turn led on / head load, disable double density, select side 0, select drive 0, do not select drive 1
  mov byte [_fdc_stat_cmd], %00001011 ; leave this restore command in order to clear BUSY flag
  mov byte [_fdc_track], $00          ; reset track


  mov a, 0
ker_loop:
  inc a
  mov [_til311_display], al
  jmp ker_loop


; file includes
.include "lib/bios.exp"         ; to obtain the bios_reset_vector location (for reboots)
.include "lib/stdio.asm"
.include "lib/ctype.asm"
.include "lib/token.asm"


; kernel parameters
; baud  divisor
; 50    2304
; 110   1047
; 300    384
; 600    192
; 1200    96
; 9600    12
; 19200    6
; 38400    3
sys_uart0_lcr:
  .db %00001111 ; 8 data bits, 2 stop bits, enable parity, even parity
sys_uart0_inten:
  .db 1
sys_uart0_fifoen:
  .db 0
sys_uart0_div0:
  .db 3
sys_uart0_div1:
  .db 0   ; default baud = 38400

sys_uart1_lcr:
  .db %00001111 ; 8 data bits, 2 stop bits, enable parity, even parity
sys_uart1_inten:
  .db 1
sys_uart1_fifoen:
  .db 0
sys_uart1_div0:
  .db 3
sys_uart1_div1:
  .db 0   ; default baud = 38400

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
  .db "************************************************\n", 0
s_prompt_init:
  .db "starting init\n", 0
s_priviledge:
  .db "\nexception: privilege\n", 0
s_divzero:
  .db "\nexception: zero division\n", 0

s_break1:  
  .db "\ndebugger entry point.\n"
  .db "0. show registers\n"
  .db "1. show 512b ram block\n"
  .db "2. continue execution", 0

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
  .db "floppy drive configuration:\n" 
  .db "  drive:     0\n"
  .db "  side:      0\n"
  .db "  density:   single density\n"
  .db "  head load: loaded\n", 0


file_obj_table: .equ $
proc_table:     .equ $ + _size_file_obj_table

; here we define areas that keep transient data
; we use '$' which is the assembler's current address pointer so that these areas are defined to be exactly
; after all the static data has been declared
fifo:           .equ $ + _size_file_obj_table + _size_proc_table
scrap_sector:   .equ $ + _size_file_obj_table + _size_proc_table + _fifo_size
transient_area: .equ $ + _size_file_obj_table + _size_proc_table + _fifo_size + _scrap_size



.end
