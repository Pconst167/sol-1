.include "lib/kernel.exp"

.org text_org			; origin at 1024
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; CHMOD - change file permissions
;; ex: chmod 7 <filename>
;; 1 = exec, 2 = write, 4 = read
;; we only have one digit in Sol-1 for now since we don't have users or groups
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; filename passed to the kernel in D
; permission value in A
cmd_chmod:
	mov a, 0
	mov [prog], a			; move tokennizer pointer to the beginning of the arguments area (address 0)
	call get_token				; read permission value
	mov d, tokstr				; pointer to permission token string
	call _strtoint				; integer in A
	and al, %00000111			; mask out garbage
	mov bl, al					; save permission in bl
	call get_token				; get filename. D already points to tokstr
	mov al, 14
	syscall sys_filesystem			; call kernel to set permission

	syscall sys_terminate_proc


.include "lib/token.asm"
.include "lib/stdio.asm"
.include "lib/ctype.asm"

.end


