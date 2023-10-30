.include "lib/kernel.exp"

.org text_org			; origin at 1024

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; mv - move / change file name
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
cmd_mv:
	mov a, 0
	mov [prog], a
	call get_token
	mov si, tokstr
	mov di, transient_data
	call _strcpy
	
	call get_token
	mov si, tokstr
	mov di, transient_data + 128
	call _strcpy

	mov d, transient_data
	mov al, 15	; mv command
	syscall sys_filesystem
	
	syscall sys_terminate_proc


.include "lib/token.asm"
.include "lib/stdio.asm"
.include "lib/ctype.asm"


transient_data: .dw 0

.end


