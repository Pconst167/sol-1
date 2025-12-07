#include <stdio.h>

void main(){
  int pass[10];
  int i;
  int nbr_tests = 10;

  // initialize pass array with -1's
  for(i = 0; i < nbr_tests; i++){
    pass[i] = -1;
  }

  pass[0] = test0();

  for(i = 0; i < nbr_tests; i++)
    printf("Test %d, Result: %d\n", i, pass[i]);
}

int test0(){
  int result = 1;

  result = result && sizeof(char) == 1;
  result = result && sizeof(int) == 2;
  result = result && sizeof(long int) == 4;
  result = result && sizeof(char**) == 2;
  result = result && sizeof(int**) == 2;

}