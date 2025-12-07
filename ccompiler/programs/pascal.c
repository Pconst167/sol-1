#include <stdio.h>

char *ss = "     ";
int coef;
int rows, space, i, j;
char *nl = "\n\r";

void main(void){
  coef = 1;

  printf("Enter the number of rows: ");
  scanf("%d", &rows);

  for (i = 0; i < rows; i=i+1) {
    for (space = 1; space <= rows - i; space=space+1) print("\n");
    
    for (j = 0; j <= i; j=j+1){
      if (j == 0 || i == 0)
        coef = 1;
       else
        coef = coef * (i - j + 1) / j;
      printf("%u", coef);
      printf(" ");
    }

   }
   return;
}

