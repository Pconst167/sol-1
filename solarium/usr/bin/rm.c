#include "lib/stdio.h"
#include "lib/ctype.h"

void main(){
  char filename[64];
  char *p;
  char *prog;

  prog = 0;
  while(is_space(*prog)) prog++;
  for(;;){
    p = filename;
    while(*prog != ' ' && *prog != ';' && *prog) *p++ = *prog++;
    *p = '\0';
    if(*prog == ' ') prog++;
    asm{
      meta mov d, filename
      mov al, 10
      syscall sys_filesystem
    }
    if(*prog == ';' || !*prog){
      break;
    }
  }
}
