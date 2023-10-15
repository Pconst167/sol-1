
#include "common.h"
#include "remap.h"

unsigned char* uart_base;
int synal_tasknr;
int this_proc;

void print_w5300(void);

char to_hex_dig(int i) {
  char res;
  i &= 0xf;
  if (i < 10)
    res = '0' + i;
  else
    res = 'a' + (i - 10);
  return res;
}

char* pr_fd(unsigned int fd) {
  static char a[64];
  if ((fd <= WIZ_UDP_DEV_OFF) && (fd >= WIZ_DEBUG_DEV_OFF)) {
    switch(fd & 0x000f) {
      case WIZ_DEBUG_DEV_OFF: strcpy(a, "DEBUG  "); break;
      case WIZ_IP_DEV_OFF:    strcpy(a, "IP     "); break;
      case WIZ_TCP_DEV_OFF:   strcpy(a, "TCP    "); break;
      case WIZ_UDP_DEV_OFF:   strcpy(a, "UDP    "); break;
      case WIZ_PS_DEV_OFF:    strcpy(a, "PS     "); break;
      case WIZ_FINGER_DEV_OFF:strcpy(a, "FINGER "); break;
      default: strcpy(a, "BOGUS "); break;
    }
  } else if (fd == WIZ_PS_DEV_OFF) {
    strcpy(a, "PS     ");
  } else if (fd == WIZ_FINGER_DEV_OFF) {
    strcpy(a, "FINGER ");
  } else if (fd == 0xffff) {
    strcpy(a, "-------");
  } else {
    char* p;
    switch(sockets[fd].protocol) {
      case WIZ_MODE_TCP: p = "TCP"; break;
      case WIZ_MODE_UDP: p = "UDP"; break;
      case WIZ_MODE_IPRAW: p = "IPRAW"; break;
      case WIZ_MODE_MACRAW: p = "MACRAW"; break;
      case WIZ_MODE_PPPoE: p = "PPPoE"; break;
      case WIZ_MODE_INVALID: p = "INVALID"; break;
      case WIZ_MODE_DEBUG: p = "DEBUG"; break;
      case WIZ_MODE_PS: p = "PS"; break;
      case WIZ_MODE_FINGER: p = "FG"; break;
      default:
                            p = "UNKNOWN";
    }
    if (sockets[fd].protocol == WIZ_MODE_TCP) {
      unsigned int port = sockets[fd].portr;
      if (port == 21) {
        p = "FTP";
      } else if (port == 23) {
        p = "TEL";
      } else if (port == 80) {
        p = "WEB";
      }
    }
    sprintf(a, "%d (%s)", fd, p);
  }
  return a;
}

void bad_assertion(char* msg, char* fname, int line) {
  print_w5300();
  printf("PANIC: %s at %s, line %d\n", msg, fname, line);
}

char* mode_names[4] = {
  "Debug",
  "TCP",
  "UDP",
  "IPRAW"
};

// Deferred reply waiting?
bool_t pending_reply = false;
// Buffer to use transiently - will not be preserved.
uint16_t big_buf[BIG_BUF_WORD_SIZE+1];
static char tbuf[TBUF_SIZE];
uint8_t *wiznet_base;  // Base mapping for Wiznet device.
mr_t *wiz_mr;          // Mode register
uint16_t* wiz_ar;      // Address register
uint16_t* wiz_dr;      // Data register
uint8_t* wiz_dr0;      // MSB of data register
uint8_t* wiz_dr1;      // LSB of data register

socket_t sockets[NUM_SOCKETS];
char* version = "1.0";
wiznet_flags_t wiz_flags = 0;
int wnet_proc_nr = -1;
int verbose = 0;
int trace = 0;
int spy = 0;
int log = 0;
// Start off with some default values.  Can change via ioctl call.
ipv4_t w5300_gtw_addr = {{192u, 168u, 0u, 1u}};
ipv4_t w5300_ip_addr = {{192u, 168u, 0u, 76u}};
ipv4_t w5300_sub_mask = {{255u, 255u, 255u, 0u}};
u8_t w5300_mac_addr[6] = {0x00, 0x16, 0x36, 0xde, 0x58, 0xf8};

// Note: shares static storage.
char* get_ipv4_str(ipv4_t* addr) {
  u8_t* p = &addr->u.bytes[0];
  snprintf(tbuf, TBUF_SIZE, "%u.%u.%u.%u", p[0], p[1], p[2], p[3]);
  return &tbuf[0];
}

dev_t ip_dev;   // Major/minor for /dev/wip

// Busy-wait delay (because we can't use signals or alarms here).
void milli_delay(int millis) {
  int j;
  int i;
  int inner = 140;   // Determined via looping test @ 4.09 Mhz.
  for (i = 0; i < millis; i++) {
    for (j = 0; j < inner; j++) {
    }
  }
}

int set_cr_check(unsigned int wsock, uint8_t value, uint8_t expected) {
  char buf1[TBUF_SIZE];
  char buf2[TBUF_SIZE];
  int i;
  set_cr(wsock, value);
  for (i = 0; i < 20; i++) {
    if ((expected == WIZ_STATUS_DONT_CARE) || (get_ssr(wsock) == expected)) {
      return TRUE;
    }
    milli_delay(10);
  }
  pr_status(get_ssr(wsock), buf1, TBUF_SIZE);
  pr_status(expected, buf2, TBUF_SIZE);
  printf("Socket %d, expected %s, got %s\n", wsock_to_sock(wsock)->sock_num,
      buf2, buf1);
  return FALSE;
}

int open_socket(socket_t* sock, uint16_t mode) {
  u8_t expected_status = WIZ_INVALID_STATUS;
  unsigned int wsock = sock->wsock;
  u8_t status;
  if (verbose > 0) {
    printf("Opening fd %s as %s\n", pr_fd(sock->fd),
        mode_names[mode]);
  }
  status = get_ssr(wsock);
  if (status != WIZ_STATUS_CLOSED) {
    char str[TBUF_SIZE];
    pr_status(status, str, TBUF_SIZE);
    printf("WARNING: expected STATUS_CLOSED, got %s [0x%x]\n", str, status);
    if (!close_socket(sock->sock_num)) {
      return FALSE;
    }
  }
  set_ir(wsock, ALL_SOCKET_INTERRUPTS);    /* clear any old interrupts */
  set_mr(wsock, mode);
  switch (mode) {
    case WIZ_MODE_IPRAW:
      set_imr(wsock, IP_INT_MASK);
      expected_status = WIZ_STATUS_IPRAW;
      break;
    case WIZ_MODE_TCP:
      set_imr(wsock, TCP_INT_MASK);
      expected_status = WIZ_STATUS_INIT;
      break;
    case WIZ_MODE_UDP:
      set_imr(wsock, UDP_INT_MASK);
      expected_status = WIZ_STATUS_UDP;
      break;
    default:
      printf("Invalid open mode %d\n", mode);
      return FALSE;
  }
  return set_cr_check(wsock, WIZ_CMD_OPEN, expected_status);
}

int connect_socket(socket_t* sock) {
  unsigned int wsock = sock->wsock;
  if (!open_socket(sock, WIZ_MODE_TCP)) {
    return FALSE;
  }
  // Note: multiple status codes are possible here, so we don't check here.
  // We will either hit ESTABLISHED or timeout - and will be notified of
  // which via interrupt.
  set_cr_check(wsock, WIZ_CMD_CONNECT, WIZ_STATUS_DONT_CARE);
  if (verbose > 0) {
    uint16_t rem_port = sock->tcp_conf.nwtc_remport;
    uint16_t loc_port = sock->tcp_conf.nwtc_locport;
    char* p;
    ipv4_t dipr;
    dipr.u.raw = sock->tcp_conf.nwtc_remaddr;
    p = get_ipv4_str(&dipr);
    printf("Connecting fd %s l_port %u", pr_fd(sock->fd), loc_port);
    printf(" to %s at rem_port %u\n", p, rem_port);
  }
  return TRUE;
}

int listen_socket(socket_t* sock)
{
  unsigned int wsock = sock->wsock;
  if (!open_socket(sock, WIZ_MODE_TCP)) {
    return ECONNRESET;
  }
  if (!set_cr_check(wsock, WIZ_CMD_LISTEN, WIZ_STATUS_LISTEN)) {
    // FIXME? What if we cycle from LISTEN to ESTABLISHED too fast for
    // the set_cr_check?  Should set_cr_check accept a list of acceptable
    // end states?
    return ECONNRESET;
  }
  if (trace || verbose > 0) {
    uint16_t loc_port = sock->tcp_conf.nwtc_locport;
    printf("Socket %d listening on port %u\n", sock->sock_num, loc_port);
  }
  return OK;
}

void put_bytes(char* buf, int size) {
  int i;
  char ch;
  for (i = 0; i < size; i++) {
    ch = buf[i];
    if (ch < ' ') 
      ch = '.';
    printf("%c",ch);
  }
}

/*
 * Write data to wiznet socket.  Each time we write, the writing process
 * is suspended until we get the CHECK_SEND_OK interrupt.
 */
int write_wsocket(socket_t* sock) {
  int sock_num = sock->sock_num;
  int status;
  unsigned int wsock = sock->wsock;
  uint16_t bytes_to_go = sock->pending_write.COUNT - sock->written_bytes;
  uint16_t bytes_to_write =
    min(min(bytes_to_go, get_tx_fsr(wsock)), BIG_BUF_BYTE_SIZE);
  uint16_t words = (bytes_to_write + 1)/2;
  message* m = &sock->pending_write;
  uint16_t* p;
  int i;
  uint32_t payload = sock->pending_write.COUNT;
  // Try to ensure there's some room in the transmit buffer.
  i = 0;
  while (get_tx_fsr(wsock) == 0) {
    if (i++ > 50) {
      break;
    } else {
      milli_delay(10);
    }
  }
  bytes_to_write = min(min(bytes_to_go, get_tx_fsr(wsock)), BIG_BUF_BYTE_SIZE);
  payload = payload << 16;
  payload |= bytes_to_write;
  add_trace(sock_num, get_trace_kind(wsock), TRACE_WRITE_WSOCKET, 0, payload);
  if (verbose) {
    printf("Send command, %d bytes to sock %d\n", bytes_to_write, sock_num);
  }

  // Is the socket ready to be written to?
  status = get_ssr(wsock);
  if ((status != WIZ_STATUS_ESTABLISHED) &&
      (status != WIZ_STATUS_CLOSE_WAIT) &&
      (status != WIZ_STATUS_IPRAW) &&
      (status != WIZ_STATUS_UDP)) {
    // Reply connection reset and return.
    sock->flags &= ~SUSPENDED_MASK;
    return ECONNRESET;
  }

  // copy to buf, set up p;
  if (bytes_to_write <= 0) {
    return EINVAL;
  }
  copy_from_user(m->PROC_NR, ((vir_bytes)m->ADDRESS) + sock->written_bytes,
      (vir_bytes)&big_buf[0], bytes_to_write);
  p = (uint16_t*)&big_buf[0];

  // Write the data to the transmit buffer 16 bits at a time.
  for (i=0; i < words; i++) { 
    set_tx_fifor(wsock, *p++);
  }
  // Record progress
  sock->written_bytes += bytes_to_write;

  // Set suspend
  sock->flags |= kSuspForOK;

  // Do the actual send
  set_tx_wrsr(wsock, bytes_to_write);
  (void)set_cr_check(wsock, WIZ_CMD_SEND, WIZ_STATUS_DONT_CARE);
  return SUSPEND;
}

int read_tcp_socket(socket_t* sock, uint16_t* buf, size_t buf_max, size_t count) {
  int words;
  int i;
  uint16_t data;
  uint16_t written = 0;
  uint16_t packet_size = 0;
  uint16_t avail = sock->unread_bytes;  // Anything left from last read?
  unsigned int wsock = sock->wsock;
  uint16_t rsr;
  assert(count != 0);
  // FIXME: ideally, we only deal with whole packets.  Can we lose leftover?
  if (avail == 0) {
    // Nothing leftover, check recieve queue.
    avail = get_rx_rsr(wsock);
    if (avail > 0) {
      // 1st word in the queue will be packet size - that's what we care about.
      avail = get_rx_fifor(wsock);
      packet_size = avail;
      if (packet_size > buf_max) {
        printf("Error: read packet too big: %u > %u\n", packet_size, buf_max);
        print_w5300();
        return 0;
      }
    }
  } else {
    packet_size = avail;
    if (sock->leftover_byte) {
      // Last time around we had an orphan byte.  Consume it now to get us back
      // on track.
      // Note: assumes non-aligned write is OK.
      u8_t* b = (u8_t*)buf;
      *b++ = sock->ch;
      buf = (uint16_t*)b;
      avail--;
      written++;
      count--;
      sock->leftover_byte = false;
    }
    sock->unread_bytes = 0;
  }
  if (avail == 0) {
    return written;
  }
  if (avail > count) {
    sock->unread_bytes = avail - count;
    if (count & 1) {
      sock->leftover_byte = true;
    }
  }
  count = min(count, avail);
  words = (count + 1) / 2;
  for (i = 0; i < words; i++) {
    data = get_rx_fifor(wsock);
    rsr = get_rx_rsr(wsock);
    buf[i] = data;
  }
  if (sock->leftover_byte) {
    sock->ch = data & 0xff;
  }
  written += count;
  if (verbose > 0) {
    printf("Packet size: %d, read: %d, rx_rsr: %u\n", packet_size, written,
        (unsigned)get_rx_rsr(wsock));
  }
  // Note: though we've read the packet, there still may be a leftover byte.
  // We need to issue the WIZ_CMD_RECV, though, to get more data.
  if (get_rx_rsr(wsock) == 0) {
    (void)set_cr_check(wsock, WIZ_CMD_RECV, WIZ_STATUS_DONT_CARE);
  }
  return written;
}

void print_int_list(int sock_int) {
  if (sock_int & WIZ_INT_CON) {
    printf(" CON");
    sock_int &= ~WIZ_INT_CON;
  }
  if (sock_int & WIZ_INT_RECV) {
    printf(" RECV");
    sock_int &= ~WIZ_INT_RECV;
  }
  if (sock_int & WIZ_INT_DISCON) {
    printf(" DISCON");
    sock_int &= ~WIZ_INT_DISCON;
  }
  if (sock_int & WIZ_INT_TIMEOUT) {
    printf(" TIMEOUT");
    sock_int &= ~WIZ_INT_TIMEOUT;
  }
  if (sock_int & WIZ_INT_SENDOK) {
    printf(" SENDOK");
    sock_int &= ~WIZ_INT_SENDOK;
  }
  if (sock_int != 0) {
    printf(" Warning: unknown signal 0x%x\n", sock_int);
  }
}

int get_trace_kind(unsigned int wsock) {
  int res;
  switch (get_mr(wsock)) {
    case WIZ_MODE_TCP: res = TRACE_KIND_TCP; break;
    case WIZ_MODE_UDP: res = TRACE_KIND_UDP; break;
    case WIZ_MODE_IPRAW: res = TRACE_KIND_IPRAW; break;
    default: res = TRACE_KIND_NONE; break;
  }
  return res;
}

/*
 * This is the interrupt handler for the Wiznet device.
 * It is responsible for calling the protocol specific handler and
 * then marking the interrupt as handled.
 */
void service_minix_socket(int sock_num, u8_t sock_int) {
  socket_t* sock = &sockets[sock_num];
  unsigned int wsock = sock->wsock;
  unsigned int trace_kind = get_trace_kind(wsock);
  if (verbose > 0) {
    printf("w5300 handler, fd %s, int:", pr_fd(sock->fd));
    print_int_list(sock_int);
    printf("\n");
  }
  if (sock_int & WIZ_INT_SENDOK) {
    int res;
    add_trace(sock_num, trace_kind, TRACE_INT_SENDOK, 0, 0);
    if (verbose > 0) {
      printf("SENDOK: send successful\n");
    }
    set_ir(wsock, WIZ_INT_SENDOK);
    if (!(sock->flags & kSuspForOK)) {
    } else {
      assert(sock->written_bytes <= sock->pending_write.COUNT);
      if (sock->written_bytes == sock->pending_write.COUNT) {
        // We're all done - report count to caller.
        res = sock->pending_write.COUNT;
      } else {
        // Try the next packet.  Note - might return an error code.
        res = write_wsocket(sock);
      }
      if (res != SUSPEND) {
        // Release caller with either successful count, or error from write.
        sock->flags &= ~kSuspForOK;
        wnet_reply(sock, &sock->pending_write, res);
      }
    }
  }
  if (sock_int & WIZ_INT_CON) {
    uint16_t rem_port = get_dportr(wsock);
    uint16_t loc_port = get_portr(wsock);
    ipv4_t dipr = get_dipr(wsock);
    if (verbose > 0) {
      char* p = get_ipv4_str(&dipr);
      printf("CON: Connected local port %u", loc_port);
      printf(" to %s at remote port 0x%04x\n", p, rem_port);
    }
    if (sock->flags & kSuspForConn) {
      if (verbose > 0) {
        printf("CON: Revive for conn suspend on fd %s\n", pr_fd(sock->fd));
      }
      sock->flags &= ~kSuspForConn;
      wnet_reply(sock, &sock->suspended_message, OK);
    }
    add_trace(sock_num, trace_kind, TRACE_INT_CONNECTED, 0, dipr.u.raw);
    set_ir(wsock, WIZ_INT_CON);
  }
  if (sock_int & WIZ_INT_RECV) {
    add_trace(sock_num, trace_kind, TRACE_INT_RECEIVE, 0, 0);
    if (verbose > 0) {
      int bytes_avail = get_rx_rsr(wsock);
      printf("RECV: bytes avail: %d\n", bytes_avail);
    }
    if (sock->flags & kSuspForData) {
      if (verbose > 0) {
        printf("RECV: Revive for data suspend on fd %s\n", pr_fd(sock->fd));
      }
      sock->flags &= ~kSuspForData;
      // NEED magic callback to know which to call!
      switch (get_mr(wsock)) {
        case WIZ_MODE_TCP: tcp_read(sock, &sock->suspended_message); break;
        case WIZ_MODE_UDP: udp_read(sock, &sock->suspended_message); break;
        case WIZ_MODE_IPRAW: ip_read(sock, &sock->suspended_message); break;
        default:
                             printf("RECV: unknown mode on revived read\n");
      }
    } else {
      if (verbose > 0) {
        printf("RECV: No pending read, return\n");
      }
    }
    set_ir(wsock, WIZ_INT_RECV);
  }
  if (sock_int & WIZ_INT_DISCON) {
    add_trace(sock_num, trace_kind, TRACE_INT_DISCONNECTED, get_ssr(wsock), 0);
    if (verbose > 0) {
      printf("DISCON: disconnected\n");
    }
    // FIXME: handle suspended requests.  How do we handle case of
    // read/close when client hasn't had a chance to generate read
    // request?  Perhaps defer this while there is outstanding data?
    set_ir(wsock, WIZ_INT_DISCON);
    if (sock->flags & kSuspForOK) {
      // Report reset and let client perform recovery as needed.
      sock->flags &= ~kSuspForOK;
      wnet_reply(sock, &sock->pending_write, ECONNRESET);
    } else if (sock->flags & kSuspForConn) {
      sock->flags &= ~kSuspForConn;
      wnet_reply(sock, &sock->suspended_message, ECONNRESET);
    } else if ((sock->flags & kSuspForData) && (get_rx_rsr(wsock) == 0)) {
      sock->flags &= ~kSuspForData;
      wnet_reply(sock, &sock->suspended_message, ECONNRESET);
    } else if (get_rx_rsr(wsock) != 0) {
      // Don't close - we might have a read coming.  But, set a timer so
      // we don't wait forever
    } else {
      // Finish the disconnect
      (void)set_cr_check(wsock, WIZ_CMD_DISCON, WIZ_STATUS_DONT_CARE);
    }
  } 
  if (sock_int & WIZ_INT_TIMEOUT) {
    add_trace(sock_num, trace_kind, TRACE_INT_TIMEOUT, 0, 0);
    if (verbose > 0) {
      printf("TIMEOUT: got timeout\n");
    }
    // Reply to any pending request with an EINTR?
    if (sock->flags & SUSPENDED_MASK) {
      message saved_message;
      if (sock->flags & kSuspForOK) {
        saved_message = sock->pending_write;
      } else {
        saved_message = sock->suspended_message;
      }
      if (verbose > 0) {
        printf("TIMEOUT: Notify waiting process on fd %s\n", pr_fd(sock->fd));
        dump_socket(sock);
      }
      sock->flags &= ~SUSPENDED_MASK;
      wnet_reply(sock, &saved_message, ETIMEDOUT);
    }
    set_ir(wsock, WIZ_INT_TIMEOUT);
  }
}

void validate_sizes(void)
{
  assert(sizeof(wiznet_t) == 0x400);
  assert(offsetof(wiznet_t,socket) == 0x200);
  assert(offsetof(wiznet_t,idr) == 0xfe);
  assert(offsetof(wiznet_t,brdy) == 0x60);
  assert(offsetof(wiznet_t,mtyper) == 0x30);
  assert(offsetof(wiznet_t,sipr) == 0x18);
  assert(offsetof(wiznet_t,subr) == 0x14);
  assert(offsetof(wiznet_t,gar) == 0x10);
  assert(offsetof(wiznet_t,shar) == 0x8);
  assert(offsetof(wiznet_t,imr) == 0x4);
  assert(offsetof(wiznet_t,ir) == 0x2);
  assert(offsetof(wiznet_t,mr) == 0x0);
}

unsigned int wsock_to_socknum(unsigned int wsock) {
  return (wsock - offsetof(wiznet_t, socket[0])) / sizeof(w_socket_t);
}

socket_t* wsock_to_sock(unsigned int wsock) {
  int sock_num = (wsock - offsetof(wiznet_t, socket[0])) / sizeof(w_socket_t);
  return &sockets[sock_num];
}

void print_dot_list(u8_t* data, int len)
{
  int i;
  for (i=0; i< (len-1); i++)
    printf("%u.",data[i]);
  printf("%u",data[len-1]);
}

void print_ip(uint32_t ip)
{
  uint8_t* t = (uint8_t*)&ip;
  printf("%u.%u.%u.%u", t[0], t[1], t[2], t[3]);
}

void print_mac(unsigned int offset)
{
  int i;
  for (i=0; i< 5; i++)
    printf("%02x:",wiz_get8(offset+i));
  printf("%02x",wiz_get8(offset+5));
}

void dump_wsocket_config(unsigned int wsock) {
  ipv4_t dipr = get_dipr(wsock);
  printf("Local: ");
  print_ip(wiz_get32(offsetof(wiznet_t, sipr)));
  printf(":%u, Remote: ", get_portr(wsock));
  print_ip(dipr.u.raw);
  printf(":%u\n", get_dportr(wsock));
}

void print_w5300(void)
{
  int i;
  uint16_t mtyper = wiz_get16(offsetof(wiznet_t, mtyper));
  char ch;
  mr_t mr;
  ir_t ir;
  ir_t imr;

  printf("Wiznet, ID = 0x%x\n", wiz_get16(offsetof(wiznet_t, idr)));
  printf("MAC address    : ");
  print_mac(offsetof(wiznet_t, shar));
  printf("\nIP address     : ");
  print_ip(wiz_get32(offsetof(wiznet_t, sipr)));
  printf("\nGateway        : ");
  print_ip(wiz_get32(offsetof(wiznet_t, gar)));
  printf("\nSubnet mask    : ");
  print_ip(wiz_get32(offsetof(wiznet_t, subr)));
  printf("\n");
  mr.u.raw = wiz_get16(offsetof(wiznet_t, mr));
  printf("MR : 0x%04x\n", mr.u.raw);
  ir.u.raw = wiz_get16(offsetof(wiznet_t, ir));
  printf("IR : 0x%04x\n", ir.u.raw);
  imr.u.raw = wiz_get16(offsetof(wiznet_t, imr));
  printf("IMR: 0x%04x\n", imr.u.raw);
  printf("RTR: 0x%04x\n", wiz_get16(offsetof(wiznet_t, rtr)));
  printf("RCR: 0x%04x\n", wiz_get16(offsetof(wiznet_t, rcr)));
  printf("mem allocation (mtyper) : ");
  for (i = 0; i < 16; i++) {
    ch = (mtyper & (1 << i)) ? 't' : 'r';
    printf("%c", ch);
  }
  printf("\n");
  for (i=0; i<8; i++) {
    printf("Socket[%d] : T-%02d, R-%02d\n",i,
        wiz_get8(offsetof(wiznet_t, tmsr[i])),
        wiz_get8(offsetof(wiznet_t, rmsr[i])));
  }
  dump_sockets();
  // Should need to do this, but pump out some nulls to flush the buffer.
  for (i = 0; i < 80; i++) {
    printf("%c", 0);
  }
}


void init_w5300(void)
{
  int i;
  mr_t mr;
  ir_t imr;

  mr.u.raw = 0;
  imr.u.raw = 0;

  // Reset w5300
  mr.u.reg.rst = 1;
  *wiz_mr = mr;
  // For a softare reset, this delay may not be necessary.
  milli_delay(10);

  // Set direct mode
  mr = *wiz_mr;
  mr.u.reg.ind = 1;
  *wiz_mr = mr;

  // Set gateway address
  wiz_set32(offsetof(wiznet_t, gar), w5300_gtw_addr.u.raw);

  // Set ip address
  wiz_set32(offsetof(wiznet_t, sipr), w5300_ip_addr.u.raw);

  // Set submask
  wiz_set32(offsetof(wiznet_t, subr), w5300_sub_mask.u.raw);

  // Set MAC address
  for (i = 0; i < 6; i++) {
    wiz_set8(offsetof(wiznet_t, shar[i]), w5300_mac_addr[i]);
  }

  // Reduce timeout values (we need get to get back online quicker)
  wiz_set16(offsetof(wiznet_t, rtr), 500);  // Default is 2000
  wiz_set16(offsetof(wiznet_t, rcr), 3);    // Default is 8

  // Disable interrupts at socket layer.  Re-enable on open socket.
  for (i = 0; i < NUM_WIZ_SOCKETS; i++) {
    wiz_set8(offsetof(wiznet_t, socket[i].imr), DISABLE_INTERRUPTS);
  }

  // Selectively enable interrupts at wiznet level.
  imr.u.reg.IPCF = 1;    // IP conflict
  imr.u.reg.DPUR = 1;    // Destination port unreachable
  imr.u.reg.PPPT = 0;    // PPoe Terminate
  imr.u.reg.FMTU = 0;    // Fragment MTU
  imr.u.reg.s7_int = 1;  // Socket 7
  imr.u.reg.s6_int = 1;  // Socket 6
  imr.u.reg.s5_int = 1;  // Socket 5
  imr.u.reg.s4_int = 1;  // Socket 4
  imr.u.reg.s3_int = 1;  // Socket 3
  imr.u.reg.s2_int = 1;  // Socket 2
  imr.u.reg.s1_int = 1;  // Socket 1
  imr.u.reg.s0_int = 1;  // Socket 0
  wiz_set16(offsetof(wiznet_t, imr), imr.u.raw);

  if (verbose > 0) {
    printf("------- After initialization ---------\n");
    print_w5300();
  }
}

char* pr_source(int source) {
  char* res = NULL;
  switch(source) {
    case FS_PROC_NR: res = "FS"; break;
    case SYN_ALRM_TASK: res = "SYN_ALARM"; break;
    case CLOCK: res = "W5300"; break;
    default: res = "UNKNOWN";
  }
  return res;
}

char* pr_type(int message_type) {
  char* res = NULL;
  switch(message_type) {
    case CANCEL:    res = "CANCEL"; break;
    case HARD_INT:  res = "HARD_INT"; break;
    case DEV_READ:  res = "DEV_READ"; break;
    case DEV_WRITE: res = "DEV_WRITE"; break;
    case DEV_IOCTL: res = "DEV_IOCTL"; break;
    case DEV_OPEN:  res = "DEV_OPEN"; break;
    case DEV_CLOSE: res = "DEV_CLOSE"; break;
    case SUSPEND:   res = "SUSPEND"; break;
    default: res ="UNKNOWN  ";
  }
  return res;
}

void pr_mode(int mode, char* buf, size_t buf_size) {
  char *res;
  switch(mode) {
    case 0 : res = "Closed"; break;
    case 1 : res = "TCP   "; break;
    case 2 : res = "UDP   "; break;
    case 3 : res = "IP RAW"; break;
    case 4 : res = "MACRAW"; break;
    case 5 : res = "PPPoE "; break;
    default:
             snprintf(buf, buf_size, "0x%04x",mode);
             return;
  }
  strncpy(buf, res, buf_size);
  return;
}

void pr_status(u8_t status, char* buf, size_t buf_size) {
  char *res;
  switch(status) {
    case 0x00 : res = "CLOSED     "; break;
    case 0x01 : res = "ARP        "; break;
    case 0x13 : res = "INIT       "; break;
    case 0x14 : res = "LISTEN     "; break;
    case 0x15 : res = "SYNSENT    "; break;
    case 0x16 : res = "SYNREC     "; break;
    case 0x17 : res = "ESTABLISHED"; break;
    case 0x18 : res = "FIN_WAIT   "; break;
    case 0x1B : res = "TIME_WAIT  "; break;
    case 0x1C : res = "CLOSE_WAIT "; break;
    case 0x1D : res = "LAST_ACK   "; break;
    case 0x22 : res = "UDP        "; break;
    case 0x32 : res = "IPRAW      "; break;
    case 0x42 : res = "MACRAW     "; break;
    case 0x5F : res = "PPPoE      "; break;
    default:
                snprintf(buf, buf_size, "0x%04x", status);
                return;
  }
  strncpy(buf, res, buf_size);
  return;
}

char* ints = "CDRTS";
void pr_interrupts(u8_t mask, char* buf, size_t buf_size) {
  int i;
  assert(buf_size >= 6);
  strcpy(buf,"-----");
  for (i=0; i<5; i++)
    if (mask & (1 << i)) {
      buf[i] = ints[i];
    }
}

char* flag_names[] = {
  "InUse",
  "Pseudo",
  "RemAddrSet",
  "RemPortSet",
  "LocPortSet",
  "LocAddrSet",
  "NetMaskSet",
  "Master",
  "NeedsReply",
  "SuspForIoctl",
  "SuspForConn",
  "SuspForData",
  "SuspForRead",
  "SuspForOK",
  "EOF",
  "Configured"};

void dump_socket(socket_t* sock) {
  char enabled[TBUF_SIZE];
  char pending[TBUF_SIZE];
  char mode[TBUF_SIZE];
  char status[TBUF_SIZE];
  char sock_str[256];
  char* fdp;
  unsigned int wsock = sock->wsock;
  int rsr = get_rx_rsr(wsock);
  int fsr = get_tx_fsr(wsock);
  int imr = get_imr(wsock);
  int ir = get_ir(wsock);
  int mr = get_mr(wsock);
  int ssr = get_ssr(wsock);
  *enabled = *pending = *mode = *status = 0;
  pr_interrupts(imr, enabled, TBUF_SIZE);
  pr_interrupts(ir, pending, TBUF_SIZE);
  pr_mode(mr, mode, TBUF_SIZE);
  pr_status(ssr, status, TBUF_SIZE);
  fdp = (sock->flags & kInUse) ? pr_fd(sock->fd) : "-------";
  snprintf(sock_str, 256,
      "[%02d] %s F:0x%04x, %s, E:%s|%s, rs:0x%03x, fs:0x%03x - %s\n",
      sock->sock_num, fdp, sock->flags, mode, enabled, pending, rsr, fsr,
      status);
  printf(sock_str);
  if (sock->flags) {
    int flags = sock->flags;
    int i;
    int first = true;
    printf("    ");
    for (i = 0; i < 16; i++) {
      if (flags & (1 << i)) {
        if (!first) {
          printf(",");
        } else {
          first = false;
        }
        printf(" %s", flag_names[i]);
      }
    }
    printf("\n");
  }
}

void dump_pseudo_socket(unsigned int sock_num) {
  char* fdp = pr_fd(sockets[sock_num].fd);
  printf("[%02d] %s F:0x%04x\n", sock_num, fdp, sockets[sock_num].flags);
}

void dump_sockets(void)
{
  int i;
  // Dump the true Wiznet sockets
  for (i=0; i < NUM_WIZ_SOCKETS; i++) {
    dump_socket(&sockets[i]);
  }
  // Dump the pseudo socket flags
  for (i = NUM_WIZ_SOCKETS; i < NUM_SOCKETS; i++) {
    dump_pseudo_socket(i);
  }
}

void become_server(void) {
  struct fssignon device;
  struct systaskinfo info;

  if (verbose > 0) {
    printf("Signing on as server to MM\n"); 
  }

  // Sign on as a server at all offices in the proper order.
  if (svrctl(MMSIGNON, NULL) == -1) { 
    printf("wnet: server signon failed\n"); 
    assert(0); 
  } 
  if (svrctl(SYSSIGNON, &info) == -1) {
    printf("Pausing before SYSSIGNON\n");
    pause(); 
  }

  /* Our new identity as a server. */ 
  wnet_proc_nr = info.proc_nr; 
  /* Register the device group. */ 
  device.dev= ip_dev;
  device.style= STYLE_CLONE; 
  if (verbose > 0) {
    printf("Registering w/ FS, ip_dev = 0x%04x\n", ip_dev); 
  }
  if (svrctl(FSSIGNON, (void *) &device) == -1) { 
    printf("wnet: error %d on registering ethernet devices\n", 
        errno); 
    pause(); 
  }
  printf("wnet_proc_nr: %d\n", wnet_proc_nr);
}


void service_w5300(void) {
  // Note: only using low 8 bits.
  u8_t interrupt_list = wiz_get16(offsetof(wiznet_t, ir));
  int sock_num;
  uint16_t saved_imr;
  printf("[W]: service_w5300\n"); fflush(stdout);
  while (interrupt_list != 0) {
    printf("[W]: servicing "); fflush(stdout);
    for (sock_num = 0; sock_num < NUM_WIZ_SOCKETS; sock_num++) {
      if (interrupt_list & (1 << sock_num)) {
        printf("%d ", sock_num);
        service_minix_socket(sock_num,
            wiz_get8(offsetof(wiznet_t, socket[sock_num].ir)));
      }
    }
    printf("\n"); fflush(stdout);
    interrupt_list = wiz_get16(offsetof(wiznet_t, ir));
  }
  // Toggle mask to ensure we don't miss.
  // TODO: Disable interrupts while doing doing?
  saved_imr = wiz_get16(offsetof(wiznet_t, imr));
  wiz_set16(offsetof(wiznet_t, imr), 0);
  wiz_set16(offsetof(wiznet_t, imr), saved_imr);
  printf("[W]: service_w5300 complete\n"); fflush(stdout);
}

void pr_reply(int code) {
  switch(code) {
    case SUSPEND: printf("SUSPEND"); break;
    case OK: printf("OK"); break;
    case EINVAL: printf("EINVAL"); break;
    case ENOTCONN: printf("ENOTCONN"); break;
    case EINTR: printf("EINTR"); break;
    default:
                if (code < 0) {
                  printf("%s", strerror(-code));
                } else {
                  printf("%d", code);
                }
  }
}

void wnet_reply(socket_t* sock, message *m, int status) {
  int r;
  sock->reply.m_type = REVIVE;
  sock->reply.REP_PROC_NR = m->PROC_NR;
  sock->reply.REP_STATUS = status;
  sock->reply_dest = m->m_source;
  if (verbose > 0) {
    printf("-reply REVIVE to proc %d w/ ", m->PROC_NR);
    pr_reply(status);
    printf("\n");
  }
  r = send(sock->reply_dest, &sock->reply);
  if (r != OK) {
    if (r == ELOCKED) {
      if (verbose > 0) {
        printf("Deferring reply to %d\n", m->m_source);
      }
      sock->flags |= kNeedsReply;
      pending_reply = true;
    } else {
      printf("ERROR - send failed with 0x%x\n",r);
      assert(0);
    }
  }
}

void copy_from_user(int user_proc, vir_bytes user_addr, vir_bytes tgt_addr,
    size_t len) {
  if (verbose > 1) {
    if (user_proc == FS_PROC_NR) {
      printf("Fetching %u bytes from FS\n", len);
    } else {
      printf("Fetching %u bytes from user proc %u\n", len, user_proc);
    }
  }
  sys_copy(user_proc, D, user_addr, wnet_proc_nr, D, tgt_addr, len);
}
void copy_to_user(vir_bytes src_addr, int user_proc, vir_bytes user_addr,
    size_t len) {
  if (verbose > 1) {
    if (user_proc == FS_PROC_NR) {
      printf("Pushing %u bytes to FS\n", len);
    } else {
      printf("Pushing %u bytes to user proc %u\n", len, user_proc);
    }
  }
  sys_copy(wnet_proc_nr, D, src_addr, user_proc, D, user_addr, len);
}

void set_handlers(int sock_num, int protocol, callback_t h_open,
    callback_t h_close, callback_t h_read, callback_t h_write,
    callback_t h_ioctl, callback_t h_cancel) {
  socket_t* sock = &sockets[sock_num];
  sock->flags = kEmpty;
  sock->sock_num = sock_num;
  sock->protocol = protocol;
  sock->open_handler = h_open;
  sock->close_handler = h_close;
  sock->read_handler = h_read;
  sock->write_handler = h_write;
  sock->ioctl_handler = h_ioctl;
  sock->cancel_handler = h_cancel;
}

void missing_handler(socket_t* sock, message* m, char* msg) {
  printf("Missing %s handler for fd %s\n", msg, pr_fd(sock->fd));
  wnet_reply(sock, m, ENODEV);
}

void missing_open_handler(socket_t* sock, message* m) {
  missing_handler(sock, m, "open");
}
void missing_close_handler(socket_t* sock, message* m) {
  missing_handler(sock, m, "close");
}
void missing_read_handler(socket_t* sock, message* m) {
  missing_handler(sock, m, "read");
}
void missing_write_handler(socket_t* sock, message* m) {
  missing_handler(sock, m, "write");
}
void missing_ioctl_handler(socket_t* sock, message* m) {
  missing_handler(sock, m, "ioctl");
}
void missing_cancel_handler(socket_t* sock, message* m) {
  missing_handler(sock, m, "cancel");
}
void missing_callback_handler(socket_t* sock, message* m) {
  missing_handler(sock, m, "callback");
}

int next_socket = 0;
static int next_fd = 1;

int find_free_socket(int master) {
  int i;
  bool_t unused_socket = false;
  assert(sockets[master].flags & kMasterSocket);
  if (master >= WIZ_PS_DEV_OFF) {
    for (i = WIZ_PS_DEV_OFF; i < NUM_SOCKETS; i++) {
      if (!(sockets[i].flags & kInUse)) {
        sockets[i] = sockets[master];
        // And now, correct the overwritten parts.
        sockets[i].sock_num = i;
        sockets[i].flags = kInUse;
        sockets[i].fd = i;
        return i;
      }
    }
    return ENFILE;
  }
  for (i=0; i < NUM_WIZ_SOCKETS; i++) {
    unsigned int wsock;
    next_socket++;
    if (next_socket > NUM_WIZ_SOCKETS) {
      next_socket = 0;
    }
    wsock = sockets[next_socket].wsock;
    if (!(sockets[next_socket].flags & kInUse)) {
      (void)next_fd;
      unused_socket = true;
      // Disable temporarily to test debug reset.
      if (get_ssr(sockets[next_socket].wsock) != WIZ_STATUS_CLOSED) {
        char buf[20];
        if (verbose > 0) {
          pr_status(get_ssr(wsock), buf, 20);
          printf("FFS: socket %d has status %s\n", next_socket, buf);
        }
        (void)close_socket(next_socket);
        if (verbose > 0) {
          pr_status(get_ssr(wsock), buf, 20);
          printf("Status after close is %s\n", buf);
        }
        if (get_ssr(wsock) != WIZ_STATUS_CLOSED) {
          force_udp_reset(wsock);
          if (verbose > 0) {
            pr_status(get_ssr(wsock), buf, 20);
            printf("Status after UDP force close is %s\n", buf);
          }
        }
        init_socket(next_socket);
      }
      if (get_ssr(sockets[next_socket].wsock) == WIZ_STATUS_CLOSED) {
        // Copy everything
        sockets[next_socket] = sockets[master];
        // And now, correct the overwritten parts.
        sockets[next_socket].sock_num = next_socket;
        sockets[next_socket].wsock = offsetof(wiznet_t, socket[next_socket]);
        sockets[next_socket].flags = kInUse;
        sockets[next_socket].fd = next_socket;
        return next_socket;
      }
    }
  }
  return unused_socket ? EAGAIN : ENFILE;
}

int allocate_socket(int master) {
  int r;
  if (!(sockets[master].flags & kMasterSocket)) {
    if (verbose) {
      printf("Not the master socket: %d\n", master);
    }
    return EINVAL;
  }
  r = find_free_socket(master);
  if ((r < 0) && (verbose > 0)) {
    printf("out of sockets\n");
  } else if (verbose > 0) {
    printf("allocated fd %s\n", pr_fd(r));
  }
  return r;
}

void force_udp_reset(unsigned int wsock) {
  ipv4_t destip;
  int deadman;
  // Clear out possible pending SENDOK interrupt.
  set_ir(wsock, WIZ_INT_SENDOK);
  destip.u.bytes[0] = 0;
  destip.u.bytes[1] = 0;
  destip.u.bytes[2] = 0;
  destip.u.bytes[3] = 1;
  set_mr(wsock, WIZ_MODE_UDP);
  set_portr(wsock, 0x3000);
  set_cr_check(wsock, WIZ_CMD_OPEN, WIZ_STATUS_UDP);
  milli_delay(100);
  set_dipr(wsock, destip);
  set_dportr(wsock, 0x3000);
  // Write some dummy data
  set_tx_fifor(wsock, 0x2020);
  milli_delay(10);
  set_tx_wrsr(wsock, 1);
  milli_delay(10);
  (void)set_cr_check(wsock, WIZ_CMD_SEND, WIZ_STATUS_DONT_CARE);
  // Busy-wait for send_ok
  deadman = 0;
  while (!(get_ir(wsock) & WIZ_INT_SENDOK)) {
    if (get_ssr(wsock) == WIZ_STATUS_CLOSED) {
      break;
    }
    milli_delay(10);
    if (get_ir(wsock) & WIZ_INT_TIMEOUT) {
      break;
    }
    if (deadman++ > 100) {
      break;  // No SENDOK - just continue anyway.
    }
  }
  if (get_ir(wsock) & WIZ_INT_SENDOK) {
  }
  // Clear out any old interrupts.
  set_ir(wsock, ALL_SOCKET_INTERRUPTS);
  // Close (redundant - but want to print status)
  set_cr_check(wsock, WIZ_CMD_CLOSE, WIZ_STATUS_CLOSED);
}

int close_socket(int sock_num) {
  socket_t* sock = &sockets[sock_num];
  unsigned int wsock = sock->wsock;
  u32_t tx_max = 8 * 1024;
  if (get_rx_rsr(wsock) > 0) {
    while (get_rx_rsr(wsock) > 0) {
      // Read out unused garbage
      u16_t junk = get_rx_fifor(wsock);
    }
    (void)set_cr_check(wsock, WIZ_CMD_RECV, WIZ_STATUS_DONT_CARE);
  }
  if (((get_mr(wsock) & 0x0f) == WIZ_MODE_TCP) &&
      (get_tx_fsr(wsock) != tx_max)) {
    u16_t loop_cnt = 0;
    while (get_tx_fsr(wsock) != tx_max) {
      if (loop_cnt++ > 50) {
        force_udp_reset(wsock);
        break;
      }
      milli_delay(10);
    }
  }
  set_ir(wsock, ALL_SOCKET_INTERRUPTS);   // Clear out any waiting interrupts.
  return set_cr_check(wsock, WIZ_CMD_CLOSE, WIZ_STATUS_CLOSED);
}

void free_socket(int sock_num) {
  int status;
  unsigned int wsock = sockets[sock_num].wsock;
  assert(sock_num < NUM_WIZ_SOCKETS);
  assert(sockets[sock_num].flags & kInUse);
  status = get_ssr(wsock);
  switch(status) {
    case WIZ_STATUS_CLOSED:
      break;   // Nothing to do.
    case WIZ_STATUS_ESTABLISHED:  // tcp client
      (void)set_cr_check(wsock, WIZ_CMD_DISCON, WIZ_STATUS_DONT_CARE);
      milli_delay(200);
      (void)close_socket(sock_num);
      break;
    default:                  // anything else
      (void)close_socket(sock_num);
  }
  init_socket(sock_num);
}

void init_socket(int sock_num) {
  socket_t* sock = &sockets[sock_num];
  if (verbose > 0) {
    printf("Initializing socket %s\n", sock_num);
  }
  sock->flags = kEmpty;
  sock->sock_num = sock_num;
  sock->protocol = WIZ_MODE_INVALID;
  sock->open_handler = missing_open_handler;
  sock->close_handler = missing_close_handler;
  sock->read_handler = missing_read_handler;
  sock->write_handler = missing_write_handler;
  sock->ioctl_handler = missing_ioctl_handler;
  sock->cancel_handler = missing_cancel_handler;
  sock->callback_handler = missing_callback_handler;
  sock->portr = 0;
  sock->dportr = 0;
  sock->dipr.u.raw = 0UL;
  sock->loopback_data = NULL;
  sock->loopback_data_size = 0;
  sock->fd = -1;
  sock->linked_socket = NO_SOCKET;
  if (sock_num < NUM_WIZ_SOCKETS) {
    unsigned int wsock = offsetof(wiznet_t, socket[sock_num]);
    set_imr(wsock, DISABLE_INTERRUPTS);
    set_mr(wsock, 0);
    sock->wsock = wsock;
  } else {
    sock->wsock = 0xdead;
  }
}

void sanity_check_sockets(void) {
  int i;
  for (i = 0; i < NUM_SOCKETS; i++) {
    if (i < NUM_WIZ_SOCKETS) {
      assert(sockets[i].wsock = offsetof(wiznet_t, socket[i]));
      assert(sockets[i].sock_num == i);
    } else {
      assert(sockets[i].wsock == 0xdead);
    }
  }
}

void init_protocols(void) {
  int i;
  // Initialize the socket array
  for (i=0; i < NUM_SOCKETS; i++) {
    init_socket(i);
  } 
  // Debug pseudo-socket.
  set_handlers(WIZ_DEBUG_DEV_OFF, WIZ_MODE_DEBUG, debug_open, debug_close,
      debug_read, debug_write, debug_ioctl, debug_cancel);
  sockets[WIZ_DEBUG_DEV_OFF].flags = (kInUse | kMasterSocket | kPseudoSocket);
  sockets[WIZ_DEBUG_DEV_OFF].fd = WIZ_DEBUG_DEV_OFF;
  // IP master socket
  set_handlers(WIZ_IP_DEV_OFF, WIZ_MODE_IPRAW, ip_open, ip_close,
      ip_read, ip_write, ip_ioctl, ip_cancel);
  sockets[WIZ_IP_DEV_OFF].flags = (kInUse | kMasterSocket);
  sockets[WIZ_IP_DEV_OFF].fd = WIZ_IP_DEV_OFF;
  // TCP master socket
  set_handlers(WIZ_TCP_DEV_OFF, WIZ_MODE_TCP, tcp_open, tcp_close,
      tcp_read, tcp_write, tcp_ioctl, tcp_cancel);
  sockets[WIZ_TCP_DEV_OFF].flags = (kInUse | kMasterSocket);
  sockets[WIZ_TCP_DEV_OFF].fd = WIZ_TCP_DEV_OFF;
  // UDP master socket
  set_handlers(WIZ_UDP_DEV_OFF, WIZ_MODE_UDP, udp_open, udp_close,
      udp_read, udp_write, udp_ioctl, udp_cancel);
  sockets[WIZ_UDP_DEV_OFF].flags = (kInUse | kMasterSocket);
  sockets[WIZ_UDP_DEV_OFF].fd = WIZ_UDP_DEV_OFF;
  // PS master socket
  set_handlers(WIZ_PS_DEV_OFF, WIZ_MODE_PS, procfs_open, procfs_close,
      procfs_read, procfs_write, procfs_ioctl, procfs_cancel);
  sockets[WIZ_PS_DEV_OFF].flags = (kInUse | kMasterSocket);
  sockets[WIZ_PS_DEV_OFF].fd = WIZ_PS_DEV_OFF;
  // PS master socket
  set_handlers(WIZ_FINGER_DEV_OFF, WIZ_MODE_FINGER, procfs_open, procfs_close,
      procfs_read, procfs_write, procfs_ioctl, procfs_cancel);
  sockets[WIZ_FINGER_DEV_OFF].flags = (kInUse | kMasterSocket);
  sockets[WIZ_FINGER_DEV_OFF].fd = WIZ_FINGER_DEV_OFF;

  // Handle special IP fields
  memset(&sockets[WIZ_IP_DEV_OFF].ip_opt, 0, sizeof(nwio_ipopt_t));
  sockets[WIZ_IP_DEV_OFF].ip_opt.nwio_flags =
    (NWIO_EN_LOC | NWIO_EN_BROAD | NWIO_REMANY | NWIO_RWDATALL |
     NWIO_HDR_O_SPEC);
  sockets[WIZ_IP_DEV_OFF].ip_opt.nwio_tos = 0;
  sockets[WIZ_IP_DEV_OFF].ip_opt.nwio_df = false;
  sockets[WIZ_IP_DEV_OFF].ip_opt.nwio_ttl = 255;
  sockets[WIZ_IP_DEV_OFF].ip_opt.nwio_hdropt.iho_opt_siz = 0;
  memset(&sockets[WIZ_IP_DEV_OFF].ip_conf, 0, sizeof(nwio_ipconf_t));

  // Handle special UDP fields
  memset(&sockets[WIZ_UDP_DEV_OFF].udp_opt, 0, sizeof(nwio_udpopt_t));

  // Handle special TCP fields
  memset(&sockets[WIZ_TCP_DEV_OFF].tcp_conf, 0, sizeof(nwio_tcpconf_t));
  sockets[WIZ_TCP_DEV_OFF].tcp_conf.nwtc_flags =
    (NWTC_COPY | NWTC_LP_UNSET | NWTC_UNSET_RA | NWTC_UNSET_RP);
  memset(&sockets[WIZ_TCP_DEV_OFF].tcp_opt, 0, sizeof(nwio_tcpopt_t));
}


// FIXME - device and file_descriptor are now the same.
void fs_rec(message* m) {
  int file_descriptor = m->DEVICE;
  int device = file_descriptor;
  socket_t* sock;
  sock = &sockets[device];
  if ((device < 0) || (device >= NUM_SOCKETS)) {
    wnet_reply(sock, m, EINVAL);
    return;
  }
  if (pending_reply) {
    if (verbose > 0) {
      printf("Resending deferred messages\n");
    }
    add_trace(device, TRACE_KIND_TCP, TRACE_RESEND_MESSAGE, m->m_type,
        (uint32_t)m->PROC_NR);
    if (m->m_type == NW_CANCEL) {
      resend_messages(m->PROC_NR);
    } else {
      resend_messages(ANY);
    }
    pending_reply = false;
  }

  // Make sure physical socket is properly owned by this request.
  if ((device < NUM_WIZ_SOCKETS) && (m->m_type != DEV_OPEN)) {
    if ((!(sockets[device].flags & kInUse)) || 
        (sockets[device].fd != file_descriptor)) {
      if (verbose > 0) {
        printf("Device %d, fd mismatch, curr: 0x%x, existing: 0x%x\n",
            device, sockets[device].fd, file_descriptor);
        printf("In use: ", kInUse ? "true" : "false");
        printf(".  Replied ECONNRESET\n");
      }
      wnet_reply(sock, m, ECONNRESET);
      return;
    }
  }

  if (m->m_type != DEV_IOCTL) {
    // IOCTL trace records will be added in tcp_ioctl
    add_trace(device, TRACE_KIND_TCP, TRACE_IO_COMMAND, m->m_type,
        (uint32_t)m->PROC_NR);
  }
  switch(m->m_type) {
    case DEV_OPEN:
      (*sockets[device].open_handler)(sock, m);
      break;
    case DEV_CLOSE:
      (*sockets[device].close_handler)(sock, m);
      break;
    case DEV_READ:
      (*sockets[device].read_handler)(sock, m);
      break;
    case DEV_WRITE:
      (*sockets[device].write_handler)(sock, m);
      break;
    case DEV_IOCTL:
      (*sockets[device].ioctl_handler)(sock, m);
      break;
    case CANCEL:
      (*sockets[device].cancel_handler)(sock, m);
      break;
    default:
      assert(0);
  }
}

// Get a unique local socket in the range 0xc000 .. 0xffff.
uint16_t next_local_port = 0xc000;
uint16_t get_next_local_port() {
  bool_t duplicate = true;
  uint16_t r;
  while (duplicate) {
    int i;
    r = (next_local_port++) | 0xc000;
    // Assume we're unique.
    duplicate = false;
    for (i = 0; i < NUM_WIZ_SOCKETS; i++) {
      if (sockets[i].flags & kInUse) {
        unsigned int wsock = offsetof(wiznet_t, socket[i]);
        if ((r == get_portr(wsock)) || (r == get_dportr(wsock))) {
          // Oops - not unique.  Try again.
          duplicate = true;
        }
      }
    }
  }
  if (verbose) {
    printf("Selected locport number %u/0x%04x\n", r, r);
  }
  return r;
}

void resend_messages(int proc) {
  int cancel_m = -1;
  int i;
  for (i = 0; i < NUM_SOCKETS; i++) {
    if (sockets[i].flags & kNeedsReply) {
      if (sockets[i].reply.REP_PROC_NR == proc) {
        cancel_m = i;
      } else {
        int r;
        r = send(sockets[i].reply_dest, &sockets[i].reply);
        if (verbose > 0) {
          printf("Re-sent message %d, response = %d\n", i, r);
        }
        assert(r == OK);
      }
      sockets[i].flags &= ~kNeedsReply;
    }
  }
  if (cancel_m != -1) {
    int r;
    printf("c: %d:%d\n", sockets[cancel_m].reply_dest, sockets[cancel_m].reply.m_type);
    r = send(sockets[cancel_m].reply_dest, &sockets[cancel_m].reply);
    if (1 || verbose > 0) {
      printf("Re-sent cancelled message %d, response = %d\n", cancel_m, r);
    }
    assert(r == OK);
  }
}

void test_timeout(int conn, timer_t* tim) {
  (void)tim;
  add_trace(TRACE_SOCKET_NUM_GLOBAL, TRACE_KIND_CLCK, TRACE_TIMER_TEST, 0, 0);
  if (verbose) {
    printf("Timeout handler, connection = %d\n", conn);
  }
}

timer_t test_timer;
int test_conn = 0;

int main(int argc, char** argv) {
  setbuf(stdout, NULL);
  if (argc > 1) {
    verbose = atoi(argv[1]);
  }
  validate_sizes();
  create_devices();
  wiznet_base = (uint8_t*)remap_dev_page(WIZNET_PHYS_ADDR,
#if 0
      true /* fast */
#else
      false /* (not) fast */
#endif
      );
  wiz_mr = (mr_t*)&wiznet_base[0];
  wiz_ar = (uint16_t*)&wiznet_base[2];
  wiz_dr = (uint16_t*)&wiznet_base[4];
  wiz_dr1 = &wiznet_base[5];
  wiz_dr0 = &wiznet_base[4];
  printf("Wiznet device mapped to 0x%04x\n",(uint16_t)wiznet_base);
  printf("Converting to server\n");
  printf("dipr: 0x%x = 0x%x\n", dipr_offset, (uint16_t)offsetof(w_socket_t, dipr));
  printf("dportr: 0x%x = 0x%x\n", dportr_offset, (uint16_t)offsetof(w_socket_t, dportr));
  printf("portr: 0x%x = 0x%x\n", portr_offset, (uint16_t)offsetof(w_socket_t, portr));
  fflush(stdout);
  printf("Becoming server\n"); fflush(stdout);
  become_server();
  printf("Became server\n"); fflush(stdout);
  init_w5300();
  if (verbose > 0) {
    printf("Became server\n");
  }
  init_protocols();
  if (verbose > 0) {
    printf("Initialized protocols\n");
  }
  if (sys_findproc("SYN_AL", &synal_tasknr, 0) != OK) {
    printf("Failed to find SYN_AL\n");
  }
  assert(SYN_ALRM_TASK == synal_tasknr);
  clck_init();
  if (verbose > 0) {
    printf("Finished clk_init()\n");
  }
  reset_time();

  if (verbose > 0) {
    printf("Entering event loop\n");
  }
  test_timer.tim_active = 0;
  // clck_timer(&test_timer, get_time() + 256, test_timeout, test_conn);
  while(TRUE) {
    int r;
    message mess;
    if (verbose > 0) {
      if (verbose > 1) {
        print_w5300();
      }
      printf("..receive(ANY, &mess);\n");
    }
    if (clck_call_expire) {
      clck_expire_timers();
      test_timer.tim_active = 0;
      // clck_timer(&test_timer, get_time() + 6400, test_timeout, test_conn++);
    }
    r = receive(ANY, &mess);
    sanity_check_sockets();
    reset_time();
    if (trace || (verbose > 0)) {
      printf("M %s from %s", pr_type(mess.m_type),
          pr_source(mess.m_source));
      if (mess.m_source == CLOCK) {
        int i;
        int count = 0;
        ir_t ints;
        ints.u.raw = wiz_get16(offsetof(wiznet_t, ir));
        for (i = 0; i < 16; i++) {
          if ((1 << i) & ints.u.raw) {
            count++;
          }
        }
        if (count == 1) {
          printf(", socket:");
        } else {
          printf(", sockets:");
        }
        for (i = 0; i < 16; i++) {
          if ((1 << i) & ints.u.raw) {
            unsigned int sock_int = wiz_get8(offsetof(wiznet_t, socket[i].ir));
            int first = true;
            printf(" %d [", i);
            if (sock_int & WIZ_INT_SENDOK) {
              first = false;
              printf("SENDOK");
            }
            if (sock_int & WIZ_INT_CON) {
              if (!first) {printf(" ");}
              first = false;
              printf("CON");
            }
            if (sock_int & WIZ_INT_RECV) {
              if (!first) {printf(" ");}
              first = false;
              printf("RECV");
            }
            if (sock_int & WIZ_INT_DISCON) {
              if (!first) {printf(" ");}
              first = false;
              printf("DISCON");
            }
            if (sock_int & WIZ_INT_TIMEOUT) {
              if (!first) {printf(" ");}
              first = false;
              printf("TIMEOUT");
            }
            printf("]");
          }
        }
        printf("\n");
      } else {
        printf(", fd %s", pr_fd(mess.DEVICE));
        if (mess.m_type == DEV_IOCTL) {
          printf(" ");
        } else {
          printf("\n");
        }
      }
    }
    if (r < 0) {
      printf("Unsable to receive: %d\n", r);
      assert(0);
    }
    switch (mess.m_source) {
      case FS_PROC_NR:
        fs_rec(&mess);
        break;
      case SYN_ALRM_TASK:
        clck_tick(&mess);
        break;
      case WIZNET:
#if 0
        printf("Good message: source %d, type %d, WIZNET: %d\n",
            mess.m_source, mess.m_type, WIZNET);
#endif
        printf("[W]: WIZNET interrupt\n"); fflush(stdout);
        service_w5300();
        break;
      default:
        printf("Bad message: source %d, type %d, WIZNET: %d\n",
            mess.m_source, mess.m_type, WIZNET);
        printf("[W]: Unexpected interrupt\n"); fflush(stdout);
        service_w5300();
    }
  }
  printf("WTF: server not allowed to terminate!\n");
  return 0;
}

