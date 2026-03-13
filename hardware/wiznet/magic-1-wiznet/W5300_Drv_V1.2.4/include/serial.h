//////////////////////////////////////////////////////////////////////////////////
// Copyright(c) 2001-2002 Hybus Co,.ltd. All rights reserved.
//
// Module name:
//      serial.h
//
// Description:
//
//
//
// Author:
//      bedguy
//
// Created:
//      2002.10
//
////////////////////////////////////////////////////////////////////////////////

#ifndef SERIAL_H
#define SERIAL_H

#define SERIAL_SPEED			0x08
#define SERIAL_DOWNLOAD_SPEED		0x08

#include "types.h"
#include "xscale.h"

#define FFUART_BASE		0x40100000
#define FFRBR			(*((volatile ulong *)(FFUART_BASE+0x00)))
#define FFTHR           (*((volatile ulong *)(FFUART_BASE+0x00)))
#define FFIER          	(*((volatile ulong *)(FFUART_BASE+0x04)))
#define FFIIR          	(*((volatile ulong *)(FFUART_BASE+0x08)))
#define FFFCR          	(*((volatile ulong *)(FFUART_BASE+0x08)))
#define FFLCR          	(*((volatile ulong *)(FFUART_BASE+0x0C)))
#define FFMCR          	(*((volatile ulong *)(FFUART_BASE+0x10)))
#define FFLSR          	(*((volatile ulong *)(FFUART_BASE+0x14)))
#define FFMSR          	(*((volatile ulong *)(FFUART_BASE+0x18)))
#define FFSPR          	(*((volatile ulong *)(FFUART_BASE+0x1C)))
#define FFISR          	(*((volatile ulong *)(FFUART_BASE+0x20)))
#define FFDLL          	(*((volatile ulong *)(FFUART_BASE+0x00)))
#define FFDLH          	(*((volatile ulong *)(FFUART_BASE+0x04)))

#define SERIAL_BAUD_115200 (0x00000008)


void SerialInit(ulong);
void SerialOutputByte(const char);
int SerialInputByte(char *);


		

#endif

