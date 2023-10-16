#include "lib/stdio.h"

struct va_list{
  char *p; // pointer to current argument

};

char *s1 = "Hello World.\n";
char *s2 = "My Name\n";
char *s3 = "is Paulo.\n";

void main(){
  print(3, s1, s2, s3);

}

void print(int count, ...){
  char **p;
  int i;

  p = &count;
  p = p - 2;
  for(i = 0; i < count; i++){
    printf(*p);
    p = p - 2;
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