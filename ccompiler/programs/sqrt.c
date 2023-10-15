#include "stdio.h"

int main() {
  int i;
  while(1){
    printf("Number: ");
    i = scann();
    if(i == 0)
      return 0;
    else
      print_signed(integer_square_root(i));
    
    printf("\n");
  }

  return 0;
}


int integer_square_root(int n) {
    if (n <= 1) {
        return n;
    }

    int x;
    int y;
    x = n;
    y = (x + n / x) / 2;

    while (y < x) {
        x = y;
        y = (x + n / x) / 2;
    }

    return x;
}


/*

ARGUMENTS
  char
  char
  ptr
  pc
  bp
  char << BP (local variables go here)

*/