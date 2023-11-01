; --- FILENAME: ../solarium/usr/bin/shell
.include "lib/kernel.exp"
.include "lib/bios.exp"
.org text_org

; --- BEGIN TEXT BLOCK
main:
  mov bp, $FFE0 ;
  mov sp, $FFE0 ; Make space for argc(2 bytes) and for 10 pointers in argv (local variables)
; $p 
; $t 
; $temp_prog 
; $varname 
; $is_assignment 
; $variable_str 
; $variable_int 
; $var_index 
; $i 
  sub sp, 142
;; set_string_var("path", "                                                                "); // 64 
  mov b, __s0 ; "path"
  swp b
  push b
  mov b, __s1 ; "                                                                "
  swp b
  push b
  call set_string_var
  add sp, 4
;; set_string_var("home", "                                                                "); // 64 
  mov b, __s2 ; "home"
  swp b
  push b
  mov b, __s1 ; "                                                                "
  swp b
  push b
  call set_string_var
  add sp, 4
;; read_config("/etc/shell.cfg", "path", variables[0].as_string); 
  mov b, __s3 ; "/etc/shell.cfg"
  swp b
  push b
  mov b, __s0 ; "path"
  swp b
  push b
  mov d, _variables_data ; $variables
  push a         
  mov b, $0        
  mma 21 ; mov a, 21; mul a, b; add d, b
  pop a
  add d, 17
  clb
  mov b, [d]
  swp b
  push b
  call read_config
  add sp, 6
;; read_config("/etc/shell.cfg", "home", variables[1].as_string); 
  mov b, __s3 ; "/etc/shell.cfg"
  swp b
  push b
  mov b, __s2 ; "home"
  swp b
  push b
  mov d, _variables_data ; $variables
  push a         
  mov b, $1        
  mma 21 ; mov a, 21; mul a, b; add d, b
  pop a
  add d, 17
  clb
  mov b, [d]
  swp b
  push b
  call read_config
  add sp, 6
;; for(;;){ 
_for1_init:
_for1_cond:
_for1_block:
;; printf("root@Sol-1:");  
  mov b, __s4 ; "root@Sol-1:"
  swp b
  push b
  call printf
  add sp, 2
;; print_cwd();  
  call print_cwd
;; printf(" # "); 
  mov b, __s5 ; " # "
  swp b
  push b
  call printf
  add sp, 2
;; gets(command); 
  mov b, _command_data ; $command           
  swp b
  push b
  call gets
  add sp, 2
;; print("\n\r"); 
  mov b, __s6 ; "\n\r"
  swp b
  push b
  call print
  add sp, 2
;; if(command[0]) strcpy(last_cmd, command); 
_if2_cond:
  mov d, _command_data ; $command
  push a         
  mov b, $0        
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  cmp b, 0
  je _if2_exit
_if2_true:
;; strcpy(last_cmd, command); 
  mov b, _last_cmd_data ; $last_cmd           
  swp b
  push b
  mov b, _command_data ; $command           
  swp b
  push b
  call strcpy
  add sp, 4
  jmp _if2_exit
_if2_exit:
;; prog = command; 
  mov d, _prog ; $prog         
  mov b, _command_data ; $command                   
  mov [d], b
;; for(;;){ 
_for3_init:
_for3_cond:
_for3_block:
;; temp_prog = prog; 
  lea d, [bp + -5] ; $temp_prog         
  mov b, [_prog] ; $prog                   
  mov [d], b
;; get(); 
  call get
;; if(tok == SEMICOLON) get(); 
_if4_cond:
  mov b, [_tok] ; $tok           
; START RELATIONAL
  push a
  mov a, b
  mov b, 35; SEMICOLON
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if4_exit
_if4_true:
;; get(); 
  call get
  jmp _if4_exit
_if4_exit:
;; if(toktype == END) break; // check for empty input 
_if5_cond:
  mov b, [_toktype] ; $toktype           
; START RELATIONAL
  push a
  mov a, b
  mov b, 6; END
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if5_exit
_if5_true:
;; break; // check for empty input 
  jmp _for3_exit ; for break
  jmp _if5_exit
_if5_exit:
;; is_assignment = 0; 
  lea d, [bp + -7] ; $is_assignment         
  mov b, $0        
  mov [d], bl
;; if(toktype == IDENTIFIER){ 
_if6_cond:
  mov b, [_toktype] ; $toktype           
; START RELATIONAL
  push a
  mov a, b
  mov b, 5; IDENTIFIER
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if6_exit
_if6_true:
;; strcpy(varname, token); 
  mov bl, [bp + -6] ; $varname
  mov bh, 0             
  swp b
  push b
  mov b, _token_data ; $token           
  swp b
  push b
  call strcpy
  add sp, 4
;; get(); 
  call get
;; is_assignment = tok == ASSIGNMENT; 
  lea d, [bp + -7] ; $is_assignment         
  mov b, [_tok] ; $tok           
; START RELATIONAL
  push a
  mov a, b
  mov b, 17; ASSIGNMENT
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL        
  mov [d], bl
  jmp _if6_exit
_if6_exit:
;; if(is_assignment){ 
_if7_cond:
  mov bl, [bp + -7] ; $is_assignment
  mov bh, 0             
  cmp b, 0
  je _if7_else
_if7_true:
;; get(); 
  call get
;; if(toktype == INTEGER_CONST) set_int_var(varname, atoi(token)); 
_if8_cond:
  mov b, [_toktype] ; $toktype           
; START RELATIONAL
  push a
  mov a, b
  mov b, 4; INTEGER_CONST
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if8_else
_if8_true:
;; set_int_var(varname, atoi(token)); 
  mov bl, [bp + -6] ; $varname
  mov bh, 0             
  swp b
  push b
  mov b, _token_data ; $token           
  swp b
  push b
  call atoi
  add sp, 2
  swp b
  push b
  call set_int_var
  add sp, 4
  jmp _if8_exit
_if8_else:
;; if(toktype == STRING_CONST) set_string_var(varname, string_const); 
_if9_cond:
  mov b, [_toktype] ; $toktype           
; START RELATIONAL
  push a
  mov a, b
  mov b, 3; STRING_CONST
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if9_else
_if9_true:
;; set_string_var(varname, string_const); 
  mov bl, [bp + -6] ; $varname
  mov bh, 0             
  swp b
  push b
  mov b, _string_const_data ; $string_const           
  swp b
  push b
  call set_string_var
  add sp, 4
  jmp _if9_exit
_if9_else:
;; if(toktype == IDENTIFIER) set_string_var(varname, token); 
_if10_cond:
  mov b, [_toktype] ; $toktype           
; START RELATIONAL
  push a
  mov a, b
  mov b, 5; IDENTIFIER
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if10_exit
_if10_true:
;; set_string_var(varname, token); 
  mov bl, [bp + -6] ; $varname
  mov bh, 0             
  swp b
  push b
  mov b, _token_data ; $token           
  swp b
  push b
  call set_string_var
  add sp, 4
  jmp _if10_exit
_if10_exit:
_if9_exit:
_if8_exit:
  jmp _if7_exit
_if7_else:
;; prog = temp_prog; 
  mov d, _prog ; $prog         
  mov b, [bp + -5] ; $temp_prog                     
  mov [d], b
;; get(); 
  call get
;; if(!strcmp(token, "cd")) command_cd(); 
_if11_cond:
  mov b, _token_data ; $token           
  swp b
  push b
  mov b, __s7 ; "cd"
  swp b
  push b
  call strcmp
  add sp, 4
  cmp b, 0
  seq ; !
  cmp b, 0
  je _if11_else
_if11_true:
;; command_cd(); 
  call command_cd
  jmp _if11_exit
_if11_else:
;; if(!strcmp(token, "shell")) command_shell(); 
_if12_cond:
  mov b, _token_data ; $token           
  swp b
  push b
  mov b, __s8 ; "shell"
  swp b
  push b
  call strcmp
  add sp, 4
  cmp b, 0
  seq ; !
  cmp b, 0
  je _if12_else
_if12_true:
;; command_shell(); 
  call command_shell
  jmp _if12_exit
_if12_else:
;; back(); 
  call back
;; get_path(); 
  call get_path
;; strcpy(path, token); // save file path 
  mov b, _path_data ; $path           
  swp b
  push b
  mov b, _token_data ; $token           
  swp b
  push b
  call strcpy
  add sp, 4
;; for(i = 0; i < 256; i++) argument[i] = 0; 
_for13_init:
  lea d, [bp + -141] ; $i         
  mov b, $0        
  mov [d], b
_for13_cond:
  mov b, [bp + -141] ; $i             
; START RELATIONAL
  push a
  mov a, b
  mov b, $100
  cmp a, b
  slt ; < 
  pop a
; END RELATIONAL
  cmp b, 0
  je _for13_exit
_for13_block:
;; argument[i] = 0; 
  mov d, _argument_data ; $argument
  push a         
  mov b, [bp + -141] ; $i                     
  add d, b
  pop a         
  mov b, $0        
  mov [d], bl
_for13_update:
  mov b, [bp + -141] ; $i             
  mov g, b
  inc b
  lea d, [bp + -141] ; $i
  mov [d], b
  mov b, g
  jmp _for13_cond
_for13_exit:
;; get(); 
  call get
;; if(tok != SEMICOLON && toktype != END){ 
_if14_cond:
  mov b, [_tok] ; $tok           
; START RELATIONAL
  push a
  mov a, b
  mov b, 35; SEMICOLON
  cmp a, b
  sneq ; !=
  pop a
; END RELATIONAL
  push a
  mov a, b
  mov b, [_toktype] ; $toktype           
; START RELATIONAL
  push a
  mov a, b
  mov b, 6; END
  cmp a, b
  sneq ; !=
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  cmp b, 0
  je _if14_exit
_if14_true:
;; back(); 
  call back
;; p = argument; 
  lea d, [bp + -1] ; $p         
  mov b, _argument_data ; $argument                   
  mov [d], b
;; do{ 
_do15_block:
;; if(*prog == '$'){ 
_if16_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $24
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if16_else
_if16_true:
;; prog++; 
  mov b, [_prog] ; $prog           
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
;; get(); // get variable name 
  call get
;; var_index = get_var_index(token); 
  lea d, [bp + -139] ; $var_index
  push d
  mov b, _token_data ; $token           
  swp b
  push b
  call get_var_index
  add sp, 2
  pop d
  mov [d], b
;; if(var_index != -1){ 
_if17_cond:
  mov b, [bp + -139] ; $var_index             
; START RELATIONAL
  push a
  mov a, b
  mov b, $1
  neg b
  cmp a, b
  sneq ; !=
  pop a
; END RELATIONAL
  cmp b, 0
  je _if17_exit
_if17_true:
;; if(get_var_type(token) == SHELL_VAR_TYP_INT) strcat(argument, "123"); 
_if18_cond:
  mov b, _token_data ; $token           
  swp b
  push b
  call get_var_type
  add sp, 2
; START RELATIONAL
  push a
  mov a, b
  mov b, 1; SHELL_VAR_TYP_INT
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if18_else
_if18_true:
;; strcat(argument, "123"); 
  mov b, _argument_data ; $argument           
  swp b
  push b
  mov b, __s9 ; "123"
  swp b
  push b
  call strcat
  add sp, 4
  jmp _if18_exit
_if18_else:
;; if(get_var_type(token) == SHELL_VAR_TYP_STR) strcat(argument, get_shell_var_strval(var_index)); 
_if19_cond:
  mov b, _token_data ; $token           
  swp b
  push b
  call get_var_type
  add sp, 2
; START RELATIONAL
  push a
  mov a, b
  mov b, 0; SHELL_VAR_TYP_STR
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if19_exit
_if19_true:
;; strcat(argument, get_shell_var_strval(var_index)); 
  mov b, _argument_data ; $argument           
  swp b
  push b
  mov b, [bp + -139] ; $var_index             
  swp b
  push b
  call get_shell_var_strval
  add sp, 2
  swp b
  push b
  call strcat
  add sp, 4
  jmp _if19_exit
_if19_exit:
_if18_exit:
;; while(*p) p++; 
_while20_cond:
  mov b, [bp + -1] ; $p             
  mov d, b
  mov bl, [d]
  mov bh, 0
  cmp b, 0
  je _while20_exit
_while20_block:
;; p++; 
  mov b, [bp + -1] ; $p             
  mov g, b
  inc b
  lea d, [bp + -1] ; $p
  mov [d], b
  mov b, g
  jmp _while20_cond
_while20_exit:
  jmp _if17_exit
_if17_exit:
  jmp _if16_exit
_if16_else:
;; *p++ = *prog++; 
  mov b, [bp + -1] ; $p             
  mov g, b
  inc b
  lea d, [bp + -1] ; $p
  mov [d], b
  mov b, g
  push b
  mov b, [_prog] ; $prog           
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
_if16_exit:
;; } while(*prog != '\0' && *prog != ';'); 
_do15_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  sneq ; !=
  pop a
; END RELATIONAL
  push a
  mov a, b
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $3b
  cmp a, b
  sneq ; !=
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  cmp b, 1
  je _do15_block
_do15_exit:
;; *p = '\0'; 
  mov b, [bp + -1] ; $p             
  push b
  mov b, $0
  pop d
  mov [d], bl
  jmp _if14_exit
_if14_exit:
;; if(*path == '/' || *path == '.') spawn_new_proc(path, argument); 
_if21_cond:
  mov b, _path_data ; $path           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $2f
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  push a
  mov a, b
  mov b, _path_data ; $path           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $2e
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  pop a
  cmp b, 0
  je _if21_else
_if21_true:
;; spawn_new_proc(path, argument); 
  mov b, _path_data ; $path           
  swp b
  push b
  mov b, _argument_data ; $argument           
  swp b
  push b
  call spawn_new_proc
  add sp, 4
  jmp _if21_exit
_if21_else:
;; temp_prog = prog; 
  lea d, [bp + -5] ; $temp_prog         
  mov b, [_prog] ; $prog                   
  mov [d], b
;; prog = variables[0].as_string; 
  mov d, _prog ; $prog
  push d
  mov d, _variables_data ; $variables
  push a         
  mov b, $0        
  mma 21 ; mov a, 21; mul a, b; add d, b
  pop a
  add d, 17
  clb
  mov b, [d]
  pop d
  mov [d], b
;; for(;;){ 
_for22_init:
_for22_cond:
_for22_block:
;; get(); 
  call get
;; if(toktype == END){ 
_if23_cond:
  mov b, [_toktype] ; $toktype           
; START RELATIONAL
  push a
  mov a, b
  mov b, 6; END
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if23_else
_if23_true:
;; break; 
  jmp _for22_exit ; for break
  jmp _if23_exit
_if23_else:
;; back(); 
  call back
_if23_exit:
;; get_path(); 
  call get_path
;; strcpy(temp, token); 
  mov b, _temp_data ; $temp           
  swp b
  push b
  mov b, _token_data ; $token           
  swp b
  push b
  call strcpy
  add sp, 4
;; strcat(temp, "/"); 
  mov b, _temp_data ; $temp           
  swp b
  push b
  mov b, __s10 ; "/"
  swp b
  push b
  call strcat
  add sp, 4
;; strcat(temp, path); // form full filepath with ENV_PATH + given filename 
  mov b, _temp_data ; $temp           
  swp b
  push b
  mov b, _path_data ; $path           
  swp b
  push b
  call strcat
  add sp, 4
;; if(file_exists(temp) != 0){ 
_if24_cond:
  mov b, _temp_data ; $temp           
  swp b
  push b
  call file_exists
  add sp, 2
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  sneq ; !=
  pop a
; END RELATIONAL
  cmp b, 0
  je _if24_exit
_if24_true:
;; spawn_new_proc(temp, argument); 
  mov b, _temp_data ; $temp           
  swp b
  push b
  mov b, _argument_data ; $argument           
  swp b
  push b
  call spawn_new_proc
  add sp, 4
;; break; 
  jmp _for22_exit ; for break
  jmp _if24_exit
_if24_exit:
;; get(); // get separator 
  call get
_for22_update:
  jmp _for22_cond
_for22_exit:
;; prog = temp_prog; 
  mov d, _prog ; $prog         
  mov b, [bp + -5] ; $temp_prog                     
  mov [d], b
_if21_exit:
_if12_exit:
_if11_exit:
_if7_exit:
_for3_update:
  jmp _for3_cond
_for3_exit:
_for1_update:
  jmp _for1_cond
_for1_exit:
  syscall sys_terminate_proc

include_ctype_lib:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM BLOCK
.include "lib/ctype.asm"
; --- END INLINE ASM BLOCK

  leave
  ret

is_space:
  enter 0 ; (push bp; mov bp, sp)
;; return c == ' ' || c == '\t' || c == '\n' || c == '\r'; 
  mov bl, [bp + 5] ; $c
  mov bh, 0             
; START RELATIONAL
  push a
  mov a, b
  mov b, $20
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  push a
  mov a, b
  mov bl, [bp + 5] ; $c
  mov bh, 0             
; START RELATIONAL
  push a
  mov a, b
  mov b, $9
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  mov bl, [bp + 5] ; $c
  mov bh, 0             
; START RELATIONAL
  push a
  mov a, b
  mov b, $a
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  mov bl, [bp + 5] ; $c
  mov bh, 0             
; START RELATIONAL
  push a
  mov a, b
  mov b, $d
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  pop a
  leave
  ret

is_digit:
  enter 0 ; (push bp; mov bp, sp)
;; return c >= '0' && c <= '9'; 
  mov bl, [bp + 5] ; $c
  mov bh, 0             
; START RELATIONAL
  push a
  mov a, b
  mov b, $30
  cmp a, b
  sge ; >=
  pop a
; END RELATIONAL
  push a
  mov a, b
  mov bl, [bp + 5] ; $c
  mov bh, 0             
; START RELATIONAL
  push a
  mov a, b
  mov b, $39
  cmp a, b
  sle ; <=
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  leave
  ret

is_alpha:
  enter 0 ; (push bp; mov bp, sp)
;; return(c >= 'a' && c <= 'z' || c >= 'A' && c <= 'Z' || c == '_'); 
  mov bl, [bp + 5] ; $c
  mov bh, 0             
; START RELATIONAL
  push a
  mov a, b
  mov b, $61
  cmp a, b
  sge ; >=
  pop a
; END RELATIONAL
  push a
  mov a, b
  mov bl, [bp + 5] ; $c
  mov bh, 0             
; START RELATIONAL
  push a
  mov a, b
  mov b, $7a
  cmp a, b
  sle ; <=
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  push a
  mov a, b
  mov bl, [bp + 5] ; $c
  mov bh, 0             
; START RELATIONAL
  push a
  mov a, b
  mov b, $41
  cmp a, b
  sge ; >=
  pop a
; END RELATIONAL
  push a
  mov a, b
  mov bl, [bp + 5] ; $c
  mov bh, 0             
; START RELATIONAL
  push a
  mov a, b
  mov b, $5a
  cmp a, b
  sle ; <=
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  sor a, b ; ||
  mov a, b
  mov bl, [bp + 5] ; $c
  mov bh, 0             
; START RELATIONAL
  push a
  mov a, b
  mov b, $5f
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  pop a
  leave
  ret

is_delimiter:
  enter 0 ; (push bp; mov bp, sp)
;; if( 
_if25_cond:
  mov bl, [bp + 5] ; $c
  mov bh, 0             
; START RELATIONAL
  push a
  mov a, b
  mov b, $40
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  push a
  mov a, b
  mov bl, [bp + 5] ; $c
  mov bh, 0             
; START RELATIONAL
  push a
  mov a, b
  mov b, $23
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  mov bl, [bp + 5] ; $c
  mov bh, 0             
; START RELATIONAL
  push a
  mov a, b
  mov b, $24
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  mov bl, [bp + 5] ; $c
  mov bh, 0             
; START RELATIONAL
  push a
  mov a, b
  mov b, $2b
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  mov bl, [bp + 5] ; $c
  mov bh, 0             
; START RELATIONAL
  push a
  mov a, b
  mov b, $2d
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  mov bl, [bp + 5] ; $c
  mov bh, 0             
; START RELATIONAL
  push a
  mov a, b
  mov b, $2a
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  mov bl, [bp + 5] ; $c
  mov bh, 0             
; START RELATIONAL
  push a
  mov a, b
  mov b, $2f
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  mov bl, [bp + 5] ; $c
  mov bh, 0             
; START RELATIONAL
  push a
  mov a, b
  mov b, $25
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  mov bl, [bp + 5] ; $c
  mov bh, 0             
; START RELATIONAL
  push a
  mov a, b
  mov b, $5b
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  mov bl, [bp + 5] ; $c
  mov bh, 0             
; START RELATIONAL
  push a
  mov a, b
  mov b, $5d
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  mov bl, [bp + 5] ; $c
  mov bh, 0             
; START RELATIONAL
  push a
  mov a, b
  mov b, $28
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  mov bl, [bp + 5] ; $c
  mov bh, 0             
; START RELATIONAL
  push a
  mov a, b
  mov b, $29
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  mov bl, [bp + 5] ; $c
  mov bh, 0             
; START RELATIONAL
  push a
  mov a, b
  mov b, $7b
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  mov bl, [bp + 5] ; $c
  mov bh, 0             
; START RELATIONAL
  push a
  mov a, b
  mov b, $7d
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  mov bl, [bp + 5] ; $c
  mov bh, 0             
; START RELATIONAL
  push a
  mov a, b
  mov b, $3a
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  mov bl, [bp + 5] ; $c
  mov bh, 0             
; START RELATIONAL
  push a
  mov a, b
  mov b, $3b
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  mov bl, [bp + 5] ; $c
  mov bh, 0             
; START RELATIONAL
  push a
  mov a, b
  mov b, $3c
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  mov bl, [bp + 5] ; $c
  mov bh, 0             
; START RELATIONAL
  push a
  mov a, b
  mov b, $3e
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  mov bl, [bp + 5] ; $c
  mov bh, 0             
; START RELATIONAL
  push a
  mov a, b
  mov b, $3d
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  mov bl, [bp + 5] ; $c
  mov bh, 0             
; START RELATIONAL
  push a
  mov a, b
  mov b, $21
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  mov bl, [bp + 5] ; $c
  mov bh, 0             
; START RELATIONAL
  push a
  mov a, b
  mov b, $5e
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  mov bl, [bp + 5] ; $c
  mov bh, 0             
; START RELATIONAL
  push a
  mov a, b
  mov b, $26
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  mov bl, [bp + 5] ; $c
  mov bh, 0             
; START RELATIONAL
  push a
  mov a, b
  mov b, $7c
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  mov bl, [bp + 5] ; $c
  mov bh, 0             
; START RELATIONAL
  push a
  mov a, b
  mov b, $7e
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  mov bl, [bp + 5] ; $c
  mov bh, 0             
; START RELATIONAL
  push a
  mov a, b
  mov b, $2e
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  pop a
  cmp b, 0
  je _if25_else
_if25_true:
;; return 1; 
  mov b, $1
  leave
  ret
  jmp _if25_exit
_if25_else:
;; return 0; 
  mov b, $0
  leave
  ret
_if25_exit:
  leave
  ret

strcpy:
  enter 0 ; (push bp; mov bp, sp)
; $psrc 
; $pdest 
  sub sp, 4
;; psrc = src; 
  lea d, [bp + -1] ; $psrc         
  mov b, [bp + 5] ; $src                     
  mov [d], b
;; pdest = dest; 
  lea d, [bp + -3] ; $pdest         
  mov b, [bp + 7] ; $dest                     
  mov [d], b
;; while(*psrc) *pdest++ = *psrc++; 
_while26_cond:
  mov b, [bp + -1] ; $psrc             
  mov d, b
  mov bl, [d]
  mov bh, 0
  cmp b, 0
  je _while26_exit
_while26_block:
;; *pdest++ = *psrc++; 
  mov b, [bp + -3] ; $pdest             
  mov g, b
  inc b
  lea d, [bp + -3] ; $pdest
  mov [d], b
  mov b, g
  push b
  mov b, [bp + -1] ; $psrc             
  mov g, b
  inc b
  lea d, [bp + -1] ; $psrc
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
  jmp _while26_cond
_while26_exit:
;; *pdest = '\0'; 
  mov b, [bp + -3] ; $pdest             
  push b
  mov b, $0
  pop d
  mov [d], bl
  leave
  ret

strcmp:
  enter 0 ; (push bp; mov bp, sp)
;; while (*s1 && (*s1 == *s2)) { 
_while27_cond:
  mov b, [bp + 7] ; $s1             
  mov d, b
  mov bl, [d]
  mov bh, 0
  push a
  mov a, b
  mov b, [bp + 7] ; $s1             
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, [bp + 5] ; $s2             
  mov d, b
  mov bl, [d]
  mov bh, 0
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  cmp b, 0
  je _while27_exit
_while27_block:
;; s1++; 
  mov b, [bp + 7] ; $s1             
  mov g, b
  inc b
  lea d, [bp + 7] ; $s1
  mov [d], b
  mov b, g
;; s2++; 
  mov b, [bp + 5] ; $s2             
  mov g, b
  inc b
  lea d, [bp + 5] ; $s2
  mov [d], b
  mov b, g
  jmp _while27_cond
_while27_exit:
;; return *s1 - *s2; 
  mov b, [bp + 7] ; $s1             
  mov d, b
  mov bl, [d]
  mov bh, 0
; START TERMS
  push a
  mov a, b
  mov b, [bp + 5] ; $s2             
  mov d, b
  mov bl, [d]
  mov bh, 0
  sub a, b
  mov b, a
  pop a
; END TERMS
  leave
  ret

strcat:
  enter 0 ; (push bp; mov bp, sp)
; $dest_len 
; $i 
  sub sp, 4
;; dest_len = strlen(dest); 
  lea d, [bp + -1] ; $dest_len
  push d
  mov b, [bp + 7] ; $dest             
  swp b
  push b
  call strlen
  add sp, 2
  pop d
  mov [d], b
;; for (i = 0; src[i] != 0; i=i+1) { 
_for28_init:
  lea d, [bp + -3] ; $i         
  mov b, $0        
  mov [d], b
_for28_cond:
  lea d, [bp + 5] ; $src
  mov d, [d]
  push a         
  mov b, [bp + -3] ; $i                     
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  sneq ; !=
  pop a
; END RELATIONAL
  cmp b, 0
  je _for28_exit
_for28_block:
;; dest[dest_len + i] = src[i]; 
  lea d, [bp + 7] ; $dest
  mov d, [d]
  push a         
  mov b, [bp + -1] ; $dest_len             
; START TERMS
  push a
  mov a, b
  mov b, [bp + -3] ; $i             
  add a, b
  mov b, a
  pop a
; END TERMS        
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  push d
  lea d, [bp + 5] ; $src
  mov d, [d]
  push a         
  mov b, [bp + -3] ; $i                     
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
_for28_update:
  lea d, [bp + -3] ; $i         
  mov b, [bp + -3] ; $i             
; START TERMS
  push a
  mov a, b
  mov b, $1
  add a, b
  mov b, a
  pop a
; END TERMS        
  mov [d], b
  jmp _for28_cond
_for28_exit:
;; dest[dest_len + i] = 0; 
  lea d, [bp + 7] ; $dest
  mov d, [d]
  push a         
  mov b, [bp + -1] ; $dest_len             
; START TERMS
  push a
  mov a, b
  mov b, [bp + -3] ; $i             
  add a, b
  mov b, a
  pop a
; END TERMS        
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a         
  mov b, $0        
  mov [d], bl
;; return dest; 
  mov b, [bp + 7] ; $dest             
  leave
  ret

strlen:
  enter 0 ; (push bp; mov bp, sp)
; $length 
  sub sp, 2
;; length = 0; 
  lea d, [bp + -1] ; $length         
  mov b, $0        
  mov [d], b
;; while (str[length] != 0) { 
_while29_cond:
  lea d, [bp + 5] ; $str
  mov d, [d]
  push a         
  mov b, [bp + -1] ; $length                     
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  sneq ; !=
  pop a
; END RELATIONAL
  cmp b, 0
  je _while29_exit
_while29_block:
;; length++; 
  mov b, [bp + -1] ; $length             
  mov g, b
  inc b
  lea d, [bp + -1] ; $length
  mov [d], b
  mov b, g
  jmp _while29_cond
_while29_exit:
;; return length; 
  mov b, [bp + -1] ; $length             
  leave
  ret

va_arg:
  enter 0 ; (push bp; mov bp, sp)
; $val 
  sub sp, 2
;; if(size == 1){ 
_if30_cond:
  mov b, [bp + 5] ; $size             
; START RELATIONAL
  push a
  mov a, b
  mov b, $1
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if30_else
_if30_true:
;; val = *(char*)arg->p; 
  lea d, [bp + -1] ; $val
  push d
  lea d, [bp + 7] ; $arg
  mov d, [d]
  add d, 0
  clb
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], b
  jmp _if30_exit
_if30_else:
;; if(size == 2){ 
_if31_cond:
  mov b, [bp + 5] ; $size             
; START RELATIONAL
  push a
  mov a, b
  mov b, $2
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if31_else
_if31_true:
;; val = *(int*)arg->p; 
  lea d, [bp + -1] ; $val
  push d
  lea d, [bp + 7] ; $arg
  mov d, [d]
  add d, 0
  clb
  mov b, [d]
  mov d, b
  mov b, [d]
  pop d
  mov [d], b
  jmp _if31_exit
_if31_else:
;; print("Unknown type size in va_arg() call. Size needs to be either 1 or 2."); 
  mov b, __s11 ; "Unknown type size in va_arg() call. Size needs to be either 1 or 2."
  swp b
  push b
  call print
  add sp, 2
_if31_exit:
_if30_exit:
;; arg->p = arg->p + size; 
  lea d, [bp + 7] ; $arg
  mov d, [d]
  add d, 0
  clb
  push d
  lea d, [bp + 7] ; $arg
  mov d, [d]
  add d, 0
  clb
  mov b, [d]
; START TERMS
  push a
  mov a, b
  mov b, [bp + 5] ; $size             
  add a, b
  mov b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; return val; 
  mov b, [bp + -1] ; $val             
  leave
  ret

printf:
  enter 0 ; (push bp; mov bp, sp)
; $p 
; $fp 
; $i 
  sub sp, 6
;; fp = format; 
  lea d, [bp + -3] ; $fp         
  mov b, [bp + 5] ; $format                     
  mov [d], b
;; p = &format; 
  lea d, [bp + -1] ; $p
  push d
  lea d, [bp + 5] ; $format
  mov b, d
  pop d
  mov [d], b
;; for(;;){ 
_for32_init:
_for32_cond:
_for32_block:
;; if(!*fp) break; 
_if33_cond:
  mov b, [bp + -3] ; $fp             
  mov d, b
  mov bl, [d]
  mov bh, 0
  cmp b, 0
  seq ; !
  cmp b, 0
  je _if33_exit
_if33_true:
;; break; 
  jmp _for32_exit ; for break
  jmp _if33_exit
_if33_exit:
;; if(*fp == '%'){ 
_if34_cond:
  mov b, [bp + -3] ; $fp             
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $25
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if34_else
_if34_true:
;; fp++; 
  mov b, [bp + -3] ; $fp             
  mov g, b
  inc b
  lea d, [bp + -3] ; $fp
  mov [d], b
  mov b, g
;; switch(*fp){ 
_switch35_expr:
  mov b, [bp + -3] ; $fp             
  mov d, b
  mov bl, [d]
  mov bh, 0
_switch35_comparisons:
  cmp bl, $64
  je _switch35_case0
  cmp bl, $69
  je _switch35_case1
  cmp bl, $75
  je _switch35_case2
  cmp bl, $78
  je _switch35_case3
  cmp bl, $63
  je _switch35_case4
  cmp bl, $73
  je _switch35_case5
  jmp _switch35_default
  jmp _switch35_exit
_switch35_case0:
_switch35_case1:
;; p = p - 2; 
  lea d, [bp + -1] ; $p         
  mov b, [bp + -1] ; $p             
; START TERMS
  push a
  mov a, b
  mov b, $2
  sub a, b
  mov b, a
  pop a
; END TERMS        
  mov [d], b
;; prints(*(int*)p); 
  mov b, [bp + -1] ; $p             
  mov d, b
  mov b, [d]
  swp b
  push b
  call prints
  add sp, 2
;; break; 
  jmp _switch35_exit ; case break
_switch35_case2:
;; p = p - 2; 
  lea d, [bp + -1] ; $p         
  mov b, [bp + -1] ; $p             
; START TERMS
  push a
  mov a, b
  mov b, $2
  sub a, b
  mov b, a
  pop a
; END TERMS        
  mov [d], b
;; printu(*(unsigned int*)p); 
  mov b, [bp + -1] ; $p             
  mov d, b
  mov b, [d]
  swp b
  push b
  call printu
  add sp, 2
;; break; 
  jmp _switch35_exit ; case break
_switch35_case3:
;; p = p - 2; 
  lea d, [bp + -1] ; $p         
  mov b, [bp + -1] ; $p             
; START TERMS
  push a
  mov a, b
  mov b, $2
  sub a, b
  mov b, a
  pop a
; END TERMS        
  mov [d], b
;; printx16(*(unsigned int*)p); 
  mov b, [bp + -1] ; $p             
  mov d, b
  mov b, [d]
  swp b
  push b
  call printx16
  add sp, 2
;; break; 
  jmp _switch35_exit ; case break
_switch35_case4:
;; p = p - 2; 
  lea d, [bp + -1] ; $p         
  mov b, [bp + -1] ; $p             
; START TERMS
  push a
  mov a, b
  mov b, $2
  sub a, b
  mov b, a
  pop a
; END TERMS        
  mov [d], b
;; putchar(*(char*)p); 
  mov b, [bp + -1] ; $p             
  mov d, b
  mov bl, [d]
  mov bh, 0
  push bl
  call putchar
  add sp, 1
;; break; 
  jmp _switch35_exit ; case break
_switch35_case5:
;; p = p - 2; 
  lea d, [bp + -1] ; $p         
  mov b, [bp + -1] ; $p             
; START TERMS
  push a
  mov a, b
  mov b, $2
  sub a, b
  mov b, a
  pop a
; END TERMS        
  mov [d], b
;; print(*(char**)p); 
  mov b, [bp + -1] ; $p             
  mov d, b
  mov b, [d]
  swp b
  push b
  call print
  add sp, 2
;; break; 
  jmp _switch35_exit ; case break
_switch35_default:
;; print("Error: Unknown argument type.\n"); 
  mov b, __s12 ; "Error: Unknown argument type.\n"
  swp b
  push b
  call print
  add sp, 2
_switch35_exit:
;; fp++; 
  mov b, [bp + -3] ; $fp             
  mov g, b
  inc b
  lea d, [bp + -3] ; $fp
  mov [d], b
  mov b, g
  jmp _if34_exit
_if34_else:
;; putchar(*fp); 
  mov b, [bp + -3] ; $fp             
  mov d, b
  mov bl, [d]
  mov bh, 0
  push bl
  call putchar
  add sp, 1
;; fp++; 
  mov b, [bp + -3] ; $fp             
  mov g, b
  inc b
  lea d, [bp + -3] ; $fp
  mov [d], b
  mov b, g
_if34_exit:
_for32_update:
  jmp _for32_cond
_for32_exit:
  leave
  ret

printx16:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM BLOCK
  mov b, [bp + 5] ; $hex             
  call print_u16x
; --- END INLINE ASM BLOCK

  leave
  ret

printx8:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM BLOCK
  lea d, [bp + 5] ; $hex
  mov bl, [d]
  call print_u8x
; --- END INLINE ASM BLOCK

  leave
  ret

hex_to_int:
  enter 0 ; (push bp; mov bp, sp)
; $value 
  mov a, $0
  mov [bp + -1], a
; $i 
; $hex_char 
; $len 
  sub sp, 7
;; len = strlen(hex_string); 
  lea d, [bp + -6] ; $len
  push d
  mov b, [bp + 5] ; $hex_string             
  swp b
  push b
  call strlen
  add sp, 2
  pop d
  mov [d], b
;; for (i = 0; i < len; i++) { 
_for36_init:
  lea d, [bp + -3] ; $i         
  mov b, $0        
  mov [d], b
_for36_cond:
  mov b, [bp + -3] ; $i             
; START RELATIONAL
  push a
  mov a, b
  mov b, [bp + -6] ; $len             
  cmp a, b
  slt ; < 
  pop a
; END RELATIONAL
  cmp b, 0
  je _for36_exit
_for36_block:
;; hex_char = hex_string[i]; 
  lea d, [bp + -4] ; $hex_char
  push d
  lea d, [bp + 5] ; $hex_string
  mov d, [d]
  push a         
  mov b, [bp + -3] ; $i                     
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; if (hex_char >= 'a' && hex_char <= 'f')  
_if37_cond:
  mov bl, [bp + -4] ; $hex_char
  mov bh, 0             
; START RELATIONAL
  push a
  mov a, b
  mov b, $61
  cmp a, b
  sge ; >=
  pop a
; END RELATIONAL
  push a
  mov a, b
  mov bl, [bp + -4] ; $hex_char
  mov bh, 0             
; START RELATIONAL
  push a
  mov a, b
  mov b, $66
  cmp a, b
  sle ; <=
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  cmp b, 0
  je _if37_else
_if37_true:
;; value = (value * 16) + (hex_char - 'a' + 10); 
  lea d, [bp + -1] ; $value         
  mov b, [bp + -1] ; $value             
; START FACTORS
  push a
  mov a, b
  mov b, $10
  mul a, b ; *
  mov a, b
  mov b, a
  pop a
; END FACTORS
; START TERMS
  push a
  mov a, b
  mov bl, [bp + -4] ; $hex_char
  mov bh, 0             
; START TERMS
  push a
  mov a, b
  mov b, $61
  sub a, b
  mov b, $a
  add a, b
  mov b, a
  pop a
; END TERMS
  add a, b
  mov b, a
  pop a
; END TERMS        
  mov [d], b
  jmp _if37_exit
_if37_else:
;; if (hex_char >= 'A' && hex_char <= 'F')  
_if38_cond:
  mov bl, [bp + -4] ; $hex_char
  mov bh, 0             
; START RELATIONAL
  push a
  mov a, b
  mov b, $41
  cmp a, b
  sge ; >=
  pop a
; END RELATIONAL
  push a
  mov a, b
  mov bl, [bp + -4] ; $hex_char
  mov bh, 0             
; START RELATIONAL
  push a
  mov a, b
  mov b, $46
  cmp a, b
  sle ; <=
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  cmp b, 0
  je _if38_else
_if38_true:
;; value = (value * 16) + (hex_char - 'A' + 10); 
  lea d, [bp + -1] ; $value         
  mov b, [bp + -1] ; $value             
; START FACTORS
  push a
  mov a, b
  mov b, $10
  mul a, b ; *
  mov a, b
  mov b, a
  pop a
; END FACTORS
; START TERMS
  push a
  mov a, b
  mov bl, [bp + -4] ; $hex_char
  mov bh, 0             
; START TERMS
  push a
  mov a, b
  mov b, $41
  sub a, b
  mov b, $a
  add a, b
  mov b, a
  pop a
; END TERMS
  add a, b
  mov b, a
  pop a
; END TERMS        
  mov [d], b
  jmp _if38_exit
_if38_else:
;; value = (value * 16) + (hex_char - '0'); 
  lea d, [bp + -1] ; $value         
  mov b, [bp + -1] ; $value             
; START FACTORS
  push a
  mov a, b
  mov b, $10
  mul a, b ; *
  mov a, b
  mov b, a
  pop a
; END FACTORS
; START TERMS
  push a
  mov a, b
  mov bl, [bp + -4] ; $hex_char
  mov bh, 0             
; START TERMS
  push a
  mov a, b
  mov b, $30
  sub a, b
  mov b, a
  pop a
; END TERMS
  add a, b
  mov b, a
  pop a
; END TERMS        
  mov [d], b
_if38_exit:
_if37_exit:
_for36_update:
  mov b, [bp + -3] ; $i             
  mov g, b
  inc b
  lea d, [bp + -3] ; $i
  mov [d], b
  mov b, g
  jmp _for36_cond
_for36_exit:
;; return value; 
  mov b, [bp + -1] ; $value             
  leave
  ret

atoi:
  enter 0 ; (push bp; mov bp, sp)
; $result 
  mov a, $0
  mov [bp + -1], a
; $sign 
  mov a, $1
  mov [bp + -3], a
  sub sp, 4
;; while (*str == ' ') str++; 
_while39_cond:
  mov b, [bp + 5] ; $str             
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $20
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _while39_exit
_while39_block:
;; str++; 
  mov b, [bp + 5] ; $str             
  mov g, b
  inc b
  lea d, [bp + 5] ; $str
  mov [d], b
  mov b, g
  jmp _while39_cond
_while39_exit:
;; if (*str == '-' || *str == '+') { 
_if40_cond:
  mov b, [bp + 5] ; $str             
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $2d
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  push a
  mov a, b
  mov b, [bp + 5] ; $str             
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $2b
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  pop a
  cmp b, 0
  je _if40_exit
_if40_true:
;; if (*str == '-') sign = -1; 
_if41_cond:
  mov b, [bp + 5] ; $str             
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $2d
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if41_exit
_if41_true:
;; sign = -1; 
  lea d, [bp + -3] ; $sign         
  mov b, $1
  neg b        
  mov [d], b
  jmp _if41_exit
_if41_exit:
;; str++; 
  mov b, [bp + 5] ; $str             
  mov g, b
  inc b
  lea d, [bp + 5] ; $str
  mov [d], b
  mov b, g
  jmp _if40_exit
_if40_exit:
;; while (*str >= '0' && *str <= '9') { 
_while42_cond:
  mov b, [bp + 5] ; $str             
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $30
  cmp a, b
  sge ; >=
  pop a
; END RELATIONAL
  push a
  mov a, b
  mov b, [bp + 5] ; $str             
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $39
  cmp a, b
  sle ; <=
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  cmp b, 0
  je _while42_exit
_while42_block:
;; result = result * 10 + (*str - '0'); 
  lea d, [bp + -1] ; $result
  push d
  mov b, [bp + -1] ; $result             
; START FACTORS
  push a
  mov a, b
  mov b, $a
  mul a, b ; *
  mov a, b
  mov b, a
  pop a
; END FACTORS
; START TERMS
  push a
  mov a, b
  mov b, [bp + 5] ; $str             
  mov d, b
  mov bl, [d]
  mov bh, 0
; START TERMS
  push a
  mov a, b
  mov b, $30
  sub a, b
  mov b, a
  pop a
; END TERMS
  add a, b
  mov b, a
  pop a
; END TERMS
  pop d
  mov [d], b
;; str++; 
  mov b, [bp + 5] ; $str             
  mov g, b
  inc b
  lea d, [bp + 5] ; $str
  mov [d], b
  mov b, g
  jmp _while42_cond
_while42_exit:
;; return sign * result; 
  mov b, [bp + -3] ; $sign             
; START FACTORS
  push a
  mov a, b
  mov b, [bp + -1] ; $result             
  mul a, b ; *
  mov a, b
  mov b, a
  pop a
; END FACTORS
  leave
  ret

gets:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM BLOCK
  mov a, [bp + 5] ; $s             
  mov d, a
  call _gets
; --- END INLINE ASM BLOCK

;; return strlen(s); 
  mov b, [bp + 5] ; $s             
  swp b
  push b
  call strlen
  add sp, 2
  leave
  ret

prints:
  enter 0 ; (push bp; mov bp, sp)
; $digits 
; $i 
  mov a, $0
  mov [bp + -6], a
  sub sp, 7
;; if (num < 0) { 
_if43_cond:
  mov b, [bp + 5] ; $num             
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  slt ; < 
  pop a
; END RELATIONAL
  cmp b, 0
  je _if43_else
_if43_true:
;; putchar('-'); 
  mov b, $2d
  push bl
  call putchar
  add sp, 1
;; num = -num; 
  lea d, [bp + 5] ; $num         
  mov b, [bp + 5] ; $num             
  neg b        
  mov [d], b
  jmp _if43_exit
_if43_else:
;; if (num == 0) { 
_if44_cond:
  mov b, [bp + 5] ; $num             
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if44_exit
_if44_true:
;; putchar('0'); 
  mov b, $30
  push bl
  call putchar
  add sp, 1
;; return; 
  leave
  ret
  jmp _if44_exit
_if44_exit:
_if43_exit:
;; while (num > 0) { 
_while45_cond:
  mov b, [bp + 5] ; $num             
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  sgt ; >
  pop a
; END RELATIONAL
  cmp b, 0
  je _while45_exit
_while45_block:
;; digits[i] = '0' + (num % 10); 
  lea d, [bp + -4] ; $digits
  push a         
  mov b, [bp + -6] ; $i                     
  add d, b
  pop a         
  mov b, $30
; START TERMS
  push a
  mov a, b
  mov b, [bp + 5] ; $num             
; START FACTORS
  push a
  mov a, b
  mov b, $a
  div a, b ; 
  mov a, b
  mov b, a
  pop a
; END FACTORS
  add a, b
  mov b, a
  pop a
; END TERMS        
  mov [d], bl
;; num = num / 10; 
  lea d, [bp + 5] ; $num         
  mov b, [bp + 5] ; $num             
; START FACTORS
  push a
  mov a, b
  mov b, $a
  div a, b
  mov b, a
  pop a
; END FACTORS        
  mov [d], b
;; i++; 
  mov b, [bp + -6] ; $i             
  mov g, b
  inc b
  lea d, [bp + -6] ; $i
  mov [d], b
  mov b, g
  jmp _while45_cond
_while45_exit:
;; while (i > 0) { 
_while46_cond:
  mov b, [bp + -6] ; $i             
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  sgt ; >
  pop a
; END RELATIONAL
  cmp b, 0
  je _while46_exit
_while46_block:
;; i--; 
  mov b, [bp + -6] ; $i             
  mov g, b
  dec b
  lea d, [bp + -6] ; $i
  mov [d], b
  mov b, g
;; putchar(digits[i]); 
  lea d, [bp + -4] ; $digits
  push a         
  mov b, [bp + -6] ; $i                     
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  push bl
  call putchar
  add sp, 1
  jmp _while46_cond
_while46_exit:
  leave
  ret

printu:
  enter 0 ; (push bp; mov bp, sp)
; $digits 
; $i 
  sub sp, 7
;; i = 0; 
  lea d, [bp + -6] ; $i         
  mov b, $0        
  mov [d], b
;; if(num == 0){ 
_if47_cond:
  mov b, [bp + 5] ; $num             
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if47_exit
_if47_true:
;; putchar('0'); 
  mov b, $30
  push bl
  call putchar
  add sp, 1
;; return; 
  leave
  ret
  jmp _if47_exit
_if47_exit:
;; while (num > 0) { 
_while48_cond:
  mov b, [bp + 5] ; $num             
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  sgu ; > (unsigned)
  pop a
; END RELATIONAL
  cmp b, 0
  je _while48_exit
_while48_block:
;; digits[i] = '0' + (num % 10); 
  lea d, [bp + -4] ; $digits
  push a         
  mov b, [bp + -6] ; $i                     
  add d, b
  pop a         
  mov b, $30
; START TERMS
  push a
  mov a, b
  mov b, [bp + 5] ; $num             
; START FACTORS
  push a
  mov a, b
  mov b, $a
  div a, b ; 
  mov a, b
  mov b, a
  pop a
; END FACTORS
  add a, b
  mov b, a
  pop a
; END TERMS        
  mov [d], bl
;; num = num / 10; 
  lea d, [bp + 5] ; $num         
  mov b, [bp + 5] ; $num             
; START FACTORS
  push a
  mov a, b
  mov b, $a
  div a, b
  mov b, a
  pop a
; END FACTORS        
  mov [d], b
;; i++; 
  mov b, [bp + -6] ; $i             
  mov g, b
  inc b
  lea d, [bp + -6] ; $i
  mov [d], b
  mov b, g
  jmp _while48_cond
_while48_exit:
;; while (i > 0) { 
_while49_cond:
  mov b, [bp + -6] ; $i             
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  sgt ; >
  pop a
; END RELATIONAL
  cmp b, 0
  je _while49_exit
_while49_block:
;; i--; 
  mov b, [bp + -6] ; $i             
  mov g, b
  dec b
  lea d, [bp + -6] ; $i
  mov [d], b
  mov b, g
;; putchar(digits[i]); 
  lea d, [bp + -4] ; $digits
  push a         
  mov b, [bp + -6] ; $i                     
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  push bl
  call putchar
  add sp, 1
  jmp _while49_cond
_while49_exit:
  leave
  ret

rand:
  enter 0 ; (push bp; mov bp, sp)
; $sec 
  sub sp, 1

; --- BEGIN INLINE ASM BLOCK
  mov al, 0
  syscall sys_rtc					
  mov al, ah
  mov al, [bp + 0] ; $sec
            
; --- END INLINE ASM BLOCK

;; return sec; 
  mov bl, [bp + 0] ; $sec
  mov bh, 0             
  leave
  ret

date:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM BLOCK
  mov al, 0 
  syscall sys_datetime
; --- END INLINE ASM BLOCK

  leave
  ret

putchar:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM BLOCK
  mov al, [bp + 5] ; $c
            
  mov ah, al
  call _putchar
; --- END INLINE ASM BLOCK

  leave
  ret

getchar:
  enter 0 ; (push bp; mov bp, sp)
; $c 
  sub sp, 1

; --- BEGIN INLINE ASM BLOCK
  call getch
  mov al, ah
  lea d, [bp + 0] ; $c
  mov [d], al
; --- END INLINE ASM BLOCK

;; return c; 
  mov bl, [bp + 0] ; $c
  mov bh, 0             
  leave
  ret

scann:
  enter 0 ; (push bp; mov bp, sp)
; $m 
  sub sp, 2

; --- BEGIN INLINE ASM BLOCK
  call scan_u16d
  lea d, [bp + -1] ; $m
  mov [d], a
; --- END INLINE ASM BLOCK

;; return m; 
  mov b, [bp + -1] ; $m             
  leave
  ret

puts:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM BLOCK
  mov a, [bp + 5] ; $s             
  mov d, a
  call _puts
  mov ah, $0A
  mov al, 0
  syscall sys_io
; --- END INLINE ASM BLOCK

  leave
  ret

print:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM BLOCK
  mov a, [bp + 5] ; $s             
  mov d, a
  call _puts
; --- END INLINE ASM BLOCK

  leave
  ret

loadfile:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM BLOCK
  mov a, [bp + 5] ; $destination             
  mov di, a
  lea d, [bp + 7] ; $filename
  mov d, [d]
  mov al, 20
  syscall sys_filesystem
; --- END INLINE ASM BLOCK

  leave
  ret

create_file:
  enter 0 ; (push bp; mov bp, sp)
  leave
  ret

delete_file:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM BLOCK
  lea d, [bp + 5] ; $filename
  mov al, 10
  syscall sys_filesystem
; --- END INLINE ASM BLOCK

  leave
  ret

fopen:
  enter 0 ; (push bp; mov bp, sp)
  leave
  ret

fclose:
  enter 0 ; (push bp; mov bp, sp)
  leave
  ret

alloc:
  enter 0 ; (push bp; mov bp, sp)
;; heap_top = heap_top + bytes; 
  mov d, _heap_top ; $heap_top         
  mov b, [_heap_top] ; $heap_top           
; START TERMS
  push a
  mov a, b
  mov b, [bp + 5] ; $bytes             
  add a, b
  mov b, a
  pop a
; END TERMS        
  mov [d], b
;; return heap_top - bytes; 
  mov b, [_heap_top] ; $heap_top           
; START TERMS
  push a
  mov a, b
  mov b, [bp + 5] ; $bytes             
  sub a, b
  mov b, a
  pop a
; END TERMS
  leave
  ret

free:
  enter 0 ; (push bp; mov bp, sp)
;; return heap_top = heap_top - bytes; 
  mov d, _heap_top ; $heap_top         
  mov b, [_heap_top] ; $heap_top           
; START TERMS
  push a
  mov a, b
  mov b, [bp + 5] ; $bytes             
  sub a, b
  mov b, a
  pop a
; END TERMS        
  mov [d], b
  leave
  ret

exit:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM BLOCK
  syscall sys_terminate_proc
; --- END INLINE ASM BLOCK

  leave
  ret

load_hex:
  enter 0 ; (push bp; mov bp, sp)
; $temp 
  sub sp, 2
;; temp = alloc(32768); 
  lea d, [bp + -1] ; $temp
  push d
  mov b, $8000
  swp b
  push b
  call alloc
  add sp, 2
  pop d
  mov [d], b

; --- BEGIN INLINE ASM BLOCK
  
  
  
  
  
_load_hex:
  push a
  push b
  push d
  push si
  push di
  sub sp, $8000      
  mov c, 0
  mov a, sp
  inc a
  mov d, a          
  call _gets        
  mov si, a
__load_hex_loop:
  lodsb             
  cmp al, 0         
  jz __load_hex_ret
  mov bh, al
  lodsb
  mov bl, al
  call _atoi        
  stosb             
  inc c
  jmp __load_hex_loop
__load_hex_ret:
  add sp, $8000
  pop di
  pop si
  pop d
  pop b
  pop a
; --- END INLINE ASM BLOCK

  leave
  ret

getparam:
  enter 0 ; (push bp; mov bp, sp)
; $data 
  sub sp, 1

; --- BEGIN INLINE ASM BLOCK
  mov al, 4
  lea d, [bp + 5] ; $address
  mov d, [d]
  syscall sys_system
  lea d, [bp + 0] ; $data
  mov [d], bl
; --- END INLINE ASM BLOCK

;; return data; 
  mov bl, [bp + 0] ; $data
  mov bh, 0             
  leave
  ret

include_stdio_asm:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM BLOCK
.include "lib/stdio.asm"
; --- END INLINE ASM BLOCK

  leave
  ret

back:
  enter 0 ; (push bp; mov bp, sp)
; $t 
  sub sp, 2
;; t = token; 
  lea d, [bp + -1] ; $t         
  mov b, _token_data ; $token                   
  mov [d], b
;; while(*t++) prog--; 
_while50_cond:
  mov b, [bp + -1] ; $t             
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  cmp b, 0
  je _while50_exit
_while50_block:
;; prog--; 
  mov b, [_prog] ; $prog           
  mov g, b
  dec b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  jmp _while50_cond
_while50_exit:
;; tok = TOK_UNDEF; 
  mov d, _tok ; $tok         
  mov b, 0; TOK_UNDEF        
  mov [d], b
;; toktype = TYPE_UNDEF; 
  mov d, _toktype ; $toktype         
  mov b, 0; TYPE_UNDEF        
  mov [d], b
;; token[0] = '\0'; 
  mov d, _token_data ; $token
  push a         
  mov b, $0        
  add d, b
  pop a         
  mov b, $0        
  mov [d], bl
  leave
  ret

get_path:
  enter 0 ; (push bp; mov bp, sp)
; $t 
  sub sp, 2
;; *token = '\0'; 
  mov b, _token_data ; $token           
  push b
  mov b, $0
  pop d
  mov [d], bl
;; t = token; 
  lea d, [bp + -1] ; $t         
  mov b, _token_data ; $token                   
  mov [d], b
;; while(is_space(*prog)) prog++; 
_while51_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
  push bl
  call is_space
  add sp, 1
  cmp b, 0
  je _while51_exit
_while51_block:
;; prog++; 
  mov b, [_prog] ; $prog           
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  jmp _while51_cond
_while51_exit:
;; if(*prog == '\0'){ 
_if52_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if52_exit
_if52_true:
;; return; 
  leave
  ret
  jmp _if52_exit
_if52_exit:
;; while( 
_while53_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $61
  cmp a, b
  sge ; >=
  pop a
; END RELATIONAL
  push a
  mov a, b
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $7a
  cmp a, b
  sle ; <=
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  push a
  mov a, b
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $41
  cmp a, b
  sge ; >=
  pop a
; END RELATIONAL
  push a
  mov a, b
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $5a
  cmp a, b
  sle ; <=
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  sor a, b ; ||
  mov a, b
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $30
  cmp a, b
  sge ; >=
  pop a
; END RELATIONAL
  push a
  mov a, b
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $39
  cmp a, b
  sle ; <=
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  sor a, b ; ||
  mov a, b
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $2f
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $5f
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $2d
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $2e
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  pop a
  cmp b, 0
  je _while53_exit
_while53_block:
;; *t++ = *prog++; 
  mov b, [bp + -1] ; $t             
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov b, [_prog] ; $prog           
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
  jmp _while53_cond
_while53_exit:
;; *t = '\0'; 
  mov b, [bp + -1] ; $t             
  push b
  mov b, $0
  pop d
  mov [d], bl
  leave
  ret

get:
  enter 0 ; (push bp; mov bp, sp)
; $t 
  sub sp, 2
;; *token = '\0'; 
  mov b, _token_data ; $token           
  push b
  mov b, $0
  pop d
  mov [d], bl
;; tok = 0; 
  mov d, _tok ; $tok         
  mov b, $0        
  mov [d], b
;; toktype = 0; 
  mov d, _toktype ; $toktype         
  mov b, $0        
  mov [d], b
;; t = token; 
  lea d, [bp + -1] ; $t         
  mov b, _token_data ; $token                   
  mov [d], b
;; while(is_space(*prog)) prog++; 
_while54_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
  push bl
  call is_space
  add sp, 1
  cmp b, 0
  je _while54_exit
_while54_block:
;; prog++; 
  mov b, [_prog] ; $prog           
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  jmp _while54_cond
_while54_exit:
;; if(*prog == '\0'){ 
_if55_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if55_exit
_if55_true:
;; toktype = END; 
  mov d, _toktype ; $toktype         
  mov b, 6; END        
  mov [d], b
;; return; 
  leave
  ret
  jmp _if55_exit
_if55_exit:
;; if(is_digit(*prog)){ 
_if56_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
  push bl
  call is_digit
  add sp, 1
  cmp b, 0
  je _if56_else
_if56_true:
;; while(is_digit(*prog)){ 
_while57_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
  push bl
  call is_digit
  add sp, 1
  cmp b, 0
  je _while57_exit
_while57_block:
;; *t++ = *prog++; 
  mov b, [bp + -1] ; $t             
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov b, [_prog] ; $prog           
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
  jmp _while57_cond
_while57_exit:
;; *t = '\0'; 
  mov b, [bp + -1] ; $t             
  push b
  mov b, $0
  pop d
  mov [d], bl
;; toktype = INTEGER_CONST; 
  mov d, _toktype ; $toktype         
  mov b, 4; INTEGER_CONST        
  mov [d], b
;; return; // return to avoid *t = '\0' line at the end of function 
  leave
  ret
  jmp _if56_exit
_if56_else:
;; if(is_alpha(*prog)){ 
_if58_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
  push bl
  call is_alpha
  add sp, 1
  cmp b, 0
  je _if58_else
_if58_true:
;; while(is_alpha(*prog) || is_digit(*prog)){ 
_while59_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
  push bl
  call is_alpha
  add sp, 1
  push a
  mov a, b
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
  push bl
  call is_digit
  add sp, 1
  sor a, b ; ||
  pop a
  cmp b, 0
  je _while59_exit
_while59_block:
;; *t++ = *prog++; 
  mov b, [bp + -1] ; $t             
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov b, [_prog] ; $prog           
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
  jmp _while59_cond
_while59_exit:
;; *t = '\0'; 
  mov b, [bp + -1] ; $t             
  push b
  mov b, $0
  pop d
  mov [d], bl
;; toktype = IDENTIFIER; 
  mov d, _toktype ; $toktype         
  mov b, 5; IDENTIFIER        
  mov [d], b
  jmp _if58_exit
_if58_else:
;; if(*prog == '\"'){ 
_if60_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $22
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if60_else
_if60_true:
;; *t++ = '\"'; 
  mov b, [bp + -1] ; $t             
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov b, $22
  pop d
  mov [d], bl
;; prog++; 
  mov b, [_prog] ; $prog           
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
;; while(*prog != '\"' && *prog){ 
_while61_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $22
  cmp a, b
  sneq ; !=
  pop a
; END RELATIONAL
  push a
  mov a, b
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
  sand a, b ; &&
  pop a
  cmp b, 0
  je _while61_exit
_while61_block:
;; *t++ = *prog++; 
  mov b, [bp + -1] ; $t             
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov b, [_prog] ; $prog           
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
  jmp _while61_cond
_while61_exit:
;; if(*prog != '\"') error("Double quotes expected"); 
_if62_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $22
  cmp a, b
  sneq ; !=
  pop a
; END RELATIONAL
  cmp b, 0
  je _if62_exit
_if62_true:
;; error("Double quotes expected"); 
  mov b, __s13 ; "Double quotes expected"
  swp b
  push b
  call error
  add sp, 2
  jmp _if62_exit
_if62_exit:
;; *t++ = '\"'; 
  mov b, [bp + -1] ; $t             
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov b, $22
  pop d
  mov [d], bl
;; prog++; 
  mov b, [_prog] ; $prog           
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
;; toktype = STRING_CONST; 
  mov d, _toktype ; $toktype         
  mov b, 3; STRING_CONST        
  mov [d], b
;; *t = '\0'; 
  mov b, [bp + -1] ; $t             
  push b
  mov b, $0
  pop d
  mov [d], bl
;; convert_constant(); // converts this string token qith quotation marks to a non quotation marks string, and also converts escape sequences to their real bytes 
  call convert_constant
  jmp _if60_exit
_if60_else:
;; if(*prog == '#'){ 
_if63_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $23
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if63_else
_if63_true:
;; *t++ = *prog++; 
  mov b, [bp + -1] ; $t             
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov b, [_prog] ; $prog           
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = HASH; 
  mov d, _tok ; $tok         
  mov b, 21; HASH        
  mov [d], b
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype         
  mov b, 1; DELIMITER        
  mov [d], b
  jmp _if63_exit
_if63_else:
;; if(*prog == '{'){ 
_if64_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $7b
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if64_else
_if64_true:
;; *t++ = *prog++; 
  mov b, [bp + -1] ; $t             
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov b, [_prog] ; $prog           
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = OPENING_BRACE; 
  mov d, _tok ; $tok         
  mov b, 30; OPENING_BRACE        
  mov [d], b
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype         
  mov b, 1; DELIMITER        
  mov [d], b
  jmp _if64_exit
_if64_else:
;; if(*prog == '}'){ 
_if65_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $7d
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if65_else
_if65_true:
;; *t++ = *prog++; 
  mov b, [bp + -1] ; $t             
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov b, [_prog] ; $prog           
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = CLOSING_BRACE; 
  mov d, _tok ; $tok         
  mov b, 31; CLOSING_BRACE        
  mov [d], b
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype         
  mov b, 1; DELIMITER        
  mov [d], b
  jmp _if65_exit
_if65_else:
;; if(*prog == '['){ 
_if66_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $5b
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if66_else
_if66_true:
;; *t++ = *prog++; 
  mov b, [bp + -1] ; $t             
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov b, [_prog] ; $prog           
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = OPENING_BRACKET; 
  mov d, _tok ; $tok         
  mov b, 32; OPENING_BRACKET        
  mov [d], b
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype         
  mov b, 1; DELIMITER        
  mov [d], b
  jmp _if66_exit
_if66_else:
;; if(*prog == ']'){ 
_if67_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $5d
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if67_else
_if67_true:
;; *t++ = *prog++; 
  mov b, [bp + -1] ; $t             
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov b, [_prog] ; $prog           
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = CLOSING_BRACKET; 
  mov d, _tok ; $tok         
  mov b, 33; CLOSING_BRACKET        
  mov [d], b
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype         
  mov b, 1; DELIMITER        
  mov [d], b
  jmp _if67_exit
_if67_else:
;; if(*prog == '='){ 
_if68_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $3d
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if68_else
_if68_true:
;; *t++ = *prog++; 
  mov b, [bp + -1] ; $t             
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov b, [_prog] ; $prog           
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; if (*prog == '='){ 
_if69_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $3d
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if69_else
_if69_true:
;; *t++ = *prog++; 
  mov b, [bp + -1] ; $t             
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov b, [_prog] ; $prog           
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = EQUAL; 
  mov d, _tok ; $tok         
  mov b, 8; EQUAL        
  mov [d], b
  jmp _if69_exit
_if69_else:
;; tok = ASSIGNMENT; 
  mov d, _tok ; $tok         
  mov b, 17; ASSIGNMENT        
  mov [d], b
_if69_exit:
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype         
  mov b, 1; DELIMITER        
  mov [d], b
  jmp _if68_exit
_if68_else:
;; if(*prog == '&'){ 
_if70_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $26
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if70_else
_if70_true:
;; *t++ = *prog++; 
  mov b, [bp + -1] ; $t             
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov b, [_prog] ; $prog           
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; if(*prog == '&'){ 
_if71_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $26
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if71_else
_if71_true:
;; *t++ = *prog++; 
  mov b, [bp + -1] ; $t             
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov b, [_prog] ; $prog           
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = LOGICAL_AND; 
  mov d, _tok ; $tok         
  mov b, 14; LOGICAL_AND        
  mov [d], b
  jmp _if71_exit
_if71_else:
;; tok = AMPERSAND; 
  mov d, _tok ; $tok         
  mov b, 22; AMPERSAND        
  mov [d], b
_if71_exit:
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype         
  mov b, 1; DELIMITER        
  mov [d], b
  jmp _if70_exit
_if70_else:
;; if(*prog == '|'){ 
_if72_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $7c
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if72_else
_if72_true:
;; *t++ = *prog++; 
  mov b, [bp + -1] ; $t             
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov b, [_prog] ; $prog           
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; if (*prog == '|'){ 
_if73_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $7c
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if73_else
_if73_true:
;; *t++ = *prog++; 
  mov b, [bp + -1] ; $t             
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov b, [_prog] ; $prog           
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = LOGICAL_OR; 
  mov d, _tok ; $tok         
  mov b, 15; LOGICAL_OR        
  mov [d], b
  jmp _if73_exit
_if73_else:
;; tok = BITWISE_OR; 
  mov d, _tok ; $tok         
  mov b, 24; BITWISE_OR        
  mov [d], b
_if73_exit:
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype         
  mov b, 1; DELIMITER        
  mov [d], b
  jmp _if72_exit
_if72_else:
;; if(*prog == '~'){ 
_if74_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $7e
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if74_else
_if74_true:
;; *t++ = *prog++; 
  mov b, [bp + -1] ; $t             
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov b, [_prog] ; $prog           
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = BITWISE_NOT; 
  mov d, _tok ; $tok         
  mov b, 25; BITWISE_NOT        
  mov [d], b
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype         
  mov b, 1; DELIMITER        
  mov [d], b
  jmp _if74_exit
_if74_else:
;; if(*prog == '<'){ 
_if75_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $3c
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if75_else
_if75_true:
;; *t++ = *prog++; 
  mov b, [bp + -1] ; $t             
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov b, [_prog] ; $prog           
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; if (*prog == '='){ 
_if76_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $3d
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if76_else
_if76_true:
;; *t++ = *prog++; 
  mov b, [bp + -1] ; $t             
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov b, [_prog] ; $prog           
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = LESS_THAN_OR_EQUAL; 
  mov d, _tok ; $tok         
  mov b, 11; LESS_THAN_OR_EQUAL        
  mov [d], b
  jmp _if76_exit
_if76_else:
;; if (*prog == '<'){ 
_if77_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $3c
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if77_else
_if77_true:
;; *t++ = *prog++; 
  mov b, [bp + -1] ; $t             
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov b, [_prog] ; $prog           
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = BITWISE_SHL; 
  mov d, _tok ; $tok         
  mov b, 26; BITWISE_SHL        
  mov [d], b
  jmp _if77_exit
_if77_else:
;; tok = LESS_THAN; 
  mov d, _tok ; $tok         
  mov b, 10; LESS_THAN        
  mov [d], b
_if77_exit:
_if76_exit:
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype         
  mov b, 1; DELIMITER        
  mov [d], b
  jmp _if75_exit
_if75_else:
;; if(*prog == '>'){ 
_if78_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $3e
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if78_else
_if78_true:
;; *t++ = *prog++; 
  mov b, [bp + -1] ; $t             
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov b, [_prog] ; $prog           
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; if (*prog == '='){ 
_if79_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $3d
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if79_else
_if79_true:
;; *t++ = *prog++; 
  mov b, [bp + -1] ; $t             
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov b, [_prog] ; $prog           
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = GREATER_THAN_OR_EQUAL; 
  mov d, _tok ; $tok         
  mov b, 13; GREATER_THAN_OR_EQUAL        
  mov [d], b
  jmp _if79_exit
_if79_else:
;; if (*prog == '>'){ 
_if80_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $3e
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if80_else
_if80_true:
;; *t++ = *prog++; 
  mov b, [bp + -1] ; $t             
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov b, [_prog] ; $prog           
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = BITWISE_SHR; 
  mov d, _tok ; $tok         
  mov b, 27; BITWISE_SHR        
  mov [d], b
  jmp _if80_exit
_if80_else:
;; tok = GREATER_THAN; 
  mov d, _tok ; $tok         
  mov b, 12; GREATER_THAN        
  mov [d], b
_if80_exit:
_if79_exit:
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype         
  mov b, 1; DELIMITER        
  mov [d], b
  jmp _if78_exit
_if78_else:
;; if(*prog == '!'){ 
_if81_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $21
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if81_else
_if81_true:
;; *t++ = *prog++; 
  mov b, [bp + -1] ; $t             
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov b, [_prog] ; $prog           
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; if(*prog == '='){ 
_if82_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $3d
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if82_else
_if82_true:
;; *t++ = *prog++; 
  mov b, [bp + -1] ; $t             
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov b, [_prog] ; $prog           
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = NOT_EQUAL; 
  mov d, _tok ; $tok         
  mov b, 9; NOT_EQUAL        
  mov [d], b
  jmp _if82_exit
_if82_else:
;; tok = LOGICAL_NOT; 
  mov d, _tok ; $tok         
  mov b, 16; LOGICAL_NOT        
  mov [d], b
_if82_exit:
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype         
  mov b, 1; DELIMITER        
  mov [d], b
  jmp _if81_exit
_if81_else:
;; if(*prog == '+'){ 
_if83_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $2b
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if83_else
_if83_true:
;; *t++ = *prog++; 
  mov b, [bp + -1] ; $t             
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov b, [_prog] ; $prog           
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; if(*prog == '+'){ 
_if84_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $2b
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if84_else
_if84_true:
;; *t++ = *prog++; 
  mov b, [bp + -1] ; $t             
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov b, [_prog] ; $prog           
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = INCREMENT; 
  mov d, _tok ; $tok         
  mov b, 5; INCREMENT        
  mov [d], b
  jmp _if84_exit
_if84_else:
;; tok = PLUS; 
  mov d, _tok ; $tok         
  mov b, 1; PLUS        
  mov [d], b
_if84_exit:
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype         
  mov b, 1; DELIMITER        
  mov [d], b
  jmp _if83_exit
_if83_else:
;; if(*prog == '-'){ 
_if85_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $2d
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if85_else
_if85_true:
;; *t++ = *prog++; 
  mov b, [bp + -1] ; $t             
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov b, [_prog] ; $prog           
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; if(*prog == '-'){ 
_if86_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $2d
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if86_else
_if86_true:
;; *t++ = *prog++; 
  mov b, [bp + -1] ; $t             
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov b, [_prog] ; $prog           
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = DECREMENT; 
  mov d, _tok ; $tok         
  mov b, 6; DECREMENT        
  mov [d], b
  jmp _if86_exit
_if86_else:
;; tok = MINUS; 
  mov d, _tok ; $tok         
  mov b, 2; MINUS        
  mov [d], b
_if86_exit:
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype         
  mov b, 1; DELIMITER        
  mov [d], b
  jmp _if85_exit
_if85_else:
;; if(*prog == '$'){ 
_if87_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $24
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if87_else
_if87_true:
;; *t++ = *prog++; 
  mov b, [bp + -1] ; $t             
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov b, [_prog] ; $prog           
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = DOLLAR; 
  mov d, _tok ; $tok         
  mov b, 18; DOLLAR        
  mov [d], b
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype         
  mov b, 1; DELIMITER        
  mov [d], b
  jmp _if87_exit
_if87_else:
;; if(*prog == '^'){ 
_if88_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $5e
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if88_else
_if88_true:
;; *t++ = *prog++; 
  mov b, [bp + -1] ; $t             
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov b, [_prog] ; $prog           
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = BITWISE_XOR; 
  mov d, _tok ; $tok         
  mov b, 23; BITWISE_XOR        
  mov [d], b
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype         
  mov b, 1; DELIMITER        
  mov [d], b
  jmp _if88_exit
_if88_else:
;; if(*prog == '@'){ 
_if89_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $40
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if89_else
_if89_true:
;; *t++ = *prog++; 
  mov b, [bp + -1] ; $t             
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov b, [_prog] ; $prog           
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = AT; 
  mov d, _tok ; $tok         
  mov b, 20; AT        
  mov [d], b
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype         
  mov b, 1; DELIMITER        
  mov [d], b
  jmp _if89_exit
_if89_else:
;; if(*prog == '*'){ 
_if90_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $2a
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if90_else
_if90_true:
;; *t++ = *prog++; 
  mov b, [bp + -1] ; $t             
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov b, [_prog] ; $prog           
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = STAR; 
  mov d, _tok ; $tok         
  mov b, 3; STAR        
  mov [d], b
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype         
  mov b, 1; DELIMITER        
  mov [d], b
  jmp _if90_exit
_if90_else:
;; if(*prog == '/'){ 
_if91_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $2f
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if91_else
_if91_true:
;; *t++ = *prog++; 
  mov b, [bp + -1] ; $t             
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov b, [_prog] ; $prog           
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = FSLASH; 
  mov d, _tok ; $tok         
  mov b, 4; FSLASH        
  mov [d], b
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype         
  mov b, 1; DELIMITER        
  mov [d], b
  jmp _if91_exit
_if91_else:
;; if(*prog == '%'){ 
_if92_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $25
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if92_else
_if92_true:
;; *t++ = *prog++; 
  mov b, [bp + -1] ; $t             
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov b, [_prog] ; $prog           
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = MOD; 
  mov d, _tok ; $tok         
  mov b, 7; MOD        
  mov [d], b
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype         
  mov b, 1; DELIMITER        
  mov [d], b
  jmp _if92_exit
_if92_else:
;; if(*prog == '('){ 
_if93_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $28
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if93_else
_if93_true:
;; *t++ = *prog++; 
  mov b, [bp + -1] ; $t             
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov b, [_prog] ; $prog           
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = OPENING_PAREN; 
  mov d, _tok ; $tok         
  mov b, 28; OPENING_PAREN        
  mov [d], b
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype         
  mov b, 1; DELIMITER        
  mov [d], b
  jmp _if93_exit
_if93_else:
;; if(*prog == ')'){ 
_if94_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $29
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if94_else
_if94_true:
;; *t++ = *prog++; 
  mov b, [bp + -1] ; $t             
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov b, [_prog] ; $prog           
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = CLOSING_PAREN; 
  mov d, _tok ; $tok         
  mov b, 29; CLOSING_PAREN        
  mov [d], b
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype         
  mov b, 1; DELIMITER        
  mov [d], b
  jmp _if94_exit
_if94_else:
;; if(*prog == ';'){ 
_if95_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $3b
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if95_else
_if95_true:
;; *t++ = *prog++; 
  mov b, [bp + -1] ; $t             
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov b, [_prog] ; $prog           
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = SEMICOLON; 
  mov d, _tok ; $tok         
  mov b, 35; SEMICOLON        
  mov [d], b
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype         
  mov b, 1; DELIMITER        
  mov [d], b
  jmp _if95_exit
_if95_else:
;; if(*prog == ':'){ 
_if96_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $3a
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if96_else
_if96_true:
;; *t++ = *prog++; 
  mov b, [bp + -1] ; $t             
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov b, [_prog] ; $prog           
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = COLON; 
  mov d, _tok ; $tok         
  mov b, 34; COLON        
  mov [d], b
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype         
  mov b, 1; DELIMITER        
  mov [d], b
  jmp _if96_exit
_if96_else:
;; if(*prog == ','){ 
_if97_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $2c
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if97_else
_if97_true:
;; *t++ = *prog++; 
  mov b, [bp + -1] ; $t             
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov b, [_prog] ; $prog           
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = COMMA; 
  mov d, _tok ; $tok         
  mov b, 36; COMMA        
  mov [d], b
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype         
  mov b, 1; DELIMITER        
  mov [d], b
  jmp _if97_exit
_if97_else:
;; if(*prog == '.'){ 
_if98_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $2e
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if98_exit
_if98_true:
;; *t++ = *prog++; 
  mov b, [bp + -1] ; $t             
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov b, [_prog] ; $prog           
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; tok = DOT; 
  mov d, _tok ; $tok         
  mov b, 37; DOT        
  mov [d], b
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype         
  mov b, 1; DELIMITER        
  mov [d], b
  jmp _if98_exit
_if98_exit:
_if97_exit:
_if96_exit:
_if95_exit:
_if94_exit:
_if93_exit:
_if92_exit:
_if91_exit:
_if90_exit:
_if89_exit:
_if88_exit:
_if87_exit:
_if85_exit:
_if83_exit:
_if81_exit:
_if78_exit:
_if75_exit:
_if74_exit:
_if72_exit:
_if70_exit:
_if68_exit:
_if67_exit:
_if66_exit:
_if65_exit:
_if64_exit:
_if63_exit:
_if60_exit:
_if58_exit:
_if56_exit:
;; *t = '\0'; 
  mov b, [bp + -1] ; $t             
  push b
  mov b, $0
  pop d
  mov [d], bl
  leave
  ret

convert_constant:
  enter 0 ; (push bp; mov bp, sp)
; $s 
; $t 
  sub sp, 4
;; t = token; 
  lea d, [bp + -3] ; $t         
  mov b, _token_data ; $token                   
  mov [d], b
;; s = string_const; 
  lea d, [bp + -1] ; $s         
  mov b, _string_const_data ; $string_const                   
  mov [d], b
;; if(toktype == CHAR_CONST){ 
_if99_cond:
  mov b, [_toktype] ; $toktype           
; START RELATIONAL
  push a
  mov a, b
  mov b, 2; CHAR_CONST
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if99_else
_if99_true:
;; t++; 
  mov b, [bp + -3] ; $t             
  mov g, b
  inc b
  lea d, [bp + -3] ; $t
  mov [d], b
  mov b, g
;; if(*t == '\\'){ 
_if100_cond:
  mov b, [bp + -3] ; $t             
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $5c
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if100_else
_if100_true:
;; t++; 
  mov b, [bp + -3] ; $t             
  mov g, b
  inc b
  lea d, [bp + -3] ; $t
  mov [d], b
  mov b, g
;; switch(*t){ 
_switch101_expr:
  mov b, [bp + -3] ; $t             
  mov d, b
  mov bl, [d]
  mov bh, 0
_switch101_comparisons:
  cmp bl, $30
  je _switch101_case0
  cmp bl, $61
  je _switch101_case1
  cmp bl, $62
  je _switch101_case2
  cmp bl, $66
  je _switch101_case3
  cmp bl, $6e
  je _switch101_case4
  cmp bl, $72
  je _switch101_case5
  cmp bl, $74
  je _switch101_case6
  cmp bl, $76
  je _switch101_case7
  cmp bl, $5c
  je _switch101_case8
  cmp bl, $27
  je _switch101_case9
  cmp bl, $22
  je _switch101_case10
  jmp _switch101_exit
_switch101_case0:
;; *s++ = '\0'; 
  mov b, [bp + -1] ; $s             
  mov g, b
  inc b
  lea d, [bp + -1] ; $s
  mov [d], b
  mov b, g
  push b
  mov b, $0
  pop d
  mov [d], bl
;; break; 
  jmp _switch101_exit ; case break
_switch101_case1:
;; *s++ = '\a'; 
  mov b, [bp + -1] ; $s             
  mov g, b
  inc b
  lea d, [bp + -1] ; $s
  mov [d], b
  mov b, g
  push b
  mov b, $7
  pop d
  mov [d], bl
;; break; 
  jmp _switch101_exit ; case break
_switch101_case2:
;; *s++ = '\b'; 
  mov b, [bp + -1] ; $s             
  mov g, b
  inc b
  lea d, [bp + -1] ; $s
  mov [d], b
  mov b, g
  push b
  mov b, $8
  pop d
  mov [d], bl
;; break;   
  jmp _switch101_exit ; case break
_switch101_case3:
;; *s++ = '\f'; 
  mov b, [bp + -1] ; $s             
  mov g, b
  inc b
  lea d, [bp + -1] ; $s
  mov [d], b
  mov b, g
  push b
  mov b, $c
  pop d
  mov [d], bl
;; break; 
  jmp _switch101_exit ; case break
_switch101_case4:
;; *s++ = '\n'; 
  mov b, [bp + -1] ; $s             
  mov g, b
  inc b
  lea d, [bp + -1] ; $s
  mov [d], b
  mov b, g
  push b
  mov b, $a
  pop d
  mov [d], bl
;; break; 
  jmp _switch101_exit ; case break
_switch101_case5:
;; *s++ = '\r'; 
  mov b, [bp + -1] ; $s             
  mov g, b
  inc b
  lea d, [bp + -1] ; $s
  mov [d], b
  mov b, g
  push b
  mov b, $d
  pop d
  mov [d], bl
;; break; 
  jmp _switch101_exit ; case break
_switch101_case6:
;; *s++ = '\t'; 
  mov b, [bp + -1] ; $s             
  mov g, b
  inc b
  lea d, [bp + -1] ; $s
  mov [d], b
  mov b, g
  push b
  mov b, $9
  pop d
  mov [d], bl
;; break; 
  jmp _switch101_exit ; case break
_switch101_case7:
;; *s++ = '\v'; 
  mov b, [bp + -1] ; $s             
  mov g, b
  inc b
  lea d, [bp + -1] ; $s
  mov [d], b
  mov b, g
  push b
  mov b, $b
  pop d
  mov [d], bl
;; break; 
  jmp _switch101_exit ; case break
_switch101_case8:
;; *s++ = '\\'; 
  mov b, [bp + -1] ; $s             
  mov g, b
  inc b
  lea d, [bp + -1] ; $s
  mov [d], b
  mov b, g
  push b
  mov b, $5c
  pop d
  mov [d], bl
;; break; 
  jmp _switch101_exit ; case break
_switch101_case9:
;; *s++ = '\''; 
  mov b, [bp + -1] ; $s             
  mov g, b
  inc b
  lea d, [bp + -1] ; $s
  mov [d], b
  mov b, g
  push b
  mov b, $27
  pop d
  mov [d], bl
;; break; 
  jmp _switch101_exit ; case break
_switch101_case10:
;; *s++ = '\"'; 
  mov b, [bp + -1] ; $s             
  mov g, b
  inc b
  lea d, [bp + -1] ; $s
  mov [d], b
  mov b, g
  push b
  mov b, $22
  pop d
  mov [d], bl
_switch101_exit:
  jmp _if100_exit
_if100_else:
;; *s++ = *t; 
  mov b, [bp + -1] ; $s             
  mov g, b
  inc b
  lea d, [bp + -1] ; $s
  mov [d], b
  mov b, g
  push b
  mov b, [bp + -3] ; $t             
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
_if100_exit:
  jmp _if99_exit
_if99_else:
;; if(toktype == STRING_CONST){ 
_if102_cond:
  mov b, [_toktype] ; $toktype           
; START RELATIONAL
  push a
  mov a, b
  mov b, 3; STRING_CONST
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if102_exit
_if102_true:
;; t++; 
  mov b, [bp + -3] ; $t             
  mov g, b
  inc b
  lea d, [bp + -3] ; $t
  mov [d], b
  mov b, g
;; while(*t != '\"' && *t){ 
_while103_cond:
  mov b, [bp + -3] ; $t             
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $22
  cmp a, b
  sneq ; !=
  pop a
; END RELATIONAL
  push a
  mov a, b
  mov b, [bp + -3] ; $t             
  mov d, b
  mov bl, [d]
  mov bh, 0
  sand a, b ; &&
  pop a
  cmp b, 0
  je _while103_exit
_while103_block:
;; *s++ = *t++; 
  mov b, [bp + -1] ; $s             
  mov g, b
  inc b
  lea d, [bp + -1] ; $s
  mov [d], b
  mov b, g
  push b
  mov b, [bp + -3] ; $t             
  mov g, b
  inc b
  lea d, [bp + -3] ; $t
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
  jmp _while103_cond
_while103_exit:
  jmp _if102_exit
_if102_exit:
_if99_exit:
;; *s = '\0'; 
  mov b, [bp + -1] ; $s             
  push b
  mov b, $0
  pop d
  mov [d], bl
  leave
  ret

error:
  enter 0 ; (push bp; mov bp, sp)
;; printf("\nError: "); 
  mov b, __s14 ; "\nError: "
  swp b
  push b
  call printf
  add sp, 2
;; printf(msg); 
  mov b, [bp + 5] ; $msg             
  swp b
  push b
  call printf
  add sp, 2
;; printf("\n"); 
  mov b, __s15 ; "\n"
  swp b
  push b
  call printf
  add sp, 2
  leave
  ret

last_cmd_insert:
  enter 0 ; (push bp; mov bp, sp)
;; if(last_cmd[0]){ 
_if104_cond:
  mov d, _last_cmd_data ; $last_cmd
  push a         
  mov b, $0        
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  cmp b, 0
  je _if104_exit
_if104_true:
;; strcpy(command, last_cmd); 
  mov b, _command_data ; $command           
  swp b
  push b
  mov b, _last_cmd_data ; $last_cmd           
  swp b
  push b
  call strcpy
  add sp, 4
;; printf(command); 
  mov b, _command_data ; $command           
  swp b
  push b
  call printf
  add sp, 2
  jmp _if104_exit
_if104_exit:
  leave
  ret

set_string_var:
  enter 0 ; (push bp; mov bp, sp)
; $i 
  sub sp, 2
;; for(i = 0; i < vars_tos; i++){ 
_for105_init:
  lea d, [bp + -1] ; $i         
  mov b, $0        
  mov [d], b
_for105_cond:
  mov b, [bp + -1] ; $i             
; START RELATIONAL
  push a
  mov a, b
  mov b, [_vars_tos] ; $vars_tos           
  cmp a, b
  slt ; < 
  pop a
; END RELATIONAL
  cmp b, 0
  je _for105_exit
_for105_block:
;; if(!strcmp(variables[i].varname, varname)){ 
_if106_cond:
  mov d, _variables_data ; $variables
  push a         
  mov b, [bp + -1] ; $i                     
  mma 21 ; mov a, 21; mul a, b; add d, b
  pop a
  add d, 0
  clb
  mov b, d
  swp b
  push b
  mov b, [bp + 7] ; $varname             
  swp b
  push b
  call strcmp
  add sp, 4
  cmp b, 0
  seq ; !
  cmp b, 0
  je _if106_exit
_if106_true:
;; strcpy(variables[vars_tos].as_string, strval); 
  mov d, _variables_data ; $variables
  push a         
  mov b, [_vars_tos] ; $vars_tos                   
  mma 21 ; mov a, 21; mul a, b; add d, b
  pop a
  add d, 17
  clb
  mov b, [d]
  swp b
  push b
  mov b, [bp + 5] ; $strval             
  swp b
  push b
  call strcpy
  add sp, 4
;; return i; 
  mov b, [bp + -1] ; $i             
  leave
  ret
  jmp _if106_exit
_if106_exit:
_for105_update:
  mov b, [bp + -1] ; $i             
  mov g, b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  mov b, g
  jmp _for105_cond
_for105_exit:
;; variables[vars_tos].var_type = SHELL_VAR_TYP_STR; 
  mov d, _variables_data ; $variables
  push a         
  mov b, [_vars_tos] ; $vars_tos                   
  mma 21 ; mov a, 21; mul a, b; add d, b
  pop a
  add d, 16
  clb         
  mov b, 0; SHELL_VAR_TYP_STR        
  mov [d], bl
;; variables[vars_tos].as_string = alloc(strlen(strval) + 1); 
  mov d, _variables_data ; $variables
  push a         
  mov b, [_vars_tos] ; $vars_tos                   
  mma 21 ; mov a, 21; mul a, b; add d, b
  pop a
  add d, 17
  clb
  push d
  mov b, [bp + 5] ; $strval             
  swp b
  push b
  call strlen
  add sp, 2
; START TERMS
  push a
  mov a, b
  mov b, $1
  add a, b
  mov b, a
  pop a
; END TERMS
  swp b
  push b
  call alloc
  add sp, 2
  pop d
  mov [d], b
;; strcpy(variables[vars_tos].varname, varname); 
  mov d, _variables_data ; $variables
  push a         
  mov b, [_vars_tos] ; $vars_tos                   
  mma 21 ; mov a, 21; mul a, b; add d, b
  pop a
  add d, 0
  clb
  mov b, d
  swp b
  push b
  mov b, [bp + 7] ; $varname             
  swp b
  push b
  call strcpy
  add sp, 4
;; strcpy(variables[vars_tos].as_string, strval); 
  mov d, _variables_data ; $variables
  push a         
  mov b, [_vars_tos] ; $vars_tos                   
  mma 21 ; mov a, 21; mul a, b; add d, b
  pop a
  add d, 17
  clb
  mov b, [d]
  swp b
  push b
  mov b, [bp + 5] ; $strval             
  swp b
  push b
  call strcpy
  add sp, 4
;; vars_tos++; 
  mov b, [_vars_tos] ; $vars_tos           
  mov g, b
  inc b
  mov d, _vars_tos ; $vars_tos
  mov [d], b
  mov b, g
;; return vars_tos - 1; 
  mov b, [_vars_tos] ; $vars_tos           
; START TERMS
  push a
  mov a, b
  mov b, $1
  sub a, b
  mov b, a
  pop a
; END TERMS
  leave
  ret

set_int_var:
  enter 0 ; (push bp; mov bp, sp)
; $i 
  sub sp, 2
;; for(i = 0; i < vars_tos; i++){ 
_for107_init:
  lea d, [bp + -1] ; $i         
  mov b, $0        
  mov [d], b
_for107_cond:
  mov b, [bp + -1] ; $i             
; START RELATIONAL
  push a
  mov a, b
  mov b, [_vars_tos] ; $vars_tos           
  cmp a, b
  slt ; < 
  pop a
; END RELATIONAL
  cmp b, 0
  je _for107_exit
_for107_block:
;; if(!strcmp(variables[i].varname, varname)){ 
_if108_cond:
  mov d, _variables_data ; $variables
  push a         
  mov b, [bp + -1] ; $i                     
  mma 21 ; mov a, 21; mul a, b; add d, b
  pop a
  add d, 0
  clb
  mov b, d
  swp b
  push b
  mov b, [bp + 7] ; $varname             
  swp b
  push b
  call strcmp
  add sp, 4
  cmp b, 0
  seq ; !
  cmp b, 0
  je _if108_exit
_if108_true:
;; variables[vars_tos].as_int = as_int; 
  mov d, _variables_data ; $variables
  push a         
  mov b, [_vars_tos] ; $vars_tos                   
  mma 21 ; mov a, 21; mul a, b; add d, b
  pop a
  add d, 19
  clb         
  mov b, [bp + 5] ; $as_int                     
  mov [d], b
;; return i; 
  mov b, [bp + -1] ; $i             
  leave
  ret
  jmp _if108_exit
_if108_exit:
_for107_update:
  mov b, [bp + -1] ; $i             
  mov g, b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  mov b, g
  jmp _for107_cond
_for107_exit:
;; variables[vars_tos].var_type = SHELL_VAR_TYP_INT; 
  mov d, _variables_data ; $variables
  push a         
  mov b, [_vars_tos] ; $vars_tos                   
  mma 21 ; mov a, 21; mul a, b; add d, b
  pop a
  add d, 16
  clb         
  mov b, 1; SHELL_VAR_TYP_INT        
  mov [d], bl
;; strcpy(variables[vars_tos].varname, varname); 
  mov d, _variables_data ; $variables
  push a         
  mov b, [_vars_tos] ; $vars_tos                   
  mma 21 ; mov a, 21; mul a, b; add d, b
  pop a
  add d, 0
  clb
  mov b, d
  swp b
  push b
  mov b, [bp + 7] ; $varname             
  swp b
  push b
  call strcpy
  add sp, 4
;; variables[vars_tos].as_int = as_int; 
  mov d, _variables_data ; $variables
  push a         
  mov b, [_vars_tos] ; $vars_tos                   
  mma 21 ; mov a, 21; mul a, b; add d, b
  pop a
  add d, 19
  clb         
  mov b, [bp + 5] ; $as_int                     
  mov [d], b
;; vars_tos++; 
  mov b, [_vars_tos] ; $vars_tos           
  mov g, b
  inc b
  mov d, _vars_tos ; $vars_tos
  mov [d], b
  mov b, g
;; return vars_tos - 1; 
  mov b, [_vars_tos] ; $vars_tos           
; START TERMS
  push a
  mov a, b
  mov b, $1
  sub a, b
  mov b, a
  pop a
; END TERMS
  leave
  ret

get_var_index:
  enter 0 ; (push bp; mov bp, sp)
; $i 
  sub sp, 2
;; for(i = 0; i < vars_tos; i++) 
_for109_init:
  lea d, [bp + -1] ; $i         
  mov b, $0        
  mov [d], b
_for109_cond:
  mov b, [bp + -1] ; $i             
; START RELATIONAL
  push a
  mov a, b
  mov b, [_vars_tos] ; $vars_tos           
  cmp a, b
  slt ; < 
  pop a
; END RELATIONAL
  cmp b, 0
  je _for109_exit
_for109_block:
;; if(!strcmp(variables[i].varname, varname)) return i; 
_if110_cond:
  mov d, _variables_data ; $variables
  push a         
  mov b, [bp + -1] ; $i                     
  mma 21 ; mov a, 21; mul a, b; add d, b
  pop a
  add d, 0
  clb
  mov b, d
  swp b
  push b
  mov b, [bp + 5] ; $varname             
  swp b
  push b
  call strcmp
  add sp, 4
  cmp b, 0
  seq ; !
  cmp b, 0
  je _if110_exit
_if110_true:
;; return i; 
  mov b, [bp + -1] ; $i             
  leave
  ret
  jmp _if110_exit
_if110_exit:
_for109_update:
  mov b, [bp + -1] ; $i             
  mov g, b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  mov b, g
  jmp _for109_cond
_for109_exit:
;; return -1; 
  mov b, $1
  neg b
  leave
  ret

get_var_type:
  enter 0 ; (push bp; mov bp, sp)
; $i 
  sub sp, 2
;; for(i = 0; i < vars_tos; i++) 
_for111_init:
  lea d, [bp + -1] ; $i         
  mov b, $0        
  mov [d], b
_for111_cond:
  mov b, [bp + -1] ; $i             
; START RELATIONAL
  push a
  mov a, b
  mov b, [_vars_tos] ; $vars_tos           
  cmp a, b
  slt ; < 
  pop a
; END RELATIONAL
  cmp b, 0
  je _for111_exit
_for111_block:
;; if(!strcmp(variables[i].varname, varname)) return variables[i].var_type; 
_if112_cond:
  mov d, _variables_data ; $variables
  push a         
  mov b, [bp + -1] ; $i                     
  mma 21 ; mov a, 21; mul a, b; add d, b
  pop a
  add d, 0
  clb
  mov b, d
  swp b
  push b
  mov b, [bp + 5] ; $varname             
  swp b
  push b
  call strcmp
  add sp, 4
  cmp b, 0
  seq ; !
  cmp b, 0
  je _if112_exit
_if112_true:
;; return variables[i].var_type; 
  mov d, _variables_data ; $variables
  push a         
  mov b, [bp + -1] ; $i                     
  mma 21 ; mov a, 21; mul a, b; add d, b
  pop a
  add d, 16
  clb
  mov bl, [d]
  mov bh, 0
  leave
  ret
  jmp _if112_exit
_if112_exit:
_for111_update:
  mov b, [bp + -1] ; $i             
  mov g, b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  mov b, g
  jmp _for111_cond
_for111_exit:
;; return -1; 
  mov b, $1
  neg b
  leave
  ret

show_var:
  enter 0 ; (push bp; mov bp, sp)
; $i 
  sub sp, 2
;; for(i = 0; i < vars_tos; i++){ 
_for113_init:
  lea d, [bp + -1] ; $i         
  mov b, $0        
  mov [d], b
_for113_cond:
  mov b, [bp + -1] ; $i             
; START RELATIONAL
  push a
  mov a, b
  mov b, [_vars_tos] ; $vars_tos           
  cmp a, b
  slt ; < 
  pop a
; END RELATIONAL
  cmp b, 0
  je _for113_exit
_for113_block:
;; if(!strcmp(variables[i].varname, varname)){ 
_if114_cond:
  mov d, _variables_data ; $variables
  push a         
  mov b, [bp + -1] ; $i                     
  mma 21 ; mov a, 21; mul a, b; add d, b
  pop a
  add d, 0
  clb
  mov b, d
  swp b
  push b
  mov b, [bp + 5] ; $varname             
  swp b
  push b
  call strcmp
  add sp, 4
  cmp b, 0
  seq ; !
  cmp b, 0
  je _if114_exit
_if114_true:
;; if(variables[i].var_type == SHELL_VAR_TYP_INT){ 
_if115_cond:
  mov d, _variables_data ; $variables
  push a         
  mov b, [bp + -1] ; $i                     
  mma 21 ; mov a, 21; mul a, b; add d, b
  pop a
  add d, 16
  clb
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, 1; SHELL_VAR_TYP_INT
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if115_else
_if115_true:
;; printu(variables[i].as_int); 
  mov d, _variables_data ; $variables
  push a         
  mov b, [bp + -1] ; $i                     
  mma 21 ; mov a, 21; mul a, b; add d, b
  pop a
  add d, 19
  clb
  mov b, [d]
  swp b
  push b
  call printu
  add sp, 2
  jmp _if115_exit
_if115_else:
;; if(variables[i].var_type == SHELL_VAR_TYP_STR){ 
_if116_cond:
  mov d, _variables_data ; $variables
  push a         
  mov b, [bp + -1] ; $i                     
  mma 21 ; mov a, 21; mul a, b; add d, b
  pop a
  add d, 16
  clb
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, 0; SHELL_VAR_TYP_STR
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if116_exit
_if116_true:
;; printf(variables[i].as_string); 
  mov d, _variables_data ; $variables
  push a         
  mov b, [bp + -1] ; $i                     
  mma 21 ; mov a, 21; mul a, b; add d, b
  pop a
  add d, 17
  clb
  mov b, [d]
  swp b
  push b
  call printf
  add sp, 2
  jmp _if116_exit
_if116_exit:
_if115_exit:
;; return i; 
  mov b, [bp + -1] ; $i             
  leave
  ret
  jmp _if114_exit
_if114_exit:
_for113_update:
  mov b, [bp + -1] ; $i             
  mov g, b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  mov b, g
  jmp _for113_cond
_for113_exit:
;; error("Undeclared variable."); 
  mov b, __s16 ; "Undeclared variable."
  swp b
  push b
  call error
  add sp, 2
  leave
  ret

get_shell_var_strval:
  enter 0 ; (push bp; mov bp, sp)
;; return variables[index].as_string; 
  mov d, _variables_data ; $variables
  push a         
  mov b, [bp + 5] ; $index                     
  mma 21 ; mov a, 21; mul a, b; add d, b
  pop a
  add d, 17
  clb
  mov b, [d]
  leave
  ret

get_shell_var_intval:
  enter 0 ; (push bp; mov bp, sp)
;; return variables[index].as_int; 
  mov d, _variables_data ; $variables
  push a         
  mov b, [bp + 5] ; $index                     
  mma 21 ; mov a, 21; mul a, b; add d, b
  pop a
  add d, 19
  clb
  mov b, [d]
  leave
  ret

file_exists:
  enter 0 ; (push bp; mov bp, sp)
; $file_exists 
  sub sp, 2

; --- BEGIN INLINE ASM BLOCK
  lea d, [bp + 5] ; $filename
  mov d, [d]
  mov al, 21
  syscall sys_filesystem
  lea d, [bp + -1] ; $file_exists
  mov [d], a
; --- END INLINE ASM BLOCK

;; return file_exists; 
  mov b, [bp + -1] ; $file_exists             
  leave
  ret

command_cd:
  enter 0 ; (push bp; mov bp, sp)
; $dirID 
  sub sp, 2
;; *path = '\0'; 
  mov b, _path_data ; $path           
  push b
  mov b, $0
  pop d
  mov [d], bl
;; get(); 
  call get
;; if(toktype == END || tok == SEMICOLON || tok == BITWISE_NOT){ 
_if117_cond:
  mov b, [_toktype] ; $toktype           
; START RELATIONAL
  push a
  mov a, b
  mov b, 6; END
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  push a
  mov a, b
  mov b, [_tok] ; $tok           
; START RELATIONAL
  push a
  mov a, b
  mov b, 35; SEMICOLON
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  mov a, b
  mov b, [_tok] ; $tok           
; START RELATIONAL
  push a
  mov a, b
  mov b, 25; BITWISE_NOT
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  pop a
  cmp b, 0
  je _if117_else
_if117_true:
;; back(); 
  call back
;; cd_to_dir(variables[1].as_string); 
  mov d, _variables_data ; $variables
  push a         
  mov b, $1        
  mma 21 ; mov a, 21; mul a, b; add d, b
  pop a
  add d, 17
  clb
  mov b, [d]
  swp b
  push b
  call cd_to_dir
  add sp, 2
  jmp _if117_exit
_if117_else:
;; for(;;){ 
_for118_init:
_for118_cond:
_for118_block:
;; strcat(path, token); 
  mov b, _path_data ; $path           
  swp b
  push b
  mov b, _token_data ; $token           
  swp b
  push b
  call strcat
  add sp, 4
;; get(); 
  call get
;; if(toktype == END) break; 
_if119_cond:
  mov b, [_toktype] ; $toktype           
; START RELATIONAL
  push a
  mov a, b
  mov b, 6; END
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if119_else
_if119_true:
;; break; 
  jmp _for118_exit ; for break
  jmp _if119_exit
_if119_else:
;; if(tok == SEMICOLON){ 
_if120_cond:
  mov b, [_tok] ; $tok           
; START RELATIONAL
  push a
  mov a, b
  mov b, 35; SEMICOLON
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if120_exit
_if120_true:
;; back(); 
  call back
;; break; 
  jmp _for118_exit ; for break
  jmp _if120_exit
_if120_exit:
_if119_exit:
_for118_update:
  jmp _for118_cond
_for118_exit:
;; cd_to_dir(path); 
  mov b, _path_data ; $path           
  swp b
  push b
  call cd_to_dir
  add sp, 2
_if117_exit:
  leave
  ret

cd_to_dir:
  enter 0 ; (push bp; mov bp, sp)
; $dirID 
  sub sp, 2

; --- BEGIN INLINE ASM BLOCK
  lea d, [bp + 5] ; $dir
  mov d, [d]
  mov al, 19
  syscall sys_filesystem 
  lea d, [bp + -1] ; $dirID
  mov d, [d]
  mov [d], a 
; --- END INLINE ASM BLOCK

;; if(dirID != -1){ 
_if121_cond:
  mov b, [bp + -1] ; $dirID             
; START RELATIONAL
  push a
  mov a, b
  mov b, $1
  neg b
  cmp a, b
  sneq ; !=
  pop a
; END RELATIONAL
  cmp b, 0
  je _if121_exit
_if121_true:

; --- BEGIN INLINE ASM BLOCK
  mov b, a
  mov al, 3
  syscall sys_filesystem
; --- END INLINE ASM BLOCK

  jmp _if121_exit
_if121_exit:
  leave
  ret

print_cwd:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM BLOCK
  mov al, 18
  syscall sys_filesystem        
; --- END INLINE ASM BLOCK

  leave
  ret

spawn_new_proc:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM BLOCK
  mov b, [bp + 5] ; $args             
  lea d, [bp + 7] ; $executable_path
  mov d, [d]
  syscall sys_spawn_proc
; --- END INLINE ASM BLOCK

  leave
  ret

command_shell:
  enter 0 ; (push bp; mov bp, sp)
  leave
  ret

command_fg:
  enter 0 ; (push bp; mov bp, sp)
  leave
  ret

read_config:
  enter 0 ; (push bp; mov bp, sp)
;; transient_area = alloc(16385); 
  mov d, _transient_area ; $transient_area
  push d
  mov b, $4001
  swp b
  push b
  call alloc
  add sp, 2
  pop d
  mov [d], b
;; *value = '\0'; 
  mov b, [bp + 5] ; $value             
  push b
  mov b, $0
  pop d
  mov [d], bl
;; loadfile(filename, transient_area); 
  mov b, [bp + 9] ; $filename             
  swp b
  push b
  mov b, [_transient_area] ; $transient_area           
  swp b
  push b
  call loadfile
  add sp, 4
;; prog = transient_area; 
  mov d, _prog ; $prog         
  mov b, [_transient_area] ; $transient_area                   
  mov [d], b
;; for(;;){ 
_for122_init:
_for122_cond:
_for122_block:
;; get(); 
  call get
;; if(toktype == END) break; 
_if123_cond:
  mov b, [_toktype] ; $toktype           
; START RELATIONAL
  push a
  mov a, b
  mov b, 6; END
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if123_exit
_if123_true:
;; break; 
  jmp _for122_exit ; for break
  jmp _if123_exit
_if123_exit:
;; if(!strcmp(entry_name, token)){ 
_if124_cond:
  mov b, [bp + 7] ; $entry_name             
  swp b
  push b
  mov b, _token_data ; $token           
  swp b
  push b
  call strcmp
  add sp, 4
  cmp b, 0
  seq ; !
  cmp b, 0
  je _if124_exit
_if124_true:
;; get(); // get '=' 
  call get
;; for(;;){ 
_for125_init:
_for125_cond:
_for125_block:
;; get(); 
  call get
;; if(!strcmp(token, ";")) return; 
_if126_cond:
  mov b, _token_data ; $token           
  swp b
  push b
  mov b, __s17 ; ";"
  swp b
  push b
  call strcmp
  add sp, 4
  cmp b, 0
  seq ; !
  cmp b, 0
  je _if126_exit
_if126_true:
;; return; 
  leave
  ret
  jmp _if126_exit
_if126_exit:
;; strcat(value, token); 
  mov b, [bp + 5] ; $value             
  swp b
  push b
  mov b, _token_data ; $token           
  swp b
  push b
  call strcat
  add sp, 4
_for125_update:
  jmp _for125_cond
_for125_exit:
  jmp _if124_exit
_if124_exit:
_for122_update:
  jmp _for122_cond
_for122_exit:
;; free(16385); 
  mov b, $4001
  swp b
  push b
  call free
  add sp, 2
  leave
  ret
; --- END TEXT BLOCK

; --- BEGIN DATA BLOCK
_tok: .fill 2, 0
_toktype: .fill 2, 0
_prog: .fill 2, 0
_token_data: .fill 256, 0
_string_const_data: .fill 256, 0
_transient_area: .fill 2, 0
_command_data: .fill 512, 0
_path_data: .fill 256, 0
_temp_data: .fill 256, 0
_argument_data: .fill 256, 0
_last_cmd_data: .fill 128, 0
_variables_data: .fill 210, 0
_vars_tos: .fill 2, 0
__s0: .db "path", 0
__s1: .db "                                                                ", 0
__s2: .db "home", 0
__s3: .db "/etc/shell.cfg", 0
__s4: .db "root@Sol-1:", 0
__s5: .db " # ", 0
__s6: .db "\n\r", 0
__s7: .db "cd", 0
__s8: .db "shell", 0
__s9: .db "123", 0
__s10: .db "/", 0
__s11: .db "Unknown type size in va_arg() call. Size needs to be either 1 or 2.", 0
__s12: .db "Error: Unknown argument type.\n", 0
__s13: .db "Double quotes expected", 0
__s14: .db "\nError: ", 0
__s15: .db "\n", 0
__s16: .db "Undeclared variable.", 0
__s17: .db ";", 0

_heap_top: .dw _heap
_heap: .db 0
; --- END DATA BLOCK

.end
