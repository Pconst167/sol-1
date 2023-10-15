CC = gcc
CFLAGS = -std=c99
LIBS = -lm

.PHONY: compile_file

extern_setup: extern_setup.o 
	@$(CC) $(CFLAGS) -o extern_setup extern_setup.o $(LIBS)
	@rm extern_setup.o

extern_setup.o: extern_setup.c
	@$(CC) $(CFLAGS) -c extern_setup.c

clean:
	@rm -f extern_setup extern_setup.o
