.include "lib/kernel.exp"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; wc filename
;; count words
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.org text_org			; origin at 1024

cmd_wc:
	mov a, 0
	mov [prog], a			; move tokennizer pointer to the beginning of the arguments area (address 0)
	call get_path			; read filename
	mov d, tokstr
	mov di, transient_data	; pointer to write buffer
	mov al, 20
	syscall sys_filesystem		; read textfile into buffer	
	
	mov a, transient_data
	mov [prog], a
	mov c, 0
L0:
	call get_token
	mov al, [tok]
	cmp al, TOK_END
	je cmd_wc_end
	mov al, [toktyp]
	cmp al, TOKTYP_IDENTIFIER
	jne L0
	inc c
	jmp L0

cmd_wc_end:
	mov a, c
	call print_u16d

	syscall sys_terminate_proc


.include "lib/token.asm"
.include "lib/stdio.asm"
.include "lib/ctype.asm"


transient_data:

.end



