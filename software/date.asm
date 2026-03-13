.include "lib/kernel.exp"

.org text_org			; origin at 1024

; ********************************************************************
; DATETIME
; ********************************************************************
date:
	mov a, 0
	mov [prog], a
	call get_token
	mov si, tokstr
	mov di, s_set
	call _strcmp
	je date_set
	mov al, 0			; print datetime
	syscall sys_datetime
	syscall sys_terminate_proc

date_set:
	mov al, 1			; print datetime
	syscall sys_datetime
	syscall sys_terminate_proc

s_set: .db "set", 0

.include "lib/string.asm"
.include "lib/ctype.asm"
.include "lib/token.asm"

.end


