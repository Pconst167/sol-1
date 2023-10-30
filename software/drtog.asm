.include "lib/kernel.exp"

.org text_org			; origin at 1024

; Toggle state of register writing flag
drtog:
  lodstat
  xor al, %00100000
  stostat
  shr al, 5
  and al, %00000001
  call print_number
  call printnl
  syscall sys_terminate_proc


.include "lib/stdio.asm"

.end


