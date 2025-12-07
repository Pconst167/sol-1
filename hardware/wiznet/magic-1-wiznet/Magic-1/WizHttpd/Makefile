SRCS	=	httpd.c net.c html_finger.c
OBJECTS	=	httpd.o net.o html_finger.o

BINDIR	=	$(IMAGE)/bin
CC =		clcc -A -A
CPPFLAGS =	-I. -I.. -D_MINIX -D_POSIX_SOURCE
CFLAGS = -Wf-g
LDFLAGS =	-Wl-m -Wl-p ${MINIXLIB} 
LD =		m1_ld
AR =		m1_ar
LD =		m1_ld
LIBS =
RANLIB = 	m1_ranlib


whttpd:	${OBJECTS}
	$(CC) -o $@ $(LDFLAGS) ${OBJECTS}

clean:
		rm -f *.o whttpd whttpd.map

install:	httpd
	cp whttpd $(BINDIR)/whttpd

lint:
	splint -predboolint -nullpass -I../../include $(SRCS) $(LIBS)

depend:
	makedepend -- -I../../include $(CFLAGS) -- $(SRCS)
# DO NOT DELETE

httpd.o: ../../include/minix/config.h ../../include/sys/types.h
httpd.o: ../../include/ansi.h ../../include/sys/ioctl.h
httpd.o: ../../include/sys/ioc_tty.h ../../include/minix/ioctl.h
httpd.o: ../../include/net/ioctl.h ../../include/sys/ioc_disk.h
httpd.o: ../../include/sys/ioc_memory.h ../../include/sys/ioc_tape.h
httpd.o: ../../include/sys/ioc_scsi.h ../../include/sys/ioc_sound.h
httpd.o: ../../include/sys/wait.h ../../include/stdio.h
httpd.o: ../../include/stdlib.h ../../include/string.h ../../include/errno.h
httpd.o: ../../include/fcntl.h ../../include/signal.h ../../include/unistd.h
httpd.o: ../../include/net/netlib.h ../../include/net/hton.h
httpd.o: ../../include/net/gen/in.h ../../include/net/gen/inet.h
httpd.o: ../../include/net/gen/tcp.h ../../include/net/gen/tcp_io.h
httpd.o: ../../include/net/gen/socket.h ../../include/net/gen/netdb.h
httpd.o: ../../include/dirent.h ../../include/sys/stat.h net.h
net.o: ../../include/minix/config.h ../../include/sys/types.h
net.o: ../../include/ansi.h ../../include/sys/ioctl.h
net.o: ../../include/sys/ioc_tty.h ../../include/minix/ioctl.h
net.o: ../../include/net/ioctl.h ../../include/sys/ioc_disk.h
net.o: ../../include/sys/ioc_memory.h ../../include/sys/ioc_tape.h
net.o: ../../include/sys/ioc_scsi.h ../../include/sys/ioc_sound.h
net.o: ../../include/sys/wait.h ../../include/stdio.h ../../include/stdlib.h
net.o: ../../include/string.h ../../include/errno.h ../../include/fcntl.h
net.o: ../../include/signal.h ../../include/unistd.h
net.o: ../../include/net/netlib.h ../../include/net/hton.h
net.o: ../../include/net/gen/in.h ../../include/net/gen/inet.h
net.o: ../../include/net/gen/tcp.h ../../include/net/gen/tcp_io.h
net.o: ../../include/net/gen/socket.h ../../include/net/gen/netdb.h net.h
html_finger.o: ../../include/sys/types.h ../../include/ansi.h
html_finger.o: ../../include/ctype.h ../../include/errno.h
html_finger.o: ../../include/fcntl.h ../../include/pwd.h
html_finger.o: ../../include/stdio.h ../../include/stdlib.h
html_finger.o: ../../include/string.h ../../include/time.h
html_finger.o: ../../include/unistd.h ../../include/utmp.h
html_finger.o: ../../include/sys/ioctl.h ../../include/sys/ioc_tty.h
html_finger.o: ../../include/minix/ioctl.h ../../include/net/ioctl.h
html_finger.o: ../../include/sys/ioc_disk.h ../../include/sys/ioc_memory.h
html_finger.o: ../../include/sys/ioc_tape.h ../../include/sys/ioc_scsi.h
html_finger.o: ../../include/sys/ioc_sound.h ../../include/sys/stat.h
