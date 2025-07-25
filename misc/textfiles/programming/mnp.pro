23-Jul-86 00:41:30-EDT,13186;000000000001
Date: Tue, 22 Jul 1986  22:30 MDT
From: Keith Petersen <W8SDZ@SIMTEL20.ARPA>
To:   Telecom@XX.LCS.MIT.EDU
Subject: Interview with MNP protocol author

By permission of the publisher...

[Micom Propoganda removed, this article is rather biased, as one would
 expect.  In that light, I will allow for one series of rebuttals in the
 next digest.  Any further discussion will be directed to the
 Protocols@Rutgers digest. -Elmo]


====

Originally published by Black Box Corporation in the Black Box 
COMMUNICATOR.



 


          ERROR CORRECTION IN MODEMS... AND THE MNP PROTOCOL

                   An Interview with Greg Pearson, 
                         the Developer of MNP


         
       ******************************************************
                                                                    
        "(Error correction in modems) is a transparent solution   
        to a problem that's been with us all the time -- noisy    
        telephone lines."                                         

       ******************************************************


Sending information, minus the errors, is a top priority among data 
communicators everywhere.  As a result, more and more modems are being 
equipped with the MNP link protocol in their firmware.  Many people 
feel that this is the most effecicent way to eliminate errors in 
today's high-speed dial-up communications.  And Greg Pearson, MICOM's 
Chief Software Development Manager for Analog Products, is one of them.  
The MNP Protocol is his brainchild -- the product of Greg Pearson's 
attempt to develop a complete protocol, one with several layers that 
perform independently of the others.  Needless to say, he was 
successful.



BBC: In much of your published material on MNP, you've stressed that 
MNP has the richest set of protocols -- that it includes both a full-
fledged link protocol as well as higher level protocols like session 
and file transfer.  To begin our discussion on error correction in 
modems, can you tell us what you mean by a "full-fledged link protocol" 
-- and then give an overview of the different types of error correcting 
techniques?

PEARSON: For one thing, a full-fledged link protocol has to provide 
layer independence.  By that I mean that it doesn't depend on the layer 
above it to operate effectively.  Since error-control is offered at the 
link protocol layer, it's important that it be independent.  And that's 
not the case with the X.PC protocol.  X.PC is actually a layer 3 
protocol that integrates certain aspects of layer 2 from the OSI 
Reference Model.  If you're a real architectural purest, you wouldn't 
do this.  

As for the different types of error correcting techniques used for 
point-to-point error correction to date, in the hobbyiest world -- or 
rather, the retail-oriented market -- three come to mind right away.  
They are Xmodem, X.PC and MNP.  

In a sense, these three techniques have been used to accomplish the 
same work, but in different environments.  For example, many personal 
computer software packages use the Xmodem protocol for the error-free 
transmission of files over a dial-up telephone connection.  But if a 
user wants to send an error-free file from a PC into TYMNET(R), X.PC 
would be used since it's the protocol used by TYMNET.  On the other 
hand, if you wanted to do the same thing -- that is, send any data 
error-free over a dial-up connection -- with the protocol built into 
the modems themselves, you would use MNP.


BBC:  Can one protocol be replaced by another?

PEARSON:  Well, you could use X.PC or MNP in the same application as 
the Xmodem protocol.  Basically, Xmodem is a very simple technique --
one that's good for file transfer but not for interactive traffic.  

And, as I just mentioned, X.PC is a software protocol approach used by 
TYMNET.  A couple of companies have put X.PC into the firmware of 
their modems, but there are some significant disadvantages in doing 
that -- and the most noticable to the user is the difference in 
throughput.  If you take a look at the market, the use of the MNP 
error-control protocol in modems is by far the preferred choice.  It's 
currently used in the products of something like 16 or 18 modem 
vendors.


       **************************************************
                                                            
         "Imagine sending all of WAR AND PEACE with the
         probability of getting only one 1-bit error."     

       **************************************************


BBC:  Can you explain what you mean by throughput?

PEARSON:  Yes.  When you have a 2400 bps modem without error control, 
the user can expect to send 2400 bits per second.  When you implement 
X.PC in the firmware of that modem, it uses 9% of those 2400 bits per 
second for protocol purposes.  So you could expect, in the best case, 
a throughput that would be 91% of the line speed.

Now when using MNP in the firmware, you have a different situation.  
This, for the most part, is due to a feature that I refer to as 
"switch-to-sync."


BBC:  You talk about this feature in one of your articles, saying that 
it's an exclusive advantage of the MNP protocol.  Can you explain what 
happens as a result of switch-to-sync?

PEARSON:  What happens is the transmission starts in the character-
oriented mode -- or asynchronous mode.  But if the modems at both ends 
of that transmission are equipped with MNP error-correction, the 
transmission will switch to bit-synchronous between the modems.  As a 
result, the transmission is much more efficient.


BBC:  How does that affect the through-put of an MNP-equipped modem?

PEARSON:  Let me take you through the whole argument.  When a user is 
connected to a V.22 bis 2400 bps modem, that user is operating in an 
asynchronous character mode.  For every eight data bits transmitted, 
there is a start bit and a stop bit.  That means that the user is 
sending 240 characters in 2400 bits -- or ten bits per character.  

Now, when an MNP error-correcting modem is sending data, it doesn't 
send the user's start and stop bits required in the asynchronous mode.  
So for every ten bits sent by the user, MNP only sends eight -- i.e. 
MNP is sending data 20% more efficiently than the user because it's 
sending 20% fewer bits.  

As for the bandwidth, MNP uses 11% for protocol mechanisms.  So even 
though it loses 11% efficiency there, it gains 20% from the switch-
to-sync operation -- and that puts you 9% ahead of the game.   

What that all boils down to is that MNP, on an error-free line, will 
impose no throughput degradation when built into the firmware of your 
modem.  And because of the unique switch-to-sync feature, MNP is 
functionally like SDLC or HDLC, the two popular synchronous link 
layer protocols.  


BBC:  What does this all mean to the user?  

PEARSON:  You can have your cake and eat it too.  The ideal aspect of 
the MNP link protocol is that you can have it either way -- character-
oriented or bit-synchronous.  Other protocols give you no options.  


BBC:  What you're saying, then, is that MNP offers you a lot more 
flexibility than other protocols.  

PEARSON:  That's right.  And it has all the classical features of a 
layer 2 protocol:  it's full-duplexed -- that is, it can send and 
receive data at the same time -- it has error detection based on a 
very powerful 16-bit CRC, ithas retransmission for error correction, 
and it can reliably send a keyboard break signal... all of which 
actually makes it more powerful than HDLC.  


BBC:  You mentioned the 16-bit CRC, or Cyclic Redundancy Check.  Can 
you explain that?  Also, tell us what actually happens in this type of 
retransmission error correction.  I believe you refer to it as the 
'go-back-n' method of correction.  

PEARSON:  Any protocol, in order to provide an error-free transmission, 
must have two things.  One -- it has to provide a way for the receiver 
to know if an error has occurred.  That's error detection.  The 
technique employed in MNP for this error detection uses a polynomial 
function to calculate a 16-bit number which is a function of all the 
data sent in a particular message.  The MNP error-correcting protocol 
then sends those 16-bits at the end of its message.

The receiver -- as it is receiving the message -- calculates its own 
version of this 16-bit number.  Then it compares its number with the 
16-bit number sent with the message.  If the numbers are the same, the 
message is free from errors.  If the numbers are different, an error 
has occurred somewhere in the message.  That's how errors are detected.

Once an error is detected, the receiver brings the error correction 
mechanism provided by the MNP link protocol into play.  That correction 
mechanism calls for the receiver to send a message back to the sender.  
The sender -- recognizing that the last correct message sent before the 
error was data message number 'n' -- is cued to go back to the message 
following message 'n'.  In other words, if the sender has sent five 
messages, and the receiver detects an error in message 4, the sender 
will 'go back' to message 4 and begin retransmitting information again.

For all practical purposes, the result of the MNP link is error-free 
transmission.  Using the 16-bit redundancy check, it will detect every 
error which is 16 bits or smaller, with 100% probability.  As a result, 
the chances of an error occurring are actually so small that you can, 
in practice, ignore them.  Imagine sending all of WAR AND PEACE with 
the probability of getting only one 1-bit error.  That's what you could 
expect from an error-control protocol that uses the 16-bit CRC.  

       ********************************************************
                                                               
       "(MNP) is a very healthy protocol over long-delay       
       channels, and that's important to dial-up users.  You'd 
       be surprised how many of your local calls today are     
       being routed over satellite..."                         
                                                               
       ********************************************************


BBC:  MNP also has the ability to send a number of messages before any 
acknowledgement is required.  Can you explain this?

PEARSON: Any link protocol that's going to work well over telephone 
lines must have this ability.  If you're making a transcontinental call 
and it's transmitted by satellite, you don't want to wait for an 
acknowledgement from the receiver after each message.  That's how 
Xmodem works.

What you want to be able to do is send a number of messages at one 
time.  MNP lets you have up to eight outstanding messages before an 
acknowledgement is required.  And MNP is designed in such a way that 
only under the worst conditions would a sender ever have to wait 
between transmissions.  It's a very healthy protocol over long-delay 
channels, and that's important to dial-up users. You'd be surprised how 
many of your local calls today are being routed over satellite or 
microwave.  


BBC:  You've talked about MNP becoming the de facto standard -- the 
unofficial standard for dial-up connections.  On what factors would 
this really depend?  How much does the demand for error-controlling, 
high-speed modems influence this?

PEARSON:  A year ago, there was some question as to whether the V.22 
bis 2400 bps modem was really going to take off.  I don't think that's 
much of an issue anymore.  The price of these modems has come way down 
-- to the point that a 2400 bps modem can cost less than a Hayes(R) 
1200.  The higher speed modems are here to stay.

What affect does this have on the demand for error control in modems?  
First of all, we're pushing more bits through the same width pipe --
and we're getting more errors as a result.  Secondly -- because we're 
sending more bits at a time -- whenever we do get an error, it really 
clobbers more bits.  Finally, there's the way we're sending bits 
through the channels.  When we get an error, it takes longer for the 
modem to recover -- so when you lose one character, you're actually 
losing a whole slew of characters.  

In short, our communications are much more error sensitive today.  And 
we have a dramatically increased need to control errors because of 
that.  A good way of doing that is by putting the protocol right in the 
firmware of a modem -- a way that doesn't really interfere with your 
through-put.

It's a transparent solution to a problem that's been with us all the 
time -- noisy telephone lines.


                              #   #   #





                

                                         -by Betsy Momich
                                          Publications Department
                                          Black Box Corporation
 4-Aug-86 01:40:49-EDT,14812;000000000001
Date: Sun, 3 Aug 1986  23:27 MDT
From: Keith Petersen <W8SDZ@SIMTEL20.ARPA>
To:   Telecom@XX.LCS.MIT.EDU
Subject: More MNP info

[This is a rather lengthly article, less biased than the previous one from
 Black Box.  It is I think more understandable, although some references to
 Newsnet (a query service) may confuse some.  I do not intend to publish any
 more MNP articles unless there is significantly new information contained
 therein.   --Elmo]

The following article is 
Copyright (c) 1986 by Brian Raub
-- ALL RIGHTS RESERVED --

    Distribution permitted via online services.
    Distribution in print requires author's permission:

    NOTE: This article is an expanded version of a similar one published
          in the NewsNet Action Letter, a publication of NewsNet Inc.

THE MNP ERROR-CORRECTING PROTOCOL,
2400 BPS MODEMS, AND NEWSNET

by Brian D. Raub
   14 Rolling Road
   Overbrook Hills, PA 19151
   215-649-7935

     NOTE: 'BPS' means 'bits per second', commonly but incorrectly called
'baud'. 'CPS' means 'characters per second'. Outside of an MNP discussion
'2400 baud' usually equates to 240 CPS. That's not necessarily true here.

     If you're a regular NewsNet user or online publisher, then you know
that telephone line noise occasionally causes stray characters (like {,
~, or |) to appear on your screen. 


REAL PROBLEMS WITH LINE NOISE

     Sometimes a whole line of text may be 'garbled' or even lost. This
is usually not a problem, since you can still read the text. But here are
a few situations where line noise is truly annoying:

     -- If you're transmitting the text of a MAIL message from a file
you've prepared on disk to a PUBLISHER (a press release, for example),
the stray characters may become part of your message. The garbled message
may create a less-than-favorable impression in the receiver's mind.

     -- When you're typing a command and stray characters are added,
NewsNet doesn't understand the command, and you must re-enter it.

     -- If you're retrieving or sending numeric data such as stock
quotes, airline fares, or next year's budget, line noise may create false
impressions or lead to bad decisions.

     -- If you're a publisher transmitting your latest issue to NewsNet,
the stray characters often become a permanent part of your online
stories. At best, the reader deciphers the garbled text. At worst, 'Joe
Blow' becomes 'J{oe Bl~ow', and the NewsNet reader will never find your
story when SEARCHing for 'JOE BLOW'.


MNP PROTOCOL TO THE RESCUE

     New modems are available that can eliminate the problem
of line noise. They include a built-in error-correction protocol called
MNP (Microcom Networking Protocol). Here's a simplified explanation of
what happens when two modems with built-in MNP are connected:

     1. When you send characters from keyboard or a disk file, your MNP
modem saves them in its own memory buffer. If you are typing slowly at
your keyboard, it may collect and save a 'packet' of just one or two
characters before proceeding to step 2. If you are sending a file quickly
from disk, it will collect and save a larger packet of characters.

     2. Your modem then sends the packet of data to the other MNP modem.
It also sends a numerically calculated result of the packet's data
content, called a 'CRC character'.

     3. The remote modem receives your packet of data, saves it in its
own buffer, then calculates its own CRC character. At the same time it
continues to receive additional packets of data from your modem, saving
them in its buffer.

     4. The remote modem compares the two CRC characters. If they match,
the remote modem knows the data is correct. It removes the CRC character,
then passes the data to the computer to which it's connected. But if line
noise has entered the data in its path between the modems, the CRC
characters won't match, and:

       a. the remote modem will order your modem to re-send the same
packet of data again, then

       b. repeat step 3 and 4, as many times as necessary until the
results match.

     When the online service (NewsNet, for example) is sending data to
you, the process is the same, but your modem acts as the remote.


MNP MODEMS WORK WITH ANY COMMUNICATIONS SOFTWARE
-- BUT NOT WITH ALL NETWORKS OR ONLINE SERVICES

     MNP can be implemented in communications software, but it is most
efficient when built into the modem itself. When using a modem with
built-in MNP, your communications software has nothing to do with the MNP
process; it's strictly the concern of the two MNP modems to assure that
all data is exchanged error-free. So you get the benefits of the MNP
modem protocol with your favorite program: CrossTalk, Qmodem, Smartcom,
or whatever.

     In order for MNP to work, your modem and the remote modem must BOTH
have MNP capability. So you can't use this protocol with just any network
or online service. So far, it's available for NewsNet and any other
online service that is accessible via Telenet or Uninet. Both use MNP
modems built by Microcom. MNP is not yet available via Tymnet or through
some 'private' networks like MCI Mail and CompuServe.


MNP CLASSES 1 THROUGH 6

     There are six different versions or 'Classes' of the MNP protocol:
1-6. At 300 BPS, Telenet uses Class 2 MNP. It uses 8 'bits' to represent
each character, plus 1 start bit and 1 stop bit, for a total of 10 bits
per character. After error-checking overhead, potential throughput is
about 204 CPS.

     At 1200 and 2400 BPS, Telenet and Uninet support Classes 2 and 3
MNP. Class 3 also uses 8 bits per character, but it deletes the start and
stop bits, then adds some characters for error-checking. Overall it's
about 23% more efficient than Class 2, with potential throughput of 252
CPS. Most Class 3 modems are downward compatible -- they can usually
recognize and communicate with Class 2 modems.

     MNP Class 3 cannot be implemented in software, except with
synchronous modems. But it is widely implemented in modem 'firmware'.
Each higher Class is potentially faster, but is application dependent for
its usefulness. Class 5, for example, compresses common character
patterns in plain English text (like NewsNet delivers) to deliver
effective throughput as high as 500 CPS using 2400 BPS modems and voice-
grade phone lines. But Class 5 is no faster when used with non-English
data like spreadsheets or programs.

     The networks and several modem manufacturers plan to upgrade their
MNP support to the higher Classes in the future. And since most
manufacturers include the MNP protocol on a ROM chip in their modems, you
should be able to inexpensively upgrade your MNP modem when the higher
Classes become available. Modem manufacturer MultiTech Systems, for
example, will offer the MNP Classes 4 and 5 ROM upgrades at no charge
when they are available.


TELENET SUPPORTS MNP AT 2400/1200/300 BPS

     Telenet has special phone numbers in more than 80 cities that
connect you to MNP modems. Telenet offers this service at any speed:
2400, 1200, or 300 BPS. 

     To use a Telenet MNP node at 300 or 1200 BPS, just follow the usual
Telenet logon procedure for NewsNet (see your Pocket Guide, chapter xx).
You may have to wait longer than usual for Telenet to recognize your
modem after you touch the first two <RETURN>s. But be certain to enter
'D1' as your terminal type, instead of touching the <RETURN> key a third
time. Otherwise useless 'nulls' are added to the end of each line you
receive, slowing text transfer as much as 25%.

     When you first connect to a Telenet MNP node at 2400 BPS, the
procedure is slightly different. You must type the @ character before you
touch your <RETURN> key. Everything after that is the same as usual (be
sure to use 'D1' as your terminal type).

     To identify your local MNP Telenet node, call Telenet Customer
Service at 800-336-0437 or 703-442-2200. 


[References to Uninet deleted since it has been melded into Telenet -Elmo]


MNP NOT AVAILABLE VIA TYMNET

     Tymnet does not currently support MNP. They developed their own
error-correcting protocol, X.PC, which also features simultaneous
connection to as many as 15 online services or other hosts using one
phone line. 

     According to spokesman Steve Kim, Tymnet released X.PC to the public
domain about 18 months ago, when Microcom still charged thousands of
dollars to license MNP. Tymnet (408-946-4900) provides developers with
free specifications and source code for X.PC. "X.PC can be implemented in
software or hardware. Hardware implementations are fastest, with
potential throughput efficiency of 85%, or about 204 CPS with 2400 BPS
modems," he said.

     Microsoft ACCESS telecommunications software supports X.PC via
software. Modem manufacturer Hayes has announced its support for X.PC,
but does not yet offer modems or software that include it. Concord Data
Systems supports both X.PC and MNP in some of its modems.

     Tymnet's X.PC error-correcting features work (???) with NewsNet. Its
multiple session capabilities are not yet compatible with all online
services. Check with Tymnet or your favorite online services for complete
details.


COMPARISON TESTS @ 2400 BPS:
TEXT RETRIEVAL: TELENET = 235 CPS; UNINET = 196 CPS
TEXT UPLOADING: TELENET = 119 CPS; UNINET = 178 CPS

     Both Telenet and Uninet offer MNP at 2400 BPS, so I tested their
Philadelphia nodes to compare actual speed. Testing occurred during
NewsNet's off-peak hours. Qmodem communications software, a Zenith 160
micro (IBM PC/XT compatible), a MultiTech Systems MultiModem 224EH with
Class 3 MNP, and a file with 33,362 characters were used for all testing.
To verify my results, I also spot-tested under the same conditions on The
Source; those spot-tests were nearly identical but are not included here.


     To simulate the retrieval of a newsletter by a NewsNet customer, I
downloaded the same file twice from NewsNet via each network, then
averaged the result and calculated the actual throughput measured in
characters per second (CPS). For text retrieval, I clocked Telenet at 235
CPS, and Uninet at 196 CPS (Telenet was 19% faster).

     To simulate the transmission of a newsletter to NewsNet from a
publisher, I uploaded the same file twice to NewsNet via each network.
For text transmission (uploading), I clocked Telenet at 119 CPS, and
Uninet at 178 CPS (Uninet was about 50% faster).

     To test the integrity of the eight transmissions (four downloads and
four uploads), I compared the files on the receiving computer. All eight
were identical, confirming the accuracy of MNP on both networks.

     NOTE: When <RETURN> was used as the Telenet terminal type (instead
of 'D1'), Telenet text retrieval slowed down to 176 CPS but uploading
speed remained at 119 CPS. 


COMPARISON TESTS @ 1200 BPS --
TEXT RETRIEVAL: TELENET = 119 CPS; UNINET = 100 CPS
TEXT UPLOADING: TELENET = 104 CPS; UNINET =  91 CPS

     I also tested both networks at 1200 BPS. Telenet was 14% - 19%
faster. For text retrieval (downloading), I clocked Uninet at 100 CPS,
and Telenet at 119 CPS (about 19% faster). For text transmission
(uploading), I clocked Uninet at 91 CPS, and Telenet at 104 CPS (about
14% faster). All eight files were once again identical, just as they were
at 2400 BPS.

     NOTE: When <RETURN> was used as the Telenet terminal type (instead
of 'D1'), Telenet text retrieval slowed down to 104 CPS and uploading
slowed to 99 CPS.

     Howard Stern, Director of Market Development at US Telecomm
(Uninet), found my limited tests inconclusive. "Results averaged from
network nodes in several cities, at various times of day for both Uninet
and Telenet, are needed to draw definitive conclusions. Network
congestion, noisy phone lines, or geographic considerations may have
distorted your test results," he said.

     Ted Holdahl, Manager of Hardware Development at Telenet Network
Services Division said "Effective speeds will vary by the caller's
location and chosen host service. Yours was a fair test of your local
conditions for NewsNet access."

     You may get different results in your area. And when NewsNet is busy
(yet another variable), you won't match my speeds. But my unusual results
show that a thorough test of throughput -- with all networks accessible
in your city -- could save you significant time and money online,
regardless of your modem's speed.


WHAT YOU'LL PAY -- AND WHERE TO GET AN MNP MODEM

     MNP is seldom found in 300/1200 BPS modems, but many 2400/1200/300
BPS models include it. The reason is that 2400 BPS transmissions are more
sensitive to line noise than transmissions at the lower speeds. Without
error correction, data integrity cannot be assured.

     According to Jan Hubbard, Manager of National Accounts at MultiTech
Systems, "Many corporate buyers recognize the time and phone line cost
savings that 2400 BPS modems deliver. Some require BOTH the high speed
and MNP error  correction capabilities for graphics, full-screen
terminal, and other data-sensitive applications. They're usually willing
to pay our $50 premium for the added protection offered by the MNP error-
correction protocol."

     This author uses the MultiModem 224EH (MNP Class 3) from MultiTech
Systems. Suggested retail is $749, including $25 of free time on NewsNet
for first-time users. (The $699 MultiModem 224AH does NOT include MNP.)
For more information write or call: MultiTech Systems, Inc., 82 Second
Avenue S.E., New Brighton, MN 55112, 612-631-3550.

     Microcom developed the MNP protocol and licenses it to other modem
manufacturers. The specifications for Classes 1-3 are 'in the public
domain'; printed documentation is available from Chris Kandianis at
Microcom (617-762-9310) for $100. According to Greg Ferguson, Microcom's
VP - Marketing, MNP modems are also now manufactured by ARK Paradyne,
Codex-Motorola, Concord Data Systems, Microcom, and Racal-Vadic. Ferguson
said that MNP modems will soon be available (perhaps by the time you read
this article) from Microcom licensees Case Rixon, Cermetek, NEC,
Novation, Micom, Penril, U.S. Robotics, and others.

     To learn more about the MNP protocol, try this search on NewsNet:

     1. SEARCH TE EC <== Search telecomm & computer services
     2. 3/1/85-      <== March 1985 to the present
     3. MNP -SORT    <== Keyword=MNP;
                         sort stories with newest ones first
     4. HEAD         <== Display the headlines, then select
                         stories (by number) to read
 5-Aug-86 17:18:41-EDT,7147;000000000001
To: protocols@red.rutgers.edu, telecom@xx.lcs.mit.edu
Subject: Re: Interview with MNP protocol author
In-reply-to: Your message of 23 Jul 86 04:29:00 GMT.
Date: 05 Aug 86 17:09:30 EDT (Tue)
From: John Robinson <jr@cc5.bbn.com>

[As promised, equal time for those opposing MNP.  -Elmo]


I wish to present some arguments by way of rebuttal to the posted
article about Microcom and the MNP protocol.

1.  Others have already spoken to this, but I wish to echo it.
Microcom is not playing straight with the world by trying to
standardize part of what their boxes do, but not the rest.  Either the
protocols should be in the public domain or not.

I advocate the former approach.  I feel it is to everyone's benefit,
including Microcom's, for this to happen.  As far as I know, what
their products do is no more than a straightforward extension of
existing, standard protocols, i.e. HDLC.  If there are ways to improve
on the HDLC standard, why not push to incorporate them into the
standard.  If other companies eventually produce products that provide
the now-standard protocols for less cost, the world has benefited.  If
Microcom perceives this as a threat, they should either stay
competitive, or else move on into the role of consultant to these
other companies, or license their particular implementation, as a way
of generating revenues.  The standardization will help the market for
the protocols grow, and they should come out ahead.  They will still
have an advantage in being there ahead of most everyone else.

The protocols ought to improve from the inputs of other standards body
members during the standardization process.  In particular,
limitations of the protocols will become well-documented and the ways
to tune them more widely known.  Again, both Microcom and the world
should benefit.

The proprietary approach may lock in more customers in the short run,
but leads to a proliferation of standards as other companies figure
out different, but better under some circumstances, methods to
out-spec the competition.  The result is a lot of incompatible boxes.
This situation exists today with IBM's and the other major
manufacturers' proprietary network architectures, but is being solved
with the movement towards the ISO protocols.

I think the halfway approach is the worst of both worlds, and will
lead to the fragmented situation in the long run.  I feel the
standards world should (and probably will) look askance at a
half-standard.

2.  MNP protocol should not be advertised as an error-free protocol,
any more than any other data link protocol.  A separate message on
this list has described a situation where a 16-bit CRC has failed to
detect certain error patterns of 4 bits over a short-haul modem
connection.  In addition, only the segment between the MNP boxes is
protected; end-to-end protection requires higher-level mechanisms to
protect the other links, such as the line from the host computer or
terminal to the MNP box, a connection through a public network such as
Telenet, or the internal operating system interfaces within the host
computer.

>> For all practical purposes, the result of the MNP link is error-free 
>> transmission.  Using the 16-bit redundancy check, it will detect every 
>> error which is 16 bits or smaller, with 100% probability.

No!  No!  No!  Any error in an odd number of bits, and all one-, two-,
and three- bit errors will be detected.  16 bits in a row which are
inverted are detected, yes (I think!), but a sequence of 16 bits in
which some bits are in error is NOT necessarily detected.  CRCs aren't
that good.  You could probably justify the cited statement, but it is
terribly misleading if he really means "every error consisting of
sequential incorrect bits of up to 16 bits in length," since this is
among the least likely error patterns.

>> As a result, 
>> the chances of an error occurring are actually so small that you can, 
>> in practice, ignore them.

Again, misleading.  Depends on how critical your data is.  If you are
sending the money wire transactions between the New York Fed and the
Washington Fed, you probably don't agree with this statement at all.

>> Imagine sending all of WAR AND PEACE with 
>> the probability of getting only one 1-bit error.

This is grandstanding.

The real answer depends on the underlying line error rate.  If it is
10^-5, which is the phone company's advertised rate for conditioned
lines, you should get an undetected error every 10^5*2^16 bits, in
round numbers, 6.6 billion bits.  But if the error rates rises to
10^-2 for brief bursts, which may happen for one or two minutes a week
without hurting the advertised average BER, your chances of an
undetected error climb fast.  Again, compare the article on RF modems.

In later statements, Pearson implies that the 2400 baud modems have a
tougher time coping with errors on the line, which would seem to make
the 10^-5 error rate assumption optimistic.  It seems that the 16-bit
CRC really may not provide as good performance as is claimed for
2400-baud operation, and better checking may be warranted in some
circumstances.

3.  I don't understand the point about layer independence at all.
Modems provide a physical connection.  MNP protocol-equipped modems
provide a better error rate, with a tradeoff in other performance
areas.  But as modems, they are still physical layer devices since
they do not, as far as I know, provide anything but a physical
interface to their users.  But this is not really the whole story.

The modems provide, in effect, a variable data rate, due to the
necessity to back up for retransmissions.  For this reason, they also
require a link protocol between the modem and the attached device, the
terminal or host.  So the terminal or host must be programmed to stop
on command from the modem, which is not necessary for a classical
modem.  But now we have lost the transparency promised before.  So I
don't agree that MNP protocol-equipped modems are completely
transparent.  They may make use of data link protocols on their local
cables that are more commonly available, yes, but without such a link
level protocol they may ultimately provide worse service to the user.

Pearson's answer on this point attacks other competing protocols
without supporting the layer independence point at all.  The sarcastic
remarks about architectural purists only hurt his case.

4.  Synchronous protocols are more efficient in eliminating the asynch
start and stop bits.  Microcom was certainly clever in figuring out
how to use this to their advantage.

PADs do the same thing.  I think, in the long run, a one-line PAD in a
box with the modem would be a far more valuable product.  And the
standards are already in place.  I would really like to see a detailed
comparison of MNP with X.25/X.32 + X.3/X.28/X.29.  I'd pay a little in
efficiency to stick with the latter standards.

John G. Robinson
BBN Communications, Inc.

Disclaimer: these are my own statements, but the company would
probably agree with me.
20-Aug-86 20:50:38-EDT,2101;000000000001
Return-Path: <BRIAN%src.csnet@CSNET-RELAY.ARPA>
Received: from CSNET-RELAY.ARPA by XX.LCS.MIT.EDU with TCP; Wed 20 Aug 86 20:50:36-EDT
Received: from src by csnet-relay.csnet id aa23072; 20 Aug 86 19:08 EDT
Date:     Wed, 20 Aug 86 13:31 EST
From:     "BRIAN T.N. STOKES -- SRC" <BRIAN%src.csnet@CSNET-RELAY.ARPA>
To:       Telecom-REQUEST@XX.LCS.MIT.EDU
Subject:  RE: TELECOM Digest V5 #130
X-VMS-To: IN%"Telecom-REQUEST@XX.LCS.MIT.EDU",BRIAN       

While I did enjoy very much the article with one of the developers of MNP, the 
description of the protocol as the Micom Network Protocol made me do a double 
take and rush for my MNP documentation.  Isn't it actually the Microcom Network 
Protocol?

I'm not trying to split the hairs on a bunny's tail, just want to make sure I 
sound like I know what I'm talking about when I tell my people it's one or the 
other...

We have just ordered 8 of the Microcom AX2400c's which have Class 5 MNP
service. We futzed around for about 3 months with half a dozen Novation 2400
Professionals with Class 2, and just sent them back to Novation due to erratic
performance.  Too bad, because many of the ergonomic features of the Novations
are unique and deserve to be copied widely.  Unfortunately, the technical
support at Novation has been spotty (a kind understatement...). 


The Novation experience was enough to make us take MNP seriously though...it 
really eliminated noisy lines for remote users during extensive testing.  The 
choppiness of the protocol is disconcerting, but everyone who has been troubled 
with noisy lines insisted the clean transmissions were worth the tradeoff, even 
during interactive use.  I agree with earlier comments here that it would be 
nice to be able to turn the protocol off and on during a session. 

The Class 5 MNP is reported to double throughput with textfile compression 
using Huffman encoding at each end.   I'll let you know what our experience is. 
If any of you out there are currently using the Microcom AX series, please 
don't sit on yer typing fingers...

Thanks!
