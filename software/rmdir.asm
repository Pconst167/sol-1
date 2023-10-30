.include "lib/kernel.exp"

.org text_org			; origin at 1024

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; RMDIR - remove DIR
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; deletes directory entry in the current directory's file list 
; also deletes the actual directory entry in the FST
; rmdir /my/first/dir /my/second/dir
; rmdir /ends/with/semi;
; rmdir ends/with/null
cmd_rmdir:
	mov a, 0
	mov [prog], a
cmd_rmdir_L0:
	call get_token
	mov al, [tok]
	cmp al, TOK_END
	je cmd_rmdir_end
	cmp al, TOK_SEMI
	je cmd_rmdir_end
	call _putback
	call get_path		; get path string in tokstr
	mov d, tokstr
	mov al, 19
	syscall sys_filesystem	; get dirID in A
	mov b, a
	mov al, 9
	syscall sys_filesystem	; rmdir syscall
	jmp cmd_rmdir_L0
cmd_rmdir_end:
	call _putback		; if token was not an identifier, then put it back

	syscall sys_terminate_proc


.include "lib/token.asm"
.include "lib/stdio.asm"
.include "lib/ctype.asm"

.end


