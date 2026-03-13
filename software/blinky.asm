.include "lib/kernel.exp"

.org text_org			; origin at 1024

cowsay:
	mov d, 0

l0:
	mov al, [d]
	inc d
	push d

	mov bl, al
  mov al, 2
  mov d, _7seg_display
  syscall sys_system
	pop d

	call wait
	jmp l0

wait:
	mov c, 65535
l1:
	dec c
	jnz l1
	ret


.end


