#include "main.h"
#include "fatfs.h"
#include "socket.h"
#include "w5300.h"
uint32_t  Read_FSMC(SOCKET s, uint8* buf,uint32 len);
uint32_t ID  = 0;
uint8_t data_buf[65536];
uint8_t data_bufTx[100];
uint8_t ip_temp[6]      = {0,0,0,0,0,0}; 
uint8 ip[4]  = {192,168,0,199};      //  192.168.11.250                
uint8 gw[4]  = {192,168,0,1};     //{192,168,11,1};                    
uint8 sn[4]  = {255,255,255,0};      //  192.168.11.249                             
uint8_t mc[6]= {0x00,0x08,0xDC,0x00,0x6F,0xC8};
volatile uint32_t disconnectreg = 0;
uint32_t snreg = 0;
uint32_t TxpacketCount = 0;
uint16_t TxSendcount = 10;
uint16_t PORT_W5300 = 80;
uint32_t update = 0;
uint32_t Rx_count = 0;
uint32_t packet_count = 0;
uint32_t Rx_count_total = 0;

volatile uint32_t FMC_ERR  = 0;
volatile uint32_t FMC_ADR_R  = 0xFE;
volatile uint32_t FMC_ADR_W = 0xFE;
volatile uint32_t FMC_R  = 0; // 22.2222MHz
volatile uint32_t FMC_W  = 0;// 40MHz

volatile uint32_t REGISTER_ADDRESS = 0;
volatile uint32_t REGISTER_DATA = 0;
volatile uint32_t REGISTER_DATA_R = 0;
void main()
{
 
  Button_IRQ_Config();
  LED_Config();
  UFL_Config();
  SRAM_Init();
  NVIC_Config();
  if(LAN_init()==1)
    while(1);
  

  while(1)
  {
    if(disconnectreg==1)
    {
      snreg = 0;
      disconnectreg = 0;
    }
    else
    {
      snreg = getSn_SSR(0);
    }
    if(snreg==0x17)
    {
      LED3_OFF;
      LED4_ON;
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
        update = listen(0); 
        if(update == 0)
        {
          close(0);
          disconnect(0); 
          socket(0,Sn_MR_TCP,PORT_W5300,(Sn_MR_TCP+Sn_MR_ALIGN + Sn_MR_IGMPv)); 
        }
        break;
     case SOCK_LISTEN:
       packet_count = 0;
       Rx_count_total = 0;
       LED3_ON;
       LED4_OFF;
     default: break;
    
    case SOCK_ESTABLISHED:
       {
          Rx_count=getSn_RX_RSR(0);
          if(Rx_count!=0)
          {

            Read_FSMC(0, data_buf, Rx_count);
            if(data_buf[0]==170)
            {
              LED1_ON;
              REGISTER_ADDRESS = data_buf[2]*(1<<24) + data_buf[3]*(1<<16) + data_buf[4]*(1<<8) + data_buf[5];
              REGISTER_DATA    = data_buf[6]*(1<<24) + data_buf[7]*(1<<16) + data_buf[8]*(1<<8) + data_buf[9];
              if(data_buf[1]==10)
              {
                 *(uint32_t *) (Bank1_SRAM1_ADDR + REGISTER_ADDRESS*4) = REGISTER_DATA;
              }
              if(data_buf[1]==20)
              {
                REGISTER_DATA_R = *(uint32_t *) (Bank1_SRAM1_ADDR + REGISTER_ADDRESS*4);
                data_bufTx[0]=180;
                data_bufTx[1]=REGISTER_DATA_R/16777216;
                data_bufTx[2]=REGISTER_DATA_R/65536;
                data_bufTx[3]=REGISTER_DATA_R/256;
                data_bufTx[4]=REGISTER_DATA_R&0xFF;
                data_bufTx[5]=0;
                send(0, data_bufTx,6);          
              }
              LED1_OFF;
            }
            if(data_buf[0]==171)
            {
              LED2_ON;
              REGISTER_ADDRESS = data_buf[2]*(1<<24) + data_buf[3]*(1<<16) + data_buf[4]*(1<<8) + data_buf[5];
              REGISTER_DATA    = data_buf[6]*(1<<24) + data_buf[7]*(1<<16) + data_buf[8]*(1<<8) + data_buf[9];
              if(data_buf[1]==10)
              {
                 *(uint32_t *) (Bank1_SRAM3_ADDR + REGISTER_ADDRESS*4) = REGISTER_DATA;
              }
              if(data_buf[1]==20)
              {
                REGISTER_DATA_R = *(uint32_t *) (Bank1_SRAM3_ADDR + REGISTER_ADDRESS*4);
                data_bufTx[0]=181;
                data_bufTx[1]=REGISTER_DATA_R/16777216;
                data_bufTx[2]=REGISTER_DATA_R/65536;
                data_bufTx[3]=REGISTER_DATA_R/256;
                data_bufTx[4]=REGISTER_DATA_R&0xFF;
                data_bufTx[5]=0;
                send(0, data_bufTx,6);          
              }
              LED2_OFF;
            }
            if(data_buf[0]==190)
            {
              LED5_ON;
              uint32_t counter_sdram = 0;
              while(counter_sdram<16777216)
              {
                *(uint32_t *) (Bank1_SRAM3_ADDR + counter_sdram*4) = counter_sdram;
                counter_sdram++;
                
              }
              counter_sdram  = 0;
              FMC_ERR =0;
              while(counter_sdram<16777216)
              {
                if((*(uint32_t *) (Bank1_SRAM3_ADDR + counter_sdram*4))!=counter_sdram)
                {
                  FMC_ERR++;
                }
                Delay(10);
                counter_sdram++;
              }
                data_bufTx[0]=183;
                data_bufTx[1]=FMC_ERR/16777216;
                data_bufTx[2]=FMC_ERR/65536;
                data_bufTx[3]=FMC_ERR/256;
                data_bufTx[4]=FMC_ERR&0xFF;
                data_bufTx[5]=0;
                send(0, data_bufTx,6);   
              LED5_OFF;
            }          
          }  
       }
    }       
   }
}


volatile uint32_t difference = 0;
void SysTick_Handler(void)
{
  static uint32_t systiccounter = 0;
  static uint32_t alive_old = 0;
  static uint32_t reconect_timeout = 0;
  if(snreg==0x17)
  {
    systiccounter++;
  }
  if(Rx_count_total == alive_old)
  {
    if(systiccounter>1500)
    {
      disconnectreg = 1;
      reconect_timeout++;
      systiccounter = 0;
      IINCHIP_WRITE(Sn_SSR(0),0);
      close(0);
    }
  }
  else
  {
    systiccounter =0;
  }
  difference = Rx_count_total-alive_old;
  alive_old = Rx_count_total;
}


uint32_t  Read_FSMC(SOCKET s, uint8* buf,uint32 len)
{
  uint32_t pointer  = 0;
  while(pointer < len)
  {
    *((uint16*)(pointer+buf)) = IINCHIP_READ(Sn_RX_FIFOR(s));
    pointer+=2;
  }
  setSn_CR(0,Sn_CR_RECV);
  return len;
}













/*

FATFS fs[1];       
FIL  ftxt;     
char buffer[20];   
FRESULT res;         
UINT bw;  
uint32_t file_number = 0;

volatile uint32_t FMC_ERR  = 0;
volatile uint32_t FMC_ADR_R  = 0xFE;
volatile uint32_t FMC_ADR_W = 0xFE;
volatile uint32_t FMC_R  = 0; // 22.2222MHz
volatile uint32_t FMC_W  = 0;// 40MHz

int main(void)
{
  
  
  
  
  
  
  Button_IRQ_Config();
  LED_Config();
  UFL_Config();
  SRAM_Init();
  NVIC_Config();
  LED1_OFF;
  FMC_ERR = 0;
  while(1)
  {
    *(uint32_t *) (Bank1_SRAM2_ADDR+FMC_ADR_W*4)  = FMC_W;
    asm("nop");
    asm("nop");
    asm("nop");
    Delay(3);
    if(FMC_W ==FMC_R)
      asm("nop");
      
    FMC_R = *(uint32_t *) (Bank1_SRAM2_ADDR+FMC_ADR_R*4);
    asm("nop");
    asm("nop");
    if(FMC_W ==FMC_R)
      asm("nop");
    Delay(2);
  }
    
  f_mount(&fs[0],"",(BYTE)0);
      
  while(1)
  {
    
    LED1_ON;
    Paint_to_SD();
    LED1_OFF;     
    LED2_ON;
    Paint_to_SD();
    LED2_OFF;  
    LED3_ON;
    Paint_to_SD();
    LED3_OFF;  
    LED4_ON;
    Paint_to_SD();
    LED4_OFF;  
    LED5_ON;
    Paint_to_SD();
    LED5_OFF;   
  }


  
}


void Paint_to_SD(void)
{
  file_number++;
  
  memset(&buffer[0], 0, sizeof(buffer));
  sprintf(buffer,"0:%d.txt",file_number);
  res = f_open(&ftxt, buffer, FA_CREATE_ALWAYS | FA_WRITE); 
    //sprintf(buffer,"%d\n",cnt);
  res = f_write(&ftxt, message, strlen(message), &bw);   
  f_close(&ftxt);
}
*/

void EXTI15_10_IRQHandler(void)//SW2
{
  if(EXTI_GetITStatus(EXTI_Line10) != RESET)
  {
    LED1_ON;
    //Paint_to_SD();
    LED1_OFF;
    EXTI_ClearITPendingBit(EXTI_Line10);
  }
}


void EXTI9_5_IRQHandler(void)//SW1
{
  if(EXTI_GetITStatus(EXTI_Line5) != RESET)
  {
    EXTI_ClearITPendingBit(EXTI_Line5);
  }
}

#ifdef  USE_FULL_ASSERT
void assert_failed(uint8_t* file, uint32_t line)
{ 
  while (1)
  {
  }
}
#endif



