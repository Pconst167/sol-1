;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; string.s
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; _strrev
; reverse a string
; D = string address
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 01234
_strrev:
	pusha
	call _strlen	; length in C
	mov a, c
	cmp a, 1
	jleu _strrev_end	; check string length. string len must be > 1
	dec a
	mov si, d	; beginning of string
	mov di, d	; beginning of string (for destinations)
	add d, a	; end of string
	mov a, c
	shr a		; divide by 2
	mov c, a	; C now counts the steps
_strrev_L0:
	mov bl, [d]	; save load right-side char into BL
	lodsb		; load left-side char into AL; increase SI
	mov [d], al	; store left char into right side
	mov al, bl
	stosb		; store right-side char into left-side; increase DI
	dec c
	dec d
	cmp c, 0
	jne _strrev_L0
_strrev_end:
	popa
	ret
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; _strchr
; search string in D for char in AL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_strchr:
_strchr_L0:
	mov bl, [d]
	cmp bl, 0
	je _strchr_end
	cmp al, bl
	je _strchr_end
	inc d
	jmp _strchr_L0
_strchr_end:
	mov al, bl
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; _strstr
; find sub-string
; str1 in SI
; str2 in DI
; SI points to end of source string
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
; result in C
; pointer in D
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_strlen:
	push d
	mov c, 0
_strlen_L1:
	cmp byte [d], 0
	je _strlen_ret
	inc d
	inc c
	jmp _strlen_L1
_strlen_ret:
	pop d
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; STRCMP
; compare two strings
; str1 in SI
; str2 in DI
; CREATE A STRING COMPAIRON INSTRUCION ?????
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


; STRCPY
; copy null terminated string from SI to DI
; source in SI
; destination in DI
_strcpy:
	push si
	push di
	push al
_strcpy_L1:
	lodsb
	stosb
	cmp al, 0
	jne _strcpy_L1
_strcpy_end:
	pop al
	pop di
	pop si
	ret

; STRCAT
; concatenate a NULL terminated string into string at DI, from string at SI
; source in SI
; destination in DI
_strcat:
	push si
	push di
	push a
	push d
	mov a, di
	mov d, a
_strcat_goto_end_L1:
	cmp byte[d], 0
	je _strcat_start
	inc d
	jmp _strcat_goto_end_L1
_strcat_start:
	mov di, d
_strcat_L1:
	lodsb
	stosb
	cmp al, 0
	jne _strcat_L1
_strcat_end:
	pop d
	pop a
	pop di
	pop si
	ret


