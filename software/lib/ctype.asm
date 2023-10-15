;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ctype.s
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; C character classification is an operation provided by a group of functions in the ANSI C Standard Library
;; for the C programming language. These functions are used to test characters for membership in a particular
;; class of characters, such as alphabetic characters, control characters, etc. Both single-byte, and wide
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
;; IS ALPHANUMERIC
;; sets ZF according with result
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_isalnum:
	call _isalpha
	je _isalnum_exit
	call _isdigit
_isalnum_exit:
	ret	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; IS DIGIT
;; sets ZF according with result
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_isdigit:
	push al
	cmp al, '0'
	jlu _isdigit_false
	cmp al, '9'
	jgu _isdigit_false
	and al, 0	; set ZF
	pop al
	ret
_isdigit_false:
	or al, 1	; clear ZF
	pop al
	ret	
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; IS ALPHA
;; sets ZF according with result
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_isalpha:
	push al
	cmp al, '_'
	je _isalpha_true
	cmp al, '.'
	je _isalpha_true
	cmp al, 'A'
	jlu _isalpha_false
	cmp al, 'z'
	jgu _isalpha_false
	cmp al, 'Z'
	jleu _isalpha_true
	cmp al, 'a'
	jgeu _isalpha_true
_isalpha_false:
	or al, 1	; clear ZF
	pop al
	ret
_isalpha_true:
	and al, 0	; set ZF
	pop al
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; IS PATH-ALPHA
;; sets ZF according with result
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
	cmp al, 'A'
	jlu ispath_false
	cmp al, 'z'
	jgu ispath_false
	cmp al, 'Z'
	jleu ispath_true
	cmp al, 'a'
	jgeu ispath_true
ispath_false:
	or al, 1	; clear ZF
	pop al
	ret
ispath_true:
	and al, 0	; set ZF
	pop al
	ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; IS SPACE
;; sets ZF according with result
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_isspace:
	cmp al, $20		; ' '
	je _isspace_exit
	cmp al, $09		; '\t'
	je _isspace_exit
	cmp al, $0A		; '\n'
	je _isspace_exit
	cmp al, $0D		; '\r'
	je _isspace_exit
	cmp al, $0B		; '\v'
_isspace_exit:
	ret	

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; TO LOWER
; input in AL
; output in AL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_to_lower:
	cmp al, 'Z'
	jgu _to_lower_ret
	add al, $20				; convert to lower case
_to_lower_ret:
	ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; TO UPPER
; input in AL
; output in AL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_to_upper:
	cmp al, 'a'
	jlu _to_upper_ret
	sub al, $20			; convert to upper case
_to_upper_ret:
	ret

