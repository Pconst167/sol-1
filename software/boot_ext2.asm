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

inode_table_start .equ 2048 * 7
inode_table_sect_start .equ 28 ; inode table starts at sector 28

;  ------------------------------------------------------------------------------------------------------------------;
;  DISK LAYOUT:
;  Metadata               | Size (bytes)      | Blocks (2048 bytes)              |Start Block |  Comment
;  ---------------------- | ----------------- | -------------------------------- |------------|-----------------------------------
;  Bootloader/MBR         | 1024 bytes        | 0.5 (2 sectors)                  |  0         |
;  Superblock             | 1024 bytes        | 1 block (2048 bytes, must align) |  0         |
;                         |                   | 1 block (2048 bytes)             |  1         | reserved
;  Block Bitmap           | 8,192 bytes       | 4 blocks                         |  2         | 4*2048*8 = 4*16384 = 65536 raw data blocks.  65536*2048 bytes = 134217728 bytes of disk space = 128MB
;  Inode Bitmap           | 2,048 bytes       | 1 block                          |  6         | 2048*8=16384. total of 16384 bits, meaning 16384 inodes, which is 1 inode per 8KB of disk space
;  Inode Table            | 2,097,152 bytes   | 1024 blocks                      |  7         | 128bytes per inode entry. 2097152 / 128 = 16384 inodes
;  Data Blocks            | 134,217,728 bytes | 65528 blocks                     | 1031       | 65528 blocks = 134,201,344 bytes
;  
;  first 960 bytes: bootloader from 0 to 959, MBR partition table from 960 to 1023 (64 bytes)
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
;  | inode_table         | Block ID of **inode table**               | 2                    | 16-bit unsigned int
;  | first_data_block    | Block ID of the data blocks area          | 2                    | 16-bit unsigned int             |
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

boot_start:

  mov a, [boot_origin + 1022] ; get kernel inode number from bootloader chunk in ram
  mov [kernel_inode], a       ; and save in variable

  call get_ino_entry_sect_ofst ; sector in a, remainder in bl
  add a, inode_table_sect_start  ; add start lba of inode table
  push bl                        ; save entry offset
  mov b, a
  mov c, 0
  mov d, ide_buffer    ; we read into the ide buffer
  mov a, $0102        ; disk read, 1 sector
  syscall bios_ide      ; read sector 

  mov d, ide_buffer
  pop bl
  mov bh, 0
  shl b, 7          ; multiply the offset integer by 128
  add d, b          ; inode entry plus entry offset: points at kernel inode entry
  push d

  mov d, s_filesize
  call __puts
  pop d
  mov a, [d + 4]
  call __print_u16d


; interrupt masks  
  mov al, $ff
  stomsk                      ; store masks
  mov d, s_masks
  call __puts
  
  mov d, s_bios2
  call __puts

; now we start the kernel.
  mov a, g                    ; retrieve kernel reset vector

  push word $ffff             ; stack. dummy value since the real value is set in the kernel code
  push byte %00001000         ; mode =supervisor, paging=on
  push a                      ; pc
  sysret

; inputs:
; a: inode number
; outputs:
; bl: offset/remainder
; a: sector
get_ino_entry_sect_ofst:
  push a                       ; save inode in stack
  and al, %00000011            ; he least 2 bits are the remainder mod 128
  mov bl, al
  pop a
  shr a, 2                     ; shifting right by 2, gives the multiple of 512 which represents the sector number
  ret

kernel_inode: .dw 0

s_boot1:         .db "executing bootloader\n", 0
s_kernel_setup:  .db "mapping kernel page-table to physical RAM\n", 0
s_masks:         .db "\n\rinterrupt masks register set to 0xFF\n", 0
s_boot:          .db "loading kernel from disk", 0
s_bios2:         .db "entering protected-mode\n"
                 .db "starting kernel\n", 0

s_hex_digits:   .db "0123456789ABCDEF"

s_read_super:       .db "\nreading superblock\n", 0
s_total_inodes:     .db "\ntotal inodes: ", 0
s_total_blocks:     .db "\ntotal blocks: ", 0
s_free_inodes:      .db "\nfree inodes: ", 0
s_free_blocks:      .db "\nfree blocks: ", 0
s_block_bitmap:     .db "\nblock bitmap: ", 0
s_inode_bitmap:     .db "\ninode bitmap: ", 0
s_inode_table:      .db "\ninode table: ", 0
s_first_data_block: .db "\nfirst data block: ", 0
s_used_dirs:        .db "\nnumber of used directories: ", 0
s_uuid:             .db "\nuuid: ", 0
s_vol_name:         .db "\nvolume name: ", 0

s_nl: .db "\n", 0
s_filesize: .db "file size: ", 0
s_blocks: .db "number of blocks: ", 0
s_block: .db "block links: ", 0

inode_entry_offset: .db 0
inode_entry_sect:   .dw 0



.end
