#include "stdio.h"

char gca1[5] = {'0','1','2','3','4'};
int gia1[5] = {0,1,2,3,4};
char gca2[5][5];
int gia2[5][5];

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
  pass[3] = test3();
  pass[4] = test4();
  pass[5] = test5();
  pass[6] = test6();
  pass[7] = test7();
  pass[8] = test8();
  pass[9] = test9();

  for(i = 0; i < nbr_tests; i++){
    printf("Test "); prints(i); printf(" Result: ");
    prints(pass[i]);
    printf("\n");
  }

}


int test0(){
  int i;
  int pass = 1;

  for (i = 0; i < 5; i++){
    gca1[i] = 'A' + i;
    gia1[i] = i;
  }

  for (i = 0; i < 5; i++){
    if(gca1[i] != 'A' + i){
      pass = 0;
      break;
    }
    if(gia1[i] != i){
      pass = 0;
      break;
    }
  }
  return pass;
}

int test1(){
  int i, j;
  int pass = 1;

  for (i = 0; i < 5; i++){
    for (j = 0; j < 5; j++){
      gca2[i][j] = 'A' + i + j;
      gia2[i][j] = i * j;
    }
  }

  for (i = 0; i < 5; i++){
    for (j = 0; j < 5; j++){
      if(gca2[i][j] != 'A' + i + j){
        pass = 0;
        break;
      }
      if(gia2[i][j] != i * j){
        pass = 0;
        break;
      }
    }
  }
  return pass;
}

int test2(){
  int i, j;
  char lca[5];
  int lia[5];
  int pass = 1;

  for (i = 0; i < 5; i++){
    lca[i] = 'A' + i + j;
    lia[i] = i * j;
  }

  for (i = 0; i < 5; i++){
    if(lca[i] != 'A' + i + j){
      pass = 0;
      break;
    }
    if(lia[i] != i * j){
      pass = 0;
      break;
    }
  }
  return pass;
}

int test3(){
  int i, j;
  char lca[5][5];
  int lia[5][5];
  int pass = 1;

  for (i = 0; i < 5; i++){
    for (j = 0; j < 5; j++){
      lca[i][j] = 'A' + i + j;
      lia[i][j] = i * j;
    }
  }

  for (i = 0; i < 5; i++){
    for (j = 0; j < 5; j++){
      if(lca[i][j] != 'A' + i + j){
        pass = 0;
        break;
      }
      if(lia[i][j] != i * j){
        pass = 0;
        break;
      }
    }
  }
  return pass;
}

int test4(){
  int a, b, c;
  int result;
  int pass = 1;

  result = 1 && 1 && 1;
  pass = pass && result == 1;
  result = 1 && 0 && 1;
  pass = pass && result == 0;
  result = 1 || 1 || 1;
  pass = pass && result == 1;
  result = 0 || 1 || 0;
  pass = pass && result == 1;
  result = 1 || 0 && 1;
  pass = pass && result == 1;
  result = 0 || 0 || 0;
  pass = pass && result == 0;

  a = 1; b = 1; c = 1;
  result = a && b && c;
  pass = pass && result == 1;
  a = 1; b = 0; c = 1;
  result = a && b && c;
  pass = pass && result == 0;
  a = 1; b = 1; c = 1;
  result = a || b || b;
  pass = pass && result == 1;
  a = 0; b = 1; c = 0;
  result = a || b || b;
  pass = pass && result == 1;
  a = 1; b = 0; c = 1;
  result = a || b && b;
  pass = pass && result == 1;
  a = 0; b = 0; c = 0;
  result = a || b || b;
  pass = pass && result == 0;

  return pass;
}

int test5(){
  int pass;
  int i, j, k;
  int a1[5];
  int a2[5];
  int a3[5];

  i = 1;
  j = 1;
  k = 1;

  a1[3] = 1;
  a2[2] = 1;
  a3[a2[a1[i + j + (k && 1) + (1 && 0)] + (i && 1)] + (0 || j)] = 56;

  pass = a3[2] == 56;

  return pass;
}

struct t_test6_struct{
  char c1;
  char ca[5];
  int i1;
  int ia[5];
} test6_struct;
int test6(){
  int pass = 1;
  int i, j, k;

  test6_struct.c1 = 'A';
  pass = pass && test6_struct.c1 == 'A';
  for(i = 0; i < 5; i++){
    test6_struct.ca[i] = i;
    pass = pass && test6_struct.ca[i] == i;
  }
  test6_struct.i1 = 55555;
  pass = pass && test6_struct.i1 == 55555;
  for(i = 0; i < 5; i++){
    test6_struct.ia[i] = i;
    pass = pass && test6_struct.ia[i] == i;
  }

  return pass;
}
struct t_test7_substruct{
  char c1;
  char ca[5];
  int i1;
  int ia[5];
};
struct t_test7_struct{
  char c1;
  char ca[5];
  struct t_test7_substruct test7_substruct;
  int i1;
  int ia[5];
} test7_struct;
int test7(){
  int pass = 1;
  int i, j, k;

  test7_struct.test7_substruct.c1 = 'A';
  pass = pass && test7_struct.test7_substruct.c1 == 'A';
  for(i = 0; i < 5; i++){
    test7_struct.test7_substruct.ca[i] = i;
    pass = pass && test7_struct.test7_substruct.ca[i] == i;
  }
  test7_struct.test7_substruct.i1 = 55555;
  pass = pass && test7_struct.test7_substruct.i1 == 55555;
  for(i = 0; i < 5; i++){
    test7_struct.test7_substruct.ia[i] = i;
    pass = pass && test7_struct.test7_substruct.ia[i] == i;
  }

  return pass;
}

struct t_test8_struct{
  char c1;
  char ca[5];
  int i1;
  int ia[5];
};
int test8(){
  int pass = 1;
  int i, j, k;
  struct t_test8_struct test8_struct;

  test8_struct.c1 = 'A';
  pass = pass && test8_struct.c1 == 'A';
  for(i = 0; i < 5; i++){
    test8_struct.ca[i] = i;
    pass = pass && test8_struct.ca[i] == i;
  }
  test8_struct.i1 = 55555;
  pass = pass && test8_struct.i1 == 55555;
  for(i = 0; i < 5; i++){
    test8_struct.ia[i] = i;
    pass = pass && test8_struct.ia[i] == i;
  }

  return pass;
}

struct t_test9_substruct{
  char c1;
  char ca[5];
  int i1;
  int ia[5];
};
struct t_test9_struct{
  char c1;
  char ca[5];
  struct t_test9_substruct test9_substruct;
  int i1;
  int ia[5];
};
int test9(){
  int pass = 1;
  int i, j, k;
  struct t_test9_struct test9_struct;

  test9_struct.test9_substruct.c1 = 'A';
  pass = pass && test9_struct.test9_substruct.c1 == 'A';
  for(i = 0; i < 5; i++){
    test9_struct.test9_substruct.ca[i] = i;
    pass = pass && test9_struct.test9_substruct.ca[i] == i;
  }
  test9_struct.test9_substruct.i1 = 55555;
  pass = pass && test9_struct.test9_substruct.i1 == 55555;
  for(i = 0; i < 5; i++){
    test9_struct.test9_substruct.ia[i] = i;
    pass = pass && test9_struct.test9_substruct.ia[i] == i;
  }

  return pass;
}
