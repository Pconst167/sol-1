>>> THE COLLECTION OF TEXT ADVENTURE GAMES <<<
>>> ORIGINALLY WRITTEN BY SCOTT ADAMS <<<
>>> CONVERTED FOR TI-89 BY ZELJKO JURIC <<<

Content
-------

- What are text adventure games
- What is included here
- How to play these games on TI-89
- Instructions and hints for playing
- If you are really stuck
- Notes about the copyright
- History (what's new in this release)
- Credits
- How to contact me

What are text adventure games
-----------------------------

Text adventure games are different kind of games, which was popular before
10-20 years. You won't find pretty images, or shoot'em-up action, but maybe
you will find games that challenge and entertain, frustrate and delight.

Text adventures was invented in the mid-1970's, at a time when the graphics
and sound capabilities of computers were obviously poor. Game authors learned
to use words alone to evoke images of fantastic places and magical events. Few
games were produced (the first one was "Collosal Cave"), but they were new and
fun and exciting. They could only run on mainframe and minicomputers, however,
so they weren't incredibly wide-spread. When first microcomputers appeared,
game authors started to produce text adventure games for them. As I know, the
first one for the microcomputer was "Adventureland" for TRS-80. Later, many of
adventure games were ported to nearly all 8-bit computers which was popular in
this time like Apple II, ZX Spectrum, Commodore 64, BBC B etc. The first text
adventure games usually were very limited, but their complexity increased as
the power of computers increases.

OK, but what are, in fact, text adventure games? Their environment is most
often all text. The basic idea of the user interface is command and response.
The program gives you a description where are you, where you can go, what do
you can see there, what happens there and so on, then gives a you command
prompt. You need to type in some command and press ENTER. The computer chews
on your input for a bit, then tells you the results and gives you a new
prompt. Most of the commands you use will be simple and direct. Typing, for
example, OPEN DESK causes your character to (you guessed it) open the desk.
Type GET PENCIL, and you will pick it up. The process is simple. When faced
with the command prompt, just think "I want to..." or "What happens if I..."
and let your mind work from there.

Text adventures are still produced today (mostly as freeware software) because
good prose is timeless. Of course, they are incomparably more complex than old
text adventures (like these included here). They usually accept and understand
even extremely complex sentences, and the amount of text descriptions is like
in best books, with a complex story (not only simple sentences like "I am in
the kitchen"). If you are interested for modern text adventures (today usually
called "interactive fiction"), visit "http:\\ifarchive.org". Video games come
and go as technology changes, but the best pictures are still in the mind...

What is included here
---------------------

This collection includes 14 text adventure games, originally procuded by
"Adventure International" company, and written by Scott Adams. These games
were available for nearly all microcomputers. They were very common and
famous, and they are often regarded as "true classic of text adventures".
Included games are: "Adventure Sample", "Adventureland", "Pirate Adventure",
"Secret Mission", "Voodoo Castle", "The Count", "Strange Odyssey", "Mystery
Fun House", "Pyramid of Doom", "Ghost Town", "Savage Island" (part I and II),
"Sorcerer of Claymorgue Castle", and "Return of Pirate's Isle".

Scott Adams wrote his games between 1978 and 1985. The first games were
text-only games with an interpreter written in BASIC, later releases had
faster interpreters written in assembler. From 1983 onwards he re-released all
the games with added graphics (SAGA, Scott Adams Graphic Adventures).

How to play these games on TI-89
--------------------------------

Text adventure games consist of the game database (which describes the game)
and the interpreter (which interpretes the database for particular game). The
game databases are principally machine-independent, and the interpreter is, of
course, strongly machine dependent. I made the interpreter which interprets
"Adventure International" databases on the TI-89, and it is in the file
"scott.89z". Game databases are in files named "*.89y". You need not to
transfer all database files to TI-89: transfer only files which represents the
games you want to play. All database files will be stored in folder "advint"
on TI-89. Their type will be shown as SDBF (ScottFree DataBase File) in the
VAR-LINK dialog. Here is the complete list which game is in which file:

File:         Game:

adsample.89y  Adventure Sample
advland.89y   Adventureland
pirate.89y    Pirate Adventure
smission.89y  Secret Mission (aka Mission Impossible)
voodoo.89y    Voodoo Castle
count.89y     The Count
odyssey.89y   Strange Odyssey
funhouse.89y  Mystery Fun House
pyramid.89y   Pyramid of Doom
gtown.89y     Ghost Town
savage1.89y   Savage Island (part I)
savage2.89y   Savage Island (part II)
sorcerer.89y  Sorcerer of Claymorgue Castle
rtpirate.89y  Return of Pirate's Isle

The games included here are the text-only versions, although later versions of
them (for ZX Spectrum and Commodore 64) had inlcudes illustrations (I still
don't know how to handle graphic informations in SAGA databases, and screen
resolution of TI-89 is, of course, smaller than both Spectrum and C64; maybe I
will include graphic support in the future).

To play these games, type "scott()" at home screen (see notes later if you
have AMS 2.03 installed). After this, a menu will appear on the screen. You
need to select the game from the menu, then press ENTER. The menu will contain
the list of all installed games in "advint" folder (note that the program is
smart: a non-database file in this folder will not fool the program). After
this, the game begins. When you want to finish the game, type QUIT to return
to the main menu (then you can press ESC to return to the home screen).

This program is "nostub" program, e.g. it does not require any kernels or
shells (like DoorsOS) for run. If you have AMS 2.03 and if you have not any
kernels installed (like DoorsOS, TEOS, Universal OS etc.) you also need to
transfer small "patch" program named "scott2" on your calc, and type
"scott2()" to run (note that BOTH "scott.89z" and "scott2.89z" must be present
on the calculator). Under any other conditions, running just "scott()" is
quite enough.

The game databases are extracted from versions for TRS-80, Apple II, TI-99/4A
and ZX Spectrum. The extraction was done by Paul David Doherty, and these
extracted databases are available on the Internet in plain ASCII format. As
this format is unpractical for usage on TI-89, I converted these ASCII files
in TI binary format (".89y") which is much more compact, so the typical
database file takes only 7-15K. I does not include the convertor program here.
Note that exist more games which are available in the same format, for example
games made by Brian Howarth, etc. If anybody is interested for an archive
which includes ALL games available in Scott Adams format, you can pick it at

http:\\www.ticalc.org/pub/89/asm/games/advint.zip

The interpreter itself I based on one freeware interpreter for the PC called
ScottFree, by Alan Cox. As this interpreter comes with the C source, I ported
it to the TI-89 and compiled with TIGCC. Note that this porting was not so
straightforward, due to very different screen organization on PC and TI-89,
and due to absence of standard file handling system on TI-89. But, the main
core of the interpreter is picked from Alan Cox's ScottFree. That's why I
named my game driver also ScottFree. Note that the interpreter is extended in
this release to allow running "Seas of Blood" game (not included in this
archive though), which needs a special treatment.

Have fun, and happy nostalgia!

Instructions for playing
------------------------

First note: if you have never played a text adventure before, try first
"Pirate adventure" or "Adventureland" before going to harder games.

Instructions are entered by you in the form of two word commands with the
first word being a verb. Note that the parser is primitive: you need to give
only verb-noun construction. For example, you must not give articles, so
instead of GET THE KEY type just GET KEY. If the computer doesn't understand,
it will tell you so and you must try rewording what you wish to do (e.g.
instead of GO FLYING try FLY). You will find that objects which can be picked
up usually require only the last part of their name as in the "Blue Ox" where
typing GET OX is all that is needed. Sometimes, where similar objects exist
(like "Blue Key" and "Red Key"), you need to type adjective, like GET BLUE KEY
or GET RED KEY (strictly speaking, as the parser is strictly two-word parser,
everything after second word is ignored, so GET BLUE or GET RED would be quite
enough). All words may be abbreviated to 3-5 letters (depending of the
particular game), so if you need to type CAPTURE PTERODACTILE, CAPT PTER will
usualy be enough.

All commands typed by player are buffered, so you can navigate through
previously typed commands using up and down arrow keys, instead of typing them
again (note that this feature had a fatal bug in previous releases of the
interpreter which causes a lockup on AMS 2.xx; this is fixed now). Due to
memory-saving reasons, the buffer is limited to previous 30 commands. It
probably will be quite enough. You can also press CLEAR key to clear whole
input line. Note that while typing from the keyboard, you can open the CHAR
menu to pick an extra character from it: this is necessary in some games (for
example, in "Ghost Town" you need to type GET $200 on some place, so you need
to use CHAR menu to type the dollar).

The vocabulary varies from game to game, and it is usually 150-300 words. Some
verbs which are usually common in the most of adventure games (note that this
is not a complete list) are: ATTACK, BREAK, BURN, BUY, CALL, CAST, CLEAN,
CLIMB, CLOSE, CONNECT, COUNT, CUT, DIG, DRINK, DROP, EAT, EMPTY, ENTER,
EXAMINE, FIND, FLY, GET, GIVE, GO, HELP, JUMP, KILL, KNOCK, LEAVE, LIE, LIGHT,
LOCK, LOOK, MAKE, MOVE, OPEN, PICK, PLAY, PRESS, PULL, PUSH, PUT, READ,
REMOVE, SAIL, SAY, SIT, SLEEP, STAND, STAY, SWIM, TAKE, THROW, TIE, TURN,
TYPE, UNLIGHT, UNLOCK, UNTIE, WAIT, WAKE, WALK, WAVE, WEAR, WRITE and YELL.

The main moving command is GO, e.g. type GO NORTH if you want to go to the
north. To speed things up you may use the abbreviations N, S, E, W, U and D,
for GO NORTH, GO SOUTH, GO EAST, GO WEST, GO UP or GO DOWN respectively. GO
may also be used as "universal" moving command. For example, instead of typing
ENTER KITCHEN or CLIMB STAIRS you can often type just GO KITCHEN or GO STAIRS.
Note that due to strict two-word parser you often need to type gramatically
incorrect statements (e.g. to type GO DOOR instead of GO THROUGH DOOR).

EXAMINE gives you a closer look at things. Remember to EXAMINE all of the
objects you find. If you come across a shovel, don't just assume it's a
shovel, pick it up, and move on. If you look closer, you might find something
important, like an inscription indicating that it's magic. Or, if you examine
a bag, you may find a new object located in the bag. Try to remember that most
problems have solutions that require no more than some careful thought and a
little common sense.

Command INVENTORY (may be typed simply as I) will list what you're carrying.
Keep a list of all the objects in the game, and another list of the puzzles
you haven't figured out yet. Study your lists and see if you can match up
objects to puzzles. In most games, almost every object is used somewhere. You
will probably not be able to carry around every portable object in the game at
the same time, so it's important to use good inventory management techniques.
Find a safe, centrally located area to act as an inventory repository. Leave
objects here when you are not using them.

WAIT tells the computer you want to do nothing for a turn. No game time
actually passes while the computer is waiting for your input. Use WAIT to
force time to pass.

Saving is an essential feature of adcenture games. It puts all the information
about the current state of the game into a file that you can recall at a later
time. Just type SAVE GAME and the game will ask you the name of the file you
want to save to. You can include even folder name, for example, "status\s1"
(the default folder is the current folder, usually "main"). Once you give the
name, your game session will continue right where you were. You can restore
the saved status at the beginning of the game (note that you can always type
QUIT to force playing from the beginning). Answer "y" on question "Restore a
previously saved game?" then give the name of the saved file which you want
to restore.

Pronoun ALL is implemented for usage in conjuction with GET and DROP, so you
can type GET ALL to pick up all pickable object at the current location. Use
this feature with care: ALL was not implemented in original Scott Adams games,
so usage of ALL sometimes may have strange consequences which are not planed
by the game author!

There is one "magic" word introduced by me: PANIC. Typing PANIC will cause
returning to home screen immidiately, without any confirmation. Why this is
introduced if QUIT exists? You need to know that the word QUIT is introduced
in the database file, not in the interpreter itself (it is, for example,
possible to make a database file in which EXIT is used instead of QUIT). If
you have a lot of programs on your TI, it is possible that a database file
becomes corrupted due to some illegal activity of some badly-written program.
Such database may fool the interpreter, and if the vocabulary part of the
database is corrupted, the word QUIT will not be recognized, and you will not
be able to exit the program. Fortunately, PANIC is implemented in the
interpreter itself (e.g. independently of database vocabulary), so it work
even with corrupted database files (e.g. always).

In some games it is possible to do things that will keep you from winning the
game later. Some games make it pretty clear when this happens, and some won't
do a thing to clue you in. You may sometimes find out that you need to restore
to a much earlier save and do something differently. So, save often and keep
your old save files. Avoid doing the iffy things for as long as possible, then
save before you do any of them. Repeat as often as needed. This will help keep
you from having to repeat steps unnecessarily should you need to restore.

If it crosses your mind to try something, try it. At the worst the game won't
know what you're talking about or something bad will happen and you'll have to
restore. At the best you'll get a humorous response or maybe even a hint about
what you really should do -- or it might actually work!

Draw a map as you go, there are a lot more places than you think and without a
map you will end up going round in circles or missing areas which you haven't
tried. It doesn't need to be perfect as long as you have some record of where
you have been and what you've found (as well as where you found it). If you
get stuck try typing HELP - you may or may not get assistance but you won't
know until you ask. And be careful about assuming things, it can be fatal.

Good luck, happy adventuring and try not to die too often.

If you are really stuck
-----------------------

If you are really stuck with some game, you are not lost. All these games are
so known, that the Internet is really full of hints, solutions, maps, etc. for
all of these games. Maybe the best place for looking is the site "The Classics
Adventures Solution Archive" at "http://hjem.get2net.dk/gunn" maintained by
Jacob Gunness. But, you need not to look so far. In the included file folder
named "game helps" you can find help for all included games. Each game got a
separated directory in this archive, so you can easily find what you are
searching for. There are four kinds of "help" files you can find in this
archive (note that all 4 kinds are not available for each game):

1) Files named "Map.gif" or "Map.jpg" are maps of all locations in the game
   (btw, these ones named "Map.gif" are drawn by me).
2) Files named "ScottHints.txt" are "official" hints for the games given by
   Scott Adams himself (they was published by "Adventure International" in a
   form of "hint book"). These are not "walkthroughs" - they don't give away
   the game. Instead, for each puzzle in the game, they give a clue, a bigger
   clue, and a solution. A simple system is used to keep you from reading any
   clues you don't want to see yet (look them to see which system is used). If
   you are stuck, and don't want to ruin the game, look these hint files first
   before you try to read more "explicite" solutions.
3) Files named "Solutions.txt" are explicite solutions for the game, which
   describe what do you exactly need to do in the game, but they do not give
   the exact sequence of commands which you need to type in to solve the game.
4) Files named "StepByStep.txt" contain exact sequance of commands you need to
   type in to solve the game. Read these files only if nothing others help:
   reading them will totally ruin the game, and from these files you can read
   mostly "what command you need to type" but not "why do you need to type
   exactly that command". Most of these files are written by Jacob Gunness.

Notes about the copyright
-------------------------

The game interpreter included in this package is written by me (i.e. by
Zeljko Juric), and it is Public Domain software (source code included). You
are restricted only to keep the copyright message intact. It is based mainly
on ScottFree interpreter for IBM PC written by Alan Cox, which is freeware
software.

Original Scott Adams text Adventure games are still copyrighted by Scott Adams
and they are not Public Domain. They may be freely enjoyed though. For more
info, see the web site

http://www.msadams.com

or mail Scott on

msadamsm@msadams.com

History (what's new in this release)
------------------------------------

Release 1.5 (27. IX 2000.)

- A major bug which causes a lockup if the user pressed up or down arrows on
  AMS 2.xx is fixed (thanks to Chillag Kristof for locating the bug).
- In this release of the interpreter, you can open the CHAR menu to pick an
  extra character from it while typing from the keyboard. Without this feature
  "Ghost Town" is unsolvable (because you need to type GET $200 on some place,
  but you can not type the dollar without opening the CHAR menu).
- The interpreter now uses a better random number generator. In previous
  release, some rare events (with chance of 2% or less) did not appear in a
  game at all.
- The interpreter is extended to allow executing of Figthing Fantasy combat
  sequence, which is necessary for the game "Seas of Blood". As this game is
  now playible with the interpreter, it is added into the collection.
- The format of database files and savefiles is slightly changed, to allow
  more consistent display in VAR-LINK dialog (old format will still be
  recognized, due to backward compatibility reasons).
- Some minor aesthetic bugs are fixed.
- Small errors in game solutions and maps are fixed.

Release 1.1 (21. II 2000.)

- This release of the interpreter does not requires Universal OS nor DoorsOS
  even on AMS 2.03, and works even on Hardware Release 2 calculators with
  AMS 2.03.
- In the previous release, I forgot to implement DELAY database command, so
  "Return to Pirate's isle" was unsolvable (the squinting didn't work), and
  maybe there was some problems in another games too. This is now corrected.
- In this release of the interpreter, all commands typed by player are
  buffered, so you can navigate through previously typed commands using up and
  down arrow keys, instead of typing them again. Thanks to Joseph Merfalen for
  a suggestion about this. You can also press CLEAR key to clear whole input
  line at once.
- Previus release of the interpreter has a bug: if there is not enough memory
  for executing the game, the calculator may crash. It is fixed now.
- In this release of the interpreter, if TI-92+ is detected, the program will
  use full TI-92+ screen size instead of using only part of it.
- In this release of the interpreter, after you quit the game by typing QUIT,
  the menu pointer will remain on this game, so starting the same game again
  is much easier. In fact, this was planed in the first release, but didn't
  work due to buggy coding.

Release 1.0 (25. I 2000.)

- The first official release.

Credits
-------

Many peoples are indirectly included in this complex project of porting old
classic text adventure games to the TI-89, so I need to give a credits to the
following people:

- Scott Adams, for writing these games;
- Me, for writting the interpreter which allows playing these games on TI-89;
- Julien Muchembled, for giving me an idea how to break a terrible protection
  on HW2 calculators with AMS 2.03 which does not allow ASM programs longer
  than 8K to be executed from the RAM (fortunately, no protection is perfect);
- Alan Cox, for writting the original ScotFree interpreter for the PC, because
  my interpreter is strongly based on his one;
- Paul David Doherty, for extracting game databases for all of these games,
  for giving a short description of each game (see "gameinfo.txt"), and for
  discovering of exact format of game databases for these games;
- Me, for converting the extracted databases to the format usable on TI-89;
- Chillag Kristof and Vir Strakul for some bug reports;
- Jacob Gunness, for writing the walkthroughs for the most of these games;
- Joe W. Aultman, for writting his article "A Beginner's Guide to Interactive
  Fiction" - some parts of this readme file are picked from his article.

How to contact me
-----------------

If you have any suggestions, comments, bug reports, if you have any questions
or need more info about any particular topic, mail me at:

zjuric@utic.net.ba

Zeljko Juric
Sarajevo
Bosnia & Herzegovina
