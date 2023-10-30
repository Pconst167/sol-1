.include "lib/kernel.exp"

.org text_org			; origin at 1024

WIDTH:	.equ	110		; must be even

menu:
	enter 512	
__get_math_choice:
	mov d, s_menu
	call _puts
	lea d, [bp +- 511]
	call _gets						; get choice
	mov al, [d]
	sub al, 30h
	cmp al, 2
	je _math_quit
	jgu __get_math_choice				; check bounds
	shl al, 1
	mov ah, 0
	call [a + __math_menu_jump_table]

	call printnl
	jmp __get_math_choice
_math_quit:
	leave
	syscall sys_terminate_proc

; ***********************************************************************************
; MATHS JUMP TABLE
; ***********************************************************************************
__math_menu_jump_table:
	.dw automaton
	.dw chg_rules
	
automaton:
	enter 2
	mov d, s_steps
	call _puts
	call scan_u16d
	mov [bp +- 1], a
	call printnl
; reset initial state
	mov si, init_state
	mov di, prev_state
	mov c, (WIDTH+1)
	rep movsb	
auto_L1:
	mov c, 1	
	mov a, [bp + -1]
	cmp a, 0
	je automaton_ret
	dec a
	mov [bp + -1], a
auto_L2:	
	mov a, c
	mov d, a
	cla
	inc d
	mov bl, [d + prev_state]
	add al, bl
	dec d
	mov bl, [d + prev_state]
	
	shl bl, 1
	add al, bl
	dec d
	mov bl, [d + prev_state]
	shl bl, 2
	add al, bl					; now al has the number for the table
	
	mov a, [a + automaton_table]
	inc d
	mov [d + state], al
	inc c
	cmp c, WIDTH
	jlu auto_L2
	
; here we finished updating the current state, now we copy the current state to
; the previous state
	mov si, state
	mov di, prev_state
	mov c, (WIDTH+1)
	rep movsb
	
; now print the current state on the screen
	mov si, state
	mov di, state_chars
	mov c, (WIDTH+1)
state_convert_loop:
	lodsb
	mov ah, 0
	mov a, [a + table_translate]
	stosb
	loopc state_convert_loop
	
	mov d, state_chars
	call _puts
	
	call printnl
	jmp auto_L1	
automaton_ret:
	leave
	
	ret
	
chg_rules:
	mov d, s_rule
	call _puts
	mov d, 0
	mov c, 4
chg_rule_L1:
	call scan_u16x
	mov [d + automaton_table], a
	add d, 2
	loopc chg_rule_L1
	ret
	
.include "lib/stdio.asm"


	
s_rule:		.db "Rule: ", 0
s_steps:	.db "Steps: ", 0

table_translate:	.db ' '
					.db 'v'
	
init_state: 	.fill (WIDTH/2), 0
				.db 1 
				.fill (WIDTH/2), 0

prev_state: 	.fill (WIDTH/2), 0
				.db 1 
				.fill (WIDTH/2), 0
		
state: 			.fill (WIDTH+1), 0

state_chars:	.fill (WIDTH+1), ' '
				.db 0

automaton_table:
	.db 1		; 000
	.db 0		; 001
	.db 1		; 010
	.db 0		; 011
	.db 0		; 100
	.db 1		; 101
	.db 0		; 110
	.db 1		; 111
					

s_menu:		.db "\n\r"
			.db "0. Run automaton\n\r"
			.db "1. Change rule\n\r"
			.db "2. Quit\n\r"
			.db "% ", 0
				
.end
