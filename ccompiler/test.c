#include "lib/stdio.h"

char *string1 = "This is a string via a pointer.";

void main(){

  printf("Hello");

  printf("Int : %d, %x\n\n", 0xFFFF, 65535);
  printf("Int : %d, %x\n\n", 0xFFFF, 65535);
  printf("Int : %d, %x\n\n", 0xFFFF, 65535);
  printf("Char: %c, %c\n\n", 'a', 0x61);
  printf("Char: %c, %c\n\n", 'a', 0x61);
  printf("Char: %c, %c\n\n", 'a', 0x61);
  printf("Str : \"%s\", \"%s\"\n\n", "Hello World this is a string.", string1);
  printf("Str : \"%s\", \"%s\"\n\n", "Hello World this is a string.", string1);
  printf("Str : \"%s\", \"%s\"\n\n", "Hello World this is a string.", string1);

}

/*

  print("Int : %d, %i, %u, %x\n\n", 0xFFFF, 65535, 0xFFFF, 65535);
  printf("Char: %c, %c, %c, %c, %c, %c\n\n", 'a', 'A', 0x61, 0x41, 97, 65);
  printf("Str : \"%s\", \"%s\"\n\n", "Hello World this is a string.", string1);
*/
void f1(){

}

void f2(){

}

void f3(){


}


/*
void print_info(const char* format, ...){
  char tempbuffer[1024];
  va_list args;
  va_start(args, format);
  vsnprintf(tempbuffer, sizeof(tempbuffer), format, args);
  va_end(args);

  puts(tempbuffer);
}

arg0
...
argn
pc
bp
local0    <<< BP
...
localn
...       <<< SP

*/