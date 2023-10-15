#include "lib/stdio.h"


const char *main_options[2] = {
    "Main Option 1",
    "Main Option 2"
};

const char *sub_options[2] = {
    "Sub Option 1",
    "Sub Option 2"
};

void print_with_escape(const char* str) {
    while (*str) {
        putchar(*str++);
    }
}

void move_cursor_to_line(int line) {
    // Move cursor to the beginning of the line
    printf("\033[");
    printu(line + 1);
    printf(";0H");
}

void display_option(const char *option, int highlighted) {
    if (highlighted) {
        print_with_escape("\033[7m");
    }

    print_with_escape(option);

    print_with_escape("\033[0m");
    print_with_escape("\033[K");
}

char read_char_from_telnet() {
    // Replace this with your own implementation.
    return getchar();
}

void main() {
    int main_selected = 0, sub_selected = 0;
    int is_submenu_open = 0;
    char ch;
    int i;


    print_with_escape("\033[2J");
    print_with_escape("\033[?25l");  // Hide cursor

    while (1) {
        move_cursor_to_line(0);

        for (i = 0; i < 2; ++i) {
            display_option(main_options[i], i == main_selected);
        }

        if (is_submenu_open) {
            move_cursor_to_line(2);
            for (i = 0; i < 2; ++i) {
                display_option(sub_options[i], i == sub_selected);
            }
        }

        ch = read_char_from_telnet();

        if (ch == 27) {  // Escape sequence
            read_char_from_telnet();  // Read '['

            ch = read_char_from_telnet();  // Read arrow key

            if (is_submenu_open) {
                if (ch == 'A' && sub_selected > 0) sub_selected--;  // Up
                if (ch == 'B' && sub_selected < 1) sub_selected++;  // Down
            } else {
                if (ch == 'A' && main_selected > 0) main_selected--;  // Up
                if (ch == 'B' && main_selected < 1) main_selected++;  // Down
            }
        } else if (ch == ' ') {  // Space bar
            if (main_selected == 0 && !is_submenu_open) {
                is_submenu_open = 1;
                sub_selected = 0;
            } else {
                is_submenu_open = 0;
            }
        } else if (ch == '\n' || ch == '\r') {  // Enter key
            // Do something with the selected options
            break;
        }
    }

    print_with_escape("\033[?25h");  // Show cursor
}
