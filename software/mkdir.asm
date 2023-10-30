.include "lib/kernel.exp"

.org text_org			; origin at 1024

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; CREATE NEW DIRECTORY
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; search list for NULL name entry.
; add new directory to list
cmd_mkdir:
	mov a, 0
	mov [prog], a
cmd_mkdir_L0:
	call get_token
	cmp byte[toktyp], TOKTYP_IDENTIFIER
	jne cmd_mkdir_end
; execute mkdir command
	mov d, tokstr
	mov al, 2
	syscall sys_filesystem
	jmp cmd_mkdir_L0
cmd_mkdir_end:
	call _putback		; if token was not an identifier, then put it back

	syscall sys_terminate_proc


.include "lib/token.asm"
.include "lib/stdio.asm"
.include "lib/ctype.asm"

.end


