.include "lib/kernel.exp"

STACK_BEGIN:	.equ $F7FF	; beginning of stack

.org text_org			; origin at 1024

shell_main:	
	mov bp, STACK_BEGIN
	mov sp, STACK_BEGIN

	mov d, s_prompt_init
	call _puts

	mov d, s_prompt_shell
	call _puts
	mov d, s_shell_path
	syscall sys_spawn_proc

s_prompt_init:	.db "init started\n", 0
s_prompt_shell:	.db "Launching a shell session...\n", 0
s_shell_path:	  .db "/usr/bin0/shell", 0

.include "lib/stdio.asm"

.end
