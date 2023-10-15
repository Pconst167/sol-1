#pragma org "boot_origin"
#include "lib/stdio.h"

void main(){
  printf("executing bootloader...\n\r");
  asm{
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; SYSTEM CONSTANTS / EQUATIONS
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    _UART0_DATA      .equ $FF80            ; data
    _UART0_DLAB_0    .equ $FF80            ; divisor latch low byte
    _UART0_DLAB_1    .equ $FF81            ; divisor latch high byte
    _UART0_IER       .equ $FF81            ; Interrupt enable register
    _UART0_FCR       .equ $FF82            ; FIFO control register
    _UART0_LCR       .equ $FF83            ; line control register
    _UART0_LSR       .equ $FF85            ; line status register

    _IDE_BASE        .equ $FFD0            ; IDE BASE
    _IDE_R0          .equ _IDE_BASE + 0    ; DATA PORT
    _IDE_R1          .equ _IDE_BASE + 1    ; READ: ERROR CODE, WRITE: FEATURE
    _IDE_R2          .equ _IDE_BASE + 2    ; NUMBER OF SECTORS TO TRANSFER
    _IDE_R3          .equ _IDE_BASE + 3    ; SECTOR ADDRESS LBA 0 [0:7]
    _IDE_R4          .equ _IDE_BASE + 4    ; SECTOR ADDRESS LBA 1 [8:15]
    _IDE_R5          .equ _IDE_BASE + 5    ; SECTOR ADDRESS LBA 2 [16:23]
    _IDE_R6          .equ _IDE_BASE + 6    ; SECTOR ADDRESS LBA 3 [24:27 (LSB)]
    _IDE_R7          .equ _IDE_BASE + 7    ; READ: STATUS, WRITE: COMMAND

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; Setting up kernel process.
    ; map kernel memory to BIOS 64KB
    ; 32 pages of 2KB = 64KB
    ; bl = ptb
    ; bh = page number (5bits)
    ; a = physical address
    ; for kernel, a goes from 0 to 31, but for the last page, bit "11" must be 1 for DEVICE space
    ; bl = 0
    ; bh(ms 5 bits) = 0 to 31
    ; a = 0000_1000_000_00000
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    setup_kernel_mem:
  }

  printf("mapping kernel pagetable to physical ram.\n\r");

  asm{
    ; map pages 0 to 30 to normal kernel ram memory.
      mov bl, 0             ; set PTB = 0 for kernel
      mov bh, 0             ; start at PAGE 0
      mov a, 0              ; set MEM/IO bit to MEMORY, for physical address. this means physical address starting at 0, but in MEMORY space
    map_kernel_mem_L1:
      pagemap               ; write page table entry
      add b, $0800          ; increase page number (msb 5 bits of BH only)
      inc al                ; increase both 
      cmp al, 31            ; check to see if we reached the end of memory for kernel
      jne map_kernel_mem_L1
      
    ; here we map the last page of kernel memory, to DEVICE space, or the last 2KB of BIOS memory
    ; so that the kernel has access to IO devices.
      or a, $0800           ; set MEM/IO bit to DEVICE, for physical address
      pagemap               ; write page table entry
      
      mov al, 0
      setptb                ; set process number to 0 (strictly not needed since we are in Supervisor mode)
                            ; which forces the page number to 0
  }

  printf("loading kernel from disk\n\r");

  asm{
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  
    ; we read sector 0, in order to obtain the LBA location of the kernel in the disk
    ; this kernel LBA is actually the second sector because the first sector is the usual file block
    ; header and has no useful kernel data.
      mov c, 0
      mov b, 0                   ; start at disk sector 1
      mov d, IDE_buffer          ; we read into the bios ide buffer
      mov a, $0102               ; disk read, 1 sector
      syscall bios_ide           ; read sector
      mov a, [IDE_buffer + 510]  ; here we now have the kernels LBA location in disk
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      mov b, a                   ; transfer the sector number into register B for use below
      push a                     ; also, save the LBA value for later
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  
    ; having obtained the first kernel sector address,
    ; we read the first kernel sector, in order to obtain the reset vector at location $10
      mov c, 0
      mov d, IDE_buffer           ; we read into the bios ide buffer
      mov a, $0102                ; disk read, 1 sector
      syscall bios_ide            ; read sector
      mov a, [IDE_buffer + $10]   ; here we now have the kernel RESET VECTOR
      mov g, a                    ; save reset vector in G  
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      
    ; read operating system into kernel memory
      pop b                       ; pop the kernels starting LBA address that we pushed into the stack earlier
                                  ; as we now need to load the kernel from disk, from that LBA address
      mov c, 0
      mov d, IDE_buffer           ; we read into the bios ide buffer
      mov a, $3102                ; disk read, 31 sectors. 31 sectors because the first sector of the kernel is just a file block header
                                  ; used to tell whether that block is taken. so the file really has 31 sectors 
                                  ; in this current file system (which is a hack and is temporary)
      syscall bios_ide            ; read sector
      mov c, 512 * 31             ; 31 sectors to copy
      mov si, IDE_buffer
      mov di, 0                   ; start at kernel memory address 0
      supcpy                      ; now copy data from bios mem to kernel mem

    ; interrupt masks  
      mov al, $FF
      stomsk                      ; store masks
  }
  
  printf("\n\rinterrupt masks register set to 0xFF.\n\r");
  printf("entering protected-mode\n\r");
  printf("starting kernel\n\r");

  asm{
    ; now we start the kernel.
      mov a, g                    ; retrieve kernel reset vector

      push word $FFFF             ; stack. dummy value since the real value is set in the kernel code
      push byte %00001000         ; mode =supervisor, paging=on
      push a                      ; PC
      sysret
  }

}
