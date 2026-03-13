/*
 * Copyright (c) 2001, Adam Dunkels.
 * All rights reserved. 
 *
 * Redistribution and use in source and binary forms, with or without 
 * modification, are permitted provided that the following conditions 
 * are met: 
 * 1. Redistributions of source code must retain the above copyright 
 *    notice, this list of conditions and the following disclaimer. 
 * 2. Redistributions in binary form must reproduce the above copyright 
 *    notice, this list of conditions and the following disclaimer in the 
 *    documentation and/or other materials provided with the distribution. 
 * 3. The name of the author may not be used to endorse or promote
 *    products derived from this software without specific prior
 *    written permission.  
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS
 * OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
 * GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.  
 *
 * This file is part of the uIP TCP/IP stack.
 *
 * $Id: uip_arch.c,v 1.1.1.1 2007/04/23 06:39:31 buzbee Exp $
 *
 */


#include "uip.h"
#include "uip_arch.h"

#define BUF ((uip_tcpip_hdr *)&uip_buf[UIP_LLH_LEN])
#define IP_PROTO_TCP    6

/*-----------------------------------------------------------------------------------*/
void
uip_add32(u8_t *op32, u16_t op16)
{
  *((u32_t*)&uip_acc32[0]) = *((u32_t*)op32) + op16;
}

/*-----------------------------------------------------------------------------------*/
u16_t
uip_chksum(u16_t *sdata, u16_t len)
{
  u16_t acc;
  
  for(acc = 0; len > 1; len -= 2) {
    acc += *sdata;
    if(acc < *sdata) {
      /* Overflow, so we add the carry to acc (i.e., increase by
         one). */
      ++acc;
    }
    ++sdata;
  }

  /* add up any odd byte */
  if(len == 1) {
    u16_t t = *sdata & 0xff00;
    acc += t;
    if (acc < t)
	++acc;
  }

  return acc;
}
/*-----------------------------------------------------------------------------------*/
u16_t
uip_ipchksum(void)
{
  return uip_chksum((u16_t *)&uip_buf[UIP_LLH_LEN], 20);
}

/*-----------------------------------------------------------------------------------*/
u16_t
uip_tcpchksum(void)
{
  u16_t hsum, sum;
  u16_t t;
  u16_t tcp_len = *((u16_t*)&BUF->len[0]) - 20;

  // Pseudo checksum first
  //  .. get src and dst addresses
  sum = uip_chksum((u16_t*)&BUF->srcipaddr[0],8);

  //  .. add in the protocol
  if ((sum += (u16_t)IP_PROTO_TCP) < (u16_t)IP_PROTO_TCP) {
      ++sum;
  }

  // .. add in the TCP length
  if ((sum += tcp_len) < tcp_len) {
      ++sum;
  }

  // now, sum the TCP header
  t = uip_chksum((u16_t*)&uip_buf[20+UIP_LLH_LEN],20);
  if ((sum += t) < t) {
      ++sum;
  }

  // finally, the TCP data
  t = uip_chksum((u16_t*)&uip_appdata[0],tcp_len-20);
  if ((sum += t) < t) {
      ++sum;
  }

  return sum;
}
/*-----------------------------------------------------------------------------------*/
