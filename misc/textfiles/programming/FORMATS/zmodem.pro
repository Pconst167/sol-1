


	   The ZMODEM Inter Application	File Transfer Protocol

			      Chuck Forsberg

			   Omen	Technology Inc


	  A overview of	this document is available as ZMODEM.OV
			     (in ZMDMOV.ARC)
















		       Omen Technology Incorporated
		      The High Reliability Software

		   17505-V Northwest Sauvie Island Road
			  Portland Oregon 97231
			VOICE: 503-621-3406 :VOICE
		Modem: 503-621-3746 Speed 1200,2400,19200
		     Compuserve:70007,2304  GEnie:CAF
		    UUCP: ...!tektronix!reed!omen!caf
























Chapter	0	       Rev 8-3-87  Typeset 10-18-87			 1







Chapter	0		     ZMODEM Protocol				 2



1.  IIIINNNNTTTTEEEENNNNDDDDEEEEDDDD AAAAUUUUDDDDIIIIEEEENNNNCCCCEEEE

This document is intended for telecommunications managers, systems
programmers, and others	who choose and implement asynchronous file
transfer protocols over	dial-up	networks and related environments.


2.  WWWWHHHHYYYY	DDDDEEEEVVVVEEEELLLLOOOOPPPP	ZZZZMMMMOOOODDDDEEEEMMMM????

Since its development half a decade ago, the Ward Christensen MMMMOOOODDDDEEEEMMMM
protocol has enabled a wide variety of computer	systems	to interchange
data.  There is	hardly a communications	program	that doesn't at	least
claim to support this protocol,	now called XXXXMMMMOOOODDDDEEEEMMMM.

Advances in computing, modems and networking have spread the XMODEM
protocol far beyond the	micro to micro environment for which it	was
designed.  These application have exposed some weaknesses:

   o+ The awkward user interface	is suitable for	computer hobbyists.
     Multiple commands must be keyboarded to transfer each file.

   o+ Since commands must be given to both programs, simple menu	selections
     are not possible.

   o+ The short block length causes throughput to suffer	when used with
     timesharing systems, packet switched networks, satellite circuits,
     and buffered (error correcting) modems.

   o+ The 8 bit checksum	and unprotected	supervison allow undetected errors
     and disrupted file	transfers.

   o+ Only one file can be sent per command.  The file name has to be given
     twice, first to the sending program and then again	to the receiving
     program.

   o+ The transmitted file accumulates as many as 127 bytes of garbage.

   o+ The modification date and other file attributes are lost.

   o+ XMODEM requires _c_o_m_p_l_e_t_e 8	bit transparency, all 256 codes.  XMODEM
     will not operate over some	networks that use ASCII	flow control or
     escape codes.  Setting network transparency disables important
     control functions for the duration	of the call.

A number of other protocols have been developed	over the years,	but none
have proven satisfactory.

   o+ Lack of public domain documentation and example programs have kept
     proprietary protocols such	as RRRReeeellllaaaayyyy,,,, BBBBllllaaaasssstttt,,,, and others tightly bound
     to	the fortunes of	their suppliers.  These	protocols have not
     benefited from public scrutiny of their design features.



Chapter	2	       Rev 8-3-87  Typeset 10-18-87			 2







Chapter	2		     ZMODEM Protocol				 3



   o+ Link level	protocols such as XXXX....22225555,,,,	XXXX....PPPPCCCC,,,, and MMMMNNNNPPPP do not manage
     application to application	file transfers.

   o+ Link Level	protocols do not eliminate end-to-end errors.  Interfaces
     between error-free	networks are not necessarily error-free.
     Sometimes,	error-free networks aren't.

   o+ The KKKKeeeerrrrmmmmiiiitttt	protocol was developed to allow	file transfers in
     environments hostile to XMODEM.  The performance compromises
     necessary to accommodate traditional mainframe environments limit
     Kermit's efficiency.  Even	with completely	transparent channels,
     Kermit control character quoting limits the efficiency of binary file
     transfers to about	75 per cent.[1]

     A number of submodes are used in various Kermit programs, including
     different methods of transferring binary files.  Two Kermit programs
     will mysteriously fail to operate with each other if the user has not
     correctly specified these submodes.

     Kermit Sliding Windows ("SuperKermit") improves throughput	over
     networks at the cost of increased complexity.  SuperKermit	requires
     full duplex communications	and the	ability	to check for the presence
     of	characters in the input	queue, precluding its implementation on
     some operating systems.

     SuperKermit state transitions are encoded in a special language
     "wart" which requires a C compiler.

     SuperKermit sends an ACK packet for each data packet of 96	bytes
     (fewer if control characters are present).	 This reduces throughput
     on	high speed modems, from	1350 to	177 characters per second in one
     test.

A number of extensions to the XMODEM protocol have been	made to	improve
performance and	(in some cases)	the user interface.  They provide useful
improvements in	some applications but not in others.  XMODEM's unprotected
control	messages compromise their reliability.	Complex	proprietary
techniques such	as CCCCyyyybbbbeeeerrrrnnnneeeettttiiiicccc DDDDaaaattttaaaa RRRReeeeccccoooovvvveeeerrrryyyy((((TTTTMMMM))))[2] improve reliability,
but are	not universally	available.  Some of the	XMODEM mutant protocols
have significant design	flaws of their own.

 o+ XXXXMMMMOOOODDDDEEEEMMMM----kkkk uses 1024 byte blocks to reduce the	overhead from transmission
   delays by 87	per cent compared to XMODEM, but network delays	still


__________

 1. Some Kermit	programs support run length encoding.

 2. Unique to DSZ, ZCOMM, Professional-YAM and PowerCom




Chapter	2	       Rev 8-3-87  Typeset 10-18-87			 3







Chapter	2		     ZMODEM Protocol				 4



   degrade performance.	 Some networks cannot transmit 1024 byte packets
   without flow	control, which is difficult to apply without impairing the
   perfect transparency	required by XMODEM.  XMODEM-k adds garbage to
   received files.

 o+ YYYYMMMMOOOODDDDEEEEMMMM sends	the file name, file length, and	creation date at the
   beginning of	each file, and allows optional 1024 byte blocks	for
   improved throughput.	 The handling of files that are	not a multiple of
   1024	or 128 bytes is	awkward, especially if the file	length is not
   known in advance, or	changes	during transmission.  The large	number of
   non conforming and substandard programs claiming to support YMODEM
   further complicates its use.

 o+ YYYYMMMMOOOODDDDEEEEMMMM----gggg provides efficient batch file transfers, preserving	exact file
   length and file modification	date.  YMODEM-g	is a modification to
   YMODEM wherein ACKs for data	blocks are not used.  YMODEM-g is
   essentially insensitive to network delays.  Because it does not support
   error recovery, YMODEM-g must be used hard wired or with a reliable
   link	level protocol.	 Successful application	at high	speed requires
   cafeful attention to	transparent flow control.  When	YMODEM-g detects a
   CRC error, data transfers are aborted.  YMODEM-g is easy to implement
   because it closely resembles	standard YMODEM.

 o+ WWWWXXXXMMMMOOOODDDDEEEEMMMM,,,, SSSSEEEEAAAAlllliiiinnnnkkkk,,,, and MMMMEEEEGGGGAAAAlllliiiinnnnkkkk have applied a subset	of ZMODEM's
   techniques to "Classic XMODEM" to improve upon their	suppliers'
   previous offerings.	They provide good performance under ideal
   conditions.

Another	XMODEM "extension" is protocol cheating, such as Omen Technology's
OOOOvvvveeeerrrrTTTThhhhrrrruuuusssstttteeeerrrr((((TTTTMMMM)))) and OOOOvvvveeeerrrrTTTThhhhrrrruuuusssstttteeeerrrr IIIIIIII((((TTTTMMMM)))).  These improve XMODEM	throughput
under some conditions by compromising error recovery.

The ZMODEM Protocol corrects the weaknesses described above while
maintaining as much of XMODEM/CRC's simplicity and prior art as	possible.



3.  ZZZZMMMMOOOODDDDEEEEMMMM PPPPrrrroooottttooooccccoooollll DDDDeeeessssiiiiggggnnnn CCCCrrrriiiitttteeeerrrriiiiaaaa

The design of a	file transfer protocol is an engineering compromise
between	conflicting requirements:

3.1  EEEEaaaasssseeee ooooffff UUUUsssseeee

 o+ ZMODEM allows either	program	to initiate file transfers, passing
   commands and/or modifiers to	the other program.

 o+ File	names need be entered only once.

 o+ Menu	selections are supported.




Chapter	3	       Rev 8-3-87  Typeset 10-18-87			 4







Chapter	3		     ZMODEM Protocol				 5



 o+ Wild	Card names may be used with batch transfers.

 o+ Minimum keystrokes required to initiate transfers.

 o+ ZRQINIT frame sent by sending program can trigger automatic downloads.

 o+ ZMODEM can step down	to YMODEM if the other end does	not support
   ZMODEM.[1]

3.2  TTTThhhhrrrroooouuuugggghhhhppppuuuutttt

All file transfer protocols make tradeoffs between throughput,
reliability, universality, and complexity according to the technology and
knowledge base available to their designers.

In the design of ZMODEM, three applications deserve special attention.

  o+ Network applications with significant delays (relative to character
    transmission time) and low error rate

  o+ Timesharing	and buffered modem applications	with significant delays
    and	throughput that	is quickly degraded by reverse channel traffic.
    ZMODEM's economy of	reverse	channel	bandwidth allows modems	that
    dynamically	partition bandwidth between the	two directions to operate
    at optimal speeds.	Special	ZMODEM features	allow simple, efficient
    implementation on a	wide variety of	timesharing hosts.

  o+ Direct modem to modem communications with high error rate

Unlike Sliding Windows Kermit, ZMODEM is not optimized for optimum
throughput when	error rate and delays are both high.  This tradeoff
markedly reduces code complexity and memory requirements.  ZMODEM
generally provides faster error	recovery than network compatible XMODEM
implementations.

In the absence of network delays, rapid	error recovery is possible, much
faster than MEGAlink and network compatible versions of	YMODEM and XMODEM.

File transfers begin immediately regardless of which program is	started
first, without the 10 second delay associated with XMODEM.







__________

 1. Provided the transmission medium accommodates X/YMODEM.




Chapter	3	       Rev 8-3-87  Typeset 10-18-87			 5







Chapter	3		     ZMODEM Protocol				 6



3.3  IIIInnnntttteeeeggggrrrriiiittttyyyy aaaannnndddd RRRRoooobbbbuuuussssttttnnnneeeessssssss

Once a ZMODEM session is begun,	all transactions are protected with 16 or
32 bit CRC.[2] Complex proprietary techniques such as CCCCyyyybbbbeeeerrrrnnnneeeettttiiiicccc DDDDaaaattttaaaa
RRRReeeeccccoooovvvveeeerrrryyyy((((TTTTMMMM))))[3]	are not	needed for reliable transfers.

An optional 32-bit CRC used as the frame check sequence	in ADCCP (ANSI
X3.66, also known as FIPS PUB 71 and FED-STD-1003, the U.S. versions of
CCITT's	X.25) is used when available.  The 32 bit CRC reduces undetected
errors by at least five	orders of magnitude when properly applied (-1
preset,	inversion).

A security challenge mechanism guards against "Trojan Horse" messages
written	to mimic legitimate command or file downloads.

3.4  EEEEaaaasssseeee ooooffff IIIImmmmpppplllleeeemmmmeeeennnnttttaaaattttiiiioooonnnn

ZMODEM accommodates a wide variety of systems:

 o+ Microcomputers that cannot overlap disk and serial i/o

 o+ Microcomputers that cannot overlap serial send and receive

 o+ Computers and/or networks requiring XON/XOFF	flow control

 o+ Computers that cannot check the serial input	queue for the presence of
   data	without	having to wait for the data to arrive.

Although ZMODEM	provides "hooks" for multiple "threads", ZMODEM	is not
intended to replace link level protocols such as X.25.

ZMODEM accommodates network and	timesharing system delays by continuously
transmitting data unless the receiver interrupts the sender to request
retransmission of garbled data.	 ZMODEM	in effect uses the entire file as
a window.[4] Using the entire file as a	window simplifies buffer
management, avoiding the window	overrun	failure	modes that affect
MEGAlink, SuperKermit, and others.

ZMODEM provides	a general purpose application to application file transfer
protocol which may be used directly or with with reliable link level


__________

 2. Except for the CAN-CAN-CAN-CAN-CAN abort sequence which requires five
    successive CAN characters.

 3. Unique to Professional-YAM and PowerCom

 4. Streaming strategies are discussed in coming chapters.




Chapter	3	       Rev 8-3-87  Typeset 10-18-87			 6







Chapter	3		     ZMODEM Protocol				 7



protocols such as X.25,	MNP, Fastlink, etc.  When used with X.25, MNP,
Fastlink, etc.,	ZMODEM detects and corrects errors in the interfaces
between	error controlled media and the remainder of the	communications
link.

ZMODEM was developed _f_o_r _t_h_e _p_u_b_l_i_c _d_o_m_a_i_n under a Telenet contract.  The
ZMODEM protocol	descriptions and the Unix rz/sz	program	source code are
public domain.	No licensing, trademark, or copyright restrictions apply
to the use of the protocol, the	Unix rz/sz source code and the _Z_M_O_D_E_M
name.


4.  EEEEVVVVOOOOLLLLUUUUTTTTIIIIOOOONNNN OOOOFFFF ZZZZMMMMOOOODDDDEEEEMMMM

In early 1986, Telenet funded a	project	to develop an improved public
domain application to application file transfer	protocol.  This	protocol
would alleviate	the throughput problems	network	customers were
experiencing with XMODEM and Kermit file transfers.

In the beginning, we thought a few modifications to XMODEM would allow
high performance over packet switched networks while preserving	XMODEM's
simplicity.

The initial concept would add a	block number to	the ACK	and NAK	characters
used by	XMODEM.	 The resultant protocol	would allow the	sender to send
more than one block before waiting for a response.

But how	to add the block number	to XMODEM's ACK	and NAK?  WXMODEM,
SEAlink, MEGAlink and some other protocols add binary byte(s) to indicate
the block number.

Pure binary was	unsuitable for ZMODEM because binary code combinations
won't pass bidirectionally through some	modems,	networks and operating
systems.  Other	operating systems may not be able to recognize something
coming back[1] unless a	break signal or	a system dependent code	or
sequence is present.  By the time all this and other problems with the
simple ACK/NAK sequences mentioned above were corrected, XMODEM's simple
ACK and	NACK characters	had evolved into a real	packet.	 The Frog was
riveting.

Managing the window[2] was another problem.  Experience	gained in
debugging The Source's SuperKermit protocol indicated a	window size of
about 1000 characters was needed at 1200 bps.  High speed modems require a


__________

 1. Without stopping for a response

 2. The	WINDOW is the data in transit between sender and receiver.




Chapter	4	       Rev 8-3-87  Typeset 10-18-87			 7







Chapter	4		     ZMODEM Protocol				 8



window of 20000	or more	characters for full throughput.	 Much of the
SuperKermit's inefficiency, complexity and debugging time centered around
its ring buffering and window management.  There had to	be a better way	to
get the	job done.

A sore point with XMODEM and its progeny is error recovery.  More to the
point, how can the receiver determine whether the sender has responded,	or
is ready to respond, to	a retransmission request?  XMODEM attacks the
problem	by throwing away characters until a certain period of silence.
Too short a time allows	a spurious pause in output (network or timesharing
congestion) to masquerade as error recovery.  Too long a timeout
devastates throughput, and allows a noisy line to lock up the protocol.
SuperKermit solves the problem with a distinct start of	packet character
(SOH).	WXMODEM	and ZMODEM use unique character	sequences to delineate the
start of frames.  SEAlink and MEGAlink do not address this problem.

A further error	recovery problem arises	in streaming protocols.	 How does
the receiver know when (or if) the sender has recognized its error signal?
Is the next packet the correct response	to the error signal?  Is it
something left over "in	the queue"?  Or	is this	new subpacket one of many
that will have to be discarded because the sender did not receive the
error signal?  How long	should this continue before sending another error
signal?	 How can the protocol prevent this from	degenerating into an
argument about mixed signals?

SuperKermit uses selective retransmission, so it can accept any	good
packet it receives.  Each time the SuperKermit receiver	gets a data
packet,	it must	decide which outstanding packet	(if any) it "wants most"
to receive, and	asks for that one.  In practice, complex software "hacks"
are needed to attain acceptable	robustness.[3]

For ZMODEM, we decided to forgo	the complexity of SuperKermit's	packet
assembly scheme	and its	associated buffer management logic and memory
requirements.

Another	sore point with	XMODEM and WXMODEM is the garbage added	to files.
This was acceptable with old CP/M files	which had no exact length, but not
with modern systems such as DOS	and Unix.  YMODEM uses file length
information transmitted	in the header block to trim the	output file, but
this causes data loss when transferring	files that grow	during a transfer.
In some	cases, the file	length may be unknown, as when data is obtained
from a process.	 Variable length data subpackets solve both of these


__________

 3. For	example, when SuperKermit encounters certain errors, the _w_n_d_e_s_r
    function is	called to determine the	next block to request.	A burst	of
    errors generates several wasteful requests to retransmit the same
    block.




Chapter	4	       Rev 8-3-87  Typeset 10-18-87			 8







Chapter	4		     ZMODEM Protocol				 9



problems.

Since some characters had to be	escaped	anyway,	there wasn't any point
wasting	bytes to fill out a fixed packet length	or to specify a	variable
packet length.	In ZMODEM, the length of data subpackets is denoted by
ending each subpacket with an escape sequence similar to BISYNC	and HDLC.

The end	result is a ZMOEM header containing a "frame type", four bytes of
supervisory information, and its own CRC.  Data	frames consist of a header
followed by 1 or more data subpackets.	In the absence of transmission
errors,	an entire file can be sent in one data frame.

Since the sending system may be	sensitive to numerous control characters
or strip parity	in the reverse data path, all of the headers sent by the
receiver are sent in hex.  A common lower level	routine	receives all
headers, allowing the main program logic to deal with headers and data
subpackets as objects.

With equivalent	binary (efficient) and hex (application	friendly) frames,
the sending program can	send an	"invitation to receive"	sequence to
activate the receiver without crashing the remote application with
unexpected control characters.

Going "back to scratch"	in the protocol	design presents	an opportunity to
steal good ideas from many sources and to add a	few new	ones.

From Kermit and	UUCP comes the concept of an initial dialog to exchange
system parameters.

ZMODEM generalizes Compuserve B	Protocol's host	controlled transfers to
single command AutoDownload and	command	downloading.  A	Security Challenge
discourages password hackers and Trojan	Horse authors from abusing
ZMODEM's power.

We were	also keen to the pain and $uffering of legions of
telecommunicators whose	file transfers have been ruined	by communications
and timesharing	faults.	 ZMODEM's file transfer	recovery and advanced file
management are dedicated to these kindred comrades.

After ZMODEM had been operational a short time,	Earl Hall pointed out the
obvious: ZMODEM's user friendly	AutoDownload was almost	useless	if the
user must assign transfer options to each of the sending and receiving
programs.  Now,	transfer options may be	specified to/by	the sending
program, which passes them to the receiving program in the ZFILE header.










Chapter	5	       Rev 8-3-87  Typeset 10-18-87			 9







Chapter	5		     ZMODEM Protocol				10



5.  RRRROOOOSSSSEEEETTTTTTTTAAAA SSSSTTTTOOOONNNNEEEE

Here are some definitions which	reflect	current	vernacular in the computer
media.	The attempt here is identify the file transfer protocol	rather
than specific programs.

FRAME	A ZMODEM frame consists	of a header and	0 or more data subpackets.

XMODEM	refers to the original 1977 file transfer etiquette introduced by
	Ward Christensen's MODEM2 program.  It's also called the MODEM or
	MODEM2 protocol.  Some who are unaware of MODEM7's unusual batch
	file mode call it MODEM7.  Other aliases include "CP/M Users's
	Group" and "TERM II FTP	3".  This protocol is supported	by most
	communications programs	because	it is easy to implement.

XMODEM/CRC replaces XMODEM's 1 byte checksum with a two	byte Cyclical
	Redundancy Check (CRC-16), improving error detection.

XMODEM-1k Refers to XMODEM-CRC with optional 1024 byte blocks.

YMODEM	refers to the XMODEM/CRC protocol with batch transmission and
	optional 1024 byte blocks as described in YMODEM.DOC.[1]


6.  ZZZZMMMMOOOODDDDEEEEMMMM RRRREEEEQQQQUUUUIIIIRRRREEEEMMMMEEEENNNNTTTTSSSS

ZMODEM requires	an 8 bit transfer medium.[1] ZMODEM escapes network
control	characters to allow operation with packet switched networks.  In
general, ZMODEM	operates over any path that supports XMODEM, and over many
that don't.

To support full	streaming,[2] the transmission path should either assert
flow control or	pass full speed	transmission without loss of data.
Otherwise the ZMODEM sender must manage	the window size.

6.1  FFFFiiiilllleeee CCCCoooonnnntttteeeennnnttttssss

6.1.1  BBBBiiiinnnnaaaarrrryyyy FFFFiiiilllleeeessss
ZMODEM places no constraints on	the information	content	of binary files,
except that the	number of bits in the file must	be a multiple of 8.



__________

 1. Available on TeleGodzilla as part of YZMODEM.ZOO

 1. The	ZMODEM design allows encoded packets for less transparent media.

 2. With XOFF and XON, or out of band flow control such	as X.25	or CTS




Chapter	6	       Rev 8-3-87  Typeset 10-18-87			10







Chapter	6		     ZMODEM Protocol				11



6.1.2  TTTTeeeexxxxtttt FFFFiiiilllleeeessss
Since ZMODEM is	used to	transfer files between different types of computer
systems, text files must meet minimum requirements if they are to be
readable on a wide variety of systems and environments.

Text lines consist of printing ASCII characters, spaces, tabs, and
backspaces.

6.1.2.1	 AAAASSSSCCCCIIIIIIII EEEEnnnndddd ooooffff LLLLiiiinnnneeee
The ASCII code definition allows text lines terminated by a CR/LF (015,
012) sequence, or by a NL (012)	character.  Lines logically terminated by
a lone CR (013)	are not	ASCII text.

A CR (013) without a linefeed implies overprinting, and	is not acceptable
as a logical line separator.  Overprinted lines	should print all important
characters in the last pass to allow CRT displays to display meaningful
text.  Overstruck characters may be generated by backspacing or	by
overprinting the line with CR (015) not	followed by LF.

Overstruck characters generated	with backspaces	should be sent with the
most important character last to accommodate CRT displays that cannot
overstrike.  The sending program may use the ZZZZCCCCNNNNLLLL bit to force the
receiving program to convert the received end of line to its local end of
line convention.[3]






















__________

 3. Files that have been translated in such a way as to	modify their
    length cannot be updated with the ZZZZCCCCRRRREEEECCCCOOOOVVVV Conversion Option.




Chapter	6	       Rev 8-3-87  Typeset 10-18-87			11







Chapter	6		     ZMODEM Protocol				12



7.  ZZZZMMMMOOOODDDDEEEEMMMM BBBBAAAASSSSIIIICCCCSSSS

7.1  PPPPaaaacccckkkkeeeettttiiiizzzzaaaattttiiiioooonnnn

ZMODEM frames differ somewhat from XMODEM blocks.  XMODEM blocks are not
used for the following reasons:

 o+ Block numbers are limited to	256

 o+ No provision	for variable length blocks

 o+ Line	hits corrupt protocol signals, causing failed file transfers.  In
   particular, modem errors sometimes generate false block numbers, false
   EOTs	and false ACKs.	 False ACKs are	the most troublesome as	they cause
   the sender to lose synchronization with the receiver.

   State of the	art programs such as Professional-YAM and ZCOMM	overcome
   some	of these weaknesses with clever	proprietary code, but a	stronger
   protocol is desired.

 o+ It is difficult to determine	the beginning and ends of XMODEM blocks
   when	line hits cause	a loss of synchronization.  This precludes rapid
   error recovery.

7.2  LLLLiiiinnnnkkkk EEEEssssccccaaaappppeeee EEEEnnnnccccooooddddiiiinnnngggg

ZMODEM achieves	data transparency by extending the 8 bit character set
(256 codes) with escape	sequences based	on the ZMODEM data link	escape
character ZDLE.[1]

Link Escape coding permits variable length data	subpackets without the
overhead of a separate byte count.  It allows the beginning of frames to
be detected without special timing techniques, facilitating rapid error
recovery.

Link Escape coding does	add some overhead.  The	worst case, a file
consisting entirely of escaped characters, would incur a 50% overhead.

The ZDLE character is special.	ZDLE represents	a control sequence of some
sort.  If a ZDLE character appears in binary data, it is prefixed with
ZDLE, then sent	as ZDLEE.

The value for ZDLE is octal 030	(ASCII CAN).  This particular value was
chosen to allow	a string of 5 consecutive CAN characters to abort a ZMODEM


__________

 1. This and other constants are defined in the	_z_m_o_d_e_m._h include file.
    Please note	that constants with a leading 0	are octal constants in C.




Chapter	7	       Rev 8-3-87  Typeset 10-18-87			12







Chapter	7		     ZMODEM Protocol				13



session, compatible with YMODEM	session	abort.

Since CAN is not used in normal	terminal operations, interactive
applications and communications	programs can monitor the data flow for
ZDLE.  The following characters	can be scanned to detect the ZRQINIT
header,	the invitation to automatically	download commands or files.

Receipt	of five	successive CAN characters will abort a ZMODEM session.
Eight CAN characters are sent.

The receiving program decodes any sequence of ZDLE followed by a byte with
bit 6 set and bit 5 reset (upper case letter, either parity) to	the
equivalent control character by	inverting bit 6.  This allows the
transmitter to escape any control character that cannot	be sent	by the
communications medium.	In addition, the receiver recognizes escapes for
0177 and 0377 should these characters need to be escaped.

ZMODEM software	escapes	ZDLE, 020, 0220, 021, 0221, 023, and 0223.  If
preceded by 0100 or 0300 (@), 015 and 0215 are also escaped to protect the
Telenet	command	escape CR-@-CR.	 The receiver ignores 021, 0221, 023, and
0223 characters	in the data stream.

The ZMODEM routines in zm.c accept an option to	escape all control
characters, to allow operation with less transparent networks.	This
option can be given to either the sending or receiving program.

7.3  HHHHeeeeaaaaddddeeeerrrr

All ZMODEM frames begin	with a header which may	be sent	in binary or HEX
form.  ZMODEM uses a single routine to recognize binary	and hex	headers.
Either form of the header contains the same raw	information:

 o+ A type byte[2] [3]

 o+ Four	bytes of data indicating flags and/or numeric quantities depending
   on the frame	type







__________

 2. The	frame types are	cardinal numbers beginning with	0 to minimize
    state transition table memory requirements.

 3. Future extensions to ZMODEM	may use	the high order bits of the type
    byte to indicate thread selection.




Chapter	7	       Rev 8-3-87  Typeset 10-18-87			13







Chapter	7		     ZMODEM Protocol				14



		   FFFFiiiigggguuuurrrreeee 1111....  Order of Bytes in	Header

		   TYPE:  frame	type
		   F0: Flags least significant byte
		   P0: file Position least significant
		   P3: file Position most significant

			   TYPE	 F3 F2 F1 F0
			   -------------------
			   TYPE	 P0 P1 P2 P3

7.3.1  11116666 BBBBiiiitttt CCCCRRRRCCCC BBBBiiiinnnnaaaarrrryyyy HHHHeeeeaaaaddddeeeerrrr
A binary header	is sent	by the sending program to the receiving	program.
ZDLE encoding accommodates XON/XOFF flow control.

A binary header	begins with the	sequence ZPAD, ZDLE, ZBIN.

The frame type byte is ZDLE encoded.

The four position/flags	bytes are ZDLE encoded.

A two byte CRC of the frame type and position/flag bytes is ZDLE encoded.

0 or more binary data subpackets with 16 bit CRC will follow depending on
the frame type.

The function _z_s_b_h_d_r transmits a	binary header.	The function _z_g_e_t_h_d_r
receives a binary or hex header.

		   FFFFiiiigggguuuurrrreeee 2222....  16 Bit CRC Binary	Header
	    * ZDLE A TYPE F3/P0	F2/P1 F1/P2 F0/P3 CRC-1	CRC-2


7.3.2  33332222 BBBBiiiitttt CCCCRRRRCCCC BBBBiiiinnnnaaaarrrryyyy HHHHeeeeaaaaddddeeeerrrr
A "32 bit CRC" Binary header is	similar	to a Binary Header, except the
ZZZZBBBBIIIINNNN (A) character is replaced by a ZZZZBBBBIIIINNNN33332222 (C) character, and four
characters of CRC are sent.  0 or more binary data subpackets with 32 bit
CRC will follow	depending on the frame type.

The common variable _T_x_f_c_s_3_2 may	be set TRUE for	32 bit CRC iff the
receiver indicates the capability with the CCCCAAAANNNNFFFFCCCC33332222 bit.	 The zgethdr,
zsdata and zrdata functions automatically adjust to the	type of	Frame
Check Sequence being used.
		   FFFFiiiigggguuuurrrreeee 3333....  32 Bit CRC Binary	Header
      *	ZDLE C TYPE F3/P0 F2/P1	F1/P2 F0/P3 CRC-1 CRC-2	CRC-3 CRC-4


7.3.3  HHHHEEEEXXXX HHHHeeeeaaaaddddeeeerrrr
The receiver sends responses in	hex headers.  The sender also uses hex
headers	when they are not followed by binary data subpackets.




Chapter	7	       Rev 8-3-87  Typeset 10-18-87			14







Chapter	7		     ZMODEM Protocol				15



Hex encoding protects the reverse channel from random control characters.
The hex	header receiving routine ignores parity.

Use of Kermit style encoding for control and paritied characters was
considered and rejected	because	of increased possibility of interacting
with some timesharing systems' line edit functions.  Use of HEX	headers
from the receiving program allows control characters to	be used	to
interrupt the sender when errors are detected.	A HEX header may be used
in place of a binary header wherever convenient.  If a data packet follows
a HEX header, it is protected with CRC-16.

A hex header begins with the sequence ZPAD, ZPAD, ZDLE,	ZHEX.  The _z_g_e_t_h_d_r
routine	synchronizes with the ZPAD-ZDLE	sequence.  The extra ZPAD
character allows the sending program to	detect an asynchronous header
(indicating an error condition)	and then call _z_g_e_t_h_d_r to receive the
header.

The type byte, the four	position/flag bytes, and the 16	bit CRC	thereof
are sent in hex	using the character set	01234567890abcdef.  Upper case hex
digits are not allowed;	they false trigger XMODEM and YMODEM programs.
Since this form	of hex encoding	detects	many patterns of errors,
especially missing characters, a hex header with 32 bit	CRC has	not been
defined.

A carriage return and line feed	are sent with HEX headers.  The	receive
routine	expects	to see at least	one of these characters, two if	the first
is CR.	The CR/LF aids debugging from printouts, and helps overcome
certain	operating system related problems.

An XON character is appended to	all HEX	packets	except ZACK and	ZFIN.  The
XON releases the sender	from spurious XOFF flow	control	characters
generated by line noise, a common occurrence.  XON is not sent after ZACK
headers	to protect flow	control	in streaming situations.  XON is not sent
after a	ZFIN header to allow clean session cleanup.

0 or more data subpackets will follow depending	on the frame type.

The function _z_s_h_h_d_r sends a hex	header.

			  FFFFiiiigggguuuurrrreeee 4444....  HEX Header

      *	* ZDLE B TYPE F3/P0 F2/P1 F1/P2	F0/P3 CRC-1 CRC-2 CR LF	XON

(TYPE, F3...F0,	CRC-1, and CRC-2 are each sent as two hex digits.)










Chapter	7	       Rev 8-3-87  Typeset 10-18-87			15







Chapter	7		     ZMODEM Protocol				16



7.4  BBBBiiiinnnnaaaarrrryyyy DDDDaaaattttaaaa SSSSuuuubbbbppppaaaacccckkkkeeeettttssss

Binary data subpackets immediately follow the associated binary	header
packet.	 A binary data packet contains 0 to 1024 bytes of data.
Recommended length values are 256 bytes	below 2400 bps,	512 at 2400 bps,
and 1024 above 4800 bps	or when	the data link is known to be relatively
error free.[4]

No padding is used with	binary data subpackets.	 The data bytes	are ZDLE
encoded	and transmitted.  A ZDLE and frameend are then sent, followed by
two or four ZDLE encoded CRC bytes.  The CRC accumulates the data bytes
and frameend.

The function _z_s_d_a_t_a sends a data subpacket.  The function _z_r_d_a_t_a receives
a data subpacket.

7.5  AAAASSSSCCCCIIIIIIII EEEEnnnnccccooooddddeeeedddd DDDDaaaattttaaaa	SSSSuuuubbbbppppaaaacccckkkkeeeetttt

The format of ASCII Encoded data subpackets is not currently specified.
These could be used for	server commands, or main transfers in 7	bit
environments.


8.  PPPPRRRROOOOTTTTOOOOCCCCOOOOLLLL TTTTRRRRAAAANNNNSSSSAAAACCCCTTTTIIIIOOOONNNN OOOOVVVVEEEERRRRVVVVIIIIEEEEWWWW

As with	the XMODEM recommendation, ZMODEM timing is receiver driven.  The
transmitter should not time out	at all,	except to abort	the program if no
headers	are received for an extended period of time, say one minute.[1]


8.1  SSSSeeeessssssssiiiioooonnnn SSSSttttaaaarrrrttttuuuupppp

To start a ZMODEM file transfer	session, the sending program is	called
with the names of the desired file(s) and option(s).

The sending program may	send the string	"rz\r" to invoke the receiving
program	from a possible	command	mode.  The "rz"	followed by carriage
return activates a ZMODEM receive program or command if	it were	not
already	active.

The sender may then display a message intended for human consumption, such


__________

 4. Strategies for adjusting the subpacket length for optimal results
    based on real time error rates are still evolving.	Shorter	subpackets
    speed error	detection but increase protocol	overhead slightly.

 1. Special considerations apply when sending commands.




Chapter	8	       Rev 8-3-87  Typeset 10-18-87			16







Chapter	8		     ZMODEM Protocol				17



as a list of the files requested, etc.

Then the sender	may send a ZZZZRRRRQQQQIIIINNNNIIIITTTT header.  The	ZZZZRRRRQQQQIIIINNNNIIIITTTT	header causes a
previously started receive program to send its ZZZZRRRRIIIINNNNIIIITTTT header without
delay.

In an interactive or conversational mode, the receiving	application may
monitor	the data stream	for ZDLE.  The following characters may	be scanned
for BBBB00000000	indicating a ZRQINIT header, a command to download a command or
data.

The sending program awaits a command from the receiving	program	to start
file transfers.	 If a "C", "G",	or NAK is received, an XMODEM or YMODEM
file transfer is indicated, and	file transfer(s) use the YMODEM	protocol.
Note: With ZMODEM and YMODEM, the sending program provides the file name,
but not	with XMODEM.

In case	of garbled data, the sending program can repeat	the invitation to
receive	a number of times until	a session starts.

When the ZMODEM	receive	program	starts,	it immediately sends a ZZZZRRRRIIIINNNNIIIITTTT
header to initiate ZMODEM file transfers, or a ZZZZCCCCHHHHAAAALLLLLLLLEEEENNNNGGGGEEEE header to verify
the sending program.  The receive program resends its header at	_r_e_s_p_o_n_s_e
_t_i_m_e (default 10 second) intervals for a suitable period of time (40
seconds	total) before falling back to YMODEM protocol.

If the receiving program receives a ZZZZRRRRQQQQIIIINNNNIIIITTTT header, it resends the ZZZZRRRRIIIINNNNIIIITTTT
header.	 If the	sending	program	receives the ZZZZCCCCHHHHAAAALLLLLLLLEEEENNNNGGGGEEEE	header,	it places
the data in ZP0...ZP3 in an answering ZZZZAAAACCCCKKKK header.

If the receiving program receives a ZZZZRRRRIIIINNNNIIIITTTT header, it is an echo
indicating that	the sending program is not operational.

Eventually the sending program correctly receives the ZZZZRRRRIIIINNNNIIIITTTT header.

The sender may then send an optional ZZZZSSSSIIIINNNNIIIITTTT frame to define the	receiving
program's AAAAttttttttnnnn sequence, or to specify complete	control	character
escaping.[2]

If the ZSINIT header specifies ESCCTL or ESC8, a HEX header is used, and
the receiver activates the specified ESC modes before reading the
following data subpacket.

The receiver sends a ZZZZAAAACCCCKKKK header in response, optionally containing the


__________

 2. If the receiver specifies the same or higher level of escaping, the
    ZSINIT frame need not be sent unless an Attn sequence is needed.




Chapter	8	       Rev 8-3-87  Typeset 10-18-87			17







Chapter	8		     ZMODEM Protocol				18



serial number of the receiving program,	or 0.

8.2  FFFFiiiilllleeee TTTTrrrraaaannnnssssmmmmiiiissssssssiiiioooonnnn

The sender then	sends a	ZZZZFFFFIIIILLLLEEEE header with ZMODEM Conversion, Management,
and Transport options[3] followed by a ZCRCW data subpacket containing the
file name, file	length,	modification date, and other information identical
to that	used by	YMODEM Batch.

The receiver examines the file name, length, and date information provided
by the sender in the context of	the specified transfer options,	the
current	state of its file system(s), and local security	requirements.  The
receiving program should insure	the pathname and options are compatible
with its operating environment and local security requirements.

The receiver may respond with a	ZZZZSSSSKKKKIIIIPPPP header, which makes the sender
proceed	to the next file (if any) in the batch.

       If the receiver has a file with the same	name and length,
       it may respond with a ZZZZCCCCRRRRCCCC header, which	requires the
       sender to perform a 32 bit CRC on the file and transmit the
       complement of the CRC in	a ZZZZCCCCRRRRCCCC header.[4] The receiver
       uses this information to	determine whether to accept the
       file or skip it.	 This sequence is triggered by the ZMCRC
       Management Option.

A ZZZZRRRRPPPPOOOOSSSS	header from the	receiver initiates transmission	of the file data
starting at the	offset in the file specified in	the ZZZZRRRRPPPPOOOOSSSS header.
Normally the receiver specifies	the data transfer to begin begin at
offset 0 in the	file.
       The receiver may	start the transfer further down	in the
       file.  This allows a file transfer interrupted by a loss
       or carrier or system crash to be	completed on the next
       connection without requiring the	entire file to be
       retransmitted.[5] If downloading	a file from a timesharing
       system that becomes sluggish, the transfer can be
       interrupted and resumed later with no loss of data.

The sender sends a ZZZZDDDDAAAATTTTAAAA binary	header (with file position) followed by
one or more data subpackets.



__________

 3. See	below, under ZFILE header type.

 4. The	crc is initialized to 0xFFFFFFFF.

 5. This does not apply	to files that have been	translated.




Chapter	8	       Rev 8-3-87  Typeset 10-18-87			18







Chapter	8		     ZMODEM Protocol				19



The receiver compares the file position	in the ZZZZDDDDAAAATTTTAAAA header with the
number of characters successfully received to the file.	 If they do not
agree, a ZZZZRRRRPPPPOOOOSSSS error response is generated to force the	sender to the
right position within the file.[6]

A data subpacket terminated by ZZZZCCCCRRRRCCCCGGGG and CRC does not elicit a response
unless an error	is detected; more data subpacket(s) follow immediately.

       ZZZZCCCCRRRRCCCCQQQQ data subpackets expect a ZZZZAAAACCCCKKKK response with the
       receiver's file offset if no error, otherwise a ZZZZRRRRPPPPOOOOSSSS
       response	with the last good file	offset.	 Another data
       subpacket continues immediately.	 ZZZZCCCCRRRRCCCCQQQQ subpackets are
       not used	if the receiver	does not indicate FDX ability
       with the	CCCCAAAANNNNFFFFDDDDXXXX bit.

ZZZZCCCCRRRRCCCCWWWW data subpackets expect a response	before the next	frame is sent.
If the receiver	does not indicate overlapped I/O capability with the
CCCCAAAANNNNOOOOVVVVIIIIOOOO	bit, or	sets a buffer size, the	sender uses the	ZZZZCCCCRRRRCCCCWWWW to allow
the receiver to	write its buffer before	sending	more data.

       A zero length data frame	may be used as an idle
       subpacket to prevent the	receiver from timing out in
       case data is not	immediately available to the sender.

In the absence of fatal	error, the sender eventually encounters	end of
file.  If the end of file is encountered within	a frame, the frame is
closed with a ZZZZCCCCRRRRCCCCEEEE data subpacket which does not elicit a response
except in case of error.

The sender sends a ZZZZEEEEOOOOFFFF	header with the	file ending offset equal to
the number of characters in the	file.  The receiver compares this
number with the	number of characters received.	If the receiver	has
received all of	the file, it closes the	file.  If the file close was
satisfactory, the receiver responds with ZZZZRRRRIIIINNNNIIIITTTT.  If the receiver has
not received all the bytes of the file,	the receiver ignores the ZEOF
because	a new ZDATA is coming.	If the receiver	cannot properly	close
the file, a ZZZZFFFFEEEERRRRRRRR header is sent.

       After all files are processed, any further protocol
       errors should not prevent the sending program from
       returning with a	success	status.





__________

 6. If the ZMSPARS option is used, the receiver	instead	seeks to the
    position given in the ZDATA	header.




Chapter	8	       Rev 8-3-87  Typeset 10-18-87			19







Chapter	8		     ZMODEM Protocol				20



8.3  SSSSeeeessssssssiiiioooonnnn CCCClllleeeeaaaannnnuuuupppp

The sender closes the session with a ZZZZFFFFIIIINNNN header.  The receiver
acknowledges this with its own ZZZZFFFFIIIINNNN header.

When the sender	receives the acknowledging header, it sends two
characters, "OO" (Over and Out)	and exits to the operating system or
application that invoked it.  The receiver waits briefly for the "O"
characters, then exits whether they were received or not.

8.4  SSSSeeeessssssssiiiioooonnnn AAAAbbbboooorrrrtttt SSSSeeeeqqqquuuueeeennnncccceeee

If the receiver	is receiving data in streaming mode, the AAAAttttttttnnnn
sequence is executed to	interrupt data transmission before the Cancel
sequence is sent.  The Cancel sequence consists	of eight CAN
characters and ten backspace characters.  ZMODEM only requires five
Cancel characters, the other three are "insurance".

The trailing backspace characters attempt to erase the effects of the
CAN characters if they are received by a command interpreter.

       static char canistr[] = {
	24,24,24,24,24,24,24,24,8,8,8,8,8,8,8,8,8,8,0
       };






























Chapter	8	       Rev 8-3-87  Typeset 10-18-87			20







Chapter	8		     ZMODEM Protocol				21



9.  SSSSTTTTRRRREEEEAAAAMMMMIIIINNNNGGGG TTTTEEEECCCCHHHHNNNNIIIIQQQQUUUUEEEESSSS //// EEEERRRRRRRROOOORRRR RRRREEEECCCCOOOOVVVVEEEERRRRYYYY

It is a	fact of	life that no single method of streaming	is applicable
to a majority of today's computing and telecommunications
environments.  ZMODEM provides several data streaming methods
selected according to the limitations of the sending environment,
receiving environment, and transmission	channel(s).


9.1  FFFFuuuullllllll SSSSttttrrrreeeeaaaammmmiiiinnnngggg wwwwiiiitttthhhh SSSSaaaammmmpppplllliiiinnnngggg

If the receiver	can overlap serial I/O with disk I/O, and if the
sender can sample the reverse channel for the presence of data
without	having to wait,	full streaming can be used with	no AAAAttttttttnnnn
sequence required.  The	sender begins data transmission	with a ZZZZDDDDAAAATTTTAAAA
header and continuous ZZZZCCCCRRRRCCCCGGGG data subpackets.  When the receiver
detects	an error, it executes the AAAAttttttttnnnn sequence	and then sends a
ZZZZRRRRPPPPOOOOSSSS header with the correct position within the file.

At the end of each transmitted data subpacket, the sender checks for
the presence of	an error header	from the receiver.  To do this,	the
sender samples the reverse data	stream for the presence	of either a
ZPAD or	CAN character.[1] Flow control characters (if present) are
acted upon.

Other characters (indicating line noise) increment a counter which is
reset whenever the sender waits	for a header from the receiver.	 If
the counter overflows, the sender sends	the next data subpacket	as
ZCRCW, and waits for a response.

ZPAD indicates some sort of error header from the receiver.  A CAN
suggests the user is attempting	to "stop the bubble machine" by
keyboarding CAN	characters.  If	one of these characters	is seen, an
empty ZCRCE data subpacket is sent.  Normally, the receiver will have
sent an	ZRPOS or other error header, which will	force the sender to
resume transmission at a different address, or take other action.  In
the unlikely event the ZPAD or CAN character was spurious, the
receiver will time out and send	a ZRPOS	header.[2]

Then the receiver's response header is read and	acted upon.[3]


__________

 1. The	call to	rdchk()	in sssszzzz....cccc	performs this function.

 2. The	obvious	choice of ZCRCW	packet,	which would trigger an ZACK from
    the	receiver, is not used because multiple in transit frames could
    result if the channel has a	long propagation delay.

 3. The	call to	getinsync() in sssszzzz....cccc performs this function.



Chapter	9	       Rev 8-3-87  Typeset 10-18-87			21







Chapter	9		     ZMODEM Protocol				22



A ZZZZRRRRPPPPOOOOSSSS	header resets the sender's file	offset to the correct
position.  If possible,	the sender should purge	its output buffers
and/or networks	of all unprocessed output data,	to minimize the
amount of unwanted data	the receiver must discard before receiving
data starting at the correct file offset.  The next transmitted	data
frame should be	a ZCRCW	frame followed by a wait to guarantee
complete flushing of the network's memory.

If the receiver	gets a ZZZZAAAACCCCKKKK header with	an address that	disagrees
with the sender	address, it is ignored,	and the	sender waits for
another	header.	 A ZZZZFFFFIIIINNNN, ZZZZAAAABBBBOOOORRRRTTTT, or TTTTIIIIMMMMEEEEOOOOUUUUTTTT terminates the session; a
ZZZZSSSSKKKKIIIIPPPP terminates the processing	of this	file.

The reverse channel is then sampled for	the presence of	another
header from the	receiver.[4] if	one is detected, the getinsync()
function is again called to read another error header.	Otherwise,
transmission resumes at	the (possibly reset) file offset with a	ZZZZDDDDAAAATTTTAAAA
header followed	by data	subpackets.


9.1.1  WWWWiiiinnnnddddoooowwww MMMMaaaannnnaaaaggggeeeemmmmeeeennnntttt
When sending data through a network, some nodes	of the network store
data while it is transferred to	the receiver.  7000 bytes and more of
transient storage have been observed.  Such a large amount of storage
causes the transmitter to "get ahead" of the reciever.	This can be
fatal with MEGAlink and	other protocols	that depend on timely
notification of	errors from the	receiver.  This	condition is not
fatal with ZMODEM, but it does slow error recovery.

To manage the window size, the sending program uses ZCRCQ data
subpackets to trigger ZACK headers from	the receiver.  The returning
ZACK headers inform the	sender of the receiver's progress.  When the
window size (current transmitter file offset - last reported receiver
file offset) exceeds a specified value,	the sender waits for a
ZACK[5]	packet with a receiver file offset that	reduces	the window
size.

Unix _s_z	versions beginning with	May 9 1987 control the window size
with the "-w N"	option,	where N	is the maximum window size.  Pro-YAM,
ZCOMM and DSZ versions beginning with May 9 1987 control the window
size with "zmodem pwN".	 This is compatible with previous versions of
these programs.[6]


__________

 4. If sampling	is possible.

 5. ZRPOS and other error packets are handled normally.

 6. When used with modems or networks that simultaneously assert flow



Chapter	9	       Rev 8-3-87  Typeset 10-18-87			22







Chapter	9		     ZMODEM Protocol				23



9.2  FFFFuuuullllllll SSSSttttrrrreeeeaaaammmmiiiinnnngggg wwwwiiiitttthhhh RRRReeeevvvveeeerrrrsssseeee IIIInnnntttteeeerrrrrrrruuuupppptttt

The above method cannot	be used	if the reverse data stream cannot be
sampled	without	entering an I/O	wait.  An alternate method is to
instruct the receiver to interrupt the sending program when an error
is detected.

The receiver can interrupt the sender with a control character,	break
signal,	or combination thereof,	as specified in	the AAAAttttttttnnnn sequence.
After executing	the AAAAttttttttnnnn sequence, the receiver	sends a	hex ZZZZRRRRPPPPOOOOSSSS
header to force	the sender to resend the lost data.

When the sending program responds to this interrupt, it	reads a	HEX
header (normally ZRPOS)	from the receiver and takes the	action
described in the previous section.  The	Unix sssszzzz....cccc program uses a
setjmp/longjmp call to catch the interrupt generated by	the AAAAttttttttnnnn
sequence.  Catching the	interrupt activates the	getinsync() function
to read	the receiver's error header and	take appropriate action.

When compiled for standard SYSTEM III/V	Unix, sssszzzz....cccc uses	an AAAAttttttttnnnn
sequence of Ctrl-C followed by a 1 second pause	to interrupt the
sender,	then give the sender (Unix) time to prepare for	the
receiver's error header.


9.3  FFFFuuuullllllll SSSSttttrrrreeeeaaaammmmiiiinnnngggg wwwwiiiitttthhhh SSSSlllliiiiddddiiiinnnngggg WWWWiiiinnnnddddoooowwww

If none	of the above methods is	applicable, hope is not	yet lost.  If
the sender can buffer responses	from the receiver, the sender can use
ZCRCQ data subpackets to get ACKs from the receiver without
interrupting the transmission of data.	After a	sufficient number of
ZCRCQ data subpackets have been	sent, the sender can read one of the
headers	that should have arrived in its	receive	interrupt buffer.

A problem with this method is the possibility of wasting an excessive
amount of time responding to the receiver's error header.  It may be
possible to program the	receiver's AAAAttttttttnnnn	sequence to flush the
sender's interrupt buffer before sending the ZRPOS header.







__________________________________________________________________________

    control with XON and XOFF characters aaaannnndddd pass XON characters that
    violate flow control, the receiving	program	should have a revision
    date of May	9 or later.




Chapter	9	       Rev 8-3-87  Typeset 10-18-87			23







Chapter	9		     ZMODEM Protocol				24



9.4  FFFFuuuullllllll SSSSttttrrrreeeeaaaammmmiiiinnnngggg oooovvvveeeerrrr EEEErrrrrrrroooorrrr FFFFrrrreeeeeeee CCCChhhhaaaannnnnnnneeeellllssss

File transfer protocols	predicated on the existence of an error	free
end to end communications channel have been proposed from time to
time.  Such channels have proven to be more readily available in
theory than in actuality.  The frequency of undetected errors
increases when modem scramblers	have more bits than the	error
detecting CRC.

A ZMODEM sender	assuming an error free channel with end	to end flow
control	can send the entire file in one	frame without any checking of
the reverse stream.  If	this channel is	completely transparent,	only
ZDLE need be escaped.  The resulting protocol overhead for average
long files is less than	one per	cent.[7]

9.5  SSSSeeeeggggmmmmeeeennnntttteeeedddd SSSSttttrrrreeeeaaaammmmiiiinnnngggg

If the receiver	cannot overlap serial and disk I/O, it uses the
ZZZZRRRRIIIINNNNIIIITTTT frame to	specify	a buffer length	which the sender will not
overflow.  The sending program sends a ZZZZCCCCRRRRCCCCWWWW data subpacket and	waits
for a ZZZZAAAACCCCKKKK header before sending the next segment of the file.

If the sending program supports	reverse	data stream sampling or
interrupt, error recovery will be faster (on average) than a protocol
(such as YMODEM) that sends large blocks.

A sufficiently large receiving buffer allows throughput	to closely
approach that of full streaming.  For example, 16kb segmented
streaming adds about 3 per cent	to full	streaming ZMODEM file
transfer times when the	round trip delay is five seconds.


10.  AAAATTTTTTTTEEEENNNNTTTTIIIIOOOONNNN SSSSEEEEQQQQUUUUEEEENNNNCCCCEEEE

The receiving program sends the	AAAAttttttttnnnn sequence whenever it detects an
error and needs	to interrupt the sending program.

The default AAAAttttttttnnnn string	value is empty (no Attn	sequence).  The
receiving program resets Attn to the empty default before each
transfer session.

The sender specifies the Attn sequence in its optional ZSINIT frame.
The AAAAttttttttnnnn string	is terminated with a null.



__________

 7. One	in 256 for escaping ZDLE, about	two (four if 32	bit CRC	is used)
    in 1024 for	data subpacket CRC's




Chapter	10	       Rev 8-3-87  Typeset 10-18-87			24







Chapter	10		     ZMODEM Protocol				25



Two meta-characters perform special functions:

   o+ \335 (octal) Send a break signal

   o+ \336 (octal) Pause	one second


11.  FFFFRRRRAAAAMMMMEEEE TTTTYYYYPPPPEEEESSSS

The numeric values for the values shown	in boldface are	given in
_z_m_o_d_e_m._h.  Unused bits and unused bytes	in the header (ZP0...ZP3) are
set to 0.

11.1  ZZZZRRRRQQQQIIIINNNNIIIITTTT

Sent by	the sending program, to	trigger	the receiving program to send
its ZRINIT header.  This avoids	the aggravating	startup	delay
associated with	XMODEM and Kermit transfers.  The sending program may
repeat the receive invitation (including ZRQINIT) if a response	is
not obtained at	first.

ZF0 contains ZCOMMAND if the program is	attempting to send a command,
0 otherwise.

11.2  ZZZZRRRRIIIINNNNIIIITTTT

Sent by	the receiving program.	ZF0 and	ZF1 contain the	 bitwise or
of the receiver	capability flags:
#define	CANCRY	    8	/* Receiver can	decrypt	*/
#define	CANFDX	   01	/* Rx can send and receive true	FDX */
#define	CANOVIO	   02	/* Rx can receive data during disk I/O */
#define	CANBRK	   04	/* Rx can send a break signal */
#define	CANCRY	  010	/* Receiver can	decrypt	*/
#define	CANLZW	  020	/* Receiver can	uncompress */
#define	CANFC32	  040	/* Receiver can	use 32 bit Frame Check */
#define	ESCCTL	 0100	/* Receiver expects ctl	chars to be escaped
*/
#define	ESC8	 0200	/* Receiver expects 8th	bit to be escaped */

ZP0 and	ZP1 contain the	size of	the receiver's buffer in bytes,	or 0
if nonstop I/O is allowed.

11.3  ZZZZSSSSIIIINNNNIIIITTTT

The Sender sends flags followed	by a binary data subpacket terminated
with ZZZZCCCCRRRRCCCCWWWW.

/* Bit Masks for ZSINIT	flags byte ZF0 */
#define	TESCCTL	0100   /* Transmitter expects ctl chars	to be escaped
*/
#define	TESC8	0200   /* Transmitter expects 8th bit to be escaped



Chapter	11	       Rev 8-3-87  Typeset 10-18-87			25







Chapter	11		     ZMODEM Protocol				26



*/

The data subpacket contains the	null terminated	AAAAttttttttnnnn sequence,
maximum	length 32 bytes	including the terminating null.

11.4  ZZZZAAAACCCCKKKK

Acknowledgment to a ZZZZSSSSIIIINNNNIIIITTTT frame, ZZZZCCCCHHHHAAAALLLLLLLLEEEENNNNGGGGEEEE header, ZZZZCCCCRRRRCCCCQQQQ or ZZZZCCCCRRRRCCCCWWWW
data subpacket.	 ZP0 to	ZP3 contain file offset.  The response to
ZCHALLENGE contains the	same 32	bit number received in the ZCHALLENGE
header.

11.5  ZZZZFFFFIIIILLLLEEEE

This frame denotes the beginning of a file transmission	attempt.
ZF0, ZF1, and ZF2 may contain options.	A value	of 0 in	each of	these
bytes implies no special treatment.  Options specified to the
receiver override options specified to the sender with the exception
of ZZZZCCCCBBBBIIIINNNN which overrides any other Conversion Option given to the
sender or receiver.


11.5.1	ZZZZFFFF0000:::: CCCCoooonnnnvvvveeeerrrrssssiiiioooonnnn	OOOOppppttttiiiioooonnnn
If the receiver	does not recognize the Conversion Option, an
application dependent default conversion may apply.

ZZZZCCCCBBBBIIIINNNN "Binary" transfer	- inhibit conversion unconditionally

ZZZZCCCCNNNNLLLL Convert received end of line to local end of line
     convention.  The supported	end of line conventions	are
     CR/LF (most ASCII based operating systems except Unix
     and Macintosh), and NL (Unix).  Either of these two end
     of	line conventions meet the permissible ASCII
     definitions for Carriage Return and Line Feed/New Line.
     Neither the ASCII code nor	ZMODEM ZCNL encompass lines
     separated only by carriage	returns.  Other	processing
     appropriate to ASCII text files and the local operating
     system may	also be	applied	by the receiver.[1]

ZZZZCCCCRRRREEEECCCCOOOOVVVV	Recover/Resume interrupted file	transfer.  ZCREVOV is
     also useful for updating a	remote copy of a file that
     grows without resending of	old data.  If the destination
     file exists and is	no longer than the source, append to
     the destination file and start transfer at	the offset
     corresponding to the receiver's end of file.  This


__________

 1. Filtering RUBOUT, NULL, Ctrl-Z, etc.




Chapter	11	       Rev 8-3-87  Typeset 10-18-87			26







Chapter	11		     ZMODEM Protocol				27



     option does not apply if the source file is shorter.
     Files that	have been converted (e.g., ZCNL) or subject
     to	a single ended Transport Option	cannot have their
     transfers recovered.

11.5.2	ZZZZFFFF1111:::: MMMMaaaannnnaaaaggggeeeemmmmeeeennnntttt	OOOOppppttttiiiioooonnnn
If the receiver	does not recognize the Management Option, the
file should be transferred normally.

The ZZZZMMMMSSSSKKKKNNNNOOOOLLLLOOOOCCCC bit instructs the	receiver to bypass the
current	file if	the receiver does not have a file with the
same name.

Five bits (defined by ZZZZMMMMMMMMAAAASSSSKKKK) define the following set of
mutually exclusive management options.

ZZZZMMMMNNNNEEEEWWWWLLLL Transfer	file if	destination file absent.  Otherwise,
     transfer file overwriting destination if the source file
     is	newer or longer.

ZZZZMMMMCCCCRRRRCCCC Compare the source and destination files.	 Transfer if
     file lengths or file polynomials differ.

ZZZZMMMMAAAAPPPPNNNNDDDD Append source file contents to the end of the existing
     destination file (if any).

ZZZZMMMMCCCCLLLLOOOOBBBB Replace existing	destination file (if any).

ZZZZMMMMDDDDIIIIFFFFFFFF Transfer	file if	destination file absent.  Otherwise,
     transfer file overwriting destination if files have
     different lengths or dates.

ZZZZMMMMPPPPRRRROOOOTTTT Protect destination file	by transferring	file only if
     the destination file is absent.

ZZZZMMMMNNNNEEEEWWWW Transfer file if destination file	absent.	 Otherwise,
     transfer file overwriting destination if the source file
     is	newer.

11.5.3	ZZZZFFFF2222:::: TTTTrrrraaaannnnssssppppoooorrrrtttt OOOOppppttttiiiioooonnnn
If the receiver	does not implement the particular transport
option,	the file is copied without conversion for later
processing.

ZZZZTTTTLLLLZZZZWWWW Lempel-Ziv compression.  Transmitted data	will be
     identical to that produced	by ccccoooommmmpppprrrreeeessssssss 4444....0000	operating on
     a computer	with VAX byte ordering,	using 12 bit
     encoding.

ZZZZTTTTCCCCRRRRYYYYPPPPTTTT	Encryption.  An	initial	null terminated	string
     identifies	the key.  Details to be	determined.



Chapter	11	       Rev 8-3-87  Typeset 10-18-87			27







Chapter	11		     ZMODEM Protocol				28



ZZZZTTTTRRRRLLLLEEEE Run Length encoding, Details to be determined.

A ZZZZCCCCRRRRCCCCWWWW	data subpacket follows with file name, file length,
modification date, and other information described in a	later
chapter.

11.5.4	ZZZZFFFF3333:::: EEEExxxxtttteeeennnnddddeeeedddd OOOOppppttttiiiioooonnnnssss
The Extended Options are bit encoded.

ZZZZTTTTSSSSPPPPAAAARRRRSSSS	Special	processing for sparse files, or	sender managed
     selective retransmission.	Each file segment is transmitted as
     a separate	frame, where the frames	are not	necessarily
     contiguous.  The sender should end	each segment with a ZCRCW
     data subpacket and	process	the expected ZACK to insure no data
     is	lost.  ZTSPARS cannot be used with ZCNL.

11.6  ZZZZSSSSKKKKIIIIPPPP

Sent by	the receiver in	response to ZZZZFFFFIIIILLLLEEEE, makes the sender skip to
the next file.

11.7  ZZZZNNNNAAAAKKKK

Indicates last header was garbled.  (See also ZZZZRRRRPPPPOOOOSSSS).

11.8  ZZZZAAAABBBBOOOORRRRTTTT

Sent by	receiver to terminate batch file transfers when	requested by
the user.  Sender responds with	a ZZZZFFFFIIIINNNN sequence.[2]

11.9  ZZZZFFFFIIIINNNN

Sent by	sending	program	to terminate a ZMODEM session.	Receiver
responds with its own ZZZZFFFFIIIINNNN.

11.10  ZZZZRRRRPPPPOOOOSSSS

Sent by	receiver to force file transfer	to resume at file offset
given in ZP0...ZP3.








__________

 2. Or ZZZZCCCCOOOOMMMMPPPPLLLL in case of server	mode.




Chapter	11	       Rev 8-3-87  Typeset 10-18-87			28







Chapter	11		     ZMODEM Protocol				29



11.11  ZZZZDDDDAAAATTTTAAAA

ZP0...ZP3 contain file offset.	One or more data subpackets follow.

11.12  ZZZZEEEEOOOOFFFF

Sender reports End of File.  ZP0...ZP3 contain the ending file
offset.

11.13  ZZZZFFFFEEEERRRRRRRR

Error in reading or writing file, protocol equivalent to ZZZZAAAABBBBOOOORRRRTTTT.

11.14  ZZZZCCCCRRRRCCCC

Request	(receiver) and response	(sender) for file polynomial.
ZP0...ZP3 contain file polynomial.

11.15  ZZZZCCCCHHHHAAAALLLLLLLLEEEENNNNGGGGEEEE

Request	sender to echo a random	number in ZP0...ZP3 in a ZACK frame.
Sent by	the receiving program to the sending program to	verify that
it is connected	to an operating	program, and was not activated by
spurious data or a Trojan Horse	message.

11.16  ZZZZCCCCOOOOMMMMPPPPLLLL

Request	now completed.

11.17  ZZZZCCCCAAAANNNN

This is	a pseudo frame type returned by	gethdr() in response to	a
Session	Abort sequence.

11.18  ZZZZFFFFRRRREEEEEEEECCCCNNNNTTTT

Sending	program	requests a ZACK	frame with ZP0...ZP3 containing	the
number of free bytes on	the current file system.  A value of 0
represents an indefinite amount	of free	space.

11.19  ZZZZCCCCOOOOMMMMMMMMAAAANNNNDDDD

ZCOMMAND is sent in a binary frame.  ZZZZFFFF0000 contains 0000 or ZZZZCCCCAAAACCCCKKKK1111 (see
below).

A ZCRCW	data subpacket follows,	with the ASCII text command string
terminated with	a NULL character.  If the command is intended to be
executed by the	operating system hosting the receiving program
(e.g., "shell escape"),	it must	have "!" as the	first character.
Otherwise the command is meant to be executed by the application
program	which receives the command.



Chapter	11	       Rev 8-3-87  Typeset 10-18-87			29







Chapter	11		     ZMODEM Protocol				30



If the receiver	detects	an illegal or badly formed command, the
receiver immediately responds with a ZCOMPL header with	an error
code in	ZP0...ZP3.

If ZF0 contained ZZZZCCCCAAAACCCCKKKK1111,,,, the receiver immediately responds with	a
ZCOMPL header with 0 status.

Otherwise, the receiver	responds with a	ZCOMPL header when the
operation is completed.	 The exit status of the	completed command is
stored in ZP0...ZP3.  A	0 exit status implies nominal completion of
the command.

If the command causes a	file to	be transmitted,	the command sender
will see a ZRQINIT frame from the other	computer attempting to send
data.

The sender examines ZF0	of the received	ZRQINIT	header to verify it
is not an echo of its own ZRQINIT header.  It is illegal for the
sending	program	to command the receiving program to send a command.

If the receiver	program	does not implement command downloading,	it
may display the	command	to the standard	error output, then return a
ZCOMPL header.



12.  SSSSEEEESSSSSSSSIIIIOOOONNNN TTTTRRRRAAAANNNNSSSSAAAACCCCTTTTIIIIOOOONNNN EEEEXXXXAAAAMMMMPPPPLLLLEEEESSSS

12.1  AAAA	ssssiiiimmmmpppplllleeee ffffiiiilllleeee ttttrrrraaaannnnssssffffeeeerrrr

A simple transaction, one file,	no errors, no CHALLENGE, overlapped
I/O:

Sender	       Receiver

"rz\r"
ZRQINIT(0)
	       ZRINIT
ZFILE
	       ZRPOS
ZDATA data ...
ZEOF
	       ZRINIT
ZFIN
	       ZFIN
OO








Chapter	12	       Rev 8-3-87  Typeset 10-18-87			30







Chapter	12		     ZMODEM Protocol				31



12.2  CCCChhhhaaaalllllllleeeennnnggggeeee	aaaannnndddd CCCCoooommmmmmmmaaaannnndddd DDDDoooowwwwnnnnllllooooaaaadddd


Sender		    Receiver

"rz\r"
ZRQINIT(ZCOMMAND)
		    ZCHALLENGE(random-number)
ZACK(same-number)
		    ZRINIT
ZCOMMAND, ZDATA
		    (Performs Command)
		    ZCOMPL
ZFIN
		    ZFIN
OO


13.  ZZZZFFFFIIIILLLLEEEE FFFFRRRRAAAAMMMMEEEE FFFFIIIILLLLEEEE IIIINNNNFFFFOOOORRRRMMMMAAAATTTTIIIIOOOONNNN

ZMODEM sends the same file information with the	ZZZZFFFFIIIILLLLEEEE frame data
that YMODEM Batch sends	in its block 0.

NNNN....BBBB....:::: TTTThhhheeee ppppaaaatttthhhhnnnnaaaammmmeeee ((((ffffiiiilllleeee nnnnaaaammmmeeee)))) ffffiiiieeeelllldddd iiiissss	mmmmaaaannnnddddaaaattttoooorrrryyyy....

PPPPaaaatttthhhhnnnnaaaammmmeeee The pathname (conventionally, the file	name) is sent as a
     null terminated ASCII string.  This is the	filename format	used
     by	the handle oriented MSDOS(TM) functions	and C library fopen
     functions.	 An assembly language example follows:
			   DB	  'foo.bar',0
     No	spaces are included in the pathname.  Normally only the	file
     name stem (no directory prefix) is	transmitted unless the
     sender has	selected YAM's ffff option	to send	the ffffuuuullllllll absolute or
     relative pathname.	 The source drive designator (A:, B:, etc.)
     usually is	not sent.

			 FFFFiiiilllleeeennnnaaaammmmeeee CCCCoooonnnnssssiiiiddddeeeerrrraaaattttiiiioooonnnnssss

	o+ File names should be translated to lower case	unless the
	  sending system supports upper/lower case file	names.	This
	  is a convenience for users of	systems	(such as Unix) which
	  store	filenames in upper and lower case.

	o+ The receiver should accommodate file names in	lower and
	  upper	case.

	o+ When transmitting files between different operating
	  systems, file	names must be acceptable to both the sender
	  and receiving	operating systems.  If not, transformations
	  should be applied to make the	file names acceptable.	If
	  the transformations are unsuccessful,	a new file name	may



Chapter	13	       Rev 8-3-87  Typeset 10-18-87			31







Chapter	13		     ZMODEM Protocol				32



	  be invented be the receiving program.

     If	directories are	included, they are delimited by	/; i.e.,
     "subdir/foo" is acceptable, "subdir\foo" is not.

LLLLeeeennnnggggtttthhhh The file	length and each	of the succeeding fields are
     optional.[1] The length field is stored as	a decimal string
     counting the number of data bytes in the file.

     The ZMODEM	receiver uses the file length as an estimate only.
     It	may be used to display an estimate of the transmission time,
     and may be	compared with the amount of free disk space.  The
     actual length of the received file	is determined by the data
     transfer.	A file may grow	after transmission commences, and
     all the data will be sent.

MMMMooooddddiiiiffffiiiiccccaaaattttiiiioooonnnn DDDDaaaatttteeee A single space separates the modification date
     from the file length.

     The mod date is optional, and the filename	and length may be
     sent without requiring the	mod date to be sent.

     The mod date is sent as an	octal number giving the	time the
     ccccoooonnnntttteeeennnnttttssss of the file were last changed measured in	seconds	from
     Jan 1 1970	Universal Coordinated Time (GMT).  A date of 0
     implies the modification date is unknown and should be left as
     the date the file is received.

     This standard format was chosen to	eliminate ambiguities
     arising from transfers between different time zones.


FFFFiiiilllleeee MMMMooooddddeeee A single space separates the file mode from the
     modification date.	 The file mode is stored as an octal string.
     Unless the	file originated	from a Unix system, the	file mode is
     set to 0.	rz(1) checks the file mode for the 0x8000 bit which
     indicates a Unix type regular file.  Files	with the 0x8000	bit
     set are assumed to	have been sent from another Unix (or
     similar) system which uses	the same file conventions.  Such
     files are not translated in any way.


SSSSeeeerrrriiiiaaaallll NNNNuuuummmmbbbbeeeerrrr A	single space separates the serial number from the
     file mode.	 The serial number of the transmitting program is
     stored as an octal	string.	 Programs which	do not have a serial


__________

 1. Fields may not be skipped.




Chapter	13	       Rev 8-3-87  Typeset 10-18-87			32







Chapter	13		     ZMODEM Protocol				33



     number should omit	this field, or set it to 0.  The receiver's
     use of this field is optional.

The file information is	terminated by a	null.  If only the pathname
is sent, the pathname is terminated with ttttwwwwoooo nulls.  The length	of
the file information subpacket,	including the trailing null, must
not exceed 1024	bytes; a typical length	is less	than 64	bytes.


14.  PPPPEEEERRRRFFFFOOOORRRRMMMMAAAANNNNCCCCEEEE RRRREEEESSSSUUUULLLLTTTTSSSS

14.1  CCCCoooommmmppppaaaattttiiiibbbbiiiilllliiiittttyyyy

Extensive testing has demonstrated ZMODEM to be	compatible with
satellite links, packet	switched networks, microcomputers,
minicomputers, regular and error correcting buffered modems at 75 to
19200 bps.  ZMODEM's economy of	reverse	channel	bandwidth allows
modems that dynamically	partition bandwidth between the	two
directions to operate at optimal speeds.

14.2  TTTThhhhrrrroooouuuugggghhhhppppuuuutttt

Between	two single task	PC-XT computers	sending	a program image	on
an in house Telenet link, SuperKermit provided 72 ch/sec throughput
at 1200	baud.  YMODEM-k	yielded	85 chars/sec, and ZMODEM provided
113 chars/sec.	XMODEM was not measured, but would have	been much
slower based on	observed network propagation delays.

Recent tests downloading large binary files to an IBM PC (4.7 mHz
V20) running YAMK 16.30	with table driven 32 bit CRC calculation
yielded	a throughput of	1870 cps on a 19200 bps	direct connection.

Tests with TELEBIT TrailBlazer modems have shown transfer rates
approaching 1400 characters per	second for long	files.	When files
are compressed,	effective transfer rates of 2000 characters per
second are possible.


14.3  EEEErrrrrrrroooorrrr RRRReeeeccccoooovvvveeeerrrryyyy

Some tests of ZMODEM protocol error recovery performance have been
made.  A PC-AT with SCO	SYS V Xenix or DOS 3.1 was connected to	a PC
with DOS 2.1 either directly at	9600 bps or with unbuffered dial-up
1200 bps modems.  The ZMODEM software was configured to	use 1024
byte data subpacket lengths above 2400 bps, 256	otherwise.

Because	no time	delays are necessary in	normal file transfers, per
file negotiations are much faster than with YMODEM, the	only
observed delay being the time required by the program(s) to update
logging	files.




Chapter	14	       Rev 8-3-87  Typeset 10-18-87			33







Chapter	14		     ZMODEM Protocol				34



During a file transfer,	a short	line hit seen by the receiver
usually	induces	a CRC error.  The interrupt sequence is	usually	seen
by the sender before the next data subpacket is	completely sent, and
the resultant loss of data throughput averages about half a data
subpacket per line hit.	 At 1200 bps this is would be about .75
second lost per	hit.  At 10-5 error rate, this would degrade
throughput by about 9 per cent.

The throughput degradation increases with increasing channel delay,
as more	data subpackets	in transit through the channel are discarded
when an	error is detected.

A longer noise burst that affects both the receiver and	the sender's
reception of the interrupt sequence usually causes the sender to
remain silent until the	receiver times out in 10 seconds.  If the
round trip channel delay exceeds the receiver's	10 second timeout,
recovery from this type	of error may become difficult.

Noise affecting	only the sender	is usually ignored, with one common
exception.  Spurious XOFF characters generated by noise	stop the
sender until the receiver times	out and	sends an interrupt sequence
which concludes	with an	XON.

In summation, ZMODEM performance in the	presence of errors resembles
that of	X.PC and SuperKermit.  Short bursts cause minimal data
retransmission.	 Long bursts (such as pulse dialing noises) often
require	a timeout error	to restore the flow of data.


15.  PPPPAAAACCCCKKKKEEEETTTT SSSSWWWWIIIITTTTCCCCHHHHEEEEDDDD NNNNEEEETTTTWWWWOOOORRRRKKKK CCCCOOOONNNNSSSSIIIIDDDDEEEERRRRAAAATTTTIIIIOOOONNNNSSSS

Flow control is	necessary for printing messages	and directories, and
for streaming file transfer protocols.	A non transparent flow
control	is incompatible	with XMODEM and	YMODEM transfers.  XMODEM
and YMODEM protocols require complete transparency of all 256 8	bit
codes to operate properly.

The "best" flow	control	(when X.25 or hardware CTS is unavailable)
would not "eat"	any characters at all.	When the PAD's buffer almost
fills up, an XOFF should be emitted.  When the buffer is no longer
nearly full, send an XON.  Otherwise, the network should neither
generate nor eat XON or	XOFF control characters.

On Telenet, this can be	met by setting CCIT X3 5:1 and 12:0 at bbbbooootttthhhh
ends of	the network.  For best throughput, parameter 64	(advance
ACK) should be set to something	like 4.	 Packets should	be forwarded
when the packet	is a full 128 bytes, or	after a	moderate delay
(3:0,4:10,6:0).

With PC-Pursuit, it is sufficient to set parameter 5 to	1 at both
ends after one is connected to the remote modem.



Chapter	15	       Rev 8-3-87  Typeset 10-18-87			34







Chapter	15		     ZMODEM Protocol				35



	<ENTER>@<ENTER>
	set 5:1<ENTER>
	rst? 5:1<ENTER>
	cont<ENTER>

Unfortunately, many PADs do not	accept the "rst?" command.

For YMODEM, PAD	buffering should guarantee that	a minimum of 1040
characters can be sent in a burst without loss of data or generation
of flow	control	characters.  Failure to	provide	this buffering will
generate excessive retries with	YMODEM.

	     TTTTAAAABBBBLLLLEEEE 1111....  Network and Flow	Control	Compatibility

______________________________________________________________________________
|   Connectivity    |  Interactive|  XMODEM|  WXMODEM|	SUPERKERMIT|  ZMODEM |
_|________________________________________|____________________________|__________________|____________________|____________________________|____________________|_
_|____________________|______________|_________|__________|______________|__________|
|Direct	Connect	    |  YES	  |  YES   |  YES    |	YES	   |  YES    |
_|____________________|______________|_________|__________|______________|__________|
|Network, no FC	    |  nnnnoooo	  |  YES   |  (4)    |	(6)	   |  YES (1)|
_|____________________|______________|_________|__________|______________|__________|
|Net, transparent FC|  YES	  |  YES   |  YES    |	YES	   |  YES    |
_|____________________|______________|_________|__________|______________|__________|
|Net, non-trans. FC |  YES	  |  nnnnoooo	   |  no (5) |	YES	   |  YES    |
_|____________________|______________|_________|__________|______________|__________|
|Network, 7 bit	    |  YES	  |  nnnnoooo	   |  no     |	YES (2)	   |  YES (3)|
_|____________________|______________|_________|__________|______________|__________|

(1) ZMODEM can optimize	window size or burst length for	fastest
transfers.
(2) Parity bits	must be	encoded, slowing binary	transfers.
(3) Natural protocol extension possible	for encoding data to 7 bits.
(4) Small WXMODEM window size may may allow operation.
(5) Some flow control codes are	not escaped in WXMODEM.
(6) Kermit window size must be reduced to avoid	buffer overrun.


16.  PPPPEEEERRRRFFFFOOOORRRRMMMMAAAANNNNCCCCEEEE CCCCOOOOMMMMPPPPAAAARRRRIIIISSSSOOOONNNN TTTTAAAABBBBLLLLEEEESSSS


"Round Trip Delay Time"	includes the time for the last byte in a
packet to propagate through the	operating systems and network to the
receiver, plus the time	for the	receiver's response to that packet
to propagate back to the sender.

The figures shown below	are calculated for round trip delay times of
40 milliseconds	and 5 seconds.	Shift registers	in the two computers
and a pair of 212 modems generate a round trip delay time on the
order of 40 milliseconds.  Operation with busy timesharing computers
and networks can easily	generate round trip delays of five seconds.



Chapter	16	       Rev 8-3-87  Typeset 10-18-87			35







Chapter	16		     ZMODEM Protocol				36



Because	the round trip delays cause visible interruptions of data
transfer when using XMODEM protocol, the subjective effect of these
delays is greatly exaggerated, especially when the user	is paying
for connect time.

A 102400 byte binary file with randomly	distributed codes is sent at
1200 bps 8 data	bits, 1	stop bit.  The calculations assume no
transmission errors.  For each of the protocols, only the per file
functions are considered.  Processor and I/O overhead are not
included.  YM-k	refers to YMODEM with 1024 byte	data packets.  YM-g
refers to the YMODEM "g" option.  ZMODEM uses 256 byte data
subpackets for this example.  SuperKermit uses maximum standard
packet size, 8 bit transparent transmission, no	run length
compression.  The 4 block WXMODEM window is too	small to span the 5
second delay in	this example; the resulting thoughput degradation is
ignored.

For comparison,	a straight "dump" of the file contents with no file
management or error checking takes 853 seconds.

		 TTTTAAAABBBBLLLLEEEE 2222....  Protocol Overhead Information
	   (102400 byte	binary file, 5 Second Round Trip)

____________________________________________________________________________
|      Protocol	      |	 XMODEM|  YM-k |  YM-g|	 ZMODEM|  SKermit|  WXMODEM|
_|____________________________________________|__________________|________________|______________|__________________|____________________|____________________|_
_|______________________|_________|________|_______|_________|__________|__________|
|Protocol Round	Trips |	 804   |  104  |  5   |	 5     |  5	 |  4	   |
_|______________________|_________|________|_______|_________|__________|__________|
|Trip Time at 40ms    |	 32s   |  4s   |  0   |	 0     |  0	 |  0	   |
_|______________________|_________|________|_______|_________|__________|__________|
|Trip Time at 5s      |	 4020s |  520s |  25s |	 25s   |  25	 |  20	   |
_|____________________________________________|__________________|________________|______________|__________________|____________________|____________________|_
_|______________________|_________|________|_______|_________|__________|__________|
|Overhead Characters  |	 4803  |  603  |  503 |	 3600  |  38280	 |  8000   |
_|____________________________________________|__________________|________________|______________|__________________|____________________|____________________|_
_|______________________|_________|________|_______|_________|__________|__________|
|Line Turnarounds     |	 1602  |  204  |  5   |	 5     |  2560	 |  1602   |
_|____________________________________________|__________________|________________|______________|__________________|____________________|____________________|_
_|______________________|_________|________|_______|_________|__________|__________|
|Transfer Time at 0s  |	 893s  |  858s |  857s|	 883s  |  1172s	 |  916s   |
_|______________________|_________|________|_______|_________|__________|__________|
|Transfer Time at 40ms|	 925s  |  862s |  857s|	 883s  |  1172s	 |  916s   |
_|______________________|_________|________|_______|_________|__________|__________|
|Transfer Time at 5s  |	 5766s |  1378s|  882s|	 918s  |  1197s	 |  936s   |
_|______________________|_________|________|_______|_________|__________|__________|








Chapter	16	       Rev 8-3-87  Typeset 10-18-87			36







Chapter	16		     ZMODEM Protocol				37



		 FFFFiiiigggguuuurrrreeee	5555....  Transmission Time Comparison
	   (102400 byte	binary file, 5 Second Round Trip)

************************************************** XMODEM
************ YMODEM-K
********** SuperKermit (Sliding	Windows)
*******	ZMODEM 16kb Segmented Streaming
*******	ZMODEM Full Streaming
*******	YMODEM-G

	TTTTAAAABBBBLLLLEEEE 3333....  Local	Timesharing Computer Download Performance

__________________________________________________________________________
|    Command	|  Protocol|  Time/HD|	Time/FD|  Throughput|  Efficiency|
_|________________________________|______________________|____________________|____________________|__________________________|__________________________|_
_|________________|___________|__________|__________|_____________|_____________|
|kermit	-x	|  Kermit  |  1:49   |	2:03   |  327	    |  34%	 |
_|________________|___________|__________|__________|_____________|_____________|
|sz -Xa	phones.t|  XMODEM  |  1:20   |	1:44   |  343	    |  36%	 |
_|________________|___________|__________|__________|_____________|_____________|
|sz -a phones.t	|  ZMODEM  |   :39   |	 :48   |  915	    |  95%	 |
_|________________|___________|__________|__________|_____________|_____________|


Times were measured downloading	a 35721	character text file at 9600
bps, from Santa	Cruz SysV 2.1.2	Xenix on a 9 mHz IBM PC-AT to DOS
2.1 on an IBM PC.  Xenix was in	multiuser mode but otherwise idle.
Transfer times to PC hard disk and floppy disk destinations are
shown.

C-Kermit 4.2(030) used server mode and file compression, sending to
Pro-YAM	15.52 using 0 delay and	a "get phones.t" command.

Crosstalk XVI 3.6 used XMODEM 8	bit checksum (CRC not available) and
an "ESC	rx phones.t" command.  The Crosstalk time does nnnnooootttt include
the time needed	to enter the extra commands not	needed by Kermit and
ZMODEM.

Professional-YAM used ZMODEM AutoDownload.  ZMODEM times included a
security challenge to the sending program.














Chapter	16	       Rev 8-3-87  Typeset 10-18-87			37







Chapter	16		     ZMODEM Protocol				38



		      TTTTAAAABBBBLLLLEEEE 4444....	File Transfer Speeds

__________________________________________________________________________________
| Prot	       file	   bytes    bps	    ch/sec		 Notes		 |
_|__________________________________________________________________________________________________________________________________________________________________|_
|X	  jancol.c	   18237    2400   53	       Tymnet PTL 5/3/87	 |
|X	  source.xxx	   6143	    2400   56	       Source/Telenet PTL 5/29/87|
|X	  jancol.c	   18237    2400   64	       Tymnet PTL		 |
|B	  jancol.c	   18237    1200   87	       DataPac (604-687-7144)	 |
|XN	  tsrmaker.arc	   25088    1200   94	       GEnie PTL		 |
|B/ovth	  emaibm.arc	   51200    1200   101	       CIS PTL MNP		 |
|UUCP	  74 files, each   >7000    1200   102	       Average,	Various	callers	 |
|ZM	  jancol.c	   18237    1200   112	       DataPac (604-687-7144)	 |
|X/ovth	  emaibm.arc	   51200    1200   114	       CIS PTL MNP		 |
|ZM	  emaibm.arc	   51200    1200   114	       CIS PTL MNP		 |
|B	  jancol.c	   18237    2400   124	       Tymnet PTL		 |
|B	  YI0515.87	   9081	    2400   157	       CIS PTL node 5/29/87	 |
|SK	  source.xxx	   6143	    2400   170	       Source/Telenet PTL 5/29/87|
|ZM	  jancol.c	   18237    2400   221	       Tymnet PTL upl/dl	 |
|B/ovth	  destro.gif	   33613    2400   223	       CIS/PTL LEVEL 5 9-12-87	 |
|ZM	  jancol.c	   18237    2400   224	       Tymnet PTL		 |
|ZM	  jancol.c	   18237    2400   226/218     TeleGodzilla upl		 |
|ZM	  jancol.c	   18237    2400   226	       Tymnet PTL 5/3/87	 |
|ZM	  zmodem.ov	   35855    2400   227	       CIS PTL node		 |
|C	  jancol.c	   18237    2400   229	       Tymnet PTL 5/3/87	 |
|ZM	  jancol.c	   18237    2400   229/221     TeleGodzilla		 |
|ZM	  zmodem.ov	   35855    2400   229	       CIS PTL node upl		 |
|ZM	  jancol.c	   18237    2400   232	       CIS PTL node		 |
|ZM	  mbox		   473104   9600   948/942     TeleGodzilla upl		 |
|ZM	  zmodem.arc	   318826   14k	   1357/1345   TeleGodzilla		 |
|ZM	  mbox		   473104   14k	   1367/1356   TeleGodzilla upl		 |
|ZM	  c2.doc	   218823   38k	   3473	       Xenix 386 Toolkit upl	 |
|ZM	  mbox		   511893   38k	   3860	       386 Xenix 2.2 Beta #	 |
|ZM	  c.doc		   218823   57k	   5611	       **			 |
_|_________________________________________________________________________________|

Times are for downloads	unless noted.  Where two speeds	are noted,
the faster speed is reported by	the receiver because its transfer
time calculation excludes the security check and transaction log
file processing.  The TeleGodzilla computer is a 4.77 mHz IBM PC
with a 10 MB hard disk.	 The 386 computer uses an Intel	motherboard
at 18 mHz 1ws.	The AT Clone (QIC) runs	at 8 mHz 0ws.
Abbreviations:
 B     Compuserve B Protocol
 B/ovth			CIS B with Omen	Technology OverThruster(TM)
 C     Capture DC2/DC4 (no protocol)
 K     Kermit
 MNP   Microcom	MNP error correcting SX/1200 modem
 PTL   Portland	Oregon network node
 SK    Sliding Window Kermit (SuperKermit) w=15
 X     XMODEM



Chapter	16	       Rev 8-3-87  Typeset 10-18-87			38







Chapter	16		     ZMODEM Protocol				39



 XN    XMODEM protocol implemented in network modes
 X/ovth			XMODEM,	Omen Technology	OverThruster(TM)
 ZM    ZMODEM
 Tk    Xenix 386 Toolkit, rz compiled -M3, dumb	serial port
 **    AT Clone	ramdisk	to 386 ramdisk,	or either ramdisk to nul
 #     On the fly format translation NL	to CR/LF
		       TTTTAAAABBBBLLLLEEEE 5555....	 Protocol Checklist

_________________________________________________________________________
|Item		       XMODEM  WXMODEM	YMDM-k	 YMDM-g	 ZMODEM	 SKermit|
_|________________________________________|__________________|__________________|__________________|________________|________________|__________________|_
|IIIINNNN SSSSEEEERRRRVVVVIIIICCCCEEEE	    |  1977  | 1986   |	1982   | 1985  | 1986  | 1985	|
_|____________________|_________|_________|_________|________|________|_________|
|UUUUSSSSEEEERRRR FFFFEEEEAAAATTTTUUUURRRREEEESSSS	    |	     |	      |	       |       |       |	|
|User Friendly I/F  |  -     | -      |	-      | -     | YES   | -	|
|Commands/batch	    |  2*N   | 2*N    |	2      | 2     | 1     | 1(1)	|
|Commands/file	    |  2     | 2      |	0      | 0     | 0     | 0	|
|Command Download   |  -     | -      |	-      | -     | YES   | YES(6)	|
|Menu Compatible    |  -     | -      |	-      | -     | YES   | -	|
|Transfer Recovery  |  -     | -      |	-      | -     | YES   | -	|
|File Management    |  -     | -      |	-      | -     | YES   | -	|
|Security Check	    |  -     | -      |	-      | -     | YES   | -	|
|YMODEM	Fallback    |  YES   | YES    |	YES    | YES   | YES   | -	|
_|____________________|_________|_________|_________|________|________|_________|
|CCCCOOOOMMMMPPPPAAAATTTTIIIIBBBBIIIILLLLIIIITTTTYYYY	    |	     |	      |	       |       |       |	|
|Dynamic Files	    |  YES   | YES    |	FFFFAAAAIIIILLLL   | FFFFAAAAIIIILLLL  | YES   | YES	|
|Packet	SW NETS	    |  -     | YES    |	-      | -     | YES   | YES	|
|7 bit PS NETS	    |  -     | -      |	-      | -     | (8)   | YES	|
|Old Mainframes	    |  -     | -      |	-      | -     | (8)   | YES	|
|CP/M-80	    |  YES   | YES    |	YES    | -     | YES(9)| -	|
_|____________________|_________|_________|_________|________|________|_________|
|AAAATTTTTTTTRRRRIIIIBBBBUUUUTTTTEEEESSSS	    |	     |	      |	       |       |       |	|
|Reliability(5)	    |  fair  | poor   |	fair(5)| none  | BEST  | HIGH	|
|Streaming	    |  -     | YES    |	-      | YES   | YES   | YES	|
|Overhead(2)	    |  7%    | 7%     |	1%     | 1%    | 1%    | 30%	|
|Faithful Xfers	    |  -     | -      |	YES    | YES   | YES   | YES	|
|Preserve Date	    |  -     | -      |	YES    | YES   | YES   | -	|
_|____________________|_________|_________|_________|________|________|_________|
|CCCCOOOOMMMMPPPPLLLLEEEEXXXXIIIITTTTYYYY	    |	     |	      |	       |       |       |	|
|No-Wait Sample	    |  -     | REQD   |	-      | -     | opt   | REQD	|
|Ring Buffers	    |  -     | REQD   |	-      | -     | opt   | REQD	|
|XMODEM	Similar	    |  YES   | LOW    |	HIGH   | HIGH  | LOW   | NONE	|
|Complexity	    |  LOW(5)| MED    |	LOW(5) | LOW   | MED   | HIGH	|
_|____________________|_________|_________|_________|________|________|_________|
|EEEEXXXXTTTTEEEENNNNSSSSIIIIOOOONNNNSSSS	    |	     |	      |	       |       |       |	|
|Server	Operation   |  -     | -      |	-      | -     | YES(4)| YES	|
|Multiple Threads   |  -     | -      |	-      | -     | future| -	|
_|________________________________________|__________________|__________________|__________________|________________|________________|__________________|_

NOTES:
(1) Server mode	or Omen	Technology Kermit AutoDownload



Chapter	16	       Rev 8-3-87  Typeset 10-18-87			39







Chapter	16		     ZMODEM Protocol				40



(2) Character count, binary file, transparent channel
(3) 32 bit math	needed for accurate transfer (no garbage added)
(4) AutoDownload operation
(5) CCCCyyyybbbbeeeerrrrnnnneeeettttiiiicccc DDDDaaaattttaaaa RRRReeeeccccoooovvvveeeerrrryyyy((((TTTTMMMM)))) improves XMODEM and YMODEM
reliability with complex proprietary logic.
(6) Server commands only
(7) No provision for transfers across time zones
(8) Future enhancement provided	for
(9) With Segmented Streaming
WXMODEM: XMODEM	derivative protocol with data encoding and windowing












































Chapter	16	       Rev 8-3-87  Typeset 10-18-87			40







Chapter	16		     ZMODEM Protocol				41



17.  FFFFUUUUTTTTUUUURRRREEEE EEEEXXXXTTTTEEEENNNNSSSSIIIIOOOONNNNSSSS

Future extensions include:

   o+ Compatibility with	7 bit networks

   o+ Server/Link Level operation: An END-TO-END	error corrected
     program to	program	session	is required for	financial and other
     sensitive applications.

   o+ Multiple independent threads

   o+ Encryption

   o+ Compression

   o+ File Comparison

   o+ Selective transfer	within a file (e.g., modified segments of a
     database file)

   o+ Selective Retransmission for error	correction


18.  RRRREEEEVVVVIIIISSSSIIIIOOOONNNNSSSS

07-31-1987 The receiver	should ignore a	ZEOF with an offset that
does not match the current file	length.	 The previous action of
responding with	ZRPOS caused transfers to fail if a CRC	error
occurred immediately before end	of file, because two retransmission
requests were being sent for each error.  This has been	observed
under exceptional conditions, such as data transmission	at speeds
greater	than the receiving computer's interrupt	response capabilitiy
or gross misapplication	of flow	control.

Discussion of the Tx backchannel garbage count and ZCRCW after error
ZRPOS was added.  Many revisions for clarity.
07-09-87 Corrected XMODEM's development	date, incorrectly stated as
1979 instead of	the actual August 1977.	 More performance data was
added.
05-30-87 Added ZMNEW and ZMSKNOLOC
05-14-87 Window	management, ZACK zshhdr	XON removed, control
character escaping, ZMSPARS changed to ZXPARS, editorial changes.
04-13-87  The ZMODEM file transfer protocol's public domain status
is emphasized.
04-04-87: minor	editorial changes, added conditionals for overview
version.
03-15-87: 32 bit CRC added.
12-19-86: 0 Length ZCRCW data subpacket	sent in	response to ZPAD or
ZDELE detected on reverse channel has been changed to ZCRCE.  The
reverse	channel	is now checked for activity before sending each



Chapter	18	       Rev 8-3-87  Typeset 10-18-87			41







Chapter	18		     ZMODEM Protocol				42



ZDATA header.
11-08-86: Minor	changes	for clarity.
10-2-86:  ZCNL definition expanded.
9-11-86:  ZMPROT file management option	added.
8-20-86:  More performance data	included.
8-4-86:	 ASCII DLE (Ctrl-P, 020) now escaped; compatible with
previous versions.  More document revisions for	clarity.
7-15-86: This document was extensively edited to improve clarity and
correct	small errors.  The definition of the ZMNEW management option
was modified, and the ZMDIFF management	option was added.  The
cancel sequence	was changed from two to	five CAN characters after
spurious two character cancel sequences	were detected.


19.  MMMMOOOORRRREEEE IIIINNNNFFFFOOOORRRRMMMMAAAATTTTIIIIOOOONNNN

Please contact Omen Technology for troff source	files and typeset
copies of this document.


19.1  TTTTeeeelllleeeeGGGGooooddddzzzziiiillllllllaaaa BBBBuuuulllllllleeeettttiiiinnnn BBBBooooaaaarrrrdddd

More information may be	obtained by calling the	TeleGodzilla
bulletin board at 503-621-3746.	 TeleGodzilla supports 2400 and	1200
bps callers with automatic speed recognition.  Once connected,
Telebit	TrailBlazer uses can keyboard
		    trailblazer
to switch the modems to	high speed (19kb) operation.

Relevant files include YZMODEM.ZOO, YAMDEMO.ZOO, YAMHELP.ZOO,
ZCOMMEXE.ARC, ZCOMMDOC.ARC, ZCOMMHLP.ARC, and YMODEM.DQC.

Useful commands	for TeleGodzilla include "menu", "dir",	"sx file
(XMODEM)", "kermit sb file ...", and "sz file ...".

19.2  UUUUnnnniiiixxxx UUUUUUUUCCCCPPPP	AAAAcccccccceeeessssssss

UUCP sites can obtain the current version of this file with
	      uucp omen!/u/caf/public/zmodem.doc /tmp
A continually updated list of available	files is stored	in
/usr/spool/uucppublic/FILES.
	   uucp	 omen!~uucp/FILES   /usr/spool/uucppublic

The following L.sys line allows	UUCP to	call site "omen" via Omen's
bulletin board system "TeleGodzilla".  TeleGodzilla is an instance
of Omen	Technology's Professional-YAM in host operation, acting	as a
bulletin board and front ending	a Xenix	system.

In response to TeleGodzilla's "Name Please:" (e:--e:), uucico gives
the Pro-YAM "link" command as a	user name.  Telegodzilla then asks
for a link password (d:).  The password	(Giznoid) controls access to



Chapter	19	       Rev 8-3-87  Typeset 10-18-87			42







Chapter	19		     ZMODEM Protocol				43



the Xenix system connected to the IBM PC's other serial	port.
Communications between Pro-YAM and Xenix use 9600 bps; YAM converts
this to	the caller's speed.

Finally, the calling uucico sees the Xenix "Login:" message (n:--
n:), and logs in as "uucp".  No	password is used for the uucp
account.

omen Any ACU 2400 1-503-621-3746 e:--e:	link d:	Giznoid	n:--n: uucp



20.  ZZZZMMMMOOOODDDDEEEEMMMM PPPPRRRROOOOGGGGRRRRAAAAMMMMSSSS

A copy of this document, a demonstration version of
Professional-YAM, a flash-up tree structured help file and
processor, are available in _Y_Z_M_O_D_E_M._Z_O_O	on TeleGodzilla	and other
bulletin boards.  This file must be unpacked with _L_O_O_Z._E_X_E, also
available on TeleGodzilla.  _Y_Z_M_O_D_E_M._Z_O_O	may be distributed provided
none of	the files are deleted or modified without the written
consent	of Omen	Technology.

TeleGodzilla and other bulletin	boards also feature ZZZZCCCCOOOOMMMMMMMM, a
shareware communications program.  ZCOMM includes Omen Technology's
TurboLearn(TM) Script Writer, ZMODEM, Omen's highly acclaimed XMODEM
and YMODEM protocol support, Sliding Windows Kermit, several
traditional protocols, a powerful script language, and the most
accurate VT100/102 emulation available in a usr	supported program.
The ZCOMM files	include:

  o+ ZZZZCCCCOOOOMMMMMMMMEEEEXXXXEEEE....AAAARRRRCCCC Executable files and beginner's telephone directory

  o+ ZZZZCCCCOOOOMMMMMMMMDDDDOOOOCCCC....AAAARRRRCCCC "Universal Line Printer Edition" Manual

  o+ ZZZZCCCCOOOOMMMMMMMMHHHHLLLLPPPP....AAAARRRRCCCC Tree structured Flash-UP help processor and
    database

Source code and	manual pages for the Unix/Xenix	_r_z and _s_z programs
are available on TeleGodzilla in _R_Z_S_Z._Z_O_O.  This ZOO archive may be
unpacked with _L_O_O_Z._E_X_E,	also available on TeleGodzilla.	 Most Unix
like systems are supported, including V7, Sys III, 4.x BSD, SYS	V,
Idris, Coherent, and Regulus.

_R_Z_S_Z._Z_O_O includes a ZCOMM/Pro-YAM/PowerCom script _Z_U_P_L._T to upload
the small (178 lines) YMODEM bootstrap program _M_I_N_I_R_B._C	without	a
file transfer protocol.	 _M_I_N_I_R_B	uses the Unix stty(1) program to set
the required raw tty modes, and	compiles without special flags on
virtually all Unix and Xenix systems.  _Z_U_P_L._T directs the Unix
system to compile _M_I_N_I_R_B, then uses it as a bootstrap to upload	the
rz/sz source and manual	files.




Chapter	20	       Rev 8-3-87  Typeset 10-18-87			43







Chapter	20		     ZMODEM Protocol				44



The PC-DOS OOOOppppuuuussss	and NNNNoooocccchhhhaaaannnnggggeeee bulletin boards support ZMODEM.
Integrated ZMODEM support for the CCCCoooolllllllliiiieeee bulletin board	program	is
planned.

A number of other bulletin board programs support ZMODEM with
external modules (DSZ, etc.).

The PC-DOS Teleconferencing system IIIINNNN----SSSSYYYYNNNNCCCCHHHH uses ZMODEM.

The LAN	modem sharing program LLLLiiiinnnneeee PPPPlllluuuussss	has announced ZMODEM
support.

Other PC-DOS communications programs with ZMODEM support modules
include	QMODEM and BOYAN.  Many	programs are adding direct ZMODEM
support, including Crosstalk Mark IV, Telix 3.0, and (expected)
Procomm	and Qmodem.

The ZZZZMMMMDDDDMMMM communications	program	by Jwahar Bammi	runs on	Atari ST
machines.

The OOOOnnnnlllliiiinnnneeee!!!!  program for the Amiga supports ZMODEM.

The Compuserve Information Service has ported the Unix rz/sz ZMODEM
programs to DECSYSTEM 20 assembler.

20.1  AAAAddddddddiiiinnnngggg ZZZZMMMMOOOODDDDEEEEMMMM ttttoooo DDDDOOOOSSSS PPPPrrrrooooggggrrrraaaammmmssss

_D_S_Z is a small program that supports XMODEM, YMODEM, and ZMODEM	file
transfers.  _D_S_Z	is designed to be called from a	bulletin board
program	or another communications program.  It may be called as
		     dsz port 2	sz file1 file2
to send	files, or as
			   dsz port 2 rz
to receive zero	or more	file(s), or as
		     dsz port 2	rz filea fileb
to receive two files, the first	to _f_i_l_e_a and the second	(if sent) to
_f_i_l_e_b.	This form of _d_s_z may be	used to	control	the pathname of
incoming file(s).  In this example, if the sending program attempted
to send	a third	file, the transfer would be terminated.

_D_s_z uses DOS stdout for	messages (no direct CRT	access), acquires
the COMM port vectors with standard DOS	calls, and restores the	COMM
port's interrupt vector	and registers upon exit.

Further	information on _d_s_z may be found	in _d_s_z._d_o_c and the ZCOMM or
Pro-YAM	user manuals.








Chapter	21	       Rev 8-3-87  Typeset 10-18-87			44







Chapter	21		     ZMODEM Protocol				45



21.  YYYYMMMMOOOODDDDEEEEMMMM PPPPRRRROOOOGGGGRRRRAAAAMMMMSSSS

The Unix _r_z/_s_z programs	support	YMODEM as well as ZMODEM.  Most	Unix
like systems are supported, including V7, Sys III, 4.2 BSD, SYS	V,
Idris, Coherent, and Regulus.

A version for VAX-VMS is available in VRBSB.SHQ, in the	same
directory.

Irv Hoff has added 1k packets and YMODEM transfers to the KMD and
IMP series programs, which replace the XMODEM and MODEM7/MDM7xx
series respectively.  Overlays are available for a wide	variety	of
CP/M systems.

Many other programs, including MEX-PLUS	and Crosstalk Mark IV also
support	some of	YMODEM's features.

Questions about	YMODEM,	the Professional-YAM communications program,
and requests for evaluation copies may be directed to:

     Chuck Forsberg
     Omen Technology Inc
     17505-V Sauvie Island Road
     Portland Oregon 97231
     VOICE: 503-621-3406 :VOICE
     Modem (TeleGodzilla): 503-621-3746
     Usenet: ...!tektronix!reed!omen!caf
     Compuserve: 70007,2304
     Source: TCE022


22.  AAAACCCCKKKKNNNNOOOOWWWWLLLLEEEEDDDDGGGGMMMMEEEENNNNTTTTSSSS

ZMODEM was developed _f_o_r _t_h_e _p_u_b_l_i_c _d_o_m_a_i_n under a Telenet contract.
The ZMODEM protocol descriptions and the Unix rz/sz program source
code are public	domain.	 No licensing, trademark, or copyright
restrictions apply to the use of the protocol, the Unix	rz/sz source
code and the _Z_M_O_D_E_M name.

Encouragement and suggestions by Thomas	Buck, Ward Christensen,	Earl
Hall, Irv Hoff,	Stuart Mathison, and John Wales, are gratefully
acknowledged.  32 bit CRC code courtesy	Gary S.	Brown.


23.  RRRREEEELLLLAAAATTTTEEEEDDDD FFFFIIIILLLLEEEESSSS

The following files may	be useful while	studying this document:

YYYYMMMMOOOODDDDEEEEMMMM....DDDDOOOOCCCC Describes the XMODEM, XMODEM-1k, and	YMODEM batch file
	transfer protocols.  This file is available on TeleGodzilla
	as YMODEM.DQC.



Chapter	23	       Rev 8-3-87  Typeset 10-18-87			45







Chapter	23		     ZMODEM Protocol				46



zzzzmmmmooooddddeeeemmmm....hhhh Definitions for ZMODEM	manifest constants

rrrrzzzz....cccc,,,, sssszzzz....cccc,,,, rrrrbbbbssssbbbb....cccc Unix	source code for	operating ZMODEM programs.

rrrrzzzz....1111,,,, sssszzzz....1111 Manual pages	for rz and sz (Troff sources).

zzzzmmmm....cccc	Operating system independent low level ZMODEM subroutines.

mmmmiiiinnnniiiirrrrbbbb....cccc A YMODEM bootstrap program, 178 lines.

RRRRZZZZSSSSZZZZ....ZZZZOOOOOOOO,,,,rrrrzzzzsssszzzz....aaaarrrrcccc Contain the C	source code and	manual pages listed
	above, plus a ZCOMM script to upload minirb.c to a Unix	or
	Xenix system, compile it, and use the program to upload	the
	ZMODEM source files with error checking.

DDDDSSSSZZZZ....ZZZZOOOOOOOO,,,,ddddsssszzzz....aaaarrrrcccc	Contains DSZ.COM, a shareware X/Y/ZMODEM subprogram,
	DESQview "pif" files for background operation in minimum
	memory,	and DSZ.DOC.

ZZZZCCCCOOOOMMMMMMMM****....AAAARRRRCCCC Archive files for ZCOMM, a powerful shareware
	communications program.

































Chapter	23	       Rev 8-3-87  Typeset 10-18-87			46











			      CONTENTS


 1.  INTENDED AUDIENCE................................................	 2

 2.  WHY DEVELOP ZMODEM?..............................................	 2

 3.  ZMODEM Protocol Design Criteria..................................	 4
     3.1    Ease of Use...............................................	 4
     3.2    Throughput................................................	 5
     3.3    Integrity and Robustness..................................	 6
     3.4    Ease of Implementation....................................	 6

 4.  EVOLUTION OF ZMODEM..............................................	 7

 5.  ROSETTA STONE....................................................	10

 6.  ZMODEM REQUIREMENTS..............................................	10
     6.1    File Contents.............................................	10

 7.  ZMODEM BASICS....................................................	12
     7.1    Packetization.............................................	12
     7.2    Link Escape	Encoding......................................	12
     7.3    Header....................................................	13
     7.4    Binary Data	Subpackets....................................	16
     7.5    ASCII Encoded Data Subpacket..............................	16

 8.  PROTOCOL TRANSACTION OVERVIEW....................................	16
     8.1    Session Startup...........................................	16
     8.2    File Transmission.........................................	18
     8.3    Session Cleanup...........................................	20
     8.4    Session Abort Sequence....................................	20

 9.  STREAMING TECHNIQUES / ERROR RECOVERY............................	21
     9.1    Full Streaming with	Sampling..............................	21
     9.2    Full Streaming with	Reverse	Interrupt.....................	23
     9.3    Full Streaming with	Sliding	Window........................	23
     9.4    Full Streaming over	Error Free Channels...................	24
     9.5    Segmented Streaming.......................................	24

10.  ATTENTION SEQUENCE...............................................	24

11.  FRAME TYPES......................................................	25
     11.1   ZRQINIT...................................................	25
     11.2   ZRINIT....................................................	25
     11.3   ZSINIT....................................................	25
     11.4   ZACK......................................................	26
     11.5   ZFILE.....................................................	26
     11.6   ZSKIP.....................................................	28
     11.7   ZNAK......................................................	28
     11.8   ZABORT....................................................	28



				  - i -











     11.9   ZFIN......................................................	28
     11.10  ZRPOS.....................................................	28
     11.11  ZDATA.....................................................	29
     11.12  ZEOF......................................................	29
     11.13  ZFERR.....................................................	29
     11.14  ZCRC......................................................	29
     11.15  ZCHALLENGE................................................	29
     11.16  ZCOMPL....................................................	29
     11.17  ZCAN......................................................	29
     11.18  ZFREECNT..................................................	29
     11.19  ZCOMMAND..................................................	29

12.  SESSION TRANSACTION EXAMPLES.....................................	30
     12.1   A simple file transfer....................................	30
     12.2   Challenge and Command Download............................	31

13.  ZFILE FRAME FILE INFORMATION.....................................	31

14.  PERFORMANCE RESULTS..............................................	33
     14.1   Compatibility.............................................	33
     14.2   Throughput................................................	33
     14.3   Error Recovery............................................	33

15.  PACKET SWITCHED NETWORK CONSIDERATIONS...........................	34

16.  PERFORMANCE COMPARISON TABLES....................................	35

17.  FUTURE EXTENSIONS................................................	41

18.  REVISIONS........................................................	41

19.  MORE INFORMATION.................................................	42
     19.1   TeleGodzilla Bulletin Board...............................	42
     19.2   Unix UUCP Access..........................................	42

20.  ZMODEM PROGRAMS..................................................	43
     20.1   Adding ZMODEM to DOS Programs.............................	44

21.  YMODEM PROGRAMS..................................................	45

22.  ACKNOWLEDGMENTS..................................................	45

23.  RELATED FILES....................................................	45


LIST OF	FIGURES


Figure 1.  Order of Bytes in Header...................................	14

Figure 2.  16 Bit CRC Binary Header...................................	14



				  - ii -











Figure 3.  32 Bit CRC Binary Header...................................	14

Figure 4.  HEX Header.................................................	15

Figure 5.  Transmission	Time Comparison...............................	37


LIST OF	TABLES


TABLE 1.  Network and Flow Control Compatibility......................	35

TABLE 2.  Protocol Overhead Information...............................	36

TABLE 3.  Local	Timesharing Computer Download Performance.............	37

TABLE 4.  File Transfer	Speeds........................................	38

TABLE 5.  Protocol Checklist..........................................	39



































				 - iii -









	   The ZMODEM Inter Application	File Transfer Protocol

			      Chuck Forsberg

			   Omen	Technology Inc


				 _A_B_S_T_R_A_C_T



The ZMODEM file	transfer protocol provides reliable file and command
transfers with complete	EEEENNNNDDDD----TTTTOOOO----EEEENNNNDDDD data	integrity between application
programs.  ZMODEM's 32 bit CRC catches errors that continue to sneak into
even the most advanced networks.

ZMODEM rapidly transfers files,	particularly with buffered (error
correcting) modems, timesharing	systems, satellite relays, and wide area
packet switched	networks.

ZMODEM greatly simplifies file transfers compared to XMODEM.  In addition
to a friendly user interface, ZMODEM provides Personal Computer	and other
users an efficient, accurate, and robust file transfer method.

ZMODEM provides	advanced file management features including AutoDownload
(Automatic file	Download initiated without user	intervention), Crash
Recovery, selective file transfers, and	security verified command
downloading.

ZMODEM protocol	features allow implementation on a wide	variety	of systems
operating in a wide variety of environments.  A	choice of buffering and
windowing modes	allows ZMODEM to operate on systems that cannot	support
other streaming	protocols.  Finely tuned control character escaping allows
operation with real world networks without Kermit's high overhead.

Although ZMODEM	software is more complex than unreliable XMODEM	routines,
actual C source	code to	pppprrrroooodddduuuuccccttttiiiioooonnnn programs allows developers to upgrade
their applications with	efficient, reliable ZMODEM file	transfers with a
minimum	of effort.

ZMODEM is carefully designed to	provide	these benefits using a minimum of
new software technology.  ZMODEM can be	implemented on all but the most
brain damaged computers.

ZMODEM was developed _f_o_r _t_h_e _p_u_b_l_i_c _d_o_m_a_i_n under a Telenet contract.  The
ZMODEM protocol	descriptions and the Unix rz/sz	program	source code are
public domain.	No licensing, trademark, or copyright restrictions apply
to the use of the protocol, the	Unix rz/sz source code and the _Z_M_O_D_E_M
name.












