/*****************************************************************************
* Copyright(C) 2011 Dong-A University MICCA
* All right reserved.
*
* File name	    : ethernet.h
* Last version	: 1.00
* Description	: This file is header file for ethernet control(w5300)
*
* History
* Date		    Version	    Author			Description
* 07/16/2011	1.00		oh woomin	    Created
*****************************************************************************/

#ifndef __ETHERNET_H
#define __ETHERNET_H

/* Includes ----------------------------------------------------------------*/
#include "socket.h"
#include "types.h"

/* Exported functions --------------------------------------------------------*/
void EthernetInit(void);
void DispEthernetInfo(void);
void LoopbackTcps(SOCKET s, uint16 port, uint8* buf, uint16 mode);
void LoopbackTcpc(SOCKET s, uint8* addr, uint16 port, uint8* buf, uint16 mode);
void LoopbackUdp(SOCKET s, uint16 port, uint8* buf, uint16 mode);

#endif
