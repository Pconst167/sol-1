
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
	call get_token
	cmp byte[toktyp], TOKTYP_IDENTIFIER
	jne cmd_end
; execute rm command
	mov d, tokstr
	mov al, 10
	syscall sys_filesystem

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; CREATE NEW BINARY FILE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; search for first null block
cmd_mkbin:
	mov a, 0
	mov [prog], a
	call get_token
	mov d, s_prompt
	call _puts
	mov d, tokstr
	mov al, 6
	syscall sys_filesystem
	syscall sys_terminate_proc

cmd_end:
	call _putback		; if token was not an identifier, then put it back
	syscall sys_terminate_proc

s_prompt: .db "% ", 0
.include "lib/token.asm"
.include "lib/stdio.asm"
.include "lib/ctype.asm"

.end


