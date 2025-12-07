#include <stdio.h>
#include <math.h>

unsigned int top;

void main(void){
	unsigned int N, i;

	printf("Find primes up to: ");
	N = scann();

	printf("\n");
	for (i = 2; i <= N; i++) {
			if (isPrime(i)) {
					printf("%u\n", i);
			}
	}

	return 0;
}

unsigned int sqrt(unsigned int n) {
    if (n <= 1) {
        return n;
    }

    unsigned int x;
    unsigned int y;
    x = n;
    y = (x + n / x) / 2;

    while (y < x) {
        x = y;
        y = (x + n / x) / 2;
    }

    return x;
}

void primes1(void){
	unsigned int n, i, s, count, divides;

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
			if(i >= s) break;
		}
		
		if(divides == 0){
			count = count + 1;	
			printf("%d\n", n);
		}
		n = n + 1;
	}
	return;
}

char isPrime(unsigned int num) {
	unsigned int i;

	if (num <= 1) return 0;
	for (i = 2; i * i <= num; i++) {
			if (num % i == 0) return 0;
	}
	return 1;
}