#include "stdio.h"

void main(){
    int n;
    int result;
    
    printf("Factorial of: ");
    n = scann();

    result = fact(n);

    printf("\nResult: ");
    print_unsigned(result);
    printf("\n");

    return;

}

int fact(int n){
    if(n == 1) return 1;
    else return n*fact(n-1);
}