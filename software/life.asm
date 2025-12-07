.include "lib/kernel.exp"

.org text_org			; origin at 1024

main:
	call init_board
	call init_board2
	mov al, 0
	mov [parity], al
main_loop:

	mov a, 1
	mov [line], a
	mov [col], a
board_lines:;{
	mov a, 1
	mov [col], a
board_cols:;{
	call update_cell
	mov a, [col]
	inc a
	mov [col], a
	cmp a, width-1
	jne board_cols
;}	
	mov a, [line]
	inc a
	mov [line], a
	cmp a, height-1
	jne board_lines
;}
	
	mov d, s_clear
	call _puts
	call print_board
	
	mov al, [parity]
	not al
	mov [parity], al
	
	jmp main_loop

check_parity_inv:
	push a
	mov al, [parity]
	cmp al, 0
	je parity_inv_even
	mov d, board
	pop a
	ret
parity_inv_even:
	mov d, board
	pop a
	ret

check_parity:
	push a
	mov al, [parity]
	cmp al, 0
	je parity_even
	mov d, board
	pop a
	ret
parity_even:
	mov d, board
	pop a
	ret

update_cell:
	mov b, [line]
	mov a, width
	mul a, b
	mov a, [col]
	add b, a
	push b				; save cell number
	call check_parity
	add d, b
	mov al, [d]
	cmp al, '*'
	je live_cell
	pop a
	call get_live_neighbours
	cmp b, 3
	jne update_cell_end
	call check_parity_inv
	add d, a
	mov al, '*'
	mov [d], al
update_cell_end:
	ret
live_cell:
	pop a
	call get_live_neighbours
	cmp b, 2
	je update_cell_end	; continue alive
	cmp b, 3
	je update_cell_end	; continue alive
	call check_parity_inv
	add d, a
	mov al, ' '
	mov [d], al
	ret

print_board:
	mov a, 0
	mov [c], a
	mov [l], a
	call check_parity_inv
print_L0:
	mov al, [d]
	mov ah, al
	call _putchar
	inc d
	mov a, [c]
	inc a
	mov [c], a
	cmp a, width
	jne print_L0
	call printnl
	mov a, 0
	mov [c], a
	mov a, [l]
	inc a
	mov [l], a
	cmp a, height
	jne print_L0
	ret

init_board:
	mov d, board
	mov b, 0
init_L0:
	mov al, bl
	and al, 5
	cmp al, 5
	je init_odd
	mov al, '*'
	mov [d], al
	inc d
	inc b
	inc c
	cmp b, width*height
	jne init_L0
	ret
init_odd:
	mov al, ' '
	mov [d], al
	inc d
	inc b
	cmp b, width*height
	jne init_L0
	ret

init_board2:
	mov d, board2
	mov b, 0
init_L02:
	mov al, bl
	and al, 5
	cmp al, 5
	je init_odd2
	mov al, '*'
	mov [d], al
	inc d
	inc b
	inc c
	cmp b, width*height
	jne init_L02
	ret
init_odd2:
	mov al, ' '
	mov [d], al
	inc d
	inc b
	cmp b, width*height
	jne init_L02
	ret
; find total neighbours at a point
; A = position
; B = result
get_live_neighbours:
	push a
	push d
	push c
	mov c, 0	; reset number

	call check_parity
	add d, a
	sub d, width+1
	mov bl, [d]
	cmp bl, '*'
	jne jmp1
	inc c
jmp1:
	call check_parity
	add d, a
	sub d, width
	mov bl, [d]
	cmp bl, '*'
	jne jmp2
	inc c
jmp2:
	call check_parity
	add d, a
	sub d, width-1
	mov bl, [d]
	cmp bl, '*'
	jne jmp3
	inc c
jmp3:
	call check_parity
	add d, a
	inc d 
	mov bl, [d]
	cmp bl, '*'
	jne jmp4
	inc c
jmp4:
	call check_parity
	add d, a
	add d, width+1
	mov bl, [d]
	cmp bl, '*'
	jne jmp5
	inc c
jmp5:
	call check_parity
	add d, a
	add d, width
	mov bl, [d]
	cmp bl, '*'
	jne jmp6
	inc c
jmp6:
	call check_parity
	add d, a
	add d, width-1
	mov bl, [d]
	cmp bl, '*'
	jne jmp7
	inc c
jmp7:
	call check_parity
	add d, a
	dec d
	mov bl, [d]
	cmp bl, '*'
	jne jmp8
	inc c
jmp8:
	mov b, c
	pop c
	pop d
	pop a
	ret

width: 			.equ 128
height:			.equ 48

l: .dw 0
c: .dw 0

line:	.dw 1
col:	.dw 1

parity: .db 0

s_clear:		.db 27, "[2J", 27, "[H", 0

.include "lib/stdio.asm"

board:			.fill (width)*(height)
board2:		


.end

