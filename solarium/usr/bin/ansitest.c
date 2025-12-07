#include <stdio.h>

int main(void) {
    unsigned int fg, bg, color;

    // Clear screen and move to top-left
    printf("\033[2J\033[H");

    // Bold text
    printf("\033[1mBold Text\033[0m\n");

    // Underlined text
    printf("\033[4mUnderlined Text\033[0m\n");

    // Blinking text (not all terminals support this)
    printf("\033[5mBlinking Text\033[0m\n");

    // Inverted colors
    printf("\033[7mInverted Colors\033[0m\n");

    // Reset all
    printf("Reset All\n\n");

    // 8-color foreground/background combinations
    for (bg = 40; bg <= 47; ++bg) {
        for (fg = 30; fg <= 37; ++fg) {
            printf("\033[%d;%dm %d/%d ", fg, bg, fg, bg);
        }
        printf("\033[0m\n");
    }

    // 256-color chart
    printf("\n256-Color Chart:\n");
    for (color = 0; color < 256; ++color) {
        printf("\033[48;5;%dm %3d \033[0m", color, color);
        if ((color + 1) % 16 == 0)
            printf("\n");
    }

    printf("\n");
    return 0;
}
