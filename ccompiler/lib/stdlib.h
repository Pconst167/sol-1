#define	EXIT_FAILURE	1	/* Failing exit status.  */
#define	EXIT_SUCCESS	0	/* Successful exit status.  */

/* The largest number rand will return (same as INT_MAX).  */
#define EOF -1
#define HEAP_SIZE 16000

// for random number generator
unsigned int rng_state = 0;

struct block{
    unsigned int size;
    struct block *next;
};

typedef struct block block_t;
block_t *free_list = 0;

void exit(int status){
  asm{
    ccmovd status
    mov b, [d] ; return value
    syscall sys_terminate_proc
  }
}

void *memset(char *s, char c, int size){
  int i;
  for(i = 0; i < size; i++){
    *(s+i) = c;
  }
  return s;
}

int atoi(char *str) {
  int result = 0;  // Initialize result
  int sign = 1;    // Initialize sign as positive

  // Skip leading whitespaces
  while (*str == ' ') str++;

  // Check for optional sign
  if (*str == '-' || *str == '+') {
    if (*str == '-') sign = -1;
    str++;
  }

  // Loop through all digits of input string
  while (*str >= '0' && *str <= '9') {
    result = result * 10 + (*str - '0');
    str++;
  }

  return sign * result;
}

int seconds(){
  int sec;
  asm{
      mov al, 0
      syscall sys_rtc					; get seconds
      mov al, ah
      ccmovd sec
      mov ah, 0
      mov [d], a
  }
  return sec;
}


// Initialize with the current time (only once)
void seed_rng(void) {
  unsigned int t = seconds();
  // scramble to avoid linear correlation
  t = t ^ (t << 13);
  t = t ^ (t >> 17);
  t = t ^ (t << 5);
  rng_state = t | 1;  // ensure non-zero
}

// Return a 16-bit pseudo-random number
unsigned int rand(void) {
  if (rng_state == 0)
    seed_rng();

  // Linear Congruential Generator (LCG)
  rng_state = rng_state * 25173u + 13849u;

  // Return upper 16 bits (better distributed)
  return rng_state;
}

void *alloc(unsigned int size) {
  block_t **b = &free_list;
  block_t *prev = 0;
  block_t *pp;
  block_t *blk = *b;

  // Align size to 2 bytes
  if (size & 1) size++;

  // Search free list
  while (*b) {
    pp = *b;
    if (pp->size >= size) {
      if (prev)
        prev->next = blk->next;
      else
        free_list = blk->next;
      return (void*)(blk + sizeof(struct block));
    }
    prev = *b;
    b = &pp->next;
  }
  
  // No suitable free block → allocate new
  if (heap_top + sizeof(struct block) + size > heap + HEAP_SIZE)
    return 0; // out of memory

  blk = heap_top;
  blk->size = size;
  heap_top = heap_top + sizeof(block_t) + size;
  return (void*)(blk + sizeof(struct block));
}

void free(char *ptr) {
  if (!ptr) return;
  block_t *blk = ptr - sizeof(struct block);
  blk->next = free_list;
  free_list = blk;
}

/*
// heap and heap_top are defined internally by the compiler
// so that 'heap' is the last variable in memory and therefore can grow upwards
// towards the stack
char *alloc(int bytes){
  heap_top = heap_top + bytes;
  return heap_top - bytes;
}

/* Free a block allocated by `malloc', `realloc' or `calloc'.  
char *free(int bytes){
  return heap_top = heap_top - bytes;
}
*/