#include "main.h"
#include "dhcp.h"
void copya(uint8_t* buf1,uint8_t* buf2, uint32_t lenght);
uint32   Read_FSMC(SOCKET s, uint8* buf,uint32 len);
uint32   Send_FSMC(SOCKET s, uint8* buf,uint32 len);
uint32   Read_FSMC2(SOCKET s, uint8* buf,uint32 len);
volatile uint16_t ID  = 0;
volatile uint16_t PORT_PC = 15000;//80;
volatile uint16_t PORT_W5300 = 15000;//80;
uint8_t pcip[4] = {192,168,8,82}; 
uint8_t chat[10] ={'L','A','B','A','S',' ',':',')',13,10};

/* USB LAN*/
uint8 ip[4] = {192,168,11,199};      //  192.168.11.250                
uint8 gw[4] = {192,168,11,249};     //{192,168,11,1};                    
uint8 sn[4] = {255,255,255,0};      //  192.168.11.249                  
uint8 mac[6] = {0x00,0x08,0xDC,0x00,0x6F,0xC8}; 
/* */
/*Local LAN      
uint8 ip[4] = {192,168,8,199};      //  192.168.11.250                
uint8 gw[4] = {192,168,11,1};     //{192,168,11,1};                    
uint8 sn[4] = {255,255,255,0};      //  192.168.11.249                  
uint8 mac[6] = {0x00,0x08,0xDC,0x00,0x6F,0xC8}; */

uint8 ip_temp[6] = {0,0,0,0,0,0}; 

uint8 data_buf[16384];
uint8 data_buf2[16384];
uint32_t update = 0;
uint32_t Rx_count = 0;
uint32_t snreg = 0;
uint32_t Rx_count_total = 0;
uint32_t packet_count = 0;
uint8_t increment[65536];
uint32_t increment2[2048];
volatile uint32_t disconnectreg = 0;
uint32_t TxpacketCount = 0;
uint16_t TxSendcount = 10;
uint16_t memtype  = 0 ;
extern uint16 sendokreg;
uint8_t htmll[] = " HTTP/1.1 200 OK\n Date: Mon, 27 Jul 2009 12:28:53 GMT\nServer: Apache/2.2.14 (Win32)\nLast-Modified: Wed, 22 Jul 2009 19:15:56 GMT\nContent-Length: 88\nContent-Type: text/html\nConnection: Closed\n\n<html>\n<body>\n<h1>Hello, World!</h1>\n</body>\n</html>\n";
void main()
{
  SRAM_Init(); 
  update = 0;
  while(update<65536)
  {
    increment[update]= 'a';
    update++;
  }
  increment[65534]= 'b';
  increment[65535]= '\n';
  update = 0;
  ID = getIDR(); 
  Delay(0xFFFFFF);

  uint8 tx_mem_conf[8] = {64,0,0,0,0,0,0,0};          
  uint8 rx_mem_conf[8] = {64,0,0,0,0,0,0,0}; 
  iinchip_init();  
  if(!sysinit(tx_mem_conf,rx_mem_conf))           
  {
    while(1);
  }
  setMR(getMR()|MR_FS);                            // If Little-endian, set MR_FS.
  Delay(Rx_count);
  
  setSHAR(mac);                                   // set source hardware address
  setGAR(gw);                                     // set gateway IP address
  setSUBR(sn);                                    // set subnet mask address
  setSIPR(ip);   
 
  getSHAR(ip_temp);
  while((mac[0]+mac[1]+mac[2]+mac[3]+mac[4]+mac[5])!=(ip_temp[0]+ip_temp[1]+ip_temp[2]+ip_temp[3]+ip_temp[4]+ip_temp[5]))
  {
    setSHAR(mac);  
    Delay(0xFFFF);
    getSHAR(ip_temp);
  }
  getSIPR(ip_temp); 
  while((ip[0]+ip[1]+ip[2]+ip[3])!=(ip_temp[0]+ip_temp[1]+ip_temp[2]+ip_temp[3]))
  {
    setSIPR(ip);  
    Delay(0xFFFF);
    getSIPR(ip_temp);
  }
  getSUBR(ip_temp);       
  while((sn[0]+sn[1]+sn[2]+sn[3])!=(ip_temp[0]+ip_temp[1]+ip_temp[2]+ip_temp[3]))
  {
    setSUBR(sn);
    Delay(0xFFFF);
    getSUBR(ip_temp);
  }
  getGAR(ip_temp);
  while((gw[0]+gw[1]+gw[2]+gw[3])!=(ip_temp[0]+ip_temp[1]+ip_temp[2]+ip_temp[3]))
  {
    setGAR(gw);  
    Delay(0xFFFF);
    getGAR(ip_temp);
  }
  getSHAR(mac);         // get source hardware address 
  getGAR(gw);           // get gateway IP address      
  getSUBR(sn);          // get subnet mask address     
  getSIPR(ip);          // get source IP address         
  setRTR(100);                                 // Timout 200ms 0x07D0
  setRCR(10);
  setIMR(1);
  setSn_TTLR(0,128);
  //DHCP_init();
  //DHCP_run();
  while((IINCHIP_READ((Sn_SSR(0)))&0xFF) != SOCK_INIT)
  {
    close(0);
    IINCHIP_WRITE(Sn_MR(0),(Sn_MR_TCP+Sn_MR_ALIGN + Sn_MR_IGMPv)) ;
    Delay(0xFFF);
    IINCHIP_WRITE(Sn_PORTR(0),PORT_W5300);
    Delay(0xFFF);
    setSn_CR(0, Sn_CR_OPEN); 
  }
  Delay(0xFFFF);
  
 Delay(0xFFFF);
 while(IINCHIP_READ(Sn_SSR(0))== SOCK_ESTABLISHED )
 setSn_IR(0,Sn_IR_CON);
  
 while(listen(0)==0);
 setSn_IR(0,0xFF);
 update = getSn_IR(0);
 memtype = IINCHIP_READ(0x30);
 while(1)
 {
   sendokreg = getSn_IR(0);
   if(disconnectreg!=0)
   {
     snreg = 0;
     disconnectreg = 0;
   }
   else
   {
     snreg = getSn_SSR(0);
   }
    switch(snreg)               
   {                                                                    
    case SOCK_CLOSE_WAIT:               
      disconnect(0);                
      break;

    case SOCK_CLOSED:                   
      close(0);     
      TxpacketCount = 0;
      socket(0,Sn_MR_TCP,PORT_W5300,(Sn_MR_TCP+Sn_MR_ALIGN + Sn_MR_IGMPv)); 
      break;
                                       
   case SOCK_INIT:                    
      listen(0);                      
      break;
   case SOCK_LISTEN:
     packet_count = 0;
     Rx_count_total = 0;  
   default: break;
   }
   
  update = getSn_TX_FSR(0);
  Rx_count=getSn_RX_RSR(0);
  if(Rx_count!=0)
  {
    Rx_count_total+=Rx_count;
    //recv(0,data_buf,Rx_count);
    Read_FSMC2(0, data_buf, Rx_count);
    setSn_CR(0,Sn_CR_RECV);

    if((data_buf[0] == 'S')&(data_buf[1] == 'T'))
      TxpacketCount = 1;
    if((data_buf[0] == 'S')&(data_buf[1] == 'P'))
      TxpacketCount = 0;
    
    if((data_buf[0] == 'B')&(data_buf[1] == 'S'))
      TxSendcount = data_buf[2]*256 +data_buf[3] ;
    
    data_buf[0] = data_buf[1] = data_buf[2] = data_buf[3] = 0;
      

  }
  if(TxpacketCount!=0)
  {
    send(0, increment,TxSendcount);
    TxpacketCount++;
  }
 }
}


         
         
uint32 idx =0;
uint32   Read_FSMC(SOCKET s, uint8* buf,uint32 len)
{
  uint32_t pointer  = 0;
  //idx = 0;
  while(pointer < len)
  {
    *((uint16*)(buf+idx)) = IINCHIP_READ(Sn_RX_FIFOR(s));
    idx+=2;
    pointer+=2;
    if(pointer ==8190)
    {
      idx = 0;
    }
  }
  return len;
}

uint32   Read_FSMC2(SOCKET s, uint8* buf,uint32 len)
{
  uint16_t pointer  = 0;
  while(pointer < len)
  {
    *((uint16*)(pointer+buf)) = IINCHIP_READ(Sn_RX_FIFOR(s));
    pointer+=2;
  }
  return len;
}

uint32_t temp1212 = 0;

uint32   Send_FSMC(SOCKET s, uint8* buf,uint32 len)
{
  
  temp1212 = getSn_IR(s);
  setSn_IR(0,Sn_IR_SENDOK);
  temp1212 = getSn_IR(s);
  for (uint32 idx = 0; idx < len; idx+=2)
  {
    IINCHIP_WRITE(Sn_TX_FIFOR(s),*((uint16*)(buf+idx))); 
  }
  //setSn_IR(0, Sn_IR_SENDOK); 
  Delay(100);
  setSn_TX_WRSR(0,(len));
  Delay(100);
  setSn_CR(0,Sn_CR_SEND);
  temp1212 = getSn_IR(s);
  return 1;
}

void Delay(__IO uint32_t nTime)
{
  while(nTime != 0)
  {
    nTime--;
    asm("nop");
  }
}

volatile void loopback_tcps(SOCKET s, uint16 port, uint8* buf, uint16 mode)
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
            len = recv(s,buf,len); 
            Rx_count = len;    // recv
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
      break;
   default:
      break;
   }
}


volatile void   loopback_tcpc(SOCKET s, uint8* addr, uint16 port, uint8* buf, uint16 mode)//"TCP CLIENT" loopback program.
{
   uint32 len;
   static uint16 any_port = 1000;
   
   switch(getSn_SSR(s))                   // check SOCKET status
   {                                      // ------------
      case SOCK_ESTABLISHED:              // ESTABLISHED?
         if(getSn_IR(s) & Sn_IR_CON)      // check Sn_IR_CON bit
         {
            //printf("%d : Connect OK\r\n",s);
            setSn_IR(s,Sn_IR_CON);        // clear Sn_IR_CON
         }
         if((len=getSn_RX_RSR(s)) > 0)    // check the size of received data
         {
            len = recv(s,buf,len);  
            Rx_count = len;      // recv
            if(len !=send(s,buf,len));     // send Fail
                 
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
      break;
   default:
      break;
   }
  }


volatile void     loopback_udp(SOCKET s, uint16 port, uint8* buf, uint16 mode) // UDP loopback program.
{
   uint32 len;
   uint16 destport;
   
   switch(getSn_SSR(s))
   {
                                                         // -------------------------------
      case SOCK_UDP:                                     // 
         if((len=getSn_RX_RSR(s)) > 0)                   // check the size of received data
         {
   
            len = recvfrom(s,buf,len,pcip,&destport);
            
            Rx_count = len;// receive data from a destination
            //if(len !=sendto(s,buf,len,pcip,destport))  // send the data to the destination
            {/*Bad Connection*/}
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

/*
    if(data_buf[0] ==0x47)
    {
      memset(data_buf,0,strlen(data_buf));
      send(0, htmll,sizeof(htmll));
      while (!((getSn_IR(0)) & Sn_IR_SENDOK))  // wait previous SEND command completion.
      {
         if ((getSn_SSR(0)&0xFF) == SOCK_CLOSED)    // check timeout or abnormal closed.
         {
            break;
         }
      }
      disconnect(0); 
    }

  //Send_FSMC(0,chat,10);
  if(Rx_count_total!=0)
  {
    Send_FSMC(0,chat,10);
    TxpacketCount++;
//Delay(0xFFFF);
    if(GPIO_ReadInputDataBit(GPIOA,1)==1) 
    {
      //Send_FSMC(0,chat,10);
      send(0, chat,10);
      if(getSn_IR(0) & Sn_IR_CON)     setSn_IR(0,Sn_IR_CON);   
      while(GPIO_ReadInputDataBit(GPIOA,1)==1)
      {
         update = 1;
      }
        update = 0; 
      }
*/
    
