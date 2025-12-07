CC = gcc
CFLAGS = -std=c99
LIBS = -lm

.PHONY: compile

compile: emulator.c def.h
	$(CC) $(CFLAGS) -o emulator emulator.c $(LIBS)


clean:
	rm -f emulator emulator.o
