
This is an ORIGINAL file from P-80
Systems...



<< TSPS COIN CONTROL SIGNALS >>




from: <S><C><A><N><*><M><A><N>








Over the years several different methods of coin control have evolved to
meet the changing needs. In addition to coin collect, coin return, and ringback
the newer MW and expanded inband methods provide signals to control the
polarity of the battery applied to the coin telephone by the local office. The
ACTS and Calling Card Service features of TSPS make use of the additional
signals. In some cases two back-to-back signals spaced by a guard interval
(required to give the local office time to respond) are used. Guard intervals
are also neccesary between coin control signals, machine generated 
announcements, and certain other suprivisory signals.


There are FOUR different methods of coin control and ringback signaling
used from TSPS-TO THE LOCAL CENTRAL OFFICE. They are POLAR MARGINAL,
INBAND, MW, and EXPANDED INBAND SIGNALING (EIS) coin control. all but
polar marginal coin control can be used from a remote trunking arrangement
(RTA) to the local central office and can be used with E&M lead signaling on
other physical or carrier facilities. All four types of coin control can be
used with 2-wire physical facilities employing loop, high-low, reverse
battery signaling. In addition all fout types of coin control can be used with
all TSPS features (except RTA). However with Calling Card service, only MW and
EIS coin control provide DTMF pad and totalizer control without station set
modifications. For those of you that are unaware of the totalizers fuction
it is simply to keep track of the total coin input and has both a LOCAL and
TOLL mode.


There are two types of coin telephones manufactured by Western Electric used
for prepaid coin service. the older is COIN FIRST, the newer is DIAL TONE
FIRST.




COIN FIRST
---- -----


These coin phones use a negative battery supply (usually -48 voltson the
ring and ground on the tip but can be other voltages,eg, when range extenders
are not used) from the local central office. They do not require a positive
battery supply (+48 volts on the ring and ground on the tip). If equipped
with DTMF, the DTMF pad is diabled unless an initial deposit equal to the
local rate has been made. When the deposite is collected or returned, the
DTMF pad is again placed in the disabled state. A feature called coin
return has been provided for DTMF pad enablement with coin first telephones
and is required for Calling Card service.




Dial Tone First
---- ---- -----


These coin telephones initially have the DTMF pad enabled and a negative
battery supplied similar to the coin first telephones. However, the negative
battery places the coin totalizer in the C-series sets in local mode,ie, the
readout does not occur until an amount equal to the initial rate s deposited.
This can result in composite coin signals which may not be recognized by
operators or ACTS. In D-series sets the negative battery gives the DTMF pad
priority over coin signals! Thus pad operation during coin deposite may
result in coin signal errors at the TSPS.


A positive battery supply (+48 volts on the ring and ground on the tip) is
neede from the local central office when acoin deposite is requested by
TSPS. The positive battery supply changes the coin totalizer in the
C-series sets to the TOLL MODE, so that coin deposites of any denomination
cause an immediate readout which can be detected by an operator or ACTS
equipment. In the D-series sets, it gives priority to the coin deposites
thus preventing DTMF pad interference. The positive battery supply also dia
bles the DTMF pad on ALL BUT TYPE D of dial tone first type fones. Disabling
the DTMF pad during coin deposites prior to ACTS was desirable to PREVENT
SIMULATION OF COIN TONES WITH THE PAD!!!!!  However, with ACTS the coin
tone recievers used at TSPS will not respond to DTMF signals so the DTMF pad
disabling function is no longer neccesary.


NOTE: If a positive battery were applied to an A-series coin first
telephone, the DTMF pad and coin totalizer would fail to function.




Now we shall discuss in some detail the four types of coin control.


POLAR MARGINAL COIN CONTROL
----- -------- ---- -------


(signals)


<1> The polar marginal coin control uses the following signals for coin
control and ringback.


(a) COIN COLLECT: +130 volts tip and -48 volts ring


(b) COIN RETURN: -48 volts tip and +130 volts ring


(c) RINGBACK: ground on tip and -48 volts ring and ground on ring for 50 to
100 milliseconds alternatly for the duration of the ringback signal
(approx: 2-2.5 seconds). RINGBACK PROTOCOL: When ringback is used at the
end of a call, the signal is repeated up to five times or untill off-hook
suprivision from the local office is detected. The siganals are spaced at
approxamately 4-second intervals. If the local office remains on-hook after
five ringback signals have been sent,TSPS sends a coin return signal
and then releases the connection (goes on-hook toward the local office). The
release back will occur no sooner than 300 milliseconds after the coin control
signal.




<2> INBAND COIN CONTROL


(signals)


Inband coin control uses MF signals to control coins and ringback the coin
station as follows:


(a) COIN COLLECT: 700+1100 HZ


(b) COIN RETURN: 1100+1700 HZ


(c) RINGBACK: 700+1700 HZ


An on-hook wink (off-hook,on-hook,off-hook) of 70 to 130 milliseconds is sent 
(50 to 100 in duration when recieved) from the TSPS equipment to alert the 
local central office to prepare a reciever for the MF signal that begins 95 to 
195 milliseconds after the end of the wink. The MF signal will persist for
approxamately 1 second for COLLECT & RETURN and 2 second for RINGBACK. The
reciever requirements are are the same as for regular MF pulsing. RINGBACK
PROTOCOL: The ringback protocol is the same as described in the POLAR MARGINAL
coin control. It is used in step-by-step,NO.5 crossbar,NO.3ESS,and
NO.5ESS switching equipment.




I would like to take this oportunity to remind you this is an original file
from P-80 Systems, and credits should not be removed from this file when
posting on other systems!!!




<3> MW COIN CONTROL


MW coin control uses multiple on-hook wink signals sent from TSPS to a local
central office. It is used in step-by-step,NO.5 crossbar,NO.3ESS and
NO.5ESS switching systems, and by DMS-10 and DMS-100F digital switching
systems. In addition to providing coin collect,coin return and ringback
signals, this signaling format provides two additional signals, called
OPERATOR-ATTACHED and OPERATOR-RELEASED. the operator-attached signal is used 
with dial tone first coin telephones to instruct the local office to change the
mode of the coin totalizer or coin signaling priority to the TOLL mode by
application of positive battery to the coin telephone (see first two
paragraphs of this article). IT is not sent the first time a coin call is
forwarded to TSPS ((contrary to:Notes On Distance Dialing 1975)for those of
you that have it) because the local central office is expected to connect a
coin call to the TSPS in the OPERATOR-ATTACHED condition. However, the  
operator-attached signal is sent before each subsequent TSPS attachment
requiring a coin deposite. The OPERATOR-RELEASED signal (negative
battery supplied to the payphone) restores the coin totalizer or coin
signaling priority to the LOCAL mode and and enables the DTMF pad on certain
payphones. The OPERATOR-RELEASED signal is sent whenever TSPS releases from a
connection having a positive battery applied to the payphone. It is also
sent upon initial connection to a 0+ coin call on a DIAL-TONE-FIRST trunk
when the trunk provides for calling card service!!!


(signals)


The MW signaling format uses a series of 1 to 5 suprivisory on-hook winks
from the TSPS to the local office outgoing trunks. The signals and there
functions are as follows:


Number of              Use or
on-hook winks          Function


1
OPERATOR-RELEASED
2
OPERATOR-ATTACHED
3                      COIN COLLECT
4                      COIN RETURN
5                      RINGBACK


The wink on-hook intervals as sent by the TSPS are 70 to 130 milliseconds and
the wink off-hook intervals are 95 to 150 milliseconds. To allow for pulse
distortion, the local central office trunk should be CAPABLE of operating
with on-hook intervals from 50 to 150 milliseconds spaced from 75 to 185
milliseconds apart when recieved !!!


At the end of a wink signal, the TSPS will allow time for the locale central
office to complete detection and application of the signal before
sending a new signal. The minimum interval after sending a signal by TSPS
and the maximum time in which the local central office (CO) must detect and
apply the signal are as follows:




. . . . . . . . . . . . . . . . . . . . . . . . . . .
.                 SUBSEQUENT            LOCAL OFFICE.
.             TSPS GUARD INTERVALS      WORK TIME   .
.TSPS SIGNAL       (minimum)            (maximum)   .
. . . . . . . . . . . . . . . . . . . . . . . . . . .
.                                                   .
.oper.-attached    500-MS               380-MS      .
.                                                   .
.oper.-released    500-MS               380-MS      .
.                                                   .
.coin collect      1.1 seconds          880-MS      .
.                                                   .
.coin return       1.1 seconds          880-MS      .
.                                                   .
.ringback          2.4 seconds          2.1 seconds .
.                                                   .
.MS= Milliseconds                                   .
. . . . . . . . . . . . . . . . . . . . . . . . . . .


RINGBACK PROTOCOL: is the same as with
MARGINAL POLAR ringback protocol.




<4> EIS COIN CONTROL


As with INBAND COIN CONTROL, EIS (expanded inband service) coin control
uses an on-hook wink to alert the local central office that MF tones will be
sent (to elaborate the wink serves the same function as KP when boxing, it
simply tells the system that digits (MF tones) will be sent). IT is used in the
NO. 1/1A ESS, NO.2/2B ESS, and NO.5 ESS switching systems, and the DMS-100F
digital switching systems. With EIS, the wink is being extended to produce
an on-hook of between 325 and 425 milliseconds (300 and 450 milliseconds
when recieved). In addition the interval between the end of the wink
signal and the start of the MF tones is being lenthend to a value of between
770 and 850 milliseconds while the duration of the tones is being
reproduced to a value of between 480 and 700 milliseconds.


(signals)


TSPS is able to work with EIS after TSPS GENERIC 1T10 or GENERIC 1BT1 is
installed. (GENERIC PROGRAM (software)=a set of instructions for an electronic
switching system that is the same for all offices using that type of
switching system. Detailed differences for each individual office will occur).
The first instalation of this program occured in mid-1980. Each TSPS in use
today should now have this change. The actual signaling is as follows:




. . . . . . . . . . . . . . . . . . . .. . . . . . . . .
.                                      SUBSEQUENT TSPS .
.     FUNCTION      MF FREQUENCIES     GUARD INTERVAL  .
. . . . . . . . . . . . . . . . . . . . . . . . . . . . .
.                                                       .
.oper.-released     900 + 1500 (HZ)     600 milliseconds.
.                                                       .
.oper.-attached     1300+ 1500 (HZ)     600 milliseconds.
.                                                       .
.coin collect       700 + 1100 (HZ)     2 seconds       .
.                                                       .
.coin return        1100+ 1700 (HZ)     2 seconds       .
.                                                       .
.ringback           700 + 1700 (HZ)     2 seconds       .
.                                                       .
.coin collect &     1500+ 1700 (HZ)     2 seconds       .
.oper.-released                                         .
. . . . . . . . . . . . . . . . . . . . . . . . . . . . .


EIS also provides operator attached and operator released signals as does MW
(multiwink) coin control. However in eis a coin station innitiating a 0+,0-
or non-chargable call on a trunk providing CALLING CARD SERVICE is
initially connected to the TSPS with negative battery applied to the
station. AS with the other signaling methods, 1+ calls are initially
connected with positive battery applied. THE operator attached signal
is sent whenever the TSPS is connected for a coin deposit, and the operator
released signal is sent whenever the TSPS is released from a connection
having positive battery applied to the coin station. There is a new signal not
available with MW, which is combined coin collect operator released. This
signal which causes the local office to collect coins then apply negative
battery to the coin station, is currently used for interim overtime
collections still in the talking state. RINGBACK PROTOCOL: EIS uses a different
ringback protocol than the other coin control signaling methods. The TSPS
sends one ringback signal. The local office applies standard ringing (2
seconds on, 4 seconds off) to the station and an audible ring toward the
TSPS until the station answers or TSPS is released and recieved. The TSPS
times for 30-36 seconds waiting for an answer. If answer is not recieved TSPS
releases back. The local office performs a coin return before releasing
the coin station. If answer is recieved and coin control signal sent, release
back will not occur until at least 300 milliseconds after completion of the
signal.


IN CLOSING--


I sincerly hope that this article has been of some assistance to all.
Remember this is another original file from P-80 Systems &


<S><C><A><N><*><M><A><N>


