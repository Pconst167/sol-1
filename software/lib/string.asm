;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; string.s
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; _strrev
; reverse a string
; d = string address
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 01234
_strrev:
	pusha
	call _strlen	; length in c
	mov a, c
	cmp a, 1
	jleu _strrev_end	; check string length. string len must be > 1
	dec a
	mov si, d	; beginning of string
	mov di, d	; beginning of string (for destinations)
	add d, a	; end of string
	mov a, c
	shr a		; divide by 2
	mov c, a	; c now counts the steps
_strrev_l0:
	mov bl, [d]	; save load right-side char into bl
	lodsb		; load left-side char into al; increase si
	mov [d], al	; store left char into right side
	mov al, bl
	stosb		; store right-side char into left-side; increase di
	dec c
	dec d
	cmp c, 0
	jne _strrev_l0
_strrev_end:
	popa
	ret
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; _strchr
; search string in d for char in al
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_strchr:
_strchr_l0:
	mov bl, [d]
	cmp bl, 0
	je _strchr_end
	cmp al, bl
	je _strchr_end
	inc d
	jmp _strchr_l0
_strchr_end:
	mov al, bl
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; _strstr
; find sub-string
; str1 in si
; str2 in di
; si points to end of source string
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_strstr:
	push al
	push d
	push di
_strstr_loop:
	cmpsb					; compare a byte of the strings
	jne _strstr_ret
	lea d, [di + 0]
	cmp byte[d], 0				; check if at end of string (null)
	jne _strstr_loop				; equal chars but not at end
_strstr_ret:
	pop di
	pop d
	pop al
	ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; length of null terminated string
; result in c
; pointer in d
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_strlen:
	push d
	mov c, 0
_strlen_l1:
	cmp byte [d], 0
	je _strlen_ret
	inc d
	inc c
	jmp _strlen_l1
_strlen_ret:
	pop d
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; strcmp
; compare two strings
; str1 in si
; str2 in di
; create a string compairon instrucion ?????
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_strcmp:
	push al
	push d
	push di
	push si
_strcmp_loop:
	cmpsb					; compare a byte of the strings
	jne _strcmp_ret
	lea d, [si +- 1]
	cmp byte[d], 0				; check if at end of string (null)
	jne _strcmp_loop				; equal chars but not at end
_strcmp_ret:
	pop si
	pop di
	pop d
	pop al
	ret


; strcpy
; copy null terminated string from si to di
; source in si
; destination in di
_strcpy:
	push si
	push di
	push al
_strcpy_l1:
	lodsb
	stosb
	cmp al, 0
	jne _strcpy_l1
_strcpy_end:
	pop al
	pop di
	pop si
	ret

; strcat
; concatenate a null terminated string into string at di, from string at si
; source in si
; destination in di
_strcat:
	push si
	push di
	push a
	push d
	mov a, di
	mov d, a
_strcat_goto_end_l1:
	cmp byte[d], 0
	je _strcat_start
	inc d
	jmp _strcat_goto_end_l1
_strcat_start:
	mov di, d
_strcat_l1:
	lodsb
	stosb
	cmp al, 0
	jne _strcat_l1
_strcat_end:
	pop d
	pop a
	pop di
	pop si
	ret


