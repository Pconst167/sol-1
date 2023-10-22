#include <stdio.h>

void main(){
  asm{
    mov al, 2
    syscall sys_io
  }
}
