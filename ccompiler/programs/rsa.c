#include <stdio.h>

int main() {
    int p, q, n, phi, e, d;
    int i;
    char input_str[100];
    int encrypted_chars[100];
    int encrypted_chars_len ;
    int decrypted_char;
    char c;

    p = 13;
    q = 11;
    n = p * q;
    phi = (p - 1) * (q - 1);
    e = find_e(phi);
    d = find_d(e, phi);

    printf("Public Key: %d, %d\n", n, e);
    printf("Private Key: %d, %d\n", n, d);

    printf("Enter a string: ");
    gets(input_str);

    encrypted_chars_len = 0;
    printf("\nEncrypted text: ");
    for (i = 0; input_str[i] != '\0' && input_str[i] != '\n'; i++) {
        encrypted_chars[i] = mod_exp(input_str[i], e, n);
        printf("%d ", encrypted_chars[i]);
        encrypted_chars_len++;
    }

    printf("\nDecrypted text: ");
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