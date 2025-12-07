.include "lib/kernel.exp"


main:
	mov a, 0
main_L0:
	syscall sys_break
	inc a
	cmp a, $20
	je end
	jmp main_L0
end:
	ret

.include "lib/stdio.asm"



.end
