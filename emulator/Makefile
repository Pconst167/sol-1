CC = gcc
CFLAGS = -std=c99
LIBS = -lm

.PHONY: compile_file

compile_file: emulator
ifeq ($(FILE),)
	@echo "Error: Please provide a file to compile using FILE=<filename>"
	@exit 1
else
	./emulator $(FILE)
endif

emulator: emulator.o 
	$(CC) $(CFLAGS) -o emulator emulator.o $(LIBS)
	rm emulator.o

emulator.o: emulator.c def.h
	$(CC) $(CFLAGS) -c emulator.c

clean:
	rm -f emulator emulator.o
