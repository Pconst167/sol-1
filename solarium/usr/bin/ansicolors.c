#include <stdio.h>


int main() {
    display_colors();
}

void display_colors() {
    int fg, bg;

    printf("ANSI Color Chart: 256 Colors\n\n");

    printf("Foreground colors:\n");
    for (fg = 0; fg < 256; ++fg) {
        printfn("\033[38;5;", fg);
        printfn("m ", fg);
        if ((fg + 1) % 16 == 0) {
            printf("\033[m\n");
        }
    }
    printf("\033[m\n");  // Reset to default

    printf("\nBackground colors:\n");
    for (bg = 0; bg < 256; ++bg) {
        printfn("\033[48;5;", bg);
        printfn("m ", bg);
        if ((bg + 1) % 16 == 0) {
            printf("\033[m\n");
        }
    }
    printf("\033[m\n");  // Reset to default

    printf("\nForeground and Background colors:\n");
    for (fg = 0; fg < 16; ++fg) {
        for (bg = 0; bg < 16; ++bg) {
            print_color(fg, bg);
            if ((bg + 1) % 16 == 0) {
                printf("\033[m ");
            }
        }
        if ((fg + 1) % 16 == 0) {
            printf("\033[m\n");
        }
    }
    printf("\033[m\n");  // Reset to default
}

void print_color(int fg, int bg) {
    printfn("\033[38;5;", fg);
    printfn(";48;5;", bg);
    printfn("m ", fg);
    printfn("/", bg);
}

