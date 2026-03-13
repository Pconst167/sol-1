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
    // Move cursor to line and column 1
    printf("\033[%d;1H", line);
}

void display_option(const char *option, int highlighted) {
    if (highlighted) {
        print_with_escape("\033[7m"); // Inverse (highlight)
    }

    printf("%s", option);
    print_with_escape("\033[0m"); // Reset attributes
    print_with_escape("\033[K");  // Clear to end of line
    putchar('\n');
}

char read_char_from_telnet() {
    // Blocking getchar, replace if needed
    return getchar();
}

int main() {
    int main_selected = 0, sub_selected = 0;
    int is_submenu_open = 0;
    char ch;
    int i;

    print_with_escape("\033[2J");     // Clear screen
    print_with_escape("\033[?25l");   // Hide cursor

    while (1) {
        move_cursor_to_line(1);

        // Print main menu at lines 1 and 2
        for (i = 0; i < 2; ++i) {
            display_option(main_options[i], i == main_selected);
        }

        if (is_submenu_open) {
            // Move cursor explicitly to line 4 for submenu
            move_cursor_to_line(4);
            for (i = 0; i < 2; ++i) {
                display_option(sub_options[i], i == sub_selected);
            }
        } else {
            // Clear submenu lines (line 4 and 5)
            move_cursor_to_line(4);
            print_with_escape("\033[K"); // Clear line 4
            move_cursor_to_line(5);
            print_with_escape("\033[K"); // Clear line 5
        }

        ch = read_char_from_telnet();

        if (ch == 27) {  // ESC sequence
            char seq1 = read_char_from_telnet();
            char seq2 = read_char_from_telnet();

            if (seq1 == '[') {
                if (is_submenu_open) {
                    if (seq2 == 'A' && sub_selected > 0) sub_selected--;
                    else if (seq2 == 'B' && sub_selected < 1) sub_selected++;
                } else {
                    if (seq2 == 'A' && main_selected > 0) main_selected--;
                    else if (seq2 == 'B' && main_selected < 1) main_selected++;
                }
            }
        } else if (ch == ' ') {
            if (main_selected == 0 && !is_submenu_open) {
                is_submenu_open = 1;
                sub_selected = 0;
            } else {
                is_submenu_open = 0;
            }
        } else if (ch == '\n' || ch == '\r') {
            break;
        }
    }

    print_with_escape("\033[?25h");  // Show cursor
    return 0;
}
