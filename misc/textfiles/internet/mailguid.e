Inter-network mail transfer guide
---------------------------------
  "...sending electronic mail from one network to another."


    Monthly updates of this guide are available by Listserv at
    LISTSERV@UNMVMA on Bitnet or listserv@unmvm.unm.edu on the Internet.
    To fetch a copy, send a message to either address, with an empty
    subject and a message body consisting of the line 'GET NETWORK
    GUIDE'. [Courtesy of Art St. George]



# Inter-Network Mail Guide - Copyright 1992 by John J. Chew
#
#V $Revision: 1.37 $
#V $Date: 92/06/25 22:52:17 $
#
# WHAT'S NEW
#
# + aol -> applelink, compuserve (Jay Levitt <postmaster@aol.com>)
# ! noted intermail gateway will vanish soon (Glen Foster <gfoster@darpa.mil>)
# + new FTP site (Art St. George <stgeorge@bootes.unm.edu>)
# ! noted DASNet BIX gateway is not universal
# ! noted 8K limit on PC version of aol (Lars Kongshem <Norge1@aol.com>)
# ! GeoNet organization (Nick Leverton <nleverton@cix.compulink.co.uk>)
# + gold-400 (Nick Leverton)
# + greennet (Nick Leverton)
# - tcg (Nick Leverton)
# ! aol gateways are no longer in beta testing (Jay Levitt)
# + mci -> compuserve (Brian Long <blong@cix.compulink.co.uk>)
#
# COPYRIGHT NOTICE
#
# This document is Copyright 1992 by John J. Chew.  All rights reserved.
# Permission for non-commercial distribution is hereby granted, provided
# that this file is distributed intact, including this copyright notice
# and the version information above.  Permission for commercial distribution
# can be obtained by contacting the author as described below.
#
# INTRODUCTION
#
# This file documents methods of sending mail from one network to another.
# It represents the aggregate knowledge of the readers of comp.mail.misc
# and many contributors elsewhere.  If you know of any corrections or
# additions to this file, please follow the instructions in the section
# entitled 'HOW TO FORMAT INFORMATION FOR SUBMISSION' and then mail the
# information to me: John J. Chew <poslfit@utcs.utoronto.ca>.  If
# you do not have access to electronic mail (which makes me wonder about
# the nature of your interest in the subject, but there does seem to be
# a small such population out there) you can call me between 14:30 and
# 19:00 MET (currently UTC+2h) at +33 1 46 40 10 60, or fax me (at any time)
# at +33 1 46 40 18 44.  Please note that these telephone numbers will remain
# valid only until the end of July 1992.
#
# DISTRIBUTION
#
# (news) This list is posted monthly to Usenet newsgroups comp.mail.misc and
#   news.newusers.questions.
# (mail) I maintain a growing list of subscribers who receive each monthly
#   issue by electronic mail, and recommend this to anyone planning to .
#   redistribute the list on a regular basis.
# (FTP) Internet users can fetch this guide by anonymous FTP as ~ftp/pub/docs/
#   internetwork-mail-guide on FTP.MsState.Edu (130.18.80.11) [Courtesy of
#   Frank W. Peters], or as ~ftp/library/network.guide on ariel.unm.edu
#   (129.24.8.1) [Courtesy of Art St. George].
# (Listserv) The guide is available by Listserv at LISTSERV@UNMVMA on Bitnet
#   or listserv@unmvm.unm.edu on the Internet.  To fetch a copy, send a message
#   to either address, with an empty subject and a message body consisting of
#   the line 'GET NETWORK GUIDE'.  [Courtesy of Art St. George]
#
# HOW TO USE THIS GUIDE
#
# This document is meant to be both human-readable and machine-parseable.  I
# have an experimental Perl script that performs queries on this document -
# send me e-mail if you would like a copy.
#
# If you just want to browse the guide manually for information, this is what
# you need to know.  The guide is organized as a list of entries.  Each entry
# tells you how to get from one network to another.  Here is what a typical
# entry might look like:
#
#   #F mynet
#   #T yournet
#   #R youraddress
#   #C contactaddress
#   #I send to 'youraddress@thegateway'
#
# This means that to send mail _f_rom a network called 'mynet' _t_o a
# _r_ecipient address 'youraddress' on a network called 'yournet', you
# should follow the _i_nstructions shown and address your mail to
# 'youraddress@thegateway'.  (The quotes are not part of the address
# you should use, and if you see \' between the double quotes, you
# should type just ' when addressing your mail.)  If you have trouble
# sending mail, you can try sending mail to 'contactaddress' for help.
#
# Network names are listed together with a brief description of each network,
# before the main entires.  The main entries themselves are sorted
# alphabetically, first by source network and then by destination network.
# Network connections that can be generated transitively (A->B and B->C give
# A->B->C) are generally omitted.  If you need further information on the
# format, read the following section.
#
# HOW TO PARSE THIS GUIDE
#
# The format of this guide is designed to be a reasonable compromise between
# the automatically parsable and the humanly legible.
#
# As distributed, the guide consists of a sequence of lines of up to eighty
# octets in the range [32,126] representing characters in the ASCII encoding,
# with each line terminated by a newline (decimal 10) character.
#
# Valid lines are either empty or begin with a '#'.  Invalid lines should
# be rejected as being part of an encapsulation such as a mail header.
#
# The portion of a non-empty, valid line following the '#' consists of a tag
# and data.  The tag is the longest leading string of characters that does not
# contain a space, the data is the portion of the line after the first space
# if any.  Leading spaces in the data are ignored, except on continuation lines
# (see below).
#
# Lines tagged with a '-' are continuation lines.  If more than eighty
# characters need to be placed in one logical record, the characters should
# be placed in several lines, with all lines after the first tagged with a '-'.
# A (possibly singleton) set of lines will be referred to as a record.  A
# record's tag is the tag of its first line.
#
# Records with empty tags (such as these) are comments for human eyes only
# and should in general be silently ignored by an automatic parser.
#
# Records are grouped into blocks, delimited by empty lines.  Empty blocks,
# or blocks which contain nothing but comments, should be ignored.
#
# The first block of the file consists of 'V'-tagged records which give
# version information for the file.  The format of this information is
# subject to change, and should not be automatically parsed.  In this
# edition, the first block is at the very beginning of the file.
#
# The second block of the file consists of 'N'-tagged records which declare
# identifiers to be used in referring to networks in the rest of the file.
# Each such record is divided into ';'-separated fields.  The fields are
# currently: identifier, full name, organization, category (academic, bbs,
# commercial, in-house, non-profit, none or ?).  Leading and trailing spaces
# in fields should be ignored.  In fact, without further ado, here's the
# second block.

#N aol           ; America Online; America Online, Inc.; commercial;
#N applelink     ; AppleLink; Apple Computer, Inc.; in-house;
#N att           ; AT&T Mail; AT&T; commercial;
#N bitnet        ; BITNET; none; academic;
#N bix           ; Byte Information eXchange; Byte magazine; commercial;
#N bmug          ; ? ; Berkeley Macintosh Users Group; in-house;
#N cgnet         ; CGNET; Agricultural research network; commercial;
#N compuserve    ; CompuServe; CompuServe Inc.; commercial;
#N connect       ; Connect Professional Information Network; ?; commercial;
#N easynet       ; Easynet; DEC; in-house;
#N envoy         ; Envoy-100; Telecom Canada; commercial; X.400
#N fax           ; Facsimile document transmission; none; none;
#N fidonet       ; FidoNet; none; bbs;
#N geonet        ; GeoNet Mailbox Systems;
#-  Geonet Mailbox Services GmbH/Systems Inc.; commercial;
#N gold-400      ; GNS Gold 400; British Telecom; commercial; X.400
#N greennet      ; GreenNet; Soft Solutions Ltd; commercial;
#N gsfcmail      ; GSFCmail; NASA/Goddard Space Flight Center; in-house;
#N ibm           ; VNET; IBM; in-house;
#N internet      ; Internet; none; academic;
#N keylink       ; KeyLink; Telecom Australia; commercial; X.400
#N mci           ; MCIMail; MCI; commercial;
#N mfenet        ; Magnetic Fusion Energy Network
#-               ; Lawrence Livermore National Laboratory; academic;
#N nasamail      ; NASAMail; NASA; in-house;
#N nsi           ; NASA Science Internet; NASA; government;
#-  Dual-protocol: instructions given here pertain only to NSI-DECnet addresses
#-  (NSI-TCP/IP addresses should be treated as shown for 'internet')
#N omnet         ; OMNET; OMNET; commercial;
#N peacenet      ; PeaceNet; Institute for Global Communications; non-profit;
#N sinet         ; Schlumberger Information NETwork; ?; ?;
#N sprintmail    ; SprintMail; Sprint; commercial; formerly Telemail
#N thenet        ; Texas Higher Education Network; University of Texas
#-               ; academic ;
#
# After these header blocks come a sequence of connection blocks, describing
# how to get from one network to another.  In each such block, the records
# are tagged 'F', 'T', and 'R', followed by an optional 'C', and at least
# one 'I'.
#
# The 'F' (from) record gives the network identifier of the source network.
#
# The 'T' (to) record gives the network identifier of the destination network.
#
# The 'R' (recipient) record gives an example of an address on the
# destination network, to make it clear in subsequent lines what text
# requires subsitution.
#
# The 'C' (contact) record gives an address for inquiries concerning the
# gateway, expressed as an address reachable from the source (#F) network.
# Presumably, if you can't get the gateway to work at all, then knowing
# an unreachable address on another network will not be of great help.
#
# The 'I' (instructions) records, of which there may be several, give verbal
# instructions to a user of the source network to let them send mail
# to a user on the destination network.  Text that needs to be typed
# will appear in double quotes, with C-style escapes if necessary.  If
# the instructions consist simply of mailing to a certain address, this
# will be indicated by the words 'send to' followed by a quoted address.
# If there are alternative addresses, they will be marked 'or to' instead.
#
# HOW TO FORMAT INFORMATION FOR SUBMISSION
#
# If you don't want to wade through the section on parsing the guide above,
# here is what I really want in the way of information.  If you are adding
# a new network to the list, tell me what its official name is (pay attention
# to capitalisation), what the name of its responsible organization is, and
# what kind of a network it is (academic, commercial, government, in-house
# or non-profit).  If this isn't clear, look at the examples above.  I would
# appreciate it if you would format the entry thus:
#
# #N foonet   ; The Foo Network; The Foo Organization; commercial
#
# Next, for each connection, give me an entry that looks something like:
#
# #F foonet
# #T barnet
# #R baraddress
# #C contactaddress
# #I send to 'baraddress@thegateway'
#
# Note that 'contactaddress' must be an address expressed in foonet's native
# format, and not that of barnet, since if a user is having trouble accessing
# barnet, giving him/her an address on that net to contact for help is not
# productive.  If there is no contact/postmaster address, please tell me.
# If there are more complicated instructions, use additional #I lines.
#
# Once you've got all the information together, send it to me in an e-mail
# message with the words 'INMG update' in the Subject: line.  You can in
# general expect an answer back from me within a week or two, modulo workload
# and vacations.

#F aol
#T applelink
#R user
#C Internet
#I send to 'user@applelink'

#F aol
#T compuserve
#R 71234,567
#C Internet
#I send to '71234.567@cis'

#F aol
#T internet
#R user@domain
#C Internet
#I send to 'user@domain'

#F applelink
#T bitnet
#R user@site
#I send to 'user@site.bitnet@internet#'

#F applelink
#T internet
#R user@domain
#I send to 'user@domain@internet#' (address must be <35 characters)

#F att
#T bitnet
#R user@site
#I send to 'internet!site.bitnet!user'

#F att
#T internet
#R user@domain
#I send to 'internet!domain!user'

#F bitnet
#T internet
#R user@domain
#I Methods for sending mail from Bitnet to the Internet vary depending on
#-  what mail software is running at the Bitnet site in question.  In the
#-  best case, users should simply be able to send mail to 'user@domain'.
#-  If this doesn't work, try 'user%domain@gateway' where 'gateway' is a
#-  Bitnet-Internet gateway site nearby.  Finally, if neither of these
#-  works, you may have to try hand-coding an SMTP envelope for your mail.
#I If you have questions concerning this rather terse note, please try
#-  contacting your local postmaster or system administrator first before
#-  you send me mail -- John Chew <poslfit@utcs.utoronto.ca>

#F cgnet
#T internet
#R user@domain
#I send to 'INTERMAIL'
#I message body must contain an appropriately (?) formatted header
#I this gateway will be discontinued 1992-09-30

#F compuserve
#T fax
#R +1 415 555 1212
#I send to '>FAX 14155551212'
#I not transitive - message must originate from a CompuServe user
#I for calls outside the NANP, use '011' as the international prefix

#F compuserve
#T internet
#R user@domain
#I send to '>INTERNET:user@domain' (only from CompuServe users)

#F compuserve
#T mci
#R 123-4567
#I send to '>MCIMAIL:123-4567' (only from CompuServe users)

#F connect
#T internet
#R user@domain
#I send to 'DASNET'
#I first line of message: '"user@domain"@DASNET'

#F easynet
#T bitnet
#R user@site
#C DECWRL::ADMIN
#I send to 'nm%DECWRL::"user@site.bitnet"' (from VMS using NMAIL)
#I send to 'user@site.bitnet' (from Ultrix)
#I   or to 'user%site.bitnet@decwrl.dec.com' (from Ultrix via IP)
#I   or to 'DECWRL::"user@site.bitnet"' (from Ultrix via DECNET)

#F easynet
#T fidonet
#R john smith at 1:2/3.4
#C DECWRL::ADMIN
#I send to 'nm%DECWRL::"john.smith@p4.f3.n2.z1.fidonet.org"'
#-  (from VMS using NMAIL)
#I send to 'john.smith@p4.f3.n2.z1.fidonet.org'
#-  (from Ultrix)
#I or to '"john.smith%p4.f3.n2.z1.fidonet.org"@decwrl.dec.com'
#-  (from Ultrix via IP)
#I or to 'DECWRL::"john.smith@p4.f3.n2.z1.fidonet.org"'
#-  (from Ultrix via DECNET)

#F easynet
#T internet
#R user@domain
#C DECWRL::ADMIN
#I send to 'nm%DECWRL::"user@domain"' (from VMS using NMAIL)
#I send to 'user@domain' (from Ultrix)
#I   or to 'user%domain@decwrl.dec.com' (from Ultrix via IP)
#I   or to 'DECWRL::"user@domain"' (from Ultrix via DECNET)

#F envoy
#T internet
#R user@domain
#C ICS.TEST or ICS.BOARD
#I send to '[RFC-822="user(a)domain"]INTERNET/TELEMAIL/US'
#I for special characters, use @=(a), !=(b), _=(u), any=(three octal digits)

#F fidonet
#T internet
#R user@domain
#I send to 'uucp' at nearest gateway site
#I set first line of message to 'To: user@domain'

#F geonet
#T internet
#R user@domain
#I send to 'DASNET'
#I set subject line to 'user@domain!subject'

#F gold-400
#T internet
#R user@host
#I send to '/DD.RFC-822=user(a)host/O=uknet/PRMD=uk.ac/ADMD=gold 400/C=GB/'
#I for special characters, use @=(a), %=(p), !=(b), "=(q)

#F gsfcmail
#T internet
#R user@domain
#C cust.svc
#I send to '(SITE:SMTPMAIL,ID:<user(a)domain>)'
#I or to '(C:USA,A:TELEMAIL,P:SMTPMAIL,ID:<user(a)domain>)'
#I or send to 'POSTMAN'
#-  and set the first line of message to 'To: user@domain'
#I Help is also available by phoning +1 301 286 6865.

#F gsfcmail
#T nsi
#R host::user
#C cust.svc
#I send to '(SITE:SMTPMAIL,ID:<user(a)host.DNET.NASA.GOV>)'
#I or to '(C:USA,A:TELEMAIL,P:SMTPMAIL,ID:<user(a)host.DNET.NASA.GOV>)'
#I or send to 'POSTMAN'
#-  and set the first line of message to 'To: user@host.DNET.NASA.GOV'

#F internet
#T aol
#R A User
#C postmaster@aol.com
#I send to auser@aol.com (all lower-case, remove spaces)
#I messages are truncated to 32K (8K for PCs), all characters except newline
#-  and printable ASCII characters are mapped to spaces, users are limited to
#-  75 pieces of Internet mail in their mailbox at a time.

#F internet
#T applelink
#R user
#I send to 'user@applelink.apple.com'

#F internet
#T att
#R user
#I send to 'user@attmail.com'

#F internet
#T bitnet
#R user@site
#I send to 'user%site.bitnet@gateway' where 'gateway' is a gateway host that
#-  is on both the internet and bitnet.  Some examples of gateways are:
#-  cunyvm.cuny.edu mitvma.mit.edu.  Check first to see what local policies
#-  are concerning inter-network forwarding.

#F internet
#T bix
#R user
#I send to 'user@dcibix.das.net'
#I reaches only paying users registered through the DASNet (commercial) gateway

#F internet
#T bmug
#R John Smith
#I send to 'John.Smith@bmug.fidonet.org'

#F internet
#T cgnet
#R user
#C intermail-request@intermail.isi.edu
#I send to 'user%CGNET@intermail.isi.edu'
#I this gateway will be discontinued 1992-09-30

#F internet
#T compuserve
#R 71234,567
#I send to '71234.567@compuserve.com'
#I   Ordinary Compuserve account IDs are pairs of octal numbers

#F internet
#T compuserve
#R organization:department:user
#I send to 'user@department.organization.compuserve.com'
#I   This syntax is for use with members of organizations which have a
#-   private CompuServe mail area.  'department' may not always be present.

#F internet
#T connect
#R NAME
#I send to 'NAME@dcjcon.das.net'

#F internet
#T easynet
#R HOST::USER
#C admin@decwrl.dec.com
#I send to 'user@host.enet.dec.com'
#I   or to 'user%host.enet@decwrl.dec.com'

#F internet
#T easynet
#R John Smith @ABC
#C admin@decwrl.dec.com
#I send to 'John.Smith@ABC.MTS.DEC.COM'
#I   this syntax is for sending mail to All-In-1 users

#F internet
#T envoy
#R John Smith (ID=userid)
#I send to 'uunet.uu.net!att!attmail!mhs!envoy!userid'

#F internet
#T envoy
#R John Smith (ID=userid)
#C /C=CA/ADMD=TELECOM.CANADA/ID=ICS.TEST/S=TEST_GROUP/@nasamail.nasa.gov
#I send to '/C=CA/ADMD=TELECOM.CANADA/DD.ID=userid/PN=John_Smith/@Sprint.COM'

#F internet
#T fidonet
#R john smith at 1:2/3.4
#I send to 'john.smith@p4.f3.n2.z1.fidonet.org'

#F internet
#T geonet
#R user at host
#I send to 'user:host@map.das.net'
#I   or to 'user@host.geomail.org' (known to work for geo2)
#I known hosts: geo1 (Europe), geo2 (UK), geo4 (USA)

#F internet
#T gold-400
#R (G:John, I:Q, S:Smith, OU: org_unit, O:organization, PRMD:prmd)
#I send to 'john.q.smith@org_unit.org.prmd.gold-400.gb'
#I   or to '"/G=John/I=Q/S=Smith/OU=org_unit/O=org/PRMD=prmd/ADMD=gold 400/
#- C=GB/"@mhs-relay.ac.uk'

#F internet
#T greennet
#R user
#C support@gn.co.uk
#I user@gn.co.uk
#I valid as of 1991-04-04

#F internet
#T gsfcmail
#R user
#C help@nic.nsi.nasa.gov
#I send to 'user@gsfcmail.nasa.gov'
#I   or to '/PN=user/ADMD=TELEMAIL/PRMD=GSFC/O=GSFCMAIL/C=US/
#- @x400.msfc.nasa.gov'

#F internet
#T ibm
#R user@vmnode.tertiary_domain (syntax?)
#C nic@vnet.ibm.com
#I send to 'user@vmnode.tertiary_domain.ibm.com'
#I To look up a user's mailbox name, mail to nic@vnet.ibm.com with
#- the line 'WHOIS name' in the message body.

#F internet
#T keylink
#R (G:John, I:Q, S:Smith, O:organization, C:au)
#C aarnet@aarnet.edu.au
#I send to '"/G=John/I=Q/S=Smith/O=organization/"@telememo.au'
#I Supported attributes are C=AU, A=ADMD=telememo, P=PRMD=private management
#-  domain, O=organization, OU=organizational unit, G=given name, I=initials,
#-  S=surname, PN=personal name (G.I.S), DD.UID (domain defined), DD.NODE
#-  (domain defined), DD.UN (domain defined).

#F internet
#T mci
#R John Smith (123-4567)
#I send to '1234567@mcimail.com'
#I or to 'JSmith@mcimail.com' (if 'JSmith' is unique)
#I or to 'John_Smith@mcimail.com' (if 'John Smith' is unique - note the
#-  underscore!)
#I or to 'John_Smith/1234567@mcimail.com' (if 'John Smith' is NOT unique)

#F internet
#T mfenet
#R user@mfenode
#I send to 'user%mfenode.mfenet@nmfecc.arpa'

#F internet
#T nasamail
#R user
#C help@nic.nsi.nasa.gov
#I send to 'user@nasamail.nasa.gov'
#I Help is available by phoning +1 205 544 1771 or +1 301 286 7251.

#F internet
#T nsi
#R host::user
#C help@nic.nsi.nasa.gov
#I send to 'user@host.dnet.nasa.gov'
#I   or to 'user%host.dnet@ames.arc.nasa.gov'
#I   or to 'user%host.dnet@east.gsfc.nasa.gov'
#I Help is also available by phoning +1 301 286 7251.

#F internet
#T omnet
#R user
#C help@nic.nsi.nasa.gov
#I send to 'user@omnet.nasa.gov'
#I   or to 'user/omnet@omnet.nasa.gov' (?)
#I   or to '/DD.UN=user/O=OMNET/ADMD=TELEMAIL/C=US/@Sprint.COM'
#I Help is available by phoning +1 301 286 7251 or +1 617 265 9230.

#F internet
#T peacenet
#R user
#C support@igc.org
#I send to 'user@cdp.igc.org'

#F internet
#T sinet
#R node::user or node1::node::user
#I send to 'user@node.SINet.SLB.COM'
#I   or to 'user%node@node1.SINet.SLB.COM'

#F internet
#T sprintmail
#R John Smith at SomeOrganization
#C help@nic.nsi.nasa.gov
#I send to '/G=John/S=Smith/O=SomeOrganization/ADMD=TELEMAIL/C=US/@Sprint.COM'
#I Help is also available by phoning +1 301 286 7251.

#F internet
#T thenet
#R user@host
#I send to 'user%host.decnet@utadnx.cc.utexas.edu'

#F keylink
#T internet
#R John Smith <user@domain>
#C (G:CUSTOMER, S:SERVICE, O:CUST.SERVICE, P:telememo, C:au)
#I send to '(C:au, A:telememo, P:oz.au, "RFC-822":"John Smith
#-  <user(a)domain>")'
#I special characters must be mapped: @->(a), %->(p), !->(b), "->(q)

#F mci
#T compuserve
#R John Smith (71234,567)
#C 267-1163 (MCI Help)
#I at the 'To:' prompt type 'John Smith (EMS)'
#I at the 'EMS:' prompt type 'compuserve'
#I at the 'Mbx:' prompt type '71234,567'

#F mci
#T internet
#R John Smith <user@domain>
#C 267-1163 (MCI Help)
#I at the 'To:' prompt type 'John Smith (EMS)'
#I at the 'EMS:' prompt type 'INTERNET'
#I at the 'Mbx:' prompt type 'user@domain'

#F nasamail
#T internet
#R user@domain
#C admin
#I send to '(site:smtpmail,id:<user(a)domain>)'
#I Help is also available by phoning +1 205 544 1771 and at 'admin/nasa'.

#F nasamail
#T nsi
#R host::user
#C admin
#I send to '(site:smtpmail,id:<user(a)host.DNET.NASA.GOV>)'
#I Help is also available by phoning +1 205 544 1771 and at 'admin/nasa'.

#F nsi
#T gsfcmail
#R user
#C help@nic.nsi.nasa.gov
#I send to 'east::"user@gsfcmail.nasa.gov"'
#I or to 'east::"/PN=user/ADMD=TELEMAIL/PRMD=GSFC/O=GSFCMAIL/C=US/
#- @x400.msfc.nasa.gov'
#I Help is also available by phoning +1 301 286 7251.

#F nsi
#T internet
#R user@domain
#C nsinic::nsihelp
#I send to 'east::"user@domain"'
#I or to 'dftnic::"user@domain"'
#I or to 'nssdca::in%"user@domain"'
#I or to 'jpllsi::"user@domain"'
#I Help is also available by phoning +1 301 286 7251.

#F nsi
#T omnet
#R user
#C omnet.service
#I send to 'east::"user@omnet.nasa.gov"'
#I Help is also available by phoning +1 617 265 9230.

#F nsi
#T sprintmail
#R John Smith at SomeOrganization
#C nsinic::nsihelp
#I send to '/G=John/S=Smith/O=SomeOrganization/ADMD=TELEMAIL/C=US/@Sprint.COM'
#I Help is also available by phoning +1 301 286 7251.

#F omnet
#T internet
#R user@domain
#C omnet.service
#I Enter 'compose manual' at the command prompt.  Choose the Internet address
#-  option from the menu that appears.  Note that this gateway service charges
#-  based on the number of 1000-character blocks sent.
#I Help is also available by phoning +1 617 265 9230.

#F sinet
#T internet
#R user@domain
#I send to 'M_MAILNOW::M_INTERNET::"user@domain"'
#I   or to 'M_MAILNOW::M_INTERNET::domain::user'

#F sprintmail
#T internet
#R user@domain
#I send to '(C:USA,A:TELEMAIL,P:INTERNET,"RFC-822":<user(a)domain>) DEL'
#I Help is available within the United States by phoning +1 800 336 0437 and
#-  pressing '2' on a TouchTone phone.

#F sprintmail
#T nsi
#R host::user
#I send to
#-  '(C:USA,A:TELEMAIL,P:INTERNET,"RFC-822":<user(a)host.DNET.NASA.GOV>) DEL'
#I Help is available within the United States by phoning +1 800 336 0437 and
#-  pressing '2' on a TouchTone phone.

#F thenet
#T internet
#R user@domain
#I send to 'UTADNX::WINS%" user@domain "'

==== <g GUIDE>                       9 links in glossary topic
==== <g MAIL>                        2 links in glossary topic
==== <g TRANSFER>                    2 links in glossary topic
