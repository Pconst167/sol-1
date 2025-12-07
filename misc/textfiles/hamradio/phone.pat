From telecom@eecs.nwu.edu Wed Aug  7 00:47:09 1991
Received: from hub.eecs.nwu.edu by gaak.LCS.MIT.EDU via TCP with SMTP
	id AA19091; Wed, 7 Aug 91 00:46:57 EDT
Resent-Message-Id: <9108070446.AA19091@gaak.LCS.MIT.EDU>
Received: from trout.nosc.mil by delta.eecs.nwu.edu id aa29672;
          5 Aug 91 8:43 CDT
Received: by trout.nosc.mil (5.59/1.27)
	id AA15410; Mon, 5 Aug 91 06:40:37 PDT
Received: by jartel.info.com (/\=-/\ Smail3.1.18.1 #18.7)
	id <m0k758G-00018IC@jartel.info.com>; Mon, 5 Aug 91 06:38 PDT
Received: by denwa.info.com (5.59/smail2.5) with UUCP
	id AA10327; 5 Aug 91 06:28:44 PDT (Mon)
Received: by denwa.info.com (5.59/smail2.5) with UUCP
	id AA10322; 5 Aug 91 06:28:28 PDT (Mon)
Received: by bongo.info.com (smail2.5)
	id AA04642; 5 Aug 91 06:20:12 PDT (Mon)
Reply-To: julian@bongo.info.com
X-Mailer: Mail User's Shell (6.4 2/14/89)
To: telecom@eecs.nwu.edu
Subject: Phone Patches
Message-Id: <9108050620.AA04638@bongo.info.com>
Date: 5 Aug 91 06:20:06 PDT (Mon)
From: Julian Macassey <julian@bongo.info.com>
Resent-Date:  Tue, 6 Aug 91 23:50:11 CDT
Resent-From: telecom@eecs.nwu.edu
Resent-To: ptownson@gaak.LCS.MIT.EDU
Status: RO

Dear Patrick,
Here is an article I wrote about phone patches. If you think it is
worth it, stuff it in the archives.

------cut, slash, deforest ----------------------

                BUILDING AND USING PHONE PATCHES 

     From simple to elegant, patches help make the connection


                               By

                     Julian Macassey, N6ARE

              First Published in Ham Radio Magazine
                          October 1985.


     In  telephone  company parlance, a patch is  any  connection 
between  a phone line and another communications device,  whether 
it be a radio, a tape recorder, a data device (such as a  modem), 
or even another phone line.

     Radio Amateurs, on the other hand, tend to limit the meaning 
of "patch" to the connection of transmitters or receivers to  the 
phone  line  for phone conversations.  But there's more to  it  - 
Amateurs  can  and do use phone patches for purposes  other  than 
telephone conversations.  One particularly effective  application 
is   for  checking  TVI  and  RFI  complaints;  simply  set   the 
transmitter on VOX, go to the site of the interference complaint, 
and  then  key your transmitter via the phone line.   Doing  this 
will indicate whether your transmitter is or is not the source of 
the  problem.   If  it is, you can use this method  to  test  the 
measures you've taken to correct the problem.

     A  phone line is, simply speaking, a 600-ohm  balanced  feed 
device  - which also happens to be how professional audio can  be 
described.    Most  modern  Amateur  transmitters  have   600-ohm 
unbalanced  inputs;  most  cassette  recorders  have  a   600-Ohm 
unbalanced  input;  the "tape" outputs on home stereos  are  also 
600-ohm  unbalanced.  All this makes patching relatively  simple.  
While there are various degrees of sophistication and  complexity 
in patching, in an emergency, patches can be easily put  together 
using  readily available components.  Before starting to build  a 
patch, however, it might be helpful to read last month's  article 
on understanding phone lines.


The Simple Patch

     The  simplest way to patch a phone line to another piece  of 
equipment  is  to use a couple of capacitors to block  the  phone 
line  DC.   While this simple approach will work in a  pinch,  it 
will  tend to introduce hum to the line because of the  unbalance 
introduced.  The capacitors used should be nonpolar, at least  2-
ohm F, and rated at 250 volts or better (see fig.1).

     To  hold  the line, the patch should provide a  DC  load  by 
means  of  a resistor (R6) or by simply leaving a phone  off  the 
hook.  The receiver output may need a DC load (R7) to prevent the 
output stage from "motorboating."  Use two capacitors to maintain 
the balance.

     With all patches hum can be lessened by reversing the  phone 
wires.  A well-made patch will have no discernible hum.


The Basic Phone Patch

     Because  a phone line is balanced and carries DC as well  as 
an  AC signal, a patch should include a DC block, a balun, and  a 
DC load to hold the line.  The best component for doing this is a 
600-ohm 1:1 transformer such as those used in professional  audio 
and for coupling modem signals to the phone line, available  from 
most electronics supply houses.  Old telephone answering machines 
are   also   a  good  source  of  600-ohm   transformers.    Some 
transformers are rated at 600-900 ohms or 900-900 ohms; these are 
also  acceptable.   Make sure that the transformer  has  a  large 
enough  core,  because  DC current will be  flowing  through  it.  
(Some  small-core transformers become saturated and  distort  the 
signal.) 

     In section 68.304 of the FCC Part 68 regulations, it  states 
that  a coupling transformer should withstand a 60 Hz 1kV  signal 
for one minute with less than 10 mA leakage.  For casual use this 
may seem unimportant, but it provides good protection against any 
destructive  high voltage that may come down the phone line,  and 
into  the  Amateur's equipment.  A 130 to 250  volt  Metal  Oxide 
Varistor  (MOV)  across  the  phone  line  will  provide  further 
protection if needed.  

     The  DC resistance of the transformer winding may be so  low 
that  it hogs most of the phone line current.   Therefore,  while 
using  a phone in parallel for monitoring and dialing - which  is 
recommended  -  the audio level on the incoming line may  be  too 
low.   Resistors  R1A  and R1B (see fig.2) will  act  as  current 
limiters  and allow the DC to flow through the phone  where  it's 
needed.    If   possible,  these  resistors  should   be   carbon 
composition types.

     To  keep  the line balanced, use two resistors of  the  same 
value  and adjust the values by listening to the dial tone  on  a 
telephone  handset.  There should be little or no drop in  volume 
when the patch transformer is switched across the phone line.

     One  of these transformers, or even two capacitors,  can  be 
used to patch two phone lines together, should there be a need to 
allow  two  distant parties to converse.  There  will  be  losses 
through the transformer so the audio level will degrade, but with 
two good connections this will not be a problem.

     On the other side of the transformer - which could be called 
the  secondary winding - choose one pin as the ground and  attach 
the shields of the microphone and headphone cables to it.  Attach 
the inner conductors to the other pin.  The receiver output  will 
work  well into the 600-ohm winding, and if transmitting  simplex 
or  just  putting  receiver audio on the line there  will  be  no 
crosstalk  or  feedback  problems.   In  some  cases,  the  audio 
amplifier  in a receiver does not have enough output to feed  the 
phone line at an adequate level; this can be handled by using the 
transformer with two secondaries (see the "improved" patch below) 
or by coupling a 8:1 kilohm transformer between the audio  output 
and  600-ohm transformer.  If RF is getting into the  transmitter 
input, a capacitor (C1) across the secondary should help.  A good 
value  for the lower bands and AM broadcast interference  is  0.1 
uF.   For  higher frequencies, 0.01 uF usually gets  rid  of  the 
problem.  Unshielded transformers are sensitive to hum fields and 
building  any patch into a steel box will help alleviate  hum  as 
well as RFI.


The Improved Phone Patch

     Several enhancements can be made to the basic phone patch to 
improve  operation.  The first is the addition of  a  double-pole 
double-throw switch to reverse the polarity of the phone line  to 
reduce  hum.  This may not be necessary with a patch at the  same 
location  with the same equipment, but if it is, experiment  with 
the  polarity of the transformer connections and adjust  for  the 
least  hum.   Most of the time the balance will be so  good  that 
switching  line polarity makes no difference.  The switch  should 
have a center "off" position or use a separate double-pole single 
throw switch to disconnect from the line.  The two secondaries on 
the  "improved"  patch (fig.3) should be checked for  balance  by 
connecting  the  receiver and transmitter and  checking  for  hum 
while  transmitting and receiving.  Switch the shield  and  inner 
conductors of the secondaries for minimum hum.

     Many transmitters do not offer easy access to the microphone 
gain control.  There may also be too much level from the patch to 
make  adjustment of the transmit level easy.  Placing R10  across 
the  transformer allows easy adjustment of the level.  It can  be 
set  so  that when switching from the station microphone  to  the 
patch the transmitter microphone gain control does not need to be 
adjusted.   This  will  also  work  on  the  basic  600-ohm   1:1 
transformer.   Most  of  the  time a  1  kilohm  potentiometer  - 
logarithmic  if  possible  - will work well.  If  not,  a  linear 
potentiometer  will  do. A 2.5kilohm  potentiometer  may  provide 
better control.


Deluxe Operation and VOX

     Using  VOX  with  a phone patch may  cause  a  problem  with 
receive  audio going down the line and into the  transmit  input, 
triggering the VOX.  There may not be enough Anti-VOX  adjustment 
to  compensate for this.  The usual solution for this problem  is 
to use a hybrid transformer, a special telephone transformer with 
a phasing network to null out the transmit audio and keep it  off 
the  receive line.  Most telephones employ a similar  transformer 
and circuit so that callers will not deafen themselves with their 
own voices.  These devices are called "networks" (see figs. 4 and 
5).

     A network can be removed from an old phone and modified into 
a  deluxe patch, or the phone can be left intact and  connections 
made  to  the line and handset cords.  The line  cord  should  be 
coupled to a 600-ohm 1:1 transformer  to keep the ground off  the 
line.   Note,  in the network schematics, that the  receiver  and 
transmitter  have a common connection; when coupling into  radios 
or other unbalanced devices, make this the ground connection.

     There may be confusion about terms used in the network.  The 
telephone  receiver  is receiving the phone line audio,  and  the 
transmitter is transmitting the caller's voice.  For phone  patch 
use,  a telephone receive line is coupled to the transmitter  and 
the  transmit line is coupled to the radio receiver.  This  is  a 
fast  way to put together  a phone patch and may be adequate  for 
VOX use.

     A better patch can be built by using a network removed  from 
a  phone or purchased from a local telephone supply house.   This 
approach  offers the added advantage of being able to  adjust  or 
null the sidetone.  The circled letters in figs. 4 and 6 refer to 
the  markings on the network terminal block.  These  letters  are 
common to all United States networks made by Western Electric (AT 
&  T), ITT, Automatic Electric, Comdial, Stromberg  Carlson,  and 
ATC.

     To  make  sidetone  adjustable, remove R4  (R5  in  European 
networks)  and  replace it with R11 (for  European  networks  use 
R12).   The Western Electric Network comes  point-to-point  wired 
and sealed in a can;  the other networks are mounted on PCBs.  To 
remove  R4 from the Western Electric network, the can has  to  be 
opened  by bending the holding tabs.  Don't be surprised to  find 
that  the network has been potted in a very sticky, odious  paste 
that has the texture of hot chewing gum and the odor of  unwashed 
shirts.  (This material - alleged to be manufactured according to 
a  secret formula - will not wash off with soap and  water.   The 
phone company has a solvent for it, but because one of the secret 
ingredients is said to be beeswax, ordinary beeswax solvents such 
as  gum  turpentine, mineral turpentine (paint thinner  or  white 
spirit)  and  kerosene  will work.)  To remove the  bulk  of  the 
potting  compound,  heat the opened can for 30 minutes in  a  300 
degree F (148 degree C) oven, or apply heat from a hot  hairdryer 
or heatgun.  You can also put the can out in the hot sun under  a 
sheet  of  glass.  Don't use too much heat  because  the  plastic 
terminal strip may melt.  Even with a film of compound  remaining 
on it, the network can be worked on.


Using a Patch

     For efficient use, a patch should have a telephone connected 
in parallel with it.  This enables the operator to dial,  answer, 
and  monitor  calls  to and from the patch, as well  as  use  the 
handset for joining in conversations or giving IDs.

     One useful modification to the control telephone is adding a 
mute  switch to the handset transmitter.  This allows  monitoring 
calls without letting room noise intrude on the line.  It's  also 
a  good modification for high noise environments,  where  ambient 
noise enters through the handset transmitter and is heard in  the 
receiver,  masking  the incoming call.   Muting  the  transmitter 
makes calls surprisingly easy to hear.  The mute switch can be  a 
momentary switch used as a "Push-To-Talk" (PTT) or a Single  Pole 
Single  Throw (SPST) mounted on the body of the phone  for  long-
term monitoring.  The switch should be wired as Normally  Closed, 
so  that the transmitter element is muted by shorting  across  it 
(see  fig.4).   This makes the mute "clickless." If  the  monitor 
phone uses an electret or dynamic transmitter it should still  be 
wired as shown in fig.4.

     Transmit  and receive levels on the phone line are a  source 
of  confusion  that  even  telephone  companies  and   regulatory 
agencies  tend  to  be vague about.  The  levels,  which  can  be 
measured  in  various ways, vary.  But all  phone  companies  and 
regulatory  agencies  aim for the same goals;  enough  level  for 
intelligibility,  but  not enough to cause crosstalk.   The  most 
trouble-free  way  to set the outgoing level on the patch  is  to 
adjust  the  feed onto the phone line until  it  sounds  slightly 
louder  than the voice from the distant party on the phone  line.  
If  the level out from the patch is not high enough, the  distant 
party will ask for repeats and tend to speak louder to compensate 
for  a "bad line."  In this case, adjust the level to  the  patch 
until  the other party lowers his or her voice.  The best way  to 
get a feel for the level needed is to practice monitoring on  the 
handset  by  feeding a broadcast station down the phone  line  to 
another  Amateur  who can give meaningful signal  reports.   It's 
difficult to send too much level down the phone while  monitoring 
because  the  signal  would  simply be  too  loud  to  listen  to 
comfortably.  The major problem is sending too little signal down 
the line.

     Coupling  the phone line into the radio transmitter  is  not 
much  more difficult than adjusting a microphone to work  with  a 
radio  transmitter.   Depending  on  the  setup,  the  RF  output 
indication  on  a wattmeter, the ALC on the transmitter  or  even 
listening  to the transmitted signal on a monitor  receiver  will 
help  in adjusting the audio into the radio  transmitter.   Phone 
lines  can  be  noisy,  and  running  too  much  level  into  the 
transmitter  and  relying on the ALC to set  the  modulation  can 
cause  a fair amount of white noise to be transmitted.   Watching 
the RF output while there are no voice or control signals on  the 
line  will  help  in  adjusting  for  this.   VOX  operation  can 
alleviate  the problem of noise being transmitted  during  speech 
pauses. 

     A  hybrid patch used for VOX operation needs to be  adjusted 
carefully  for  good performance.  If it has a  null  adjustment, 
this  should be set before adjusting the VOX controls.   Using  a 
separate receiver/transmitter setup is the easiest to adjust  the 
patch.    The  phone  line  should  be  attached  to   a   silent 
termination:  the  easiest way to do this is to dial  part  of  a 
number; another way to do it is call a cooperative friend.   Tune 
the  shack receiver to a "talk" broadcast station or use the  BFO 
as  a heterodyne.  With the transmitter keyed into a dummy  load, 
set  the  null  adjustment potentiometer R11  (R12  for  European 
phones)  for  a minimum RF output on the  transmitter.   Using  a 
transceiver, place an oscilloscope or audio voltmeter across  the 
microphone input terminals and, while receiving a signal,  adjust 
for  the  lowest voltage.  For proper operation,  it's  important 
that the phone be connected to the patch during these adjustments 
since  the  hybrid  relies  on  all  inputs  and  outputs   being 
terminated.


Reference

1. Julian Macassey, N6ARE, "Understanding Telephones," ham radio, 
September 1985, page  38


Bibliography

Rogers, Tom, You and Your Telephone, Howard W. Sams & Co.,  Inc., 
Indianapolis, Indiana 46206. ISBN No. 0-672-21744-9.

Bell System Technical Reference 48005; Telephones, January, 1980.

British  Standard  Specification  for  General  Requirements  for 
Apparatus for Connection to the British Telecommunications Public 
Switched Telephone Network.  BS 6305.

Certification  Standard  for  Voice-Type Terminal  Equipment  and 
Connectors, No.CS-01 and No.CS-03, Department of  Communications, 
Government of Canada.

FCC  Rules  and Regulations: Part 68 -  connection  of  Terminal 
Equipment  to  the Telephone Network,  United  States  Government 
Printing Office, 1982. 

                           End of Text
                      
                   ----------------------------


                    Fig 1. Simple Phone Patch

     Tip  \                   C5
     O----.\---o---------o----||----------O  
          .    |         |           
          .    |         /              
        S1.    |       R6\       Shielded
          .    |         /       Wire
     Ring \    |         |    C5 To Transmitter
     O---- \--------o----o----||---o------O  
               |    |              |
               |    |              |
               |    |            -----
               |    |             ---
               |    |              -
               |    |         C5
               |    |---------||---o------O
               |                   |
               |                   \ Shileded
               |                 R7/ Wire
               |                   \ To Receiver
               |              C5   |
               ---------------||---o------O
                                   |
                                   |
                                 -----
                                  ---
                                   -


                 -------------------------------

                    Fig 2. Basic Phone Patch



      Tip \     R1A
     O---o.\o--/\/\/-----o-----  -------o----o----O
          .              |    |  |      |    | To Tx
          .              |    |  |      |    |
          .              |    )||(      |    |
          .             ---   )||(   C1---   -----O
        S1.         MOV ^ ^ T1)||(     ---     To Rx
          .             ---   )||(      |  
          .              |    )||(      | Shielded
          .              |    |  |      | Cable
      Ring\     R1B      |    |  |      |    Common
     O---o \o--/\/\/-----o-----  -------o----o----O
                                             |
                                             |
                                           -----
                                            ---
                                             -

                             ------------------


                   Fig. 3 Improved Phone Patch


             ----
     Tip   \ |  |    R1A
     o----o.\o  o---/\/\/--o-------||(-----------------o
          |.    |          |      |||(       
          |.    |          |      |||( 8 Ohms   To RX
          |.    |          |      |||(   Shielded cable
        --|.    |          |      |||(------------o----o
        |  .    |          |   T2 )||             |
        | |-----|     MOV ---     )||(----o----o  |
        | |.              ^ ^     )||(    |    |  |
        | |. S2 Hksw      ---     )||(600 | C1 \  | R10
        --------           | 600  )||(   ---   /<------o
          |.    |          | Ohms |||(   ---   \  | To TX
          |.    |          |      |||(Ohms|    /  | Shielded
      Ring|\    |   R1B    |      |||(    |    |  | Cable   
     o----o \o  o--/\/\/---o-------  (----o----o--o----o
             |  |                                 |
             ----                               ----- 
                                                 ---
                                                  -
     NOTE: S2 Hook Switch is also a polarity reversal switch.




                    -------------------------

Fig  4.  Typical U.S. Network (425B). Note: Circled  letters  are 
marked  on  Network Interconnection  block  terminals.  Component 
values may vary slightly between manufacturers.






                                                               
                         |-------------------|                 
                       ..|...................|                 
                       . |                  .|                 
     Sidetone balancing. |    C3            .|                 
     impedance & loop  . |    | |           .|                 
     compensation. >>> . o----| |-------o   .|                 
                       . |    | |       |   .|                 
                       . |              |   .|                 
                       . |    |<| VR2   |   .|                 
                       . o----| |-------o---.|                 
                       . |    |>|          |.|                 
                       . |                 |.|                 
                       . |   R4            |.|                 
                       . o---\/\/\/-----|  |.|                 
                       ..|..............|..|.|                 
                         |              |  | |                 
                         |        . (GN)|  | |                 
                     (R) -----)||(------|-------o-----|        
                         TA1 1)||(5 TC  |  | |  |     |        
               Loop           )||(      |  | |  |     |        
 TIP    \      Compensation  2)||(6     |  | | ---    |        
 o-----o.\----------o---------)||(------o  | | ^ ^ RX O        
        .           |   (RR) . ||       |  | | ---    |        
        .           |          ||       |  | |  |VR60 |        
        .           \ 180      ||   C2 --- | |  |     |        
        .           / Ohms     ||      --- | |--o-----o        
        .  (F) C4   \          ||       |  |    |     |        
   S1   .   o--||---|          ||       |  |    |     |        
  HKSW  .          ---       . || .     |  |    o     |        
        .          ^ ^   -----)||(------o---   \   TX O        
        .      VR1 ---   |   3)||(7           S3|     |        
        .           |    |TA2 )||(  TB          |     |        
  RING \.           |    |   4)||(8       R3    |     |        
 o----o \-----------o---------)||(---o----/\/\/-o------        
      (L2)               | (C)       |         (B)             
            ^            |           |                         
        Hookswitch        ------------                         
                                                               
                                                               

                       -------------------------



     Fig. 5. Typical European Network


      A  \                              
     o--o.\---------o----o----o-------| 
         .          |    |    |       | 
         .          | C4 |    |       | 
         .          |   ---   \       | 
         .          |   ---   / R5    | 
         .          |    |    \       | 
         .          |    |    |       |
         .          |    -----o----)|||
         .          |              )||| 
     S1  .          |              )||o------o-----
    HKSW .          |         200  )|||   VR |    |
         .       TX O          Ohms)|||   60 |    |
         .          |              )||(    -----  |
         .          |              )||(     ^ ^   O RX
         .          ---------------|||(    -----  |
         .                     50  )||(60    |    |
         .                     Ohms)||(Ohms  |    |
      B \.                         )||(------o----- 
     o--o\-------------------------)||  
                                        


                        ----------------------------



     Fig. 6. Deluxe Phone Patch



                                                               
                         |-------------------|                 
                         |                   |                 
                         |                   |                 
                         |    C3             |                 
                         |    | |            |                 
                         o----| |-------o    |                 
                         |    | |       |    |                 
                         |              |    |                 
                         |    |<| VR2   |    |                 
                         o----| |-------o--- |                 
                         |    |>|          | |                 
                         |                 | |                 
                         |   R4            | |                 
                         o---\/\/\/-----|  | |                 
                         |      ^ or R11|  | |                 
                         |      |-------|  | |                 
                         |        . (GN)|  | |                 
                     (R) -----)||(------|-------------        
                         TA1 1)||(5 TC  |  | |       |         
                              )||(      |  | |       |         
 TIP    \    R1A             2)||(6     |  | |    R12/   To TX 
 o-----o.\--/\/\/---o---------)||(------o  | |       \<---------
        .           |   (RR) . ||       |  | |       /         
        .           |          ||       |  | |       |         
        .           \ R2       ||   C2 --- | |--o----|---|------
        .           /          ||      --- |    |    |  ---
        .           \          ||       |  |    | R12\   -     
   S1   .           |          ||       |  |    |    /<---------
  HKSW  .          ---       . || .     |  |   ---   \   To RX 
        .          ^ ^   -----)||(------o---   ---   |         
        .      VR1 ---   |   3)||(7          C1 |    |         
        .           |    |TA2 )||(  TB          |    |         
  RING \.   R1B     |    |   4)||(8       R3    |    |         
 o----o \---/\/\----o---------)||(---o----/\/\/-o------        
      (L2)               | (C)       |         (B)             
                         |           |                         
                          ------------                         
                                                               
                                                               
Note:  T1  600 Ohm 1:1 Transformer would be between  R1  and  the 
line.


                    -------------------------


     Parts List



     Item      Description
               
     C1        0.1 uF (see text)
     C2        1.5 to 2.0uF (Depending on manufacturer)
     C3        0.47 uF Not used in all networks
     C4        0.1 uF
     C5        2.0 uF 250 Volt Mylar Film (see text)
     MOV       130 to 250 Volt MOV (see text)
     R1A,B     100 to 270 Ohms (see text)
     R2        180 to 220 Ohms (depending on manufacturer)
     R3        22 Ohms
     R4        47 to 110 Ohms (depending on manufacturer)
     R5        1 Kilo Ohm            
     R6        1 Kilo Ohm (see text)
     R7        10 Ohm (see text)
     R10       1 Kilo Ohm potentiometer (see text)
     R11       200 Ohm potentiometer (see text)
     R12       2 Kilo Ohm potentiometer (see text)
     S1        DPST or Hookswitch
     S3        NC Momentary switch (see text)
     T1        600 Ohm 1:1 transformer
     T2        600 Ohm primary. 600 Ohm and 8 Ohm secondary (see text)
     T3        Network Transformer
     VR1       Silicon Carbide Varistor or Back-to-back Zener
     VR2       Silicon Carbide Varistor or Back-to-back Zener
     VR60      Silicon Carbide Varistor or Back-to-back Zener


                        END

-- 
Julian Macassey, julian@bongo.info.com  N6ARE@K6VE.#SOCAL.CA.USA.NA
742 1/2 North Hayworth Avenue Hollywood CA 90046-7142 voice (213) 653-4495

