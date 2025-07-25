
Control sequences in ANSI (VT100) mode
======================================

Function                                Control Sequence

Cursor movement commands
------------------------

Cursor up                               ESC [ Pn A
Cursor down                             ESC [ Pn B
Cursor Forward                          ESC [ Pn C
Cursor Backward                         ESC [ Pn D
Cursor Position                         ESC [ line ; col H
                                     or ESC [ line ; col f
Index                                   ESC D
New Line                                ESC E
Reverse Index                           ESC M
Save cursor and attributes              ESC 7
Restore cursor and attributes           ESC 8

Double height and widht commands
--------------------------------

Double height top half                  ESC #3
Double height height bottom half        ESC #4
Single widht line                       ESC #5
Double width line                       ESC #6

Erasing commands
----------------

From cursor to end of line              ESC [ K
From start of line to cursor            ESC [ 1 K
Entire line                             ESC [ 2 K
From cursor to end of screen            ESC [ J
From start of screen to cursor          ESC [ 1 J
Entire screen                           ESC [ 2 J

Character attribute commands
----------------------------

Video attributes off                    ESC [ m
High intensity on                       ESC [ 1 m
Underline on                            ESC [ 4 m
Blink                                   ESC [ 5 m
Reverse video on                        ESC [ 7 m

Character set commands
----------------------

U.K. set is G0                          ESC ( A
U.K. set is G1                          ESC ) A
U.S. set is G0                          ESC ) B
U.S. set is G1                          ESC ) B
Special graphics is G0                  ESC ( C
Special graphics is G1                  ESC ) C

Mode setting commands
---------------------

Set new line mode                       ESC [ 20 h
Reset New line mode                     ESC [ 20 l
Set cursor key mode                     ESC [ ? 1 h
Reset cursor key mode                   ESC [ ? 1 l
Set VT52 mode                           ESC [ ? 2 l

Set slow scroll                         ESC [ ? 4 h
Reset slow scroll                       ESC [ ? 4 l
Set reverse video                       ESC [ ? 5 h
Reset reverse video                     ESC [ ? 5 l
Set origin mode                         ESC [ ? 6 h
Reset origin mode                       ESC [ ? 6 l
Set autowrap mode                       ESC [ ? 7 h
Reset autowrap mode                     ESC [ ? 7 l
Set application keypad mode             ESC =
Reset application keypad mode           ESC >

Scrolling region and tab stop commands
--------------------------------------

Define scrolling region                 ESC [ top ; bottom r
Set tab at current column               ESC H
Clear tab at current column             ESC [ g 
                                     or ESC [ 0 g
Clear all tabs                          ESC [ 3 g

Reporting commands
------------------

Cursor position request                 ESC [ 6 n
Cursor position report                  ESC [ line ; col R
Status report request                   ESC [ 5 n
Status report (terminal OK)             ESC 0 n
DA request                              ESC [ c
                                     or ESC [ 0 c

DA response

with advanced video                     ESC [ ? 1 ; 2 c
with no options                         ESC [ ? 1 ; 0 c
with printer port                       ESC [ ? 1 ; 11 c

Logging commands
----------------

Print screen                            ESC [ i
Enter auto print mode                   ESC [ ? 5 i
Exit auto print mode                    ESC [ ? 4 i
Enter printer controller mode           ESC [ 5 i
Exit printer controller mode            ESC [ 4 i

Programmable LED commands
-------------------------

Turn all off or one on                  ESC [ Ps ; ...Ps q
                                        Ps 0 or none = all off
                                        Ps 1 turn on L1
                                        Ps 2 turn on L2
                                        Ps 3 turn on L3
                                        Ps 4 turn on L4

Control sequences in VT52 mode
==============================

Function                                Control sequence

Cursor up                               ESC A
Cursor down                             ESC B
Cursor right                            ESC C
Cursor left                             ESC D
Enter graphics                          ESC F
Exit graphics                           ESC G
Curosr home                             ESC H
Reverse line feed                       ESC I
Erase to end of page                    ESC J
Erase to end of line                    ESC K

Cursor addressing                       ESC Y line col
        (line and column relative to decimal 32)

DA request                              ESC Z
Enter alternate keypad mode             ESC =
Exit alternate keypad mode              ESC >
Print page                              ESC ]
Enter auto print mode                   ESC ^
Exit auto print mode                    ESC _
Enter printer controller mode           ESC W
Exit printer controller mode            ESC X
Enter ANSI mode                         ESC <

