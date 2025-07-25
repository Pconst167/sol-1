

                       The USENET MIDI Primer
                            Bob McQueer

PURPOSE

It seems as though many people in the USENET community have an interest
in the Musical Instrument Digital Interface (MIDI), but for one reason
or another have only obtained word of mouth or fragmentary descriptions
of the specification.  Basic questions such as "what's the baud rate?",
"is it EIA?" and the like seem to keep surfacing in about half a dozen
newsgroups.  This article is an attempt to provide the basic data to
the readers of the net.

REFERENCE

The major written reference for this article is version 1.0 of the MIDI
specification, published by the International MIDI Association, copyright
1983.  There exists an expanded document.  This document, which I have not
seen, is simply an expansion of the 1.0 spec. to contain more explanatory
material, and fill in some areas of hazy explanation.  There are no
radical departures from 1.0 in it.  I have also heard of a "2.0" spec.,
but the IMA claims no such animal exists.  In any event, backwards
compatibility with the information I am presenting here should be
maintained.

CONVENTIONS

I will give constants in C syntax, ie. 0x for hexadecimal.  If I
refer to bits by number, I number them starting with 0 for the low
order (1's place) bit.  The following notation:

>>

text

<<

will be used to delimit commentary which is not part of the "bare-
bones" specification.  A sentence or paragraph marked with a question
mark in column 1 is a point I would kind of like to hear something
about myself.

OK, let's give it a shot.

PHYSICAL CONNECTOR SPECIFICATION

The standard connectors used for MIDI are 5 pin DIN.  Separate sockets
are used for input and output, clearly marked on a given device.  The
spec. gives 50 feet as the maximum cable length.  Cables are to be
shielded twisted pair, with the shield connecting pin 2 at both ends.
The pair is pins 4 and 5, pins 1 and 3 being unconnected:

                              2
                          5       4
                        3           1


A device may also be equipped with a "MIDI-THRU" socket which is used
to pass the input of one device directly to output.

>>
        I think this arrangement shows some of the original conception
        of MIDI more as a way of allowing keyboardists to control
        multiple boxes than an instrument to computer interface.  The
        "daisy-chain" arrangement probably has advantages for a performing
        musician who wants to play "stacked" synthesizers for a desired
        sound, and has to be able to set things up on the road.
<<

ELECTRICAL SPECIFICATION

Asynchronous serial interface.  The baud rate is 31.25 Kbaud (+/- 1%).
There are 8 data bits, with 1 start bit and 1 stop bit, for 320 microseconds
per serial byte.

MIDI is current loop, 5 mA.  Logic 0 is current ON.  The specification
states that input is to be opto-isolated, and points out that Sharp
PC-900 and HP 6N138 optoisolators are satisfactory devices.  Rise and
fall time for the optoisolator should be less than 2 microseconds.

The specification shows a little circuit diagram for the connections
to a UART.  I am not going to reproduce it here.  There's not much
to it - I think the important thing it shows is +5 volt connection
to pi 4 of the MIDI out with pin 5 going to the UART, through 220
ohm load resisors. It alo shws tha you're supposed to connect
to the "in" side of the UART through an optoisolator, and to the
MIDI-THRU on the UART side of the isolator.


>>
        I'm not much of a hardware person, and don't really know what
        I'm talking about in paragraphs like the three above.  I DO
        recognize that this is a "non-standard" specification, which
        won't work over serial ports intended for anything else.  People
        who do know about such things seem to either have giggling
        or gagging fits when they see it, depending on their dispos-
        itions, saying things like "I haven't seen current loop since
        the days of the old teletypes".  I also know the fast 31.25
        Kbaud pushes the edge for clocking commonly available UART's.
<<

DATA FORMAT

For standard MIDI messages, there is a clear concept that one device
is a "transmitter" or "master", and the other a "receiver" or "slave".
Messages take the form of opcode bytes, followed by data bytes.
Opcode bytes are commonly called "status" bytes, so we shall use
this term.

>>
        very similar to handling a terminal via escape sequences.  There
        aren't ACK's or other handshaking mechanisms in the protocol.

<<

Status bytes are marked by bit 7 being 1.  All data bytes must
contain a 0 in bit 7, and thus lie in the range 0 - 127.

MIDI has a logical channel concept.  There are 16 logical channels,
encoded into bits 0 - 3 of the status bytes of messages for
which a channel number is significant.  Since bit 7 is taken over
for marking the status byte, this leaves 3 opcode bits for message
types with a logical channel.  7 of the possible 8 opcodes are
used in this fashion,  reserving the status bytes containing all
1's in the high nibble for "system" messages which don't have a
channel number.  The low order nibble in these remaining messages
is really further opcode.

>>
        If you are interested in receiving MIDI input, look over the
        SYSTEM messages even if you wish to ignore them.  Especially the
        "system exclusive" and "real time" messages.  The real time
        messages may be legally inserted in the middle of other data,
        and you should be aware of them, even though many devices won't
        use them.
<<

VOICE MESSAGES

I will cover the message with channel numbers first.  The opcode determines
the number of data bytes for a single message (see "running status byte",
below).  The specification divides these into "voice" and "mode" messages.
The "mode" messages are for control of the logical channels, and the control
opcodes are piggybacked onto the data bytes for the "parameter" message.  I
will go into this after describing the "voice messages".  These messages are:

status byte   meaning        data bytes

0x80-0x8f     note off       2 - 1 byte pitch, followed by 1 byte velocity
0x90-0x9f     note on        2 - 1 byte pitch, followed by 1 byte velocity
0xa0-0xaf     key pressure   2 - 1 byte pitch, 1 byte pressure (after-touch)
0xb0-0xbf     parameter      2 - 1 byte parameter number, 1 byte setting
0xc0-0xcf     program        1 byte program selected
0xd0-0xdf     chan. pressure 1 byte channel pressure (after-touch)
0xe0-0xef     pitch wheel    2 bytes giving a 14 bit value, least
                                   significant 7 bits first

Many explanations are necessary here:

For all of these messages, a convention called the "running status
byte" may be used.  If the transmitter wishes to send another message
of the same type on the same channel, thus the same status byte, the
status byte need not be resent.

Also, a "note on" message with a velocity of zero is to be synonymous
with a "note off".  Combined with the previous feature, this is intended
to allow long strings of notes to be sent without repeating status bytes.


>>
        From what I've seen, the "zero velocity note on" feature is very
        heavily used.  My six-trak sends these, even though it sends
        status bytes on every note anyway.  Roland stuff uses it.
<<

The pitch bytes of notes are simply number of half-steps, with
middle C = 60.

>>
        On keyboard synthesizers, this usually simplymeans high physically
        coresponds, since the patch selection will
        change the actual pitch range of the keyboard.  Most keyboards
        have one C key which is unmistakably in the middle of the
        keyboard.  This is probably note 60.
<<

The velocity bytes for velocity sensing keyboards are supposed
to represent a logarithmic scale.  "advisable" in the words
of the spec.  Non-velocity sensing devices are supposed to
send velocity 64.

The pitch wheel value is an absolute setting, 0 - 0x3FFF.  The
1.0 spec. says that the increment is determined by the receiver.
0x2000 is to correspond to a centered pitch wheel (unmodified
notes)



>>
        I believe standard scale steps are one of the things discussed
        in expansions.  The six-trak pitch wheel is up/down about a third.
        I believe several makers have used this value, but I may be
        wrong.

        The "pressure" messages are for keyboards which sense the amount
        of pressure placed on an already depressed key, as opposed to
        velocity, which is how fast it is depressed or released.

?       I'm not really certain of how "channel" pressure works.  Yamaha
        is one maker that uses these messages, I know.
<<

Now, about those parameter messages.

Instruments are so fundamentally different in the various controls
they have that no attempt was made to define a standard set, like
say 9 for "Filter Resonance".  Instead, it was simply assumed that
these messages allow you to set "controller" dials, whose purposes
are left to the given device, except as noted below.  The first data
bytes correspond to these "controllers" as follows:

data byte

0 - 31       continuous controllers 0 - 31, most significant byte
32 - 63      continuous controllers 0 - 31, least significant byte
64 - 95      on / off switches

96 - 121     unspecified, reserved for future.
122 - 127    the "channel mode" messages I alluded to above.  See
             below.

The second data byte contains the seven bit setting for the controller.
The switches have data byte 0 = OFF, 127 = ON with 1 - 126 undefined.
If a controller only needs seven bits of resolution, it is supposed to
use the most significant byte.  If both are needed, the order is
specified as most significant followed by least significant.  With a
14 bit controller, it is to be legal to send only the least significant
byte if the most significant doesn't need to be changed.

>>
        This may of, course, wind up stretched a bit by a given manufacturer.
        The Six-Trak, for instance, uses only single byte values (LEFT
        justified within the 7 bits at that), and recognizes >32 parameters
<<

Controller number 1 IS standardized to be the modulation wheel.

?       Are there any other standardizations which are being followed by most
        manufacturers?

MODE MESSAGES

These are messages with status bytes 0xb0 through 0xbf, and leading data
bytes 122 - 127.  In reality, these data bytes function as further
opcode data for a group of messages which control the combination of
voices and channels to be accepted by a receiver.

An important point is that there is an implicit "basic" channel over which
a given device is to receive these messages.  The receiver is to ignore
mode messages over any other channels, no matter what mode it might be in.
The basic channel for a given device may be fixed or set in some manner
outside the scope of the MIDI standard.

The meaning of the values 122 through 127 is as follows:


data byte                   second data byte

122       local control     0 = local control off, 127 = on
123       all notes off     0
124       omni mode off     0
125       omni mode on      0
126       monophonic mode   number of monophonic channels, or 0
                            for a number equal to receivers voices
127       polyphonic mode   0

124 - 127 also turn all notes off.

Local control refers to whether or not notes played on an instruments
keyboard play on the instrument or not.  With local control off, the
host is still supposed to be able to read input data if desired, as
well as sending notes to the instrument.  Very much like "local echo"
on a terminal, or "half duplex" vs. "full duplex".


The mode setting messages control what channels / how many voices the
receiver recognizes.  The "basic channel" must be kept in mind. "Omni"
refers to the ability to receive voice messages on all channels.  "Mono"
and "Poly" refer to whether multiple voices are allowed.  The rub is
that the omni on/off state and the mono/poly state interact with each
other.  We will go over each of the four possible settings, called "modes"
and given numbers in the specification:

mode 2 - Omni on / Mono - monophonic instrument which will receive
         notes to play in one voice on all channels.

mode 3 - Omni off / Poly - polyphonic instrument which will receive
         voice messages on only the basic channel.

mode 4 - Omni off / Mono - A useful mode, but "mono" is a misnomer.
         To operate in this mode a receiver is supposed to receive
                 one voice per channel.  The number channels recognized will be
                 given by the second data byte, or the maximum number of possibl
                 voices if this byte is zero.  The set of channels thus defined
                 is a sequential set, starting with the basic channel.

The spec. states that a receiver may ignore any mode that it cannot
honor, or switch to an alternate - "usually" mode 1.  Receivers are
supposed to default to mode 1 on power up.  It is also stated that
power up conditions are supposed to place a receiver in a state where
it will only respond to note on / note off messages, requiring a
setting of some sort to enable the other message types.

>>
        I think this shows the desire to "daisy-chain" devices for
        of instruments to different basic channels, tie 'em together,
        and let them pass through the stuff they're not supposed to
        play to someone down the line.

        This suffers greatly from lack of acknowledgement concerning
        modes and usable channels by a receiver.  You basically have
        to know your device, what it can do, and what channels it can
        do it on.

        I think most makers have used the "system exclusive" message
        (see below) to handle channels in a more sophisticated manner,
        as well as changing "basic channel" and enabling receipt of
        different message types under host control rather than by
        adjustment on the device alone.

        The "parameters" may also be usurped by a manufacturer for
        mode control, since their purposes are undefined.


        Another HUGE problem with the "daisy-chain" mental set of MIDI
        is that most devices ALWAYS shovel whatever they play to their
        MIDI outs, whether they got it from the keyboard or MIDI in.
        This means that you have to cope with the instrument echoing
        input back at you if you're trying to do an interactive session
        with the synthesizer.  There is DRASTIC need for some MIDI flag
        which specifically means that only locally generated data is to
        go to MIDI out.  From device to device there are ways of coping
        with this, none of them good.
<<

SYSTEM MESSAGES

The status bytes 0x80 - 0x8f do not have channel numbers in the
lower nibble.  These bytes are used as follows:

byte    purpose              data bytes

0xf0    system exclusive     variable length
0xf1    undefined
0xf2    song position        2 - 14 bit value, least significant byte
                                 first
0xf3    song select          1 - song number
0xf4    undefined
0xf5    undefined
0xf6    tune request         0
0xf7    EOX (terminator)     0

The status bytes 0xf8 - 0xff are the so-called "real-time" messages.
I will discuss these after the accumulated notes concerning the
first bunch.

Song position / song select are for control of sequencers.  The
song position is in beats, which are to be interpreted as every
6 MIDI clock pulses.  These messages determine what is to be played
upon receipt of a "start" real-time message (see below).

The "tune request" is a command to analog synthesizers to tune their
oscillators.

The system exclusive message is intended for manufacturers to use
to insert any specific messages they want to which apply to their
own product.  The following data bytes are all to be "data" bytes,
that is they are all to be in the range 0 - 127.  The system exclusive
is to be terminated by the 0xf7 terminator byte.  The first data byte
is also supposed to be a "manufacturer's id", assigned by a MIDI
standards committee.  THE TERMINATOR BYTE IS OPTIONAL - a system
exclusive may also be "terminated" by the status byte of the next
message.


>>
        Yamaha, in particular, caused problems by not sending terminator
        bytes.  As I understand it, the DX-7 sends a system exclusive
        at something like 80 msec. intervals when it has nothing better
        to do, just so you know it's still there, I guess.  The messages
        aren't explicitly terminated, so if you want to handle the
        protocol (esp. in hardware), you should be aware that a DX-7
        will leave you in "waiting for EOX" state a lot, and be sending
        data even when it isn't doing anything.  This is all word of
        mouth, since I've never personally played with a DX-7.
<<

some MIDI ID's:

        Sequential Circuits   1      Bon Tempi     0x20     Kawai     0x40
        Big Briar             2      S.I.E.L.      0x21     Roland    0x41
        Octave / Plateau      3                             Korg      0x42
        Moog                  4      SyntheAxe     0x23     Yamaha    0x43
        Passport Designs      5
        Lexicon               6

    PAIA                  0x11
        Simmons               0x12
    Gentle Electric       0x13
    Fairlight             0x14

>>

        Note the USA / Europe / Japan grouping of codes.  Also note
        that Sequential Circuits snarfed id number 1 - Sequential
        Circuits was one of the earliest participators in MIDI, some
        people claim its originator.


        Two large makers missing from the original lineup were Casio
        and Oberheim.  I know Oberheim is on the bandwagon now, and
        Casio also, I believe.  Oberheim had their own protocol previous
        to MIDI, and when MIDI first came out they were reluctant to
?       go along with it.  I wonder what we'd be looking at if Oberheim
        had pushed their ideas and made them the standard.  From what I
        understand they thought THEIRS was better, and kind of sulked
        for a while until the market forced them to go MIDI.

?       Nobody seems to care much about these ID numbers.  I can only
        imagine them becoming useful if additions to the standard message
        set are placed into system exclusives, with the ID byte to let
        you know what added protocol is being used.  Are any groups of
        manufacturers considering consolidating their efforts in a
        standard extension set via system exclusives?

<<



REAL TIME MESSAGES.


This is the final group of status bytes, 0xf8 - 0xff.  These bytes
are reserved for messages which are called "real-time" messages
because they are allowed to be sent ANYPLACE.  This includes in
between data bytes of other messages.  A receiver is supposed to
be able to receive and process (or ignore) these messages and
resume collection of the remaining data bytes for the message
which was in progress.  Realtime messages do not affect the
"running status byte" which might be in effect.


?       Do any devices REALLY insert these things in the middle of
        other messages?



All of these messages have no data bytes following (or they could
get interrupted themselves, obviously).  The messages:

0xf8   timing clock
0xf9   undefined
0xfa   start
0xfb   continue
0xfc   stop
0xfd   undefined
0xfe   active sensing
0xff   system reset


The timing clock message is to be sent at the rate of 24 clocks
per quarter note, and is used to sync. devices, especially drum
machines.

Start / continue / stop are for control of sequencers and drum
machines.  The continue message causes a device to pick up at the
next clock mark.

>>
        These things are also designed for performance, allowing control
        of sequencers and drum machines from a "master" unit which
        sends the messages down the line when its buttons are pushed.

        I can't tell you much about the trials and tribulations of drum
        machines.  Other folks can, I am sure.
<<

The active sensing byte is to be sent every 300 ms. or more often,
if it is used.  Its purpose is to implement a timeout mechanism
for a receiver to revert to a default state.  A receiver is to
operate normally if it never gets one of these, activating the
timeout mechanism from the receipt of the first one.

>>
        My impression is that active sensing is largely unused.
<<

The system reset initializes to power up conditions.  The spec. says
that it should be used "sparingly" and in particular not sent
automatically on power up.

AND NOW, CLIMBING TO THE PULPIT ....

>> - from here on out.

There are many deficiencies with MIDI, but it IS a standard.  As such,
it will have to be grappled with.

The electrical specification leaves me with only one question - WHY?
What was wanted was a serial interface, and a perfectly good RS232
specification was to be had.  WHY wasn't it used?  The baud rate is
too fast to simply convert into something you can feed directly to
8your serial port via fairly dumb hardware, also.  The "standard"
baud rate step you would have to use would be 38.4 Kbaud which very
few hardware interfaces accept.  The other alternative is to buffer
messages and send them out a slower baud rate - in fact buffering
of characters by some kind of I/O processor is very helpful.  Hence
units like the MPU-401, which does a lot of other stuff, too of
course.

The fast baud rate with MIDI was set for two reasons I believe:

        1) to allow daisy-chaining of a few devices with no noticeable
                end to end lag.

        2) to allow chords to be played by just sending all the notes down
                the pipe, the baud rate being fast enough that they will
                sound simultaneous.

It doesn't exactly work - I've heard gripes concerning end to end lag
on three instrument chains.  And consider chords - at two bytes (running
status byte being used) per note, there will be a ten character lag
between the trailing edges of the first and last notes of a six note
chord.  That's 3.2 ms., assuming no "dead air" between characters.  It's
still pretty fast, but on large chords with voices possessing distinctive
attack characteristics, you may hear separate note beginnings.

I think MIDI could have used some means of packetizing chords, or having
transaction markers.  If a "chord" message were specified, you could easily
break even on byte count with a few notes, given that we assume all notes
of a chord at the same velocity.  Transaction markers might be useful in
any case, although I don't know if it would be worth taking over the
remaining system message space for them.  I would say yes.  I would
see having "start" and "end" transaction bytes.  On receipt of a "start"
a receiver buffers up but does not act on messages until receipt of the
"end" byte.  You could then do chords by sending the notes ahead of time,
and precisely timing the "end" marker.  Of course, the job of the hardware
in the receiver has been complicated considerably.

The protocol is VERY keyboard oriented - take a look at the use of TWO
of the opcodes in the limited opcode space for "pressure" messages,
and the inability to specify semitones or glissando effects except
through the pitch wheel (which took up yet ANOTHER of the opcodes).
All keyboards I know of modify ALL playing notes when they receive
pitch wheel data.  Also, you have to use a continuous stream of
pitch wheel messages to effect a slide, the pitch wheel step isn't
standardized, and on a slide of a large number of tones you will
overrun the range of the wheel.

?       Some of these problems would be addressed by a device which allowed
        its pitch wheel to have selective control - say modifying only
        the notes playing on the channel the pitch wheel message is
        received in, for instance.  The thing for a guitar synthesizer
        to do, then, would be to use mode 4, one channel per string, and
        bends would only affect the one note.  You could play a chord
        on a voice with a lot of release, then bend a note and not have
        the entire still sounding chord bend.  Any such devices?


I think some of the deficiencies in MIDI might be addressed by
different communities of interest developing a standard set of
system exclusives which answer the problem.  One perfect area
for this, I think, is a standard set for representation of "non-
keyboard / drum machine" instruments which have continuous pitch
capabilities.  Like a pedal steel, for instance.  Or non-western
intervals.  Like a sitar.

There is a crying need to do SOMETHING about the "loopback" problem.
I would even vote for usurping a few more bytes in the mode messages
to allow you to TURN OFF input echo by the receiver.  With the
local control message, you could then at least deal with something
that would act precisely like a half or full duplex terminal.
Several patchwork solutions exist to this problem, but there OUGHT
to be a standard way of doing it within the protocol.  Another
thought is to allow data bytes of other than 0 or 127 to control
echo on the existing local control message.

The lack of acknowledgement is a problem.  Another candidate for a
standard system exclusive set would be a series of messages for
mode setting with acknowledgement.  This set could then also
take care of the loopback problem.

The complete lack of ability to specify standardized waveforms is
probably another source of intense disappointment to many readers.
Trouble is, the standard lingo used by the synthesizer industry and
most working musicians is something which hails back to the first
days of synthesizer design, deals with envelope generators and
filters and VCO / LFO hardware parameters, and is very damn difficult
to relate to Fourier series expressing the harmonic content or any other
abstractions some people interested in doing computer composition
would like.  The parameter set used by the average synthesizer manufacturer
isn't anyplace close to orthogonal in any sense, and is bound to vary
wildly n comparison to anybody elses.  Ther are essentially no
abstractions made by most of the industry from underlyin hardwre
prameers.  hat tandarizaton exits refects only the similarity
in hardware.  This is one quagmire that we have a long way to go to
get out of, I think.  It might be possible, eventually, to come up
with translation tables describing the best way to approximate a
desired sound on a given device in terms of its parameter set, but
the difficulties are enormous.  MIDI has chosen to punt on this one,
foks.

Well that's abot it.  Good luck with talking to your synthesizer.

Bob McQueer
22 Bcy, 3151


All rites reversed.  Reprint what you like.
t.  Good luck with talking to your synthesizer.

Bob Mc