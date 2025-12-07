		 ANSI CODES DIMYSTIFIED
		 ----------------------

Cursor Position

  ESC [#;#H Moves cursor to the position specified by the parameters.  The first
	    parameter is the line number, and the second is the column number.
	    If no parameter is given, it moves the cursor to the home position.

Cursor Up


  ESC [#A Moves the cursor up one line without changing columns.  The value of
	  # determines the lines to move up.  The default value for # is one.

Cursor Down

  ESC [#B Same as Cursor Up, except it moves the cursor down.

Cursor Forward

  ESC [#C Moves the cursor forward one column without changing lines.  The value
	  of # determines the number of columns moved.

Cursor Backward

  ESC [#D Same as cursor forward, except it moves the cursor backward.

Horizontal and Vertical Position

  ESC [#;#f Same as cursor position.

Device Status Report

  ESC [6n The console driver will output a CPR sequence on reciept of DSR
	   (See below).


Cursor Position Report



ESC [#;#R  The CPR sequence reports the current cursor position through the
	   standard output device.  The first parameter specifies the current
	   line and the second parameter specifies the current column.

Save Cursor Position


ESC [s	   The current cursor position is saved.  This cursor position can be
	   restored with the RCP sequence.

Restore Cursor Position

ESC [u	   Restores the cursor to the value it had when the console driver
	   recieved the Save Cursor Position sequence.

Erase Display

ESC [2j    Erases all of the screen and the cursor goes to the home position.
Erase in Line

ESC [k	   Erases from the cursor to the end of line and includes the cursor
	   position.

Set Graphics Rendition

ESC	   Sets the character attribute specified by the parameter(s).	All of
[#;...;#m  the following characters will have the attribute according to the
	   parameter(s) until the next occurrence of SGR.

	   0   All attributes Off (normal white on black).
	   1   Bold On (high intensity)
	   4   Underscore on (IBM Monochrome Display Only)
	   5   Blink On
	   7   Reverse Video On
	   8   Cancelled On (invisible)
	   30  Black foreground
	   31  Red foreground
	   32  Green foreground
	   33  Yellow foreground
	   34  Blue foreground
	   35  Magenta foreground
	   36  Cyan foreground
	   37  White foreground
	   40  Black Background
	   41  Red Background
	   42  Green background
	   43  Yellow Background
	   44  Blue background
	   45  Magenta background
	   46  Cyan background
	   47  White background



Set Mode

ESC [=#h   Invokes the screen width or type specified by the parameter.
ESC [=h
ESC [=0h   0   40x25 black and white
ESC [?7h   1   40x25 color
	   2   80x25 black and white
	   3   80x25 color
	   4   320x200 color
	   5   320x200 balck and white
	   6   640x200 black and white
	   7   wrap at end of linte (typing past end-of-line results in new
	       line)

Reset Mode

ESC [=#I   Parameters are the same as above except that parameter 7 will reset
ESC [=I    wrap at end-of-line mode (characters past end-of-line are thrown
ESC [=0I   away)
ESC [?7I


