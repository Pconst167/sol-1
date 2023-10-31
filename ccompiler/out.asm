; --- FILENAME: ../solarium/asm/asm
.include "lib/kernel.exp"
.include "lib/bios.exp"
.org text_org

; --- BEGIN TEXT BLOCK
main:
  mov bp, $FFE0 ;
  mov sp, $FFE0 ; Make space for argc(2 bytes) and for 10 pointers in argv (local variables)
; $p 
  sub sp, 2
;; print("\n"); 
  mov b, __s9 ; "\n"
  swp b
  push b
  call print
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
  mov b, __s10 ; "./config.d/op_tbl"
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
;; label_directive_scan(); 
  call label_directive_scan
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

parse_data:
  enter 0 ; (push bp; mov bp, sp)
;; print("Parsing DATA section..."); 
  mov b, __s11 ; "Parsing DATA section..."
  swp b
  push b
  call print
  add sp, 2
;; for(;;){ 
_for3_init:
_for3_cond:
_for3_block:
;; get(); 
  call get
;; if(toktype == END) error("Data segment not found."); 
_if4_cond:
  mov b, [_toktype] ; $toktype           
; START RELATIONAL
  push a
  mov a, b
  mov b, 7; END
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if4_exit
_if4_true:
;; error("Data segment not found."); 
  mov b, __s12 ; "Data segment not found."
  swp b
  push b
  call error
  add sp, 2
  jmp _if4_exit
_if4_exit:
;; if(tok == DOT){ 
_if5_cond:
  mov b, [_tok] ; $tok           
; START RELATIONAL
  push a
  mov a, b
  mov b, 16; DOT
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if5_exit
_if5_true:
;; get(); 
  call get
;; if(tok == DATA) break; 
_if6_cond:
  mov b, [_tok] ; $tok           
; START RELATIONAL
  push a
  mov a, b
  mov b, 3; DATA
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if6_exit
_if6_true:
;; break; 
  jmp _for3_exit ; for break
  jmp _if6_exit
_if6_exit:
  jmp _if5_exit
_if5_exit:
_for3_update:
  jmp _for3_cond
_for3_exit:
;; for(;;){ 
_for7_init:
_for7_cond:
_for7_block:
;; get(); 
  call get
;; if(tok == SEGMENT_END) break; 
_if8_cond:
  mov b, [_tok] ; $tok           
; START RELATIONAL
  push a
  mov a, b
  mov b, 5; SEGMENT_END
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if8_exit
_if8_true:
;; break; 
  jmp _for7_exit ; for break
  jmp _if8_exit
_if8_exit:
;; if(tok == DB){ 
_if9_cond:
  mov b, [_tok] ; $tok           
; START RELATIONAL
  push a
  mov a, b
  mov b, 6; DB
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if9_else
_if9_true:
;; print(".db: "); 
  mov b, __s13 ; ".db: "
  swp b
  push b
  call print
  add sp, 2
;; for(;;){ 
_for10_init:
_for10_cond:
_for10_block:
;; get(); 
  call get
;; if(toktype == CHAR_CONST){ 
_if11_cond:
  mov b, [_toktype] ; $toktype           
; START RELATIONAL
  push a
  mov a, b
  mov b, 3; CHAR_CONST
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if11_else
_if11_true:
;; emit_byte(string_const[0], 0); 
  mov d, _string_const_data ; $string_const
  push a         
  mov b, $0        
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  push bl
  mov b, $0
  push bl
  call emit_byte
  add sp, 2
;; printx8(string_const[0]); 
  mov d, _string_const_data ; $string_const
  push a         
  mov b, $0        
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  push bl
  call printx8
  add sp, 1
  jmp _if11_exit
_if11_else:
;; if(toktype == INTEGER_CONST){ 
_if12_cond:
  mov b, [_toktype] ; $toktype           
; START RELATIONAL
  push a
  mov a, b
  mov b, 5; INTEGER_CONST
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if12_exit
_if12_true:
;; emit_byte(int_const, 0); 
  mov b, [_int_const] ; $int_const           
  push bl
  mov b, $0
  push bl
  call emit_byte
  add sp, 2
;; printx8(int_const); 
  mov b, [_int_const] ; $int_const           
  push bl
  call printx8
  add sp, 1
  jmp _if12_exit
_if12_exit:
_if11_exit:
;; get(); 
  call get
;; if(tok != COMMA){ 
_if13_cond:
  mov b, [_tok] ; $tok           
; START RELATIONAL
  push a
  mov a, b
  mov b, 15; COMMA
  cmp a, b
  sneq ; !=
  pop a
; END RELATIONAL
  cmp b, 0
  je _if13_exit
_if13_true:
;; back(); 
  call back
;; break; 
  jmp _for10_exit ; for break
  jmp _if13_exit
_if13_exit:
;; print(", "); 
  mov b, __s14 ; ", "
  swp b
  push b
  call print
  add sp, 2
_for10_update:
  jmp _for10_cond
_for10_exit:
;; print("\n"); 
  mov b, __s9 ; "\n"
  swp b
  push b
  call print
  add sp, 2
  jmp _if9_exit
_if9_else:
;; if(tok == DW){ 
_if14_cond:
  mov b, [_tok] ; $tok           
; START RELATIONAL
  push a
  mov a, b
  mov b, 7; DW
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if14_exit
_if14_true:
;; print(".dw: "); 
  mov b, __s15 ; ".dw: "
  swp b
  push b
  call print
  add sp, 2
;; for(;;){ 
_for15_init:
_for15_cond:
_for15_block:
;; get(); 
  call get
;; if(toktype == CHAR_CONST){ 
_if16_cond:
  mov b, [_toktype] ; $toktype           
; START RELATIONAL
  push a
  mov a, b
  mov b, 3; CHAR_CONST
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if16_else
_if16_true:
;; emit_byte(string_const[0], 0); 
  mov d, _string_const_data ; $string_const
  push a         
  mov b, $0        
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  push bl
  mov b, $0
  push bl
  call emit_byte
  add sp, 2
;; emit_byte(0, 0); 
  mov b, $0
  push bl
  mov b, $0
  push bl
  call emit_byte
  add sp, 2
;; printx8(string_const[0]); 
  mov d, _string_const_data ; $string_const
  push a         
  mov b, $0        
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  push bl
  call printx8
  add sp, 1
  jmp _if16_exit
_if16_else:
;; if(toktype == INTEGER_CONST){ 
_if17_cond:
  mov b, [_toktype] ; $toktype           
; START RELATIONAL
  push a
  mov a, b
  mov b, 5; INTEGER_CONST
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if17_exit
_if17_true:
;; emit_word(int_const, 0); 
  mov b, [_int_const] ; $int_const           
  swp b
  push b
  mov b, $0
  push bl
  call emit_word
  add sp, 3
;; printx16(int_const); 
  mov b, [_int_const] ; $int_const           
  swp b
  push b
  call printx16
  add sp, 2
  jmp _if17_exit
_if17_exit:
_if16_exit:
;; get(); 
  call get
;; if(tok != COMMA){ 
_if18_cond:
  mov b, [_tok] ; $tok           
; START RELATIONAL
  push a
  mov a, b
  mov b, 15; COMMA
  cmp a, b
  sneq ; !=
  pop a
; END RELATIONAL
  cmp b, 0
  je _if18_exit
_if18_true:
;; back(); 
  call back
;; break; 
  jmp _for15_exit ; for break
  jmp _if18_exit
_if18_exit:
;; print(", "); 
  mov b, __s14 ; ", "
  swp b
  push b
  call print
  add sp, 2
_for15_update:
  jmp _for15_cond
_for15_exit:
;; print("\n"); 
  mov b, __s9 ; "\n"
  swp b
  push b
  call print
  add sp, 2
  jmp _if14_exit
_if14_exit:
_if9_exit:
_for7_update:
  jmp _for7_cond
_for7_exit:
;; print("Done.\n"); 
  mov b, __s16 ; "Done.\n"
  swp b
  push b
  call print
  add sp, 2
  leave
  ret

parse_directive:
  enter 0 ; (push bp; mov bp, sp)
;; get(); 
  call get
;; if(tok == ORG){ 
_if19_cond:
  mov b, [_tok] ; $tok           
; START RELATIONAL
  push a
  mov a, b
  mov b, 1; ORG
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if19_else
_if19_true:
;; get(); 
  call get
;; if(toktype != INTEGER_CONST) error("Integer constant expected in .org directive."); 
_if20_cond:
  mov b, [_toktype] ; $toktype           
; START RELATIONAL
  push a
  mov a, b
  mov b, 5; INTEGER_CONST
  cmp a, b
  sneq ; !=
  pop a
; END RELATIONAL
  cmp b, 0
  je _if20_exit
_if20_true:
;; error("Integer constant expected in .org directive."); 
  mov b, __s17 ; "Integer constant expected in .org directive."
  swp b
  push b
  call error
  add sp, 2
  jmp _if20_exit
_if20_exit:
;; _org = int_const; 
  mov d, __org ; $_org         
  mov b, [_int_const] ; $int_const                   
  mov [d], b
  jmp _if19_exit
_if19_else:
;; if(tok == DB){ 
_if21_cond:
  mov b, [_tok] ; $tok           
; START RELATIONAL
  push a
  mov a, b
  mov b, 6; DB
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if21_else
_if21_true:
;; for(;;){ 
_for22_init:
_for22_cond:
_for22_block:
;; get(); 
  call get
;; if(toktype == CHAR_CONST){ 
_if23_cond:
  mov b, [_toktype] ; $toktype           
; START RELATIONAL
  push a
  mov a, b
  mov b, 3; CHAR_CONST
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if23_else
_if23_true:
;; emit_byte(string_const[0], emit_override); 
  mov d, _string_const_data ; $string_const
  push a         
  mov b, $0        
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  push bl
  mov bl, [bp + 5] ; $emit_override
  mov bh, 0             
  push bl
  call emit_byte
  add sp, 2
  jmp _if23_exit
_if23_else:
;; if(toktype == INTEGER_CONST){ 
_if24_cond:
  mov b, [_toktype] ; $toktype           
; START RELATIONAL
  push a
  mov a, b
  mov b, 5; INTEGER_CONST
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if24_exit
_if24_true:
;; emit_byte(int_const, emit_override); 
  mov b, [_int_const] ; $int_const           
  push bl
  mov bl, [bp + 5] ; $emit_override
  mov bh, 0             
  push bl
  call emit_byte
  add sp, 2
  jmp _if24_exit
_if24_exit:
_if23_exit:
;; get(); 
  call get
;; if(tok != COMMA){ 
_if25_cond:
  mov b, [_tok] ; $tok           
; START RELATIONAL
  push a
  mov a, b
  mov b, 15; COMMA
  cmp a, b
  sneq ; !=
  pop a
; END RELATIONAL
  cmp b, 0
  je _if25_exit
_if25_true:
;; back(); 
  call back
;; break; 
  jmp _for22_exit ; for break
  jmp _if25_exit
_if25_exit:
_for22_update:
  jmp _for22_cond
_for22_exit:
  jmp _if21_exit
_if21_else:
;; if(tok == DW){ 
_if26_cond:
  mov b, [_tok] ; $tok           
; START RELATIONAL
  push a
  mov a, b
  mov b, 7; DW
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if26_exit
_if26_true:
;; for(;;){ 
_for27_init:
_for27_cond:
_for27_block:
;; get(); 
  call get
;; if(toktype == CHAR_CONST){ 
_if28_cond:
  mov b, [_toktype] ; $toktype           
; START RELATIONAL
  push a
  mov a, b
  mov b, 3; CHAR_CONST
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if28_else
_if28_true:
;; emit_byte(string_const[0], emit_override); 
  mov d, _string_const_data ; $string_const
  push a         
  mov b, $0        
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  push bl
  mov bl, [bp + 5] ; $emit_override
  mov bh, 0             
  push bl
  call emit_byte
  add sp, 2
;; emit_byte(0, emit_override); 
  mov b, $0
  push bl
  mov bl, [bp + 5] ; $emit_override
  mov bh, 0             
  push bl
  call emit_byte
  add sp, 2
  jmp _if28_exit
_if28_else:
;; if(toktype == INTEGER_CONST){ 
_if29_cond:
  mov b, [_toktype] ; $toktype           
; START RELATIONAL
  push a
  mov a, b
  mov b, 5; INTEGER_CONST
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if29_exit
_if29_true:
;; emit_word(int_const, 0); 
  mov b, [_int_const] ; $int_const           
  swp b
  push b
  mov b, $0
  push bl
  call emit_word
  add sp, 3
  jmp _if29_exit
_if29_exit:
_if28_exit:
;; get(); 
  call get
;; if(tok != COMMA){ 
_if30_cond:
  mov b, [_tok] ; $tok           
; START RELATIONAL
  push a
  mov a, b
  mov b, 15; COMMA
  cmp a, b
  sneq ; !=
  pop a
; END RELATIONAL
  cmp b, 0
  je _if30_exit
_if30_true:
;; back(); 
  call back
;; break; 
  jmp _for27_exit ; for break
  jmp _if30_exit
_if30_exit:
_for27_update:
  jmp _for27_cond
_for27_exit:
  jmp _if26_exit
_if26_exit:
_if21_exit:
_if19_exit:
  leave
  ret

label_directive_scan:
  enter 0 ; (push bp; mov bp, sp)
; $temp_prog 
; $i 
  sub sp, 4
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
;; print("Parsing labels and directives...\n"); 
  mov b, __s18 ; "Parsing labels and directives...\n"
  swp b
  push b
  call print
  add sp, 2
;; for(;;){ 
_for31_init:
_for31_cond:
_for31_block:
;; get(); back(); 
  call get
;; back(); 
  call back
;; temp_prog = prog; 
  lea d, [bp + -1] ; $temp_prog         
  mov b, [_prog] ; $prog                   
  mov [d], b
;; get(); 
  call get
;; if(toktype == END) break; 
_if32_cond:
  mov b, [_toktype] ; $toktype           
; START RELATIONAL
  push a
  mov a, b
  mov b, 7; END
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if32_exit
_if32_true:
;; break; 
  jmp _for31_exit ; for break
  jmp _if32_exit
_if32_exit:
;; if(tok == DOT){ 
_if33_cond:
  mov b, [_tok] ; $tok           
; START RELATIONAL
  push a
  mov a, b
  mov b, 16; DOT
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if33_else
_if33_true:
;; get(); 
  call get
;; if(is_directive(token)){ 
_if34_cond:
  mov b, _token_data ; $token           
  swp b
  push b
  call is_directive
  add sp, 2
  cmp b, 0
  je _if34_exit
_if34_true:
;; back(); 
  call back
;; parse_directive(1); 
  mov b, $1
  push bl
  call parse_directive
  add sp, 1
  jmp _if34_exit
_if34_exit:
  jmp _if33_exit
_if33_else:
;; if(toktype == IDENTIFIER){ 
_if35_cond:
  mov b, [_toktype] ; $toktype           
; START RELATIONAL
  push a
  mov a, b
  mov b, 6; IDENTIFIER
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if35_exit
_if35_true:
;; get(); 
  call get
;; if(tok == COLON){ 
_if36_cond:
  mov b, [_tok] ; $tok           
; START RELATIONAL
  push a
  mov a, b
  mov b, 13; COLON
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if36_else
_if36_true:
;; prog = temp_prog; 
  mov d, _prog ; $prog         
  mov b, [bp + -1] ; $temp_prog                     
  mov [d], b
;; parse_label(); 
  call parse_label
;; print("."); 
  mov b, __s19 ; "."
  swp b
  push b
  call print
  add sp, 2
  jmp _if36_exit
_if36_else:
;; prog = temp_prog; 
  mov d, _prog ; $prog         
  mov b, [bp + -1] ; $temp_prog                     
  mov [d], b
;; parse_instr(1);       
  mov b, $1
  push bl
  call parse_instr
  add sp, 1
;; print("."); 
  mov b, __s19 ; "."
  swp b
  push b
  call print
  add sp, 2
_if36_exit:
  jmp _if35_exit
_if35_exit:
_if33_exit:
_for31_update:
  jmp _for31_cond
_for31_exit:
;; print("\nDone.\n"); 
  mov b, __s20 ; "\nDone.\n"
  swp b
  push b
  call print
  add sp, 2
;; print_info2("Org: ", _org, "\n"); 
  mov b, __s21 ; "Org: "
  swp b
  push b
  mov b, [__org] ; $_org           
  swp b
  push b
  mov b, __s9 ; "\n"
  swp b
  push b
  call print_info2
  add sp, 6
;; print("\nLabels list:\n"); 
  mov b, __s22 ; "\nLabels list:\n"
  swp b
  push b
  call print
  add sp, 2
;; for(i = 0; label_table[i].name[0]; i++){ 
_for37_init:
  lea d, [bp + -3] ; $i         
  mov b, $0        
  mov [d], b
_for37_cond:
  mov d, _label_table_data ; $label_table
  push a         
  mov b, [bp + -3] ; $i                     
  mma 18 ; mov a, 18; mul a, b; add d, b
  pop a
  add d, 0
  clb
  push a         
  mov b, $0        
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  cmp b, 0
  je _for37_exit
_for37_block:
;; print(label_table[i].name); 
  mov d, _label_table_data ; $label_table
  push a         
  mov b, [bp + -3] ; $i                     
  mma 18 ; mov a, 18; mul a, b; add d, b
  pop a
  add d, 0
  clb
  mov b, d
  swp b
  push b
  call print
  add sp, 2
;; print(": "); 
  mov b, __s23 ; ": "
  swp b
  push b
  call print
  add sp, 2
;; printx16(label_table[i].address); 
  mov d, _label_table_data ; $label_table
  push a         
  mov b, [bp + -3] ; $i                     
  mma 18 ; mov a, 18; mul a, b; add d, b
  pop a
  add d, 16
  clb
  mov b, [d]
  swp b
  push b
  call printx16
  add sp, 2
;; print("\n"); 
  mov b, __s9 ; "\n"
  swp b
  push b
  call print
  add sp, 2
_for37_update:
  mov b, [bp + -3] ; $i             
  mov g, b
  inc b
  lea d, [bp + -3] ; $i
  mov [d], b
  mov b, g
  jmp _for37_cond
_for37_exit:
;; print("\n"); 
  mov b, __s9 ; "\n"
  swp b
  push b
  call print
  add sp, 2
  leave
  ret

label_parse_instr:
  enter 0 ; (push bp; mov bp, sp)
; $opcode 
; $code_line 
; $op 
; $num_operands 
; $num_operandsexp 
; $i 
; $j 
; $operand_types 
; $old_pc 
; $has_operands 
  sub sp, 136
;; old_pc = pc; 
  lea d, [bp + -134] ; $old_pc         
  mov b, [_pc] ; $pc                   
  mov [d], b
;; get_line(); 
  call get_line
;; push_prog(); 
  call push_prog
;; strcpy(code_line, string_const); 
  lea d, [bp + -95] ; $code_line
  mov b, d
  swp b
  push b
  mov b, _string_const_data ; $string_const           
  swp b
  push b
  call strcpy
  add sp, 4
;; has_operands = 0; 
  lea d, [bp + -135] ; $has_operands         
  mov b, $0        
  mov [d], bl
;; prog = code_line; 
  mov d, _prog ; $prog
  push d
  lea d, [bp + -95] ; $code_line
  mov b, d
  pop d
  mov [d], b
;; get(); // get main opcode 
  call get
;; for(;;){ 
_for38_init:
_for38_cond:
_for38_block:
;; get(); 
  call get
;; if(toktype == END) break; 
_if39_cond:
  mov b, [_toktype] ; $toktype           
; START RELATIONAL
  push a
  mov a, b
  mov b, 7; END
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if39_exit
_if39_true:
;; break; 
  jmp _for38_exit ; for break
  jmp _if39_exit
_if39_exit:
;; if(toktype == INTEGER_CONST || toktype == IDENTIFIER && !is_reserved(token)){ 
_if40_cond:
  mov b, [_toktype] ; $toktype           
; START RELATIONAL
  push a
  mov a, b
  mov b, 5; INTEGER_CONST
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  push a
  mov a, b
  mov b, [_toktype] ; $toktype           
; START RELATIONAL
  push a
  mov a, b
  mov b, 6; IDENTIFIER
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  push a
  mov a, b
  mov b, _token_data ; $token           
  swp b
  push b
  call is_reserved
  add sp, 2
  cmp b, 0
  seq ; !
  sand a, b ; &&
  pop a
  sor a, b ; ||
  pop a
  cmp b, 0
  je _if40_exit
_if40_true:
;; has_operands = 1; 
  lea d, [bp + -135] ; $has_operands         
  mov b, $1        
  mov [d], bl
;; break; 
  jmp _for38_exit ; for break
  jmp _if40_exit
_if40_exit:
_for38_update:
  jmp _for38_cond
_for38_exit:
;; opcode[0] = '\0'; 
  lea d, [bp + -31] ; $opcode
  push a         
  mov b, $0        
  add d, b
  pop a         
  mov b, $0        
  mov [d], bl
;; prog = code_line; 
  mov d, _prog ; $prog
  push d
  lea d, [bp + -95] ; $code_line
  mov b, d
  pop d
  mov [d], b
;; if(!has_operands){ 
_if41_cond:
  mov bl, [bp + -135] ; $has_operands
  mov bh, 0             
  cmp b, 0
  seq ; !
  cmp b, 0
  je _if41_else
_if41_true:
;; get(); 
  call get
;; strcpy(opcode, token); 
  lea d, [bp + -31] ; $opcode
  mov b, d
  swp b
  push b
  mov b, _token_data ; $token           
  swp b
  push b
  call strcpy
  add sp, 4
;; get();  
  call get
;; if(toktype == END){ 
_if42_cond:
  mov b, [_toktype] ; $toktype           
; START RELATIONAL
  push a
  mov a, b
  mov b, 7; END
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if42_else
_if42_true:
;; strcat(opcode, " ."); 
  lea d, [bp + -31] ; $opcode
  mov b, d
  swp b
  push b
  mov b, __s24 ; " ."
  swp b
  push b
  call strcat
  add sp, 4
  jmp _if42_exit
_if42_else:
;; strcat(opcode, " "); 
  lea d, [bp + -31] ; $opcode
  mov b, d
  swp b
  push b
  mov b, __s25 ; " "
  swp b
  push b
  call strcat
  add sp, 4
;; strcat(opcode, token); 
  lea d, [bp + -31] ; $opcode
  mov b, d
  swp b
  push b
  mov b, _token_data ; $token           
  swp b
  push b
  call strcat
  add sp, 4
;; for(;;){ 
_for43_init:
_for43_cond:
_for43_block:
;; get(); 
  call get
;; if(toktype == END) break; 
_if44_cond:
  mov b, [_toktype] ; $toktype           
; START RELATIONAL
  push a
  mov a, b
  mov b, 7; END
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if44_exit
_if44_true:
;; break; 
  jmp _for43_exit ; for break
  jmp _if44_exit
_if44_exit:
;; strcat(opcode, token); 
  lea d, [bp + -31] ; $opcode
  mov b, d
  swp b
  push b
  mov b, _token_data ; $token           
  swp b
  push b
  call strcat
  add sp, 4
_for43_update:
  jmp _for43_cond
_for43_exit:
_if42_exit:
;; op = search_opcode(opcode); 
  lea d, [bp + -121] ; $op
  push d
  lea d, [bp + -31] ; $opcode
  mov b, d
  swp b
  push b
  call search_opcode
  add sp, 2
  pop d
  mov si, b
  mov di, d
  mov c, 26
  rep movsb
;; if(op.opcode_type){ 
_if45_cond:
  lea d, [bp + -121] ; $op
  add d, 25
  clb
  mov bl, [d]
  mov bh, 0
  cmp b, 0
  je _if45_exit
_if45_true:
;; forwards(1); 
  mov b, $1
  push bl
  call forwards
  add sp, 1
  jmp _if45_exit
_if45_exit:
;; forwards(1); 
  mov b, $1
  push bl
  call forwards
  add sp, 1
  jmp _if41_exit
_if41_else:
;; num_operands = 0; 
  lea d, [bp + -123] ; $num_operands         
  mov b, $0        
  mov [d], b
;; for(;;){ 
_for46_init:
_for46_cond:
_for46_block:
;; get(); 
  call get
;; if(toktype == END) break; 
_if47_cond:
  mov b, [_toktype] ; $toktype           
; START RELATIONAL
  push a
  mov a, b
  mov b, 7; END
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if47_exit
_if47_true:
;; break; 
  jmp _for46_exit ; for break
  jmp _if47_exit
_if47_exit:
;; if(toktype == INTEGER_CONST || toktype == IDENTIFIER && !is_reserved(token)){ 
_if48_cond:
  mov b, [_toktype] ; $toktype           
; START RELATIONAL
  push a
  mov a, b
  mov b, 5; INTEGER_CONST
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  push a
  mov a, b
  mov b, [_toktype] ; $toktype           
; START RELATIONAL
  push a
  mov a, b
  mov b, 6; IDENTIFIER
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  push a
  mov a, b
  mov b, _token_data ; $token           
  swp b
  push b
  call is_reserved
  add sp, 2
  cmp b, 0
  seq ; !
  sand a, b ; &&
  pop a
  sor a, b ; ||
  pop a
  cmp b, 0
  je _if48_exit
_if48_true:
;; num_operands++; 
  mov b, [bp + -123] ; $num_operands             
  mov g, b
  inc b
  lea d, [bp + -123] ; $num_operands
  mov [d], b
  mov b, g
  jmp _if48_exit
_if48_exit:
_for46_update:
  jmp _for46_cond
_for46_exit:
;; if(num_operands > 2) error("Maximum number of operands per instruction is 2."); 
_if49_cond:
  mov b, [bp + -123] ; $num_operands             
; START RELATIONAL
  push a
  mov a, b
  mov b, $2
  cmp a, b
  sgt ; >
  pop a
; END RELATIONAL
  cmp b, 0
  je _if49_exit
_if49_true:
;; error("Maximum number of operands per instruction is 2."); 
  mov b, __s26 ; "Maximum number of operands per instruction is 2."
  swp b
  push b
  call error
  add sp, 2
  jmp _if49_exit
_if49_exit:
;; num_operandsexp = exp(2, num_operands); 
  lea d, [bp + -125] ; $num_operandsexp
  push d
  mov b, $2
  swp b
  push b
  mov b, [bp + -123] ; $num_operands             
  swp b
  push b
  call exp
  add sp, 4
  pop d
  mov [d], b
;; for(i = 0; i < num_operandsexp; i++){ 
_for50_init:
  lea d, [bp + -127] ; $i         
  mov b, $0        
  mov [d], b
_for50_cond:
  mov b, [bp + -127] ; $i             
; START RELATIONAL
  push a
  mov a, b
  mov b, [bp + -125] ; $num_operandsexp             
  cmp a, b
  slt ; < 
  pop a
; END RELATIONAL
  cmp b, 0
  je _for50_exit
_for50_block:
;; prog = code_line; 
  mov d, _prog ; $prog
  push d
  lea d, [bp + -95] ; $code_line
  mov b, d
  pop d
  mov [d], b
;; get(); 
  call get
;; strcpy(opcode, token); 
  lea d, [bp + -31] ; $opcode
  mov b, d
  swp b
  push b
  mov b, _token_data ; $token           
  swp b
  push b
  call strcpy
  add sp, 4
;; strcat(opcode, " "); 
  lea d, [bp + -31] ; $opcode
  mov b, d
  swp b
  push b
  mov b, __s25 ; " "
  swp b
  push b
  call strcat
  add sp, 4
;; j = 0; 
  lea d, [bp + -129] ; $j         
  mov b, $0        
  mov [d], b
;; for(;;){ 
_for51_init:
_for51_cond:
_for51_block:
;; get(); 
  call get
;; if(toktype == END) break; 
_if52_cond:
  mov b, [_toktype] ; $toktype           
; START RELATIONAL
  push a
  mov a, b
  mov b, 7; END
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if52_exit
_if52_true:
;; break; 
  jmp _for51_exit ; for break
  jmp _if52_exit
_if52_exit:
;; if(toktype == INTEGER_CONST || toktype == IDENTIFIER && !is_reserved(token)){ 
_if53_cond:
  mov b, [_toktype] ; $toktype           
; START RELATIONAL
  push a
  mov a, b
  mov b, 5; INTEGER_CONST
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  push a
  mov a, b
  mov b, [_toktype] ; $toktype           
; START RELATIONAL
  push a
  mov a, b
  mov b, 6; IDENTIFIER
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  push a
  mov a, b
  mov b, _token_data ; $token           
  swp b
  push b
  call is_reserved
  add sp, 2
  cmp b, 0
  seq ; !
  sand a, b ; &&
  pop a
  sor a, b ; ||
  pop a
  cmp b, 0
  je _if53_else
_if53_true:
;; strcat(opcode, symbols[i*2+j]); 
  lea d, [bp + -31] ; $opcode
  mov b, d
  swp b
  push b
  mov d, _symbols_data ; $symbols
  push a         
  mov b, [bp + -127] ; $i             
; START FACTORS
  push a
  mov a, b
  mov b, $2
  mul a, b ; *
  mov a, b
  mov b, a
  pop a
; END FACTORS
; START TERMS
  push a
  mov a, b
  mov b, [bp + -129] ; $j             
  add a, b
  mov b, a
  pop a
; END TERMS        
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  swp b
  push b
  call strcat
  add sp, 4
;; operand_types[j] = *symbols[i*2+j]; 
  lea d, [bp + -132] ; $operand_types
  push a         
  mov b, [bp + -129] ; $j                     
  add d, b
  pop a
  push d
  mov d, _symbols_data ; $symbols
  push a         
  mov b, [bp + -127] ; $i             
; START FACTORS
  push a
  mov a, b
  mov b, $2
  mul a, b ; *
  mov a, b
  mov b, a
  pop a
; END FACTORS
; START TERMS
  push a
  mov a, b
  mov b, [bp + -129] ; $j             
  add a, b
  mov b, a
  pop a
; END TERMS        
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; j++; 
  mov b, [bp + -129] ; $j             
  mov g, b
  inc b
  lea d, [bp + -129] ; $j
  mov [d], b
  mov b, g
  jmp _if53_exit
_if53_else:
;; strcat(opcode, token); 
  lea d, [bp + -31] ; $opcode
  mov b, d
  swp b
  push b
  mov b, _token_data ; $token           
  swp b
  push b
  call strcat
  add sp, 4
_if53_exit:
_for51_update:
  jmp _for51_cond
_for51_exit:
;; op = search_opcode(opcode); 
  lea d, [bp + -121] ; $op
  push d
  lea d, [bp + -31] ; $opcode
  mov b, d
  swp b
  push b
  call search_opcode
  add sp, 2
  pop d
  mov si, b
  mov di, d
  mov c, 26
  rep movsb
;; if(op.name[0] == '\0') continue; 
_if54_cond:
  lea d, [bp + -121] ; $op
  add d, 0
  clb
  push a         
  mov b, $0        
  add d, b
  pop a
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
  je _if54_exit
_if54_true:
;; continue; 
  jmp _for50_update ; for continue
  jmp _if54_exit
_if54_exit:
;; if(op.opcode_type){ 
_if55_cond:
  lea d, [bp + -121] ; $op
  add d, 25
  clb
  mov bl, [d]
  mov bh, 0
  cmp b, 0
  je _if55_exit
_if55_true:
;; forwards(1); 
  mov b, $1
  push bl
  call forwards
  add sp, 1
  jmp _if55_exit
_if55_exit:
;; forwards(1); 
  mov b, $1
  push bl
  call forwards
  add sp, 1
;; prog = code_line; 
  mov d, _prog ; $prog
  push d
  lea d, [bp + -95] ; $code_line
  mov b, d
  pop d
  mov [d], b
;; j = 0; 
  lea d, [bp + -129] ; $j         
  mov b, $0        
  mov [d], b
;; get(); 
  call get
;; for(;;){ 
_for56_init:
_for56_cond:
_for56_block:
;; get(); 
  call get
;; if(toktype == END) break; 
_if57_cond:
  mov b, [_toktype] ; $toktype           
; START RELATIONAL
  push a
  mov a, b
  mov b, 7; END
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if57_exit
_if57_true:
;; break; 
  jmp _for56_exit ; for break
  jmp _if57_exit
_if57_exit:
;; if(toktype == IDENTIFIER && !is_reserved(token)){ 
_if58_cond:
  mov b, [_toktype] ; $toktype           
; START RELATIONAL
  push a
  mov a, b
  mov b, 6; IDENTIFIER
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  push a
  mov a, b
  mov b, _token_data ; $token           
  swp b
  push b
  call is_reserved
  add sp, 2
  cmp b, 0
  seq ; !
  sand a, b ; &&
  pop a
  cmp b, 0
  je _if58_else
_if58_true:
;; if(operand_types[j] == '#'){ 
_if59_cond:
  lea d, [bp + -132] ; $operand_types
  push a         
  mov b, [bp + -129] ; $j                     
  add d, b
  pop a
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
  je _if59_else
_if59_true:
;; error("8bit operand expected but 16bit label given."); 
  mov b, __s27 ; "8bit operand expected but 16bit label given."
  swp b
  push b
  call error
  add sp, 2
  jmp _if59_exit
_if59_else:
;; if(operand_types[j] == '@'){ 
_if60_cond:
  lea d, [bp + -132] ; $operand_types
  push a         
  mov b, [bp + -129] ; $j                     
  add d, b
  pop a
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
  je _if60_exit
_if60_true:
;; forwards(2); 
  mov b, $2
  push bl
  call forwards
  add sp, 1
  jmp _if60_exit
_if60_exit:
_if59_exit:
;; j++; 
  mov b, [bp + -129] ; $j             
  mov g, b
  inc b
  lea d, [bp + -129] ; $j
  mov [d], b
  mov b, g
  jmp _if58_exit
_if58_else:
;; if(toktype == INTEGER_CONST){ 
_if61_cond:
  mov b, [_toktype] ; $toktype           
; START RELATIONAL
  push a
  mov a, b
  mov b, 5; INTEGER_CONST
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if61_exit
_if61_true:
;; if(operand_types[j] == '#'){ 
_if62_cond:
  lea d, [bp + -132] ; $operand_types
  push a         
  mov b, [bp + -129] ; $j                     
  add d, b
  pop a
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
  je _if62_else
_if62_true:
;; forwards(1); 
  mov b, $1
  push bl
  call forwards
  add sp, 1
  jmp _if62_exit
_if62_else:
;; if(operand_types[j] == '@'){ 
_if63_cond:
  lea d, [bp + -132] ; $operand_types
  push a         
  mov b, [bp + -129] ; $j                     
  add d, b
  pop a
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
  je _if63_exit
_if63_true:
;; forwards(2); 
  mov b, $2
  push bl
  call forwards
  add sp, 1
  jmp _if63_exit
_if63_exit:
_if62_exit:
;; j++; 
  mov b, [bp + -129] ; $j             
  mov g, b
  inc b
  lea d, [bp + -129] ; $j
  mov [d], b
  mov b, g
  jmp _if61_exit
_if61_exit:
_if58_exit:
_for56_update:
  jmp _for56_cond
_for56_exit:
;; break; 
  jmp _for50_exit ; for break
_for50_update:
  mov b, [bp + -127] ; $i             
  mov g, b
  inc b
  lea d, [bp + -127] ; $i
  mov [d], b
  mov b, g
  jmp _for50_cond
_for50_exit:
_if41_exit:
;; pop_prog(); 
  call pop_prog
  leave
  ret

parse_instr:
  enter 0 ; (push bp; mov bp, sp)
; $opcode 
; $code_line 
; $op 
; $instr_len 
; $num_operands 
; $num_operandsexp 
; $i 
; $j 
; $operand_types 
; $old_pc 
; $has_operands 
  sub sp, 138
;; old_pc = pc; 
  lea d, [bp + -136] ; $old_pc         
  mov b, [_pc] ; $pc                   
  mov [d], b
;; get_line(); 
  call get_line
;; push_prog(); 
  call push_prog
;; strcpy(code_line, string_const); 
  lea d, [bp + -95] ; $code_line
  mov b, d
  swp b
  push b
  mov b, _string_const_data ; $string_const           
  swp b
  push b
  call strcpy
  add sp, 4
;; has_operands = 0; 
  lea d, [bp + -137] ; $has_operands         
  mov b, $0        
  mov [d], bl
;; prog = code_line; 
  mov d, _prog ; $prog
  push d
  lea d, [bp + -95] ; $code_line
  mov b, d
  pop d
  mov [d], b
;; get(); 
  call get
;; for(;;){ 
_for64_init:
_for64_cond:
_for64_block:
;; get(); 
  call get
;; if(toktype == END) break; 
_if65_cond:
  mov b, [_toktype] ; $toktype           
; START RELATIONAL
  push a
  mov a, b
  mov b, 7; END
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if65_exit
_if65_true:
;; break; 
  jmp _for64_exit ; for break
  jmp _if65_exit
_if65_exit:
;; if(toktype == INTEGER_CONST || label_exists(token) != -1){ 
_if66_cond:
  mov b, [_toktype] ; $toktype           
; START RELATIONAL
  push a
  mov a, b
  mov b, 5; INTEGER_CONST
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  push a
  mov a, b
  mov b, _token_data ; $token           
  swp b
  push b
  call label_exists
  add sp, 2
; START RELATIONAL
  push a
  mov a, b
  mov b, $1
  neg b
  cmp a, b
  sneq ; !=
  pop a
; END RELATIONAL
  sor a, b ; ||
  pop a
  cmp b, 0
  je _if66_exit
_if66_true:
;; has_operands = 1; 
  lea d, [bp + -137] ; $has_operands         
  mov b, $1        
  mov [d], bl
;; break; 
  jmp _for64_exit ; for break
  jmp _if66_exit
_if66_exit:
_for64_update:
  jmp _for64_cond
_for64_exit:
;; opcode[0] = '\0'; 
  lea d, [bp + -31] ; $opcode
  push a         
  mov b, $0        
  add d, b
  pop a         
  mov b, $0        
  mov [d], bl
;; prog = code_line; 
  mov d, _prog ; $prog
  push d
  lea d, [bp + -95] ; $code_line
  mov b, d
  pop d
  mov [d], b
;; if(!has_operands){ 
_if67_cond:
  mov bl, [bp + -137] ; $has_operands
  mov bh, 0             
  cmp b, 0
  seq ; !
  cmp b, 0
  je _if67_else
_if67_true:
;; get(); 
  call get
;; strcpy(opcode, token); 
  lea d, [bp + -31] ; $opcode
  mov b, d
  swp b
  push b
  mov b, _token_data ; $token           
  swp b
  push b
  call strcpy
  add sp, 4
;; get();  
  call get
;; if(toktype == END){ 
_if68_cond:
  mov b, [_toktype] ; $toktype           
; START RELATIONAL
  push a
  mov a, b
  mov b, 7; END
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if68_else
_if68_true:
;; strcat(opcode, " ."); 
  lea d, [bp + -31] ; $opcode
  mov b, d
  swp b
  push b
  mov b, __s24 ; " ."
  swp b
  push b
  call strcat
  add sp, 4
  jmp _if68_exit
_if68_else:
;; strcat(opcode, " "); 
  lea d, [bp + -31] ; $opcode
  mov b, d
  swp b
  push b
  mov b, __s25 ; " "
  swp b
  push b
  call strcat
  add sp, 4
;; strcat(opcode, token); 
  lea d, [bp + -31] ; $opcode
  mov b, d
  swp b
  push b
  mov b, _token_data ; $token           
  swp b
  push b
  call strcat
  add sp, 4
;; for(;;){ 
_for69_init:
_for69_cond:
_for69_block:
;; get(); 
  call get
;; if(toktype == END) break; 
_if70_cond:
  mov b, [_toktype] ; $toktype           
; START RELATIONAL
  push a
  mov a, b
  mov b, 7; END
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if70_exit
_if70_true:
;; break; 
  jmp _for69_exit ; for break
  jmp _if70_exit
_if70_exit:
;; strcat(opcode, token); 
  lea d, [bp + -31] ; $opcode
  mov b, d
  swp b
  push b
  mov b, _token_data ; $token           
  swp b
  push b
  call strcat
  add sp, 4
_for69_update:
  jmp _for69_cond
_for69_exit:
_if68_exit:
;; op = search_opcode(opcode); 
  lea d, [bp + -121] ; $op
  push d
  lea d, [bp + -31] ; $opcode
  mov b, d
  swp b
  push b
  call search_opcode
  add sp, 2
  pop d
  mov si, b
  mov di, d
  mov c, 26
  rep movsb
;; instr_len = 1; 
  lea d, [bp + -123] ; $instr_len         
  mov b, $1        
  mov [d], b
;; if(op.opcode_type){ 
_if71_cond:
  lea d, [bp + -121] ; $op
  add d, 25
  clb
  mov bl, [d]
  mov bh, 0
  cmp b, 0
  je _if71_exit
_if71_true:
;; instr_len++; 
  mov b, [bp + -123] ; $instr_len             
  mov g, b
  inc b
  lea d, [bp + -123] ; $instr_len
  mov [d], b
  mov b, g
;; emit_byte(0xFD, emit_override); 
  mov b, $fd
  push bl
  mov bl, [bp + 5] ; $emit_override
  mov bh, 0             
  push bl
  call emit_byte
  add sp, 2
  jmp _if71_exit
_if71_exit:
;; emit_byte(op.opcode, emit_override); 
  lea d, [bp + -121] ; $op
  add d, 24
  clb
  mov bl, [d]
  mov bh, 0
  push bl
  mov bl, [bp + 5] ; $emit_override
  mov bh, 0             
  push bl
  call emit_byte
  add sp, 2
;; if(!emit_override){ 
_if72_cond:
  mov bl, [bp + 5] ; $emit_override
  mov bh, 0             
  cmp b, 0
  seq ; !
  cmp b, 0
  je _if72_exit
_if72_true:
;; printx16(old_pc); print(" ("); printu(instr_len); print(") : "); 
  mov b, [bp + -136] ; $old_pc             
  swp b
  push b
  call printx16
  add sp, 2
;; print(" ("); printu(instr_len); print(") : "); 
  mov b, __s28 ; " ("
  swp b
  push b
  call print
  add sp, 2
;; printu(instr_len); print(") : "); 
  mov b, [bp + -123] ; $instr_len             
  swp b
  push b
  call printu
  add sp, 2
;; print(") : "); 
  mov b, __s29 ; ") : "
  swp b
  push b
  call print
  add sp, 2
;; print(code_line); putchar('\n'); 
  lea d, [bp + -95] ; $code_line
  mov b, d
  swp b
  push b
  call print
  add sp, 2
;; putchar('\n'); 
  mov b, $a
  push bl
  call putchar
  add sp, 1
  jmp _if72_exit
_if72_exit:
  jmp _if67_exit
_if67_else:
;; num_operands = 0; 
  lea d, [bp + -125] ; $num_operands         
  mov b, $0        
  mov [d], b
;; for(;;){ 
_for73_init:
_for73_cond:
_for73_block:
;; get(); 
  call get
;; if(toktype == END) break; 
_if74_cond:
  mov b, [_toktype] ; $toktype           
; START RELATIONAL
  push a
  mov a, b
  mov b, 7; END
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if74_exit
_if74_true:
;; break; 
  jmp _for73_exit ; for break
  jmp _if74_exit
_if74_exit:
;; if(toktype == INTEGER_CONST || label_exists(token) != -1) num_operands++; 
_if75_cond:
  mov b, [_toktype] ; $toktype           
; START RELATIONAL
  push a
  mov a, b
  mov b, 5; INTEGER_CONST
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  push a
  mov a, b
  mov b, _token_data ; $token           
  swp b
  push b
  call label_exists
  add sp, 2
; START RELATIONAL
  push a
  mov a, b
  mov b, $1
  neg b
  cmp a, b
  sneq ; !=
  pop a
; END RELATIONAL
  sor a, b ; ||
  pop a
  cmp b, 0
  je _if75_exit
_if75_true:
;; num_operands++; 
  mov b, [bp + -125] ; $num_operands             
  mov g, b
  inc b
  lea d, [bp + -125] ; $num_operands
  mov [d], b
  mov b, g
  jmp _if75_exit
_if75_exit:
_for73_update:
  jmp _for73_cond
_for73_exit:
;; if(num_operands > 2) error("Maximum number of operands per instruction is 2."); 
_if76_cond:
  mov b, [bp + -125] ; $num_operands             
; START RELATIONAL
  push a
  mov a, b
  mov b, $2
  cmp a, b
  sgt ; >
  pop a
; END RELATIONAL
  cmp b, 0
  je _if76_exit
_if76_true:
;; error("Maximum number of operands per instruction is 2."); 
  mov b, __s26 ; "Maximum number of operands per instruction is 2."
  swp b
  push b
  call error
  add sp, 2
  jmp _if76_exit
_if76_exit:
;; num_operandsexp = exp(2, num_operands); 
  lea d, [bp + -127] ; $num_operandsexp
  push d
  mov b, $2
  swp b
  push b
  mov b, [bp + -125] ; $num_operands             
  swp b
  push b
  call exp
  add sp, 4
  pop d
  mov [d], b
;; for(i = 0; i < num_operandsexp; i++){ 
_for77_init:
  lea d, [bp + -129] ; $i         
  mov b, $0        
  mov [d], b
_for77_cond:
  mov b, [bp + -129] ; $i             
; START RELATIONAL
  push a
  mov a, b
  mov b, [bp + -127] ; $num_operandsexp             
  cmp a, b
  slt ; < 
  pop a
; END RELATIONAL
  cmp b, 0
  je _for77_exit
_for77_block:
;; prog = code_line; 
  mov d, _prog ; $prog
  push d
  lea d, [bp + -95] ; $code_line
  mov b, d
  pop d
  mov [d], b
;; get(); 
  call get
;; strcpy(opcode, token); 
  lea d, [bp + -31] ; $opcode
  mov b, d
  swp b
  push b
  mov b, _token_data ; $token           
  swp b
  push b
  call strcpy
  add sp, 4
;; strcat(opcode, " "); 
  lea d, [bp + -31] ; $opcode
  mov b, d
  swp b
  push b
  mov b, __s25 ; " "
  swp b
  push b
  call strcat
  add sp, 4
;; j = 0; 
  lea d, [bp + -131] ; $j         
  mov b, $0        
  mov [d], b
;; for(;;){ 
_for78_init:
_for78_cond:
_for78_block:
;; get(); 
  call get
;; if(toktype == END) break; 
_if79_cond:
  mov b, [_toktype] ; $toktype           
; START RELATIONAL
  push a
  mov a, b
  mov b, 7; END
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if79_exit
_if79_true:
;; break; 
  jmp _for78_exit ; for break
  jmp _if79_exit
_if79_exit:
;; if(toktype == INTEGER_CONST || label_exists(token) != -1){ 
_if80_cond:
  mov b, [_toktype] ; $toktype           
; START RELATIONAL
  push a
  mov a, b
  mov b, 5; INTEGER_CONST
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  push a
  mov a, b
  mov b, _token_data ; $token           
  swp b
  push b
  call label_exists
  add sp, 2
; START RELATIONAL
  push a
  mov a, b
  mov b, $1
  neg b
  cmp a, b
  sneq ; !=
  pop a
; END RELATIONAL
  sor a, b ; ||
  pop a
  cmp b, 0
  je _if80_else
_if80_true:
;; strcat(opcode, symbols[i*2+j]); 
  lea d, [bp + -31] ; $opcode
  mov b, d
  swp b
  push b
  mov d, _symbols_data ; $symbols
  push a         
  mov b, [bp + -129] ; $i             
; START FACTORS
  push a
  mov a, b
  mov b, $2
  mul a, b ; *
  mov a, b
  mov b, a
  pop a
; END FACTORS
; START TERMS
  push a
  mov a, b
  mov b, [bp + -131] ; $j             
  add a, b
  mov b, a
  pop a
; END TERMS        
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  swp b
  push b
  call strcat
  add sp, 4
;; operand_types[j] = *symbols[i*2+j]; 
  lea d, [bp + -134] ; $operand_types
  push a         
  mov b, [bp + -131] ; $j                     
  add d, b
  pop a
  push d
  mov d, _symbols_data ; $symbols
  push a         
  mov b, [bp + -129] ; $i             
; START FACTORS
  push a
  mov a, b
  mov b, $2
  mul a, b ; *
  mov a, b
  mov b, a
  pop a
; END FACTORS
; START TERMS
  push a
  mov a, b
  mov b, [bp + -131] ; $j             
  add a, b
  mov b, a
  pop a
; END TERMS        
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; j++; 
  mov b, [bp + -131] ; $j             
  mov g, b
  inc b
  lea d, [bp + -131] ; $j
  mov [d], b
  mov b, g
  jmp _if80_exit
_if80_else:
;; strcat(opcode, token); 
  lea d, [bp + -31] ; $opcode
  mov b, d
  swp b
  push b
  mov b, _token_data ; $token           
  swp b
  push b
  call strcat
  add sp, 4
_if80_exit:
_for78_update:
  jmp _for78_cond
_for78_exit:
;; op = search_opcode(opcode); 
  lea d, [bp + -121] ; $op
  push d
  lea d, [bp + -31] ; $opcode
  mov b, d
  swp b
  push b
  call search_opcode
  add sp, 2
  pop d
  mov si, b
  mov di, d
  mov c, 26
  rep movsb
;; if(op.name[0] == '\0') continue; 
_if81_cond:
  lea d, [bp + -121] ; $op
  add d, 0
  clb
  push a         
  mov b, $0        
  add d, b
  pop a
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
  je _if81_exit
_if81_true:
;; continue; 
  jmp _for77_update ; for continue
  jmp _if81_exit
_if81_exit:
;; instr_len = 1; 
  lea d, [bp + -123] ; $instr_len         
  mov b, $1        
  mov [d], b
;; if(op.opcode_type){ 
_if82_cond:
  lea d, [bp + -121] ; $op
  add d, 25
  clb
  mov bl, [d]
  mov bh, 0
  cmp b, 0
  je _if82_exit
_if82_true:
;; emit_byte(0xFD, emit_override); 
  mov b, $fd
  push bl
  mov bl, [bp + 5] ; $emit_override
  mov bh, 0             
  push bl
  call emit_byte
  add sp, 2
;; instr_len++; 
  mov b, [bp + -123] ; $instr_len             
  mov g, b
  inc b
  lea d, [bp + -123] ; $instr_len
  mov [d], b
  mov b, g
  jmp _if82_exit
_if82_exit:
;; emit_byte(op.opcode, emit_override); 
  lea d, [bp + -121] ; $op
  add d, 24
  clb
  mov bl, [d]
  mov bh, 0
  push bl
  mov bl, [bp + 5] ; $emit_override
  mov bh, 0             
  push bl
  call emit_byte
  add sp, 2
;; prog = code_line; 
  mov d, _prog ; $prog
  push d
  lea d, [bp + -95] ; $code_line
  mov b, d
  pop d
  mov [d], b
;; j = 0; 
  lea d, [bp + -131] ; $j         
  mov b, $0        
  mov [d], b
;; get(); 
  call get
;; for(;;){ 
_for83_init:
_for83_cond:
_for83_block:
;; get(); 
  call get
;; if(toktype == END) break; 
_if84_cond:
  mov b, [_toktype] ; $toktype           
; START RELATIONAL
  push a
  mov a, b
  mov b, 7; END
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if84_exit
_if84_true:
;; break; 
  jmp _for83_exit ; for break
  jmp _if84_exit
_if84_exit:
;; if(toktype == IDENTIFIER){ 
_if85_cond:
  mov b, [_toktype] ; $toktype           
; START RELATIONAL
  push a
  mov a, b
  mov b, 6; IDENTIFIER
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if85_else
_if85_true:
;; if(label_exists(token) != -1){ 
_if86_cond:
  mov b, _token_data ; $token           
  swp b
  push b
  call label_exists
  add sp, 2
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
  je _if86_else
_if86_true:
;; if(operand_types[j] == '#'){ 
_if87_cond:
  lea d, [bp + -134] ; $operand_types
  push a         
  mov b, [bp + -131] ; $j                     
  add d, b
  pop a
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
  je _if87_else
_if87_true:
;; error("8bit operand expected but 16bit label given."); 
  mov b, __s27 ; "8bit operand expected but 16bit label given."
  swp b
  push b
  call error
  add sp, 2
  jmp _if87_exit
_if87_else:
;; if(operand_types[j] == '@'){ 
_if88_cond:
  lea d, [bp + -134] ; $operand_types
  push a         
  mov b, [bp + -131] ; $j                     
  add d, b
  pop a
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
  je _if88_exit
_if88_true:
;; emit_word(get_label_addr(token), emit_override); 
  mov b, _token_data ; $token           
  swp b
  push b
  call get_label_addr
  add sp, 2
  swp b
  push b
  mov bl, [bp + 5] ; $emit_override
  mov bh, 0             
  push bl
  call emit_word
  add sp, 3
;; instr_len = instr_len + 2; 
  lea d, [bp + -123] ; $instr_len         
  mov b, [bp + -123] ; $instr_len             
; START TERMS
  push a
  mov a, b
  mov b, $2
  add a, b
  mov b, a
  pop a
; END TERMS        
  mov [d], b
  jmp _if88_exit
_if88_exit:
_if87_exit:
;; j++; 
  mov b, [bp + -131] ; $j             
  mov g, b
  inc b
  lea d, [bp + -131] ; $j
  mov [d], b
  mov b, g
  jmp _if86_exit
_if86_else:
;; if(!is_reserved(token)){ 
_if89_cond:
  mov b, _token_data ; $token           
  swp b
  push b
  call is_reserved
  add sp, 2
  cmp b, 0
  seq ; !
  cmp b, 0
  je _if89_exit
_if89_true:
;; error_s("Undeclared label: ", token); 
  mov b, __s30 ; "Undeclared label: "
  swp b
  push b
  mov b, _token_data ; $token           
  swp b
  push b
  call error_s
  add sp, 4
  jmp _if89_exit
_if89_exit:
_if86_exit:
  jmp _if85_exit
_if85_else:
;; if(toktype == INTEGER_CONST){ 
_if90_cond:
  mov b, [_toktype] ; $toktype           
; START RELATIONAL
  push a
  mov a, b
  mov b, 5; INTEGER_CONST
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if90_exit
_if90_true:
;; if(operand_types[j] == '#'){ 
_if91_cond:
  lea d, [bp + -134] ; $operand_types
  push a         
  mov b, [bp + -131] ; $j                     
  add d, b
  pop a
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
  je _if91_else
_if91_true:
;; emit_byte(int_const, emit_override); 
  mov b, [_int_const] ; $int_const           
  push bl
  mov bl, [bp + 5] ; $emit_override
  mov bh, 0             
  push bl
  call emit_byte
  add sp, 2
;; instr_len++; 
  mov b, [bp + -123] ; $instr_len             
  mov g, b
  inc b
  lea d, [bp + -123] ; $instr_len
  mov [d], b
  mov b, g
  jmp _if91_exit
_if91_else:
;; if(operand_types[j] == '@'){ 
_if92_cond:
  lea d, [bp + -134] ; $operand_types
  push a         
  mov b, [bp + -131] ; $j                     
  add d, b
  pop a
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
  je _if92_exit
_if92_true:
;; emit_word(int_const, emit_override); 
  mov b, [_int_const] ; $int_const           
  swp b
  push b
  mov bl, [bp + 5] ; $emit_override
  mov bh, 0             
  push bl
  call emit_word
  add sp, 3
;; instr_len = instr_len + 2; 
  lea d, [bp + -123] ; $instr_len         
  mov b, [bp + -123] ; $instr_len             
; START TERMS
  push a
  mov a, b
  mov b, $2
  add a, b
  mov b, a
  pop a
; END TERMS        
  mov [d], b
  jmp _if92_exit
_if92_exit:
_if91_exit:
;; j++; 
  mov b, [bp + -131] ; $j             
  mov g, b
  inc b
  lea d, [bp + -131] ; $j
  mov [d], b
  mov b, g
  jmp _if90_exit
_if90_exit:
_if85_exit:
_for83_update:
  jmp _for83_cond
_for83_exit:
;; if(!emit_override){ 
_if93_cond:
  mov bl, [bp + 5] ; $emit_override
  mov bh, 0             
  cmp b, 0
  seq ; !
  cmp b, 0
  je _if93_exit
_if93_true:
;; printx16(old_pc); print(" ("); printu(instr_len); print(") : "); 
  mov b, [bp + -136] ; $old_pc             
  swp b
  push b
  call printx16
  add sp, 2
;; print(" ("); printu(instr_len); print(") : "); 
  mov b, __s28 ; " ("
  swp b
  push b
  call print
  add sp, 2
;; printu(instr_len); print(") : "); 
  mov b, [bp + -123] ; $instr_len             
  swp b
  push b
  call printu
  add sp, 2
;; print(") : "); 
  mov b, __s29 ; ") : "
  swp b
  push b
  call print
  add sp, 2
;; print(code_line); putchar('\n'); 
  lea d, [bp + -95] ; $code_line
  mov b, d
  swp b
  push b
  call print
  add sp, 2
;; putchar('\n'); 
  mov b, $a
  push bl
  call putchar
  add sp, 1
  jmp _if93_exit
_if93_exit:
;; break; 
  jmp _for77_exit ; for break
_for77_update:
  mov b, [bp + -129] ; $i             
  mov g, b
  inc b
  lea d, [bp + -129] ; $i
  mov [d], b
  mov b, g
  jmp _for77_cond
_for77_exit:
_if67_exit:
;; pop_prog(); 
  call pop_prog
  leave
  ret

parse_text:
  enter 0 ; (push bp; mov bp, sp)
; $temp_prog 
  sub sp, 2
;; print("Parsing TEXT section...\n"); 
  mov b, __s31 ; "Parsing TEXT section...\n"
  swp b
  push b
  call print
  add sp, 2
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
;; for(;;){ 
_for94_init:
_for94_cond:
_for94_block:
;; get(); 
  call get
;; if(toktype == END) error("TEXT section not found."); 
_if95_cond:
  mov b, [_toktype] ; $toktype           
; START RELATIONAL
  push a
  mov a, b
  mov b, 7; END
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if95_exit
_if95_true:
;; error("TEXT section not found."); 
  mov b, __s32 ; "TEXT section not found."
  swp b
  push b
  call error
  add sp, 2
  jmp _if95_exit
_if95_exit:
;; if(tok == TEXT){ 
_if96_cond:
  mov b, [_tok] ; $tok           
; START RELATIONAL
  push a
  mov a, b
  mov b, 4; TEXT
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if96_exit
_if96_true:
;; break; 
  jmp _for94_exit ; for break
  jmp _if96_exit
_if96_exit:
_for94_update:
  jmp _for94_cond
_for94_exit:
;; for(;;){ 
_for97_init:
_for97_cond:
_for97_block:
;; get(); back(); 
  call get
;; back(); 
  call back
;; temp_prog = prog; 
  lea d, [bp + -1] ; $temp_prog         
  mov b, [_prog] ; $prog                   
  mov [d], b
;; get(); 
  call get
;; if(toktype == END) error("TEXT section end not found."); 
_if98_cond:
  mov b, [_toktype] ; $toktype           
; START RELATIONAL
  push a
  mov a, b
  mov b, 7; END
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if98_exit
_if98_true:
;; error("TEXT section end not found."); 
  mov b, __s33 ; "TEXT section end not found."
  swp b
  push b
  call error
  add sp, 2
  jmp _if98_exit
_if98_exit:
;; if(tok == DOT){ 
_if99_cond:
  mov b, [_tok] ; $tok           
; START RELATIONAL
  push a
  mov a, b
  mov b, 16; DOT
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if99_else
_if99_true:
;; get(); 
  call get
;; if(tok == SEGMENT_END) break; 
_if100_cond:
  mov b, [_tok] ; $tok           
; START RELATIONAL
  push a
  mov a, b
  mov b, 5; SEGMENT_END
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if100_else
_if100_true:
;; break; 
  jmp _for97_exit ; for break
  jmp _if100_exit
_if100_else:
;; error("Unexpected directive."); 
  mov b, __s34 ; "Unexpected directive."
  swp b
  push b
  call error
  add sp, 2
_if100_exit:
  jmp _if99_exit
_if99_else:
;; if(toktype == IDENTIFIER){ 
_if101_cond:
  mov b, [_toktype] ; $toktype           
; START RELATIONAL
  push a
  mov a, b
  mov b, 6; IDENTIFIER
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if101_exit
_if101_true:
;; get(); 
  call get
;; if(tok != COLON){ 
_if102_cond:
  mov b, [_tok] ; $tok           
; START RELATIONAL
  push a
  mov a, b
  mov b, 13; COLON
  cmp a, b
  sneq ; !=
  pop a
; END RELATIONAL
  cmp b, 0
  je _if102_exit
_if102_true:
;; prog = temp_prog; 
  mov d, _prog ; $prog         
  mov b, [bp + -1] ; $temp_prog                     
  mov [d], b
;; parse_instr(0); 
  mov b, $0
  push bl
  call parse_instr
  add sp, 1
  jmp _if102_exit
_if102_exit:
  jmp _if101_exit
_if101_exit:
_if99_exit:
_for97_update:
  jmp _for97_cond
_for97_exit:
;; print("Done.\n\n"); 
  mov b, __s35 ; "Done.\n\n"
  swp b
  push b
  call print
  add sp, 2
  leave
  ret

debug:
  enter 0 ; (push bp; mov bp, sp)
;; print("\n"); 
  mov b, __s9 ; "\n"
  swp b
  push b
  call print
  add sp, 2
;; print("Prog Offset: "); printx16(prog-program); print(", "); 
  mov b, __s36 ; "Prog Offset: "
  swp b
  push b
  call print
  add sp, 2
;; printx16(prog-program); print(", "); 
  mov b, [_prog] ; $prog           
; START TERMS
  push a
  mov a, b
  mov b, [_program] ; $program           
  sub a, b
  mov b, a
  pop a
; END TERMS
  swp b
  push b
  call printx16
  add sp, 2
;; print(", "); 
  mov b, __s14 ; ", "
  swp b
  push b
  call print
  add sp, 2
;; print("Prog value : "); putchar(*prog); print("\n"); 
  mov b, __s37 ; "Prog value : "
  swp b
  push b
  call print
  add sp, 2
;; putchar(*prog); print("\n"); 
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
  push bl
  call putchar
  add sp, 1
;; print("\n"); 
  mov b, __s9 ; "\n"
  swp b
  push b
  call print
  add sp, 2
;; print("Token       : "); print(token); print(", "); 
  mov b, __s38 ; "Token       : "
  swp b
  push b
  call print
  add sp, 2
;; print(token); print(", "); 
  mov b, _token_data ; $token           
  swp b
  push b
  call print
  add sp, 2
;; print(", "); 
  mov b, __s14 ; ", "
  swp b
  push b
  call print
  add sp, 2
;; print("Tok: "); printu(tok); print(", "); 
  mov b, __s39 ; "Tok: "
  swp b
  push b
  call print
  add sp, 2
;; printu(tok); print(", "); 
  mov b, [_tok] ; $tok           
  swp b
  push b
  call printu
  add sp, 2
;; print(", "); 
  mov b, __s14 ; ", "
  swp b
  push b
  call print
  add sp, 2
;; print("Toktype: "); printu(toktype); print("\n"); 
  mov b, __s40 ; "Toktype: "
  swp b
  push b
  call print
  add sp, 2
;; printu(toktype); print("\n"); 
  mov b, [_toktype] ; $toktype           
  swp b
  push b
  call printu
  add sp, 2
;; print("\n"); 
  mov b, __s9 ; "\n"
  swp b
  push b
  call print
  add sp, 2
;; print("StringConst : "); print(string_const); print("\n"); 
  mov b, __s41 ; "StringConst : "
  swp b
  push b
  call print
  add sp, 2
;; print(string_const); print("\n"); 
  mov b, _string_const_data ; $string_const           
  swp b
  push b
  call print
  add sp, 2
;; print("\n"); 
  mov b, __s9 ; "\n"
  swp b
  push b
  call print
  add sp, 2
;; print("PC          : "); printx16(pc); 
  mov b, __s42 ; "PC          : "
  swp b
  push b
  call print
  add sp, 2
;; printx16(pc); 
  mov b, [_pc] ; $pc           
  swp b
  push b
  call printx16
  add sp, 2
;; print("\n"); 
  mov b, __s9 ; "\n"
  swp b
  push b
  call print
  add sp, 2
  leave
  ret

display_output:
  enter 0 ; (push bp; mov bp, sp)
; $i 
; $p 
  sub sp, 4
;; print("\nAssembly complete.\n"); 
  mov b, __s43 ; "\nAssembly complete.\n"
  swp b
  push b
  call print
  add sp, 2
;; print_info2("Program size: ", prog_size, "\n"); 
  mov b, __s44 ; "Program size: "
  swp b
  push b
  mov b, [_prog_size] ; $prog_size           
  swp b
  push b
  mov b, __s9 ; "\n"
  swp b
  push b
  call print_info2
  add sp, 6
;; print("Listing: \n"); 
  mov b, __s45 ; "Listing: \n"
  swp b
  push b
  call print
  add sp, 2
;; p = bin_out + _org; 
  lea d, [bp + -3] ; $p         
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
;; for(;;){ 
_for103_init:
_for103_cond:
_for103_block:
;; if(p == bin_p) break; 
_if104_cond:
  mov b, [bp + -3] ; $p             
; START RELATIONAL
  push a
  mov a, b
  mov b, [_bin_p] ; $bin_p           
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if104_exit
_if104_true:
;; break; 
  jmp _for103_exit ; for break
  jmp _if104_exit
_if104_exit:
;; printx8(*p);  
  mov b, [bp + -3] ; $p             
  mov d, b
  mov bl, [d]
  mov bh, 0
  push bl
  call printx8
  add sp, 1
;; p++; 
  mov b, [bp + -3] ; $p             
  mov g, b
  inc b
  lea d, [bp + -3] ; $p
  mov [d], b
  mov b, g
_for103_update:
  jmp _for103_cond
_for103_exit:
;; print("\n"); 
  mov b, __s9 ; "\n"
  swp b
  push b
  call print
  add sp, 2
  leave
  ret

is_reserved:
  enter 0 ; (push bp; mov bp, sp)
;; return !strcmp(name, "a") 
  mov b, [bp + 5] ; $name             
  swp b
  push b
  mov b, __s46 ; "a"
  swp b
  push b
  call strcmp
  add sp, 4
  cmp b, 0
  seq ; !
  push a
  mov a, b
  mov b, [bp + 5] ; $name             
  swp b
  push b
  mov b, __s47 ; "al"
  swp b
  push b
  call strcmp
  add sp, 4
  cmp b, 0
  seq ; !
  sor a, b ; ||
  mov a, b
  mov b, [bp + 5] ; $name             
  swp b
  push b
  mov b, __s48 ; "ah"
  swp b
  push b
  call strcmp
  add sp, 4
  cmp b, 0
  seq ; !
  sor a, b ; ||
  mov a, b
  mov b, [bp + 5] ; $name             
  swp b
  push b
  mov b, __s49 ; "b"
  swp b
  push b
  call strcmp
  add sp, 4
  cmp b, 0
  seq ; !
  sor a, b ; ||
  mov a, b
  mov b, [bp + 5] ; $name             
  swp b
  push b
  mov b, __s50 ; "bl"
  swp b
  push b
  call strcmp
  add sp, 4
  cmp b, 0
  seq ; !
  sor a, b ; ||
  mov a, b
  mov b, [bp + 5] ; $name             
  swp b
  push b
  mov b, __s51 ; "bh"
  swp b
  push b
  call strcmp
  add sp, 4
  cmp b, 0
  seq ; !
  sor a, b ; ||
  mov a, b
  mov b, [bp + 5] ; $name             
  swp b
  push b
  mov b, __s52 ; "c"
  swp b
  push b
  call strcmp
  add sp, 4
  cmp b, 0
  seq ; !
  sor a, b ; ||
  mov a, b
  mov b, [bp + 5] ; $name             
  swp b
  push b
  mov b, __s53 ; "cl"
  swp b
  push b
  call strcmp
  add sp, 4
  cmp b, 0
  seq ; !
  sor a, b ; ||
  mov a, b
  mov b, [bp + 5] ; $name             
  swp b
  push b
  mov b, __s54 ; "ch"
  swp b
  push b
  call strcmp
  add sp, 4
  cmp b, 0
  seq ; !
  sor a, b ; ||
  mov a, b
  mov b, [bp + 5] ; $name             
  swp b
  push b
  mov b, __s55 ; "d"
  swp b
  push b
  call strcmp
  add sp, 4
  cmp b, 0
  seq ; !
  sor a, b ; ||
  mov a, b
  mov b, [bp + 5] ; $name             
  swp b
  push b
  mov b, __s56 ; "dl"
  swp b
  push b
  call strcmp
  add sp, 4
  cmp b, 0
  seq ; !
  sor a, b ; ||
  mov a, b
  mov b, [bp + 5] ; $name             
  swp b
  push b
  mov b, __s57 ; "dh"
  swp b
  push b
  call strcmp
  add sp, 4
  cmp b, 0
  seq ; !
  sor a, b ; ||
  mov a, b
  mov b, [bp + 5] ; $name             
  swp b
  push b
  mov b, __s58 ; "g"
  swp b
  push b
  call strcmp
  add sp, 4
  cmp b, 0
  seq ; !
  sor a, b ; ||
  mov a, b
  mov b, [bp + 5] ; $name             
  swp b
  push b
  mov b, __s59 ; "gl"
  swp b
  push b
  call strcmp
  add sp, 4
  cmp b, 0
  seq ; !
  sor a, b ; ||
  mov a, b
  mov b, [bp + 5] ; $name             
  swp b
  push b
  mov b, __s60 ; "gh"
  swp b
  push b
  call strcmp
  add sp, 4
  cmp b, 0
  seq ; !
  sor a, b ; ||
  mov a, b
  mov b, [bp + 5] ; $name             
  swp b
  push b
  mov b, __s61 ; "pc"
  swp b
  push b
  call strcmp
  add sp, 4
  cmp b, 0
  seq ; !
  sor a, b ; ||
  mov a, b
  mov b, [bp + 5] ; $name             
  swp b
  push b
  mov b, __s62 ; "sp"
  swp b
  push b
  call strcmp
  add sp, 4
  cmp b, 0
  seq ; !
  sor a, b ; ||
  mov a, b
  mov b, [bp + 5] ; $name             
  swp b
  push b
  mov b, __s63 ; "bp"
  swp b
  push b
  call strcmp
  add sp, 4
  cmp b, 0
  seq ; !
  sor a, b ; ||
  mov a, b
  mov b, [bp + 5] ; $name             
  swp b
  push b
  mov b, __s64 ; "si"
  swp b
  push b
  call strcmp
  add sp, 4
  cmp b, 0
  seq ; !
  sor a, b ; ||
  mov a, b
  mov b, [bp + 5] ; $name             
  swp b
  push b
  mov b, __s65 ; "di"
  swp b
  push b
  call strcmp
  add sp, 4
  cmp b, 0
  seq ; !
  sor a, b ; ||
  mov a, b
  mov b, [bp + 5] ; $name             
  swp b
  push b
  mov b, __s66 ; "word"
  swp b
  push b
  call strcmp
  add sp, 4
  cmp b, 0
  seq ; !
  sor a, b ; ||
  mov a, b
  mov b, [bp + 5] ; $name             
  swp b
  push b
  mov b, __s67 ; "byte"
  swp b
  push b
  call strcmp
  add sp, 4
  cmp b, 0
  seq ; !
  sor a, b ; ||
  mov a, b
  mov b, [bp + 5] ; $name             
  swp b
  push b
  mov b, __s68 ; "cmpsb"
  swp b
  push b
  call strcmp
  add sp, 4
  cmp b, 0
  seq ; !
  sor a, b ; ||
  mov a, b
  mov b, [bp + 5] ; $name             
  swp b
  push b
  mov b, __s69 ; "movsb"
  swp b
  push b
  call strcmp
  add sp, 4
  cmp b, 0
  seq ; !
  sor a, b ; ||
  mov a, b
  mov b, [bp + 5] ; $name             
  swp b
  push b
  mov b, __s70 ; "stosb"
  swp b
  push b
  call strcmp
  add sp, 4
  cmp b, 0
  seq ; !
  sor a, b ; ||
  pop a
  leave
  ret

is_directive:
  enter 0 ; (push bp; mov bp, sp)
;; return !strcmp(name, "org")  
  mov b, [bp + 5] ; $name             
  swp b
  push b
  mov b, __s0 ; "org"
  swp b
  push b
  call strcmp
  add sp, 4
  cmp b, 0
  seq ; !
  push a
  mov a, b
  mov b, [bp + 5] ; $name             
  swp b
  push b
  mov b, __s71 ; "define"
  swp b
  push b
  call strcmp
  add sp, 4
  cmp b, 0
  seq ; !
  sor a, b ; ||
  pop a
  leave
  ret

parse_label:
  enter 0 ; (push bp; mov bp, sp)
; $label_name 
  sub sp, 32
;; get(); 
  call get
;; strcpy(label_name, token); 
  lea d, [bp + -31] ; $label_name
  mov b, d
  swp b
  push b
  mov b, _token_data ; $token           
  swp b
  push b
  call strcpy
  add sp, 4
;; declare_label(label_name, pc); 
  lea d, [bp + -31] ; $label_name
  mov b, d
  swp b
  push b
  mov b, [_pc] ; $pc           
  swp b
  push b
  call declare_label
  add sp, 4
;; get(); // get ':' 
  call get
  leave
  ret

declare_label:
  enter 0 ; (push bp; mov bp, sp)
; $i 
  sub sp, 2
;; for(i = 0; i <  16         ; i++){ 
_for105_init:
  lea d, [bp + -1] ; $i         
  mov b, $0        
  mov [d], b
_for105_cond:
  mov b, [bp + -1] ; $i             
; START RELATIONAL
  push a
  mov a, b
  mov b, $10
  cmp a, b
  slt ; < 
  pop a
; END RELATIONAL
  cmp b, 0
  je _for105_exit
_for105_block:
;; if(!label_table[i].name[0]){ 
_if106_cond:
  mov d, _label_table_data ; $label_table
  push a         
  mov b, [bp + -1] ; $i                     
  mma 18 ; mov a, 18; mul a, b; add d, b
  pop a
  add d, 0
  clb
  push a         
  mov b, $0        
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  cmp b, 0
  seq ; !
  cmp b, 0
  je _if106_exit
_if106_true:
;; strcpy(label_table[i].name, name); 
  mov d, _label_table_data ; $label_table
  push a         
  mov b, [bp + -1] ; $i                     
  mma 18 ; mov a, 18; mul a, b; add d, b
  pop a
  add d, 0
  clb
  mov b, d
  swp b
  push b
  mov b, [bp + 7] ; $name             
  swp b
  push b
  call strcpy
  add sp, 4
;; label_table[i].address = address; 
  mov d, _label_table_data ; $label_table
  push a         
  mov b, [bp + -1] ; $i                     
  mma 18 ; mov a, 18; mul a, b; add d, b
  pop a
  add d, 16
  clb         
  mov b, [bp + 5] ; $address                     
  mov [d], b
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
  leave
  ret

get_label_addr:
  enter 0 ; (push bp; mov bp, sp)
; $i 
  sub sp, 2
;; for(i = 0; i <  16         ; i++){ 
_for107_init:
  lea d, [bp + -1] ; $i         
  mov b, $0        
  mov [d], b
_for107_cond:
  mov b, [bp + -1] ; $i             
; START RELATIONAL
  push a
  mov a, b
  mov b, $10
  cmp a, b
  slt ; < 
  pop a
; END RELATIONAL
  cmp b, 0
  je _for107_exit
_for107_block:
;; if(!strcmp(label_table[i].name, name)){ 
_if108_cond:
  mov d, _label_table_data ; $label_table
  push a         
  mov b, [bp + -1] ; $i                     
  mma 18 ; mov a, 18; mul a, b; add d, b
  pop a
  add d, 0
  clb
  mov b, d
  swp b
  push b
  mov b, [bp + 5] ; $name             
  swp b
  push b
  call strcmp
  add sp, 4
  cmp b, 0
  seq ; !
  cmp b, 0
  je _if108_exit
_if108_true:
;; return label_table[i].address; 
  mov d, _label_table_data ; $label_table
  push a         
  mov b, [bp + -1] ; $i                     
  mma 18 ; mov a, 18; mul a, b; add d, b
  pop a
  add d, 16
  clb
  mov b, [d]
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
;; error_s("Label does not exist: ", name); 
  mov b, __s72 ; "Label does not exist: "
  swp b
  push b
  mov b, [bp + 5] ; $name             
  swp b
  push b
  call error_s
  add sp, 4
  leave
  ret

label_exists:
  enter 0 ; (push bp; mov bp, sp)
; $i 
  sub sp, 2
;; for(i = 0; i <  16         ; i++){ 
_for109_init:
  lea d, [bp + -1] ; $i         
  mov b, $0        
  mov [d], b
_for109_cond:
  mov b, [bp + -1] ; $i             
; START RELATIONAL
  push a
  mov a, b
  mov b, $10
  cmp a, b
  slt ; < 
  pop a
; END RELATIONAL
  cmp b, 0
  je _for109_exit
_for109_block:
;; if(!strcmp(label_table[i].name, name)){ 
_if110_cond:
  mov d, _label_table_data ; $label_table
  push a         
  mov b, [bp + -1] ; $i                     
  mma 18 ; mov a, 18; mul a, b; add d, b
  pop a
  add d, 0
  clb
  mov b, d
  swp b
  push b
  mov b, [bp + 5] ; $name             
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

print_info:
  enter 0 ; (push bp; mov bp, sp)
;; if(print_information){ 
_if111_cond:
  mov d, _print_information ; $print_information
  mov bl, [d]
  mov bh, 0
  cmp b, 0
  je _if111_exit
_if111_true:
;; print(s1); 
  mov b, [bp + 9] ; $s1             
  swp b
  push b
  call print
  add sp, 2
;; print(s2); 
  mov b, [bp + 7] ; $s2             
  swp b
  push b
  call print
  add sp, 2
;; print(s3); 
  mov b, [bp + 5] ; $s3             
  swp b
  push b
  call print
  add sp, 2
  jmp _if111_exit
_if111_exit:
  leave
  ret

print_info2:
  enter 0 ; (push bp; mov bp, sp)
;; if(print_information){ 
_if112_cond:
  mov d, _print_information ; $print_information
  mov bl, [d]
  mov bh, 0
  cmp b, 0
  je _if112_exit
_if112_true:
;; print(s1); 
  mov b, [bp + 9] ; $s1             
  swp b
  push b
  call print
  add sp, 2
;; printu(n); 
  mov b, [bp + 7] ; $n             
  swp b
  push b
  call printu
  add sp, 2
;; print(s2); 
  mov b, [bp + 5] ; $s2             
  swp b
  push b
  call print
  add sp, 2
  jmp _if112_exit
_if112_exit:
  leave
  ret

search_opcode:
  enter 0 ; (push bp; mov bp, sp)
; $opcode_str 
; $opcode_hex 
; $hex_p 
; $op_p 
; $tbl_p 
; $return_opcode 
  sub sp, 61
;; tbl_p = opcode_table; 
  lea d, [bp + -34] ; $tbl_p         
  mov b, [_opcode_table] ; $opcode_table                   
  mov [d], b
;; for(;;){ 
_for113_init:
_for113_cond:
_for113_block:
;; op_p = opcode_str; 
  lea d, [bp + -32] ; $op_p
  push d
  lea d, [bp + -23] ; $opcode_str
  mov b, d
  pop d
  mov [d], b
;; hex_p = opcode_hex; 
  lea d, [bp + -30] ; $hex_p
  push d
  lea d, [bp + -28] ; $opcode_hex
  mov b, d
  pop d
  mov [d], b
;; while(*tbl_p != ' ') *op_p++ = *tbl_p++; 
_while114_cond:
  mov b, [bp + -34] ; $tbl_p             
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $20
  cmp a, b
  sneq ; !=
  pop a
; END RELATIONAL
  cmp b, 0
  je _while114_exit
_while114_block:
;; *op_p++ = *tbl_p++; 
  mov b, [bp + -32] ; $op_p             
  mov g, b
  inc b
  lea d, [bp + -32] ; $op_p
  mov [d], b
  mov b, g
  push b
  mov b, [bp + -34] ; $tbl_p             
  mov g, b
  inc b
  lea d, [bp + -34] ; $tbl_p
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
  jmp _while114_cond
_while114_exit:
;; *op_p++ = *tbl_p++; 
  mov b, [bp + -32] ; $op_p             
  mov g, b
  inc b
  lea d, [bp + -32] ; $op_p
  mov [d], b
  mov b, g
  push b
  mov b, [bp + -34] ; $tbl_p             
  mov g, b
  inc b
  lea d, [bp + -34] ; $tbl_p
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; while(*tbl_p != ' ') *op_p++ = *tbl_p++; 
_while115_cond:
  mov b, [bp + -34] ; $tbl_p             
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $20
  cmp a, b
  sneq ; !=
  pop a
; END RELATIONAL
  cmp b, 0
  je _while115_exit
_while115_block:
;; *op_p++ = *tbl_p++; 
  mov b, [bp + -32] ; $op_p             
  mov g, b
  inc b
  lea d, [bp + -32] ; $op_p
  mov [d], b
  mov b, g
  push b
  mov b, [bp + -34] ; $tbl_p             
  mov g, b
  inc b
  lea d, [bp + -34] ; $tbl_p
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
  jmp _while115_cond
_while115_exit:
;; *op_p = '\0'; 
  mov b, [bp + -32] ; $op_p             
  push b
  mov b, $0
  pop d
  mov [d], bl
;; if(!strcmp(opcode_str, what_opcode)){ 
_if116_cond:
  lea d, [bp + -23] ; $opcode_str
  mov b, d
  swp b
  push b
  mov b, [bp + 5] ; $what_opcode             
  swp b
  push b
  call strcmp
  add sp, 4
  cmp b, 0
  seq ; !
  cmp b, 0
  je _if116_else
_if116_true:
;; strcpy(return_opcode.name, what_opcode); 
  lea d, [bp + -60] ; $return_opcode
  add d, 0
  clb
  mov b, d
  swp b
  push b
  mov b, [bp + 5] ; $what_opcode             
  swp b
  push b
  call strcpy
  add sp, 4
;; while(*tbl_p == ' ') tbl_p++; 
_while117_cond:
  mov b, [bp + -34] ; $tbl_p             
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
  je _while117_exit
_while117_block:
;; tbl_p++; 
  mov b, [bp + -34] ; $tbl_p             
  mov g, b
  inc b
  lea d, [bp + -34] ; $tbl_p
  mov [d], b
  mov b, g
  jmp _while117_cond
_while117_exit:
;; while(is_hex_digit(*tbl_p)) *hex_p++ = *tbl_p++; // Copy hex opcode 
_while118_cond:
  mov b, [bp + -34] ; $tbl_p             
  mov d, b
  mov bl, [d]
  mov bh, 0
  push bl
  call is_hex_digit
  add sp, 1
  cmp b, 0
  je _while118_exit
_while118_block:
;; *hex_p++ = *tbl_p++; // Copy hex opcode 
  mov b, [bp + -30] ; $hex_p             
  mov g, b
  inc b
  lea d, [bp + -30] ; $hex_p
  mov [d], b
  mov b, g
  push b
  mov b, [bp + -34] ; $tbl_p             
  mov g, b
  inc b
  lea d, [bp + -34] ; $tbl_p
  mov [d], b
  mov b, g
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
  jmp _while118_cond
_while118_exit:
;; *hex_p = '\0'; 
  mov b, [bp + -30] ; $hex_p             
  push b
  mov b, $0
  pop d
  mov [d], bl
;; if(strlen(opcode_hex) == 4){ 
_if119_cond:
  lea d, [bp + -28] ; $opcode_hex
  mov b, d
  swp b
  push b
  call strlen
  add sp, 2
; START RELATIONAL
  push a
  mov a, b
  mov b, $4
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if119_else
_if119_true:
;; return_opcode.opcode_type = 1; 
  lea d, [bp + -60] ; $return_opcode
  add d, 25
  clb         
  mov b, $1        
  mov [d], bl
;; *(opcode_hex + 2) = '\0'; 
  lea d, [bp + -28] ; $opcode_hex
  mov b, d
; START TERMS
  push a
  mov a, b
  mov b, $2
  add a, b
  mov b, a
  pop a
; END TERMS
  push b
  mov b, $0
  pop d
  mov [d], b
;; return_opcode.opcode = hex_to_int(opcode_hex); 
  lea d, [bp + -60] ; $return_opcode
  add d, 24
  clb
  push d
  lea d, [bp + -28] ; $opcode_hex
  mov b, d
  swp b
  push b
  call hex_to_int
  add sp, 2
  pop d
  mov [d], bl
  jmp _if119_exit
_if119_else:
;; return_opcode.opcode_type = 0; 
  lea d, [bp + -60] ; $return_opcode
  add d, 25
  clb         
  mov b, $0        
  mov [d], bl
;; return_opcode.opcode = hex_to_int(opcode_hex); 
  lea d, [bp + -60] ; $return_opcode
  add d, 24
  clb
  push d
  lea d, [bp + -28] ; $opcode_hex
  mov b, d
  swp b
  push b
  call hex_to_int
  add sp, 2
  pop d
  mov [d], bl
_if119_exit:
;; return return_opcode; 
  lea d, [bp + -60] ; $return_opcode
  mov b, d
  leave
  ret
  jmp _if116_exit
_if116_else:
;; while(*tbl_p != '\n') tbl_p++; 
_while120_cond:
  mov b, [bp + -34] ; $tbl_p             
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $a
  cmp a, b
  sneq ; !=
  pop a
; END RELATIONAL
  cmp b, 0
  je _while120_exit
_while120_block:
;; tbl_p++; 
  mov b, [bp + -34] ; $tbl_p             
  mov g, b
  inc b
  lea d, [bp + -34] ; $tbl_p
  mov [d], b
  mov b, g
  jmp _while120_cond
_while120_exit:
;; while(*tbl_p == '\n') tbl_p++; 
_while121_cond:
  mov b, [bp + -34] ; $tbl_p             
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $a
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _while121_exit
_while121_block:
;; tbl_p++; 
  mov b, [bp + -34] ; $tbl_p             
  mov g, b
  inc b
  lea d, [bp + -34] ; $tbl_p
  mov [d], b
  mov b, g
  jmp _while121_cond
_while121_exit:
;; if(!*tbl_p) break; 
_if122_cond:
  mov b, [bp + -34] ; $tbl_p             
  mov d, b
  mov bl, [d]
  mov bh, 0
  cmp b, 0
  seq ; !
  cmp b, 0
  je _if122_exit
_if122_true:
;; break; 
  jmp _for113_exit ; for break
  jmp _if122_exit
_if122_exit:
_if116_exit:
_for113_update:
  jmp _for113_cond
_for113_exit:
;; return_opcode.name[0] = '\0'; 
  lea d, [bp + -60] ; $return_opcode
  add d, 0
  clb
  push a         
  mov b, $0        
  add d, b
  pop a         
  mov b, $0        
  mov [d], bl
;; return return_opcode; 
  lea d, [bp + -60] ; $return_opcode
  mov b, d
  leave
  ret

forwards:
  enter 0 ; (push bp; mov bp, sp)
;; bin_p = bin_p + amount; 
  mov d, _bin_p ; $bin_p         
  mov b, [_bin_p] ; $bin_p           
; START TERMS
  push a
  mov a, b
  mov bl, [bp + 5] ; $amount
  mov bh, 0             
  add a, b
  mov b, a
  pop a
; END TERMS        
  mov [d], b
;; prog_size = prog_size + amount; 
  mov d, _prog_size ; $prog_size         
  mov b, [_prog_size] ; $prog_size           
; START TERMS
  push a
  mov a, b
  mov bl, [bp + 5] ; $amount
  mov bh, 0             
  add a, b
  mov b, a
  pop a
; END TERMS        
  mov [d], b
;; pc = pc + amount; 
  mov d, _pc ; $pc         
  mov b, [_pc] ; $pc           
; START TERMS
  push a
  mov a, b
  mov bl, [bp + 5] ; $amount
  mov bh, 0             
  add a, b
  mov b, a
  pop a
; END TERMS        
  mov [d], b
  leave
  ret

emit_byte:
  enter 0 ; (push bp; mov bp, sp)
;; if(!emit_override){ 
_if123_cond:
  mov bl, [bp + 5] ; $emit_override
  mov bh, 0             
  cmp b, 0
  seq ; !
  cmp b, 0
  je _if123_exit
_if123_true:
;; *bin_p = byte; 
  mov b, [_bin_p] ; $bin_p           
  push b
  mov bl, [bp + 6] ; $byte
  mov bh, 0             
  pop d
  mov [d], bl
  jmp _if123_exit
_if123_exit:
;; forwards(1); 
  mov b, $1
  push bl
  call forwards
  add sp, 1
  leave
  ret

emit_word:
  enter 0 ; (push bp; mov bp, sp)
;; if(!emit_override){ 
_if124_cond:
  mov bl, [bp + 5] ; $emit_override
  mov bh, 0             
  cmp b, 0
  seq ; !
  cmp b, 0
  je _if124_exit
_if124_true:
;; *((int*)bin_p) = word; 
  mov b, [_bin_p] ; $bin_p           
  push b
  mov b, [bp + 6] ; $word             
  pop d
  mov [d], b
  jmp _if124_exit
_if124_exit:
;; forwards(2); 
  mov b, $2
  push bl
  call forwards
  add sp, 1
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
;; while(*t){ 
_while125_cond:
  mov b, [bp + -1] ; $t             
  mov d, b
  mov bl, [d]
  mov bh, 0
  cmp b, 0
  je _while125_exit
_while125_block:
;; prog--; 
  mov b, [_prog] ; $prog           
  mov g, b
  dec b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
;; t++; 
  mov b, [bp + -1] ; $t             
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  jmp _while125_cond
_while125_exit:
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
_while126_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
  push bl
  call is_space
  add sp, 1
  cmp b, 0
  je _while126_exit
_while126_block:
;; prog++; 
  mov b, [_prog] ; $prog           
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  jmp _while126_cond
_while126_exit:
;; if(*prog == '\0'){ 
_if127_cond:
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
  je _if127_exit
_if127_true:
;; toktype = END; 
  mov d, _toktype ; $toktype         
  mov b, 7; END        
  mov [d], b
;; return; 
  leave
  ret
  jmp _if127_exit
_if127_exit:
;; while(*prog == '/' || is_alpha(*prog) || is_digit(*prog) || *prog == '_' || *prog == '-' || *prog == '.') { 
_while128_cond:
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
  push a
  mov a, b
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
  push bl
  call is_alpha
  add sp, 1
  sor a, b ; ||
  mov a, b
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
  push bl
  call is_digit
  add sp, 1
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
  je _while128_exit
_while128_block:
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
  jmp _while128_cond
_while128_exit:
;; *t = '\0'; 
  mov b, [bp + -1] ; $t             
  push b
  mov b, $0
  pop d
  mov [d], bl
  leave
  ret

is_hex_digit:
  enter 0 ; (push bp; mov bp, sp)
;; return c >= '0' && c <= '9' || c >= 'A' && c <= 'F' || c >= 'a' && c <= 'f'; 
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
  mov b, $46
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
  mov b, $66
  cmp a, b
  sle ; <=
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  sor a, b ; ||
  pop a
  leave
  ret

get_line:
  enter 0 ; (push bp; mov bp, sp)
; $t 
  sub sp, 2
;; t = string_const; 
  lea d, [bp + -1] ; $t         
  mov b, _string_const_data ; $string_const                   
  mov [d], b
;; *t = '\0'; 
  mov b, [bp + -1] ; $t             
  push b
  mov b, $0
  pop d
  mov [d], bl
;; while(*prog != 0x0A && *prog != '\0'){ 
_while129_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $a
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
  mov b, $0
  cmp a, b
  sneq ; !=
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  cmp b, 0
  je _while129_exit
_while129_block:
;; if(*prog == ';'){ 
_if130_cond:
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
  je _if130_else
_if130_true:
;; while(*prog != 0x0A && *prog != '\0') prog++; 
_while131_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $a
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
  mov b, $0
  cmp a, b
  sneq ; !=
  pop a
; END RELATIONAL
  sand a, b ; &&
  pop a
  cmp b, 0
  je _while131_exit
_while131_block:
;; prog++; 
  mov b, [_prog] ; $prog           
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  jmp _while131_cond
_while131_exit:
;; break; 
  jmp _while129_exit ; while break
  jmp _if130_exit
_if130_else:
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
_if130_exit:
  jmp _while129_cond
_while129_exit:
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
; $temp_hex 
; $p 
  sub sp, 68
;; *token = '\0'; 
  mov b, _token_data ; $token           
  push b
  mov b, $0
  pop d
  mov [d], bl
;; tok = TOK_UNDEF; 
  mov d, _tok ; $tok         
  mov b, 0; TOK_UNDEF        
  mov [d], b
;; toktype = TYPE_UNDEF; 
  mov d, _toktype ; $toktype         
  mov b, 0; TYPE_UNDEF        
  mov [d], b
;; t = token; 
  lea d, [bp + -1] ; $t         
  mov b, _token_data ; $token                   
  mov [d], b
;; do{ 
_do132_block:
;; while(is_space(*prog)) prog++; 
_while133_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
  push bl
  call is_space
  add sp, 1
  cmp b, 0
  je _while133_exit
_while133_block:
;; prog++; 
  mov b, [_prog] ; $prog           
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  jmp _while133_cond
_while133_exit:
;; if(*prog == ';'){ 
_if134_cond:
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
  je _if134_exit
_if134_true:
;; while(*prog != '\n') prog++; 
_while135_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $a
  cmp a, b
  sneq ; !=
  pop a
; END RELATIONAL
  cmp b, 0
  je _while135_exit
_while135_block:
;; prog++; 
  mov b, [_prog] ; $prog           
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  jmp _while135_cond
_while135_exit:
;; if(*prog == '\n') prog++; 
_if136_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $a
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if136_exit
_if136_true:
;; prog++; 
  mov b, [_prog] ; $prog           
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
  jmp _if136_exit
_if136_exit:
  jmp _if134_exit
_if134_exit:
;; } while(is_space(*prog) || *prog == ';'); 
_do132_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
  push bl
  call is_space
  add sp, 1
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
  seq ; ==
  pop a
; END RELATIONAL
  sor a, b ; ||
  pop a
  cmp b, 1
  je _do132_block
_do132_exit:
;; if(*prog == '\0'){ 
_if137_cond:
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
  je _if137_exit
_if137_true:
;; toktype = END; 
  mov d, _toktype ; $toktype         
  mov b, 7; END        
  mov [d], b
;; return; 
  leave
  ret
  jmp _if137_exit
_if137_exit:
;; if(is_alpha(*prog)){ 
_if138_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
  push bl
  call is_alpha
  add sp, 1
  cmp b, 0
  je _if138_else
_if138_true:
;; while(is_alpha(*prog) || is_digit(*prog)){ 
_while139_cond:
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
  je _while139_exit
_while139_block:
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
  jmp _while139_cond
_while139_exit:
;; *t = '\0'; 
  mov b, [bp + -1] ; $t             
  push b
  mov b, $0
  pop d
  mov [d], bl
;; if((tok = search_keyword(token)) != -1)  
_if140_cond:
  mov d, _tok ; $tok
  push d
  mov b, _token_data ; $token           
  swp b
  push b
  call search_keyword
  add sp, 2
  pop d
  mov [d], b
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
  je _if140_else
_if140_true:
;; toktype = KEYWORD; 
  mov d, _toktype ; $toktype         
  mov b, 1; KEYWORD        
  mov [d], b
  jmp _if140_exit
_if140_else:
;; toktype = IDENTIFIER; 
  mov d, _toktype ; $toktype         
  mov b, 6; IDENTIFIER        
  mov [d], b
_if140_exit:
  jmp _if138_exit
_if138_else:
;; if(is_digit(*prog) || (*prog == '$' && is_hex_digit(*(prog+1)))){ 
_if141_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
  push bl
  call is_digit
  add sp, 1
  push a
  mov a, b
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
  push a
  mov a, b
  mov b, [_prog] ; $prog           
; START TERMS
  push a
  mov a, b
  mov b, $1
  add a, b
  mov b, a
  pop a
; END TERMS
  mov d, b
  mov bl, [d]
  mov bh, 0
  push bl
  call is_hex_digit
  add sp, 1
  sand a, b ; &&
  pop a
  sor a, b ; ||
  pop a
  cmp b, 0
  je _if141_else
_if141_true:
;; if(*prog == '$' && is_hex_digit(*(prog+1))){ 
_if142_cond:
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
  push a
  mov a, b
  mov b, [_prog] ; $prog           
; START TERMS
  push a
  mov a, b
  mov b, $1
  add a, b
  mov b, a
  pop a
; END TERMS
  mov d, b
  mov bl, [d]
  mov bh, 0
  push bl
  call is_hex_digit
  add sp, 1
  sand a, b ; &&
  pop a
  cmp b, 0
  je _if142_else
_if142_true:
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
;; p = temp_hex; 
  lea d, [bp + -67] ; $p
  push d
  lea d, [bp + -65] ; $temp_hex
  mov b, d
  pop d
  mov [d], b
;; *t++ = *p++ = *prog++; 
  mov b, [bp + -1] ; $t             
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov b, [bp + -67] ; $p             
  mov g, b
  inc b
  lea d, [bp + -67] ; $p
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
  pop d
  mov [d], bl
;; while(is_hex_digit(*prog)){ 
_while143_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
  push bl
  call is_hex_digit
  add sp, 1
  cmp b, 0
  je _while143_exit
_while143_block:
;; *t++ = *p++ = *prog++; 
  mov b, [bp + -1] ; $t             
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov b, [bp + -67] ; $p             
  mov g, b
  inc b
  lea d, [bp + -67] ; $p
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
  pop d
  mov [d], bl
  jmp _while143_cond
_while143_exit:
;; *t = *p = '\0'; 
  mov b, [bp + -1] ; $t             
  push b
  mov b, [bp + -67] ; $p             
  push b
  mov b, $0
  pop d
  mov [d], bl
  pop d
  mov [d], bl
;; int_const = hex_to_int(temp_hex); 
  mov d, _int_const ; $int_const
  push d
  lea d, [bp + -65] ; $temp_hex
  mov b, d
  swp b
  push b
  call hex_to_int
  add sp, 2
  pop d
  mov [d], b
  jmp _if142_exit
_if142_else:
;; while(is_digit(*prog)){ 
_while144_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
  push bl
  call is_digit
  add sp, 1
  cmp b, 0
  je _while144_exit
_while144_block:
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
  jmp _while144_cond
_while144_exit:
;; *t = '\0'; 
  mov b, [bp + -1] ; $t             
  push b
  mov b, $0
  pop d
  mov [d], bl
;; int_const = atoi(token); 
  mov d, _int_const ; $int_const
  push d
  mov b, _token_data ; $token           
  swp b
  push b
  call atoi
  add sp, 2
  pop d
  mov [d], b
_if142_exit:
;; toktype = INTEGER_CONST; 
  mov d, _toktype ; $toktype         
  mov b, 5; INTEGER_CONST        
  mov [d], b
  jmp _if141_exit
_if141_else:
;; if(*prog == '\''){ 
_if145_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $27
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if145_else
_if145_true:
;; *t++ = '\''; 
  mov b, [bp + -1] ; $t             
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov b, $27
  pop d
  mov [d], bl
;; prog++; 
  mov b, [_prog] ; $prog           
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
;; if(*prog == '\\'){ 
_if146_cond:
  mov b, [_prog] ; $prog           
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
  je _if146_else
_if146_true:
;; *t++ = '\\'; 
  mov b, [bp + -1] ; $t             
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov b, $5c
  pop d
  mov [d], bl
;; prog++; 
  mov b, [_prog] ; $prog           
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
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
  jmp _if146_exit
_if146_else:
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
_if146_exit:
;; if(*prog != '\''){ 
_if147_cond:
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
; START RELATIONAL
  push a
  mov a, b
  mov b, $27
  cmp a, b
  sneq ; !=
  pop a
; END RELATIONAL
  cmp b, 0
  je _if147_exit
_if147_true:
;; error("Closing single quotes expected."); 
  mov b, __s73 ; "Closing single quotes expected."
  swp b
  push b
  call error
  add sp, 2
  jmp _if147_exit
_if147_exit:
;; *t++ = '\''; 
  mov b, [bp + -1] ; $t             
  mov g, b
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  mov b, g
  push b
  mov b, $27
  pop d
  mov [d], bl
;; prog++; 
  mov b, [_prog] ; $prog           
  mov g, b
  inc b
  mov d, _prog ; $prog
  mov [d], b
  mov b, g
;; toktype = CHAR_CONST; 
  mov d, _toktype ; $toktype         
  mov b, 3; CHAR_CONST        
  mov [d], b
;; *t = '\0'; 
  mov b, [bp + -1] ; $t             
  push b
  mov b, $0
  pop d
  mov [d], bl
;; convert_constant(); // converts this string token with quotation marks to a non quotation marks string, and also converts escape sequences to their real bytes 
  call convert_constant
  jmp _if145_exit
_if145_else:
;; if(*prog == '\"'){ 
_if148_cond:
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
  je _if148_else
_if148_true:
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
_while149_cond:
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
  je _while149_exit
_while149_block:
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
  jmp _while149_cond
_while149_exit:
;; if(*prog != '\"') error("Double quotes expected"); 
_if150_cond:
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
  je _if150_exit
_if150_true:
;; error("Double quotes expected"); 
  mov b, __s74 ; "Double quotes expected"
  swp b
  push b
  call error
  add sp, 2
  jmp _if150_exit
_if150_exit:
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
  mov b, 4; STRING_CONST        
  mov [d], b
;; *t = '\0'; 
  mov b, [bp + -1] ; $t             
  push b
  mov b, $0
  pop d
  mov [d], bl
;; convert_constant(); // converts this string token with quotation marks to a non quotation marks string, and also converts escape sequences to their real bytes 
  call convert_constant
  jmp _if148_exit
_if148_else:
;; if(*prog == '['){ 
_if151_cond:
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
  je _if151_else
_if151_true:
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
  mov b, 11; OPENING_BRACKET        
  mov [d], b
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype         
  mov b, 2; DELIMITER        
  mov [d], b
  jmp _if151_exit
_if151_else:
;; if(*prog == ']'){ 
_if152_cond:
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
  je _if152_else
_if152_true:
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
  mov b, 12; CLOSING_BRACKET        
  mov [d], b
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype         
  mov b, 2; DELIMITER        
  mov [d], b
  jmp _if152_exit
_if152_else:
;; if(*prog == '+'){ 
_if153_cond:
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
  je _if153_else
_if153_true:
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
;; tok = PLUS; 
  mov d, _tok ; $tok         
  mov b, 8; PLUS        
  mov [d], b
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype         
  mov b, 2; DELIMITER        
  mov [d], b
  jmp _if153_exit
_if153_else:
;; if(*prog == '-'){ 
_if154_cond:
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
  je _if154_else
_if154_true:
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
;; tok = MINUS; 
  mov d, _tok ; $tok         
  mov b, 9; MINUS        
  mov [d], b
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype         
  mov b, 2; DELIMITER        
  mov [d], b
  jmp _if154_exit
_if154_else:
;; if(*prog == '$'){ 
_if155_cond:
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
  je _if155_else
_if155_true:
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
  mov b, 10; DOLLAR        
  mov [d], b
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype         
  mov b, 2; DELIMITER        
  mov [d], b
  jmp _if155_exit
_if155_else:
;; if(*prog == ':'){ 
_if156_cond:
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
  je _if156_else
_if156_true:
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
  mov b, 13; COLON        
  mov [d], b
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype         
  mov b, 2; DELIMITER        
  mov [d], b
  jmp _if156_exit
_if156_else:
;; if(*prog == ';'){ 
_if157_cond:
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
  je _if157_else
_if157_true:
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
  mov b, 14; SEMICOLON        
  mov [d], b
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype         
  mov b, 2; DELIMITER        
  mov [d], b
  jmp _if157_exit
_if157_else:
;; if(*prog == ','){ 
_if158_cond:
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
  je _if158_else
_if158_true:
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
  mov b, 15; COMMA        
  mov [d], b
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype         
  mov b, 2; DELIMITER        
  mov [d], b
  jmp _if158_exit
_if158_else:
;; if(*prog == '.'){ 
_if159_cond:
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
  je _if159_exit
_if159_true:
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
  mov b, 16; DOT        
  mov [d], b
;; toktype = DELIMITER;   
  mov d, _toktype ; $toktype         
  mov b, 2; DELIMITER        
  mov [d], b
  jmp _if159_exit
_if159_exit:
_if158_exit:
_if157_exit:
_if156_exit:
_if155_exit:
_if154_exit:
_if153_exit:
_if152_exit:
_if151_exit:
_if148_exit:
_if145_exit:
_if141_exit:
_if138_exit:
;; *t = '\0'; 
  mov b, [bp + -1] ; $t             
  push b
  mov b, $0
  pop d
  mov [d], bl
;; if(toktype == TYPE_UNDEF){ 
_if160_cond:
  mov b, [_toktype] ; $toktype           
; START RELATIONAL
  push a
  mov a, b
  mov b, 0; TYPE_UNDEF
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if160_exit
_if160_true:
;; print("TOKEN ERROR. Prog: "); printx16((int)(prog-program));  
  mov b, __s75 ; "TOKEN ERROR. Prog: "
  swp b
  push b
  call print
  add sp, 2
;; printx16((int)(prog-program));  
  snex b
  mov b, [_prog] ; $prog           
; START TERMS
  push a
  mov a, b
  mov b, [_program] ; $program           
  sub a, b
  mov b, a
  pop a
; END TERMS
  swp b
  push b
  call printx16
  add sp, 2
;; print(", ProgVal: "); putchar(*prog);  
  mov b, __s76 ; ", ProgVal: "
  swp b
  push b
  call print
  add sp, 2
;; putchar(*prog);  
  mov b, [_prog] ; $prog           
  mov d, b
  mov bl, [d]
  mov bh, 0
  push bl
  call putchar
  add sp, 1
;; print("\n Text after prog: \n"); 
  mov b, __s77 ; "\n Text after prog: \n"
  swp b
  push b
  call print
  add sp, 2
;; print(prog); 
  mov b, [_prog] ; $prog           
  swp b
  push b
  call print
  add sp, 2
;; exit(); 
  call exit
  jmp _if160_exit
_if160_exit:
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
_if161_cond:
  mov b, [_toktype] ; $toktype           
; START RELATIONAL
  push a
  mov a, b
  mov b, 3; CHAR_CONST
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if161_else
_if161_true:
;; t++; 
  mov b, [bp + -3] ; $t             
  mov g, b
  inc b
  lea d, [bp + -3] ; $t
  mov [d], b
  mov b, g
;; if(*t == '\\'){ 
_if162_cond:
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
  je _if162_else
_if162_true:
;; t++; 
  mov b, [bp + -3] ; $t             
  mov g, b
  inc b
  lea d, [bp + -3] ; $t
  mov [d], b
  mov b, g
;; switch(*t){ 
_switch163_expr:
  mov b, [bp + -3] ; $t             
  mov d, b
  mov bl, [d]
  mov bh, 0
_switch163_comparisons:
  cmp bl, $30
  je _switch163_case0
  cmp bl, $61
  je _switch163_case1
  cmp bl, $62
  je _switch163_case2
  cmp bl, $66
  je _switch163_case3
  cmp bl, $6e
  je _switch163_case4
  cmp bl, $72
  je _switch163_case5
  cmp bl, $74
  je _switch163_case6
  cmp bl, $76
  je _switch163_case7
  cmp bl, $5c
  je _switch163_case8
  cmp bl, $27
  je _switch163_case9
  cmp bl, $22
  je _switch163_case10
  jmp _switch163_exit
_switch163_case0:
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
  jmp _switch163_exit ; case break
_switch163_case1:
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
  jmp _switch163_exit ; case break
_switch163_case2:
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
  jmp _switch163_exit ; case break
_switch163_case3:
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
  jmp _switch163_exit ; case break
_switch163_case4:
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
  jmp _switch163_exit ; case break
_switch163_case5:
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
  jmp _switch163_exit ; case break
_switch163_case6:
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
  jmp _switch163_exit ; case break
_switch163_case7:
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
  jmp _switch163_exit ; case break
_switch163_case8:
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
  jmp _switch163_exit ; case break
_switch163_case9:
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
  jmp _switch163_exit ; case break
_switch163_case10:
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
_switch163_exit:
  jmp _if162_exit
_if162_else:
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
_if162_exit:
  jmp _if161_exit
_if161_else:
;; if(toktype == STRING_CONST){ 
_if164_cond:
  mov b, [_toktype] ; $toktype           
; START RELATIONAL
  push a
  mov a, b
  mov b, 4; STRING_CONST
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if164_exit
_if164_true:
;; t++; 
  mov b, [bp + -3] ; $t             
  mov g, b
  inc b
  lea d, [bp + -3] ; $t
  mov [d], b
  mov b, g
;; while(*t != '\"' && *t){ 
_while165_cond:
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
  je _while165_exit
_while165_block:
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
  jmp _while165_cond
_while165_exit:
  jmp _if164_exit
_if164_exit:
_if161_exit:
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
;; print("\nError: "); 
  mov b, __s78 ; "\nError: "
  swp b
  push b
  call print
  add sp, 2
;; print(msg); 
  mov b, [bp + 5] ; $msg             
  swp b
  push b
  call print
  add sp, 2
;; print("\n"); 
  mov b, __s9 ; "\n"
  swp b
  push b
  call print
  add sp, 2
;; exit(); 
  call exit
  leave
  ret

error_s:
  enter 0 ; (push bp; mov bp, sp)
;; print("\nError: "); 
  mov b, __s78 ; "\nError: "
  swp b
  push b
  call print
  add sp, 2
;; print(msg); 
  mov b, [bp + 7] ; $msg             
  swp b
  push b
  call print
  add sp, 2
;; print(param); 
  mov b, [bp + 5] ; $param             
  swp b
  push b
  call print
  add sp, 2
;; print("\n"); 
  mov b, __s9 ; "\n"
  swp b
  push b
  call print
  add sp, 2
;; exit(); 
  call exit
  leave
  ret

push_prog:
  enter 0 ; (push bp; mov bp, sp)
;; if(prog_tos == 10) error("Cannot push prog. Stack overflow."); 
_if166_cond:
  mov b, [_prog_tos] ; $prog_tos           
; START RELATIONAL
  push a
  mov a, b
  mov b, $a
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if166_exit
_if166_true:
;; error("Cannot push prog. Stack overflow."); 
  mov b, __s79 ; "Cannot push prog. Stack overflow."
  swp b
  push b
  call error
  add sp, 2
  jmp _if166_exit
_if166_exit:
;; prog_stack[prog_tos] = prog; 
  mov d, _prog_stack_data ; $prog_stack
  push a         
  mov b, [_prog_tos] ; $prog_tos                   
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a         
  mov b, [_prog] ; $prog                   
  mov [d], b
;; prog_tos++; 
  mov b, [_prog_tos] ; $prog_tos           
  mov g, b
  inc b
  mov d, _prog_tos ; $prog_tos
  mov [d], b
  mov b, g
  leave
  ret

pop_prog:
  enter 0 ; (push bp; mov bp, sp)
;; if(prog_tos == 0) error("Cannot pop prog. Stack overflow."); 
_if167_cond:
  mov b, [_prog_tos] ; $prog_tos           
; START RELATIONAL
  push a
  mov a, b
  mov b, $0
  cmp a, b
  seq ; ==
  pop a
; END RELATIONAL
  cmp b, 0
  je _if167_exit
_if167_true:
;; error("Cannot pop prog. Stack overflow."); 
  mov b, __s80 ; "Cannot pop prog. Stack overflow."
  swp b
  push b
  call error
  add sp, 2
  jmp _if167_exit
_if167_exit:
;; prog_tos--; 
  mov b, [_prog_tos] ; $prog_tos           
  mov g, b
  dec b
  mov d, _prog_tos ; $prog_tos
  mov [d], b
  mov b, g
;; prog = prog_stack[prog_tos]; 
  mov d, _prog ; $prog
  push d
  mov d, _prog_stack_data ; $prog_stack
  push a         
  mov b, [_prog_tos] ; $prog_tos                   
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  pop d
  mov [d], b
  leave
  ret

search_keyword:
  enter 0 ; (push bp; mov bp, sp)
; $i 
  sub sp, 2
;; for(i = 0; keywords[i].keyword[0]; i++) 
_for168_init:
  lea d, [bp + -1] ; $i         
  mov b, $0        
  mov [d], b
_for168_cond:
  mov d, _keywords_data ; $keywords
  push a         
  mov b, [bp + -1] ; $i                     
  mma 3 ; mov a, 3; mul a, b; add d, b
  pop a
  add d, 0
  clb
  push a         
  mov b, $0        
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  cmp b, 0
  je _for168_exit
_for168_block:
;; if (!strcmp(keywords[i].keyword, keyword)) return keywords[i].tok; 
_if169_cond:
  mov d, _keywords_data ; $keywords
  push a         
  mov b, [bp + -1] ; $i                     
  mma 3 ; mov a, 3; mul a, b; add d, b
  pop a
  add d, 0
  clb
  mov b, [d]
  swp b
  push b
  mov b, [bp + 5] ; $keyword             
  swp b
  push b
  call strcmp
  add sp, 4
  cmp b, 0
  seq ; !
  cmp b, 0
  je _if169_exit
_if169_true:
;; return keywords[i].tok; 
  mov d, _keywords_data ; $keywords
  push a         
  mov b, [bp + -1] ; $i                     
  mma 3 ; mov a, 3; mul a, b; add d, b
  pop a
  add d, 2
  clb
  mov bl, [d]
  mov bh, 0
  leave
  ret
  jmp _if169_exit
_if169_exit:
_for168_update:
  mov b, [bp + -1] ; $i             
  mov g, b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  mov b, g
  jmp _for168_cond
_for168_exit:
;; return -1; 
  mov b, $1
  neg b
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
_for170_init:
  lea d, [bp + -3] ; $i         
  mov b, $0        
  mov [d], b
_for170_cond:
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
  je _for170_exit
_for170_block:
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
_if171_cond:
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
  je _if171_else
_if171_true:
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
  jmp _if171_exit
_if171_else:
;; if (hex_char >= 'A' && hex_char <= 'F')  
_if172_cond:
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
  je _if172_else
_if172_true:
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
  jmp _if172_exit
_if172_else:
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
_if172_exit:
_if171_exit:
_for170_update:
  mov b, [bp + -3] ; $i             
  mov g, b
  inc b
  lea d, [bp + -3] ; $i
  mov [d], b
  mov b, g
  jmp _for170_cond
_for170_exit:
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
_while173_cond:
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
  je _while173_exit
_while173_block:
;; str++; 
  mov b, [bp + 5] ; $str             
  mov g, b
  inc b
  lea d, [bp + 5] ; $str
  mov [d], b
  mov b, g
  jmp _while173_cond
_while173_exit:
;; if (*str == '-' || *str == '+') { 
_if174_cond:
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
  je _if174_exit
_if174_true:
;; if (*str == '-') sign = -1; 
_if175_cond:
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
  je _if175_exit
_if175_true:
;; sign = -1; 
  lea d, [bp + -3] ; $sign         
  mov b, $1
  neg b        
  mov [d], b
  jmp _if175_exit
_if175_exit:
;; str++; 
  mov b, [bp + 5] ; $str             
  mov g, b
  inc b
  lea d, [bp + 5] ; $str
  mov [d], b
  mov b, g
  jmp _if174_exit
_if174_exit:
;; while (*str >= '0' && *str <= '9') { 
_while176_cond:
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
  je _while176_exit
_while176_block:
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
  jmp _while176_cond
_while176_exit:
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
_if177_cond:
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
  je _if177_exit
_if177_true:
;; putchar('0'); 
  mov b, $30
  push bl
  call putchar
  add sp, 1
;; return; 
  leave
  ret
  jmp _if177_exit
_if177_exit:
;; while (num > 0) { 
_while178_cond:
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
  je _while178_exit
_while178_block:
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
  jmp _while178_cond
_while178_exit:
;; while (i > 0) { 
_while179_cond:
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
  je _while179_exit
_while179_block:
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
  jmp _while179_cond
_while179_exit:
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

exp:
  enter 0 ; (push bp; mov bp, sp)
; $i 
; $result 
  mov a, $1
  mov [bp + -3], a
  sub sp, 4
;; for(i = 0; i < exp; i++){ 
_for180_init:
  lea d, [bp + -1] ; $i         
  mov b, $0        
  mov [d], b
_for180_cond:
  mov b, [bp + -1] ; $i             
; START RELATIONAL
  push a
  mov a, b
  mov b, [bp + 5] ; $exp             
  cmp a, b
  slt ; < 
  pop a
; END RELATIONAL
  cmp b, 0
  je _for180_exit
_for180_block:
;; result = result * base; 
  lea d, [bp + -3] ; $result         
  mov b, [bp + -3] ; $result             
; START FACTORS
  push a
  mov a, b
  mov b, [bp + 7] ; $base             
  mul a, b ; *
  mov a, b
  mov b, a
  pop a
; END FACTORS        
  mov [d], b
_for180_update:
  mov b, [bp + -1] ; $i             
  mov g, b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  mov b, g
  jmp _for180_cond
_for180_exit:
;; return result; 
  mov b, [bp + -3] ; $result             
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
;; while(*psrc){ 
_while181_cond:
  mov b, [bp + -1] ; $psrc             
  mov d, b
  mov bl, [d]
  mov bh, 0
  cmp b, 0
  je _while181_exit
_while181_block:
;; *pdest = *psrc; 
  mov b, [bp + -3] ; $pdest             
  push b
  mov b, [bp + -1] ; $psrc             
  mov d, b
  mov bl, [d]
  mov bh, 0
  pop d
  mov [d], bl
;; pdest++; 
  mov b, [bp + -3] ; $pdest             
  mov g, b
  inc b
  lea d, [bp + -3] ; $pdest
  mov [d], b
  mov b, g
;; psrc++; 
  mov b, [bp + -1] ; $psrc             
  mov g, b
  inc b
  lea d, [bp + -1] ; $psrc
  mov [d], b
  mov b, g
  jmp _while181_cond
_while181_exit:
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
_while182_cond:
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
  je _while182_exit
_while182_block:
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
  jmp _while182_cond
_while182_exit:
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
_for183_init:
  lea d, [bp + -3] ; $i         
  mov b, $0        
  mov [d], b
_for183_cond:
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
  je _for183_exit
_for183_block:
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
_for183_update:
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
  jmp _for183_cond
_for183_exit:
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
_while184_cond:
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
  je _while184_exit
_while184_block:
;; length++; 
  mov b, [bp + -1] ; $length             
  mov g, b
  inc b
  lea d, [bp + -1] ; $length
  mov [d], b
  mov b, g
  jmp _while184_cond
_while184_exit:
;; return length; 
  mov b, [bp + -1] ; $length             
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

include_stdio_asm:
  enter 0 ; (push bp; mov bp, sp)

; --- BEGIN INLINE ASM BLOCK
.include "lib/stdio.asm"
; --- END INLINE ASM BLOCK

  leave
  ret
; --- END TEXT BLOCK

; --- BEGIN DATA BLOCK
_keywords_data:
.dw __s0
.db 1
.dw __s1
.db 2
.dw __s2
.db 3
.dw __s3
.db 4
.dw __s4
.db 6
.dw __s5
.db 7
.dw __s6
.db 5
.dw __s7
.db 0
_label_table_data: .fill 288, 0
__org: .dw 1024
_pc: .fill 2, 0
_print_information: .db 1
_tok: .fill 2, 0
_toktype: .fill 2, 0
_prog: .fill 2, 0
_token_data: .fill 64, 0
_string_const_data: .fill 256, 0
_int_const: .fill 2, 0
_program: .fill 2, 0
_bin_out: .fill 2, 0
_bin_p: .fill 2, 0
_opcode_table: .fill 2, 0
_prog_stack_data: .fill 20, 0
_prog_tos: .fill 2, 0
_prog_size: .fill 2, 0
_symbols_data: 
.dw __s7, __s8, __s8, __s7, __s7, __s7, __s8, __s8, 
__s0: .db "org", 0
__s1: .db "include", 0
__s2: .db "data", 0
__s3: .db "text", 0
__s4: .db "db", 0
__s5: .db "dw", 0
__s6: .db "end", 0
__s7: .db "@", 0
__s8: .db "#", 0
__s9: .db "\n", 0
__s10: .db "./config.d/op_tbl", 0
__s11: .db "Parsing DATA section...", 0
__s12: .db "Data segment not found.", 0
__s13: .db ".db: ", 0
__s14: .db ", ", 0
__s15: .db ".dw: ", 0
__s16: .db "Done.\n", 0
__s17: .db "Integer constant expected in .org directive.", 0
__s18: .db "Parsing labels and directives...\n", 0
__s19: .db ".", 0
__s20: .db "\nDone.\n", 0
__s21: .db "Org: ", 0
__s22: .db "\nLabels list:\n", 0
__s23: .db ": ", 0
__s24: .db " .", 0
__s25: .db " ", 0
__s26: .db "Maximum number of operands per instruction is 2.", 0
__s27: .db "8bit operand expected but 16bit label given.", 0
__s28: .db " (", 0
__s29: .db ") : ", 0
__s30: .db "Undeclared label: ", 0
__s31: .db "Parsing TEXT section...\n", 0
__s32: .db "TEXT section not found.", 0
__s33: .db "TEXT section end not found.", 0
__s34: .db "Unexpected directive.", 0
__s35: .db "Done.\n\n", 0
__s36: .db "Prog Offset: ", 0
__s37: .db "Prog value : ", 0
__s38: .db "Token       : ", 0
__s39: .db "Tok: ", 0
__s40: .db "Toktype: ", 0
__s41: .db "StringConst : ", 0
__s42: .db "PC          : ", 0
__s43: .db "\nAssembly complete.\n", 0
__s44: .db "Program size: ", 0
__s45: .db "Listing: \n", 0
__s46: .db "a", 0
__s47: .db "al", 0
__s48: .db "ah", 0
__s49: .db "b", 0
__s50: .db "bl", 0
__s51: .db "bh", 0
__s52: .db "c", 0
__s53: .db "cl", 0
__s54: .db "ch", 0
__s55: .db "d", 0
__s56: .db "dl", 0
__s57: .db "dh", 0
__s58: .db "g", 0
__s59: .db "gl", 0
__s60: .db "gh", 0
__s61: .db "pc", 0
__s62: .db "sp", 0
__s63: .db "bp", 0
__s64: .db "si", 0
__s65: .db "di", 0
__s66: .db "word", 0
__s67: .db "byte", 0
__s68: .db "cmpsb", 0
__s69: .db "movsb", 0
__s70: .db "stosb", 0
__s71: .db "define", 0
__s72: .db "Label does not exist: ", 0
__s73: .db "Closing single quotes expected.", 0
__s74: .db "Double quotes expected", 0
__s75: .db "TOKEN ERROR. Prog: ", 0
__s76: .db ", ProgVal: ", 0
__s77: .db "\n Text after prog: \n", 0
__s78: .db "\nError: ", 0
__s79: .db "Cannot push prog. Stack overflow.", 0
__s80: .db "Cannot pop prog. Stack overflow.", 0

_heap_top: .dw _heap
_heap: .db 0
; --- END DATA BLOCK

.end
