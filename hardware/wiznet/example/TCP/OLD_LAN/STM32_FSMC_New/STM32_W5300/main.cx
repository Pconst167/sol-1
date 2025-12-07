/**
 * \file    main.c
 * W5300 example applications
 * 
 * This file shows how to use  SOCKET_API_FUNC "WIZnet SOCKET APIs" and 
 * how to implement your internet application with  W5300.\n
 * 
 * \author MidnightCow
 * \date 04/07/2008
 * \version 1.1.1
 *
 * Revision History :
 * ----------  -------  -----------  ----------------------------
 * Date        Version  Author       Description
 * ----------  -------  -----------  ----------------------------
 * 24/03/2008  1.0.0    MidnightCow  Release with W5300 launching
 * ----------  -------  -----------  ----------------------------
 * 01/05/2008  1.0.1    MidnightCow  Modify 'w5300.c'. Refer M_01052008.
 * ----------  -------  -----------  ----------------------------
 * 15/05/2008  1.1.0    MidnightCow  Refer M_15052008.
 *                                   Modify 'w5300.c', 'w5300.h' and 'socket.c'. 
 * ----------  -------  -----------  ----------------------------
 * 04/07/2008  1.1.1    MidnightCow  Refer M_04072008.
 *                                   Modify 'socket.c'. 
 * ----------  -------  -----------  ----------------------------
 * 08/08/2008  1.2.0    MidnightCow  Refer M_08082008.
 *                                   Modify 'w5300.c' & 'socket.c'. 
 * ----------  -------  -----------  ----------------------------
 * 15/03/2012  1.2.2    Dongeun      Modify a ARP error.
 *                                   Modify 'w5300.c' & 'socket.c'.
 * ----------  -------  -----------  ----------------------------
 * 12/07/2012  1.2.3    Dongeun      Modify a ARP error.
 *                                   Modify 'socket.c'.
 * ----------  -------  -----------  ---------------------------- 
 * 16/05/2013  1.2.4    Dongeun      Fixed bug. ( when data received, 1byte data is crashed ) 
 *
 * ----------  -------  -----------  ---------------------------- 
 * The Main() includes the example program of  W5300 such as 
 * - loopback_tcps() \n
 * - loopback_tcpc() \n
 * - loopback_udp()
 */



#include "main.h"
#include "xscale.h"
#include "socket.h"


LOADER_STATUS	status;           // for serial port

void InitXHyper255A(void);       // Intialize MCU

/* Definition of example code */
void     loopback_tcps(SOCKET s, uint16 port, uint8* buf,uint16 mode);
void     loopback_tcpc(SOCKET s, uint8* addr, uint16 port, uint8* buf,uint16 mode);
void     loopback_udp(SOCKET s, uint16 port, uint8* buf, uint16 mode);
 

/**
 * It executes example program such as loopback_tcps(), loopback_tcpc(), and loopback_udp().
 */ 
void Main()
{
   uint8 tx_mem_conf[8] = {8,8,8,8,8,8,8,8};          // for setting TMSR regsiter
   uint8 rx_mem_conf[8] = {8,8,8,8,8,8,8,8};          // for setting RMSR regsiter
   
   uint8 * data_buf = (uint8 *) 0xA10E0000;         // buffer for loopack data
   
   uint8 ip[4] = {192,168,111,200};                   // for setting SIP register
   uint8 gw[4] = {192,168,111,1};                     // for setting GAR register
   uint8 sn[4] = {255,255,255,0};                     // for setting SUBR register
   uint8 mac[6] = {0x00,0x08,0xDC,0x00,111,200};      // for setting SHAR register
   
   uint8 serverip[4] = {192,168,111,78};              // "TCP SERVER" IP address for loopback_tcpc()
   
   status.terminalSpeed = SERIAL_SPEED;
   status.downloadSpeed = SERIAL_DOWNLOAD_SPEED;
   
   data_buf = (uint8*)0xA10F0000;                       
   
   InitXHyper255A();                                  // initiate MCU
   SerialInit(status.terminalSpeed);                  // initiate serial port
   
   /* initiate W5300 */
   iinchip_init();  

   /* allocate internal TX/RX Memory of W5300 */
   if(!sysinit(tx_mem_conf,rx_mem_conf))           
   {
      printf("MEMORY CONFIG ERR.\r\n");
      while(1);
   }

   //setMR(getMR()|MR_FS);                            // If Little-endian, set MR_FS.
   
   setSHAR(mac);                                      // set source hardware address
   
   #ifdef __DEF_IINCHIP_PPP__
      if(pppinit((uint8*)"test01", 6, (uint8*)"pppoe1000", 9)!=1)
      {
         printf("PPPoE fail.\r\n");
         while(1);
      }
      close(0);
   #else
      /* configure network information */
      setGAR(gw);                                     // set gateway IP address
      setSUBR(sn);                                    // set subnet mask address
      setSIPR(ip);                                    // set source IP address
   #endif
   
   /* verify network information */
   getSHAR(mac);                                      // get source hardware address 
   getGAR(gw);                                        // get gateway IP address      
   getSUBR(sn);                                       // get subnet mask address     
   getSIPR(ip);                                       // get source IP address       
   
   printf("SHAR : %02x:%02x:%02x:%02x:%02x:%02x\r\n",mac[0],mac[1],mac[2],mac[3],mac[4],mac[5]);
   printf("GWR  : %d.%d.%d.%d\r\n",gw[0],gw[1],gw[2],gw[3]);
   printf("SUBR : %d.%d.%d.%d\r\n",sn[0],sn[1],sn[2],sn[3]);
   printf("SIPR : %d.%d.%d.%d\r\n",ip[0],ip[1],ip[2],ip[3]);
   
   while(1)
   {
      loopback_tcps(0,5000,data_buf,0);
      loopback_tcps(1,5000,data_buf,0);
      loopback_tcps(2,5000,data_buf,0);
      loopback_tcps(3,5000,data_buf,0);
      loopback_tcps(4,5000,data_buf,0);
      loopback_tcps(5,5000,data_buf,0);
      loopback_tcpc(6,serverip, 3000, data_buf,0);
      loopback_udp(7,3000,data_buf,0);
   }

   #ifdef __DEF_IINCHIP_PPP__
   {
      uint8 ppp_mac[6];
      getPDHAR(ppp_mac);
      pppterm(ppp_mac, getPSIDR());
   }
   #endif

   while(1);
}


void InitXHyper255A(void)
{
   ADDR32(GPIO_BASE+GPDR2) |= GPDR2_VALUE; //~0x0;//((ADDR32(GPIO_BASE+GPDR2) & 0x0001FFFF) | GPDR2_VALUE);
   ADDR32(GPIO_BASE+GAFR2_L) |= GAFR2L_VALUE;
   ADDR32(MEM_CTL_BASE+MSC1) = 0x00008259;//0x000095F8;
}

/**
 * "TCP SERVER" loopback program.
 */ 
void     loopback_tcps(SOCKET s, uint16 port, uint8* buf, uint16 mode)
{
   uint32 len;
   
   switch(getSn_SSR(s))                // check SOCKET status
   {                                   // ------------
      case SOCK_ESTABLISHED:           // ESTABLISHED?
         if(getSn_IR(s) & Sn_IR_CON)   // check Sn_IR_CON bit
         {
            printf("%d : Connect OK\r\n",s);
            setSn_IR(s,Sn_IR_CON);     // clear Sn_IR_CON
         }
         if((len=getSn_RX_RSR(s)) > 0) // check the size of received data
         {
            len = recv(s,buf,len);     // recv
            if(len !=send(s,buf,len))  // send
            {
               printf("%d : Send Fail.len=%d\r\n",s,len);
            }
         }
         break;
                                       // ---------------
   case SOCK_CLOSE_WAIT:               // PASSIVE CLOSED
         disconnect(s);                // disconnect 
         break;
                                       // --------------
   case SOCK_CLOSED:                   // CLOSED
      close(s);                        // close the SOCKET
      socket(s,Sn_MR_TCP,port,mode);   // open the SOCKET  
      break;
                                       // ------------------------------
   case SOCK_INIT:                     // The SOCKET opened with TCP mode
      listen(s);                       // listen to any connection request from "TCP CLIENT"
      printf("%d : LOOPBACK_TCPS(%d) Started.\r\n",s,port);
      break;
   default:
      break;
   }
}

/**
 * "TCP CLIENT" loopback program.
 */ 
void     loopback_tcpc(SOCKET s, uint8* addr, uint16 port, uint8* buf, uint16 mode)
{
   uint32 len;
   static uint16 any_port = 1000;
   
   switch(getSn_SSR(s))                   // check SOCKET status
   {                                      // ------------
      case SOCK_ESTABLISHED:              // ESTABLISHED?
         if(getSn_IR(s) & Sn_IR_CON)      // check Sn_IR_CON bit
         {
            printf("%d : Connect OK\r\n",s);
            setSn_IR(s,Sn_IR_CON);        // clear Sn_IR_CON
         }
         if((len=getSn_RX_RSR(s)) > 0)    // check the size of received data
         {
            len = recv(s,buf,len);        // recv
            if(len !=send(s,buf,len))     // send
            {
               printf("%d : Send Fail.len=%d\r\n",s,len);
            }
         }
         break;
                                          // ---------------
   case SOCK_CLOSE_WAIT:                  // PASSIVE CLOSED
         disconnect(s);                   // disconnect 
         break;
                                          // --------------
   case SOCK_CLOSED:                      // CLOSED
      close(s);                           // close the SOCKET
      socket(s,Sn_MR_TCP,any_port++,mode);// open the SOCKET with TCP mode and any source port number
      break;
                                          // ------------------------------
   case SOCK_INIT:                        // The SOCKET opened with TCP mode
      connect(s, addr, port);             // Try to connect to "TCP SERVER"
      printf("%d : LOOPBACK_TCPC(%d.%d.%d.%d:%d) Started.\r\n",s,addr[0],addr[1],addr[2],addr[3],port);
      break;
   default:
      break;
   }
}

/**
 * UDP loopback program.
 */ 
void     loopback_udp(SOCKET s, uint16 port, uint8* buf, uint16 mode)
{
   uint32 len;
   uint8 destip[4];
   uint16 destport;
   
   switch(getSn_SSR(s))
   {
                                                         // -------------------------------
      case SOCK_UDP:                                     // 
         if((len=getSn_RX_RSR(s)) > 0)                   // check the size of received data
         {
            len = recvfrom(s,buf,len,destip,&destport);  // receive data from a destination
            if(len !=sendto(s,buf,len,destip,destport))  // send the data to the destination
            {
               printf("%d : Sendto Fail.len=%d,",s,len);
               printf("%d.%d.%d.%d(%d)\r\n",destip[0],destip[1],destip[2],destip[3],destport);
            }
         }
         break;
                                                         // -----------------
      case SOCK_CLOSED:                                  // CLOSED
         close(s);                                       // close the SOCKET
         socket(s,Sn_MR_UDP,port,mode);                  // open the SOCKET with UDP mode
         break;
      default:
         break;
   }
}
