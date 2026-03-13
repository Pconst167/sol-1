#include "stm32f429_sram.h"
#include "stm32f4xx.h"

extern void Delay(__IO uint32_t nTime);
void SRAM_Init(void)
{
  RCC_AHB1PeriphClockCmd(RCC_AHB1Periph_GPIOE|RCC_AHB1Periph_GPIOA, ENABLE);
  
  GPIO_InitTypeDef      GPIO_InitStructure;
  
  GPIO_InitStructure.GPIO_Pin = GPIO_Pin_0;
  GPIO_InitStructure.GPIO_Mode = GPIO_Mode_IN;
  //GPIO_InitStructure.GPIO_Speed = GPIO_Speed_100MHz;
  GPIO_InitStructure.GPIO_OType = GPIO_OType_PP;
  //GPIO_InitStructure.GPIO_PuPd  = GPIO_PuPd_DOWN;
  GPIO_Init(GPIOA, &GPIO_InitStructure);
  
  GPIO_InitStructure.GPIO_Pin = GPIO_Pin_0;
  GPIO_InitStructure.GPIO_Mode = GPIO_Mode_OUT;
  GPIO_InitStructure.GPIO_Speed = GPIO_Speed_100MHz;
  GPIO_InitStructure.GPIO_OType = GPIO_OType_PP;
  GPIO_InitStructure.GPIO_PuPd  = GPIO_PuPd_DOWN;
  GPIO_Init(GPIOE, &GPIO_InitStructure);
  
  GPIO_InitStructure.GPIO_Pin = GPIO_Pin_4|GPIO_Pin_6;
  GPIO_InitStructure.GPIO_Mode = GPIO_Mode_OUT;
  GPIO_InitStructure.GPIO_Speed = GPIO_Speed_100MHz;
  GPIO_InitStructure.GPIO_OType = GPIO_OType_PP;
  GPIO_InitStructure.GPIO_PuPd  = GPIO_PuPd_DOWN;
  GPIO_Init(GPIOA, &GPIO_InitStructure);

  GPIOE->BSRRH = GPIO_Pin_0; // RESET Low
  Delay(0xFFFFFF);
  GPIOE->BSRRL = GPIO_Pin_0; // RESET High
  Delay(0xFFFFFF);
  
  
  
  
  FMC_NORSRAMInitTypeDef  FMC_NORSRAMInitStructure;
  FMC_NORSRAMTimingInitTypeDef  NORSRAMTimingStructure;
  
  /* GPIO configuration for FMC SRAM bank */
  SRAM_GPIOConfig();
  
  /* Enable FMC clock */
  RCC_AHB3PeriphClockCmd(RCC_AHB3Periph_FMC, ENABLE); 

/* FMC Configuration ---------------------------------------------------------*/
  /* SRAM Timing configuration */
  NORSRAMTimingStructure.FMC_AddressSetupTime = 5;
  NORSRAMTimingStructure.FMC_AddressHoldTime = 0;
  NORSRAMTimingStructure.FMC_DataSetupTime = 5;
  NORSRAMTimingStructure.FMC_BusTurnAroundDuration = 0;
  NORSRAMTimingStructure.FMC_CLKDivision = 1;
  NORSRAMTimingStructure.FMC_DataLatency = 0;
  NORSRAMTimingStructure.FMC_AccessMode = FMC_AccessMode_A; 

  /* FMC SRAM control configuration */
  FMC_NORSRAMInitStructure.FMC_Bank = FMC_Bank1_NORSRAM1;
  FMC_NORSRAMInitStructure.FMC_DataAddressMux = FMC_DataAddressMux_Disable;
  FMC_NORSRAMInitStructure.FMC_MemoryType = FMC_MemoryType_SRAM;
  FMC_NORSRAMInitStructure.FMC_MemoryDataWidth = SRAM_MEMORY_WIDTH;
  FMC_NORSRAMInitStructure.FMC_BurstAccessMode = SRAM_BURSTACCESS; 
  FMC_NORSRAMInitStructure.FMC_AsynchronousWait = FMC_AsynchronousWait_Disable;  
  FMC_NORSRAMInitStructure.FMC_WaitSignalPolarity = FMC_WaitSignalPolarity_Low;
  FMC_NORSRAMInitStructure.FMC_WrapMode = FMC_WrapMode_Disable;
  FMC_NORSRAMInitStructure.FMC_WaitSignalActive = FMC_WaitSignalActive_BeforeWaitState;
  FMC_NORSRAMInitStructure.FMC_WriteOperation = FMC_WriteOperation_Enable;
  FMC_NORSRAMInitStructure.FMC_WaitSignal = FMC_WaitSignal_Disable;
  FMC_NORSRAMInitStructure.FMC_ExtendedMode = FMC_ExtendedMode_Disable;
  FMC_NORSRAMInitStructure.FMC_WriteBurst = SRAM_WRITEBURST;
  FMC_NORSRAMInitStructure.FMC_ContinousClock = CONTINUOUSCLOCK_FEATURE;
  FMC_NORSRAMInitStructure.FMC_ReadWriteTimingStruct = &NORSRAMTimingStructure;
  FMC_NORSRAMInitStructure.FMC_WriteTimingStruct = &NORSRAMTimingStructure;

  /* SRAM configuration */
  FMC_NORSRAMInit(&FMC_NORSRAMInitStructure); 

  /* Enable FMC Bank1_SRAM2 Bank */
  FMC_NORSRAMCmd(FMC_Bank1_NORSRAM1, ENABLE); 
  
}
/*
PD7 -> CS
PD5 -> WE
PD4 -> RD
*/


void SRAM_GPIOConfig(void)
{
  GPIO_InitTypeDef GPIO_InitStructure; 
  
  RCC_AHB1PeriphClockCmd(RCC_AHB1Periph_GPIOD | RCC_AHB1Periph_GPIOE | RCC_AHB1Periph_GPIOF |RCC_AHB1Periph_GPIOG | RCC_AHB1Periph_GPIOH | RCC_AHB1Periph_GPIOI, ENABLE);
  
/*-- GPIOs Configuration -----------------------------------------------------*/
/*
 +-------------------+--------------------+--------------------+--------------------+
 +                       SRAM pins assignment                                       +                                
 +-------------------+--------------------+--------------------+--------------------+
 | PD0  <-> FMC_D2   | PE0  <-> FMC_NBL0  | PF0  <-> FMC_A0    | PG0 <-> FMC_A10    | 
 | PD1  <-> FMC_D3   | PE1  <-> FMC_NBL1  | PF1  <-> FMC_A1    | PG1 <-> FMC_A11    | 
 | PD3  <-> FMC_CLK  | PE3  <-> FMC_A19   | PF2  <-> FMC_A2    | PG2 <-> FMC_A12    |
 | PD4  <-> FMC_NOE  | PE4  <-> FMC_A20   | PF3  <-> FMC_A3    | PG3 <-> FMC_A13    |   
 | PD5  <-> FMC_NWE  | PE7  <-> FMC_D4    | PF4  <-> FMC_A4    | PG4 <-> FMC_A14    |  
 | PD8  <-> FMC_D13  | PE8  <-> FMC_D5    | PF5  <-> FMC_A5    | PG5 <-> FMC_A15    |  
 | PD9  <-> FMC_D14  | PE9  <-> FMC_D6    | PF12 <-> FMC_A6    | PG9 <-> FMC_NE2/3  | 
 | PD10 <-> FMC_D15  | PE10 <-> FMC_D7    | PF13 <-> FMC_A7    |--------------------+ 
 | PD11 <-> FMC_A16  | PE11 <-> FMC_D8    | PF14 <-> FMC_A8    |
 | PD12 <-> FMC_A17  | PE12 <-> FMC_D9    | PF15 <-> FMC_A9    |                     
 | PD13 <-> FMC_A18  | PE13 <-> FMC_D10   |--------------------+                     
 | PD14 <-> FMC_D0   | PE14 <-> FMC_D11   |                     
 | PD15 <-> FMC_D1   | PE15 <-> FMC_D12   | 
 +-------------------+--------------------+   
		                					 
*/ 

  /* Common GPIO configuration */
  GPIO_InitStructure.GPIO_Mode = GPIO_Mode_AF;
  GPIO_InitStructure.GPIO_Speed = GPIO_Speed_100MHz;
  GPIO_InitStructure.GPIO_OType = GPIO_OType_PP;
  GPIO_InitStructure.GPIO_PuPd  = GPIO_PuPd_NOPULL;
  
  /* GPIOD configuration */
  GPIO_PinAFConfig(GPIOD, GPIO_PinSource0, GPIO_AF_FMC);        // PD0  <-> FMC_D2 
  GPIO_PinAFConfig(GPIOD, GPIO_PinSource1, GPIO_AF_FMC);        // PD1  <-> FMC_D3
  //GPIO_PinAFConfig(GPIOD, GPIO_PinSource3, GPIO_AF_FMC);        // PD3  <-> FMC_CLK 
  GPIO_PinAFConfig(GPIOD, GPIO_PinSource4, GPIO_AF_FMC);        // PD4  <-> FMC_NOE
  GPIO_PinAFConfig(GPIOD, GPIO_PinSource5, GPIO_AF_FMC);        // PD5  <-> FMC_NWE
  GPIO_PinAFConfig(GPIOD, GPIO_PinSource8, GPIO_AF_FMC);        // PD8  <-> FMC_D13
  GPIO_PinAFConfig(GPIOD, GPIO_PinSource9, GPIO_AF_FMC);        // PD9  <-> FMC_D14
  GPIO_PinAFConfig(GPIOD, GPIO_PinSource10, GPIO_AF_FMC);       // PD10 <-> FMC_D15 
  //GPIO_PinAFConfig(GPIOD, GPIO_PinSource11, GPIO_AF_FMC);       // PD11 <-> FMC_A16 
  //GPIO_PinAFConfig(GPIOD, GPIO_PinSource12, GPIO_AF_FMC);       // PD12 <-> FMC_A17
  //GPIO_PinAFConfig(GPIOD, GPIO_PinSource13, GPIO_AF_FMC);       // PD13 <-> FMC_A18
  GPIO_PinAFConfig(GPIOD, GPIO_PinSource14, GPIO_AF_FMC);       // PD14 <-> FMC_D0
  GPIO_PinAFConfig(GPIOD, GPIO_PinSource15, GPIO_AF_FMC);       // PD15 <-> FMC_D1
  GPIO_PinAFConfig(GPIOD, GPIO_PinSource7, GPIO_AF_FMC);       // PD15 <-> FMC_CS
  GPIO_InitStructure.GPIO_Pin = GPIO_Pin_0|GPIO_Pin_1|GPIO_Pin_4|GPIO_Pin_5|GPIO_Pin_7|GPIO_Pin_8|GPIO_Pin_9|GPIO_Pin_10|GPIO_Pin_14|GPIO_Pin_15;//GPIO_Pin_3|GPIO_Pin_11|GPIO_Pin_12|GPIO_Pin_13|

  GPIO_Init(GPIOD, &GPIO_InitStructure);

  /* GPIOE configuration */
  //GPIO_PinAFConfig(GPIOE, GPIO_PinSource0 , GPIO_AF_FMC);       // PE0  <-> FMC_NBL0
  //GPIO_PinAFConfig(GPIOE, GPIO_PinSource1 , GPIO_AF_FMC);       // PE1  <-> FMC_NBL1
  //GPIO_PinAFConfig(GPIOE, GPIO_PinSource3 , GPIO_AF_FMC);       // PE3  <-> FMC_A19
 // GPIO_PinAFConfig(GPIOE, GPIO_PinSource4 , GPIO_AF_FMC);       // PE4  <-> FMC_A20 
  GPIO_PinAFConfig(GPIOE, GPIO_PinSource7 , GPIO_AF_FMC);       // PE7  <-> FMC_D4 
  GPIO_PinAFConfig(GPIOE, GPIO_PinSource8 , GPIO_AF_FMC);       // PE8  <-> FMC_D5
  GPIO_PinAFConfig(GPIOE, GPIO_PinSource9 , GPIO_AF_FMC);       // PE9  <-> FMC_D6
  GPIO_PinAFConfig(GPIOE, GPIO_PinSource10 , GPIO_AF_FMC);      // PE10 <-> FMC_D7
  GPIO_PinAFConfig(GPIOE, GPIO_PinSource11 , GPIO_AF_FMC);      // PE11 <-> FMC_D8
  GPIO_PinAFConfig(GPIOE, GPIO_PinSource12 , GPIO_AF_FMC);      // PE12 <-> FMC_D9 
  GPIO_PinAFConfig(GPIOE, GPIO_PinSource13 , GPIO_AF_FMC);      // PE13 <-> FMC_D10 
  GPIO_PinAFConfig(GPIOE, GPIO_PinSource14 , GPIO_AF_FMC);      // PE14 <-> FMC_D11
  GPIO_PinAFConfig(GPIOE, GPIO_PinSource15 , GPIO_AF_FMC);      // PE15 <-> FMC_D12

  GPIO_InitStructure.GPIO_Pin = GPIO_Pin_7|GPIO_Pin_8|GPIO_Pin_9|GPIO_Pin_10|GPIO_Pin_11|GPIO_Pin_12|GPIO_Pin_13|GPIO_Pin_14|GPIO_Pin_15;//GPIO_Pin_0|GPIO_Pin_1|GPIO_Pin_3|GPIO_Pin_4|
  GPIO_Init(GPIOE, &GPIO_InitStructure);
  
  /*-- GPIOs Configuration -----------------------------------------------------*/
/*
 +-------------------+--------------------+--------------------+--------------------+
 +                       SRAM pins assignment                                       +                                
 +-------------------+--------------------+--------------------+--------------------+
 | PD0  <-> FMC_D2   | PE0  <-> FMC_NBL0  | PF0  <-> FMC_A0    | PG0 <-> FMC_A10    | 
 | PD1  <-> FMC_D3   | PE1  <-> FMC_NBL1  | PF1  <-> FMC_A1    | PG1 <-> FMC_A11    | 
 | PD3  <-> FMC_CLK  | PE3  <-> FMC_A19   | PF2  <-> FMC_A2    | PG2 <-> FMC_A12    |
 | PD4  <-> FMC_NOE  | PE4  <-> FMC_A20   | PF3  <-> FMC_A3    | PG3 <-> FMC_A13    |   
 | PD5  <-> FMC_NWE  | PE7  <-> FMC_D4    | PF4  <-> FMC_A4    | PG4 <-> FMC_A14    |  
 | PD8  <-> FMC_D13  | PE8  <-> FMC_D5    | PF5  <-> FMC_A5    | PG5 <-> FMC_A15    |  
 | PD9  <-> FMC_D14  | PE9  <-> FMC_D6    | PF12 <-> FMC_A6    | PG9 <-> FMC_NE2/3  | 
 | PD10 <-> FMC_D15  | PE10 <-> FMC_D7    | PF13 <-> FMC_A7    |--------------------+ 
 | PD11 <-> FMC_A16  | PE11 <-> FMC_D8    | PF14 <-> FMC_A8    |
 | PD12 <-> FMC_A17  | PE12 <-> FMC_D9    | PF15 <-> FMC_A9    |                     
 | PD13 <-> FMC_A18  | PE13 <-> FMC_D10   |--------------------+                     
 | PD14 <-> FMC_D0   | PE14 <-> FMC_D11   |                     
 | PD15 <-> FMC_D1   | PE15 <-> FMC_D12   | 
 +-------------------+--------------------+   
		                					 
*/ 

  GPIO_PinAFConfig(GPIOF, GPIO_PinSource0 , GPIO_AF_FMC); // PF0  <-> FMC_A0
  GPIO_PinAFConfig(GPIOF, GPIO_PinSource1 , GPIO_AF_FMC); // PF1  <-> FMC_A1
  GPIO_PinAFConfig(GPIOF, GPIO_PinSource2 , GPIO_AF_FMC); // PF2  <-> FMC_A2
  GPIO_PinAFConfig(GPIOF, GPIO_PinSource3 , GPIO_AF_FMC); // PF3  <-> FMC_A3
  GPIO_PinAFConfig(GPIOF, GPIO_PinSource4 , GPIO_AF_FMC); // PF4  <-> FMC_A4
  GPIO_PinAFConfig(GPIOF, GPIO_PinSource5 , GPIO_AF_FMC); // PF5  <-> FMC_A5 
  GPIO_PinAFConfig(GPIOF, GPIO_PinSource12 , GPIO_AF_FMC);// PF12 <-> FMC_A6
  GPIO_PinAFConfig(GPIOF, GPIO_PinSource13 , GPIO_AF_FMC);// PF13 <-> FMC_A7
  GPIO_PinAFConfig(GPIOF, GPIO_PinSource14 , GPIO_AF_FMC);// PF14 <-> FMC_A8
  GPIO_PinAFConfig(GPIOF, GPIO_PinSource15 , GPIO_AF_FMC);// PF15 <-> FMC_A9
  GPIO_InitStructure.GPIO_Pin = GPIO_Pin_0|GPIO_Pin_1|GPIO_Pin_2|GPIO_Pin_3|GPIO_Pin_4|GPIO_Pin_5|GPIO_Pin_12|GPIO_Pin_13|GPIO_Pin_14|GPIO_Pin_15;      
  GPIO_Init(GPIOF, &GPIO_InitStructure);

  /*
  GPIO_PinAFConfig(GPIOG, GPIO_PinSource0 , GPIO_AF_FMC);
  GPIO_PinAFConfig(GPIOG, GPIO_PinSource1 , GPIO_AF_FMC);
  GPIO_PinAFConfig(GPIOG, GPIO_PinSource2 , GPIO_AF_FMC);
  GPIO_PinAFConfig(GPIOG, GPIO_PinSource3 , GPIO_AF_FMC);
  GPIO_PinAFConfig(GPIOG, GPIO_PinSource4 , GPIO_AF_FMC);
  GPIO_PinAFConfig(GPIOG, GPIO_PinSource5 , GPIO_AF_FMC);
  GPIO_PinAFConfig(GPIOG, GPIO_PinSource9 , GPIO_AF_FMC); 
  GPIO_InitStructure.GPIO_Pin = GPIO_Pin_0|GPIO_Pin_1|GPIO_Pin_2|GPIO_Pin_3|GPIO_Pin_4|GPIO_Pin_5|GPIO_Pin_9;      
  GPIO_Init(GPIOG, &GPIO_InitStructure);*/
}


void SRAM_WriteBuffer(uint16_t* pBuffer, uint32_t uwWriteAddress, uint32_t uwBufferSize)
{
  __IO uint32_t write_pointer = (uint32_t)uwWriteAddress;
  
  /* while there is data to write */
  for (; uwBufferSize != 0; uwBufferSize--) 
  {
    /* Transfer data to the memory */
    *(uint16_t *) (SRAM_BANK_ADDR + write_pointer) = *pBuffer++;

    /* Increment the address*/
    write_pointer += 2;
  }
}


void SRAM_ReadBuffer(uint16_t* pBuffer, uint32_t uwReadAddress, uint32_t uwBufferSize)
{
  __IO uint32_t write_pointer = (uint32_t)uwReadAddress;
  
  for (; uwBufferSize != 0; uwBufferSize--)
  {
    /* Read a half-word from the memory */
    *pBuffer++ = *(__IO uint16_t*) (SRAM_BANK_ADDR + write_pointer);

    /* Increment the address*/
    write_pointer += 2;
  }
}

