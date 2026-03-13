TOKTYP_IDENTIFIER  .equ 0
TOKTYP_KEYWORD     .equ 1
TOKTYP_DELIMITER   .equ 2
TOKTYP_STRING      .equ 3
TOKTYP_CHAR        .equ 4
TOKTYP_NUMERIC     .equ 5
TOKTYP_END         .equ 6

TOK_NULL           .equ 0
TOK_FSLASH         .equ 1
TOK_TIMES          .equ 2
TOK_PLUS           .equ 3
TOK_MINUS          .equ 4
TOK_DOT            .equ 5
TOK_SEMI           .equ 6
TOK_ANGLE          .equ 7
TOK_TILDE          .equ 8
TOK_EQUAL          .equ 9
TOK_COLON          .equ 10
TOK_COMMA          .equ 11

TOK_END            .equ 20


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
get_arg_L0:
  cmp al, $3B        ; check if is ';'
  je get_arg_end
  cmp al, 0
  je get_arg_end      ; check if end of input
  stosb
  lodsb
  jmp get_arg_L0
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
get_line_L0:
  lodsb
  cmp al, $0A    ; check for new line
  je get_line_exit
  stosb
  jmp get_line_L0
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
  mov al, TOK_NULL
  mov [tok], al        ; nullify token
  mov a, [prog]
  mov si, a
  mov di, tokstr
get_tok_skip_spaces:
  lodsb
  call _isspace
  je get_tok_skip_spaces
  cmp al, 0      ; check for end of input (NULL)
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
  mov al, TOK_FSLASH
  mov [tok], al      
  mov al, TOKTYP_DELIMITER
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
  mov al, TOK_MINUS
  mov [tok], al      
  mov al, TOKTYP_DELIMITER
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
  mov al, TOK_COMMA
  mov [tok], al      
  mov al, TOKTYP_DELIMITER
  mov [toktyp], al
  mov a, si
  mov [prog], a    ; update pointer
  jmp get_token_return
get_token_semi:
  cmp al, $3B        ; check if ';'
  jne get_token_colon
  stosb          ; store ';' into token string
  mov al, 0
  stosb          ; terminate token string
  mov al, TOK_SEMI
  mov [tok], al      
  mov al, TOKTYP_DELIMITER
  mov [toktyp], al
  mov a, si
  mov [prog], a    ; update pointer
  jmp get_token_return
get_token_colon:
  cmp al, $3A        ; check if ':'
  jne get_token_angle
  stosb          ; store ':' into token string
  mov al, 0
  stosb          ; terminate token string
  mov al, TOK_COLON
  mov [tok], al      
  mov al, TOKTYP_DELIMITER
  mov [toktyp], al
  mov a, si
  mov [prog], a    ; update pointer
  jmp get_token_return
get_token_angle:
  cmp al, $3E        ; check if '>'
  jne get_token_tilde
  stosb          ; store '>' into token string
  mov al, 0
  stosb          ; terminate token string
  mov al, TOK_ANGLE
  mov [tok], al      
  mov al, TOKTYP_DELIMITER
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
  mov al, TOK_TILDE
  mov [tok], al      
  mov al, TOKTYP_DELIMITER
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
  mov al, TOK_EQUAL
  mov [tok], al      
  mov al, TOKTYP_DELIMITER
  mov [toktyp], al
  mov a, si
  mov [prog], a    ; update pointer
  jmp get_token_return
get_token_skip:
  mov a, si
  mov [prog], a    ; update pointer
  jmp get_token_return
get_token_end:        ; end of file token
  mov al, TOK_END
  mov [tok], al
  mov al, TOKTYP_END
  mov [toktyp], al
  jmp get_token_return
is_alphanumeric:
  stosb
  lodsb
  call _isalnum      ;check if is alphanumeric
  jz is_alphanumeric
  cmp al, $2E        ; check if is '.'
  je is_alphanumeric
  mov al, 0
  stosb
  mov al, TOKTYP_IDENTIFIER
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
  cmp al, $0A      ; new line
  jne get_tok_comment
  jmp get_tok_skip_spaces


get_number:
  push a
  push d
  push si
  push di
  mov al, 0
  mov [tokstr], al      ; nullify tokstr string
  mov al, TOK_NULL
  mov [tok], al        ; nullify token
  mov a, [prog]
  mov si, a
  mov di, tokstr
get_number_skip_spaces:
  lodsb
  call _isspace
  je get_number_skip_spaces
  cmp al, 0      ; check for end of input (NULL)
  jne get_number_L0
  mov al, TOK_END
  mov [tok], al
  mov al, TOKTYP_END
  mov [toktyp], al
  jmp get_number_return
get_number_L0:
  stosb
  lodsb
  call _isdigit      ;check if is numeric
  jz get_number_L0
  mov al, 0
  stosb
  mov al, TOKTYP_NUMERIC
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
;; PUT BACK TOKEN
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
