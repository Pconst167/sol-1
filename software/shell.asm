.include "lib/kernel.exp"

STACK_BEGIN:  .equ $F7FF  ; beginning of stack

.org text_org      ; origin at 1024

shell_main:  
  mov bp, STACK_BEGIN
  mov sp, STACK_BEGIN

; open config file
; example: path=/usr/bin;
; read path config entry
  mov d, s_etc_config   ; '/etc/sh.conf'
  mov si, s_path        ; config entry name is "path"
  mov di, path          ; config value destination is the var that holds the path variable
  call read_config
  mov d, path
  call _puts

; open config file
; read home directory config entry
  mov d, s_etc_config     ; '/etc/sh.conf'
  mov si, s_home          ; config entry name is "home"
  mov di, homedir         ; config value destination is the var that holds the home directory path
  call read_config  

  call printnl

  mov a, s_etc_shellrc
  mov [prog], a
  call cmd_shell

shell_L0:
  mov d, s_sol1
  call _puts
  mov al, 18
  syscall sys_filesystem        ; print current path
  mov d, s_hash
  call _puts
  mov d, shell_input_buff
  mov a, d
  mov [prog], a      ; reset tokenizer buffer pointer
  call _gets            ; get command
  call cmd_parser
  jmp shell_L0

cmd_parser:
  call get_token          ; get command into tokstr
  mov di, commands
  cla
  mov [parser_index], a    ; reset commands index
parser_L0:
  mov si, tokstr
  call _strcmp
  je parser_cmd_equal
parser_L0_L0:
  lea d, [di + 0]
  cmp byte[d], 0
  je parser_L0_L0_exit      ; run through the keyword until finding NULL
  add di, 1
  jmp parser_L0_L0
parser_L0_L0_exit:
  add di, 1        ; then skip NULL byte at the end 
  mov a, [parser_index]
  add a, 2
  mov [parser_index], a      ; increase commands table index
  lea d, [di + 0]
  cmp byte[d], 0
  je parser_cmd_not_found
  jmp parser_L0
parser_cmd_equal:
  call printnl
  mov a, [parser_index]      ; get the keyword pointer
  call [a + keyword_ptrs]    ; execute command
  call printnl
parser_retry:
  call get_token
  cmp byte[tok], TOK_SEMI
  je cmd_parser
  call _putback
  ret
parser_cmd_not_found:
  call _putback
  call cmd_exec      ; execute as file/program
  jmp parser_retry    ; check for more commands
  ret

; inputs:
; D = filename ptr
; SI = entry name ptr
; DI = output value string ptr
read_config:
  push di
  push si
  mov di, shell_transient_area
  mov al, 20
  syscall sys_filesystem        ; read entire config file
  mov a, shell_transient_area
  mov [prog], a
  pop si
read_config_L0:
  call get_token
  cmp byte[tok], TOK_END
  je read_config_EOF
  mov di, tokstr
  call _strcmp
  je read_config_found_entry
read_config_L0_L0:
  call get_token
  cmp byte[tok], TOK_SEMI
  je read_config_L0
  jmp read_config_L0_L0
read_config_found_entry:
  call get_token      ; bypass '=' sign
  pop di
  mov a, [prog]
  mov si, a
read_conf_L1:
  lodsb
  cmp al, $3B        ; ';'
  je read_config_EOF_2
  stosb
  jmp read_conf_L1
read_config_EOF:
  pop di
read_config_EOF_2:
  mov al, 0
  stosb          ; terminate value with NULL
  ret

;  sol shell
cmd_shell:
  call get_path
  mov d, tokstr
  mov di, shell_transient_area
  mov al, 20
  syscall sys_filesystem        ; read textfile 
  
  mov d, shell_transient_area
  mov a, d
  mov [prog], a      ; reset tokenizer buffer pointer
  call cmd_parser

  call printnl
  ret

  

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; CD
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; search for given directory inside current dir
; if found, read its LBA, and switch directories
; example:  cd /usr/bin; ls
;       cd /usr/bin;
;      cd /usr/bin
cmd_cd:
  call get_token
  mov al, [tok]
  cmp al, TOK_END
  je cmd_cd_gotohome
  cmp al, TOK_SEMI
  je cmd_cd_gotohome
  cmp al, TOK_TILDE
  je cmd_cd_gotohome
  call _putback
  call get_path    ; get the path for the cd command
cmd_cd_syscall:
  mov d, tokstr
  mov al, 19
  syscall sys_filesystem  ; get dirID in A
  cmp a, $FFFF
  je cmd_cd_fail
  mov b, a
  mov al, 3
  syscall sys_filesystem  ; set dir to B

; apply 'ls' to the directory
	mov al, 4
	syscall sys_filesystem
  ret
cmd_cd_gotohome:
  call _putback
  mov si, homedir
  mov di, tokstr
  call _strcpy
  jmp cmd_cd_syscall
cmd_cd_fail:
  ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; EXEC/OPEN PROGRAM/FILE
;; 'filename' maps to '$path/filename'
;; './file' or '/a/directory/file' loads a file directly
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
cmd_exec:
  cmp byte[tok], TOK_END
  je cmd_exec_ret    ; check for NULL input
  call get_path    ; get file path 
  mov a, [prog]
  push a        ; save argument pointer
  mov si, tokstr
  mov di, temp_data1
  call _strcpy      ; copy filename for later
  cmp byte[tokstr], '/'  ; check first character of path
  je cmd_exec_abs
  cmp byte[tokstr], '.'  ; check first character of path
  je cmd_exec_abs
  mov a, path
  mov [prog], a    ; set token pointer to $path beginning
cmd_exec_L0:
  call get_path    ; get a path option
  mov si, tokstr
  mov di, temp_data
  call _strcpy      ; firstly, form address from one of the '$path' addresses
  mov si, s_fslash
  mov di, temp_data
  call _strcat      ; add '/' in between $path component and filename
  mov si, temp_data1
  mov di, temp_data
  call _strcat      ; now glue the given filename to the total path
  mov d, temp_data
  mov al, 21
  syscall sys_filesystem  ; now we check whether such a file exists. success code is given in A. if 0, file does not exist
  cmp a, 0
  jne cmd_exec_path_exists
  call get_token
  cmp byte[tok], TOK_SEMI
  jne cmd_exec_L0    ; if not ';' at the end, then token must be a separator. so try another path
  jmp cmd_exec_unknown
cmd_exec_path_exists:
  pop a        ; retrieve token pointer which points to the arguments given
  mov [prog], a
  call get_arg    ; if however, $path/filename was found, then we execute it
  mov b, tokstr
  mov d, temp_data
  syscall sys_spawn_proc
  ret
cmd_exec_abs:  ; execute as absolute path
  pop a
  mov [prog], a
  call get_arg
  mov b, tokstr
  mov d, temp_data1  ;original filename
  syscall sys_spawn_proc
cmd_exec_ret:
  ret
cmd_exec_unknown:
  pop a
  ret

cmd_fg:
  call get_token
  mov al, [tokstr]
  sub al, $30
  syscall sys_resume_proc
  ret

commands:         
  .db "cd", 0
  .db "fg", 0
  .db "shell", 0
  .db 0

keyword_ptrs:     
  .dw cmd_cd
  .dw cmd_fg
  .dw cmd_shell

homedir:          .fill 128, 0
path:             .fill 128, 0    ; $path environment variable 

s_etc_shellrc:    .db "/etc/.shellrc", 0
s_etc_config:     .db "/etc/shell.cfg", 0
s_home:           .db "home", 0
s_path:           .db "path", 0

s_rebooting:      .db "\033[2J\033[H", "Now Rebooting...", 0
s_hash:           .db " # ", 0
s_fslash:         .db "/", 0
s_sol1:           .db "Sol-1:", 0, 0

shell_input_buff: .fill 512, 0
parser_index:     .dw 0

temp_data1:       .fill 512, 0
temp_data:        .fill 512, 0

.include "lib/stdio.asm"
.include "lib/ctype.asm"
.include "lib/token.asm"

shell_transient_area:  ; shell transient data area

.end
