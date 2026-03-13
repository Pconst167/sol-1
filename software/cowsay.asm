.include "lib/kernel.exp"

.org text_org			; origin at 1024

cowsay:
	call printnl
	mov a, 0
	mov [prog], a			; move tokennizer pointer to the beginning of the arguments area (address 0)
	call get_arg			; read argument line
	mov d, tokstr
	call _puts
	call printnl
	mov d, cow
	call _puts
	syscall sys_terminate_proc

cow: .db "    \\  ^__^\n"
     .db "     \\ (oo)\\_______\n"
     .db "       (__)\\       )\\/\\\n"
     .db "           ||----w |\n"
     .db "           ||     ||\n\n", 0

.include "lib/token.asm"
.include "lib/stdio.asm"
.include "lib/ctype.asm"

.end


