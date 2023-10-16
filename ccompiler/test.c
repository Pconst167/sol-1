#include "lib/stdio.h"

struct va_list{
  char *p; // pointer to current argument

};


void main(){
  print("Int: %d, Char: %c, String: %s", 123, 'a', "Hello World");

}

// printf("Int: %d, Char: %c, String: %s", 123, 'A', "Hello World");

void print(char *format, ...){
  void **p;
  char *fp;
  int i;
  fp = format;
  p = &format;
  for(;;){
    if(!*fp) break;
    if(*fp == '%'){
      fp++;
      switch(*fp){
        case 'd':
        case 'i':
          fp++;
          p = p - 2;
          prints(*(int*)p);
          break;

        case 's':
          fp++;
          p = p - 2;
          printf(*(char**)p);
          break;

        case 'c':
          fp++;
          p = p - 2;
          putchar(*(char*)p);
          break;

        default:
          putchar(*fp);
      }
    }
    else{
      putchar(*fp++);
    }
  }
  //va_start(args, &count);  
}

inline int va_arg(struct va_list *arg, int size){
  int val;
  if(size == 1){
    val = *(char*)arg->p;
  }
  else if(size == 2){
    val = *(int*)arg->p;
  }
  else{
    printf("Unknown type size in va_arg() call. Size needs to be either 1 or 2.");
  }
  arg->p = arg->p + size;
  return val;
}

void va_start(struct va_list args, int num){

}

void va_end(struct va_list args){

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