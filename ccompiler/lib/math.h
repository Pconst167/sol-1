int sqrt(int n) {
  int x;
  int y;

  if (n <= 1) {
      return n;
  }

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