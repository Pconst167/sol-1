#include "lib/token.h"

char filename[64];
char *content;

void main(){
  char *s;

  content = alloc(16900); // 1024 * 16 + 512

  // Get filename string
  prog = 0x0000; // Beginning of filenameuments buffer
  s = filename;
  for(;;){
    if(*prog == '\0' || *prog == ';' || *prog == ' '){
      *s = '\0';
      break;
    }
    else{
      *s++ = *prog++;
    }
  }

  strcpy(content + 1, filename);

  asm{
    mov a, [_content]
    mov d, a
    add d, 512
    call _gettxt
    
    mov a, [_content]
    mov d, a
    add d, 1

    mov a, [_content]
    mov d, a
    mov al, 5
    syscall sys_filesystem
  }

}