From jamal@bronze.lcs.mit.edu (Jamal Hannah)
Newsgroups: alt.binaries.sounds.music,comp.sys.amiga.audio,comp.sys.mac.programmer,rec.games.programmer,comp.sys.atari.st.tech,comp.msdos.programmer,comp.sys.ibm.pc.soundcard,comp.sys.ibm.pc.programmer
Subject: Advanced-Music-Formats10.doc [FAQ]
Date: 12 Feb 1994 00:35:53 -0500

Advanced Music Formats - Document version 1.0, By Jamal Hannah 2/11/94
----------------------------------------------------------------------

Lately, a number of different programmers have entertained the idea
of newer, advanced "Module" formats, for music storage and playback.. these
formats take into account most of the following things:
(or at least they should)

* 16, 32, or an infinate number of sound channels.

* 16bit, 44kHz sound samples (CD quality sound for the respective
instruments)

* The file format can be easily enhanced, updated, and expanded, while
still remaining backward-compatible with older software intended to play
modules of the same type. (albiet an erlier version).  The "IFF FORM" or
"chunky" style of file structure from Commodore/Electronic Arts seems to
be well suited for this purpose.

* The file format should be able to handle a large number of musical
effects.  (Including, but not limited to: all ProTracker and OctaMED Pro
effects, and others, like "wa-wa", "flange", "fade", "attack", "decay"
various type of distortion, etc.)

* Format should handle a large octave range (at least C0 to C6, with all sharp
and flat notes.)

* The format should be versitile enough for use in traditional
"Compositional" software applications.. that is, where the music is
entered via a musical staff, complete with notes and other units of
traditional musical notation, as well as equaly useful in Sequencing
or "Tracker" style software, where the musical notes are entered
via the computer keyboard, or an electronic synthesizer connected via
a MIDI (or other) interface.

* The format should be as flexible as MIDI with respect to timing. (more
about this later)

* The format should have a "Compact" (but not compressed) version of itself,
where the musical information is stored in such a way that no space is wasted.
There wont be much reason for programmers to use the new format if songs
stored in it tend to take up 30% more disk space than, say, traditional
ProTracker format!  A song should never be, by default, compressed.
Compression technology changes all the time, as well as adds a new level of
complexity to the format specification and to programmer's efforts to
implement a format.  Compression should *always* be up to the user.
Some modems transfer uncompressed files better than compressed ones,
and some systems play uncompressed files faster than compressed ones.
Obviously, this does not apply to songs stored inside games or demos,
which might be compressed for security or space-saving reasons, but remember
that it's still sometimes better that the user of the program gets to decide
to compress a program or not.

* There should be some indication of the "Compatibility level" of the song.
That is, certain features, effects, and numbers of sound channels should
be limited if it is indicated that the song was origionaly created on
a Commodore-64, a Macintosh Classic, an Amiga 1000, an IBM 286 with an
AdLib card, etc.  In this case, the song may only have 3 or 4 sound channels,
8-bit/11kHz sampled musical instruments, and a limited number of effects,
(if it has any at all) so it will always play on these systems.
It's possible there should be a set of "Levels" of compatibility, indicated
in the file: Level I = 1-4 channel song with limited effects,  Level 2 =
1-6 channel song, Level 3 = 1-8 channel song, Level 4 = 1-16 channel song
with CD-quality Sampled Instruments, and so on.  It should be remembered
that what makes a song "good" is not neccesarily the hardware involved,
but the skill, imagination, and inspiration of the composer.  Also, the more
systems a song can be played back on, the more people who can enjoy the music
around the world.

* The format should be structured in such a way that it is reletivly easy
to translate from other module formats to this one.. and back. Thus it 
should be perfectly possible to translate a 15-instrument 4-voice Amiga Sound
Tracker file to a "Level 1" version of this new format, and then back
again, with no change in quality or file size.  Not only that, but it
should be possible to take a simple 1-4 track song and then "upgrade" it
to "Level 5" and add new effects and such, as well as "degrade" a Level
5 song to Level 1, where the composer can decide what effects and
music tracks to leave out... this of course depends on the music
composition software, and not the format exclusivly.

* Adiquite space should be given for the Author name, version of the song,
date the song was written, copyright/shareware/Public Domain message, and
some general information about the song.  This should be seperate from
the "Instrument Name" strings section, though it might also be optional
that such a "Comment" section exist at all, as it may add unwanted overhead
to the file size.

* It might be possible for the Module to be stored as a "Song".. that is,
the note information, but not the instrument samples. (Only their
respective names.)

* It might be possible to have more than one song stored in a single
module file at a time.  Each song should be able to have it's own speed and
overall volume associated with it, if different from the others.


There are a few issues that may need to be resolved.  For one thing, is
a "track" actualy representative of a seperate instrument, or a seperate
sequence of musical notes?   A single piano can, in theory, have more than
one sequence of notes associated with it, since the player can use two
hands, or two people can be playing the same piano at once, thus giving
up to 4 seperate sequences of simultanious musical notes to the same
physical instrument!

And timing.. while timing in video game and techno music is
naturaly very exact and presice (electronic drum machines and such),
"Real" music that the human ear is used to does not have such exact timing.
This "exact" timing can sound mechanical and repeditive.  Serious attention
should be given to this issue.

Often, music origionaly composed with one program and played with another,
(possibly a different hardware platform) will tend to sound different.
Several differences include the speed of the overal song, the pitches of the
respective notes, the timbre of the notes, and the length of the
individual notes, as well as the absence of certain effects on the notes.
There should be some "objective" or "hard-coded" reference points to
make it easy for programmers to get very exact results from the same
musical data but on different systems.  Music from a C-64 or Amiga 500
always has it's own destinctive overall tone to it, because of the
specific sound hardware.   The user should have the choice of playing a
tune back exactly the same origional way, or in a way most optimal for
the advanced sound hardware they might posess.

The musical format should be flexible enough so that on one hand, people
with a minimal understanding of music can use it to write and play songs,
while on the other hand, people with a full understanding and expertise
in music can be unrestrained and fully satesfied with the capabilities
of the file format.  The Amiga's IFF FORM SMUS, for example, is a relatively
simple music format.. compared to the MIDI (.MID) file format, which is more
complicated, arbitrary, and harder to understand, except by a musical expert.
This is both a strength and a weakness.

It's very important that the musical format is as flexible and favorable to
the user as possible.  The user should not be forced to upgrade their
hardware, or envy another platform altogether, in order to enjoy some music.
It benefits everyone that as many systems and configurations as possible
can support a musical format, so that the business of getting the music
to play is trivial, and the business of producing and sharing the best
music possible with everyone is the main activity.  Over the last decade
there have been hundreds of different musical applications producing
thousands of imaginative and inspiring songs for video games, graphics &
sound demos, and personal projects.   It's time we started going back
and "digging up" these hidden treasures out of our old piles of computer
disks.  I wouldnt be suprised if some of the most impressive computer
songs were produced by a skilled musician in 1985 on an Apple II or
Commodore-64 with Electronic Arts music software, just waiting to be
enjoyed once more!


  Jamal Hannah  <jamal@gnu.ai.mit.edu>
  
  Please contact me if you have comments, additions, or are working on a
  "universal" music file format yourself.



Appendix A: Some People Working on Advanced Music Formats
---------------------------------------------------------

As of early 1994, There are several advanced module format projects in
existance that I know of.  This is likely to change.

Anyway, here are the projects/formats that I know of:

"IFF FORM TRKR" - Darren Schebek <dschebek@outb.wimsey.bc.ca> is working on
this format which he has submitted to Commodore.  Currently, I've seen the
1st version of his proposal, but not the second.  This is still only in
the proposal stage, and has not been fully implimented or completed yet.
If you get no response from Darren, send Email to his sysop, Roger Earl
<rog@outb.wimsey.bc.ca>.

"IFF FORM MODL" - Tom "OutLand" Bech of the Amiga group "CryptoBurners"
<db62@hp825.bih.no> outlined a proposed "chunky" version of the ProTracker
format in the archive for the Amiga's "ProTracker" version 3.01 beta.  It
still seems to be in the proposal stage, though ProTracker seems to be up
to version 3.15 by now.  Martin "Leviticus" Blom <lcs@lysator.liu.se>
has submitted his own, enhanced version of IFF FORM MODL to Tom.

"IFF FORM EMOD" - Calle Englund <c92caren@und.ida.liu.se> and Bo Lincoln
created this "chunky" version of the Amiga NoiseTracker format for their
Amiga program "QuadraComposer" version 2.0.  It's complete and described in
the Manual for QC 2.0.

"IFF FORM STrk" - Frank Seide <seide@pfa.philips.de>, author of the
excellent Macintosh program "Sound Trecker" version 2.0 would like to
produce this format for his program.  I dont have any information on this
format yet.

"AMF" - Otto Chrons <c142092@cc.tut.fi> author of the IBM program
"DMP" and "DSMI" has created the "Advanced Module Format" for his program.
It handles 16 channels (at least) and is supposed to be very versitile.
Otto is very hard to reach, and busy in the military in his country, but
you might try contacting Andrew James Bromage <bromage@mundil.cs.mu.oz.au>
for information about the format, as well as, possibly, a newer format
supersceeding AMF.  I dont have any structural information about the AMF
format yet.

"UltraTracker" - Marc A. Schallehn <mas@doit.fido.de>, author of "Ultra-
Tracker" version 1.50 for IBM's with GUS (Gravis UltraSound) cards has
developed this 32-voice format.  Michael J. Sutter <freejack@shell.portal.com>
has documented the format well, and translated the German documentation.

"S3M" - The S3M format is from the IBM's "ScreamTracker" version
3.0, though I dont know if versions of the program are available beyond
2.0 (which produced "STM" and "STS" files).  This format supports up to
32 voices, works best with a SoundBlaster Pro card in an IBM, and was made
most popular by a Demo group called "Future Crew", who produced some really
wonderful pieces of (techno) music in their demos.  A little more information
on this format may be needed to write an adiquite player, but I have
included some documentation on the format in this file.
(The best IBM player for S3M files seems to be DMP version 2.82)

"QuickTime" - I just recently read an announcement from Apple that
the new QuickTime multimedia specification (version 2) which will be
available in mid-1994, will include a compact music format.  I dont have
any more information about this format at this time.


Some Relevant Individuals:

Antoine Rosset <rosset@cultnet.ch> is interested in producing his own
advanced music file format for his Macintosh program "The Player Pro",
currently at version 4.10.  The Player Pro is pretty much the only
music module _editor_ for the Macintosh to date.  I don't have any info
about Antoine's special format yet.

Harald Zappe <zappe@gaea.sietec.de> is interested in all music module
formats and (when he has time) helping people on all platforms get
information about computer music.  He posts frequently on
alt.binaries.sounds.music (a very good newsgroup. comp.sys.amiga.audio
is another good USENET newsgroup to subscribe to.)

Bryan Ford <baford@schirf.cs.utah.edu> wrote Amiga MultiPlayer, interested
in supporting many module formats in his program.

Peter Kunath <kunath@informatik.tu-muenchen.de> wrote Amiga "DeliTracker",
a very versitile program that plays many, many Amiga music module
formats.. even some really obscure ones meant only for certain games.

Marco van den Hout <M.f.C.vDnHoUt@kub.nl> is very interested in advanced
module formats and is collecting information on them.



Appendix B: Some Advanced Music Format Specifications
-----------------------------------------------------

I'm including information relating to 6 different file specifications:

IFF FORM TRKR
IFF FORM MODL (Tom Bech proposal)
IFF FORM MODL (Martin Blom Proposal)
IFF FORM EMOD
UltraTracker 1.5
ScreamTracker 3.0

Each section ends with a 78-character-long row of "=" (equal sign) symbols.



IFF FORM TRKR
-------------
<Thanks to Harald Zappe for this email message -JH>

>From: rog@outb.wimsey.bc.ca (Roger Earl)
>Subject: IFF TRKR info part-2
>Date: 20 May 93 00:52:41 PDT

Recently some rather brilliant posts by Darren Schebek have popped up on
my BBS and the material was just so good and informative that I felt it
needed to be shared with the rest of the world.  I have Darren's permission,
so I am cross-posting some of his messages here and elsewhere.

I'll try to forward any responses to Darren, or you can send Internet
E-Mail to him at dschebek@wiz.wimsey.bc.ca.

..

>From: dschebek@outb.wimsey.bc.ca (Darren Schebek)
>Newsgroups: comp.sys.amiga.audio
>Subject: IFF FORM TRKR - a brief explanation...
>Distribution: world
>Message-ID: <dschebek.0el0@outb.wimsey.bc.ca>
>Date: 21 May 93 01:45:56 PDT
>Organization: Wizard Online

Hi.  I'm the one whose been working on the IFF FORM TRKR document.  Since
I'll be losing my usenet access for an underterminate period of time, I'd
thought the last thing I could do here is explain myself. :)
..

I have been working on this IFF FORM TRKR for almost a year now.  I have sent
the original draft proposal to Commodore, and they have included it in their
latest IFF_FORMS document as a proposal.  The current technical specification
is in excess of 180K, and is about 70% complete as of this time.

I have also written player code that supports the format fully.  This code is
about 90% written, and still requires debugging and honing.  All of the code
has been written completely from scratch in assembly language (I even
recalculated all lookup tables).  I will also be writing load & save routines
to go with the player code.  All of this code is meant to accompany the IFF
FORM TRKR document, and it will be public domain.

The player code is very organized, and very well commented. It is also
optimized to a point that sustains readability and comprehension.  I'm sorry,
but I'm just a little tired of seeing player code accompanying some new
release of a tracker editor that has the excuse "This code is not optimized
in any way" at the top.  Such player code is very badly written and
completely convoluted.  Code that is not optimized is one thing, but code in
this state is inexcusable.

The player code will support n-octave 8SVX instruments, and will (hopefully,
it all looks good on paper) support playing instruments from fast memory as
well as chip memory.

I have redesigned the structure of a note event.  It is still a longword, but
now supports 127 note range, up to 63 commands, up to 63 instruments, and
contains a 13-bit operand field.  This has allowed me to enhance many
commands.

I will list the commands that FORM TRKR supports here.  Upward compatibilty
with older tracker file formats is maintained.  An existing tracker file that
is converted to FORM TRKR can always be converted back to that format.  Here
are the commands (be aware that this list is unofficial and may change):

Arpeggio ( [basenote] [,secondnote] [,thirdnote] [,rate] [,direction] )
Arpeggio II (same as Arpeggio, but restarts the sample.
Pitch Slide ( [,signedamount], mode) mode=0 once only, 1=every tick
Tone Portamento ( destnote [,rate] )
Tone Portemento II (destnote, progessionmode [,time] )
                    progressionmode: 0=exponential pitch, 1=linear pitch
Tone Portamento + Volume Slide (destnote [,rate] [,signedvolamount] )
Vibrato ( [frequency] [,amplitude] [,wavetype] )
                    wavetype: 1 = sine wave
                              2 = ramp up
                              3 = ramp down
                              4 = triangle
                              5 = square wave
                              6 = noise wave (pseudo-random)
Vibrato+Vol. Slide ( [freq] [,wavetype] [signedvolamount] )
Volume Slide ( [signedamount] )
Volume Portamento ( destvolume [,time] )
Tremolo ( [freq] [,amp] [,wavetype] ) wavetype same as vibrato.
Set Channel Volume ( volume )
Set Parameters I ( [glissando] [,filter] [,tremoloamp] [,vibratoamp] )
Restart Note ( [initialdelay] [,restartrate] )
Cut-off Note ( [cutoffdelay] )
Set Fine Tune ( finetuneval )
Sample Offset ( offset )
Pause Voice ( time )
Pause Music ( time )
Set Marker ( markerID )
Repeat From Marker ( markerID, numiterations )
Set Ticks Per Minute ( numticks )  Replaces meaningless "BPM"
Set Ticks Per Note ( numticks )    Replaces SET SPEED command
Set Time Signature ( numerator, denominator )
Set Beats Per Minute ( numbeats )  This is REAL beats per minute.
Set Notes Per Beat ( numnotes )    Used with Set Beats Per Minute.
Signal Task(s) ( signalcode )

Those, very very briefly are the commands supported so far.  I have included
commands for defining a beat as well as a time signature so that it may be
possible to render FORM TRKR music in sheet music format using standard music
notation.

FORM TRKR supports n-voice (aka channel) songs.  It can be used for songs
with any number of voices, from 1 to ??.

I would like to state my ambitions here.  After completing the technical
specification and player code, I intend to write a conversion program for
Protracker/Noisetracker and Soundtracker v2.6.  Following that, I intend to
develop (with a colleague of mine) a FORM TRKR datatype, as well as a fully
window-oriented music editor.

..

Any comments on this format are welcome.  I am losing my usenet access, so
please direct comments to Roger (he cross-posted the nine messages).  he will
make sure I get them.  Thank you for reading this.

I would lastly like to add that one of the cross-posted messages talks about
the problems inherent with portamento the way it's traditionally handled by
most (if not all) tracker players.  It offers an example of the time taken to
complete portamento operations in different octaves using the same notes.
Yes, the example given has an incorrect result, but you get the general idea.
:)

- Darren Schebek

___
passages not relating the format dropped [...] (HZ).
==============================================================================



IFF FORM MODL (Tom Bech proposal)
---------------------------------
<From "PT-Fileformat.doc" in the ProTracker 3.01b archive. -JH>

Introduction.
=============

The text below was intended to be the documentation on the fileformat used
in this release of ProTracker. However, we decided to wait with the actual
implementation of the format until having released a couple of versions,
because we'd like to hear some comments, suggestions etc. upon it first.
So read it lightly, and feel free to post your opinion to one of the authors
(see the ReadMe.doc file elsewhere on the disk). Note that since this is only
a suggestion, don't start programming a revolutionary new piece of code based
on this info yet; we may change the format :)... Here we go...

 - Signed Tom "Outland" Bech of CryptoBurners.

                                    -**-

Protracker release 3.01 Beta. Fileformat documentation.
=======================================================

This document includes the complete documentation of the fileformat used in
Protracker 3.01ß, and instructions on how to use it. Fields marked "*Reserved*"
are reserved for future use and are guarantied to cause hangup if messed with.

General
-------

With this release of Protracker we have decided to change the filestructure
of the musicfiles produced with the program. We felt the old format was
too obsolete, messy and out of date for us to use any further. So we invented
this new format. The format is based upon Interchanged File Format (IFF)
chunks, originally developed by Electronic Arts, but now in widely use on the
Amiga. The format allows considerable flexibility and does not suffer too
severly from changes and updates, and is therefore perfect for our use.

The Format
----------

We will in this section introduce and describe each chunk type appearing in a
Protracker music file. Look in the next section for the sequencial description.

** Contents of Chunk "VERS":

OFFSET		Length		Contents	Meaning
--------------------------------------------------------------------------------
 0		 4		"VERS"		Chunk identifier.
 4		 4		????????	Chunk length (in bytes).
 8		 2		????????	Version number (word).
10		 6		"PT3.01"	Version ID string.
--------------------------------------------------------------------------------

This chunk is used by Protracker to identify the producer of the module, and
if necessary perform upgrade-conversion if the file was made with a pre-
vious version of Protracker. There can be at maximum one "VERS" chunk in a
Protracker music file. This chunk is not critical; it may be obmitted, but
be aware of the possible incompatibility problems that may arise if it's left
out.

** Contents of Chunk "INFO":

OFFSET		Length		Contents	Meaning
--------------------------------------------------------------------------------
 0		 4		"INFO"		Chunk identifier.
 4		 4		????????	Chunk length (in bytes).
 8		32		[..??..]	Song name (string).
40		 2		????????	Number of instruments (word).
42		 2		????????	Number of positions (word).
44		 2		????????	Number of patterns (word).
46		 2		????????	Overall volume factor (word).
48		 2		0006h		Default speed (#VB) (word).
50		 2		????????	Packed field. See below.
--------------------------------------------------------------------------------

Protracker uses this chunk to set different internal variables, and to store
vital information used in replay and processing of the file. The song name
is a maximum 32 Chars long ASCII string. It need not be NULL-terminated.
Number of instruments indicates the number of instruments used in the song,
it may range from 0 to 65535. At present version number, however, there may
be maximum 255 instruments in one song. Number of positions reflects the
actual length of the song, that is; how many patterns that will be played during
a complete cycle. This number may vary from 0 to 65535. Number of patterns,
on the other side, reflects how many _different_ patterns that will be played
during the song. This number is used to calculate the total length (in bytes)
of the song. The Overall Volume factor is used to compute the final volume
of all channels after the individual channel-volumes have been figured out.
In this way it is easy to control the loudness of the music from the program/
song itself. Default speed is the number of VBlank frames between each pattern
position change, and is as default set to 0006h. The packed field consists
of these bits (right to left order):

Bit	Meaning		0			1			 Default
--------------------------------------------------------------------------------
 0	Filter flag.	Filter off.		Filter on.		      0
 1	Timing method.	VBlank.			CIA timing (BPM).             0
 2	File type.	Module.			Song (no instruments).        0
 3	Packstatus.	Packed patterns.	Raw patterns.                 1
 4	Length flag.	Equal pattern length.	Variable pattern length.      0
 5	Voices flag.	4 voices.		8 voices.                     0
 6	Sample res.     8 bit. 			16 bit.		              0
 7	*Reserved*             						      x
 8	*Reserved*							      x
 9	*Reserved*							      x
10	*Reserved*  							      x
11	*Reserved*							      x
12	*Reserved*							      x
13	*Reserved*							      x
14	*Reserved*							      x
15	*Reserved*							      x
--------------------------------------------------------------------------------

There can be at most one "INFO" chunk in a Protracker musicfile. This chunk is
vital; it _must_ be present for the replay routine to function properly.

** Contents of Chunk "INST":

OFFSET		Length		Contents	Meaning
--------------------------------------------------------------------------------
 0		 4		"INST"		Chunk identifier.
 4		 4		????????	Chunk length (in bytes).
 8		32		[..??..]	Instrument name (string).
40		 2		????????	Length of instrument (word).
42		 2		????????	Instrument loop start (word).
44		 2		????????	Instrument loop length (word).
46		 2		????????	Instrument volume (word).
48		 2		????????	Instrument finetuning (integer).
--------------------------------------------------------------------------------

The "INST" chunk is used to store information about an instruments properties,
such as length and volume. The instrument name is a maximum 32 Chars long ASCII
string. It need not be NULL-terminated. The Length field describes the length
of the instrument (in words) and thus ranges from 0 to 128Kb (65535 words).
Instrument Loop Start sets the offset from which to start playing after the
first replay. This value may vary from 0 to the instrument length. Instrument
Loop End sets the length of the loop to play after the first replay, relative
to the loop start value. It may thus vary from 0 to [Ins_len-Loop_start]. 
Instrument volume indicates which volume to use in the replay of the sample,
if the song doesn't say differently. This value varies between 0 and 40h.
Instrument finetuning sets the sample-rate correction difference and varies
from -7 to 7 (0fff9 to 0007h).
  There may be any number of "INST" chunks in a Protracker music file,
limited to the number of instruments actually used in the song. This
chunk is not vital; it may be left out if the song-only bit of the control
word in the "INFO" chunk is set. Otherwise, it should result in an error.

** Contents of Chunk "PPOS":

OFFSET		Length		Contents	Meaning
--------------------------------------------------------------------------------
 0		 4		"PPOS"		Chunk identifier.
 4		 4		0ffh		Chunk length (in bytes).
 8	       256		[..??..]	Pattern position table.
--------------------------------------------------------------------------------

This chunk contains the table defining which pattern to play in a given song-
position. Each entry in the table is a byte indicating which out of 256
possible patterns to play. There may be at maximum one "PPOS" chunk in a
Protracker musicfile. This chunk is vital; it _must_ be present to play the
song.

** Contents of Chunk "PTRN":

OFFSET		Length		Contents	Meaning
--------------------------------------------------------------------------------
 0		 4		"PTRN"		Chunk identifier.
 4		 4		????????	Chunk length (in bytes).
 8              32              [..??..]        Pattern name.
40	         ?		[..??..]	Pattern data.
--------------------------------------------------------------------------------

This chunk is used in a module of variable pattern length. The chunk must thus
appear as many times as there are patterns in the song. The chunk length divided
by 8 ( >>3 ) will show the pattern length (default 64). Pattern name is a 32
byte long ASCII string, describing the pattern, eg. "Intro part 3". It need not
be NULL-terminated. This chunk is critical; it must be present in the file, or
it will be regarded invalid. NOTE: This chunk is not in use in the present
version (3.01B), and will be ignored if found.

** Contents of Chunk "SMPL":

OFFSET		Length		Contents	Meaning
--------------------------------------------------------------------------------
 0		 4		"SMPL"		Chunk identifier.
 4		 4		????????	Chunk length (!in bytes!).
 8	         ?		[..??..]	Raw sample data.
--------------------------------------------------------------------------------

The "SMPL" chunk contains the raw sample data of an instrument. This chunk is
not critical; if the song-only bit of the "INFO" chunk is set, it may be
obmitted. If, however, the file is a module, then the number of "SMPL" chunks in
the file must be equal to or greater than the number of instruments used in the
song. If not, the file will be regarded incomplete.

** Contents of Chunk "CMNT":

OFFSET		Length		Contents	Meaning
--------------------------------------------------------------------------------
 0		 4		"CMNT"		Chunk identifier.
 4		 4		????????	Chunk length (in bytes).
 8	         ?		[..??..]	Raw ASCII text.
--------------------------------------------------------------------------------

The "CMNT" chunk is used for a signature, comments, greetings, date of
completion or whatever information the composer wishes to include with his or
hers creation. This chunks is not critical; it may be left out and will
typically be ignored by most applications.

These are the chunks that may appear in a Protracker musicfile. If other chunks
are encountered, they will be ignored. Any program dealing with this fileformat
should perform tests to determine the validity of the file in consideration.
Using the Protracker.library will guarantee correct handling of musicfiles, and
we strongly encourage the use of this runtime shared library instead of hacking
away on your own. Look elsewhere on this disk for the library documentation,
the library can be found in the "LIBS/" directory.

The sequential format
---------------------

In this section we will describe how the various chunks are expected to be
located within the file. These rules _must_ be followed or it will wreak
havoc when tried manipulated with inside Protracker. Here comes the header in
table form:

OFFSET		Length		Contents	Meaning
--------------------------------------------------------------------------------
  0		 4		"FORM"		Indicate start of IFF file.
  4		 4		????????	File length.
  8		 4		"MODL"		IFF type identifier.
-------------------------------------------------------------------------------

This header must be found in the start of the file, or it will be rejected as
not being a Protracker musicfile. From offset 12 in the file, things may vary
somewhat. The only rules are these: After a "INST" chunk a "SMPL" or a new 
"INST" chunk _must_ follow. This "SMPL" chunk will be regarded as the sample
data of the instrument(s) preceding it. If after a "INST" chunk another "INST"
chunk follows, and the module-flag in the "INFO" chunk is set, then all "INST"
chunks following each other will share the same sampledata found in the first
"SMPL" chunk after them. Also, all "INST" and "SMPL" chunks must be found in
sequence. That is, when a "INST" chunk is found for the first time in a file,
all other "INST" and "SMPL" chunks must follow. If this is not so, an error
message should be given, and processing terminated. Note that in a song-only
file, no "SMPL" chunks should be included. If any "SMPL" chunks are encountered
in such a file, they should be ignored and a warning given. All other chunks
used in a musicfile may be located anywhere in the file, usually in the
beginning of it, but no assumptions of their locations should be taken. Note
that all used chunks _must_ be found _before_ the "BODY" chunk, which is the
last chunk to be found in the file. Searching for chunks should stop when
encountering a "BODY" chunk. The "BODY" chunk is constructed like this:

OFFSET		Length		Contents	Meaning
--------------------------------------------------------------------------------
  0		 4		"BODY"		Chunk identifier.
  4		 4		????????	Chunk length (in bytes).
  8		 ?		[..??..]	Raw pattern data.
-------------------------------------------------------------------------------

Chunk summary
-------------

Now follows a list of the chunks that have meaning in a Protracker musicfile:

Chunk	  Function					              Critical?
-------------------------------------------------------------------------------
"VERS"	  Contains information about the producer of the file.               No
"INFO"	  Contains vital information and standard settings.	           Yes
"INST"	  Information about instruments; such as length, volume etc.        Yes
"SMPL"    Raw sample data associated with one or more instruments.           No
"PPOS"	  Position table. Information about patternsequence.                Yes
"CMNT"    Comments, greetings etc. Contains information in ASCII code.       No
"PTRN"	  Pattern data. Used only in modules of varying patternlengths.     Yes
"BODY"    Pattern data. Used in modules of equal patternlengths (default).  Yes
-------------------------------------------------------------------------------


/* End Of File */
==============================================================================


IFF FORM MODL (Martin Blom Proposal)
------------------------------------
<From an email message I recieved from Martin Blom -JH>

Date: Thu, 10 Feb 1994 12:27:05 +0100
>From: lcs@lysator.liu.se
Message-Id: <199402101127.MAA26288@robin.lysator.liu.se>
To: jamal@bronze.lcs.mit.edu
Subject: Re: IFF FORM MODL, (IFF MODULE FORMATS)
Newsgroups: comp.sys.amiga.audio
References: <2j3ojs$h2k@bronze.lcs.mit.edu>
Status: RO

In comp.sys.amiga.audio you write:

>Is the specification for "IFF FORM MODL" which was described in PT301b's
>documentation still being worked on?  Does anyone know?  And if so,
>who would I contact for information about it?

>There are a couple IFF "chunk" Module file Formats being worked on
>right now, one being "IFF FORM TRKR", and it would be nice to
>coordinate all efforts towards a single, versitile IFF mod format.
>(or at least make the different ones somehow compatible.)

> - Jamal Hannah (jamal@gnu.ai.mit.edu)


Hi! A couple of days ago, I sent my suggestion of the IFF-MODL format to 
Tom "Outland" Bech, however I have not got an answear yet. In order to
coordinate all work, I think it is important that everyone with an interest
in the IFF-MODL standard should have regular contact. Anyway, here follows
my proposition. Comment it, please!

/Martin

-------------------------------------------------------------------------------

This is my version of the new IFF MODL format. I love the idea of using IFF for
modules in the future. However, the format you have proposed is, IMHO, far too
hardware and Protracker specific. Please comment everyting you don't like (and
everything you do like, too!). Ok:

IFF MODL format.

A IFF file can contain these chunks:

Name                       #               Desc

FORM MODL                  1-n             A file can contain many modules.
  CSET                     0/1             Character set. See RKRM-Devices.
  NAME                     0/1             Module name. See RKRM-Devices.
  AUTH                     0/1             Author of module. See RKRM-Devices.
  (C)                      0/1             Copyright notice. See RKRM-Devices.
  ANNO                     any             Annotations. See RKRM-Devices.
  FVER                     0/1             Version string. See RKRM-Devices.
  MHDR                     1               Module header. Info about the mod.
  CAMG                     0/1             Amiga specific info.
  TPOS               # of sound channels   Track sequence info.
  NTRK               # of note tracks      Note track. (Pattern, 1/channel).
  ETRK               # of effect tracks    Effect track.
  FORM 8SVX          # of samples          Sample data.
    GPID                   1               Group ID.
    ....                                   ...and any other 8SVX chunks.
  FORM INST          # of instruments      Instrument info.
    CSET                   0/1
    NAME                   0/1
    AUTH                   0/1
    (C)                    0/1
    ANNO                   any
    FVER                   0/1
    IHDR                   1               Instrument header. Simular to VHDR.
    ATAK                   0/1             Attack. See RKRM-Devices.
    RLSE                   0/1             Release. See RKRM-Devices.
    PAN                    0/1             Panning. See RKRM-Devices.
    ...                                    More effect information.
  ...                                      More module information.


Description of nonstandard chunks. (C-format (I think. I only know asm.. )).

FORM MODL - music MODuLe
~~~~~~~~~
A module can contain the chunks lised above. The MHDR, TPOS, NTRK, ETRK and 
FORM INST chunks are vital, they must exist. The MHDR contains various info
about the module, TPOS contains the actual track sequence for each channel
(that is, the notes are stored in tracks, NOT patterns.), NTRK and ETRK is the
actual tracks, containing notes and effects. This was split up because
a) the format allows only one note/track, but many effects.
b) Often, you have more notes than effects, and since effects needs more space
   to store, the overall size will (hopefully) be smaller.
A FORM MODL chunk also contain other FORMs, for now FORM 8SVX and FORM INST.
This makes the FORM MODL a bit more complex, but a lot more flexible.

All includes FORM 8SVX shuld contain a GPID chunk. A field in the IHDR chunk
inside FORM INST is refering to a sample number, and the GPID contains the
sample number. Because of this, the order that the sample and instrument FORMs
come in is not important. This also allows futures enhanchmens such as 16 bit
samples or MIDI sounds. Even if a player don't support 16 bit samples the
player will be able to locate the number of all samples it DOES support.

FORM INST - INSTrument
~~~~~~~~~
A instrument FORM contains information for a instrument. Only one chunk is
vital, the IHDR chunk, but one will probably include at least a NAME chunk too.
In this FORM, a lot of effect chunks can be saved. All effect chunks that a
8SVX can contain can be used here to. All information in this FORM has priority
over the same info in (f.ex.) a 8SVX FORM. The actual instrument is split up in
two chunks (FORM INST and FORM 8SVX for now) because you may want to use the
same sample (8SVX), but with different effects and volume, for many
instruments.

GPID - GrouP IDentification number
~~~~
typedef struct {
  UWORD  id                                 ID number.
} GroupID

MHDR - Module HeaDeR
~~~~
typedef struct {
  Fixed  volume                             Overall volume. 0-65536 (0-1.0)
  UWORD  tempo                              tempo in 1/128 BPM.
  UWORD  ctInst                             # of instruments.
  UWORD  ctSamp                             # of samples.
  UWORD  ctTrack                            # of tracks.
  UBYTE  ctChannel                          # of voices/channels. (4 on Amiga.)
  UBYTE  speed                              ST/PT/NT speed, VBL delay.
} ModuleHeader
*** 'Fixed' is defined as ULONG in the IFF includes.

CAMG - Commodore AMiGa info
~~~~
ULONG  flags                                bit 0:   0=filter off, 1=on
                                            bit 1:   0=VBL timing, 1=CIA

TPOS - Track POSitions
~~~~
typedef struct {
  UWORD  channel                            play this track which channel?
  UWORD  track[]                            sequence of track numbers.
} TrackPos

NTRK - Note TRacK
~~~~
typedef struct {
  structure Noteinfo[]                      Sequence of Noteinfo structures.
} NoteTrack

typedef struct {
  UBYTE  nEv                                Note Event.
                                            1-126: MIDI note
                                            128: Pause
  UBYTE  data1                              Length in 1/128 notes, high byte
  UBYTE  data2                                                     low byte
} Noteinfo

ETRK - Effect track
~~~~
typedef struct {
  structure Effectinfo[]                    Sequence of Effectinfo structures
} EffectTrack

typedef struct {
  UWORD  effect                             Effect number.
  UWORD  data                               Data for effect.
  UWORD  length                             Length in 1/128 notes.
} EffectInfo


IHDR - Instrument HeaDeR
~~~~
typedef struct {
  Fixed  volume                             Instrument volume, 0-65536 (0-1.0)
  UWORD  instrument                         The number of this instrument
  UWORD  sample                             Use sampledata from which sample?
  BYTE   finetune                           Finetune data, -8 - 7
  UBYTE  tune                               Sample is tuned as..? MIDI tone.
} InstrumentHeader
*** 'Fixed' is defined as ULONG in the IFF includes.






That's it! Hope to hear from you soon.

/ Martin 'Leviticus' Blom

,-----------------------------------------------.
|                                               |
|      Standard mail                            |
|              Martin Blom                      |
|              Alsattersgatan 15A.24            |
|              58251 Linkoping                  |
|                                               |
|      E-Mail                                   |
|              d93marbl@und.ida.liu.se          |
|              lcs@lysator.liu.se               |
|                                               |
|      Voice, Data and Fax                      |
|              Int        +46-13-260044         |
|              Nat        013-260044            |
|                                               |
`-----------------------------------------------'

-------------------------------------------------------------------------------

Some things is missing, like the trackname, and the effect IDs.
But, like I said. Please comment!

/Martin  ...again.


-- 

+- Martin Blom - Linkoping institute -+     Proud owner of ABC 80, Commodore 64
|        of technology, Sweden        |               Amiga 500, Amiga 4000'040
+---- Email to lcs@lysator.liu.se ----+              NOTHING beats SID & VIC-II
==============================================================================



IFF FORM EMOD
-------------
<From the text-file manual from QuadraComposer 2.0.  Two of the effects in
this format are said to differ from the standard NoiseTracker format's
effects.  These are the "SET SAMPLE OFFSET" and "POSITION JUMP"
effects commands.  The Manual lists all commands, im just including the
format outline from the very end of the file. -JH>

The standard EMOD fileformat is using the standard IFF (not 
SMUS!) format. It was necessary to create a new fileformat, to be able 
to include all the new features (compared to the NT-fileformat), like:

     * 255x128 kb samples.

     * 256x256 rows named patterns.

     * 255 positions.

     * Better internal format for pattern data - 4 bits left per note 
	  for future expansion.


The patterndata is put in the file row by row, 4 bytes for each 
note, and 16 bytes for each row:

SampleNr NoteNr   Empty Effect 
                        cmd.
-------- -------- ----  -------------
00000000 00000000 0000  0000-00000000        <--- Bits
-------- -------- ---------- --------  
Byte 0   Byte 1   Byte 2     Byte 3    

The notenumber is a number from 0 to 35 which corresponds to a 
note (C 1 to B 3). To get the period you'll have to use a list. The following 
are  the IFF chunks of the EMOD fileformat. If you want to add something 
new to the module like a long comment or a text, please make a new 
chunk. A properly made program should just ignore the unknown chunks.


Type      Size Description
~~~~~~~~~~~~~~~~~~~~~~~~~~
char	     4    "FORM"
long	     4    Size of file from offset 8

*********** Infochunk ************

char      4    "EMOD"				;Extended Module
char      4    "EMIC"				;Extended Module Info Chunk
long      4    Size of chunk
word      2    Version of IFF EMIC-chunk
char      20   Name of song
char      20   Composer
byte      1    Tempo
byte      1    Number of samples
  byte    1    Sample nr
  byte    1    Volume
  word    2    Samplelength in words
  char    20   Name of sample
  byte    1    Controlbyte bit 0=loop on/off
  byte    1    First 4 bits finetune 
  word    2    Repeat in words		;Length to loop repeatpoint
  word    2    Replen in words		;Length of loop
  long    4    Offset to the sample from the very beginning of the 
               file

byte      1    Pad
byte      1    Nr of patterns
  byte    1    Pattern nr
  byte    1    Length of pattern in rows - 1
  char    20   Name of pattern
  long    4    Offset to the pattern from the beginning of the file

byte      1    Pad
byte      1    Nr of positions
  byte    1    Patternnumber

byte      0 or 1 Extra byte to wordalign if necessary.


******** Pattern data chunk **********

char      4	"PATT"                   ;Patterndata
long      4	Size of chunk
byte	16   row 1
byte 16   row 2
byte 16   row 3...


******** Sample data chunk *********

char	4    "8SMP"              ;8 - bit SaMPle
long	4    Size of chunk
byte	?    Sampledata
==============================================================================



UltraTracker 1.5
----------------
<From the IBM "ultra150.zip" archive by Marc Schallehn, text file by
Muchael J. Sutter and update comments added by Marc Schallehn. -JH>

               Mysterious's ULTRA TRACKER File Format
                  by FreeJack of The Elven Nation
   (some additional infos on the new format (V1.4/5) by MAS -> * marked)

I've done my best to document the file format of Ultra Tracker (UT).
If you find any errors please contact me.
The file format has stayed consistent through the first four public releases.
At the time of this writting, Ultra Tracker is up to version 1.3
(* With version V1.4/5 there are some changes done in the format. *)

Thanks go to :
SoJa of YLYSY for help translating stuff.

Marc Andr‚ Schallehn
Thanks for putting out this GREAT program.
Also thanks for the info on 16bit samples.

With all this crap out of the way lets get to the format.


Sample Structure :
______________________________________________________________________________
Samplename : 32 bytes (Sample name)
DosName    : 12 bytes (when you load a sample into UT,
                      it records the file name here)
LoopStart  : dbl word (loop start point)
LoopEnd    : dbl word (loop end point)
SizeStart  : dbl word (see below)
SizeEnd    : dbl word (see below)
volume     : byte (UT uses a logarithmic volume setting, ranging from 0-255)
             (* V1.4: uses linear Volume ranging from 0-255 *)
Bidi Loop  : byte (see below)
FineTune   : word (Fine tune setting, uses full word value)
______________________________________________________________________________

8 Bit Samples  :

SizeStart  :
The SizeStart is the starting offset of the sample. 
This seems to tell UT how to load the sample into the Gus's onboard memory. 
All the files I have worked with start with a value of 32 for the first sample, 
and the previous SizeEnd value for all sample after that. (See Example below)
If the previous sample was 16bit, then SizeStart = (Last SizeEnd * 2)
SizeEnd : 
Like the SizeStart, SizeEnd seems to tell UT where to load the sample into the 
Gus's onboard memory. SizeEnd equal SizeStart + the length of the sample.

Example :
If a UT file had 3 samples, 1st 12000 bytes, 2nd 5600  bytes, 3rd 8000 byte. 
The SizeStart and SizeEnd would look like this:

Sample        SizeStart         SizeEnd
1st            32                12032
2nd            12032             17632
3rd            17632             25632

***Note***
Samples may NOT cross 256k boundaries. If a sample is too large to fit into the
remaining space, its Sizestart will equal the start of the next 256k boundary.
UT does keep track of the free space at the top of the 256k boundaries, and
will load a sample in there if it will fit.
Example : EndSize = 252144
If the next sample was 12000 bytes, its SizeStart would be 262144, not 252144.
Note that this leaves 10000 bytes unused. If any of the following sample could
fit between 252144 and 262144, its Sizestart would be 252144.
Say that 2 samples after the 12000 byte sample we had a sample that was only
5000 bytes long. Its SizeStart would be 252144 and its SizeEnd would be 257144.
This also applies to 16 Bit Samples.

16 Bit Samples :
16 bit samples are handled a little different then 8 bit samples.
The SizeStart variable is calculated by dividing offset (last SizeEnd)
by 2. The SizeEnd variable equals SizeStart + (SampleLength / 2).
If the first sample is 16bit, then SizeStart = 16.
Example :
          sample1 = 8bit, 1000 bytes
          sample2 = 16bit, 5000 bytes

          sample1 SizeStart = 32
                  SizeEnd   = 1032 (32 + 1000)

          sample2 SizeStart = 516 (offset (1032) / 2)
                  SizeEnd   = 3016 (516 + (5000/2))

***Note***
If a 16bit sample is loaded into banks 2,3, or 4
the SizeStart variable will be
(offset / 2) + 262144 (bank 2)
(offset / 2) + 524288 (bank 3)
(offset / 2) + 786432 (bank 4)
The SizeEnd variable will be
SizeStart + (SampleLength / 2) + 262144 (bank 2)
SizeStart + (SampleLength / 2) + 524288 (bank 3)
SizeStart + (SampleLength / 2) + 786432 (bank 4)

BiDi Loop : (Bidirectional Loop)
UT takes advantage of the Gus's ability to loop a sample in several different
ways. By setting the Bidi Loop, the sample can be played forward or backwards,
looped or not looped. The Bidi variable also tracks the sample
resolution (8 or 16 bit).

The following table shows the possible values of the Bidi Loop.
Bidi = 0  : No looping, forward playback,  8bit sample
Bidi = 4  : No Looping, forward playback, 16bit sample
Bidi = 8  : Loop Sample, forward playback, 8bit sample
Bidi = 12 : Loop Sample, forward playback, 16bit sample
Bidi = 24 : Loop Sample, reverse playback 8bit sample
Bidi = 28 : Loop Sample, reverse playback, 16bit sample
______________________________________________________________________________
Event Structure:
______________________________________________________________________________
Note                : byte (See note table below)
SampleNumber        : byte (Sample Number)
Effect1             : nib (Effect1)
Effect2             : nib (Effect2)
EffectVar           : word (Effect variables)

The High order byte of EffectVar is the Effect variable for Effect1.
The Low order byte of EffectVar is the Effect variable for Effect2.
***(Note)***
UT uses a form of compression on repetitive events. Say we read in the first
byte, if it = $FC then this signifies a repeat block. The next byte is the
repeat count. followed by the event structure to repeat.
If the first byte read does NOT = $FC then this is the note of the event.
So repeat blocks will be 7 bytes long : RepFlag      : byte ($FC)
                                        RepCount     : byte
                                        note         : byte
                                        samplenumber : byte
                                        effect1      : nib
                                        effect2      : nib
                                        effectVar    : word

Repeat blocks do NOT bridge patterns. 
______________________________________________________________________________
Note Table:
______________________________________________________________________________
note value of 0 = pause
C-0 to B-0    1 to 12
C-1 to B-1    13 to 24
C-2 to B-2    26 to 36
C-3 to B-3    39 to 48
C-4 to B-4    52 to 60
______________________________________________________________________________
Offset     Bytes            Type                   Description
______________________________________________________________________________
0             15           byte           ID block : should contain
                                                     'MAS_UTrack_V001'
                                          
                                          (* V1.4: 'MAS_UTrack_V002')

                                          (* V1.5: 'MAS_UTrack_V003')

15            32           AsciiZ         Song Title
47            1            reserved       This byte is reserved and
                                          always contain 0;

                                          (* V1.4: jump-value: reserved * 32; 
                                           space between is used for song
                                           text;
                                           [reserved * 32] = RES ! )

48+RES        1            byte           Number of Samples (NOS)
49+RES        NOS * 64     SampleStruct   Sample Struct (see Sample Structure)

Patt_Seq = 48 + (NOS * 64) + RES
                       
Patt_Seq          256        byte            Pattern Sequence
Patt_Seq+256      1          byte            Number Of Channels (NOC) Base 0
Patt_Seq+257      1          byte            Number Of patterns (NOP) Base 0

                                             (* V1.5: PAN-Position Table
                                              Length: NOC * 1byte
                                              [0 left] - [0F right] )

NOC+Patt_Seq+258      varies     EventStruct     Pattern Data (See Event
Structure)

______________________________________________________________________________
The remainder of the file is the raw sample data. (signed)
______________________________________________________________________________

That should about cover it. If you have any questions, feel free to e-mail
me at freejack@shell.portal.com

I can also be contacted on The UltraSound Connection   (813) 787-8644 
The UltraSound Connection is a BBS dedicated to the Gravis Ultrasound Card.

Also I'm the author of Ripper and Gvoc. If anyone has any questions or
problems, please contact me.
==============================================================================



ScreamTracker 3.0
-----------------
<This is from the "s3mform.txt" file, from the "s3mrip.zip" archive by
Patch/Avalanche <hamell@cs.pdx.edu> on 11/10/93.  "KnightOrc" supplied
this doc.  Be sure to view or print this section with a PC-ANSI character
set font if you can. -JH>

                        Scream Tracker 3.0 file formats
                        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
                                Song/Module header
          0   1   2   3   4   5   6   7   8   9   A   B   C   D   E   F
        ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  0000: ³ Song name, max 28 chars (incl. NUL)                           ³
        ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÂÄÄÄÂÄÄÄÂÄÄÄ´
  0010: ³                                               ³1Ah³Typ³ x ³ x ³
        ÃÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÅÄÄÄÅÄÄÄÅÄÄÄÅÄÄÄ´
  0020: ³OrdNum ³InsNum ³PatNum ³ Flags ³ Cwt/v ³  Ffv  ³'S'³'C'³'R'³'M'³
        ÃÄÄÄÂÄÄÄÅÄÄÄÂÄÄÄÅÄÄÄÂÄÄÄÅÄÄÄÂÄÄÄÅÄÄÄÂÄÄÄÅÄÄÄÂÄÄÄÅÄÄÄÅÄÄÄÅÄÄÄÅÄÄÄ´
  0030: ³m.v³i.s³i.t³m.m³ x ³ x ³ x ³ x ³ x ³ x ³ x ³ x ³ x ³ x ³ x ³ x ³
        ÃÄÄÄÁÄÄÄÁÄÄÄÁÄÄÄÁÄÄÄÁÄÄÄÁÄÄÄÁÄÄÄÁÄÄÄÁÄÄÄÁÄÄÄÁÄÄÄÁÄÄÄÁÄÄÄÁÄÄÄÁÄÄÄ´
  0040: ³Channel settings for 32 channels, 255=unused,+128=disabled     ³
        ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
  0050: ³                                                               ³
        ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
  0060: ³Orders; length=OrdNum (must be even)                           ³
        ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
  xxxx: ³Parapointers to instruments; length=InsNum*2                   ³
        ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
  xxxx: ³Parapointers to patterns; length=PatNum*2                      ³
        ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

 
        Typ     = File type: 16=module,17=song
        Ordnum  = Number of orders in file
        Insnum  = Number of instruments in file
        Patnum  = Number of patterns in file
        Cwt/v   = Created with tracker / version: &0xfff=version, >>12=tracker
                        ST30:0x1300
        Ffv     = File format version;
                        1=original
                        2=original BUT samples unsigned
        Parapointers are OFFSET/16 relative to the beginning of the header.
 
        PLAYING AFFECTORS / INITIALIZERS:
        Flags   =  +1:st2vibrato 
                   +2:st2tempo
                   +4:amigaslides
                   +8:0vol optimizations
                   +16:amiga limits
                   +32:enable filter/sfx
        m.v     = master volume
        m.m     = master multiplier (&15) + stereo(=+16)
        i.s     = initial speed (command A)
        i.t     = initial tempo (command T)
 
        Channel types:
        &128=on, &127=type: (127=unused)
        8  - L-Adlib-Melody 1 (A1)      0  - L-Sample 1 (S1)
        9  - L-Adlib-Melody 2 (A2)      1  - L-Sample 2 (S2)
        10 - L-Adlib-Melody 3 (A3)      2  - L-Sample 3 (S3)
        11 - L-Adlib-Melody 4 (A4)      3  - L-Sample 4 (S4)
        12 - L-Adlib-Melody 5 (A5)      4  - R-Sample 5 (S5)
        13 - L-Adlib-Melody 6 (A6)      5  - R-Sample 6 (S6)
        14 - L-Adlib-Melody 7 (A7)      6  - R-Sample 7 (S7)
        15 - L-Adlib-Melody 8 (A8)      7  - R-Sample 8 (S8)
        16 - L-Adlib-Melody 9 (A9)
                                        26 - L-Adlib-Bassdrum (AB)
        17 - R-Adlib-Melody 1 (B1)      27 - L-Adlib-Snare    (AS)
        18 - R-Adlib-Melody 2 (B2)      28 - L-Adlib-Tom      (AT)
        19 - R-Adlib-Melody 3 (B3)      29 - L-Adlib-Cymbal   (AC)
        20 - R-Adlib-Melody 4 (B4)      30 - L-Adlib-Hihat    (AH)
        21 - R-Adlib-Melody 5 (B5)      31 - R-Adlib-Bassdrum (BB)
        22 - R-Adlib-Melody 6 (B6)      32 - R-Adlib-Snare    (BS)
        23 - R-Adlib-Melody 7 (B7)      33 - R-Adlib-Tom      (BT)
        24 - R-Adlib-Melody 8 (B8)      34 - R-Adlib-Cymbal   (BC)
        25 - R-Adlib-Melody 9 (B9)      35 - R-Adlib-Hihat    (BH)
        
                
                        Digiplayer/ST3.0 samplefileformat
          0   1   2   3   4   5   6   7   8   9   A   B   C   D   E   F
        ÚÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿
  0000: ³[T]³ Dos filename (12345678.ABC)                   ³    MemSeg ³
        ÃÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÅÄÄÄÂÄÄÄÂÄÄÄ´
  0010: ³Length ³HI:leng³LoopBeg³HI:LBeg³LoopEnd³HI:Lend³Vol³Dsk³[P]³[F]³
        ÃÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÅÄÄÄÂÄÄÄÅÄÄÄÂÄÄÄÅÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÅÄÄÄÁÄÄÄÁÄÄÄÁÄÄÄ´
  0020: ³C2Spd  ³HI:C2sp³ x ³ x ³ x ³ x ³GVSPOS ³Int:512³Int:lastused   ³
        ÃÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÁÄÄÄÁÄÄÄÁÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
  0030: ³ Sample name, 28 characters max... (incl. NUL)                 ³
        ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÂÄÄÄÂÄÄÄÂÄÄÄ´
  0040: ³ ...sample name...                             ³'S'³'C'³'R'³'S'³
        ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÁÄÄÄÁÄÄÄÁÄÄÄÙ
  xxxx:	sampledata

        NOTES:
        Inside module, MemSeg tells the paragraph position of
        the actual sampledata (offset/16). In separate insfile the same,
        in memory segment of data relative to beginning of module.
        GVSPOS=Position in gravis memory /32 (used inside player only)
        [T]ype, 1=Sample
        [F]lags, +1=loop on
                 +2=stereo (after Length bytes for LEFT channel,
                          another Length bytes for RIGHT channel)
                 +4=16-bit samples (intel LO-HI byteorder)
        { [P]ack, 0=8 bit normal (1=DP30ADPCM1 for holland project) }
 
                        ST3.0 adlib instrument format
          0   1   2   3   4   5   6   7   8   9   A   B   C   D   E   F
        ÚÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÂÄÄÄÂÄÄÄ¿
  0000: ³[T]³ Dos filename (12345678.123)                   ³00h³00h³00h³
        ÃÄÄÄÅÄÄÄÂÄÄÄÂÄÄÄÂÄÄÄÂÄÄÄÂÄÄÄÂÄÄÄÂÄÄÄÂÄÄÄÂÄÄÄÂÄÄÄÂÄÄÄÅÄÄÄÅÄÄÄÅÄÄÄ´
  0010: ³D00³D01³D02³D03³D04³D05³D06³D07³D08³D09³D0A³D0B³Vol³Dsk³ x ³ x ³
        ÃÄÄÄÁÄÄÄÅÄÄÄÁÄÄÄÅÄÄÄÅÄÄÄÅÄÄÄÅÄÄÄÅÄÄÄÅÄÄÄÅÄÄÄÅÄÄÄÅÄÄÄÅÄÄÄÅÄÄÄÅÄÄÄ´
  0020: ³C2Spd  ³HI:C2sp³ x ³ x ³ x ³ x ³ x ³ x ³ x ³ x ³ x ³ x ³ x ³ x ³
        ÃÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÁÄÄÄÁÄÄÄÁÄÄÄÁÄÄÄÁÄÄÄÁÄÄÄÁÄÄÄÁÄÄÄÁÄÄÄÁÄÄÄÁÄÄÄ´
  0030: ³ Sample name, 28 characters max... (incl. NUL)                 ³
        ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÂÄÄÄÂÄÄÄÂÄÄÄ´
  0040: ³ ...sample name...                             ³'S'³'C'³'R'³'I'³
        ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÁÄÄÄÁÄÄÄÁÄÄÄÙ

        NOTES:
        [T]ype, 2..7=amel,abd,asnare,atom,acym,ahihat
        modulator:                                              carrier:
        D00=[freq.muliplier]+[?scale env.]*16+[?sustain]*32+
                [?pitch vib]*64+[?vol.vib]*128                  =D01
        D02=[63-volume]+[levelscale&1]*128+[l.s.&2]*64          =D03
        D04=[Attack]*16+[decay]                                 =D05
        D06=[15-sustain]*16+[release]                           =D07
        D08=[wave select]                                       =D09
        D0A=[modulation feedback]*2+[?additive synthesis]
        D0B=unused
 
 
Unpacked Internal memoryformat for patterns:
 
REMARK: each channel takes 320 bytes, rows for each channel
are sequential.
byte:
0 - Note; hi=oct, lo=note, 255=empty note,254=key off (used with adlib)
1 - Instrument ;255=..
2 - Volume ;255=..
3 - Special command ;255=..
4 - Command info 
 
 
Packed Internal memoryformat for patterns:
 
Pattern length fixed for 64 rows.
 
BYTE:flag, 0=end of row
        &31=channel
        &32=follows;  BYTE:note, BYTE:instrument
        &64=follows;  BYTE:volume
        &128=follows; BYTE:command, BYTE:info
        
************************************************
NOTES on [memseg].
In memory, the memseg's highest byte (3) is always zero
(thus also the ASCIIZ terminator). For the actual 16 bit
memseg the following storage method is used:
0..EFFF = Segment to memory
F000... = EMS page ####-F000


And here is info for STM:

Song/Module file structure:
        Offset: Info:
        0       Song/File name, max 20 chars, ASCIIZ, except if 20 chars long
        20      Tracker name, max 8 chars, NO NUL
        28      0x1A
        29      File type: 1=song, 2=module
        30      Version major (eg. 2)
        31      Version minor (eg. 2)
        32      byte; tempo
        33      byte; num of patterns saved
        34      byte; global volume
        36      reserved, 13 bytes
 
        48      Instruments (31 kpl) (see below) Instrument structure:
                Offset  Info
                0       Inst. Filename, 12 bytes max, ASCIIZ
                12      0x00
                13      byte; instrument disk
                14      word; reserved (used as internal segment while playing)
                16      word; length in bytes
                18      word; loop start
                20      word; loop end
                22      byte; volume
                23      byte; reserved
                24      word; speed for mid-C (in Hz)
                26      reserved, 4 bytes
                30      word; internal segment address/(in modules:)length in
                		paragraphs
 
        XXXX    Music pattern orders (64 bytes/orders)
         
        XXXX    Patterns (number in header, each pattern 1KB)
                Patterns consist of 64 rows, each 4 channels. Each channel
                is 4 bytes in length, and the channels are stored from left
                to right, row by row.
                Special [BYTE0] contents:
                         251=last 3 bytes NOT in file, all bytes 0
                         252=last 3 bytes NOT in file, note: -0-
                         253=last 3 bytes NOT in file, note: ...
                         254=(in memory), -0- 
                         255=(in memory), ...
                otherwise:
                        note=[BYTE0] and 15 (C=0,C#=1,D=2...)
                        octave=[BYTE0] / 16
                        instrument=[BYTE1]/8
                        volume=([BYTE1] and 7)+[BYTE2]/2
                        command=[BYTE2] and 15
                        command info=[BYTE3]
        
        [XXXX]  In modules: Samples, padded to 16 byte limits. Sample lengths
        		in paragraphs (and as saved) are storen in instruments
        		internal segment address.
==============================================================================
End of file "Advanced-Music-Formats10.doc" by Jamal Hannah


 