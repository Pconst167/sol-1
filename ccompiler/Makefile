CC = gcc
CFLAGS = -std=c99
LIBS = -lm

.PHONY: compile_file

compile_file: cc
ifeq ($(FILE),)
	@echo "Error: Please provide a file to compile using FILE=<filename>"
	@exit 1
else
	./cc $(FILE)
	@echo
	@wine tasm -1 -b a.s
	@echo
	@xxd -ps a.obj | sed -z 's/\n//g' | tr 'abcdef' 'ABCDEF' | xclip -selection c
	@echo "> .obj copied to clipboard in intel-hex format"
	
	@echo
	@echo -n "Object file size: "; ls -la a.obj | awk '{print $$5}'
	@echo -n "Hex file size : "; ls -la a.obj | awk '{print $$5*2}'
	@echo -n "Number of Assembly lines: "; wc -l a.s
endif

cc: cc.o 
	@$(CC) $(CFLAGS) -o cc cc.o $(LIBS)
	@rm cc.o

cc.o: cc.c def.h
	@$(CC) $(CFLAGS) -c cc.c

clean:
	@rm -f cc cc.o
