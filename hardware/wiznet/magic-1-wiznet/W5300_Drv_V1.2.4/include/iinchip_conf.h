#ifndef	_IINCHIP_CONF_H_
#define	_IINCHIP_CONF_H_

/**
 * \file    iinchip_conf.h
 * W5300 Configuration & Defintions
 *
 * This file defines some compile options of the W5300 program 
 * and code dependency of a target host system. \n \n
 */

 
//#define __DEF_IINCHIP_DBG__      /**< Involves debug code */
//#define __DEF_IINCHIP_INT__    /**< Involves ISR routine */
//#define __DEF_IINCHIP_PPP__    /**< Involves PPP service routines and md5.h & md5.c */

/**
 * SOCKET count of W5300 
 */
#define	MAX_SOCK_NUM		8


#define __DEF_IINCHIP_DIRECT_MODE__     1    /**< Direct address mode */
#define __DEF_IINCHIP_INDIRECT_MODE__   2    /**< Indirect address mode */

/**
 * It is used to decide to W5300 host interface mode. 
 */
#define __DEF_IINCHIP_ADDRESS_MODE__           __DEF_IINCHIP_DIRECT_MODE__
//#define __DEF_IINCHIP_ADDRESS_MODE__         __DEF_IINCHIP_INDIRECT_MODE__

/**
 * Define the base address of W5300 on your target host system.
 */
#define __DEF_IINCHIP_MAP_BASE__ 0x08000000

#if (__DEF_IINCHIP_ADDRESS_MODE__ == __DEF_IINCHIP_DIRECT_MODE__)
   #define COMMON_REG_BASE   __DEF_IINCHIP_MAP_BASE__          /**< The base address of COMMON_REG */
   #define SOCKET_REG_BASE   __DEF_IINCHIP_MAP_BASE__ + 0x0200 /**< The base address of SOCKET_REG */   
#else
   #define COMMON_REG_BASE     0                               
   #define SOCKET_REG_BASE     0x0200                          
#endif

#define SOCKET_REG_SIZE    0x40     // SOCKET Regsiter Count per Channel




#define __DEF_C__                  0   /**< Using C code */
#define __DEF_MCU_DEP_INLINE_ASM__ 1   /**< Using inline ASM code */
#define __DEF_MCU_DEP_DMA__        2   /**< Using DMA controller */



/**
 * It define how to access to the intenal TX/RX memory of W5300.
 */
#define __DEF_IINCHIP_BUF_OP__      __DEF_C__
//#define __DEF_IINCHIP_BUF_OP__    __DEF_MCU_DEP_INLINE_ASM__
//#define __DEF_IINCHIP_BUF_OP__    __DEF_MCU_DEP_DMA__


/**
 * Enter a critical section
 */
#define IINCHIP_CRITICAL_SECTION_ENTER() {}

/**
 * Exit a critical section
 */
#define IINCHIP_CRITICAL_SECTION_EXIT() {}


#endif