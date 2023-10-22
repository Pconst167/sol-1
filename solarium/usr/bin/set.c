#include <stdio.h>


void main(int argc, char argv[][64]){
  char debug;
  int i;

  if(argc == 0){
    printf("\nusage: set -parameter <val>\n");
    exit();
  }

  for(i = 0; i < argc; i = i + 2){
    if(argv[i][0] == '-'){
      // debug mode
      if(!strcmp(argv[i]+1, "debugmode")){
        debug = atoi(argv[i+1]);
        printfn("Setting kernel debug mode to: ", debug);
        printf("\n");
        asm{
          meta mov d, debug
          mov bl, [d]
          mov al, 3 ; set debug mode
          syscall sys_system
        }
        printf("\nOK.\n");
      }
      else{
        printf("unknown option: ");
        printf(argv[i]);
        printf("\n");
        exit();
      }
    }
  }
}