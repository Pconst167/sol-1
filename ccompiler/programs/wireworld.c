#include <stdio.h>

enum CellState {
    EMPTY,
    CONDUCTOR,
    ELECTRON_HEAD,
    ELECTRON_TAIL
};

int grid[20][40];
int new_grid[20][40];
int x, y, dx, dy;
int nx, ny;
int head_count;
char c;

void print_grid() {
    for (y = 0; y < 20; ++y) {
        for (x = 0; x < 40; ++x) {
            switch (grid[y][x]) {
                case EMPTY: c = ' '; break;
                case CONDUCTOR: c = '*'; break;
                case ELECTRON_HEAD: c = 'H'; break;
                case ELECTRON_TAIL: c = 'T'; break;
            }
            putchar(c);
        }
        putchar('\n');
    }
    return;
}

void iterate(){
    for (y = 0; y < 20; ++y){
        for (x = 0; x < 40; ++x){
            head_count = 0;
            for (dy = -1; dy <= 1; dy++){
                for (dx = -1; dx <= 1; dx++) {
                    if (dx == 0 && dy == 0) continue;
                    nx = x + dx;
                    ny = y + dy;
                    if (nx >= 0 && nx < 40 && ny >= 0 && ny < 20 && grid[ny][nx] == ELECTRON_HEAD){
                      head_count++;
                    }
                }
            }
            
            switch (grid[y][x]) {
                case EMPTY: new_grid[y][x] = EMPTY; break;
                case CONDUCTOR: new_grid[y][x] = (head_count == 1 || head_count == 2) ? ELECTRON_HEAD : CONDUCTOR; break;
                case ELECTRON_HEAD: new_grid[y][x] = ELECTRON_TAIL; break;
                case ELECTRON_TAIL: new_grid[y][x] = CONDUCTOR; break;
            }
        }
    }

    for (y = 0; y < 20; ++y) {
        for (x = 0; x < 40; ++x) {
            grid[y][x] = new_grid[y][x];
        }
    }
    return;
}

int main() {
    int i;
// Clock signal 1
grid[5][5] = CONDUCTOR;
grid[6][5] = ELECTRON_HEAD;
grid[7][5] = CONDUCTOR;
grid[6][6] = ELECTRON_TAIL;
grid[6][7] = CONDUCTOR;

// Clock signal 2
grid[5][10] = CONDUCTOR;
grid[6][10] = ELECTRON_HEAD;
grid[7][10] = CONDUCTOR;
grid[6][11] = ELECTRON_TAIL;
grid[6][12] = CONDUCTOR;

// Wires connecting the clock signals to the OR gate
for (i = 8; i <= 14; i++) {
    grid[7][i] = CONDUCTOR;
}

// OR gate (Diode-Resistor)
grid[7][15] = CONDUCTOR;
grid[6][15] = ELECTRON_TAIL;
grid[8][15] = ELECTRON_TAIL;
grid[6][16] = CONDUCTOR;
grid[8][16] = CONDUCTOR;

// Output wire from the OR gate
for (i = 17; i <= 25; i++) {
    grid[7][i] = CONDUCTOR;
}


    while (1) {
        print_grid();
        iterate();
    }

    return 0;
}