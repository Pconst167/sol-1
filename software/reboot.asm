.include "lib/kernel.exp"

.org text_org			; origin at 1024

reboot:
  mov d, s_reboot
  call _puts
  syscall sys_reboot

s_reboot: .db "\n\rNow rebooting...\n\r", 0

.include "lib/stdio.asm"

.end


