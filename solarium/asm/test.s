.org 1024

.text

main:
  mov bp, $FFFF
  mov sp, $FFFF
; $p 
  sub sp, 2
;; printf("\n"); 
  mov b, _string_9 ; "\n"
  swp b
  push b
  call printf
  add sp, 2
;; program = alloc(16384); 
  mov d, _program ; $program
  push d
  mov b, $4000
  swp b
  push b
  call alloc
  add sp, 2
  pop d
  mov [d], b
;; bin_out = alloc(16384); 
  mov d, _bin_out ; $bin_out
  push d
  mov b, $4000
  swp b
  push b
  call alloc
  add sp, 2
  pop d
  mov [d], b
;; opcode_table = alloc(12310); 
  mov d, _opcode_table ; $opcode_table
  push d
  mov b, $3016
  swp b
  push b
  call alloc
  add sp, 2
  pop d
  mov [d], b
;; loadfile(0x0000, program); 
  mov b, $0
  swp b
  push b
  mov b, [_program] ; $program           
  swp b
  push b
  call loadfile
  add sp, 4
;; loadfile("./config.d/op_tbl", opcode_table); 
  mov b, _string_10 ; "./config.d/op_tbl"
  swp b
  push b
  mov b, [_opcode_table] ; $opcode_table           
  swp b
  push b
  call loadfile
  add sp, 4
;; p = program; 
  lea d, [bp + -1] ; $p         
  mov b, [_program] ; $program                   
  mov [d], b
;; while(*p) p++; 
_while1_cond:
  mov b, [bp + -1] ; $p             
  mov d, b
  mov bl, [d]
  mov bh, 0
  cmp b, 0
  je _while1_exit
_while1_block:
;; p++; 
  mov b, [bp + -1] ; $p             
  mov g, b
  inc b
  lea d, [bp + -1] ; $p
  mov [d], b
  mov b, g
  jmp _while1_cond
_while1_exit:
;; while(is_space(*p)) p--; 
_while2_cond:
  mov b, [bp + -1] ; $p             
  mov d, b
  mov bl, [d]
  mov bh, 0
  push bl
  call is_space
  add sp, 1
  cmp b, 0
  je _while2_exit
_while2_block:
;; p--; 
  mov b, [bp + -1] ; $p             
  mov g, b
  dec b
  lea d, [bp + -1] ; $p
  mov [d], b
  mov b, g
  jmp _while2_cond
_while2_exit:
;; p++; 
  mov b, [bp + -1] ; $p             
  mov g, b
  inc b
  lea d, [bp + -1] ; $p
  mov [d], b
  mov b, g
;; *p = '\0'; 
  mov b, [bp + -1] ; $p             
  push b
  mov b, $0
  pop d
  mov [d], bl
;; prog = program; 
  mov d, _prog ; $prog         
  mov b, [_program] ; $program                   
  mov [d], b
;; bin_p = bin_out + _org; 
  mov d, _bin_p ; $bin_p         
  mov b, [_bin_out] ; $bin_out           
; START TERMS
  push a
  mov a, b
  mov b, [__org] ; $_org           
  add a, b
  mov b, a
  pop a
; END TERMS        
  mov [d], b
;; pc = _org; 
  mov d, _pc ; $pc         
  mov b, [__org] ; $_org                   
  mov [d], b
;; prog_size = 0; 
  mov d, _prog_size ; $prog_size         
  mov b, $0        
  mov [d], b
;; label_scan(); 
  call label_scan
;; prog_size = 0; 
  mov d, _prog_size ; $prog_size         
  mov b, $0        
  mov [d], b
;; parse_text(); 
  call parse_text
;; parse_data(); 
  call parse_data
;; display_output(); 
  call display_output
  syscall sys_terminate_proc

.end

.data

_string_0: .db 65,'\0'
_string_1: .db 65,'\0'
_string_2: .db 65,'\0'
_string_3: .db 65,'\0'
_string_4: .db 65,'\0'
_string_5: .db 65,'\0'
_string_6: .db 65,'\0'
_string_7: .db 65,'\0'
_string_8: .db 65,'\0'
_string_9: .db 65,'\0'

.end