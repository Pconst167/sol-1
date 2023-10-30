.include "lib/kernel.exp"

.org text_org			; origin at 1024

cmd_man:
  mov d, s_telnet_clear
  call _puts
  mov a, 0
  mov [prog], a			; move tokennizer pointer to the beginning of the arguments area (address 0)
  call get_token
  mov al, [tok]
  cmp al, TOK_END
  je cmd_man_fail

  mov si, manpath
  mov di, temp_data
  call _strcpy        ; complete path with command name
  mov si, tokstr
  mov di, temp_data
  call _strcat        ; complete path with command name
  mov d, temp_data
  mov di, transient_area
  mov al, 20
  syscall sys_filesystem
  mov d, transient_area
  call _puts
  call printnl
cmd_man_fail:
	syscall sys_terminate_proc

manpath:  .db "/usr/share/man/", 0
temp_data: .fill 512, 0
s_fslash:  .db "/", 0

.include "lib/token.asm"
.include "lib/stdio.asm"
.include "lib/ctype.asm"

transient_area:

.end