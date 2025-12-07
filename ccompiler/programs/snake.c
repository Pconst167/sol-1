#include <stdio.h>

char s[8] = {27, '[', '2', 'J', 27, '[', 'H', 0};

int snake_x[8], snake_y[8];
int dx = 1, dy = 0;

void draw_board() {
    int x, y;
    int i;
    char c;
    print(s);
    printf("%d", rand());
    print("\n");
    for (y = 0; y < 20; y++) {
        for (x = 0; x < 40; x++) {
            c = ' ';

            if (x == 0 || x == 39 || y == 0 || y == 19) {
                c = '#';
            } else {
                for (i = 0; i < 8; i++) {
                    if (x == snake_x[i] && y == snake_y[i]) {
                        c = 'o';
                        break;
                    }
                }
            }

            putchar(c);
        }
        putchar('\n');
    }
    return;
}

void update_snake() {
    int i;
    int snkx, snky;
    for (i = 8 - 1; i > 0; i--) {
        snake_x[i] = snake_x[i - 1];
        snake_y[i] = snake_y[i - 1];
    }

    snake_x[0] = snake_x[0] + dx;
    snake_y[0] = snake_y[0] + dy;

    if (rand() % 10 < 2) { // Randomly change direction
        if (dx != 0) {
            dy = rand() % 2 == 0 ? 1 : -1;
            dx = 0;
        } else if (dy != 0) {
            dx = rand() % 2 == 0 ? 1 : -1;
            dy = 0;
        }
    }
    
    snkx = snake_x[0];
    snky = snake_y[0];
    if (snkx <= 0) {
        snake_x[0] = 1;
        dx = 1;
        dy = 0;
    } else if (snkx >= 39) {
        snake_x[0] = 38;
        dx = -1;
        dy = 0;
    } else if (snky <= 0) {
        snake_y[0] = 1;
        dy = 1;
        dx = 0;
    } else if (snky >= 19) {
        snake_y[0] = 18;
        dy = -1;
        dx = 0;
    }
    return;
}

int main() {
    int i;
    for (i = 0; i < 8; i++) {
        snake_x[i] = 20 - i;
        snake_y[i] = 10;
    }

    while (1) {
        draw_board();
        update_snake();
    }

    return 0;
}


