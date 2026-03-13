#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>
#include <termios.h>
#include <unistd.h>
#include "terminal.h"

struct termios g_term_orig;
int g_term_inited = 0;

int kbhit(void) {
  struct timeval tv = {0L, 0L};
  fd_set fds;
  FD_ZERO(&fds);
  FD_SET(STDIN_FILENO, &fds);
  return select(STDIN_FILENO+1, &fds, NULL, NULL, &tv);
}

void term_restore(void) {
  if (g_term_inited) {
    tcsetattr(STDIN_FILENO, TCSANOW, &g_term_orig);
  }
}

void term_raw_noecho(void) {
  if (tcgetattr(STDIN_FILENO, &g_term_orig) != 0) {
    perror("tcgetattr");
    exit(1);
  }
  g_term_inited = 1;
  atexit(term_restore);

  struct termios raw = g_term_orig;

  /* Non-canonical + no echo */
  raw.c_lflag &= (tcflag_t) ~(ICANON | ECHO);

  /* Optional but usually nice for “raw-ish” input */
  raw.c_lflag &= (tcflag_t) ~(IEXTEN | ISIG);   // no Ctrl-C/Z signals
  raw.c_iflag &= (tcflag_t) ~(IXON | ICRNL);    // no XON/XOFF, no CR->NL
  raw.c_oflag |= ONLCR;      // map NL -> CRNL

  /* Make reads return immediately (we still use select()) */
  raw.c_cc[VMIN]  = 0;
  raw.c_cc[VTIME] = 0;

  if (tcsetattr(STDIN_FILENO, TCSANOW, &raw) != 0) {
    perror("tcsetattr");
    exit(1);
  }

  /* If you want your "IRQ" prints to show immediately: */
  setvbuf(stdout, NULL, _IONBF, 0);
}

int read_stdin_byte(uint8_t *out) {
  unsigned char c;
  ssize_t n = read(STDIN_FILENO, &c, 1);
  if (n == 1) { *out = (uint8_t)c; return 1; }
  return 0; // 0 = none available
}