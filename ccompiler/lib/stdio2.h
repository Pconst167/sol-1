#include <stddef.h>
#include <string.h>
#include <stdlib.h>

#define NULL 0
#define ARG_BUFF 0x0000
#define MAX_SCANF_STRING_SIZE 512

struct _FILE{
  int handle;
  uint8_t filename[256];
  uint8_t mode; // 0: RD, 1: WR, 2: RW, 3: APPEND
  uint8_t loc; // position of seek head
};

typedef struct _FILE FILE;

FILE *fopen(char *filename, uint8_t mode){
  FILE *fp;
  static int max_handle = 0;

  fp = alloc(sizeof(FILE));
  strcpy(fp->filename, filename);
  fp->handle = max_handle;
  fp->mode = mode;
  fp->loc = 0;

  max_handle++;
}

/*
struct va_list_t{
  char *current_arg; // pointer to current argument
};

void va_start(struct va_list_t *argp, char *first_fixed_param){
  argp->current_arg = first_fixed_param + sizeof(first_fixed_param);
}

char *va_arg(struct va_list_t *argp, unsigned int size) {
  char *p;
  p = argp->current_arg;
  argp->current_arg = argp->current_arg + size;
  return p;
}

void va_end(struct va_list_t *argp) {
  argp->current_arg = NULL;
}
*/

void fclose(FILE *fp){
  free(sizeof(FILE));
}


void printf(const char *format, ...){
  char *p, *format_p;

  format_p = format;
  p = &format + 2;

// printf("%i %d %d", 124, 1234, 65535);
  for(;;){
    if(!*format_p) break;
    else if(*format_p == '%'){
      format_p++;
      switch(*format_p){
        case 'l':
        case 'L':
          format_p++;
          if(*format_p == 'd' || *format_p == 'i')
            print_signed_long(*(long *)p);
          else if(*format_p == 'u')
            print_unsigned_long(*(unsigned long *)p);
          else if(*format_p == 'x')
            printx32(*(long int *)p);
          else err("Unexpected format in printf.");
          p = p + 4;
          break;

        case 'd':
        case 'i':
          print_signed(*(int*)p);
          p = p + 2;
          break;

        case 'u':
          print_unsigned(*(unsigned int*)p);
          p = p + 2;
          break;

        case 'x':
          asm{
            ccmovd p
            mov d, [d]
            mov b, [d]
            call print_u16x
          }
          p = p + 2;
          break;

        case 'c':
          asm{
            ccmovd p
            mov d, [d]
            mov al, [d]
            mov ah, al
            call _putchar
          }
          p = p + 1;
          break;

        case 's':
          asm{
            ccmovd p
            mov d, [d]
            mov d, [d]
            call _puts
          }
          p = p + 2;
          break;

        default:
          print("Error: Unknown argument type.\n");
      }
      format_p++;
    }
    else {
      putchar(*format_p);
      format_p++;
    }
  }
}

void scanf(const char *format, ...){
  char *p, *format_p;
  char c;
  int i;
  char input_string[MAX_SCANF_STRING_SIZE];

  format_p = format;
  p = &format + 2;

// scanf("%d %c %s", &a, &b, &c);
  for(;;){
    if(!*format_p) break;
    else if(*format_p == '%'){
      format_p++;
      switch(*format_p){
        case 'l':
        case 'L':
          format_p++;
          if(*format_p == 'd' || *format_p == 'i');
          else if(*format_p == 'u');
          else if(*format_p == 'x');
          else err("Unexpected format in printf.");
          p = p + 4;
          break;

        case 'd':
        case 'i':
          i = scann();
          **(int **)p = i;
          p = p + 2;
          break;

        case 'u':
          i = scann();
          **(int **)p = i;
          p = p + 2;
          break;

        case 'x':
          p = p + 2;
          break;

        case 'c':
          c = getchar();
          **(char **)p = *(char *)c;
          p = p + 1;
          break;

        case 's':
          gets(input_string);
          strcpy(*(char **)p, input_string);
          p = p + 2;
          break;

        default:
          print("Error: Unknown argument type.\n");
      }
      format_p++;
    }
    else {
      putchar(*format_p);
      format_p++;
    }
  }
}

void sprintf(char *dest, const char *format, ...){
  char *p, *format_p;
  char *sp;

  sp = dest;
  format_p = format;
  p = &format + 2;

// sprintf(dest, "%i %d %d", 124, 1234, 65535);
  for(;;){
    if(!*format_p) break;
    else if(*format_p == '%'){
      format_p++;
      switch(*format_p){
        case 'l':
        case 'L':
          format_p++;
          if(*format_p == 'd' || *format_p == 'i')
            print_signed_long(*(long *)p);
          else if(*format_p == 'u')
            print_unsigned_long(*(unsigned long *)p);
          else if(*format_p == 'x')
            printx32(*(long int *)p);
          else err("Unexpected format in printf.");
          p = p + 4;
          break;

        case 'd':
        case 'i':
          sp = sp + sprint_signed(sp, *(int*)p);
          p = p + 2;
          break;

        case 'u':
          sp = sp + sprint_unsigned(sp, *(unsigned int*)p);
          p = p + 2;
          break;

        case 'x':
          asm{
            ccmovd p
            mov d, [d]
            mov b, [d]
            call print_u16x
          }
          p = p + 2;
          break;

        case 'c':
          *sp++ = *(char *)p;
          p = p + 1;
          break;

        case 's':
          int len = strlen(*(char **)p);
          strcpy(sp, *(char **)p);
          sp = sp + len;
          p = p + 2;
          break;

        default:
          print("Error: Unknown argument type.\n");
      }
      format_p++;
    }
    else {
      *sp++ = *format_p++;
    }
  }
  *sp = '\0';

  return sp - dest; // return total number of chars written
}

void err(char *e){
  print(e);
}

void printx32(long int hex) {
  asm{
    ccmovd hex
    mov b, [d+2]
    call print_u16x
    mov b, [d]
    call print_u16x
  }
}

void printx16(int hex) {
  asm{
    ccmovd hex
    mov b, [d]
    call print_u16x
  }
}

void printx8(char hex) {
  asm{
    ccmovd hex
    mov bl, [d]
    call print_u8x
  }
}

int hex_str_to_int(char *hex_string) {
  int value = 0;
  int i;
  char hex_char;
  int len;

  len = strlen(hex_string);
  for (i = 0; i < len; i++) {
    hex_char = hex_string[i];
    if (hex_char >= 'a' && hex_char <= 'f') 
      value = (value * 16) + (hex_char - 'a' + 10);
    else if (hex_char >= 'A' && hex_char <= 'F') 
      value = (value * 16) + (hex_char - 'A' + 10);
    else 
      value = (value * 16) + (hex_char - '0');
  }
  return value;
}

int gets(char *s){
  asm{
    ccmovd s
    mov a, [d]
    mov d, a
    call _gets
  }
  return strlen(s);
}

void print_signed(int num) {
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

void print_signed_long(long int num) {
  char digits[10];
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

void print_unsigned_long(unsigned long int num) {
  char digits[10];
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

void sprint_unsigned(char *dest, unsigned int num) {
  char digits[5];
  int i;
  int len = 0;

  i = 0;
  if(num == 0){
    *dest++ = '0';
    return 1;
  }
  while (num > 0) {
    digits[i] = '0' + (num % 10);
    num = num / 10;
    i++;
  }
  // Print the digits in reverse order using putchar()
  while (i > 0) {
    i--;
    *dest++ = digits[i];
    len++;
  }
  *dest = '\0';
  return len;
}

void print_unsigned(unsigned int num) {
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

void sprint_signed(char *dest, int num) {
  char digits[5];
  int i = 0;
  int len = 0;

  if (num < 0) {
    *dest++ = '-';
    num = -num;
    len++;
  }
  else if (num == 0) {
    *dest++ = '0';
    *dest = '\0';
    return 1;
  }

  while (num > 0) {
    digits[i] = '0' + (num % 10);
    num = num / 10;
    i++;
  }

  while (i > 0) {
    i--;
    *dest++ = digits[i];
    len++;
  }
  *dest = '\0';
  return len;
}

void date(){
  asm{
    mov al, 0 ; print datetime
    syscall sys_datetime
  }
}

void putchar(char c){
  asm{
    ccmovd c
    mov al, [d]
    mov ah, al
    call _putchar
  }
}

char getchar(){
  char c;
  asm{
    call getch
    mov al, ah
    ccmovd c
    mov [d], al
  }
  return c;
}

int scann(){
  int m;
  asm{
    call scan_u16d
    ccmovd m
    mov [d], a
  }
  
  return m;
}

void puts(char *s){
  asm{
    ccmovd s
    mov a, [d]
    mov d, a
    call _puts
    mov a, $0A00
    syscall sys_io
  }
}

void print(char *s){
  asm{
    ccmovd s
    mov d, [d]
    call _puts
  }
}

unsigned char getparam(char *address){
  char data;

  asm{
    mov al, 4
    ccmovd address
    mov d, [d]
    syscall sys_system
    ccmovd data
    mov [d], bl
  }
  return data;
}

void clear(){
  print("\033[2J\033[H");
}

int abs(int i){
  return i < 0 ? -i : i;
}

int loadfile(char *filename, char *destination){
  asm{
    ccmovd destination
    mov a, [d]
    mov di, a
    ccmovd filename
    mov d, [d]
    mov al, 20
    syscall sys_filesystem
  }
}

int create_file(char *filename, char *content){
}

int delete_file(char *filename){
  asm{
    ccmovd filename
    mov al, 10
    syscall sys_filesystem
  }
}

void load_hex(char *destination){
  char *temp;
  
  temp = alloc(32768);

  asm{
    ; GET HEX FILE
    ; di = destination address
    ; return length in bytes in C
    _load_hex:
      ccmovd destination
      mov d, [d]
      mov di, d
      ccmovd temp
      mov d, [d]
      mov c, 0
      mov a, sp
      inc a
      mov d, a          ; start of string data block
      call _gets        ; get program string
      mov si, a
    __load_hex_loop:
      lodsb             ; load from [SI] to AL
      cmp al, 0         ; check if ASCII 0
      jz __load_hex_ret
      mov bh, al
      lodsb
      mov bl, al
      call _atoi        ; convert ASCII byte in B to int (to AL)
      stosb             ; store AL to [DI]
      inc c
      jmp __load_hex_loop
    __load_hex_ret:
  }
}

void include_stdio_asm(){
  asm{
    .include "lib/asm/stdio.asm"
  }
}