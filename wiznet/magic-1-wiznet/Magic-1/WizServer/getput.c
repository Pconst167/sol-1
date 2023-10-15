#include "common.h"

#define GET(field, reg, type) \
  type get_ ## field(unsigned int wsock) {\
    *wiz_ar = wsock + field ## _offset; \
    return *reg; \
  }

#define SET(field, reg, type) \
  void set_ ## field(unsigned int wsock, type value) {\
    *wiz_ar = wsock + field ## _offset; \
    *reg = value; \
  }

#define GET_32(field) \
  uint32_t get_ ## field(unsigned int wsock) {\
    uint32_t res; \
    *wiz_ar = wsock + field ## _offset; \
    res = *wiz_dr; \
    res <<= 16; \
    *wiz_ar = wsock + field ## _offset + 2; \
    res |= *wiz_dr; \
    return res; \
  }

#define SET_32(field) \
  void set_ ## field(unsigned int wsock, uint32_t val) { \
    *wiz_ar = wsock + field ## _offset; \
    *wiz_dr = (val >> 16); \
    *wiz_ar = wsock + field ## _offset + 2; \
    *wiz_dr = val; \
  }

// Odd
  GET(cr, wiz_dr1, uint8_t)
  SET(cr, wiz_dr1, uint8_t)
  GET(imr, wiz_dr1, uint8_t)
  SET(imr, wiz_dr1, uint8_t)
  GET(ir, wiz_dr1, uint8_t)
  SET(ir, wiz_dr1, uint8_t)
  GET(ssr, wiz_dr1, uint8_t)
  SET(ssr, wiz_dr1, uint8_t)
  GET(protor, wiz_dr1, uint8_t)
  SET(protor, wiz_dr1, uint8_t)
  GET(fragr, wiz_dr1, uint8_t)
SET(fragr, wiz_dr1, uint8_t)
  // Even
  GET(kpalvtr, wiz_dr0, uint8_t)
SET(kpalvtr, wiz_dr0, uint8_t)

  GET(mr, wiz_dr, uint16_t)
  SET(mr, wiz_dr, uint16_t)
  GET(mssr, wiz_dr, uint16_t)
  SET(mssr, wiz_dr, uint16_t)
  GET(tosr, wiz_dr, uint16_t)
  SET(tosr, wiz_dr, uint16_t)
  GET(ttlr, wiz_dr, uint16_t)
  SET(ttlr, wiz_dr, uint16_t)
  GET(tx_fifor, wiz_dr, uint16_t)
  SET(tx_fifor, wiz_dr, uint16_t)
  GET(rx_fifor, wiz_dr, uint16_t)
SET(rx_fifor, wiz_dr, uint16_t)

  GET_32(tx_wrsr)
  SET_32(tx_wrsr)
  GET_32(tx_fsr)
  SET_32(tx_fsr)
  GET_32(rx_rsr)
SET_32(rx_rsr)

  /*
   * The Wiznet device doesn't correctly and consistently support readback,
   * so, we'll keep some shadow values in the socket structure.
   */
  void set_dipr(unsigned int wsock, ipv4_t addr) {
    socket_t* sock = wsock_to_sock(wsock);
    sock->dipr = addr;
    *wiz_ar = wsock + dipr_offset;
    *wiz_dr = (uint16_t)(addr.u.raw >> 16);
    *wiz_ar = wsock + dipr_offset + 2;
    *wiz_dr = (uint16_t)addr.u.raw;
  }

ipv4_t get_dipr(unsigned int wsock) {
  ipv4_t res;
  socket_t* sock = wsock_to_sock(wsock);
  res = sock->dipr;
  if (get_ssr(wsock) == WIZ_STATUS_ESTABLISHED) {
    int i = sock->sock_num;
    // If we've got a connection going, look at wiznet registers directly.
    assert(i < NUM_WIZ_SOCKETS);
    assert(i >= 0);
    res.u.raw = wiz_get32(offsetof(wiznet_t, socket[i].dipr));
  }
  return res;
}

void set_dportr(unsigned int wsock, uint16_t port) {
  *wiz_ar = wsock + dportr_offset;
  wsock_to_sock(wsock)->dportr = *wiz_dr = port;
}

uint16_t get_dportr(unsigned int wsock) {
  uint16_t res;
  socket_t* sock = wsock_to_sock(wsock);
  res = sock->dportr;
  if (get_ssr(wsock) == WIZ_STATUS_ESTABLISHED) {
    int i = sock->sock_num;
    // If we've got a connection going, look at wiznet registers directly.
    assert(i < NUM_WIZ_SOCKETS);
    assert(i >= 0);
    res = wiz_get16(offsetof(wiznet_t, socket[i].dportr));
  }
  return res;
}

void set_portr(unsigned int wsock, uint16_t port) {
  *wiz_ar = wsock + portr_offset;
  wsock_to_sock(wsock)->portr = *wiz_dr = port;
}

uint16_t get_portr(unsigned int wsock) {
  uint16_t res;
  socket_t* sock = wsock_to_sock(wsock);
  res = sock->portr;
  if (get_ssr(wsock) == WIZ_STATUS_ESTABLISHED) {
    int i = sock->sock_num;
    // If we've got a connection going, look at wiznet registers directly.
    assert(i < NUM_WIZ_SOCKETS);
    assert(i >= 0);
    res = wiz_get16(offsetof(wiznet_t, socket[i].portr));
  }
  return res;
}

uint8_t wiz_get8(unsigned int offset) {
  *wiz_ar = offset;
  if (offset & 0x1) {
    return *wiz_dr1;
  } else {
    return *wiz_dr0;
  }
}

void wiz_set8(unsigned int offset, uint8_t val) {
  *wiz_ar = offset;
  if (offset & 0x1) {
    *wiz_dr1 = val;
  } else {
    *wiz_dr0 = val;
  }
}

uint16_t wiz_get16(unsigned int offset) {
  *wiz_ar = offset;
  return *wiz_dr;
}

void wiz_set16(unsigned int offset, uint16_t val) {
  *wiz_ar = offset;
  *wiz_dr = val;
}

uint32_t wiz_get32(unsigned int offset) {
  uint32_t res;
  uint16_t* p = (uint16_t*)&res;
  p[0] = wiz_get16(offset);
  p[1] = wiz_get16(offset+2);
  return res;
}

void wiz_set32(unsigned int offset, uint32_t val) {
  uint16_t* p = (uint16_t*)&val;
  wiz_set16(offset, p[0]);
  wiz_set16(offset+2, p[1]);
}






