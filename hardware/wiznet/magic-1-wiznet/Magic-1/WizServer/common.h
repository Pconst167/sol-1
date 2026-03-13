#ifndef COMMON_H
#define COMMON_H

#define _SYSTEM	1	/* get OK and negative error codes */
#define _MINIX 1

#include <ansi.h>
#include <sys/types.h>
#include <errno.h>
#include <stddef.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/svrctl.h>
#include <minix/config.h>
#include <minix/type.h>
#include <minix/const.h>
#include <minix/com.h>
#include <minix/syslib.h>
#include <minix/callnr.h>
// #include <net/hton.h>
// #include <net/gen/ether.h>
// #include <net/gen/eth_hdr.h>
// #include <net/gen/eth_io.h>
#include <net/gen/in.h>
#include <net/gen/ip_hdr.h>
#include <net/gen/ip_io.h>
#include <net/gen/icmp.h>
#include <net/gen/icmp_hdr.h>
// #include <net/gen/oneCsum.h>
#include <net/gen/psip_hdr.h>
#include <net/gen/psip_io.h>
#include <net/gen/route.h>
#include <net/gen/tcp.h>
#include <net/gen/tcp_hdr.h>
#include <net/gen/tcp_io.h>
#include <net/gen/udp.h>
#include <net/gen/udp_hdr.h>
#include <net/gen/udp_io.h>
#include <net/ioctl.h>
#include <stdio.h>
#include <magic1.h>
#include <time.h>

#define TBUF_SIZE 40

#define PROC_DEVICE 128

typedef unsigned char uint8_t;
typedef unsigned short uint16_t;
typedef unsigned long uint32_t;

int sprintf(char* str, const char* format, ...);
void bad_assertion(char* expr, char* file, int line);
#define	assert(expr)	((expr)? (void)0 : \
    bad_assertion( #expr, __FILE__ , __LINE__))

#define HIGH_WORD(x) (*(((unsigned short*)&x)+0))
#define LOW_WORD(x) (*(((unsigned short*)&x)+1))

#define min(x,y) ((x < y) ? x : y)
#define max(x,y) ((x > y) ? x : y)

#define INVALID_FD 0xff

#define NUM_WIZ_SOCKETS 8
#define NUM_SOCKETS 20 
#define NO_SOCKET (-1)

#define true 1
#define false 0

#define PROTCOL_ICMP 1
#define PROTOCOL_IGMP 2
#define PROTOCOL_TCP 6
#define PROTOCOL_UDP 17


typedef int ioreq_t;
typedef char bool_t;

typedef struct ipv4_t {
  union {
    uint8_t  bytes[4];
    uint32_t raw;
  } u;
} ipv4_t;

// Global Wiznet 5300 flags
typedef enum wiznet_flags_t {
  kBlank        = 0x0000,
  kIPAddrSet    = 0x0001,
  kGatewaySet   = 0x0002,
  kNetmaskSet   = 0x0004,
  kReadyToUse   = 0x0008      // IP, netmask & gateway set
} wiznet_flags_t;

// Per-socket flags
#define kEmpty        0x0000U
#define kInUse        0x0001U
#define kPseudoSocket 0x0002U
#define kRemAddrSet   0x0004U    // May not need?
#define kRemPortSet   0x0008U    // May not need?
#define kLocPortSet   0x0010U    // May not need?
#define kLocAddrSet   0x0020U    // May not need?
#define kNetMaskset   0x0040U
#define kMasterSocket 0x0080U    // Is this the template ip, tcp or udp socket?
#define kNeedsReply   0x0100U    // Send deferred reply
#define kSuspForIoctl 0x0200U    // Suspended, awaiting IP/netmask setup.
#define kSuspForConn  0x0400U    // Suspended, awaiting TCP connection.
#define kSuspForData  0x0800U    // Suspended, awaiting arrival of data packet.
#define kSuspForRead  0x1000U    // Writer suspended, awaiting read completion.
#define kSuspForOK    0x2000U    // Suspended, awaiting successful write
#define kEOF          0x4000U    // Socket at end of file
#define kConfSet      0x8000U
#if 0
// Suspend flags from Minix inet.  Probably won't use?
// kTCPRecvUrg   = 0x4000,    // Probably won't use this
// kTCPSendUrg   = 0x4000     // Probably won't use this
// kTCPDelRst    = 0x8000,    // Probably won't use this
#endif

#define SUSPENDED_MASK (kSuspForIoctl | kSuspForConn \
    | kSuspForData | kSuspForRead | kSuspForOK)

struct timer;

typedef void (*timer_func_t)(int fd, struct timer *timer);

typedef struct timer
{
  struct timer *tim_next;
  timer_func_t tim_func;
  int tim_ref;
  time_t tim_time;
  int tim_active;
} timer_t;


typedef struct socket_t {
  uint16_t flags;
  int sock_num;    // For convenience
  int protocol;    // Which protocol is this socket using?
  void (*open_handler)(struct socket_t* sock, message* m);
  void (*close_handler)(struct socket_t* sock, message* m);
  void (*read_handler)(struct socket_t* sock, message* m);
  void (*write_handler)(struct socket_t* sock, message* m);
  void (*ioctl_handler)(struct socket_t* sock, message* m);
  void (*cancel_handler)(struct socket_t* sock, message* m);
  void (*callback_handler)(struct socket_t* sock, message* m);
  unsigned int wsock;
  message suspended_message;
  message reply;
  message pending_write;
  int reply_dest;
  // TODO: set these in a union
  nwio_tcpconf_t tcp_conf;
  nwio_tcpopt_t tcp_opt;
  nwio_udpopt_t udp_opt;
  nwio_ipopt_t ip_opt;
  nwio_ipconf_t ip_conf;
  uint16_t unread_bytes;   // # of unread bytes in socket's rx buffer
  uint16_t written_bytes;  // Used during write. Compare with message->count.
  bool_t leftover_byte;    // is 1st unread byte in following field?
  char ch;                 // odd byte from 2nd half of last 16-bit read.
  uint16_t portr;
  uint16_t dportr;
  ipv4_t dipr;
  uint8_t* loopback_data;
  uint16_t loopback_data_size;
  int fd;            // Associated fd
  timer_t timer;
  int linked_socket;
} socket_t;

// Handler templates (must match above)
typedef void (*callback_t)(struct socket_t* sock, message* m);

#define WIZ_DEBUG_DEV_OFF 8
#define WIZ_IP_DEV_OFF 9
#define WIZ_TCP_DEV_OFF 10
#define WIZ_UDP_DEV_OFF 11
#define WIZ_PS_DEV_OFF 12
#define WIZ_FINGER_DEV_OFF 13
#define FIRST_PROCFS_SOCKET 14

#define WIZNET_PHYS_ADDR ((phys_bytes)0x00FF90L)

#define WIZ_CMD_OPEN      0x01
#define WIZ_CMD_LISTEN    0x02
#define WIZ_CMD_CONNECT   0x04
#define WIZ_CMD_DISCON    0x08
#define WIZ_CMD_CLOSE     0x10
#define WIZ_CMD_SEND      0x20
#define WIZ_CMD_SEND_MAC  0x21
#define WIZ_CMD_SEND_KEEP 0x22
#define WIZ_CMD_RECV      0x40

#define WIZ_STATUS_CLOSED      0x00
#define WIZ_STATUS_ARP         0x01
#define WIZ_STATUS_INIT        0x13
#define WIZ_STATUS_LISTEN      0x14
#define WIZ_STATUS_SYNSENT     0x15
#define WIZ_STATUS_SYNRECV     0x16
#define WIZ_STATUS_ESTABLISHED 0x17
#define WIZ_STATUS_FIN_WAIT    0x18
#define WIZ_STATUS_TIME_WAIT   0x1B
#define WIZ_STATUS_CLOSE_WAIT  0x1C
#define WIZ_STATUS_LAST_ACK    0x1D
#define WIZ_STATUS_UDP         0x22
#define WIZ_STATUS_IPRAW       0x32
#define WIZ_STATUS_MACRAW      0x42
#define WIZ_STATUS_PPPoE       0x5F
#define WIZ_STATUS_DONT_CARE   0xfe
#define WIZ_INVALID_STATUS     0xff

#define WIZ_INT_CON     0x01
#define WIZ_INT_DISCON  0x02
#define WIZ_INT_RECV    0x04
#define WIZ_INT_TIMEOUT 0x08
#define WIZ_INT_SENDOK  0x10

#define WIZ_MODE_TCP   1
#define WIZ_MODE_UDP   2
#define WIZ_MODE_IPRAW 3
#define WIZ_MODE_MACRAW 4
#define WIZ_MODE_PPPoE 5
#define WIZ_MODE_INVALID 0xff
#define WIZ_MODE_DEBUG 0xfe
#define WIZ_MODE_PS 0xfd
#define WIZ_MODE_FINGER 0xfc

#define TCP_INT_MASK (WIZ_INT_CON | WIZ_INT_DISCON | WIZ_INT_SENDOK | \
    WIZ_INT_RECV | WIZ_INT_TIMEOUT)
#define IP_INT_MASK (WIZ_INT_RECV | WIZ_INT_TIMEOUT | WIZ_INT_SENDOK)
#define UDP_INT_MASK (WIZ_INT_RECV | WIZ_INT_TIMEOUT | WIZ_INT_SENDOK)
#define DISABLE_INTERRUPTS 0x00
#define ALL_SOCKET_INTERRUPTS 0xff


typedef struct mr_reg_t {
  unsigned dbw:1;           // Data bus width (set at reset)
  unsigned mpf:1;           // Mac Layer pause frame (0-normal, 1-pause)
  unsigned wdf:3;           // Write data fetch time (wait states?)
  unsigned rdh:1;           // Read data hold time (0-none, 1-2X pll_clk)
  unsigned reserved0:1;
  unsigned fs:1;            // FIFO swap (0-disable)
  unsigned rst:1;           // Reset (auto clears)
  unsigned reserved1:1;
  unsigned mt:1;            // Memory test (0-disable, 1-enable)
  unsigned pb:1;            // Ping block (0-disable, 1-enable block)
  unsigned pppoe:1;         // PPPoE Mode (0-disable, 1-enable)
  unsigned dbs:1;           // Data Bus Swap (0-disable, 1-enable)
  unsigned reserved2:1;
  unsigned ind:1;           // Indirect addressing mode (0-disable, 1-enable)
} mr_reg_t;

typedef struct mr_t {
  union {
    uint16_t raw;
    mr_reg_t reg;
  } u;
} mr_t;

/*
 * /INT kept low until all bits of IR becomes 0.  To clear
 * a bit, write a "1" to it.  [Check] the documentation suggests
 * that an sX_int bit is auto cleared when all bits of related
 * sX_ir are cleared.
 */
typedef struct ir_reg_t {
  unsigned IPCF:1;         // IP conflict
  unsigned DPUR:1;         // Destination port unreachable
  unsigned PPPT:1;         // PPPoe Terminate
  unsigned FMTU:1;         // Fragment MTU (see FMTUR)
  unsigned reserved:4;
  unsigned s7_int:1;       // Socket 7 interrupt
  unsigned s6_int:1;       // Socket 6 interrupt
  unsigned s5_int:1;       // Socket 5 interrupt
  unsigned s4_int:1;       // Socket 4 interrupt
  unsigned s3_int:1;       // Socket 3 interrupt
  unsigned s2_int:1;       // Socket 2 interrupt
  unsigned s1_int:1;       // Socket 1 interrupt
  unsigned s0_int:1;       // Socket 0 interrupt
} ir_reg_t;

typedef struct ir_t {
  union {
    uint16_t raw;
    ir_reg_t reg;
  } u;
} ir_t;

typedef struct brdy_t {
  uint16_t  brdyr;          // Pin BRDYx Configure Register
  uint16_t  bdpthr;         // Pin BRDYx Buffer Depth Register
} brdy_t;

#define mr_offset 0x0
#define cr_offset 0x3
#define imr_offset 0x5
#define ir_offset 0x7
#define ssr_offset 0x9
#define portr_offset 0xa
#define dhar_offset 0xc
#define dportr_offset 0x12
#define dipr_offset 0x14
#define mssr_offset 0x18
#define kpalvtr_offset 0x1a
#define protor_offset 0x1b
#define tosr_offset 0x1c
#define ttlr_offset 0x1e
#define tx_wrsr_offset 0x20
#define tx_fsr_offset 0x24
#define rx_rsr_offset 0x28
#define fragr_offset 0x2d
#define tx_fifor_offset 0x2e
#define rx_fifor_offset 0x30

typedef struct w_socket_t {
  uint16_t  mr;             // mode register
  uint8_t   rsv0;           // ..reserved
  uint8_t   cr;             // command register
  uint8_t   rsv1;           // ..reserved
  uint8_t   imr;            // interrupt mask register
  uint8_t   rsv2;           // ..reserved
  uint8_t   ir;             // iterrupt register
  uint8_t   rsv3;           // ..reserved
  uint8_t   ssr;            // status register
  uint16_t  portr;          // source port register
  uint8_t   dhar[6];        // destination hardware address register
  uint16_t  dportr;         // destination port register
  ipv4_t    dipr;           // destination IP address register
  uint16_t  mssr;           // maximum segment size register
  uint8_t   kpalvtr;        // keep alive time register
  uint8_t   protor;         // protocol number register
  uint16_t  tosr;           // TOS register
  uint16_t  ttlr;           // TTL register
  uint32_t  tx_wrsr;        // TX write size register
  uint32_t  tx_fsr;         // TX free size register
  uint32_t  rx_rsr;         // RX receive size register
  uint8_t   rsv4;           // ..reserved
  uint8_t   fragr;          // Flag register
  uint16_t  tx_fifor;       // TX FIFO register
  uint16_t  rx_fifor;       // RX FIFO register
  uint8_t   rsv5[14];       // ..reserved
} w_socket_t;

typedef struct wiznet_t {
  mr_t       mr;	       // Mode register
  ir_t       ir;         // Interrupt Register
  ir_t       imr;        // Interrupt Mask Register
  uint8_t    rsv0[2];    // ..reserved
  uint8_t    shar[6];    // Source Hardware Address Register
  uint8_t    rsv1[2];    // ..reserved
  ipv4_t     gar;        // Gateway IP Address Register
  ipv4_t     subr;       // Subnet Mask Register
  ipv4_t     sipr;       // Source IP Address Register
  uint16_t   rtr;        // Retransmission Timeout-period (in 100us)
  uint16_t   rcr;        // Retransmission Retry-Count Register
  uint8_t    tmsr[8];    // Transmit Memory Size Registers
  uint8_t    rmsr[8];    // Receive Memory Size Registers
  uint16_t   mtyper;     // Memory Block Type Register
  uint16_t   patr;       // PPPoE Authentication Register
  uint8_t    rsv2[2];    // ..reserved
  uint16_t   ptimer;     // PPP LCP Request Time Register
  uint16_t   pmagicr;    // PPP LCP Magic Number Register
  uint8_t    rsv3[2];    // ..reserved
  uint16_t   psidr;      // PPP Session ID Register
  uint8_t    rsv4[2];    // ..reserved
  uint8_t    pdhar[6];   // PPP Destination Hardware Address Register
  uint8_t    rsv5[2];    // ..reserved
  ipv4_t     uipr;       // Unreachable IP Address Register
  uint16_t   uportr;     // Unreachable Port Number Register
  uint16_t   fmtur;      // Fragment MTU Register
  uint8_t    rsv6[16];   // ..reserved
  brdy_t     brdy[4];    // Config regs for PRDYx pins
  uint8_t    rsv7[142];  // ..reserved
  uint16_t   idr;        // W5300 ID Register
  uint8_t    rsv8[256];  // ..reserved
  w_socket_t socket[8];  // Socket registers
} wiznet_t;

// Flags to describe state of socket used for TCP communication
#define TCP_EMPTY       0x0
#define TCP_CONFIGURED  0x1
#define TCP_IPADDRSET   0x2
#define TCP_NETMASKSET  0x4

// Flags to describe state of socket used for IP communication
#define IP_EMPTY        0x0

// Flags to describe state of socket used for UDP communication
#define UDP_EMPTY       0x0

#define TRACE_DEPTH 16

#define TRACE_SOCKET_NUM_GLOBAL NUM_SOCKETS

#define TRACE_KIND_NONE 0
#define TRACE_KIND_UDP 1
#define TRACE_KIND_CLCK 2
#define TRACE_KIND_TCP 3
#define TRACE_KIND_IPRAW 4

#define TRACE_ACTION_NONE 0
#define TRACE_TIMER_TEST 1
#define TRACE_INT_SENDOK 2
#define TRACE_INT_CONNECTED 3
#define TRACE_INT_RECEIVE 4
#define TRACE_INT_DISCONNECTED 5
#define TRACE_INT_TIMEOUT 6
#define TRACE_RESEND_MESSAGE 7
#define TRACE_IO_COMMAND 8
#define TRACE_NWIOADDHITCOUNT 9
#define TRACE_NWIOGETHITCOUNT 10
#define TRACE_NWIOSTCPCONF 11 
#define TRACE_NWIOGTCPCONF 12
#define TRACE_NWIOSTCPOPT 13
#define TRACE_NWIOGTCPOPT 14
#define TRACE_NWIOTCPCONN 15 
#define TRACE_NWIOTCPLISTEN 16
#define TRACE_NWIOTCPSHUTDOWN 17
#define TRACE_NWIOTCPCLOSEHOLD 18
#define TRACE_WRITE_WSOCKET 19

// Debugging trace structure
typedef struct trace_t {
  time_t time;
  uint8_t socket_num;  // Note: use TRACE_SOCKET_NUM_GLOBAL if non-specific
  uint8_t socket_kind;
  uint8_t action;
  uint8_t source;
  uint32_t payload;
} trace_t;

typedef struct traces_t {
  uint8_t next[NUM_SOCKETS + 1];
  trace_t traces[NUM_SOCKETS + 1][TRACE_DEPTH];
} traces_t;

extern traces_t traces;

// Extern/forward decls
void ip_open(socket_t* sock, message* m);
void ip_close(socket_t* sock, message* m);
void ip_read(socket_t* sock, message* m);
void ip_write(socket_t* sock, message* m);
void ip_ioctl(socket_t* sock, message* m);
void ip_cancel(socket_t* sock, message* m);

void tcp_open(socket_t* sock, message* m);
void tcp_close(socket_t* sock, message* m);
void tcp_read(socket_t* sock, message* m);
void tcp_write(socket_t* sock, message* m);
void tcp_ioctl(socket_t* sock, message* m);
void tcp_cancel(socket_t* sock, message* m);

void udp_open(socket_t* sock, message* m);
void udp_close(socket_t* sock, message* m);
void udp_read(socket_t* sock, message* m);
void udp_write(socket_t* sock, message* m);
void udp_ioctl(socket_t* sock, message* m);
void udp_cancel(socket_t* sock, message* m);

void debug_open(socket_t* sock, message* m);
void debug_close(socket_t* sock, message* m);
void debug_read(socket_t* sock, message* m);
void debug_write(socket_t* sock, message* m);
void debug_ioctl(socket_t* sock, message* m);
void debug_cancel(socket_t* sock, message* m);

void procfs_open(socket_t* sock, message* m);
void procfs_close(socket_t* sock, message* m);
void procfs_read(socket_t* sock, message* m);
void procfs_write(socket_t* sock, message* m);
void procfs_ioctl(socket_t* sock, message* m);
void procfs_cancel(socket_t* sock, message* m);

void ip_init(int sock_num);
void tcp_init(int sock_num);
void udp_init(int sock_num);
void debug_init(int sock_num);

void set_handlers(int sock_num, int protocol, callback_t h_open,
    callback_t h_close, callback_t h_read, callback_t h_write,
    callback_t h_ioctl, callback_t h_cancel);

void create_devices(void);
int allocate_socket(int master);
void free_socket(int sock_num);
void init_socket(int sock_num);
int read_tcp_socket(socket_t* sock, uint16_t* buf, size_t buf_max, size_t count);
int write_wsocket(socket_t* sock);

void dump_sockets(void);
void dump_socket(socket_t* sock);
void dump_traces(uint8_t socket_num);

void milli_delay(int millis);
uint16_t get_next_local_port(void);
void copy_from_user(int user_proc, vir_bytes user_addr, vir_bytes tgt_addr,
    size_t len);
void copy_to_user(vir_bytes src_addr, int user_proc, vir_bytes user_addr,
    size_t len);
void wnet_reply(socket_t* sock, message *m, int status);
void init_w5300(void);
void init_protocols(void);
void print_w5300(void);
void print_ip(uint32_t ip);
void pr_status(uint8_t status, char* buf, size_t buf_size);
int connect_socket(socket_t* sock);
int listen_socket(socket_t* sock);
int open_socket(socket_t* sock, uint16_t mode);
int close_socket(int sock_num);
void dump_wsocket_config(unsigned int wsock);
void dump_socket_config(socket_t* sock);
void defer_reply(int source, message* m);
void resend_messages(int proc);
void force_udp_reset(unsigned int wsock);

void clck_init(void);
void set_time(time_t time);
time_t get_time(void);
void reset_time( void );
/* set a timer to go off at the time specified by timeout */
void clck_timer(timer_t* timer, time_t timeout, timer_func_t func, int fd);
void clck_untimer(struct timer *timer);
void clck_expire_timers(void);
void clck_tick(message* m);
char* pr_fd(unsigned int fd);
char* get_ipv4_str(ipv4_t* addr);
void dump_pseudo_socket(unsigned int sock_num);
// Experimenting with avoiding include of stdio.h
int snprintf(char* _s, size_t _n, const char* _format, ...); 

#define BIG_BUF_WORD_SIZE 2048
#define BIG_BUF_BYTE_SIZE (BIG_BUF_WORD_SIZE * 2)

extern uint16_t big_buf[BIG_BUF_WORD_SIZE+1];
extern socket_t sockets[NUM_SOCKETS];
extern char* version;
extern wiznet_flags_t wiz_flags;
extern int wnet_proc_nr;     // Proc number for the wnet server.
extern int verbose;
extern int trace;
extern int spy;
extern int log;
extern dev_t ip_dev;
extern ipv4_t w5300_gtw_addr;
extern ipv4_t w5300_ip_addr;
extern ipv4_t w5300_sub_mask;
extern uint8_t w5300_mac_addr[6];
extern int synal_tasknr;
extern int clck_call_expire;	// Call clck_expire_timer from the mainloop
extern uint8_t *wiznet_base;  // Base mapping for Wiznet device.
extern mr_t* wiz_mr;          // Mode register
extern uint16_t* wiz_ar;      // Address register
extern uint16_t* wiz_dr;      // Data register
extern uint8_t* wiz_dr0;      // MSB of data register
extern uint8_t* wiz_dr1;      // LSB of data register

uint8_t get_cr(unsigned int wsock);
void set_cr(unsigned int wsock, uint8_t value);
int set_cr_check(unsigned int wsock, uint8_t value, uint8_t expected);
uint8_t get_imr(unsigned int wsock);
void set_imr(unsigned int wsock, uint8_t value);
uint8_t get_ir(unsigned int wsock);
void set_ir(unsigned int wsock, uint8_t value);
uint8_t get_ssr(unsigned int wsock);
void set_ssr(unsigned int wsock, uint8_t value);
uint8_t get_protor(unsigned int wsock);
void set_protor(unsigned int wsock, uint8_t value);
uint8_t get_fragr(unsigned int wsock);
void set_fragr(unsigned int wsock, uint8_t value);
uint8_t get_kpalvtr(unsigned int wsock);
void set_kpalvtr(unsigned int wsock, uint8_t value);
uint16_t get_mr(unsigned int wsock);
void set_mr(unsigned int wsock, uint16_t value);
uint16_t get_portr(unsigned int wsock);
void set_portr(unsigned int wsock, uint16_t value);
uint16_t get_dportr(unsigned int wsock);
void set_dportr(unsigned int wsock, uint16_t value);
uint16_t get_mssr(unsigned int wsock);
void set_mssr(unsigned int wsock, uint16_t value);
uint16_t get_tosr(unsigned int wsock);
void set_tosr(unsigned int wsock, uint16_t value);
uint16_t get_ttlr(unsigned int wsock);
void set_ttlr(unsigned int wsock, uint16_t value);
uint16_t get_tx_fifor(unsigned int wsock);
void set_tx_fifor(unsigned int wsock, uint16_t value);
uint16_t get_rx_fifor(unsigned int wsock);
void set_rx_fifor(unsigned int wsock, uint16_t value);
void set_dipr(unsigned int wsock, ipv4_t addr);
ipv4_t get_dipr(unsigned int wsock);
void set_tx_wrsr(unsigned int wsock, uint32_t value);
uint32_t get_tx_wrsr(unsigned int wsock);
void set_tx_fsr(unsigned int wsock, uint32_t value);
uint32_t get_tx_fsr(unsigned int wsock);
void set_rx_rsr(unsigned int wsock, uint32_t value);
uint32_t get_rx_rsr(unsigned int wsock);
socket_t* wsock_to_sock(unsigned int wsock);
uint16_t wiz_get16(unsigned int offset);
void wiz_set16(unsigned int offset, uint16_t val);
uint8_t wiz_get8(unsigned int offset);
void wiz_set8(unsigned int offset, uint8_t val);
uint32_t wiz_get32(unsigned int offset);
void wiz_set32(unsigned int offset, uint32_t val);
void sanity_check_sockets(void);
void init_traces(void);
int get_trace_kind(unsigned int wsock);
void add_trace(uint8_t num, uint8_t kind, uint8_t action, uint8_t source,
    uint32_t payload);
time_t get_rtc_time(void);
#endif /* COMMON_H */

