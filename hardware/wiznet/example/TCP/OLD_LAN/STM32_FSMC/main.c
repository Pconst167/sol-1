#include "main.h"

volatile uint16_t ID  = 0;
volatile uint16_t PORT_PC = 33000;
volatile uint16_t PORT_W5300 = 32000; //mano portas
uint8_t pcip[4] = {192,168,8,82}; 
uint8_t chat[9] ={'L','A','B','A','S',' ',':',')','P'};

uint8 ip[4] = {192,168,8,254};                         // for setting SIP register
uint8 gw[4] = {192,168,11,1};                          // for setting GAR register
uint8 sn[4] = {255,255,252,0};                          // for setting SUBR register
uint8 mac[6] = {0x00,0x08,0xDC,0x11,0x22,0x86};         // for setting SHAR register  {0x00,0x08,0xDC,0x11,0x22,0x86};

uint8 serverip[4] = {192,168,8,255};              // "TCP SERVER" IP address for loopback_tcpc()
uint8 tx_mem_conf[8] = {8,8,8,8,8,8,8,8};
uint8 rx_mem_conf[8] = {8,8,8,8,8,8,8,8}; 
volatile uint16_t data = 0;
  uint8_t data_buftx[2048] = {0};
  uint8_t data_bufrx[2048] = {0};
  uint8 *data_buf = (uint8 *)0x2000;

  int main(void)
{
  SRAM_Init(); 

  iinchip_init();
  Delay(0xFFFFFF);
  ID  =IINCHIP_READ(IDR);                  
   
    

   if(!sysinit(tx_mem_conf,rx_mem_conf))           
   {
      while(1);
   }
   
  setSHAR(mac);         // set source hardware address
  
  setGAR(gw);           // set gateway IP address
  setSUBR(sn);          // set subnet mask address
  setSIPR(ip);          // set source IP address

  getSHAR(mac);         // get source hardware address 
  getGAR(gw);           // get gateway IP address      
  getSUBR(sn);          // get subnet mask address     
  getSIPR(ip);          // get source IP address       
   
  if(!sysinit(tx_mem_conf,rx_mem_conf))           
  {
    while(1);
  }
  /*
  Delay(0xFFFFF);
  Delay(IINCHIP_READ(Sn_SSR(0)));
  while((IINCHIP_READ((Sn_SSR(0)))&0xFF) != SOCK_INIT)
  {
    IINCHIP_WRITE(Sn_MR(0),1); // sets TCP mode 
    Delay(0xFFFF);
    IINCHIP_WRITE(Sn_PORTR(0),PORT_W5300);
    Delay(0xFFFF);
    IINCHIP_WRITE(Sn_CR(0),Sn_CR_OPEN); 
  }
  
  IINCHIP_WRITE(Sn_DIPR(0), ((uint16)pcip[0]<<8)+(uint16)pcip[1]);
  IINCHIP_WRITE(Sn_DIPR2(0),((uint16)pcip[2]<<8)+(uint16)pcip[3]);
  IINCHIP_WRITE(Sn_PORTR(0),PORT_W5300);
  setSn_CR(0, PORT_W5300);

  setSn_CR(0,Sn_CR_CONNECT);

  Delay(0xFFFF);
  send(0, chat,9);
  while(1)
  {    
    data = getSn_SSR(0);
    //loopback_tcps(1,32000,data_buf,0);
    //loopback_udp(2,33000,data_buf,0);
  }
  while(1)
  {
     setSn_CR(0,Sn_CR_SEND_KEEP);
    send(0, chat,9);
    recv(0, data_bufrx,100);
  }

  
  while(1);
  {
    loopback_tcps(0,32000,data_buf,0);
    loopback_udp(1,33000,data_buf,0);
  }
  */
   while(1)
   {
      loopback_tcps(0,15000,data_buf,0);
      loopback_tcps(1,15000,data_buf,0);
      loopback_tcps(2,15000,data_buf,0);
      loopback_tcps(3,15000,data_buf,0);
      loopback_tcps(4,15000,data_buf,0);
      loopback_tcps(5,15000,data_buf,0);
      //loopback_tcpc(6,serverip, 12000, data_buf,0);
      loopback_udp(7,15000,data_buf,0);
   }

}


/*

uint8 ip[4] = {192,168,8,199};                         // for setting SIP register
uint8 gw[4] = {192,168,11,1};                          // for setting GAR register
uint8 sn[4] = {255,255,252,0};                          // for setting SUBR register
uint8 mac[6] = {0x00,0x08,0xDC,0x11,0x22,0x86};
void Get_DHCP(void)
{
  uint8_t ipdhcp[4] = {192,168,8,199};                         
  uint8_t gwdhcp[4] = {192,168,11,1};                         
  uint8_t sndhcp[4] = {255,255,252,0};                          
  uint8_t macdhcp[6] = {0x00,0x08,0xDC,0x11,0x22,0x86};         
ipconfig
  
}
*/
void     loopback_tcps(SOCKET s, uint16 port, uint8* buf, uint16 mode)
{
   uint32 len;
   
   switch(getSn_SSR(s))                // check SOCKET status
   {                                   // ------------
      case SOCK_ESTABLISHED:           // ESTABLISHED?
         if(getSn_IR(s) & Sn_IR_CON)   // check Sn_IR_CON bit
         {
            //printf("%d : Connect OK\r\n",s);
            setSn_IR(s,Sn_IR_CON);     // clear Sn_IR_CON
         }
         if((len=getSn_RX_RSR(s)) > 0) // check the size of received data
         {
            len = recv(s,buf,len);     // recv
            if(len !=send(s,buf,len))  // send
            {
               //printf("%d : Send Fail.len=%d\r\n",s,len);
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
      //printf("%d : LOOPBACK_TCPS(%d) Started.\r\n",s,port);
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
           // printf("%d : Connect OK\r\n",s);
            setSn_IR(s,Sn_IR_CON);        // clear Sn_IR_CON
         }
         if((len=getSn_RX_RSR(s)) > 0)    // check the size of received data
         {
            len = recv(s,buf,len);        // recv
            if(len !=send(s,buf,len))     // send
            {
               //printf("%d : Send Fail.len=%d\r\n",s,len);
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
      //printf("%d : LOOPBACK_TCPC(%d.%d.%d.%d:%d) Started.\r\n",s,addr[0],addr[1],addr[2],addr[3],port);
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
               //printf("%d : Sendto Fail.len=%d,",s,len);
               //printf("%d.%d.%d.%d(%d)\r\n",destip[0],destip[1],destip[2],destip[3],destport);
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


void Delay(__IO uint32_t nTime)
{
  while(nTime != 0)
  {
    nTime--;
    asm("nop");
  }
}


void WriteReg(uint16_t address, uint16_t data)
{
  *(uint16_t *) (SRAM_BANK_ADDR + address*2) = data;
}

uint16_t ReadReg(uint16_t address)
{
  return *(uint16_t *) (SRAM_BANK_ADDR + address*2);
}

/*
  setMR(getMR()|MR_FS);            
  setSHAR(mac);                                   // set source hardware address
  setGAR(gw);                                     // set gateway IP address
  setSUBR(sn);                                    // set subnet mask address
  setSIPR(ip);                                    // set source IP address      
  
  getSHAR(mac);   // get source hardware address 
  getGAR(gw);     // get gateway IP address      
  getSUBR(sn);    // get subnet mask address     
  getSIPR(ip);    // get source IP address   
  
  if(!sysinit(tx_mem_conf,rx_mem_conf))           
  {
    while(1);
  }
  Delay(0xFFFFF);
  Delay(IINCHIP_READ(Sn_SSR(0)));
  //while(IINCHIP_READ((Sn_SSR(0))) != SOCK_INIT)
  {
    IINCHIP_WRITE(Sn_MR(0),1); // sets TCP mode 
    Delay(0xFFFF);
    IINCHIP_WRITE(Sn_PORTR(0),PORT_W5300);
    Delay(0xFFFF);
    IINCHIP_WRITE(Sn_CR(0),Sn_CR_OPEN); 
  }
  while( ((IINCHIP_READ(Sn_SSR(0)))&0xFF) != SOCK_INIT);
  
  IINCHIP_WRITE(Sn_DIPR(0), ((uint16)pcip[0]<<8)+(uint16)pcip[1]);
  IINCHIP_WRITE(Sn_DIPR2(0),((uint16)pcip[2]<<8)+(uint16)pcip[3]);
  IINCHIP_WRITE(Sn_PORTR(0),PORT_W5300);
  setSn_CR(0, PORT_W5300);

  data = IINCHIP_READ(MR);
  data_buf = (uint8*)0xA10F0000;  

*/


