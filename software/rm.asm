.include "lib/kernel.exp"

.org text_org			; origin at 1024

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; RM - remove file
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; frees up the data sectors for the file further down the disk
; deletes file entry in the current directory's file list 
cmd_rm:	
	mov a, 0
	mov [prog], a
cmd_rm_L0:
	call get_token
	cmp byte[toktyp], TOKTYP_IDENTIFIER
	jne cmd_rm_end
; execute rm command
	mov d, tokstr
	mov al, 10
	syscall sys_filesystem
	jmp cmd_rm_L0
cmd_rm_end:
	call _putback		; if token was not an identifier, then put it back

	syscall sys_terminate_proc


.include "lib/token.asm"
.include "lib/stdio.asm"
.include "lib/ctype.asm"

.end


