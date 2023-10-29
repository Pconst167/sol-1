#include <stdio.h>

const char *shell_path = "/usr/bin0/shell";

void main(){
  printf("init process started.\n\r");
  printf("starting shell...\n\r");


  asm{
    meta mov d, shell_path
    mov d, [d]
    syscall sys_spawn_proc
  }

}