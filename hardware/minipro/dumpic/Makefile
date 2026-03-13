CC = i686-w64-mingw32-gcc

all: dump-infoic-dll.exe dump-infoic2plus-dll.exe

dump-infoic-dll.exe: dump-infoic-dll.c
	$(CC) -o $@ -m32 -Wall -W dump-infoic-dll.c

dump-infoic2plus-dll.exe: dump-infoic2plus-dll.c
	$(CC) -o $@ -m32 -Wall -W dump-infoic2plus-dll.c
clean:
	$(RM) dump-infoic-dll.exe dump-infoic2plus-dll.exe
