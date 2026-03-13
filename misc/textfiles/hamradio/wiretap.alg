Date: 30-Oct-85 22:51:33-UT
From: mills at dcn6.arpa
To:   packet-radio at mit-eddie.arpa
Re:   The Wiretap Algorithm (*long*)

I hope you enjoy the following enough that you won't get mad at me for
bloating your mail file, which as we all know creates gas.

Dave

The Wiretap Algorithm

Abstract

This document introduces wiretap algorithms, which are a class of routing
algorithms that compute quasi-optimal routes for stations sharing a broadcast
channel, but with some stations hidden from others. The wiretapper observes
the paths (source routes) used by other stations sending traffic on the
channel and, using a heuristic set of factors and weights, constructs
speculative paths for its own traffic. A prototype algorithm, called here
the Wiretap Algorithm, has been designed for the AX.25 packet-radio channel.
Its design is similar in many respects to the shortest-path-first (spf)
algorithm used in the ARPANET and elsewhere, and is in fact a variation on the
Viterbi algorithm in that it constructs minimum-weight paths as a function of
a weighted sum of factors derived from link and node quality estimates.

Since the amateur AX.25 packet-radio channel is very active in the Washington,
DC, area and carries a good deal of traffic under punishing conditions, it was
considered a sufficiently fiesty environment to implement and test the
prototype algorithm. It was implemented as part of an IP/TCP driver for the
LSI-11 processor running the "fuzzball" operating system. The driver is
connected via serial line to a 6809-based TAPR-1 processor running the WA8DED
firmware. This document describes the design, implementation and initial
testing of the algorithm.

Introduction

This document describes the design, implementation and initial testing of the
Wiretap Algorithm, a dynamic routing algorithm for the AX.25 packet-radio
channel. The AX.25 channel operates in CSMA contention mode at VHF frequencies
using AFSK/FM modulation at 1200 bps. The AX.25 protocol itself is similar to
X.25 LAPB, but with an extended frame header consisting of a string of radio
callsigns representing a path, usually selected by the operator, from the
originating station to the destination station, possibly via one or more
intermediate packet repeaters or digipeaters. Most stations can operate
simultaneously as digipeaters and as end systems.

Wiretap uses passive monitoring of frames transmitted on the channel in order
to build a dynamic data base which can be used to determine optimum routes.
The algorithm operates in real time and selects a minimum-weight path, as
determined by a shortest-path-first procedure similar to that used now in the
ARPANET and planned for use in the new Internet gateway system. The
implementation provides optimum routes (with respect to the factors and
weights selected) at initial-connection time for virtual circuits, as well as
for each datagram transmission. This note is an initial status report and
overview of the prototype implementation for the LSI-11 processor running the
"fuzzball" operating system.

The principal advantage in the use of routing algorithms like Wiretap is that
digipeater paths can be avoided when direct paths are available, with
digipeaters used only when necessary and also to discover hidden stations. In
the present exploratory stage of evolution, the scope of Wiretap has been
intentionally restricted to passive monitoring. In a later stage the scope may
be extended to include the use of active probes to discover hidden stations
and the use of clustering techniques to manage the distribution of large
quantities of routing information.

The AX.25 channel interface is the 6809-based TAPR-1 processor running the
WA8DED firmware (version 1.0) and connected to the LSI-11 by a 4800-bps serial
line. The WA8DED firmware produces as an option a monitor report for each
received frame of a selected type, including U, I and S frames. Wiretap
processes each of these to extract routing information and (optionally) saves
them in the system log file. Following is a typical report:

	fm KS3Q to W4CQI via WB4JFI-5* WB4APR-6 ctl I11 pid F0

The originating station is KS3Q and the destination is W4CQI. The frame has
been digipeated first by WB4JFI-5 and then WB4APR-6, is an I frame (sequence
numbers follow the I indicator) and has protocol identifier F0 (hex). The
asterisk "*" indicates the report was received from that station. If no
asterisk appears, the report was received from the originator.

Design Principles

A path is a concatenation of directed links originating at one station,
extending through one or more digipeaters and terminating at another station.
Each link is characterized by a set of factors such as cost, delay or
throughput that can be computed or estimated. Wiretap computes several
intrinsic factors for each link and updates the routing data base, consisting
of node and link tables. The weighted sum of these factors over the entire
path is the path weight.

Wiretap incorporates an algorithm which constructs the minimum-weight paths
between given end stations according to the factors and weights contained in
the routing data base. Such paths can be considered optimum routes between
these stations with respect to the given assignment of factors and weights. In
the prototype implementation one of the end stations must be the Wiretap
station itself.

Note that Wiretap in effect constructs minimum-weight paths in the direction
from another station to the Wiretap station and, based on that information,
then computes the optimum reciprocal routes from the Wiretap station to the
other station. The expectation is that the other station also runs its own
routing algorithm, which then computes its own optimal reciprocal routes (i.e.
the optimum direct routes from the Wiretap station). However, the routing data
bases at the two stations may diverge due to congestion or hidden stations, so
that the computed routes may not coincide.

In principle, Wiretap-computed routes can be fine-tuned using information
provided not only by its directly communicating stations but others that may
hear them as well. The best scenario would be for all stations to exchange
Wiretap information using a suitable distributed protocol, but this is at the
moment beyond the scope of the prototype implementation. Nevertheless,
suboptimal but useful paths can be obtained in the traditional and simple way
with one station using a Wiretap-computed route and the other its reciprocal,
as determined from the received frame header. Thus, Wiretap is compatible with
existing channel procedures and protocols.

Implementation Overview

The prototype Wiretap implementation for the LSI-11 includes two routines, the
wiretap routine, which extracts information from received monitor headers and
builds the routing data base, and the routing routine, which calculates routes
using the information in the data base. The data base consists of three
tables, the channel table, node table and link table. The channel table
includes an entry for each channel of the TAPR-1 processor running the WA8DED
firmware, five in the present configuration. The structure and use of this
table are only incidental to the algorithm and will not be discussed further.

The node table includes an entry for each distinct callsign (which may be a
collective or beacon identifier) heard on the channel, together with its
assigned IP address (if known), node-related routing information, the latest
computed route and other miscellaneous information. The table is indexed by
node ID (NID), which is used in the computed route and in other tables instead
of the awkward callsign string.

The link table contains an entry for each distinct (unordered) node pair
observed in a monitor header. Each entry includes the from-NID and to-NID of
the first instance found, together with node-related routing information
and other miscellaneous information.

The example discussed later in this document includes candidate node and link
tables for illustration. These tables were constructed in real time by the
prototype implementation from off-the-air monitor headers collected over a
several-hour period on a busy evening. Each node table entry requires 30 bytes
and each link table entry four bytes. The maximum size of the node table is
presently 100 entries, while that of the link table is 300 entries. The data
base illustrated in the example has 42 entries in the node table and 46
entries in the link table.

The node table and link table together contain all the information necessary
to construct a network graph, as well as calculate the shortest path on that
graph between any two end stations, not just those involving the Wiretap
station. Note, however, that the Wiretap station does not in general hear all
other stations on the channel, so may choose suboptimal routes. In practice in
the Washington, DC, area, most stations use a digipeater, which is in general
heard reliably by other stations in the area. Thus, a Wiretap station can
eventually capture routes to almost all other stations using the above tables
and the routing algorithm described later.

The Wiretap Routine

The wiretap routine is called to process each monitor header. It extracts each
callsign from the header in turn and searches the node table for corresponding
NID, making a new entry and NID if not already there. The result is a string
of NIDs, starting at the originating station, extending through a maximum of
eight digipeaters, and ending at the destination station. For each pair of
NIDs along this string the link table is searched for either the direct link,
as indicated in the string, or its reciprocal; that is, the direction towards
the originator.

The operations that occur at this point can be illustrated by the following
diagram, which represents a monitor header with apparent path from station 4
to station 6 via digipeaters 7, 2 and 9 in sequence. It happens the header was
heard by the Wiretap station (0) from station 2.

	       (4)     (7)     (2)     (9)     (6)
	   orig	o------>o<=====>o------>o------>o dest
				|
				|
				V
			       (0)
			     wiretap

Presumably, the fact that the header was heard from station 2 indicates the
path from station 4 to station 2 and then to station 0 is viable, so that each
link along this path can be marked "heard" in that direction. However, the
viability of the path from station 2 to station 6 can only be presumed, unless
additional evidence is available. If in fact the header is from an I or S
frame (but not a U frame), an AX.25 virtual circuit has apparently been
previously established between the end stations and the presumption is
strengthened. In this case each link from 4 to 6 is marked "synchronized" (but
not the link from 2 to 0).

Depending on the presence of congestion and hidden stations, it may happen
that the reciprocal path in the direction from station 6 to station 4 has
quite different link characteristics; therefore, a link can be marked heard in
each direction independently. In the above diagram the link between 2 and 7 is
marked heard in both directions. However, there is only one synchronized mark,
which can be set in either direction. If a particular link is not marked
either heard or synchronized, any presumption on its viability to carry
traffic is highly speculative (the frame is probably a beacon). If later
marked synchronized the presumption is strengthened and if later marked heard
in the reciprocal direction the presumption is confirmed.

Experience shows that a successful routing algorithm for the packet-radio
channel must have provisions for congestion avoidance. There are two
straightforward ways to cope with this. The first is a static measure of node
congestion based on the number of links in the network graph incident at each
node. This number is computed by the wiretap routine and stored in the node
table as it adds entries to the link table.

The second, not yet implemented, is a dynamic measure of node congestion which
tallies the number of link references during the most recent time interval (of
specified length). The current plan was suggested by the reachability
mechanism used in the ARPANET and the Exterior Gateway Protocol. An eight-bit
shift register for each node is shifted in the direction from high-order to
low-order bits, with zero-bits preceeding the high-order bit, at the rate of
one shift every ten seconds. If during the preceeding ten-second period a
header with a path involving that node is found, the high-order bit of the
register is set to one. When a path is calculated the number of one-bits in
the register is totalled and used as a measure of dynamic node congestion.
Thus, the time interval specified is 80 seconds, which is believed appropriate
for the AX.25 channel dynamics.

Factors and Weights

The data items produced by the wiretap routine are processed to produce a set
of factors that can be used by the routing routine to develop optimal routes.
In order to insure a stable and reliable convergence as the routing algorithm
constructs and discards candidate paths leading to these routes, the factor
computations should have the following properties:

1. All factors should be positive, monotone functions which increase in value
   as system performance degrades from optimal.

1. The criteria used to estimate link factors should be symmetric; that is,
   their values should not depend on the particular direction the link is
   used.

2. The criteria used to estimate node factors should not depend on the
   particular links that traffic enters or leaves the node.

Each factor is associated with a weight assignment which reflects the
importance of the factor in the total path calculation, with the larger values
indicating greater importance. The weighted sum of factors is thus a metric
and represents the quantity to be minimized in the routing computation.
Obviously, the success of this method depends on cleverly (i.e.
experimentally) determined factor computations and weight assignments. 

The particular choices used in the prototype implementation should be
considered educated first guesses that might be changed, perhaps in dramatic
ways, in later implementations. Nevertheless, the operation of the algorithm
in finding optimum routes over all choices in factor computations and weights
is unchanged. Recall that the wiretap routine generates data items for each
node and link heard and saves them in the node and link tables. These items
are processed by the routing routine to generate the factors shown below in
Table 1 and Table 2.

	Factor	Weight	Name		How Determined
	----------------------------------------------------------------
	f0	30	hop		1 for each link
	f1	15	unverified	1 if not heard in either direction
	f2	5	non-reciprocal	1 if not heard in both directions
	f3	5	unsynchronized	1 if no I or S frame

				Table 1. Link Factors

	Factor	Weight	Name		How Determined
	----------------------------------------------------------------
	f4	5	complexity	1 for each incident link
	f5	5	congestion	(see text)

				Table 2. Node Factors

With regard to link factors, the "hop" factor is assigned as one for each link
and represents the bias found in other routing algorithms of this type. The
intent is that the routing mechanism degenerate to minimum-hop in the absence
of any other information. The "unverified" factor is assigned as one if the
heard bit is not set for either direction and zero otherwise, while the
"non-reciprocal" factor is assigned as one if the heard bit is not set for
both directions. The "unsynchronized" factor is assigned as one if the
synchronized bit is not set (no I or S frames observed in either direction).

With regard to node factors, the "complexity" factor is computed as the number
of links heard on the direction to the node, while the "congestion" factor
(not yet implemented) is to be computed as the number of intervals in the
eight ten-second intervals preceding the time of observation in which a frame
was transmitted to or through the node. For the purposes of path-weight
calculations, both of these factors are taken as zero for the endpoint nodes,
since their contribution to any path would be the same.

The Routing Routine

The dynamic data base built by the wiretap routine is used by the routing
routine to compute routes as required. Ordinarily, this needs to be done only
when the first frame to a new destination is sent and at intervals thereafter,
with the intervals perhaps modulated by retry count together with congestion
thresholds, etc. The technique used is a variation of the shortest-path-first
algorithm used in the ARPANET and elsewhere. It operates by constructing a set
of candidate paths on the network graph, each assigned the weighted sum of the
node and link factors along the path. Construction continues until all of the
minimum-weight complete paths are found (each of the same minimum weight),
which are the optimum routes.

There are a number of algorithms to determine the mimimum-weight path on a
graph between two nodes with given metric. The prototype implementation
operates using a dynamic list of entries derived from the link table. Each
list entry includes the from-NID and to-NID of a link in the path, along with
the current accumulated path weight from the from-NID to the final destination
NID of the path.

The algorithm starts with an empty list and the final destination NID. It
scans the link table for all links with either to-NID or from-NID matching
the final destination NID, updates the path weights based on the link factors
and node factors of the to-NIDs and adds them to the list. Next, the algorithm
selects the first entry in the list and scans the node table again for all
links with from-NID matching the to-NID of this entry, updating the path
weights as it proceeds. The algorithm coontinues to select succeeding entries
and scan the link table until no further entries remain to be processed. In
order to prevent a size explosion in the list, duplicates are suppressed along
with potential loops (new entries with a from-NID matching the to-NID of an
existing entry).

If the Wiretap station NID is found in the from-NID of a link to be added to
the list a complete path has been found. The algorithm remembers the minimum
path weight of all complete paths found as it proceeds. If the accumulated
path weight found on any subsequent path exceeds this, the path is abandoned
and no further list entries made for it. At the completion of processing the
minimum-weight complete paths have been determined with the first one
found identified as the optimum route. However, the path must be reversed,
since it was constructed backwards starting at the destination. At
the same time the callsigns can be extracted from the node table to build the
TAPR-1 command line.

Some idea of the time and space complexity of the routing routine can be
determined from the observation that the example below with 42 nodes and 46
links requires 27 list entries, each of which requires a scan of up to 46
links and a search (for duplicates and loops) of up to 27 list entries, and is
thus roughly linear in the number of links and quadratic in the number of
hops. The number of links is roughly somewhere between linear and quadratic in
the number of nodes, so that processing resources can become strained if the
number of nodes grows very large. The prototype implementation requires about
283 milliseconds on an LSI-11/73 to calculate the routes to all 42 nodes.

An Example

An example will illustrate how Wiretap constructs optimum routes given
candidate node and link tables. The candidate tables resulted from a scenario
monitoring normal traffic on the 145.01-MHz AX.25 packet-radio channel in the
Washington, DC, area on a weekend evening. The node and link tables
illustrated below give an idea of what the constructed data base looks like,
as well as provide the basis for the example.

Figure 1 illustrates a candidate node table showing the node ID (NID),
callsign and related information for each node in the order collected. The
Route field contains the digipeater route, as a string of NIDs, on a
minimum-weight path to that station, except for the last one, which is the
station NID itself. The absence of a route string indicates the station is
directly reachable without the assistance of a digipeater. The Wgt field shows
the total path weight of the route string shown, while the Links field
contains the complexity factor f5. The contents of the remaining fields can be
ignored. Note that the first four entries of the table are wired; that is,
they were initialized with defaults before Wiretap was started.

NID Callsign	IP Address	Flags	Links	Last Rec    Wgt   Route
-----------------------------------------------------------------------
0   W3HCF    	[128.4.1.1]	000	14	00:00:00    0	  1
1   WB4JFI-5 	[128.4.1.2]	006	15	16:37:56    40	 
2   W4HCP    	[128.4.1.3]	000	0	00:00:00    0	  1
3   WD5DBC   	[128.4.1.4]	000	0	00:00:00    0	  1
4   DPTRID   	[0.0.0.0]	000	1	00:00:00    155	  1
5   K4KMC    	[0.0.0.0]	007	0	14:46:39    40	 
6   WD4BAV   	[0.0.0.0]	000	1	00:00:00    115	  5 7
7   K4ARO-1  	[0.0.0.0]	006	1	14:46:39    75	  5
8   WB2RVX   	[0.0.0.0]	007	3	16:25:42    85	  18
9   W3IWI    	[0.0.0.0]	007	6	16:37:44    40	 
10   WB4APR-6 	[0.0.0.0]	007	9	16:25:45    40	 
11   KB5ZU    	[0.0.0.0]	000	1	00:00:00    170	  1
12   WB6RQN   	[0.0.0.0]	003	0	16:33:17    40	 
13   BEACON   	[0.0.0.0]	000	3	00:00:00    80	  16
14   KA4USE-1 	[0.0.0.0]	007	8	15:57:59    40	 
15   MAIL     	[0.0.0.0]	000	1	00:00:00    125	  10
16   WA4TSC   	[0.0.0.0]	003	0	15:21:45    40	 
17   CQ       	[0.0.0.0]	000	1	00:00:00    80	  5
18   KS3Q     	[0.0.0.0]	007	2	16:25:47    40	 
19   WB2MNF   	[0.0.0.0]	006	2	15:05:05    120	  10
20   KC2TN    	[0.0.0.0]	007	3	15:05:05    85	  18
21   AK3P     	[0.0.0.0]	007	1	14:00:07    130	  24 22
22   AK3P-5   	[0.0.0.0]	006	4	14:00:07    80	  24
23   KC3BN    	[0.0.0.0]	007	2	05:42:41    80	  24
24   WA3KXG-6 	[0.0.0.0]	007	2	05:42:41    40	 
25   KA4USE   	[0.0.0.0]	003	0	15:57:57    115	  14
26   TEST     	[0.0.0.0]	000	1	00:00:00    110	  9
27   K4NGC    	[0.0.0.0]	007	0	15:14:51    40	 
28   KA3KIW   	[0.0.0.0]	007	1	11:39:26    85	  29
29   KA3DBK   	[0.0.0.0]	007	2	16:21:08    40	 
30   K3SLV    	[0.0.0.0]	007	1	13:17:19    40	 
31   W3HCE    	[0.0.0.0]	000	3	00:00:00    80	  30
32   W3VH     	[0.0.0.0]	007	0	12:49:21    40	 
33   KE4TZ    	[0.0.0.0]	003	1	13:11:27    90	  29
34   WA4QNO   	[0.0.0.0]	000	1	00:00:00    165	  5 7 35
35   K4UMI-5  	[0.0.0.0]	002	1	14:43:26    120	  5 7
36   WB4FJI-5 	[0.0.0.0]	002	1	14:45:41    80	  27
37   WA4SZK   	[0.0.0.0]	000	1	00:00:00    210	  5 7 38 39
38   K4LKQ-1  	[0.0.0.0]	002	1	14:46:39    120	  5 7
39   W4ULH-1  	[0.0.0.0]	002	1	14:46:39    165	  5 7 38
40   WB4FQR-4 	[0.0.0.0]	006	1	15:05:25    75	  27
41   N4SN     	[0.0.0.0]	007	0	15:47:25    145	  1
42   KX3C     	[0.0.0.0]	002	2	16:21:08    40	 

		Figure 1. Candidate Node Table

Figure 2 illustrates a candidate node table showing the from-NID, to-NID and
associated information for each link in the order collected. In the Flags
field, which is in octal format, bit 1 (numbering from the rightmost bit,
which is bit 0) is the heard bit, bit 2 the synchronized bit and bit 7 the
reciprocal bit. The remaining bits and fields can be ignored.

From	To	Flags	Age		From	To	Flags	Age
---------------------------		---------------------------
1	0	002	3		1	4	002	3
5	0	002	104		5	7	007	104
7	6	006	255		10	0	002	19
8	10	207	15		10	9	207	43
9	1	207	4		1	11	000	41
12	1	003	8		1	14	206	8
14	13	003	8		14	0	002	40
1	10	002	4		10	15	002	4
10	13	002	57		12	0	002	237
16	0	002	72		16	13	003	72
5	17	003	255		18	0	002	15
18	10	207	15		10	20	006	87
20	19	207	87		18	9	003	255
19	10	006	87		21	22	207	146
22	10	206	146		10	21	004	255
24	0	002	255		23	22	007	255
22	24	206	255		24	23	207	255
23	9	006	255		9	22	006	146
25	14	203	40		18	1	003	15
9	26	002	255		9	8	006	43
27	1	207	78		27	0	002	79
29	0	002	19		28	29	007	255
29	1	207	62		1	28	006	255
30	0	002	185		30	31	007	185
32	0	002	211		32	1	207	211
29	18	207	72		33	29	003	191
29	14	202	191		14	33	002	196
18	20	203	157		18	8	203	158
9	0	002	152		5	10	003	109
10	31	002	109		5	1	003	109
5	31	003	108		5	30	003	108
7	35	002	107		35	34	002	107
27	36	003	104		36	9	002	104
27	14	207	81		14	9	006	40
7	38	002	104		38	39	002	104
39	37	002	104		27	40	007	87
40	1	206	83		41	1	207	49
29	42	207	19		42	0	002	19

		Figure 2. Candidate Link Table

The following example shows how Wiretap operates to compute the optimum route
with respect to the factor computations and weights previously described. The
example also shows how the procedure reacts to congested nodes by routing
around them.

The route to be computed involves the Wiretap station W3HCF (NID 0) and
station AK3P (NID 21). As it turns out, the latter is not direclty reachable
from W3HCF, but is indirectly reachable via other stations, including W3IWI
(NID 9), WB4APR-6 (NID 10), AK3P-5 (NID 22) and WA3KXG-6 (NID 24). Some
possible paths that might be considered include those in the following
diagrams (the NID is shown above the node and the complexity factor below):

		       (0)     (10)    (21)
		(1)	o-------o-------o
			0	9	0

		       (0)     (24)    (22)    (21)
		(2)	o-------o-------o-------o
			0	2	4	0

		       (0)     (9)     (22)    (21)
		(3)	o-------o-------o-------o
			0	6	4	0

A minimum-hop algorithm would chose the first path (1) as the optimum on the
basis that it has the least number of hops; however, node 10 is a very busy
digipeater and is often congested, as suggested by the complexity factor of 9.
The other two paths (2) and (3) are one hop longer, but have lower complexity
factors. Actually, the choice can go either way depending upon the link
factors, which are not shown in the diagrams.

Following is the result of a step-by-step analysis of the routing algorithm as
it constructs the optimum route. The contents of the list used by this
algorithm are shown at each step along with the factors used to calculate the
path weight. The Incr field shows the incremental weight computed for the
entry, while the Total field shows the accumulated total path weight. Only the
From, To and Total fields are actually stored in the list.

First, the algorithm scans the link table for links leading to the destination
21, which results in two entries in the list:

From	To	f0	f1	f2	f3	f4	Incr	Total
---------------------------------------------------------------------
22	21	30	0	0	0	0	30	30
10	21	30	15	5	0	0	50	50

Since the Wiretap station 0 is not found in the From field, the link table is
scanned again for links leading to 22, which causes the following entries to
be added to the list:

10	22	30	0	0	0	20	50	80
23	22	30	0	5	0	20	55	85
24	22	30	0	0	0	20	50	80
9	22	30	0	5	0	20	55	85

The link table is scanned again for links leading to 10, which causes the
following entries to be added:

0	10	30	0	5	5	45	85	135
8	10	30	0	0	0	45	75	125
9	10	30	0	0	0	45	75	125
1	10	30	0	5	5	45	85	135
15	10	30	0	5	5	45	85	135
13	10	30	0	5	5	45	85	135
18	10	30	0	0	0	45	75	125
20	10	30	0	5	0	45	80	130
19	10	30	0	5	0	45	80	130
5	10	30	0	5	5	45	85	135
31	10	30	0	5	5	45	85	135

The result is a complete path of total weight 135, which is up to this point
the minimum-weight complete path. However, the algorithm may yet find a
complete path of less weight. The next entry in the list is 10, which has
already been processed, so the algorithm tries the next entry 23, which has
not been processed, and then entry 24 after that, which results in the
following additions to the list:

9	23	30	0	5	0	10	45	110
24	23	30	0	0	0	10	40	95
0	24	30	0	5	5	10	50	130

Another complete path has been found, this one of total path weight 130, which
is now the minimum of all found so far. Continuing, the algorithm scans the
link table for links leading to 9 and adds the following:

1	9	30	0	0	0	30	60	145
18	9	30	0	5	5	30	70	155
26	9	30	0	5	5	30	70	155
8	9	30	0	0	5	30	65	150
0	9	30	0	5	5	30	70	155
36	9	30	0	5	5	30	70	155
14	9	30	0	0	5	30	70	155

All of these paths have total weights greater than 130 and thus can never lead
to a complete path of weight less than that. Inspection of all remaining
entries in the list show that none of them can lead to a complete path of
weight less than 130, so the algorithm terminates at this point with the
declaration that the (reversed) optimum route is (2) in the diagram above. It
remains to be shown, however, that this route is indeed superior to the
minimum-hop route, but this can be determined only by experiment.

Data Base Housekeeping

As apparent from the example, Wiretap tends to pick up a good deal of what
might be called routing trash on the channel. It can happen that a station may
call any other station whatsoever, with the result that Wiretap may pick this
up and add speculative links to the data base. In practice, this happens
reasonably often as operators try various heuristic routes to stations that
may be shut down, busy or blocked by congestion. Nevertheless since Wiretap
operates entirely by passive monitoring, speculative links may represent the
principal means of discovery of new paths.

The number of speculative links can be expected to grow without limit as the
Wiretap station continues to monitor the channel. Eventually some sort of
garbage collection will be required, possibly based upon an activity timer.
The prototype implementation includes in every link table entry an activity
timer represented as a counter that is incremented once each minute and reset
to zero when the link is found in a monitor header. The intent is that, should
this counter exceed a threshold, say fifteen minutes, and the link is not
marked heard on either direction or synchronized, the link should be purged
from the data base. If this results in an isolated node; that is, one not
represented by any to-NID or from-NID in the link table, the node is purged as
well.

It is possible that a more agressive purging policy may be required for
exceptionally busy channels, especially if operation using active probes or
third-party routing is implemented. An effective way to manage this is on the
basis of the link factors, their weights and the activity timers, with the
rule that, among links with the highest weighted sum of link factors, the one
not heard for the longest time should be the first one purged from the data
base. Other heuristics may be useful as well.

Summary and Directions for Further Development

Wiretap represents an initial experiment and evaluation of the effectiveness
of passive monitoring in the management of the packet-radio channel. While
the results of initial experiments have been encouraging, considerable work
needs to be done in the optimization of factor computations and weight
assignments. For this to be done effectively, some experience needs to be
gained in the day-to-day operation of the prototype system during which
various combinations of weight assignments can be tried.

The next step in the evolution towards a fully distributed routing algorithm
is the introduction of active probing techniques. This should considerably
improve the capability to discover new paths, as well as to fine-tune
existing ones. It should be possible to implement an active probing mechanism
while maintaining compatibility with the passive-only Wiretap, as well as
maintaining compatibilty with other stations using no routing algorithms at
all.

A particularly difficult area for any routing algorithm is in its detection
and reponse to congestion. Some hints on how the existing Wiretap mechanism
can be improved are indicated in the text. Additional work, especially with
respect to the hidden-station problem, is necessary.

It is quite likely that the most effective application of routing algorithms
in general will be at the local-area digipeater sites. One reason for this is
that these stations may have off-channel trunking facilities that connect
different areas and may exchange wide-area routing information via these
facilities. The routing information collected by the local-area Wiretap
stations could then be exchanged directly with the wide-area sites.
