#ifndef __MAIN_H
#define __MAIN_H
#include "stm32f4xx.h"
#include "string.h"
#include "math.h"
#include "w5300.h"
#include "stdio.h"
#include "stm32f4xx.h"
#include "stm32f429_sram.h"
#include "socket.h"

volatile void     loopback_tcps(SOCKET s, uint16 port, uint8* buf,uint16 mode);
volatile void     loopback_tcpc(SOCKET s, uint8* addr, uint16 port, uint8* buf,uint16 mode);
volatile void     loopback_udp(SOCKET s, uint16 port, uint8* buf, uint16 mode);
uint8_t htm[78]={'<',
'h',
't',
'm',
'l',
'>',
'<',
'b',
'o',
'd',
'y',
'>',
'<',
'h',
'1',
'>',
'M',
'y',
' ',
'F',
'i',
'r',
's',
't',
' ',
'H',
'e',
'a',
'd',
'i',
'n',
'g',
'<',
'/',
'h',
'1',
'>',
'<',
'p',
'>',
'M',
'y',
' ',
'f',
'i',
'r',
's',
't',
' ',
'p',
'a',
'r',
'a',
'g',
'r',
'a',
'p',
'h',
'.',
'<',
'/',
'p',
'>',
' ',
'<',
'/',
'b',
'o',
'd',
'y',
'>',
'<',
'/',
'h',
't',
'm',
'l',
'>'};


void Delay(__IO uint32_t nTime);

#endif /* __MAIN_H */

