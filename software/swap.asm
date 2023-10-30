.include "lib/kernel.exp"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.org text_org			; origin at 1024

; when running the installer, we need to be inside /boot because the mkbin system call
; creates all binary files inside whatever is the current directory
; and we want the kernel to live inside /boot
bootloader_installer:
  mov d, s_enter_filename
  call _puts
  mov d, kernel_filename
  call _gets

  mov si, kernel_filename
  mov di, kernel_fullpath
  call _strcat             ; form full pathname for the kernel file
	mov d, kernel_fullpath
	mov al, 19
	syscall sys_filesystem		; obtain dirID for kernel file, in A
	inc a					; increment LBA because data starts after the header sector

  mov b, a
  mov al, 3
	syscall sys_system
	syscall sys_terminate_proc




s_enter_filename:  .db "Kernel filename: ", 0
kernel_filename:   .fill 64, 0
kernel_fullpath:   .db "/boot/"
                   .fill 64, 0

.include "lib/stdio.asm"


.end



