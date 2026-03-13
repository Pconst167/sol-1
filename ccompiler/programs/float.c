#include <stdio.h>

struct t_float16 {
    int mantissa;  // 16-bit integer for the mantissa
    char exponent; // 8-bit integer for the exponent
};

int main() {
    struct t_float16 a, b;
    struct t_float16 sum;

    printf("a mantissa: ");
    a.mantissa = scann();
    printf("a exponent: ");
    a.exponent = scann();
    printf("b mantissa: ");
    b.mantissa = scann();
    printf("b exponent: ");
    b.exponent = scann();

    sum = add(a, b);

    printf("Sum mantissa: %d\n", sum.mantissa);
    printf("Sum exponent: %d\n", sum.exponent);

    return 0;
}

struct t_float16 add(struct t_float16 a, struct t_float16 b) {
    struct t_float16 result;

    // Align exponents
    if (a.exponent < b.exponent) {
        a.mantissa = a.mantissa >> (b.exponent - a.exponent);
        a.exponent = b.exponent;
    } else if (b.exponent < a.exponent) {
        b.mantissa = b.mantissa >> (a.exponent - b.exponent);
        b.exponent = a.exponent;
    }

    // Add mantissas
    result.mantissa = a.mantissa + b.mantissa;
    result.exponent = a.exponent;
    // Normalize result
    while (result.mantissa > 32767 || result.mantissa < -32767) {
    //while (result.mantissa > 2147483647 || result.mantissa < -2147483648) {
        result.mantissa = result.mantissa / 2;
        result.exponent = result.exponent + 1;
    }

    return result;
}

struct t_float16 subtract(struct t_float16 a, struct t_float16 b) {
    struct t_float16 result;

    // Align exponents
    if (a.exponent < b.exponent) {
        a.mantissa = a.mantissa >> (b.exponent - a.exponent);
        a.exponent = b.exponent;
    } else if (b.exponent < a.exponent) {
        b.mantissa = b.mantissa >> (a.exponent - b.exponent);
        b.exponent = a.exponent;
    }

    // Subtract mantissas
    result.mantissa = a.mantissa - b.mantissa;
    result.exponent = a.exponent;

    // Normalize result
    while (result.mantissa > 32767 || result.mantissa < -32767) {
    //while (result.mantissa > 2147483647 || result.mantissa < -2147483648) {
        result.mantissa = result.mantissa / 2;
        result.exponent = result.exponent + 1;
    }

    return result;
}
