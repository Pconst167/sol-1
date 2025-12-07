@#$%&@#$%&@#$%&@#$%&@#$%&@#$%&@#$%&@#$%&@#$%&#$%&@#$%&@#$%&@#$%&@#$%&@#$%&#@
#                                                                          $
$                                   A                                      %
&                                                                          @
@                             Hacker's Guide                               #
#                                                                          $
$                                  to                                      %
%                                                                          &
&                             The Internet                                 @
@                                                                          #
#                                                                          $
$                             By: The Gatsby                               %
%                                                                          &
&@#$%&@#$%&@#$%&@#$%&@#$%&@#$%&@#$%&@#$%&@#$%&@#$%&@#$%&@#$&@#$%&@#$%&@#$%&@
@                                                                          #
$      Version  2.00       !         AXiS         !         7/7/91         $
%                                                                          &
&@#$%&@#$%&@#$%&@#$%&@#$%&@#$%&@#$%&@#$%&@#$%&@#$%&@#$%&@#$&@#$%&@#$%&@#$%&@



1   Index
~~~~~~~~~

            Part:          Title:
            ~~~~           ~~~~~
             1             Index
             2             Introduction
             3             Glossary, Acronyms & Abbreviations
             4             What is The Internet ?
             5             Where Can You Access The Internet
             6             TAC
             7             Basic Commands
               a                TELNET command
               b                ftp ANONYMOUS to a Remote Site
               c                Basic How to tftp the Files
               d                Basic Fingering
             8             Networks You Will See Around
             9             Internet Protocols
            10             Host Name & Address
            11             Tips and Hints


2   Introduction
~~~~~~~~~~~~~~~~

     Well, I was asked to write this file by Haywire (aka. Insanity, SysOp
of Insanity Lane), about Internet. Thus the first release of this file was in
a IRG newsletter. Due to the mistakes of the last release of this file has
prompted me to "redo" some of this file, add some more technical stuff and
release it for AXiS.
      I have not seen any files written for the new comer to Internet, so
this will cover the basic commands, the use of Internet, and some tips for
hacking through internet. There is no MAGICAL way to hacking a UNIX system, i
have found that brute force works best (Brute hacker is something different).
Hacking snow balls, once you get the feel of it, it is all clock work from
there. Well i hope you enjoy the file. If you have any questions i can be
reached on a number of boards. This file was written for hackers (like me)
who do not go to school with a nice Internet account, this is purely written
for hackers to move around effectively who are new to Internet. The last part
of this file is for people who know what they are doing, and want more
insight.


- The Crypt       -            - 619/457+1836 -     - Call today -
- Land of Karrus  -            - 215/948+2132 -
- Insanity Lane   -            - 619/591+4974 -
- Apocalypse NOW  -            - 2o6/838+6435 -  <*> AXiS World HQ <*>

  and any other good board  across the country.....

  Mail me on the Internet:  gats@ryptyde.cts.com
                            bbs.gatsby@spies.com


                                The Gatsby


3   Glossary, Acronyms & Abbreviations
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ACSE     -  Association Control Service Element, this is used with ISO
            to help manage associations.
ARP      -  Address Resolution Protocol, this is used to translate IP
            protocol to Ethernet Address.
ARPA     -  defence_Advanced_Research_Project_Agency.
ARPANET  -  defence Advanced Research Project Agency or ARPA. This is a
            experimental PSN which is still a sub network in the Internet.
CCITT    -  International Telegraph and Telephone Consultative Committee
            is a international committee that sets standard. I wish they
            would set a standard for the way they present their name!
CERT     -  Computer Emergency Response Team, they are responsible for
            coordinating many security incident response efforts. In other
            words, these are the guys you do not want to mess with, because
            they will make your life a living hell. They are the Internet
            pigs, but they do have real nice reports on "holes" in various
            UNIX strands, which you should get, they will help you a lot.
CMIP     -  Common Management Information Protocol, this is a new HIGH level
            protocol.
CLNP     -  Connection Less Network Protocol is a OSI equivalent to
            Internet IP
DARPA    -  Defence Advanced Research Project Agency. See ARPANET
DDN      -  Defence Data Network
driver   -  a program (or software) that communicates with the network
itself,
            examples are TELNET, FTP, RLOGON, etc
ftp      -  File Transfer Protocol, this is used to copy files from
            one host to another.
FQDN     -  Fully Qualified Domain Name, the complete hostname that
            reflects the domains of which the host is a part
gateway  -  Computer that interconnects networks
host     -  Computer that connected to a PSN.
hostname -  Name that officially identifies each computer attached
            internetwork.
Internet -  The specific IP-base internetwork.
IP       -  Internet Protocol which is the standard that allows dissimilar
            host to connect.
ICMP     -  Internet Control Message Protocol is used for error messages for
            the TCP/IP
LAN      -  Local Area Network
MAN      -  Metropolitan Area Network
MILNET   -  DDN unclassified operational military network
NCP      -  Network Control Protocol, the official network protocol from
            1970 until 1982.
NIC      -  DDN Network Information Center
NUA      -  Network User Address
OSI      -  Open System Interconnection. An international standardization
            program facilitate to communications among computers of
            different makes and models.
Protocol -  The rules for communication between hosts, controlling the
            information by making it orderly.
PSN      -  Packet Switched Network
RFC      -  Request For Comments, is technical files about Internet
            protocols one can access these from anonymous ftp at NIC.DDN.MIL
ROSE     -  Remote Operations Service Element, this is a protocol that
            is used along with OSI applications.
TAC      -  Terminal Access Controller; a computer that allow direct
            access to internet.
TCP      -  Transmission Control Protocol.
TELNET   -  Protocol for opening a transparent connection to a distant host.
tftp     -  Trivial File Transfer Protocol, one way to transfer data from
            one host to another.
UDP      -  User Datagram _Protocol
UNIX     -  This is copyrighted by AT$T, but i use it to cover all the look
            alike UNIX system, which you will run into more often.
UUCP     -  Unix-to-Unix Copy Program, this protocol allows UNIX file
            transfers. This uses phone lines using its own protocol, X.25 and
            TCP/IP. This protocol also exist for VMS and MS-DOS (Why not
            Apple's ProDOS ? I still have one!).
uucp     -  uucp when in lower case refers to the UNIX command uucp. For
            more information on uucp read The Mentors files in LoD Tech.
            Journals.
WAN      -  Wide Area Network
X.25     -  CCITTs standard protocol that rules the interconnection of two
            hosts.

  In this text file i have used several special charters to signify certain
thing. Here is the key.

*  - Buffed from UNIX it self. You will find this on the left side of the
     margin. This is normally "how to do" or just "examples" of what to do
     when using Internet.
#  - This means these are commands, or something that must be typed in.




4   What is The Internet ?
~~~~~~~~~~~~~~~~~~~~~~~~~~

     To understand The Internet you must first know what it is. The Internet
is a group of various networks, ARPANET (an experimental WAN) was the
first. ARPANET started in 1969, this experimental PSN used Network Control
Protocol (NCP). NCP was the official protocol from 1970 until 1982 of the
Internet (at this time also known as DARPA Internet or ARPA Internet). In the
early 80's DARPA developed the Transmission Control Protocol/Internet
Protocol which is the official protocol today, but much more on this later.
Due to this fact, in 1983 ARPANet split into two networks, MILNET and ARPANET
(both still being part of the DDN).
    The expansion of Local Area Networks (LAN) and Wide Area Networks (WAN)
helped make the Internet connecting 2,000+ networks strong. The networks
include NSFNET, MILNET, NSN, ESnet and CSNET. Though the largest part of the
Internet is in the United States, the Internet still connects the TCP/IP
networks in Europe, Japan, Australia, Canada, and Mexico.


5   Where can you access Internet ?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

   Internet is most likely to be found on Local Area Networks or LANs and
Wide Area networks or WANs. LANs are defined as networks permitting the
interconnection and intercommunication of a group of computers, primarily for
the sharing of resources such as data storage device and printers. LANs cover
a short distance (less than a mile), almost always within a single building
complex. Normally having gateways to Internet, and in turn Internet the back
bone to the area network, but one could argue this point.
   WANs are networks which have been designed to carry data calls over long
distances (many hundreds of miles). Thus also being (for the same reasons
LANs are) linked into the mix mash of PSN.
   You can also access Internet through TymNet or Telenet via gateway. But i
do not happen to have the TymNet or Telenet a NUA now, just ask around.


6   TAC
~~~~~~~

    TAC is another way to access internet, but due to the length of this part 
I
just made it another section.
   TAC (terminal access controller) is another way to access Internet. This
is just dial-up terminal to a terminal access controller. You will need to
hack out a password and account. TAC has direct access to MILNET (a part of
internet, one of the networks in the group that makes up internet).
 A TAC dial up number is 18oo/368+2217 (this is just one, there are full
lists on any good text file board), and TAC information services from which
you can try to social engineer a account (watch out their is a CERT report
out
about this, for more information the CERT reports are available at
128.237.253.5 anonymous ftp, more on that later), the number is 18oo/235+3155
and 1415/859+3695. If you want the TAC manual you can write a letter to (be
sure an say you want the TAC user guide, 310-p70-74) :

       Defense Communications Agency
       Attn: Code BIAR
       Washington, DC 2o3o5-2ooo


 To logon you will need a TAC Access Card, but you are a hacker, so I am not
counting on this (if you can get a card, you would get it from the DDN NIC).
Here is a sample logon:

Use Control-Q for help...

*
* PVC-TAC 111: 01               \ TAC uses to this to identify itself
* @ #o 124.32.5.82               \ Use ``O'' for open and the internet
*                                / address which yea want to call.
*
* TAC Userid: #THE.GATSBY
* Access Code: #10kgb0124
* Login OK
* TCP trying...Open
*
*


Good Luck you will need it....

7   Basic Commands, and things to do
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

a:  Basic TELNET Commands



      Ok, you now have a account on a UNIX system which is a host on
Internet, you can not access the world. Once on the UNIX system you should
see a prompt, which can look like a '$', '%' of the systems name (also
depending on what shell you are in, and the type of UNIX system). Now at the
prompt you can do all the normal UNIX accounts, but when on a Internet host
you can type 'telnet' which will bring you to the 'telnet' prompt.

*
* $ #telnet
* ^   ^
  |   |
  |  the command that will bring you to the telnet prompt
  |
  a normal UNIX prompt


once this is done you should see this:

*
* telnet>
*
    At this prompt you will have a whole different set of commands which are
as follow (NOTE taken from UCSD, so this may vary from place to place).

*
* telnet> #help
*
* close           close current connection
* display         display operating parameters
* open            connect to a site
* quit            exit telnet
* send            transmit special character
* set             set operating parameters
* status          print status information
* toggle          toggle operating parameters
* ?               to see what you are looking at now
*

close      - this command is used to 'close' a connection, when multitasking
             or jumping between systems.

display    - this set the display setting, commands for this are as follow.

             ^E    echo.
             ^]    escape.
             ^H    erase.
             ^O    flushoutput.
             ^C    interrupt.
             ^U    kill.
             ^\    quit.
             ^D    eof.



open       - type 'open [host]' to connect to a system

*
* $ #telnet ucsd.edu
*

     or
*
* telnet> #open 125.24.64.32.1
*

quit       - to get out of telnet, and back to UNIX.

send       -  send files

set        -
             echo    - character to toggle local echoing on/off
             escape  - character to escape back to telnet command mode

                The following need 'localchars' to be toggled true
             erase         -  character to cause an Erase Character
             flushoutput   -  character to cause an Abort Output
             interrupt     -  character to cause an Interrupt Process
             kill          -  character to cause an Erase Line
             quit          -  character to cause a Break
             eof           -  character to cause an EOF
             ?             -  display help information

?          -  to see the help screen






b:   ftp ANONYMOUS to a remote site


    ftp or file transfer protocol is used to copy file from a remote host to
the one that you are on. You can copy anything from some ones mail to the
passwd file. Though security has really clamped down on the passwd flaw, but
it will still work here and there (always worth a shot). More on this later,
lets get an idea what it is first.
     This could come in use full when you see a Internet CuD site that
accepts a anonymous ftps, and you want to read the CuDs but do not feel like
wasting your time on boards down loading them. The best way to start out is
to ftp a directory to see what you are getting (taking blind stabs is not
worth a few CuDs). This is done as follow: (the CuD site is Internet address
192.55.239.132, and my account name is gats)


*
* $ #ftp
* ^  ^
  |  |
  | ftp command
  |
 UNIX prompt

*
* ftp> #open 192.55.239.132
* Connected to 192.55.239.132
* 220 192.55.239.132 FTP Server (sometimes the date, etc)
* Name (192.55.239.132:gats): #anonymous
*            ^         ^        ^
             |         |        |
             |         |       This is where you type 'anonymous' unless
             |         |     you have a account 192.55.239.132.
             |         |
             |        This is the name of my account or [from]
             |
            This is the Internet address or [to]
*
* Password: #gats
*            ^
             |
            For this just type your user name or anything you feel like
            typing in at that time.

*
* % ftp 192.55.239.132
* Connected to 192.55.239.132
* ftp> #ls
*       ^
        |
       You are connected now, thus you can ls it.

     Just move around like you would in a normal unix system. Most of the
commands still apply on this connection. Here is a example of me getting a
Electronic Frontier Foundation Vol. 1.04 from Internet address
192.55.239.132.

*
* % #ftp
* ftp> #open 128.135.12.60
* Trying 128.135.12.60...
* 220 chsun1 FTP server (SunOS 4.1) ready.
* Name (128.135.12.60:gatsby): anonymous
* 331 Guest login ok, send ident as password.
* Password: #gatsby
* 230 Guest login ok, access restrictions apply.
* ftp> #ls
* 200 PORT command successful.
* 150 ASCII data connection for /bin/ls (132.239.13.10,4781) * (0 bytes).
* .hushlogin
* bin
* dev
* etc
* pub
* usr
* README
* 226 ASCII Transfer complete.
* 37 bytes received in 0.038 seconds (0.96 Kbytes/s)
* ftp>

     /
     \  this is where you can try to 'cd' the "etc" dir or just 'get'
     /  /etc/passwd, but grabbing the passwd file this way is a dieing art.
     \  But then again always worth a shot, may be you will get lucky.
     /

* ftp> #cd pub
* 200 PORT command successful.
* ftp> #ls
* ceremony
* cud
* dos
* eff
* incoming
* united
* unix
* vax
* 226 ASCII Transfer cmplete.
* 62 bytes received in 1.1 seconds (0.054 Kbytes/s)
* ftp> #cd eff
* 250 CWD command successful.
* ftp> #ls
* 200 PORT command successful.
* 150 ASCII data connection for /bin/ls (132.239.13.10,4805) (0 bytes).
* Index
* eff.brief
* eff.info
* eff.paper
* eff1.00
* eff1.01
* eff1.02
* eff1.03
* eff1.04
* eff1.05
* realtime.1
* 226 ASCII Transfer complete.
* 105 bytes received in 1.8 seconds (0.057 Kbytes/s)
* ftp> #get
* (remote-file) #eff1.04
* (local-file) #eff1.04
* 200 PORT command successful.
* 150 Opening ASCII mode data connection for eff1.04 (909 bytes).
* 226 Transfer complete.
* local: eff1.04 remote: eff1.04
* 931 bytes received in 2.2 seconds (0.42 Kbytes/s)
* ftp> #close
* Bye...
* ftp> #quit
* %
*


   To read the file you can just 'get' the file and buff it! Now if the
files are just too long you can 'xmodem' it off the host your on. Just type
'xmodem' and that will make it much faster to get the files. Here is the set
up (stolen from ocf.berkeley.edu).

   If you want to:                                         type:
send a text file from an apple computer to the ME       xmodem ra <filename>
send a text file from a non-apple home computer         xmodem rt <filename>
send a non-text file from a home computer               xmodem rb <filename>
send a text file to an apple computer from the ME       xmodem sa <filename>
send a text file to a non-apple home computer           xmodem st <filename>
send a non-text file to a home computer                 xmodem sb <filename>


xmodem will then display:

*
* XMODEM Version 3.6 -- UNIX-Microcomputer Remote File Transfer Facility
* File filename Ready to (SEND/BATCH RECEIVE) in (binary/text/apple) mode
* Estimated File Size (file size)
* Estimated transmission time (time)
* Send several Control-X characters to cancel
*


Hints - File transfer can be an iffy endeavor; one thing that can help is to
tell the annex box not to use flow control.  Before you do rlogin to an
ME machine, type

 stty oflow none
 stty iflow none

at the annex prompt.  This works best coming through 2-6092. Though i have
not found this on too many UNIX systems with the xmodem command, but where it
is you can find me LeEcHiNg files.

      |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|
      |          Special commands used during ftp session:              |
      |                                                                 |
      | Command:			Description:			|
      | 								|
      |     cdup			same as cd ..			|
      |     dir 			give detailed listing of files	|
      | 								|
      |                                                                 |
      ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

c:   How to tftp the Files

     tftp (Trivial File Transfer Protocol, the command is not in caps,
because UNIX is cap sensitive) is a command that is used to transfer files
from host to host. This command is used sometimes like ftp, in that you can
mover around using UNIX command. I will not go into this part of the command,
but i will go into the basic format, and structure to get files you want. More
over I will be covering how to flip the /etc/passwd out of remote sites. Real
use full, then you can give Killer Kracker a test run!
     Well there is a little trick that has been around a while. This trick it
the tftp. This little trick will help you to "flip" the /etc/passwd file out
of different sites. This can be real handy, you can have the passwd file with
out breaking into the system. Then just run Brute Hacker (the latest version)
on the thing, thus you will save time, and energy.  This 'hole' (NOTE the
word 'hole' is not used in this case in the normal sense, the normal sense it
a way to obtain super user status once in UNIX) may be found on SunOS 3.X,
but have been fixed in 4.0. Though i have found this hole in several other
system, such as System V, BSD and a few others.
     The only problem with this 'hole' is that the system manager will
sometimes know that you are doing this (that is if the manager know what the
hell he is doing). The problem occurs when attempts to tftp the /etc/passwd
is done too many times, you may see this (or something like this) when you
logon on to your ? account. (This is what I buffed this off
plague.berkeley.edu, hmm i think they knew what i was doing <g>).

*
* DomainOS Release 10.3 (bsd4.3) Apollo DN3500 (host name):
*         This account has been deactivated due to use in system cracking
* activities (specifically attempting to tftp /etc/passwd files from remote
* sites) and for having been used or broken in to from <where the calls are
* from>.  If the legitimate owner of the account wishes it reactivated,
* please mail to the staff for more information.
*
* - Staff
*

    Though, if this is not done too much it can be a use full tool in hacking
 on Internet. The tftp is used in this format is as follow:

 tftp -<command> <any name> <Internet Address>  /etc/passwd  <netascii>

Command      -g   is to get the file, this will copy the file onto
                  your 'home' directory, thus you can do anything with
                  the file.

Any Name     If your going to copy it to your 'home' directory
             you may want to name anything that is not already
             used. I have found it best to name it 'a<and the internet
             address>' or the internet address name, so I know
             where is came from.

Internet     This is the address that you want to snag the passwd file
   Address   from.  I will not include any for there are huge list that other
             hackers have scanned out, and I would be just copying their
             data.

/ETC/PASSWD  THIS IS THE FILE THAT YOU WANT, ISN'T IT ? I DO NOT THINK YOU
             want John Jones mail. Well you could grab their mail, this
             would be one way to do it.

netascii     This how you want file transferred, you can also do it
             Image, but i have never done this. I just leave it blank, and it
             dose it for me.

&            Welcome to the power of UNIX, it is multitasking, this little
             symbol place at the end will allow you to do other things (such
             as grab the passwd file from the UNIX that you are on).

    Here is the set up:We want to get the passwd file from sunshine.ucsd.edu.
The file is copying to your 'home' directory is going to be named
'asunshine'.

*
* $ #tftp -g asunshine sunshine.ucsd.edu /etc/passwd &
*


d  Basic Fingering

   Fingering is a real good way to get account on remote sites. Typing 'who'
of just 'finger <account name> <CR>' you can have names to "finger". This
will give you all kinds info. on the persons account, thus you will have a
better chance of cracking that system. Here is a example of how to do it.


*
* % #who
* joeo                 ttyp0       Jun 10 21:50   (bmdlib.csm.edu)
* gatsby               ttyp1       Jun 10 22:25   (foobar.plague.mil)
* bbc                  crp00       Jun 10 11:57   (aogpat.cs.pitt.edu)
* liliya               display     Jun 10 19:40

                 /and fingering what you see

* % #finger bbc
* Login name: bbc                     In real life: David Douglas Cornuelle
* Office: David D. Co
* Directory: //aogpat/users_local/bdc     Shell: /bin/csh
* On since Jun 10 11:57:46 on crp00 from aogpat   Phone 555-1212
* 52 minutes Idle Time
* Plan: I am a dumb fool!!
* %
*

     From there i can just call 'aogpat.cs.pit.edu' and try to hack it out.
Try the last name as the password, the first name, middle name and try them
all backwards (do i really need to explain it any more). The chances are real
good that you WILL get in since you now have something to work with.
     If there are no users in line for you to type "who" you can just type
"last" and all the user who logged on will come rolling out, and "finger"
them. The only problem with using the last command is aborting it.
     You can also try and call them and say you are the system manager, and
bull
shit your way to your new account! But i have not always seen phone numbers,
only on some systems....


11  Networks You Will See Around
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   I though I would add this as a reference guide to some common networks on
the Internet. If anything, you can know what people are talking about on some
good BBSs you may be on. NOTE I assembled this list from various information
I have.


AARNet -      Australian Academic and Research Network, this network is to
              support research for various Australian Universities. This
              network supports TCP/IP, DECnet, and OSI (CLNS).

ARPANET -     Getting sick of reading about this yet ? Well i am getting
              sick of typing it.

BITNET -      Because It's Time NETwork (BITNET) is a worldwide network that
              connects many colleges and universities. This network uses many
              different protocols, but it dose use the TCP/IP. Maybe you will
              come across it.

CREN CSNET -  Corporation for Research and Educational Network (CREN), The
              Computer + Science research NETwork (CSNET). This network
              links scientists at sites all over the world. CSNET providing
              access to the Internet, CRET to BITNET. CREN being the name
              used today.

CSUNET -      California State University Network (CSUNET). This net
              connects the California State University campuses and other
              universities in California. This network is based on the CCITT
              X.25 protocol, and also uses TCP/IP, SNA/DSLC, DECnet, etc etc.

The Cypress Net - This network started as a experimental network. The use
             of this network today is to connection to the TCP/IP Internet
             as a cheap price.

DRI -        Dirty Rotten Oops, _Defense _Research _Internet is a WAN that
             is used as a platform from which to work from. This network has
             all kind of services, such as multicast service, real-time
             conference etc. This network uses the TCP/IP (also see RFC
             907-A for more information on this network).

ESnet -      Is the new network by the Department of Energy Office of Energy
             Research (DoE OER). This net is the backbone for all DoE OER
             programs. This network replaced the High Energy Physics DECnet
             (HEPnet) and also the Magnetic Fusion Energy network (MFEnet).
             The protocols offered are IP/TCP, and also DECnet service.

JANET -      JANET is a Joint Academic NETwork based in the UK, connected to
             the Internet. JANET is a PSN (information has pass through a
             PAD) using the protocol X.25 though it dose support the TCP/IP.
             This network also connects PSS (Packet Switched Service is a
             PSN that is owned and operated by British telecom).

JUNET -      Japan's university message system using UUCP, the Internet
             as its backbone, and X.25 (Confused, read RFC 877). This network
             is also a part of USENET (this is the network news).

Los Nettos - Los Nettos is a high speed MAN in the Los Angeles area. This
             network uses the IP/TCP.

MILNET -     When ARPANET split, the DDN was created, thus MILNET (MILitary
             NETwork) being apart of the network. MILNET is a unclassified,
             along with three other classified networks which make up the
             DDN.

NORDUNet -   This net is the backbone to the networks in the Nordic
             Countries, Denmark (DENet), Finland (FUNET), Iceland (SURIS),
             Norway (UNINETT), and Sweden (SUNET). NORDUnet supports TCP/IP,
             DECNet, and X.25.
NSN -        NASA Science Network (NSN), this network is for NASA to send and
             relay information. The protocols used are TCP/IP and there is a
             sister network called Space Physics Analysis Network (SPAM) for
             DECNet.

ONet -       Ontario Network  is a TCP/IP network that is research network.



NSFNet -     National Science Foundation Network, this network is in the
             IP/TCP family but in any case it uses UDP (User Diagram
             Protocol) and not TCP. NSFnet is the network for the US
             scientific and engineering research community. Listed below are
             all the NSFNet Sub-networks.


       BARRNet -     Bay Area Regional Research Network is a MAN in the San
                     Francisco area. This network uses TCP/IP. When on this
                     network  be sure and stop into LBL and say hi to Cliff
                     Stool! Welp, I do not think there is a bigger fool!
                     (yeah I read his book too, i did not stop hacking for a
                     weeks after reading it).

       CERFnet -     California Education and Research Federation Network is
                     a research (welp, there is a lot of research going to in
                     the Internet, huh ?) based network supporting Southern
                     Californian Universities communication services. This
                     network uses TCP/IP.

       CICNet -      Committee on Institutional Cooperation. This network
                     services the BIG 10, and University of Chicago. This
                     network uses

       JvNCnet -     John von Neumann National Supercomputer Center. This
                     network uses  TCP/IP.

       Merit -       Mert is a network connects Michigan's academic and
                     research computers. This network supports TCP/IP, X.25
                     and Ethernet for LANs.

       MIDnet -      MIDnet connects 18 universities and research centers in
                     the midwest US. The support protocols are TELNET, FTP
                     and SMTP.

       MRNet -       Minnesota Regional Network, this network services
                     Minnesota. The network protocols are TCP/IP.

       NEARnet -     New England Academic and Research Network, connects
                     various research/educational institutions. You
                     can get more information about this net by mailing
                     'nearnet-staff@bbn.com'. That is if you have address
                     like I do.

       NCSAnet -     National Center for Supercomputing Applications
                     (hell, there is a network for this ? I can think of
                     a lot of application for it a Cray, Kracking K0dez
                     maybe?) supports the whole IP family (TCP, UDP, ICMP,
                     etc).

       NWNet -       North West Network provides service to the Northwestern
                     US, and Alaska. This network supports IP and DECnet.

       NYSERNet -    New York Service Network is a autonomous nonprofit
                     network. This network supports the TCP/IP.

       OARnet -      Ohio Academic Resources Network gives access to Ohio
                     Supercomputer Center.  This network supports TCP/IP.

       PREPnet -     Pennsylvania Research and Economic Partnership is a
                     network run, operated and managed by Bell of
                     Pennsylvania. It supports TCP/IP.

       PSCNET -      Pittsburgh Supercomputer Center serving Pennsylvania,
                     Maryland, and Ohio. It supports TCP/IP, and DECnet.

       SDSCnet -     San Diego Super Computer Center is a network whose
                     goal is to support research in the field of science.
                     The Internet address is 'y1.ucsc.edu' or call Bob
                     at 619/534+5o6o and ask for a account on his Cray. I
                     am sure he will be happy to help you out.

       Sesquinet -   Sesquinet is a network based in Texas, TCP/IP are the
                     primary protocols.

       SURAnet -     Southeastern Universities Research Association Network
                     is a network that connects southern institutions. It is
                     more of a south eastern connection, than a southern
                     connection.

       THEnet -      Texas Higher Education Network is a network that is run
                     by Texas A&M University. This network connects to host
                     Mexico.

       USAN/NCAR -   University SAtellite Network (USAN)/National Center
                     for Atmospheric Research is a network for the for
                     a information exchange.

       Westnet -     Westnet connects the western part of the US, not
                     including California. The network is supported by
                     Colorado State University.

USENET -     USENET is the network news (the message base for the Internet).
             This message base is the largest i have ever seen, with well
             over 400 different topics, connecting 17 different countries.
             I just read the security, unix bugs, and telco talk posts with
             each of those subs having 100++ posts a day, i send a few hours
             reading. There is just too much!!


12  Internet Protocols
~~~~~~~~~~~~~~~~~~~~~~
     TCP/IP is a general term, this means everything related to the whole
family of Internet protocols. The protocols in this family are IP, TCP, UDP,
ICMP, ROSE, ACSE, CMIP, ISO, ARP and Ethernet for LANs. I will not go into
the too in depth, as to not take up ten-thousand pages, and not to bore you,
if you want more information, get the RFCs. RFCs authors (yeah authors, some
RFC are books!!) are stuck up Ph.d.s in Computer Science, hell I am just some
dumb Cyberpunk.
      TCP/IP protocol is a "layered" set of protocols.  In this diagram taken
from RFC 1180 you will see how the protocol is layered when connection is
made.

Figure is of a Basic TCP/IP Network Nodes

         -----------------------------------
         |      Network    Application     |
         |                                 |
         | ... \  |  /  ..  \  |  /    ... |
         |     -------      -------        |
         |     | TCP |      | UDP |        |
         |     -------      -------        |
         |           \       /             |          % Key %
         |  -------   ---------            |          ~~~~~~~
         |  | ARP |   |  IP   |            |   UDP  User Diagram Protocol
         |  -------   ------*--            |   TCP  Transfer Control Protocol
         |     \            |              |   IP   Internet Protocol
         |      \           |              |   ENET Ethernet
         |       -------------             |   ARP  Address Resolution
         |       |    ENET   |             |                  Protocol
         |       -------@-----             |   O    Transceiver
         |              |                  |   @    Ethernet Address
         -------------- | ------------------   *    IP address
                        |
========================O=================================================
      ^
      |
  Ethernet Cable

TCP/IP: If connection is made is between the IP module and the TCP module
        the packets are called a TCP datagram. TCP is responsible for making
        sure that the commands get through the other end. It keeps track of
        what is sent, and retransmits anything that does not go through. The
        IP provides the basic service of getting TCP datagram from place to
        place. It may seem like the TCP is doing all the work, this is true
        in small networks, but when connection is made to a remote host on
        the Internet (passing through several networks) this is a complex
        job. Say I am connected from a server at UCSD, and I am connection
        through to LSU (SURAnet) the data grams have to pass through a NSFnet
        backbone. The IP has to keep track of all the data when the switch is
        made at the NSFnet backbone from the TCP to the UDP. The only NSFnet
        backbone that connects LSU is University of Maryland. U. of Maryland
        has different circuit sets, thus having to pass through them. The
        cable (trunk)/circuit types are the T1 (a basic 24-channel 1.544 Md/s
        pulse code modulation used in the US) to a 56 Kbps. Keeping track of
        all the data from the switch from T1 to 56Kbs and TCP to UDP is not
        all it has to deal with. Datagrams on their way to the NSFnet
        backbone (U. of Maryland) may take many different paths from the UCSD
        server.
            All the TCP dose is break up the data into datagrams (manageable
        chunks), and keeps track of the datagrams. The TCP keeps track of the
        datagrams by placing a header at the front of each datagram. The
        header contains 160 (20 octets) pieces of information about
        the datagram. Some of the information in this is the sending FQDN to
        the receiving FQDN (more over the port address, but Fully Qualified
        Domain Name is a much better term). The datagrams are numbers in
        octets (a group of eight binary digits, say there are 500 octets of
        data, the numbering of the datagrams would be 0, next datagram 500,
        next datagram 1000, 1500 etc.

UDP/IP: UDP is one of the two main protocols to count of the IP. In other
        words the UDP works the same as TCP, it places a header on the data
        you send, and passes it over to the IP for transportation through out
        the internet. The difference is in it offers service to the user's
        network application, thus it dose not maintain a end-to-end
        connection, it just pushes the datagrams out!

ICMP:  ICMP is used for relaying error messages, such as you may try to
       connect to a system and get a message back saying "Host unreachable",
       this is ICMP in action. This protocol is universal within the
       Internet, because if it's nature. This protocol dose not use port
       numbers in it's headers, since it talks to the network software it
       self.

Ethernet:  Most of the networks use Ethernet. Ethernet is just a party line.
       When packets are sent out on the Ethernet, every host on the Ethernet
       sees them. To make sure the packets get to the right place the
       Ethernet designers wanted to make sure that each address is different.
       For this reason 48 bits are allocated for the Ethernet address, and a
       built in Ethernet address on the Ethernet controller.
            The Ethernet packets have a 14-octet header, this includes
       address to and from. The Ethernet is not too secure, it is possible to
       have the packets go to two places, thus someone can see just what you
       are doing. You need to take note that the Ethernet is not connected to
       the internet, in other words a host on the Ethernet and on the
       Internet has to have both a Ethernet connection and a Internet server.

ARP    ARP translates IP address to Ethernet address. A conversion table is
       used (the table is called ARP Table) to convert the addresses. Thus
       you would never even know if you were connected to the Ethernet
       because you would be connecting to the IP address.

    This is a real ruff description of  a few Internet protocols, but if you
would like to know more information you can access it via anonymous ftp from
various hosts. Here is a list of RFC that are on the topic of protocols.


      |~~~~~~~~~~~~~~~|~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|
      |     RFC:      |       Description:                     |
      |               |                                        |
      |~~~~~~~~~~~~~~~|~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|
      |   rfc1011     |  Official Protocols of the Internet    |
      |   rfc1009     |  NSFnet gateway specifications         |
      |   rfc1001/2   |  netBIOS: networking for PC's          |
      |   rfc894      |  IP on Ethernet                        |
      |   rfc854/5    |  telnet - protocols for remote logins  |
      |   rfc793      |  TCP                                   |
      |   rfc792      |  ICMP                                  |
      |   rfc791      |  IP                                    |
      |   rfc768      |  UDP                                   |
      |               |                                        |
      ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

13  Hostname and Address
~~~~~~~~~~~~~~~~~~~~~~~~

  This is for those of who like to know what they are doing, and when it
comes to address, you will know what you are looking at.


   Hostnames:

   Internet address are long and hard to remember such as 128.128.57.83. If
you had to remember all the hosts you are on you would need a really good
memory which most people (like me) do not have. So Being humans (thus lazy)
we came up with host names.
        All hosts registered on the Internet must have names that reflect
them domains under which they are registered. Such names are called Fully
Qualified Domain Names (FQDNs). Ok, lets take apart a name, and see such
domains.


 lilac.berkeley.edu
   ^      ^      ^
   |      |      |
   |      |      |____  ``edu'' shows that this host is sponsored by a
   |      |               educational related organization. This is a
   |      |               top-level domain.
   |      |
   |      |___________   ``berkeley'' is the second-level domain, this
   |                       shows that it is an organization within UC
   |                       Berkeley.
   |
   |__________________   ``lilac'' is the third-level domain, this indicates
                           the local host name is 'lilac'.

   Here is a list of top-level domain you will run into.

      |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|
      |            Common Top-Level Domains                 |
      |                                                     |
      |   COM  -  commercial enterprise                     |
      |   EDU  -  educational institutions                  |
      |   GOV  -  nonmilitary government agencies           |
      |   MIL  -  military (non-classified)                 |
      |   NET  -  networking entities                       |
      |   ORG  -  nonprofit intuitions                      |
      |                                                     |
      ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

      Addressing:

      A network address is that numeric address of a host, gateway or TAC.
The address was though of with us in mind, meaning it is easy to scan
(war dial, wonder etc..). The address are maid up of four decimals numbered
slots, which are separated by the well know dot called a period. The think I
will place at the end of this sentence. See it, it is four word over from the
word four. Now that we have that down <Grin>, we can move on. There are three
classes that are used most, these are Class A, Class B, and Class C. I know
this has nothing to do with you, but I feel you should know what they are...


   Class A  -  from '0'    to  '127'
   Class B  -  from '128'  to  '191'
   Class C  -  from '192'  to  '223'


Class A  -  Is for MILNET net hosts. The first part of the address has the
            network number. The second is for the their physical PSN port
            number, and the third is for the logical port number, since it is
            on MILNET it is a MILNET host. The fourth part is for which PSN
            is on. 29.34.0.9. '29' is the network it is on. '34'  means it is
            on port '34'. '9' is the PSN number.

Class B  -  This is for the Internet hosts, the first two "clumps" are for
            the network portion. The second two are for the local port.

             128.28.82.1
               \_/   \_/
                |     |_____ Local portion of the address
                |
                |___________ Potation address.

Class C  -  The first three "clumps" is the network portion. And the last one
            is the local port.

            193.43.91.1
              ^  ^  ^ ^
               \_|_/  |_____ Local Portation Address
                 |
                 |__________ Network Portation Address



14  Tips and Hints
~~~~~~~~~~~~~~~~~~

    When on a stolen account these are basic thing to do and not to do.

       -  Do not logon too late at night. All the manager has to
          do is see when you logoned by typing "login". If it
          sees 3 am to 5 am he is going to know that you were
          in the system. I know, I love spending all night on a
          account, but the best times are in the middle of the day
          when the normal (the owner) would use the account. (NOTE
          this is what they look for !)
      -   Do not leave files that were not there on *ANY*
          directory, checks are sometimes made. This is on a
          system security check list, which is normally done from
          time to time.
      -   When hacking, do not try to hack a account more than
          three times. It does show up on a logon file (when more
          than three try are made on the same account !), and it
          will also not let you logon on the account even if you
          do get it right (NOTE this is not on all UNIX systems).
      -   Do not type in your handle ! you real name etc ..
      -   Encrypt all the mail you send.
      -   Leave VMS alone, VMS and TCP/IP do not mix well. It is
          not worth your time. VMS is better for a X.25 network.
      -   DO send The Gatsby all the accounts you will get and
          have.

         @#$$%@#$%@#$%@#$%@#$%@#$%@#$%@#$%@#$%@#$%@#$%@#%@#$@#$%
         #                                                     @
         $      I would like to take this time to thank        #
         %     Doctor Dissector for getting me on in the       $
         @      The Internet in the first place, and           %
         #      for helping me correct the errors in           @
         $               the first release.                    #
         %                                                     $
         @               The Gatsby    1991                    %
         #                                                     @
         @#$%@#$%@#$%@#$%@#$%@#$%@#$%@#$%@#$%@#$%@#$%@#$%@#$%@#$

                   This has been a AXiS Production!


                              |\ /|
                              (6_9)
                               'U`
                                .
=/eof                           .






          