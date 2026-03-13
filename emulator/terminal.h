#ifndef TERMINAL_H
#define TERMINAL_H

#include <stdint.h>

extern struct termios g_term_orig;
extern int g_term_inited;

void term_restore(void);
int kbhit(void);
void term_raw_noecho(void);
int read_stdin_byte(uint8_t *out);

#endif