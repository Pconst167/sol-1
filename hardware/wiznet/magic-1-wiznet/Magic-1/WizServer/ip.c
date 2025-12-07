#include "common.h"

typedef struct ip_packet_info_t {
  ipv4_t dest_ip;
  uint16_t packet_len;
} ip_packet_info_t;

int ip_socket_ok(socket_t* sock);

void ip_open(socket_t* sock, message* m) {
  int r;
  r = allocate_socket(sock->sock_num);
  if (verbose > 0) {
    printf("ip_open allocated fd %s\n", pr_fd(r));
  }
  wnet_reply(sock, m, r);
}

void ip_close(socket_t* sock, message* m) {
  if (verbose > 0) {
    printf("ip_close handler for fd %s\n", pr_fd(sock->fd));
  }
  free_socket(sock->sock_num);
  wnet_reply(sock, m, OK);
}

// FIXME: consol w/ read_udp_raw
uint16_t read_ip_raw(socket_t* sock, uint16_t* buf, size_t buf_size,
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


void ip_read(socket_t* sock, message* m) {
  // FIXME: refactor to consolidate w/ tcp_read.
  int socket_status = ip_socket_ok(sock);
  int count = m->COUNT;
  int r = EINVAL;  // Default to something relatively harmless.
  unsigned int wsock = sock->wsock;
  int avail = get_rx_rsr(wsock);
  int mode = get_mr(wsock);
  if (sock->portr == 127) {
    printf("UNIMP: IP Loopback\n");
    wnet_reply(sock, m, EINVAL);
    // ip_loopback_read(sock, m);
    return;
  }
  if (verbose > 0) {
    printf("i_read, fd %s, avail %d, wanted %d\n", pr_fd(sock->fd),
        avail, count);
  }
  if (socket_status != OK) {
    wnet_reply(sock, m, socket_status);
    return;
  }
  if (avail < sizeof(ip_packet_info_t)) {
    if (verbose > 0) {
      printf("no IP data - suspending\n");
    }
    sock->suspended_message = *m;
    sock->flags |= kSuspForData;
    r = SUSPEND;
  } else {
    ip_packet_info_t info;
    ip_hdr_t hdr;
    vir_bytes user_addr = (vir_bytes)m->ADDRESS;
    if (verbose > 0) {
      printf("Before read, rx_rsr: %u\n", (unsigned)get_rx_rsr(wsock));
      printf("sizeof(info): %u\n", (int)sizeof(info));
    }
    r = read_ip_raw(sock, (uint16_t*)&info, sizeof(info), sizeof(info));
    if (verbose > 0) {
      printf("Got packet, size: %u, ", info.packet_len);
      print_ip(info.dest_ip.u.raw);
      printf("\n");
    }
    avail = get_rx_rsr(wsock);
    if (avail >= info.packet_len) {
      r = read_ip_raw(sock, &big_buf[0], BIG_BUF_BYTE_SIZE, 
          min(count, info.packet_len));
      if (verbose) {
        printf("Read %u bytes\n", r);
      }
      if (r > 0) {
        if ((sock->ip_opt.nwio_flags & NWIO_RWDATALL) == NWIO_RWDATALL) {
          hdr.ih_vers_ihl = 0x45;  // 20 bytes and IPV4
          hdr.ih_tos = sock->ip_opt.nwio_tos;
          hdr.ih_length = 20 + info.packet_len;
          hdr.ih_id = 0;  // don't know this
          hdr.ih_flags_fragoff = 0x4000;  // Don't fragment, 0 offset.
          hdr.ih_ttl = sock->ip_opt.nwio_ttl;
          hdr.ih_hdr_chk = 0;  // Let's ignore checksum for now.
          hdr.ih_src = info.dest_ip.u.raw;
          hdr.ih_dst = wiz_get32(offsetof(wiznet_t, sipr));
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

int ip_socket_ok(socket_t* sock) {
  int res = OK;
  if (get_mr(sock->wsock) != WIZ_MODE_IPRAW) {
    if (verbose) {
      printf("Not IP mode\n");
    }
    res = EINVAL;
  } else if (!(sock->flags & kConfSet)) {
    if (verbose > 0) {
      printf("Attempted IP write before options set\n");
    }
    res = EBADMODE;
  }
  return res;
}

void ip_write(socket_t* sock, message* m) {
  int socket_status = ip_socket_ok(sock);
  unsigned int wsock = sock->wsock;
  int res;
  ipv4_t dipr;
  if (verbose > 0) {
    printf("ip_write fd %s, count %u\n", pr_fd(sock->fd), m->COUNT);
  }
  if (socket_status != OK) {
    wnet_reply(sock, m, socket_status);
    return;
  }
  if (m->COUNT == 0) {
    printf("Zero length write from ip_write\n");
    wnet_reply(sock, m, 0);
  }
  sock->pending_write = *m;
  sock->written_bytes = 0;
  if ((sock->ip_opt.nwio_flags & NWIO_RWDATALL) == NWIO_RWDATALL) {
    ip_hdr_t hdr;
    if (m->COUNT <= sizeof(hdr)) {
      wnet_reply(sock, m, EINVAL);
      return;
    }
    copy_from_user(m->PROC_NR, (vir_bytes)m->ADDRESS, (vir_bytes)&hdr,
        sizeof(hdr));
    if (verbose > 0) {
      printf("Write ip header: (TBD)");
      // dump_ip_hdr(hdr);
    }
    set_dipr(wsock, *((ipv4_t*)&hdr.ih_dst));
    sock->written_bytes = sizeof(hdr);
  }
  // Do write
  if (verbose > 0) {
    printf("Writing IP packet -> (TBD)");
    // dump_wsocket_config(wsock);
  }
  dipr = get_dipr(wsock);
  if (dipr.u.bytes[0] == 127) {
    printf("UNIMP - IP loopback write\n");
    res = EINVAL;
    // res = udp_loopback_write(sock, (char*)&big_buf[0], count);
  } else {
    res = write_wsocket(sock);
  }
#if 0
  // FIXME: don't think I need to do this?
  // Restore target socket info.
  set_dipr(wsock, *((ipv4_t*)&sock->udp_opt.nwio_remaddr));
#endif
  wnet_reply(sock, m, res);
}

PUBLIC int ip_chk_hdropt (u8_t* opt, int optlen) {
  int i;
  int security_present = FALSE;
  int lose_source_present = FALSE;
  int strict_source_present = FALSE;
  int record_route_present = FALSE;
  int timestamp_present = FALSE;

  assert (!(optlen & 3));
  i= 0;
  while (i<optlen) {
    if (verbose) {
      printf("*opt= %d\n", *opt);
    }

    switch (*opt) {
      case 0x0:		/* End of Option list */
        return OK;
      case 0x1:		/* No Operation */
        i++;
        opt++;
        break;
      case 0x82:		/* Security */
        if (security_present)
          return EINVAL;
        security_present= TRUE;
        if (opt[1] != 11)
          return EINVAL;
        i += opt[1];
        opt += opt[1];
        break;
      case 0x83:		/* Lose Source and Record Route */
        if (lose_source_present) {
          if (verbose) {
            printf("snd lose soruce route\n");
          }
          return EINVAL;
        }
        lose_source_present= TRUE;
        if (opt[1]<3) {
          if (verbose) {
            printf("wrong length in source route\n");
          }
          return EINVAL;
        }
        i += opt[1];
        opt += opt[1];
        break;
      case 0x89:		/* Strict Source and Record Route */
        if (strict_source_present)
          return EINVAL;
        strict_source_present= TRUE;
        if (opt[1]<3)
          return EINVAL;
        i += opt[1];
        opt += opt[1];
        break;
      case 0x7:		/* Record Route */
        if (record_route_present)
          return EINVAL;
        record_route_present= TRUE;
        if (opt[1]<3)
          return EINVAL;
        i += opt[1];
        opt += opt[1];
        break;
      case 0x88:
        if (timestamp_present)
          return EINVAL;
        timestamp_present= TRUE;
        if (opt[1] != 4)
          return EINVAL;
        switch (opt[3] & 0xff) {
          case 0:
          case 1:
          case 3:
            break;
          default:
            return EINVAL;
        }
        i += opt[1];
        opt += opt[1];
        break;
      default:
        return EINVAL;
    }
  }
  if (i > optlen) {
    if (verbose) {
      printf("option of wrong length\n");
    }
    return EINVAL;
  }
  return OK;
}

int ip_checkopt(socket_t* sock) {
  unsigned long flags;
  unsigned int en_di_flags;

  flags = sock->ip_opt.nwio_flags;
  en_di_flags = HIGH_WORD(flags) | LOW_WORD(flags);

  if (flags & NWIO_HDR_O_SPEC) {
    int result = ip_chk_hdropt(sock->ip_opt.nwio_hdropt.iho_data,
        sock->ip_opt.nwio_hdropt.iho_opt_siz);
    if (result<0)
      return result;
  }

  if ((en_di_flags & (unsigned)NWIO_ACC_MASK) &&
      (en_di_flags & (unsigned)NWIO_LOC_MASK) &&
      (en_di_flags & (unsigned)NWIO_BROAD_MASK) &&
      (en_di_flags & (unsigned)NWIO_REM_MASK) &&
      (en_di_flags & (unsigned)NWIO_PROTO_MASK) &&
      (en_di_flags & (unsigned)NWIO_HDR_O_MASK) &&
      (en_di_flags & (unsigned)NWIO_RW_MASK)) {
    unsigned int wsock = sock->wsock;
    int protocol = sock->ip_opt.nwio_proto;
    assert(protocol != PROTOCOL_TCP);
    assert(protocol != PROTOCOL_UDP);
    set_protor(wsock, protocol);
    set_tosr(wsock, sock->ip_opt.nwio_tos);
    set_ttlr(wsock, sock->ip_opt.nwio_ttl);
    sock->flags |= kConfSet;
    // FIXME: open on write?  (perhaps not - will always come here if chagne)
    /*
     * 11/26/2016.  Not sure if I'm doing the right thing here.  Before I was
     * trying to repeatedly open an already IPRAW socket.  Probably doesn't
     * hurt, but resulted in warning messages.  Just open if not already IPRAW.
     */
    if ((get_ssr(wsock) != WIZ_STATUS_IPRAW) &&
        !open_socket(sock, WIZ_MODE_IPRAW)) {
      return EIO;
    }
    if (verbose) {
      printf("IP fd %s, configured\n", pr_fd(sock->fd));
    }
  } else {
    sock->flags &= ~kConfSet;
    if (verbose) {
      printf("IP fd %s, not configured\n", pr_fd(sock->fd));
    }
  }
  return OK;
}

int ip_setopt(socket_t* sock, message* m) {
  int r;
  unsigned long new_flags;
  nwio_ipopt_t newopt, oldopt;
  // read from userspace here
  unsigned int new_en_flags, new_di_flags, old_en_flags, old_di_flags;
  copy_from_user(m->PROC_NR, (vir_bytes)m->ADDRESS, (vir_bytes)&newopt,
      sizeof(nwio_ipopt_t));
  oldopt = sock->ip_opt;
  old_en_flags= LOW_WORD(oldopt.nwio_flags);
  old_di_flags= HIGH_WORD(oldopt.nwio_flags);
  new_en_flags= LOW_WORD(newopt.nwio_flags);
  new_di_flags= HIGH_WORD(newopt.nwio_flags);

  if (new_en_flags & new_di_flags) {
    if (verbose) {
      printf("ip_setopt flags mismatch 1\n");
    }
    return EBADMODE;
  }

  /* NWIO_ACC_MASK */
  if (new_di_flags & (unsigned)NWIO_ACC_MASK) {
    if (verbose) {
      printf("ip_setopt: can't disable access modes.\n");
    }
    return EBADMODE;
  }

  if (!(new_en_flags & (unsigned)NWIO_ACC_MASK)) {
    new_en_flags |= (old_en_flags & (unsigned)NWIO_ACC_MASK);
  }

  /* NWIO_LOC_MASK */
  if (!((new_en_flags|new_di_flags) & (unsigned)NWIO_LOC_MASK)) {
    new_en_flags |= (old_en_flags & (unsigned)NWIO_LOC_MASK);
    new_di_flags |= (old_di_flags & (unsigned)NWIO_LOC_MASK);
  }

  /* NWIO_BROAD_MASK */
  if (!((new_en_flags|new_di_flags) & (unsigned)NWIO_BROAD_MASK)) {
    new_en_flags |= (old_en_flags & (unsigned)NWIO_BROAD_MASK);
    new_di_flags |= (old_di_flags & (unsigned)NWIO_BROAD_MASK);
  }

  /* NWIO_REM_MASK */
  if (!((new_en_flags|new_di_flags) & (unsigned)NWIO_REM_MASK)) {
    new_en_flags |= (old_en_flags & (unsigned)NWIO_REM_MASK);
    new_di_flags |= (old_di_flags & (unsigned)NWIO_REM_MASK);
    newopt.nwio_rem= oldopt.nwio_rem;
  }

  /* NWIO_PROTO_MASK */
  if (!((new_en_flags|new_di_flags) & (unsigned)NWIO_PROTO_MASK)) {
    new_en_flags |= (old_en_flags & (unsigned)NWIO_PROTO_MASK);
    new_di_flags |= (old_di_flags & (unsigned)NWIO_PROTO_MASK);
    newopt.nwio_proto= oldopt.nwio_proto;
  }

  /* NWIO_HDR_O_MASK */
  if (!((new_en_flags|new_di_flags) & (unsigned)NWIO_HDR_O_MASK)) {
    new_en_flags |= (old_en_flags & (unsigned)NWIO_HDR_O_MASK);
    new_di_flags |= (old_di_flags & (unsigned)NWIO_HDR_O_MASK);
    newopt.nwio_tos= oldopt.nwio_tos;
    newopt.nwio_ttl= oldopt.nwio_ttl;
    newopt.nwio_df= oldopt.nwio_df;
    newopt.nwio_hdropt= oldopt.nwio_hdropt;
  }

  /* NWIO_RW_MASK */
  if (!((new_en_flags|new_di_flags) & (unsigned)NWIO_RW_MASK)) {
    new_en_flags |= (old_en_flags & (unsigned)NWIO_RW_MASK);
    new_di_flags |= (old_di_flags & (unsigned)NWIO_RW_MASK);
  }

  new_flags= ((unsigned long)new_di_flags << 16) | new_en_flags;

  if ((new_flags & NWIO_RWDATONLY) && (new_flags &
        (NWIO_REMANY|NWIO_PROTOANY|NWIO_HDR_O_ANY))) {
    if (verbose) {
      printf("ip_setopt: bad mode #2\n");
    }
    return EBADMODE;
  }

  newopt.nwio_flags= new_flags;
  sock->ip_opt = newopt;

  r = ip_checkopt(sock);

  if (r < 0) {
    sock->ip_opt= oldopt;
  }
  return r;
}

void ip_ioctl(socket_t* sock, message* m) {
  int req = m->REQUEST;
  int r = OK;
  int i;
  nwio_ipconf_t ipconf;
  vir_bytes user_addr = (vir_bytes)m->ADDRESS;
  int user_proc = m->PROC_NR;
  if (verbose > 0) {
    printf("ip_ioctl handler for fd %s\n", pr_fd(sock->fd));
  }
  switch (req) {
    case NWIOSIPOPT:
      if (trace || (verbose > 1)) {
        printf("ip_ioctl NWIOSIPOPT\n");
      }
      r = ip_setopt(sock, m);
      break;
    case NWIOGIPOPT:
      if (trace || (verbose > 1)) {
        printf("ip_ioctl NWIOGIPOPT\n");
      }
      copy_to_user((vir_bytes)&sock->ip_opt, m->PROC_NR,
          (vir_bytes)m->ADDRESS, sizeof(nwio_ipopt_t));
      r = OK;
      break;
    case NWIOSIPCONF:
      if (trace || (verbose > 1)) {
        printf("ip_ioctl NWIOSIPCONF\n");
      }
      copy_from_user(user_proc, user_addr, (vir_bytes)&ipconf, sizeof(ipconf));
      if (ipconf.nwic_flags & ~NWIC_FLAGS) {
        r = EBADMODE;
        break;
      }
      if (ipconf.nwic_flags & NWIC_IPADDR_SET) {
        w5300_ip_addr.u.raw = ipconf.nwic_ipaddr;
        wiz_flags |= kIPAddrSet;
      }
      if (ipconf.nwic_flags & NWIC_NETMASK_SET) {
        w5300_sub_mask.u.raw = ipconf.nwic_netmask;
        wiz_flags |= kNetmaskSet;
      }
      if (ipconf.nwic_flags & (NWIC_NETMASK_SET | NWIC_IPADDR_SET)) {
        init_w5300();
      }
      /*
       * Revive any process suspended awaiting IP setup.  Note that
       * this is the only instance of an action on one socket affecting
       * a different socket.
       */
      for (i = 0; i < NUM_WIZ_SOCKETS; i++) {
        if (sockets[i].flags & kSuspForIoctl) {
          if (verbose > 0) {
            printf("Reviving fd %s for kSuspForIoctl\n", pr_fd(sockets[i].fd));
          }
          sockets[i].flags &= ~kSuspForIoctl;
          ip_ioctl(&sockets[i], &sockets[i].suspended_message);
        }
      }
      break;

    case NWIOGIPCONF:
      if (trace || (verbose > 1)) {
        printf("ip_ioctl NWIOGIPCONF\n");
      }
      if (!(wiz_flags & kIPAddrSet)) {
        // Suspend.
        if (verbose > 0) {
          printf("Suspending NWIOGIPCONF on fd %s\n",
              pr_fd(sock->fd));
        }
        sock->suspended_message = *m;
        sock->flags |= kSuspForIoctl;
        r = SUSPEND;
        break;
      }
      copy_from_user(user_proc, user_addr, (vir_bytes)&ipconf, sizeof(ipconf));
      ipconf.nwic_flags= NWIC_IPADDR_SET;
      ipconf.nwic_ipaddr = w5300_ip_addr.u.raw;
      ipconf.nwic_netmask = w5300_sub_mask.u.raw;
      if (wiz_flags & kNetmaskSet)
        ipconf.nwic_flags |= NWIC_NETMASK_SET;
      copy_to_user((vir_bytes)&ipconf, user_proc, user_addr, sizeof(ipconf));
      break;
    case NWIOGIPIROUTE:
    case NWIOGIPOROUTE:
      {
        // A bit hacky here - hardcode the gateway route only.
        int looking_for;
        nwio_route_t route_ent;
        if ((trace || (verbose > 0)) && (req == NWIOGIPOROUTE)) {
          printf("ip_ioctl NWIOGIPOROUTE\n");
        }
        if ((trace || (verbose > 0)) && (req == NWIOGIPIROUTE)) {
          printf("ip_ioctl NWIOGIPIROUTE\n");
        }
        copy_from_user(user_proc, user_addr, (vir_bytes)&route_ent,
            sizeof(route_ent));
        looking_for = route_ent.nwr_ent_no;
        route_ent.nwr_ent_count = 1;
        route_ent.nwr_ent_no = looking_for;
        route_ent.nwr_netmask = w5300_sub_mask.u.raw;
        route_ent.nwr_gateway = w5300_gtw_addr.u.raw;
        route_ent.nwr_ifaddr = w5300_ip_addr.u.raw;
        route_ent.nwr_dist = 25;
        route_ent.nwr_dest = 0ul;
        if ((req == NWIOGIPOROUTE) && (looking_for == 0)) {
          route_ent.nwr_flags = NWRF_INUSE | NWRF_STATIC;
        } else {
          route_ent.nwr_flags = NWRF_EMPTY;
        }
        copy_to_user((vir_bytes)&route_ent, user_proc, user_addr,
            sizeof(route_ent));
      }
      break;
    case NWIOSIPIROUTE:
      if (trace || (verbose > 0)) {
        printf("ip_ioctl NWIOSIPIROUTE\n");
      }
      r = ENOENT;
      break;
    case NWIODIPIROUTE:
      if (trace || (verbose > 0)) {
        printf("ip_ioctl: NWIODIPIROUTE\n");
      }
      r = ENOENT;
      break;
    case NWIOSIPOROUTE:
      {
        nwio_route_t route_ent;
        if (trace || (verbose > 0)) {
          printf("ip_ioctl: NWIOSIPOROUTE\n");
        }
        copy_from_user(user_proc, user_addr, (vir_bytes)&route_ent,
            sizeof(route_ent));
        // Cheating - only look for the gateway.
        w5300_gtw_addr.u.raw = route_ent.nwr_gateway;
        wiz_flags |= kGatewaySet;
        init_w5300();
      }
      break;
    default:
      break;
  }
  wnet_reply(sock, m, r);
}

void ip_cancel(socket_t* sock, message* m) {
  if (verbose > 0) {
    printf("ip cancel handler for fd %s\n", pr_fd(sock->fd));
  }
  // May need to get more clever about this and take the cancelled
  // response into account.
  if (sock->flags & (kSuspForIoctl | kSuspForData | kSuspForConn)) {
    wnet_reply(sock, &sock->suspended_message, EINTR);
  }
  sock->flags &= ~(kSuspForIoctl | kSuspForData | kSuspForConn);
  // Clear any pending interrupts.
  set_ir(sock->wsock, ALL_SOCKET_INTERRUPTS);
  wnet_reply(sock, m, OK);
}
