CC = gcc
CFLAGS = -std=c11
LIBS = -lm -lncurses

BASENAME = $(notdir $(basename $(FILE)))

.phony: all
all: cc

cc: cc.o char.o debug.o search.o
	$(CC) $(CFLAGS) -o cc cc.o char.o debug.o search.o $(LIBS)
	rm cc.o char.o debug.o search.o

cc.o: cc.c definitions.h cc.h
	$(CC) $(CFLAGS) -c cc.c -o cc.o

char.o: char.c char.h
	$(CC) $(CFLAGS) -c char.c -o char.o

debug.o: debug.c debug.h
	$(CC) $(CFLAGS) -c debug.c -o debug.o

search.o: search.c search.h
	$(CC) $(CFLAGS) -c search.c -o search.o

.phony: clean
clean:
	rm -f cc cc.o char.o debug.o search.o
