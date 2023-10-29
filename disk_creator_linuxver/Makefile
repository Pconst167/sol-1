CC = gcc
CFLAGS = -std=c99
LIBS = -lm

sol1_disk_creator: sol1_disk_creator.o 
	@$(CC) $(CFLAGS) -o sol1_disk_creator sol1_disk_creator.o $(LIBS)
	@rm sol1_disk_creator.o

sol1_disk_creator.o: sol1_disk_creator.c
	@$(CC) $(CFLAGS) -c sol1_disk_creator.c

clean:
	@rm -f sol1_disk_creator sol1_disk_creator.o
