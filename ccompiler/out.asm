; --- FILENAME: test.c
; --- DATE:     13-12-2025 at 17:40:20
.include "lib/asm/kernel.exp"
.include "lib/asm/bios.exp"

; --- BEGIN TEXT SEGMENT
.org text_org
main:
  mov bp, $FFE0 ;
  mov sp, $FFE0 ; Make space for argc(2 bytes) and for 10 pointers in argv (local variables)
; int i; 
  sub sp, 2
; i--; 
  lea d, [bp + -1] ; $i
  mov b, [d]
  mov c, 0
  mov a, b
  dec b
  mov [d], b
  mov b, a
  syscall sys_terminate_proc
; --- END TEXT SEGMENT

; --- BEGIN DATA SEGMENT

_heap_top: .dw _heap
_heap: .db 0
; --- END DATA SEGMENT

.end
