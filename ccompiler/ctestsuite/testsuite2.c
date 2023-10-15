#include "stdio.h"

struct t_structTest3{
  char c;
  int i;
  int m[5];
} st1;

void main(){
  int pass[10];
  int i;
  int nbr_tests = 10;
  // initialize pass array with -1's
  for(i = 0; i < nbr_tests; i++){
    pass[i] = -1;
  }

  pass[0] = test0();
  pass[1] = test1();
  pass[2] = test2();
  pass[3] = test3(st1);

  for(i = 0; i < nbr_tests; i++){
    printf("Test "); prints(i); printf(" Result: ");
    prints(pass[i]);
    printf("\n");
  }
}

int test0(){
  int result;
  int pass = 1;
  char c;
  int i;
  char ca[5];
  int ia[5];
  c = 'A';
  i = 55;
  ca[0] = 'A';
  ca[1] = 'B';
  ca[2] = 'C';
  ca[3] = 'D';
  ca[4] = 'E';
  ia[0] = 0;
  ia[1] = 1;
  ia[2] = 2;
  ia[3] = 3;
  ia[4] = 4;

  pass = pass && test0_subTest0(c, i);

  return pass;
}

int test0_subTest0(char c, int i, char ca[5], int ia[5]){
  int pass = 1;

  pass = pass && c == 'A';
  pass = pass && i == 55;

  pass = pass && ca[0] == 'A';
  pass = pass && ca[1] == 'B';
  pass = pass && ca[2] == 'C';
  pass = pass && ca[3] == 'D';
  pass = pass && ca[4] == 'E';

  pass = pass && ia[0] == 0;
  pass = pass && ia[1] == 1;
  pass = pass && ia[2] == 2;
  pass = pass && ia[3] == 3;
  pass = pass && ia[4] == 4;

  return pass;
}

int test1(){
  int pass = 1;
  char ca[5];
  char *p;
  p = ca;

  ca[0] = 'A';
  ca[1] = 'B';
  ca[2] = 'C';
  ca[3] = 'D';
  ca[4] = 'E';

  pass = pass && *p == 'A';
  pass = pass && *(p + 1) == 'B';
  pass = pass && *(p + 2) == 'C';
  pass = pass && *(p + 3) == 'D';
  pass = pass && *(p + 4) == 'E';

  return pass;

}

int test2(){
  int pass = 1;
  char ca[5];
  int indices[5];
  char *p;
  p = ca;

  ca[0] = 'A';
  ca[1] = 'B';
  ca[2] = 'C';
  ca[3] = 'D';
  ca[4] = 'E';

  indices[0] = 0;
  indices[1] = 1;
  indices[2] = 2;
  indices[3] = 3;
  indices[4] = 4;

  pass = pass && *(p + indices[0]) == 'A';
  pass = pass && *(p + indices[1]) == 'B';
  pass = pass && *(p + indices[2]) == 'C';
  pass = pass && *(p + indices[3]) == 'D';
  pass = pass && *(p + indices[4]) == 'E';

  return pass;
}
/*
  test3(st);
*/
int test3(struct t_structTest3 st){
  int pass = 1;

  printf("part 1");
  st.c = 'A';
  st.i = 277;
  st.m[0] = 0;
  st.m[1] = 1;
  st.m[2] = 2;
  st.m[3] = 3;
  st.m[4] = 4;

  printf("part 2");
  pass = pass && st.c == 'A';
  pass = pass && st.i == 277;

  printf("part 3");
  pass = pass && st.m[0] == 0;
  pass = pass && st.m[1] == 1;
  pass = pass && st.m[2] == 2;
  pass = pass && st.m[3] == 3;
  pass = pass && st.m[4] == 4;

  printf("part 4");
  return pass;
}