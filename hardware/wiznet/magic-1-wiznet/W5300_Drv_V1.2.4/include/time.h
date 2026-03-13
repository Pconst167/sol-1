/////////////////////////////////////////////////////////////////////////////////
// Copyright(c) 2001-2002 Hybus Co,.ltd. All rights reserved.
//  
// Module name:
//      main.c
//  
// Description:
//  
//  
// Author:
//      bedguy
//  
// Created:
//      2002.10
//
///////////////////////////////////////////////////////////////////////////////

#ifndef _TIME_H_416463482947123749237434
#define _TIME_H_416463482947123749237434

#include "types.h"

#define HZ						(1)

#define RCNR					 (*(volatile ulong *)(0x40900000))


// Prototypes.
void	TimerInit(void);
ulong	GetTime(void);

#endif		// end _TIME_H_416463482947123749237434.
