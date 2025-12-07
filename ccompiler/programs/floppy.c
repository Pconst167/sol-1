#include <stdio.h>


void main(){
  char option;
  char byte;
  unsigned int word;

  printf("Test of 5.25 inch Floppy Drive Interface.\n");

  asm{
    mov d, $FFC0    ; wd1770 data register
    mov al, 2       ; setparam call
    mov bl, $09     
    syscall sys_system
  }


  for(;;){
    printf("0. select drive 0\n");
    printf("1. select drive 1\n");
    printf("f. format\n");
    printf("a. set reset bit and select drive 0\n");
    printf("b. clear reset bit, and select drive 0\n");
    printf("w. write 16 to data register\n");
    printf("d. read data register\n");
    printf("t. read track register\n");
    printf("s. step\n");
    printf("k. seek\n");
    printf("r. restore\n");
    printf("i. step in\n");
    printf("o. step out\n");
    printf("e. exit\n");
    printf("q. read pending irq status register\n");
    printf("\nOption: ");
    option = getchar();
    switch(option){
      case 'f':
        asm{
          mov al, 0       ; format track
          syscall sys_fdc
        }
        break;
      case 'a':
        asm{
          mov d, $FFC0    ; fdc output register
          mov al, 2       ; setparam call
          mov bl, $2A     ; set reset bit, select drive 0
          syscall sys_system
        }
        break;
      case 'b':
        asm{
          mov d, $FFC0    ; fdc output register
          mov al, 2       ; setparam call
          mov bl, $0A     ; clear reset bit, select drive 0
          syscall sys_system
        }
        break;
      case '0':
        asm{
          mov d, $FFC0    ; fdc output register
          mov al, 2       ; setparam call
          mov bl, $0A     ; select drive 0
          syscall sys_system
        }
        break;
      case '1':
        asm{
          mov d, $FFC0    ; fdc output register
          mov al, 2       ; setparam call
          mov bl, $09     ; select drive 1
          syscall sys_system
        }
        break;
      case 'w':
        asm{
          mov d, $FFCB    ; wd1770 data register
          mov al, 2       ; setparam call
          mov bl, $10     ; track 16
          syscall sys_system
        }
        break;
      case 'd':
        asm{
          mov d, $FFCB    ; wd1770 data register
          mov al, 4       ; getparam call
          syscall sys_system
          ccmovd byte
          mov [d], bl
        }
          printf("\nData register value: %d\n", byte);
        break;
      case 't':
        asm{
          mov d, $FFC9    ; wd1770 track register
          mov al, 4       ; getparam call
          syscall sys_system
          ccmovd byte
          mov [d], bl
        }
          printf("\nTrack register value: %d\n", byte);
        break;
      case 's':
        asm{
          mov d, $FFC8    ; wd1770 command register
          mov al, 2       ; setparam call
          mov bl, $23     ; STEP command, 30ms rate
          syscall sys_system
        }
        break;
      case 'k':
        asm{
          mov d, $FFC8    ; wd1770 command register
          mov al, 2       ; setparam call
          mov bl, $13     ; seek command
          syscall sys_system
        }
        break;
      case 'r':
        asm{
        ; send restore command
          mov d, $FFC8    ; wd1770
          mov al, 2       ; setparam call
          mov bl, $03     ; restore command, 30ms rate
          syscall sys_system
        }
        break;
      case 'i':
        asm{
        ; send step in command
          mov d, $FFC8    ; wd1770
          mov al, 2       ; setparam call
          mov bl, $43     ; step in command, 30ms rate
          syscall sys_system
        }
        break;
      case 'o':
        asm{
        ; send step out command
          mov d, $FFC8    ; wd1770
          mov al, 2       ; setparam call
          mov bl, $63     ; step out command, 30ms rate
          syscall sys_system
        }
        break;
      case 'q':
        asm{
          lodmsk          ; load masks register/irq status register
          ccmovd word     ; load address of word into d
          mov [d], a      ; al = masks, ah = irq status
        }
          printf("\nMasks: %x\n", word);
        break;
    case 'e':
      return;
    }
  }
  
}

