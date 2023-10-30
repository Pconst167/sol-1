.include "lib/kernel.exp"

.org text_org

primes:
	mov sp, $FFFF
	mov bp, $FFFF

	mov a, 0
	mov [prog], a
	call get_token
	mov al, [tok]
	cmp al, TOK_END
	je bad_args
	mov d, tokstr
	call _strtoint
	mov [min], a
	call get_token
	mov al, [tok]
	cmp al, TOK_END
	je bad_args
	mov d, tokstr
	call _strtoint
	mov [max], a
	
	mov a, [min]
primes_L1:
	mov c, 2	
primes_L2:
	push a
	mov b, c
	div a, b
	cmp b, 0
	jz divisible
	inc c
	pop a
	jmp primes_L2		
divisible:
	pop a
	cmp a, c
	jnz notprime			
isprime:
	call print_u16d
	
	push a
	mov a, [total]
	inc a
	mov [total], a
	mov d, s_total
	call _puts
	call print_u16d
	
	pop a

	call printnl
	inc a
	mov b, [max]
	cmp a, b
	jgeu primes_ret
	jmp primes_L1
notprime:
	inc a
	jmp primes_L1		
primes_ret:
	syscall sys_terminate_proc

bad_args:
	mov d, s_usage
	call _puts
	jmp primes_ret

.include "lib/stdio.asm"
.include "lib/token.asm"
.include "lib/ctype.asm"

s_usage:	.db "Usage: primes [min] [max]\n", 0
total:		.dw 0
max:		.dw 1000
min:		.dw 5

s_max:		.db "\rUpper bound: ", 0
s_total:	.db ", Total primes: ", 0
			
.end
