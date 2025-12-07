.include "lib/kernel.exp"

.org text_org			; origin at 1024

TRUE:	.equ 1
FALSE:	.equ 0
SIZE:	.equ 8190
SIZEP1:	.equ 8191

main:
	mov d, s_title
	call _puts

	mov a, 1
	mov [iter], a
L0:
	cla
	mov [count], a
	mov [i], a
L0_0:
	mov a, [i]
	mov d, a
	mov al, TRUE
	mov [d + flags], al
	mov a, [i]
	inc a
	mov [i], a
	cmp a, SIZE
	jleu L0_0	

	mov a, 0
	mov [i], a
L0_1:
	mov a, [i]
	mov d, a
	mov al, [d + flags]
	cmp al, TRUE
	je IF_0_TRUE
L0_1_COND:	
	mov a, [i]
	inc a
	mov [i], a
	cmp a, SIZE
	jleu L0_1	
L0_COND:
	mov a, [iter]
	inc a
	mov [iter], a
	cmp a, 10
	jleu L0
	jmp L0_EXIT
IF_0_TRUE:
	mov b, [i]
	mov a, [i]
	add a, b
	add a, 3
	mov [prime], a		; prime = i + i + 3
	add a, b
	mov [k], a			; k = i + prime	
WHILE:
	mov a, [k]
	mov b, SIZE
	cmp a, b
	jgu WHILE_EXIT
	mov a, [k]
	mov d, a
	mov al, FALSE
	mov [d + flags], al
	mov a, [k]
	mov b, [prime]
	add a, b
	mov [k], a
	jmp WHILE
WHILE_EXIT:	
	mov a, [count]
	inc a
	mov [count], a	
	jmp L0_1_COND

L0_EXIT:
	mov a, [count]
	call print_u16d
	mov d, s_result
	call _puts

	syscall sys_terminate_proc

s_title:	.db "-----------------------------------------------\n"
			.db "Byte Magazine\'s Sieve of Erastothenes Benchmark\n"
			.db "Size: 8192\n"
			.db "Iterations: 10\n"
			.db "-----------------------------------------------\n", 0

s_result:	.db " primes.\n"
			.db "-----------------------------------------------\n", 0

s_comma:	.db ", ", 0

i:		.dw
prime:	.dw
k:		.dw
count:	.dw
iter:	.dw


.include "lib/stdio.asm"

flags:	.db

.end

