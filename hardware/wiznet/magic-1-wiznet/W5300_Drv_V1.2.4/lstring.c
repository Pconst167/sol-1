/////////////////////////////////////////////////////////////////////////////////
// Copyright(c) 2001-2002 Hybus Co,.ltd. All rights reserved.
//
// Module name:
//      lstring.c
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


#include "stdarg.h"
#include "lstring.h"

static void PrintChar(char *fmt, char c);
static void PrintDec(char *fmt, int value);
static void PrintHex(char *fmt, uint value);
static void PrintString(char *fmt, char *cptr);
static int Power(int num, int cnt);


void MemCpy32(void *dest, void *src, int numWords){
	volatile long *s1=dest, *s2=src;
	while(numWords--) {
		*s1++ = *s2++;
	}
	return;
}	// MemCpy32.


void MemCpy(void *dest, void *src, int cnt){
	char *s1=dest, *s2=src, *endptr=(char *)dest+cnt;
	
	while (s1<endptr)
		*s1++ = *s2++;
	return;
}	// MemCpy.


void MemSet(void *dest, char c, int len){
	char *s=dest;
	char *limit = (char *)dest+len;

	while (s < limit) *s++ = c;
}	// MemSet.


int MemCmp(void *addr1, void *addr2, int len){
	volatile char *s1=addr1, *s2=addr2;
	volatile char *endptr = (char*)addr1+len;

	while ((ulong)s1 < (ulong)endptr){
		if (*s1++ != *s2++) return *(--s1) - *(--s2);
	}
	return 0;
}	// MemCmp.


void StrCpy(char *dest, char *src){
	volatile char *s1=dest, *s2=src;
	
	while (*s2!=0) *s1++ = *s2++;
	*s1 = 0;
	return;
}	// StrCpy.


int StrLen(char *dest){
	volatile char *tmp = dest;

	if (!tmp) return -1;
	while (*tmp!=0) tmp++;
	return (tmp - dest);
}	// StrLen.


int StrNCmp(char *s1, char *s2, int len){
	int i;

	for(i = 0; i < len; i++){
		if(s1[i] != s2[i])	return ((int)s1[i]) - ((int)s2[i]);
		if(s1[i] == 0)		return 0;
	}
	return 0;
} // StrNCmp.


int StrCmp(char *s1, char *s2){
	for (; *s1 && *s2; s1++, s2++){
		if (*s1 != *s2) return ((int)(*s1) - (int)(*s2));
	}
	if (*s1 || *s2) return ((int)(*s1) - (int)(*s2));
	return 0;
}	// StrCmp.


bool HexToInt(char *s, void *retval, VAR_TYPE type){
	char	c;
	int		i;
	long	rval;

	if (!s || !retval) return false;
	if (!StrNCmp(s, "0x", 2)) s+=2;
	// fine int value.
	for (i=0, rval=0; i<type/4; i++){
		if (*s=='\0'){
			if (i==0) return false;
			else      break;
		}
		c = *s++;

		if      (c>='0' && c<='9') c-='0';
		else if (c>='a' && c<='f') c=c-'a'+10;
		else if (c>='A' && c<='F') c=c-'A'+10;
		else    return false;

		rval = rval<<4 | c;
	}
	// make retval.
	switch (type){
		case 8 :
			*(char *)retval = (char)rval;
			break;
		case 16 :
			*(short *)retval = (short)rval;
			break;
		case 32 :
			*(long *)retval = (long)rval;
			break;
		default :
			return false;
	}
	return true;
}	// HexToInt.


bool DecToLong(char *s, long *retval){
	long remainder;
	if (!s || !s[0]) return false;

	for (*retval=0; *s; s++){
		if (*s < '0' || *s > '9') return false;
		remainder = *s - '0';
		*retval = *retval * 10 + remainder;
	}

	return true;
}	// DecToLong.


void HexDump(char *addr, int len){
	char	*s=addr, *endPtr=(char *)((long)addr+len);
	int		i, remainder=len%16;
	
	printf("\n");
	printf("Offset      Hex Value                                        Ascii value\n");
	
	// print out 16 byte blocks.
	while (s+16<=endPtr){
		// offset 출력.
		printf("0x%08lx  ", (long)(s-addr));
		// 16 bytes 단위로 내용 출력.
		for (i=0; i<16; i++){
			printf("%02x ", s[i]);
		}
		printf(" ");
		for (i=0; i<16; i++){
			if		(s[i]>=32 && s[i]<=125)	printf("%c", s[i]);
			else							printf(".");
		}
		s += 16;
		printf("\n");
	}
	
	// Print out remainder.
	if (remainder){
		// offset 출력.
		printf("0x%08lx  ", (long)(s-addr));
		// 16 bytes 단위로 출력하고 남은 것 출력.
		for (i=0; i<remainder; i++){
			printf("%02x ", s[i]);
		}
		for (i=0; i<(16-remainder); i++){
			printf("   ");
		}
		printf(" ");
		for (i=0; i<remainder; i++){
			if		(s[i]>=32 && s[i]<=125)	printf("%c", s[i]);
			else							printf(".");
		}
		for (i=0; i<(16-remainder); i++){
			printf(" ");
		}
		printf("\n");
	}
	return;
}	// HexDump.


void printf(char *fmt, ...){

	int		i;
	va_list args;
	char	*s=fmt;
	char	format[10];		// fmt의 인자가 "%08lx"라면, "08l"를 임시로 기록.
	
	va_start(args, fmt);
	while (*s){
		if (*s=='%'){
			s++;
			// s에서 "%08lx"형식을 가져와 format에 기록. 나중에 출력함수에 넘겨줌.
			format[0] = '%';
			for (i=1; i<10;){
				if (*s=='c' || *s=='d' || *s=='x' || *s=='s' || *s=='%'){
					format[i++] = *s;
					format[i] = '\0';
					break;
				}
				else {
					format[i++] = *s++;
				}
			}
			// "%s", "%c", "%d", "%x"를 찾아 출력할 함수 호출.
			switch (*s++){
				case 'c' :
					PrintChar(format, va_arg(args, int));
					break;
				case 'd' :
					PrintDec(format, va_arg(args, int));
					break;
				case 'x' :
					PrintHex(format, va_arg(args, int));
					break;
				case 's' :
					PrintString(format, va_arg(args, char *));
					break;
				case '%' :
					PrintChar("%c", '%');
					break;
			}
		}
		else {
			PrintChar("%c", *s);
			s++;
		}
	}
	va_end(args);
	return;
/*
	va_list args;
	static char printf_buf[512];
	int i;

	va_start(args, fmt);
	i = vsnprintf(printf_buf, sizeof(printf_buf), fmt, args);
	va_end(args);
	PrintString("%s",printf_buf);
	//return i;
	return ;
*/	
}


void PrintChar(char *fmt, char c){
	SerialOutputByte(c);
	return;
}


void PrintDec(char *fmt, int l){
	int		i, j;
	char	c, *s=fmt, tol[10];
	bool	flag0=false, flagl=false;	// "%08lx"에서 '0', 'l'의 존재 여부.
	long	flagcnt=0;					// "%08lx"에서 "8"을 찾아서 long형으로.
	bool	leading_zero=true;			// long형의 data를 출력하기 위한 변수.
	long	divisor, result, remainder;

	// fmt의 "%08lx"에서 '0', '8', 'l'을 해석.
	for (i=0; (c=s[i]); i++){
		if (c=='d') break;
		else if (c>='1' && c<='9'){
			for (j=0; s[i]>='0' && s[i]<='9'; j++){
				tol[j] = s[i++];
			}
			tol[j] = '\0';
			i--;
			DecToLong(tol, &flagcnt);
		}
		else if (c=='0') flag0=true;
		else if (c=='l') flagl=true;
		else continue;
	}

	// 위의 flag에 따라 출력.
	if (flagcnt){
		if (flagcnt>9) flagcnt=9;
		remainder = l%(Power(10, flagcnt));	// flagcnt보다 윗자리의 수는 걸러냄. 199에 flagcnt==2이면, 99만.

		for (divisor=Power(10, flagcnt-1); divisor>0; divisor/=10){
			result = remainder/divisor;
			remainder %= divisor;

			if (result!=0 || divisor==1) leading_zero = false;

			if (leading_zero==true){
				if (flag0)	SerialOutputByte('0');
				else		SerialOutputByte(' ');
			}
			else SerialOutputByte((char)(result)+'0');
		}
	} else {
		remainder = l;

		for (divisor=1000000000; divisor>0; divisor/=10){
			result = remainder/divisor;
			remainder %= divisor;

			if (result!=0 || divisor==1) leading_zero = false;
			if (leading_zero==false) SerialOutputByte((char)(result)+'0');
		}
	}
	return;
}


void PrintHex(char *fmt, uint l){
	int		i, j;
	char	c, tol[10];
	uchar *s=(uchar*)fmt;
	bool	flag0=false, flagr=false, flagl=false;	// flags.
	long	flagcnt=0;
	bool	leading_zero=true;
	char	uHex, lHex;
	int		cnt;						// "%5x"의 경우 5개만 출력하도록 출력한 개수.

	// fmt의 "%08l(L)x"에서 '0', '8', 'l', 'L'을 해석.
	for (i=0; (c=s[i]); i++){
		if (c=='x') break;
		else if (c>='1' && c<='9'){
			for (j=0; s[i]>='0' && s[i]<='9'; j++){
				tol[j] = s[i++];
			}
			tol[j] = '\0';
			i--;
			DecToLong(tol, &flagcnt);
		}
		else if (c=='0') flag0=true;
		else if (c=='r') flagr=true;  // SWAP
		else if (c=='l') flagl=true;  // Long Type
		else continue;
	}


 	s = (uchar *)(&l);
   if(!flagr) l = SWAP32(l);		   // little, big endian에 따라서.(big이 출력하기 쉬워 순서를 바꿈)
	 
	
	// 위의 flag에 따라 출력.
	if (flagcnt){
		if (flagcnt&0x01){	// flagcnt가 홀수 일때, upper를 무시, lower만 출력.
			c = s[(8-(flagcnt+1))/2]; // 홀수 일때 그 위치를 포함하는 곳의 값을 가져 옵니다.
			
			// lower 4 bits를 가져와서 ascii code로.
			lHex = ((c>>0)&0x0f);
			if (lHex!=0) leading_zero=false;
			if (lHex<10) lHex+='0';
			else         lHex+='A'-10;

			// lower 4 bits 출력.
			if (leading_zero){
				if (flag0) SerialOutputByte('0');
				else       SerialOutputByte(' ');
			}
			else SerialOutputByte(lHex);
			
			flagcnt--;
		}

		// byte단위의 data를 Hex로 출력.
		for (cnt=0, i=(8-flagcnt)/2; i<4; i++){
			c = s[i];
				
			// get upper 4 bits and lower 4 bits.
			uHex = ((c>>4)&0x0f);
			lHex = ((c>>0)&0x0f);

			// upper 4 bits and lower 4 bits to '0'~'9', 'A'~'F'.
			// upper 4 bits를 ascii code로.
			if (uHex!=0) leading_zero = false;
			if (uHex<10) uHex+='0';
			else         uHex+='A'-10;

			// upper 4 bits 출력.
			if (leading_zero){
				if (flag0) SerialOutputByte('0');
				else       SerialOutputByte(' ');
			}
			else SerialOutputByte(uHex);
			
			// lower 4 bits를 ascii code로.
			if (lHex!=0) leading_zero = false;
			if (lHex<10) lHex+='0';
			else         lHex+='A'-10;

			// lower 4 bits 출력.
			if (leading_zero){
				if (flag0) SerialOutputByte('0');
				else       SerialOutputByte(' ');
			}
			else SerialOutputByte(lHex);
		}
	}
	else {
		for (i=0; i<4; i++){
			c = s[i];
	
			// get upper 4 bits and lower 4 bits.
			uHex = ((c>>4)&0x0f);
			lHex = ((c>>0)&0x0f);

			// upper 4 bits and lower 4 bits to '0'~'9', 'A'~'F'.
			if (uHex!=0) leading_zero = false;
			if (uHex<10) uHex+='0';
			else         uHex+='A'-10;
			if (!leading_zero) SerialOutputByte(uHex);
			
			if (lHex!=0 || i==3) leading_zero = false;
			if (lHex<10) lHex+='0';
			else         lHex+='A'-10;
			if (!leading_zero) SerialOutputByte(lHex);
		}
	}
	return;
}


void PrintString(char *fmt, char *s){
	if (!fmt || !s) return;
	while (*s) SerialOutputByte(*s++);
	return;
}


int Power(int num, int cnt){
	long retval=num;
	cnt--;

	while (cnt--){
		retval *= num;
	}
	return retval;
}
