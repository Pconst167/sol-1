#include "stdio.h"
#include "token.h"


char *transient_area;

void cat(){
  prog = 0x0000;
  get();

  if(tok == GRATER_THAN){
    get();
    strcpy(transient_area + 1, token);
    asm{
      @transient_area
      add d, 512
      call gettxt
      @transient_area
      mov al, 5
      syscall sys_filesystem
    }
  }
  else{
    back();

    cmd_cat_read:
      call _putback
      call get_path
      mov d, tokstr
      mov di, transient_area
      mov al, 20
      syscall sys_filesystem				; read textfile into shell buffer
      mov d, transient_area
      call _puts					; print textfile to stdout
      call get_token
      mov al, [tok]
      cmp al, TOK_END
      je cmd_cat_end
      jmp cmd_cat_read
    cmd_cat_end:
      call _putback
      syscall sys_terminate_proc

  }
}


cmd_cat:
	mov a, 0
	mov [prog], a			; move tokennizer pointer to the beginning of the arguments area (address 0)
	call get_token

	cmp byte[tok], TOK_ANGLE
	je cmd_cat_write
cmd_cat_read:
	call _putback
	call get_path
	mov d, tokstr
	mov di, transient_area
	mov al, 20
	syscall sys_filesystem				; read textfile into shell buffer
	mov d, transient_area
	call _puts					; print textfile to stdout
	call get_token
	mov al, [tok]
	cmp al, TOK_END
	je cmd_cat_end
	jmp cmd_cat_read
cmd_cat_end:
	call _putback
	syscall sys_terminate_proc




transient_area:	

.end


