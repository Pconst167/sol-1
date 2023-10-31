.include "lib/kernel.exp"
.org text_org

; --- BEGIN TEXT BLOCK
main:
  mov bp, $FFFF
  mov sp, $FFFF

  call printnl
  mov a, $FFFF
  mov b, a

  call print_u16x
  and a, $0000

  mov b, a
  call print_u16x

  call printnl


  mov a, $FFFF
  and al, $00
  mov b, a
  call print_u16x

  call printnl



  syscall sys_terminate_proc

.include "lib/stdio.asm"
.end
