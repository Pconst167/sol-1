/*****************************************************************************
* Copyright(C) 2011 Dong-A University MICCA
* All right reserved.
*
* File name	    : ethernet.c
* Last version	: 1.00
* Description	: This file is source file for ethernet control(w5300)
*
* History
* Date		    Version	    Author			Description
* 07/16/2011	1.00		oh woomin	    Created
*****************************************************************************/

/* Includes ----------------------------------------------------------------*/
#include <stdio.h>
#include <string.h>
#include "stm32f4xx.h"
#include "socket.h"
#include "types.h"
//#include "typedef.h"
#include "ethernet.h"

extern u16 FontColor, BgColor;







uint8 bufferTx[2048];
uint8 bufferRx[2048];

void LoopbackTcps(SOCKET s, uint16 port, uint8* buf, uint16 mode)
{
    uint32 len = 0;
    while(len<sizeof(buf))
    {
      bufferTx[len]=buf[len];
      len++;
    }
    len = 0;
    switch(getSn_SSR(s))                    // check SOCKET status
    {                                       // ------------
        case SOCK_ESTABLISHED:              // ESTABLISHED?
            if(getSn_IR(s) & Sn_IR_CON)     // check Sn_IR_CON bit
            {
                setSn_IR(s,Sn_IR_CON);      // clear Sn_IR_CON Connect Ok
            }
            if((len=getSn_RX_RSR(s)) > 0)   // check the size of received data
            {
                len = recv(s,bufferRx,len);      // recv                                   
                if(len !=send(s,bufferTx,len))   // send 
                { //Send Fail
       
                }
                
                if(len>70) *(buf+70) = '\0';
                else *(buf+len) = '\0';
                

            }
            break;
        // ---------------
        case SOCK_CLOSE_WAIT:               // PASSIVE CLOSED
            disconnect(s);                  // disconnect 
            break;
        // --------------
        case SOCK_CLOSED:                   // CLOSED
            close(s);                       // close the SOCKET
            socket(s,Sn_MR_TCP,port,mode);  // open the SOCKET  
            break;
        // ------------------------------
        case SOCK_INIT:                     // The SOCKET opened with TCP mode
            listen(s);                      // listen to any connection request from "TCP CLIENT"
            break;
        default:
            break;
    }
}

/**
 * "TCP CLIENT" loopback program.
 */ 
void LoopbackTcpc(SOCKET s, uint8* addr, uint16 port, uint8* buf, uint16 mode)
{
    uint32 len;
    static uint16 any_port = 1000;
    
    switch(getSn_SSR(s))                            // check SOCKET status
    {                                               // ------------
        case SOCK_ESTABLISHED:                      // ESTABLISHED?
            if(getSn_IR(s) & Sn_IR_CON)             // check Sn_IR_CON bit
            {
                setSn_IR(s,Sn_IR_CON);              // clear Sn_IR_CON
            }
            if((len=getSn_RX_RSR(s)) > 0)           // check the size of received data
            {
                len = recv(s,buf,len);              // recv
                if(len !=send(s,buf,len))           // send
                {
   
                }
            }
            break;
            // ---------------
        case SOCK_CLOSE_WAIT:                       // PASSIVE CLOSED
            disconnect(s);                          // disconnect 
            break;
            // --------------
        case SOCK_CLOSED:                           // CLOSED
            close(s);                               // close the SOCKET
            socket(s,Sn_MR_TCP,any_port++,mode);    // open the SOCKET with TCP mode and any source port number
            break;
            // ------------------------------
        case SOCK_INIT:                             // The SOCKET opened with TCP mode
            connect(s, addr, port);                 // Try to connect to "TCP SERVER"
            break;
        default:
            break;
    }
}

/**
 * UDP loopback program.
 */ 
void LoopbackUdp(SOCKET s, uint16 port, uint8* buf, uint16 mode)
{
    uint32 len;
    uint8 destip[4];
    uint16 destport;
    
    switch(getSn_SSR(s))
    {
        // -------------------------------
        case SOCK_UDP:                                      // 
            if((len=getSn_RX_RSR(s)) > 0)                   // check the size of received data
            {
                len = recvfrom(s,buf,len,destip,&destport); // receive data from a destination
                if(len !=sendto(s,buf,len,destip,destport)) // send the data to the destination
                {
                    //vPrintf(UART1_SERIAL, "%d : Sendto Fail.len=%d,",s,len);
                    //vPrintf(UART1_SERIAL, "%d.%d.%d.%d(%d)\r\n",destip[0],destip[1],destip[2],destip[3],destport);
                }
                                
                if(len>70) *(buf+70) = '\0';
                else *(buf+len) = '\0';
                

            }
            break;
        // -----------------
        case SOCK_CLOSED:                                   // CLOSED
            close(s);                                       // close the SOCKET
            socket(s,Sn_MR_UDP,port,mode);                  // open the SOCKET with UDP mode
            break;
        default:
            break;
    }
}                
