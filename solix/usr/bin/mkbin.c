#include "lib/token.h"

char arg[512];

void main(){
  char *s;

  // Get filename string
  prog = 0x0000; // Beginning of arguments buffer
  s = arg;
  for(;;){
    if(*prog == '\0' || *prog == ';' || *prog == ' '){
      *s = '\0';
      break;
    }
    else{
      *s++ = *prog++;
    }
  }

  printf("> ");
  // Create binary file
  
  asm{
    ccmovd arg
    mov al, 6
    syscall sys_filesystem
  }

}