;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ctype.s
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; c character classification is an operation provided by a group of functions in the ansi c standard library
;; for the c programming language. these functions are used to test characters for membership in a particular
;; class of characters, such as alphabetic characters, control characters, etc. both single-byte, and wide
;; characters are supported.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; _isalnum 
;; _isalpha 
;; islower 
;; isupper 
;; _isdigit 
;; isxdigit
;; iscntrl 
;; isgraph 
;; _isspace 
;; isblank 
;; isprint 
;; ispunct 
;; tolower 
;; toupper


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; is alphanumeric
;; sets zf according with result
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_isalnum:
	call _isalpha
	je _isalnum_exit
	call _isdigit
_isalnum_exit:
	ret	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; is digit
;; sets zf according with result
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_isdigit:
	push al
	cmp al, '0'
	jlu _isdigit_false
	cmp al, '9'
	jgu _isdigit_false
	and al, 0	; set zf
	pop al
	ret
_isdigit_false:
	or al, 1	; clear zf
	pop al
	ret	
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; is alpha
;; sets zf according with result
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_isalpha:
	push al
	cmp al, '_'
	je _isalpha_true
	cmp al, '.'
	je _isalpha_true
	cmp al, 'a'
	jlu _isalpha_false
	cmp al, 'z'
	jgu _isalpha_false
	cmp al, 'z'
	jleu _isalpha_true
	cmp al, 'a'
	jgeu _isalpha_true
_isalpha_false:
	or al, 1	; clear zf
	pop al
	ret
_isalpha_true:
	and al, 0	; set zf
	pop al
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; is path-alpha
;; sets zf according with result
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ispath:
	push al
	call _isdigit
	je ispath_true
	cmp al, '_'
	je ispath_true
	cmp al, '/'
	je ispath_true
	cmp al, '.'
	je ispath_true
	cmp al, 'a'
	jlu ispath_false
	cmp al, 'z'
	jgu ispath_false
	cmp al, 'z'
	jleu ispath_true
	cmp al, 'a'
	jgeu ispath_true
ispath_false:
	or al, 1	; clear zf
	pop al
	ret
ispath_true:
	and al, 0	; set zf
	pop al
	ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; is space
;; sets zf according with result
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_isspace:
	cmp al, $20		; ' '
	je _isspace_exit
	cmp al, $09		; '\t'
	je _isspace_exit
	cmp al, $0a		; '\n'
	je _isspace_exit
	cmp al, $0d		; '\r'
	je _isspace_exit
	cmp al, $0b		; '\v'
_isspace_exit:
	ret	

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; to lower
; input in al
; output in al
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_to_lower:
	cmp al, 'z'
	jgu _to_lower_ret
	add al, $20				; convert to lower case
_to_lower_ret:
	ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; to upper
; input in al
; output in al
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_to_upper:
	cmp al, 'a'
	jlu _to_upper_ret
	sub al, $20			; convert to upper case
_to_upper_ret:
	ret

