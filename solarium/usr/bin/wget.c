#include <token.h>
#include <http.h>

char url[128];
char filename[64];

void main() {
  char status;
  char *p;

  p = url;
  prog = 0;
  while(*prog && *prog != ' ') *p++ = *prog++;
  *p = '\0';
  if(!*prog){
    printf("\nusage: hget <url> <filename>");
    exit();
  }
  while(*prog == ' ') prog++;
  if(!*prog){
    printf("\nusage: hget <url> <filename>");
    exit();
  }
  p = filename;
  while(*prog && *prog != ' ' && *prog != ';') *p++ = *prog++;
  *p = '\0';

  printf("Filename: "); printf(filename); printf("\n");
  printf("Url: "); printf(url); printf("\n");

  status = http(2, url); // Request ESP to download file

  if(status >= 100 && status <= 299){
    printf("Now creating file...\n");
    // Now Request file
    http(3, url); // Request ESP to send the file
    // Create binary file and wait for ESP's input + 0x0A
    asm{
        meta mov d, filename  // Filename
        mov al, 11
        syscall sys_filesystem
    }
    printf("OK.\n");
  }
  else{
    printf("Bad code, aborting...\n");
  }

}
