.include "lib/kernel.exp"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; cat /etc/sh.conf
;; cat > test.txt
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.org text_org			; origin at 1024

cmd_cat:
	mov a, 0
	mov [prog], a			; move tokennizer pointer to the beginning of the arguments area (address 0)
	call get_token

	cmp byte[tok], TOK_ANGLE
	je cmd_cat_write
cmd_cat_read:
	call _putback
	call get_path
	mov d, tokstr
	mov di, transient_area
	mov al, 20
	syscall sys_filesystem				; read textfile into shell buffer
	mov d, transient_area
	call _puts					; print textfile to stdout
	call get_token
	mov al, [tok]
	cmp al, TOK_END
	jne cmd_cat_read
	syscall sys_terminate_proc
cmd_cat_write:
	call get_token
	mov si, tokstr
	mov di, transient_area + 1
	call _strcpy				; copy filename
	mov d, transient_area + 512		; get text contents
	call _gettxt
	mov d, transient_area
	mov al, 5
	syscall sys_filesystem
	syscall sys_terminate_proc


.include "lib/token.asm"
.include "lib/stdio.asm"
.include "lib/ctype.asm"


transient_area:	

.end


