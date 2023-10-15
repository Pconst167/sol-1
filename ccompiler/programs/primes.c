#include "lib/stdio.h"
#include "lib/math.h"


unsigned int n;
unsigned int i;
unsigned int s;
unsigned int count = 0;
unsigned int divides;
unsigned int top;

void main(void){
	printf("Max: ");
	top = scann();
	date();
	primes();
	date();

	return;
}

void primes(void){
	n = 2;
	while(n < top){
		s = sqrt(n);
		divides = 0;

		i = 2;
		while(i <= s){

			if(n % i == 0){
				divides = 1;
				break;
			}
			i = i + 1;
			if(i == n) break;
		}
		
		if(divides == 0){
			count = count+1;	
			printu(n);
			printf("\n");
			asm{
				meta mov d, n
				mov bl, [d]
				mov al, 2
				syscall sys_system
			}
		}
		n = n + 1;
	}
	return;
}

