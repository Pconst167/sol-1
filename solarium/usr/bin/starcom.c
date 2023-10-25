#include "lib/token.h"

char filename[64];
int size;
char data[128];

void main(){
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
    mov d, _data_data
    call _load_binary
  }

  int i;
  for(i=0; i< size;i++){
    printx8(data[i]); print(" ");
  }
  return;

asm{
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; INPUT BINARY
;; pointer in D
;; size in b
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_load_binary:
  push a
  push d
  push c
_load_binary_loop:
  push b
  call _getchar
  pop b
  mov al, ah
  mov [d], al
  inc d
  dec b
  cmp b, 0
  jne _load_binary_loop
_load_binary_end:
  pop c
  pop d
  pop a
  ret
}

}

