.include "lib/kernel.exp"
.org text_org

main:
  mov bp, $FFFF
  mov sp, $FFFF

  mov d, s_color
  call _puts

  mov d, s_test
  call _puts


  syscall sys_terminate_proc


s_test: .db "\nHello World\n",0
s_color:  .db "\033[32m", 0
.include "lib/stdio.asm"
.end
