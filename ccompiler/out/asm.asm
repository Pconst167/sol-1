; --- FILENAME: ../solarium/asm/asm.c
; --- DATE:     22-10-2025 at 19:31:29
.include "lib/asm/kernel.exp"
.include "lib/asm/bios.exp"

; --- BEGIN TEXT SEGMENT
.org text_org
main:
  mov bp, $FFE0 ;
  mov sp, $FFE0 ; Make space for argc(2 bytes) and for 10 pointers in argv (local variables)
; char *p; 
  sub sp, 2
; printf("\n"); 
; --- START FUNCTION CALL
  mov b, _s10 ; "\n"
  swp b
  push b
  call printf
  add sp, 2
; --- END FUNCTION CALL
; program = alloc(16384); 
  mov d, _program ; $program
  push d
; --- START FUNCTION CALL
  mov32 cb, $00004000
  swp b
  push b
  call alloc
  add sp, 2
; --- END FUNCTION CALL
  pop d
  mov [d], b
; bin_out = alloc(16384); 
  mov d, _bin_out ; $bin_out
  push d
; --- START FUNCTION CALL
  mov32 cb, $00004000
  swp b
  push b
  call alloc
  add sp, 2
; --- END FUNCTION CALL
  pop d
  mov [d], b
; opcode_table = alloc(12310); 
  mov d, _opcode_table ; $opcode_table
  push d
; --- START FUNCTION CALL
  mov32 cb, $00003016
  swp b
  push b
  call alloc
  add sp, 2
; --- END FUNCTION CALL
  pop d
  mov [d], b
; loadfile(0x0000, program); 
; --- START FUNCTION CALL
  mov d, _program ; $program
  mov b, [d]
  mov c, 0
  swp b
  push b
  mov32 cb, $00000000
  swp b
  push b
  call loadfile
  add sp, 4
; --- END FUNCTION CALL
; loadfile("./config.d/op_tbl", opcode_table); 
; --- START FUNCTION CALL
  mov d, _opcode_table ; $opcode_table
  mov b, [d]
  mov c, 0
  swp b
  push b
  mov b, _s11 ; "./config.d/op_tbl"
  swp b
  push b
  call loadfile
  add sp, 4
; --- END FUNCTION CALL
; p = program; 
  lea d, [bp + -1] ; $p
  push d
  mov d, _program ; $program
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
; while(*p) p++; 
_while1_cond:
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  cmp b, 0
  je _while1_exit
_while1_block:
; p++; 
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -1] ; $p
  mov [d], b
  dec b
  jmp _while1_cond
_while1_exit:
; while(is_space(*p)) p--; 
_while2_cond:
; --- START FUNCTION CALL
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push bl
  call is_space
  add sp, 1
; --- END FUNCTION CALL
  cmp b, 0
  je _while2_exit
_while2_block:
; p--; 
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov c, 0
  dec b
  lea d, [bp + -1] ; $p
  mov [d], b
  inc b
  jmp _while2_cond
_while2_exit:
; p++; 
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -1] ; $p
  mov [d], b
  dec b
; *p = '\0'; 
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov c, 0
  push b
  mov32 cb, $00000000
  pop d
  mov [d], bl
; prog = program; 
  mov d, _prog ; $prog
  push d
  mov d, _program ; $program
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
; bin_p = bin_out + _org; 
  mov d, _bin_p ; $bin_p
  push d
  mov d, _bin_out ; $bin_out
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov d, __org ; $_org
  mov b, [d]
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; pc = _org; 
  mov d, _pc ; $pc
  push d
  mov d, __org ; $_org
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
; prog_size = 0; 
  mov d, _prog_size ; $prog_size
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
; label_directive_scan(); 
; --- START FUNCTION CALL
  call label_directive_scan
; prog_size = 0; 
  mov d, _prog_size ; $prog_size
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
; parse_text(); 
; --- START FUNCTION CALL
  call parse_text
; parse_data(); 
; --- START FUNCTION CALL
  call parse_data
; display_output(); 
; --- START FUNCTION CALL
  call display_output
  syscall sys_terminate_proc

parse_data:
  enter 0 ; (push bp; mov bp, sp)
; printf("Parsing DATA section..."); 
; --- START FUNCTION CALL
  mov b, _s12 ; "Parsing DATA section..."
  swp b
  push b
  call printf
  add sp, 2
; --- END FUNCTION CALL
; for(;;){ 
_for3_init:
_for3_cond:
_for3_block:
; get(); 
; --- START FUNCTION CALL
  call get
; if(toktype == END) error("Data segment not found."); 
_if4_cond:
  mov d, _toktype ; $toktype
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $7 ; enum element: END
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if4_exit
_if4_TRUE:
; error("Data segment not found."); 
; --- START FUNCTION CALL
  mov b, _s13 ; "Data segment not found."
  swp b
  push b
  call error
  add sp, 2
; --- END FUNCTION CALL
  jmp _if4_exit
_if4_exit:
; if(tok == DOT){ 
_if5_cond:
  mov d, _tok ; $tok
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $10 ; enum element: DOT
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if5_exit
_if5_TRUE:
; get(); 
; --- START FUNCTION CALL
  call get
; if(tok == DATA) break; 
_if6_cond:
  mov d, _tok ; $tok
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $3 ; enum element: DATA
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if6_exit
_if6_TRUE:
; break; 
  jmp _for3_exit ; for break
  jmp _if6_exit
_if6_exit:
  jmp _if5_exit
_if5_exit:
_for3_update:
  jmp _for3_cond
_for3_exit:
; for(;;){ 
_for7_init:
_for7_cond:
_for7_block:
; get(); 
; --- START FUNCTION CALL
  call get
; if(tok == SEGMENT_END) break; 
_if8_cond:
  mov d, _tok ; $tok
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $5 ; enum element: SEGMENT_END
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if8_exit
_if8_TRUE:
; break; 
  jmp _for7_exit ; for break
  jmp _if8_exit
_if8_exit:
; if(tok == DB){ 
_if9_cond:
  mov d, _tok ; $tok
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $6 ; enum element: DB
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if9_else
_if9_TRUE:
; printf(".db: "); 
; --- START FUNCTION CALL
  mov b, _s14 ; ".db: "
  swp b
  push b
  call printf
  add sp, 2
; --- END FUNCTION CALL
; for(;;){ 
_for10_init:
_for10_cond:
_for10_block:
; get(); 
; --- START FUNCTION CALL
  call get
; if(toktype == CHAR_CONST){ 
_if11_cond:
  mov d, _toktype ; $toktype
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $3 ; enum element: CHAR_CONST
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if11_else
_if11_TRUE:
; emit_byte(string_const[0], 0); 
; --- START FUNCTION CALL
  mov32 cb, $00000000
  push bl
  mov d, _string_const_data ; $string_const
  push a
  push d
  mov32 cb, $00000000
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push bl
  call emit_byte
  add sp, 2
; --- END FUNCTION CALL
; printf("%d", string_const[0]); 
; --- START FUNCTION CALL
  mov d, _string_const_data ; $string_const
  push a
  push d
  mov32 cb, $00000000
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
  swp b
  push b
  mov b, _s15 ; "%d"
  swp b
  push b
  call printf
  add sp, 3
; --- END FUNCTION CALL
  jmp _if11_exit
_if11_else:
; if(toktype == INTEGER_CONST){ 
_if12_cond:
  mov d, _toktype ; $toktype
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $5 ; enum element: INTEGER_CONST
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if12_exit
_if12_TRUE:
; emit_byte(int_const, 0); 
; --- START FUNCTION CALL
  mov32 cb, $00000000
  push bl
  mov d, _int_const ; $int_const
  mov b, [d]
  mov c, 0
  push bl
  call emit_byte
  add sp, 2
; --- END FUNCTION CALL
; printf("%d", int_const); 
; --- START FUNCTION CALL
  mov d, _int_const ; $int_const
  mov b, [d]
  mov c, 0
  swp b
  push b
  mov b, _s15 ; "%d"
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
  jmp _if12_exit
_if12_exit:
_if11_exit:
; get(); 
; --- START FUNCTION CALL
  call get
; if(tok != COMMA){ 
_if13_cond:
  mov d, _tok ; $tok
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $f ; enum element: COMMA
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if13_exit
_if13_TRUE:
; back(); 
; --- START FUNCTION CALL
  call back
; break; 
  jmp _for10_exit ; for break
  jmp _if13_exit
_if13_exit:
; printf(", "); 
; --- START FUNCTION CALL
  mov b, _s16 ; ", "
  swp b
  push b
  call printf
  add sp, 2
; --- END FUNCTION CALL
_for10_update:
  jmp _for10_cond
_for10_exit:
; printf("\n"); 
; --- START FUNCTION CALL
  mov b, _s10 ; "\n"
  swp b
  push b
  call printf
  add sp, 2
; --- END FUNCTION CALL
  jmp _if9_exit
_if9_else:
; if(tok == DW){ 
_if14_cond:
  mov d, _tok ; $tok
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $7 ; enum element: DW
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if14_exit
_if14_TRUE:
; printf(".dw: "); 
; --- START FUNCTION CALL
  mov b, _s17 ; ".dw: "
  swp b
  push b
  call printf
  add sp, 2
; --- END FUNCTION CALL
; for(;;){ 
_for15_init:
_for15_cond:
_for15_block:
; get(); 
; --- START FUNCTION CALL
  call get
; if(toktype == CHAR_CONST){ 
_if16_cond:
  mov d, _toktype ; $toktype
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $3 ; enum element: CHAR_CONST
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if16_else
_if16_TRUE:
; emit_byte(string_const[0], 0); 
; --- START FUNCTION CALL
  mov32 cb, $00000000
  push bl
  mov d, _string_const_data ; $string_const
  push a
  push d
  mov32 cb, $00000000
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push bl
  call emit_byte
  add sp, 2
; --- END FUNCTION CALL
; emit_byte(0, 0); 
; --- START FUNCTION CALL
  mov32 cb, $00000000
  push bl
  mov32 cb, $00000000
  push bl
  call emit_byte
  add sp, 2
; --- END FUNCTION CALL
; printf("%d", string_const[0]); 
; --- START FUNCTION CALL
  mov d, _string_const_data ; $string_const
  push a
  push d
  mov32 cb, $00000000
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
  swp b
  push b
  mov b, _s15 ; "%d"
  swp b
  push b
  call printf
  add sp, 3
; --- END FUNCTION CALL
  jmp _if16_exit
_if16_else:
; if(toktype == INTEGER_CONST){ 
_if17_cond:
  mov d, _toktype ; $toktype
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $5 ; enum element: INTEGER_CONST
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if17_exit
_if17_TRUE:
; emit_word(int_const, 0); 
; --- START FUNCTION CALL
  mov32 cb, $00000000
  push bl
  mov d, _int_const ; $int_const
  mov b, [d]
  mov c, 0
  swp b
  push b
  call emit_word
  add sp, 3
; --- END FUNCTION CALL
; printf("%d", int_const); 
; --- START FUNCTION CALL
  mov d, _int_const ; $int_const
  mov b, [d]
  mov c, 0
  swp b
  push b
  mov b, _s15 ; "%d"
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
  jmp _if17_exit
_if17_exit:
_if16_exit:
; get(); 
; --- START FUNCTION CALL
  call get
; if(tok != COMMA){ 
_if18_cond:
  mov d, _tok ; $tok
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $f ; enum element: COMMA
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if18_exit
_if18_TRUE:
; back(); 
; --- START FUNCTION CALL
  call back
; break; 
  jmp _for15_exit ; for break
  jmp _if18_exit
_if18_exit:
; printf(", "); 
; --- START FUNCTION CALL
  mov b, _s16 ; ", "
  swp b
  push b
  call printf
  add sp, 2
; --- END FUNCTION CALL
_for15_update:
  jmp _for15_cond
_for15_exit:
; printf("\n"); 
; --- START FUNCTION CALL
  mov b, _s10 ; "\n"
  swp b
  push b
  call printf
  add sp, 2
; --- END FUNCTION CALL
  jmp _if14_exit
_if14_exit:
_if9_exit:
_for7_update:
  jmp _for7_cond
_for7_exit:
; printf("Done.\n"); 
; --- START FUNCTION CALL
  mov b, _s18 ; "Done.\n"
  swp b
  push b
  call printf
  add sp, 2
; --- END FUNCTION CALL
  leave
  ret

parse_directive:
  enter 0 ; (push bp; mov bp, sp)
; get(); 
; --- START FUNCTION CALL
  call get
; if(tok == ORG){ 
_if19_cond:
  mov d, _tok ; $tok
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $1 ; enum element: ORG
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if19_else
_if19_TRUE:
; get(); 
; --- START FUNCTION CALL
  call get
; if(toktype != INTEGER_CONST) error("Integer constant _expected in .org directive."); 
_if20_cond:
  mov d, _toktype ; $toktype
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $5 ; enum element: INTEGER_CONST
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if20_exit
_if20_TRUE:
; error("Integer constant _expected in .org directive."); 
; --- START FUNCTION CALL
  mov b, _s19 ; "Integer constant _expected in .org directive."
  swp b
  push b
  call error
  add sp, 2
; --- END FUNCTION CALL
  jmp _if20_exit
_if20_exit:
; _org = int_const; 
  mov d, __org ; $_org
  push d
  mov d, _int_const ; $int_const
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
  jmp _if19_exit
_if19_else:
; if(tok == DB){ 
_if21_cond:
  mov d, _tok ; $tok
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $6 ; enum element: DB
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if21_else
_if21_TRUE:
; for(;;){ 
_for22_init:
_for22_cond:
_for22_block:
; get(); 
; --- START FUNCTION CALL
  call get
; if(toktype == CHAR_CONST){ 
_if23_cond:
  mov d, _toktype ; $toktype
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $3 ; enum element: CHAR_CONST
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if23_else
_if23_TRUE:
; emit_byte(string_const[0], emit_override); 
; --- START FUNCTION CALL
  lea d, [bp + 5] ; $emit_override
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push bl
  mov d, _string_const_data ; $string_const
  push a
  push d
  mov32 cb, $00000000
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push bl
  call emit_byte
  add sp, 2
; --- END FUNCTION CALL
  jmp _if23_exit
_if23_else:
; if(toktype == INTEGER_CONST){ 
_if24_cond:
  mov d, _toktype ; $toktype
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $5 ; enum element: INTEGER_CONST
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if24_exit
_if24_TRUE:
; emit_byte(int_const, emit_override); 
; --- START FUNCTION CALL
  lea d, [bp + 5] ; $emit_override
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push bl
  mov d, _int_const ; $int_const
  mov b, [d]
  mov c, 0
  push bl
  call emit_byte
  add sp, 2
; --- END FUNCTION CALL
  jmp _if24_exit
_if24_exit:
_if23_exit:
; get(); 
; --- START FUNCTION CALL
  call get
; if(tok != COMMA){ 
_if25_cond:
  mov d, _tok ; $tok
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $f ; enum element: COMMA
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if25_exit
_if25_TRUE:
; back(); 
; --- START FUNCTION CALL
  call back
; break; 
  jmp _for22_exit ; for break
  jmp _if25_exit
_if25_exit:
_for22_update:
  jmp _for22_cond
_for22_exit:
  jmp _if21_exit
_if21_else:
; if(tok == DW){ 
_if26_cond:
  mov d, _tok ; $tok
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $7 ; enum element: DW
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if26_exit
_if26_TRUE:
; for(;;){ 
_for27_init:
_for27_cond:
_for27_block:
; get(); 
; --- START FUNCTION CALL
  call get
; if(toktype == CHAR_CONST){ 
_if28_cond:
  mov d, _toktype ; $toktype
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $3 ; enum element: CHAR_CONST
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if28_else
_if28_TRUE:
; emit_byte(string_const[0], emit_override); 
; --- START FUNCTION CALL
  lea d, [bp + 5] ; $emit_override
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push bl
  mov d, _string_const_data ; $string_const
  push a
  push d
  mov32 cb, $00000000
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push bl
  call emit_byte
  add sp, 2
; --- END FUNCTION CALL
; emit_byte(0, emit_override); 
; --- START FUNCTION CALL
  lea d, [bp + 5] ; $emit_override
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push bl
  mov32 cb, $00000000
  push bl
  call emit_byte
  add sp, 2
; --- END FUNCTION CALL
  jmp _if28_exit
_if28_else:
; if(toktype == INTEGER_CONST){ 
_if29_cond:
  mov d, _toktype ; $toktype
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $5 ; enum element: INTEGER_CONST
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if29_exit
_if29_TRUE:
; emit_word(int_const, 0); 
; --- START FUNCTION CALL
  mov32 cb, $00000000
  push bl
  mov d, _int_const ; $int_const
  mov b, [d]
  mov c, 0
  swp b
  push b
  call emit_word
  add sp, 3
; --- END FUNCTION CALL
  jmp _if29_exit
_if29_exit:
_if28_exit:
; get(); 
; --- START FUNCTION CALL
  call get
; if(tok != COMMA){ 
_if30_cond:
  mov d, _tok ; $tok
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $f ; enum element: COMMA
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if30_exit
_if30_TRUE:
; back(); 
; --- START FUNCTION CALL
  call back
; break; 
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
; char *temp_prog; 
  sub sp, 2
; int i; 
  sub sp, 2
; prog = program; 
  mov d, _prog ; $prog
  push d
  mov d, _program ; $program
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
; bin_p = bin_out + _org; 
  mov d, _bin_p ; $bin_p
  push d
  mov d, _bin_out ; $bin_out
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov d, __org ; $_org
  mov b, [d]
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; pc = _org; 
  mov d, _pc ; $pc
  push d
  mov d, __org ; $_org
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
; printf("Parsing labels and directives...\n"); 
; --- START FUNCTION CALL
  mov b, _s20 ; "Parsing labels and directives...\n"
  swp b
  push b
  call printf
  add sp, 2
; --- END FUNCTION CALL
; for(;;){ 
_for31_init:
_for31_cond:
_for31_block:
; get(); back(); 
; --- START FUNCTION CALL
  call get
; back(); 
; --- START FUNCTION CALL
  call back
; temp_prog = prog; 
  lea d, [bp + -1] ; $temp_prog
  push d
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
; get(); 
; --- START FUNCTION CALL
  call get
; if(toktype == END) break; 
_if32_cond:
  mov d, _toktype ; $toktype
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $7 ; enum element: END
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if32_exit
_if32_TRUE:
; break; 
  jmp _for31_exit ; for break
  jmp _if32_exit
_if32_exit:
; if(tok == DOT){ 
_if33_cond:
  mov d, _tok ; $tok
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $10 ; enum element: DOT
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if33_else
_if33_TRUE:
; get(); 
; --- START FUNCTION CALL
  call get
; if(is_directive(token)){ 
_if34_cond:
; --- START FUNCTION CALL
  mov d, _token_data ; $token
  mov b, d
  mov c, 0
  swp b
  push b
  call is_directive
  add sp, 2
; --- END FUNCTION CALL
  cmp b, 0
  je _if34_exit
_if34_TRUE:
; back(); 
; --- START FUNCTION CALL
  call back
; parse_directive(1); 
; --- START FUNCTION CALL
  mov32 cb, $00000001
  push bl
  call parse_directive
  add sp, 1
; --- END FUNCTION CALL
  jmp _if34_exit
_if34_exit:
  jmp _if33_exit
_if33_else:
; if(toktype == IDENTIFIER){ 
_if35_cond:
  mov d, _toktype ; $toktype
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $6 ; enum element: IDENTIFIER
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if35_exit
_if35_TRUE:
; get(); 
; --- START FUNCTION CALL
  call get
; if(tok == COLON){ 
_if36_cond:
  mov d, _tok ; $tok
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $d ; enum element: COLON
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if36_else
_if36_TRUE:
; prog = temp_prog; 
  mov d, _prog ; $prog
  push d
  lea d, [bp + -1] ; $temp_prog
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
; parse_label(); 
; --- START FUNCTION CALL
  call parse_label
; printf("."); 
; --- START FUNCTION CALL
  mov b, _s21 ; "."
  swp b
  push b
  call printf
  add sp, 2
; --- END FUNCTION CALL
  jmp _if36_exit
_if36_else:
; prog = temp_prog; 
  mov d, _prog ; $prog
  push d
  lea d, [bp + -1] ; $temp_prog
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
; parse_instr(1);       
; --- START FUNCTION CALL
  mov32 cb, $00000001
  push bl
  call parse_instr
  add sp, 1
; --- END FUNCTION CALL
; printf("."); 
; --- START FUNCTION CALL
  mov b, _s21 ; "."
  swp b
  push b
  call printf
  add sp, 2
; --- END FUNCTION CALL
_if36_exit:
  jmp _if35_exit
_if35_exit:
_if33_exit:
_for31_update:
  jmp _for31_cond
_for31_exit:
; printf("\nDone.\n"); 
; --- START FUNCTION CALL
  mov b, _s22 ; "\nDone.\n"
  swp b
  push b
  call printf
  add sp, 2
; --- END FUNCTION CALL
; printf("Org: %s\n", _org); 
; --- START FUNCTION CALL
  mov d, __org ; $_org
  mov b, [d]
  mov c, 0
  swp b
  push b
  mov b, _s23 ; "Org: %s\n"
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
; printf("\nLabels list:\n"); 
; --- START FUNCTION CALL
  mov b, _s24 ; "\nLabels list:\n"
  swp b
  push b
  call printf
  add sp, 2
; --- END FUNCTION CALL
; for(i = 0; label_table[i].name[0]; i++){ 
_for37_init:
  lea d, [bp + -3] ; $i
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
_for37_cond:
  mov d, _label_table_data ; $label_table
  push a
  push d
  lea d, [bp + -3] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 18 ; mov a, 18; mul a, b; add d, b
  pop a
  add d, 0
  push a
  push d
  mov32 cb, $00000000
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
  cmp b, 0
  je _for37_exit
_for37_block:
; printf("%s: %x\n", label_table[i].name, label_table[i].address); 
; --- START FUNCTION CALL
  mov d, _label_table_data ; $label_table
  push a
  push d
  lea d, [bp + -3] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 18 ; mov a, 18; mul a, b; add d, b
  pop a
  add d, 16
  mov b, [d]
  mov c, 0
  swp b
  push b
  mov d, _label_table_data ; $label_table
  push a
  push d
  lea d, [bp + -3] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 18 ; mov a, 18; mul a, b; add d, b
  pop a
  add d, 0
  mov b, d
  mov c, 0
  swp b
  push b
  mov b, _s25 ; "%s: %x\n"
  swp b
  push b
  call printf
  add sp, 6
; --- END FUNCTION CALL
_for37_update:
  lea d, [bp + -3] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -3] ; $i
  mov [d], b
  mov b, a
  jmp _for37_cond
_for37_exit:
; printf("\n"); 
; --- START FUNCTION CALL
  mov b, _s10 ; "\n"
  swp b
  push b
  call printf
  add sp, 2
; --- END FUNCTION CALL
  leave
  ret

label_parse_instr:
  enter 0 ; (push bp; mov bp, sp)
; char opcode[32]; 
  sub sp, 32
; char code_line[64]; 
  sub sp, 64
; struct t_opcode op; 
  sub sp, 26
; int num_operands, num_operands_exp; 
  sub sp, 2
  sub sp, 2
; int i, j; 
  sub sp, 2
  sub sp, 2
; char operand_types[3]; // operand types and locations 
  sub sp, 3
; int old_pc; 
  sub sp, 2
; char has_operands; 
  sub sp, 1
; old_pc = pc; 
  lea d, [bp + -134] ; $old_pc
  push d
  mov d, _pc ; $pc
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
; get_line(); 
; --- START FUNCTION CALL
  call get_line
; push_prog(); 
; --- START FUNCTION CALL
  call push_prog
; strcpy(code_line, string_const); 
; --- START FUNCTION CALL
  mov d, _string_const_data ; $string_const
  mov b, d
  mov c, 0
  swp b
  push b
  lea d, [bp + -95] ; $code_line
  mov b, d
  mov c, 0
  swp b
  push b
  call strcpy
  add sp, 4
; --- END FUNCTION CALL
; has_operands = 0; 
  lea d, [bp + -135] ; $has_operands
  push d
  mov32 cb, $00000000
  pop d
  mov [d], bl
; prog = code_line; 
  mov d, _prog ; $prog
  push d
  lea d, [bp + -95] ; $code_line
  mov b, d
  mov c, 0
  pop d
  mov [d], b
; get(); // get main opcode 
; --- START FUNCTION CALL
  call get
; for(;;){ 
_for38_init:
_for38_cond:
_for38_block:
; get(); 
; --- START FUNCTION CALL
  call get
; if(toktype == END) break; 
_if39_cond:
  mov d, _toktype ; $toktype
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $7 ; enum element: END
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if39_exit
_if39_TRUE:
; break; 
  jmp _for38_exit ; for break
  jmp _if39_exit
_if39_exit:
; if(toktype == INTEGER_CONST || toktype == IDENTIFIER && !is_reserved(token)){ 
_if40_cond:
  mov d, _toktype ; $toktype
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $5 ; enum element: INTEGER_CONST
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
; --- START LOGICAL OR
  push a
  mov a, b
  mov d, _toktype ; $toktype
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $6 ; enum element: IDENTIFIER
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
; --- START LOGICAL AND
  push a
  mov a, b
; --- START FUNCTION CALL
  mov d, _token_data ; $token
  mov b, d
  mov c, 0
  swp b
  push b
  call is_reserved
  add sp, 2
; --- END FUNCTION CALL
  sand a, b
  pop a
; --- END LOGICAL AND
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  cmp b, 0
  je _if40_exit
_if40_TRUE:
; has_operands = 1; 
  lea d, [bp + -135] ; $has_operands
  push d
  mov32 cb, $00000001
  pop d
  mov [d], bl
; break; 
  jmp _for38_exit ; for break
  jmp _if40_exit
_if40_exit:
_for38_update:
  jmp _for38_cond
_for38_exit:
; opcode[0] = '\0'; 
  lea d, [bp + -31] ; $opcode
  push a
  push d
  mov32 cb, $00000000
  pop d
  add d, b
  pop a
  push d
  mov32 cb, $00000000
  pop d
  mov [d], bl
; prog = code_line; 
  mov d, _prog ; $prog
  push d
  lea d, [bp + -95] ; $code_line
  mov b, d
  mov c, 0
  pop d
  mov [d], b
; if(!has_operands){ 
_if41_cond:
  lea d, [bp + -135] ; $has_operands
  mov bl, [d]
  mov bh, 0
  mov c, 0
  cmp b, 0
  je _if41_else
_if41_TRUE:
; get(); 
; --- START FUNCTION CALL
  call get
; strcpy(opcode, token); 
; --- START FUNCTION CALL
  mov d, _token_data ; $token
  mov b, d
  mov c, 0
  swp b
  push b
  lea d, [bp + -31] ; $opcode
  mov b, d
  mov c, 0
  swp b
  push b
  call strcpy
  add sp, 4
; --- END FUNCTION CALL
; get();  
; --- START FUNCTION CALL
  call get
; if(toktype == END){ 
_if42_cond:
  mov d, _toktype ; $toktype
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $7 ; enum element: END
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if42_else
_if42_TRUE:
; strcat(opcode, " ."); 
; --- START FUNCTION CALL
  mov b, _s26 ; " ."
  swp b
  push b
  lea d, [bp + -31] ; $opcode
  mov b, d
  mov c, 0
  swp b
  push b
  call strcat
  add sp, 4
; --- END FUNCTION CALL
  jmp _if42_exit
_if42_else:
; strcat(opcode, " "); 
; --- START FUNCTION CALL
  mov b, _s27 ; " "
  swp b
  push b
  lea d, [bp + -31] ; $opcode
  mov b, d
  mov c, 0
  swp b
  push b
  call strcat
  add sp, 4
; --- END FUNCTION CALL
; strcat(opcode, token); 
; --- START FUNCTION CALL
  mov d, _token_data ; $token
  mov b, d
  mov c, 0
  swp b
  push b
  lea d, [bp + -31] ; $opcode
  mov b, d
  mov c, 0
  swp b
  push b
  call strcat
  add sp, 4
; --- END FUNCTION CALL
; for(;;){ 
_for43_init:
_for43_cond:
_for43_block:
; get(); 
; --- START FUNCTION CALL
  call get
; if(toktype == END) break; 
_if44_cond:
  mov d, _toktype ; $toktype
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $7 ; enum element: END
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if44_exit
_if44_TRUE:
; break; 
  jmp _for43_exit ; for break
  jmp _if44_exit
_if44_exit:
; strcat(opcode, token); 
; --- START FUNCTION CALL
  mov d, _token_data ; $token
  mov b, d
  mov c, 0
  swp b
  push b
  lea d, [bp + -31] ; $opcode
  mov b, d
  mov c, 0
  swp b
  push b
  call strcat
  add sp, 4
; --- END FUNCTION CALL
_for43_update:
  jmp _for43_cond
_for43_exit:
_if42_exit:
; op = search_opcode(opcode); 
  lea d, [bp + -121] ; $op
  push d
; --- START FUNCTION CALL
  lea d, [bp + -31] ; $opcode
  mov b, d
  mov c, 0
  swp b
  push b
  call search_opcode
  add sp, 2
; --- END FUNCTION CALL
  pop d
  mov si, b
  mov di, d
  mov c, 26
  rep movsb
; if(op.opcode_type){ 
_if45_cond:
  lea d, [bp + -121] ; $op
  add d, 25
  mov bl, [d]
  mov bh, 0
  mov c, 0
  cmp b, 0
  je _if45_exit
_if45_TRUE:
; forwards(1); 
; --- START FUNCTION CALL
  mov32 cb, $00000001
  push bl
  call forwards
  add sp, 1
; --- END FUNCTION CALL
  jmp _if45_exit
_if45_exit:
; forwards(1); 
; --- START FUNCTION CALL
  mov32 cb, $00000001
  push bl
  call forwards
  add sp, 1
; --- END FUNCTION CALL
  jmp _if41_exit
_if41_else:
; num_operands = 0; 
  lea d, [bp + -123] ; $num_operands
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
; for(;;){ 
_for46_init:
_for46_cond:
_for46_block:
; get(); 
; --- START FUNCTION CALL
  call get
; if(toktype == END) break; 
_if47_cond:
  mov d, _toktype ; $toktype
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $7 ; enum element: END
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if47_exit
_if47_TRUE:
; break; 
  jmp _for46_exit ; for break
  jmp _if47_exit
_if47_exit:
; if(toktype == INTEGER_CONST || toktype == IDENTIFIER && !is_reserved(token)){ 
_if48_cond:
  mov d, _toktype ; $toktype
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $5 ; enum element: INTEGER_CONST
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
; --- START LOGICAL OR
  push a
  mov a, b
  mov d, _toktype ; $toktype
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $6 ; enum element: IDENTIFIER
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
; --- START LOGICAL AND
  push a
  mov a, b
; --- START FUNCTION CALL
  mov d, _token_data ; $token
  mov b, d
  mov c, 0
  swp b
  push b
  call is_reserved
  add sp, 2
; --- END FUNCTION CALL
  sand a, b
  pop a
; --- END LOGICAL AND
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  cmp b, 0
  je _if48_exit
_if48_TRUE:
; num_operands++; 
  lea d, [bp + -123] ; $num_operands
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -123] ; $num_operands
  mov [d], b
  mov b, a
  jmp _if48_exit
_if48_exit:
_for46_update:
  jmp _for46_cond
_for46_exit:
; if(num_operands > 2) error("Maximum number of operands per instruction is 2."); 
_if49_cond:
  lea d, [bp + -123] ; $num_operands
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000002
  cmp a, b
  sgt ; >
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if49_exit
_if49_TRUE:
; error("Maximum number of operands per instruction is 2."); 
; --- START FUNCTION CALL
  mov b, _s28 ; "Maximum number of operands per instruction is 2."
  swp b
  push b
  call error
  add sp, 2
; --- END FUNCTION CALL
  jmp _if49_exit
_if49_exit:
; num_operands_exp = _exp(2, num_operands); 
  lea d, [bp + -125] ; $num_operands_exp
  push d
; --- START FUNCTION CALL
  lea d, [bp + -123] ; $num_operands
  mov b, [d]
  mov c, 0
  swp b
  push b
  mov32 cb, $00000002
  swp b
  push b
  call _exp
  add sp, 4
; --- END FUNCTION CALL
  pop d
  mov [d], b
; for(i = 0; i < num_operands_exp; i++){ 
_for50_init:
  lea d, [bp + -127] ; $i
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
_for50_cond:
  lea d, [bp + -127] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -125] ; $num_operands_exp
  mov b, [d]
  mov c, 0
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for50_exit
_for50_block:
; prog = code_line; 
  mov d, _prog ; $prog
  push d
  lea d, [bp + -95] ; $code_line
  mov b, d
  mov c, 0
  pop d
  mov [d], b
; get(); 
; --- START FUNCTION CALL
  call get
; strcpy(opcode, token); 
; --- START FUNCTION CALL
  mov d, _token_data ; $token
  mov b, d
  mov c, 0
  swp b
  push b
  lea d, [bp + -31] ; $opcode
  mov b, d
  mov c, 0
  swp b
  push b
  call strcpy
  add sp, 4
; --- END FUNCTION CALL
; strcat(opcode, " "); 
; --- START FUNCTION CALL
  mov b, _s27 ; " "
  swp b
  push b
  lea d, [bp + -31] ; $opcode
  mov b, d
  mov c, 0
  swp b
  push b
  call strcat
  add sp, 4
; --- END FUNCTION CALL
; j = 0; 
  lea d, [bp + -129] ; $j
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
; for(;;){ 
_for51_init:
_for51_cond:
_for51_block:
; get(); 
; --- START FUNCTION CALL
  call get
; if(toktype == END) break; 
_if52_cond:
  mov d, _toktype ; $toktype
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $7 ; enum element: END
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if52_exit
_if52_TRUE:
; break; 
  jmp _for51_exit ; for break
  jmp _if52_exit
_if52_exit:
; if(toktype == INTEGER_CONST || toktype == IDENTIFIER && !is_reserved(token)){ 
_if53_cond:
  mov d, _toktype ; $toktype
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $5 ; enum element: INTEGER_CONST
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
; --- START LOGICAL OR
  push a
  mov a, b
  mov d, _toktype ; $toktype
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $6 ; enum element: IDENTIFIER
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
; --- START LOGICAL AND
  push a
  mov a, b
; --- START FUNCTION CALL
  mov d, _token_data ; $token
  mov b, d
  mov c, 0
  swp b
  push b
  call is_reserved
  add sp, 2
; --- END FUNCTION CALL
  sand a, b
  pop a
; --- END LOGICAL AND
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  cmp b, 0
  je _if53_else
_if53_TRUE:
; strcat(opcode, symbols[i*2+j]); 
; --- START FUNCTION CALL
  mov d, _symbols_data ; $symbols
  push a
  push d
  lea d, [bp + -127] ; $i
  mov b, [d]
  mov c, 0
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $00000002
  push a     ; save left operand
  xor a, b   ; xor sign bits
  swp a      ; swap bytes
  mov cl, al ; save result of xor into 'dl'
  pop a      ; restore left side operator
  push cl    ; save result of xor above
  swp a  
  test al, $80  
  swp a  
  jz skip_invert_a_61  
  neg a 
skip_invert_a_61:   
  swp b
  test bl, $80  
  swp b
  jz skip_invert_b_61  
  neg b 
skip_invert_b_61:   
  mul a, b ; *
  mov g, a
  mov a, b
  pop bl
  test bl, $80
  jz _same_signs_61
  mov bl, al
  not a
  neg b
  adc a, 0
  mov g, a
  mov a, b
_same_signs_61:
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
; --- START TERMS
  push a
  push g
  mov a, b
  mov g, c
  lea d, [bp + -129] ; $j
  mov b, [d]
  mov c, 0
  mov c, 0
  add32 cb, ga
  pop g
  pop a
; --- END TERMS
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  swp b
  push b
  lea d, [bp + -31] ; $opcode
  mov b, d
  mov c, 0
  swp b
  push b
  call strcat
  add sp, 4
; --- END FUNCTION CALL
; operand_types[j] = *symbols[i*2+j]; 
  lea d, [bp + -132] ; $operand_types
  push a
  push d
  lea d, [bp + -129] ; $j
  mov b, [d]
  mov c, 0
  pop d
  add d, b
  pop a
  push d
  mov d, _symbols_data ; $symbols
  push a
  push d
  lea d, [bp + -127] ; $i
  mov b, [d]
  mov c, 0
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $00000002
  push a     ; save left operand
  xor a, b   ; xor sign bits
  swp a      ; swap bytes
  mov cl, al ; save result of xor into 'dl'
  pop a      ; restore left side operator
  push cl    ; save result of xor above
  swp a  
  test al, $80  
  swp a  
  jz skip_invert_a_65  
  neg a 
skip_invert_a_65:   
  swp b
  test bl, $80  
  swp b
  jz skip_invert_b_65  
  neg b 
skip_invert_b_65:   
  mul a, b ; *
  mov g, a
  mov a, b
  pop bl
  test bl, $80
  jz _same_signs_65
  mov bl, al
  not a
  neg b
  adc a, 0
  mov g, a
  mov a, b
_same_signs_65:
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
; --- START TERMS
  push a
  push g
  mov a, b
  mov g, c
  lea d, [bp + -129] ; $j
  mov b, [d]
  mov c, 0
  mov c, 0
  add32 cb, ga
  pop g
  pop a
; --- END TERMS
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mov [d], bl
; j++; 
  lea d, [bp + -129] ; $j
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -129] ; $j
  mov [d], b
  mov b, a
  jmp _if53_exit
_if53_else:
; strcat(opcode, token); 
; --- START FUNCTION CALL
  mov d, _token_data ; $token
  mov b, d
  mov c, 0
  swp b
  push b
  lea d, [bp + -31] ; $opcode
  mov b, d
  mov c, 0
  swp b
  push b
  call strcat
  add sp, 4
; --- END FUNCTION CALL
_if53_exit:
_for51_update:
  jmp _for51_cond
_for51_exit:
; op = search_opcode(opcode); 
  lea d, [bp + -121] ; $op
  push d
; --- START FUNCTION CALL
  lea d, [bp + -31] ; $opcode
  mov b, d
  mov c, 0
  swp b
  push b
  call search_opcode
  add sp, 2
; --- END FUNCTION CALL
  pop d
  mov si, b
  mov di, d
  mov c, 26
  rep movsb
; if(op.name[0] == '\0') continue; 
_if66_cond:
  lea d, [bp + -121] ; $op
  add d, 0
  push a
  push d
  mov32 cb, $00000000
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if66_exit
_if66_TRUE:
; continue; 
  jmp _for50_update ; for continue
  jmp _if66_exit
_if66_exit:
; if(op.opcode_type){ 
_if67_cond:
  lea d, [bp + -121] ; $op
  add d, 25
  mov bl, [d]
  mov bh, 0
  mov c, 0
  cmp b, 0
  je _if67_exit
_if67_TRUE:
; forwards(1); 
; --- START FUNCTION CALL
  mov32 cb, $00000001
  push bl
  call forwards
  add sp, 1
; --- END FUNCTION CALL
  jmp _if67_exit
_if67_exit:
; forwards(1); 
; --- START FUNCTION CALL
  mov32 cb, $00000001
  push bl
  call forwards
  add sp, 1
; --- END FUNCTION CALL
; prog = code_line; 
  mov d, _prog ; $prog
  push d
  lea d, [bp + -95] ; $code_line
  mov b, d
  mov c, 0
  pop d
  mov [d], b
; j = 0; 
  lea d, [bp + -129] ; $j
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
; get(); 
; --- START FUNCTION CALL
  call get
; for(;;){ 
_for68_init:
_for68_cond:
_for68_block:
; get(); 
; --- START FUNCTION CALL
  call get
; if(toktype == END) break; 
_if69_cond:
  mov d, _toktype ; $toktype
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $7 ; enum element: END
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if69_exit
_if69_TRUE:
; break; 
  jmp _for68_exit ; for break
  jmp _if69_exit
_if69_exit:
; if(toktype == IDENTIFIER && !is_reserved(token)){ 
_if70_cond:
  mov d, _toktype ; $toktype
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $6 ; enum element: IDENTIFIER
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
; --- START LOGICAL AND
  push a
  mov a, b
; --- START FUNCTION CALL
  mov d, _token_data ; $token
  mov b, d
  mov c, 0
  swp b
  push b
  call is_reserved
  add sp, 2
; --- END FUNCTION CALL
  sand a, b
  pop a
; --- END LOGICAL AND
  cmp b, 0
  je _if70_else
_if70_TRUE:
; if(operand_types[j] == '#'){ 
_if71_cond:
  lea d, [bp + -132] ; $operand_types
  push a
  push d
  lea d, [bp + -129] ; $j
  mov b, [d]
  mov c, 0
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000023
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if71_else
_if71_TRUE:
; error("8bit operand _expected but 16bit label given."); 
; --- START FUNCTION CALL
  mov b, _s29 ; "8bit operand _expected but 16bit label given."
  swp b
  push b
  call error
  add sp, 2
; --- END FUNCTION CALL
  jmp _if71_exit
_if71_else:
; if(operand_types[j] == '@'){ 
_if72_cond:
  lea d, [bp + -132] ; $operand_types
  push a
  push d
  lea d, [bp + -129] ; $j
  mov b, [d]
  mov c, 0
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000040
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if72_exit
_if72_TRUE:
; forwards(2); 
; --- START FUNCTION CALL
  mov32 cb, $00000002
  push bl
  call forwards
  add sp, 1
; --- END FUNCTION CALL
  jmp _if72_exit
_if72_exit:
_if71_exit:
; j++; 
  lea d, [bp + -129] ; $j
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -129] ; $j
  mov [d], b
  mov b, a
  jmp _if70_exit
_if70_else:
; if(toktype == INTEGER_CONST){ 
_if73_cond:
  mov d, _toktype ; $toktype
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $5 ; enum element: INTEGER_CONST
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if73_exit
_if73_TRUE:
; if(operand_types[j] == '#'){ 
_if74_cond:
  lea d, [bp + -132] ; $operand_types
  push a
  push d
  lea d, [bp + -129] ; $j
  mov b, [d]
  mov c, 0
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000023
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if74_else
_if74_TRUE:
; forwards(1); 
; --- START FUNCTION CALL
  mov32 cb, $00000001
  push bl
  call forwards
  add sp, 1
; --- END FUNCTION CALL
  jmp _if74_exit
_if74_else:
; if(operand_types[j] == '@'){ 
_if75_cond:
  lea d, [bp + -132] ; $operand_types
  push a
  push d
  lea d, [bp + -129] ; $j
  mov b, [d]
  mov c, 0
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000040
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if75_exit
_if75_TRUE:
; forwards(2); 
; --- START FUNCTION CALL
  mov32 cb, $00000002
  push bl
  call forwards
  add sp, 1
; --- END FUNCTION CALL
  jmp _if75_exit
_if75_exit:
_if74_exit:
; j++; 
  lea d, [bp + -129] ; $j
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -129] ; $j
  mov [d], b
  mov b, a
  jmp _if73_exit
_if73_exit:
_if70_exit:
_for68_update:
  jmp _for68_cond
_for68_exit:
; break; 
  jmp _for50_exit ; for break
_for50_update:
  lea d, [bp + -127] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -127] ; $i
  mov [d], b
  mov b, a
  jmp _for50_cond
_for50_exit:
_if41_exit:
; pop_prog(); 
; --- START FUNCTION CALL
  call pop_prog
  leave
  ret

parse_instr:
  enter 0 ; (push bp; mov bp, sp)
; char opcode[32]; 
  sub sp, 32
; char code_line[64]; 
  sub sp, 64
; struct t_opcode op; 
  sub sp, 26
; int instr_len; 
  sub sp, 2
; int num_operands, num_operands_exp; 
  sub sp, 2
  sub sp, 2
; int i, j; 
  sub sp, 2
  sub sp, 2
; char operand_types[3]; // operand types and locations 
  sub sp, 3
; int old_pc; 
  sub sp, 2
; char has_operands; 
  sub sp, 1
; old_pc = pc; 
  lea d, [bp + -136] ; $old_pc
  push d
  mov d, _pc ; $pc
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
; get_line(); 
; --- START FUNCTION CALL
  call get_line
; push_prog(); 
; --- START FUNCTION CALL
  call push_prog
; strcpy(code_line, string_const); 
; --- START FUNCTION CALL
  mov d, _string_const_data ; $string_const
  mov b, d
  mov c, 0
  swp b
  push b
  lea d, [bp + -95] ; $code_line
  mov b, d
  mov c, 0
  swp b
  push b
  call strcpy
  add sp, 4
; --- END FUNCTION CALL
; has_operands = 0; 
  lea d, [bp + -137] ; $has_operands
  push d
  mov32 cb, $00000000
  pop d
  mov [d], bl
; prog = code_line; 
  mov d, _prog ; $prog
  push d
  lea d, [bp + -95] ; $code_line
  mov b, d
  mov c, 0
  pop d
  mov [d], b
; get(); 
; --- START FUNCTION CALL
  call get
; for(;;){ 
_for76_init:
_for76_cond:
_for76_block:
; get(); 
; --- START FUNCTION CALL
  call get
; if(toktype == END) break; 
_if77_cond:
  mov d, _toktype ; $toktype
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $7 ; enum element: END
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if77_exit
_if77_TRUE:
; break; 
  jmp _for76_exit ; for break
  jmp _if77_exit
_if77_exit:
; if(toktype == INTEGER_CONST || label_exists(token) != -1){ 
_if78_cond:
  mov d, _toktype ; $toktype
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $5 ; enum element: INTEGER_CONST
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
; --- START LOGICAL OR
  push a
  mov a, b
; --- START FUNCTION CALL
  mov d, _token_data ; $token
  mov b, d
  mov c, 0
  swp b
  push b
  call label_exists
  add sp, 2
; --- END FUNCTION CALL
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $ffffffff
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  cmp b, 0
  je _if78_exit
_if78_TRUE:
; has_operands = 1; 
  lea d, [bp + -137] ; $has_operands
  push d
  mov32 cb, $00000001
  pop d
  mov [d], bl
; break; 
  jmp _for76_exit ; for break
  jmp _if78_exit
_if78_exit:
_for76_update:
  jmp _for76_cond
_for76_exit:
; opcode[0] = '\0'; 
  lea d, [bp + -31] ; $opcode
  push a
  push d
  mov32 cb, $00000000
  pop d
  add d, b
  pop a
  push d
  mov32 cb, $00000000
  pop d
  mov [d], bl
; prog = code_line; 
  mov d, _prog ; $prog
  push d
  lea d, [bp + -95] ; $code_line
  mov b, d
  mov c, 0
  pop d
  mov [d], b
; if(!has_operands){ 
_if79_cond:
  lea d, [bp + -137] ; $has_operands
  mov bl, [d]
  mov bh, 0
  mov c, 0
  cmp b, 0
  je _if79_else
_if79_TRUE:
; get(); 
; --- START FUNCTION CALL
  call get
; strcpy(opcode, token); 
; --- START FUNCTION CALL
  mov d, _token_data ; $token
  mov b, d
  mov c, 0
  swp b
  push b
  lea d, [bp + -31] ; $opcode
  mov b, d
  mov c, 0
  swp b
  push b
  call strcpy
  add sp, 4
; --- END FUNCTION CALL
; get();  
; --- START FUNCTION CALL
  call get
; if(toktype == END){ 
_if80_cond:
  mov d, _toktype ; $toktype
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $7 ; enum element: END
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if80_else
_if80_TRUE:
; strcat(opcode, " ."); 
; --- START FUNCTION CALL
  mov b, _s26 ; " ."
  swp b
  push b
  lea d, [bp + -31] ; $opcode
  mov b, d
  mov c, 0
  swp b
  push b
  call strcat
  add sp, 4
; --- END FUNCTION CALL
  jmp _if80_exit
_if80_else:
; strcat(opcode, " "); 
; --- START FUNCTION CALL
  mov b, _s27 ; " "
  swp b
  push b
  lea d, [bp + -31] ; $opcode
  mov b, d
  mov c, 0
  swp b
  push b
  call strcat
  add sp, 4
; --- END FUNCTION CALL
; strcat(opcode, token); 
; --- START FUNCTION CALL
  mov d, _token_data ; $token
  mov b, d
  mov c, 0
  swp b
  push b
  lea d, [bp + -31] ; $opcode
  mov b, d
  mov c, 0
  swp b
  push b
  call strcat
  add sp, 4
; --- END FUNCTION CALL
; for(;;){ 
_for81_init:
_for81_cond:
_for81_block:
; get(); 
; --- START FUNCTION CALL
  call get
; if(toktype == END) break; 
_if82_cond:
  mov d, _toktype ; $toktype
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $7 ; enum element: END
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if82_exit
_if82_TRUE:
; break; 
  jmp _for81_exit ; for break
  jmp _if82_exit
_if82_exit:
; strcat(opcode, token); 
; --- START FUNCTION CALL
  mov d, _token_data ; $token
  mov b, d
  mov c, 0
  swp b
  push b
  lea d, [bp + -31] ; $opcode
  mov b, d
  mov c, 0
  swp b
  push b
  call strcat
  add sp, 4
; --- END FUNCTION CALL
_for81_update:
  jmp _for81_cond
_for81_exit:
_if80_exit:
; op = search_opcode(opcode); 
  lea d, [bp + -121] ; $op
  push d
; --- START FUNCTION CALL
  lea d, [bp + -31] ; $opcode
  mov b, d
  mov c, 0
  swp b
  push b
  call search_opcode
  add sp, 2
; --- END FUNCTION CALL
  pop d
  mov si, b
  mov di, d
  mov c, 26
  rep movsb
; instr_len = 1; 
  lea d, [bp + -123] ; $instr_len
  push d
  mov32 cb, $00000001
  pop d
  mov [d], b
; if(op.opcode_type){ 
_if83_cond:
  lea d, [bp + -121] ; $op
  add d, 25
  mov bl, [d]
  mov bh, 0
  mov c, 0
  cmp b, 0
  je _if83_exit
_if83_TRUE:
; instr_len++; 
  lea d, [bp + -123] ; $instr_len
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -123] ; $instr_len
  mov [d], b
  mov b, a
; emit_byte(0xFD, emit_override); 
; --- START FUNCTION CALL
  lea d, [bp + 5] ; $emit_override
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push bl
  mov32 cb, $000000fd
  push bl
  call emit_byte
  add sp, 2
; --- END FUNCTION CALL
  jmp _if83_exit
_if83_exit:
; emit_byte(op.opcode, emit_override); 
; --- START FUNCTION CALL
  lea d, [bp + 5] ; $emit_override
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push bl
  lea d, [bp + -121] ; $op
  add d, 24
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push bl
  call emit_byte
  add sp, 2
; --- END FUNCTION CALL
; if(!emit_override){ 
_if84_cond:
  lea d, [bp + 5] ; $emit_override
  mov bl, [d]
  mov bh, 0
  mov c, 0
  cmp b, 0
  je _if84_exit
_if84_TRUE:
; printf("%x(%d): %s\n", old_pc, instr_len, code_line); 
; --- START FUNCTION CALL
  lea d, [bp + -95] ; $code_line
  mov b, d
  mov c, 0
  swp b
  push b
  lea d, [bp + -123] ; $instr_len
  mov b, [d]
  mov c, 0
  swp b
  push b
  lea d, [bp + -136] ; $old_pc
  mov b, [d]
  mov c, 0
  swp b
  push b
  mov b, _s30 ; "%x(%d): %s\n"
  swp b
  push b
  call printf
  add sp, 8
; --- END FUNCTION CALL
  jmp _if84_exit
_if84_exit:
  jmp _if79_exit
_if79_else:
; num_operands = 0; 
  lea d, [bp + -125] ; $num_operands
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
; for(;;){ 
_for85_init:
_for85_cond:
_for85_block:
; get(); 
; --- START FUNCTION CALL
  call get
; if(toktype == END) break; 
_if86_cond:
  mov d, _toktype ; $toktype
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $7 ; enum element: END
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if86_exit
_if86_TRUE:
; break; 
  jmp _for85_exit ; for break
  jmp _if86_exit
_if86_exit:
; if(toktype == INTEGER_CONST || label_exists(token) != -1) num_operands++; 
_if87_cond:
  mov d, _toktype ; $toktype
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $5 ; enum element: INTEGER_CONST
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
; --- START LOGICAL OR
  push a
  mov a, b
; --- START FUNCTION CALL
  mov d, _token_data ; $token
  mov b, d
  mov c, 0
  swp b
  push b
  call label_exists
  add sp, 2
; --- END FUNCTION CALL
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $ffffffff
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  cmp b, 0
  je _if87_exit
_if87_TRUE:
; num_operands++; 
  lea d, [bp + -125] ; $num_operands
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -125] ; $num_operands
  mov [d], b
  mov b, a
  jmp _if87_exit
_if87_exit:
_for85_update:
  jmp _for85_cond
_for85_exit:
; if(num_operands > 2) error("Maximum number of operands per instruction is 2."); 
_if88_cond:
  lea d, [bp + -125] ; $num_operands
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000002
  cmp a, b
  sgt ; >
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if88_exit
_if88_TRUE:
; error("Maximum number of operands per instruction is 2."); 
; --- START FUNCTION CALL
  mov b, _s28 ; "Maximum number of operands per instruction is 2."
  swp b
  push b
  call error
  add sp, 2
; --- END FUNCTION CALL
  jmp _if88_exit
_if88_exit:
; num_operands_exp = _exp(2, num_operands); 
  lea d, [bp + -127] ; $num_operands_exp
  push d
; --- START FUNCTION CALL
  lea d, [bp + -125] ; $num_operands
  mov b, [d]
  mov c, 0
  swp b
  push b
  mov32 cb, $00000002
  swp b
  push b
  call _exp
  add sp, 4
; --- END FUNCTION CALL
  pop d
  mov [d], b
; for(i = 0; i < num_operands_exp; i++){ 
_for89_init:
  lea d, [bp + -129] ; $i
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
_for89_cond:
  lea d, [bp + -129] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -127] ; $num_operands_exp
  mov b, [d]
  mov c, 0
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for89_exit
_for89_block:
; prog = code_line; 
  mov d, _prog ; $prog
  push d
  lea d, [bp + -95] ; $code_line
  mov b, d
  mov c, 0
  pop d
  mov [d], b
; get(); 
; --- START FUNCTION CALL
  call get
; strcpy(opcode, token); 
; --- START FUNCTION CALL
  mov d, _token_data ; $token
  mov b, d
  mov c, 0
  swp b
  push b
  lea d, [bp + -31] ; $opcode
  mov b, d
  mov c, 0
  swp b
  push b
  call strcpy
  add sp, 4
; --- END FUNCTION CALL
; strcat(opcode, " "); 
; --- START FUNCTION CALL
  mov b, _s27 ; " "
  swp b
  push b
  lea d, [bp + -31] ; $opcode
  mov b, d
  mov c, 0
  swp b
  push b
  call strcat
  add sp, 4
; --- END FUNCTION CALL
; j = 0; 
  lea d, [bp + -131] ; $j
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
; for(;;){ 
_for90_init:
_for90_cond:
_for90_block:
; get(); 
; --- START FUNCTION CALL
  call get
; if(toktype == END) break; 
_if91_cond:
  mov d, _toktype ; $toktype
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $7 ; enum element: END
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if91_exit
_if91_TRUE:
; break; 
  jmp _for90_exit ; for break
  jmp _if91_exit
_if91_exit:
; if(toktype == INTEGER_CONST || label_exists(token) != -1){ 
_if92_cond:
  mov d, _toktype ; $toktype
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $5 ; enum element: INTEGER_CONST
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
; --- START LOGICAL OR
  push a
  mov a, b
; --- START FUNCTION CALL
  mov d, _token_data ; $token
  mov b, d
  mov c, 0
  swp b
  push b
  call label_exists
  add sp, 2
; --- END FUNCTION CALL
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $ffffffff
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  cmp b, 0
  je _if92_else
_if92_TRUE:
; strcat(opcode, symbols[i*2+j]); 
; --- START FUNCTION CALL
  mov d, _symbols_data ; $symbols
  push a
  push d
  lea d, [bp + -129] ; $i
  mov b, [d]
  mov c, 0
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $00000002
  push a     ; save left operand
  xor a, b   ; xor sign bits
  swp a      ; swap bytes
  mov cl, al ; save result of xor into 'dl'
  pop a      ; restore left side operator
  push cl    ; save result of xor above
  swp a  
  test al, $80  
  swp a  
  jz skip_invert_a_100  
  neg a 
skip_invert_a_100:   
  swp b
  test bl, $80  
  swp b
  jz skip_invert_b_100  
  neg b 
skip_invert_b_100:   
  mul a, b ; *
  mov g, a
  mov a, b
  pop bl
  test bl, $80
  jz _same_signs_100
  mov bl, al
  not a
  neg b
  adc a, 0
  mov g, a
  mov a, b
_same_signs_100:
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
; --- START TERMS
  push a
  push g
  mov a, b
  mov g, c
  lea d, [bp + -131] ; $j
  mov b, [d]
  mov c, 0
  mov c, 0
  add32 cb, ga
  pop g
  pop a
; --- END TERMS
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  swp b
  push b
  lea d, [bp + -31] ; $opcode
  mov b, d
  mov c, 0
  swp b
  push b
  call strcat
  add sp, 4
; --- END FUNCTION CALL
; operand_types[j] = *symbols[i*2+j]; 
  lea d, [bp + -134] ; $operand_types
  push a
  push d
  lea d, [bp + -131] ; $j
  mov b, [d]
  mov c, 0
  pop d
  add d, b
  pop a
  push d
  mov d, _symbols_data ; $symbols
  push a
  push d
  lea d, [bp + -129] ; $i
  mov b, [d]
  mov c, 0
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $00000002
  push a     ; save left operand
  xor a, b   ; xor sign bits
  swp a      ; swap bytes
  mov cl, al ; save result of xor into 'dl'
  pop a      ; restore left side operator
  push cl    ; save result of xor above
  swp a  
  test al, $80  
  swp a  
  jz skip_invert_a_104  
  neg a 
skip_invert_a_104:   
  swp b
  test bl, $80  
  swp b
  jz skip_invert_b_104  
  neg b 
skip_invert_b_104:   
  mul a, b ; *
  mov g, a
  mov a, b
  pop bl
  test bl, $80
  jz _same_signs_104
  mov bl, al
  not a
  neg b
  adc a, 0
  mov g, a
  mov a, b
_same_signs_104:
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
; --- START TERMS
  push a
  push g
  mov a, b
  mov g, c
  lea d, [bp + -131] ; $j
  mov b, [d]
  mov c, 0
  mov c, 0
  add32 cb, ga
  pop g
  pop a
; --- END TERMS
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mov [d], bl
; j++; 
  lea d, [bp + -131] ; $j
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -131] ; $j
  mov [d], b
  mov b, a
  jmp _if92_exit
_if92_else:
; strcat(opcode, token); 
; --- START FUNCTION CALL
  mov d, _token_data ; $token
  mov b, d
  mov c, 0
  swp b
  push b
  lea d, [bp + -31] ; $opcode
  mov b, d
  mov c, 0
  swp b
  push b
  call strcat
  add sp, 4
; --- END FUNCTION CALL
_if92_exit:
_for90_update:
  jmp _for90_cond
_for90_exit:
; op = search_opcode(opcode); 
  lea d, [bp + -121] ; $op
  push d
; --- START FUNCTION CALL
  lea d, [bp + -31] ; $opcode
  mov b, d
  mov c, 0
  swp b
  push b
  call search_opcode
  add sp, 2
; --- END FUNCTION CALL
  pop d
  mov si, b
  mov di, d
  mov c, 26
  rep movsb
; if(op.name[0] == '\0') continue; 
_if105_cond:
  lea d, [bp + -121] ; $op
  add d, 0
  push a
  push d
  mov32 cb, $00000000
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if105_exit
_if105_TRUE:
; continue; 
  jmp _for89_update ; for continue
  jmp _if105_exit
_if105_exit:
; instr_len = 1; 
  lea d, [bp + -123] ; $instr_len
  push d
  mov32 cb, $00000001
  pop d
  mov [d], b
; if(op.opcode_type){ 
_if106_cond:
  lea d, [bp + -121] ; $op
  add d, 25
  mov bl, [d]
  mov bh, 0
  mov c, 0
  cmp b, 0
  je _if106_exit
_if106_TRUE:
; emit_byte(0xFD, emit_override); 
; --- START FUNCTION CALL
  lea d, [bp + 5] ; $emit_override
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push bl
  mov32 cb, $000000fd
  push bl
  call emit_byte
  add sp, 2
; --- END FUNCTION CALL
; instr_len++; 
  lea d, [bp + -123] ; $instr_len
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -123] ; $instr_len
  mov [d], b
  mov b, a
  jmp _if106_exit
_if106_exit:
; emit_byte(op.opcode, emit_override); 
; --- START FUNCTION CALL
  lea d, [bp + 5] ; $emit_override
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push bl
  lea d, [bp + -121] ; $op
  add d, 24
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push bl
  call emit_byte
  add sp, 2
; --- END FUNCTION CALL
; prog = code_line; 
  mov d, _prog ; $prog
  push d
  lea d, [bp + -95] ; $code_line
  mov b, d
  mov c, 0
  pop d
  mov [d], b
; j = 0; 
  lea d, [bp + -131] ; $j
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
; get(); 
; --- START FUNCTION CALL
  call get
; for(;;){ 
_for107_init:
_for107_cond:
_for107_block:
; get(); 
; --- START FUNCTION CALL
  call get
; if(toktype == END) break; 
_if108_cond:
  mov d, _toktype ; $toktype
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $7 ; enum element: END
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if108_exit
_if108_TRUE:
; break; 
  jmp _for107_exit ; for break
  jmp _if108_exit
_if108_exit:
; if(toktype == IDENTIFIER){ 
_if109_cond:
  mov d, _toktype ; $toktype
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $6 ; enum element: IDENTIFIER
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if109_else
_if109_TRUE:
; if(label_exists(token) != -1){ 
_if110_cond:
; --- START FUNCTION CALL
  mov d, _token_data ; $token
  mov b, d
  mov c, 0
  swp b
  push b
  call label_exists
  add sp, 2
; --- END FUNCTION CALL
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $ffffffff
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if110_else
_if110_TRUE:
; if(operand_types[j] == '#'){ 
_if111_cond:
  lea d, [bp + -134] ; $operand_types
  push a
  push d
  lea d, [bp + -131] ; $j
  mov b, [d]
  mov c, 0
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000023
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if111_else
_if111_TRUE:
; error("8bit operand _expected but 16bit label given."); 
; --- START FUNCTION CALL
  mov b, _s29 ; "8bit operand _expected but 16bit label given."
  swp b
  push b
  call error
  add sp, 2
; --- END FUNCTION CALL
  jmp _if111_exit
_if111_else:
; if(operand_types[j] == '@'){ 
_if112_cond:
  lea d, [bp + -134] ; $operand_types
  push a
  push d
  lea d, [bp + -131] ; $j
  mov b, [d]
  mov c, 0
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000040
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if112_exit
_if112_TRUE:
; emit_word(get_label_addr(token), emit_override); 
; --- START FUNCTION CALL
  lea d, [bp + 5] ; $emit_override
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push bl
; --- START FUNCTION CALL
  mov d, _token_data ; $token
  mov b, d
  mov c, 0
  swp b
  push b
  call get_label_addr
  add sp, 2
; --- END FUNCTION CALL
  swp b
  push b
  call emit_word
  add sp, 3
; --- END FUNCTION CALL
; instr_len = instr_len + 2; 
  lea d, [bp + -123] ; $instr_len
  push d
  lea d, [bp + -123] ; $instr_len
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000002
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
  jmp _if112_exit
_if112_exit:
_if111_exit:
; j++; 
  lea d, [bp + -131] ; $j
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -131] ; $j
  mov [d], b
  mov b, a
  jmp _if110_exit
_if110_else:
; if(!is_reserved(token)){ 
_if113_cond:
; --- START FUNCTION CALL
  mov d, _token_data ; $token
  mov b, d
  mov c, 0
  swp b
  push b
  call is_reserved
  add sp, 2
; --- END FUNCTION CALL
  cmp b, 0
  je _if113_exit
_if113_TRUE:
; error_s("Undeclared label: ", token); 
; --- START FUNCTION CALL
  mov d, _token_data ; $token
  mov b, d
  mov c, 0
  swp b
  push b
  mov b, _s31 ; "Undeclared label: "
  swp b
  push b
  call error_s
  add sp, 4
; --- END FUNCTION CALL
  jmp _if113_exit
_if113_exit:
_if110_exit:
  jmp _if109_exit
_if109_else:
; if(toktype == INTEGER_CONST){ 
_if114_cond:
  mov d, _toktype ; $toktype
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $5 ; enum element: INTEGER_CONST
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if114_exit
_if114_TRUE:
; if(operand_types[j] == '#'){ 
_if115_cond:
  lea d, [bp + -134] ; $operand_types
  push a
  push d
  lea d, [bp + -131] ; $j
  mov b, [d]
  mov c, 0
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000023
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if115_else
_if115_TRUE:
; emit_byte(int_const, emit_override); 
; --- START FUNCTION CALL
  lea d, [bp + 5] ; $emit_override
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push bl
  mov d, _int_const ; $int_const
  mov b, [d]
  mov c, 0
  push bl
  call emit_byte
  add sp, 2
; --- END FUNCTION CALL
; instr_len++; 
  lea d, [bp + -123] ; $instr_len
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -123] ; $instr_len
  mov [d], b
  mov b, a
  jmp _if115_exit
_if115_else:
; if(operand_types[j] == '@'){ 
_if116_cond:
  lea d, [bp + -134] ; $operand_types
  push a
  push d
  lea d, [bp + -131] ; $j
  mov b, [d]
  mov c, 0
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000040
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if116_exit
_if116_TRUE:
; emit_word(int_const, emit_override); 
; --- START FUNCTION CALL
  lea d, [bp + 5] ; $emit_override
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push bl
  mov d, _int_const ; $int_const
  mov b, [d]
  mov c, 0
  swp b
  push b
  call emit_word
  add sp, 3
; --- END FUNCTION CALL
; instr_len = instr_len + 2; 
  lea d, [bp + -123] ; $instr_len
  push d
  lea d, [bp + -123] ; $instr_len
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000002
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
  jmp _if116_exit
_if116_exit:
_if115_exit:
; j++; 
  lea d, [bp + -131] ; $j
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -131] ; $j
  mov [d], b
  mov b, a
  jmp _if114_exit
_if114_exit:
_if109_exit:
_for107_update:
  jmp _for107_cond
_for107_exit:
; if(!emit_override){ 
_if117_cond:
  lea d, [bp + 5] ; $emit_override
  mov bl, [d]
  mov bh, 0
  mov c, 0
  cmp b, 0
  je _if117_exit
_if117_TRUE:
; printf("%x(%d): %s\n", old_pc, instr_len, code_line); 
; --- START FUNCTION CALL
  lea d, [bp + -95] ; $code_line
  mov b, d
  mov c, 0
  swp b
  push b
  lea d, [bp + -123] ; $instr_len
  mov b, [d]
  mov c, 0
  swp b
  push b
  lea d, [bp + -136] ; $old_pc
  mov b, [d]
  mov c, 0
  swp b
  push b
  mov b, _s30 ; "%x(%d): %s\n"
  swp b
  push b
  call printf
  add sp, 8
; --- END FUNCTION CALL
  jmp _if117_exit
_if117_exit:
; break; 
  jmp _for89_exit ; for break
_for89_update:
  lea d, [bp + -129] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -129] ; $i
  mov [d], b
  mov b, a
  jmp _for89_cond
_for89_exit:
_if79_exit:
; pop_prog(); 
; --- START FUNCTION CALL
  call pop_prog
  leave
  ret

parse_text:
  enter 0 ; (push bp; mov bp, sp)
; char *temp_prog; 
  sub sp, 2
; printf("Parsing TEXT section...\n"); 
; --- START FUNCTION CALL
  mov b, _s32 ; "Parsing TEXT section...\n"
  swp b
  push b
  call printf
  add sp, 2
; --- END FUNCTION CALL
; prog = program; 
  mov d, _prog ; $prog
  push d
  mov d, _program ; $program
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
; bin_p = bin_out + _org; 
  mov d, _bin_p ; $bin_p
  push d
  mov d, _bin_out ; $bin_out
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov d, __org ; $_org
  mov b, [d]
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; pc = _org; 
  mov d, _pc ; $pc
  push d
  mov d, __org ; $_org
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
; for(;;){ 
_for118_init:
_for118_cond:
_for118_block:
; get(); 
; --- START FUNCTION CALL
  call get
; if(toktype == END) error("TEXT section not found."); 
_if119_cond:
  mov d, _toktype ; $toktype
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $7 ; enum element: END
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if119_exit
_if119_TRUE:
; error("TEXT section not found."); 
; --- START FUNCTION CALL
  mov b, _s33 ; "TEXT section not found."
  swp b
  push b
  call error
  add sp, 2
; --- END FUNCTION CALL
  jmp _if119_exit
_if119_exit:
; if(tok == TEXT){ 
_if120_cond:
  mov d, _tok ; $tok
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $4 ; enum element: TEXT
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if120_exit
_if120_TRUE:
; break; 
  jmp _for118_exit ; for break
  jmp _if120_exit
_if120_exit:
_for118_update:
  jmp _for118_cond
_for118_exit:
; for(;;){ 
_for121_init:
_for121_cond:
_for121_block:
; get(); back(); 
; --- START FUNCTION CALL
  call get
; back(); 
; --- START FUNCTION CALL
  call back
; temp_prog = prog; 
  lea d, [bp + -1] ; $temp_prog
  push d
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
; get(); 
; --- START FUNCTION CALL
  call get
; if(toktype == END) error("TEXT section end not found."); 
_if122_cond:
  mov d, _toktype ; $toktype
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $7 ; enum element: END
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if122_exit
_if122_TRUE:
; error("TEXT section end not found."); 
; --- START FUNCTION CALL
  mov b, _s34 ; "TEXT section end not found."
  swp b
  push b
  call error
  add sp, 2
; --- END FUNCTION CALL
  jmp _if122_exit
_if122_exit:
; if(tok == DOT){ 
_if123_cond:
  mov d, _tok ; $tok
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $10 ; enum element: DOT
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if123_else
_if123_TRUE:
; get(); 
; --- START FUNCTION CALL
  call get
; if(tok == SEGMENT_END) break; 
_if124_cond:
  mov d, _tok ; $tok
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $5 ; enum element: SEGMENT_END
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if124_else
_if124_TRUE:
; break; 
  jmp _for121_exit ; for break
  jmp _if124_exit
_if124_else:
; error("Un_expected directive."); 
; --- START FUNCTION CALL
  mov b, _s35 ; "Un_expected directive."
  swp b
  push b
  call error
  add sp, 2
; --- END FUNCTION CALL
_if124_exit:
  jmp _if123_exit
_if123_else:
; if(toktype == IDENTIFIER){ 
_if125_cond:
  mov d, _toktype ; $toktype
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $6 ; enum element: IDENTIFIER
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if125_exit
_if125_TRUE:
; get(); 
; --- START FUNCTION CALL
  call get
; if(tok != COLON){ 
_if126_cond:
  mov d, _tok ; $tok
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $d ; enum element: COLON
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if126_exit
_if126_TRUE:
; prog = temp_prog; 
  mov d, _prog ; $prog
  push d
  lea d, [bp + -1] ; $temp_prog
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
; parse_instr(0); 
; --- START FUNCTION CALL
  mov32 cb, $00000000
  push bl
  call parse_instr
  add sp, 1
; --- END FUNCTION CALL
  jmp _if126_exit
_if126_exit:
  jmp _if125_exit
_if125_exit:
_if123_exit:
_for121_update:
  jmp _for121_cond
_for121_exit:
; printf("Done.\n\n"); 
; --- START FUNCTION CALL
  mov b, _s36 ; "Done.\n\n"
  swp b
  push b
  call printf
  add sp, 2
; --- END FUNCTION CALL
  leave
  ret

debug:
  enter 0 ; (push bp; mov bp, sp)
; printf("\n"); 
; --- START FUNCTION CALL
  mov b, _s10 ; "\n"
  swp b
  push b
  call printf
  add sp, 2
; --- END FUNCTION CALL
; printf("Prog Offset: %x\n", prog - program); 
; --- START FUNCTION CALL
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov d, _program ; $program
  mov b, [d]
  mov c, 0
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  swp b
  push b
  mov b, _s37 ; "Prog Offset: %x\n"
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
; printf("Prog value : %c\n", *prog); 
; --- START FUNCTION CALL
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  swp b
  push b
  mov b, _s38 ; "Prog value : %c\n"
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
; printf("Token      : %s\n", token); 
; --- START FUNCTION CALL
  mov d, _token_data ; $token
  mov b, d
  mov c, 0
  swp b
  push b
  mov b, _s39 ; "Token      : %s\n"
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
; printf("Tok        : %d\n", tok); 
; --- START FUNCTION CALL
  mov d, _tok ; $tok
  mov b, [d]
  mov c, 0
  swp b
  push b
  mov b, _s40 ; "Tok        : %d\n"
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
; printf("Toktype    : %d\n", toktype); 
; --- START FUNCTION CALL
  mov d, _toktype ; $toktype
  mov b, [d]
  mov c, 0
  swp b
  push b
  mov b, _s41 ; "Toktype    : %d\n"
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
; printf("StringConst: %s\n", string_const); 
; --- START FUNCTION CALL
  mov d, _string_const_data ; $string_const
  mov b, d
  mov c, 0
  swp b
  push b
  mov b, _s42 ; "StringConst: %s\n"
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
; printf("PC         : %x\n", pc); 
; --- START FUNCTION CALL
  mov d, _pc ; $pc
  mov b, [d]
  mov c, 0
  swp b
  push b
  mov b, _s43 ; "PC         : %x\n"
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
  leave
  ret

display_output:
  enter 0 ; (push bp; mov bp, sp)
; int i; 
  sub sp, 2
; unsigned char *p; 
  sub sp, 2
; printf("\nAssembly complete.\n"); 
; --- START FUNCTION CALL
  mov b, _s44 ; "\nAssembly complete.\n"
  swp b
  push b
  call printf
  add sp, 2
; --- END FUNCTION CALL
; printf("Program size: %d\n", prog_size); 
; --- START FUNCTION CALL
  mov d, _prog_size ; $prog_size
  mov b, [d]
  mov c, 0
  swp b
  push b
  mov b, _s45 ; "Program size: %d\n"
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
; printf("Listing: \n"); 
; --- START FUNCTION CALL
  mov b, _s46 ; "Listing: \n"
  swp b
  push b
  call printf
  add sp, 2
; --- END FUNCTION CALL
; p = bin_out + _org; 
  lea d, [bp + -3] ; $p
  push d
  mov d, _bin_out ; $bin_out
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov d, __org ; $_org
  mov b, [d]
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; for(;;){ 
_for127_init:
_for127_cond:
_for127_block:
; if(p == bin_p) break; 
_if128_cond:
  lea d, [bp + -3] ; $p
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov d, _bin_p ; $bin_p
  mov b, [d]
  mov c, 0
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if128_exit
_if128_TRUE:
; break; 
  jmp _for127_exit ; for break
  jmp _if128_exit
_if128_exit:
; printf("%x", *p);  
; --- START FUNCTION CALL
  lea d, [bp + -3] ; $p
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  swp b
  push b
  mov b, _s47 ; "%x"
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
; p++; 
  lea d, [bp + -3] ; $p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -3] ; $p
  mov [d], b
  dec b
_for127_update:
  jmp _for127_cond
_for127_exit:
; printf("\n"); 
; --- START FUNCTION CALL
  mov b, _s10 ; "\n"
  swp b
  push b
  call printf
  add sp, 2
; --- END FUNCTION CALL
  leave
  ret

is_reserved:
  enter 0 ; (push bp; mov bp, sp)
; return !strcmp(name, "a") 
; --- START FUNCTION CALL
  mov b, _s48 ; "a"
  swp b
  push b
  lea d, [bp + 5] ; $name
  mov b, [d]
  mov c, 0
  swp b
  push b
  call strcmp
  add sp, 4
; --- END FUNCTION CALL
; --- START LOGICAL OR
  push a
  mov a, b
; --- START FUNCTION CALL
  mov b, _s49 ; "al"
  swp b
  push b
  lea d, [bp + 5] ; $name
  mov b, [d]
  mov c, 0
  swp b
  push b
  call strcmp
  add sp, 4
; --- END FUNCTION CALL
  sor a, b ; ||
  mov a, b
; --- START FUNCTION CALL
  mov b, _s50 ; "ah"
  swp b
  push b
  lea d, [bp + 5] ; $name
  mov b, [d]
  mov c, 0
  swp b
  push b
  call strcmp
  add sp, 4
; --- END FUNCTION CALL
  sor a, b ; ||
  mov a, b
; --- START FUNCTION CALL
  mov b, _s51 ; "b"
  swp b
  push b
  lea d, [bp + 5] ; $name
  mov b, [d]
  mov c, 0
  swp b
  push b
  call strcmp
  add sp, 4
; --- END FUNCTION CALL
  sor a, b ; ||
  mov a, b
; --- START FUNCTION CALL
  mov b, _s52 ; "bl"
  swp b
  push b
  lea d, [bp + 5] ; $name
  mov b, [d]
  mov c, 0
  swp b
  push b
  call strcmp
  add sp, 4
; --- END FUNCTION CALL
  sor a, b ; ||
  mov a, b
; --- START FUNCTION CALL
  mov b, _s53 ; "bh"
  swp b
  push b
  lea d, [bp + 5] ; $name
  mov b, [d]
  mov c, 0
  swp b
  push b
  call strcmp
  add sp, 4
; --- END FUNCTION CALL
  sor a, b ; ||
  mov a, b
; --- START FUNCTION CALL
  mov b, _s54 ; "c"
  swp b
  push b
  lea d, [bp + 5] ; $name
  mov b, [d]
  mov c, 0
  swp b
  push b
  call strcmp
  add sp, 4
; --- END FUNCTION CALL
  sor a, b ; ||
  mov a, b
; --- START FUNCTION CALL
  mov b, _s55 ; "cl"
  swp b
  push b
  lea d, [bp + 5] ; $name
  mov b, [d]
  mov c, 0
  swp b
  push b
  call strcmp
  add sp, 4
; --- END FUNCTION CALL
  sor a, b ; ||
  mov a, b
; --- START FUNCTION CALL
  mov b, _s56 ; "ch"
  swp b
  push b
  lea d, [bp + 5] ; $name
  mov b, [d]
  mov c, 0
  swp b
  push b
  call strcmp
  add sp, 4
; --- END FUNCTION CALL
  sor a, b ; ||
  mov a, b
; --- START FUNCTION CALL
  mov b, _s57 ; "d"
  swp b
  push b
  lea d, [bp + 5] ; $name
  mov b, [d]
  mov c, 0
  swp b
  push b
  call strcmp
  add sp, 4
; --- END FUNCTION CALL
  sor a, b ; ||
  mov a, b
; --- START FUNCTION CALL
  mov b, _s58 ; "dl"
  swp b
  push b
  lea d, [bp + 5] ; $name
  mov b, [d]
  mov c, 0
  swp b
  push b
  call strcmp
  add sp, 4
; --- END FUNCTION CALL
  sor a, b ; ||
  mov a, b
; --- START FUNCTION CALL
  mov b, _s59 ; "dh"
  swp b
  push b
  lea d, [bp + 5] ; $name
  mov b, [d]
  mov c, 0
  swp b
  push b
  call strcmp
  add sp, 4
; --- END FUNCTION CALL
  sor a, b ; ||
  mov a, b
; --- START FUNCTION CALL
  mov b, _s60 ; "g"
  swp b
  push b
  lea d, [bp + 5] ; $name
  mov b, [d]
  mov c, 0
  swp b
  push b
  call strcmp
  add sp, 4
; --- END FUNCTION CALL
  sor a, b ; ||
  mov a, b
; --- START FUNCTION CALL
  mov b, _s61 ; "gl"
  swp b
  push b
  lea d, [bp + 5] ; $name
  mov b, [d]
  mov c, 0
  swp b
  push b
  call strcmp
  add sp, 4
; --- END FUNCTION CALL
  sor a, b ; ||
  mov a, b
; --- START FUNCTION CALL
  mov b, _s62 ; "gh"
  swp b
  push b
  lea d, [bp + 5] ; $name
  mov b, [d]
  mov c, 0
  swp b
  push b
  call strcmp
  add sp, 4
; --- END FUNCTION CALL
  sor a, b ; ||
  mov a, b
; --- START FUNCTION CALL
  mov b, _s63 ; "pc"
  swp b
  push b
  lea d, [bp + 5] ; $name
  mov b, [d]
  mov c, 0
  swp b
  push b
  call strcmp
  add sp, 4
; --- END FUNCTION CALL
  sor a, b ; ||
  mov a, b
; --- START FUNCTION CALL
  mov b, _s64 ; "sp"
  swp b
  push b
  lea d, [bp + 5] ; $name
  mov b, [d]
  mov c, 0
  swp b
  push b
  call strcmp
  add sp, 4
; --- END FUNCTION CALL
  sor a, b ; ||
  mov a, b
; --- START FUNCTION CALL
  mov b, _s65 ; "bp"
  swp b
  push b
  lea d, [bp + 5] ; $name
  mov b, [d]
  mov c, 0
  swp b
  push b
  call strcmp
  add sp, 4
; --- END FUNCTION CALL
  sor a, b ; ||
  mov a, b
; --- START FUNCTION CALL
  mov b, _s66 ; "si"
  swp b
  push b
  lea d, [bp + 5] ; $name
  mov b, [d]
  mov c, 0
  swp b
  push b
  call strcmp
  add sp, 4
; --- END FUNCTION CALL
  sor a, b ; ||
  mov a, b
; --- START FUNCTION CALL
  mov b, _s67 ; "di"
  swp b
  push b
  lea d, [bp + 5] ; $name
  mov b, [d]
  mov c, 0
  swp b
  push b
  call strcmp
  add sp, 4
; --- END FUNCTION CALL
  sor a, b ; ||
  mov a, b
; --- START FUNCTION CALL
  mov b, _s68 ; "word"
  swp b
  push b
  lea d, [bp + 5] ; $name
  mov b, [d]
  mov c, 0
  swp b
  push b
  call strcmp
  add sp, 4
; --- END FUNCTION CALL
  sor a, b ; ||
  mov a, b
; --- START FUNCTION CALL
  mov b, _s69 ; "byte"
  swp b
  push b
  lea d, [bp + 5] ; $name
  mov b, [d]
  mov c, 0
  swp b
  push b
  call strcmp
  add sp, 4
; --- END FUNCTION CALL
  sor a, b ; ||
  mov a, b
; --- START FUNCTION CALL
  mov b, _s70 ; "cmpsb"
  swp b
  push b
  lea d, [bp + 5] ; $name
  mov b, [d]
  mov c, 0
  swp b
  push b
  call strcmp
  add sp, 4
; --- END FUNCTION CALL
  sor a, b ; ||
  mov a, b
; --- START FUNCTION CALL
  mov b, _s71 ; "movsb"
  swp b
  push b
  lea d, [bp + 5] ; $name
  mov b, [d]
  mov c, 0
  swp b
  push b
  call strcmp
  add sp, 4
; --- END FUNCTION CALL
  sor a, b ; ||
  mov a, b
; --- START FUNCTION CALL
  mov b, _s72 ; "stosb"
  swp b
  push b
  lea d, [bp + 5] ; $name
  mov b, [d]
  mov c, 0
  swp b
  push b
  call strcmp
  add sp, 4
; --- END FUNCTION CALL
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  leave
  ret

is_directive:
  enter 0 ; (push bp; mov bp, sp)
; return !strcmp(name, "org")  
; --- START FUNCTION CALL
  mov b, _s0 ; "org"
  swp b
  push b
  lea d, [bp + 5] ; $name
  mov b, [d]
  mov c, 0
  swp b
  push b
  call strcmp
  add sp, 4
; --- END FUNCTION CALL
; --- START LOGICAL OR
  push a
  mov a, b
; --- START FUNCTION CALL
  mov b, _s73 ; "define"
  swp b
  push b
  lea d, [bp + 5] ; $name
  mov b, [d]
  mov c, 0
  swp b
  push b
  call strcmp
  add sp, 4
; --- END FUNCTION CALL
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  leave
  ret

parse_label:
  enter 0 ; (push bp; mov bp, sp)
; char label_name[ 32      ]; 
  sub sp, 32
; get(); 
; --- START FUNCTION CALL
  call get
; strcpy(label_name, token); 
; --- START FUNCTION CALL
  mov d, _token_data ; $token
  mov b, d
  mov c, 0
  swp b
  push b
  lea d, [bp + -31] ; $label_name
  mov b, d
  mov c, 0
  swp b
  push b
  call strcpy
  add sp, 4
; --- END FUNCTION CALL
; declare_label(label_name, pc); 
; --- START FUNCTION CALL
  mov d, _pc ; $pc
  mov b, [d]
  mov c, 0
  swp b
  push b
  lea d, [bp + -31] ; $label_name
  mov b, d
  mov c, 0
  swp b
  push b
  call declare_label
  add sp, 4
; --- END FUNCTION CALL
; get(); // get ':' 
; --- START FUNCTION CALL
  call get
  leave
  ret

declare_label:
  enter 0 ; (push bp; mov bp, sp)
; int i; 
  sub sp, 2
; for(i = 0; i <  16          ; i++){ 
_for129_init:
  lea d, [bp + -1] ; $i
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
_for129_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000010
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for129_exit
_for129_block:
; if(!label_table[i].name[0]){ 
_if130_cond:
  mov d, _label_table_data ; $label_table
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 18 ; mov a, 18; mul a, b; add d, b
  pop a
  add d, 0
  push a
  push d
  mov32 cb, $00000000
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
  cmp b, 0
  je _if130_exit
_if130_TRUE:
; strcpy(label_table[i].name, name); 
; --- START FUNCTION CALL
  lea d, [bp + 5] ; $name
  mov b, [d]
  mov c, 0
  swp b
  push b
  mov d, _label_table_data ; $label_table
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 18 ; mov a, 18; mul a, b; add d, b
  pop a
  add d, 0
  mov b, d
  mov c, 0
  swp b
  push b
  call strcpy
  add sp, 4
; --- END FUNCTION CALL
; label_table[i].address = address; 
  mov d, _label_table_data ; $label_table
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 18 ; mov a, 18; mul a, b; add d, b
  pop a
  add d, 16
  push d
  lea d, [bp + 7] ; $address
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
; return i; 
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  leave
  ret
  jmp _if130_exit
_if130_exit:
_for129_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  mov b, a
  jmp _for129_cond
_for129_exit:
  leave
  ret

get_label_addr:
  enter 0 ; (push bp; mov bp, sp)
; int i; 
  sub sp, 2
; for(i = 0; i <  16          ; i++){ 
_for131_init:
  lea d, [bp + -1] ; $i
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
_for131_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000010
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for131_exit
_for131_block:
; if(!strcmp(label_table[i].name, name)){ 
_if132_cond:
; --- START FUNCTION CALL
  lea d, [bp + 5] ; $name
  mov b, [d]
  mov c, 0
  swp b
  push b
  mov d, _label_table_data ; $label_table
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 18 ; mov a, 18; mul a, b; add d, b
  pop a
  add d, 0
  mov b, d
  mov c, 0
  swp b
  push b
  call strcmp
  add sp, 4
; --- END FUNCTION CALL
  cmp b, 0
  je _if132_exit
_if132_TRUE:
; return label_table[i].address; 
  mov d, _label_table_data ; $label_table
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 18 ; mov a, 18; mul a, b; add d, b
  pop a
  add d, 16
  mov b, [d]
  mov c, 0
  leave
  ret
  jmp _if132_exit
_if132_exit:
_for131_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  mov b, a
  jmp _for131_cond
_for131_exit:
; error_s("Label does not exist: ", name); 
; --- START FUNCTION CALL
  lea d, [bp + 5] ; $name
  mov b, [d]
  mov c, 0
  swp b
  push b
  mov b, _s74 ; "Label does not exist: "
  swp b
  push b
  call error_s
  add sp, 4
; --- END FUNCTION CALL
  leave
  ret

label_exists:
  enter 0 ; (push bp; mov bp, sp)
; int i; 
  sub sp, 2
; for(i = 0; i <  16          ; i++){ 
_for133_init:
  lea d, [bp + -1] ; $i
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
_for133_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000010
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for133_exit
_for133_block:
; if(!strcmp(label_table[i].name, name)){ 
_if134_cond:
; --- START FUNCTION CALL
  lea d, [bp + 5] ; $name
  mov b, [d]
  mov c, 0
  swp b
  push b
  mov d, _label_table_data ; $label_table
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 18 ; mov a, 18; mul a, b; add d, b
  pop a
  add d, 0
  mov b, d
  mov c, 0
  swp b
  push b
  call strcmp
  add sp, 4
; --- END FUNCTION CALL
  cmp b, 0
  je _if134_exit
_if134_TRUE:
; return i; 
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  leave
  ret
  jmp _if134_exit
_if134_exit:
_for133_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  mov b, a
  jmp _for133_cond
_for133_exit:
; return -1; 
  mov32 cb, $ffffffff
  leave
  ret

search_opcode:
  enter 0 ; (push bp; mov bp, sp)
; char opcode_str[24]; 
  sub sp, 24
; char opcode_hex[5]; 
  sub sp, 5
; char *hex_p; 
  sub sp, 2
; char *op_p; 
  sub sp, 2
; char *tbl_p; 
  sub sp, 2
; struct t_opcode return_opcode; 
  sub sp, 26
; tbl_p = opcode_table; 
  lea d, [bp + -34] ; $tbl_p
  push d
  mov d, _opcode_table ; $opcode_table
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
; for(;;){ 
_for135_init:
_for135_cond:
_for135_block:
; op_p = opcode_str; 
  lea d, [bp + -32] ; $op_p
  push d
  lea d, [bp + -23] ; $opcode_str
  mov b, d
  mov c, 0
  pop d
  mov [d], b
; hex_p = opcode_hex; 
  lea d, [bp + -30] ; $hex_p
  push d
  lea d, [bp + -28] ; $opcode_hex
  mov b, d
  mov c, 0
  pop d
  mov [d], b
; while(*tbl_p != ' ') *op_p++ = *tbl_p++; 
_while136_cond:
  lea d, [bp + -34] ; $tbl_p
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000020
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _while136_exit
_while136_block:
; *op_p++ = *tbl_p++; 
  lea d, [bp + -32] ; $op_p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -32] ; $op_p
  mov [d], b
  dec b
  push b
  lea d, [bp + -34] ; $tbl_p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -34] ; $tbl_p
  mov [d], b
  dec b
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mov [d], bl
  jmp _while136_cond
_while136_exit:
; *op_p++ = *tbl_p++; 
  lea d, [bp + -32] ; $op_p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -32] ; $op_p
  mov [d], b
  dec b
  push b
  lea d, [bp + -34] ; $tbl_p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -34] ; $tbl_p
  mov [d], b
  dec b
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mov [d], bl
; while(*tbl_p != ' ') *op_p++ = *tbl_p++; 
_while137_cond:
  lea d, [bp + -34] ; $tbl_p
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000020
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _while137_exit
_while137_block:
; *op_p++ = *tbl_p++; 
  lea d, [bp + -32] ; $op_p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -32] ; $op_p
  mov [d], b
  dec b
  push b
  lea d, [bp + -34] ; $tbl_p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -34] ; $tbl_p
  mov [d], b
  dec b
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mov [d], bl
  jmp _while137_cond
_while137_exit:
; *op_p = '\0'; 
  lea d, [bp + -32] ; $op_p
  mov b, [d]
  mov c, 0
  push b
  mov32 cb, $00000000
  pop d
  mov [d], bl
; if(!strcmp(opcode_str, what_opcode)){ 
_if138_cond:
; --- START FUNCTION CALL
  lea d, [bp + 5] ; $what_opcode
  mov b, [d]
  mov c, 0
  swp b
  push b
  lea d, [bp + -23] ; $opcode_str
  mov b, d
  mov c, 0
  swp b
  push b
  call strcmp
  add sp, 4
; --- END FUNCTION CALL
  cmp b, 0
  je _if138_else
_if138_TRUE:
; strcpy(return_opcode.name, what_opcode); 
; --- START FUNCTION CALL
  lea d, [bp + 5] ; $what_opcode
  mov b, [d]
  mov c, 0
  swp b
  push b
  lea d, [bp + -60] ; $return_opcode
  add d, 0
  mov b, d
  mov c, 0
  swp b
  push b
  call strcpy
  add sp, 4
; --- END FUNCTION CALL
; while(*tbl_p == ' ') tbl_p++; 
_while139_cond:
  lea d, [bp + -34] ; $tbl_p
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000020
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _while139_exit
_while139_block:
; tbl_p++; 
  lea d, [bp + -34] ; $tbl_p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -34] ; $tbl_p
  mov [d], b
  dec b
  jmp _while139_cond
_while139_exit:
; while(is_hex_digit(*tbl_p)) *hex_p++ = *tbl_p++; // Copy hex opcode 
_while140_cond:
; --- START FUNCTION CALL
  lea d, [bp + -34] ; $tbl_p
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push bl
  call is_hex_digit
  add sp, 1
; --- END FUNCTION CALL
  cmp b, 0
  je _while140_exit
_while140_block:
; *hex_p++ = *tbl_p++; // Copy hex opcode 
  lea d, [bp + -30] ; $hex_p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -30] ; $hex_p
  mov [d], b
  dec b
  push b
  lea d, [bp + -34] ; $tbl_p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -34] ; $tbl_p
  mov [d], b
  dec b
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mov [d], bl
  jmp _while140_cond
_while140_exit:
; *hex_p = '\0'; 
  lea d, [bp + -30] ; $hex_p
  mov b, [d]
  mov c, 0
  push b
  mov32 cb, $00000000
  pop d
  mov [d], bl
; if(strlen(opcode_hex) == 4){ 
_if141_cond:
; --- START FUNCTION CALL
  lea d, [bp + -28] ; $opcode_hex
  mov b, d
  mov c, 0
  swp b
  push b
  call strlen
  add sp, 2
; --- END FUNCTION CALL
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000004
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if141_else
_if141_TRUE:
; return_opcode.opcode_type = 1; 
  lea d, [bp + -60] ; $return_opcode
  add d, 25
  push d
  mov32 cb, $00000001
  pop d
  mov [d], bl
; *(opcode_hex + 2) = '\0'; 
  lea d, [bp + -28] ; $opcode_hex
  mov b, d
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000002
  add b, a
  pop a
; --- END TERMS
  push b
  mov32 cb, $00000000
  pop d
  mov [d], b
; return_opcode.opcode = hex_to_int(opcode_hex); 
  lea d, [bp + -60] ; $return_opcode
  add d, 24
  push d
; --- START FUNCTION CALL
  lea d, [bp + -28] ; $opcode_hex
  mov b, d
  mov c, 0
  swp b
  push b
  call hex_to_int
  add sp, 2
; --- END FUNCTION CALL
  pop d
  mov [d], bl
  jmp _if141_exit
_if141_else:
; return_opcode.opcode_type = 0; 
  lea d, [bp + -60] ; $return_opcode
  add d, 25
  push d
  mov32 cb, $00000000
  pop d
  mov [d], bl
; return_opcode.opcode = hex_to_int(opcode_hex); 
  lea d, [bp + -60] ; $return_opcode
  add d, 24
  push d
; --- START FUNCTION CALL
  lea d, [bp + -28] ; $opcode_hex
  mov b, d
  mov c, 0
  swp b
  push b
  call hex_to_int
  add sp, 2
; --- END FUNCTION CALL
  pop d
  mov [d], bl
_if141_exit:
; return return_opcode; 
  lea d, [bp + -60] ; $return_opcode
  mov b, d
  mov c, 0
  leave
  ret
  jmp _if138_exit
_if138_else:
; while(*tbl_p != '\n') tbl_p++; 
_while142_cond:
  lea d, [bp + -34] ; $tbl_p
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $0000000a
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _while142_exit
_while142_block:
; tbl_p++; 
  lea d, [bp + -34] ; $tbl_p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -34] ; $tbl_p
  mov [d], b
  dec b
  jmp _while142_cond
_while142_exit:
; while(*tbl_p == '\n') tbl_p++; 
_while143_cond:
  lea d, [bp + -34] ; $tbl_p
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $0000000a
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _while143_exit
_while143_block:
; tbl_p++; 
  lea d, [bp + -34] ; $tbl_p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -34] ; $tbl_p
  mov [d], b
  dec b
  jmp _while143_cond
_while143_exit:
; if(!*tbl_p) break; 
_if144_cond:
  lea d, [bp + -34] ; $tbl_p
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  cmp b, 0
  seq ; !
  cmp b, 0
  je _if144_exit
_if144_TRUE:
; break; 
  jmp _for135_exit ; for break
  jmp _if144_exit
_if144_exit:
_if138_exit:
_for135_update:
  jmp _for135_cond
_for135_exit:
; return_opcode.name[0] = '\0'; 
  lea d, [bp + -60] ; $return_opcode
  add d, 0
  push a
  push d
  mov32 cb, $00000000
  pop d
  add d, b
  pop a
  push d
  mov32 cb, $00000000
  pop d
  mov [d], bl
; return return_opcode; 
  lea d, [bp + -60] ; $return_opcode
  mov b, d
  mov c, 0
  leave
  ret

forwards:
  enter 0 ; (push bp; mov bp, sp)
; bin_p = bin_p + amount; 
  mov d, _bin_p ; $bin_p
  push d
  mov d, _bin_p ; $bin_p
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + 5] ; $amount
  mov bl, [d]
  mov bh, 0
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; prog_size = prog_size + amount; 
  mov d, _prog_size ; $prog_size
  push d
  mov d, _prog_size ; $prog_size
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + 5] ; $amount
  mov bl, [d]
  mov bh, 0
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; pc = pc + amount; 
  mov d, _pc ; $pc
  push d
  mov d, _pc ; $pc
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + 5] ; $amount
  mov bl, [d]
  mov bh, 0
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
  leave
  ret

emit_byte:
  enter 0 ; (push bp; mov bp, sp)
; if(!emit_override){ 
_if145_cond:
  lea d, [bp + 6] ; $emit_override
  mov bl, [d]
  mov bh, 0
  mov c, 0
  cmp b, 0
  je _if145_exit
_if145_TRUE:
; *bin_p = byte; 
  mov d, _bin_p ; $bin_p
  mov b, [d]
  mov c, 0
  push b
  lea d, [bp + 5] ; $byte
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mov [d], bl
  jmp _if145_exit
_if145_exit:
; forwards(1); 
; --- START FUNCTION CALL
  mov32 cb, $00000001
  push bl
  call forwards
  add sp, 1
; --- END FUNCTION CALL
  leave
  ret

emit_word:
  enter 0 ; (push bp; mov bp, sp)
; if(!emit_override){ 
_if146_cond:
  lea d, [bp + 7] ; $emit_override
  mov bl, [d]
  mov bh, 0
  mov c, 0
  cmp b, 0
  je _if146_exit
_if146_TRUE:
; *((int*)bin_p) = word; 
  mov d, _bin_p ; $bin_p
  mov b, [d]
  mov c, 0
  push b
  lea d, [bp + 5] ; $word
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
  jmp _if146_exit
_if146_exit:
; forwards(2); 
; --- START FUNCTION CALL
  mov32 cb, $00000002
  push bl
  call forwards
  add sp, 1
; --- END FUNCTION CALL
  leave
  ret

back:
  enter 0 ; (push bp; mov bp, sp)
; char *t; 
  sub sp, 2
; t = token; 
  lea d, [bp + -1] ; $t
  push d
  mov d, _token_data ; $token
  mov b, d
  mov c, 0
  pop d
  mov [d], b
; while(*t){ 
_while147_cond:
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  cmp b, 0
  je _while147_exit
_while147_block:
; prog--; 
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  dec b
  mov d, _prog ; $prog
  mov [d], b
  inc b
; t++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  dec b
  jmp _while147_cond
_while147_exit:
  leave
  ret

get_path:
  enter 0 ; (push bp; mov bp, sp)
; char *t; 
  sub sp, 2
; *token = '\0'; 
  mov d, _token_data ; $token
  mov b, d
  mov c, 0
  push b
  mov32 cb, $00000000
  pop d
  mov [d], bl
; tok = 0; 
  mov d, _tok ; $tok
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
; toktype = 0; 
  mov d, _toktype ; $toktype
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
; t = token; 
  lea d, [bp + -1] ; $t
  push d
  mov d, _token_data ; $token
  mov b, d
  mov c, 0
  pop d
  mov [d], b
; while(is_space(*prog)) prog++; 
_while148_cond:
; --- START FUNCTION CALL
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push bl
  call is_space
  add sp, 1
; --- END FUNCTION CALL
  cmp b, 0
  je _while148_exit
_while148_block:
; prog++; 
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  inc b
  mov d, _prog ; $prog
  mov [d], b
  dec b
  jmp _while148_cond
_while148_exit:
; if(*prog == '\0'){ 
_if149_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if149_exit
_if149_TRUE:
; toktype = END; 
  mov d, _toktype ; $toktype
  push d
  mov32 cb, $7 ; enum element: END
  pop d
  mov [d], b
; return; 
  leave
  ret
  jmp _if149_exit
_if149_exit:
; while(*prog == '/' || is_alpha(*prog) || is_digit(*prog) || *prog == '_' || *prog == '-' || *prog == '.') { 
_while150_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $0000002f
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
; --- START LOGICAL OR
  push a
  mov a, b
; --- START FUNCTION CALL
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push bl
  call is_alpha
  add sp, 1
; --- END FUNCTION CALL
  sor a, b ; ||
  mov a, b
; --- START FUNCTION CALL
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push bl
  call is_digit
  add sp, 1
; --- END FUNCTION CALL
  sor a, b ; ||
  mov a, b
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $0000005f
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  mov a, b
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $0000002d
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  mov a, b
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $0000002e
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  cmp b, 0
  je _while150_exit
_while150_block:
; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  dec b
  push b
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  inc b
  mov d, _prog ; $prog
  mov [d], b
  dec b
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mov [d], bl
  jmp _while150_cond
_while150_exit:
; *t = '\0'; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov c, 0
  push b
  mov32 cb, $00000000
  pop d
  mov [d], bl
  leave
  ret

is_hex_digit:
  enter 0 ; (push bp; mov bp, sp)
; return c >= '0' && c <= '9' || c >= 'A' && c <= 'F' || c >= 'a' && c <= 'f'; 
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000030
  cmp a, b
  sge ; >=
  pop a
; --- END RELATIONAL
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000039
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
; --- START LOGICAL OR
  push a
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000041
  cmp a, b
  sge ; >=
  pop a
; --- END RELATIONAL
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000046
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  sor a, b ; ||
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000061
  cmp a, b
  sge ; >=
  pop a
; --- END RELATIONAL
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000066
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  leave
  ret

get_line:
  enter 0 ; (push bp; mov bp, sp)
; char *t; 
  sub sp, 2
; t = string_const; 
  lea d, [bp + -1] ; $t
  push d
  mov d, _string_const_data ; $string_const
  mov b, d
  mov c, 0
  pop d
  mov [d], b
; *t = '\0'; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov c, 0
  push b
  mov32 cb, $00000000
  pop d
  mov [d], bl
; while(*prog != 0x0A && *prog != '\0'){ 
_while151_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $0000000a
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
; --- START LOGICAL AND
  push a
  mov a, b
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  cmp b, 0
  je _while151_exit
_while151_block:
; if(*prog == ';'){ 
_if152_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $0000003b
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if152_else
_if152_TRUE:
; while(*prog != 0x0A && *prog != '\0') prog++; 
_while153_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $0000000a
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
; --- START LOGICAL AND
  push a
  mov a, b
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  cmp b, 0
  je _while153_exit
_while153_block:
; prog++; 
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  inc b
  mov d, _prog ; $prog
  mov [d], b
  dec b
  jmp _while153_cond
_while153_exit:
; break; 
  jmp _while151_exit ; while break
  jmp _if152_exit
_if152_else:
; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  dec b
  push b
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  inc b
  mov d, _prog ; $prog
  mov [d], b
  dec b
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mov [d], bl
_if152_exit:
  jmp _while151_cond
_while151_exit:
; *t = '\0'; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov c, 0
  push b
  mov32 cb, $00000000
  pop d
  mov [d], bl
  leave
  ret

get:
  enter 0 ; (push bp; mov bp, sp)
; char *t; 
  sub sp, 2
; char temp_hex[64]; 
  sub sp, 64
; char *p; 
  sub sp, 2
; *token = '\0'; 
  mov d, _token_data ; $token
  mov b, d
  mov c, 0
  push b
  mov32 cb, $00000000
  pop d
  mov [d], bl
; tok = TOK_UNDEF; 
  mov d, _tok ; $tok
  push d
  mov32 cb, $0 ; enum element: TOK_UNDEF
  pop d
  mov [d], b
; toktype = TYPE_UNDEF; 
  mov d, _toktype ; $toktype
  push d
  mov32 cb, $0 ; enum element: TYPE_UNDEF
  pop d
  mov [d], b
; t = token; 
  lea d, [bp + -1] ; $t
  push d
  mov d, _token_data ; $token
  mov b, d
  mov c, 0
  pop d
  mov [d], b
; do{ 
_do154_block:
; while(is_space(*prog)) prog++; 
_while155_cond:
; --- START FUNCTION CALL
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push bl
  call is_space
  add sp, 1
; --- END FUNCTION CALL
  cmp b, 0
  je _while155_exit
_while155_block:
; prog++; 
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  inc b
  mov d, _prog ; $prog
  mov [d], b
  dec b
  jmp _while155_cond
_while155_exit:
; if(*prog == ';'){ 
_if156_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $0000003b
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if156_exit
_if156_TRUE:
; while(*prog != '\n') prog++; 
_while157_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $0000000a
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _while157_exit
_while157_block:
; prog++; 
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  inc b
  mov d, _prog ; $prog
  mov [d], b
  dec b
  jmp _while157_cond
_while157_exit:
; if(*prog == '\n') prog++; 
_if158_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $0000000a
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if158_exit
_if158_TRUE:
; prog++; 
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  inc b
  mov d, _prog ; $prog
  mov [d], b
  dec b
  jmp _if158_exit
_if158_exit:
  jmp _if156_exit
_if156_exit:
; } while(is_space(*prog) || *prog == ';'); 
_do154_cond:
; --- START FUNCTION CALL
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push bl
  call is_space
  add sp, 1
; --- END FUNCTION CALL
; --- START LOGICAL OR
  push a
  mov a, b
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $0000003b
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  cmp b, 1
  je _do154_block
_do154_exit:
; if(*prog == '\0'){ 
_if159_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if159_exit
_if159_TRUE:
; toktype = END; 
  mov d, _toktype ; $toktype
  push d
  mov32 cb, $7 ; enum element: END
  pop d
  mov [d], b
; return; 
  leave
  ret
  jmp _if159_exit
_if159_exit:
; if(is_alpha(*prog)){ 
_if160_cond:
; --- START FUNCTION CALL
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push bl
  call is_alpha
  add sp, 1
; --- END FUNCTION CALL
  cmp b, 0
  je _if160_else
_if160_TRUE:
; while(is_alpha(*prog) || is_digit(*prog)){ 
_while161_cond:
; --- START FUNCTION CALL
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push bl
  call is_alpha
  add sp, 1
; --- END FUNCTION CALL
; --- START LOGICAL OR
  push a
  mov a, b
; --- START FUNCTION CALL
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push bl
  call is_digit
  add sp, 1
; --- END FUNCTION CALL
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  cmp b, 0
  je _while161_exit
_while161_block:
; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  dec b
  push b
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  inc b
  mov d, _prog ; $prog
  mov [d], b
  dec b
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mov [d], bl
  jmp _while161_cond
_while161_exit:
; *t = '\0'; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov c, 0
  push b
  mov32 cb, $00000000
  pop d
  mov [d], bl
; if((tok = search_keyword(token)) != -1)  
_if162_cond:
  mov d, _tok ; $tok
  push d
; --- START FUNCTION CALL
  mov d, _token_data ; $token
  mov b, d
  mov c, 0
  swp b
  push b
  call search_keyword
  add sp, 2
; --- END FUNCTION CALL
  pop d
  mov [d], b
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $ffffffff
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if162_else
_if162_TRUE:
; toktype = KEYWORD; 
  mov d, _toktype ; $toktype
  push d
  mov32 cb, $1 ; enum element: KEYWORD
  pop d
  mov [d], b
  jmp _if162_exit
_if162_else:
; toktype = IDENTIFIER; 
  mov d, _toktype ; $toktype
  push d
  mov32 cb, $6 ; enum element: IDENTIFIER
  pop d
  mov [d], b
_if162_exit:
  jmp _if160_exit
_if160_else:
; if(is_digit(*prog) || (*prog == '$' && is_hex_digit(*(prog+1)))){ 
_if163_cond:
; --- START FUNCTION CALL
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push bl
  call is_digit
  add sp, 1
; --- END FUNCTION CALL
; --- START LOGICAL OR
  push a
  mov a, b
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000024
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
; --- START LOGICAL AND
  push a
  mov a, b
; --- START FUNCTION CALL
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000001
  add b, a
  pop a
; --- END TERMS
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push bl
  call is_hex_digit
  add sp, 1
; --- END FUNCTION CALL
  sand a, b
  pop a
; --- END LOGICAL AND
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  cmp b, 0
  je _if163_else
_if163_TRUE:
; if(*prog == '$' && is_hex_digit(*(prog+1))){ 
_if164_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000024
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
; --- START LOGICAL AND
  push a
  mov a, b
; --- START FUNCTION CALL
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000001
  add b, a
  pop a
; --- END TERMS
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push bl
  call is_hex_digit
  add sp, 1
; --- END FUNCTION CALL
  sand a, b
  pop a
; --- END LOGICAL AND
  cmp b, 0
  je _if164_else
_if164_TRUE:
; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  dec b
  push b
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  inc b
  mov d, _prog ; $prog
  mov [d], b
  dec b
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mov [d], bl
; p = temp_hex; 
  lea d, [bp + -67] ; $p
  push d
  lea d, [bp + -65] ; $temp_hex
  mov b, d
  mov c, 0
  pop d
  mov [d], b
; *t++ = *p++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  dec b
  push b
  lea d, [bp + -67] ; $p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -67] ; $p
  mov [d], b
  dec b
  push b
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  inc b
  mov d, _prog ; $prog
  mov [d], b
  dec b
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mov [d], bl
  pop d
  mov [d], bl
; while(is_hex_digit(*prog)){ 
_while165_cond:
; --- START FUNCTION CALL
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push bl
  call is_hex_digit
  add sp, 1
; --- END FUNCTION CALL
  cmp b, 0
  je _while165_exit
_while165_block:
; *t++ = *p++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  dec b
  push b
  lea d, [bp + -67] ; $p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -67] ; $p
  mov [d], b
  dec b
  push b
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  inc b
  mov d, _prog ; $prog
  mov [d], b
  dec b
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mov [d], bl
  pop d
  mov [d], bl
  jmp _while165_cond
_while165_exit:
; *t = *p = '\0'; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov c, 0
  push b
  lea d, [bp + -67] ; $p
  mov b, [d]
  mov c, 0
  push b
  mov32 cb, $00000000
  pop d
  mov [d], bl
  pop d
  mov [d], bl
; int_const = hex_to_int(temp_hex); 
  mov d, _int_const ; $int_const
  push d
; --- START FUNCTION CALL
  lea d, [bp + -65] ; $temp_hex
  mov b, d
  mov c, 0
  swp b
  push b
  call hex_to_int
  add sp, 2
; --- END FUNCTION CALL
  pop d
  mov [d], b
  jmp _if164_exit
_if164_else:
; while(is_digit(*prog)){ 
_while166_cond:
; --- START FUNCTION CALL
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push bl
  call is_digit
  add sp, 1
; --- END FUNCTION CALL
  cmp b, 0
  je _while166_exit
_while166_block:
; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  dec b
  push b
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  inc b
  mov d, _prog ; $prog
  mov [d], b
  dec b
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mov [d], bl
  jmp _while166_cond
_while166_exit:
; *t = '\0'; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov c, 0
  push b
  mov32 cb, $00000000
  pop d
  mov [d], bl
; int_const = atoi(token); 
  mov d, _int_const ; $int_const
  push d
; --- START FUNCTION CALL
  mov d, _token_data ; $token
  mov b, d
  mov c, 0
  swp b
  push b
  call atoi
  add sp, 2
; --- END FUNCTION CALL
  pop d
  mov [d], b
_if164_exit:
; toktype = INTEGER_CONST; 
  mov d, _toktype ; $toktype
  push d
  mov32 cb, $5 ; enum element: INTEGER_CONST
  pop d
  mov [d], b
  jmp _if163_exit
_if163_else:
; if(*prog == '\''){ 
_if167_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000027
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if167_else
_if167_TRUE:
; *t++ = '\''; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  dec b
  push b
  mov32 cb, $00000027
  pop d
  mov [d], bl
; prog++; 
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  inc b
  mov d, _prog ; $prog
  mov [d], b
  dec b
; if(*prog == '\\'){ 
_if168_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $0000005c
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if168_else
_if168_TRUE:
; *t++ = '\\'; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  dec b
  push b
  mov32 cb, $0000005c
  pop d
  mov [d], bl
; prog++; 
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  inc b
  mov d, _prog ; $prog
  mov [d], b
  dec b
; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  dec b
  push b
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  inc b
  mov d, _prog ; $prog
  mov [d], b
  dec b
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mov [d], bl
  jmp _if168_exit
_if168_else:
; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  dec b
  push b
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  inc b
  mov d, _prog ; $prog
  mov [d], b
  dec b
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mov [d], bl
_if168_exit:
; if(*prog != '\''){ 
_if169_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000027
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if169_exit
_if169_TRUE:
; error("Closing single quotes _expected."); 
; --- START FUNCTION CALL
  mov b, _s75 ; "Closing single quotes _expected."
  swp b
  push b
  call error
  add sp, 2
; --- END FUNCTION CALL
  jmp _if169_exit
_if169_exit:
; *t++ = '\''; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  dec b
  push b
  mov32 cb, $00000027
  pop d
  mov [d], bl
; prog++; 
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  inc b
  mov d, _prog ; $prog
  mov [d], b
  dec b
; toktype = CHAR_CONST; 
  mov d, _toktype ; $toktype
  push d
  mov32 cb, $3 ; enum element: CHAR_CONST
  pop d
  mov [d], b
; *t = '\0'; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov c, 0
  push b
  mov32 cb, $00000000
  pop d
  mov [d], bl
; convert_constant(); // converts this string token with quotation marks to a non quotation marks string, and also converts escape sequences to their real bytes 
; --- START FUNCTION CALL
  call convert_constant
  jmp _if167_exit
_if167_else:
; if(*prog == '\"'){ 
_if170_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000022
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if170_else
_if170_TRUE:
; *t++ = '\"'; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  dec b
  push b
  mov32 cb, $00000022
  pop d
  mov [d], bl
; prog++; 
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  inc b
  mov d, _prog ; $prog
  mov [d], b
  dec b
; while(*prog != '\"' && *prog){ 
_while171_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000022
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
; --- START LOGICAL AND
  push a
  mov a, b
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  sand a, b
  pop a
; --- END LOGICAL AND
  cmp b, 0
  je _while171_exit
_while171_block:
; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  dec b
  push b
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  inc b
  mov d, _prog ; $prog
  mov [d], b
  dec b
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mov [d], bl
  jmp _while171_cond
_while171_exit:
; if(*prog != '\"') error("Double quotes _expected"); 
_if172_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000022
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if172_exit
_if172_TRUE:
; error("Double quotes _expected"); 
; --- START FUNCTION CALL
  mov b, _s76 ; "Double quotes _expected"
  swp b
  push b
  call error
  add sp, 2
; --- END FUNCTION CALL
  jmp _if172_exit
_if172_exit:
; *t++ = '\"'; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  dec b
  push b
  mov32 cb, $00000022
  pop d
  mov [d], bl
; prog++; 
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  inc b
  mov d, _prog ; $prog
  mov [d], b
  dec b
; toktype = STRING_CONST; 
  mov d, _toktype ; $toktype
  push d
  mov32 cb, $4 ; enum element: STRING_CONST
  pop d
  mov [d], b
; *t = '\0'; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov c, 0
  push b
  mov32 cb, $00000000
  pop d
  mov [d], bl
; convert_constant(); // converts this string token with quotation marks to a non quotation marks string, and also converts escape sequences to their real bytes 
; --- START FUNCTION CALL
  call convert_constant
  jmp _if170_exit
_if170_else:
; if(*prog == '['){ 
_if173_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $0000005b
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if173_else
_if173_TRUE:
; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  dec b
  push b
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  inc b
  mov d, _prog ; $prog
  mov [d], b
  dec b
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mov [d], bl
; tok = OPENING_BRACKET; 
  mov d, _tok ; $tok
  push d
  mov32 cb, $b ; enum element: OPENING_BRACKET
  pop d
  mov [d], b
; toktype = DELIMITER;   
  mov d, _toktype ; $toktype
  push d
  mov32 cb, $2 ; enum element: DELIMITER
  pop d
  mov [d], b
  jmp _if173_exit
_if173_else:
; if(*prog == ']'){ 
_if174_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $0000005d
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if174_else
_if174_TRUE:
; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  dec b
  push b
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  inc b
  mov d, _prog ; $prog
  mov [d], b
  dec b
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mov [d], bl
; tok = CLOSING_BRACKET; 
  mov d, _tok ; $tok
  push d
  mov32 cb, $c ; enum element: CLOSING_BRACKET
  pop d
  mov [d], b
; toktype = DELIMITER;   
  mov d, _toktype ; $toktype
  push d
  mov32 cb, $2 ; enum element: DELIMITER
  pop d
  mov [d], b
  jmp _if174_exit
_if174_else:
; if(*prog == '+'){ 
_if175_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $0000002b
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if175_else
_if175_TRUE:
; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  dec b
  push b
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  inc b
  mov d, _prog ; $prog
  mov [d], b
  dec b
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mov [d], bl
; tok = PLUS; 
  mov d, _tok ; $tok
  push d
  mov32 cb, $8 ; enum element: PLUS
  pop d
  mov [d], b
; toktype = DELIMITER;   
  mov d, _toktype ; $toktype
  push d
  mov32 cb, $2 ; enum element: DELIMITER
  pop d
  mov [d], b
  jmp _if175_exit
_if175_else:
; if(*prog == '-'){ 
_if176_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $0000002d
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if176_else
_if176_TRUE:
; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  dec b
  push b
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  inc b
  mov d, _prog ; $prog
  mov [d], b
  dec b
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mov [d], bl
; tok = MINUS; 
  mov d, _tok ; $tok
  push d
  mov32 cb, $9 ; enum element: MINUS
  pop d
  mov [d], b
; toktype = DELIMITER;   
  mov d, _toktype ; $toktype
  push d
  mov32 cb, $2 ; enum element: DELIMITER
  pop d
  mov [d], b
  jmp _if176_exit
_if176_else:
; if(*prog == '$'){ 
_if177_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000024
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if177_else
_if177_TRUE:
; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  dec b
  push b
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  inc b
  mov d, _prog ; $prog
  mov [d], b
  dec b
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mov [d], bl
; tok = DOLLAR; 
  mov d, _tok ; $tok
  push d
  mov32 cb, $a ; enum element: DOLLAR
  pop d
  mov [d], b
; toktype = DELIMITER;   
  mov d, _toktype ; $toktype
  push d
  mov32 cb, $2 ; enum element: DELIMITER
  pop d
  mov [d], b
  jmp _if177_exit
_if177_else:
; if(*prog == ':'){ 
_if178_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $0000003a
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if178_else
_if178_TRUE:
; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  dec b
  push b
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  inc b
  mov d, _prog ; $prog
  mov [d], b
  dec b
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mov [d], bl
; tok = COLON; 
  mov d, _tok ; $tok
  push d
  mov32 cb, $d ; enum element: COLON
  pop d
  mov [d], b
; toktype = DELIMITER;   
  mov d, _toktype ; $toktype
  push d
  mov32 cb, $2 ; enum element: DELIMITER
  pop d
  mov [d], b
  jmp _if178_exit
_if178_else:
; if(*prog == ';'){ 
_if179_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $0000003b
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if179_else
_if179_TRUE:
; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  dec b
  push b
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  inc b
  mov d, _prog ; $prog
  mov [d], b
  dec b
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mov [d], bl
; tok = SEMICOLON; 
  mov d, _tok ; $tok
  push d
  mov32 cb, $e ; enum element: SEMICOLON
  pop d
  mov [d], b
; toktype = DELIMITER;   
  mov d, _toktype ; $toktype
  push d
  mov32 cb, $2 ; enum element: DELIMITER
  pop d
  mov [d], b
  jmp _if179_exit
_if179_else:
; if(*prog == ','){ 
_if180_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $0000002c
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if180_else
_if180_TRUE:
; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  dec b
  push b
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  inc b
  mov d, _prog ; $prog
  mov [d], b
  dec b
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mov [d], bl
; tok = COMMA; 
  mov d, _tok ; $tok
  push d
  mov32 cb, $f ; enum element: COMMA
  pop d
  mov [d], b
; toktype = DELIMITER;   
  mov d, _toktype ; $toktype
  push d
  mov32 cb, $2 ; enum element: DELIMITER
  pop d
  mov [d], b
  jmp _if180_exit
_if180_else:
; if(*prog == '.'){ 
_if181_cond:
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $0000002e
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if181_exit
_if181_TRUE:
; *t++ = *prog++; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -1] ; $t
  mov [d], b
  dec b
  push b
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  inc b
  mov d, _prog ; $prog
  mov [d], b
  dec b
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mov [d], bl
; tok = DOT; 
  mov d, _tok ; $tok
  push d
  mov32 cb, $10 ; enum element: DOT
  pop d
  mov [d], b
; toktype = DELIMITER;   
  mov d, _toktype ; $toktype
  push d
  mov32 cb, $2 ; enum element: DELIMITER
  pop d
  mov [d], b
  jmp _if181_exit
_if181_exit:
_if180_exit:
_if179_exit:
_if178_exit:
_if177_exit:
_if176_exit:
_if175_exit:
_if174_exit:
_if173_exit:
_if170_exit:
_if167_exit:
_if163_exit:
_if160_exit:
; *t = '\0'; 
  lea d, [bp + -1] ; $t
  mov b, [d]
  mov c, 0
  push b
  mov32 cb, $00000000
  pop d
  mov [d], bl
; if(toktype == TYPE_UNDEF){ 
_if182_cond:
  mov d, _toktype ; $toktype
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $0 ; enum element: TYPE_UNDEF
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if182_exit
_if182_TRUE:
; printf("TOKEN ERROR. Prog: %x\n", (int)(prog-program));  
; --- START FUNCTION CALL
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov d, _program ; $program
  mov b, [d]
  mov c, 0
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  snex b
  swp b
  push b
  mov b, _s77 ; "TOKEN ERROR. Prog: %x\n"
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
; printf("ProgVal: %x", *prog);  
; --- START FUNCTION CALL
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  swp b
  push b
  mov b, _s78 ; "ProgVal: %x"
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
; printf("\n Text after prog: %s\n", prog); 
; --- START FUNCTION CALL
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  swp b
  push b
  mov b, _s79 ; "\n Text after prog: %s\n"
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
; exit(1); 
; --- START FUNCTION CALL
  mov32 cb, $00000001
  swp b
  push b
  call exit
  add sp, 2
; --- END FUNCTION CALL
  jmp _if182_exit
_if182_exit:
  leave
  ret

convert_constant:
  enter 0 ; (push bp; mov bp, sp)
; char *s; 
  sub sp, 2
; char *t; 
  sub sp, 2
; t = token; 
  lea d, [bp + -3] ; $t
  push d
  mov d, _token_data ; $token
  mov b, d
  mov c, 0
  pop d
  mov [d], b
; s = string_const; 
  lea d, [bp + -1] ; $s
  push d
  mov d, _string_const_data ; $string_const
  mov b, d
  mov c, 0
  pop d
  mov [d], b
; if(toktype == CHAR_CONST){ 
_if183_cond:
  mov d, _toktype ; $toktype
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $3 ; enum element: CHAR_CONST
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if183_else
_if183_TRUE:
; t++; 
  lea d, [bp + -3] ; $t
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -3] ; $t
  mov [d], b
  dec b
; if(*t == '\\'){ 
_if184_cond:
  lea d, [bp + -3] ; $t
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $0000005c
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if184_else
_if184_TRUE:
; t++; 
  lea d, [bp + -3] ; $t
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -3] ; $t
  mov [d], b
  dec b
; switch(*t){ 
_switch185_expr:
  lea d, [bp + -3] ; $t
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
_switch185_comparisons:
  cmp bl, $30
  je _switch185_case0
  cmp bl, $61
  je _switch185_case1
  cmp bl, $62
  je _switch185_case2
  cmp bl, $66
  je _switch185_case3
  cmp bl, $6e
  je _switch185_case4
  cmp bl, $72
  je _switch185_case5
  cmp bl, $74
  je _switch185_case6
  cmp bl, $76
  je _switch185_case7
  cmp bl, $5c
  je _switch185_case8
  cmp bl, $27
  je _switch185_case9
  cmp bl, $22
  je _switch185_case10
  jmp _switch185_exit
_switch185_case0:
; *s++ = '\0'; 
  lea d, [bp + -1] ; $s
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -1] ; $s
  mov [d], b
  dec b
  push b
  mov32 cb, $00000000
  pop d
  mov [d], bl
; break; 
  jmp _switch185_exit ; case break
_switch185_case1:
; *s++ = '\a'; 
  lea d, [bp + -1] ; $s
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -1] ; $s
  mov [d], b
  dec b
  push b
  mov32 cb, $00000007
  pop d
  mov [d], bl
; break; 
  jmp _switch185_exit ; case break
_switch185_case2:
; *s++ = '\b'; 
  lea d, [bp + -1] ; $s
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -1] ; $s
  mov [d], b
  dec b
  push b
  mov32 cb, $00000008
  pop d
  mov [d], bl
; break;   
  jmp _switch185_exit ; case break
_switch185_case3:
; *s++ = '\f'; 
  lea d, [bp + -1] ; $s
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -1] ; $s
  mov [d], b
  dec b
  push b
  mov32 cb, $0000000c
  pop d
  mov [d], bl
; break; 
  jmp _switch185_exit ; case break
_switch185_case4:
; *s++ = '\n'; 
  lea d, [bp + -1] ; $s
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -1] ; $s
  mov [d], b
  dec b
  push b
  mov32 cb, $0000000a
  pop d
  mov [d], bl
; break; 
  jmp _switch185_exit ; case break
_switch185_case5:
; *s++ = '\r'; 
  lea d, [bp + -1] ; $s
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -1] ; $s
  mov [d], b
  dec b
  push b
  mov32 cb, $0000000d
  pop d
  mov [d], bl
; break; 
  jmp _switch185_exit ; case break
_switch185_case6:
; *s++ = '\t'; 
  lea d, [bp + -1] ; $s
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -1] ; $s
  mov [d], b
  dec b
  push b
  mov32 cb, $00000009
  pop d
  mov [d], bl
; break; 
  jmp _switch185_exit ; case break
_switch185_case7:
; *s++ = '\v'; 
  lea d, [bp + -1] ; $s
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -1] ; $s
  mov [d], b
  dec b
  push b
  mov32 cb, $0000000b
  pop d
  mov [d], bl
; break; 
  jmp _switch185_exit ; case break
_switch185_case8:
; *s++ = '\\'; 
  lea d, [bp + -1] ; $s
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -1] ; $s
  mov [d], b
  dec b
  push b
  mov32 cb, $0000005c
  pop d
  mov [d], bl
; break; 
  jmp _switch185_exit ; case break
_switch185_case9:
; *s++ = '\''; 
  lea d, [bp + -1] ; $s
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -1] ; $s
  mov [d], b
  dec b
  push b
  mov32 cb, $00000027
  pop d
  mov [d], bl
; break; 
  jmp _switch185_exit ; case break
_switch185_case10:
; *s++ = '\"'; 
  lea d, [bp + -1] ; $s
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -1] ; $s
  mov [d], b
  dec b
  push b
  mov32 cb, $00000022
  pop d
  mov [d], bl
_switch185_exit:
  jmp _if184_exit
_if184_else:
; *s++ = *t; 
  lea d, [bp + -1] ; $s
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -1] ; $s
  mov [d], b
  dec b
  push b
  lea d, [bp + -3] ; $t
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mov [d], bl
_if184_exit:
  jmp _if183_exit
_if183_else:
; if(toktype == STRING_CONST){ 
_if186_cond:
  mov d, _toktype ; $toktype
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $4 ; enum element: STRING_CONST
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if186_exit
_if186_TRUE:
; t++; 
  lea d, [bp + -3] ; $t
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -3] ; $t
  mov [d], b
  dec b
; while(*t != '\"' && *t){ 
_while187_cond:
  lea d, [bp + -3] ; $t
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000022
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + -3] ; $t
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  sand a, b
  pop a
; --- END LOGICAL AND
  cmp b, 0
  je _while187_exit
_while187_block:
; *s++ = *t++; 
  lea d, [bp + -1] ; $s
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -1] ; $s
  mov [d], b
  dec b
  push b
  lea d, [bp + -3] ; $t
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -3] ; $t
  mov [d], b
  dec b
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mov [d], bl
  jmp _while187_cond
_while187_exit:
  jmp _if186_exit
_if186_exit:
_if183_exit:
; *s = '\0'; 
  lea d, [bp + -1] ; $s
  mov b, [d]
  mov c, 0
  push b
  mov32 cb, $00000000
  pop d
  mov [d], bl
  leave
  ret

error:
  enter 0 ; (push bp; mov bp, sp)
; printf("\nError: %s\n", msg); 
; --- START FUNCTION CALL
  lea d, [bp + 5] ; $msg
  mov b, [d]
  mov c, 0
  swp b
  push b
  mov b, _s80 ; "\nError: %s\n"
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
; exit(1); 
; --- START FUNCTION CALL
  mov32 cb, $00000001
  swp b
  push b
  call exit
  add sp, 2
; --- END FUNCTION CALL
  leave
  ret

error_s:
  enter 0 ; (push bp; mov bp, sp)
; printf("\nError: %s %s\n", msg, param); 
; --- START FUNCTION CALL
  lea d, [bp + 7] ; $param
  mov b, [d]
  mov c, 0
  swp b
  push b
  lea d, [bp + 5] ; $msg
  mov b, [d]
  mov c, 0
  swp b
  push b
  mov b, _s81 ; "\nError: %s %s\n"
  swp b
  push b
  call printf
  add sp, 6
; --- END FUNCTION CALL
; exit(1); 
; --- START FUNCTION CALL
  mov32 cb, $00000001
  swp b
  push b
  call exit
  add sp, 2
; --- END FUNCTION CALL
  leave
  ret

push_prog:
  enter 0 ; (push bp; mov bp, sp)
; if(prog_tos == 10) error("Cannot push prog. Stack overflow."); 
_if188_cond:
  mov d, _prog_tos ; $prog_tos
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $0000000a
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if188_exit
_if188_TRUE:
; error("Cannot push prog. Stack overflow."); 
; --- START FUNCTION CALL
  mov b, _s82 ; "Cannot push prog. Stack overflow."
  swp b
  push b
  call error
  add sp, 2
; --- END FUNCTION CALL
  jmp _if188_exit
_if188_exit:
; prog_stack[prog_tos] = prog; 
  mov d, _prog_stack_data ; $prog_stack
  push a
  push d
  mov d, _prog_tos ; $prog_tos
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov d, _prog ; $prog
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
; prog_tos++; 
  mov d, _prog_tos ; $prog_tos
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  mov d, _prog_tos ; $prog_tos
  mov [d], b
  mov b, a
  leave
  ret

pop_prog:
  enter 0 ; (push bp; mov bp, sp)
; if(prog_tos == 0) error("Cannot pop prog. Stack overflow."); 
_if189_cond:
  mov d, _prog_tos ; $prog_tos
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if189_exit
_if189_TRUE:
; error("Cannot pop prog. Stack overflow."); 
; --- START FUNCTION CALL
  mov b, _s83 ; "Cannot pop prog. Stack overflow."
  swp b
  push b
  call error
  add sp, 2
; --- END FUNCTION CALL
  jmp _if189_exit
_if189_exit:
; prog_tos--; 
  mov d, _prog_tos ; $prog_tos
  mov b, [d]
  mov c, 0
  mov a, b
  dec b
  mov d, _prog_tos ; $prog_tos
  mov [d], b
  mov b, a
; prog = prog_stack[prog_tos]; 
  mov d, _prog ; $prog
  push d
  mov d, _prog_stack_data ; $prog_stack
  push a
  push d
  mov d, _prog_tos ; $prog_tos
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
  leave
  ret

search_keyword:
  enter 0 ; (push bp; mov bp, sp)
; int i; 
  sub sp, 2
; for(i = 0; keywords[i].keyword[0]; i++) 
_for190_init:
  lea d, [bp + -1] ; $i
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
_for190_cond:
  mov d, _keywords_data ; $keywords
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 3 ; mov a, 3; mul a, b; add d, b
  pop a
  add d, 0
  push a
  push d
  mov32 cb, $00000000
  pop d
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
  cmp b, 0
  je _for190_exit
_for190_block:
; if (!strcmp(keywords[i].keyword, keyword)) return keywords[i].tok; 
_if191_cond:
; --- START FUNCTION CALL
  lea d, [bp + 5] ; $keyword
  mov b, [d]
  mov c, 0
  swp b
  push b
  mov d, _keywords_data ; $keywords
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 3 ; mov a, 3; mul a, b; add d, b
  pop a
  add d, 0
  mov b, [d]
  mov c, 0
  swp b
  push b
  call strcmp
  add sp, 4
; --- END FUNCTION CALL
  cmp b, 0
  je _if191_exit
_if191_TRUE:
; return keywords[i].tok; 
  mov d, _keywords_data ; $keywords
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 3 ; mov a, 3; mul a, b; add d, b
  pop a
  add d, 2
  mov bl, [d]
  mov bh, 0
  mov c, 0
  leave
  ret
  jmp _if191_exit
_if191_exit:
_for190_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  mov b, a
  jmp _for190_cond
_for190_exit:
; return -1; 
  mov32 cb, $ffffffff
  leave
  ret

hex_to_int:
  enter 0 ; (push bp; mov bp, sp)
; int value = 0; 
  sub sp, 2
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -1] ; $value
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
; --- END LOCAL VAR INITIALIZATION
; int i; 
  sub sp, 2
; char hex_char; 
  sub sp, 1
; int len; 
  sub sp, 2
; len = strlen(hex_string); 
  lea d, [bp + -6] ; $len
  push d
; --- START FUNCTION CALL
  lea d, [bp + 5] ; $hex_string
  mov b, [d]
  mov c, 0
  swp b
  push b
  call strlen
  add sp, 2
; --- END FUNCTION CALL
  pop d
  mov [d], b
; for (i = 0; i < len; i++) { 
_for192_init:
  lea d, [bp + -3] ; $i
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
_for192_cond:
  lea d, [bp + -3] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -6] ; $len
  mov b, [d]
  mov c, 0
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for192_exit
_for192_block:
; hex_char = hex_string[i]; 
  lea d, [bp + -4] ; $hex_char
  push d
  lea d, [bp + 5] ; $hex_string
  mov d, [d]
  push a
  push d
  lea d, [bp + -3] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mov [d], bl
; if (hex_char >= 'a' && hex_char <= 'f')  
_if193_cond:
  lea d, [bp + -4] ; $hex_char
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000061
  cmp a, b
  sge ; >=
  pop a
; --- END RELATIONAL
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + -4] ; $hex_char
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000066
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  cmp b, 0
  je _if193_else
_if193_TRUE:
; value = (value * 16) + (hex_char - 'a' + 10); 
  lea d, [bp + -1] ; $value
  push d
  lea d, [bp + -1] ; $value
  mov b, [d]
  mov c, 0
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $00000010
  push a     ; save left operand
  xor a, b   ; xor sign bits
  swp a      ; swap bytes
  mov cl, al ; save result of xor into 'dl'
  pop a      ; restore left side operator
  push cl    ; save result of xor above
  swp a  
  test al, $80  
  swp a  
  jz skip_invert_a_197  
  neg a 
skip_invert_a_197:   
  swp b
  test bl, $80  
  swp b
  jz skip_invert_b_197  
  neg b 
skip_invert_b_197:   
  mul a, b ; *
  mov g, a
  mov a, b
  pop bl
  test bl, $80
  jz _same_signs_197
  mov bl, al
  not a
  neg b
  adc a, 0
  mov g, a
  mov a, b
_same_signs_197:
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
; --- START TERMS
  push a
  push g
  mov a, b
  mov g, c
  lea d, [bp + -4] ; $hex_char
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000061
  sub a, b
  mov b, a
  mov a, b
  mov32 cb, $0000000a
  add b, a
  pop a
; --- END TERMS
  mov c, 0
  add32 cb, ga
  pop g
  pop a
; --- END TERMS
  pop d
  mov [d], b
  jmp _if193_exit
_if193_else:
; if (hex_char >= 'A' && hex_char <= 'F')  
_if198_cond:
  lea d, [bp + -4] ; $hex_char
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000041
  cmp a, b
  sge ; >=
  pop a
; --- END RELATIONAL
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + -4] ; $hex_char
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000046
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  cmp b, 0
  je _if198_else
_if198_TRUE:
; value = (value * 16) + (hex_char - 'A' + 10); 
  lea d, [bp + -1] ; $value
  push d
  lea d, [bp + -1] ; $value
  mov b, [d]
  mov c, 0
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $00000010
  push a     ; save left operand
  xor a, b   ; xor sign bits
  swp a      ; swap bytes
  mov cl, al ; save result of xor into 'dl'
  pop a      ; restore left side operator
  push cl    ; save result of xor above
  swp a  
  test al, $80  
  swp a  
  jz skip_invert_a_202  
  neg a 
skip_invert_a_202:   
  swp b
  test bl, $80  
  swp b
  jz skip_invert_b_202  
  neg b 
skip_invert_b_202:   
  mul a, b ; *
  mov g, a
  mov a, b
  pop bl
  test bl, $80
  jz _same_signs_202
  mov bl, al
  not a
  neg b
  adc a, 0
  mov g, a
  mov a, b
_same_signs_202:
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
; --- START TERMS
  push a
  push g
  mov a, b
  mov g, c
  lea d, [bp + -4] ; $hex_char
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000041
  sub a, b
  mov b, a
  mov a, b
  mov32 cb, $0000000a
  add b, a
  pop a
; --- END TERMS
  mov c, 0
  add32 cb, ga
  pop g
  pop a
; --- END TERMS
  pop d
  mov [d], b
  jmp _if198_exit
_if198_else:
; value = (value * 16) + (hex_char - '0'); 
  lea d, [bp + -1] ; $value
  push d
  lea d, [bp + -1] ; $value
  mov b, [d]
  mov c, 0
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $00000010
  push a     ; save left operand
  xor a, b   ; xor sign bits
  swp a      ; swap bytes
  mov cl, al ; save result of xor into 'dl'
  pop a      ; restore left side operator
  push cl    ; save result of xor above
  swp a  
  test al, $80  
  swp a  
  jz skip_invert_a_206  
  neg a 
skip_invert_a_206:   
  swp b
  test bl, $80  
  swp b
  jz skip_invert_b_206  
  neg b 
skip_invert_b_206:   
  mul a, b ; *
  mov g, a
  mov a, b
  pop bl
  test bl, $80
  jz _same_signs_206
  mov bl, al
  not a
  neg b
  adc a, 0
  mov g, a
  mov a, b
_same_signs_206:
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
; --- START TERMS
  push a
  push g
  mov a, b
  mov g, c
  lea d, [bp + -4] ; $hex_char
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000030
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  mov c, 0
  add32 cb, ga
  pop g
  pop a
; --- END TERMS
  pop d
  mov [d], b
_if198_exit:
_if193_exit:
_for192_update:
  lea d, [bp + -3] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -3] ; $i
  mov [d], b
  mov b, a
  jmp _for192_cond
_for192_exit:
; return value; 
  lea d, [bp + -1] ; $value
  mov b, [d]
  mov c, 0
  leave
  ret

loadfile:
  enter 0 ; (push bp; mov bp, sp)
; --- BEGIN INLINE ASM SEGMENT
  lea d, [bp + 7] ; $destination
  mov a, [d]
  mov di, a
  lea d, [bp + 5] ; $filename
  mov d, [d]
  mov al, 20
  syscall sys_filesystem
; --- END INLINE ASM SEGMENT
  leave
  ret

_exp:
  enter 0 ; (push bp; mov bp, sp)
; int i; 
  sub sp, 2
; int result = 1; 
  sub sp, 2
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -3] ; $result
  push d
  mov32 cb, $00000001
  pop d
  mov [d], b
; --- END LOCAL VAR INITIALIZATION
; for(i = 0; i < _exp; i++){ 
_for207_init:
  lea d, [bp + -1] ; $i
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
_for207_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  lea d, [bp + 7] ; $_exp
  mov b, [d]
  mov c, 0
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for207_exit
_for207_block:
; result = result * base; 
  lea d, [bp + -3] ; $result
  push d
  lea d, [bp + -3] ; $result
  mov b, [d]
  mov c, 0
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  lea d, [bp + 5] ; $base
  mov b, [d]
  mov c, 0
  push a     ; save left operand
  xor a, b   ; xor sign bits
  swp a      ; swap bytes
  mov cl, al ; save result of xor into 'dl'
  pop a      ; restore left side operator
  push cl    ; save result of xor above
  swp a  
  test al, $80  
  swp a  
  jz skip_invert_a_209  
  neg a 
skip_invert_a_209:   
  swp b
  test bl, $80  
  swp b
  jz skip_invert_b_209  
  neg b 
skip_invert_b_209:   
  mul a, b ; *
  mov g, a
  mov a, b
  pop bl
  test bl, $80
  jz _same_signs_209
  mov bl, al
  not a
  neg b
  adc a, 0
  mov g, a
  mov a, b
_same_signs_209:
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  pop d
  mov [d], b
_for207_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  mov b, a
  jmp _for207_cond
_for207_exit:
; return result; 
  lea d, [bp + -3] ; $result
  mov b, [d]
  mov c, 0
  leave
  ret

printf:
  enter 0 ; (push bp; mov bp, sp)
; char *p, *format_p; 
  sub sp, 2
  sub sp, 2
; format_p = format; 
  lea d, [bp + -3] ; $format_p
  push d
  lea d, [bp + 5] ; $format
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
; p = &format + 2; 
  lea d, [bp + -1] ; $p
  push d
  lea d, [bp + 5] ; $format
  mov b, d
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000002
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; for(;;){ 
_for210_init:
_for210_cond:
_for210_block:
; if(!*format_p) break; 
_if211_cond:
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  cmp b, 0
  seq ; !
  cmp b, 0
  je _if211_else
_if211_TRUE:
; break; 
  jmp _for210_exit ; for break
  jmp _if211_exit
_if211_else:
; if(*format_p == '%'){ 
_if212_cond:
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000025
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if212_else
_if212_TRUE:
; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  dec b
; switch(*format_p){ 
_switch213_expr:
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
_switch213_comparisons:
  cmp bl, $6c
  je _switch213_case0
  cmp bl, $4c
  je _switch213_case1
  cmp bl, $64
  je _switch213_case2
  cmp bl, $69
  je _switch213_case3
  cmp bl, $75
  je _switch213_case4
  cmp bl, $78
  je _switch213_case5
  cmp bl, $63
  je _switch213_case6
  cmp bl, $73
  je _switch213_case7
  jmp _switch213_default
  jmp _switch213_exit
_switch213_case0:
_switch213_case1:
; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  dec b
; if(*format_p == 'd' || *format_p == 'i') 
_if214_cond:
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000064
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
; --- START LOGICAL OR
  push a
  mov a, b
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000069
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  cmp b, 0
  je _if214_else
_if214_TRUE:
; print_signed_long(*(long int*)p); 
; --- START FUNCTION CALL
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov c, 0
  mov d, b
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
  mov a, c
  swp a
  push a
  swp b
  push b
  call print_signed_long
  add sp, 4
; --- END FUNCTION CALL
  jmp _if214_exit
_if214_else:
; if(*format_p == 'u') 
_if215_cond:
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000075
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if215_else
_if215_TRUE:
; print_unsigned_long(*(unsigned long int*)p); 
; --- START FUNCTION CALL
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov c, 0
  mov d, b
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
  mov a, c
  swp a
  push a
  swp b
  push b
  call print_unsigned_long
  add sp, 4
; --- END FUNCTION CALL
  jmp _if215_exit
_if215_else:
; if(*format_p == 'x') 
_if216_cond:
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000078
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if216_else
_if216_TRUE:
; printx32(*(long int *)p); 
; --- START FUNCTION CALL
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov c, 0
  mov d, b
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
  mov a, c
  swp a
  push a
  swp b
  push b
  call printx32
  add sp, 4
; --- END FUNCTION CALL
  jmp _if216_exit
_if216_else:
; err("Unexpected format in printf."); 
; --- START FUNCTION CALL
  mov b, _s84 ; "Unexpected format in printf."
  swp b
  push b
  call err
  add sp, 2
; --- END FUNCTION CALL
_if216_exit:
_if215_exit:
_if214_exit:
; p = p + 4; 
  lea d, [bp + -1] ; $p
  push d
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000004
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; break; 
  jmp _switch213_exit ; case break
_switch213_case2:
_switch213_case3:
; print_signed(*(int*)p); 
; --- START FUNCTION CALL
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov c, 0
  mov d, b
  mov b, [d]
  mov c, 0
  swp b
  push b
  call print_signed
  add sp, 2
; --- END FUNCTION CALL
; p = p + 2; 
  lea d, [bp + -1] ; $p
  push d
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000002
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; break; 
  jmp _switch213_exit ; case break
_switch213_case4:
; print_unsigned(*(unsigned int*)p); 
; --- START FUNCTION CALL
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov c, 0
  mov d, b
  mov b, [d]
  mov c, 0
  swp b
  push b
  call print_unsigned
  add sp, 2
; --- END FUNCTION CALL
; p = p + 2; 
  lea d, [bp + -1] ; $p
  push d
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000002
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; break; 
  jmp _switch213_exit ; case break
_switch213_case5:
; printx16(*(int*)p); 
; --- START FUNCTION CALL
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov c, 0
  mov d, b
  mov b, [d]
  mov c, 0
  swp b
  push b
  call printx16
  add sp, 2
; --- END FUNCTION CALL
; p = p + 2; 
  lea d, [bp + -1] ; $p
  push d
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000002
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; break; 
  jmp _switch213_exit ; case break
_switch213_case6:
; putchar(*(char*)p); 
; --- START FUNCTION CALL
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push bl
  call putchar
  add sp, 1
; --- END FUNCTION CALL
; p = p + 2; 
  lea d, [bp + -1] ; $p
  push d
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000002
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; break; 
  jmp _switch213_exit ; case break
_switch213_case7:
; print(*(char**)p); 
; --- START FUNCTION CALL
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov c, 0
  mov d, b
  mov b, [d]
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; p = p + 2; 
  lea d, [bp + -1] ; $p
  push d
  lea d, [bp + -1] ; $p
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000002
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; break; 
  jmp _switch213_exit ; case break
_switch213_default:
; print("Error: Unknown argument type.\n"); 
; --- START FUNCTION CALL
  mov b, _s85 ; "Error: Unknown argument type.\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
_switch213_exit:
  jmp _if212_exit
_if212_else:
; putchar(*format_p); 
; --- START FUNCTION CALL
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push bl
  call putchar
  add sp, 1
; --- END FUNCTION CALL
_if212_exit:
_if211_exit:
; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  dec b
_for210_update:
  jmp _for210_cond
_for210_exit:
  leave
  ret

print_signed_long:
  enter 0 ; (push bp; mov bp, sp)
; char digits[10];  // fits 2,147,483,647 
  sub sp, 10
; int i = 0; 
  sub sp, 2
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -11] ; $i
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
; --- END LOCAL VAR INITIALIZATION
; unsigned long int absval; 
  sub sp, 4
; if (num < 0) { 
_if217_cond:
  lea d, [bp + 5] ; $num
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; --- START RELATIONAL
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $00000000
  mov c, 0
  cmp32 ga, cb
  slt ; <
  pop g
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if217_else
_if217_TRUE:
; putchar('-'); 
; --- START FUNCTION CALL
  mov32 cb, $0000002d
  push bl
  call putchar
  add sp, 1
; --- END FUNCTION CALL
; absval = (unsigned long int)(-(num + 1)) + 1; 
  lea d, [bp + -15] ; $absval
  push d
  lea d, [bp + 5] ; $num
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; --- START TERMS
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $00000001
  mov c, 0
  add32 cb, ga
  pop g
  pop a
; --- END TERMS
  mov a, c
  not a
  not b
  add b, 1
  adc a, 0
  mov c, a
  mov bh, 0
  mov c, 0
; --- START TERMS
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $00000001
  mov c, 0
  add32 cb, ga
  pop g
  pop a
; --- END TERMS
  pop d
  mov [d], b
  mov b, c
  mov [d + 2], b
  jmp _if217_exit
_if217_else:
; absval = (unsigned long int)num; 
  lea d, [bp + -15] ; $absval
  push d
  lea d, [bp + 5] ; $num
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
  mov bh, 0
  mov c, 0
  pop d
  mov [d], b
  mov b, c
  mov [d + 2], b
_if217_exit:
; if (absval == 0) { 
_if218_cond:
  lea d, [bp + -15] ; $absval
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; --- START RELATIONAL
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $00000000
  mov c, 0
  cmp32 ga, cb
  seq ; ==
  pop g
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if218_exit
_if218_TRUE:
; putchar('0'); 
; --- START FUNCTION CALL
  mov32 cb, $00000030
  push bl
  call putchar
  add sp, 1
; --- END FUNCTION CALL
; return; 
  leave
  ret
  jmp _if218_exit
_if218_exit:
; while (absval > 0) { 
_while219_cond:
  lea d, [bp + -15] ; $absval
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; --- START RELATIONAL
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $00000000
  mov c, 0
  cmp32 ga, cb
  sgu
  pop g
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _while219_exit
_while219_block:
; digits[i++] = '0' + (absval % 10); 
  lea d, [bp + -9] ; $digits
  push a
  push d
  lea d, [bp + -11] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -11] ; $i
  mov [d], b
  mov b, a
  pop d
  add d, b
  pop a
  push d
  mov32 cb, $00000030
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -15] ; $absval
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $0000000a
  push g ; save 'g' as the div instruction uses it
  div a, b ; %, a: quotient, b: remainder
  mov a, b
  pop g
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  mov g, 0
  add32 cb, ga
  pop a
; --- END TERMS
  pop d
  mov [d], bl
; absval = absval / 10; 
  lea d, [bp + -15] ; $absval
  push d
  lea d, [bp + -15] ; $absval
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $0000000a
  push g ; save 'g' as the div instruction uses it
  div a, b ; /, a: quotient, b: remainder
  pop g
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  pop d
  mov [d], b
  mov b, c
  mov [d + 2], b
  jmp _while219_cond
_while219_exit:
; while (i > 0) { 
_while226_cond:
  lea d, [bp + -11] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  sgt ; >
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _while226_exit
_while226_block:
; putchar(digits[--i]); 
; --- START FUNCTION CALL
  lea d, [bp + -9] ; $digits
  push a
  push d
  lea d, [bp + -11] ; $i
  mov b, [d]
  dec b
  lea d, [bp + -11] ; $i
  mov [d], b
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push bl
  call putchar
  add sp, 1
; --- END FUNCTION CALL
  jmp _while226_cond
_while226_exit:
  leave
  ret

putchar:
  enter 0 ; (push bp; mov bp, sp)
; --- BEGIN INLINE ASM SEGMENT
  lea d, [bp + 5] ; $c
  mov al, [d]
  mov ah, al
  mov al, 0
  syscall sys_io      ; char in AH
; --- END INLINE ASM SEGMENT
  leave
  ret

print_unsigned_long:
  enter 0 ; (push bp; mov bp, sp)
; char digits[10]; 
  sub sp, 10
; int i = 0; 
  sub sp, 2
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -11] ; $i
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
; --- END LOCAL VAR INITIALIZATION
; if(num == 0){ 
_if227_cond:
  lea d, [bp + 5] ; $num
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; --- START RELATIONAL
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $00000000
  mov c, 0
  cmp32 ga, cb
  seq ; ==
  pop g
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if227_exit
_if227_TRUE:
; putchar('0'); 
; --- START FUNCTION CALL
  mov32 cb, $00000030
  push bl
  call putchar
  add sp, 1
; --- END FUNCTION CALL
; return; 
  leave
  ret
  jmp _if227_exit
_if227_exit:
; while (num > 0) { 
_while228_cond:
  lea d, [bp + 5] ; $num
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; --- START RELATIONAL
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $00000000
  mov c, 0
  cmp32 ga, cb
  sgu
  pop g
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _while228_exit
_while228_block:
; digits[i++] = '0' + (num % 10); 
  lea d, [bp + -9] ; $digits
  push a
  push d
  lea d, [bp + -11] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -11] ; $i
  mov [d], b
  mov b, a
  pop d
  add d, b
  pop a
  push d
  mov32 cb, $00000030
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + 5] ; $num
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $0000000a
  push g ; save 'g' as the div instruction uses it
  div a, b ; %, a: quotient, b: remainder
  mov a, b
  pop g
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  mov g, 0
  add32 cb, ga
  pop a
; --- END TERMS
  pop d
  mov [d], bl
; num = num / 10; 
  lea d, [bp + 5] ; $num
  push d
  lea d, [bp + 5] ; $num
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $0000000a
  push g ; save 'g' as the div instruction uses it
  div a, b ; /, a: quotient, b: remainder
  pop g
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  pop d
  mov [d], b
  mov b, c
  mov [d + 2], b
  jmp _while228_cond
_while228_exit:
; while (i > 0) { 
_while235_cond:
  lea d, [bp + -11] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  sgt ; >
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _while235_exit
_while235_block:
; putchar(digits[--i]); 
; --- START FUNCTION CALL
  lea d, [bp + -9] ; $digits
  push a
  push d
  lea d, [bp + -11] ; $i
  mov b, [d]
  dec b
  lea d, [bp + -11] ; $i
  mov [d], b
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push bl
  call putchar
  add sp, 1
; --- END FUNCTION CALL
  jmp _while235_cond
_while235_exit:
  leave
  ret

printx32:
  enter 0 ; (push bp; mov bp, sp)
; --- BEGIN INLINE ASM SEGMENT
  lea d, [bp + 5] ; $hex
  mov b, [d+2]
  call print_u16x_printx32
  mov b, [d]
  call print_u16x_printx32
; --- END INLINE ASM SEGMENT
; return; 
  leave
  ret
; --- BEGIN INLINE ASM SEGMENT
print_u16x_printx32:
  push a
  push b
  push bl
  mov bl, bh
  call _itoa_printx32        ; convert bh to char in A
  mov bl, al        ; save al
  mov al, 0
  syscall sys_io        ; display AH
  mov ah, bl        ; retrieve al
  mov al, 0
  syscall sys_io        ; display AL
  pop bl
  call _itoa_printx32        ; convert bh to char in A
  mov bl, al        ; save al
  mov al, 0
  syscall sys_io        ; display AH
  mov ah, bl        ; retrieve al
  mov al, 0
  syscall sys_io        ; display AL
  pop b
  pop a
  ret
_itoa_printx32:
  push d
  push b
  mov bh, 0
  shr bl, 4  
  mov d, b
  mov al, [d + s_hex_digits_printx32]
  mov ah, al
  pop b
  push b
  mov bh, 0
  and bl, $0F
  mov d, b
  mov al, [d + s_hex_digits_printx32]
  pop b
  pop d
  ret
s_hex_digits_printx32: .db "0123456789ABCDEF"  
; --- END INLINE ASM SEGMENT
  leave
  ret

err:
  enter 0 ; (push bp; mov bp, sp)
; print(e); 
; --- START FUNCTION CALL
  lea d, [bp + 5] ; $e
  mov b, [d]
  mov c, 0
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
  leave
  ret

print:
  enter 0 ; (push bp; mov bp, sp)
; --- BEGIN INLINE ASM SEGMENT
  lea d, [bp + 5] ; $s
  mov d, [d]
_puts_L1_print:
  mov al, [d]
  cmp al, 0
  jz _puts_END_print
  mov ah, al
  mov al, 0
  syscall sys_io
  inc d
  jmp _puts_L1_print
_puts_END_print:
; --- END INLINE ASM SEGMENT
  leave
  ret

print_signed:
  enter 0 ; (push bp; mov bp, sp)
; char digits[5];  // enough for "-32768" 
  sub sp, 5
; int i = 0; 
  sub sp, 2
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -6] ; $i
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
; --- END LOCAL VAR INITIALIZATION
; unsigned int absval; 
  sub sp, 2
; if (num < 0) { 
_if236_cond:
  lea d, [bp + 5] ; $num
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if236_else
_if236_TRUE:
; putchar('-'); 
; --- START FUNCTION CALL
  mov32 cb, $0000002d
  push bl
  call putchar
  add sp, 1
; --- END FUNCTION CALL
; absval = (unsigned int)(-(num + 1)) + 1;  // safe for -32768 
  lea d, [bp + -8] ; $absval
  push d
  lea d, [bp + 5] ; $num
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000001
  add b, a
  pop a
; --- END TERMS
  neg b
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000001
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
  jmp _if236_exit
_if236_else:
; absval = (unsigned int)num; 
  lea d, [bp + -8] ; $absval
  push d
  lea d, [bp + 5] ; $num
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
_if236_exit:
; if (absval == 0) { 
_if237_cond:
  lea d, [bp + -8] ; $absval
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if237_exit
_if237_TRUE:
; putchar('0'); 
; --- START FUNCTION CALL
  mov32 cb, $00000030
  push bl
  call putchar
  add sp, 1
; --- END FUNCTION CALL
; return; 
  leave
  ret
  jmp _if237_exit
_if237_exit:
; while (absval > 0) { 
_while238_cond:
  lea d, [bp + -8] ; $absval
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  sgu ; > (unsigned)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _while238_exit
_while238_block:
; digits[i++] = '0' + (absval % 10); 
  lea d, [bp + -4] ; $digits
  push a
  push d
  lea d, [bp + -6] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -6] ; $i
  mov [d], b
  mov b, a
  pop d
  add d, b
  pop a
  push d
  mov32 cb, $00000030
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -8] ; $absval
  mov b, [d]
  mov c, 0
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $0000000a
  push g ; save 'g' as the div instruction uses it
  div a, b ; %, a: quotient, b: remainder
  mov a, b
  pop g
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], bl
; absval = absval / 10; 
  lea d, [bp + -8] ; $absval
  push d
  lea d, [bp + -8] ; $absval
  mov b, [d]
  mov c, 0
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $0000000a
  push g ; save 'g' as the div instruction uses it
  div a, b ; /, a: quotient, b: remainder
  pop g
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  pop d
  mov [d], b
  jmp _while238_cond
_while238_exit:
; while (i > 0) { 
_while245_cond:
  lea d, [bp + -6] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  sgt ; >
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _while245_exit
_while245_block:
; putchar(digits[--i]); 
; --- START FUNCTION CALL
  lea d, [bp + -4] ; $digits
  push a
  push d
  lea d, [bp + -6] ; $i
  mov b, [d]
  dec b
  lea d, [bp + -6] ; $i
  mov [d], b
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push bl
  call putchar
  add sp, 1
; --- END FUNCTION CALL
  jmp _while245_cond
_while245_exit:
  leave
  ret

print_unsigned:
  enter 0 ; (push bp; mov bp, sp)
; char digits[5]; 
  sub sp, 5
; int i = 0; 
  sub sp, 2
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -6] ; $i
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
; --- END LOCAL VAR INITIALIZATION
; if(num == 0){ 
_if246_cond:
  lea d, [bp + 5] ; $num
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if246_exit
_if246_TRUE:
; putchar('0'); 
; --- START FUNCTION CALL
  mov32 cb, $00000030
  push bl
  call putchar
  add sp, 1
; --- END FUNCTION CALL
; return; 
  leave
  ret
  jmp _if246_exit
_if246_exit:
; while (num > 0) { 
_while247_cond:
  lea d, [bp + 5] ; $num
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  sgu ; > (unsigned)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _while247_exit
_while247_block:
; digits[i++] = '0' + (num % 10); 
  lea d, [bp + -4] ; $digits
  push a
  push d
  lea d, [bp + -6] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -6] ; $i
  mov [d], b
  mov b, a
  pop d
  add d, b
  pop a
  push d
  mov32 cb, $00000030
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + 5] ; $num
  mov b, [d]
  mov c, 0
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $0000000a
  push g ; save 'g' as the div instruction uses it
  div a, b ; %, a: quotient, b: remainder
  mov a, b
  pop g
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], bl
; num = num / 10; 
  lea d, [bp + 5] ; $num
  push d
  lea d, [bp + 5] ; $num
  mov b, [d]
  mov c, 0
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $0000000a
  push g ; save 'g' as the div instruction uses it
  div a, b ; /, a: quotient, b: remainder
  pop g
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  pop d
  mov [d], b
  jmp _while247_cond
_while247_exit:
; while (i > 0) { 
_while254_cond:
  lea d, [bp + -6] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  sgt ; >
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _while254_exit
_while254_block:
; putchar(digits[--i]); 
; --- START FUNCTION CALL
  lea d, [bp + -4] ; $digits
  push a
  push d
  lea d, [bp + -6] ; $i
  mov b, [d]
  dec b
  lea d, [bp + -6] ; $i
  mov [d], b
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push bl
  call putchar
  add sp, 1
; --- END FUNCTION CALL
  jmp _while254_cond
_while254_exit:
  leave
  ret

printx16:
  enter 0 ; (push bp; mov bp, sp)
; --- BEGIN INLINE ASM SEGMENT
  lea d, [bp + 5] ; $hex
  mov b, [d]
print_u16x_printx16:
  push bl
  mov bl, bh
  call _itoa_printx16        ; convert bh to char in A
  mov bl, al        ; save al
  mov al, 0
  syscall sys_io        ; display AH
  mov ah, bl        ; retrieve al
  mov al, 0
  syscall sys_io        ; display AL
  pop bl
  call _itoa_printx16        ; convert bh to char in A
  mov bl, al        ; save al
  mov al, 0
  syscall sys_io        ; display AH
  mov ah, bl        ; retrieve al
  mov al, 0
  syscall sys_io        ; display AL
; --- END INLINE ASM SEGMENT
; return; 
  leave
  ret
; --- BEGIN INLINE ASM SEGMENT
_itoa_printx16:
  push d
  push b
  mov bh, 0
  shr bl, 4  
  mov d, b
  mov al, [d + s_hex_digits_printx16]
  mov ah, al
  pop b
  push b
  mov bh, 0
  and bl, $0F
  mov d, b
  mov al, [d + s_hex_digits_printx16]
  pop b
  pop d
  ret
s_hex_digits_printx16:    .db "0123456789ABCDEF"  
; --- END INLINE ASM SEGMENT
  leave
  ret

alloc:
  enter 0 ; (push bp; mov bp, sp)
; block_t **b = &free_list; 
  sub sp, 2
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -1] ; $b
  push d
  mov d, _free_list ; $free_list
  mov b, d
  pop d
  mov si, b
  mov di, d
  mov c, 2
  rep movsb
; --- END LOCAL VAR INITIALIZATION
; block_t *prev = 0; 
  sub sp, 2
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -3] ; $prev
  push d
  mov32 cb, $00000000
  pop d
  mov si, b
  mov di, d
  mov c, 2
  rep movsb
; --- END LOCAL VAR INITIALIZATION
; block_t *pp; 
  sub sp, 2
; block_t *blk = *b; 
  sub sp, 2
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -7] ; $blk
  push d
  lea d, [bp + -1] ; $b
  mov b, [d]
  mov c, 0
  mov d, b
  mov b, [d]
  pop d
  mov si, b
  mov di, d
  mov c, 2
  rep movsb
; --- END LOCAL VAR INITIALIZATION
; if (size & 1) size++; 
_if255_cond:
  lea d, [bp + 5] ; $size
  mov b, [d]
  mov c, 0
  push a
  mov a, b
  mov32 cb, $00000001
  and b, a ; &
  pop a
  cmp b, 0
  je _if255_exit
_if255_TRUE:
; size++; 
  lea d, [bp + 5] ; $size
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + 5] ; $size
  mov [d], b
  mov b, a
  jmp _if255_exit
_if255_exit:
; while (*b) { 
_while256_cond:
  lea d, [bp + -1] ; $b
  mov b, [d]
  mov c, 0
  mov d, b
  mov b, [d]
  cmp b, 0
  je _while256_exit
_while256_block:
; pp = *b; 
  lea d, [bp + -5] ; $pp
  push d
  lea d, [bp + -1] ; $b
  mov b, [d]
  mov c, 0
  mov d, b
  mov b, [d]
  pop d
  mov [d], b
; if (pp->size >= size) { 
_if257_cond:
  lea d, [bp + -5] ; $pp
  mov d, [d]
  add d, 0
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  lea d, [bp + 5] ; $size
  mov b, [d]
  mov c, 0
  cmp a, b
  sgeu ; >= (unsigned)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if257_exit
_if257_TRUE:
; if (prev) 
_if258_cond:
  lea d, [bp + -3] ; $prev
  mov b, [d]
  mov c, 0
  cmp b, 0
  je _if258_else
_if258_TRUE:
; prev->next = blk->next; 
  lea d, [bp + -3] ; $prev
  mov d, [d]
  add d, 2
  push d
  lea d, [bp + -7] ; $blk
  mov d, [d]
  add d, 2
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
  jmp _if258_exit
_if258_else:
; free_list = blk->next; 
  mov d, _free_list ; $free_list
  push d
  lea d, [bp + -7] ; $blk
  mov d, [d]
  add d, 2
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
_if258_exit:
; return (void*)(blk + 1); 
  lea d, [bp + -7] ; $blk
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000001
  add b, a
  pop a
; --- END TERMS
  leave
  ret
  jmp _if257_exit
_if257_exit:
; prev = *b; 
  lea d, [bp + -3] ; $prev
  push d
  lea d, [bp + -1] ; $b
  mov b, [d]
  mov c, 0
  mov d, b
  mov b, [d]
  pop d
  mov [d], b
; b = &pp->next; 
  lea d, [bp + -1] ; $b
  push d
  lea d, [bp + -5] ; $pp
  mov d, [d]
  add d, 2
  mov b, d
  pop d
  mov [d], b
  jmp _while256_cond
_while256_exit:
; if (heap_top + sizeof(struct block) + size > heap +  16000         ) 
_if259_cond:
  mov d, _heap_top ; $heap_top
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, 4
  add b, a
  mov a, b
  lea d, [bp + 5] ; $size
  mov b, [d]
  mov c, 0
  add b, a
  pop a
; --- END TERMS
; --- START RELATIONAL
  push a
  mov a, b
  mov d, _heap ; $heap
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00003e80
  add b, a
  pop a
; --- END TERMS
  cmp a, b
  sgu ; > (unsigned)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if259_exit
_if259_TRUE:
; return 0; // out of memory 
  mov32 cb, $00000000
  leave
  ret
  jmp _if259_exit
_if259_exit:
; blk = heap_top; 
  lea d, [bp + -7] ; $blk
  push d
  mov d, _heap_top ; $heap_top
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
; blk->size = size; 
  lea d, [bp + -7] ; $blk
  mov d, [d]
  add d, 0
  push d
  lea d, [bp + 5] ; $size
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
; heap_top = heap_top + sizeof(struct block) + size; 
  mov d, _heap_top ; $heap_top
  push d
  mov d, _heap_top ; $heap_top
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, 4
  add b, a
  mov a, b
  lea d, [bp + 5] ; $size
  mov b, [d]
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; return (void*)(blk + 1); 
  lea d, [bp + -7] ; $blk
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000001
  add b, a
  pop a
; --- END TERMS
  leave
  ret

is_space:
  enter 0 ; (push bp; mov bp, sp)
; return c == ' ' || c == '\t' || c == '\n' || c == '\r'; 
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000020
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
; --- START LOGICAL OR
  push a
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000009
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $0000000a
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $0000000d
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  leave
  ret

is_alpha:
  enter 0 ; (push bp; mov bp, sp)
; return(c >= 'a' && c <= 'z' || c >= 'A' && c <= 'Z' || c == '_'); 
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000061
  cmp a, b
  sge ; >=
  pop a
; --- END RELATIONAL
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $0000007a
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
; --- START LOGICAL OR
  push a
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000041
  cmp a, b
  sge ; >=
  pop a
; --- END RELATIONAL
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $0000005a
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  sor a, b ; ||
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $0000005f
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  leave
  ret

is_digit:
  enter 0 ; (push bp; mov bp, sp)
; return c >= '0' && c <= '9'; 
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000030
  cmp a, b
  sge ; >=
  pop a
; --- END RELATIONAL
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000039
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  leave
  ret

strcmp:
  enter 0 ; (push bp; mov bp, sp)
; while (*s1 && (*s1 == *s2)) { 
_while260_cond:
  lea d, [bp + 5] ; $s1
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + 5] ; $s1
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  lea d, [bp + 7] ; $s2
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  cmp b, 0
  je _while260_exit
_while260_block:
; s1++; 
  lea d, [bp + 5] ; $s1
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + 5] ; $s1
  mov [d], b
  dec b
; s2++; 
  lea d, [bp + 7] ; $s2
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + 7] ; $s2
  mov [d], b
  dec b
  jmp _while260_cond
_while260_exit:
; return *s1 - *s2; 
  lea d, [bp + 5] ; $s1
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + 7] ; $s2
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  leave
  ret

strlen:
  enter 0 ; (push bp; mov bp, sp)
; int length; 
  sub sp, 2
; length = 0; 
  lea d, [bp + -1] ; $length
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
; while (str[length] != 0) { 
_while261_cond:
  lea d, [bp + 5] ; $str
  mov d, [d]
  push a
  push d
  lea d, [bp + -1] ; $length
  mov b, [d]
  mov c, 0
  pop d
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _while261_exit
_while261_block:
; length++; 
  lea d, [bp + -1] ; $length
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -1] ; $length
  mov [d], b
  mov b, a
  jmp _while261_cond
_while261_exit:
; return length; 
  lea d, [bp + -1] ; $length
  mov b, [d]
  mov c, 0
  leave
  ret

atoi:
  enter 0 ; (push bp; mov bp, sp)
; int result = 0;  // Initialize result 
  sub sp, 2
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -1] ; $result
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
; --- END LOCAL VAR INITIALIZATION
; int sign = 1;    // Initialize sign as positive 
  sub sp, 2
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -3] ; $sign
  push d
  mov32 cb, $00000001
  pop d
  mov [d], b
; --- END LOCAL VAR INITIALIZATION
; while (*str == ' ') str++; 
_while262_cond:
  lea d, [bp + 5] ; $str
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000020
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _while262_exit
_while262_block:
; str++; 
  lea d, [bp + 5] ; $str
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + 5] ; $str
  mov [d], b
  dec b
  jmp _while262_cond
_while262_exit:
; if (*str == '-' || *str == '+') { 
_if263_cond:
  lea d, [bp + 5] ; $str
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $0000002d
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
; --- START LOGICAL OR
  push a
  mov a, b
  lea d, [bp + 5] ; $str
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $0000002b
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  cmp b, 0
  je _if263_exit
_if263_TRUE:
; if (*str == '-') sign = -1; 
_if264_cond:
  lea d, [bp + 5] ; $str
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $0000002d
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if264_exit
_if264_TRUE:
; sign = -1; 
  lea d, [bp + -3] ; $sign
  push d
  mov32 cb, $ffffffff
  pop d
  mov [d], b
  jmp _if264_exit
_if264_exit:
; str++; 
  lea d, [bp + 5] ; $str
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + 5] ; $str
  mov [d], b
  dec b
  jmp _if263_exit
_if263_exit:
; while (*str >= '0' && *str <= '9') { 
_while265_cond:
  lea d, [bp + 5] ; $str
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000030
  cmp a, b
  sgeu ; >= (unsigned)
  pop a
; --- END RELATIONAL
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + 5] ; $str
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000039
  cmp a, b
  sleu ; <= (unsigned)
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  cmp b, 0
  je _while265_exit
_while265_block:
; result = result * 10 + (*str - '0'); 
  lea d, [bp + -1] ; $result
  push d
  lea d, [bp + -1] ; $result
  mov b, [d]
  mov c, 0
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $0000000a
  push a     ; save left operand
  xor a, b   ; xor sign bits
  swp a      ; swap bytes
  mov cl, al ; save result of xor into 'dl'
  pop a      ; restore left side operator
  push cl    ; save result of xor above
  swp a  
  test al, $80  
  swp a  
  jz skip_invert_a_267  
  neg a 
skip_invert_a_267:   
  swp b
  test bl, $80  
  swp b
  jz skip_invert_b_267  
  neg b 
skip_invert_b_267:   
  mul a, b ; *
  mov g, a
  mov a, b
  pop bl
  test bl, $80
  jz _same_signs_267
  mov bl, al
  not a
  neg b
  adc a, 0
  mov g, a
  mov a, b
_same_signs_267:
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
; --- START TERMS
  push a
  push g
  mov a, b
  mov g, c
  lea d, [bp + 5] ; $str
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000030
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  add b, a
  pop g
  pop a
; --- END TERMS
  pop d
  mov [d], b
; str++; 
  lea d, [bp + 5] ; $str
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + 5] ; $str
  mov [d], b
  dec b
  jmp _while265_cond
_while265_exit:
; return sign * result; 
  lea d, [bp + -3] ; $sign
  mov b, [d]
  mov c, 0
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  lea d, [bp + -1] ; $result
  mov b, [d]
  mov c, 0
  push a     ; save left operand
  xor a, b   ; xor sign bits
  swp a      ; swap bytes
  mov cl, al ; save result of xor into 'dl'
  pop a      ; restore left side operator
  push cl    ; save result of xor above
  swp a  
  test al, $80  
  swp a  
  jz skip_invert_a_269  
  neg a 
skip_invert_a_269:   
  swp b
  test bl, $80  
  swp b
  jz skip_invert_b_269  
  neg b 
skip_invert_b_269:   
  mul a, b ; *
  mov g, a
  mov a, b
  pop bl
  test bl, $80
  jz _same_signs_269
  mov bl, al
  not a
  neg b
  adc a, 0
  mov g, a
  mov a, b
_same_signs_269:
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  leave
  ret

exit:
  enter 0 ; (push bp; mov bp, sp)
; --- BEGIN INLINE ASM SEGMENT
  lea d, [bp + 5] ; $status
  mov b, [d] ; return value
  syscall sys_terminate_proc
; --- END INLINE ASM SEGMENT
  leave
  ret

strcpy:
  enter 0 ; (push bp; mov bp, sp)
; char *psrc; 
  sub sp, 2
; char *pdest; 
  sub sp, 2
; psrc = src; 
  lea d, [bp + -1] ; $psrc
  push d
  lea d, [bp + 7] ; $src
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
; pdest = dest; 
  lea d, [bp + -3] ; $pdest
  push d
  lea d, [bp + 5] ; $dest
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
; while(*psrc) *pdest++ = *psrc++; 
_while270_cond:
  lea d, [bp + -1] ; $psrc
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  cmp b, 0
  je _while270_exit
_while270_block:
; *pdest++ = *psrc++; 
  lea d, [bp + -3] ; $pdest
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -3] ; $pdest
  mov [d], b
  dec b
  push b
  lea d, [bp + -1] ; $psrc
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -1] ; $psrc
  mov [d], b
  dec b
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mov [d], bl
  jmp _while270_cond
_while270_exit:
; *pdest = '\0'; 
  lea d, [bp + -3] ; $pdest
  mov b, [d]
  mov c, 0
  push b
  mov32 cb, $00000000
  pop d
  mov [d], bl
  leave
  ret

strcat:
  enter 0 ; (push bp; mov bp, sp)
; int dest_len; 
  sub sp, 2
; int i; 
  sub sp, 2
; dest_len = strlen(dest); 
  lea d, [bp + -1] ; $dest_len
  push d
; --- START FUNCTION CALL
  lea d, [bp + 5] ; $dest
  mov b, [d]
  mov c, 0
  swp b
  push b
  call strlen
  add sp, 2
; --- END FUNCTION CALL
  pop d
  mov [d], b
; for (i = 0; src[i] != 0; i=i+1) { 
_for271_init:
  lea d, [bp + -3] ; $i
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
_for271_cond:
  lea d, [bp + 7] ; $src
  mov d, [d]
  push a
  push d
  lea d, [bp + -3] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for271_exit
_for271_block:
; dest[dest_len + i] = src[i]; 
  lea d, [bp + 5] ; $dest
  mov d, [d]
  push a
  push d
  lea d, [bp + -1] ; $dest_len
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -3] ; $i
  mov b, [d]
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  pop d
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  push d
  lea d, [bp + 7] ; $src
  mov d, [d]
  push a
  push d
  lea d, [bp + -3] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mov [d], bl
_for271_update:
  lea d, [bp + -3] ; $i
  push d
  lea d, [bp + -3] ; $i
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000001
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
  jmp _for271_cond
_for271_exit:
; dest[dest_len + i] = 0; 
  lea d, [bp + 5] ; $dest
  mov d, [d]
  push a
  push d
  lea d, [bp + -1] ; $dest_len
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -3] ; $i
  mov b, [d]
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  pop d
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  push d
  mov32 cb, $00000000
  pop d
  mov [d], bl
; return dest; 
  lea d, [bp + 5] ; $dest
  mov b, [d]
  mov c, 0
  leave
  ret
; --- END TEXT SEGMENT

; --- BEGIN DATA SEGMENT
_keywords_data:
.dw _s0
.db 1
.dw _s1
.db 2
.dw _s2
.db 3
.dw _s3
.db 4
.dw _s4
.db 6
.dw _s5
.db 7
.dw _s6
.db 5
.dw _s7
.db 0
_label_table_data: .fill 288, 0
__org: .dw $0400
_pc: .fill 2, 0
_print_information: .db $01
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
_symbols_data: .dw _s8, _s9, _s9, _s8, _s8, _s8, _s9, _s9, 
_rng_state: .dw $0000
_s0: .db "org", 0
_s1: .db "include", 0
_s2: .db "data", 0
_s3: .db "text", 0
_s4: .db "db", 0
_s5: .db "dw", 0
_s6: .db "end", 0
_s7: .db "", 0
_s8: .db "@", 0
_s9: .db "#", 0
_s10: .db "\n", 0
_s11: .db "./config.d/op_tbl", 0
_s12: .db "Parsing DATA section...", 0
_s13: .db "Data segment not found.", 0
_s14: .db ".db: ", 0
_s15: .db "%d", 0
_s16: .db ", ", 0
_s17: .db ".dw: ", 0
_s18: .db "Done.\n", 0
_s19: .db "Integer constant _expected in .org directive.", 0
_s20: .db "Parsing labels and directives...\n", 0
_s21: .db ".", 0
_s22: .db "\nDone.\n", 0
_s23: .db "Org: %s\n", 0
_s24: .db "\nLabels list:\n", 0
_s25: .db "%s: %x\n", 0
_s26: .db " .", 0
_s27: .db " ", 0
_s28: .db "Maximum number of operands per instruction is 2.", 0
_s29: .db "8bit operand _expected but 16bit label given.", 0
_s30: .db "%x(%d): %s\n", 0
_s31: .db "Undeclared label: ", 0
_s32: .db "Parsing TEXT section...\n", 0
_s33: .db "TEXT section not found.", 0
_s34: .db "TEXT section end not found.", 0
_s35: .db "Un_expected directive.", 0
_s36: .db "Done.\n\n", 0
_s37: .db "Prog Offset: %x\n", 0
_s38: .db "Prog value : %c\n", 0
_s39: .db "Token      : %s\n", 0
_s40: .db "Tok        : %d\n", 0
_s41: .db "Toktype    : %d\n", 0
_s42: .db "StringConst: %s\n", 0
_s43: .db "PC         : %x\n", 0
_s44: .db "\nAssembly complete.\n", 0
_s45: .db "Program size: %d\n", 0
_s46: .db "Listing: \n", 0
_s47: .db "%x", 0
_s48: .db "a", 0
_s49: .db "al", 0
_s50: .db "ah", 0
_s51: .db "b", 0
_s52: .db "bl", 0
_s53: .db "bh", 0
_s54: .db "c", 0
_s55: .db "cl", 0
_s56: .db "ch", 0
_s57: .db "d", 0
_s58: .db "dl", 0
_s59: .db "dh", 0
_s60: .db "g", 0
_s61: .db "gl", 0
_s62: .db "gh", 0
_s63: .db "pc", 0
_s64: .db "sp", 0
_s65: .db "bp", 0
_s66: .db "si", 0
_s67: .db "di", 0
_s68: .db "word", 0
_s69: .db "byte", 0
_s70: .db "cmpsb", 0
_s71: .db "movsb", 0
_s72: .db "stosb", 0
_s73: .db "define", 0
_s74: .db "Label does not exist: ", 0
_s75: .db "Closing single quotes _expected.", 0
_s76: .db "Double quotes _expected", 0
_s77: .db "TOKEN ERROR. Prog: %x\n", 0
_s78: .db "ProgVal: %x", 0
_s79: .db "\n Text after prog: %s\n", 0
_s80: .db "\nError: %s\n", 0
_s81: .db "\nError: %s %s\n", 0
_s82: .db "Cannot push prog. Stack overflow.", 0
_s83: .db "Cannot pop prog. Stack overflow.", 0
_s84: .db "Unexpected format in printf.", 0
_s85: .db "Error: Unknown argument type.\n", 0

_heap_top: .dw _heap
_heap: .db 0
; --- END DATA SEGMENT

.end
