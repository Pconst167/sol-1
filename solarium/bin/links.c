#include <token.h>
#include <http.h>

char url[128];

void main() {
  char *p;

  p = url;
  prog = 0;
  if(!*prog){
    printf("\nusage: hget <url> <filename>");
    exit();
  }
  while(*prog) *p++ = *prog++;
  *p = '\0';

  http(1, url); // Request ESP to download file
}
