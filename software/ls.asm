.include "lib/kernel.exp"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ls /usr/bin
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.org text_org			; origin at 1024

cmd_ls:
	mov a, 0
	mov [prog], a			; move tokennizer pointer to the beginning of the arguments area (address 0)
	call get_token
	mov al, [tok]
	cmp al, tok_end
	je cmd_ls_current
cmd_ls_arg_given:
	call _putback
	call get_path
	mov d, tokstr
	mov al, 19
	syscall sys_filesystem	; get dirid in a
	mov b, a
	mov al, 4
	syscall sys_filesystem
	syscall sys_terminate_proc
cmd_ls_current:
	mov al, 17
	syscall sys_filesystem		; get current dirid in b
	mov al, 4
	syscall sys_filesystem

	syscall sys_terminate_proc


.include "lib/token.asm"
.include "lib/stdio.asm"
.include "lib/ctype.asm"

.end



