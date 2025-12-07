#ifndef __MAIN_H
#define __MAIN_H
#include "stm32f4xx.h"

#include "math.h"
#include "w5300.h"
#include "stdio.h"
#include "stm32f429_sram.h"
#include "socket.h"

void     loopback_tcps(SOCKET s, uint16 port, uint8* buf,uint16 mode);
void     loopback_tcpc(SOCKET s, uint8* addr, uint16 port, uint8* buf,uint16 mode);
void     loopback_udp(SOCKET s, uint16 port, uint8* buf, uint16 mode);


void Delay(__IO uint32_t nTime);

#endif /* __MAIN_H */

