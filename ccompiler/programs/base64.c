#include "stdio.h"

char *base64_table = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

void base64_encode(char *input, char *output) {
  int i = 0;
  int j = 0;
  int k;
  int input_len;
  unsigned char input_buffer[3];
  unsigned char output_buffer[4];
  input_len = strlen(input);

  while (input_len--) {
    input_buffer[i++] = *(input++);
    if (i == 3) {
      output_buffer[0] = (input_buffer[0] & 0xFC) >> 2;
      output_buffer[1] = ((input_buffer[0] & 0x03) << 4) + ((input_buffer[1] & 0xF0) >> 4);
      output_buffer[2] = ((input_buffer[1] & 0x0F) << 2) + ((input_buffer[2] & 0xC0) >> 6);
      output_buffer[3] = input_buffer[2] & 0x3F;

      for (i = 0; i < 4; i++) {
        output[j++] = base64_table[output_buffer[i]];
      }
      i = 0;
    }
  }

  if (i) {
    for (k = i; k < 3; k++) {
      input_buffer[k] = '\0';
    }

    output_buffer[0] = (input_buffer[0] & 0xFC) >> 2;
    output_buffer[1] = ((input_buffer[0] & 0x03) << 4) + ((input_buffer[1] & 0xF0) >> 4);
    output_buffer[2] = ((input_buffer[1] & 0x0F) << 2) + ((input_buffer[2] & 0xC0) >> 6);

    for (k = 0; k < i + 1; k++) {
      output[j++] = base64_table[output_buffer[k]];
    }

    while (i++ < 3) {
      output[j++] = '=';
    }
  }
  output[j] = '\0';
}

int main() {
  char input[256];
  char output[512];

  printf("Enter a string to encode in base64: ");
  gets(input);

  base64_encode(input, output);

  printf("Base64 encoded string: ");
  printf(output);
  printf("\n");

  return 0;
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