/**
 * \addtogroup httpd
 * @{
 */

/**
 * \file
 * HTTP server script language C functions file.
 * \author Adam Dunkels <adam@dunkels.com>
 *
 * This file contains functions that are called by the web server
 * scripts. The functions takes one argument, and the return value is
 * interpreted as follows. A zero means that the function did not
 * complete and should be invoked for the next packet as well. A
 * non-zero value indicates that the function has completed and that
 * the web server should move along to the next script line.
 *
 */

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
 * $Id: cgi.c,v 1.1.1.1 2007/04/23 06:39:31 buzbee Exp $
 *
 */

#include "uip.h"
#include "cgi.h"
#include "httpd.h"
#include "fs.h"

#include <stdio.h>
#include <string.h>

static u8_t print_stats(u8_t next);
static u8_t file_stats(u8_t next);
static u8_t tcp_stats(u8_t next);
static u8_t magic_stats(u8_t next);
static u8_t magic_guestbook(u8_t next);
static u8_t magic_commands(u8_t next);

cgifunction cgitab[] = {
  print_stats,   /* CGI function "a" */
  file_stats,    /* CGI function "b" */
  tcp_stats,      /* CGI function "c" */
  magic_stats,	/* CGI function "d" */
  magic_guestbook,	/* CGI function "e" */
  magic_commands	/* CGI function "f" */
};

static const char closed[] =   /*  "CLOSED",*/
{0x43, 0x4c, 0x4f, 0x53, 0x45, 0x44, 0};
static const char syn_rcvd[] = /*  "SYN-RCVD",*/
{0x53, 0x59, 0x4e, 0x2d, 0x52, 0x43, 0x56, 
 0x44,  0};
static const char syn_sent[] = /*  "SYN-SENT",*/
{0x53, 0x59, 0x4e, 0x2d, 0x53, 0x45, 0x4e, 
 0x54,  0};
static const char established[] = /*  "ESTABLISHED",*/
{0x45, 0x53, 0x54, 0x41, 0x42, 0x4c, 0x49, 0x53, 0x48, 
 0x45, 0x44, 0};
static const char fin_wait_1[] = /*  "FIN-WAIT-1",*/
{0x46, 0x49, 0x4e, 0x2d, 0x57, 0x41, 0x49, 
 0x54, 0x2d, 0x31, 0};
static const char fin_wait_2[] = /*  "FIN-WAIT-2",*/
{0x46, 0x49, 0x4e, 0x2d, 0x57, 0x41, 0x49, 
 0x54, 0x2d, 0x32, 0};
static const char closing[] = /*  "CLOSING",*/
{0x43, 0x4c, 0x4f, 0x53, 0x49, 
 0x4e, 0x47, 0};
static const char time_wait[] = /*  "TIME-WAIT,"*/
{0x54, 0x49, 0x4d, 0x45, 0x2d, 0x57, 0x41, 
 0x49, 0x54, 0};
static const char last_ack[] = /*  "LAST-ACK"*/
{0x4c, 0x41, 0x53, 0x54, 0x2d, 0x41, 0x43, 
 0x4b, 0};

static const char *states[] = {
  closed,
  syn_rcvd,
  syn_sent,
  established,
  fin_wait_1,
  fin_wait_2,
  closing,
  time_wait,
  last_ack};
  

char *col1[] = {
    "I/O",
    "",
    "",
    "IP",
    "",
    "",
    "",
    "IP errors",
    "",
    "",
    "",
    "",
    "",
    "ICMP",
    "",
    "",
    "",
    "TCP",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
};

char *col2[] = {
    "Bytes recieved",
    "Bytes sent",
    "Total bytes",
    "Packets dropped",
    "Packets received",
    "Packets sent",
    "Total IP Packets",
    "IP version/header length",
    "IP length, high byte",
    "IP length, low byte",
    "IP fragments",
    "Header checksum",
    "Wrong protocol",
    "Packets dropped",
    "Packets received",
    "Packets sent",
    "Type errors",
    "Packets dropped",
    "Packets received",
    "Packets sent",
    "Checksum errors",
    "Data packets without ACKs",
    "Resets",
    "Retransmissions",
    "No connection avaliable",
    "Connection attempts to closed ports",
};

/*-----------------------------------------------------------------------------------*/
/* print_stats:
 *
 * Prints out a part of the uIP statistics. The statistics data is
 * written into the uip_appdata buffer. It overwrites any incoming
 * packet.
 */
static u8_t
print_stats(u8_t next)
{
#if UIP_STATISTICS
  u16_t i;
  u8_t *buf;
  u8_t sbuf[200];
  u16_t done;
  u16_t num_recs = sizeof(struct uip_stats)/sizeof(uip_stats_t);

// MSB of hs->count is number of last element attempted on previous invocation
// LSB of hs->count is number of first element to attempt  
  if(next) {
    /* If our last data has been acknowledged, we move on the next
       chunk of statistics. */
    hs->count = (hs->count >> 8);
    if(hs->count >= num_recs) {
      /* We have printed out all statistics, so we return 1 to
	 indicate that we are done. */
      return 1;
    }
  }

  hs->count &= 0xff;   // Clear attempt count
  done = FALSE;
  /* Write part of the statistics into the uip_appdata buffer. */
  buf       = (u8_t *)uip_appdata;
  buf[0] = 0;
  i = hs->count;

  while (!done) {

      // Write out next line
      sprintf((char*)sbuf,
	  "<tr><td><b>%s</b></td><td>%s</td><td align=\"right\">%8lu</td></tr>\n",
	  col1[i],col2[i],*((uip_stats_t*)&uip_stat + i));

      if (strlen((char*)sbuf) + strlen((char*)uip_appdata) >= (UIP_BUFSIZE-50)) {
	  done = TRUE;
      } else {
          strcpy((char*)buf,(char*)sbuf);
          buf += strlen((char*)sbuf);
	  i++;
      }
      if (i == num_recs) {
	  done = TRUE;
      }
  }

  hs->count |= (i<<8);

  /* Send the data. */
  uip_send(uip_appdata, strlen((char*)uip_appdata));
  
  return 0;
#else
  return 1;
#endif /* UIP_STATISTICS */
}
/*-----------------------------------------------------------------------------------*/
static u8_t
magic_stats(u8_t next)
{
  unsigned long total = 0;
  u16_t i;

  char *p = (char*)uip_appdata;

  for (i=0;i<FS_NUMFILES;i++) {
      total += count[i];
  }

  (void)kgetinfo(&sysinfo);

  sprintf(p,"<h2>Magic-1 Stats</h2><ul>");
  p += strlen(p);
  sprintf(p,"<li>Files served:  %lu</li>", total);
  p += strlen(p);
  sprintf(p,"<li>Current time:  ");
  p += strlen(p);
  strftime(p,100,"%A, %B %d 20%y - %I:%M:%S %p %Z",localtime(&sysinfo.curr_time));
  p += strlen(p);
  sprintf(p,"<li>Last clock sync:</li><DIR>");
  p += strlen(p);
  if (sysinfo.curr_udt) {
      strftime(p,100,"%A, %B %d 20%y - %I:%M:%S %p %Z<br>",localtime(&sysinfo.curr_udt));
      p += strlen(p);
      sprintf(p,"Sync'd from %s [%s]<br></DIR>",
           time_servers[curr_time_server].full_name,
	   time_servers[curr_time_server].ip_name);
      p += strlen(p);
  } else {
      strcpy(p,"No sync yet<br>");
      p += strlen(p);
  }
  p += strlen(p);
  sprintf(p,"<li>Boot time:     %s</li>",boot_time);
  p += strlen(p);
  sprintf(p,"</li>");
  p += strlen(p);
#if 0
  sprintf(p,"<li>Ticks:     %d</li>",sysinfo.curr_ticks);
  p += strlen(p);
  sprintf(p,"<li>uIP start time: %s</li>",start_time);
  p += strlen(p);
#endif
  sprintf(p,"<li>OS Version:     %s</li>",sysinfo.os_version);

  uip_send(uip_appdata, strlen((char*)uip_appdata));

  return 1;
}
/*-----------------------------------------------------------------------------------*/
static u8_t
magic_guestbook(u8_t next)
{
  unsigned long total = 0;
  u16_t i;

  char *p = (char*)uip_appdata;

  (void)kgetinfo(&sysinfo);

  if (!strlen(sysinfo.last_name))
      strcpy(sysinfo.last_name,"<empty>");
  if (!strlen(sysinfo.last_from))
      strcpy(sysinfo.last_from,"<empty>");
  if (!strlen(sysinfo.last_msg))
      strcpy(sysinfo.last_msg,"<empty>");

  sprintf(p,"<hr>Last guestbook entry:\n");
  p += strlen(p);
  sprintf(p,"<DIR>Name: %s<br>",sysinfo.last_name);
  p += strlen(p);
  sprintf(p,"From: %s<br>",sysinfo.last_from);
  p += strlen(p);
  sprintf(p,"Message: %s<br>",sysinfo.last_msg);
  p += strlen(p);
  strftime(sign_time,50,"%A, %B %d 20%y - %I:%M:%S %p",
	      localtime(&sysinfo.last_time));
      sprintf(p,"Signed on %s</DIR>",sign_time);
  p += strlen(p);

  sprintf(p,"Number of new guestbook entries: %d<br>",sysinfo.num_guestbook_entries);
  p += strlen(p);
  sprintf(p,"Click <a href=\"http://www.homebrewcpu.com/guestbook.htm\" target=\"_top\">here</a> to view older guestbook entries.");

  uip_send(uip_appdata, strlen((char*)uip_appdata));

  return 1;
}
/*-----------------------------------------------------------------------------------*/
static u8_t
magic_commands(u8_t next)
{
  unsigned long total = 0;
  u16_t i;

  char *p = (char*)uip_appdata;

  (void)kgetinfo(&sysinfo);

  sprintf(p,"<hr><li>Number of commands executed: %d</li>",sysinfo.num_commands);
  p += strlen(p);
  strftime(sign_time,50,"%A, %B %d 20%y - %I:%M:%S %p",
	  localtime(&sysinfo.last_command_time));
  sprintf(p,"<li>Last command: \"%c\", executed on %s</li>",
	  sysinfo.last_command,sign_time);
  p += strlen(p);
  sprintf(p,"<li>Last program executed: \"%s\"</li>",sysinfo.process_name);
  p += strlen(p);

  sprintf(p,"</ul>");

  uip_send(uip_appdata, strlen((char*)uip_appdata));

  return 1;
}
/*-----------------------------------------------------------------------------------*/
static u8_t
file_stats(u8_t next)
{
  /* We use sprintf() to print the number of file accesses to a
     particular file (given as an argument to the function in the
     script). We then use uip_send() to actually send the data. */
  if(next) {
    return 1;
  }
  uip_send(uip_appdata, sprintf((char *)uip_appdata, "%5u", fs_count(&hs->script[4])));  
  return 0;
}
/*-----------------------------------------------------------------------------------*/
static u8_t
tcp_stats(u8_t next)
{
  struct uip_conn *conn;  
  u16_t i;
  u16_t done;
  u8_t *buf;
  u8_t sbuf[200];

  if(next) {
    hs->count = hs->count >> 8;
    if(hs->count == UIP_CONNS) {
      /* If all connections has been printed out, we are done and
	 return 1. */
      return 1;
    }
  }

  hs->count &= 0xff;
  i = hs->count;
  done = FALSE;
  buf = (u8_t *)uip_appdata;
  buf[0] = 0;

  while (!done) { 
      conn = &uip_conns[i]; 
      if((conn->tcpstateflags & TS_MASK) == CLOSED) { 
	  sprintf((char *)sbuf,
	        "<tr align=\"center\"><td>-</td><td>-</td><td>%u</td><td>%u</td><td>%c %c</td></tr>\r\n", 
		conn->nrtx, 
		conn->timer, 
		(uip_outstanding(conn))? '*':' ', 
		(uip_stopped(conn))? '!':' ');
      } else {
           sprintf((char *)sbuf, 
		 "<tr align=\"center\"><td>%u.%u.%u.%u:%u</td><td>%s</td><td>%u</td><td>%u</td><td>%c %c</td></tr>\r\n", 
		 conn->ripaddr[0] >> 8, 
		 conn->ripaddr[0] & 0xff, 
		 conn->ripaddr[1] >> 8, 
		 conn->ripaddr[1] & 0xff, 
		 conn->rport, 
		 states[conn->tcpstateflags & TS_MASK], 
		 conn->nrtx, 
		 conn->timer, 
		 (uip_outstanding(conn))? '*':' ', 
		 (uip_stopped(conn))? '!':' ');
      }
      if (strlen((char*)sbuf) + strlen((char*)uip_appdata) >= (UIP_BUFSIZE-50)) {
	  done = TRUE;
      } else {
          strcpy((char*)buf,(char*)sbuf);
          buf += strlen((char*)sbuf);
	  i++;
      }
      if (i == UIP_CONNS) {
	  done = TRUE;
      }
  }
  hs->count |= (i<<8);

  /* Send the data. */
  uip_send(uip_appdata, strlen((char*)uip_appdata));
  return 0;
}
/*-----------------------------------------------------------------------------------*/
