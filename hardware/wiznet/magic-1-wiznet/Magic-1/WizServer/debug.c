#include "common.h"

#define HBUF_SIZE 10

traces_t traces;

uint8_t next_trace(uint8_t next) {
  return (next == (TRACE_DEPTH - 1)) ? 0 : (next + 1);
}

uint8_t prev_trace(uint8_t prev) {
  return (prev == 0) ? (TRACE_DEPTH - 1) : (prev - 1);
}

void init_traces() {
  memset(&traces, 0, sizeof(traces_t));
}

void add_trace(uint8_t num, uint8_t kind, uint8_t action, uint8_t source,
    uint32_t payload) {
  uint8_t next;
  trace_t* p;
  // printf("Adding trace socket %d\n", num);
  assert(num <= NUM_SOCKETS);
  next = traces.next[num];
  p = &traces.traces[num][next];
  p->time = get_rtc_time();
  p->socket_num = num;
  p->socket_kind = kind;
  p->action = action;
  p->source = source;
  p->payload = payload;
  traces.next[num] = next_trace(next);
}

char* trace_kind[] = {"NONE", "UDP ", "CLCK", "TCP ", "IPRW"};

void print_trace_clck(trace_t* p) {
  switch(p->action) {
    case TRACE_TIMER_TEST:
      printf("Timer_Test ");
      break;
    default:
      printf("Unknown_action %d ", p->action);
      break;
  }
}

char* io_codes[] = {
  "CANCEL", "1", "HARD_INT", "READ", "WRITE", "IOCTL", "OPEN", "CLOSE"};

char* get_io_code(unsigned mtype) {
  if (mtype <= DEV_CLOSE) {
    return io_codes[mtype];
  } else {
    return "UNKNOWN";
  }
}

char* ioctl_names[] = {
  "NWIOADDHITCOUNT",
  "NWIOGETHITCOUNT",
  "NWIOSTCPCONF",
  "NWIOGTCPCONF",
  "NWIOSTCPOPT",
  "NWIOGTCPOPT",
  "NWIOTCPCONN",
  "NWIOTCPLISTEN",
  "NWIOTCPSHUTDOWN",
  "NWIOTCPCLOSEHOLD"
};

void print_trace_tcp_udp(trace_t* p) {
  char* str;
  char buf[64];
  ipv4_t tmp;
  switch(p->action) {
    case TRACE_INT_SENDOK: printf("SEND_OK "); break;
    case TRACE_INT_CONNECTED:
                           tmp.u.raw = p->payload;
                           str = get_ipv4_str(&tmp);
                           printf("Connected to %s ", str);
                           break;
    case TRACE_INT_RECEIVE: printf("RECEIVE "); break;
    case TRACE_INT_DISCONNECTED:
                            pr_status(p->source, buf, 64);
                            printf("DISCONNECTED, status was %s ", buf);
                            break;
    case TRACE_INT_TIMEOUT: printf("TIMEOUT "); break;
    case TRACE_RESEND_MESSAGE: printf("Resend i/o cmd %s to %d",
                                   get_io_code(p->source),
                                   (int)p->payload);
                               break;
    case TRACE_IO_COMMAND:
                               printf("i/o cmd %s to %d", get_io_code(p->source), (int)p->payload);
                               break;

    case TRACE_NWIOADDHITCOUNT:
    case TRACE_NWIOGETHITCOUNT:
    case TRACE_NWIOSTCPCONF:
    case TRACE_NWIOGTCPCONF:
    case TRACE_NWIOSTCPOPT:
    case TRACE_NWIOGTCPOPT:
    case TRACE_NWIOTCPCONN:
    case TRACE_NWIOTCPLISTEN:
    case TRACE_NWIOTCPSHUTDOWN:
    case TRACE_NWIOTCPCLOSEHOLD:
                               pr_status(p->source, buf, 64);
                               printf("ioctl %s status: %s",
                                   ioctl_names[p->action - TRACE_NWIOADDHITCOUNT],
                                   buf);
                               break;
    case TRACE_WRITE_WSOCKET:
                               printf("write_wsocket %d of %d bytes", (unsigned int)p->payload,
                                   (unsigned int)(p->payload >> 16));
                               break;
    default: printf("Uknown action %d ", p->action);
  }
}

void print_trace(trace_t* p) {
  if (p->socket_kind == TRACE_KIND_NONE) {
    return;
  }
  assert(p->socket_kind <= TRACE_KIND_IPRAW);
  printf("    %s ", trace_kind[p->socket_kind]);
  switch(p->socket_kind) {
    case TRACE_KIND_TCP:
    case TRACE_KIND_UDP:
      print_trace_tcp_udp(p);
      break;
    case TRACE_KIND_CLCK:
      print_trace_clck(p);
      break;
    default:
      printf(" ** UNKNOWN TRACE KIND %d ** ", p->socket_kind);
      break;
  }
  printf(" at %s", ctime(&p->time));
}

void dump_traces(uint8_t socket_num) {
  int i;
  trace_t* p_base;
  uint8_t prev;
  assert(socket_num <= NUM_SOCKETS);
  if (socket_num < NUM_WIZ_SOCKETS) {
    dump_socket(&sockets[socket_num]);
  } else if (socket_num < NUM_SOCKETS) {
    dump_pseudo_socket(socket_num);
  } else {
    printf("GLOBAL Actions\n");
  }
  p_base = &traces.traces[socket_num][0];
  prev = prev_trace(traces.next[socket_num]);
  // printf("Socket %d\n", socket_num);
  for (i = 0; i < TRACE_DEPTH; i++) {
    trace_t* p = &p_base[prev];
    print_trace(p);
    prev = prev_trace(prev);
  }
}


void dump_log(void) {
}

void clear_hung_sockets(void) {
  // TODO: figure out the case we're looking for
  int i;
  int found = false;
  for (i = 0; i < NUM_WIZ_SOCKETS; i++) {
    unsigned int wsock = sockets[i].wsock;
    message saved_message;
    uint16_t saved_flags;
    if (get_ssr(wsock) == 0x11) {
      char buf[20];
      saved_flags = sockets[i].flags;
      if (saved_flags & kSuspForOK) {
        saved_message = sockets[i].pending_write;
      } else {
        saved_message = sockets[i].suspended_message;
      }
      found = true;
      pr_status(get_ssr(wsock), buf, 20);
      printf("Socket[%d] has status %s\n", i, buf);
      force_udp_reset(wsock);
      if (saved_flags & SUSPENDED_MASK) {
        printf("Replying ECONNRESET\n");
        wnet_reply(&sockets[i], &saved_message, ECONNRESET);
      }
      if (get_ssr(wsock) == WIZ_STATUS_CLOSED) {
        printf("UDP reset successful\n");
        init_socket(i);
        continue;
      }
      pr_status(get_ssr(wsock), buf, 20);
      printf("UDP reset failed, final status is %s\n", buf);
    }
  }
  if (!found) {
    printf("No wedged sockets found\n");
  }
}

void force_reset(void) {
  int i;
  printf("Resetting w5300\n");
  for (i = 0; i < NUM_WIZ_SOCKETS; i++) {
    if (sockets[i].flags & kInUse) {
      free_socket(i);
    }
  }
  init_w5300();
}

void debug_help(void) {
  printf("h -> print this message\n");
  printf("0 -> turn off verbose mode\n");
  printf("1 -> turn on verbose mode\n");
  printf("2 -> turn on verbose verbose mode\n");
  printf("3 -> dump w5300\n");
  printf("4 -> reset w5300\n");
  printf("5 -> clear hung sockets\n");
  printf("6 -> toggle log mode\n");
  printf("7 -> dump log\n");
  printf("8 -> toggle spy mode\n");
  printf("9 -> toggle trace mode\n");
  printf("d<sock> -> dump traces for single socket.  For ex: d3\n");
  printf("D -> dump traces for all sockets\n");
}

int handle_debug_settings(message* m) {
  char buf[HBUF_SIZE];
  int newval;
  int saved_verbose = verbose;
  size_t count = m->COUNT;
  if (count > HBUF_SIZE) {
    return EINVAL;
  }
  copy_from_user(m->PROC_NR, (vir_bytes)m->ADDRESS, (vir_bytes)buf, count);
  if (buf[0] == 'h') {
    debug_help();
    return count;
  }
  if (buf[0] == 'D') {
    int i;
    for (i = 0; i <= NUM_SOCKETS; i++) {
      dump_traces(i);
    }
    return count;
  }
  if (buf[0] == 'd') {
    dump_traces(atoi(buf+1));
    return count;
  }
  newval = atoi(buf);
  switch (newval) {
    case 3:
      // one-shot socket dump
      verbose = 1;
      print_w5300();
      verbose = saved_verbose;
      break;
    case 4:
      force_reset();
      break;
    case 5:
      clear_hung_sockets();
      break;
    case 6:
      log = !log;
      break;
    case 7:
      dump_log();
      break;
    case 8:
      spy = !spy;
      printf("Spy mode = %s\n", spy ? "on" : "off");
      break;
    case 9:
      trace = !trace;
      printf("Trace mode = %s\n", trace ? "on" : "off");
      break;
    default:
      verbose = newval;
      printf("Verbose mode = %d\n", verbose);
  }
  return count;
}

void init_debug(int sock_num) {
  (void)sock_num;
  if (verbose > 0) { printf("init_debug\n"); }
}

void debug_open(socket_t* sock, message* m) {
  // We don't copy into a new slot for the debug port.
  if (verbose > 0) {
    printf("debug_open uses master fd %s\n", pr_fd(sock->fd));
  }
  wnet_reply(sock, m, WIZ_DEBUG_DEV_OFF);
}

void debug_close(socket_t* sock, message* m) {
  (void)sock;
  if (verbose > 0) { printf("debug_close\n"); }
  wnet_reply(sock, m, OK);
}

bool_t first_read = true;
void debug_read(socket_t* sock, message* m) {
  int len;
  if (verbose > 0) {
    printf("debug_read from fd %s\n", pr_fd(sock->fd));
  }
  if (first_read) {
    char buf[32];
    snprintf(buf, 32, "Verbose: %d\n", verbose);
    len = strlen(buf) + 1;
    copy_to_user((vir_bytes)&buf, m->PROC_NR, (vir_bytes)m->ADDRESS, len);
    first_read = false;
  } else {
    first_read = true;
    len = 0;
  }
  wnet_reply(sock, m, len);
}

void debug_write(socket_t* sock, message* m) {
  int r;
  (void)sock;
  if (verbose > 0) { printf("debug_write\n"); }
  r = handle_debug_settings(m);
  if (verbose > 1) {
    print_w5300();
  }
  wnet_reply(sock, m, r);
}

void debug_ioctl(socket_t* sock, message* m) {
  (void)sock;
  if (trace || (verbose > 0)) { printf("debug_ioctl\n"); }
  wnet_reply(sock, m, EINVAL);
}

void debug_cancel(socket_t* sock, message* m) {
  (void)sock;
  if (verbose > 0) { printf("debug_cancel\n"); }
  first_read = true;
  wnet_reply(sock, m, OK);
}

void debug_interrupt(int sock_num, uint8_t ir) {
  printf("debug interrupt handler for sock %s, ir 0x%02x\n",
      pr_fd(sock_num), ir);
  assert(0);
}

