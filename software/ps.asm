.include "lib/kernel.exp"

.org text_org			; origin at 1024

cmd_ps:
	syscall sys_list_proc

	syscall sys_terminate_proc


.include "lib/token.asm"
.include "lib/stdio.asm"
.include "lib/ctype.asm"

.end


