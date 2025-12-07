#include <stdio.h>
#include <math.h>

//  X[k] = sum{n=0 to N-1}(x_real[n]*exp(-2pi*i*k*n/N))
//  x_real[n] = (1/N)*sum{k=0 to N-1}(X[k]*exp(2pi*i*k*n/N))
#define N 32

void dft(float x_real[N], float X_real[N], float X_img[N]);
void idft(float x_real[N], float x_img[N], float X_real[N], float X_img[N]);

//float x_real[N] = {4, -3.5549, 2.4142, -1.0583, 0, 0.4725, -0.4142, 0.1407, 0, 0.1407, -0.4142, 0.4725, 0, -1.0583, 2.4142, -3.5549};
//float x_img[N] = {0.0000, 0.7071, -1.0000, 0.7071, 0.0000, -0.7071, 1.0000, -0.7071, 0.0000, 0.7071, -1.0000, 0.7071, 0.0000, -0.7071, 1.0000, -0.7071};
float x_real[N] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
float x_img[N] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
float X_real[N];
float X_img[N];

FILE *fp;

int main(){
  fp = fopen("plotdata.dat", "w+");

  dft(x_real, X_real, X_img);

  printf("DFT: \n");
  for(int k = 0; k < N; k++){
    printf("X[%2d] = %8.4f + %8.4fi, M = %6.4f, A = %6.4f\n", k, X_real[k], X_img[k], sqrt(X_real[k]*X_real[k] + X_img[k]*X_img[k]), atan2(X_img[k], X_real[k]));
  }


  idft(x_real, x_img, X_real, X_img);
  printf("IDFT: \n");
  for(int n = 0; n < N; n++){
    printf("x_real[%2d] = %8.4f + %8.4fi, M = %6.4f, A = %6.4f\n", n, x_real[n], x_img[n], sqrt(x_real[n]*x_real[n] + x_img[n]*x_img[n]), atan2(x_img[n], x_real[n]));
  }

  fprintf(fp, "# k  X[k]\n");
  for(int k = 0; k < N; k++){
    fprintf(fp, "%d  %.5f\n", k, sqrt(X_real[k]*X_real[k] + X_img[k]*X_img[k]));
  }

  fclose(fp);
}

void dft(float x_real[N], float X_real[N], float X_img[N]){
//  X[k] = sum{n=0 to N-1}(x_real[n]*exp(-2pi*i*k*n/N))
/*
  for(int k = 0; k < N; k++){
    X_real[k] = 0;
    X_img[k] = 0;
    for(int n = 0; n < N; n++){
      X_real[k] = X_real[k] + x_real[n] * cos(-2*M_PI*n*k/N);
      X_img[k] = X_img[k] + x_real[n] * sin(-2*M_PI*n*k/N);
    }
  }
*/

  for(int k = 0; k < N; k++){
    X_real[k] = 0;
    X_img[k] = 0;
  }
  for(int n = 0; n < N; n++){
    for(int k = 0; k < N; k++){
      X_real[k] = X_real[k] + x_real[n] * cos(-2*M_PI*n*k/N);
      X_img[k] = X_img[k] + x_real[n] * sin(-2*M_PI*n*k/N);
    }
  }
}

void idft(float x_real[N], float x_img[N], float X_real[N], float X_img[N]){
//  x_real[n] = (1/N)*sum{k=0 to N-1}(X[k]*exp(2pi*i*k*n/N))
  for(int n = 0; n < N; n++){
    x_real[n] = 0;
    x_img[n] = 0;
    for(int k = 0; k < N; k++){
      x_real[n] = x_real[n] + X_real[k] * cos(2*M_PI*n*k/N) - X_img[k] *  sin(2*M_PI*n*k/N);
      x_img[n] = x_img[n] + X_real[k] *  sin(2*M_PI*n*k/N) + X_img[k] * cos(2*M_PI*n*k/N);
    }
    x_real[n] = x_real[n] / N;
    x_img[n] = x_img[n] / N;
  }

}