
#ifndef __STM32429__SRAM_H
#define __STM32429__SRAM_H

#ifdef __cplusplus
 extern "C" {
#endif


//#include "stm324x9i_eval.h"

#define SRAM_BANK_ADDR  ((uint32_t)0x60000000)  
  
/**
  * @brief  FMC SRAM Memory Width
  */  
#define SRAM_MEMORY_WIDTH    FMC_NORSRAM_MemoryDataWidth_16b


#define SRAM_BURSTACCESS    FMC_BurstAccessMode_Disable  
/* #define SRAM_BURSTACCESS    FMC_BurstAccessMode_Enable*/


#define SRAM_WRITEBURST    FMC_WriteBurst_Disable  
/* #define SRAM_WRITEBURST   FMC_WriteBurst_Enable */


//#define CONTINUOUSCLOCK_FEATURE    FMC_CClock_SyncOnly 
#define CONTINUOUSCLOCK_FEATURE     FMC_CClock_SyncAsync 


void  SRAM_Init(void);
void  SRAM_GPIOConfig(void);
//void  SRAM_WriteBuffer(uint16_t* pBuffer, uint32_t uwWriteAddress, uint32_t uwBufferSize);
//void  SRAM_ReadBuffer(uint16_t* pBuffer, uint32_t uwReadAddress, uint32_t uwBufferSize);

#ifdef __cplusplus
}
#endif

#endif

