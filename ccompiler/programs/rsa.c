#include "stdio.h"

int main() {
    int p, q, n, phi, e, d;
    p = 13;
    q = 11;
    n = p * q;
    phi = (p - 1) * (q - 1);
    e = find_e(phi);
    d = find_d(e, phi);

    printf("Public Key: (");
    printu(n);
    printf(", ");
    printu(e);
    printf(")\n");

    printf("Private Key: (");
    printu(n);
    printf(", ");
    printu(d);
    printf(")\n");

    char input_str[100];
    printf("Enter a string: ");
    gets(input_str);

    int encrypted_chars[100];
    int encrypted_chars_len ;
    encrypted_chars_len = 0;
    printf("Encrypted text: ");
    int i;
    for (i = 0; input_str[i] != '\0' && input_str[i] != '\n'; i++) {
        encrypted_chars[i] = mod_exp(input_str[i], e, n);
        printu(encrypted_chars[i]);
        printf(" ");
        encrypted_chars_len++;
    }
    printf("\n");

    int decrypted_char;
    char c;
    printf("Decrypted text: ");
    for (i = 0; i < encrypted_chars_len; i++) {
        decrypted_char = mod_exp(encrypted_chars[i], d, n);
        c = decrypted_char;
        putchar(c);
    }
    printf("\n");

    return 0;
}



int gcd(int a, int b) {
    if (b == 0) {
        return a;
    }
    return gcd(b, a % b);
}

int mod_exp(int base, int exp, int mod) {
    int result;
    result = 1;
    while (exp > 0) {
        if (exp & 1) {
            result = (result * base) % mod;
        }
        exp = exp >> 1;
        base = (base * base) % mod;
    }
    return result;
}

int find_e(int phi) {
    int e;
    for (e = 2; e < phi; e++) {
        if (gcd(e, phi) == 1) {
            return e;
        }
    }
    return 0;
}

int find_d(int e, int phi) {
    int d;
    for (d = 2; d < phi; d++) {
        if ((d * e) % phi == 1) {
            return d;
        }
    }
    return 0;
}