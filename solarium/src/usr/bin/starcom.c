#include "lib/token.h"

char filename[64];
int size;
char *data;

void main()
{
  data = alloc(16384);

  print("\nStarcom 1.0\n");
  get(); // get filename
  if(toktype == END){
    print("\nusage: starcom <filename> <size>\n");
    exit();
  }
  strcpy(data, token);
  get(); // get size
  if(toktype == END){
    print("\nusage: starcom <filename> <size>\n");
    exit();
  }
  size = atoi(token);

  print("\nOK. Start transfer now.\n");

  // Create binary file
  asm{
    mov b, [_size] 
    meta mov d, data
    mov d, [d]
    add d, 512
    call _load_binary
  }
  print("\nBinary data loaded successfully. Now creating your file...\n");
  asm{
    meta mov d, data
    mov d, [d]
    mov a, [_size]
    mov c, a
    mov al, 11        ; starcom
    syscall sys_filesystem
  }

}