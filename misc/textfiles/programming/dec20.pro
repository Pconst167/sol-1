Here is a guide to using the decsystem-20. Good for nostalgia!

You might have got my last message, in which case ignore this one. But
I'm not sure
whether it was sent or not...

Love the site, by the way. Very well done. I must try it in Lynx :-)

-malc.
--- cut here ---

      %
      % %         d u n d e e   c o l l e g e 
  %%%%% %
 %   ** %%%       o f   t e c h n o l o g y
 |  * % %
  \ *_/ %  
    \__ %         Computer Centre
    
    
    
    
    
                  Introduction to using the 
		  
		  DECSYSTEM-20
		  
		  
		  
		  Programming Information PI16
		  
		  
		  
		  
		  
		  
		  
		  
		  
		  
		  
		  Introduction To Using The DECSYSTEM-20
		  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		  
		             C O N T E N T S
		             ~~~~~~~~~~~~~~~
			     
Section                                                 Page
~~~~~~~                                                 ~~~~

1.      INTRODUCTION                                      1

2.      GETTING ACQUAINTED                                2
  2.1     Identifying Yourself                            2
  2.2     Leaving The System                              2
  2.3     Using Two Easy Commands                         3
  
3.      STORING YOUR PROGRAM IN THE COMPUTER              4
  3.1     Using EDIT                                      4
  3.2     Correcting Typing Errors                        5
  
4.      RUNNING YOUR PROGRAM                              6
  4.1     Executing Your Program                          6
  4.2     Checking Your Program                           6
  4.3     Stopping Your Program                           6
  
5.      CHANGING YOUR PROGRAM                             7
  5.1     Starting EDIT                                   7
  5.2     Printing a Line                                 7
  5.3     Inserting a Line                                7
  5.4     Deleting a Line                                 7
  5.5     Replacing a Line                                8
  5.6     Changing a Line Without Completely Retyping It  8
  5.7     Saving the File                                 8
  
6.      WORKING WITH FILES                                9
  6.1     Listing the Names Of Your Files                 9
  6.2     Deleting a File                                 9
  6.3     Restoring a File                                9
  6.4     Listing Your Program on Your Terminal          10
  6.5     Listing Your Program on the Line Printer       10
  6.6     Copying a File                                 10
  
7.      LETTING TOPS-20 DO SOME OF THE WORK              11
  7.1     Getting information about Command Names        11
  7.2     Getting information about Command Arguments    11
  7.3     Letting TOPS-20 type part of a command         11
  7.4     Correcting TOPS-20 Commands                    12
  7.5     Abbreviating Commands                          12
  7.6     Getting information about TOPS-20 Programs or  13
          Facilities

8.      RUNNING A SYSTEM PROGRAM                         14

9.      USING BASIC                                      15
  9.1     Starting BASIC                                 15
  9.2     Entering Your Program                          15
  9.3     Saving Your Program                            15
  9.4     Running Your Program                           15
  9.5     Changing Your Program                          16
  9.6     Replacing Your Program                         16
  9.7     Listing Your Program                           16
  9.8     Running An Existing Program                    16
  9.9     Leaving BASIC and logging out                  16
  
10.     SUMMARY OF TOPS-20 COMMANDS                      17
  10.1    System Access Commands                         17
  10.2    File System Commands                           17
  10.3    Device Handling Commands                       18
  10.4    Program Control Commands                       19
  10.5    Information Commands                           20
  10.6    Terminal Commands                              20
  10.7    BATCH Commands                                 21
  10.8    CTRL Commands                                  21
  
11.     REFERENCES                                       22







                                         PI16/4  DEO/KLB   January 1983
					 Retyped  M.MacArthur June 1993
                                     - 1 -

1.      INTRODUCTION
~~~~~~~~~~~~~~~~~~~~

This brief guide introduces you to both the DECSYSTEM-20 and the basic
commands of the TOPS-20 Command Language, as used from an on-line
terminal.

Each section describes the minimum number of steps needed to accomplish 
common tasks.  For fuller information the appropriate DECSYSTEM-20
manuals
should be consulted.  As you use this guide you should try each
procedure
described at a computer terminal - the easiest and surest way of
learning 
about TOPS-20 is to use it.

The following conventions have been used in this guide

      Convention                             Meaning
      ~~~~~~~~~~                             ~~~~~~~
        <RET>             means press the carriage RETURN
	                    (CR) key on your terminal.
			    
	  $               means press the ESCape (or ALTMODE) key on your
	                    terminal( not to be confused with the $ key).
			    
          _               (underlining) in examples, indicates what you
	                    should type if you want to try the examples.
			  
	CTRL/x            means press the CTRL key and, at the same time, 
	                    type the letter after the slash (e.g. CTRL/C
			    means press the CTRL key and type C). The 
			    charachter represented by CTRL/x is called a 
			    control charachter
			    
	 TAB              means press the TAB key on your terminal.  If 
	                    your terminal does not have a TAB key, a
			    CTRL/I may be typed instead.
			    
			    
			    
			    
			    
Acknowledgement is due to Digital Equipment Co. for co-operation in
permitting the reproduction of the material which forms the basis of
this
booklet.


                                 - 2 -
				 
2.      GETTING ACQUAINTED
~~~~~~~~~~~~~~~~~~~~~~~~~~
2.1     Identifying Yourself
        ~~~~~~~~~~~~~~~~~~~~
	In order to begin using the system, do the following:
	
	i)   Ask someone to show you how to turn on the computer terminal.
	
	ii)  After you turn on the terminal, press the key labelled CTRL
	     and, at the same time, type the letter C.
	     
	iii) After you see the @, which is the system prompt, type LOGIN
	     and press the key labelled ESC.  After the system prints
	     (USER), type your user name and press the ESC key.  After
	     the system prints (PASSWORD), type your password and press 
	     the ESC key.  After the system prints (ACCOUNT), type your
	     account number and press the key labelled RETURN.
	     
	     In Dundee College of Technology, you should give the room
	     number of the romm in which you are working as the account 
	     code.  If the room number contains a point, it should be hyphen-
	     ated, e.g. 4322-1   shouldbe used as the account code in
	     room 4322.1.  When logging in from an external location over
	     a telephone line, the account TELE should be used
	     
        This procedure is called logging-in.  Below is an example of how
	you would identify yourself if your user name were DES-B2, your
	password FREDDY, and if you were working in room 3506.
	
	     _CTRL/C_
	     MR2172 Dundee Coll of Tech. TOPS-20 Monitor 5(4747)
	     There are 30+5 jobs and the load average is 0.76
	     @_LOGIN$_ (USER)  _DES-B2$_   (PASSWORD) _$_ (ACCOUNT) _3506_<RET>
	     
	      Job 17 on TTY20 8-Nov-82 13:00:40
	      
	     @
	     
	Note that your password is not echoed (printed) at your terminal, for
        security reasons.  It is in your own interest not to reveal your
pass-
	word to other users, and you should not interfere with directories and
	files other than those you are authorised to use.
	
2.2     Leaving the System
        ~~~~~~~~~~~~~~~~~~
	When you are finished using the system, do the following:
	
	      After you see the @, type LOGOUT, and press the key labelled 
	      RETURN. The system then prints a sign-off message.
	      
	This procedure is called logging-out.  Below is an example of how you
	would leave the system.
	
	      @_LOGOUT_<RET>
	       Killed Job 17, User DES-B2, Account 3506, TTY 20,
	         at 8-Nov-82 13.10.55 Used 0:0:9 in 0:10:15
		 
		 
		                  - 3 -
				  
2.3    Using Two Easy Commands
       ~~~~~~~~~~~~~~~~~~~~~~~
       To find out who else is using the system, after you see the @,
type
       the command SYSTAT and press the key labelled RETURN.
              
	      @_SYSTAT_
	       Mon 8-Nov-82 13:01:30 Up 3:46:54
	       15+7 Jobs Load Av 2.54 2.42 2.03
	       
	       System shutdown scheduled for 9-Nov-82 09:30:00
	       
	       Job  Line  Program  User
	       
	         8   26    EXEC     EES-B3
		 9   41    EDIT     PHT-STAFF
		10    6    FORTRA   MCS-D1
		.
		.
		.
	      @
	      
	To get today's date and time, after you see the @, type the command
	DAYTIME and press the RETURN key.
	
	      @_DAYTIME_
	      
	       Monday, November 8, 1982 13:02:16
	       
	      @
	      
	Now that you know hoe to get on and off the system and also how to
	type several commands, your next task is to get your program into
	the computer so that you can run it.  Turn to Section 3 - STORING
	YOUR PROGRAM IN THE COMPUTER and continue.
	
	If you have a BASIC language program, turn to Section 9 - USING BASIC.
	
	
	
	
	
	
	
	
	
	                             - 4 -
				     
3.      STORING YOUR PROGRAM IN THE COMPUTER
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



If your program is written in the BASIC language, you do not have to
read
this section.  Turn to Section 9 - USING BASIC to find out how tp get
your
BASIC program into the computer and run it.


First you must get your program into a file in your area of disk
storage, 
because the DECSYSTEM-20 keeps all programs in files.  Choose a name for
your file; in general it is better if this name is not more than six
charachters long.  If the program you are going to put in the file is a 
FORTRAN program, add .FOR to the end of the name; if it is a COBOL
program
add .CBL to the end; if it is an ALGOL program, add .ALG to the end. 
These
three-letter combinations (.FOR, .CBL, and .ALG) are called file types. 
If
you name your FORTRAN program TEST, the file name and file type appear
together as TEST.FOR.

3.1     Using EDIT
        ~~~~~~~~~~
	After you have a name for your file, do the following:
	
	i)    After you see the @, type CREATE and press the ESC key.
	
	ii)   After you see (FILE), type the file name and file type you have
	      chosen for your file, and press the RETURN key.
	      
	iii)  After you see 00100, type the first line of your program and
	      press the RETURN key.
	      
	iv)   After you see the next line number (i.e. 00200), type the second
	      line of your program and press the RETURN key.
	      
	v)    Continue typing your program; wait for the line number, type
	      the next line of your program, and then press the RETURN key.
	      
	vi)   Type the last line of your program, but press the ESC key instead
	      of the RETURN key.
	      
	vii)  After you see the *, type E (for End) and press the RETURN key.
	
	e.g.  @_CREATE$_  (FILE) _TEST.FOR_<RET>
	      Input:  TEST.FOR.1
	      00100   _     WRITE (5,1010)_<RET>
	      00200   _1010 FORMAT(` THIS IS A TEST.')_<RET>
	      00300   _     END$_
	      *_E_<RET>
	      [TEST.FOR.1]
	      @
	      
	      The name used for the FORTRAN program in this example was TEST.
	      Note that typing E in response to the EDIT prompt * returns you
	      to MONITOR level with the @ prompt.


                                   - 5 - 
				
				
3.2     Correecting Typing Errors
        ~~~~~~~~~~~~~~~~~~~~~~~~~
	You can type a CTRL/U on a line to tell the system to ignore what you
	have typed so far because you want to start the line over again.  In
	addition to correcting a line by typing it over, you can correct one 
	or more charachters on the line with the DELETE key.  The way you  
	correct a typing error with the DELETE key depends on when you notice
	it:
	
	  -   If you notice that you have just mistyped a charachter, press the
	      DELETE key.  The last charachter you typed will be erased.  Now
	      type the correct charachters and continue typing the line:
	      
	      00400    _REEE\AD (X);_
	                  ^                    You pressed the DELETE key here
			  |___________________ to erase the second E.  Note
			                       that TOPS-20 prints the deleted
					       charachter followed by a \ when
					       you press the DELETE key.
					       
	  -  If you mistyped a charachter, but did not notice it until you 
	     typed more charachters on the same line, press the DELETE key as 
	     many times as it takes to erase the line back through the mistyped
	     charachter.  Now type the correct charachter and the rest of the 
	     line.
	     
	     After deleting charachters, you can have the current line 
	     reprinted, in a tidier form for checking, by typing CTRL/R;  you 
	     may then continue to type the rest of the line.
	                                                          CTRL/R -*
	     00600  _WRITE (`[C] THE SQUAROOT OF_F\O\ \T\O\O\_EROOT OF `);_
	                                        ^-----------:
	     00600  WRITE (`[C] THE SQUAREROOT OF `);       |
	                                                    |
			                You pressed the DELETE key six times
					to erase the word OF, a space, and
					the letters OOT. Note that TOPS-20 
					prints the six deleted charachters,
					each followed by a backslash (\).
					
	  -   If you mistyped a charachter but did not notice it until you
	      pressed the RETURN key at the end of the line, turn to Section 5-
	      CHANGING YOUR PROGRAM and learn how to replace a line in your 
	      file.
	      
	Now that you have entered your program into a file, you must inform 
	TOPS-20 that you want it translated, loaded, and started.  Turn to 
	Section 4 - RUNNING YOUR PROGRAM to learn the necessary steps for
	this task.
	
	
	                         - 6 -
				 
4.       RUNNING YOUR PROGRAM
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
4.1      Executing Your Program
         ~~~~~~~~~~~~~~~~~~~~~~
	 To translate, load, and start your program, do the following:
	 
	 i)    After the @,type EXECUTE and press the ESC key.
	 
	 ii)   After the guide word (FROM), type the file name and file type,
	       and press the RETURN key.
	       
	 @_EXECUTE$_ (FROM) _SQRT.ALG_<RET>   The file type .ALG tells the 
	 ALGOL:  SQRT                         system to translate your program
	                                      using the ALGOL compiler.
	 LINK:   Loading                      
	 [LNKXCT SQRT Execution]              Execution begins.
	  TYPE THE VALUE OF X: _34.562_<RET>  Obtain the square root of 34.562
	  
	  THE SQUAREROOT OF 34.562 IS 5.879   The answer is 5.879
	  
	 End of Execution
	 
	 @                                    The program execution is finished
	                                      when the system prints the @.
					      
					      
					
4.2     Checking Your Program
        ~~~~~~~~~~~~~~~~~~~~~
	If you want to check on the progress of your program while it is 
	running, type T while pressing the CTRL key. This is called typing a 
	CTRL/T; it will not interfere with the running of your program in any 
	way.
	
	@_EXECUTE$_ (FROM) _SQRT.ALG_<RET>
	ALGOL:  SQRT
	_<CTRL/T>_ALGOL Running at 410644 Used 0:00:20.3 in 0:09:54 Load 0.64
	LINK:   Loading
	[LNKXCT SQRT Execution]
	.
	.
	.
	@
	
	
4.3     Stopping Your Program
        ~~~~~~~~~~~~~~~~~~~~~
	There may be times when you want to stop your program while it is still
	running.  To do so, type C twice while pressing the CTRL key.  You
	will then see an @, which means you can type any TOPS-20 command.
	
	@_EXECUTE$_ (FROM) _SQRT.ALG_<RET> The user executes the program.
	ALGOL:  SQRT
	200  IMPROPER DECLARATION          The user finds an error, so he types
	_<CTRL/C><CTRL/C>_                 two CTRL/C's to stop the process.
	^C
	
	@
	
	You have now learned how to enter and run your program. Sometimes, how-
	ever, your program may not contain an error and thus return incorrect
	results, or, more often, simply not execute. In such cases, you must
        modify it; turn to Section 5 - CHANGING YOUR PROGRAM.
	
	
                                     - 7 -
				     
				  
5.      CHANGING YOUR PROGRAM
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
5.1     Starting EDIT
        ~~~~~~~~~~~~~
	To use EDIT to change your program, after you see an @, type EDit, and
	press the ESC key.  After the computer prints (FILE), type the file
	name and file type of the file you want to change.Press the RETURN key.
	
	@_EDIT_ (FILE) ADDTWO.FOR
	Edit:  ADDTWO.FOR.1
	*
	
	Note:  If you type the name of a file which does not exist, the system
	       prints:
	      
	      %File not found, Creating New file
	      Input:  ADDTWO.FOR.1
	      00100
	      
	      allowing you to create a new file.  If you mistyped the file name
	      or file type, press the ESC key and type EQ (for End and Quit),
	      then press the RETURN key.  The system will print @.
	      Now type another EDIT command and give the correct file name.
	      
	      
5.2     Printing a Line
        ~~~~~~~~~~~~~~~
        To print a line of your file, type P and the number of the line
you 
	want printed.  Press the RETURN key.
	
	*_P200_<RET>
	00200                WRITE (5,1910)
	*
	
	
5.3     Inserting a Line
        ~~~~~~~~~~~~~~~~
	To insert a new line in your file, type I and the line number you
        want your new line to have.  Press the RETURN key.  After you
see the
	line number, type the new line and press the RETURN key again.
	
	*_I450_<RET>
	00450              _ 1820 FORMAT (2F)_<RET>
	*
	
	
5.4     Deleting a Line 
        ~~~~~~~~~~~~~~~
	To delete a line in your file, type D and the number of the line you
	want deleted.   Press the RETURN key.  EDIT replies with the number
	of lines deleted.
	
	*_D500_<RET>
	1 Lines (00500/1) deleted     - line 500 on page 1 of the file deleted.
	*


                                     - 8 -
				     
				     
5.5     Replacing a Line
        ~~~~~~~~~~~~~~~~
	To delete a line in your file and insert a new line in its place, type
	R and the number of the line you want to replace.  Press the RETURN
	key.  After you see the line number, type the new line and press the
	RETURN key again.  EDIT prints a message telling you how many lines
	you deleted.
	
	*_R200_<RET>
	00200         _WRITE (5,1820)_<RET>
	1 Lines (00200/1) deleted
	*
	
	
5.6     Changing a Line Without Completely Retyping It
        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	To replace an existing group of charachters on a line with a new group
	of charachters, type S (for Substitute) and the existing group of 
	charachters, then press the ESC key (EDIT prints a $ every time you
	pres the ESC key).  Type the new charachters, then press the ESC key
	again. Type the number of the line that contains the existing group of
	charachters, and then press the RETURN key.
	
	For example, the existing contents of line 800 are:
	
	00800   1030 FIRMAT (`ADDING `,F,' TO `,F,' GIVES `,F)
	
	To correct this line, FIRMAT should be FORMAT.  The command 
	SFIRMAT$FORMAT$800 replaces all occurences of FIRMAT with FORMAT 
	on line 800.
	
	*_SFIRMAT$FORMAT$800_<RET>
	00800   1030 FORMAT (`ADDING `,F,' TO `,F,' GIVES `,F)
	*
	
5.7     Saving The File
        ~~~~~~~~~~~~~~~
	To finish using EDIT and save the edited file, type E and press the 
	RETURN key.
	
	*_E_<RET>
	
	[ADDTWO.FOR.2]
	@
	
	You have now learned the process of entering, executing, editing and
	saving a program.  By this time, you should have several files in 
	your area of the disk.  The next task you will learn is how to list
	the names of all your files.  Turn to Section 6 - WORKING WITH FILES.
	
	
	
	                           - 9 -
				 
				 
6.      WORKING WITH FILES
~~~~~~~~~~~~~~~~~~~~~~~~~~
6.1     Listing the Names of Your Files
        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	To obtain a list of the names of your files, do the following:
	
	   After you see an @, type DIRECTORY and press the RETURN key.
	   
	The names of your files, along with other information about them, will
	be printed on your terminal.  The following example shows a typical 
	response from TOPS-20 when you type DIRECTORY.
	
	@_DIRECTORY_<RET>
	
	 PS:<DES-B2>
	 ADDTWO.FOR.2
	    .QOR.1
	    .REL.2
	 SQRT.ALG.1
	    .REL.1
	    
	Total of 5 files
	
	@
	
	The disk structure (PS: in the above example) on which your directory
	resides precedes the directory name.  The number after the file type
	is a generation number supplied by TOPS-20.  These numbers indicate
	how many times you have changed each file.
	
	
6.2     Deleting a File
        ~~~~~~~~~~~~~~~
	To remove a file that you no longer want, do the following:
	
	    After you see an @, type DELETE, press the ESC key, and type
	    the name of the file you want to mark as deleted.  Press the 
	    RETURN key.  The system responds by printing the name of the
            file it has delted.
	    
	    @_DELETE$_ (FILES) _ADDTWO.QOR_<RET>
	     ADDTWO.QOR.1 [OK]
	    @
	    
	If you want to mark more than one file for deletion, separate each file
	specification with a comma.  When a file is marked for deletion, it is
	not immediately removed from the system.
	
	
6.3     Restoring a File
        ~~~~~~~~~~~~~~~~
	If you delete a file by mistake, you can retrieve it by typing 
	UNDELETE, pressing the ESC key, and typing the name of the file. Then
	press the RETURN key. The system responds by printing the name of the
	file it restored.
	
	@_UNDELETE$_ (FILES) _ADDTWO.QOR_<RET>
	 ADDTWO.QOR.1 [OK]
	@
	
	The command should be given as soon as you notice that you deleted
        the file by mistake. Otherwise, the file may not be restorable.
In
	addition, you cannot restore the file once you log off the system.
	
	
	
	                        - 10 -
				
				
6.4     Listing Your Program on Your Terminal
        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	If you want a copy of your program listed on your terminal, do the
	following:
	
	    After you see an @, type TYPE, press the ESC key, and type
	    the name and file type of the file containing your program.
	    Press the RETURN key.
	    
	    @_TYPE$_ (FILE) _ADDTWO.FOR_<RET>
	    
	    If, for any reason, you want to stop the listing of your file, 
	    press the CTRl key and, at the same time, type the letter O,
	    (i.e. type a CTRL/O).  To resume printing, type another CTRL/O.
	    
	    
6.5     Listing Your Program on The Line Printer
        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	If you want to get a copy of your program listed on the line printer
	in the Computer Centre, do the following:
	
	   After you see an @, type PRINT, press the ESC key, and type
	   the name and file type of the file containing your program.
	   Press the RETURN key.
	   
	   @_PRINT$_ (FILES) _SQRT.ALG_<RET>
	   [Job SQRT Queued, Request-ID 963, Limit 52]
	   @
	   
	  
6.6     Copying a File
        ~~~~~~~~~~~~~~
	If you want to copy one of your files and store it as another file in
	your area, do the following:
	
	i)    After you see an @, type COPY and press the ESC key.
	
	ii)   After the system prints (FROM), type the complete name of 
	      the file you want to copy and press the ESC key.
	      
	iii)  After the system prints the generation number and (TO), type
	      the name you want the new file to have and press the RETURN
	      key.
	      
	      @_COPY$_ (FROM) _ADDTWO.QOR$_.1 (TO) _ADDTWO.BAK_<RET>
	       ADDTWO.QOR.1 => ADDTWO.BAK.1 [OK]
	      @
	You now have the basic information you need in order to enter your
	program, to edit it, and to run it.  You also know how to list the 
	names of your files, to delete any files you no longer want to keep,
	and to obtain copies of your files.  The next section tells you 
	how to make TOPS-20 do still more work for you.  Turn to Section 7 -
	LETTING TOPS-20 DO SOME OF THE WORK.


                                  - 11 -
	
	
7.      LETTING TOPS-20 DO SOME OF THE WORK
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
7.1     Getting Information About Command Names
        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	
	To get a list of all the TOPS-20 commands, type a ? after you see an @.
	
	e.g.  @_?_
	
	To get a partial list of TOPS-20 commands, type one or more letters
        and a ?.
	
	e.g.  @_A?_             - list all commands beginning with letter A.
	
7.2     Getting Information About Command Arguments
        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	To find out the arguments TOPS-20 expects you to type after you type
        a particular command name, do the following:
	
	i)    After you see an @, type the command name and a space.  Then 
	      type a ?.
	      
	ii)   After TOPS-20 types the arguments it expects and retypes the 
	      command name on the next line, type the argument you want to 
	      use. Press the RETURN key at the end of the argument.
	      e.g.
	      
	      @_INFORMATION$_ (ABOUT) _?_ one of the following:
	      
	      ADDRESS-BREAK           ALERTS               ARCHIVE-STATUS
	      ARPANET                 AVAILABLE            BATCH-REQUESTS
	      COMMAND-LEVEL           DECNET               DEFAULTS
	      DIRECTORY               DISK-USAGE           DOWNTIME
	      ERROR-MESSAGE           FILE-STATUS          FORK-STATUS
	      JOB-STATUS              LOGICAL-NAMES        MAIL
	      MEMORY-USAGE            MONITOR-STATISTICS   MOUNT-REQUESTS
	      OUTPUT-REQUESTS         PLOT-REQUESTS        PRINT-REQUESTS
	      PROGRAM-STATUS          PSI-STATUS           RETRIEVAL-REQUESTS
	      SPOOLED-OUTPUT-ACTION   STRUCTURE            SUBSYSTEM-STATISTICS
	      SYSTEM-STATUS           TAPE-PARAMETERS      TERMINAL-MODE
	      VERSION                 VOLUMES
	      
	      @INFORMATION (ABOUT) _DISK-USAGE$_ (OF DIRECTORY)<RET>
	       118 pages assigned, 110 in use, 8 deleted
	       300 Working pages, 200 Permanent pages allowed
	       39634 Pages free on PS:, 112773 pages used
	      
7.3     Letting TOPS-20 Type Part of a Command
        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	If you want TOPS-20 to help you type a command, press the ESC key 
	after typing any part of the command.  If it is able to help you, 
	TOPS-20 will type as much of the command as it can and then wait for 
	you to type in more. If TOPS-20 is not able to help you, it will ring
	the terminal's bell and wait for you to type in more of the command.
	
	This method of typing is called RECOGNITION INPUT.
	
	e.g.  @_TY$_PE (FILE) _A$_DDTWO._F$_OR.2<RET>
	
	When you press the ESC key after typing TY, TOPS-20 responds with the
	rest of the command name and the guide word (FILE) indicating that it
	wants you to give a name of a file as an argument.  After typing the
	first charachter of the name, press the ESC key again. TOPS-20 com-
	pletes the name for you and stops when it tries to complete the file 
	type.
	
	
	                          - 12 - 
			
			
        Because you have more than one file with the name ADDTWO,
TOPS-20 
	cannot choose a file type.  Type only the first letter of the file
	type and press the ESC key. TOPS-20 then completes the file type
	and generation number.  Press the RETURN key to get the file printed
	on your terminal.
	
	
7.4     Correcting TOPS-20 Commands
        ~~~~~~~~~~~~~~~~~~~~~~~~~~~
	When you use recognition input, you will notice that a TOPS-20 command 
	consists of a command name, guide words, and arguments.   In 
	the command:
	
	@TYPE (FILE) ADDTWO.FOR
	
	the command name is TYPE, the guide word is (FILE), and the argument
	is ADDTWO.FOR.  When you do not use recognition input, a TOPS-20 
	command will consist only of a command name and arguments.
	
	Commands are divided into fields.  Each command name or argument you 
	type begins a field, and the next keyword argument you type begins
	the next field.  The fields, separated by vertical lines, of several
	commands are shown below.
	
	@LOGIN (USER) | DES-B2 (PASSWORD) | password (ACCOUNT) | 3506
	@TYPE (FILE) | ADDTWO.FOR
	@COPY (FROM) | FRED.FOR (TO) | FRED2.FOR
	
	There are three methods of correcting typing errors in TOPS-20 commands
	
	1.    Pressing the DELETE key erases the previous charachter.
	
	2.    Typing a CTRL/W erases back to the start of the current field.
	
	3.    Typing a CTRL/U erases the entire current line.
	
	
7.5     Abbreviating Commands
        ~~~~~~~~~~~~~~~~~~~~~
	When you have become very familiar with the use of the common TOPS-20
	commands, you may wish only to type abbreviated versions, without
	invoking recognition input every time.  Only sufficient letters at the
	start of each keyword need to be typed to permit the system to 
	recognise it uniquely.
	
	e.g.  @_INFO$_RMATION (ABOUT) _DISK$_-USAGE<RET> - recognition input
	      @_INFORMATION DISK-USAGE_<RET>             - full input
	      @_INFO DIS_<RET>                         ) - abbreviated
	      @_I DIS_<RET>                            )     input
	      
	         are all acceptable to the system;
		 
              @_I DI_<RET>
	      
	         is not acceptable because DI is insufficient to define the
		 second keyword - it could mean DIRECTORY or DISK-USAGE.
		 
		 
		 
		                    - 13 -
				    
				    
7.6     Getting Information About TOPS-20 Programs or Facilities
        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	If you want to get a list of programs or facilities that have infor-
        mation on how to use them, type HELP, a space, and a ?.
	
	
	@_HELP ?_
	
	If you want to get information about a certain program or facility,
	type HELP, a space, and the name of the program or facility.  Press
	the RETURN key.
	
	Now that you have learned some of the helpful features of TOPS-20,
	in addition to learning how to run your program, you may want to
	learn how to run a system program.  Turn to Section 8 - RUNNING A
	SYSTEM PROGRAM.
	
	
	
	
	
	
	
	
	                           - 14 -
				   
				   
8.      RUNNING A SYSTEM PROGRAM
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
The TOPS-20 system includes a variety of general-purpose system
programs,
provided by the manufacturer, that help you get your work done.   The
method of using such programs is generally similar.   It is illustrated 
here by an example of using the FILCOM program to compare two files and
tell you the differences between them.  Let us assume that two files
have
been created previously in your directory and that their names are 
FIRST.FIL and SECOND.FIL.  The following steps would then be followed:

i)     Start the system program by typing its name and pressing the
RETURN 
       key.  Most system programs respond by printing an * prompt on
your
       terminal.
       
       @_FILCOM_<RET>
       
       *
       
ii)    After the *, type the place where you want the program to output
the
       results, followed by an equals sign, then tye the name of the
input 
       file(s).  If there is more than one input file, separate the file
names
       with commas:
       
       *_TTY:=FIRST.FIL,SECOND.FIL_<RET>
       
iii)   After the program finishes all the tasks you have for it, stop it
by 
       typing a single CTRL/C.
       
       *_  <----- CTRL/C
       
       @
       
In the above  example, the system will print out at your terminal (i.e.
TTY:)
a list of all the differences found between the two files FIRST.FIL and
SECOND.FIL.







                                  - 15 -
				
				
9.      USING BASIC
~~~~~~~~~~~~~~~~~~~

If you want to run a BASIC program, you can enter it directly into
BASIC; you
should not use EDIT.

9.1     Starting BASIC
        ~~~~~~~~~~~~~~
	After you see the @, type BASIC and press the RETURN key.
	
	@_BASIC_<RET>
	
	READY
	
	
9.2     Entering Your Program
        ~~~~~~~~~~~~~~~~~~~~~
	If you want to enter a new BASIC program, do the following:
	
	i)    After you see READY, type NEW and press the RETURN key.
	
	ii)   After you see the NEW FILE NAME--, type a name up to 6 char-
	      achters long for your program and press the RETURN key.
	      
	iii)  After you see READY, begin typing your program.  Start each 
	      new line with a line number, type the contents of the line and
	      press the RETURN key at the end of each line. To erase a
	      charachter on the current line, press the DELETE key.
	      
	      _NEW_<RET>
	      NEW FILE NAME--_SQUARE_<RET>
	      
	      READY
	      
	      
9.3     Saving Your Program
        ~~~~~~~~~~~~~~~~~~~
	Once you have finished entering your program type SAVE and press the 
	RETURN key.  When BASIC is finished saving your program, it prints
	the word READY.
	
	_SAVE_<RET>
	
	READY
	
	In the above example the program would be saved as a file in your
	directory on disk with the filename SQUARE.BAS.1
	
	
9.4     Running Your Program
        ~~~~~~~~~~~~~~~~~~~~
	To run your program, type RUN and press the RETURN key.
	
	_RUN_<RET>
	
	SQUARE        13:08         9-NOV-82
	
	TYPE A NUMBER.
	 ?_34.5_<RET>
	THE SQUAREROOT OF   34.5   is   5.87367
	
	TIME: 0.14 SECS.
	
	READY
	
	

                               - 16 -
			       
			       
9.5     Changing Your Program
        ~~~~~~~~~~~~~~~~~~~~~
        To change your program, type the number of the line you want to 
	change.  Then type the new contents of that line and press the RETURN 
	key.
	
	_400 INPUT X_<RET>
	_500 Y = SQR(X)_<RET>
	
	
9.6     Replacing Your Program
        ~~~~~~~~~~~~~~~~~~~~~~
	After you have finished changing your file, type REPLACE and press the
	RETURN key.  The REPLACE command works only for programs that you have
	already saved.
	
	_REPLACE_<RET>
	
	READY
	
	
9.7     Listing Your Program
        ~~~~~~~~~~~~~~~~~~~~
	To list the entire program, type LIST and press the RETURN key.
	
	_LIST_<RET>
	
	To list a single line of your program, type LIST followed by the line
	number and press the RETURN key.
	
	
9.8     Running An Existing Program
        ~~~~~~~~~~~~~~~~~~~~~~~~~~~
	If you want to run an existing BASIC program do the following:
	
	i)    After you see READY type OLD, a space, and the name of the
	      existing progra. Press the RETURN key.
	      
	ii)   After you see READY, type RUN and press the RETURN key.
	
	      _OLD RANDOM_<RET>
	      
	      READY
	      _RUN_<RET>
	      
	      
9.9     Leaving BASIC and Logging Out
        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	To leave BASIC and log out, type MONITOR and press the RETURN key.
	Then type LOGOUT and press the RETURN key.
	
	
	
	                          - 17 -
				  
				  
				 
10.     SUMMARY OF TOPS-20 COMMANDS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This summary lists and briefly explains all commands in the TOPS-20
Command
Language which are relevant to normal use of the system.  The commands
are
grouped in categories of similar use.  Although most of these commands
have
not been described in this guide, the purpose of this summary is to make
you
aware of the full extent and capability of the TOPS-20 Command Language.

10.     System Access Commands
        ~~~~~~~~~~~~~~~~~~~~~~
	These commands allow you to gain and relinquish access to the system
	
	ATTACH      Connects your terminal to a designated job.
	
	DETACH      Disconnects your terminal from the current job without
	            affecting the job.
		    
        DISABLE     Returns a privileged user to normal status.
	
	ENABLE      Permits privileged users to access and change confidential
	            system information.
		    
	LOGIN       Gains access to the TOPS-20 system.
	
	LOGOUT      Relinquishes access to the TOPS-20 system.
	
	UNATTACH    Disconnects a terminal from a job; it does not have to be 
	            the terminal you are using.
		    
		    
10.2    File System Commands
        ~~~~~~~~~~~~~~~~~~~~
	The file system commands allow you to create and delete files, to 
	specify where they are to be stored, and to output them on any
	device.
	
	ACCESS      Grants ownership and group rights to a specific directory.
	
	APPEND      Adds information from one or more source files to an
	            existing disk file
		   
	ARCHIVE     Marks a file for long-term off-line storage.
	
	BUILD       Allows you to create, change and delete subdirectories.
	
	CANCEL      Removes a previous request from a system queue e.g. BATCH
	            or Line Printer queue.
		    
	CLOSE       Close a file or files left open by a program.
	
	CONNECT     Removes you from your current directory and connects you to
	            a specified directory.
		    
	COPY        Duplicates a source file in a destination file, on the same
	            or another device.
		    
	CREATE      Starts EDIT for the purpose of making a new file
	
	DELETE      Marks the specified file(s) for eventual deletion (disk 
	            files only).
		    
	DEFINE      Associates a logical name with one or more file names,
	            directory or structure names.
		    
	DIRECTORY   Lists the names of files residing in the specified 
	            directory and information relating to those files.
		    
		    
		    
		                  - 18 -
				  
				  
       
	DISMOUNT    Notifies the system that the given structure or magnetic
	            tape is no longer needed.
		    
	EDIT        Starts EDIT for the purpose of changing an existing file.
	
	EXPUNGE     Permanently remoes any deleted files from the disk.
	
	FDIRECTORY  Lists all the information about a file or files.
	
	MODIFY      Changes and/or adds switches to a previously issued PRINT
	            or SUBMIT command.
		    
	PRINT       Places one or more files in the output queue for printing
	            on the Line Printer.
		    
	RENAME      Changes one or more descriptors of the file specification
	            of an existing file.
		    
	RETRIEVE    Requests restoration of a file stored off-line.
	
	TDIRECTORY  Lists the names of all files, along with their protection,
	            size, and date and time they were last written.
		    
		    
10.3    Device Handling Commands
        ~~~~~~~~~~~~~~~~~~~~~~~~
	These commands allow you to reserve a device prior to using it, to
	manipulate the device, and to release it once it is no longer needed.
	
	ASSIGN      Reserves a device for use by your job.
	
	BACKSPACE   Moves a magnetic tape drive back any number of records 
	            or files.
		    
	DEASSIGN    Releases a previously assigned device.
	
	EOF         Writes an end-of-file mark on a magnetic tape.
	
	REWIND      Positions a magnetic tape backward to its load point.
	
	SKIP        Advances a magnetic tape one or more records or files.
	
	UNLOAD      Rewinds a magnetic tape until the tape is wound completely
	            on the source reel.
		    
		    
		    
		    
		                    - 19 -
				    
				    
10.4    Program Control Commands
        ~~~~~~~~~~~~~~~~~~~~~~~~
	The following commands help you create, run, edit and debug your own
	programs.
	
	COMPILE     Translates a source program using the appropriate compiler.
	
	CONTINUE    Resumes execution of a program interrupted by a CTRL/C.
	
	CREF        Runs the CREF program which produces a cross-reference
	            listing and automatically sends it to the Line Printer.
		    
	CSAVE       Saves the program currently in memory so that it may be 
	            used by giving a RUN command. The program is saved in a
		    compressed format.
		    
        DDT         Merges the debugging program, DDT, with the current
program
	            and then starts DDT.
		    
        DEBUG       Takes a source program, compiles it, loads it with
DDT and
	            then starts DDT.
		    
	DEPOSIT     Places a value in an address in memory.
	
	EXAMINE     Allows you to examine an address in memory.
	
	EXECUTE     Translates, loads , and begins execution of a program.
	
	FORK        Makes the TOPS-20 language work for a particular address
	            space.
		    
	GET         Loads an executable program from the specified file.
	
	LOAD        Translates a program and loads it into memory.
	
	MERGE       Loads an executable program into memory and merges it with
	            the current contents of memory.
		    
	POP         Stops the current active copy of the TOPS-20 Command
	            Processor (EXEC) and returns control to the previous copy
		    of the Command Processor.
		    
	PUSH        Preserves the contents of memory at the current command 
	            level and creates a new TOPS-20 command level.
		    
	R           Runs a program from the SYS: disk area.
	
	REENTER     Starts the program currently in memory at an alternate 
	            entry point specified by the program.
		    
	RESET       Clears the job to which your terminal is currently 
	            attached.
		    
	RUN         Loads an executable program from a file and starts it at
	            the location specified in the program.
		    
	SAVE        Copies the contents of memory into a file in executable
	            format.  If memory contains a program you may now execute
		    the program by giving the RUN command with the proper
		    file specification.
		    
	SET         Sets the value of various job parameters.
	
	START       Begins execution of a program previously loaded.
	
	TRANSLATE   Translates a project-programmer number (PPN) to a directory
	            name or a directory name to a project-programmer number.
		    
		    
		    
		                   - 20 -
				   
				   
10.5    Information Commands
        ~~~~~~~~~~~~~~~~~~~~
	These commands return information about TOPS-20 commands, your job, 
	and the system as a whole.
	
	DAYTIME     Prints the current date and time of day.
	
	HELP        Prints explanatory information about the use of specific 
	            system programs or facilities.
		    
	INFORMATION Provides information about your job, files, memory, errors,
	            system status, and many other parameters.
		    
	SYSTAT      Outputs a summary of system users and available computing 
	            resources.
		    
10.6    Terminal Commands
        ~~~~~~~~~~~~~~~~~
	The terminal commands allow you to declare the charachteristics of 
	your terminal and to control linking to another user's terminal.
	
	ADVISE      Sends whatver you type on your terminal as input to a job
	            connected to another terminal.
		    
	BLANK       Clears the video terminal screen and moves the cursor to
	            the first line.
		    
	BREAK       Clears terminal and advising links.
	
	RECEIVE     Allows your terminal to receive links and advice from
	            other users.
		    
	REFUSE      Denies links and advice to your terminal.
	
	REMARK      Allows you to type many lines of text when using the TALK 
	            command.
		  
        TAKE        Accept commands from a file, just as if you had
typed 
	            its contents on your terminal.
		    
	TALK        Links two terminals so that each user can observe what
                    the other user is doing, but does not affect either
		    user's job.
		    
	TERMINAL    Declares the hardware type of terminal you have and lets 
	            you inform TOPS-20 of any special charachteristics that 
		    the terminal has, e.g. page length, page width, terminal
		    data rate in bits per second.
		    
		    
		    
		    
		    
		    
		    
		    
		                   - 21 -
				   
				   
				   
10.7    Batch Commands
        ~~~~~~~~~~~~~~
	The TOPS-20 system also has a BATCH system to which you may submit jobs
	for later execution.
	
	SUBMIT      Enters a control file into the BATCH job queue.  When it 
	            is your job's turn, the commands executed in the control 
		    file are executed.
		    
10.8    CTRL Commands
        ~~~~~~~~~~~~~
	CTRL/C      Gains the system's attention prior to logging-in
	
	CTRL/C CTRL/C  Stops execution of a program
	
	CTRL/F      Invokes recognition input only as far as the end of the
	            current field being typed.
		    
	CTRL/O      Stops printing of output on a terminal. The system
                    continues to generate output but it is not printed. 
To
		    resume printing, type another CTRL/O;  the intervening
		    output will be lost.
		    
	CTRL/Q      Contioues printing at a terminal on which a page length
	            has been specified, and on which printing has been 
		    interrupted, either by typing a CTRL/S or by a page having
		    been printed.
		    
	CTRL/R      Reprints the line currently being typed, tidying up any
	            charachter deletions.
		    
	CTRL/S      Interrupts printing at a terminal on which a page length 
	            has been specified.  To resume printing type CTRL/Q; 
		    no output will be lost.
		    
	CTRL/T      Checks on progress of a running program.
	
	CTRL/U      Deletes line currently being typed.
	
	CTRL/W      Deletes all charachters back to the start of the current
	            field.
		    
        $           The ESCape key, most commonly used to invoke
recognition
	            input
		    
	TAB         Advance the print position at the terminal to the next TAB
	(CTRL/I)    position on the line.  Standard TAB positions are set
	            after each charachter position which is a multiple of 8.
		    
		    
		    
		    
		    
		    
		    
		    
		    
		                   - 22 -
				   
				   
11.     REFERENCES
~~~~~~~~~~~~~~~~~~

Further information regarding aspects of using the DECSYSTEM-20 which
have
been introduced in this booklet is available in the following
Programming
Information booklets which are available from the Computer Centre:

        PI20        Introduction to Using DECSYSTEM-20 BATCH
	
	PI21        Introduction to Using DECSYSTEM-20 EDIT
	
	
	
Full information is provided in the following Digital Equipment Co.
manuals,
copies of which are available in the Computer Centre for consultation by
all users.

        D204         DECSYSTEM-20 User's Guide
	
	D243         DECSYSTEM-20 BATCH Reference Manual.
	
Enquiries regarding any of the above documentation should be made at
Computer
Centre Reception.
