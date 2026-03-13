#include <stdio.h>

#define WIDTH  40
#define HEIGHT 40
#define NUM_BALLS 4

struct Ball{
    int x;
    int y;
    int vx;
    int vy;
    int old_x;
    int old_y;
} ;

struct Ball balls[NUM_BALLS] = {
    {5, 5, 1, 1, 5, 5},
    {30, 3, -1, 1, 30, 3},
    {10, 20, 1, -1, 10, 20},
    {25, 15, -1, -1, 25, 15},
};

// Move terminal cursor to (row, col)
void gotoxy(int row, int col) {
    printf("\033[%d;%dH", row + 1, col + 1);
}

// Erase a character
void erase_char(int x, int y) {
    if (x >= 0 && x < WIDTH && y >= 0 && y < HEIGHT) {
        gotoxy(y, x);
        putchar(' ');
    }
}

// Draw a ball at (x, y)
void draw_char(int x, int y, char c) {
    if (x >= 0 && x < WIDTH && y >= 0 && y < HEIGHT) {
        gotoxy(y, x);
        putchar(c);
    }
}

// Update ball positions, handle collisions
void update_positions() {
    int i;
    int j;

    i = 0;
    while (i < NUM_BALLS) {
        balls[i].old_x = balls[i].x;
        balls[i].old_y = balls[i].y;

        balls[i].x = balls[i].x + balls[i].vx;
        balls[i].y = balls[i].y + balls[i].vy;

        if (balls[i].x <= 0 || balls[i].x >= WIDTH - 1) {
            balls[i].vx = 0 - balls[i].vx;
        }
        if (balls[i].y <= 0 || balls[i].y >= HEIGHT - 1) {
            balls[i].vy = 0 - balls[i].vy;
        }

        i = i + 1;
    }

    // Ball-to-ball collision
    i = 0;
    while (i < NUM_BALLS) {
        j = i + 1;
        while (j < NUM_BALLS) {
            if (balls[i].x == balls[j].x && balls[i].y == balls[j].y) {
                int temp;
                temp = balls[i].vx;
                balls[i].vx = balls[j].vx;
                balls[j].vx = temp;

                temp = balls[i].vy;
                balls[i].vy = balls[j].vy;
                balls[j].vy = temp;
            }
            j = j + 1;
        }
        i = i + 1;
    }
}

int main() {
    int i;
    printf("\033[2J"); // clear screen once

    while (1) {
        // erase old positions
        i = 0;
        while (i < NUM_BALLS) {
            erase_char(balls[i].old_x, balls[i].old_y);
            i = i + 1;
        }

        update_positions();

        // draw new positions
        i = 0;
        while (i < NUM_BALLS) {
            draw_char(balls[i].x, balls[i].y, 'O');
            i = i + 1;
        }

        // no delay — relies on loop speed
    }

    return 0;
}
