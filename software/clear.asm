.include "lib/kernel.exp"

.org text_org			; origin at 1024

cmd_clear:
	mov d, s_telnet_clear
	call _puts

	syscall sys_terminate_proc

.include "lib/token.asm"
.include "lib/stdio.asm"
.include "lib/ctype.asm"

.end



