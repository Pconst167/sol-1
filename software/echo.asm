.include "lib/kernel.exp"

.org text_org			; origin at 1024

cmd_echo:
	mov a, 0
	mov [prog], a			; move tokennizer pointer to the beginning of the arguments area (address 0)
	call get_arg			; read argument line
	mov d, tokstr
	call _puts
	call printnl
	syscall sys_terminate_proc


.include "lib/token.asm"
.include "lib/stdio.asm"
.include "lib/ctype.asm"

.end


