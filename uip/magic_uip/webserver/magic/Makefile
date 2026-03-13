
CC	= lcc
CFLAGS	= -I../uip -I../apps/httpd -DNOFLOAT

ALL	= web

all:	$(ALL)

clean:
	rm -f *.s *.S *.lst *.o *.hex *.sss $(ALL)

hex:	$(ALL)
	tohex $?
