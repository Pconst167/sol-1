#include <stdio.h>

char mystring[256];

void main(){

  printf("Enter a string(256 max): ");
	gets(mystring);
	quick(mystring, strlen(mystring));

  printf("\n");
  printf("Sorted string: ");
	printf(mystring);
  printf("\n");

}

void quick(char *items, int count){
	qs(items, 0, count - 1);
}

void qs(char *items, int left, int right){
	int i, j;
	char x, y;
	
	i = left; j = right;
	x = *(items + ( (left + right) / 2) );
	do{
		while ( ( *(items + i) < x ) && ( i < right ) ) i++;
		while((x < *(items+j)) && (j > left)) j--;
		if(i <= j){
			y = *(items+i);
			*(items+i) = *(items+j);
			*(items+j) = y;
			i++; j--;
		}
	} while(i <= j);

	if(left < j) qs(items, left, j);
	if(i < right) qs(items, i, right);
}