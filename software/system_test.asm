.include "lib/kernel.exp"
.org text_org

; --- BEGIN TEXT BLOCK
; FFC0    5.25" Floppy Drive Block
;   - FFC0  (Last 4 bits: 0000)    Output Port (377 Flip-Flop)                       Note: A3 Address line is 0
;   - FFC1  (Last 4 bits: 0001)    Input Port  (244 Buffer)                          Note: A3 Address line is 0
;   - FFC8  (Last 4 bits: 1000)    FDC         (WD1770 Floppy Drive Controller)      Note: A3 Address line is 1
main:
  mov bp, $FFFF
  mov sp, $FFFF

  mov d, s_irq1
  call _puts
  call print_u8x        ; print irq event
  call printnl

  syscall sys_terminate_proc

s_irq1: .db "\nvalue of fdc irq: ", 0

.include "lib/stdio.asm"
.end
