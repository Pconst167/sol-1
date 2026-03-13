Network Working Group                                          G. Malkin
Request for Comments: 1177                            FTP Software, Inc.
FYI: 4                                                         A. Marine
                                                                     SRI
                                                             J. Reynolds
                                                                     ISI
                                                             August 1990


                      FYI on Questions and Answers
        Answers to Commonly asked "New Internet User" Questions

Status of this Memo

   This FYI RFC is one of three FYI's called, "Questions and Answers"
   (Q/A), produced by the User Services Working Group (USWG) of the
   Internet Engineering Task Force (IETF).  The goal is to document the
   most commonly asked questions and answers in the Internet.

   This memo provides information for the Internet community.  It does
   not specify any standard.  Distribution of this memo is unlimited.

Table of Contents

   1. Introduction....................................................   1
   2. Acknowledgements................................................   2
   3. Questions About the Internet....................................   2
   4. Questions About TCP/IP..........................................   3
   5. Questions About Internet Documentation..........................   4
   6. Questions about Internet Organizations and Contacts.............   6
   7. Questions About Services........................................   9
   8. Mailing Lists...................................................  11
   9. References......................................................  11
   10. Suggested Reading..............................................  12
   11. Condensed Glossary.............................................  12
   12. Security Considerations........................................  23
   13. Authors' Addresses.............................................  24

1. Introduction

   New users joining the Internet community for the first time have had
   the same questions as did everyone else who has ever joined.  Our
   quest is to provide the Internet community with up to date, basic
   Internet knowledge and experience, while moving the redundancies away
   from the electronic mailing lists so that the lists' subscribers do
   not have to read the same queries and answers over and over again.

   Future updates of this memo will be produced as USWG members become



User Services Working Group                                     [Page 1]


RFC 1177            FYI Q/A - for New Internet Users         August 1990


   aware of additional questions that should be included, and of
   deficiencies or inaccuracies that should be amended in this document.
   Additional FYI Q/A's will be published which will deal with
   intermediate and advanced Q/A topics.

   The Q/A mailing lists are maintained by Gary Malkin at FTP.COM.  They
   are used by a subgroup of the USWG to discuss the Q/A FYIs.  They
   include:

   quail@ftp.com           This is a discussion mailing list.  Its
                           primary use is for pre-release (to the
                           USWG) review of the Q/A FYIs.

   quail-request@ftp.com   This is how you join the quail mailing list.

   quail-box@ftp.com       This is where the questions and answers
                           will be forwarded-and-stored.  It is
                           not necessary to be on the quail mailing
                           list to forward to the quail-box.

2. Acknowledgements

   The following people deserve thanks for their help and contributions
   to the FYI Q/As: Berlin Moore (PREPNet), Craig Partridge (BBN),
   Jon Postel (ISI), Karen Roubicek (BBNST), James Van Bokkelen (FTP
   Software, Inc.), John Wobus (Syracuse University), and David Paul
   Zimmerman (Rutgers).

3. Questions About the Internet

   I just got on the Internet.  What can I do now?

      You now have access to all the resources you are authorized to use
      on your own Internet host, on any other Internet host on which you
      have an account, and on any other Internet host that offers
      publicly accessible information.  The Internet gives you the
      ability to move information between these hosts via file
      transfers.  Once you are logged into one host, you can use the
      Internet to open a connection to another, log in, and use its
      services interactively.  In addition, you can send electronic mail
      to users at any Internet site and to users on many non-Internet
      sites that are accessible via electronic mail.

      There are various other services you can use.  For example, some
      hosts provide access to specialized databases or to archives of
      information.  The Internet Resource Guide provides information
      regarding some of these sites.  The Internet Resource Guide lists
      facilities on the Internet that are available to users.  Such



User Services Working Group                                     [Page 2]


RFC 1177            FYI Q/A - for New Internet Users         August 1990


      facilities include supercomputer centers, library catalogs and
      specialized data collections.  The guide is published by the NSF
      Network Service Center (NNSC) and is continuously being updated.
      The Resource Guide is distributed free via e-mail (send a note to
      resource-guide-request@nnsc.nsf.net to join the e-mail
      distribution) and via anonymous FTP (in nnsc.nsf.net:resource-
      guide/*).  Hardcopy is available at a nominal fee (to cover
      reproduction costs) from the NNSC.  Call the NNSC at 617-873-3400
      for more information.

   How do I find out if a site has a computer on the Internet?

      Three good sources to consult are "!%@:: A Directory of Electronic
      Mail Addressing and Networks" by Donnalyn Frey and Rick Adams;
      "The User's Directory to Computer Networks", by Tracy LaQuey; and
      "The Matrix: Computer Networks and Conferencing Systems
      Worldwide", by John Quarterman.

      In addition, it is possible to find some information about
      Internet sites in the WHOIS database maintained at the DDN NIC at
      SRI International.  The DDN NIC provides an information retrieval
      interface to the database that is also called WHOIS.  To use this
      interface, Telnet to NIC.DDN.MIL and type "whois" (carriage
      return).  No login is necessary.  Type "help" at the whois prompt
      for more information on using the facility.  WHOIS will show many
      sites, but may not show every site registered with the DDN NIC
      (simply for reasons having to do with how the program is set up to
      search the database).

4. Questions About TCP/IP

   What is TCP/IP?

      TCP/IP (Transmission Control Protocol/Internet Protocol) [4,5,6]
      is the common name for a family of data-communications protocols
      used to tie computers and data-communications equipment into
      computer networks.  TCP/IP originated for use on a network called
      ARPANET, but it is currently used on a large international network
      of universities, other research institutions, government
      facilities, and some corporations called the Internet.  TCP/IP is
      also sometimes used for other networks, particularly local area
      networks that tie together numerous different kinds of computers
      or tie together engineering workstations.

   What are the other standard protocols in the TCP/IP family?

      Other than TCP and IP, the three main protocols in the TCP/IP
      suite are the Simple Mail Transfer Protocol (SMTP), the File



User Services Working Group                                     [Page 3]


RFC 1177            FYI Q/A - for New Internet Users         August 1990


      Transfer Protocol (FTP), and the Telnet Protocol.  There are many
      other protocols in use on the Internet.  The Internet Activities
      Board (IAB) regularly publishes an RFC [2] that describes the
      state of standardization of the various Internet protocols.  This
      document is the best guide to the current status of Internet
      protocols and their recommended usage.

5. Questions About Internet Documentation

   What is an RFC?

      The Request for Comments documents (RFCs) are working notes of the
      Internet research and development community.  A document in this
      series may be on essentially any topic related to computer
      communication, and may be anything from a meeting report to the
      specification of a standard.  Submissions for Requests for
      Comments may be sent to the RFC Editor, Jon Postel
      (POSTEL@ISI.EDU).

      Most RFCs are the descriptions of network protocols or services,
      often giving detailed procedures and formats providing the
      information necessary for creating implementations.  Other RFCs
      report on the results of policy studies or summarize the work of
      technical committees or workshops.

      While RFCs are not refereed publications, they do receive
      technical review from either the task forces, individual technical
      experts, or the RFC Editor, as appropriate.  Currently, most
      standards are published as RFCs, but not all RFCs specify
      standards.

      Anyone can submit a document for publication as an RFC.
      Submissions must be made via electronic mail to the RFC Editor.
      RFCs are distributed online by being stored as public access
      files, and a short message is sent to the distribution list
      indicating the availability of the memo.  Requests to be added to
      this distribution list should be sent to RFC-REQUEST@NIC.DDN.MIL.

      The online files are copied by interested people and printed or
      displayed at their sites on their equipment.  (An RFC may also be
      returned via electronic mail in response to an electronic mail
      query.) This means that the format of the online files must meet
      the constraints of a wide variety of printing and display
      equipment.

      Once a document is assigned an RFC number and published, that RFC
      is never revised or re-issued with the same number.  There is
      never a question of having the most recent version of a particular



User Services Working Group                                     [Page 4]


RFC 1177            FYI Q/A - for New Internet Users         August 1990


      RFC.  However, a protocol (such as File Transfer Protocol (FTP))
      may be improved and re-documented many times in several different
      RFCs.  It is important to verify that you have the most recent RFC
      on a particular protocol.  The "IAB Official Protocol Standards"
      [2] memo is the reference for determining the correct RFC to refer
      to for the current specification of each protocol.

   How do I obtain RFCs?

      RFCs can be obtained via FTP from NIC.DDN.MIL, with the pathname
      RFC:RFCnnnn.TXT or RFC:RFCnnnn.PS (where "nnnn" refers to the
      number of the RFC).  Login with FTP, username "anonymous" and
      password "guest".  The NIC also provides an automatic mail service
      for those sites which cannot use FTP.  Address the request to
      SERVICE@NIC.DDN.MIL and in the subject field of the message
      indicate the RFC number, as in "Subject: RFC nnnn" (or "Subject:
      RFC nnnn.PS" for PostScript RFCs).

      RFCs can also be obtained via FTP from NIS.NSF.NET.  Using FTP,
      login with username "anonymous" and password "guest"; then connect
      to the RFC directory ("cd RFC").  The file name is of the form
      RFCnnnn.TXT-1 (where "nnnn" refers to the number of the RFC).  The
      NIS also provides an automatic mail service for those sites which
      cannot use FTP.  Address the request to NIS-INFO@NIS.NSF.NET and
      leave the subject field of the message blank.  The first line of
      the text of the message must be "SEND RFCnnnn.TXT-1", where nnnn
      is replaced by the RFC number.

      Requests for special distribution should be addressed to either
      the author of the RFC in question, or to NIC@NIC.DDN.MIL.  Unless
      specifically noted otherwise on the RFC itself, all RFCs are for
      unlimited distribution.

   Which RFCs are Standards?

      See "IAB Official Protocol Standards" (currently, RFC 1140) [2].

   How do I obtain OSI Standards documents from the Internet?

      OSI Standards documents are NOT available from the Internet via
      anonymous FTP due to copyright restrictions.  These are available
      from:

         Omnicom Information Service
         501 Church Street NE
         Suite 304
         Vienna, VA  22180  USA
         Telephone: (800) 666-4266 or (703) 281-1135 Fax: (703) 281-1505



User Services Working Group                                     [Page 5]


RFC 1177            FYI Q/A - for New Internet Users         August 1990


6. Questions about Internet Organizations and Contacts

   What is the IAB?

      The Internet Activities Board (IAB) is the coordinating committee
      for Internet design, engineering and management [7].  IAB members
      are deeply committed to making the Internet function effectively
      and evolve to meet a large scale, high speed future.  The chairman
      serves a term of two years and is elected by the members of the
      IAB.  The current Chair of the IAB is Vint Cerf.  The IAB focuses
      on the TCP/IP protocol suite, and extensions to the Internet
      system to support multiple protocol suites.

      The IAB performs the following functions:

         1)   Sets Internet Standards,

         2)   Manages the RFC publication process,

         3)   Reviews the operation of the IETF and IRTF,

         4)   Performs strategic planning for the Internet, identifying
              long-range problems and opportunities,

         5)   Acts as an international technical policy liaison and
              representative for the Internet community, and

         6)   Resolves technical issues which cannot be treated within
              the IETF or IRTF frameworks.

      The IAB has two principal subsidiary task forces:

         1)  Internet Engineering Task Force (IETF)

         2)  Internet Research Task Force (IRTF)

      Each of these Task Forces is led by a chairman and guided by a
      Steering Group which reports to the IAB through its chairman.  For
      the most part, a collection of Research or Working Groups carries
      out the work program of each Task Force.

      All decisions of the IAB are made public.  The principal vehicle
      by which IAB decisions are propagated to the parties interested in
      the Internet and its TCP/IP protocol suite is the Request for
      Comments (RFC) note series and the Internet Monthly Report.






User Services Working Group                                     [Page 6]


RFC 1177            FYI Q/A - for New Internet Users         August 1990


   What is the IANA?

      The task of coordinating the use of the parameters of protocols is
      delegated by the Internet Activities Board (IAB) to the Internet
      Assigned Numbers Authority (IANA).  These protocol parameters are
      op-codes, type fields, terminal types, system names, object
      identifiers, and so on.  The "Assigned Numbers" Request for
      Comments (RFC) [1] documents the currently assigned values from
      several series of numbers used in network protocol
      implementations.

      Current types of assignments listed in Assigned Numbers and
      maintained by the IANA are:

         Address Resolution Protocol Parameters
         ARPANET and MILNET X.25 Address Mappings
         ARPANET and MILNET Logical Addresses
         ARPANET and MILNET Link Numbers
         BOOTP Parameters and BOOTP Extension Codes
         Domain System Parameters
         IANA Ethernet Address Blocks
         Ethernet Numbers of Interest
         IEEE 802 Numbers of Interest
         Internet Protocol Numbers
         Internet Version Numbers
         IP Time to Live Parameter
         IP TOS Parameters
         Machine Names
         Mail Encryption Types
         Multicast Addresses
         Network Management Parameters
         PRONET 80 Type Numbers
         Port Assignments
         Protocol and Service Names
         Protocol/Type Field Assignments
         Public Data Network Numbers
         Reverse Address Resolution Protocol Operation Codes
         Telnet Options
         Terminal Type Names
         Unix Ports
         X.25 Type Numbers

      For more information on number assignments, contact IANA@ISI.EDU.

   What is "The NIC"?

      "The NIC" is the Defense Data Network, Network Information Center
      (DDN NIC) at SRI International, which is a network information



User Services Working Group                                     [Page 7]


RFC 1177            FYI Q/A - for New Internet Users         August 1990


      center which holds a primary repository for RFCs and Internet
      drafts.  The host name is NIC.DDN.MIL.  Shadow copies of the RFCs
      and the Internet Drafts are maintained by the NSFnet on
      NNSC.NSF.NET and on MERIT.EDU.

      The DDN NIC also provides various user assistance services for DDN
      users; contact NIC@NIC.DDN.MIL or call 1-800-235-3155 for more
      information.  In addition, the DDN NIC is the Internet
      registration authority for the root domain and several top and
      second level domains; maintains the official DoD Internet Host
      Table; is the site of the Internet Registry (IR); and maintains
      the whois database of network users, hosts, domains, networks, and
      Points of Contact.

   What is the IR?

      The Internet Registry (IR) is the organization that is responsible
      for assigning identifiers, such as IP network numbers and
      autonomous system numbers, to networks.  The IR also gathers and
      registers such assigned information.  The IR may, in the future,
      allocate the authority to assign network identifiers to other
      organizations; however, it will continue to gather data regarding
      such assignments.  At present, the DDN NIC at SRI International
      serves as the IR.

   What is the IETF?

      The Internet has grown to encompass a large number of widely
      geographically dispersed networks in academic and research
      communities.  It now provides an infrastructure for a broad
      community with various interests.  Moreover, the family of
      Internet protocols and system components has moved from
      experimental to commercial development.  To help coordinate the
      operation, management and evolution of the Internet, the IAB
      established the Internet Engineering Task Force (IETF).

      The IETF is chaired by Phill Gross and managed by its Internet
      Engineering Steering Group (IESG).  The IETF is a large open
      community of network designers, operators, vendors, and
      researchers concerned with the Internet and the Internet protocol
      suite.  It is organized around a set of eight technical areas,
      each managed by a technical area director.  In addition to the
      IETF Chairman, the area directors make up the IESG membership.

      The IAB has delegated to the IESG the general responsibility for
      making the Internet work and for the resolution of all short- and
      mid-range protocol and architectural issues required to make the
      Internet function effectively.



User Services Working Group                                     [Page 8]


RFC 1177            FYI Q/A - for New Internet Users         August 1990


   What is the IRTF?

      To promote research in networking and the development of new
      technology, the IAB established the Internet Research Task Force
      (IRTF).

      In the area of network protocols, the distinction between research
      and engineering is not always clear, so there will sometimes be
      overlap between activities of the IETF and the IRTF.  There is, in
      fact, considerable overlap in membership between the two groups.
      This overlap is regarded as vital for cross-fertilization and
      technology transfer.

      The IRTF is a community of network researchers, generally with an
      Internet focus.  The work of the IRTF is governed by its Internet
      Research Steering Group (IRSG).  The chairman of the IRTF and IRSG
      is David Clark.

7. Questions About Services

   How do I find someone's electronic mail address?

      There are a number of directories on the Internet; however, all of
      them are far from complete.  The two largest directories are the
      WHOIS database at the DDN NIC and the PSInet White Pages.
      Generally, it is still necessary to ask the person for his or her
      email address.

   How do I use the WHOIS program at the DDN NIC?

      To use the WHOIS program to search the WHOIS database at the DDN
      NIC, telnet to the NIC host, NIC.DDN.MIL.  There is no need to
      login.  Type "whois" to call up the information retrieval program.
      Next, type the name of the person, host, domain, network, or
      mailbox for which you need information.  If you are only typing
      part of the name, end your search string with a period.  Type
      "help" for a more in-depth explanation of what you can search for
      and how you can search.  If you have trouble, send a message to
      NIC@NIC.DDN.MIL or call 1-800-235-3155.  Bug reports can be sent
      to BUG-WHOIS@NIC.DDN.MIL and suggestions for improvements to the
      program can be sent to SUGGESTIONS@NIC.DDN.MIL.

   How do I become registered in the DDN NIC's WHOIS database?

      If you would like to be listed in the WHOIS database, you must
      have an electronic mailbox accessible from the Internet.  First
      obtain the file NETINFO:USER-TEMPLATE.TXT.  You can either
      retrieve this file via anonymous FTP from NIC.DDN.MIL or get it



User Services Working Group                                     [Page 9]


RFC 1177            FYI Q/A - for New Internet Users         August 1990


      through electronic mail.  To obtain the file via electronic mail,
      send a message to SERVICE@NIC.DDN.MIL and put the file name in the
      subject line of the message; that is, "Subject: NETINFO USER-
      TEMPLATE.TXT".  The file will be returned to you overnight.

      Fill out the name and address information requested in the file
      and return it to REGISTRAR@NIC.DDN.MIL.  Your application will be
      processed and you will be added to the database.  Unless you are
      an official Point of Contact for a network entity registered at
      the DDN NIC, the DDN NIC will not regularly poll you for updates,
      so you should remember to send corrections to your information as
      your contact data changes.

   How do I use the White Pages at PSI?

      Performance Systems International, Inc. (PSI), sponsors a White
      Pages Pilot Project that collects personnel information from
      member organizations into a database and provides online access to
      that data.  This effort is based on the OSI X.500 Directory
      standard.

      To access the data, telnet to WP.PSI.COM and login as "fred" (no
      password is necessary).  You may now look up information on
      participating organizations.  The program provides help on usage.
      For example, typing "help" will show you a list of commands,
      "manual" will give detailed documentation, and "whois" will
      provide information regarding how to find references to people.
      For a list of the organizations that are participating in the
      pilot project by providing information regarding their members,
      type "whois -org *".

      For more information, send a message to INFO@PSI.COM.

   What is Usenet?  What is Netnews?

      Usenet and Netnews are common names of a distributed computer
      bulletin board system that some computers on the Internet
      participate in.  It is not strictly an Internet service: many
      computers not on the Internet also participate.

   How do I get on Usenet?  How do I get Netnews on my computer?

      To get on Usenet, you must acquire the software, which is
      available for some computers at no cost from some anonymous ftp
      sites across the Internet, and you must find an existing Usenet
      site that is willing to support a connection to your computer.





User Services Working Group                                    [Page 10]


RFC 1177            FYI Q/A - for New Internet Users         August 1990


   What is anonymous FTP?

      Anonymous FTP is a conventional way of allowing you to sign on to
      a computer on the Internet and copy specified public files from it
      [3].  Some sites offer anonymous FTP to distribute software and
      various kinds of information.  You use it like any FTP, but the
      username is "anonymous" and the password is "guest".

8. Mailing Lists

   What are some good mailing lists or news groups?

      The TCP-IP, IETF, and RFC Distribution lists are primary lists for
      new Internet users who desire further information about current
      and emerging developments in the Internet.  The first two lists
      are unmoderated discussion lists, and the latter is an
      announcement service used by the RFC Editor.

   How do I subscribe to the TCP-IP mailing list?

      To be added to the TCP-IP mailing list, send a message to:

            TCP-IP-REQUEST@NIC.DDN.MIL

   How do I subscribe to the IETF mailing list?

      To be added to the IETF mailing list, send a message to:

            IETF-REQUEST@ISI.EDU

   How do I subscribe to the RFC Distribution list?

      To be added to the RFC Distribution list, send a message to:

            RFC-REQUEST@NIC.DDN.MIL

9. References

   [1] Reynolds, J., and J. Postel, "Assigned Numbers", RFC 1060,
       USC/Information Sciences Institute, March 1990.

   [2] Postel, J., Editor, "IAB Official Protocol Standards", RFC 1140,
       Internet Activities Board, May 1990.

   [3] Postel, J., and J. Reynolds, "File Transfer Protocol (FTP), RFC
       959, USC/Information Sciences Institute, October 1985.

   [4] Postel, J., "Internet Protocol - DARPA Internet Program Protocol



User Services Working Group                                    [Page 11]


RFC 1177            FYI Q/A - for New Internet Users         August 1990


       Specification", RFC 791, DARPA, September 1981.

   [5] Postel, J., "Transmission Control Protocol - DARPA Internet
       Program Protocol Specification", RFC 793, DARPA, September 1981.

   [6] Leiner, B., R. Cole, J. Postel, and D. Mills, "The DARPA Internet
       Protocol Suite", IEEE INFOCOM85, Washington D.C., March 1985.
       Also in IEEE Communications Magazine, March 1985.  Also as
       ISI/RS-85-153.

   [7] Cerf, V., "The Internet Activities Board" RFC 1160, CNRI, May
       1990.

10. Suggested Reading

   For further information about the Internet and its protocols in
   general, you may choose to obtain copies of the following works:

      Bowers, K., T. LaQuey, J. Reynolds, K. Roubicek, M. Stahl, and A.
      Yuan, "Where to Start - A Bibliography of General Internetworking
      Information", RFC 1175, FYI 3, CNRI, U Texas, ISI, BBN, SRI,
      Mitre, August 1990.

      Comer, D., "Internetworking with TCP/IP: Principles, Protocols,
      and Architecture", Prentice Hall, New Jersey, 1989.

      Krol, E., "The Hitchhikers Guide to the Internet", RFC 1118,
      University of Illinois Urbana, September 1989.

11. Condensed Glossary

   As with any profession, computers have a particular terminology all
   their own.  Below is a condensed glossary to assist in making some
   sense of the Internet world.

   address There are two separate uses of this term in internet
           networking: "electronic mail address" and "internet
           address".   An electronic mail address is the string
           of characters that you must give an electronic mail
           program to direct a message to a particular person.
           See "internet address" for its definition.

   AI      Artificial Intelligence
           The branch of computer science which deals with the
           simulation of human intelligence by computer systems.

   AIX     Advanced Interactive Executive
           IBM's version of Unix.



User Services Working Group                                    [Page 12]


RFC 1177            FYI Q/A - for New Internet Users         August 1990


   ANSI    American National Standards Institute
           A group that defines U.S. standards for the information
           processing industry.  ANSI participates in defining
           network protocol standards.

   ARP     Address Resolution Protocol
           An Internet protocol which runs on Ethernets and
           Token Rings which maps internet addresses to MAC addresses.

   ARPA    Advanced Research Projects Agency
           The former name of what is now called DARPA.

   ARPANET Advanced Research Projects Agency Network
           A pioneering long haul network funded by ARPA.  It
           served as the basis for early networking research as
           well as a central backbone during the development of
           the Internet.  The ARPANET consisted of individual
           packet  switching computers interconnected by leased lines.

   ASCII   American Standard Code for Information Interchange


   B       Byte
           One character of information, usually eight bits wide.

   b       bit - binary digit
           The smallest amount of information which may be stored
           in a computer.

   BBN     Bolt, Beranek, and Newman, Inc.
           The Cambridge, MA company responsible for development,
           operation and monitoring of the ARPANET, and later,
           the Internet core gateway system, the CSNET Coordination
           and Information Center (CIC), and NSFnet Network
           Service Center (NNSC).

   BITNET  Because It's Time Network
           BITNET has about 2,500 host computers, primarily at
           universities, in many countries.  It is managed by
           EDUCOM, which provides administrative support and
           information services.  There are three
           main constituents of the network: BITNET in the United
           States and Mexico, NETNORTH in Canada, and EARN in
           Europe.  There are also AsiaNet, in Japan, and
           connections in South America.  See CREN.

   bps     bits per second
           A measure of data transmission speed.



User Services Working Group                                    [Page 13]


RFC 1177            FYI Q/A - for New Internet Users         August 1990


   BSD     Berkeley Software Distribution
           Term used when describing different versions
           of the Berkeley UNIX software, as in "4.3BSD
           UNIX".


   catenet A network in which hosts are connected to networks
           with varying characteristics, and the networks
           are interconnected by gateways (routers).  The
           Internet is an example of a catenet.

   CCITT   International Consultative Committee for
           Telegraphy and Telephony.

   core gateway
           Historically, one of a set of gateways (routers)
           operated by the Internet Network Operations Center
           at BBN.  The core gateway system forms a central part
           of Internet routing in that all groups must advertise
           paths to their networks from a core gateway.

   CREN    The Corporation for Research and Educational Networking
           BITNET and CSNET have recently merged to form CREN.

   CSNET   Computer + Science Network
           A large data communications network for institutions doing
           research in computer science.   It uses several different
           protocols including some of its own.  CSNET sites include
           universities, research laboratories, and commercial
           companies.  See CREN.


   DARPA   U.S. Department of Defense Advanced Research Projects Agency
           The government agency that funded the ARPANET and later
           started the Internet.

   datagram
           The unit transmitted between a pair of internet modules.
           The Internet Protocol provides for transmitting blocks of
           data, called datagrams, from sources to destinations.
           The Internet Protocol does not provide a reliable
           communication facility.  There are no acknowledgements
           either end-to-end or hop-by-hop.  There is no error
           control for data, only a header checksum.  There are
           no retransmissions.  There is no flow control.  See IP.

   DCA     Defense Communications Agency
           The government agency responsible for installation of



User Services Working Group                                    [Page 14]


RFC 1177            FYI Q/A - for New Internet Users         August 1990


           the Defense Data Network (DDN), including the ARPANET
           and MILNET lines and PSNs.  Currently, DCA administers
           the DDN, and supports the user assistance and network
           registration services of the DDN NIC.

   DDN     Defense Data Network
           Comprises the MILNET and several other DoD networks.

   DDN NIC The network information center at SRI International.
           It is the primary repository for RFCs and Internet drafts,
           as well as providing other services.

   DEC     Digital Equipment Corporation

   DECnet  Digital Equipment Corporation network
           A networking protocol for DEC computers and network devices.

   default route
           A routing table entry which is used to direct any data
           addressed to any network numbers not explicitly listed
           in the routing table.

   DOD     U.S. Department of Defense

   DOE     U.S. Department of Energy

   DNS     The Domain Name System is a mechanism used in
           the Internet for translating names of host computers
           into addresses.  The DNS also allows host computers
           not directly on the Internet to have registered
           names in the same style.


   EARN    European Academic Research Network
           One of three main constituents of BITNET.

   EBCDIC  Extended Binary-coded Decimal Interchange Code

   EGP     External Gateway Protocol
           A protocol which distributes routing information to
           the routers and gateways which interconnect networks.

   Ethernet
           A network standard for the hardware and data link levels.
           There are two types of Ethernet: Digital/Intel/Xerox (DIX)
           and IEEE 802.3.





User Services Working Group                                    [Page 15]


RFC 1177            FYI Q/A - for New Internet Users         August 1990


   FIPS    Federal Information Processing Standard

   FTP     File Transfer Protocol
           The Internet standard high-level protocol for
           transferring files from one computer to another.


   gateway A special-purpose dedicated computer that attaches to
           two or more networks and routes packets from one
           network to the other.  In particular, an Internet
           gateway routes IP datagrams among the networks it
           connects.  Gateways route packets to other
           gateways until they can be delivered to the final
           destination directly across one physical network.

   GB      Gigabyte
           A unit of data storage size which represents 2^30 (over
           1 billion) characters of information.

   Gb      Gigabit
           2^30 bits of information (usually used to express a
           data transfer rate; as in, 1 gigabit/second = 1Gbps).

   GNU     Gnu's Not UNIX
           A UNIX-compatible operating system developed by the
           Free Software Foundation.


   header  The portion of a packet, preceding the actual data,
           containing source and destination addresses and
           error-checking fields.

   host number
           The part of an internet address that designates which
           node on the (sub)network is being addressed.

   HP      Hewlett-Packard

   HYPERchannel
           High-speed communications link.


   I/O     Input/Output

   IAB     Internet Activities Board
           The IAB is the coordinating committee for Internet
           design, engineering and management.




User Services Working Group                                    [Page 16]


RFC 1177            FYI Q/A - for New Internet Users         August 1990


   IBM     International Business Machines Corporation

   IEEE    Institute for Electrical and Electronics Engineers

   IETF    Internet Engineering Task Force
           The IETF is a large open community of network designers,
           operators, vendors, and researchers whose purpose is to
           coordinate the operation, management and evolution of
           the Internet, and to resolve short- and mid-range
           protocol and architectural issues.  It is a major source
           of proposed protocol standards which are submitted to the
           Internet Activities Board for final approval.  The IETF
           meets three times a year and extensive minutes of the
           plenary proceedings are issued.

   internet
           internetwork
           Any connection of two or more local or wide-area networks.

   Internet
           The global collection of interconnected regional and
           wide-area networks which use IP as the network
           layer protocol.

   internet address
           An assigned number which identifies a host in an internet.
           It has two or three parts: network number, optional subnet
           number, and host number.

   IP      Internet Protocol
           The network layer protocol for the Internet.  It the
           datagram protocol defined by RFC 791.

   IRTF    Internet Research Task Force
           The IRTF is a community of network researchers,
           generally with an Internet focus.  The work of the IRTF
           is governed by its Internet Research Steering Group (IRSG).

   ISO     International Standards Organization


   JvNC    John von Neumann National Supercomputer Center


   KB      Kilobyte
           A unit of data storage size which represents 2^10
           (1024) characters of information.




User Services Working Group                                    [Page 17]


RFC 1177            FYI Q/A - for New Internet Users         August 1990


   Kb      Kilobit
           2^10 bits of information (usually used to express a
           data transfer rate; as in, 1 kilobit/second = 1Kbps = 1Kb).

   KNET    Kangaroo Network
           Hardware/software product (Spartacus/Fibronics) that enables
           IBM mainframes to communicate over networks with the TCP/IP
           protocol suite.


   LAN     Local Area Network
           A network that takes advantage of the proximity of computers
           to offer relatively efficient, higher speed communications
           than long-haul or wide-area networks.

   LISP    List Processing Language


   MAC     Medium Access Control
           For broadcast networks, it is the method which devices use
           to determine which device has line access at any given
           time.

   Mac     Apple Macintosh computer.

   MB      Megabyte
           A unit of data storage size which represents over
           2^20 (one million) characters of information.

   Mb      Megabit
           2^20 bits of information (usually used to express a
           data transfer rate; as in, 1 megabit/second = 1Mbps).

   MILNET  Military Network
           A network used for unclassified military production
           applications.  It is part of the Internet.

   MIT     Massachusetts Institute of Technology

   MTTF    Mean Time to Failure
           The average time between hardware breakdown or loss of
           service.  This may be an empirical measurement or a
           calculation based on the MTTF of component parts.

   MTTR    Mean Time to Recovery
           The average time it takes to restore service after a
           breakdown or loss.  This is usually an empirical measurement.




User Services Working Group                                    [Page 18]


RFC 1177            FYI Q/A - for New Internet Users         August 1990


   MVS     Multiple Virtual Storage
           An IBM operating system based on OS/1.


   NASA    National Aeronautics and Space Administration

   NBS     National Bureau of Standards
           Now called NIST.

   network number
           The part of an internet address which designates the
           network to which the addressed node belongs.

   NFS     Network File System
           A network service that lets a program running on one
           computer to use data stored on a different computer on
           the same internet as if it were on its own disk.

   NIC     Network Information Center
           An organization which provides network users with
           information about services provided by the network.

   NOC     Network Operations Center
           An organization which is responsible for maintaining
           a network.

   NIST    National Institute of Standards and Technology
           Formerly NBS.

   NSF     National Science Foundation

   NSFNET  National Science Foundation Network
           A high-speed internet that spans the country, and is
           intended for research applications.  It is made up of
           the NSFnet Backbone and the NSFnet regional networks.
           It is part of the Internet.

   NSFNET Backbone
           A network connecting 13 sites across the continental United
           States.  It is the central component of NSFnet.

   NSFNET Regional
           A network connected to the NSFnet Backbone that covers a
           region of the United States.  It is to the regionals that
           local sites connect.






User Services Working Group                                    [Page 19]


RFC 1177            FYI Q/A - for New Internet Users         August 1990


   NYSERnet
           New York State Educational and Research Network
           An internet which serves NY educational and research
           institutions.   It also serves as the NSFnet regional
           network for New York State.


   OSI     Open Systems Interconnection
           A set of protocols designed to be an international standard
           method for connecting unlike computers and networks.  Europe
           has done most of the work developing OSI and will probably
           use it as soon as possible.

   OSI Reference Model
           An "outline" of OSI which defines its seven layers and
           their functions.  Sometimes used to help describe other
           networks.

   OSPFIGP Open Shortest-Path First Internet Gateway Protocol
           An experimental replacement for RIP.  It addresses some
           problems of RIP and is based upon principles that have
           been well-tested in non-internet protocols.  Often referred
           to simply as OSPF.


   packet  The unit of data sent across a packet switching network.
           The term is used loosely.  While some Internet
           literature uses it to refer specifically to data sent
           across a physical network, other literature views
           the Internet as a packet switching network
           and describes IP datagrams as packets.

   PC      Personal Computer

   PCNFS   Personal Computer Network File System

   POSIX   Portable Operating System Interface
           Operating system based on UNIX.

   protocol
           A formal description of message formats and the rules
           two computers must follow to exchange those messages.
           Protocols can describe low-level details of
           machine-to-machine interfaces (e.g., the order in
           which bits and bytes are sent across a wire)
           or high-level exchanges between allocation
           programs (e.g., the way in which two programs
           transfer a file across the Internet).



User Services Working Group                                    [Page 20]


RFC 1177            FYI Q/A - for New Internet Users         August 1990


   PSC     Pittsburgh Supercomputing Center

   PSCNET  Pittsburgh Supercomputing Center Network


   RFC     The Internet's Request for Comments documents series
           The RFCs are working notes of the Internet research and
           development community.  A document in this series may be on
           essentially any topic related to computer communication, and
           may be anything from a meeting report to the specification of
           a standard.

   RIP     Routing Interchange Protocol
           One protocol which may be used on internets simply to pass
           routing information between gateways.   It is used on may
           LANs and on some of the NSFnet regional networks.

   RJE     Remote Job Entry
           The general protocol for submitting batch jobs and
           retrieving the results.

   RLOGIN  Remote Login
           A service on internets very similar to TELNET.   RLOGIN was
           invented for use between Berkeley Unix systems on the same
           LAN at a time when TELNET programs didn't provide all the
           services users wanted.   Berkeley plans to phase it out.

   RPC     Remote Procedure Call
           An easy and popular paradigm for implementing the
           client-server model of distributed computing.


   server  A computer that shares its resources, such as printers
           and files, with other computers on the network.  An
           example of this is a Network Files System (NFS)
           Server which shares its disk space with a workstations
           that does not have a disk drive of its own.

   SESQUINET
           Sesquicentennial Network
           Texas-based regional network named for their sesquicentennial
           celebration

   SMTP    Simple Mail Transfer Protocol
           The Internet standard protocol for transferring
           electronic mail messages from one computer to another.
           SMTP specifies how two mail systems interact and the
           format of control messages they exchange to transfer mail.



User Services Working Group                                    [Page 21]


RFC 1177            FYI Q/A - for New Internet Users         August 1990


   SNA     System Network Architecture
           IBM's data communications protocol.

   subnet  A portion of a network, which may be a physically independent
           network, which shares a network address with other portions
           of the network and is distinguished by a subnet number.  A
           subnet is to a network what a network is to an internet.

   subnet number
           A part of the internet address which designates a subnet.
           It is ignored for the purposes internet routing, but is
           used for intranet routing.

   SURANET Southeastern Universities Research Association Network
           An NSFNET regional network.


   T1      A term for a digital carrier facility used to transmit a
           DS-1 formatted digital signal at 1.544 megabits per second.

   T3      A term for a digital carrier facility used to transmit a DS-3
           formatted digital signal at 44.746 megabits per second.

   TCP     Transmission Control Protocol
           A transport layer protocol for the Internet.  It is a
           connection oriented, stream protocol defined by RFC 793.

   TCP/IP  Transmission Control Protocol/Internet Protocol
           This is a common shorthand which refers to the suite
           of application and transport protocols which run over IP.
           These include FTP, Telnet, SMTP, and UDP (a transport
           layer protocol).

   Telenet A public packet-switching network operated by US Sprint.

   Telnet  The Internet standard protocol for remote terminal
           connection service.  Telnet allows a user at one site
           to interact with a remote timesharing system at
           another site as if the user's terminal was connected
           directly to the remote computer.

   Token Ring
           A type of LAN.   Examples are IEEE 802.5, ProNET-10/80 and
           FDDI.  The term "token ring" is often used to denote 802.5

   Tymnet  A public packet-switching network operated by McDonnell
           Douglas Network Systems Company.




User Services Working Group                                    [Page 22]


RFC 1177            FYI Q/A - for New Internet Users         August 1990


   UDP     User Datagram Protocol
           A transport layer protocol for the Internet.  It is a
           datagram protocol which simply adds a level of reliability
           to IP datagrams.  It is defined by RFC 768.

   ULTRIX  UNIX-based operating system for Digital Equipment Corporation
           computers.

   UNIX    An operating system developed by Bell Laboratories that
           supports multiuser and multitasking operations.

   UUCP    UNIX-to-UNIX Copy Program
           A protocol used for communication between consenting
           UNIX systems.


   VMS     Virtual Memory System
           A Digital Equipment Corporation operating system.


   WAN     Wide Area Network

   WESTNET One of the National Science Foundation funded regional
           TCP/IP networks that covers the states of Arizona,
           Colorado, New Mexico, Utah, and Wyoming.

   WHOIS   An Internet program which allows users to query a database of
           people and other Internet entities, such as domains, networks,
           and hosts, kept at the NIC.  The information for people shows
           a person's company name, address, phone number and email
           address.


   XNS     Xerox Network System
           A data communications protocol developed by Xerox.  It
           uses Ethernet to move the data between computers.

   X.25    A data communications protocol developed to describe how
           data passes into and out of public data communications
           networks.  The public networks such as Telenet and Tymnet,
           use X.25 to interface to customer computers.

12. Security Considerations

   Security issues are not discussed in this memo.






User Services Working Group                                    [Page 23]


RFC 1177            FYI Q/A - for New Internet Users         August 1990


13. Authors' Addresses

   Gary Scott Malkin
   FTP Software, Inc.
   26 Princess Street
   Wakefield, MA 01880
   Phone:  (617) 246-0900
   EMail:  gmalkin@ftp.com


   April N. Marine
   SRI International
   Network Information Systems Center
   333 Ravenswood Avenue, EJ294
   Menlo Park, CA 94025
   Phone:  (415) 859-5318
   EMail:  APRIL@NIC.DDN.MIL


   Joyce K. Reynolds
   USC/Information Sciences Institute
   4676 Admiralty Way
   Marina del Rey, CA  90292-6695
   Phone:  (213) 822-1511
   EMail:  jkrey@isi.edu
