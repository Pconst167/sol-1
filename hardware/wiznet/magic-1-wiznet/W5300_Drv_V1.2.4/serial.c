//////////////////////////////////////////////////////////////////////////////////
// Copyright(c) 2001-2002 Hybus Co,.ltd. All rights reserved.
//
// Module name:
//      serial.c
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

#include "serial.h"
#include "types.h"



void SerialInit(ulong baud){

   // GP39, GP40, GP41을 UART(10)로 사용한다.
   GAFR1_L |= 0x000A8000;	
   GPDR1   |= 0x00000380;

   // 8-bit, 1 stop, no parity 세팅.
   FFLCR = 0x00000003;

   // Reset tx, rx FIFO. clear. FIFO enable
   FFFCR = 0x00000007;

   // UART Enable Interrupt
   FFIER = 0x00000040;

   // DLAB set=latch registers, DLAB clear=일반 포트.
   FFLCR |= 0x00000080;

   // baud rate 설정. 
   FFDLL = baud;

   // DLAB clear, 일반 포트로 전환.
   FFLCR &= 0xFFFFFF7F;

   // Transmit Shift Register, Transmit Holding Register, FIFO에 
   // 데이타가 없을때까지 기다린다.
   while(! FFLSR & 0x00000040 );

   return;
}


void SerialOutputByte(const char c){

	// FIFO에 데이타가 없을때까지 기다린다.
	while ((FFLSR & 0x00000020) == 0 );

	FFTHR = ((ulong)c & 0xFF);

	// c=='\n'이면, 실제로는 "\n\r"을 출력.
//	if (c=='\n') SerialOutputByte('\r');
}


int SerialInputByte(char *c){

	// FIFO에 데이타가 있을때.
	if((FFLSR & 0x00000001)==0){
		return 0;
	} else {

		(volatile char)*c = FFRBR;
		return 1;
	}
}
