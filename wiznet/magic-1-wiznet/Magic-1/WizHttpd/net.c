/* net.c
 *
 * This file is part of httpd.
 *
 * 01/25/1996 			Michael Temari <Michael@TemWare.Com>
 * 07/07/1996 Initial Release	Michael Temari <Michael@TemWare.Com>
 * 12/29/2002 			Michael Temari <Michael@TemWare.Com>
 *
 */
#include <minix/config.h>
#include <sys/types.h>
#include <sys/ioctl.h>
#include <sys/wait.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <fcntl.h>
#include <signal.h>
#include <unistd.h>
#include <net/netlib.h>
#include <net/hton.h>
#include <net/gen/in.h>
#include <net/gen/inet.h>
#include <net/gen/tcp.h>
#include <net/gen/tcp_io.h>
#include <net/gen/socket.h>
#include <net/gen/netdb.h>

#include "net.h"

ipaddr_t myipaddr, rmtipaddr;
tcpport_t myport, rmtport;
char myhostname[256];
char rmthostname[256];
char rmthostaddr[3+1+3+1+3+1+3+1];

char* get_client_ip(int socket) {
  nwio_tcpconf_t tcpconf;
  int s;

  /* get clients ip address */
  s = ioctl(socket, NWIOGTCPCONF, &tcpconf);
  if (s < 0) {
    strcpy(rmthostaddr, "???.???.???.???");
  } else {
    rmtipaddr = tcpconf.nwtc_remaddr;
    strcpy(rmthostaddr, inet_ntoa(rmtipaddr));
  }
  return rmthostaddr;
}

void get_net_info(int socket) {
  nwio_tcpconf_t tcpconf;
  int s;
  struct hostent *hostent;

  /* Ask the system what our hostname is. */
  if (gethostname(myhostname, sizeof(myhostname)) < 0)
    strcpy(myhostname, "unknown");

  /* lets get our ip address and the clients ip address */
  s = ioctl(socket, NWIOGTCPCONF, &tcpconf);
  if (s < 0) {
    myipaddr = 0;
    myport = 0;
    rmtipaddr = 0;
    rmtport = 0;
    strcpy(rmthostname, "??Unknown??");
    strcpy(rmthostaddr, "???.???.???.???");
    return;
  }

  myipaddr = tcpconf.nwtc_locaddr;
  myport = tcpconf.nwtc_locport;
  rmtipaddr = tcpconf.nwtc_remaddr;
  rmtport = tcpconf.nwtc_remport;

  /* Look up the host name of the remote host. */
  hostent = gethostbyaddr((char *) &rmtipaddr, sizeof(rmtipaddr), AF_INET);
  if (!hostent)
    strncpy(rmthostname, inet_ntoa(rmtipaddr), sizeof(rmthostname)-1);
  else
    strncpy(rmthostname, hostent->h_name, sizeof(rmthostname)-1);

  strcpy(rmthostaddr, inet_ntoa(rmtipaddr));

  rmthostname[sizeof(rmthostname)-1] = '\0';

  return;
}

int open_http_socket(char* service) {
  char* tcp_device;
  struct servent *servent;
  struct nwio_tcpconf tcpconf;
  int socket;
  int port;

  if ((servent= getservbyname(service, "tcp")) == NULL) {
    unsigned long p;
    char *end;

    p = strtoul(service, &end, 0);
    if (p <= 0 || p > 0xFFFF || *end != 0) {
      fprintf(stderr, "httpd: %s: Unknown service\n", service);
      fflush(stderr);
      return ERR_UNKNOWN_SERVICE;
    }
    port= htons((tcpport_t) p);
  } else {
    port= servent->s_port;
  }

  if ((tcp_device = getenv("TCP_DEVICE")) == NULL) {
    tcp_device = TCP_DEVICE;
  }

  if ((socket = open(tcp_device, O_RDWR)) < 0) {
    fprintf(stderr, "httpd: Can't open %s - %s",
        tcp_device, strerror(errno));
    fflush(stderr);
    return ERR_CANT_OPEN;
  }

  tcpconf.nwtc_flags= NWTC_LP_SET | NWTC_UNSET_RA | NWTC_UNSET_RP;
  tcpconf.nwtc_locport= port;

  if (ioctl(socket, NWIOSTCPCONF, &tcpconf) < 0) {
    fprintf(stderr, "httpd: Can't configure TCP channel - %s",
        strerror(errno));
    fflush(stderr);
    return ERR_CANT_CONFIGURE;
  }
  return socket;
}

int reopen_http_socket(int socket) {
  struct nwio_tcpconf tcpconf;

  if (ioctl(socket, NWIOGTCPCONF, &tcpconf) < 0) {
    fprintf(stderr, "httpd: Can't get TCP config - %s", strerror(errno));
    fflush(stderr);
    return ERR_CANT_CONFIGURE;
  }

  // Blindly disconnect.  Might not be connected, so just ignore error.
  ioctl(socket, NWIOTCPSHUTDOWN, &tcpconf);

  // Blindly close socket.  Same - might already be closed, just ignore error.
  ioctl(socket, NWIOTCPCLOSEHOLD, &tcpconf);

  tcpconf.nwtc_flags= NWTC_LP_SET | NWTC_UNSET_RA | NWTC_UNSET_RP;

  if (ioctl(socket, NWIOSTCPCONF, &tcpconf) < 0) {
    fprintf(stderr, "httpd: Can't configure TCP channel - %s",
        strerror(errno));
    fflush(stderr);
    return ERR_CANT_CONFIGURE;
  }
  return 0;
}

int get_http_client(int socket) {
  struct nwio_tcpcl tcplistenopt;
  int res = 0;
  /* Wait for a new connection. */
  tcplistenopt.nwtcl_flags= 0;
  res = ioctl(socket, NWIOTCPLISTEN, &tcplistenopt);
  if (verbose && (res < 0)) {
    fprintf(stderr, "httpd: Unable to listen - %s\n", strerror(errno));
    fflush(stderr);
  }
  return res;
}
