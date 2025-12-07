DOWNLOADED FROM WARD CHRISTENSEN'S BOARD AT (312) 849-1132
		   ON 2/13/85 23:30 PST


Msg 00006 is 99 line(s) on 01/16/85 from JOHN BYRNS
to ALL re: MODEM PROTOCOL (CONT):CRC

(really, 221 lines - but 99 is max in hdr)
MODEM PROTOCOL OVERVIEW,  CRC OPTION ADDENDUM

1/13/85 by John Byrns.
Please pass on any reports of errors in this document or suggestions
for improvement to me via Ward's/CBBS at (312) 849-1132, or by voice
at (312) 885-1105.

Last Rev: (preliminary	1/13/85)

This document describes the changes to the Christensen Modem Protocol
that implement the CRC option. This document is an addendum to
Ward Christensen's "Modem Protocol Overview". This document and
Ward's document are both required  for a complete description of the
Modem Protocol.

	Table of Contents

1.  DEFINITIONS
7.  OVERVIEW OF CRC OPTION
8.  MESSAGE BLOCK LEVEL PROTOCOL, CRC MODE
9.  CRC CALCULATION
10. FILE LEVEL PROTOCOL, CHANGES FOR COMPATIBILITY
11. DATA FLOW EXAMPLES WITH CRC OPTION


---- 1B. ADDITIONAL DEFINITIONS

<C>	43H

-------- 7. OVERVIEW OF CRC OPTION

The CRC used in the Modem Protocol is an alternate form of block check
which provides more robust error detection than the original checksum.
Andrew S. Tanenbaum says in his book, Computer Networks, that the
CRC-CCITT used by the Modem Protocol will detect all single and double
bit errors, all errors with an odd number of bits, all burst errors of
length 16 or less, 99.997% of 17-bit error bursts, and 99.998% of
18-bit and longer bursts.

The changes to the Modem Protocol to replace the checksum with the CRC
are straight forward. If that were all that we did we would not be
able to communicate between a program using the old checksum protocol
and one using the new CRC protocol. An initial handshake was added to
solve this problem. The handshake allows a receiving program with CRC
capability to determine whether the sending program supports the CRC
option, and to switch it to CRC mode if it does. This handshake is
designed so that it will work properly with programs which implement
only the original protocol. A description of this handshake is
presented in section 10.

-------- 8. MESSAGE BLOCK LEVEL PROTOCOL, CRC MODE

 Each block of the transfer in CRC mode looks like:
<SOH><blk #><255-blk #><--128 data bytes--><CRC hi><CRC lo>
    in which:
<SOH>		  = 01 hex
<blk #>     = binary number, starts at 01 increments by 1, and
	      wraps 0FFH to 00H (not to 01)
<255-blk #> = ones complement of blk #.
<CRC hi>    = byte containing the 8 hi order coefficients of the CRC.
<CRC lo>    = byte containing the 8 lo order coefficients of the CRC.
	      See the next section for CRC calculation.

-------- 9. CRC CALCULATION

---- 9A. FORMAL DEFINITION OF THE CRC CALCULATION

To calculate the 16 bit CRC the message bits are considered to be the
coefficients of a polynomial. This message polynomial is first
multiplied by X^16 and then divided by the generator polynomial
(X^16 + X^12 + X^5 + 1) using modulo two arithemetic. The remainder
left after the division is the desired CRC. Since a message block in
the Modem Protocol is 128 bytes or 1024 bits, the message polynomial
will be of order X^1023. The hi order bit of the first byte of the
message block is the coefficient of X^1023 in the message polynomial.
The lo order bit of the last byte of the message block is the
coefficient of X^0 in the message polynomial.

---- 9B. EXAMPLE OF CRC CALCULATION WRITTEN IN C

/*
This function calculates the CRC used by the "Modem Protocol"
The first argument is a pointer to the message block. The second
argument is the number of bytes in the message block. The message
block used by the Modem Protocol contains 128 bytes.
The function return value is an integer which contains the CRC. The
lo order 16 bits of this integer are the coefficients of the CRC. The
The lo order bit is the lo order coefficient of the CRC.
*/

int calcrc(ptr, count) char *ptr; int count; {

    int crc, i;

    crc = 0;
    while(--count >= 0) {
	crc = crc ^ (int)*ptr++ << 8;
	for(i = 0; i < 8; ++i)
	    if(crc & 0x8000)
		crc = crc << 1 ^ 0x1021;
	    else
		crc = crc << 1;
	}
    return (crc & 0xFFFF);
    }

-------- 10. FILE LEVEL PROTOCOL, CHANGES FOR COMPATIBILITY

---- 10A. COMMON TO BOTH SENDER AND RECEIVER:

The only change to the File Level Protocol for the CRC option is the
initial handshake which is used to determine if both the sending and
the receiving programs support the CRC mode. All Modem Programs should
support the checksum mode for compatibility with older versions.
A receiving program that wishes to receive in CRC mode implements the
mode setting handshake by sending a <C> in place of the initial <nak>.
If the sending program supports CRC mode it will recognize the <C> and
will set itself into CRC mode, and respond by sending the first block
as if a <nak> had been received. If the sending program does not
support CRC mode it will not respond to the <C> at all. After the
receiver has sent the <C> it will wait up to 3 seconds for the <soh>
that starts the first block. If it receives a <soh> within 3 seconds
it will assume the sender supports CRC mode and will proceed with the
file exchange in CRC mode. If no <soh> is received within 3 seconds
the receiver will switch to checksum mode, send a <nak>, and proceed
in checksum mode. If the receiver wishes to use checksum mode it
should send an initial <nak> and the sending program should respond to
the <nak> as defined in the original Modem Protocol. After the mode
has been set by the initial <C> or <nak> the protocol follows the
original Modem Protocol and is identical whether the checksum or CRC
is being used.

---- 10B. RECEIVE PROGRAM CONSIDERATIONS:

There are at least 4 things that can go wrong with the mode setting
handshake.
  1. the initial <C> can be garbled or lost.
  2. the initial <soh> can be garbled.
  3. the initial <C> can be changed to a <nak>.
  4. the initial <nak> from a receiver which wants to receive in
     checksum can be changed to a <C>.

The first problem can be solved if the receiver sends a second <C>
after it times out the first time. This process can be repeated
several times. It must not be repeated a too many times before sending
a <nak> and switching to checksum mode or a sending program without
CRC support may time out and abort. Repeating the <C> will also fix
the second problem if the sending program cooperates by responding as
if a <nak> were received instead of ignoring the extra <C>.

It is possible to fix problems 3 and 4 but probably not worth the
trouble since they will occur very infrequently. They could be fixed
by switching modes in either the sending or the receiving program
after a large number of successive <nak>s. This solution would risk
other problems however.

---- 10C. SENDING PROGRAM CONSIDERATIONS.

The sending program should start in the checksum mode. This will
insure compatibility with checksum only receiving programs. Anytime a
<C> is received before the first <nak> or <ack> the sending program
should set itself into CRC mode and respond as if a <nak> were
received. The sender should respond to additional <C>s as if they were
<nak>s until the first <ack> is received. This will assist the
receiving program in determining the correct mode when the <soh> is
lost or garbled. After the first <ack> is received the sending program
should ignore <C>s.

-------- 11. DATA FLOW EXAMPLES WITH CRC OPTION

---- 11A. RECEIVER HAS CRC OPTION, SENDER DOESN'T

Here is a data flow example for the case where the receiver requests
transmission in the CRC mode but the sender does not support the CRC
option. This example also includes various transmission errors.
<xx> represents the checksum byte.

SENDER					RECEIVER
			<---		<C>
				times out after 3 seconds,
			<---		<nak>
<soh> 01 FE -data- <xx> --->
			<---		<ack>
<soh> 02 FD -data- <xx> --->	(data gets line hit)
			<---		<nak>
<soh> 02 FD -data- <xx> --->
			<---		<ack>
<soh> 03 FC -data- <xx> --->
   (ack gets garbaged)	<---		<ack>
				times out after 10 seconds,
			<---		<nak>
<soh> 03 FC -data- <xx> --->
			<---		<ack>
<eot>			--->
			<---		<ack>

---- 11B. RECEIVER AND SENDER BOTH HAVE CRC OPTION

Here is a data flow example for the case where the receiver requests
transmission in the CRC mode and the sender supports the CRC option.
This example also includes various transmission errors.
<xxxx> represents the 2 CRC bytes.

SENDER					  RECEIVER
			  <---		  <C>
<soh> 01 FE -data- <xxxx> --->
			  <---		  <ack>
<soh> 02 FD -data- <xxxx> --->	  (data gets line hit)
			  <---		  <nak>
<soh> 02 FD -data- <xxxx> --->
			  <---		  <ack>
<soh> 03 FC -data- <xxxx> --->
   (ack gets garbaged)	  <---		  <ack>
				  times out after 10 seconds,
			  <---		  <nak>
<soh> 03 FC -data- <xxxx> --->
			  <---		  <ack>
<eot>			  --->
			  <---		  <ack>
--End of 00006

Msg #: to retrieve (C/R when done)?
