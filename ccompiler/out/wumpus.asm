; --- FILENAME: programs/wumpus.c
; --- DATE:     26-07-2025 at 17:28:21
.include "lib/asm/kernel.exp"
.include "lib/asm/bios.exp"

; --- BEGIN TEXT SEGMENT
.org text_org
main:
  mov bp, $FFE0 ;
  mov sp, $FFE0 ; Make space for argc(2 bytes) and for 10 pointers in argv (local variables)
; int c; 
  sub sp, 2
; c = getlet("INSTRUCTIONS (Y-N): "); 
  lea d, [bp + -1] ; $c
  push d
; --- START FUNCTION CALL
  mov b, _s0 ; "INSTRUCTIONS (Y-N): "
  swp b
  push b
  call getlet
  add sp, 2
; --- END FUNCTION CALL
  pop d
  mov [d], b
; if (c == 'Y') { 
_if1_cond:
  lea d, [bp + -1] ; $c
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000059
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if1_exit
_if1_TRUE:
; print_instructions(); 
; --- START FUNCTION CALL
  call print_instructions
  jmp _if1_exit
_if1_exit:
; do {  
_do2_block:
; game_setup(); 
; --- START FUNCTION CALL
  call game_setup
; game_play(); 
; --- START FUNCTION CALL
  call game_play
; } while (getlet("NEW GAME (Y-N): ") != 'N'); 
_do2_cond:
; --- START FUNCTION CALL
  mov b, _s1 ; "NEW GAME (Y-N): "
  swp b
  push b
  call getlet
  add sp, 2
; --- END FUNCTION CALL
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $0000004e
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
  cmp b, 1
  je _do2_block
_do2_exit:
; return 0; 
  mov32 cb, $00000000
  leave
  syscall sys_terminate_proc

getnum:
  enter 0 ; (push bp; mov bp, sp)
; int n; 
  sub sp, 2
; print(prompt); 
; --- START FUNCTION CALL
  lea d, [bp + 5] ; $prompt
  mov b, [d]
  mov c, 0
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; n = scann(); 
  lea d, [bp + -1] ; $n
  push d
; --- START FUNCTION CALL
  call scann
  pop d
  mov [d], b
; return n; 
  lea d, [bp + -1] ; $n
  mov b, [d]
  mov c, 0
  leave
  ret

getlet:
  enter 0 ; (push bp; mov bp, sp)
; char c = '\n'; 
  sub sp, 1
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + 0] ; $c
  push d
  mov32 cb, $0000000a
  pop d
  mov [d], bl
; --- END LOCAL VAR INITIALIZATION
; print(prompt); 
; --- START FUNCTION CALL
  lea d, [bp + 5] ; $prompt
  mov b, [d]
  mov c, 0
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; while (c == '\n') { 
_while3_cond:
  lea d, [bp + 0] ; $c
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
  je _while3_exit
_while3_block:
; c = getchar(); 
  lea d, [bp + 0] ; $c
  push d
; --- START FUNCTION CALL
  call getchar
  pop d
  mov [d], bl
  jmp _while3_cond
_while3_exit:
; return toupper(c); 
; --- START FUNCTION CALL
  lea d, [bp + 0] ; $c
  mov bl, [d]
  mov bh, 0
  mov c, 0
  push bl
  call toupper
  add sp, 1
; --- END FUNCTION CALL
  leave
  ret

print_instructions:
  enter 0 ; (push bp; mov bp, sp)
; print("\n\n"); 
; --- START FUNCTION CALL
  mov b, _s2 ; "\n\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; print("WELCOME TO HUNT THE WUMPUS\n"); 
; --- START FUNCTION CALL
  mov b, _s3 ; "WELCOME TO HUNT THE WUMPUS\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; print("THE WUMPUS LIVES IN A CAVE OF 20 ROOMS. EACH ROOM HAS 3 TUNNELS LEADING TO OTHER ROOMS.\n");  
; --- START FUNCTION CALL
  mov b, _s4 ; "THE WUMPUS LIVES IN A CAVE OF 20 ROOMS. EACH ROOM HAS 3 TUNNELS LEADING TO OTHER ROOMS.\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; print("LOOK AT A DODECAHEDRON TO SEE HOW THIS WORKS.\n\n"); 
; --- START FUNCTION CALL
  mov b, _s5 ; "LOOK AT A DODECAHEDRON TO SEE HOW THIS WORKS.\n\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; print(" HAZARDS:\n"); 
; --- START FUNCTION CALL
  mov b, _s6 ; " HAZARDS:\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; print(" BOTTOMLESS PITS: TWO ROOMS HAVE BOTTOMLESS PITS IN THEM. IF YOU GO THERE, YOU FALL INTO THE PIT (& LOSE!)\n"); 
; --- START FUNCTION CALL
  mov b, _s7 ; " BOTTOMLESS PITS: TWO ROOMS HAVE BOTTOMLESS PITS IN THEM. IF YOU GO THERE, YOU FALL INTO THE PIT (& LOSE!)\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; print(" SUPER BATS: TWO OTHER ROOMS HAVE SUPER BATS. IF YOU GO THERE, A BAT GRABS YOU AND TAKES YOU TO SOME OTHER\n"); 
; --- START FUNCTION CALL
  mov b, _s8 ; " SUPER BATS: TWO OTHER ROOMS HAVE SUPER BATS. IF YOU GO THERE, A BAT GRABS YOU AND TAKES YOU TO SOME OTHER\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; print("   ROOM AT RANDOM. (WHICH MAY BE TROUBLESOME)\n\n"); 
; --- START FUNCTION CALL
  mov b, _s9 ; "   ROOM AT RANDOM. (WHICH MAY BE TROUBLESOME)\n\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; print(" WUMPUS: THE WUMPUS IS NOT BOTHERED BY HAZARDS (HE HAS SUCKER FEET AND IS TOO BIG FOR A BAT TO LIFT).  USUALLY\n"); 
; --- START FUNCTION CALL
  mov b, _s10 ; " WUMPUS: THE WUMPUS IS NOT BOTHERED BY HAZARDS (HE HAS SUCKER FEET AND IS TOO BIG FOR A BAT TO LIFT).  USUALLY\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; print("   HE IS ASLEEP.  TWO THINGS WAKE HIM UP: YOU SHOOTING AN ARROW OR YOU ENTERING HIS ROOM.\n"); 
; --- START FUNCTION CALL
  mov b, _s11 ; "   HE IS ASLEEP.  TWO THINGS WAKE HIM UP: YOU SHOOTING AN ARROW OR YOU ENTERING HIS ROOM.\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; print("   IF THE WUMPUS WAKES HE MOVES (P=.75) ONE ROOM OR STAYS STILL (P=.25).  AFTER THAT, IF HE IS WHERE YOU\n"); 
; --- START FUNCTION CALL
  mov b, _s12 ; "   IF THE WUMPUS WAKES HE MOVES (P=.75) ONE ROOM OR STAYS STILL (P=.25).  AFTER THAT, IF HE IS WHERE YOU\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; print("   ARE, HE EATS YOU UP AND YOU LOSE!\n\n"); 
; --- START FUNCTION CALL
  mov b, _s13 ; "   ARE, HE EATS YOU UP AND YOU LOSE!\n\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; print(" YOU: EACH TURN YOU MAY MOVE OR SHOOT A CROOKED ARROW\n"); 
; --- START FUNCTION CALL
  mov b, _s14 ; " YOU: EACH TURN YOU MAY MOVE OR SHOOT A CROOKED ARROW\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; print(" MOVING: YOU CAN MOVE ONE ROOM (THRU ONE TUNNEL)\n"); 
; --- START FUNCTION CALL
  mov b, _s15 ; " MOVING: YOU CAN MOVE ONE ROOM (THRU ONE TUNNEL)\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; print(" ARROWS: YOU HAVE 5 ARROWS. YOU LOSE WHEN YOU RUN OUT\n"); 
; --- START FUNCTION CALL
  mov b, _s16 ; " ARROWS: YOU HAVE 5 ARROWS. YOU LOSE WHEN YOU RUN OUT\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; print("   EACH ARROW CAN GO FROM 1 TO 5 ROOMS. YOU AIM BY TELLING THE COMPUTER THE ROOM#S YOU WANT THE ARROW TO GO TO.\n"); 
; --- START FUNCTION CALL
  mov b, _s17 ; "   EACH ARROW CAN GO FROM 1 TO 5 ROOMS. YOU AIM BY TELLING THE COMPUTER THE ROOM#S YOU WANT THE ARROW TO GO TO.\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; print("   IF THE ARROW CANT GO THAT WAY (IF NO TUNNEL) IT MOVES AT RANDOM TO THE NEXT ROOM.\n"); 
; --- START FUNCTION CALL
  mov b, _s18 ; "   IF THE ARROW CANT GO THAT WAY (IF NO TUNNEL) IT MOVES AT RANDOM TO THE NEXT ROOM.\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; print("   IF THE ARROW HITS THE WUMPUS, YOU WIN.\n"); 
; --- START FUNCTION CALL
  mov b, _s19 ; "   IF THE ARROW HITS THE WUMPUS, YOU WIN.\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; print("   IF THE ARROW HITS YOU, YOU LOSE.\n"); 
; --- START FUNCTION CALL
  mov b, _s20 ; "   IF THE ARROW HITS YOU, YOU LOSE.\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; print(" WARNINGS: WHEN YOU ARE ONE ROOM AWAY FROM A WUMPUS OR HAZARD, THE COMPUTER SAYS:\n"); 
; --- START FUNCTION CALL
  mov b, _s21 ; " WARNINGS: WHEN YOU ARE ONE ROOM AWAY FROM A WUMPUS OR HAZARD, THE COMPUTER SAYS:\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; print("   WUMPUS: I SMELL A WUMPUS\n"); 
; --- START FUNCTION CALL
  mov b, _s22 ; "   WUMPUS: I SMELL A WUMPUS\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; print("   BAT: BATS NEARBY\n"); 
; --- START FUNCTION CALL
  mov b, _s23 ; "   BAT: BATS NEARBY\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; print("   PIT: I FEEL A DRAFT\n\n"); 
; --- START FUNCTION CALL
  mov b, _s24 ; "   PIT: I FEEL A DRAFT\n\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
  leave
  ret

show_room:
  enter 0 ; (push bp; mov bp, sp)
; int room, k; 
  sub sp, 2
  sub sp, 2
; print("\n"); 
; --- START FUNCTION CALL
  mov b, _s25 ; "\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; for (k = 0; k < 3; k++) { 
_for4_init:
  lea d, [bp + -3] ; $k
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
_for4_cond:
  lea d, [bp + -3] ; $k
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
  je _for4_exit
_for4_block:
; room = cave[loc[      0   ]][k]; 
  lea d, [bp + -1] ; $room
  push d
  mov d, _cave_data ; $cave
  push a
  push d
  mov d, _loc_data ; $loc
  push a
  push d
  mov32 cb, $00000000
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  pop d
  mma 6 ; mov a, 6; mul a, b; add d, b
  push d
  lea d, [bp + -3] ; $k
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
; if (room == loc[  1      ]) { 
_if5_cond:
  lea d, [bp + -1] ; $room
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov d, _loc_data ; $loc
  push a
  push d
  mov32 cb, $00000001
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if5_else
_if5_TRUE:
; print("I SMELL A WUMPUS!\n"); 
; --- START FUNCTION CALL
  mov b, _s26 ; "I SMELL A WUMPUS!\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
  jmp _if5_exit
_if5_else:
; if (room == loc[  2    ] || room == loc[  3    ]) { 
_if6_cond:
  lea d, [bp + -1] ; $room
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov d, _loc_data ; $loc
  push a
  push d
  mov32 cb, $00000002
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
; --- START LOGICAL OR
  push a
  mov a, b
  lea d, [bp + -1] ; $room
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov d, _loc_data ; $loc
  push a
  push d
  mov32 cb, $00000003
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  cmp b, 0
  je _if6_else
_if6_TRUE:
; print("I FEEL A DRAFT\n"); 
; --- START FUNCTION CALL
  mov b, _s27 ; "I FEEL A DRAFT\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
  jmp _if6_exit
_if6_else:
; if (room == loc[  4     ] || room == loc[  5     ]) { 
_if7_cond:
  lea d, [bp + -1] ; $room
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov d, _loc_data ; $loc
  push a
  push d
  mov32 cb, $00000004
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
; --- START LOGICAL OR
  push a
  mov a, b
  lea d, [bp + -1] ; $room
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov d, _loc_data ; $loc
  push a
  push d
  mov32 cb, $00000005
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  cmp b, 0
  je _if7_exit
_if7_TRUE:
; print("BATS NEARBY!\n"); 
; --- START FUNCTION CALL
  mov b, _s28 ; "BATS NEARBY!\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
  jmp _if7_exit
_if7_exit:
_if6_exit:
_if5_exit:
_for4_update:
  lea d, [bp + -3] ; $k
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -3] ; $k
  mov [d], b
  mov b, a
  jmp _for4_cond
_for4_exit:
; print("YOU ARE IN ROOM "); print_unsigned(loc[      0   ]+1); print("\n"); 
; --- START FUNCTION CALL
  mov b, _s29 ; "YOU ARE IN ROOM "
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; print_unsigned(loc[      0   ]+1); print("\n"); 
; --- START FUNCTION CALL
  mov d, _loc_data ; $loc
  push a
  push d
  mov32 cb, $00000000
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000001
  add b, a
  pop a
; --- END TERMS
  swp b
  push b
  call print_unsigned
  add sp, 2
; --- END FUNCTION CALL
; print("\n"); 
; --- START FUNCTION CALL
  mov b, _s25 ; "\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; print("TUNNELS LEAD TO ");  
; --- START FUNCTION CALL
  mov b, _s30 ; "TUNNELS LEAD TO "
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; print_unsigned(cave[loc[      0   ]][0]+1); print(", "); 
; --- START FUNCTION CALL
  mov d, _cave_data ; $cave
  push a
  push d
  mov d, _loc_data ; $loc
  push a
  push d
  mov32 cb, $00000000
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  pop d
  mma 6 ; mov a, 6; mul a, b; add d, b
  push d
  mov32 cb, $00000000
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000001
  add b, a
  pop a
; --- END TERMS
  swp b
  push b
  call print_unsigned
  add sp, 2
; --- END FUNCTION CALL
; print(", "); 
; --- START FUNCTION CALL
  mov b, _s31 ; ", "
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; print_unsigned(cave[loc[      0   ]][1]+1); print(", "); 
; --- START FUNCTION CALL
  mov d, _cave_data ; $cave
  push a
  push d
  mov d, _loc_data ; $loc
  push a
  push d
  mov32 cb, $00000000
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  pop d
  mma 6 ; mov a, 6; mul a, b; add d, b
  push d
  mov32 cb, $00000001
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000001
  add b, a
  pop a
; --- END TERMS
  swp b
  push b
  call print_unsigned
  add sp, 2
; --- END FUNCTION CALL
; print(", "); 
; --- START FUNCTION CALL
  mov b, _s31 ; ", "
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; print_unsigned(cave[loc[      0   ]][2]+1); 
; --- START FUNCTION CALL
  mov d, _cave_data ; $cave
  push a
  push d
  mov d, _loc_data ; $loc
  push a
  push d
  mov32 cb, $00000000
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  pop d
  mma 6 ; mov a, 6; mul a, b; add d, b
  push d
  mov32 cb, $00000002
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000001
  add b, a
  pop a
; --- END TERMS
  swp b
  push b
  call print_unsigned
  add sp, 2
; --- END FUNCTION CALL
; print("\n\n"); 
; --- START FUNCTION CALL
  mov b, _s2 ; "\n\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
  leave
  ret

move_or_shoot:
  enter 0 ; (push bp; mov bp, sp)
; int c = -1; 
  sub sp, 2
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -1] ; $c
  push d
  mov32 cb, $ffffffff
  pop d
  mov [d], b
; --- END LOCAL VAR INITIALIZATION
; while ((c != 'S') && (c != 'M')) { 
_while8_cond:
  lea d, [bp + -1] ; $c
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000053
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + -1] ; $c
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $0000004d
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  cmp b, 0
  je _while8_exit
_while8_block:
; c = getlet("SHOOT OR MOVE (S-M): "); 
  lea d, [bp + -1] ; $c
  push d
; --- START FUNCTION CALL
  mov b, _s32 ; "SHOOT OR MOVE (S-M): "
  swp b
  push b
  call getlet
  add sp, 2
; --- END FUNCTION CALL
  pop d
  mov [d], b
  jmp _while8_cond
_while8_exit:
; return (c == 'S') ? 1 : 0; 
_ternary9_cond:
  lea d, [bp + -1] ; $c
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000053
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _ternary9_FALSE
_ternary9_TRUE:
  mov32 cb, $00000001
  jmp _ternary9_exit
_ternary9_FALSE:
  mov32 cb, $00000000
_ternary9_exit:
  leave
  ret

move_wumpus:
  enter 0 ; (push bp; mov bp, sp)
; int k; 
  sub sp, 2
; k = rand2() % 4; 
  lea d, [bp + -1] ; $k
  push d
; --- START FUNCTION CALL
  call rand2
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $00000004
  push g ; save 'g' as the div instruction uses it
  div a, b ; %, a: quotient, b: remainder
  mov a, b
  pop g
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  pop d
  mov [d], b
; if (k < 3) { 
_if12_cond:
  lea d, [bp + -1] ; $k
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
  je _if12_exit
_if12_TRUE:
; loc[  1      ] = cave[loc[  1      ]][k]; 
  mov d, _loc_data ; $loc
  push a
  push d
  mov32 cb, $00000001
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov d, _cave_data ; $cave
  push a
  push d
  mov d, _loc_data ; $loc
  push a
  push d
  mov32 cb, $00000001
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  pop d
  mma 6 ; mov a, 6; mul a, b; add d, b
  push d
  lea d, [bp + -1] ; $k
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
  jmp _if12_exit
_if12_exit:
; if (loc[  1      ] == loc[      0   ]) { 
_if13_cond:
  mov d, _loc_data ; $loc
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
  mov d, _loc_data ; $loc
  push a
  push d
  mov32 cb, $00000000
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if13_exit
_if13_TRUE:
; print("TSK TSK TSK - WUMPUS GOT YOU!\n"); 
; --- START FUNCTION CALL
  mov b, _s33 ; "TSK TSK TSK - WUMPUS GOT YOU!\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; finished =   2    ; 
  mov d, _finished ; $finished
  push d
  mov32 cb, $00000002
  pop d
  mov [d], b
  jmp _if13_exit
_if13_exit:
  leave
  ret

shoot:
  enter 0 ; (push bp; mov bp, sp)
; int path[5]; 
  sub sp, 10
; int scratchloc = -1; 
  sub sp, 2
; --- START LOCAL VAR INITIALIZATION
  lea d, [bp + -11] ; $scratchloc
  push d
  mov32 cb, $ffffffff
  pop d
  mov [d], b
; --- END LOCAL VAR INITIALIZATION
; int len, k; 
  sub sp, 2
  sub sp, 2
; finished =        0   ; 
  mov d, _finished ; $finished
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
; len = -1; 
  lea d, [bp + -13] ; $len
  push d
  mov32 cb, $ffffffff
  pop d
  mov [d], b
; while (len < 1 || len > 5) { 
_while14_cond:
  lea d, [bp + -13] ; $len
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000001
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
; --- START LOGICAL OR
  push a
  mov a, b
  lea d, [bp + -13] ; $len
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000005
  cmp a, b
  sgt ; >
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  cmp b, 0
  je _while14_exit
_while14_block:
; len = getnum("\nNUMBER OF ROOMS (1-5): "); 
  lea d, [bp + -13] ; $len
  push d
; --- START FUNCTION CALL
  mov b, _s34 ; "\nNUMBER OF ROOMS (1-5): "
  swp b
  push b
  call getnum
  add sp, 2
; --- END FUNCTION CALL
  pop d
  mov [d], b
  jmp _while14_cond
_while14_exit:
; k = 0; 
  lea d, [bp + -15] ; $k
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
; while (k < len) { 
_while15_cond:
  lea d, [bp + -15] ; $k
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -13] ; $len
  mov b, [d]
  mov c, 0
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _while15_exit
_while15_block:
; path[k] = getnum("ROOM #") - 1; 
  lea d, [bp + -9] ; $path
  push a
  push d
  lea d, [bp + -15] ; $k
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
; --- START FUNCTION CALL
  mov b, _s35 ; "ROOM #"
  swp b
  push b
  call getnum
  add sp, 2
; --- END FUNCTION CALL
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000001
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; if ((k>1) && (path[k] == path[k - 2])) { 
_if16_cond:
  lea d, [bp + -15] ; $k
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000001
  cmp a, b
  sgt ; >
  pop a
; --- END RELATIONAL
; --- START LOGICAL AND
  push a
  mov a, b
  lea d, [bp + -9] ; $path
  push a
  push d
  lea d, [bp + -15] ; $k
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -9] ; $path
  push a
  push d
  lea d, [bp + -15] ; $k
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000002
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sand a, b
  pop a
; --- END LOGICAL AND
  cmp b, 0
  je _if16_exit
_if16_TRUE:
; print("ARROWS ARENT THAT CROOKED - TRY ANOTHER ROOM\n"); 
; --- START FUNCTION CALL
  mov b, _s36 ; "ARROWS ARENT THAT CROOKED - TRY ANOTHER ROOM\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; continue;  
  jmp _while15_cond ; while continue
  jmp _if16_exit
_if16_exit:
; k++; 
  lea d, [bp + -15] ; $k
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -15] ; $k
  mov [d], b
  mov b, a
  jmp _while15_cond
_while15_exit:
; scratchloc = loc[      0   ]; 
  lea d, [bp + -11] ; $scratchloc
  push d
  mov d, _loc_data ; $loc
  push a
  push d
  mov32 cb, $00000000
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
; for (k = 0; k < len; k++) { 
_for17_init:
  lea d, [bp + -15] ; $k
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
_for17_cond:
  lea d, [bp + -15] ; $k
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -13] ; $len
  mov b, [d]
  mov c, 0
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for17_exit
_for17_block:
; if ((cave[scratchloc][0] == path[k]) || 
_if18_cond:
  mov d, _cave_data ; $cave
  push a
  push d
  lea d, [bp + -11] ; $scratchloc
  mov b, [d]
  mov c, 0
  pop d
  mma 6 ; mov a, 6; mul a, b; add d, b
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
  lea d, [bp + -9] ; $path
  push a
  push d
  lea d, [bp + -15] ; $k
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
; --- START LOGICAL OR
  push a
  mov a, b
  mov d, _cave_data ; $cave
  push a
  push d
  lea d, [bp + -11] ; $scratchloc
  mov b, [d]
  mov c, 0
  pop d
  mma 6 ; mov a, 6; mul a, b; add d, b
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
  lea d, [bp + -9] ; $path
  push a
  push d
  lea d, [bp + -15] ; $k
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  mov a, b
  mov d, _cave_data ; $cave
  push a
  push d
  lea d, [bp + -11] ; $scratchloc
  mov b, [d]
  mov c, 0
  pop d
  mma 6 ; mov a, 6; mul a, b; add d, b
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
  lea d, [bp + -9] ; $path
  push a
  push d
  lea d, [bp + -15] ; $k
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  cmp b, 0
  je _if18_else
_if18_TRUE:
; scratchloc = path[k]; 
  lea d, [bp + -11] ; $scratchloc
  push d
  lea d, [bp + -9] ; $path
  push a
  push d
  lea d, [bp + -15] ; $k
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
  jmp _if18_exit
_if18_else:
; scratchloc = cave[scratchloc][rand2()%3]; 
  lea d, [bp + -11] ; $scratchloc
  push d
  mov d, _cave_data ; $cave
  push a
  push d
  lea d, [bp + -11] ; $scratchloc
  mov b, [d]
  mov c, 0
  pop d
  mma 6 ; mov a, 6; mul a, b; add d, b
  push d
; --- START FUNCTION CALL
  call rand2
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $00000003
  push g ; save 'g' as the div instruction uses it
  div a, b ; %, a: quotient, b: remainder
  mov a, b
  pop g
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
_if18_exit:
; if (scratchloc == loc[  1      ]) { 
_if23_cond:
  lea d, [bp + -11] ; $scratchloc
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov d, _loc_data ; $loc
  push a
  push d
  mov32 cb, $00000001
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if23_else
_if23_TRUE:
; print("AHA! YOU GOT THE WUMPUS!\n"); 
; --- START FUNCTION CALL
  mov b, _s37 ; "AHA! YOU GOT THE WUMPUS!\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; finished =        1   ; 
  mov d, _finished ; $finished
  push d
  mov32 cb, $00000001
  pop d
  mov [d], b
  jmp _if23_exit
_if23_else:
; if (scratchloc == loc[      0   ]) { 
_if24_cond:
  lea d, [bp + -11] ; $scratchloc
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov d, _loc_data ; $loc
  push a
  push d
  mov32 cb, $00000000
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if24_exit
_if24_TRUE:
; print("OUCH! ARROW GOT YOU!\n"); 
; --- START FUNCTION CALL
  mov b, _s38 ; "OUCH! ARROW GOT YOU!\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; finished =   2    ; 
  mov d, _finished ; $finished
  push d
  mov32 cb, $00000002
  pop d
  mov [d], b
  jmp _if24_exit
_if24_exit:
_if23_exit:
; if (finished !=        0   ) { 
_if25_cond:
  mov d, _finished ; $finished
  mov b, [d]
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
  je _if25_exit
_if25_TRUE:
; return; 
  leave
  ret
  jmp _if25_exit
_if25_exit:
_for17_update:
  lea d, [bp + -15] ; $k
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -15] ; $k
  mov [d], b
  mov b, a
  jmp _for17_cond
_for17_exit:
; print("MISSED\n"); 
; --- START FUNCTION CALL
  mov b, _s39 ; "MISSED\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; move_wumpus(); 
; --- START FUNCTION CALL
  call move_wumpus
; if (--arrows <= 0) { 
_if26_cond:
  mov d, _arrows ; $arrows
  mov b, [d]
  dec b
  mov d, _arrows ; $arrows
  mov [d], b
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000000
  cmp a, b
  sle ; <= (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if26_exit
_if26_TRUE:
; finished =   2    ; 
  mov d, _finished ; $finished
  push d
  mov32 cb, $00000002
  pop d
  mov [d], b
  jmp _if26_exit
_if26_exit:
  leave
  ret

move:
  enter 0 ; (push bp; mov bp, sp)
; int scratchloc; 
  sub sp, 2
; scratchloc = -1; 
  lea d, [bp + -1] ; $scratchloc
  push d
  mov32 cb, $ffffffff
  pop d
  mov [d], b
; while (scratchloc == -1) { 
_while27_cond:
  lea d, [bp + -1] ; $scratchloc
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $ffffffff
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _while27_exit
_while27_block:
; scratchloc = getnum("\nWHERE TO: ")- 1; 
  lea d, [bp + -1] ; $scratchloc
  push d
; --- START FUNCTION CALL
  mov b, _s40 ; "\nWHERE TO: "
  swp b
  push b
  call getnum
  add sp, 2
; --- END FUNCTION CALL
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000001
  sub a, b
  mov b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; if (scratchloc < 0 || scratchloc > 19) { 
_if28_cond:
  lea d, [bp + -1] ; $scratchloc
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
; --- START LOGICAL OR
  push a
  mov a, b
  lea d, [bp + -1] ; $scratchloc
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000013
  cmp a, b
  sgt ; >
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  cmp b, 0
  je _if28_exit
_if28_TRUE:
; scratchloc = -1; 
  lea d, [bp + -1] ; $scratchloc
  push d
  mov32 cb, $ffffffff
  pop d
  mov [d], b
; continue; 
  jmp _while27_cond ; while continue
  jmp _if28_exit
_if28_exit:
; if ((cave[loc[      0   ]][0] != scratchloc) & 
_if29_cond:
  mov d, _cave_data ; $cave
  push a
  push d
  mov d, _loc_data ; $loc
  push a
  push d
  mov32 cb, $00000000
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  pop d
  mma 6 ; mov a, 6; mul a, b; add d, b
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
  lea d, [bp + -1] ; $scratchloc
  mov b, [d]
  mov c, 0
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
  push a
  mov a, b
  mov d, _cave_data ; $cave
  push a
  push d
  mov d, _loc_data ; $loc
  push a
  push d
  mov32 cb, $00000000
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  pop d
  mma 6 ; mov a, 6; mul a, b; add d, b
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
  lea d, [bp + -1] ; $scratchloc
  mov b, [d]
  mov c, 0
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
  and b, a ; &
  mov a, b
  mov d, _cave_data ; $cave
  push a
  push d
  mov d, _loc_data ; $loc
  push a
  push d
  mov32 cb, $00000000
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  pop d
  mma 6 ; mov a, 6; mul a, b; add d, b
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
  lea d, [bp + -1] ; $scratchloc
  mov b, [d]
  mov c, 0
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
  and b, a ; &
  mov a, b
  mov d, _loc_data ; $loc
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
  lea d, [bp + -1] ; $scratchloc
  mov b, [d]
  mov c, 0
  cmp a, b
  sneq ; !=
  pop a
; --- END RELATIONAL
  and b, a ; &
  pop a
  cmp b, 0
  je _if29_exit
_if29_TRUE:
; print("NOT POSSIBLE\n"); 
; --- START FUNCTION CALL
  mov b, _s41 ; "NOT POSSIBLE\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; scratchloc = -1; 
  lea d, [bp + -1] ; $scratchloc
  push d
  mov32 cb, $ffffffff
  pop d
  mov [d], b
; continue; 
  jmp _while27_cond ; while continue
  jmp _if29_exit
_if29_exit:
  jmp _while27_cond
_while27_exit:
; loc[      0   ] = scratchloc; 
  mov d, _loc_data ; $loc
  push a
  push d
  mov32 cb, $00000000
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  lea d, [bp + -1] ; $scratchloc
  mov b, [d]
  mov c, 0
  pop d
  mov [d], b
; while ((scratchloc == loc[  4     ]) || (scratchloc == loc[  5     ])) { 
_while30_cond:
  lea d, [bp + -1] ; $scratchloc
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov d, _loc_data ; $loc
  push a
  push d
  mov32 cb, $00000004
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
; --- START LOGICAL OR
  push a
  mov a, b
  lea d, [bp + -1] ; $scratchloc
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov d, _loc_data ; $loc
  push a
  push d
  mov32 cb, $00000005
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  cmp b, 0
  je _while30_exit
_while30_block:
; print("ZAP--SUPER BAT SNATCH! ELSEWHEREVILLE FOR YOU!\n"); 
; --- START FUNCTION CALL
  mov b, _s42 ; "ZAP--SUPER BAT SNATCH! ELSEWHEREVILLE FOR YOU!\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; scratchloc = loc[      0   ] = rand2()%20; 
  lea d, [bp + -1] ; $scratchloc
  push d
  mov d, _loc_data ; $loc
  push a
  push d
  mov32 cb, $00000000
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
; --- START FUNCTION CALL
  call rand2
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $00000014
  push g ; save 'g' as the div instruction uses it
  div a, b ; %, a: quotient, b: remainder
  mov a, b
  pop g
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  pop d
  mov [d], b
  pop d
  mov [d], b
  jmp _while30_cond
_while30_exit:
; if (scratchloc == loc[  1      ]) { 
_if33_cond:
  lea d, [bp + -1] ; $scratchloc
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov d, _loc_data ; $loc
  push a
  push d
  mov32 cb, $00000001
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if33_exit
_if33_TRUE:
; print("... OOPS! BUMPED A WUMPUS!\n"); 
; --- START FUNCTION CALL
  mov b, _s43 ; "... OOPS! BUMPED A WUMPUS!\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; move_wumpus(); 
; --- START FUNCTION CALL
  call move_wumpus
  jmp _if33_exit
_if33_exit:
; if (scratchloc == loc[  2    ] || scratchloc == loc[  3    ]) { 
_if34_cond:
  lea d, [bp + -1] ; $scratchloc
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov d, _loc_data ; $loc
  push a
  push d
  mov32 cb, $00000002
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
; --- START LOGICAL OR
  push a
  mov a, b
  lea d, [bp + -1] ; $scratchloc
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov d, _loc_data ; $loc
  push a
  push d
  mov32 cb, $00000003
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  sor a, b ; ||
  pop a
; --- END LOGICAL OR
  cmp b, 0
  je _if34_exit
_if34_TRUE:
; print("YYYYIIIIEEEE . . . FELL IN PIT\n"); 
; --- START FUNCTION CALL
  mov b, _s44 ; "YYYYIIIIEEEE . . . FELL IN PIT\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; finished =   2    ; 
  mov d, _finished ; $finished
  push d
  mov32 cb, $00000002
  pop d
  mov [d], b
  jmp _if34_exit
_if34_exit:
  leave
  ret

rand2:
  enter 0 ; (push bp; mov bp, sp)
; rand_val=rand_val+rand_inc; 
  mov d, _rand_val ; $rand_val
  push d
  mov d, _rand_val ; $rand_val
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov d, _rand_inc ; $rand_inc
  mov b, [d]
  mov c, 0
  add b, a
  pop a
; --- END TERMS
  pop d
  mov [d], b
; rand_inc++; 
  mov d, _rand_inc ; $rand_inc
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  mov d, _rand_inc ; $rand_inc
  mov [d], b
  mov b, a
; return rand_val; 
  mov d, _rand_val ; $rand_val
  mov b, [d]
  mov c, 0
  leave
  ret

game_setup:
  enter 0 ; (push bp; mov bp, sp)
; int j, k; 
  sub sp, 2
  sub sp, 2
; int v; 
  sub sp, 2
; for (j = 0; j <   6    ; j++) { 
_for35_init:
  lea d, [bp + -1] ; $j
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
_for35_cond:
  lea d, [bp + -1] ; $j
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000006
  cmp a, b
  slt ; < (signed)
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _for35_exit
_for35_block:
; loc[j] = -1; 
  mov d, _loc_data ; $loc
  push a
  push d
  lea d, [bp + -1] ; $j
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov32 cb, $ffffffff
  pop d
  mov [d], b
; while (loc[j] < 0) { 
_while36_cond:
  mov d, _loc_data ; $loc
  push a
  push d
  lea d, [bp + -1] ; $j
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
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
  je _while36_exit
_while36_block:
; v = rand2(); 
  lea d, [bp + -5] ; $v
  push d
; --- START FUNCTION CALL
  call rand2
  pop d
  mov [d], b
; loc[j] = v % 20; 
  mov d, _loc_data ; $loc
  push a
  push d
  lea d, [bp + -1] ; $j
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  lea d, [bp + -5] ; $v
  mov b, [d]
  mov c, 0
; --- START FACTORS
  push a
  push g
  mov a, b
  mov g, c
  mov32 cb, $00000014
  push g ; save 'g' as the div instruction uses it
  div a, b ; %, a: quotient, b: remainder
  mov a, b
  pop g
  mov c, g
  mov b, a
  pop g
  pop a
; --- END FACTORS
  pop d
  mov [d], b
; for (k=0; k < j - 1; k++) { 
_for39_init:
  lea d, [bp + -3] ; $k
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
_for39_cond:
  lea d, [bp + -3] ; $k
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  lea d, [bp + -1] ; $j
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
  je _for39_exit
_for39_block:
; if (loc[j] == loc[k]) { 
_if40_cond:
  mov d, _loc_data ; $loc
  push a
  push d
  lea d, [bp + -1] ; $j
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov d, _loc_data ; $loc
  push a
  push d
  lea d, [bp + -3] ; $k
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if40_exit
_if40_TRUE:
; loc[j] = -1; 
  mov d, _loc_data ; $loc
  push a
  push d
  lea d, [bp + -1] ; $j
  mov b, [d]
  mov c, 0
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  push d
  mov32 cb, $ffffffff
  pop d
  mov [d], b
  jmp _if40_exit
_if40_exit:
_for39_update:
  lea d, [bp + -3] ; $k
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -3] ; $k
  mov [d], b
  mov b, a
  jmp _for39_cond
_for39_exit:
  jmp _while36_cond
_while36_exit:
_for35_update:
  lea d, [bp + -1] ; $j
  mov b, [d]
  mov c, 0
  mov a, b
  inc b
  lea d, [bp + -1] ; $j
  mov [d], b
  mov b, a
  jmp _for35_cond
_for35_exit:
  leave
  ret

game_play:
  enter 0 ; (push bp; mov bp, sp)
; arrows = 5; 
  mov d, _arrows ; $arrows
  push d
  mov32 cb, $00000005
  pop d
  mov [d], b
; print("*********************\n"); 
; --- START FUNCTION CALL
  mov b, _s45 ; "*********************\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; print("** HUNT THE WUMPUS **\n"); 
; --- START FUNCTION CALL
  mov b, _s46 ; "** HUNT THE WUMPUS **\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; print("*********************\n"); 
; --- START FUNCTION CALL
  mov b, _s45 ; "*********************\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; if (debug) { 
_if41_cond:
  mov d, _debug ; $debug
  mov b, [d]
  mov c, 0
  cmp b, 0
  je _if41_exit
_if41_TRUE:
; print("Wumpus is at "); print_unsigned(loc[  1      ]+1); 
; --- START FUNCTION CALL
  mov b, _s47 ; "Wumpus is at "
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; print_unsigned(loc[  1      ]+1); 
; --- START FUNCTION CALL
  mov d, _loc_data ; $loc
  push a
  push d
  mov32 cb, $00000001
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000001
  add b, a
  pop a
; --- END TERMS
  swp b
  push b
  call print_unsigned
  add sp, 2
; --- END FUNCTION CALL
; print(", pits at "); print_unsigned(loc[  2    ]+1); 
; --- START FUNCTION CALL
  mov b, _s48 ; ", pits at "
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; print_unsigned(loc[  2    ]+1); 
; --- START FUNCTION CALL
  mov d, _loc_data ; $loc
  push a
  push d
  mov32 cb, $00000002
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000001
  add b, a
  pop a
; --- END TERMS
  swp b
  push b
  call print_unsigned
  add sp, 2
; --- END FUNCTION CALL
; print(" & "); print_unsigned(loc[  3    ]+1); 
; --- START FUNCTION CALL
  mov b, _s49 ; " & "
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; print_unsigned(loc[  3    ]+1); 
; --- START FUNCTION CALL
  mov d, _loc_data ; $loc
  push a
  push d
  mov32 cb, $00000003
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000001
  add b, a
  pop a
; --- END TERMS
  swp b
  push b
  call print_unsigned
  add sp, 2
; --- END FUNCTION CALL
; print(", bats at "); print_unsigned(loc[  4     ]+1); 
; --- START FUNCTION CALL
  mov b, _s50 ; ", bats at "
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; print_unsigned(loc[  4     ]+1); 
; --- START FUNCTION CALL
  mov d, _loc_data ; $loc
  push a
  push d
  mov32 cb, $00000004
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000001
  add b, a
  pop a
; --- END TERMS
  swp b
  push b
  call print_unsigned
  add sp, 2
; --- END FUNCTION CALL
; print(" & "); print_unsigned(loc[  5     ]+1); 
; --- START FUNCTION CALL
  mov b, _s49 ; " & "
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
; print_unsigned(loc[  5     ]+1); 
; --- START FUNCTION CALL
  mov d, _loc_data ; $loc
  push a
  push d
  mov32 cb, $00000005
  pop d
  mma 2 ; mov a, 2; mul a, b; add d, b
  pop a
  mov b, [d]
  mov c, 0
; --- START TERMS
  push a
  mov a, b
  mov32 cb, $00000001
  add b, a
  pop a
; --- END TERMS
  swp b
  push b
  call print_unsigned
  add sp, 2
; --- END FUNCTION CALL
  jmp _if41_exit
_if41_exit:
; finished =        0   ; 
  mov d, _finished ; $finished
  push d
  mov32 cb, $00000000
  pop d
  mov [d], b
; while (finished ==        0   ) { 
_while42_cond:
  mov d, _finished ; $finished
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
  je _while42_exit
_while42_block:
; show_room(); 
; --- START FUNCTION CALL
  call show_room
; if (move_or_shoot()) { 
_if43_cond:
; --- START FUNCTION CALL
  call move_or_shoot
  cmp b, 0
  je _if43_else
_if43_TRUE:
; shoot(); 
; --- START FUNCTION CALL
  call shoot
  jmp _if43_exit
_if43_else:
; move(); 
; --- START FUNCTION CALL
  call move
_if43_exit:
  jmp _while42_cond
_while42_exit:
; if (finished ==        1   ) { 
_if44_cond:
  mov d, _finished ; $finished
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000001
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if44_exit
_if44_TRUE:
; print("HEE HEE HEE - THE WUMPUS WILL GET YOU NEXT TIME!!\n"); 
; --- START FUNCTION CALL
  mov b, _s51 ; "HEE HEE HEE - THE WUMPUS WILL GET YOU NEXT TIME!!\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
  jmp _if44_exit
_if44_exit:
; if (finished ==   2    ) { 
_if45_cond:
  mov d, _finished ; $finished
  mov b, [d]
  mov c, 0
; --- START RELATIONAL
  push a
  mov a, b
  mov32 cb, $00000002
  cmp a, b
  seq ; ==
  pop a
; --- END RELATIONAL
  cmp b, 0
  je _if45_exit
_if45_TRUE:
; print("HA HA HA - YOU LOSE!\n"); 
; --- START FUNCTION CALL
  mov b, _s52 ; "HA HA HA - YOU LOSE!\n"
  swp b
  push b
  call print
  add sp, 2
; --- END FUNCTION CALL
  jmp _if45_exit
_if45_exit:
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

getchar:
  enter 0 ; (push bp; mov bp, sp)
; char c; 
  sub sp, 1
; --- BEGIN INLINE ASM SEGMENT
  mov al, 1
  syscall sys_io      ; receive in AH
  mov al, ah
  lea d, [bp + 0] ; $c
  mov [d], al
; --- END INLINE ASM SEGMENT
; return c; 
  lea d, [bp + 0] ; $c
  mov bl, [d]
  mov bh, 0
  mov c, 0
  leave
  ret

toupper:
  enter 0 ; (push bp; mov bp, sp)
; if (ch >= 'a' && ch <= 'z')  
_if46_cond:
  lea d, [bp + 5] ; $ch
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
  lea d, [bp + 5] ; $ch
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
  je _if46_else
_if46_TRUE:
; return ch - 'a' + 'A'; 
  lea d, [bp + 5] ; $ch
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
  mov32 cb, $00000041
  add b, a
  pop a
; --- END TERMS
  leave
  ret
  jmp _if46_exit
_if46_else:
; return ch; 
  lea d, [bp + 5] ; $ch
  mov bl, [d]
  mov bh, 0
  mov c, 0
  leave
  ret
_if46_exit:
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
_if47_cond:
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
  je _if47_exit
_if47_TRUE:
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
  jmp _if47_exit
_if47_exit:
; while (num > 0) { 
_while48_cond:
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
  je _while48_exit
_while48_block:
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
  jmp _while48_cond
_while48_exit:
; while (i > 0) { 
_while55_cond:
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
  je _while55_exit
_while55_block:
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
  jmp _while55_cond
_while55_exit:
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

scann:
  enter 0 ; (push bp; mov bp, sp)
; int m; 
  sub sp, 2
; --- BEGIN INLINE ASM SEGMENT
  enter 8
  lea d, [bp +- 7]
  call _gets_scann
  call _strlen_scann      ; get string length in C
  dec c
  mov si, d
  mov a, c
  shl a
  mov d, table_power_scann
  add d, a
  mov c, 0
mul_loop_scann:
  lodsb      ; load ASCII to al
  cmp al, 0
  je mul_exit_scann
  sub al, $30    ; make into integer
  mov ah, 0
  mov b, [d]
  mul a, b      ; result in B since it fits in 16bits
  mov a, b
  mov b, c
  add a, b
  mov c, a
  sub d, 2
  jmp mul_loop_scann
mul_exit_scann:
  mov a, c
  leave
  lea d, [bp + -1] ; $m
  mov [d], a
; --- END INLINE ASM SEGMENT
; return m; 
  lea d, [bp + -1] ; $m
  mov b, [d]
  mov c, 0
  leave
  ret
; --- BEGIN INLINE ASM SEGMENT
_strlen_scann:
  push d
  mov c, 0
_strlen_L1_scann:
  cmp byte [d], 0
  je _strlen_ret_scann
  inc d
  inc c
  jmp _strlen_L1_scann
_strlen_ret_scann:
  pop d
  ret
_gets_scann:
  push d
_gets_loop_scann:
  mov al, 1
  syscall sys_io      ; receive in AH
  cmp al, 0        ; check error code (AL)
  je _gets_loop_scann      ; if no char received, retry
  cmp ah, 27
  je _gets_ansi_esc_scann
  cmp ah, $0A        ; LF
  je _gets_end_scann
  cmp ah, $0D        ; CR
  je _gets_end_scann
  cmp ah, $5C        ; '\\'
  je _gets_escape_scann
  cmp ah, $08      ; check for backspace
  je _gets_backspace_scann
  mov al, ah
  mov [d], al
  inc d
  jmp _gets_loop_scann
_gets_backspace_scann:
  dec d
  jmp _gets_loop_scann
_gets_ansi_esc_scann:
  mov al, 1
  syscall sys_io        ; receive in AH without echo
  cmp al, 0          ; check error code (AL)
  je _gets_ansi_esc_scann    ; if no char received, retry
  cmp ah, '['
  jne _gets_loop_scann
_gets_ansi_esc_2_scann:
  mov al, 1
  syscall sys_io          ; receive in AH without echo
  cmp al, 0            ; check error code (AL)
  je _gets_ansi_esc_2_scann  ; if no char received, retry
  cmp ah, 'D'
  je _gets_left_arrow_scann
  cmp ah, 'C'
  je _gets_right_arrow_scann
  jmp _gets_loop_scann
_gets_left_arrow_scann:
  dec d
  jmp _gets_loop_scann
_gets_right_arrow_scann:
  inc d
  jmp _gets_loop_scann
_gets_escape_scann:
  mov al, 1
  syscall sys_io      ; receive in AH
  cmp al, 0        ; check error code (AL)
  je _gets_escape_scann      ; if no char received, retry
  cmp ah, 'n'
  je _gets_LF_scann
  cmp ah, 'r'
  je _gets_CR_scann
  cmp ah, '0'
  je _gets_NULL_scann
  cmp ah, $5C  
  je _gets_slash_scann
  mov al, ah        ; if not a known escape, it is just a normal letter
  mov [d], al
  inc d
  jmp _gets_loop_scann
_gets_slash_scann:
  mov al, $5C
  mov [d], al
  inc d
  jmp _gets_loop_scann
_gets_LF_scann:
  mov al, $0A
  mov [d], al
  inc d
  jmp _gets_loop_scann
_gets_CR_scann:
  mov al, $0D
  mov [d], al
  inc d
  jmp _gets_loop_scann
_gets_NULL_scann:
  mov al, $00
  mov [d], al
  inc d
  jmp _gets_loop_scann
_gets_end_scann:
  mov al, 0
  mov [d], al        ; terminate string
  pop d
  ret
table_power_scann:
.dw 1              ; 1
.dw $A             ; 10
.dw $64            ; 100
.dw $3E8           ; 1000
.dw $2710          ; 10000
.dw $86A0, $1      ; 100000
.dw $4240, $F      ; 1000000
.dw $9680, $98     ; 10000000
.dw $E100, $5F5    ; 100000000
.dw $CA00, $3B9A   ; 1000000000
; --- END INLINE ASM SEGMENT
  leave
  ret
; --- END TEXT SEGMENT

; --- BEGIN DATA SEGMENT
_arrows: .fill 2, 0
_debug: .dw $0000
_rand_val: .dw $001d
_rand_inc: .dw $0001
_loc_data: .fill 12, 0
_finished: .fill 2, 0
_cave_data: .dw $0001,$0004,$0007,$0000,$0002,$0009,$0001,$0003,$000b,$0002,$0004,$000d,$0000,$0003,$0005,
.dw 
.dw 
.dw $0004,$0006,$000e,$0005,$0007,$0010,$0000,$0006,$0008,$0007,$0009,$0011,$0001,$0008,$000a,$0009,
.dw $000b,$0012,$0002,$000a,$000c,$000b,$000d,$0013,$0003,$000c,$000e,$0005,$000d,$000f,$000e,$0010,
.dw $0013,$0006,$000f,$0011,$0008,$0010,$0012,$000a,$0011,$0013,$000c,$000f,$0012,
_s0: .db "INSTRUCTIONS (Y-N): ", 0
_s1: .db "NEW GAME (Y-N): ", 0
_s2: .db "\n\n", 0
_s3: .db "WELCOME TO HUNT THE WUMPUS\n", 0
_s4: .db "THE WUMPUS LIVES IN A CAVE OF 20 ROOMS. EACH ROOM HAS 3 TUNNELS LEADING TO OTHER ROOMS.\n", 0
_s5: .db "LOOK AT A DODECAHEDRON TO SEE HOW THIS WORKS.\n\n", 0
_s6: .db " HAZARDS:\n", 0
_s7: .db " BOTTOMLESS PITS: TWO ROOMS HAVE BOTTOMLESS PITS IN THEM. IF YOU GO THERE, YOU FALL INTO THE PIT (& LOSE!)\n", 0
_s8: .db " SUPER BATS: TWO OTHER ROOMS HAVE SUPER BATS. IF YOU GO THERE, A BAT GRABS YOU AND TAKES YOU TO SOME OTHER\n", 0
_s9: .db "   ROOM AT RANDOM. (WHICH MAY BE TROUBLESOME)\n\n", 0
_s10: .db " WUMPUS: THE WUMPUS IS NOT BOTHERED BY HAZARDS (HE HAS SUCKER FEET AND IS TOO BIG FOR A BAT TO LIFT).  USUALLY\n", 0
_s11: .db "   HE IS ASLEEP.  TWO THINGS WAKE HIM UP: YOU SHOOTING AN ARROW OR YOU ENTERING HIS ROOM.\n", 0
_s12: .db "   IF THE WUMPUS WAKES HE MOVES (P=.75) ONE ROOM OR STAYS STILL (P=.25).  AFTER THAT, IF HE IS WHERE YOU\n", 0
_s13: .db "   ARE, HE EATS YOU UP AND YOU LOSE!\n\n", 0
_s14: .db " YOU: EACH TURN YOU MAY MOVE OR SHOOT A CROOKED ARROW\n", 0
_s15: .db " MOVING: YOU CAN MOVE ONE ROOM (THRU ONE TUNNEL)\n", 0
_s16: .db " ARROWS: YOU HAVE 5 ARROWS. YOU LOSE WHEN YOU RUN OUT\n", 0
_s17: .db "   EACH ARROW CAN GO FROM 1 TO 5 ROOMS. YOU AIM BY TELLING THE COMPUTER THE ROOM#S YOU WANT THE ARROW TO GO TO.\n", 0
_s18: .db "   IF THE ARROW CANT GO THAT WAY (IF NO TUNNEL) IT MOVES AT RANDOM TO THE NEXT ROOM.\n", 0
_s19: .db "   IF THE ARROW HITS THE WUMPUS, YOU WIN.\n", 0
_s20: .db "   IF THE ARROW HITS YOU, YOU LOSE.\n", 0
_s21: .db " WARNINGS: WHEN YOU ARE ONE ROOM AWAY FROM A WUMPUS OR HAZARD, THE COMPUTER SAYS:\n", 0
_s22: .db "   WUMPUS: I SMELL A WUMPUS\n", 0
_s23: .db "   BAT: BATS NEARBY\n", 0
_s24: .db "   PIT: I FEEL A DRAFT\n\n", 0
_s25: .db "\n", 0
_s26: .db "I SMELL A WUMPUS!\n", 0
_s27: .db "I FEEL A DRAFT\n", 0
_s28: .db "BATS NEARBY!\n", 0
_s29: .db "YOU ARE IN ROOM ", 0
_s30: .db "TUNNELS LEAD TO ", 0
_s31: .db ", ", 0
_s32: .db "SHOOT OR MOVE (S-M): ", 0
_s33: .db "TSK TSK TSK - WUMPUS GOT YOU!\n", 0
_s34: .db "\nNUMBER OF ROOMS (1-5): ", 0
_s35: .db "ROOM #", 0
_s36: .db "ARROWS ARENT THAT CROOKED - TRY ANOTHER ROOM\n", 0
_s37: .db "AHA! YOU GOT THE WUMPUS!\n", 0
_s38: .db "OUCH! ARROW GOT YOU!\n", 0
_s39: .db "MISSED\n", 0
_s40: .db "\nWHERE TO: ", 0
_s41: .db "NOT POSSIBLE\n", 0
_s42: .db "ZAP--SUPER BAT SNATCH! ELSEWHEREVILLE FOR YOU!\n", 0
_s43: .db "... OOPS! BUMPED A WUMPUS!\n", 0
_s44: .db "YYYYIIIIEEEE . . . FELL IN PIT\n", 0
_s45: .db "*********************\n", 0
_s46: .db "** HUNT THE WUMPUS **\n", 0
_s47: .db "Wumpus is at ", 0
_s48: .db ", pits at ", 0
_s49: .db " & ", 0
_s50: .db ", bats at ", 0
_s51: .db "HEE HEE HEE - THE WUMPUS WILL GET YOU NEXT TIME!!\n", 0
_s52: .db "HA HA HA - YOU LOSE!\n", 0

_heap_top: .dw _heap
_heap: .db 0
; --- END DATA SEGMENT

.end
