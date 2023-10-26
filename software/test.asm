.include "lib/kernel.exp"
.org TEXT_ORG

; --- BEGIN TEXT BLOCK
main:
  mov bp, $FFFF
  mov sp, $FFFF

  call getch

  syscall sys_terminate_proc

.include "lib/stdio.asm"
.end
