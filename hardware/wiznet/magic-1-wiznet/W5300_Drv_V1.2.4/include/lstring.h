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

#ifndef _LSTRING_H_467326478126341264324
#define _LSTRInG_H_467326478126341264324

#include "main.h"

void	MemCpy32(void *dest, void *src, int numWords);
void	HexDump(char *addr, int len);

int		StrCmp(char *s1, char *s2);
int		StrNCmp(char *s1, char *s2, int len);
void	MemCpy(void *dest, void *src, int len);
void	MemSet(void *dest, const char c, int len);
int		MemCmp(void *addr1, void *addr2, int len);
void	StrCpy(char *dest, char *src);
int		StrLen(char *str);

bool	HexToInt(char *s, void *retval, VAR_TYPE type);
int		DecToLong(char *s, long *retval);

void	printf(char *fmt, ...);

#endif		// end _LSTRING_H_467326478126341264324.
