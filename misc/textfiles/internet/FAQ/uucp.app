From gilly!dave Tue, 10 Nov 92 18:43:18 EST
Received: by tmok.uucp (V1.13/Amiga)
	id AA00000; Tue, 10 Nov 92 18:43:18 EST
Received: by gilly.UUCP (smail2.5-coherent) id AA29181; 10 Nov 92 18:27:07
Message-Id: <9211101827.AA29180.V3.4@gilly.UUCP>
Date: 10 Nov 92 18:27:03
From: dave@gilly.UUCP (Dave Fischer)
To: tmok!daver
Subject: usenet registration

This is the README file associated with the usenet mapping project.
I'll send the most recent copy of the RI map I have in a seperate
msg, so you can see a bunch of examples...


# The UUCP map is posted to the newsgroup comp.mail.maps.
#
# From rn, the map can be easily unpacked with a command such as:
#
#	43-46w | (cd ~uucp/uumap ; sh)
#
# or you can use John Quarterman's script to automatically unpack the
# files.  All files intended as pathalias input being with "d." and
# "u.", thus:
#
#	pathalias Path.* uumap/[du].*
# is a useful command to run.  (You supply Path.* with local additions.)
#
# 
# The files are organized by country, using the ISO 3166 3 letter
# country code for each country.  Each file has a name like
# u.iso.r1.r2.s, where "iso" is the country code, r1, r2, etc are
# regions and subregions (e.g. states in the USA, provinces in Canada,
# etc.) and s is a sequence number (usually 1, but sometimes 2, 3, and
# up may be provided to keep individual files down to a reasonable size,
# thus, u.usa.ca is separated into two regions: [135] for southern,
# [246] for northern.)
# 
# The map contains two types of files: u.* and d.* files.  The d.* files
# are for domains registered in the UUCP Zone.  The u.* files are for
# UUCP hosts that do not have officially registered domains.  Membership
# in the UUCP Zone allows organizations and individuals to register
# official, unique, domain names, recognized by all major academic
# computing networks worldwide.  For more information about joining the
# UUCP Zone, send electronic mail to the UUCP Project at one of the
# addresses:
#
#	domain-request@uunet.uu.net
#	{vucomp,halla,pyramid,rutgers,uiucuxc,rosevax}!uunet!domain-request
# or, if you cannot send electronic mail, telephone
#	+1 703 764 9789
#
# We strongly encourage you to send email if at all possible, since it
# cuts down on telephone tag and is much more efficient on our volunteer
# workforce.
# 
# This map can be used to generate mail routes with the pathalias
# program.  The map is also useful to determine the person to contact
# when a problem arises, and to find someone for a new site to connect
# to.
#
# Pathalias was first posted to Usenet in January 1986.  It is posted
# whenever a new release becomes available as well.  The sources are
# posted in the comp.sources.unix newsgroup.  You may also ask the
# comp.sources.unix moderators (unix-sources-moderators@pa.dec.com) to
# send sources to you via email.
# 
# Please check the entry for your host (and any neighbors for whom you
# know the information and have the time) for correctness and
# completeness.  Please send corrections and additional information to
# uucpmap@rutgers.UUCP or rutgers!uucpmap or uucpmap@rutgers.EDU.
# 
# This map is maintained by a group of volunteers who make up the UUCP
# Mapping Project.  These people devote many hours of their own time to
# helping out the UUCP community by keeping this map up to date.  The
# volunteers include:
#
#
# Tohru Asami - konish@kddlab.kddlabs.co.jp
#   Japan: all regions
# 
#
# Jesse Asher - homecare!jessea
#   USA: Alabama, North Carolina, South Carolina, Tennessee
#
#
# Stan Barber - texas-uucpmap@tmc.edu
#   USA: Texas
#
#
# Piet Beertema - Europe (piet@cwi.nl)
#   Europe: all countries (unless otherwise noted)
# 
# 
# Bill Blue - bblue@crash.cts.com
#   USA: Arizona, California (Southern half)
# 
#
# Kent Brodie - brodie@fps.mcw.edu
#   USA: North Dakota, South Dakota, Wisconsin
#
#
# Malcolm Carlock - uucpmap@unrvax.unr.edu
#   USA: Nevada
#
#
# Ken Herron - kherron@ms.uky.edu
#   USA: Kentucky
# 
#
# Haesoon Cho - dnmc@sorak.kaist.ac.kr
#   Korea: all regions
# 
#
# Robert Elz, Dave Davey - map-coord@munnari.UUCP
#   Australia: all regions
# 
#
# Paul Graham - pjg@acsu.buffalo.edu
#   USA: Delaware, Maryland, New Jersey, New York, Virginia, Washington DC,
#   West Virginia
# 
#
# Hokey - hokey@plus5.com
#   USA: Missouri
# 
#
# Jeff Janock - nemap@harvard.edu
#   USA: Connecticut, Maine, Massachusetts, New Hampshire, Pennsylvania, 
#        Rhode Island, Vermont
#
#
# Bob Leffler - uucpmap@vela.acs.oakland.edu
#   USA: Michigan
#
#
# Mikel Manitius - map-request@aaa.com
#   USA: Florida
#
#
# Doug McCallum - dougm@ico.isc.com
#   USA: Arkansas, Colorado, Iowa, Kansas, Louisiana, Mississippi, Nebraska,
#        New Mexico, Oklahoma, Utah
# 
#
# Mark Moraes - path@cs.toronto.edu
#   CANADA: All provinces
# 
#
# Todd Ogasawara - todd@pinhead.pegasus.com
#   USA: Hawaii
# 
#
# Mel Pleasant - pleasant@rutgers.edu
#   Singapore: all regions
#   New Zealand: all regions
# 
# 
# Rob Robertson - nca-maps@violet.berkeley.edu
#   USA: California (Northern half)
# 
# 
# Partono Rudiarto - didik@indovax.uucp
#   Indonesia: all regions
#
#
# David Schmidt - davids@isc-br.isc-br.com
#   USA: Alaska, Idaho, Oregon, Montana, Washington, Wyoming
# 
# 
# Larry Snyder - larry@nstar.rn.com
#   USA: Illinois, Indiana
#
#
# Gil Tene - devil@diablery.10a.com
#   Israel: all regions
#
#
# Tim Thompson - tgt@att.att.com
#   USA: Ohio
#
#
#   Jeff Wabik - jwabik@msc.umn.edu
#   USA: Minnesota
# 
#
# Peter Wan - uucpmap@msdc.com
#   USA: Georgia
# 
# 
# Please note that the purpose of this map is to allow mail routers
# within UUCP to work properly.  The eventual direction is to make the
# map smaller (through the use of domains), not larger.  As such, sites
# with lots of local machines connected together are *strongly*
# encouraged to join the UUCP Zone.  Through the use of a domain, you
# need only register your domain gateway system(s) with the UUCP Mapping
# Project.  Properly configured, all of your internal nodes will hide
# behind the gateway(s).  We would prefer not to have information
# listing the machines on your local area networks.  Helping us to
# accomplish the goal of reducing the size of the map will take some
# work on your part but it is well worth the effort.  Once done, you
# will never need to register any new nodes acquired by you.
# Instructions for contacting the UUCP Zone are given above.
#
# PLEASE NOTE - IF YOU HAVEN'T THE TIME OR MANPOWER TO ACQUIRE A DOMAIN
# AND CONVERT YOUR SYSTEMS OVER TO USING IT, you are *strongly*
# encouraged to publish all the names of those sites in your local area
# network which can and do generate email messages or netnews articles.
# Publishing the names of all systems not hiding behind a domain is the
# only way to ensure that some other site will not register with the
# same name that you have chosen and hence will ensure that mail routers
# will generate uucp mail paths to your systems properly.  
#
#
# The remainder of this file describes the format of the UUCP map data.
# It was written July 9, 1985 by Erik E. Fair <ucbvax!fair>, and last
# updated July 12, 1985 by Mark Horton <stargate!mark>.
# 
# The entire map is intended to be processed by pathalias, a program
# that generates UUCP routes from this data.  All lines beginning in `#'
# are comment lines to pathalias, however the UUCP Project has defined a
# set of these comment lines to have specific format so that a complete
# database could be built.
# 
# The generic form of these lines is
# 
# #<field id letter><tab><field data>
# 
# Each host has an entry in the following format.  The entry should
# begin with the #N line, end with a blank line after the pathalias
# data, and not contain any other blank lines, since there are ed, sed,
# and awk scripts that use expressions like /^#N $1/,/^$/ for the
# purpose of separating the map out into files, each containing one site
# entry.
# 
# #N	UUCP name of site
# #S	manufacturer machine model; operating system & version
# #O	organization name
# #C	contact person's name
# #E	contact person's electronic mail address
# #T	contact person's telephone number
# #P	organization's address
# #L	latitude / longitude
# #R	remarks
# #U	netnews neighbors
# #W	who last edited the entry ; date edited
# #
# sitename	.domain
# sitename	remote1(FREQUENCY), remote2(FREQUENCY),
# 	remote3(FREQUENCY)
# 
# Example of a completed entry:
# 
# #N	ucbvax
# #S	DEC VAX-11/750; 4.3 BSD UNIX
# #O	University of California at Berkeley
# #C	Robert W. Henry
# #E	ucbvax!postmaster
# #T	+1 415 642 1024
# #P	573 Evans Hall, Berkeley, CA 94720
# #L	37 52 29 N / 122 13 44 W
# #R	This is also UCB-VAX.BERKELEY.EDU [10.2.0.78] on the internet
# #U	decvax ibmpa ucsfcgl ucbtopaz ucbcad
# #W	ucbvax!fair (Erik E. Fair); Sat Jun 22 03:35:16 PDT 1985
# #
# ucbvax	berkeley.edu
# ucbvax	= ucbvax.berkeley.edu
# ucbvax	decvax(DAILY/4)
# 	sun(POLLED)
# 
# Specific Field Descriptions
# 
# #N	system name
# 
# Your system's UUCP name should go here. Either the uname(1) command
# from System III or System V UNIX; or the uuname(1) command from
# Version 7 UNIX will tell you what UUCP is using for the local UUCP
# name.
# 
# One of the goals of the UUCP Project is to keep duplicate UUCP host
# names from appearing because there exist mailers in the world which
# assume that the UUCP name space contains no duplicates (and attempts
# UUCP path optimization on that basis), and it's just plain confusing
# to have two different sites with the same name.
# 
# At present, the most severe restriction on UUCP names is that the name
# must be unique somewhere in the first six characters, because of a
# poor software design decision made by AT&T for the System V release of
# UNIX.
# 
# This does not mean that your site name has to be six characters or
# less in length. Just unique within that length.
# 
# With regard to choosing system names, HARRIS'S LAMENT:
# 
# 	``All the good ones are taken.''
# 
# #S	machine type; operating system
# 
# This is a quick description of your equipment. Machine type should be
# manufacturer and model, and after a semi-colon(;), the operating
# system name and version number (if you have it). Some examples:
# 
# 	DEC PDP-11/70; 2.9 BSD UNIX
# 	DEC PDP-11/45; ULTRIX-11
# 	DEC VAX-11/780; VMS 4.0
# 	SUN 2/150; 4.2 BSD UNIX
# 	Pyramid 90x; OSx 2.1
# 	CoData 3300; Version 7 UniPlus+
# 	Callan Unistar 200; System V UniPlus+
# 	IBM PC/XT; Coherent
# 	Intel 386; XENIX 3.0
# 	CRDS Universe 68; UNOS
# 
# #O	organization name
# 
# This should be the full name of your organization, squeezed to fit
# inside 80 columns as necessary. Don't be afraid to abbreviate where
# the abbreviation would be clear to the entire world (say a famous
# institution like MIT or CERN), but beware of duplication (In USC the C
# could be either California or Carolina).
# 
# #C	contact person
# 
# This should be the full name (or names, separated by commas) of the
# person responsible for handling queries from the outside world about
# your machine.
# 
# #E	contact person's electronic address
# 
# This should be just a machine name, and a user name, like
# `ucbvax!fair'. It should not be a full path, since we will be able to
# generate a path to the given address from the data you're giving us.
# There is no problem with the machine name not being the same as the #N
# field (i.e. the contact `lives' on another machine at your site).
# 
# Also, it's a good idea to give a generic address or alias (if your
# mail system is capable of providing aliases) like `usenet' or
# `postmaster', so that if the contact person leaves the institution or
# is re-assigned to other duties, he doesn't keep getting mail about the
# system. In a perfect world, people would send notice to the UUCP
# Project, but in practice, they don't, so the data does get out of
# date. If you give a generic address you can easily change it to point
# at the appropriate person.
# 
# Multiple electronic addresses should be separated by commas, and all
# of them should be specified in the manner described above.
# 
# #T	contact person's telephone number
# 
# Format: +<country code><space><area code><space><prefix><space><number>
# 
# Example:
# 
# #T	+1 415 642 1024
# 
# This is the international format for the representation of phone
# numbers. The country code for the United States of America (and
# Canada) is 1. Other country codes should be listed in your telephone
# book.
# 
# If you must list an extension (i.e. what to ask the receptionist for,
# if not the name of the contact person), list it after the main phone
# number with an `x' in front of it to distinguish it from the rest of
# the phone number.
# 
# Example:
# 
# #T	+1 415 549 3854 x37
# 
# Multiple phone numbers should be separated by commas, and all of them
# should be completely specified as described above to prevent
# confusion.
# 
# #P      organization's address
# 
# This field should be one line filled with whatever else anyone would
# need after the contact person's name, and your organization's name
# (given in other fields above), to mail you something by paper mail.
# 
# #L      latitude and longitude
# 
# This should be in the following format:
# 
# #L	DD MM [SS] "N"|"S" / DDD MM [SS] "E"|"W" ["city"]
# 
# Two fields, with optional third.
# 
# First number is Latitude in degrees (NN), minutes (MM), and seconds
# (SS), and a N or S to indicate North or South of the Equator.
# 
# A Slash Separator.
# 
# Second number is Longitude in degrees (DDD), minutes (MM), and seconds
# (SS), and a E or W to indicate East or West of the Prime Meridian in
# Greenwich, England.
# 
# Seconds are optional, but it is worth noting that the more accurate
# you are, the more accurate maps we can make of the network (including
# blow-ups of various high density areas, like New Jersey, or the San
# Francisco Bay Area).
# 
# If you give the coordinates for your city (i.e. without fudging for
# where you are relative to that), add the word `city' at the end of the
# end of the specification, to indicate that. If you know where you are
# relative to a given coordinate for which you have longitude and
# latitude data, then the following fudge factors can be useful:
# 
# 1 degree	=	69.2 miles	=	111 kilometers
# 1 minute	=	1.15 miles	=	1.86 kilometers
# 1 second	=	102 feet	=	30.9 meters
#
# For LONGITUDE, multiply the above numbers by the cosine of your
# latitude.  For instance, at latitude 35 degrees, a degree of longitude
# is 69.2*0.819 = 56.7 miles; at latitude 40 degrees, it is 69.2*0.766 =
# 53.0 miles.  If you don't see why the measure of longitude depends on
# your latitude, just think of a globe, with all those N-S meridians of
# longitude converging on the poles.  You don't do this cosine
# multiplication for LATITUDE.
#
# Here is a short cosine table in case you don't have a trig calculator
# handy.  (But you can always write a short program in C.  The cosine
# function in bc(1) doesn't seem to work as documented.)
# deg  cos  deg  cos  deg  cos  deg  cos  deg  cos  deg  cos
#  0  1.000  5  0.996 10  0.985 15  0.966 20  0.940 25  0.906
# 30  0.866 35  0.819 40  0.766 45  0.707 50  0.643 55  0.574
# 60  0.500 65  0.423 70  0.342 75  0.259 80  0.174 85  0.087
# 
# The Prime Meridian is through Greenwich, England, and longitudes run
# from 180 degrees West of Greenwich to 180 East.  Latitudes run from
# 90 degrees North of the Equator to 90 degrees South.
# 
# #R      remarks
# 
# This is for one line of comment. As noted before, all lines beginning
# with a `#' character are comment lines, so if you need more than one
# line to tell us something about your site, do so between the end of the
# map data (the #?\t fields) and the pathalias data.
# 
# #U	netnews neighbors
# 
# The USENET is the network that moves netnews around, specifically,
# news.announce.important. If you send news.announce.important to any of
# your UUCP neighbors, list their names here, delimited by spaces.
# Example:
# 
# #U	decvax mcvax seismo
# 
# Since some places have lots of USENET neighbors, continuation lines
# should be just another #U and more site names.
# 
# #W      who last edited the entry and when
# 
# This field should contain an email address, a name in parentheses,
# followed by a semi-colon, and the output of the date program.
# Example:
# 
# #W	ucbvax!fair (Erik E. Fair); Sat Jun 22 03:35:16 PDT 1985
# 
# The same rules for email address that apply in the contact's email
# address apply here also. (i.e. only one system name, and user name).
# It is intended that this field be used for automatic aging of the
# map entries so that we can do more automated checking and updating
# of the entire map. See getdate(3) from the netnews source for other
# acceptable date formats.
# 
# PATHALIAS DATA (or, documenting your UUCP connections & frequency of use)
# 
# The DEMAND, DAILY, etc., entries represent imaginary connect costs (see
# below) used by pathalias to calculate lowest cost paths.  The cost
# breakdown is:
# 
# 	LOCAL		25	local area network
# 	DEDICATED	95	high speed dedicated
# 	DIRECT		200	local call
# 	DEMAND          300     normal call (long distance, anytime)
# 	HOURLY		500	hourly poll
# 	EVENING		1800	time restricted call
# 	DAILY		5000	daily poll
# 	WEEKLY		30000	irregular poll
# 	DEAD            a very high number - not usable path
# 
# Additionally, HIGH and LOW (used like DAILY+HIGH) are -5 and +5
# respectively, for baud-rate or quality bonuses/penalties.  Arithmetic
# expressions can be used, however, you should be aware that the results
# are often counter-intuitive (e.g. (DAILY*4) means every 4 days, not 4
# times a day).  This is because the numbers represent "cost of connection"
# rather than "frequency of connection."
# 
# The numbers are intended to represent cost of transferring mail over
# the link, measured very roughly in elapsed time, which seems to be
# far more important than baud rates for this type of
# traffic.  There is an assumed high overhead for each hop; thus,
# HOURLY is far more than DAILY/24.
# 
# There are a few other cost names that sometimes appear in the map.
# Some are synonyms for the preferred names above (e.g. POLLED is assumed
# to mean overnight and is taken to be the same as DAILY), some are
# obsolete (e.g.  the letters A through F, which are letter grades for
# connections.) It is not acceptable to make up new names or spellings
# (pathalias gets very upset when people do that...).
# 
# LOCAL AREA NETWORKS
# 
# We do not want local area network information in the published map.
# If you want to put your LAN in your local Path.* files, read about
# the LAN syntax in the pathalias.1 manual page.
# 
# WHAT TO DO WITH THIS STUFF
# 
# Once you have finished constructing your pathalias entry, mail it off
# to {uunet|gatech|ucsd|ames}!rutgers!uucpmap, which will be sent to the
# appropriate regional map coordinator.  They maintain assigned
# geographic sections of the map, and the entire map is posted on a
# rolling basis in the USENET newsgroups comp.mail.maps over the course
# of a month.
# 
# Questions or comments about this specification should also be directed
# at rutgers!uucpmap.
# 

