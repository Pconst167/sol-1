Newsgroups: comp.editors
From: rnelson@wsuaix.csc.wsu.edu (roger nelson;S23487)
Subject: Text editor compendium  (LONG)
Message-ID: <1993Jan25.233032.17317@serval.net.wsu.edu>
Organization: Washington State University
Date: Mon, 25 Jan 93 23:30:32 GMT
Lines: 310

A number of people often post questions asking for editors which have
certain features.  

I have been working on a summary of features available in a few 
editors.  The summary is organized in a tabular check-sheet format
listing features available for various text editors with a general indication
of how well the feature/command is supported with respect to other
editors.

Perhaps this table (when further filled in) might be useful 
addition to the  comp.text.editors  FAQ.

I would like to hear comments, and suggestions for additional features,
and table entries for additional editors.
Fill out a table column for your favorite editor and send it to me,
and I will add it to the compendium and submit it to Ruben Olson for
possible inclusion in the archive.

The table is listed first followed by footnotes, followed by a detailed 
description of the features listed in the first column.

                         TEXT EDITOR COMPENDIUM

The following is a tabular cross reference of text editors that are available
on a variety of computers/operating systems.

Send additions, changes and comments to Roger Nelson:

           rnelson@wsuaix.csc.wsu.edu
Codes:

     y     The editor supports this feature
     n     The editor doesn't support this feature at all
     +     The editor supports this better than most editors
     -     The editor supports this but not very well other editors do better
     ~     The editor does this another way but not necessarily better
     !     The editor does this another way better
     M     The editor comes with a macro to do this
     m     A macro could be written to do this
     O     Optional (the feature may be enabled/disabled somehow)
     ?     Don't know
     y?/n? Don't know for sure
     NA    Not applicable or unnecessary with the editing model
   number  see footnote
   #number The editor supports this number of X's (Ie number of buffers)
     #!    The editor supports an unlimited number of X's

For example:  Support of regular expressions,

    Vi has very good support of regular expressions so it would get a 'y+'
    The borland compiler text editors offer regular expression searching,
    but only a subset of options, this would qualify for  a 'y'.
    An editor offering wild cards (Ie * or ?) would qualify for 'n-' or
    may be a '~'.
    An editor which has a search string construction interface that makes
    regular expression like searches easier would get a '!'.
    
     
                         |  |  |  |  |  |  |  |  |  |  |u |  |  |  |  |  |  |
                         |  |FE|  |  |  |X |  |B |C |T |E |  |  |  |  |  |  |
                         |  |UM|  |S |R |E |  |R |R |u |M |  |  |  |  |  |  |
                         |  |LA|E |E |E |D |TE|I |I |r |A |  |  |  |  |  |  |
   Feature               |v |LC|D |D |D |I |PV|E |S |b |C |  |  |  |  |  |  |
                         |i | S|T |T |T |T |UE|F |P |o |S |  |  |  |  |  |  |
-------------------------+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
Modal (like vi)          |y |n |n |n |n |  |  |  |  |n |  |  |  |  |  |  |  |
Prog. lang senstive mode |n |y |n |n |n |  |  |  |  |y |  |  |  |  |  |  |  |
Match parenthesis mode   |y |y |n |n |y |  |  |  |  |y |  |  |  |  |  |  |  |
Append file to buffer    |  |  |  |  |y |  |  |  |  |n |  |  |  |  |  |  |  |
Auto. indentation mode   |  |  |  |  |y |  |  |  |  |y |  |  |  |  |  |  |  |
Simple tallying          |n |n |n |n |1 |n |  |  |  |n |  |  |  |  |  |  |  |
User defined tabs        |n |  |n |y |y |y?|  |  |  |y~|  |  |  |  |  |  |  |
User defined margins     |y |  |n |y |y |y |  |  |  |n |  |  |  |  |  |  |  |
Auto-wrap (CR inserted)  |y |y |  |  |n |  |  |  |  |n |  |  |  |  |  |  |  |
Multiple rulers          |NA|  |NA|#9|#9|  |  |  |  |NA|  |  |  |  |  |  |  |
Editable rulers or tabs  |- |  |- |y+|y+|y+|  |  |  |~ |  |  |  |  |  |  |  |
Allows backward search   |y |  |y |y |y |y |  |  |  |y |  |  |  |  |  |  |  |
Case insensitive search  |n |  |y |y |n |y |  |  |  |y |  |  |  |  |  |  |  |
Case sensitive search    |y |  |y |y |y |y |  |  |  |y |  |  |  |  |  |  |  |
Wildcard search          |! |n |n |n |y |y |  |  |  |n |  |  |  |  |  |  |  |
Regular expression search|+ |+ |n |n |+ |n?|  |  |  |y |  |  |  |  |  |  |  |
Incremental find         |n |y |n |n |y |n |  |  |  |n |  |  |  |  |  |  |  |
Cont. inc find           |n |y?|n |n |y |n |  |  |  |n |  |  |  |  |  |  |  |
Center line              |n |  |n |y |y |n |  |  |  |n |  |  |  |  |  |  |  |
Multiple buffers     (12)|- |+ |n |y |y |n?|  |  |  |y |  |  |  |  |  |  |  |
Pulldown/popup menus     |n |n |n |n |yO|n |  |  |  |y |  |  |  |  |  |  |  |
Other Menus              |n |y |n |n |y~|n |  |  |  |y |  |  |  |  |  |  |  |
Command line mode like ex|y |~ |y |~ |~ |y |  |  |  |n |  |  |  |  |  |  |  |
Cut/paste regions        |n |y |y |y |y |n |  |  |  |y |  |  |  |  |  |  |  |
Columnwise cut/paste     |n |M?|n |y |y |n |m?|  |  |n |  |  |  |  |  |  |  |
Command keys redefinable |-?|y |-?|y |y |n |y |  |  |n?|  |  |  |  |  |  |  |
Delete character         |y |y |y |y |y |y |y |  |  |y |  |  |  |  |  |  |  |
Delete word              |y |y |y |y |y |n |y |  |  |y |  |  |  |  |  |  |  |
Delete line              |y |y |n?|n?|y |y |y |  |  |y |  |  |  |  |  |  |  |
Delete to EOL            |n?|  |y |y |~ |y |y |  |  |n |  |  |  |  |  |  |  |
Change filename w/o save |n |  |n |n |y |n |n |  |  |n |  |  |  |  |  |  |  |
Enter ASCII codes by #   |- |  |y |y |y |n |y?|  |  |y |  |  |  |  |  |  |  |
Exit and save            |y |y |y |y |y |y |y |  |  |y |  |  |  |  |  |  |  |
Search and replace  (10) |~ |! |~ |~ |~ |~ |  |  |  |y |  |  |  |  |  |  |  |
Replacement prompting    |n |y |y?|y |y |n |y |  |  |y |  |  |  |  |  |  |  |
Continue search          |y |  |y |y |y |- |y |  |  |y |  |  |  |  |  |  |  |
Format paragraph         |n |m?|n |y |y |n |m?|  |  |n |  |  |  |  |  |  |  |
Insert file at cursor    |n |y |y |y |y |n |y |  |  |y |  |  |  |  |  |  |  |
Goto begin of file.      |y |  |y |y |y |y |y |  |  |y |  |  |  |  |  |  |  |
Goto end of file.        |y |  |y |y |y |y |y |  |  |y |  |  |  |  |  |  |  |
Goto left margin.        |NA|  |NA|n |y |n |  |  |  |NA|  |  |  |  |  |  |  |
Goto right margin.       |n |  |  |n |y |n |  |  |  |NA|  |  |  |  |  |  |  |
Goto begin of line.      |y |y |  |  |y |y |  |  |  |y |  |  |  |  |  |  |  |
Goto end of line.        |y |y |  |  |y |  |  |  |  |y |  |  |  |  |  |  |  |
Goto bottom of screen.   |  |y |  |  |y |- |  |  |  |n |  |  |  |  |  |  |  |
Goto middle of screen.   |  |y |  |  |n |- |  |  |  |n |  |  |  |  |  |  |  |
Goto top of screen.      |  |y |  |  |y |- |  |  |  |n |  |  |  |  |  |  |  |
Goto column number       |  |  |  |  |y |n |  |  |  |n |  |  |  |  |  |  |  |
Goto line number         |y |y |y |y |y |y |y |  |  |y |  |  |  |  |  |  |  |
Online manual            |~ |y |y |y |y |- |y |  |  |+ |  |  |  |  |  |  |  |
Context sensitive help   |n |y?|  |n |n-|  |  |  |  |+ |  |  |  |  |  |  |  |
Insert space             |n |  |n |n |y |y |n |  |  |n |  |  |  |  |  |  |  |
Open blank line before   |y |  |y?|y?|y |y |  |  |  |n |  |  |  |  |  |  |  |
Open blank line after    |y |  |y |y |y |y |y |  |  |n |  |  |  |  |  |  |  |
Insert/Overwrite mode    |y |y |n?|y |y |n |  |  |  |y |  |  |  |  |  |  |  |
Invert case char         |y |y |y |y |y |n |y |  |  |n |  |  |  |  |  |  |  |
Invert case region       |n |  |y |y |y |n |y |  |  |n |  |  |  |  |  |  |  |
Uppercase char           |n |  |n |n |y |n |  |  |  |n |  |  |  |  |  |  |  |
Uppercase region         |n |  |n |n |y |n |  |  |  |n |  |  |  |  |  |  |  |
Lowercase char           |n |  |n |n |y |n |  |  |  |n |  |  |  |  |  |  |  |
Lowercase region         |n |  |n |n |y |n |  |  |  |n |  |  |  |  |  |  |  |
Join lines               |y |  |! |! |y |y |  |  |  |! |  |  |  |  |  |  |  |
Split lines              |y |  |! |! |y |y |  |  |  |! |  |  |  |  |  |  |  |
Save/recall keystrokes   |- |y?|n |y |y |n |y |  |  |n |  |  |  |  |  |  |  |
Load file (replacing text|  |  |  |y |y |  |  |  |  |y |  |  |  |  |  |  |  |
Save/Load rulers         |NA|  |NA|y |y |? |  |  |  |n |  |  |  |  |  |  |  |
Goto begin next line     |y |  |  |  |y |n |  |  |  |n |  |  |  |  |  |  |  |
Goto begin prev line     |  |  |  |  |y |n |  |  |  |n |  |  |  |  |  |  |  |
Move cursor up by page   |y |y |y |y |y |y |y |  |  |y |  |  |  |  |  |  |  |
Move cursor dn by page   |y |y |y |y |y |y |y |  |  |y |  |  |  |  |  |  |  |
Move to next word        |y |y |y~|y~|y |n |y |  |  |y |  |  |  |  |  |  |  |
Move to prev word        |y?|y |y~|y~|y |n |y |  |  |y |  |  |  |  |  |  |  |
4-way scrolling/panning  |n |- |n |y |y |- |- |  |  |y |  |  |  |  |  |  |  |
Query key (show key bind)|n |n |n |n |y |n |n |  |  |n |  |  |  |  |  |  |  |
Abort editing session    |y |y |y |y |y |y |y |  |  |y |  |  |  |  |  |  |  |
Refresh the screen.      |y |y |y |y |y |y |y |  |  |NA|  |  |  |  |  |  |  |
Save w/ new name         |y |y |y |y |y |y |y |  |  |y |  |  |  |  |  |  |  |
Save macros to file      |  |y |  |n |y |y |  |  |  |n |  |  |  |  |  |  |  |
Save region to file.     |NA|y?|y |y |y |NA|y |  |  |y |  |  |  |  |  |  |  |
Send select text to shell|n |y?|n |n |y |n |  |  |  |n |  |  |  |  |  |  |  |
Spawn a new process/shell|~ |+ |y?|y |y |n |y |  |  |y |  |  |  |  |  |  |  |
Execute a system command.|y |+ |y |n |y |+ |? |  |  |+ |  |  |  |  |  |  |  |
Sort by selected columns |n |m?|n |n |y |y |  |  |  |n |  |  |  |  |  |  |  |
Spell check buffer       |m?|y?|n |n |y |n |  |  |  |n |  |  |  |  |  |  |  |
Spell check select text  |m?|y?|n |n |n |n |  |  |  |n |  |  |  |  |  |  |  |
Tab to next tab position.|NA|  |y |y |y |y |  |  |  |y |  |  |  |  |  |  |  |
Transpose character      |  |y |n |n |y |  |  |  |  |n |  |  |  |  |  |  |  |
Transpose line           |  |y |n |n |y |~ |  |  |  |n |  |  |  |  |  |  |  |
Trim leading spaces      |n |n |n |n |y |n |  |  |  |n |  |  |  |  |  |  |  |
Trim trailing spaces     |n |n |n |n |y |n |  |  |  |n |  |  |  |  |  |  |  |
Automatic trim trailing  |n |n |n |y?|n |O?|  |  |  |y |  |  |  |  |  |  |  |
Undelete char (own buff.)|n |y?|y |y |y |n |  |  |  |n |  |  |  |  |  |  |  |
Undelete word (own buff.)|n |y?|y |y |y |n |  |  |  |n |  |  |  |  |  |  |  |
Undelete line (own buff.)|n |y?|y |y |y |n |  |  |  |- |  |  |  |  |  |  |  |
Abort text region select |NA|y?|y |y |y |n |  |  |  |y |  |  |  |  |  |  |  |
Clear buffer             |  |  |  |  |y |  |y |  |  |  |  |  |  |  |  |  |  |
Repeat last cmd (+ multi)|+ |  |n |n |n~|- |  |  |  |n |  |  |  |  |  |  |  |
Repeat next cmd (+ multi)|+ |  |+ |+ |n |n |+ |  |  |n |  |  |  |  |  |  |  |
Repeat mult. cmds (macro)|n |y |n |y |y |n |y |  |  |n |  |  |  |  |  |  |  |
                         |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
Highlight selected text  |NA|n-|y |y |y |n |y |  |  |y |  |  |  |  |  |  |  |
                         |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
Markers                  |y |y |y?|y |n |n |  |  |  |y |  |  |  |  |  |  |  |
                         |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
Folding Editor           |n |n |n |n |n |- |n |  |  |n |  |  |  |  |  |  |  |
                         |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
Scroll/insert after EOL  |n |M?|n |y |y |y |y?|  |  |y |  |  |  |  |  |  |  |
Scroll/insert after EOF  |n |M?|n |y |n |- |y?|  |  |y |  |  |  |  |  |  |  |
                         |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
Has limited line length  |y |n |y |y |y |O?|n?|  |  |y |  |  |  |  |  |  |  |
Has limited on rows  (12)|y |  |  |  |y |  |  |  |  |y |  |  |  |  |  |  |  |
                         |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
Larger window sizing (11)|y?|Y |n?|n?|y |? |? |  |  |n |  |  |  |  |  |  |  |
Smaller window sizing    |y?|y |n |n |y |? |? |  |  |Y |  |  |  |  |  |  |  |
Window sizable (initial) |y-|y |n |n |y |n |  |  |  |y |  |  |  |  |  |  |  |
Window resizable         |y-|y |n |n |y4|n |  |  |  |y |  |  |  |  |  |  |  |
Multiple windows     (12)|n |y |n |y |n |n |#2|  |  |y |  |  |  |  |  |  |  |
Columnwise windows       |n |n |n |n |n |n |n |  |  |y |  |  |  |  |  |  |  |
Rowwise windows          |n |y |n |y |n |n |n |  |  |y |  |  |  |  |  |  |  |
Undo last command        |- |y |y |y |y |  |y |  |  |- |  |  |  |  |  |  |  |
Undo line changes        |y |y |n |n |n |  |  |  |  |n |  |  |  |  |  |  |  |
Undo historically        |n |y |n |n |n |n |  |  |  |n |  |  |  |  |  |  |  |
Multiple views of buffer |n |y |n |y |- |? |y |  |  |y |  |  |  |  |  |  |  |
                         |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
Automatic backup         |n |  |y |O |n |y |y |  |  |y |  |  |  |  |  |  |  |
Periodic backup          |n |  |n |y |y |y |y |  |  |n |  |  |  |  |  |  |  |
Interrupt recovery       |y |  |y |y |n |n |y |  |  |n |  |  |  |  |  |  |  |
Keeps session environ.   |n |y |n |- |- |- |m |  |  |+ |  |  |  |  |  |  |  |
                         |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
Status line(s)           |~ |y |n |y |yO|y |y?|  |  |y |  |  |  |  |  |  |  |
Support slow terminals   |y |n?|y |n |y |n |y |  |  |NA|  |  |  |  |  |  |  |
Support various terms.   |y |y |y-|y-|y |n |y-|  |  |NA|  |  |  |  |  |  |  |
Supports keypads         |n |y |y |y |y |y |y |  |  |y |  |  |  |  |  |  |  |
Supports func. keys      |n |y |y |y |y |y |y |  |  |y |  |  |  |  |  |  |  |
Display line nums option |y |~ |n |~ |~ |y |~ |  |  |~ |  |  |  |  |  |  |  |
                         |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
Scripting language       |y |y |n |? |y-|y |y |  |  |n |  |  |  |  |  |  |  |
                         |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
Mouse support (some vers)|n |y |n |y |y |n |n |  |  |+ |  |  |  |  |  |  |  |
Source provided (avail.) |n |y |n |n |y |n |n |  |  |! |  |  |  |  |  |  |  |
                         |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |

The following table indicates version availability for various machines.

   Y+   The version supports almost all basic functions plus some extensions
   Y    The version supports almost all basic functions
   y    The version supports most basic functions and may have some extensions
        or there is another editor (clone) which supporst most basic function.
   y-   The version supports most basic functions and has some restrictions
   n+   There is no specific version, but there exists another editor 
        with very similar features that supports many basic functions.
   n    There is no similar editor available.
   ?    It is possible that the could compile and run on this machine with
        little or no modification.
   -    Versions are only available for specific models/version of this
        machine/OS.
        
                         |  |  |  |  |  |  |  |  |  |  |u |  |  |  |  |  |  |
                         |  |FE|  |  |  |X |  |B |C |T |E |  |  |  |  |  |  |
                         |  |UM|  |S |R |E |  |R |R |u |M |  |  |  |  |  |  |
                         |  |LA|E |E |E |D |TE|I |I |r |A |  |  |  |  |  |  |
   Feature               |v |LC|D |D |D |I |PV|E |S |b |C |  |  |  |  |  |  |
                         |i | S|T |T |T |T |UE|F |P |o |S |  |  |  |  |  |  |
-------------------------+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
VAX/VMS                  |y |Y |Y |Y |? |n |y |  |  |n |  |  |  |  |  |  |  |
UNIX                     |Y |y |y |- |Y |y |- |  |  |n |  |  |  |  |  |  |  |
X windows versions       |n |Y |? |n |Y+|? |? |  |  |n |  |  |  |  |  |  |  |
MS/DOS                   |y |y |n+|Y |n |y-|n |  |  |Y |  |  |  |  |  |  |  |
OS2                      |  |  |  |  |n |  |  |  |  |y?|  |  |  |  |  |  |  |
MacIntosh                |  |  |  |  |n |  |  |  |  |n |  |  |  |  |  |  |  |
Amiga                    |y |y+|n |n |Y+|n |n |  |  |n |  |  |  |  |  |  |  |
Atari                    |y |y |n |Y |n |n |n |  |  |n |  |  |  |  |  |  |  |

The term 'buffers' (as in multiple buffers) refers to the editors' ability to
maintain multiple file editing sessions simultaneously

1  REDT can tally columns of numbers. Count, sum, average registers can be
   inserted in the text.
2  To qualify for cut/paste regions, the editor must be able to start/stop
   at a column within a line.  Vi and Xedit multiple line delete/copy doesn't
   qualify.
3  REDT uses columwise like region selection to define the sort key.
   Previous line orientation is preserved so that multiple key sorts 
   are possible.
4  REDT window resizing is supported in the Amiga and X windows version.

(10) EDT,SEDT,and REDT offer interactive search and replace, but not
   regular expressions.  Vi offers regular expressions but not interactive
   search and replace.  Borlands editors do this very well

(11) Does the editor offer window resizing greater than 80x25 if the 
    terminal (Ie Xwindow) supports it?  Can windows be made smaller than
    80x25? 

    SEDT and EVE/TPU will half window sizes for split screen and will
    extend window columns for 132 column mode terminals.  

    EDT supports 132 column terminals.  

    Vi may or may not size to the terminal's screen size depending on the 
    implementation.  

    Stevie (amiga and Atari?ST versions can be dynamically resized).

    EMACS resizes windows for split screens and will size windows for 
    Xwindows. 

    REDT will automatically size to the terminal screen size at startup
    but cannot be resized.  The Amiga and Xwindow versions can be resized 
    dynamically.

(12)             Max     Max     Max      Max
      Editor     Cols    Rows    Buffers  Windows

      VI         160?    ?       ?        1
      EMAX       nolim?  ?       ?        nolim
      EDT        ~400?   ?       1        1
      SEDT       ~400?   ?       9        2
      REDT       adjust  ~50000  9        1
      XEDIT      adjust  nolim?  1        1
      EVE        nolim?  nolim?  nolim?   2
      BORLAND    ~130    nolim?  nolim    nolim
      
      adjust - The user may adjust this limit before or during the editing
               session.
      
      nolim  - Limited only by available memory or other hardware limitations
               or a generally large arbitrary number.
      
      To qualify as having multiple buffers, the user should be able to (at
      least) easily move between buffers, and cut/paste (yank/put) text.

  
_____________________________________________________________________
      ______________
____  | ^          |    Roger Nelson          rnelson@wsuaix.csc.wsu.edu
\^^ | | ^          |    Biological Systems Engineering Department
 |^^//  ^^         |
 |  '  ^          +|<---Washington State University
 \_  ^    _________|    Pullman, WA 99164-6120
   `-----'              Work: (509)335-4714  Home: (509)332-8387
                        FAX: (509)335-2722


 