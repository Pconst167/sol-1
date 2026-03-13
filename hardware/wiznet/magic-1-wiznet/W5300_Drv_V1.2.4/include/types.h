#ifndef _TYPE_H_
#define _TYPE_H_
/**
 * \file    types.h
 * Type Definition of Variables.
 *
 * The simple data types supported by the W5300 programs are used to define function return values,
 * function and message parameters, and structure members.
 * They define the size and meaning of these elements.
 *
 */


typedef char int8;                        /**< The 8-bit signed data type. */

typedef volatile char vint8;              /**< The volatile 8-bit signed data type. */
                                           
typedef unsigned char uint8;              /**< The 8-bit unsigned data type. */
                                           
typedef volatile unsigned char vuint8;    /**< The volatile 8-bit unsigned data type. */
                                           
typedef short int16;                      /**< The 16-bit signed data type. */
                                           
typedef volatile short vint16;            /**< The volatile 16-bit signed data type. */
                                           
typedef unsigned short uint16;            /**< The 16-bit unsigned data type. */
                                           
typedef volatile unsigned short vuint16;  /**< The volatile 16-bit unsigned data type. */
                                           
typedef long int32;                       /**< The 32-bit signed data type. */
                                           
typedef volatile long vint32;             /**< The volatile 32-bit signed data type. */
                                           
typedef unsigned long uint32;             /**< The 32-bit unsigned data type. */
                                           
typedef volatile unsigned long vuint32;   /**< The volatile 32-bit unsigned data type. */

/**
 * The SOCKET data type.
 */
typedef uint8 SOCKET;


typedef unsigned long	ulong;
typedef unsigned short	ushort;
typedef unsigned char	uchar;
typedef unsigned int    uint;

#ifndef __cplusplus
typedef int				bool;
#define	true			1
#define false			0
#endif

// print in hex value.
// type= 8 : print in format "ff".
// type=16 : print in format "ffff".
// type=32 : print in format "ffffffff".
typedef enum {
	VAR_LONG=32,
	VAR_SHORT=16,
	VAR_CHAR=8
} VAR_TYPE;

#ifndef NULL
#define NULL (void *)0
#endif

#endif		/* _TYPE_H_ */
