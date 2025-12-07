























                           Xmodem, CRC Xmodem, Wxmodem







                             File Transfer Protocols



































               Please circulate this document anyway that you see
               fit without alteration except on the page at the
               end titled: "Notes and Comments".  It is requested
               that anyone using these protocols within a commer-
               cial product not charge for them as an option or
               surcharge, but include XMODEM and its derivations
               as part of the basic product.















                                             Peter Boswell

                                             June 20, 1986

                                             People/Link email: TOPPER









          Xmodem, CRC Xmodem, WXmodem

     June 20, 1986                                                 Page 2

     ----------------------------------------------------------------------



                                TABLE OF CONTENTS





     1.   PREFACE  . . . . . . . . . . . . . . . . . . . . . . . . . .     3

     2.   INTRODUCTION . . . . . . . . . . . . . . . . . . . . . . . . .   5

     3.   TERMINOLOGY  . . . . . . . . . . . . . . . . . . . . . . . . .   6

     4.   XMODEM . . . . . . . . . . . . . . . . . . . . . . . . . . . .   7

          4.1. Xmodem Hardware Level Protocol  . . . . . . . . . . . . .   7
          4.2. Xmodem Initiation . . . . . . . . . . . . . . . . . . . .   7
          4.3. Xmodem Data Transmission  . . . . . . . . . . . . . . . .   8
          4.4. Xmodem Cancellation . . . . . . . . . . . . . . . . . . .   9
          4.5. Xmodem Error Recovery and Timing  . . . . . . . . . . . .   9

     5.   CRC XMODEM . . . . . . . . . . . . . . . . . . . . . . . . . .  13

          5.1. CRC Calculation Rules . . . . . . . . . . . . . . . . . .  13
          5.2. CRC Xmodem Initiation . . . . . . . . . . . . . . . . . .  14


     6.   WINDOWED XMODEM (WXMODEM)  . . . . . . . . . . . . . . . . . .  15

          6.2. Transparency and Flow Control Rules (Byte Level Rules)  .  16
          6.3. Initial Handshake Rules . . . . . . . . . . . . . . . . .  18
          6.4. Window Packet Transmission Rules  . . . . . . . . . . . .  18
          6.5. Notes for X.25 Hosts  . . . . . . . . . . . . . . . . . .  22


     7.   APPENDIX A - CRC CALCULATION RULES . . . . . . . . . . . . . .  23

          7.1. IBM PC - 8088/8086 Data Structure . . . . . . . . . . . .  23
          7.2. BASIC Implementation of Bit Shift Method  . . . . . . . .  23
          7.3. BASIC Implementation of the Table Method  . . . . . . . .  26



     8.   NOTES AND COMMENTS . . . . . . . . . . . . . . . . . . . . . .  28









          Xmodem, CRC Xmodem, WXmodem

     June 20, 1986                                                 Page 3

     ----------------------------------------------------------------------



     1.   PREFACE


     In the years that have past since Xmodem was first developed as a file
     transfer protocol, many thousands of people have been involved in
     finding reasonable ways to move data via asynchronous telephone commun-
     ications.  I appreciate the opportunity that I have had to meet and
     learn from many of these people.  There is nothing in this document
     that did not actually come from someone else.  Indeed, whether it is
     WXMODEM, X.PC, Synchronous dial-up X.25, SNA, ZMODEM, Blast, Kermit or
     any other protocol that becomes the dominant dial-up file transfer
     protocol for personal and home computers is just not important.  What
     is important is that the public domain have a high speed file transfer
     protocol that is reasonably popular and  commonly available for many
     types of personal computers, for bulletin boards and for services such
     as People/Link, Delphi, CompuServe, GEnie and The Source.

     Here are a few people that all of us should thank and I would espec-
     ially like to recognize:

          Ward Christensen  Ward, a true pioneer in the microcomputer
          communications area, is the author of the original Checksum
          Xmodem protocol.  Thanks for reminding me to "keep it simple
          stupid".

          Chuck Forsberg  Chuck has edited perhaps the best work on
          Xmodem and has provided both YMODEM (1K Xmodem) and ZMODEM
          (Windowed YMODEM) to the public domain.  Thanks for showing
          me a protocol which would deal with the X-On/X-Off problem
          and reminding me that there is such a thing as a DLE char-
          acter.

          Richard (Scott) McGinnis  Scott is the architect, the moving
          force, for the People/Link software system.  His ideas,
          comments and encouragement have been wonderful.  Wait until
          you see his visual conference program for the IBM PC!
          Thanks for showing me how to use a DLE.

          Gene Plantz  Gene operates a major IBM PC bulletin board in
          the Chicago area and has been active in the National SYSOP
          Association.  Thanks for pushing me to do something about
          performance.

     In a historical perspective, there seems to be a common pattern in all
     computer systems development that can shed some light on where we stand
     and how we got here.  The pattern is function first, then integrity and
     finally performance.

     Any kind of software must first do something worthwhile.  There is no
     point in being error free, or inexpensive to operate if we do not want
     the function.  Back in 1977, Ward Christensen had a need to move data







          Xmodem, CRC Xmodem, WXmodem

     June 20, 1986                                                 Page 4

     ----------------------------------------------------------------------

     between microcomputers.  Within a year it became obvious that the
     function Xmodem provided met a real need to many microcomputer users.

     Once we have a new function and we accept it, there is a normal desire
     for the function to be correct.  No one can't count the times that new
     software users have pointed out ... "that new function is super, but
     the results are wrong".  The effort changes from providing new function
     to providing integrity.  The development of CRC Xmodem is a clear
     response to the integrity phase of a service as it reduced undetected
     transmission errors by many orders of magnitude.

     After the integrity has been accepted, people begin to look toward cost
     and performance.  XMODEM entered this phase in 1984-1985.  Chuck
     Forsberg's YMODEM is a major step in this effort providing larger
     block sizes, batch mode and more.  His ZMODEM is a major step toward
     making XMODEM derivative protocols work effectively with Public Data
     Networks and most importantly, provides for restart of a file transfer
     at the point of failure.  WXMODEM, presented here, is an alternate
     solution to ZMODEM which is, hopefully, an easier solution to the most

     important performance problems.

     No one really knows where XMODEM and the file transfer function will go
     in the coming years.  Perhaps X.PC from Tymnet, MNP from Microcom or
     Synchronous X.25 will slowly push XMODEM, et. al, into history.  I
     think this will happen, but not for maybe 5 to 10 years.  Perhaps when
     50% of the households outgrow the Commodore 64, or when modem manufac-
     turers can provide a $50 synchronous modem we will see the beginning of
     the end for XMODEM, but not today.







          Xmodem, CRC Xmodem, WXmodem

     June 20, 1986                                                 Page 5

     ----------------------------------------------------------------------



     2.   INTRODUCTION

     XMODEM and its derivatives have become the primary method for file
     transfer for personal computers.  Hopefully this document will help
     people to understand these protocols and to implement them on their
     own.  In particular, this document presents an additional XMODEM
     derivation to the public domain: WXMODEM.

     Why develop another file transfer protocol?

     After working with bulletin boards, Public Data Networks such as Tymnet
     and Telenet, and commercial host systems such as People/Link, Delphi,
     CompuServe and others, a number of people came to believe that hobby-
     ist, home and business users would benefit significantly from a new,
     conceptually simple file transfer protocol which would provide improved
     performance and fully support the public data networks such as Tymnet,
     Telenet and Datapac.

     But before WXMODEM can be presented, XMODEM and CRC XMODEM must be
     described in detail.









          Xmodem, CRC Xmodem, WXmodem

     June 20, 1986                                                 Page 6

     ----------------------------------------------------------------------

     3.   TERMINOLOGY

     I've elected to use two special terms: transmitter and receiver.  The
     transmitter is the computer/software which is transmitting data packets
     and receiving acknowledgement characters.  The receiver is the com-
     puter/software receiving the data packets and transmitting acknowledge-
     ment characters.

     Here is a table of special ASCII characters that are used throughout
     this paper:

          Name      Decimal        Hexadecimal    Description


          SOH          01           H001          Start Of Header
          EOT          04           H004          End Of Transmission
          ACK          06           H006          Acknowledge (positive)
          DLE          16           H010          Data Link Escape
          X-On (DC1)   17           H011          Transmit On
          X-Off(DC3)   19           H013          Transmit Off
          NAK          21           H015          Negative Acknowledge
          SYN          22           H016          Synchronous idle
          CAN          24           H018          Cancel








          Xmodem, CRC Xmodem, WXmodem

     June 20, 1986                                                 Page 7

     ----------------------------------------------------------------------



     4.   XMODEM


     Xmodem is a popular error recovery type protocol for transferring files
     between computers via serial, asynchronous communications.   Before
     learning more about Xmodem, it is important to hear what its author has

     to say:


          "It was a quick hack I threw together, very unplanned (like
          everything I do), to satisfy a personal need to communicate
          with some other people.  ONLY the fact that it was done in
          8/77, and that I put it in the public domain immediately,
          made it become the standard that it is"....."People who
          suggest I make SIGNIFICANT changes to the protocol, such as
          'full duplex', 'multiple outstanding blocks', 'multiple
          destinations', etc etc don't understand that the incredible
          simplicity of the protocol is one of the reasons it survived
          to this day in as many machines and programs as it may be
          found in!"a


          4.1. Xmodem Hardware Level Protocol

          The protocol is Asynchronous, 8 data bits, no parity bit, one stop
          bit.  Modems which are commonly used are AT&T 103 (300 baud), AT&T
          212A (1200 baud) and CCITT V.22 (2400 baud).


          Typically, the data in a file is transmitted without change (if a
          7 bit machine, the left most, high order, bit is always zero)
          except that CP/M and MS/DOS operating systems want a ^Z (decimal
          26) to represent end-of-file.

          4.2. Xmodem Initiation

          Prior to entering the protocol, both the transmitting and receiv-
          ing computer must know where to get the data (what file is to be
          transmitted) and where to put the data (file to store the data or
          buffer area).  In Xmodem one side of the file transmission is
          always in charge (local computer), asking the other side (remote
          computer) to either transmit a file or to accept a file.  Through
          a dialog outside of Xmodem the local computer (your PC) first
          sends commands to the remote computer to select a file name
          to prepare to transmit or receive a file via XMODEM.  Once this is
          completed the remote computer enters the XMODEM protocol.  Now the
          local computer must be told what file to transmit or receive and
          it enters the XMODEM protocol, and hopefully data starts moving.


          a    Ward Christensen, quoted from a message posted on CompuServe

               in 1985.  Edited by Chuck Forsberg, "X/Ymodem Protocol

               Reference", unpublished, 10/20/1985.






          Xmodem, CRC Xmodem, WXmodem

     June 20, 1986                                                 Page 8

     ----------------------------------------------------------------------


          Upon entering the Xmodem protocol, the transmitting computer waits
          between 10 seconds and a minute to receive an NAK character from
          the receiving computer.  The receiving computer is said to drive
          the protocol.  The transmitter may retry any number of times.  If
          any character other than a NAK or CAN is read by the transmitter,
          it is ignored.  The CAN character implies cancellation of the
          Xmodem file transfer and that the transmitter should leave the
          Xmodem protocol.  Once the receiver has sent a NAK, it will wait
          10 seconds for data to begin to arrive.  If none arrives in 10
          seconds, the receiver will send another NAK and continue to repeat
          10 times at which point the receiver will leave the Xmodem
          protocol (typically with a super cryptic error message such as
          "aborted", "NAK retry maximum exceeded").


          Transmitter                        Receiver

          [wait for one minute]         <    [NAK]

          [begin block transmission]    >

          4.3. Xmodem Data Transmission


          The transmitter takes the data, divides it into 128, 8 bit byte
          pieces and places it in an Xmodem Packet.

          The Xmodem Packet looks like this:

               [SOH] [seq] [cmpl [seq] [128 data bytes] [csum]

               SOH       Start of header character (decimal 1).

               seq       one byte sequence number which starts at 1, and
                         increments by one until it reaches 255 and then
                         wraps around to zero.

               cmpl seq  one byte 1's complement of seq.  This can be
                         calculated as cmpl = 255 - (255 and seq) or using
                         xor as cmpl = (255 and seq) xor 255.

               data      128, 8 bit bytes of data.  Note than when sending
                         CP/M and MS/DOS files a ^Z (decimal 26) must be
                         added to then end of the file.  If the last block
                         of data is less than 128 bytes, the Xmodem packet
                         must be padded with characters, usually ^Z's.

               csum      one byte sum of all of the data bytes where any
                         overflow or carry is discarded immediately.  For
                         example, if the first 3 bytes are 255, 5 and 6 the
                         checksum after the first 3 bytes will be 10.








          Xmodem, CRC Xmodem, WXmodem

     June 20, 1986                                                 Page 9

     ----------------------------------------------------------------------


          Once Xmodem Initiation has completed, the transmitter sends the
          first Xmodem packet and then waits.  After the receiver has the
          full packet, it will compare its own checksum calculation with the
          checksum that was sent by the transmitter.  If the checksums
          match, the receiver will send an ACK.  If the checksums are
          different, the receiver will send a NAK.

          After receiving an ACK the transmitter will send the next Xmodem
          packet.  If a NAK is received, the transmitter will resend the
          same XMODEM packet again.

          Once the transmitter has sent the last Xmodem packet and has
          received an ACK, the transmitter will send an EOT and then wait
          for a final ACK from the receiver before leaving the Xmodem
          protocol.  When the receiver sees an EOT instead of an SOH (the
          first character the next packet), the receiver transmits an ACK
          character, closes its files and leaves the Xmodem protocol.

          Let's look at a three block file transfer:


               Transmitter                                  Receiver

                                             <<<<<          [NAK]
               [SOH][001][255][...][csum]    >>>>>
                                             <<<<<          [ACK]
               [SOH][002][254][...][csum]    >>>>>
                                             <<<<<          [ACK]
               [SOH][003][253][...][csum]    >>>>>
                                             <<<<<          [ACK]
               [EOT]                         >>>>>
                                             <<<<<          [ACK]


          Seems easy, right?  And it is, until something goes wrong.

          4.4. Xmodem Cancellation


          It has become a defacto standard that the receiver may cancel the
          file transfer by sending a CAN character and then leaving the
          protocol.  If the transmitter receives a CAN character when
          expecting either a NAK or ACK, the transmitter is to termin-
          ate and leave the protocol.  Likewise, if the receiver sees a CAN
          when expecting an SOH (start of packet) it should terminate the
          file transfer.  Many implementations now require two CAN char-
          acters before recognizing a cancel condition.


          4.5. Xmodem Error Recovery and Timing


          Error detection and recovery are the primary purposes of the
          Xmodem protocol.  The transmitter and receiver should continue to
          retry until 10 errors in a row have occurred.  Some of the common






          Xmodem, CRC Xmodem, WXmodem

     June 20, 1986                                                 Page 10

     ----------------------------------------------------------------------


          error conditions are listed below:


               4.5.1.    Complement Error


               If the sequence number does not match the complement
               sequence number, the packet must be discarded and a NAK
               sent to the transmitter.


               4.5.2.    Duplicate packet condition


               If the sequence number is the same as the sequence
               number of the last packet received, the packet should be
               discarded and an ACK sent to the transmitter.


               4.5.3.    Out of sequence error


               If the sequence number matches the complement sequence
               number and it is neither the expected sequence number
               nor the last sequence number, the receiver should send
               two CAN characters and leave the Xmodem protocol
               (e. g. abort the file transfer).


               4.5.4.    Receive timeout errors


               When expecting data, if 10 seconds ever pass without
               receipt of a character, the receiver should send another
               NAK.  This should be repeated 10 times.  Some implement-
               ations will timeout after 10 seconds waiting for the
               first character of a packet, SOH, and then reduce the
               timeout for characters in a packet.  The timeout should
               not go below 5 seconds if the protocol is to be used
               with public data networks.


               4.5.5.    Transmit timeout errors


               In the original protocol, the transmitter would wait 10
               seconds for an ACK, NAK or CAN and then retransmit the
               last Xmodem packet as if a NAK had been received.  Most
               implementations either have the transmitter wait for a
               very long time (30 seconds to a minute) and then
               terminate the file transfer if an ACK, NAK or CAN has
               not been receive or wait about 30 seconds and retransmit
               the last packet.


               4.5.6.    Packet synchronization errors


               Since extraneous characters are frequently generated
               when using asynchronous communications, the receiver
               should not count on receiving exactly 132 characters for
               each Xmodem packet.  One algorithm for re-synchroniz-







          Xmodem, CRC Xmodem, WXmodem

     June 20, 1986                                                 Page 11

     ----------------------------------------------------------------------


               ation goes as follows:

                    Assume that the checksum algorithm will cause re-trans-
                    mission of Xmodem packets which contain extraneous
                    characters.

                    If the character received when expecting the start of a
                    packet is not a SOH then ignore the character and
                    continue to search for a SOH.

                    Once a SOH is found, assume that the next two characters
                    will be a valid sequence number and complement.  If they
                    are complements then assume that the packet has begun.
                    If they are not complements, continue to search for a
                    SOH.

                    Send a NAK if a timeout occurs while attempting to
                    re-synchronize (e.g. continue to process timeouts as
                    described above).

                    If no re-synchronization occurs within 135 characters
                    then send a NAK character and retry receiving the
                    packet.


               4.5.7.    False EOT condition

               When the receiver sees an EOT (which was not sent by the
               transmitter, but generated out of a communications error)
               instead of a SOH character, the receiver assumes incorrectly
               that the complete file has been transmitted.  This is
               typically an unrecoverable error and it does occur especdally
               when the transmitting and receiving UARTs are clocked
               slightly differently.  An algorithm to detect false EOT might
               return a NAK for the first EOT received and only assume true
               end of transmission after receiving two EOT's.


                    Transmitter                   Receiver

                    [last block .. ]    >>>>>
                                        <<<<<     [ACK]
                    [EOT]               >>>>>
                                        <<<<<     [NAK]
                    [EOT]               >>>>>
                                        <<<<<     [ACK]


               Just in case the transmitter was not prepared to resend the
               EOT, it might be wise to set the timeout to about 3 seconds
               and retransmit the NAK up to 3 times and then issue a warning
               message but assume end of transmission.








          Xmodem, CRC Xmodem, WXmodem

     June 20, 1986                                                 Page 12

     ----------------------------------------------------------------------

               4.5.8.    False CAN condition


               Some Xmodem implementations will terminate on a single CAN
               character.  Occasionally a CAN character will be generated by
               a communications error and if this occurs and is seen by the
               receiver between packets or is ever seen by the transmitter,
               the file transfer will be incorrectly canceled.  Many
               implementations now require two CAN characters in a row
               before assuming that the file transfer is to be aborted.







          Xmodem, CRC Xmodem, WXmodem

     June 20, 1986                                                 Page 13

     ----------------------------------------------------------------------



     5.   CRC XMODEM


     CRC Xmodem is very similar to Checksum Xmodem.  The protocol initiation
     has changed and the 8 bit checksum has been replaced by a 16 bit CRC.
     Only theses changes are presented.

     One of the earliest and most persistent problems with Xmodem were
     transmission errors which were not caught by the checksum algorithm.
     Assuming that there is no bias in asynchronous communications errors,
     we would expect that 1 out of every 256 erroneous complete or oversized
     Xmodem packets to have a valid checksum.  With the same assumption, if
     the checksum were 16 bits, we would expect 1 out of every 65,536
     erroneous complete or oversized packets would have a valid checksum.


          5.1. CRC Calculation Rules


          Considerable theoretical research has shown that a 16 bit cyclical
          redundancy check character (CRC/16) will detect a much higher
          percent of errors such that it would only allow 1 undetected
          bit in error for every 10^14 bits transmitted.  That's 1 un-
          detected error per 30 years of constant transmission at 1 mega-
          bit per second.  However, my personal experience indicates that
          something around 10^9 to 10^10 is more realistic.  Why such a vast
          improvement over the checksum algorithm?  It is caused by the
          unique properties that prime numbers have when being divided into
          integers.  Simply stated, if an integer is divided by a prime
          number, the remainder is unique.  The CRC/16 algorithm treats all
          integer by 2^16 and then divides that 1040 bit number by a 17 bit
          prime number.  The low order 16 bits of the remainder becomes the
          16 bit CRC.

          The 17 bit prime number in CRC Xmodem is 2^16 + 2^12 + 2^5 + 1 or
          65536 + 4096 + 32 + 1 = 69665.  So calculating the CRC is simple,
          just multiply the 128 byte data number by 65536, divide by 69665
          and the low order 16 bits of the remainder are the CRC.  The only
          problem is, I've never seen a computer which has instructions to
          support 130 byte integer arithmetic!  Fortunately for us, Seephan
          Satchell, Satchell Evaluations, published a specification a very
          efficient algorithm to calculate the CRC without either 130 byte
          arithmetic or bit manipulation.  Appendix A contains the source
          code, in IBM/PC BASIC, for the calculation of a CRC.

          Other methods of calculating CRC's for Xmodem involve bit level
          logic. a.




          a    Chuck Forsberg, "X/Ymodem Protocol Reference", available on
               many bulletin boards.







          Xmodem, CRC Xmodem, WXmodem

     June 20, 1986                                                 Page 14

     ----------------------------------------------------------------------



          5.2. CRC Xmodem Initiation


          The initiation of CRC Xmodem was designed to provide for automatic
          fall back to Checksum Xmodem if the transmitter does not support
          the CRC version.

          The receiver requests CRC Xmodem by sending the letter C (decimal
          67) instead of a NAK.  If the transmitter supports CRC Xmodem, it
          will begin transmission of the first Xmodem packet upon receipt of
          the C.  If the transmitter does not support CRC Xmodem, it will
          ignore the C.  The receiver should timeout after 3 seconds and
          repeat sending the C.  After 3 timeouts, the receiver should fall
          back to the checksum Xmodem protocol and send a NAK.










          Xmodem, CRC Xmodem, WXmodem

     June 20, 1986                                                 Page 15

     ----------------------------------------------------------------------



     6.   WINDOWED XMODEM (WXMODEM)a


     First, Xmodem provided the basic file transfer function, then CRC
     Xmodem improved the data integrity, now we come to WXmodem which
     provides better cost/performance.

          6.1. WXmodem Design Criteria


          A few people began discussing improvements to Xmodem with me in
          late 1985, over time we developed the following criteria:


               6.1.1.    The protocol must be as similar as possible to the
                         XMODEM originally developed by Ward Christensen.
                         The popularity of XMODEM, I believe, is based on
                         its conceptual simplicity.  More software writers
                         are familiar with this protocol than any other.
                         More files are transferred everyday by this
                         protocol than any other asynchronous protocol.
                         Simplicity here implies a limited number of rules
                         for timing, error recovery and initiation.


               6.1.2.    The protocol must overcome the propagation delay
                         that is characteristic of the public data net-
                         works.  While the cost of long distance communi-
                         cation is 50 to 90% less via the public data
                         networks than via the public voice networks, the
                         propagation delays inherent in public data networks
                         both reduces the cost savings and increases the
                         aggravation that occurs while watching a computer
                         slowly perform a file transfer.


               6.1.3.    The protocol must overcome the flow control
                         problems which are characteristic in many public
                         data network situations.  Basically, in most
                         situations, the X-On and X-Off characters must
                         always be used for flow control and only for flow
                         control when using public data networks.


               6.1.4.    The protocol should improve error recovery by
                         simplifying the manner in which a programmer can
                         determine the beginning of an XMODEM block.  Since
                         the Start of Header character (SOH) can appear in
                         the data or CRC, the programmer must use a rela-
                         tively sophisticated method to determine if a SOH
                         actually represents the beginning of a XMODEM
                         block.





          a    This section assumes that the reader is already familiar with
               Xmodem and CRC Xmodem presented above.







          Xmodem, CRC Xmodem, WXmodem

     June 20, 1986                                                 Page 16

     ----------------------------------------------------------------------





          6.2. Transparency and Flow Control Rules (Byte Level Rules)


          This protocol provides special public data network support for
          non-X.25 hosts and PC-Pursuit access to bulletin boards.  In order
          to accomplish this, the transmitter is not permitted to transmit
          the X-On and X-Off characters in the Xmodem packets.  The reason
          for this restriction is simple:


               By the very nature of X.25 public data networks, without
               flow control, buffer overruns and lost data are inevit-
               able from time to time at any baud rate.


               To avoid data loss public data networks must always
               assume that any X-Off and X-On character is a flow
               control character when supporting PC-Pursuit for
               bulletin boards and when supporting non-X.25 host
               systems.


          Since many non-X.25 hosts, bulletin boards and communications
          programs use X-On and X-Off as flow control characters, public
          data networks must support those X-Off and X-On requests at the
          point of connection where the X-Off is received by the public data
          network.  Otherwise, as many as several hundred characters backed
          up in the network would be transmitted by the public data network
          before the X-Off used for flow control reached the transmitter.
          The public data network has no way to know whether an X-On/X-Off
          protocol or Xmodem is operational at any point in time.  Therefore
          a Xmodem packet which contains an X-Off character and no succeed-
          ing X-On character will cause the public data network to stop
          forwarding the ACK or NAK.

          In addition, error recovery requires sophisticated programming for
          the receiver to determine the start of an XMODEM packet.  This
          protocol simplifies this task by dedicating a special character as
          an indicator that an XMODEM packet is about to begin.  The
          SYN (synch, decimal 22) character is used for this purpose.
          The presence of one or more SYN characters in a data stream always
          indicates that the next non SYN character is the beginning of an
          XMODEM packet (e.g. SOH).

          The method used here to handle these situations is through the
          insertion of the DLE character (H010, decimal 16, data link escape
          character) as an indicator that the character following the DLE is
          in fact a modified DLE, SYN, X-On, or X-Off character.

          Rules:


               6.2.1.    Whenever an X-On, X-Off, SYN or DLE character is
                         about to be transmitted as any part of an actual







          Xmodem, CRC Xmodem, WXmodem

     June 20, 1986                                                 Page 17

     ----------------------------------------------------------------------


                         XMODEM packet including the CRC, the transmitter
                         will transmit instead a DLE character followed by
                         the original character which has been modified by
                         exclusive or'ing it with 64 to its value. 1


               6.2.2.    The inserted DLE characters are not counted in the
                         128 byte data length of the data portion of the
                         XMODEM packet.  Indeed, it would be possible to
                         have a packet which is physically 264 bytes in
                         length because the Xmodem block sequence number
                         (or its complement), all of the 128 data characters
                         and two CRC characters are all either X-On, X-Off,
                         SYN or DLE characters.

               6.2.3.    Neither the DLE nor the adjusted characters are
                         used in the CRC calculation, rather the original
                         character is always used in the CRC calculation.

               6.2.4.    When the receiver sees a DLE character, it does not
                         count it in the XMODEM block length calculation,
                         nor compute it in the CRC calculation but discards
                         it and then remembers to exclusive or the next
                         character with 64 and to verify that the result
                         character is either a DLE, SYN, X-On or X-Off (the
                         receiver will reject the packet unconditionally, if
                         not one of those four characters) and then include
                         the character as part of the packet.

               6.2.5.    Prior to transmission of a XMODEM packet, the
                         transmitter will send one or more SYN characters
                         (recommend two) as a positive indicator to the
                         receiver of the beginning of a Xmodem packet.2


               6.2.6.    Except for the character received after a DLE, the
                         receiver will test each incoming character to see
                         if it is a SYN character.  If it is, it will
                         discard the character and assume that the next
                         character will be another SYN or SOH.  If a SYN
                         character is received in the middle of a packet,
                         the receiver will NAK that packet.  The purpose of
                         the SYN character is to simplify recognition of the
                         beginning of a XMODEM packet by the receiver.  Once
                         an out of synch condition occurs on incoming
                         data, the receiver can just ignore every incoming
                         character until it sees a SYN.  Existing XMODEM
                         code which already properly deals with this
                         situation could just always discard any SYN
                         character at time of receipt with no further
                         action.







          Xmodem, CRC Xmodem, WXmodem

     June 20, 1986                                                 Page 18

     ----------------------------------------------------------------------



               6.2.7.    The transmitter must support flow control char-
                         acters (X-On, and X-Off) during transmission of
                         packets.  Upon receipt of an X-Off it will wait 10
                         seconds for an X-On and will start transmission
                         again after 10 seconds or an X-On is received,
                         whichever occurs first.  Any extraneous X-On
                         characters received by the transmitter will be
                         ignored and discarded.  (Note that this does NOT
                         apply to X.25 host computers which use X.25 L2 and
                         L3 windows for flow control.)


          6.3. Initial Handshake Rules


          An initial handshake is provided to permit the receiver to
          indicate to the transmitter whether it can support checksum

     Xmodem, CRC Xmodem, or Windowed Xmodem:

               6.3.1.    WXMODEM - The receiver will send a character W
                         (decimal 87) and wait 3 seconds for the beginning
                         of a Xmodem packet.  This will be repeated 3 times
                         and then the receiver will drop down to CRC Xmodem.

               6.3.2.    CRC XMODEM - The receiver will send a character C
                         (decimal 67) and wait 3 seconds for the beginning
                         of a Xmodem packet.  This will be repeated 3 times
                         and then the receiver will drop down to Checksum
                         Xmodem.

               6.3.3.    Checksum XMODEM -  The receivers will send a NAK
                         and wait up to 3 seconds for the beginning of a
                         Xmodem packet.  This will be repeated 4 times and
                         if no valid SOH is received, the receiver will
                         abort the file transfer request.

          6.4. Window Packet Transmission Rules


          In order to overcome the propagation delays inherent with public
          data networks such as Tymnet, Telenet, Datapac, IPSS, Transpac and
          dozens more, the protocol must permit the transmitter to send more
          than one packet before receiving an acknowledgement from the
          receiver.  The number of packets that the transmitter will send
          before stopping transmission if an acknowledgement has not been
          received is called the "window".  WXmodem uses a window of 4
          packets for several reasons.  Most importantly, it uses a single
          set of timing rules which would deal reasonably well with a wide
          range of baud rates (that implied keeping the window fairly
          small).  Secondly, the window sequence number is directly related
          to the Xmodem packet sequence number which, hopefully, will
          simplify implementation of windowing.







          Xmodem, CRC Xmodem, WXmodem

     June 20, 1986                                                 Page 19

     ----------------------------------------------------------------------





          Rules:

               6.4.1.    The window is always 4 Xmodem packets.  That is,
                         the transmitter will send 4 unacknowledged pack-
                         ets.  Transmission will not cease and the time out
                         interval will not begin until 4 unacknowledged
                         packets have been transmitted.  Note that the
                         window may be less than 4 Xmodem packets for short
                         files or at end-of-file.


               6.4.2.    The receiver will transmit acknowledgements in the
                         form:


                              ACK[sequence]

                         The [sequence] field is an 8 bit number where the
                         high order or most significant 6 bits are always
                         zero and the low order or least significant 2 bits
                         are always the same as the low order 2 bits of the
                         XMODEM block sequence number of the XMODEM packet
                         being acknowledged (value in decimal may range
                         from 0 to 3).

               6.4.3.    The receiver does not have to acknowledge every
                         packet, but must acknowledge at minimum every
                         fourth packet.  The transmitter will accept one
                         ACK[sequence] for multiple XMODEM packets.  For
                         example, after an unknown number of packets:


                         Transmitter                             Receiver
                         ....
                         ....
                         ....
                         [Block Sequence Number H0FE]
                         [Block Sequence Number H0FF]            ACK[H002]
                         [Block Sequence Number H000]            ACK[H003]
                         [Block Sequence Number H001]
                         [Block Sequence Number H002]            ACK[H001]
                         .....

                         Since some transmitters must close the window and
                         cease all communications before doing disk I/O to
                         read more data, it is suggested that acknowledge-
                         ments be sent for every packet (except when the
                         receiver can easily determine that another packet
                         is already being received at the point in time that
                         the ACK[sequence] is about to be sent).3








          Xmodem, CRC Xmodem, WXmodem

     June 20, 1986                                                 Page 20

     ----------------------------------------------------------------------


               6.4.4.    The receiver will reject a packet (request re-
                         transmission) by sending:

                              NAK[sequence]

                         Where [sequence] is then next window sequence
                         number (between H000 and H003) after the [sequence]
                         of the last good block.  The receiver will discard
                         up to 3 Xmodem packets received after the NAK is
                         transmitted until it receives the packet with the
                         sequence number that had previously been nak'ed by
                         the receiver.  The receiver will not send a second
                         NAK until another packet with the same sequence
                         number is received which is also invalid or a
                         timeout has occurred.

               6.4.5.    When the transmitter receives a NAK[sequence], it
                         will complete transmission of any XMODEM block
                         currently being transmitted and then begin re-
                         transmission starting with the block which was
                         nak'ed.

               6.4.6.    The receiver will discard duplicate packets but
                         count them in the window for purposes of deter-
                         mining the maximum receive window without an ACK in
                         response.  For example, if the receiver gets packet
                         sequence number 127 four times in a row, it must
                         send an ACK H003 even if the receiver has previous-
                         ly acked that block.

               6.4.7.    The timeout intervals at various points in process-
                         ing are:

                         Waiting for a character on receive, start of packet
                         not yet recognized:      15 seconds

                         Waiting for a character on receive, start of packet
                         has been recognized:     15 seconds

                         Waiting for an Ack or Nak on transmit side after
                         the window has closed:   15 seconds4

                         Waiting for an X-On after receipt of an X-Off by
                         the transmitter:         10 seconds



               6.4.8.    When the transmitter times out waiting for an ACK
                         or NAK when the window is closed (e.g. four blocks
                         have been transmitted), the transmitter will
                         retransmit the last block transmitted and wait
                         again.  Only after 10 consecutive timeouts have







          Xmodem, CRC Xmodem, WXmodem

     June 20, 1986                                                 Page 21

     ----------------------------------------------------------------------



                         occurred will the transmitter cancel the trans-
                         mission.

               6.4.9.    Where possible, it is recommended that the receiver
                         return an ACK[sequence] for every packet or at
                         least 50% of the Xmodem packets.  When the receiver
                         must wait for the window to close (e.g. receive 4
                         Xmodem packets without an acknowledgement),
                         some performance benefit will be lost.

          If the receiver cannot overlap disk I/O and communications
          I/O, the receiver can temporarily stop transmission by either:

               "Closing the window" (e.g. receiving 4 blocks without sending
               an ACK[sequence]) performing the disk I/O and then sending an

               ACK[sequence].

               Transmitting an X-Off followed by an X-On when the receiver
               is ready to resume accepting data.  Note that the receiver
               should be prepared to accept data for about a 1/4 of a second
               after the X-Off is sent to cover situations where satellite
               propagation delay may occur.  One possible implementation
               would let the computer user set the "X-Off delay time" so
               that in the normal case the X-Off delay could be set to 25
               milleseconds.  A sophisticated implementation might set the
               initial X-Off delay at 250 milleseconds and then reduce it
               based on experience during the file transfer.

               Each approach has its advantages, but the X-Off approach will
               provide the best performance in most cases especially when
               using a public data network.  Note, however, that some
               computers, notably the Commodore 64 and the IBM PC Jr cannot
               receive communications data while writing to disk.








          Xmodem, CRC Xmodem, WXmodem

     June 20, 1986                                                 Page 22

     ----------------------------------------------------------------------



          6.5. Notes for X.25 Hosts


          Host computer systems which utilize the X.25 protocol
          (examples: People/Link, Delphi, CompuServe, The Source) to
          interface with the various public data networks may send special
          control packets which change the manner in which the network will
          communicate with the remote personal computer, bulletin board or
          terminal.  For the purposes of this paper, it is assumed that the
          X.25 host can already support CRC and/or Checksum Xmodem and
          present only the changes for WXMODEM.

               6.5.1.    When an X.25 Host is the transmitter, it must be
                         sure to set the distant X.3 PAD parameters to
                         assure that the receiver can use X-Off/X-On for
                         flow control.  This is accomplished by sending a
                         Q-Bit command packet to set X.3 parameter 12 to a 1
                         prior to the initial handshake.  Note that if the
                         receiver cannot support WXMODEM, the X.25 Host must
                         send the appropriate Q-Bit packet to reset para-
                         meter 12 to a 0 before transmitting the first CRC
                         or Checksum Xmodem packet.

               6.5.2.    When an X.25 Host is the receiver and in WXMODEM
                         mode, it must be sure to set the distant X.3 PAD
                         parameters to assure that the network will use
                         X-Off/X-On for flow control between the network and
                         the transmitter to prevent its buffers from
                         overflowing.  This is accomplished by sending a
                         Q-Bit command packet to set X.3 parameter 5 to a 1
                         prior to the initial handshake.









          Xmodem, CRC Xmodem, WXmodem

     June 20, 1986                                                 Page 23

     ----------------------------------------------------------------------



     7.   APPENDIX A - CRC CALCULATION RULES


     The purpose of this appendix is to give non-technical and non mathema-
     tical software writers a cook book approach to calculating the CRC-16
     used in Xmodem.  We have half accomplished that goal.  The BASIC code
     in the examples below has been tested on an IBM PC and found to work
     effectively even at 9600 with compiled Basic.  Some BASIC languages do
     not offer an XOR function and others do not have MKI$ and CVI functions
     which simplified the movement of data between data types.  Someday we
     hope to provide a Commodore C-64/C-128 implementation which simulates
     XOR, but not today!


     My thanks go to Chuck Forsberg, Joe Noonan, John Byrns and Stephen
     Satchell.  Without their help and public domain documents, this would
     have never been possible.


          7.1. IBM PC - 8088/8086 Data Structure


          The Intel 8080 and upward has a feature, convenient only to some
          electrical engineer somewhere, which places 2 byte (16) bit
          integers in BYTE REVERSE order in memory.  That is, the least
          significant byte is placed in memory before the most significant
          byte for integer operations.  If A$ is one byte containing the
          number 52 and it is assigned to I% using the ASC function, the
          binary value (52) ends up in the first byte of I% and the second
          byte is zero.

                                   Result

               I%=0                [x'0000']
               I%=1                [x'0100']
               A$="A"              [x'41']
               I%=ASC(A$)          [x'4100']
               B$=MKI$(I%)         [x'4100']  letter "A" then binary zero
               I%=CVI(CHR$(0)+A$)  [x'0041']
               A$=CHR$(65)         [x'41']

          Once this is understood, many problems with these algorithms goes
          away.



          7.2. BASIC Implementation of Bit Shift Method


          The bit shift method here was converted from the "C" logic
          presented in Chuck Forsberg's "Xmodem/Ymodem" protocol reference
          and from an old IBM two page reference guide that Joe Noonan
          carries with him in his appointment calendar!








          Xmodem, CRC Xmodem, WXmodem

     June 20, 1986                                                 Page 24

     ----------------------------------------------------------------------





          Chucks' "C" code:

     /*
      * This function calculates the CRC used by the XMODEM/CRC Protocol
      * The first argument is a pointer to the message block.
      * The second argument is the number of bytes in the message block.
      * The function returns an integer which contains the CRC.
      * The low order 16 bits are the coefficients of the CRC.
      */

     int calcrc(ptr, count)
     char *ptr;
     int count;
     {
         int crc, i;


         crc = 0;
         while (--count >= 0) {
          crc = crc ^ (int)*ptr++ << 8;
          for (i = 0; i < 8; ++i)
              if (crc & 0x8000)
               crc = crc << 1 ^ 0x1021;
              else
               crc = crc << 1;
          }
         return (crc & 0xFFFF);
     }








          Xmodem, CRC Xmodem, WXmodem

     June 20, 1986                                                 Page 25

     ----------------------------------------------------------------------





          But in IBM PC BASIC, our implementation looks like:


     100 DEFINT A-Z 'DEFAULT IS TWO BYTE INTEGERS
     2000 REM * V$ CONTAINS 133 CHARACTER COMPLETE XMODEM PACKET
     2010 REM * CRC$ IS TWO BYTE CRC WITH MOST SIGNIFICANT BYTE FIRST
     2020 CRC$=CHR$(0)+CHR$(0)                      'START AT ZERO
     2030 FOR I2=4 TO 131
     2040   A$=MID$(V$,I2,1)
     2050   GOSUB 4000
     2060 NEXT I2
     2070 REM * CRC$ CONTAINS CALCULATED CRC!
     3000 IF CRC$=MID$(V$,132,2) THEN ....    'IT'S GOOD!!!
     4000 REM * CRC BITWISE CALCULATION (WHAT A JOKE!)
     4010 CRCH1=ASC(LEFT$(CRC$,1)) XOR ASC(A$)
     4020 CRCL1=ASC(RIGHT$(CRC$,1))
     4030 FOR I3 = 0 TO 7
     4040   CARRY=0 : IF CRCH1 > 127 THEN CARRY=-1  'IS HIGH BIT ON IN CRC?
     4050   CRCH1=(CRCH1*2) AND 255                 'CRCH << 1 AND 255
     4060   IF CRCL1>127 THEN CRCH1=CRCH1+1 'IF CRCL CARRIES THEN INCR CRCH
     4070   CRCL1=(CRCL1*2) AND 255                 'CRCL << 1 AND 255
     4080   IF CARRY=0 THEN GOTO 4105               'IF HIGH BIT WAS ON,
     4090   CRCH1=CRCH1 XOR 16                      'XOR WITH &H1021
     4100   CRCL1=CRCL1 XOR 33
     4110 NEXT I3
     4130 CRC$=CHR$(CRCH1)+CHR$(CRCL1)
     4140 RETURN 'WHEW

          That routine will execute 128 * 7 + 128 * 9 * 8 BASIC statements
          for each Xmodem packet or 10112 statements per Xmodem packet!  It
          will work for low baud rates in compiled BASIC, but just is too
          much for interpretive BASIC.









          Xmodem, CRC Xmodem, WXmodem

     June 20, 1986                                                 Page 26

     ----------------------------------------------------------------------



          7.3. BASIC Implementation of the Table Method


          This method is based on routine M4 in Steven Satchell's paper,
          "Test of CRC Routines for CRC-CCITT", but has some very signifi-
          cant differences.  A table of 256 CRC's, originally calculated
          with the bit shift method is used to avoid performing the bit
          shift during communications.  The table contains the CRC's for
          each byte value from 0 to 255 when the original CRC is zero.  The
          result of this calculation is included in the DATA statements in
          the code.

          The comments are intended to show what is logically happening
          rather than physically.  Because of the "byte reverse" nature of
          integers in the 8088, a logical shift of 8 bits to the left is a
          physical shift of eight bits to the right!




     200 DEFINT A-Z  'ALL INTEGERS
     210 DIM CRCTB(256)
     300 GOSUB 9000 'INITIALIZE CRC TABLES
     6200 REM * CRC CALCULATION USING TABLE METHOD, V$=XMODEM PACKET
     6210 CRC$=CHR$(0)+CHR$(0)                 'INITIALIZE TO ZERO
     6220 FOR Q=4 TO 131
     6230   CRCH1=ASC(LEFT$(CRC$,1))           'CRC >> 8 AND 255
     6240   CRCL2=CVI(CHR$(0)+RIGHT$(CRC$,1))  'CRC << 8 AND 255
     6250   CRC1$=MKI$(CRCTB(CRCH1 XOR ASC(MID$(V$,Q,1))) XOR CRCL2)
     6260   CRC$=RIGHT$(CRC1$,1)+LEFT$(CRC1$,1) 'SET IT BACK!
     6270 NEXT Q
     6280 IF CRC$ <> MID$(V$,N,2) THEN ....... 'GOTO ERROR ROUTINE
     6290 REM * END OF CRC CALC
     9000 FOR I%=0 TO 255 ' INITIALIZE CRC TABLE
     9010   READ CRCTB(I%)
     9020 NEXT I%
     9025 RETURN
     9030 DATA 0, 4129, 8258, 12387, 16516, 20645, 24774, 28903
     9040 DATA -32504,-28375,-24246,-20117,-15988,-11859,-7730,-3601
     9050 DATA 4657, 528, 12915, 8786, 21173, 17044, 29431, 25302
     9060 DATA -27847,-31976,-19589,-23718,-11331,-15460,-3073,-7202
     9070 DATA 9314, 13379, 1056, 5121, 25830, 29895, 17572, 21637
     9080 DATA -23190,-19125,-31448,-27383,-6674,-2609,-14932,-10867
     9090 DATA 13907, 9842, 5649, 1584, 30423, 26358, 22165, 18100
     9100 DATA -18597,-22662,-26855,-30920,-2081,-6146,-10339,-14404
     9110 DATA 18628, 22757, 26758, 30887, 2112, 6241, 10242, 14371
     9120 DATA -13876,-9747,-5746,-1617,-30392,-26263,-22262,-18133
     9130 DATA 23285, 19156, 31415, 27286, 6769, 2640, 14899, 10770
     9140 DATA -9219,-13348,-1089,-5218,-25735,-29864,-17605,-21734
     9150 DATA 27814, 31879, 19684, 23749, 11298, 15363, 3168, 7233







          Xmodem, CRC Xmodem, WXmodem

     June 20, 1986                                                 Page 27

     ----------------------------------------------------------------------



     9160 DATA -4690,-625,-12820,-8755,-21206,-17141,-29336,-25271
     9170 DATA 32407, 28342, 24277, 20212, 15891, 11826, 7761, 3696
     9180 DATA -97,-4162,-8227,-12292,-16613,-20678,-24743,-28808
     9190 DATA -28280,-32343,-20022,-24085,-12020,-16083,-3762,-7825
     9200 DATA 4224, 161, 12482, 8419, 20484, 16421, 28742, 24679
     9210 DATA -31815,-27752,-23557,-19494,-15555,-11492,-7297,-3234
     9300 DATA 689, 4752, 8947, 13010, 16949, 21012, 25207, 29270
     9310 DATA -18966,-23093,-27224,-31351,-2706,-6833,-10964,-15091
     9320 DATA 13538, 9411, 5280, 1153, 29798, 25671, 21540, 17413
     9330 DATA -22565,-18438,-30823,-26696,-6305,-2178,-14563,-10436
     9340 DATA 9939, 14066, 1681, 5808, 26199, 30326, 17941, 22068
     9350 DATA -9908,-13971,-1778,-5841,-26168,-30231,-18038,-22101
     9360 DATA 22596, 18533, 30726, 26663, 6336, 2273, 14466, 10403
     9370 DATA -13443,-9380,-5313,-1250,-29703,-25640,-21573,-17510
     9380 DATA 19061, 23124, 27191, 31254, 2801, 6864, 10931, 14994
     9390 DATA -722,-4849,-8852,-12979,-16982,-21109,-25112,-29239
     9400 DATA 31782, 27655, 23652, 19525, 15522, 11395, 7392, 3265
     9410 DATA -4321,-194,-12451,-8324,-20581,-16454,-28711,-24584
     9420 DATA 28183, 32310, 20053, 24180, 11923, 16050, 3793, 7920


          This method uses 128 * 6 BASIC statements per Xmodem packet or a
          miserly 768 BASIC statements per packet.  And, if you want, the
          code can be tightened still more.  Unfortunately, any further
          tightening that we could see would eliminate most of the already
          limited readability of the code.



     Xmodem, CRC Xmodem, WXmodem

     June 20, 1986                                                 Page 28

     ----------------------------------------------------------------------



     8.   NOTES AND COMMENTS


     Please add your notes and comments here or send them to me and I'll get
     them added to the current copy on People/Link.


     1.   This was originally set up to ADD 32 to the character on transmit
          and SUBTRACT 32 on receive.  By using exclusive or with 64, the
          logic is the same on transmit and receive.


     2.   The use of the SYN character was added at the request of several
          people who have coded Xmodem routines and have struggled valiantly
          to improve their error recovery routines.  Peter Boswell 6/10/86


     3.   The suggestion that ACK[sequence] be sent for every block received
          was added.          Peter Boswell       6/10/86


     4.   The original value for the ACK/NAK timeout was 10 seconds.  This
          was changed to 15 seconds the situation where the receiver is
          operating at 300 baud and using X-Off to stop receipt of characters
          during disk I/O.  Peter Boswell, 6/10/86



