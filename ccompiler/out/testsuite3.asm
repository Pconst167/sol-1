; --- FILENAME: ctestsuite/testsuite3.c
; --- DATE:     24-10-2025 at 20:03:06
.include "lib/asm/kernel.exp"
.include "lib/asm/bios.exp"

; --- BEGIN TEXT SEGMENT
.org text_org
main:
  mov bp, $FFE0 ;
  mov sp, $FFE0 ; Make space for argc(2 bytes) and for 10 pointers in argv (local variables)
; int pass = 1; 
  sub sp, 2
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -1] ; $pass
  push d
  mov32 cb, $00000001
  pop d
  mov [d], b
; --- END LOCAL VAR INITIALIZATION
; struct s1 ss[5]; 
  sub sp, 995
; printf("\nassigning values...\n"); 
; --- START FUNCTION CALL
  mov b, _s0 ; "\nassigning values...\n"
  swp b
  push b
  call printf
  add sp, 2
; --- END FUNCTION CALL
; ss[0].c = 'a'; 
  lea d, [bp + -996] ; $ss
  push a
  push d
  mov32 cb, $00000000
  pop d
  mma 199 ; mov a, 199; mul a, b; add d, b
  pop a
  add d, 0
  push d
  mov32 cb, $00000061
  pop d
  mov [d], bl
; ss[0].i = 123; 
  lea d, [bp + -996] ; $ss
  push a
  push d
  mov32 cb, $00000000
  pop d
  mma 199 ; mov a, 199; mul a, b; add d, b
  pop a
  add d, 1
  push d
  mov32 cb, $0000007b
  pop d
  mov [d], b
; ss[0].a[0] = 555; 
  lea d, [bp + -996] ; $ss
  push a
  push d
  mov32 cb, $00000000
  pop d
  mma 199 ; mov a, 199; mul a, b; add d, b
  pop a
  add d, 3
  push a
  push d
  mov32 cb, $00000000
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov32 cb, $0000022b
  pop d
  mov [d], b
; ss[0].a[1] = 666; 
  lea d, [bp + -996] ; $ss
  push a
  push d
  mov32 cb, $00000000
  pop d
  mma 199 ; mov a, 199; mul a, b; add d, b
  pop a
  add d, 3
  push a
  push d
  mov32 cb, $00000001
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov32 cb, $0000029a
  pop d
  mov [d], b
; ss[0].a[2] = 777; 
  lea d, [bp + -996] ; $ss
  push a
  push d
  mov32 cb, $00000000
  pop d
  mma 199 ; mov a, 199; mul a, b; add d, b
  pop a
  add d, 3
  push a
  push d
  mov32 cb, $00000002
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov32 cb, $00000309
  pop d
  mov [d], b
; ss[0].b[0] = 100; 
  lea d, [bp + -996] ; $ss
  push a
  push d
  mov32 cb, $00000000
  pop d
  mma 199 ; mov a, 199; mul a, b; add d, b
  pop a
  add d, 23
  push a
  push d
  mov32 cb, $00000000
  pop d
  add d, b
  pop a
  push d
  mov32 cb, $00000064
  pop d
  mov [d], bl
; ss[0].b[1] = 200; 
  lea d, [bp + -996] ; $ss
  push a
  push d
  mov32 cb, $00000000
  pop d
  mma 199 ; mov a, 199; mul a, b; add d, b
  pop a
  add d, 23
  push a
  push d
  mov32 cb, $00000001
  pop d
  add d, b
  pop a
  push d
  mov32 cb, $000000c8
  pop d
  mov [d], bl
; ss[0].b[2] = 30; 
  lea d, [bp + -996] ; $ss
  push a
  push d
  mov32 cb, $00000000
  pop d
  mma 199 ; mov a, 199; mul a, b; add d, b
  pop a
  add d, 23
  push a
  push d
  mov32 cb, $00000002
  pop d
  add d, b
  pop a
  push d
  mov32 cb, $0000001e
  pop d
  mov [d], bl
; ss[3].s2[3].cc = 'z'; 
  lea d, [bp + -996] ; $ss
  push a
  push d
  mov32 cb, $00000003
  pop d
  mma 199 ; mov a, 199; mul a, b; add d, b
  pop a
  add d, 33
  push a
  push d
  mov32 cb, $00000003
  pop d
  mma 33 ; mov a, 33; mul a, b; add d, b
  pop a
  add d, 0
  push d
  mov32 cb, $0000007a
  pop d
  mov [d], bl
; ss[3].s2[3].ii = 999; 
  lea d, [bp + -996] ; $ss
  push a
  push d
  mov32 cb, $00000003
  pop d
  mma 199 ; mov a, 199; mul a, b; add d, b
  pop a
  add d, 33
  push a
  push d
  mov32 cb, $00000003
  pop d
  mma 33 ; mov a, 33; mul a, b; add d, b
  pop a
  add d, 1
  push d
  mov32 cb, $000003e7
  pop d
  mov [d], b
; ss[3].s2[3].cc2[0] = 255; 
  lea d, [bp + -996] ; $ss
  push a
  push d
  mov32 cb, $00000003
  pop d
  mma 199 ; mov a, 199; mul a, b; add d, b
  pop a
  add d, 33
  push a
  push d
  mov32 cb, $00000003
  pop d
  mma 33 ; mov a, 33; mul a, b; add d, b
  pop a
  add d, 3
  push a
  push d
  mov32 cb, $00000000
  pop d
  add d, b
  pop a
  push d
  mov32 cb, $000000ff
  pop d
  mov [d], bl
; ss[3].s2[3].cc2[1] = 128; 
  lea d, [bp + -996] ; $ss
  push a
  push d
  mov32 cb, $00000003
  pop d
  mma 199 ; mov a, 199; mul a, b; add d, b
  pop a
  add d, 33
  push a
  push d
  mov32 cb, $00000003
  pop d
  mma 33 ; mov a, 33; mul a, b; add d, b
  pop a
  add d, 3
  push a
  push d
  mov32 cb, $00000001
  pop d
  add d, b
  pop a
  push d
  mov32 cb, $00000080
  pop d
  mov [d], bl
; ss[3].s2[3].cc2[2] = 100; 
  lea d, [bp + -996] ; $ss
  push a
  push d
  mov32 cb, $00000003
  pop d
  mma 199 ; mov a, 199; mul a, b; add d, b
  pop a
  add d, 33
  push a
  push d
  mov32 cb, $00000003
  pop d
  mma 33 ; mov a, 33; mul a, b; add d, b
  pop a
  add d, 3
  push a
  push d
  mov32 cb, $00000002
  pop d
  add d, b
  pop a
  push d
  mov32 cb, $00000064
  pop d
  mov [d], bl
; ss[3].s2[3].ii2[0] = 65535; 
  lea d, [bp + -996] ; $ss
  push a
  push d
  mov32 cb, $00000003
  pop d
  mma 199 ; mov a, 199; mul a, b; add d, b
  pop a
  add d, 33
  push a
  push d
  mov32 cb, $00000003
  pop d
  mma 33 ; mov a, 33; mul a, b; add d, b
  pop a
  add d, 13
  push a
  push d
  mov32 cb, $00000000
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov32 cb, $0000ffff
  pop d
  mov [d], b
; ss[3].s2[3].ii2[1] = 50000; 
  lea d, [bp + -996] ; $ss
  push a
  push d
  mov32 cb, $00000003
  pop d
  mma 199 ; mov a, 199; mul a, b; add d, b
  pop a
  add d, 33
  push a
  push d
  mov32 cb, $00000003
  pop d
  mma 33 ; mov a, 33; mul a, b; add d, b
  pop a
  add d, 13
  push a
  push d
  mov32 cb, $00000001
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov32 cb, $0000c350
  pop d
  mov [d], b
; ss[3].s2[3].ii2[2] = 20000; 
  lea d, [bp + -996] ; $ss
  push a
  push d
  mov32 cb, $00000003
  pop d
  mma 199 ; mov a, 199; mul a, b; add d, b
  pop a
  add d, 33
  push a
  push d
  mov32 cb, $00000003
  pop d
  mma 33 ; mov a, 33; mul a, b; add d, b
  pop a
  add d, 13
  push a
  push d
  mov32 cb, $00000002
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov32 cb, $00004e20
  pop d
  mov [d], b
; ss[3].cc2 = 'b'; 
  lea d, [bp + -996] ; $ss
  push a
  push d
  mov32 cb, $00000003
  pop d
  mma 199 ; mov a, 199; mul a, b; add d, b
  pop a
  add d, 198
  push d
  mov32 cb, $00000062
  pop d
  mov [d], bl
; printf("printing assignments...\n"); 
; --- START FUNCTION CALL
  mov b, _s1 ; "printing assignments...\n"
  swp b
  push b
  call printf
  add sp, 2
; --- END FUNCTION CALL
; printf("%c\n", ss[0].c); 
; --- START FUNCTION CALL
  lea d, [bp + -996] ; $ss
  push a
  push d
  mov32 cb, $00000000
  pop d
  mma 199 ; mov a, 199; mul a, b; add d, b
  pop a
  add d, 0
  mov bl, [d]
  mov bh, 0
  mov c, 0
  swp b
  push b
  mov b, _s2 ; "%c\n"
  swp b
  push b
  call printf
  add sp, 3
; --- END FUNCTION CALL
; printf("%d\n", ss[0].i); 
; --- START FUNCTION CALL
  lea d, [bp + -996] ; $ss
  push a
  push d
  mov32 cb, $00000000
  pop d
  mma 199 ; mov a, 199; mul a, b; add d, b
  pop a
  add d, 1
  mov b, [d]
  mov c, 0
  swp b
  push b
  mov b, _s3 ; "%d\n"
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
; printf("%d\n", ss[0].a[0]); 
; --- START FUNCTION CALL
  lea d, [bp + -996] ; $ss
  push a
  push d
  mov32 cb, $00000000
  pop d
  mma 199 ; mov a, 199; mul a, b; add d, b
  pop a
  add d, 3
  push a
  push d
  mov32 cb, $00000000
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  swp b
  push b
  mov b, _s3 ; "%d\n"
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
; printf("%d\n", ss[0].a[1]); 
; --- START FUNCTION CALL
  lea d, [bp + -996] ; $ss
  push a
  push d
  mov32 cb, $00000000
  pop d
  mma 199 ; mov a, 199; mul a, b; add d, b
  pop a
  add d, 3
  push a
  push d
  mov32 cb, $00000001
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  swp b
  push b
  mov b, _s3 ; "%d\n"
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
; printf("%d\n", ss[0].a[2]); 
; --- START FUNCTION CALL
  lea d, [bp + -996] ; $ss
  push a
  push d
  mov32 cb, $00000000
  pop d
  mma 199 ; mov a, 199; mul a, b; add d, b
  pop a
  add d, 3
  push a
  push d
  mov32 cb, $00000002
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  swp b
  push b
  mov b, _s3 ; "%d\n"
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
; printf("%d\n", ss[0].b[0]); 
; --- START FUNCTION CALL
  lea d, [bp + -996] ; $ss
  push a
  push d
  mov32 cb, $00000000
  pop d
  mma 199 ; mov a, 199; mul a, b; add d, b
  pop a
  add d, 23
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
  mov b, _s3 ; "%d\n"
  swp b
  push b
  call printf
  add sp, 3
; --- END FUNCTION CALL
; printf("%d\n", ss[0].b[1]); 
; --- START FUNCTION CALL
  lea d, [bp + -996] ; $ss
  push a
  push d
  mov32 cb, $00000000
  pop d
  mma 199 ; mov a, 199; mul a, b; add d, b
  pop a
  add d, 23
  push a
  push d
  mov32 cb, $00000001
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
  swp b
  push b
  mov b, _s3 ; "%d\n"
  swp b
  push b
  call printf
  add sp, 3
; --- END FUNCTION CALL
; printf("%d\n", ss[0].b[2]); 
; --- START FUNCTION CALL
  lea d, [bp + -996] ; $ss
  push a
  push d
  mov32 cb, $00000000
  pop d
  mma 199 ; mov a, 199; mul a, b; add d, b
  pop a
  add d, 23
  push a
  push d
  mov32 cb, $00000002
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
  swp b
  push b
  mov b, _s3 ; "%d\n"
  swp b
  push b
  call printf
  add sp, 3
; --- END FUNCTION CALL
; printf("%c\n", ss[3].s2[3].cc); 
; --- START FUNCTION CALL
  lea d, [bp + -996] ; $ss
  push a
  push d
  mov32 cb, $00000003
  pop d
  mma 199 ; mov a, 199; mul a, b; add d, b
  pop a
  add d, 33
  push a
  push d
  mov32 cb, $00000003
  pop d
  mma 33 ; mov a, 33; mul a, b; add d, b
  pop a
  add d, 0
  mov bl, [d]
  mov bh, 0
  mov c, 0
  swp b
  push b
  mov b, _s2 ; "%c\n"
  swp b
  push b
  call printf
  add sp, 3
; --- END FUNCTION CALL
; printf("%d\n", ss[3].s2[3].ii); 
; --- START FUNCTION CALL
  lea d, [bp + -996] ; $ss
  push a
  push d
  mov32 cb, $00000003
  pop d
  mma 199 ; mov a, 199; mul a, b; add d, b
  pop a
  add d, 33
  push a
  push d
  mov32 cb, $00000003
  pop d
  mma 33 ; mov a, 33; mul a, b; add d, b
  pop a
  add d, 1
  mov b, [d]
  mov c, 0
  swp b
  push b
  mov b, _s3 ; "%d\n"
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
; printf("%u\n", ss[3].s2[3].cc2[0]); 
; --- START FUNCTION CALL
  lea d, [bp + -996] ; $ss
  push a
  push d
  mov32 cb, $00000003
  pop d
  mma 199 ; mov a, 199; mul a, b; add d, b
  pop a
  add d, 33
  push a
  push d
  mov32 cb, $00000003
  pop d
  mma 33 ; mov a, 33; mul a, b; add d, b
  pop a
  add d, 3
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
  mov b, _s4 ; "%u\n"
  swp b
  push b
  call printf
  add sp, 3
; --- END FUNCTION CALL
; printf("%u\n", ss[3].s2[3].cc2[1]); 
; --- START FUNCTION CALL
  lea d, [bp + -996] ; $ss
  push a
  push d
  mov32 cb, $00000003
  pop d
  mma 199 ; mov a, 199; mul a, b; add d, b
  pop a
  add d, 33
  push a
  push d
  mov32 cb, $00000003
  pop d
  mma 33 ; mov a, 33; mul a, b; add d, b
  pop a
  add d, 3
  push a
  push d
  mov32 cb, $00000001
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
  swp b
  push b
  mov b, _s4 ; "%u\n"
  swp b
  push b
  call printf
  add sp, 3
; --- END FUNCTION CALL
; printf("%u\n", ss[3].s2[3].cc2[2]); 
; --- START FUNCTION CALL
  lea d, [bp + -996] ; $ss
  push a
  push d
  mov32 cb, $00000003
  pop d
  mma 199 ; mov a, 199; mul a, b; add d, b
  pop a
  add d, 33
  push a
  push d
  mov32 cb, $00000003
  pop d
  mma 33 ; mov a, 33; mul a, b; add d, b
  pop a
  add d, 3
  push a
  push d
  mov32 cb, $00000002
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
  swp b
  push b
  mov b, _s4 ; "%u\n"
  swp b
  push b
  call printf
  add sp, 3
; --- END FUNCTION CALL
; printf("%u\n", ss[3].s2[3].ii2[0]); 
; --- START FUNCTION CALL
  lea d, [bp + -996] ; $ss
  push a
  push d
  mov32 cb, $00000003
  pop d
  mma 199 ; mov a, 199; mul a, b; add d, b
  pop a
  add d, 33
  push a
  push d
  mov32 cb, $00000003
  pop d
  mma 33 ; mov a, 33; mul a, b; add d, b
  pop a
  add d, 13
  push a
  push d
  mov32 cb, $00000000
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  swp b
  push b
  mov b, _s4 ; "%u\n"
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
; printf("%u\n", ss[3].s2[3].ii2[1]); 
; --- START FUNCTION CALL
  lea d, [bp + -996] ; $ss
  push a
  push d
  mov32 cb, $00000003
  pop d
  mma 199 ; mov a, 199; mul a, b; add d, b
  pop a
  add d, 33
  push a
  push d
  mov32 cb, $00000003
  pop d
  mma 33 ; mov a, 33; mul a, b; add d, b
  pop a
  add d, 13
  push a
  push d
  mov32 cb, $00000001
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  swp b
  push b
  mov b, _s4 ; "%u\n"
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
; printf("%u\n", ss[3].s2[3].ii2[2]); 
; --- START FUNCTION CALL
  lea d, [bp + -996] ; $ss
  push a
  push d
  mov32 cb, $00000003
  pop d
  mma 199 ; mov a, 199; mul a, b; add d, b
  pop a
  add d, 33
  push a
  push d
  mov32 cb, $00000003
  pop d
  mma 33 ; mov a, 33; mul a, b; add d, b
  pop a
  add d, 13
  push a
  push d
  mov32 cb, $00000002
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  swp b
  push b
  mov b, _s4 ; "%u\n"
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
; printf("%c\n", ss[3].cc2); 
; --- START FUNCTION CALL
  lea d, [bp + -996] ; $ss
  push a
  push d
  mov32 cb, $00000003
  pop d
  mma 199 ; mov a, 199; mul a, b; add d, b
  pop a
  add d, 198
  mov bl, [d]
  mov bh, 0
  mov c, 0
  swp b
  push b
  mov b, _s2 ; "%c\n"
  swp b
  push b
  call printf
  add sp, 3
; --- END FUNCTION CALL
; printf("checking results...\n");     
; --- START FUNCTION CALL
  mov b, _s5 ; "checking results...\n"
  swp b
  push b
  call printf
  add sp, 2
; --- END FUNCTION CALL
; pass = pass && ss[0].c == 'a'; 
  lea d, [bp + -1] ; $pass
  push d
  lea d, [bp + -1] ; $pass
  mov b, [d]
  mov c, 0
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + -996] ; $ss
  push a
  push d
  mov32 cb, $00000000
  pop d
  mma 199 ; mov a, 199; mul a, b; add d, b
  pop a
  add d, 0
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000061
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  pop d
  mov [d], b
; pass = pass && ss[0].i == 123; 
  lea d, [bp + -1] ; $pass
  push d
  lea d, [bp + -1] ; $pass
  mov b, [d]
  mov c, 0
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + -996] ; $ss
  push a
  push d
  mov32 cb, $00000000
  pop d
  mma 199 ; mov a, 199; mul a, b; add d, b
  pop a
  add d, 1
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $0000007b
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  pop d
  mov [d], b
; pass = pass && ss[0].a[0] == 555; 
  lea d, [bp + -1] ; $pass
  push d
  lea d, [bp + -1] ; $pass
  mov b, [d]
  mov c, 0
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + -996] ; $ss
  push a
  push d
  mov32 cb, $00000000
  pop d
  mma 199 ; mov a, 199; mul a, b; add d, b
  pop a
  add d, 3
  push a
  push d
  mov32 cb, $00000000
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $0000022b
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  pop d
  mov [d], b
; pass = pass && ss[0].a[1] == 666; 
  lea d, [bp + -1] ; $pass
  push d
  lea d, [bp + -1] ; $pass
  mov b, [d]
  mov c, 0
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + -996] ; $ss
  push a
  push d
  mov32 cb, $00000000
  pop d
  mma 199 ; mov a, 199; mul a, b; add d, b
  pop a
  add d, 3
  push a
  push d
  mov32 cb, $00000001
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $0000029a
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  pop d
  mov [d], b
; pass = pass && ss[0].a[2] == 777; 
  lea d, [bp + -1] ; $pass
  push d
  lea d, [bp + -1] ; $pass
  mov b, [d]
  mov c, 0
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + -996] ; $ss
  push a
  push d
  mov32 cb, $00000000
  pop d
  mma 199 ; mov a, 199; mul a, b; add d, b
  pop a
  add d, 3
  push a
  push d
  mov32 cb, $00000002
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000309
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  pop d
  mov [d], b
; pass = pass && ss[0].b[0] == 100; 
  lea d, [bp + -1] ; $pass
  push d
  lea d, [bp + -1] ; $pass
  mov b, [d]
  mov c, 0
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + -996] ; $ss
  push a
  push d
  mov32 cb, $00000000
  pop d
  mma 199 ; mov a, 199; mul a, b; add d, b
  pop a
  add d, 23
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
  mov32 cb, $00000064
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  pop d
  mov [d], b
; pass = pass && ss[0].b[1] == 200; 
  lea d, [bp + -1] ; $pass
  push d
  lea d, [bp + -1] ; $pass
  mov b, [d]
  mov c, 0
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + -996] ; $ss
  push a
  push d
  mov32 cb, $00000000
  pop d
  mma 199 ; mov a, 199; mul a, b; add d, b
  pop a
  add d, 23
  push a
  push d
  mov32 cb, $00000001
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $000000c8
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  pop d
  mov [d], b
; pass = pass && ss[0].b[2] == 30; 
  lea d, [bp + -1] ; $pass
  push d
  lea d, [bp + -1] ; $pass
  mov b, [d]
  mov c, 0
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + -996] ; $ss
  push a
  push d
  mov32 cb, $00000000
  pop d
  mma 199 ; mov a, 199; mul a, b; add d, b
  pop a
  add d, 23
  push a
  push d
  mov32 cb, $00000002
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $0000001e
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  pop d
  mov [d], b
; pass = pass && ss[3].s2[3].cc == 'z'; 
  lea d, [bp + -1] ; $pass
  push d
  lea d, [bp + -1] ; $pass
  mov b, [d]
  mov c, 0
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + -996] ; $ss
  push a
  push d
  mov32 cb, $00000003
  pop d
  mma 199 ; mov a, 199; mul a, b; add d, b
  pop a
  add d, 33
  push a
  push d
  mov32 cb, $00000003
  pop d
  mma 33 ; mov a, 33; mul a, b; add d, b
  pop a
  add d, 0
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $0000007a
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  pop d
  mov [d], b
; pass = pass && ss[3].s2[3].ii == 999; 
  lea d, [bp + -1] ; $pass
  push d
  lea d, [bp + -1] ; $pass
  mov b, [d]
  mov c, 0
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + -996] ; $ss
  push a
  push d
  mov32 cb, $00000003
  pop d
  mma 199 ; mov a, 199; mul a, b; add d, b
  pop a
  add d, 33
  push a
  push d
  mov32 cb, $00000003
  pop d
  mma 33 ; mov a, 33; mul a, b; add d, b
  pop a
  add d, 1
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $000003e7
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  pop d
  mov [d], b
; pass = pass && ss[3].s2[3].cc2[0] == 255; 
  lea d, [bp + -1] ; $pass
  push d
  lea d, [bp + -1] ; $pass
  mov b, [d]
  mov c, 0
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + -996] ; $ss
  push a
  push d
  mov32 cb, $00000003
  pop d
  mma 199 ; mov a, 199; mul a, b; add d, b
  pop a
  add d, 33
  push a
  push d
  mov32 cb, $00000003
  pop d
  mma 33 ; mov a, 33; mul a, b; add d, b
  pop a
  add d, 3
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
  mov32 cb, $000000ff
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  pop d
  mov [d], b
; pass = pass && ss[3].s2[3].cc2[1] == 128; 
  lea d, [bp + -1] ; $pass
  push d
  lea d, [bp + -1] ; $pass
  mov b, [d]
  mov c, 0
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + -996] ; $ss
  push a
  push d
  mov32 cb, $00000003
  pop d
  mma 199 ; mov a, 199; mul a, b; add d, b
  pop a
  add d, 33
  push a
  push d
  mov32 cb, $00000003
  pop d
  mma 33 ; mov a, 33; mul a, b; add d, b
  pop a
  add d, 3
  push a
  push d
  mov32 cb, $00000001
  pop d
  add d, b
  pop a
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000080
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  pop d
  mov [d], b
; pass = pass && ss[3].s2[3].cc2[2] == 100; 
  lea d, [bp + -1] ; $pass
  push d
  lea d, [bp + -1] ; $pass
  mov b, [d]
  mov c, 0
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + -996] ; $ss
  push a
  push d
  mov32 cb, $00000003
  pop d
  mma 199 ; mov a, 199; mul a, b; add d, b
  pop a
  add d, 33
  push a
  push d
  mov32 cb, $00000003
  pop d
  mma 33 ; mov a, 33; mul a, b; add d, b
  pop a
  add d, 3
  push a
  push d
  mov32 cb, $00000002
  pop d
  add d, b
  pop a
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
  sand a, b
  pop a
; --- END LOGICAL AND
  pop d
  mov [d], b
; pass = pass && ss[3].s2[3].ii2[0] == 65535; 
  lea d, [bp + -1] ; $pass
  push d
  lea d, [bp + -1] ; $pass
  mov b, [d]
  mov c, 0
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + -996] ; $ss
  push a
  push d
  mov32 cb, $00000003
  pop d
  mma 199 ; mov a, 199; mul a, b; add d, b
  pop a
  add d, 33
  push a
  push d
  mov32 cb, $00000003
  pop d
  mma 33 ; mov a, 33; mul a, b; add d, b
  pop a
  add d, 13
  push a
  push d
  mov32 cb, $00000000
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $0000ffff
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  pop d
  mov [d], b
; pass = pass && ss[3].s2[3].ii2[1] == 50000; 
  lea d, [bp + -1] ; $pass
  push d
  lea d, [bp + -1] ; $pass
  mov b, [d]
  mov c, 0
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + -996] ; $ss
  push a
  push d
  mov32 cb, $00000003
  pop d
  mma 199 ; mov a, 199; mul a, b; add d, b
  pop a
  add d, 33
  push a
  push d
  mov32 cb, $00000003
  pop d
  mma 33 ; mov a, 33; mul a, b; add d, b
  pop a
  add d, 13
  push a
  push d
  mov32 cb, $00000001
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $0000c350
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  pop d
  mov [d], b
; pass = pass && ss[3].s2[3].ii2[2] == 20000; 
  lea d, [bp + -1] ; $pass
  push d
  lea d, [bp + -1] ; $pass
  mov b, [d]
  mov c, 0
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + -996] ; $ss
  push a
  push d
  mov32 cb, $00000003
  pop d
  mma 199 ; mov a, 199; mul a, b; add d, b
  pop a
  add d, 33
  push a
  push d
  mov32 cb, $00000003
  pop d
  mma 33 ; mov a, 33; mul a, b; add d, b
  pop a
  add d, 13
  push a
  push d
  mov32 cb, $00000002
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00004e20
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  pop d
  mov [d], b
; pass = pass && ss[3].cc2 == 'b'; 
  lea d, [bp + -1] ; $pass
  push d
  lea d, [bp + -1] ; $pass
  mov b, [d]
  mov c, 0
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + -996] ; $ss
  push a
  push d
  mov32 cb, $00000003
  pop d
  mma 199 ; mov a, 199; mul a, b; add d, b
  pop a
  add d, 198
  mov bl, [d]
  mov bh, 0
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000062
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  pop d
  mov [d], b
; printf("final test result: %s\n", pass ? "passed" : "failed"); 
; --- START FUNCTION CALL
_ternary2_cond:
  lea d, [bp + -1] ; $pass
  mov b, [d]
  mov c, 0
  cmp b, 0
  je _ternary2_FALSE
_ternary2_TRUE:
  mov b, _s6 ; "passed"
  jmp _ternary2_exit
_ternary2_FALSE:
  mov b, _s7 ; "failed"
_ternary2_exit:
  swp b
  push b
  mov b, _s8 ; "final test result: %s\n"
  swp b
  push b
  call printf
  add sp, 4
; --- END FUNCTION CALL
  syscall sys_terminate_proc

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
_for3_init:
_for3_cond:
_for3_block:
; if(!*format_p) break; 
_if4_cond:
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
  je _if4_else
_if4_TRUE:
; break; 
  jmp _for3_exit ; for break
  jmp _if4_exit
_if4_else:
; if(*format_p == '%'){ 
_if5_cond:
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
  je _if5_else
_if5_TRUE:
; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  dec b
; switch(*format_p){ 
_switch6_expr:
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  mov d, b
  mov bl, [d]
  mov bh, 0
  mov c, 0
_switch6_comparisons:
  cmp bl, $6c
  je _switch6_case0
  cmp bl, $4c
  je _switch6_case1
  cmp bl, $64
  je _switch6_case2
  cmp bl, $69
  je _switch6_case3
  cmp bl, $75
  je _switch6_case4
  cmp bl, $78
  je _switch6_case5
  cmp bl, $70
  je _switch6_case6
  cmp bl, $63
  je _switch6_case7
  cmp bl, $73
  je _switch6_case8
  jmp _switch6_default
  jmp _switch6_exit
_switch6_case0:
_switch6_case1:
; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  dec b
; if(*format_p == 'd' || *format_p == 'i') 
_if7_cond:
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
  je _if7_else
_if7_TRUE:
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
  jmp _if7_exit
_if7_else:
; if(*format_p == 'u') 
_if8_cond:
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
  je _if8_else
_if8_TRUE:
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
  jmp _if8_exit
_if8_else:
; if(*format_p == 'x') 
_if9_cond:
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
  je _if9_else
_if9_TRUE:
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
  jmp _if9_exit
_if9_else:
; err("Unexpected format in printf."); 
; --- START FUNCTION CALL
  mov b, _s9 ; "Unexpected format in printf."
  swp b
  push b
  call err
  add sp, 2
; --- END FUNCTION CALL
_if9_exit:
_if8_exit:
_if7_exit:
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
  jmp _switch6_exit ; case break
_switch6_case2:
_switch6_case3:
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
  jmp _switch6_exit ; case break
_switch6_case4:
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
  jmp _switch6_exit ; case break
_switch6_case5:
_switch6_case6:
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
  jmp _switch6_exit ; case break
_switch6_case7:
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
  jmp _switch6_exit ; case break
_switch6_case8:
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
  jmp _switch6_exit ; case break
_switch6_default:
; print("Error: Unknown argument type.\n"); 
; --- START FUNCTION CALL
  mov b, _s10 ; "Error: Unknown argument type.\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
_switch6_exit:
  jmp _if5_exit
_if5_else:
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
_if5_exit:
_if4_exit:
; format_p++; 
  lea d, [bp + -3] ; $format_p
  mov b, [d]
  mov c, 0
  inc b
  lea d, [bp + -3] ; $format_p
  mov [d], b
  dec b
_for3_update:
  jmp _for3_cond
_for3_exit:
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
_if10_cond:
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
  je _if10_else
_if10_TRUE:
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
  jmp _if10_exit
_if10_else:
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
_if10_exit:
; if (absval == 0) { 
_if11_cond:
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
  je _if11_exit
_if11_TRUE:
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
  jmp _if11_exit
_if11_exit:
; while (absval > 0) { 
_while12_cond:
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
  je _while12_exit
_while12_block:
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
  jmp _while12_cond
_while12_exit:
; while (i > 0) { 
_while19_cond:
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
  je _while19_exit
_while19_block:
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
  jmp _while19_cond
_while19_exit:
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
_if20_cond:
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
  je _if20_exit
_if20_TRUE:
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
  jmp _if20_exit
_if20_exit:
; while (num > 0) { 
_while21_cond:
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
  je _while21_exit
_while21_block:
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
  jmp _while21_cond
_while21_exit:
; while (i > 0) { 
_while28_cond:
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
  je _while28_exit
_while28_block:
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
  jmp _while28_cond
_while28_exit:
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
_if29_cond:
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
  je _if29_else
_if29_TRUE:
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
  jmp _if29_exit
_if29_else:
; absval = (unsigned int)num; 
  lea d, [bp + -8] ; $absval
  push d
  lea d, [bp + 5] ; $num
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
_if29_exit:
; if (absval == 0) { 
_if30_cond:
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
  je _if30_exit
_if30_TRUE:
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
  jmp _if30_exit
_if30_exit:
; while (absval > 0) { 
_while31_cond:
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
  je _while31_exit
_while31_block:
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
  jmp _while31_cond
_while31_exit:
; while (i > 0) { 
_while38_cond:
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
  je _while38_exit
_while38_block:
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
  jmp _while38_cond
_while38_exit:
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
_if39_cond:
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
  je _if39_exit
_if39_TRUE:
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
  jmp _if39_exit
_if39_exit:
; while (num > 0) { 
_while40_cond:
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
  je _while40_exit
_while40_block:
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
  jmp _while40_cond
_while40_exit:
; while (i > 0) { 
_while47_cond:
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
  je _while47_exit
_while47_block:
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
  jmp _while47_cond
_while47_exit:
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
; --- END TEXT SEGMENT

; --- BEGIN DATA SEGMENT
_s0: .db "\nassigning values...\n", 0
_s1: .db "printing assignments...\n", 0
_s2: .db "%c\n", 0
_s3: .db "%d\n", 0
_s4: .db "%u\n", 0
_s5: .db "checking results...\n", 0
_s6: .db "passed", 0
_s7: .db "failed", 0
_s8: .db "final test result: %s\n", 0
_s9: .db "Unexpected format in printf.", 0
_s10: .db "Error: Unknown argument type.\n", 0

_heap_top: .dw _heap
_heap: .db 0
; --- END DATA SEGMENT

.end
