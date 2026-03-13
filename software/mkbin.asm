.include "lib/kernel.exp"

.org text_org			; origin at 1024

; content is loaded into a buffer here. buffer size will be 16KB
; content is loaded as a pure binary string with given size
; invoke syscall that will copy the data, sector by sectors
; data is copied sector by sectors, from userspace to kernelspace
; after each sector is transferred, the sector is written to disk
; 
; we could also add XON/XOFF software flow control such that
; the kernel will request blocks of 1024 bytes and after that
; it will send an XOFF signal to the client.
; it will then write the data to disk and clear the buffer
; then if the total size - 1024 is still > 0, then we loop again
; requesting another 1024 bytes etc...

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; CREATE NEW BINARY FILE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
cmd_mkbin:
	mov a, 0
	mov [prog], a
	call get_token
	mov d, s_prompt
	call _puts
	mov d, tokstr
	mov al, 6
	syscall sys_filesystem

	syscall sys_terminate_proc

s_prompt: .db "% ", 0

.include "lib/token.asm"
.include "lib/stdio.asm"
.include "lib/ctype.asm"

.end


