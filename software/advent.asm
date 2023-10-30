;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ADVENTURE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.include "lib/kernel.exp"

.org text_org			; origin at 1024

adventure:
	mov d, s_telnet_clear
	call _puts
	mov d, s_adv_instr
	call _puts

adv_start:
	call printnl
	mov al, 0
	mov [player_location], al		; reset position
	mov d, s_adv_0
	call printnl
	call _puts
	call printnl

adv_loop:
	mov d, player_command
	call _gets			; get command

	mov al, [d]
	mov ah, al
	call _to_upper
	cmp al, 'Q'
	je adv_ret			; quit game
	cmp al, 'X'
	je examine_command
	call adv_map_dir		; convert NESW to 0123 in AL
	cmp al, 4
	je unknown_command		; other keywords
move_command:
	mov bl, al			; save converted movement value
	mov al, [player_location]		; get current pos
	mov cl, 2
	shl al, cl			; multiply pos by 4, for table conversion
	add al, bl			; get new position table index
	mov ah, 0
	add a, adv_pos_table
	mov d, a
	mov al, [d]
	mov [player_location], al		; save new position
	call print_location_description
	jmp adv_loop			; back to main loop

print_location_description:
	mov al, [player_location]		; get position
	mov ah, 0
	mov cl, 1
	shl a, cl			; times 2
	mov a, [a + adv_text_table]	; get text description for new position
	mov d, a
	call printnl
	call _puts
	call printnl
	ret

unknown_command:
	mov d, s_unknown_command
	call _puts
	jmp adv_loop

examine_command:
	mov d, s_items_here
	call _puts
	mov d, item_list
examine_command_L0:
	mov a, [d + 1]
	cmp a, 0
	je examine_command_end
	mov al, [d]
	mov bl, [player_location]
	cmp al, bl
	je examine_command_item_here
	add d, 4
	jmp examine_command_L0
examine_command_item_here:
	push d
	mov a, [d+1]	; get pointer
	mov d, a
	call _puts
	pop d
	add d, 4
	call printnl
	jmp examine_command_L0
examine_command_end:
	jmp adv_loop

adv_ret:
	syscall sys_terminate_proc			; return to shell

player_location:	.db 0
player_command:		.fill 256, 0


; location(1), 255 = with player
; pointer to item name (2)
; flags(1)
;
item_list:
	.db 0
	.dw item0
	.db 0
	.db 0
	.dw item1
	.db 0
	.db 1
	.dw item2
	.db 0
	.db 1
	.dw item3
	.db 0
; end of list
	.db 0
	.dw 0
	.db 0
	
item_names:	
item0:	.db "an old brass lantern", 0
item1:	.db "a small key", 0
item2:	.db "an empty bottle", 0
item3:	.db "an old axe", 0

adv_pos_table:
	; pos 0, beginning
	.db 1			; N
	.db 2			; E
	.db 3			; S
	.db 4			; W
	; pos 1
	.db 6			
	.db 1			
	.db 0			
	.db 1	
	; pos 2
	.db 2
	.db 2
	.db 3
	.db 0	
	; pos 3
	.db 0
	.db 2
	.db 3
	.db 4
	; pos 4
	.db 5
	.db 0
	.db 3
	.db 4
	; pos 5
	.db 5
	.db 5
	.db 4
	.db 5
	; pos 6
	.db 7
	.db 6
	.db 1
	.db 6
	; pos 7
	.db 8
	.db 7
	.db 6
	.db 7
	; pos 8
	.db 9
	.db 8
	.db 7
	.db 8
	; pos 9
	.db 9
	.db 9
	.db 8
	.db 9


; dir char in AL
; output in AL
adv_map_dir:
	mov ah, al
	mov al, 0
	cmp ah, 'N'
	je dir_ret
	inc al
	cmp ah, 'E'
	je dir_ret
	inc al
	cmp ah, 'S'
	je dir_ret
	inc al
	cmp ah, 'W'
	je dir_ret
	inc al			
dir_ret:
	ret
	
	
adv_text_table:
	.dw s_adv_0
	.dw s_adv_1
	.dw s_adv_2
	.dw s_adv_3
	.dw s_adv_4
	.dw s_adv_5
	.dw s_adv_6
	.dw s_adv_7
	.dw s_adv_8
	.dw s_adv_9	
	


s_adv_instr:	.db "INSTRUCTIONS:\n"
				.db "n: go north\n"
				.db "s: go south\n"
				.db "w: go west\n"
				.db "e: go east\n"
				.db "x: examine location\n"
				.db "t: take item\n"
				.db "q: quit", 0

s_adv_0:
	.db "It is around 9am, and you find yourself in a forest.\n"
	.db "There is an old wooden cabin north of you.\n"
	.db "The cabin looks very old and seems abandoned. It has two windows and a door at the front.\n"
	.db "You can see through the windows and the sunlight illuminates the inside of the cabin.", 0

s_adv_1:
	.db "You are at the entrance door to the cabin. The door is locked.\n", 0

s_adv_2:
	.db "You are in a clearing. Small trees encircle you. The grass is short and there are a few big rocks on the ground.\n"
	.db "The sky is a deep blue with big white puffy clouds flying calmly.", 0

s_adv_3:
	.db "You are in a deep forest. Big trees block the way south.", 0

s_adv_4:
	.db "You are on a rocky plateau.", 0

s_adv_5:
	.db "You are at the top of the plateau. Looking down the mountain you see a big lake.", 0

s_adv_6:
	.db "You are north of the cabin. There is a path through the trees leading north.", 0

s_adv_7:
	.db "You are in a forest path. There is a small stream north of you.", 0

s_adv_8:
	.db "You are in a rocky floored water spring. "
	.db "Clear water flows out of a small spring amidst the rocks. "
	.db "Wet and muddy grass encircles the spring. A bird is singing nearby.", 0

s_adv_9:
	.db "You are in a bog. The water reaches up to your knees.\n"
	.db "The ground feels like quick sand and it is difficult to move around.", 0

s_adv_restart:
	.db "Restart? ", 0
	
s_unknown_command:
	.db "I do not understand that word.\n", 0
	
s_adv_exam:
	.db "There is nothing here.\n", 0
	
s_items_here:
	.db "Items found at this location...\n", 0

p_itemlist:


.include "lib/stdio.asm"
.include "lib/ctype.asm"
.include "lib/token.asm"

.end
