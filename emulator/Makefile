CC = gcc
CFLAGS = -Wall -Wextra -Wformat=2 -O3 -march=native -std=c99 
LIBS = -lm

.PHONY: build
  
build: 
	$(CC) $(CFLAGS) ./*.c $(LIBS) -o emulator

clean:
	rm -f *.o
