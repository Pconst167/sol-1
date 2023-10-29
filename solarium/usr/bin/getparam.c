#include <token.h>

char *address;
char data;

void main(){
  prog = 0;

  get();
  address = atoi(token);

  data = getparam(address);

  print("\nParam Value: ");
  printx8(data);
  print("\n");
}
