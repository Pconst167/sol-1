SRCS	=	wnet.c remap.c wnet_config.c ip.c tcp.c debug.c udp.c clock.c \
				procfs.c getput.c get_rtc_time.c
OBJECTS	=	wnet.o remap.o wnet_config.o ip.o tcp.o debug.o udp.o clock.o \
				 	procfs.o getput.o get_rtc_time.o

BINDIR	=	$(IMAGE)/bin
# -A -A gives additional warnings about non-ANSI usage
CC =		clcc -A -A
CPPFLAGS =	-I. -I.. 
CFLAGS = ${CPPFLAGS} -Wf-g
LDFLAGS =	-Wl-m -Wl-p ${MINIXLIB} 
LD =		m1_ld
AR =		m1_ar
LD =		m1_ld
LIBS =
RANLIB = 	m1_ranlib


wnet:	${OBJECTS}
	$(CC) -o $@ $(LDFLAGS) ${OBJECTS} -lsys

clean:
		rm -f *.o wnet wnet.map

install:	wnet
	cp wnet $(BINDIR)/wnet

lint:
	splint -predboolint -nullpass -I../../include $(SRCS) $(LIBS)

depend:
	makedepend -- -I../../include $(CFLAGS) -- $(SRCS)
# DO NOT DELETE

wnet.o: common.h ../../include/ansi.h ../../include/sys/types.h
wnet.o: ../../include/errno.h ../../include/stddef.h ../../include/stdlib.h
wnet.o: ../../include/string.h ../../include/unistd.h
wnet.o: ../../include/sys/svrctl.h ../../include/minix/ioctl.h
wnet.o: ../../include/minix/config.h ../../include/minix/type.h
wnet.o: ../../include/minix/const.h ../../include/minix/com.h
wnet.o: ../../include/minix/syslib.h ../../include/minix/callnr.h
wnet.o: ../../include/net/gen/in.h ../../include/net/gen/ip_hdr.h
wnet.o: ../../include/net/gen/ip_io.h ../../include/net/gen/icmp.h
wnet.o: ../../include/net/gen/icmp_hdr.h ../../include/net/gen/psip_hdr.h
wnet.o: ../../include/net/gen/psip_io.h ../../include/net/gen/route.h
wnet.o: ../../include/net/gen/tcp.h ../../include/net/gen/tcp_hdr.h
wnet.o: ../../include/net/gen/tcp_io.h ../../include/net/gen/udp.h
wnet.o: ../../include/net/gen/udp_hdr.h ../../include/net/gen/udp_io.h
wnet.o: ../../include/net/ioctl.h ../../include/stdio.h
wnet.o: ../../include/magic1.h ../../include/time.h remap.h
remap.o: common.h ../../include/ansi.h ../../include/sys/types.h
remap.o: ../../include/errno.h ../../include/stddef.h ../../include/stdlib.h
remap.o: ../../include/string.h ../../include/unistd.h
remap.o: ../../include/sys/svrctl.h ../../include/minix/ioctl.h
remap.o: ../../include/minix/config.h ../../include/minix/type.h
remap.o: ../../include/minix/const.h ../../include/minix/com.h
remap.o: ../../include/minix/syslib.h ../../include/minix/callnr.h
remap.o: ../../include/net/gen/in.h ../../include/net/gen/ip_hdr.h
remap.o: ../../include/net/gen/ip_io.h ../../include/net/gen/icmp.h
remap.o: ../../include/net/gen/icmp_hdr.h ../../include/net/gen/psip_hdr.h
remap.o: ../../include/net/gen/psip_io.h ../../include/net/gen/route.h
remap.o: ../../include/net/gen/tcp.h ../../include/net/gen/tcp_hdr.h
remap.o: ../../include/net/gen/tcp_io.h ../../include/net/gen/udp.h
remap.o: ../../include/net/gen/udp_hdr.h ../../include/net/gen/udp_io.h
remap.o: ../../include/net/ioctl.h ../../include/stdio.h
remap.o: ../../include/magic1.h ../../include/time.h ../../include/fcntl.h
remap.o: ../../include/sys/ioc_memory.h ../kernel/const.h
wnet_config.o: common.h ../../include/ansi.h ../../include/sys/types.h
wnet_config.o: ../../include/errno.h ../../include/stddef.h
wnet_config.o: ../../include/stdlib.h ../../include/string.h
wnet_config.o: ../../include/unistd.h ../../include/sys/svrctl.h
wnet_config.o: ../../include/minix/ioctl.h ../../include/minix/config.h
wnet_config.o: ../../include/minix/type.h ../../include/minix/const.h
wnet_config.o: ../../include/minix/com.h ../../include/minix/syslib.h
wnet_config.o: ../../include/minix/callnr.h ../../include/net/gen/in.h
wnet_config.o: ../../include/net/gen/ip_hdr.h ../../include/net/gen/ip_io.h
wnet_config.o: ../../include/net/gen/icmp.h ../../include/net/gen/icmp_hdr.h
wnet_config.o: ../../include/net/gen/psip_hdr.h
wnet_config.o: ../../include/net/gen/psip_io.h ../../include/net/gen/route.h
wnet_config.o: ../../include/net/gen/tcp.h ../../include/net/gen/tcp_hdr.h
wnet_config.o: ../../include/net/gen/tcp_io.h ../../include/net/gen/udp.h
wnet_config.o: ../../include/net/gen/udp_hdr.h ../../include/net/gen/udp_io.h
wnet_config.o: ../../include/net/ioctl.h ../../include/stdio.h
wnet_config.o: ../../include/magic1.h ../../include/time.h
wnet_config.o: ../../include/sys/stat.h
ip.o: common.h ../../include/ansi.h ../../include/sys/types.h
ip.o: ../../include/errno.h ../../include/stddef.h ../../include/stdlib.h
ip.o: ../../include/string.h ../../include/unistd.h
ip.o: ../../include/sys/svrctl.h ../../include/minix/ioctl.h
ip.o: ../../include/minix/config.h ../../include/minix/type.h
ip.o: ../../include/minix/const.h ../../include/minix/com.h
ip.o: ../../include/minix/syslib.h ../../include/minix/callnr.h
ip.o: ../../include/net/gen/in.h ../../include/net/gen/ip_hdr.h
ip.o: ../../include/net/gen/ip_io.h ../../include/net/gen/icmp.h
ip.o: ../../include/net/gen/icmp_hdr.h ../../include/net/gen/psip_hdr.h
ip.o: ../../include/net/gen/psip_io.h ../../include/net/gen/route.h
ip.o: ../../include/net/gen/tcp.h ../../include/net/gen/tcp_hdr.h
ip.o: ../../include/net/gen/tcp_io.h ../../include/net/gen/udp.h
ip.o: ../../include/net/gen/udp_hdr.h ../../include/net/gen/udp_io.h
ip.o: ../../include/net/ioctl.h ../../include/stdio.h ../../include/magic1.h
ip.o: ../../include/time.h
tcp.o: common.h ../../include/ansi.h ../../include/sys/types.h
tcp.o: ../../include/errno.h ../../include/stddef.h ../../include/stdlib.h
tcp.o: ../../include/string.h ../../include/unistd.h
tcp.o: ../../include/sys/svrctl.h ../../include/minix/ioctl.h
tcp.o: ../../include/minix/config.h ../../include/minix/type.h
tcp.o: ../../include/minix/const.h ../../include/minix/com.h
tcp.o: ../../include/minix/syslib.h ../../include/minix/callnr.h
tcp.o: ../../include/net/gen/in.h ../../include/net/gen/ip_hdr.h
tcp.o: ../../include/net/gen/ip_io.h ../../include/net/gen/icmp.h
tcp.o: ../../include/net/gen/icmp_hdr.h ../../include/net/gen/psip_hdr.h
tcp.o: ../../include/net/gen/psip_io.h ../../include/net/gen/route.h
tcp.o: ../../include/net/gen/tcp.h ../../include/net/gen/tcp_hdr.h
tcp.o: ../../include/net/gen/tcp_io.h ../../include/net/gen/udp.h
tcp.o: ../../include/net/gen/udp_hdr.h ../../include/net/gen/udp_io.h
tcp.o: ../../include/net/ioctl.h ../../include/stdio.h ../../include/magic1.h
tcp.o: ../../include/time.h
debug.o: common.h ../../include/ansi.h ../../include/sys/types.h
debug.o: ../../include/errno.h ../../include/stddef.h ../../include/stdlib.h
debug.o: ../../include/string.h ../../include/unistd.h
debug.o: ../../include/sys/svrctl.h ../../include/minix/ioctl.h
debug.o: ../../include/minix/config.h ../../include/minix/type.h
debug.o: ../../include/minix/const.h ../../include/minix/com.h
debug.o: ../../include/minix/syslib.h ../../include/minix/callnr.h
debug.o: ../../include/net/gen/in.h ../../include/net/gen/ip_hdr.h
debug.o: ../../include/net/gen/ip_io.h ../../include/net/gen/icmp.h
debug.o: ../../include/net/gen/icmp_hdr.h ../../include/net/gen/psip_hdr.h
debug.o: ../../include/net/gen/psip_io.h ../../include/net/gen/route.h
debug.o: ../../include/net/gen/tcp.h ../../include/net/gen/tcp_hdr.h
debug.o: ../../include/net/gen/tcp_io.h ../../include/net/gen/udp.h
debug.o: ../../include/net/gen/udp_hdr.h ../../include/net/gen/udp_io.h
debug.o: ../../include/net/ioctl.h ../../include/stdio.h
debug.o: ../../include/magic1.h ../../include/time.h
udp.o: common.h ../../include/ansi.h ../../include/sys/types.h
udp.o: ../../include/errno.h ../../include/stddef.h ../../include/stdlib.h
udp.o: ../../include/string.h ../../include/unistd.h
udp.o: ../../include/sys/svrctl.h ../../include/minix/ioctl.h
udp.o: ../../include/minix/config.h ../../include/minix/type.h
udp.o: ../../include/minix/const.h ../../include/minix/com.h
udp.o: ../../include/minix/syslib.h ../../include/minix/callnr.h
udp.o: ../../include/net/gen/in.h ../../include/net/gen/ip_hdr.h
udp.o: ../../include/net/gen/ip_io.h ../../include/net/gen/icmp.h
udp.o: ../../include/net/gen/icmp_hdr.h ../../include/net/gen/psip_hdr.h
udp.o: ../../include/net/gen/psip_io.h ../../include/net/gen/route.h
udp.o: ../../include/net/gen/tcp.h ../../include/net/gen/tcp_hdr.h
udp.o: ../../include/net/gen/tcp_io.h ../../include/net/gen/udp.h
udp.o: ../../include/net/gen/udp_hdr.h ../../include/net/gen/udp_io.h
udp.o: ../../include/net/ioctl.h ../../include/stdio.h ../../include/magic1.h
udp.o: ../../include/time.h
clock.o: common.h ../../include/ansi.h ../../include/sys/types.h
clock.o: ../../include/errno.h ../../include/stddef.h ../../include/stdlib.h
clock.o: ../../include/string.h ../../include/unistd.h
clock.o: ../../include/sys/svrctl.h ../../include/minix/ioctl.h
clock.o: ../../include/minix/config.h ../../include/minix/type.h
clock.o: ../../include/minix/const.h ../../include/minix/com.h
clock.o: ../../include/minix/syslib.h ../../include/minix/callnr.h
clock.o: ../../include/net/gen/in.h ../../include/net/gen/ip_hdr.h
clock.o: ../../include/net/gen/ip_io.h ../../include/net/gen/icmp.h
clock.o: ../../include/net/gen/icmp_hdr.h ../../include/net/gen/psip_hdr.h
clock.o: ../../include/net/gen/psip_io.h ../../include/net/gen/route.h
clock.o: ../../include/net/gen/tcp.h ../../include/net/gen/tcp_hdr.h
clock.o: ../../include/net/gen/tcp_io.h ../../include/net/gen/udp.h
clock.o: ../../include/net/gen/udp_hdr.h ../../include/net/gen/udp_io.h
clock.o: ../../include/net/ioctl.h ../../include/stdio.h
clock.o: ../../include/magic1.h ../../include/time.h
procfs.o: common.h ../../include/ansi.h ../../include/sys/types.h
procfs.o: ../../include/errno.h ../../include/stddef.h ../../include/stdlib.h
procfs.o: ../../include/string.h ../../include/unistd.h
procfs.o: ../../include/sys/svrctl.h ../../include/minix/ioctl.h
procfs.o: ../../include/minix/config.h ../../include/minix/type.h
procfs.o: ../../include/minix/const.h ../../include/minix/com.h
procfs.o: ../../include/minix/syslib.h ../../include/minix/callnr.h
procfs.o: ../../include/net/gen/in.h ../../include/net/gen/ip_hdr.h
procfs.o: ../../include/net/gen/ip_io.h ../../include/net/gen/icmp.h
procfs.o: ../../include/net/gen/icmp_hdr.h ../../include/net/gen/psip_hdr.h
procfs.o: ../../include/net/gen/psip_io.h ../../include/net/gen/route.h
procfs.o: ../../include/net/gen/tcp.h ../../include/net/gen/tcp_hdr.h
procfs.o: ../../include/net/gen/tcp_io.h ../../include/net/gen/udp.h
procfs.o: ../../include/net/gen/udp_hdr.h ../../include/net/gen/udp_io.h
procfs.o: ../../include/net/ioctl.h ../../include/stdio.h
procfs.o: ../../include/magic1.h ../../include/time.h
getput.o: common.h ../../include/ansi.h ../../include/sys/types.h
getput.o: ../../include/errno.h ../../include/stddef.h ../../include/stdlib.h
getput.o: ../../include/string.h ../../include/unistd.h
getput.o: ../../include/sys/svrctl.h ../../include/minix/ioctl.h
getput.o: ../../include/minix/config.h ../../include/minix/type.h
getput.o: ../../include/minix/const.h ../../include/minix/com.h
getput.o: ../../include/minix/syslib.h ../../include/minix/callnr.h
getput.o: ../../include/net/gen/in.h ../../include/net/gen/ip_hdr.h
getput.o: ../../include/net/gen/ip_io.h ../../include/net/gen/icmp.h
getput.o: ../../include/net/gen/icmp_hdr.h ../../include/net/gen/psip_hdr.h
getput.o: ../../include/net/gen/psip_io.h ../../include/net/gen/route.h
getput.o: ../../include/net/gen/tcp.h ../../include/net/gen/tcp_hdr.h
getput.o: ../../include/net/gen/tcp_io.h ../../include/net/gen/udp.h
getput.o: ../../include/net/gen/udp_hdr.h ../../include/net/gen/udp_io.h
getput.o: ../../include/net/ioctl.h ../../include/stdio.h
getput.o: ../../include/magic1.h ../../include/time.h
get_rtc_time.o: common.h ../../include/ansi.h ../../include/sys/types.h
get_rtc_time.o: ../../include/errno.h ../../include/stddef.h
get_rtc_time.o: ../../include/stdlib.h ../../include/string.h
get_rtc_time.o: ../../include/unistd.h ../../include/sys/svrctl.h
get_rtc_time.o: ../../include/minix/ioctl.h ../../include/minix/config.h
get_rtc_time.o: ../../include/minix/type.h ../../include/minix/const.h
get_rtc_time.o: ../../include/minix/com.h ../../include/minix/syslib.h
get_rtc_time.o: ../../include/minix/callnr.h ../../include/net/gen/in.h
get_rtc_time.o: ../../include/net/gen/ip_hdr.h ../../include/net/gen/ip_io.h
get_rtc_time.o: ../../include/net/gen/icmp.h ../../include/net/gen/icmp_hdr.h
get_rtc_time.o: ../../include/net/gen/psip_hdr.h
get_rtc_time.o: ../../include/net/gen/psip_io.h ../../include/net/gen/route.h
get_rtc_time.o: ../../include/net/gen/tcp.h ../../include/net/gen/tcp_hdr.h
get_rtc_time.o: ../../include/net/gen/tcp_io.h ../../include/net/gen/udp.h
get_rtc_time.o: ../../include/net/gen/udp_hdr.h
get_rtc_time.o: ../../include/net/gen/udp_io.h ../../include/net/ioctl.h
get_rtc_time.o: ../../include/stdio.h ../../include/magic1.h
get_rtc_time.o: ../../include/time.h ../lib/ansi/loc_time.h
