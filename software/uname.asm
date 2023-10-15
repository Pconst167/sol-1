.include "lib/kernel.exp"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; uname
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.org TEXT_ORG			; origin at 1024

cmd_ls:
	mov al, 0
	syscall sys_system
	syscall sys_terminate_proc


.include "lib/stdio.asm"
.include "lib/ctype.asm"

.end



