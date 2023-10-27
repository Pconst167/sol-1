void main(){

  print("Hello World\n");
  return;

asm{
  mov b, 25

  push a
  push d
  push c
  mov c, 0

  mov a, b
  call print_u16d
  mov ah, $0A
  call _putchar
  
  mov al, 3
  syscall sys_io      ; receive in AH with no echo
  mov a, b
  call print_u16d
  mov ah, $0A
  call _putchar

  pop c
  pop d
  pop a
}

  /*printf("Int : %d, %i, %u, %x\n\n", 0xFFFF, 65535, 0xFFFF, 65535);
  printf("Char: %c, %c, %c, %c, %c, %c\n\n", 'a', 'A', 0x61, 0x41, 97, 65);
*/
}

/*

  printf("Int : %d, %i, %u, %x\n\n", 0xFFFF, 65535, 0xFFFF, 65535);
  printf("Char: %c, %c, %c, %c, %c, %c\n\n", 'a', 'A', 0x61, 0x41, 97, 65);
  printf("Str : \"%s\", \"%s\"\n\n", "Hello World this is a string.", string1);
*/
void printf(char *format, ...){

  print("\n");
  print("Format: "); print(format); print("\n");

}

void print(char *s){
  asm{
    meta mov d, s
    mov a, [d]
    mov d, a
    call _puts
  }
}

void putchar(char c){
  asm{
    meta mov d, c
    mov al, [d]
    mov ah, al
    call _putchar
  }
}

void printx16(int hex) {
  asm{
    meta mov d, hex
    mov b, [d]
    call print_u16x
  }
}

void printx8(char hex) {
  asm{
    meta mov d, hex
    mov bl, [d]
    call print_u8x
  }
}
void prints(int num) {
  char digits[5];
  int i = 0;

  if (num < 0) {
    putchar('-');
    num = -num;
  }
  else if (num == 0) {
    putchar('0');
    return;
  }

  while (num > 0) {
    digits[i] = '0' + (num % 10);
    num = num / 10;
    i++;
  }

  while (i > 0) {
    i--;
    putchar(digits[i]);
  }
}

void printu(unsigned int num) {
  char digits[5];
  int i;
  i = 0;
  if(num == 0){
    putchar('0');
    return;
  }
  while (num > 0) {
      digits[i] = '0' + (num % 10);
      num = num / 10;
      i++;
  }
  // Print the digits in reverse order using putchar()
  while (i > 0) {
      i--;
      putchar(digits[i]);
  }
}



void stdio(){
asm{

.include "lib/stdio.asm"


}

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