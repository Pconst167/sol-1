#include <token.h>

char *address;
char data;

void main(){
  prog = 0;

  get();
  address = atoi(token);
  get();
  data = atoi(token);

  asm{
    mov al, 2     ; setparam
    mov d, _address
    mov d, [d]
    mov bl, [_data]
    syscall sys_system
  }
}
