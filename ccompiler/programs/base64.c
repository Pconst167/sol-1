#include <stdio.h>

char *base64_table = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

int main() {
  char input[512];
  char output[256];

  printf("\nEnter a base64 encoded string to decode: ");
  gets(input);

  base64_encode(input, output);

  printf("\nEncoded string: %s\n", output);

  base64_decode(output, input);

  printf("\nDecoded string: %s\n", input);

  return 0;
}

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

int base64_char_value(char c) {
  if (c >= 'A' && c <= 'Z') return c - 'A';
  if (c >= 'a' && c <= 'z') return c - 'a' + 26;
  if (c >= '0' && c <= '9') return c - '0' + 52;
  if (c == '+') return 62;
  if (c == '/') return 63;
  return -1;
}

void base64_decode(char *input, char *output) {
  int i = 0, j = 0, k = 0;
  int input_len;
  unsigned char input_buffer[4];
  unsigned char output_buffer[3];

  input_len = strlen(input);

  while (input_len-- && (input[k] != '=') && base64_char_value(input[k]) != -1) {
    input_buffer[i++] = input[k++];
    if (i == 4) {
      for (i = 0; i < 4; i++) {
        input_buffer[i] = base64_char_value(input_buffer[i]);
      }
      output_buffer[0] = (input_buffer[0] << 2) + ((input_buffer[1] & 0x30) >> 4);
      output_buffer[1] = ((input_buffer[1] & 0x0F) << 4) + ((input_buffer[2] & 0x3C) >> 2);
      output_buffer[2] = ((input_buffer[2] & 0x03) << 6) + input_buffer[3];

      for (i = 0; i < 3; i++) {
        output[j++] = output_buffer[i];
      }
      i = 0;
    }
  }

  if (i) {
    for (k = i; k < 4; k++) {
      input_buffer[k] = 0;
    }

    for (k = 0; k < 4; k++) {
      input_buffer[k] = base64_char_value(input_buffer[k]);
    }

    output_buffer[0] = (input_buffer[0] << 2) + ((input_buffer[1] & 0x30) >> 4);
    output_buffer[1] = ((input_buffer[1] & 0x0F) << 4) + ((input_buffer[2] & 0x3C) >> 2);

    for (k = 0; k < i - 1; k++) {
      output[j++] = output_buffer[k];
    }
  }
  output[j] = '\0';
}
