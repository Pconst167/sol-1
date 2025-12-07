#include <stdio.h>

void bubble_sort(char arr[1], int n) {
    int i, j;
    char temp;

    for (i = 0; i < n - 1; i++) {
        for (j = 0; j < n - i - 1; j++) {
            if (arr[j] > arr[j + 1]) {
                temp = arr[j];
                arr[j] = arr[j + 1];
                arr[j + 1] = temp;
            }
        }
    }
    return;
}

int main() {
    int n, i;

    char s[100];
    print("Enter the elements of the array as a string: ");
    _gets(s);
    print("OK.\n");

    n = _strlen(s);
    print("Now sorting...\n");
    bubble_sort(s, n);

    print("Sorted array: ");
    for (i = 0; i < n; i++) {
        _putchar(s[i]);
    }
    print("\n");

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