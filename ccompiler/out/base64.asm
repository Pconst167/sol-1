; --- FILENAME: programs/base64.c
; --- DATE:     26-07-2025 at 17:28:19
.include "lib/asm/kernel.exp"
.include "lib/asm/bios.exp"

; --- BEGIN TEXT SEGMENT
.org text_org
main:
  mov bp, $FFE0 ;
  mov sp, $FFE0 ; Make space for argc(2 bytes) and for 10 pointers in argv (local variables)
; char input[512]; 
  sub sp, 512
; char output[256]; 
  sub sp, 256
; printf("\nEnter a base64 encoded string to decode: "); 
; --- START FUNCTION CALL
  mov b, _s0 ; "\nEnter a base64 encoded string to decode: "
  swp b
  push b
  call printf
  add sp, 2
; --- END FUNCTION CALL
; gets(input); 
; --- START FUNCTION CALL
  lea d, [bp + -511] ; $input
  mov b, d
  mov c, 0
  swp b
  push b
  call gets
  add sp, 2
; --- END FUNCTION CALL
; base64_encode(input, output); 
; --- START FUNCTION CALL
  lea d, [bp + -767] ; $output
  mov b, d
  mov c, 0
  swp b
  push b
  lea d, [bp + -511] ; $input
  mov b, d
  mov c, 0
  swp b
  push b
  call base64_encode
  add sp, 4
; --- END FUNCTION CALL
; printf("\nEncoded string: %s\n", output); 
; --- START FUNCTION CALL
  lea d, [bp + -767] ; $output
  mov b, d
  mov c, 0
  swp b
  push b
  mov b, _s1 ; "\nEncoded string: %s\n"
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
; base64_decode(output, input); 
; --- START FUNCTION CALL
  lea d, [bp + -511] ; $input
  mov b, d
  mov c, 0
  swp b
  push b
  lea d, [bp + -767] ; $output
  mov b, d
  mov c, 0
  swp b
  push b
  call base64_decode
  add sp, 4
; --- END FUNCTION CALL
; printf("\nDecoded string: %s\n", input); 
; --- START FUNCTION CALL
  lea d, [bp + -511] ; $input
  mov b, d
  mov c, 0
  swp b
  push b
  mov b, _s2 ; "\nDecoded string: %s\n"
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
; return 0; 
  mov32 cb, $00000000
  leave
  syscall sys_terminate_proc

base64_encode:
  enter 0 ; (push bp; mov bp, sp)
; int i = 0; 
  sub sp, 2
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -1] ; $i
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
; --- END LOCAL VAR INITIALIZATION
; int j = 0; 
  sub sp, 2
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -3] ; $j
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
; --- END LOCAL VAR INITIALIZATION
; int k; 
  sub sp, 2
; int input_len; 
  sub sp, 2
; unsigned char input_buffer[3]; 
  sub sp, 3
; unsigned char output_buffer[4]; 
  sub sp, 4
; input_len = strlen(input); 
  lea d, [bp + -7] ; $input_len
  push d
; --- START FUNCTION CALL
  lea d, [bp + 5] ; $input
  mov b, [d]
  mov c, 0
  swp b
  push b
  call strlen
  add sp, 2
; --- END FUNCTION CALL
  pop d
  mov [d], b
; while (input_len--) { 
_while1_cond:
  lea d, [bp + -7] ; $input_len
  mov b, [d]
  mov c, 0
  mov a, b
  dec b
  lea d, [bp + -7] ; $input_len
  mov [d], b
  mov b, a
  cmp b, 0
  je _while1_exit
_while1_block:
; input_buffer[i++] = *(input++); 
  lea d, [bp + -10] ; $input_buffer
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  mov b, a
  pop d
  add d, b
  pop a
  push d
  lea d, [bp + 5] ; $input
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + 5] ; $input
  mov [d], b
  dec b
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mov [d], bl
; if (i == 3) { 
_if2_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000003
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if2_exit
_if2_TRUE:
; output_buffer[0] = (input_buffer[0] & 0xFC) >> 2; 
  lea d, [bp + -14] ; $output_buffer
  push a
  push d
  mov32 cb, $00000000
  pop d
  add d, b
  pop a
  push d
  lea d, [bp + -10] ; $input_buffer
  push a
  push d
  mov32 cb, $00000000
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push a
  mov a, b
  mov32 cb, $000000fc
  and b, a ; &
  pop a
; --- START SHIFT
  push a
  mov a, b
  mov32 cb, $00000002
  mov c, b
  ashr a, cl
  mov b, a
  pop a
; --- END SHIFT
  pop d
  mov [d], bl
; output_buffer[1] = ((input_buffer[0] & 0x03) << 4) + ((input_buffer[1] & 0xF0) >> 4); 
  lea d, [bp + -14] ; $output_buffer
  push a
  push d
  mov32 cb, $00000001
  pop d
  add d, b
  pop a
  push d
  lea d, [bp + -10] ; $input_buffer
  push a
  push d
  mov32 cb, $00000000
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push a
  mov a, b
  mov32 cb, $00000003
  and b, a ; &
  pop a
; --- START SHIFT
  push a
  mov a, b
  mov32 cb, $00000004
  mov c, b
  shl a, cl
  mov b, a
  pop a
; --- END SHIFT
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -10] ; $input_buffer
  push a
  push d
  mov32 cb, $00000001
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push a
  mov a, b
  mov32 cb, $000000f0
  and b, a ; &
  pop a
; --- START SHIFT
  push a
  mov a, b
  mov32 cb, $00000004
  mov c, b
  ashr a, cl
  mov b, a
  pop a
; --- END SHIFT
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], bl
; output_buffer[2] = ((input_buffer[1] & 0x0F) << 2) + ((input_buffer[2] & 0xC0) >> 6); 
  lea d, [bp + -14] ; $output_buffer
  push a
  push d
  mov32 cb, $00000002
  pop d
  add d, b
  pop a
  push d
  lea d, [bp + -10] ; $input_buffer
  push a
  push d
  mov32 cb, $00000001
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push a
  mov a, b
  mov32 cb, $0000000f
  and b, a ; &
  pop a
; --- START SHIFT
  push a
  mov a, b
  mov32 cb, $00000002
  mov c, b
  shl a, cl
  mov b, a
  pop a
; --- END SHIFT
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -10] ; $input_buffer
  push a
  push d
  mov32 cb, $00000002
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push a
  mov a, b
  mov32 cb, $000000c0
  and b, a ; &
  pop a
; --- START SHIFT
  push a
  mov a, b
  mov32 cb, $00000006
  mov c, b
  ashr a, cl
  mov b, a
  pop a
; --- END SHIFT
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], bl
; output_buffer[3] = input_buffer[2] & 0x3F; 
  lea d, [bp + -14] ; $output_buffer
  push a
  push d
  mov32 cb, $00000003
  pop d
  add d, b
  pop a
  push d
  lea d, [bp + -10] ; $input_buffer
  push a
  push d
  mov32 cb, $00000002
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push a
  mov a, b
  mov32 cb, $0000003f
  and b, a ; &
  pop a
  pop d
  mov [d], bl
; for (i = 0; i < 4; i++) { 
_for3_init:
  lea d, [bp + -1] ; $i
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
_for3_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000004
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for3_exit
_for3_block:
; output[j++] = base64_table[output_buffer[i]]; 
  lea d, [bp + 7] ; $output
  mov d, [d]
  push a
  push d
  lea d, [bp + -3] ; $j
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -3] ; $j
  mov [d], b
  mov b, a
  pop d
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  push d
  mov d, _base64_table ; $base64_table
  mov d, [d]
  push a
  push d
  lea d, [bp + -14] ; $output_buffer
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mov [d], bl
_for3_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  mov b, a
  jmp _for3_cond
_for3_exit:
; i = 0; 
  lea d, [bp + -1] ; $i
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
  jmp _if2_exit
_if2_exit:
  jmp _while1_cond
_while1_exit:
; if (i) { 
_if4_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  cmp b, 0
  je _if4_exit
_if4_TRUE:
; for (k = i; k < 3; k++) { 
_for5_init:
  lea d, [bp + -5] ; $k
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
_for5_cond:
  lea d, [bp + -5] ; $k
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000003
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for5_exit
_for5_block:
; input_buffer[k] = '\0'; 
  lea d, [bp + -10] ; $input_buffer
  push a
  push d
  lea d, [bp + -5] ; $k
  mov b, [d]
  mov c, 0
  pop d
  add d, b
  pop a
  push d
  mov32 cb, $00000000
  pop d
  mov [d], bl
_for5_update:
  lea d, [bp + -5] ; $k
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -5] ; $k
  mov [d], b
  mov b, a
  jmp _for5_cond
_for5_exit:
; output_buffer[0] = (input_buffer[0] & 0xFC) >> 2; 
  lea d, [bp + -14] ; $output_buffer
  push a
  push d
  mov32 cb, $00000000
  pop d
  add d, b
  pop a
  push d
  lea d, [bp + -10] ; $input_buffer
  push a
  push d
  mov32 cb, $00000000
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push a
  mov a, b
  mov32 cb, $000000fc
  and b, a ; &
  pop a
; --- START SHIFT
  push a
  mov a, b
  mov32 cb, $00000002
  mov c, b
  ashr a, cl
  mov b, a
  pop a
; --- END SHIFT
  pop d
  mov [d], bl
; output_buffer[1] = ((input_buffer[0] & 0x03) << 4) + ((input_buffer[1] & 0xF0) >> 4); 
  lea d, [bp + -14] ; $output_buffer
  push a
  push d
  mov32 cb, $00000001
  pop d
  add d, b
  pop a
  push d
  lea d, [bp + -10] ; $input_buffer
  push a
  push d
  mov32 cb, $00000000
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push a
  mov a, b
  mov32 cb, $00000003
  and b, a ; &
  pop a
; --- START SHIFT
  push a
  mov a, b
  mov32 cb, $00000004
  mov c, b
  shl a, cl
  mov b, a
  pop a
; --- END SHIFT
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -10] ; $input_buffer
  push a
  push d
  mov32 cb, $00000001
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push a
  mov a, b
  mov32 cb, $000000f0
  and b, a ; &
  pop a
; --- START SHIFT
  push a
  mov a, b
  mov32 cb, $00000004
  mov c, b
  ashr a, cl
  mov b, a
  pop a
; --- END SHIFT
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], bl
; output_buffer[2] = ((input_buffer[1] & 0x0F) << 2) + ((input_buffer[2] & 0xC0) >> 6); 
  lea d, [bp + -14] ; $output_buffer
  push a
  push d
  mov32 cb, $00000002
  pop d
  add d, b
  pop a
  push d
  lea d, [bp + -10] ; $input_buffer
  push a
  push d
  mov32 cb, $00000001
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push a
  mov a, b
  mov32 cb, $0000000f
  and b, a ; &
  pop a
; --- START SHIFT
  push a
  mov a, b
  mov32 cb, $00000002
  mov c, b
  shl a, cl
  mov b, a
  pop a
; --- END SHIFT
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -10] ; $input_buffer
  push a
  push d
  mov32 cb, $00000002
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push a
  mov a, b
  mov32 cb, $000000c0
  and b, a ; &
  pop a
; --- START SHIFT
  push a
  mov a, b
  mov32 cb, $00000006
  mov c, b
  ashr a, cl
  mov b, a
  pop a
; --- END SHIFT
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], bl
; for (k = 0; k < i + 1; k++) { 
_for6_init:
  lea d, [bp + -5] ; $k
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
_for6_cond:
  lea d, [bp + -5] ; $k
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000001
  add b, a
  pop a
; --- END TERMS
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for6_exit
_for6_block:
; output[j++] = base64_table[output_buffer[k]]; 
  lea d, [bp + 7] ; $output
  mov d, [d]
  push a
  push d
  lea d, [bp + -3] ; $j
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -3] ; $j
  mov [d], b
  mov b, a
  pop d
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  push d
  mov d, _base64_table ; $base64_table
  mov d, [d]
  push a
  push d
  lea d, [bp + -14] ; $output_buffer
  push a
  push d
  lea d, [bp + -5] ; $k
  mov b, [d]
  mov c, 0
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mov [d], bl
_for6_update:
  lea d, [bp + -5] ; $k
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -5] ; $k
  mov [d], b
  mov b, a
  jmp _for6_cond
_for6_exit:
; while (i++ < 3) { 
_while7_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  mov b, a
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000003
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _while7_exit
_while7_block:
; output[j++] = '='; 
  lea d, [bp + 7] ; $output
  mov d, [d]
  push a
  push d
  lea d, [bp + -3] ; $j
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -3] ; $j
  mov [d], b
  mov b, a
  pop d
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  push d
  mov32 cb, $0000003d
  pop d
  mov [d], bl
  jmp _while7_cond
_while7_exit:
  jmp _if4_exit
_if4_exit:
; output[j] = '\0'; 
  lea d, [bp + 7] ; $output
  mov d, [d]
  push a
  push d
  lea d, [bp + -3] ; $j
  mov b, [d]
  mov c, 0
  pop d
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  push d
  mov32 cb, $00000000
  pop d
  mov [d], bl
  leave
  ret

base64_char_value:
  enter 0 ; (push bp; mov bp, sp)
; if (c >= 'A' && c <= 'Z') return c - 'A'; 
_if8_cond:
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
  cmp b, 0
  je _if8_exit
_if8_TRUE:
; return c - 'A'; 
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000041
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  leave
  ret
  jmp _if8_exit
_if8_exit:
; if (c >= 'a' && c <= 'z') return c - 'a' + 26; 
_if9_cond:
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
  cmp b, 0
  je _if9_exit
_if9_TRUE:
; return c - 'a' + 26; 
  lea d, [bp + 5] ; $c
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
  mov32 cb, $0000001a
  add b, a
  pop a
; --- END TERMS
  leave
  ret
  jmp _if9_exit
_if9_exit:
; if (c >= '0' && c <= '9') return c - '0' + 52; 
_if10_cond:
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
  cmp b, 0
  je _if10_exit
_if10_TRUE:
; return c - '0' + 52; 
  lea d, [bp + 5] ; $c
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000030
  sub a, b
  mov b, a
  mov a, b
  mov32 cb, $00000034
  add b, a
  pop a
; --- END TERMS
  leave
  ret
  jmp _if10_exit
_if10_exit:
; if (c == '+') return 62; 
_if11_cond:
  lea d, [bp + 5] ; $c
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
  je _if11_exit
_if11_TRUE:
; return 62; 
  mov32 cb, $0000003e
  leave
  ret
  jmp _if11_exit
_if11_exit:
; if (c == '/') return 63; 
_if12_cond:
  lea d, [bp + 5] ; $c
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
  cmp b, 0
  je _if12_exit
_if12_TRUE:
; return 63; 
  mov32 cb, $0000003f
  leave
  ret
  jmp _if12_exit
_if12_exit:
; return -1; 
  mov32 cb, $ffffffff
  leave
  ret

base64_decode:
  enter 0 ; (push bp; mov bp, sp)
; int i = 0, j = 0, k = 0; 
  sub sp, 2
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -1] ; $i
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
; --- END LOCAL VAR INITIALIZATION
  sub sp, 2
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -3] ; $j
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
; --- END LOCAL VAR INITIALIZATION
  sub sp, 2
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -5] ; $k
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
; --- END LOCAL VAR INITIALIZATION
; int input_len; 
  sub sp, 2
; unsigned char input_buffer[4]; 
  sub sp, 4
; unsigned char output_buffer[3]; 
  sub sp, 3
; input_len = strlen(input); 
  lea d, [bp + -7] ; $input_len
  push d
; --- START FUNCTION CALL
  lea d, [bp + 5] ; $input
  mov b, [d]
  mov c, 0
  swp b
  push b
  call strlen
  add sp, 2
; --- END FUNCTION CALL
  pop d
  mov [d], b
; while (input_len-- && (input[k] != '=') && base64_char_value(input[k]) != -1) { 
_while13_cond:
  lea d, [bp + -7] ; $input_len
  mov b, [d]
  mov c, 0
  mov a, b
  dec b
  lea d, [bp + -7] ; $input_len
  mov [d], b
  mov b, a
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + 5] ; $input
  mov d, [d]
  push a
  push d
  lea d, [bp + -5] ; $k
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
  mov32 cb, $0000003d
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
  sand a, b
  mov a, b
; --- START FUNCTION CALL
  lea d, [bp + 5] ; $input
  mov d, [d]
  push a
  push d
  lea d, [bp + -5] ; $k
  mov b, [d]
  mov c, 0
  pop d
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push bl
  call base64_char_value
  add sp, 1
; --- END FUNCTION CALL
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $ffffffff
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  cmp b, 0
  je _while13_exit
_while13_block:
; input_buffer[i++] = input[k++]; 
  lea d, [bp + -11] ; $input_buffer
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  mov b, a
  pop d
  add d, b
  pop a
  push d
  lea d, [bp + 5] ; $input
  mov d, [d]
  push a
  push d
  lea d, [bp + -5] ; $k
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -5] ; $k
  mov [d], b
  mov b, a
  pop d
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mov [d], bl
; if (i == 4) { 
_if14_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000004
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if14_exit
_if14_TRUE:
; for (i = 0; i < 4; i++) { 
_for15_init:
  lea d, [bp + -1] ; $i
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
_for15_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000004
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for15_exit
_for15_block:
; input_buffer[i] = base64_char_value(input_buffer[i]); 
  lea d, [bp + -11] ; $input_buffer
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  add d, b
  pop a
  push d
; --- START FUNCTION CALL
  lea d, [bp + -11] ; $input_buffer
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push bl
  call base64_char_value
  add sp, 1
; --- END FUNCTION CALL
  pop d
  mov [d], bl
_for15_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  mov b, a
  jmp _for15_cond
_for15_exit:
; output_buffer[0] = (input_buffer[0] << 2) + ((input_buffer[1] & 0x30) >> 4); 
  lea d, [bp + -14] ; $output_buffer
  push a
  push d
  mov32 cb, $00000000
  pop d
  add d, b
  pop a
  push d
  lea d, [bp + -11] ; $input_buffer
  push a
  push d
  mov32 cb, $00000000
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START SHIFT
  push a
  mov a, b
  mov32 cb, $00000002
  mov c, b
  shl a, cl
  mov b, a
  pop a
; --- END SHIFT
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -11] ; $input_buffer
  push a
  push d
  mov32 cb, $00000001
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push a
  mov a, b
  mov32 cb, $00000030
  and b, a ; &
  pop a
; --- START SHIFT
  push a
  mov a, b
  mov32 cb, $00000004
  mov c, b
  ashr a, cl
  mov b, a
  pop a
; --- END SHIFT
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], bl
; output_buffer[1] = ((input_buffer[1] & 0x0F) << 4) + ((input_buffer[2] & 0x3C) >> 2); 
  lea d, [bp + -14] ; $output_buffer
  push a
  push d
  mov32 cb, $00000001
  pop d
  add d, b
  pop a
  push d
  lea d, [bp + -11] ; $input_buffer
  push a
  push d
  mov32 cb, $00000001
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push a
  mov a, b
  mov32 cb, $0000000f
  and b, a ; &
  pop a
; --- START SHIFT
  push a
  mov a, b
  mov32 cb, $00000004
  mov c, b
  shl a, cl
  mov b, a
  pop a
; --- END SHIFT
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -11] ; $input_buffer
  push a
  push d
  mov32 cb, $00000002
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push a
  mov a, b
  mov32 cb, $0000003c
  and b, a ; &
  pop a
; --- START SHIFT
  push a
  mov a, b
  mov32 cb, $00000002
  mov c, b
  ashr a, cl
  mov b, a
  pop a
; --- END SHIFT
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], bl
; output_buffer[2] = ((input_buffer[2] & 0x03) << 6) + input_buffer[3]; 
  lea d, [bp + -14] ; $output_buffer
  push a
  push d
  mov32 cb, $00000002
  pop d
  add d, b
  pop a
  push d
  lea d, [bp + -11] ; $input_buffer
  push a
  push d
  mov32 cb, $00000002
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push a
  mov a, b
  mov32 cb, $00000003
  and b, a ; &
  pop a
; --- START SHIFT
  push a
  mov a, b
  mov32 cb, $00000006
  mov c, b
  shl a, cl
  mov b, a
  pop a
; --- END SHIFT
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -11] ; $input_buffer
  push a
  push d
  mov32 cb, $00000003
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], bl
; for (i = 0; i < 3; i++) { 
_for16_init:
  lea d, [bp + -1] ; $i
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
_for16_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000003
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for16_exit
_for16_block:
; output[j++] = output_buffer[i]; 
  lea d, [bp + 7] ; $output
  mov d, [d]
  push a
  push d
  lea d, [bp + -3] ; $j
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -3] ; $j
  mov [d], b
  mov b, a
  pop d
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  push d
  lea d, [bp + -14] ; $output_buffer
  push a
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mov [d], bl
_for16_update:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -1] ; $i
  mov [d], b
  mov b, a
  jmp _for16_cond
_for16_exit:
; i = 0; 
  lea d, [bp + -1] ; $i
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
  jmp _if14_exit
_if14_exit:
  jmp _while13_cond
_while13_exit:
; if (i) { 
_if17_cond:
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  cmp b, 0
  je _if17_exit
_if17_TRUE:
; for (k = i; k < 4; k++) { 
_for18_init:
  lea d, [bp + -5] ; $k
  push d
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
_for18_cond:
  lea d, [bp + -5] ; $k
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000004
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for18_exit
_for18_block:
; input_buffer[k] = 0; 
  lea d, [bp + -11] ; $input_buffer
  push a
  push d
  lea d, [bp + -5] ; $k
  mov b, [d]
  mov c, 0
  pop d
  add d, b
  pop a
  push d
  mov32 cb, $00000000
  pop d
  mov [d], bl
_for18_update:
  lea d, [bp + -5] ; $k
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -5] ; $k
  mov [d], b
  mov b, a
  jmp _for18_cond
_for18_exit:
; for (k = 0; k < 4; k++) { 
_for19_init:
  lea d, [bp + -5] ; $k
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
_for19_cond:
  lea d, [bp + -5] ; $k
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000004
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for19_exit
_for19_block:
; input_buffer[k] = base64_char_value(input_buffer[k]); 
  lea d, [bp + -11] ; $input_buffer
  push a
  push d
  lea d, [bp + -5] ; $k
  mov b, [d]
  mov c, 0
  pop d
  add d, b
  pop a
  push d
; --- START FUNCTION CALL
  lea d, [bp + -11] ; $input_buffer
  push a
  push d
  lea d, [bp + -5] ; $k
  mov b, [d]
  mov c, 0
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push bl
  call base64_char_value
  add sp, 1
; --- END FUNCTION CALL
  pop d
  mov [d], bl
_for19_update:
  lea d, [bp + -5] ; $k
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -5] ; $k
  mov [d], b
  mov b, a
  jmp _for19_cond
_for19_exit:
; output_buffer[0] = (input_buffer[0] << 2) + ((input_buffer[1] & 0x30) >> 4); 
  lea d, [bp + -14] ; $output_buffer
  push a
  push d
  mov32 cb, $00000000
  pop d
  add d, b
  pop a
  push d
  lea d, [bp + -11] ; $input_buffer
  push a
  push d
  mov32 cb, $00000000
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START SHIFT
  push a
  mov a, b
  mov32 cb, $00000002
  mov c, b
  shl a, cl
  mov b, a
  pop a
; --- END SHIFT
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -11] ; $input_buffer
  push a
  push d
  mov32 cb, $00000001
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push a
  mov a, b
  mov32 cb, $00000030
  and b, a ; &
  pop a
; --- START SHIFT
  push a
  mov a, b
  mov32 cb, $00000004
  mov c, b
  ashr a, cl
  mov b, a
  pop a
; --- END SHIFT
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], bl
; output_buffer[1] = ((input_buffer[1] & 0x0F) << 4) + ((input_buffer[2] & 0x3C) >> 2); 
  lea d, [bp + -14] ; $output_buffer
  push a
  push d
  mov32 cb, $00000001
  pop d
  add d, b
  pop a
  push d
  lea d, [bp + -11] ; $input_buffer
  push a
  push d
  mov32 cb, $00000001
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push a
  mov a, b
  mov32 cb, $0000000f
  and b, a ; &
  pop a
; --- START SHIFT
  push a
  mov a, b
  mov32 cb, $00000004
  mov c, b
  shl a, cl
  mov b, a
  pop a
; --- END SHIFT
; --- START TERMS
  push a
  mov a, b
  lea d, [bp + -11] ; $input_buffer
  push a
  push d
  mov32 cb, $00000002
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push a
  mov a, b
  mov32 cb, $0000003c
  and b, a ; &
  pop a
; --- START SHIFT
  push a
  mov a, b
  mov32 cb, $00000002
  mov c, b
  ashr a, cl
  mov b, a
  pop a
; --- END SHIFT
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], bl
; for (k = 0; k < i - 1; k++) { 
_for20_init:
  lea d, [bp + -5] ; $k
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
_for20_cond:
  lea d, [bp + -5] ; $k
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000001
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for20_exit
_for20_block:
; output[j++] = output_buffer[k]; 
  lea d, [bp + 7] ; $output
  mov d, [d]
  push a
  push d
  lea d, [bp + -3] ; $j
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -3] ; $j
  mov [d], b
  mov b, a
  pop d
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  push d
  lea d, [bp + -14] ; $output_buffer
  push a
  push d
  lea d, [bp + -5] ; $k
  mov b, [d]
  mov c, 0
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
  pop d
  mov [d], bl
_for20_update:
  lea d, [bp + -5] ; $k
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -5] ; $k
  mov [d], b
  mov b, a
  jmp _for20_cond
_for20_exit:
  jmp _if17_exit
_if17_exit:
; output[j] = '\0'; 
  lea d, [bp + 7] ; $output
  mov d, [d]
  push a
  push d
  lea d, [bp + -3] ; $j
  mov b, [d]
  mov c, 0
  pop d
  mma 1 ; mov a, 1; mul a b; add d, b
  pop a
  push d
  mov32 cb, $00000000
  pop d
  mov [d], bl
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
_for21_init:
_for21_cond:
_for21_block:
; if(!*format_p) break; 
_if22_cond:
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
  je _if22_else
_if22_TRUE:
; break; 
  jmp _for21_exit ; for break
  jmp _if22_exit
_if22_else:
; if(*format_p == '%'){ 
_if23_cond:
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
  je _if23_else
_if23_TRUE:
; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  dec b
; switch(*format_p){ 
_switch24_expr:
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
_switch24_comparisons:
  cmp bl, $6c
  je _switch24_case0
  cmp bl, $4c
  je _switch24_case1
  cmp bl, $64
  je _switch24_case2
  cmp bl, $69
  je _switch24_case3
  cmp bl, $75
  je _switch24_case4
  cmp bl, $78
  je _switch24_case5
  cmp bl, $63
  je _switch24_case6
  cmp bl, $73
  je _switch24_case7
  jmp _switch24_default
  jmp _switch24_exit
_switch24_case0:
_switch24_case1:
; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  dec b
; if(*format_p == 'd' || *format_p == 'i') 
_if25_cond:
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
  je _if25_else
_if25_TRUE:
; print_signed_long(*(long *)p); 
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
  jmp _if25_exit
_if25_else:
; if(*format_p == 'u') 
_if26_cond:
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
  je _if26_else
_if26_TRUE:
; print_unsigned_long(*(unsigned long *)p); 
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
  jmp _if26_exit
_if26_else:
; if(*format_p == 'x') 
_if27_cond:
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
  je _if27_else
_if27_TRUE:
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
  jmp _if27_exit
_if27_else:
; err("Unexpected format in printf."); 
; --- START FUNCTION CALL
  mov b, _s3 ; "Unexpected format in printf."
  swp b
  push b
  call err
  add sp, 2
; --- END FUNCTION CALL
_if27_exit:
_if26_exit:
_if25_exit:
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
  jmp _switch24_exit ; case break
_switch24_case2:
_switch24_case3:
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
  jmp _switch24_exit ; case break
_switch24_case4:
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
  jmp _switch24_exit ; case break
_switch24_case5:
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
  jmp _switch24_exit ; case break
_switch24_case6:
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
  jmp _switch24_exit ; case break
_switch24_case7:
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
  jmp _switch24_exit ; case break
_switch24_default:
; print("Error: Unknown argument type.\n"); 
; --- START FUNCTION CALL
  mov b, _s4 ; "Error: Unknown argument type.\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
_switch24_exit:
  jmp _if23_exit
_if23_else:
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
_if23_exit:
_if22_exit:
; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  dec b
_for21_update:
  jmp _for21_cond
_for21_exit:
  leave
  ret

print_signed_long:
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
; if (num < 0) { 
_if28_cond:
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
  je _if28_else
_if28_TRUE:
; putchar('-'); 
; --- START FUNCTION CALL
  mov32 cb, $0000002d
  push bl
  call putchar
  add sp, 1
; --- END FUNCTION CALL
; num = -num; 
  lea d, [bp + 5] ; $num
  push d
  lea d, [bp + 5] ; $num
  mov b, [d + 2] ; Upper Word of the Long Int
  mov c, b ; And place it into C
  mov b, [d] ; Lower Word in B
  mov a, c
  not a
  not b
  add b, 1
  adc a, 0
  mov c, a
  pop d
  mov [d], b
  mov b, c
  mov [d + 2], b
  jmp _if28_exit
_if28_else:
; if (num == 0) { 
_if29_cond:
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
  je _if29_exit
_if29_TRUE:
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
  jmp _if29_exit
_if29_exit:
_if28_exit:
; while (num > 0) { 
_while30_cond:
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
  sgt
  pop g
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _while30_exit
_while30_block:
; digits[i] = '0' + (num % 10); 
  lea d, [bp + -9] ; $digits
  push a
  push d
  lea d, [bp + -11] ; $i
  mov b, [d]
  mov c, 0
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
; i++; 
  lea d, [bp + -11] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -11] ; $i
  mov [d], b
  mov b, a
  jmp _while30_cond
_while30_exit:
; while (i > 0) { 
_while37_cond:
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
  je _while37_exit
_while37_block:
; i--; 
  lea d, [bp + -11] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  dec b
  lea d, [bp + -11] ; $i
  mov [d], b
  mov b, a
; putchar(digits[i]); 
; --- START FUNCTION CALL
  lea d, [bp + -9] ; $digits
  push a
  push d
  lea d, [bp + -11] ; $i
  mov b, [d]
  mov c, 0
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
  jmp _while37_cond
_while37_exit:
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
; int i; 
  sub sp, 2
; i = 0; 
  lea d, [bp + -11] ; $i
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
; if(num == 0){ 
_if38_cond:
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
  je _if38_exit
_if38_TRUE:
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
  jmp _if38_exit
_if38_exit:
; while (num > 0) { 
_while39_cond:
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
  je _while39_exit
_while39_block:
; digits[i] = '0' + (num % 10); 
  lea d, [bp + -9] ; $digits
  push a
  push d
  lea d, [bp + -11] ; $i
  mov b, [d]
  mov c, 0
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
; i++; 
  lea d, [bp + -11] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -11] ; $i
  mov [d], b
  mov b, a
  jmp _while39_cond
_while39_exit:
; while (i > 0) { 
_while46_cond:
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
  je _while46_exit
_while46_block:
; i--; 
  lea d, [bp + -11] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  dec b
  lea d, [bp + -11] ; $i
  mov [d], b
  mov b, a
; putchar(digits[i]); 
; --- START FUNCTION CALL
  lea d, [bp + -9] ; $digits
  push a
  push d
  lea d, [bp + -11] ; $i
  mov b, [d]
  mov c, 0
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
  jmp _while46_cond
_while46_exit:
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
; if (num < 0) { 
_if47_cond:
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
  je _if47_else
_if47_TRUE:
; putchar('-'); 
; --- START FUNCTION CALL
  mov32 cb, $0000002d
  push bl
  call putchar
  add sp, 1
; --- END FUNCTION CALL
; num = -num; 
  lea d, [bp + 5] ; $num
  push d
  lea d, [bp + 5] ; $num
  mov b, [d]
  mov c, 0
  neg b
  pop d
  mov [d], b
  jmp _if47_exit
_if47_else:
; if (num == 0) { 
_if48_cond:
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
  je _if48_exit
_if48_TRUE:
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
  jmp _if48_exit
_if48_exit:
_if47_exit:
; while (num > 0) { 
_while49_cond:
  lea d, [bp + 5] ; $num
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
  je _while49_exit
_while49_block:
; digits[i] = '0' + (num % 10); 
  lea d, [bp + -4] ; $digits
  push a
  push d
  lea d, [bp + -6] ; $i
  mov b, [d]
  mov c, 0
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
; i++; 
  lea d, [bp + -6] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -6] ; $i
  mov [d], b
  mov b, a
  jmp _while49_cond
_while49_exit:
; while (i > 0) { 
_while56_cond:
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
  je _while56_exit
_while56_block:
; i--; 
  lea d, [bp + -6] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  dec b
  lea d, [bp + -6] ; $i
  mov [d], b
  mov b, a
; putchar(digits[i]); 
; --- START FUNCTION CALL
  lea d, [bp + -4] ; $digits
  push a
  push d
  lea d, [bp + -6] ; $i
  mov b, [d]
  mov c, 0
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
  jmp _while56_cond
_while56_exit:
  leave
  ret

print_unsigned:
  enter 0 ; (push bp; mov bp, sp)
; char digits[5]; 
  sub sp, 5
; int i; 
  sub sp, 2
; i = 0; 
  lea d, [bp + -6] ; $i
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
; if(num == 0){ 
_if57_cond:
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
  je _if57_exit
_if57_TRUE:
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
  jmp _if57_exit
_if57_exit:
; while (num > 0) { 
_while58_cond:
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
  je _while58_exit
_while58_block:
; digits[i] = '0' + (num % 10); 
  lea d, [bp + -4] ; $digits
  push a
  push d
  lea d, [bp + -6] ; $i
  mov b, [d]
  mov c, 0
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
; i++; 
  lea d, [bp + -6] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -6] ; $i
  mov [d], b
  mov b, a
  jmp _while58_cond
_while58_exit:
; while (i > 0) { 
_while65_cond:
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
  je _while65_exit
_while65_block:
; i--; 
  lea d, [bp + -6] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  dec b
  lea d, [bp + -6] ; $i
  mov [d], b
  mov b, a
; putchar(digits[i]); 
; --- START FUNCTION CALL
  lea d, [bp + -4] ; $digits
  push a
  push d
  lea d, [bp + -6] ; $i
  mov b, [d]
  mov c, 0
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
  jmp _while65_cond
_while65_exit:
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

gets:
  enter 0 ; (push bp; mov bp, sp)
; --- BEGIN INLINE ASM SEGMENT
  lea d, [bp + 5] ; $s
  mov a, [d]
  mov d, a
  call _gets_gets
; --- END INLINE ASM SEGMENT
; return strlen(s); 
; --- START FUNCTION CALL
  lea d, [bp + 5] ; $s
  mov b, [d]
  mov c, 0
  swp b
  push b
  call strlen
  add sp, 2
; --- END FUNCTION CALL
  leave
  ret
; --- BEGIN INLINE ASM SEGMENT
_gets_gets:
  push a
  push d
_gets_loop_gets:
  mov al, 1
  syscall sys_io      ; receive in AH
  cmp al, 0        ; check error code (AL)
  je _gets_loop_gets      ; if no char received, retry
  cmp ah, 27
  je _gets_ansi_esc_gets
  cmp ah, $0A        ; LF
  je _gets_end_gets
  cmp ah, $0D        ; CR
  je _gets_end_gets
  cmp ah, $5C        ; '\\'
  je _gets_escape_gets
  cmp ah, $08      ; check for backspace
  je _gets_backspace_gets
  mov al, ah
  mov [d], al
  inc d
  jmp _gets_loop_gets
_gets_backspace_gets:
  dec d
  jmp _gets_loop_gets
_gets_ansi_esc_gets:
  mov al, 1
  syscall sys_io        ; receive in AH without echo
  cmp al, 0          ; check error code (AL)
  je _gets_ansi_esc_gets    ; if no char received, retry
  cmp ah, '['
  jne _gets_loop_gets
_gets_ansi_esc_2_gets:
  mov al, 1
  syscall sys_io          ; receive in AH without echo
  cmp al, 0            ; check error code (AL)
  je _gets_ansi_esc_2_gets  ; if no char received, retry
  cmp ah, 'D'
  je _gets_left_arrow_gets
  cmp ah, 'C'
  je _gets_right_arrow_gets
  jmp _gets_loop_gets
_gets_left_arrow_gets:
  dec d
  jmp _gets_loop_gets
_gets_right_arrow_gets:
  inc d
  jmp _gets_loop_gets
_gets_escape_gets:
  mov al, 1
  syscall sys_io      ; receive in AH
  cmp al, 0        ; check error code (AL)
  je _gets_escape_gets      ; if no char received, retry
  cmp ah, 'n'
  je _gets_LF_gets
  cmp ah, 'r'
  je _gets_CR_gets
  cmp ah, '0'
  je _gets_NULL_gets
  cmp ah, $5C  
  je _gets_slash_gets
  mov al, ah        ; if not a known escape, it is just a normal letter
  mov [d], al
  inc d
  jmp _gets_loop_gets
_gets_slash_gets:
  mov al, $5C
  mov [d], al
  inc d
  jmp _gets_loop_gets
_gets_LF_gets:
  mov al, $0A
  mov [d], al
  inc d
  jmp _gets_loop_gets
_gets_CR_gets:
  mov al, $0D
  mov [d], al
  inc d
  jmp _gets_loop_gets
_gets_NULL_gets:
  mov al, $00
  mov [d], al
  inc d
  jmp _gets_loop_gets
_gets_end_gets:
  mov al, 0
  mov [d], al        ; terminate string
  pop d
  pop a
  ret
; --- END INLINE ASM SEGMENT
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
_while66_cond:
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
  je _while66_exit
_while66_block:
; length++; 
  lea d, [bp + -1] ; $length
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -1] ; $length
  mov [d], b
  mov b, a
  jmp _while66_cond
_while66_exit:
; return length; 
  lea d, [bp + -1] ; $length
  mov b, [d]
  mov c, 0
  leave
  ret
; --- END TEXT SEGMENT

; --- BEGIN DATA SEGMENT
_base64_table_data: .db "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/", 0
_base64_table: .dw _base64_table_data
_s0: .db "\nEnter a base64 encoded string to decode: ", 0
_s1: .db "\nEncoded string: %s\n", 0
_s2: .db "\nDecoded string: %s\n", 0
_s3: .db "Unexpected format in printf.", 0
_s4: .db "Error: Unknown argument type.\n", 0

_heap_top: .dw _heap
_heap: .db 0
; --- END DATA SEGMENT

.end
