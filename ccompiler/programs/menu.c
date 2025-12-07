#include "lib/stdio.h"

const char *options[] = {
    "List Guestbook",
    "Sign Guestbook",
    "Exit"
};

char *filename = "/home/guest/data.txt";
char *guestbook_data;

void print_with_escape(const char* str) {
    while (*str) {
        putchar(*str++);
    }
}

void move_cursor_to_line(int line) {
    // Move cursor to the beginning of the line
    printf("\033[");
    printu(line + 3);
    printf(";0H");
}

void display_option(const char *option, int highlighted) {
    if (highlighted) {
        // Reverse video for selected item
        print_with_escape("\033[7m");
    }

    // Print option
    print_with_escape(option);

    // Reset text attributes
    print_with_escape("\033[0m");

    // Clear to the end of the line in case the new label is shorter than the old one
    print_with_escape("\033[K");
}

void main() {
    int selected = 1;
    int previously_selected = 1;
    char ch;
    int i;

    guestbook_data = alloc(5000);
    // CLear
    print_with_escape("\033[2J");


    move_cursor_to_line(1);
    printf("**** Sol-1 Guestbook ****\n");

    // Hide the cursor
    print_with_escape("\033[?25l");

    // Display initial menu
    for (i = 0; i < 3; ++i) {
        move_cursor_to_line(i);
        display_option(options[i], i == selected);
    }

    // Listen to keyboard or read from socket
    while (1) {
        // Read one character (from Telnet)
        ch = getchar();  // Implement this function based on your OS

        previously_selected = selected;

        if (ch == 27) {  // Escape sequence
            // Read '['
            ch = getchar();

            if (ch == '[') {
                // Read the arrow key identifier
                ch = getchar();

                if (ch == 'A' && selected > 0) {  // Up arrow
                    selected--;
                } else if (ch == 'B' && selected < 4) {  // Down arrow
                    selected++;
                }
            }
        } else if (ch == '\n' || ch == '\r') {  // Enter key
          switch(selected){
            case 0: 
                move_cursor_to_line(6);
                asm{
                  meta mov d, guestbook_data
                  mov d, [d]
                  mov di, d
                  meta mov d, filename
                  mov d, [d]
                  mov al, 20
                  syscall sys_filesystem				; read textfile into shell buffer
                }
                printf(guestbook_data);

                print_with_escape("\033[7m"); // highlight
                printf("Press Return to exit.");
                // Reset text attributes
                print_with_escape("\033[0m");
                while(1){
                  ch = getchar();
                  if(ch == 0x0A || ch == 0x0D){
                    print_with_escape("\033[2J"); // clear
                    // Display initial menu
                    for (i = 0; i < 3; ++i) {
                        move_cursor_to_line(i);
                        display_option(options[i], i == selected);
                    }
                    continue;
                  }

                }

                break;
            case 1:
                move_cursor_to_line(6);
                printf("Soon!!");
                break;
            case 2:
                print_with_escape("\033[?25h");
                return;
          }
        }

        // Move cursor to previously selected line and redraw it without highlight
        move_cursor_to_line(previously_selected);
        display_option(options[previously_selected], 0);

        // Move cursor to newly selected line and redraw it with highlight
        move_cursor_to_line(selected);
        display_option(options[selected], 1);
    }

    // Show the cursor
    print_with_escape("\033[?25h");
}
