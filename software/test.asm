.include "lib/kernel.exp"
.org text_org

; --- BEGIN TEXT BLOCK
main:
  mov bp, $FFFF
  mov sp, $FFFF

  call getch

  syscall sys_terminate_proc

.include "lib/stdio.asm"
.end
