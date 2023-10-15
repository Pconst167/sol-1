int sqrt(int n) {
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

int exp(int base, int exp){
  int i;
  int result = 1;
  for(i = 0; i < exp; i++){
    result = result * base;
  }
  return result;
}