CC = gcc
CFLAGS = -std=c99
LIBS = -lm

solfs: solfs.o 
	@$(CC) $(CFLAGS) -o solfs solfs.o $(LIBS)
	@rm solfs.o

solfs.o: solfs.c
	@$(CC) $(CFLAGS) -c solfs.c

clean:
	@rm -f solfs solfs.o
