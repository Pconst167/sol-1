#include "common.h"
void write_socket(socket_t* sock, char* buf, size_t size);
void tcp_open(socket_t* sock, message* m);
void tcp_close(socket_t* sock, message* m);
void tcp_read(socket_t* sock, message* m);
void tcp_write(socket_t* sock, message* m);
void tcp_ioctl(socket_t* sock, message* m);
void tcp_cancel(socket_t* sock, message* m);
int tcp_setconf(socket_t* sock, message* m);
int tcp_setopt(socket_t* sock, message* m);
int tcp_connect(socket_t* sock, message* m);
int tcp_listen(socket_t* sock, message* m);
void dump_tcpconf_t(char* msg, nwio_tcpconf_t conf);

/*
 * Open a socket in reponse to a FS message.  Note that we're really
 * just allocating a socket.
 */
void tcp_open(socket_t* sock, message* m) {
  int r;
  // Allocate a free socket, which will also copy TCP values from template dev.
  r = allocate_socket(sock->sock_num);
  if (verbose > 0) {
    printf("tcp_open allocated fd %s\n", pr_fd(r));
  }
  wnet_reply(sock, m, r);
}

void tcp_close(socket_t* sock, message* m) {
  if (verbose > 0) {
    printf("tcp_close releasing fd %s\n", pr_fd(sock->fd));
  }
  if (spy && (sock->portr == 23)) {
    printf("SPY: close socket %d\n", sock->sock_num);
  }
  assert(sock->sock_num < NUM_WIZ_SOCKETS);
  wnet_reply(sock, m, OK);
  free_socket(sock->sock_num);
}

char hex_digit(unsigned int i) {
  char ch;
  if (i < 10) {
    ch = '0' + i;
  } else {
    ch = 'A' + (i - 10);
  }
  return ch;
}

#if 0
char* telnet_cmds[] = {
  "*IAC* ",
  "*DONT* ",
  "*DO* ",
  "*WONT* ",
  "*WILL* ",
  "*SB* ",
  "*GA* ",
  "*EL* ",
  "*EC* ",
  "*AYT* ",
  "*AO* ",
  "*IP* ",
  "*BREAK* ",
  "*DM* ",
  "*NOP* ",
  "*SE* ",
  "*EOR* ",
};

char* telnet_opts[] = {
  "*BINARY* ",
  "*ECHO* ",
  "*RCP* ",
  "*SGA* ",
  "*NAMS* ",
  "*STATUS* ",
  "*TM* ",
  "*RCTE* ",
  "*NAOL* ",
  "*NAOP* ",
  "*NAOCRD* ",
  "*NAOHTS* ",
  "*NAOHTD* ",
  "*NAOFFD* ",
  "*NAOVTS* ",
  "*NAOVTD* ",
  "*NAOLFD* ",
  "*XASCII* ",
  "*LOGOUT* ",
  "*BM* ",
  "*DET* ",
  "*SUPDUP* ",
  "*SUPDUPOUTPUT* ",
  "*SNDLOC* ",
  "*TTYPE* ",
  "*EOR* "
};
#endif

int tost(char* buf, char ch, int status) {
  int res = 0;
  (void)status;
#if 0
  if (ch >= 239) {
    strcpy(buf, telnet_cmds[255-ch]);
    res = 1;
  } else if ((ch <= 25) && (status == 1)) {
    strcpy(buf, telnet_opts[ch]);
  } else
#endif
    if ((ch >= ' ') && (ch <= '~')) {
      buf[0] = ch;
      buf[1] = 0;
    } else {
      strcpy(buf, "xXX");
      buf[1] = hex_digit((ch >> 4) & 0xf);
      buf[2] = hex_digit(ch & 0xf);
    }
  return res;
}

void tcp_read(socket_t* sock, message* m) {
  int count = m->COUNT;
  // FIXME - count should be uint16_t
  int r = EINVAL;  // Default to something that relatively harmless.
  unsigned int wsock = sock->wsock;
  int avail = get_rx_rsr(wsock) + sock->unread_bytes;
  int mode = get_mr(wsock);
  int status = get_ssr(wsock);
  if (verbose > 0) {
    printf("tcp_read, fd %s, avail %d, wanted %d\n", pr_fd(sock->fd),
        avail, count);
  }
  if (mode != WIZ_MODE_TCP) {
    if (verbose > 0) {
      printf("mr != WIZ_MODE_TCP, is: 0x%x\n", mode);
    }
    r = EINVAL;
  } else if (!((status == WIZ_STATUS_ESTABLISHED) ||
        (status == WIZ_STATUS_CLOSE_WAIT))) {
    if (verbose > 0) {
      char buf[40];
      pr_status(status, buf, 40);
      printf("status != ESTABLISHED or CLOSE_WAIT, is: %s\n", buf);
    }
    r = ENOTCONN;
  } else if (avail == 0) {
    if (status != WIZ_STATUS_ESTABLISHED) {
      r = 0;
    } else {
      if (verbose > 0) {
        printf("no data - suspending\n");
      }
      sock->suspended_message = *m;
      sock->flags |= kSuspForData;
      r = SUSPEND;
    }
  } else {
    r = read_tcp_socket(sock, &big_buf[0], BIG_BUF_BYTE_SIZE, count);
    if (r > 0) {
      if (spy && (sock->portr == 23)) {
        int i;
        int status = 0;
        char* cbuf = (char*)&big_buf[0];
        printf("RDs%d:\"", sock->sock_num);
        for (i = 0; i < r; i++) {
          char st[16];
          status = tost(st, cbuf[i], status);
          printf("%s",st);
        }
        printf("\"\n");
      }
      copy_to_user((vir_bytes)&big_buf[0], m->PROC_NR,
          (vir_bytes)m->ADDRESS, r);
    }
  }
  wnet_reply(sock, m, r);
}

void tcp_write(socket_t* sock, message* m) {
  uint16_t count = m->COUNT;
  uint16_t wsock = sock->wsock;
  int res;
  if (verbose > 0) {
    printf("tcp_write fd %s, count %u\n", pr_fd(sock->fd), count);
  }
  if (count == 0) {
    wnet_reply(sock, m, 0);
  }
  // Initialize for possible multi-stage write.
  sock->pending_write = *m;
  sock->written_bytes = 0;
  // TCP status OK?  (Generic wsocket checks later)
  if (get_mr(wsock) != WIZ_MODE_TCP) {
    wnet_reply(sock, m, EINVAL);
    return;
  }
  if (get_ssr(wsock) != WIZ_STATUS_ESTABLISHED) {
    wnet_reply(sock, m, ENOTCONN);
    return;
  }
  // Do the first (and possibly last) write.
  res = write_wsocket(sock);
  wnet_reply(sock, m, res);
}

nwio_hitcount_t hits;

void tcp_ioctl(socket_t* sock, message* m) {
  int r = EINVAL;   // Default to something relatively harmless.
  int req = m->REQUEST;
  nwio_tcpconf_t tcp_conf;
  nwio_tcpopt_t tcp_opt;
  unsigned int wsock = sock->wsock;
  unsigned sock_num = sock->sock_num;
  int status = get_ssr(wsock);
  if (verbose > 0) {
    printf("tcp_ioctl fd %s ", pr_fd(sock->fd));
  }
  assert(sock->flags & kInUse);

  switch (req) {

    // Hitcount manipulation
    case NWIOADDHITCOUNT:
      add_trace(sock_num, TRACE_KIND_TCP, TRACE_NWIOADDHITCOUNT, status, 0);
      if (trace) {
        printf("NWIOADDHITCOUNT\n");
      }
      hits.hit_count++;
      r = OK;
      break;

    case NWIOGETHITCOUNT:
      add_trace(sock_num, TRACE_KIND_TCP, TRACE_NWIOGETHITCOUNT, status, 0);
      if (trace) {
        printf("NWIOGETHITCOUNT\n");
      }
      copy_to_user((vir_bytes)&hits, m->PROC_NR,
          (vir_bytes)m->ADDRESS, sizeof(nwio_hitcount_t));
      r = OK;
      break;

      // Set TCP configuration
    case NWIOSTCPCONF:
      add_trace(sock_num, TRACE_KIND_TCP, TRACE_NWIOSTCPCONF, status, 0);
      if (trace || (verbose > 0)) {
        printf("NWIOSTCPCONF (set TCP configuration)\n");
      }
      r = tcp_setconf(sock, m);
      break;

      // Get TCP configuration
    case NWIOGTCPCONF:
      add_trace(sock_num, TRACE_KIND_TCP, TRACE_NWIOGTCPCONF, status, 0);
      if (trace || (verbose > 0)) {
        printf("NWIOGTCPCONF (read current TCP configuration)\n");
      }
      tcp_conf = sockets[sock->sock_num].tcp_conf;
      if (get_ssr(wsock) == WIZ_STATUS_ESTABLISHED) {
        ipv4_t dipr = get_dipr(wsock);
        tcp_conf.nwtc_locport = get_portr(wsock);
        // In this case, we need to query the wiznet registers directly.
        tcp_conf.nwtc_remaddr = dipr.u.raw;
        tcp_conf.nwtc_remport = get_dportr(wsock);
      }
      tcp_conf.nwtc_locaddr = w5300_ip_addr.u.raw;
      // Set the info in the socket record.
      sock->tcp_conf = tcp_conf;
      if (verbose > 0) {
        dump_tcpconf_t("get tcp conf", tcp_conf);
      }
      copy_to_user((vir_bytes)&tcp_conf, m->PROC_NR,
          (vir_bytes)m->ADDRESS, sizeof(nwio_tcpconf_t));
      r = OK;
      break;

      // Set TCP options
    case NWIOSTCPOPT:
      add_trace(sock_num, TRACE_KIND_TCP, TRACE_NWIOSTCPOPT, status, 0);
      if (trace || (verbose > 0)) {
        printf("NWIOSTCPOPT\n");
      }
      r = tcp_setopt(sock, m);
      break;

      // get TCP options
    case NWIOGTCPOPT:
      add_trace(sock_num, TRACE_KIND_TCP, TRACE_NWIOGTCPOPT, status, 0);
      if (trace || (verbose > 0)) {
        printf("NWIOGTCPOPT (read current TCP option)\n");
      }
      tcp_opt = sockets[sock->sock_num].tcp_opt;
      copy_to_user((vir_bytes)&tcp_opt, m->PROC_NR,
          (vir_bytes)m->ADDRESS, sizeof(nwio_tcpopt_t));
      r = OK;
      break;

      // Establish TCP connection
    case NWIOTCPCONN:
      add_trace(sock_num, TRACE_KIND_TCP, TRACE_NWIOTCPCONN, status, 0);
      if (trace || (verbose > 0)) {
        printf("NWIOTCPCONN (establish TCP client connection)\n");
      }
      r = tcp_connect(sock, m);
      break;

      // Open server listening connection
    case NWIOTCPLISTEN:
      add_trace(sock_num, TRACE_KIND_TCP, TRACE_NWIOTCPLISTEN, status, 0);
      if (trace || (verbose > 0)) {
        unsigned int mode = sock->portr;
        char b1[20];
        char* p = b1;
        switch (mode) {
          case 21: p = "FTP"; break;
          case 23: p = "Telnet";
                   if (spy) {
                     printf("SPY: Listen on socket %d\n", sock->sock_num);
                   }
                   break;
          case 80: p = "Web"; break;
          default:
                   sprintf(p, "TCP port %d", mode);
        }
        printf("NWIOTCPLISTEN (start %s server)\n", p);
      }
      r = tcp_listen(sock, m);
      break;

      // Shut down TCP connection
    case NWIOTCPSHUTDOWN:
      add_trace(sock_num, TRACE_KIND_TCP, TRACE_NWIOTCPSHUTDOWN, status, 0);
      if (trace || (verbose > 0)) {
        printf("NWIOTCPSHUTDOWN (shut down TCP connection)\n");
      }
      if (spy && (sock->portr == 23)) {
        printf("SPY: Shutdown on socket %d\n", sock->sock_num);
      }
      // Clear and discard any pending reads
      if (get_rx_rsr(wsock) > 0) {
        while (get_rx_rsr(wsock) > 0) {
          u16_t junk = get_rx_fifor(wsock);
        }
        (void)set_cr_check(wsock, WIZ_CMD_RECV, WIZ_STATUS_DONT_CARE);
      }
      if (get_ssr(wsock) == WIZ_STATUS_ESTABLISHED) {
        (void)set_cr_check(wsock, WIZ_CMD_DISCON, WIZ_STATUS_DONT_CARE);
      }
      // FIXME? it's possible I should suspend here and wait for the
      // disconnect interrupt.
      r = OK;
      break;

      // Shut down a TCP socket, but don't release it
    case NWIOTCPCLOSEHOLD:
      add_trace(sock_num, TRACE_KIND_TCP, TRACE_NWIOTCPCLOSEHOLD, status, 0);
      if (trace || (verbose > 0)) {
        printf("NWIOTCPCLOSEHOLD (close socket, but keep it)\n");
      }
      if (!close_socket(sock->sock_num)) {
        r = EIO;
      } else {
        r = OK;
      }
      break;

    default:
      if (trace) {
        printf("EBADIOCTL: 0x%x\n", req);
      }
      r = EBADIOCTL;
      break;
  }
  wnet_reply(sock, m, r);
}

void tcp_cancel(socket_t* sock, message* m) {
  unsigned int wsock = sock->wsock;
  if (verbose > 0) {
    printf("tcp_cancel fd %s, REQUEST 0x%x\n", pr_fd(sock->fd), m->REQUEST);
  }
  if (spy && (sock->portr == 23)) {
    printf("SPY: cancel on socket %d\n", sock->sock_num);
  }
  if (sock->flags & kSuspForData) {
    set_ir(wsock, WIZ_INT_RECV);
    if (get_rx_rsr(wsock) > 0) {
      (void)set_cr_check(wsock, WIZ_CMD_RECV, WIZ_STATUS_DONT_CARE);
    }
  }
  if (sock->flags & kSuspForConn) {
    set_ir(wsock, WIZ_INT_CON);
    (void)set_cr_check(wsock, WIZ_CMD_DISCON, WIZ_STATUS_DONT_CARE);
  }
  if (sock->flags & kSuspForOK) {
    wnet_reply(sock, &sock->pending_write, EINTR);
  } else {
    wnet_reply(sock, &sock->suspended_message, EINTR);
  }

  if (sock->flags & SUSPENDED_MASK) {
    sock->flags &= ~SUSPENDED_MASK;
  }
  wnet_reply(sock, m, OK);
}

void dump_tcpconf_t(char* msg, nwio_tcpconf_t conf) {
  printf("%s\n", msg);
  printf("nwtc_flags:   0x%08lx\n", conf.nwtc_flags);
  printf("nwtc_locaddr: 0x%08lx\n", conf.nwtc_locaddr);
  printf("nwtc_remaddr: 0x%08lx\n", conf.nwtc_remaddr);
  printf("nwtc_locport: %u\n", conf.nwtc_locport);
  printf("nwtc_remport: %u\n", conf.nwtc_remport);
}

int tcp_setconf(socket_t* sock, message* m) {
  nwio_tcpconf_t tcpconf;
  nwio_tcpconf_t oldconf, newconf;
  uint16_t new_en_flags, new_di_flags;
  uint16_t old_en_flags, old_di_flags;
  uint16_t all_flags;
  copy_from_user(m->PROC_NR, (vir_bytes)m->ADDRESS, (vir_bytes)&tcpconf,
      sizeof(tcpconf));

  oldconf = sock->tcp_conf;
  newconf = tcpconf;

  if (verbose > 0) {
    dump_tcpconf_t("old tcp conf:", oldconf);
    dump_tcpconf_t("new tcp conf:", newconf);
  }

  old_en_flags= LOW_WORD(oldconf.nwtc_flags);
  old_di_flags= HIGH_WORD(oldconf.nwtc_flags);
  new_en_flags= LOW_WORD(newconf.nwtc_flags);
  new_di_flags= HIGH_WORD(newconf.nwtc_flags);

  if (verbose > 0) {
    printf("old di: 0x%04x, old en: 0x%04x\n", old_di_flags, old_en_flags);
    printf("new di: 0x%04x, new en: 0x%04x\n", new_di_flags, new_en_flags);
  }

  if (new_en_flags & new_di_flags) {
    if (trace || (verbose > 0)) {
      printf("Error: conflict w/ new_en and old_en.  EBADMODE\n");
    }
    return EBADMODE;
  }

  /* NWTC_ACC_MASK */
  if (new_di_flags & (unsigned)NWTC_ACC_MASK) {
    if (trace || verbose > 0) {
      printf("Error Access modes can't be disabled. EBADMODE.\n");
    }
    return EBADMODE;
  }

  if (!(new_en_flags & (unsigned)NWTC_ACC_MASK)) {
    new_en_flags |= (old_en_flags & (unsigned)NWTC_ACC_MASK);
  }

  /* NWTC_LOCPORT_MASK */
  if (new_di_flags & (unsigned)NWTC_LOCPORT_MASK) {
    if (trace || verbose > 0) {
      printf("Error: Loc ports can't be disabled.  EBADMODE.\n");
    }
    return EBADMODE;
  }
  if (!(new_en_flags & (unsigned)NWTC_LOCPORT_MASK)) {
    // If not setting new local port, reuse the last one.
    if (verbose > 0) {
      printf("Reusing old local port %u\n", oldconf.nwtc_locport);
    }
    new_en_flags |= (old_en_flags & (unsigned)NWTC_LOCPORT_MASK);
    newconf.nwtc_locport= oldconf.nwtc_locport;
  } else if ((new_en_flags &
        (unsigned)NWTC_LOCPORT_MASK) == (unsigned)NWTC_LP_SEL) {
    // Wanting us to choose the local port.
    newconf.nwtc_locport = get_next_local_port();
    if (verbose > 0) {
      printf("Selected new local port %u\n", newconf.nwtc_locport);
    }
  } else if ((new_en_flags &
        (unsigned)NWTC_LOCPORT_MASK) == (unsigned)NWTC_LP_SET) {
    if (!newconf.nwtc_locport) {
      printf("Local port already set, EBADMODE\n");
      return EBADMODE;
    }
  }

  /* NWTC_REMADDR_MASK */
  if (!((new_en_flags | new_di_flags) & (unsigned)NWTC_REMADDR_MASK)) {
    new_en_flags |= (old_en_flags & (unsigned)NWTC_REMADDR_MASK);
    new_di_flags |= (old_di_flags & (unsigned)NWTC_REMADDR_MASK);
    if (verbose > 0) {
      printf("Reusing remote address ");
      print_ip(oldconf.nwtc_remaddr);
      printf("\n");
    }
    newconf.nwtc_remaddr= oldconf.nwtc_remaddr;
  } else if (new_en_flags & (unsigned)NWTC_SET_RA) {
    if (verbose > 0) {
      printf("Setting remote address ");
      print_ip(newconf.nwtc_remaddr);
      printf("\n");
    }
    if (!newconf.nwtc_remaddr) {
      if (trace || verbose > 0) {
        printf("Error: trying to set 0.0.0.0 remaddr.  EBADMODE.\n");
      }
      return EBADMODE;
    }
  } else {
    if (verbose > 0) {
      printf("Clearing remote address\n");
    }
    assert (new_di_flags & (unsigned)NWTC_REMADDR_MASK);
    newconf.nwtc_remaddr= 0;
  }

  /* NWTC_REMPORT_MASK */
  if (!((new_en_flags | new_di_flags) & (unsigned)NWTC_REMPORT_MASK)) {
    new_en_flags |= (old_en_flags & (unsigned)NWTC_REMPORT_MASK);
    new_di_flags |= (old_di_flags & (unsigned)NWTC_REMPORT_MASK);
    if (verbose > 0) {
      printf("Reusing remote port %u\n", oldconf.nwtc_remport);
    }
    newconf.nwtc_remport= oldconf.nwtc_remport;
  } else if (new_en_flags & (unsigned)NWTC_SET_RP) {
    if (verbose > 0) {
      printf("Setting remote port %u\n", newconf.nwtc_remport);
    }
    if (!newconf.nwtc_remport) {
      printf("Error: attempted to set remote port of 0. EBADMODE.\n");
      return EBADMODE;
    }
  } else {
    if (verbose > 0) {
      printf("Clearing remote port.\n");
    }
    assert (new_di_flags & (unsigned)NWTC_REMPORT_MASK);
    newconf.nwtc_remport= 0;
  }

  newconf.nwtc_flags = ((unsigned long)new_di_flags << 16) | new_en_flags;
  all_flags = new_en_flags | new_di_flags;
  sock->tcp_conf = newconf;

  if ((all_flags & (unsigned)NWTC_ACC_MASK) &&
      ((all_flags & (unsigned)NWTC_LOCPORT_MASK) == (unsigned)NWTC_LP_SET ||
       (all_flags & (unsigned)NWTC_LOCPORT_MASK) == (unsigned)NWTC_LP_SEL) &&
      (all_flags & (unsigned)NWTC_REMADDR_MASK) &&
      (all_flags & (unsigned)NWTC_REMPORT_MASK)) { 
    unsigned int wsock = sock->wsock;
    sock->flags |= kConfSet;
    set_dportr(wsock, sock->tcp_conf.nwtc_remport); // 16 bits
    set_portr(wsock, sock->tcp_conf.nwtc_locport);  // 16 bits
    set_dipr(wsock, *((ipv4_t*)&sock->tcp_conf.nwtc_remaddr)); // ipv4_t
    if (verbose > 0) {
      printf("Full TCP configuration in place.\n");
    }
  } else {
    if (verbose > 0) {
      printf("TCP configuration not in place.\n");
    }
    sock->flags &= ~kConfSet;
  }
  return OK;
}

// We'll probably ignore most of this.
int tcp_setopt(socket_t* sock, message* m) {
  nwio_tcpopt_t oldopt, newopt;
  unsigned int new_en_flags, new_di_flags, old_en_flags, old_di_flags;
  copy_from_user(m->PROC_NR, (vir_bytes)m->ADDRESS, (vir_bytes)&newopt,
      sizeof(nwio_tcpopt_t));
  oldopt = sock->tcp_opt;

  old_en_flags= LOW_WORD(oldopt.nwto_flags);
  old_di_flags= HIGH_WORD(oldopt.nwto_flags);
  new_en_flags= LOW_WORD(newopt.nwto_flags);
  new_di_flags= HIGH_WORD(newopt.nwto_flags);

  if (new_en_flags & new_di_flags) {
    if (verbose) {
      printf("tcp_setopt flags mismatch 1\n");
    }
    return EBADMODE;
  }

  /* NWTO_SND_URG_MASK */
  if (!((new_en_flags | new_di_flags) & (unsigned)NWTO_SND_URG_MASK)) {
    new_en_flags |= (old_en_flags & (unsigned)NWTO_SND_URG_MASK);
    new_di_flags |= (old_di_flags & (unsigned)NWTO_SND_URG_MASK);
  }

  /* NWTO_RCV_URG_MASK */
  if (!((new_en_flags | new_di_flags) & (unsigned)NWTO_RCV_URG_MASK)) {
    new_en_flags |= (old_en_flags & (unsigned)NWTO_RCV_URG_MASK);
    new_di_flags |= (old_di_flags & (unsigned)NWTO_RCV_URG_MASK);
  }

  /* NWTO_BSD_URG_MASK */
  if (!((new_en_flags | new_di_flags) & (unsigned)NWTO_BSD_URG_MASK)) {
    new_en_flags |= (old_en_flags & (unsigned)NWTO_BSD_URG_MASK);
    new_di_flags |= (old_di_flags & (unsigned)NWTO_BSD_URG_MASK);
  }

  /* NWTO_DEL_RST_MASK */
  if (!((new_en_flags | new_di_flags) & (unsigned)NWTO_DEL_RST_MASK)) {
    new_en_flags |= (old_en_flags & (unsigned)NWTO_DEL_RST_MASK);
    new_di_flags |= (old_di_flags & (unsigned)NWTO_DEL_RST_MASK);
  }

  newopt.nwto_flags= ((unsigned long)new_di_flags << 16) | new_en_flags;
  sock->tcp_opt = newopt;
  return OK;
}

int tcp_connect(socket_t* sock, message* m) {
  unsigned int wsock = sock->wsock;

  if (!(sock->flags & kConfSet)) {
    if (verbose > 0) {
      printf("Haven't fully set up connection\n");
    }
    return EBADMODE;
  }

  if (get_ssr(wsock) == WIZ_STATUS_ESTABLISHED) {
    if (verbose > 0) {
      printf("Connection already in process\n");
    }
    return EISCONN;
  }

  if ((sock->tcp_conf.nwtc_flags & (NWTC_SET_RA|NWTC_SET_RP)) !=
      (NWTC_SET_RA|NWTC_SET_RP)) {
    if (verbose > 0) {
      printf("Funny flags #1\n");
    }
    return EBADMODE;
  }
  if (!connect_socket(sock)) {
    return EIO;
  }
  sock->flags |= kSuspForConn;
  sock->suspended_message = *m;
  return SUSPEND;
}

int tcp_listen(socket_t* sock, message* m) {
  unsigned int wsock = sock->wsock;
  int res;
  int status;

  if (!(sock->flags & kConfSet)) {
    if (verbose > 0) {
      printf("Haven't fully set up connection\n");
    }
    return EBADMODE;
  }

  status = get_ssr(wsock);
  if (status != WIZ_STATUS_CLOSED) {
    char buf[TBUF_SIZE];
    pr_status(get_ssr(wsock), buf, TBUF_SIZE);
    if (trace) {
      printf("Attempted listen on non-closed socket, status was: %s\n", buf);
    }
    if (status == WIZ_STATUS_ESTABLISHED) {
      res = EISCONN;
    } else {
      res = ECONNRESET;
    }
  } else {
    res = listen_socket(sock);
  }

  if (res != OK) {
    return res;
  }
  sock->flags |= kSuspForConn;
  sock->suspended_message = *m;
  return SUSPEND;
}
