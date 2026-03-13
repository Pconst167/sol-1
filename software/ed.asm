.include "lib/kernel.exp"

.org text_org			; origin at 1024

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ed - the original Unix text editor.
;
; 1,$p
; 1,2p
;
; 2d
; 1,3d
;
; 2a
; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ed_main:
	mov sp, $FFFF
	mov bp, $FFFF

	mov a, 0
	mov [prog], a
	call get_token
	mov al, [tok]
	cmp al, tok_end
	je no_filename_given	; no filename given as argument

	call _putback
	call get_path			; read filename
	mov d, tokstr
	mov di, text_buffer		; pointer to write buffer
	mov al, 20
	syscall sys_filesystem		; read textfile into buffer
	mov d, text_buffer
	call _strlen
	mov a, c				; find size of buffer
	add a, text_buffer
	mov d, a
	mov al, $0a
	mov [d], al
	inc d
	mov al, 0
	mov [d], al
	mov a, d
	mov [txt_buffer_ptr], a	; set buffer pointer

	mov d, text_buffer
	call _strlen
	mov a, c
	call print_u16d
	call printnl

no_filename_given:
	mov d, ss
	call _puts
main_l0:
	mov byte [tokstr], 0			; clear tokstr (so that enter doesnt repeat last shell command)
	call command_parser
	jmp main_l0
ss:.db "\nhello world\n",0
; ,p
; 1,3p
; 2p
; 1,$d
command_parser:
	mov d, input_buff
	mov a, input_buff
	mov [prog], a
	call _gets						; get command
	mov al, [input_buff]
	call _isalpha
	je get_command					; test if this is a command with a range in front

	cmp al, ','
	jne parser_hasrange
	mov a, 1
	mov [start], a
	call total_lines
	mov [end], a			; set range as the full range
	mov a, [prog]
	inc a
	mov [prog], a			; pass over ',' token
	jmp get_command

parser_hasrange:
	call get_number			; range start
	mov d, tokstr
	call _strtoint			; convert range to integer in a
	mov [start], a			; save range start
	mov [end], a			; save end too in case the range end is not given

	call get_token
	mov al, [tok]
	cmp al, tok_comma
	je parser_range_end
	jmp parser_start		; not a comma, so it must be a command

parser_range_end:
	call get_number			; range end
	mov d, tokstr
	call _strtoint			; convert range to integer in a
	mov [end], a			; save range start

get_command:
	call get_token			; get command
parser_start:
	mov di, keywords
	mov a, 0
	mov [parser_index], a		; reset keywords index
parser_l2:
	mov si, tokstr
	call _strcmp
	je parser_cmd_equal
parser_l2_l0:
	lea d, [di + 0]
	mov al, [d]
	cmp al, 0
	je parser_l2_l0_exit			; run through the keyword until finding null
	add di, 1
	jmp parser_l2_l0
parser_l2_l0_exit:
	add di, 1				; then skip null byte at the end 
	mov a, [parser_index]
	add a, 2
	mov [parser_index], a			; increase keywords table index
	lea d, [di + 0]
	mov al, [d]
	cmp al, 0
	je parser_cmd_not_found
	jmp parser_l2
parser_cmd_equal:
	mov a, $0d00
	syscall sys_io				; print carriage return
	mov a, [parser_index]			; get the keyword pointer
	call [a + keyword_pointers]		; execute command
	mov a, $0d00
	syscall sys_io				; print carriage return
	ret
parser_cmd_not_found:
	mov ah, '?'
	call _putchar
	ret

; a = line to append after
; b = address of text to append
append_lines:
	inc a
	mov d, b
	call _strlen		; length of text in c
	call find_line	; address in d
	mov di, d
	mov si, d
append_lines_l0:
	lodsb
	cmp al, $0a
	jne append_lines_l0
; now si points to char after \n
; start copying chars from there to beginning of deleted line
; copy till we find null
append_lines_l1:
	lodsb
	stosb
	cmp al, 0
	jne append_lines_l1
append_lines_end:
	ret

cmd_append:
	mov a, [txt_buffer_ptr]
	mov d, a
cmd_append_l0:
	call _gets		; read new line
	mov si, d
	mov di, s_dot
	call _strcmp
	je cmd_append_end
	mov a, [txt_buffer_ptr]
	mov si, a
cmd_append_l1:		; look for null termination
	lodsb
	cmp al, 0
	jne cmd_append_l1
	lea d, [si + -1]
	mov al, $0a
	mov [d], al
	lea d, [si + 0]
	mov al, 0
	mov [d], al
	mov a, d
	mov [txt_buffer_ptr], a
	jmp cmd_append_l0
cmd_append_end:
	mov al, 0
	mov [d], al
	ret

cmd_insert:
	ret

cmd_quit:
	syscall sys_terminate_proc

; first line\n
; second line\n
; third line\n
; fourth line\n
cmd_delete:
	mov a, [end]		; get starting line
cmd_delete_l0:
	call delete_line		
	mov b, [start]
	cmp a, b
	je cmd_delete_end
	dec a
	jmp cmd_delete_l0
cmd_delete_end:
; set text pointer to the end of file
	mov si, text_buffer
cmd_delete_l1:
	lodsb
	cmp al, 0
	jne cmd_delete_l1
	mov a, si
	dec a
	mov [txt_buffer_ptr], a
	ret
	
; find address of line beginning
; find eol address
; start copying chars from eol into beginning of required line
; stop when reache null
; a = line to delete
delete_line:
	push a
	call find_line	; address in d
	mov di, d
	mov si, d
delete_line_l0:
	lodsb
	cmp al, $0a
	jne delete_line_l0
; now si points to char after \n
; start copying chars from there to beginning of deleted line
; copy till we find null
delete_line_l1:
	lodsb
	stosb
	cmp al, 0
	jne delete_line_l1
delete_line_end:
	pop a
	ret

cmd_open:
	call get_token			; read filename
	mov d, tokstr
	mov di, text_buffer		; pointer to write buffer
	mov al, 20
	syscall sys_filesystem		; read textfile into buffer
	mov d, text_buffer
	call _strlen
	mov a, c				; find size of buffer
	add a, text_buffer
	mov d, a
	mov al, $0a
	mov [d], al
	inc d
	mov al, 0
	mov [d], al
	mov a, d
	mov [txt_buffer_ptr], a	; set buffer pointer

	mov d, text_buffer
	call _strlen
	mov a, c
	call print_u16d
	call printnl
	ret

cmd_save:
	call get_token		; read filename
	mov si, tokstr
	mov di, transient_data + 1
	call _strcpy				; copy filename

	mov d, transient_data	; pass data to kernel. starting at 512 byte header. text_buffer follows the header in mem.
	mov al, 5
	syscall sys_filesystem

	mov d, text_buffer
	call _strlen
	mov a, c
	call print_u16d
	call printnl
	ret
	
cmd_list:
	mov d, text_buffer
	call _puts
	ret

cmd_print:
	mov a, [start]		; get starting line
cmd_print_l0:
	call find_line		; address in d
	call printline		; print line at d	
	mov b, [end]
	cmp a, b
	je cmd_print_end
	inc a
	jmp cmd_print_l0
cmd_print_end:
	ret

cmd_print_numbered:
	mov a, [start]		; get starting line
cmd_print_numbered_l0:
	push a
	call print_u16d
	mov ah, $09			; tab
	call _putchar
	pop a
	call find_line		; address in d
	call printline		; print line at d	
	mov b, [end]
	cmp a, b
	je cmd_print_numbered_end
	inc a
	jmp cmd_print_numbered_l0
cmd_print_numbered_end:
	ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; print line
; pointer in d
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
printline:
	push a
	push d
printline_l0:
	mov al, [d]
	mov ah, al
	call _putchar
	cmp al, $0a
	je printline_end
	inc d
	jmp printline_l0
printline_end:
	pop d
	pop a
	ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; inputs
; a = line number
; outputs
; d = line address
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
find_line:
	push a
	push b
	mov b, text_buffer
	mov [prog], b
find_line_l0:
	cmp a, 1
	je find_line_end
	call get_line
	dec a
	jmp find_line_l0
find_line_end:
	mov a, [prog]
	mov d, a
	pop b
	pop a
	ret


; find total number of lines
; a = total
total_lines:
	mov b, 0
	mov si, text_buffer
total_lines_l0:
	lodsb
	cmp al, 0
	je total_lines_end
	cmp al, $0a
	jne total_lines_l0
	inc b
	jmp total_lines_l0
total_lines_end:
	mov a, b
	ret

input_buff:			.fill 512, 0

txt_buffer_ptr:		.dw text_buffer

s_dot:				.db ".", 0

keywords:
	.db "a", 0		; append
	.db "i", 0		; insert
	.db "d", 0		; delete
	.db "p", 0		; print
	.db "n", 0		; print
	.db "l", 0		; list
	.db "e", 0		; edit
	.db "w", 0		; write
	.db "q", 0		; quit
	.db 0

keyword_pointers:
	.dw cmd_append
	.dw cmd_insert
	.dw cmd_delete
	.dw cmd_print
	.dw cmd_print_numbered
	.dw cmd_list
	.dw cmd_open
	.dw cmd_save
	.dw cmd_quit

s_bad_command:		.db "?", 0

; file includes. these are functions used by the shell
.include "lib/stdio.asm"
.include "lib/ctype.asm"
.include "lib/token.asm"

parser_index: .dw 0
start:	.dw 0
end:	.dw 0

new_input:		.fill 1024 * 4
transient_data:	.fill 512
text_buffer:	.db 0			

.end

