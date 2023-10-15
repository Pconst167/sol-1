#include <stdio.h>



int main(int argc) {
  unsigned int fg, bg, color;
  // Clear screen
  printf("\033[2J");
  
  // Set cursor position to top-left corner
  printf("\033[H");
  
  // Bold text
  printf("\033[1m");
  printf("Bold Text");
  printf("\033[0m\n");
  
  // Underlined text
  printf("\033[4m");
  printf("Underlined Text");
  printf("\033[0m\n");

  // Blinking text
  printf("\033[5m");
  printf("Blinking Text");
  printf("\033[0m\n");
  
  // Inverted colors
  printf("\033[7m");
  printf("Inverted Colors");
  printf("\033[0m\n");
  
  // Reset all
  printf("\033[0m");
  printf("Reset All\n");
  
  // Foreground and background colors
  for (bg = 40; bg <= 47; ++bg) {
    for (fg = 30; fg <= 37; ++fg) {
      printf("\033[");
      printu(fg);
      printf("m\033[");
      printu(bg);
      printf("m ");
      printu(fg);
      printf("/");
      printu(bg);
      printf(" ");
    }
    printf("\033[0m\n");
  }
  
  // 256-color chart
  printf("256-Color Chart:\n");
  for (color = 0; color < 256; ++color) {
    printf("\033[48;5;");
    printu(color);
    printf("m  ");
    printu(color);
    printf(" \033[0m");
    if ((color + 1) % 16 == 0) {
      printf("\n");
    }
  }
  
  return 0;
}
