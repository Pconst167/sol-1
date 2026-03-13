toktyp_identifier  .equ 0
toktyp_keyword     .equ 1
toktyp_delimiter   .equ 2
toktyp_string      .equ 3
toktyp_char        .equ 4
toktyp_numeric     .equ 5
toktyp_end         .equ 6

tok_null           .equ 0
tok_fslash         .equ 1
tok_times          .equ 2
tok_plus           .equ 3
tok_minus          .equ 4
tok_dot            .equ 5
tok_semi           .equ 6
tok_angle          .equ 7
tok_tilde          .equ 8
tok_equal          .equ 9
tok_colon          .equ 10
tok_comma          .equ 11

tok_end            .equ 20


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; read a full command argment from shell input buffer
;; argument is written into tokstr
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
get_arg:
  push a
  push si
  push di
  mov al, 0
  mov [tokstr], al      ; nullify tokstr string
  mov a, [prog]
  mov si, a
  mov di, tokstr
get_arg_skip_spaces:
  lodsb
  call _isspace
  je get_arg_skip_spaces
get_arg_l0:
  cmp al, $3b        ; check if is ';'
  je get_arg_end
  cmp al, 0
  je get_arg_end      ; check if end of input
  stosb
  lodsb
  jmp get_arg_l0
get_arg_end:
  mov al, 0
  stosb
  sub si, 1
  mov a, si
  mov [prog], a    ; update pointer
  pop di
  pop si
  pop a
  ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; read a path formation from shell input buffer
;; path is written into tokstr
;; /usr/bin
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
get_path:
  push a
  push si
  push di
  mov al, 0
  mov [tokstr], al      ; nullify tokstr string
  mov a, [prog]
  mov si, a
  mov di, tokstr
get_path_skip_spaces:
  lodsb
  call _isspace
  je get_path_skip_spaces
get_path_is_pathchar:
  stosb
  lodsb
  call _isalnum      ;check if is alphanumeric
  je get_path_is_pathchar
  cmp al, '/'        ; check if is '/'
  je get_path_is_pathchar
  mov al, 0
  stosb
  sub si, 1
  mov a, si
  mov [prog], a    ; update pointer
get_path_end:
  pop di
  pop si
  pop a
  ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; read a line
;; line is written into tokstr
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
get_line:
  push a
  push si
  push di
  mov al, 0
  mov [tokstr], al      ; nullify tokstr string
  mov a, [prog]
  mov si, a
  mov di, tokstr
get_line_l0:
  lodsb
  cmp al, $0a    ; check for new line
  je get_line_exit
  stosb
  jmp get_line_l0
get_line_exit:
  mov al, 0
  stosb
  mov a, si
  mov [prog], a    ; update pointer
  pop di
  pop si
  pop a
  ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; token parser
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
get_token:
  push a
  push d
  push si
  push di
  mov al, 0
  mov [tokstr], al      ; nullify tokstr string
  mov al, tok_null
  mov [tok], al        ; nullify token
  mov a, [prog]
  mov si, a
  mov di, tokstr
get_tok_skip_spaces:
  lodsb
  call _isspace
  je get_tok_skip_spaces
  cmp al, 0      ; check for end of input (null)
  je get_token_end
  cmp al, '#'      ; comments!
  je get_tok_comment
  call _isalnum
  jz is_alphanumeric
; other token types
get_token_slash:
  cmp al, '/'        ; check if '/'
  jne get_token_minus
  stosb          ; store '/' into token string
  mov al, 0
  stosb          ; terminate token string
  mov al, tok_fslash
  mov [tok], al      
  mov al, toktyp_delimiter
  mov [toktyp], al
  mov a, si
  mov [prog], a    ; update pointer
  jmp get_token_return
get_token_minus:
  cmp al, '-'        ; check if '-'
  jne get_token_comma
  stosb          ; store '-' into token string
  mov al, 0
  stosb          ; terminate token string
  mov al, tok_minus
  mov [tok], al      
  mov al, toktyp_delimiter
  mov [toktyp], al
  mov a, si
  mov [prog], a    ; update pointer
  jmp get_token_return
get_token_comma:
  cmp al, ','        ; check if ','
  jne get_token_semi
  stosb          ; store ',' into token string
  mov al, 0
  stosb          ; terminate token string
  mov al, tok_comma
  mov [tok], al      
  mov al, toktyp_delimiter
  mov [toktyp], al
  mov a, si
  mov [prog], a    ; update pointer
  jmp get_token_return
get_token_semi:
  cmp al, $3b        ; check if ';'
  jne get_token_colon
  stosb          ; store ';' into token string
  mov al, 0
  stosb          ; terminate token string
  mov al, tok_semi
  mov [tok], al      
  mov al, toktyp_delimiter
  mov [toktyp], al
  mov a, si
  mov [prog], a    ; update pointer
  jmp get_token_return
get_token_colon:
  cmp al, $3a        ; check if ':'
  jne get_token_angle
  stosb          ; store ':' into token string
  mov al, 0
  stosb          ; terminate token string
  mov al, tok_colon
  mov [tok], al      
  mov al, toktyp_delimiter
  mov [toktyp], al
  mov a, si
  mov [prog], a    ; update pointer
  jmp get_token_return
get_token_angle:
  cmp al, $3e        ; check if '>'
  jne get_token_tilde
  stosb          ; store '>' into token string
  mov al, 0
  stosb          ; terminate token string
  mov al, tok_angle
  mov [tok], al      
  mov al, toktyp_delimiter
  mov [toktyp], al
  mov a, si
  mov [prog], a    ; update pointer
  jmp get_token_return
get_token_tilde:
  cmp al, '~'        ; check if '~'
  jne get_token_equal
  stosb          ; store '~' into token string
  mov al, 0
  stosb          ; terminate token string
  mov al, tok_tilde
  mov [tok], al      
  mov al, toktyp_delimiter
  mov [toktyp], al
  mov a, si
  mov [prog], a    ; update pointer
  jmp get_token_return
get_token_equal:
  cmp al, '='        ; check if '='
  jne get_token_skip
  stosb          ; store '=' into token string
  mov al, 0
  stosb          ; terminate token string
  mov al, tok_equal
  mov [tok], al      
  mov al, toktyp_delimiter
  mov [toktyp], al
  mov a, si
  mov [prog], a    ; update pointer
  jmp get_token_return
get_token_skip:
  mov a, si
  mov [prog], a    ; update pointer
  jmp get_token_return
get_token_end:        ; end of file token
  mov al, tok_end
  mov [tok], al
  mov al, toktyp_end
  mov [toktyp], al
  jmp get_token_return
is_alphanumeric:
  stosb
  lodsb
  call _isalnum      ;check if is alphanumeric
  jz is_alphanumeric
  cmp al, $2e        ; check if is '.'
  je is_alphanumeric
  mov al, 0
  stosb
  mov al, toktyp_identifier
  mov [toktyp], al
  sub si, 1
  mov a, si
  mov [prog], a    ; update pointer
get_token_return:
  pop di
  pop si
  pop d
  pop a
  ret
get_tok_comment:
  lodsb
  cmp al, $0a      ; new line
  jne get_tok_comment
  jmp get_tok_skip_spaces


get_number:
  push a
  push d
  push si
  push di
  mov al, 0
  mov [tokstr], al      ; nullify tokstr string
  mov al, tok_null
  mov [tok], al        ; nullify token
  mov a, [prog]
  mov si, a
  mov di, tokstr
get_number_skip_spaces:
  lodsb
  call _isspace
  je get_number_skip_spaces
  cmp al, 0      ; check for end of input (null)
  jne get_number_l0
  mov al, tok_end
  mov [tok], al
  mov al, toktyp_end
  mov [toktyp], al
  jmp get_number_return
get_number_l0:
  stosb
  lodsb
  call _isdigit      ;check if is numeric
  jz get_number_l0
  mov al, 0
  stosb
  mov al, toktyp_numeric
  mov [toktyp], al
  sub si, 1
  mov a, si
  mov [prog], a    ; update pointer
get_number_return:
  pop di
  pop si
  pop d
  pop a
  ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; put back token
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  
_putback:
  push a
  push si
  mov si, tokstr  
_putback_loop:
  lodsb
  cmp al, 0
  je _putback_end
  mov a, [prog]
  dec a
  mov [prog], a      ; update pointer
  jmp _putback_loop
_putback_end:
  pop si
  pop a
  ret




prog:      .dw 0          ; pointer to current position in buffer

toktyp:    .db 0          ; token type symbol
tok:       .db 0          ; current token symbol
tokstr:    .fill 256, 0   ; token as a string
