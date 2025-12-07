CC = gcc
CFLAGS = -std=c99
LIBS = -lm

.PHONY: compile_file

compile_file: micro
ifeq ($(FILE),)
	@echo "Error: Please provide a file to compile using FILE=<filename>"
	@exit 1
endif

micro: micro.o 
	$(CC) $(CFLAGS) -o micro micro.o $(LIBS)
	rm micro.o

micro.o: micro.c def.h
	$(CC) $(CFLAGS) -c micro.c

clean:
	rm -f micro micro.o
