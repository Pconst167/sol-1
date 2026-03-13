#include "common.h"

void udp_open(socket_t* sock, message* m);
void udp_close(socket_t* sock, message* m);
void udp_read(socket_t* sock, message* m);
void udp_write(socket_t* sock, message* m);
void udp_setconf(socket_t* sock, message* m);
void udp_ioctl(socket_t* sock, message* m);
void udp_cancel(socket_t* sock, message* m);
int udp_socket_ok(socket_t* sock);

typedef struct udp_packet_info_t {
  ipv4_t dest_ip;
  uint16_t dest_port;
  uint16_t packet_len;
} udp_packet_info_t;

// Done
void udp_open(socket_t* sock, message* m) {
  int r;
  // This should be the master socket (allocate_socket will check)
  r = allocate_socket(sock->sock_num);
  if (verbose > 0) {
    printf("udp_open allocated fd %s\n", pr_fd(r));
  }
  wnet_reply(sock, m, r);
}

// Done
void udp_close(socket_t* sock, message* m) {
  if (verbose > 0) {
    printf("udp_close handler for fd %s\n", pr_fd(sock->fd));
  }
  assert(sock->sock_num < NUM_WIZ_SOCKETS);
  wnet_reply(sock, m, OK);
  free_socket(sock->sock_num);
}

uint16_t read_udp_raw(socket_t* sock, uint16_t* buf, size_t buf_size,
    size_t count) {
  unsigned int wsock = sock->wsock;
  int i;
  uint16_t words;
  count = min(count, get_rx_rsr(wsock));
  count = min(count, buf_size);
  words = (count + 1) / 2;
  for (i = 0; i < words; i++) {
    *buf++ = get_rx_fifor(wsock);
  }
  if (get_rx_rsr(wsock) == 0) {
    (void)set_cr_check(wsock, WIZ_CMD_RECV, WIZ_STATUS_DONT_CARE);
  }
  return count;
}

void udp_loopback_read(socket_t* sock, message* m) {
  // FIXME: refactor to consolidate w/ udp_read.
  int socket_status = udp_socket_ok(sock);
  int count = m->COUNT;
  int r = EINVAL;  // Default to something relatively harmless.
  unsigned int wsock = sock->wsock;
  int avail = sock->loopback_data_size;
  int mode = get_mr(wsock);
  if (verbose > 0) {
    printf("udp_loopback_read, fd %s, avail %d, wanted %d\n",
        pr_fd(sock->fd), avail, count);
  }
  if (socket_status != OK) {
    if (verbose > 0) {
      printf("Bad socket status - replying failure\n");
    }
    wnet_reply(sock, m, socket_status);
    return;
  }
  if (avail < sizeof(udp_packet_info_t)) {
    if (verbose > 0) {
      printf("no UDP data - suspending\n");
    }
    sock->suspended_message = *m;
    sock->flags |= kSuspForData;
    r = SUSPEND;
  } else {
    udp_packet_info_t info;
    udp_io_hdr_t hdr;
    vir_bytes user_addr = (vir_bytes)m->ADDRESS;
    uint8_t* p = sock->loopback_data;
    memcpy((uint8_t*)&info, p, sizeof(info));
    assert(p != NULL);
    if (verbose > 0) {
      printf("Got loopback packet, size: %u, dest_port: %u, ", info.packet_len,
          info.dest_port);
      print_ip(info.dest_ip.u.raw);
      printf("\n");
    }
    avail -= sizeof(info);
    p += sizeof(info);
    r = min(info.packet_len, avail);
    if (verbose) {
      printf("Read %u bytes\n", r);
    }
    if (r > 0) {
      if ((sock->udp_opt.nwuo_flags & NWUO_RWDATALL) == NWUO_RWDATALL) {
        hdr.uih_dst_addr = 0x7f000001; // 127.0.0.1
        hdr.uih_dst_port = sock->portr;
        hdr.uih_src_addr = info.dest_ip.u.raw;
        hdr.uih_src_port = info.dest_port;
        hdr.uih_data_len = info.packet_len;
        hdr.uih_ip_opt_len = 0;
        copy_to_user((vir_bytes)&hdr, m->PROC_NR, user_addr, (int)sizeof(hdr));
        user_addr += sizeof(hdr);
        copy_to_user((vir_bytes)p, m->PROC_NR, user_addr, r);
        r += sizeof(hdr);
      } else {
        copy_to_user((vir_bytes)p, m->PROC_NR, user_addr, r);
      }
    } else {
      printf("Got packet info, but packet incomplete\n");
      r = EIO;
    }
  }
  // Single packet allowed, clear.
  free(sock->loopback_data);
  sock->loopback_data = NULL;
  sock->loopback_data_size = 0;
  if (verbose > 0) {
    printf("Loopback read completed - return val: %d\n", r);
  }
  wnet_reply(sock, m, r);
}

void udp_read(socket_t* sock, message* m) {
  // FIXME: refactor to consolidate w/ tcp_read.
  int socket_status = udp_socket_ok(sock);
  int count = m->COUNT;
  int r = EINVAL;  // Default to something relatively harmless.
  unsigned int wsock = sock->wsock;
  int avail = get_rx_rsr(wsock);
  int mode = get_mr(wsock);
  if (sock->portr == 127) {
    udp_loopback_read(sock, m);
    return;
  }
  if (verbose > 0) {
    printf("udp_read, fd %s, avail %d, wanted %d\n",
        pr_fd(sock->fd), avail, count);
  }
  if (socket_status != OK) {
    wnet_reply(sock, m, socket_status);
    return;
  }
  if (avail < sizeof(udp_packet_info_t)) {
    if (verbose > 0) {
      printf("no UDP data - suspending\n");
    }
    sock->suspended_message = *m;
    sock->flags |= kSuspForData;
    r = SUSPEND;
  } else {
    udp_packet_info_t info;
    udp_io_hdr_t hdr;
    vir_bytes user_addr = (vir_bytes)m->ADDRESS;
    if (verbose > 0) {
      printf("Before read, rx_rsr: %u\n", (unsigned)get_rx_rsr(wsock));
      printf("sizeof(info): %u\n", (int)sizeof(info));
    }
    r = read_udp_raw(sock, (uint16_t*)&info, sizeof(info), sizeof(info));
    if (verbose > 0) {
      printf("Got packet, size: %u, dest_port: %u, ", info.packet_len,
          info.dest_port);
      print_ip(info.dest_ip.u.raw);
      printf("\n");
    }
    avail = get_rx_rsr(wsock);
    if (avail >= info.packet_len) {
      r = read_udp_raw(sock, &big_buf[0], BIG_BUF_BYTE_SIZE, 
          min(count, info.packet_len));
      if (verbose) {
        printf("Read %u bytes\n", r);
      }
      if (r > 0) {
        if ((sock->udp_opt.nwuo_flags & NWUO_RWDATALL) == NWUO_RWDATALL) {
          hdr.uih_dst_addr = wiz_get32(offsetof(wiznet_t, sipr));
          hdr.uih_dst_port = sock->portr;
          hdr.uih_src_addr = info.dest_ip.u.raw;
          hdr.uih_src_port = info.dest_port;
          hdr.uih_data_len = info.packet_len;
          hdr.uih_ip_opt_len = 0;
          copy_to_user((vir_bytes)&hdr, m->PROC_NR, user_addr, (int)sizeof(hdr));
          user_addr += sizeof(hdr);
          copy_to_user((vir_bytes)&big_buf[0], m->PROC_NR, user_addr, r);
          r += sizeof(hdr);
        } else {
          copy_to_user((vir_bytes)&big_buf[0], m->PROC_NR, user_addr, r);
        }
      } else {
        if (verbose) {
          printf("Bad socket read\n");
        }
        r = EIO;
      }
    } else {
      printf("Got packet info, but packet incomplete\n");
      r = EIO;
    }
  }
  wnet_reply(sock, m, r);
}

void dump_udp_io_hdr(udp_io_hdr_t hdr) {
  printf("Dst: ");
  print_ip(hdr.uih_dst_addr);
  printf(":%u, len: %u\n", hdr.uih_dst_port, hdr.uih_data_len);
}

static uint8_t tmp_buf[1024];
void udp_loopback_write(socket_t* sock, char* buf, size_t size) {
  int i;
  int res = -1;
  unsigned int packet_info_size = sizeof(udp_packet_info_t);
  if (verbose > 0) {
    printf("LOOPBACK write to port %u of %u bytes\n", sock->dportr,
        (uint16_t)size);
  }
  for (i = 0; i < NUM_WIZ_SOCKETS; i++) {
    if ((sockets[i].flags & kInUse) &&
        (sockets[i].protocol == WIZ_MODE_UDP) &&
        (sockets[i].portr == sock->dportr)) {
      res = i;
      break;
    }
  }
  // Make sure target loopback socket exists and is configured.
  if ((res != -1) && (udp_socket_ok(&sockets[res]) == OK)) {
    uint8_t* newbuf;
    // If there was already a message pending, discard it.
    if (sockets[res].loopback_data != NULL) {
      if (verbose) {
        printf("Discarding pending packet of %u bytes\n",
            sockets[res].loopback_data_size);
      }
      free(sockets[res].loopback_data);
      sockets[res].loopback_data = NULL;
      sockets[res].loopback_data_size = 0;
    }
    //newbuf = (uint8_t*)malloc(size + packet_info_size);
    newbuf = &tmp_buf[0];
    if (newbuf != NULL) {
      // We need to construct a buffer as if it were produced by a Wiznet
      // packet receipt.  This means dummying up a udp_packet_info_t struct.
      udp_packet_info_t info;
      // ip and port of the sender.
      info.dest_ip.u.raw = 0x7f000001; // 127.0.0.1
      info.dest_port = sock->portr;
      info.packet_len = size;
      // Copy the packet info.
      memcpy(newbuf, (uint8_t*)&info, packet_info_size);
      // Copy the real packet.
      memcpy(newbuf + packet_info_size, buf, size);
      sockets[res].loopback_data = newbuf;
      sockets[res].loopback_data_size = size + packet_info_size;
      // Are we already waiting on this data?
      if (sockets[res].flags & kSuspForData) {
        if (verbose > 0) {
          printf("RECV: Loopback revive for data susp on fd %s\n",
              pr_fd(sockets[res].fd));
        }
        sockets[res].flags &= ~kSuspForData;
        udp_loopback_read(&sockets[res], &sockets[res].suspended_message);
      }
    } else {
      printf("Could not malloc buffer of %u bytes.  Discarding\n", size);
    }
  } else {
    if (verbose) {
      printf("NO MATCH\n");
    }
  }
}

int udp_socket_ok(socket_t* sock) {
  int res = OK;
  if (get_mr(sock->wsock) != WIZ_MODE_UDP) {
    if (verbose) {
      printf("Not UDP mode\n");
    }
    res = EINVAL;
  } else if (!(sock->flags & kConfSet)) {
    if (verbose > 0) {
      printf("Attempted UDP write before options set\n");
    }
    res = EBADMODE;
  }
  return res;
}

void udp_write(socket_t* sock, message* m) {
  int socket_status = udp_socket_ok(sock);
  uint16_t count = m->COUNT;
  unsigned int wsock = sock->wsock;
  vir_bytes user_addr = (vir_bytes)m->ADDRESS;
  int res;
  ipv4_t dipr;
  if (verbose > 0) {
    printf("udp_write fd %s, count %u\n", pr_fd(sock->fd), count);
  }
  if (socket_status != OK) {
    wnet_reply(sock, m, socket_status);
    return;
  }
  if (count == 0) {
    printf("Zero length write from udp_write\n");
    wnet_reply(sock, m, 0);
  }
  sock->pending_write = *m;
  sock->written_bytes = 0;
  if ((sock->udp_opt.nwuo_flags & NWUO_RWDATALL) == NWUO_RWDATALL) {
    udp_io_hdr_t hdr;
    copy_from_user(m->PROC_NR, user_addr, (vir_bytes)&hdr, sizeof(hdr));
    if (verbose > 0) {
      printf("Write udp pseudo header: ");
      dump_udp_io_hdr(hdr);
    }
    set_dipr(wsock, *((ipv4_t*)&hdr.uih_dst_addr));
    set_dportr(wsock, hdr.uih_dst_port);
    user_addr += sizeof(hdr);
    count -= sizeof(hdr);
    sock->written_bytes = sizeof(hdr);
  }
  if (verbose > 0) {
    printf("Writing UDP packet -> ");
    dump_wsocket_config(wsock);
  }
  dipr = get_dipr(wsock);
  if (dipr.u.bytes[0] == 127) {
    copy_from_user(m->PROC_NR, user_addr, (vir_bytes)&big_buf[0], count);
    udp_loopback_write(sock, (char*)&big_buf[0], count);
    // FIXME - assuming no failure?  Need to rewrite loopback stuff.
    res = m->COUNT;
  } else {
    res = write_wsocket(sock);
    if (res == SUSPEND) {
      // Ugliness with restoring socket info.  Must complete in one shot?
      assert(sock->written_bytes == m->COUNT);
    }
  }
  // Restore target socket info.
  // FIXME:  Why is this necessary?
  set_dipr(wsock, *((ipv4_t*)&sock->udp_opt.nwuo_remaddr));
  set_dportr(wsock, sock->udp_opt.nwuo_remport);
  wnet_reply(sock, m, res);
}

void dump_udpopt(nwio_udpopt_t opt) {
  if ((opt.nwuo_flags & NWUO_ACC_MASK) == NWUO_EXCL) {
    printf("EXCL ");
  }
  if ((opt.nwuo_flags & NWUO_ACC_MASK) == NWUO_SHARED) {
    printf("SHARED ");
  }
  if ((opt.nwuo_flags & NWUO_ACC_MASK) == NWUO_COPY) {
    printf("COPY ");
  }
  printf(", ");
  if ((opt.nwuo_flags & NWUO_LOCPORT_MASK) == NWUO_LP_SEL) {
    printf("LP_SEL ");
  }
  if ((opt.nwuo_flags & NWUO_LOCPORT_MASK) == NWUO_LP_SET) {
    printf("LP_SET ");
  }
  if ((opt.nwuo_flags & NWUO_LOCPORT_MASK) == NWUO_LP_ANY) {
    printf("LP_ANY ");
  }
  printf(", ");
  if ((opt.nwuo_flags & NWUO_EN_LOC) == NWUO_EN_LOC) {
    printf("EN_LOC ");
  }
  if ((opt.nwuo_flags & NWUO_DI_LOC) == NWUO_DI_LOC) {
    printf("DI_LOC ");
  }
  printf(", ");
  if ((opt.nwuo_flags & NWUO_EN_BROAD) == NWUO_EN_BROAD) {
    printf("EN_BROAD ");
  }
  if ((opt.nwuo_flags & NWUO_DI_BROAD) == NWUO_DI_BROAD) {
    printf("DI_BROAD ");
  }
  printf(", ");
  if ((opt.nwuo_flags & NWUO_RP_SET) == NWUO_RP_SET) {
    printf("RP_SET ");
  }
  if ((opt.nwuo_flags & NWUO_RP_ANY) == NWUO_RP_ANY) {
    printf("RP_ANY ");
  }
  printf(", ");
  if ((opt.nwuo_flags & NWUO_RA_SET) == NWUO_RA_SET) {
    printf("RA_SET ");
  }
  if ((opt.nwuo_flags & NWUO_RA_ANY) == NWUO_RA_ANY) {
    printf("RA_ANY ");
  }
  printf(", ");
  if ((opt.nwuo_flags & NWUO_RWDATONLY) == NWUO_RWDATONLY) {
    printf("RWDATONLY ");
  }
  if ((opt.nwuo_flags & NWUO_RWDATALL) == NWUO_RWDATALL) {
    printf("RWDATALL ");
  }
  printf(", ");
  if ((opt.nwuo_flags & NWUO_EN_IPOPT) == NWUO_EN_IPOPT) {
    printf("EN_IPOPT ");
  }
  if ((opt.nwuo_flags & NWUO_DI_IPOPT) == NWUO_DI_IPOPT) {
    printf("DI_IPOPT ");
  }
  printf("\n");
  printf("Local: ");
  print_ip(opt.nwuo_locaddr);
  printf(":%u, Remote: ",opt.nwuo_locport);
  print_ip(opt.nwuo_remaddr);
  printf(":%u\n", opt.nwuo_remport);
}

int udp_setopt(socket_t* sock, message* m) {
  nwio_udpopt_t udpopt;
  nwio_udpopt_t oldopt, newopt;
  unsigned int new_en_flags, new_di_flags,
               old_en_flags, old_di_flags, all_flags;
  unsigned long new_flags;
  copy_from_user(m->PROC_NR, (vir_bytes)m->ADDRESS, (vir_bytes)&udpopt,
      sizeof(nwio_udpopt_t));

  // Clear out unset fields.
  if ((udpopt.nwuo_flags & NWUO_LOCPORT_MASK) != NWUO_LP_SET) {
    udpopt.nwuo_locport = 0;
  }
  if ((udpopt.nwuo_flags & NWUO_REMPORT_MASK) != NWUO_RP_SET) {
    udpopt.nwuo_remport = 0;
  }
  if ((udpopt.nwuo_flags & NWUO_REMADDR_MASK) != NWUO_RA_SET) {
    udpopt.nwuo_remaddr = 0;
  }
  // Paste in locaddr (not really needed, but makes dumps look nicer).
  udpopt.nwuo_locaddr = wiz_get32(offsetof(wiznet_t, sipr));

  oldopt = sock->udp_opt;
  newopt = udpopt;
  old_en_flags= LOW_WORD(oldopt.nwuo_flags);
  old_di_flags= HIGH_WORD(oldopt.nwuo_flags);
  new_en_flags= LOW_WORD(newopt.nwuo_flags);
  new_di_flags= HIGH_WORD(newopt.nwuo_flags);

  if (new_en_flags & new_di_flags)
  {
    if (verbose) {
      printf("udp_setopt flags mismatch 1\n");
    }
    return EBADMODE;
  }

  /* NWUO_ACC_MASK */
  if (new_di_flags & (unsigned)NWUO_ACC_MASK)
  {
    /* access modes can't be disabled */
    if (verbose) {
      printf("returning EBADMODE\n");
    }
    return EBADMODE;
  }

  if (!(new_en_flags & (unsigned)NWUO_ACC_MASK)) {
    new_en_flags |= (old_en_flags & (unsigned)NWUO_ACC_MASK);
  }

  /* NWUO_LOCPORT_MASK */
  if (new_di_flags & (unsigned)NWUO_LOCPORT_MASK) {
    /* the loc ports can't be disabled */
    if (verbose) {
      printf("returning EBADMODE\n");
    }
    return EBADMODE;
  }
  if (!(new_en_flags & (unsigned)NWUO_LOCPORT_MASK)) {
    new_en_flags |= (old_en_flags & (unsigned)NWUO_LOCPORT_MASK);
    newopt.nwuo_locport= oldopt.nwuo_locport;
  } else if ((new_en_flags & (unsigned)NWUO_LOCPORT_MASK) ==
      (unsigned)NWUO_LP_SEL) {
    newopt.nwuo_locport = get_next_local_port();
  } else if ((new_en_flags & (unsigned)NWUO_LOCPORT_MASK) ==
      (unsigned)NWUO_LP_SET) {
    if (!newopt.nwuo_locport) {
      if (verbose) {
        printf("udp_setopt - no local port\n");
      }
      return EBADMODE;
    }
  }

  /* NWUO_LOCADDR_MASK */
  if (!((new_en_flags | new_di_flags) & (unsigned)NWUO_LOCADDR_MASK)) {
    new_en_flags |= (old_en_flags & (unsigned)NWUO_LOCADDR_MASK);
    new_di_flags |= (old_di_flags & (unsigned)NWUO_LOCADDR_MASK);
  }

  /* NWUO_BROAD_MASK */
  if (!((new_en_flags | new_di_flags) & (unsigned)NWUO_BROAD_MASK)) {
    new_en_flags |= (old_en_flags & (unsigned)NWUO_BROAD_MASK);
    new_di_flags |= (old_di_flags & (unsigned)NWUO_BROAD_MASK);
  }

  /* NWUO_REMPORT_MASK */
  if (!((new_en_flags | new_di_flags) & (unsigned)NWUO_REMPORT_MASK)) {
    new_en_flags |= (old_en_flags & (unsigned)NWUO_REMPORT_MASK);
    new_di_flags |= (old_di_flags & (unsigned)NWUO_REMPORT_MASK);
    newopt.nwuo_remport= oldopt.nwuo_remport;
  }

  /* NWUO_REMADDR_MASK */
  if (!((new_en_flags | new_di_flags) & (unsigned)NWUO_REMADDR_MASK)) {
    new_en_flags |= (old_en_flags & (unsigned)NWUO_REMADDR_MASK);
    new_di_flags |= (old_di_flags & (unsigned)NWUO_REMADDR_MASK);
    newopt.nwuo_remaddr= oldopt.nwuo_remaddr;
  }

  /* NWUO_RW_MASK */
  if (!((new_en_flags | new_di_flags) & (unsigned)NWUO_RW_MASK)) {
    new_en_flags |= (old_en_flags & (unsigned)NWUO_RW_MASK);
    new_di_flags |= (old_di_flags & (unsigned)NWUO_RW_MASK);
  }

  /* NWUO_IPOPT_MASK */
  if (!((new_en_flags | new_di_flags) & (unsigned)NWUO_IPOPT_MASK)) {
    new_en_flags |= (old_en_flags & (unsigned)NWUO_IPOPT_MASK);
    new_di_flags |= (old_di_flags & (unsigned)NWUO_IPOPT_MASK);
  }

  new_flags= ((unsigned long)new_di_flags << 16) | new_en_flags;
  if ((new_flags & NWUO_RWDATONLY) && 
      ((new_flags & NWUO_LOCPORT_MASK) == NWUO_LP_ANY || 
       (new_flags & (NWUO_RP_ANY|NWUO_RA_ANY|NWUO_EN_IPOPT)))) {
    if (verbose) {
      printf("udp_setopt error #1\n");
    }
    return EBADMODE;
  }

  /* Check the access modes (skipped - see inet's udp.c)*/

  /* Update */
  newopt.nwuo_flags = new_flags;
  sock->udp_opt = newopt;
  if (verbose > 0) {
    dump_udpopt(newopt);
  }

  all_flags= new_en_flags | new_di_flags;
  if ((all_flags & (unsigned)NWUO_ACC_MASK) &&
      (all_flags & (unsigned)NWUO_LOCPORT_MASK) &&
      (all_flags & (unsigned)NWUO_LOCADDR_MASK) &&
      (all_flags & (unsigned)NWUO_BROAD_MASK) &&
      (all_flags & (unsigned)NWUO_REMPORT_MASK) &&
      (all_flags & (unsigned)NWUO_REMADDR_MASK) &&
      (all_flags & (unsigned)NWUO_RW_MASK) &&
      (all_flags & (unsigned)NWUO_IPOPT_MASK)) {
    unsigned int wsock = sock->wsock;
    sock->flags |= kConfSet;
    set_dportr(wsock, sock->udp_opt.nwuo_remport);
    set_portr(wsock, sock->udp_opt.nwuo_locport);
    set_dipr(wsock, *((ipv4_t*)&sock->udp_opt.nwuo_remaddr));
    if (verbose > 0) {
      printf("UDP port configured -> ");
      dump_wsocket_config(sock->wsock);
    }
    if (!open_socket(sock, WIZ_MODE_UDP)) {
      return EIO;
    }
  } else {
    if (verbose) {
      printf("UDP Configuration not in place\n");
      printf("access = 0x%x\n", all_flags & (unsigned)NWUO_ACC_MASK);
      printf("locport= 0x%x\n", all_flags & (unsigned)NWUO_LOCPORT_MASK);
      printf("remaddr= 0x%x\n", all_flags & (unsigned)NWUO_REMADDR_MASK);
    }
    sock->flags &= ~kConfSet;
  }
  return OK;
}

void udp_ioctl(socket_t* sock, message* m) {
  int r = EINVAL;   // Default to something relatively harmless.
  int req = m->REQUEST;
  nwio_udpopt_t udp_opt;
  unsigned int wsock = sock->wsock;
  if (verbose > 0) {
    printf("udp_ioctl fd %s ", pr_fd(sock->fd));
  }
  assert(sock->flags & kInUse);

  switch (req) {

    // Set UDP options
    case NWIOSUDPOPT:
      if (trace || (verbose > 0)) {
        printf("NWIOSUDPOPT (set UDP options)\n");
      }
      r = udp_setopt(sock, m);
      break;

      // get UDP options
    case NWIOGUDPOPT:
      if (trace || (verbose > 0)) {
        printf("NWIOGUDPOPT (read current TCP option)\n");
      }
      udp_opt = sockets[sock->sock_num].udp_opt;
      udp_opt.nwuo_locaddr = wiz_get32(offsetof(wiznet_t, sipr));
      copy_to_user((vir_bytes)&udp_opt, m->PROC_NR,
          (vir_bytes)m->ADDRESS, sizeof(nwio_udpopt_t));
      r = OK;
      break;

    default:
      if (verbose) {
        printf("BAD UDP ioctl: 0x%x\n", req);
      }
      r = EBADIOCTL;
      break;
  }
  wnet_reply(sock, m, r);
}

void udp_cancel(socket_t* sock, message* m) {
  unsigned int wsock = sock->wsock;
  if (verbose > 0) {
    printf("udp_cancel fd %s, REQUEST 0x%x\n", pr_fd(sock->fd),
        m->REQUEST);
  }
  if (sock->flags & kSuspForData) {
    set_ir(wsock, WIZ_INT_RECV);
    if (get_rx_rsr(wsock) > 0) {
      (void)set_cr_check(wsock, WIZ_CMD_RECV, WIZ_STATUS_DONT_CARE);
    }
  }
  if (sock->flags & SUSPENDED_MASK) {
    sock->flags &= ~SUSPENDED_MASK;
    wnet_reply(sock, &sock->suspended_message, EINTR);
  }
  wnet_reply(sock, m, OK);
}
