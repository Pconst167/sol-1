#include <string.h>

#define NULL 0
#define ARG_BUFF 0x0000
#define MAX_SCANF_STRING_SIZE 512

struct _FILE{
  int handle;
  unsigned char filename[256];
  unsigned char mode; // 0: RD, 1: WR, 2: RW, 3: APPEND
  unsigned char loc; // position of seek head
};

typedef struct _FILE FILE;

FILE *fopen(char *filename, unsigned char mode){
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
            print_signed_long(*(long int*)p);
          else if(*format_p == 'u')
            print_unsigned_long(*(unsigned long int*)p);
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
        case 'p':
          printx16(*(int*)p);
          /*asm{
            ccmovd p
            mov d, [d]
            mov b, [d]
            call print_u16x
          }*/
          p = p + 2;
          break;

        case 'c':
          putchar(*(char*)p);
          /*asm{
            ccmovd p
            mov d, [d]
            mov al, [d]
            mov ah, al
            call _putchar
          }*/
          p = p + 2;
          break;

        case 's':
          print(*(char**)p);
          /*asm{
            ccmovd p
            mov d, [d]
            mov d, [d]
            call _puts
          }*/
          p = p + 2;
          break;

        default:
          print("Error: Unknown argument type.\n");
      }
    }
    else {
      putchar(*format_p);
    }
    format_p++;
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
        case 'p':
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
        case 'p':
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
    call print_u16x_printx32
    mov b, [d]
    call print_u16x_printx32
  }
  return;
  asm{
  print_u16x_printx32:
    push a
    push b
    push bl
    mov bl, bh
    call _itoa_printx32        ; convert bh to char in A
    mov bl, al        ; save al
    mov al, 0
    syscall sys_io        ; display AH
    mov ah, bl        ; retrieve al
    mov al, 0
    syscall sys_io        ; display AL

    pop bl
    call _itoa_printx32        ; convert bh to char in A
    mov bl, al        ; save al
    mov al, 0
    syscall sys_io        ; display AH
    mov ah, bl        ; retrieve al
    mov al, 0
    syscall sys_io        ; display AL

    pop b
    pop a
    ret

  _itoa_printx32:
    push d
    push b
    mov bh, 0
    shr bl, 4  
    mov d, b
    mov al, [d + s_hex_digits_printx32]
    mov ah, al
    
    pop b
    push b
    mov bh, 0
    and bl, $0F
    mov d, b
    mov al, [d + s_hex_digits_printx32]
    pop b
    pop d
    ret

    s_hex_digits_printx32: .db "0123456789ABCDEF"  
  }
}

void printx16(int hex) {
  asm{
    ccmovd hex
    mov b, [d]
  print_u16x_printx16:
    push bl
    mov bl, bh
    call _itoa_printx16        ; convert bh to char in A
    mov bl, al        ; save al
    mov al, 0
    syscall sys_io        ; display AH
    mov ah, bl        ; retrieve al
    mov al, 0
    syscall sys_io        ; display AL

    pop bl
    call _itoa_printx16        ; convert bh to char in A
    mov bl, al        ; save al
    mov al, 0
    syscall sys_io        ; display AH
    mov ah, bl        ; retrieve al
    mov al, 0
    syscall sys_io        ; display AL
  }
  return;
  asm{
  _itoa_printx16:
    push d
    push b
    mov bh, 0
    shr bl, 4  
    mov d, b
    mov al, [d + s_hex_digits_printx16]
    mov ah, al
    pop b
    push b
    mov bh, 0
    and bl, $0F
    mov d, b
    mov al, [d + s_hex_digits_printx16]
    pop b
    pop d
    ret

    s_hex_digits_printx16:    .db "0123456789ABCDEF"  
  }
}

void printx8(char hex) {
  asm{
    ccmovd hex
    mov bl, [d]
    call _itoa_printx8        ; convert bl to char in A
    mov bl, al        ; save al
    mov al, 0
    syscall sys_io        ; display AH
    mov ah, bl        ; retrieve al
    mov al, 0
    syscall sys_io        ; display AL
  }
  return;
  asm{
  _itoa_printx8:
    push d
    push b
    mov bh, 0
    shr bl, 4  
    mov d, b
    mov al, [d + s_hex_digits_printx8]
    mov ah, al
    
    pop b
    push b
    mov bh, 0
    and bl, $0F
    mov d, b
    mov al, [d + s_hex_digits_printx8]
    pop b
    pop d
    ret

    s_hex_digits_printx8:    .db "0123456789ABCDEF"  
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
    call _gets_gets
  }
  return strlen(s);

  asm{
  _gets_gets:
    push a
    push d
  _gets_loop_gets:
    mov al, 1
    syscall sys_io      ; receive in AH
    cmp al, 0        ; check error code (AL)
    je _gets_loop_gets      ; if no char received, retry

    cmp ah, 27
    je _gets_ansi_esc_gets
    cmp ah, $0A        ; LF
    je _gets_end_gets
    cmp ah, $0D        ; CR
    je _gets_end_gets
    cmp ah, $5C        ; '\\'
    je _gets_escape_gets
    
    cmp ah, $08      ; check for backspace
    je _gets_backspace_gets

    mov al, ah
    mov [d], al
    inc d
    jmp _gets_loop_gets
  _gets_backspace_gets:
    dec d
    jmp _gets_loop_gets
  _gets_ansi_esc_gets:
    mov al, 1
    syscall sys_io        ; receive in AH without echo
    cmp al, 0          ; check error code (AL)
    je _gets_ansi_esc_gets    ; if no char received, retry
    cmp ah, '['
    jne _gets_loop_gets
  _gets_ansi_esc_2_gets:
    mov al, 1
    syscall sys_io          ; receive in AH without echo
    cmp al, 0            ; check error code (AL)
    je _gets_ansi_esc_2_gets  ; if no char received, retry
    cmp ah, 'D'
    je _gets_left_arrow_gets
    cmp ah, 'C'
    je _gets_right_arrow_gets
    jmp _gets_loop_gets
  _gets_left_arrow_gets:
    dec d
    jmp _gets_loop_gets
  _gets_right_arrow_gets:
    inc d
    jmp _gets_loop_gets
  _gets_escape_gets:
    mov al, 1
    syscall sys_io      ; receive in AH
    cmp al, 0        ; check error code (AL)
    je _gets_escape_gets      ; if no char received, retry
    cmp ah, 'n'
    je _gets_LF_gets
    cmp ah, 'r'
    je _gets_CR_gets
    cmp ah, '0'
    je _gets_NULL_gets
    cmp ah, $5C  
    je _gets_slash_gets
    mov al, ah        ; if not a known escape, it is just a normal letter
    mov [d], al
    inc d
    jmp _gets_loop_gets
  _gets_slash_gets:
    mov al, $5C
    mov [d], al
    inc d
    jmp _gets_loop_gets
  _gets_LF_gets:
    mov al, $0A
    mov [d], al
    inc d
    jmp _gets_loop_gets
  _gets_CR_gets:
    mov al, $0D
    mov [d], al
    inc d
    jmp _gets_loop_gets
  _gets_NULL_gets:
    mov al, $00
    mov [d], al
    inc d
    jmp _gets_loop_gets
  _gets_end_gets:
    mov al, 0
    mov [d], al        ; terminate string
    pop d
    pop a
    ret
  }
}

void print_signed(int num) {
  char digits[5];  // enough for "-32768"
  int i = 0;
  unsigned int absval;

  if (num < 0) {
    putchar('-');
    absval = (unsigned int)(-(num + 1)) + 1;  // safe for -32768
  } else {
    absval = (unsigned int)num;
  }

  if (absval == 0) {
    putchar('0');
    return;
  }

  while (absval > 0) {
    digits[i++] = '0' + (absval % 10);
    absval = absval / 10;
  }

  while (i > 0) {
    putchar(digits[--i]);
  }
}

void print_signed_long(long int num) {
  char digits[10];  // fits 2,147,483,647
  int i = 0;
  unsigned long int absval;

  if (num < 0) {
    putchar('-');
    // handle LONG_MIN safely
    absval = (unsigned long int)(-(num + 1)) + 1;
  } else {
    absval = (unsigned long int)num;
  }

  if (absval == 0) {
    putchar('0');
    return;
  }

  while (absval > 0) {
    digits[i++] = '0' + (absval % 10);
    absval = absval / 10;
  }

  while (i > 0) {
    putchar(digits[--i]);
  }
}

void print_unsigned(unsigned int num) {
  char digits[5];
  int i = 0;
  
  if(num == 0){
    putchar('0');
    return;
  }

  while (num > 0) {
    digits[i++] = '0' + (num % 10);
    num = num / 10;
  }

  // Print the digits in reverse order using putchar()
  while (i > 0) {
    putchar(digits[--i]);
  }
}

void print_unsigned_long(unsigned long int num) {
  char digits[10];
  int i = 0;

  if(num == 0){
    putchar('0');
    return;
  }

  while (num > 0) {
    digits[i++] = '0' + (num % 10);
    num = num / 10;
  }

  // Print the digits in reverse order using putchar()
  while (i > 0) {
    putchar(digits[--i]);
  }
}

int sprint_unsigned(char *dest, unsigned int num) {
  char digits[5];
  int i = 0;
  int len = 0;

  if(num == 0){
    *dest++ = '0';
    *dest = '\0';
    return 1;
  }

  while (num > 0) {
    digits[i++] = '0' + (num % 10);
    num = num / 10;
  }

  // Print the digits in reverse order using putchar()
  while (i > 0) {
    *dest++ = digits[--i];
    len++;
  }
  *dest = '\0';

  return len;
}

int sprint_signed(char *dest, int num) {
  char digits[5];   // enough for 32768
  int i = 0;
  int len = 0;
  unsigned int absval;

  if (num < 0) {
    *dest++ = '-';
    len++;
    absval = (unsigned int)(-(num + 1)) + 1;  // safe even for -32768
  } else {
    absval = (unsigned int)num;
  }

  if (absval == 0) {
    *dest++ = '0';
    *dest = '\0';
    return len + 1;
  }

  while (absval > 0) {
    digits[i++] = '0' + (absval % 10);
    absval = absval / 10;
  }

  while (i > 0) {
    *dest++ = digits[--i];
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
    mov al, 0
    syscall sys_io      ; char in AH
  }
}

char getchar(){
  char c;
  asm{
    mov al, 1
    syscall sys_io      ; receive in AH
    mov al, ah
    ccmovd c
    mov [d], al
  }
  return c;
}

int scann(){
  int m;

  asm{
    enter 8
    lea d, [bp +- 7]
    call _gets_scann
    call _strlen_scann      ; get string length in C
    dec c
    mov si, d
    mov a, c
    shl a
    mov d, table_power_scann
    add d, a
    mov c, 0
  mul_loop_scann:
    lodsb      ; load ASCII to al
    cmp al, 0
    je mul_exit_scann
    sub al, $30    ; make into integer
    mov ah, 0
    mov b, [d]
    mul a, b      ; result in B since it fits in 16bits
    mov a, b
    mov b, c
    add a, b
    mov c, a
    sub d, 2
    jmp mul_loop_scann
  mul_exit_scann:
    mov a, c
    leave

    ccmovd m
    mov [d], a
  }
  
  return m;

  asm{
  _strlen_scann:
    push d
    mov c, 0
  _strlen_L1_scann:
    cmp byte [d], 0
    je _strlen_ret_scann
    inc d
    inc c
    jmp _strlen_L1_scann
  _strlen_ret_scann:
    pop d
    ret

  _gets_scann:
    push d
  _gets_loop_scann:
    mov al, 1
    syscall sys_io      ; receive in AH
    cmp al, 0        ; check error code (AL)
    je _gets_loop_scann      ; if no char received, retry

    cmp ah, 27
    je _gets_ansi_esc_scann
    cmp ah, $0A        ; LF
    je _gets_end_scann
    cmp ah, $0D        ; CR
    je _gets_end_scann
    cmp ah, $5C        ; '\\'
    je _gets_escape_scann
    
    cmp ah, $08      ; check for backspace
    je _gets_backspace_scann

    mov al, ah
    mov [d], al
    inc d
    jmp _gets_loop_scann
  _gets_backspace_scann:
    dec d
    jmp _gets_loop_scann
  _gets_ansi_esc_scann:
    mov al, 1
    syscall sys_io        ; receive in AH without echo
    cmp al, 0          ; check error code (AL)
    je _gets_ansi_esc_scann    ; if no char received, retry
    cmp ah, '['
    jne _gets_loop_scann
  _gets_ansi_esc_2_scann:
    mov al, 1
    syscall sys_io          ; receive in AH without echo
    cmp al, 0            ; check error code (AL)
    je _gets_ansi_esc_2_scann  ; if no char received, retry
    cmp ah, 'D'
    je _gets_left_arrow_scann
    cmp ah, 'C'
    je _gets_right_arrow_scann
    jmp _gets_loop_scann
  _gets_left_arrow_scann:
    dec d
    jmp _gets_loop_scann
  _gets_right_arrow_scann:
    inc d
    jmp _gets_loop_scann
  _gets_escape_scann:
    mov al, 1
    syscall sys_io      ; receive in AH
    cmp al, 0        ; check error code (AL)
    je _gets_escape_scann      ; if no char received, retry
    cmp ah, 'n'
    je _gets_LF_scann
    cmp ah, 'r'
    je _gets_CR_scann
    cmp ah, '0'
    je _gets_NULL_scann
    cmp ah, $5C  
    je _gets_slash_scann
    mov al, ah        ; if not a known escape, it is just a normal letter
    mov [d], al
    inc d
    jmp _gets_loop_scann
  _gets_slash_scann:
    mov al, $5C
    mov [d], al
    inc d
    jmp _gets_loop_scann
  _gets_LF_scann:
    mov al, $0A
    mov [d], al
    inc d
    jmp _gets_loop_scann
  _gets_CR_scann:
    mov al, $0D
    mov [d], al
    inc d
    jmp _gets_loop_scann
  _gets_NULL_scann:
    mov al, $00
    mov [d], al
    inc d
    jmp _gets_loop_scann
  _gets_end_scann:
    mov al, 0
    mov [d], al        ; terminate string
    pop d
    ret

  table_power_scann:
    .dw 1              ; 1
    .dw $A             ; 10
    .dw $64            ; 100
    .dw $3E8           ; 1000
    .dw $2710          ; 10000

    .dw $86A0, $1      ; 100000
    .dw $4240, $F      ; 1000000
    .dw $9680, $98     ; 10000000
    .dw $E100, $5F5    ; 100000000
    .dw $CA00, $3B9A   ; 1000000000
  }
}

void puts(char *s){
  asm{
    ccmovd s
    mov d, [d]
  _puts_L1_puts:
    mov al, [d]
    cmp al, 0
    jz _puts_END_puts
    mov ah, al
    mov al, 0
    syscall sys_io
    inc d
    jmp _puts_L1_puts
  _puts_END_puts:
    mov a, $0A00
    syscall sys_io
  }
}

void print(char *s){
  asm{
    ccmovd s
    mov d, [d]
  _puts_L1_print:
    mov al, [d]
    cmp al, 0
    jz _puts_END_print
    mov ah, al
    mov al, 0
    syscall sys_io
    inc d
    jmp _puts_L1_print
  _puts_END_print:
  }
}

void clear(){
  print("\033[2J\033[H");
}

void move_cursor(int x, int y){
  printf("\033[%d;%dH", y, x);
}

void hide_cursor(char hide){
  if(hide){
    printf("\033[?25l");
  }
  else{
    printf("\033[?25h");
  }
}

int abs(int i){
  return i < 0 ? -i : i;
}

long int scanx32(){
  long int i;

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