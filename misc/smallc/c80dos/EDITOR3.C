
/* START OF SOURCE TO EDITOR.C FOR BEEHIVE B100-LIKE TERMINALS */
/* ALL-IN-MEMORY VERSION */
/* 29 april 85 - R. D. Keys */


/* change areas marked >>> CHANGE-HERE <<< to suit your system */

/* update version number in >>> TWO <<< places in source */


/* put a header on the very front of the editor */
#asm
HEADER:
        DB      'PUBLIC DOMAIN CP/M SMALL-C EDITOR VERSION 2.03.',0
#endasm



#include editor.lib



/* Screen editor:  non-user defined globals.
 *
 * Source: ed0.c
 * Version: June 19, 1980.
 */

/* Define global constants */

/* Define constants describing a text line */

#define MAXLEN  133	/* max chars per line */
#define MAXLEN1 134	/* MAXLEN + 1 */

/* define operating system constants */

#define SYSFNMAX 15     /* CPM filename length + 1 */

/* Define miscellaneous constants */

#define EOS	0	/* Code sometimes assumes \0 */
#define OK	1
#define ERR	-1	/* Error. Must be <0 */
#define EOF     -2      /* LEFT OUT OF ORIGINAL CODE (RKD) */
#define YES	1	/* Must be non zero */
#define NO	0
#define CR	13	/* Carriage return */
#define LF	10	/* Line feed */
#define FF	12	/* Form feed CTRL-L (insert mode only) */
#define BELL	7	/* ASCII Bell CTRL-G (insert mode only) */
#define TAB	9	/* Tab character */
#define HUGE	32000	/* Practically infinity ! */



/*
 * Screen editor: Special key definitions.
 *
 * Source: ed1.c
 * Version 2: September 6, 1981.
 */

/*
 * Define which keys are used for special edit functions.
 */

#define UP1	21		/* ctrl_U -- Insert up    */
#define DOWN1	13		/* RETURN -- Insert down  */
#define UP2	11		/* ctrl_K -- cursor up    */
#define DOWN2	10		/* ctrl_J -- cursor down  */
#define LEFT1	8		/* ctrl_H -- cursor left  */
#define RIGHT1	12		/* ctrl_L -- cursor right */
#define INS1	9		/* ctrl-i -- insert mode  */
#define EDIT1	5		/* ctrl-e -- edit mode    */
#define ESC1	27		/* ESCAPE -- command mode */
#define DEL1	127		/* DELETE -- delete char  */
#define ZAP1	26		/* ctrl_Z -- delete line  */
#define ABT1	24		/* ctrl_X -- undo         */
#define SPLT1	19		/* ctrl_S -- split line   */
#define JOIN1	1 		/* ctrl_A -- append (join) 2 lines */

/*
 * Define length and width of screen and printer.
 */
/*
 * CHANGE-HERE ***********************************
 */

#define SCRNW	80
#define SCRNW1	79
#define SCRNL	24
#define SCRNL1	23
#define SCRNL2	22
#define COMSBUFSZ 132

/*
 * END CHANGE ************************************
 */

/*
 * Screen editor: Main program.
 *
 * source: ed2.c
 * Version: September 5, 1981.
 */

/* define signon message */

/*
 * CHANGE-HERE ***********************************
 */

#define CONFIG "Configured for Beehive B100-like terminals, using...."
#define CONFIG1 "      ESC-F y+32 x+32 cursor positioning,"
#define CONFIG2 "      ESC-H home and ESC-E clear screen,"
#define CONFIG3 "      ESC-K delete to end of line,"
#define CONFIG4 "      CTRL-J scroll the screen up at the bottom line, and"
#define CONFIG5 "      no hardware scroll the screen down at the top line."

/*
 * END CHANGE ************************************
 */




/*
 * The main program dispatches the routines that
 * handle the various modes.
 */

#define CMNDMODE  1	/* Enter command mode flag */
#define INSMODE   2	/* Enter insert mode flag */
#define EDITMODE  3	/* Enter edit mode flag */
#define EXITMODE  4	/* Exit editor flag */

main()
{
int mode ;
	/* fmt output by default goes to the screen */
	fmtassn(NO) ;
	/* set tabs, clear the screen and sign on */
	fmtset(8) ;
	outclr() ;
	outxy(0,SCRNL1) ;
	message("Small-C EDITOR from Dr. Dobbs Journal, Jan 82.") ;
	message("Original program written by Edward K. Ream.") ;
	message("This version (2.03) by R. D. Keys.") ;
	message("") ;
	message("THIS PROGRAM IS IN THE PUBLIC DOMAIN.") ;
	message("") ;
	message("") ;
	message(CONFIG) ;
	message(CONFIG1) ;
	message(CONFIG2) ;
	message(CONFIG3) ;
	message(CONFIG4) ;
	message(CONFIG5) ;
	message("") ;
	message("") ;
	message(
	"Type '?' in the COMMAND or EDIT modes, for on-line help.") ;
	message("") ;
	message("") ;
	outxy(0,1) ;
	/* clear filename[] for save() , resave() */
	name("") ;
	/* clear the main buffer */
	bufnew() ;
	/* start off in command mode */
	mode=CMNDMODE ;
	/* get null line 1 for edit() */
	edgetln() ;
	while(1) {
		if (mode == EXITMODE) {
			break ;
		}
		else if (mode == CMNDMODE) {
			mode=command() ;
		}
		else if (mode == EDITMODE) {
			mode=edit() ;
		}
		else if (mode == INSMODE) {
			mode=insert() ;
		}
		else {
			syserr("MAIN: No Mode") ;
			mode=EDITMODE ;
		}
	}
}

/*
 * handle edit mode.
 * Dispatch the proper routine based on one character commands
 */

edit()
{
char buffer[SCRNW1] ;
int v ;
int x,y, topline ;
char c ;
	/*
	 * We cant do edgetln() or edgo() here because
	 * those calls reset the cursor.
	 */
	pmtedit() ;
	while(1) {
		/* get command */
		c=tolower(syscin()) ;
		if (c == ESC1) {
			/* enter command mode */
			return (CMNDMODE) ;
		}
		else if ((c == 'i') | (c == INS1)) {
			/* enter insert mode */
			return (INSMODE) ;
		}
		else if (special(c) == YES) {
			if (c == UP1) {
				return(INSMODE) ;
			}
			else {
				continue ;
			}
		}
		else if (control(c) == YES) {
			continue ;
		}
		else if (c == ' ') {
			edright() ;
			pmtcol() ;
		}
		else if (c == DOWN1) {
			/* cursor down using carriage return */
			eddn() ;
			pmtline() ;
			edbegin() ;
			pmtcol() ;
		}
		else if (c == 'b') {
			edbegin() ;
			pmtcol() ;
		}
		else if (c == 'd') {
			/* scroll down */
			pmtmode("EDIT: scroll") ;
			while (bufnrbot() == NO) {
				if (chkkey() == YES) {
					break ;
				}
				if (eddn() == ERR) {
					break ;
				}
			}
			pmtedit() ;
		}
		else if (c == 'e') {
			edend() ;
			pmtcol() ;
		}
		else if (c == 'g') {
			/* save x , y in case we dont get number */
			x=outgetx() ;
			y=outgety() ;
			pmtcmnd("EDIT: goto: ",buffer) ;
			if (number(buffer,&v)) {
				edgo(v,0) ;
			}
			else {
				outxy(x,y) ;
			}
			pmtedit() ;
		}
		else if (c == '?') {
			/* remember how screen was drawn */
			x=outgetx();
			y=outgety();
			topline=bufln()-y+1;

			/* output the help message */
			outclr();
			outxy(0,SCRNL1);
			edithelp();

			/* redraw the screen */
			bufout(topline,1,SCRNL1);
			outxy(x,y);
			pmtedit();
		}
		else if (c == 'k') {
			pmtmode("EDIT: kill") ;
			c=syscin() ;
			if ((special(c) == NO) & (control(c) == NO)) {
				edkill(c) ;
			}
			pmtedit() ;
		}
		else if (c == 's') {
			pmtmode("EDIT: set cursor") ;
			c=syscin() ;
			if ((special(c) == NO) & (control(c) == NO)) {
				edsrch(c) ;
			}
			pmtedit() ;
		}
		else if (c == 'u') {
			/* scroll up */
			pmtmode("EDIT: scroll") ;
			while (bufattop() == NO) {
				if (chkkey() == YES) {
					break ;
				}
				if (edup() == ERR) {
					break ;
				}
			}
			pmtedit() ;
		}
		else if (c == 'x') {
			pmtmode("EDIT: eXchange") ;
			while (c != ESC1) {
			   c=syscin() ;
			   if (c == ESC1) {
					return (EDITMODE) ;
			   }

	/* Make sure you have only printing characters plus space */
	/* and tab characters that may be exchanged, to prevent   */
	/* confusion.  This is done only in the exchange mode.    */
	/* All of the characters are active in the insert mode.   */

			   if (c == FF) {
					return (EDITMODE) ;
			   }
			   if (c == BELL) {
					return (EDITMODE) ;
			   }
			   if (c == CR) {
					return (EDITMODE) ;
			   }
			   if (control(c) == YES) {
					return (EDITMODE) ;
			   }
			   if (special(c) == YES) {
					return (EDITMODE) ;
			   }
			   edchng(c) ;
			}
			pmtedit() ;
		}
		/* do nothing if command not found */
	}
}

/*
 * Insert mode.
 */

insert()
{
char c ;
	pmtmode("insert") ;
	while (1) {
		/* get command */
		c=syscin() ;
		if (c == ESC1) {
			/* enter edit mode */
			return (EDITMODE) ;
		}
		else if (c == DEL1) {
			/* delete a character using delete key */
			eddel() ;
			pmtcol() ;
			continue ;
		}
		else if (c == DOWN1) {
			/* insert down using carriage return */
			ednewdn() ;
			pmtline() ;
			continue ;
		}
		else if (control(c) == YES) {
			/* ignore non-special control characters */
			continue ;
		}
		else {
			/* insert one char in line */
			edins(c) ;
			pmtcol() ;
		}
	}
}

/* Return YES if c is a control char */

control(c)
char c ;
{
	if (c == TAB) {
		return (NO) ;		/* tab is regular */
	}
	else if (c == CR) {
		return (NO) ;		/* return CTRL-M is regular */
	}
	else if (c == FF) {
		return (NO) ;		/* form feed CTRL-L is regular */
	}
	else if (c == BELL) {
		return (NO) ;		/* ASCII Bell is regular */
	}
	else if (c >= 127) {
		return (YES) ;		/* del or high bit on */
	}
	else if (c < 32) {
		return (YES) ;
	}
	else {
		return (NO) ;		/* normal */
	}
}

/*
 * handle the default actions of all special keys.
 * return YES if c is one of the keys.
 */

special(c)
char c ;
{
	if (c == JOIN1) {
		edjoin() ;
		pmtline() ;
		return (YES) ;
	}
	else if (c == SPLT1) {
		edsplit() ;
		pmtline() ;
		return (YES) ;
	}
	else if (c == ABT1) {
		edabt() ;
		pmtcol() ;
		return (YES) ;
	}
	else if (c == DEL1) {
		eddel() ;
		pmtcol() ;
		return (YES) ;
	}
	else if (c == ZAP1) {
		edzap() ;
		pmtline() ;
		return(YES) ;
	}
	else if (c == UP2) {
		/* move up */
		edup() ;
		pmtline() ;
		return (YES) ;
	}
	else if (c == UP1) {
		/* insert up */
		ednewup() ;
		pmtline() ;
		return (YES) ;
	}
	else if (c == DOWN2) {
		/* move down */
		eddn() ;
		pmtline() ;
		return (YES) ;
	}
	else if (c == LEFT1) {
		edleft() ;
		pmtcol() ;
		return (YES) ;
	}
	else if (c == RIGHT1) {
		edright() ;
		pmtcol() ;
		return (YES) ;
	}
	else {
		return (NO) ;
	}
}

/*

 * command() dispatches command routines while
 * in command mode.
 */

command()
{
int v ;
char c ;
char args[SCRNW1] ;
char *argp ;
int topline ;
int ypos ;
int oldline ;
int k ;
	/* command mode commands may move the current line.
	 * command mode must save the current line on entry
	 * and restore it on exit.
	 */
	edrepl() ;
	/* remember how the screen was drawn on entry */
	oldline=bufln() ;
	ypos=outgety() ;
	topline=oldline-ypos+1 ;
	while(1) {
		outxy(0,SCRNL1) ;
		fmtcrlf() ;
		pmtmode("COMMAND:") ;
		getcmnd(args,0) ;
		fmtcrlf() ;
		pmtline() ;
		c=args[0] ;
		if ((c == EDIT1) | (c == INS1)) {
			/* redraw screen */
			if (oldline == bufln()) {
				/* get current line */
				edgetln() ;
				/* redraw old screen */
				bufout(topline,1,SCRNL1) ;
				outxy(0,ypos) ;
			}
			else {
				/* update line and screen */
				edgo(bufln(),0) ;
			}
			if (c == EDIT1) {
				return (EDITMODE) ;
			}
			else {
				return (INSMODE) ;
			}
		}
		else if (tolower(args[0]) == 'g') {
			argp=skipbl(args+1) ;
			if (argp[0] == EOS) {
				edgo(oldline,0) ;
				return (EDITMODE) ;
			}
			else if (number(argp,&v) == YES) {
				edgo(v,0) ;
				return (EDITMODE) ;
			}
			else {
				message("bad line number") ;
			}
		}
		else if (lookup(args,"append")) {
			append(args) ;
		}
		else if (lookup(args,"change")) {
			change(args) ;
		}
		else if (lookup(args,"clear")) {
			clear() ;
		}
		else if (lookup(args,"copy")) {
			copy(args) ;
		}
		else if (lookup(args,"delete")) {
			delete(args) ;
		}
		else if (lookup(args,"dos")) {
			if (chkbuf() == YES) {
			message("Returning to the disk operating system.") ;
			return (EXITMODE) ;
			}
		}
		else if (lookup(args,"find")) {
			if ((k = find()) >= 0) {
				edgo(bufln(),k) ;
				return (EDITMODE) ;
			}
			else {
				/* get current line */
				bufgo(oldline) ;
				edgetln() ;
				/* stay in command mode */
				message(
				">>>>> FIND pattern not found. <<<<<") ;
			}
		}
		else if (lookup(args,"?")) {
			help() ;
		}
		else if (lookup(args,"list")) {
			list(args) ;
		}
		else if (lookup(args,"load")) {
			load(args) ;
		}
		else if (lookup(args,"move")) {
			move(args) ;
		}
		else if (lookup(args,"name")) {
			name(args) ;
		}
		else if (lookup(args,"resave")) {
			resave() ;
		}
		else if (lookup(args,"save")) {
			save() ;
		}
		else if (lookup(args,"search")) {
			search(args) ;
		}
		else if (lookup(args,"tabs")) {
			tabs(args) ;
		}
		else {
			message(">>>>> Command not found. <<<<<") ;
		}
	}
}

/* return YES if line starts with a command */

lookup(line,comand)
char *line , *comand ;
{
	while (*comand) {
		if (tolower(*line++) != *comand++) {
			return (NO) ;
		}
	}
	if ((*line == EOS) | (*line == ' ') | (*line == TAB)) {
		return (YES) ;
	}
	else {
		return (NO) ;
	}
}

/* get next command into argument buffer */

getcmnd(args,offset)
char *args ;
int offset ;
{
int j,k ;
char c ;
	outxy(offset,outgety()) ;
	outdeol() ;
	k=0 ;
	while ((c=syscin()) != CR) {
		if ((c == EDIT1) | (c == INS1)) {
			args[0]=c ;
			return ;
		}
		if ((c == DEL1) | (c == LEFT1)) {
			if (k > 0) {
				outxy(offset,outgety()) ;
				outdeol() ;
				k-- ;
				j=0 ;
				while (j < k) {
					outchar(args[j++]) ;
				}
			}
		}
		else if (c == ABT1) {
			outxy(offset,outgety()) ;
			outdeol() ;
			k=0 ;
		}
		else if ((c != TAB) & ((c < 32) | (c == 127))) {
			/* do nothing */
			continue ;
		}
		else {
			if ((k+offset) < SCRNW1) {
				args[k++]=c ;
				outchar(c) ;
			}
		}
	}
	args[k]=EOS ;
}




/*
 * screen editor: command mode commands.
 *
 * source: ed3.c
 * Version: September 5, 1981.
 *
 */

/* data global to these routines */

char filename[SYSFNMAX] ;

/*
 * append command.
 * load a file into main buffer at current location.
 * this command does NOT change the current filename.
 */

append(args)
char *args ;
{
char buffer[MAXLEN] ;		/* disk line buffer */
int file ;
int n ;
int topline ;
char locfn[SYSFNMAX] ;		/* local filename */
	/* get filename which follows command */
	if (name1(args,locfn) == ERR) {
		return ;
	}
	if (locfn[0] == EOS) {
		message(">>>>> ERROR - No file argument. <<<<<") ;
		return ;
	}
	/* open the new file */
	if ((file=sysopen(locfn,"r")) == ERR) {
		message(">>>>> ERROR - File not found. <<<<<") ;
		return ;
	}
	/* read the file into the buffer */
	message(
	">>>>> File append cycle in progress, please wait... <<<<<") ;
	while ((n=readline(file,buffer,MAXLEN)) >= 0) {
		if (n > MAXLEN) {
			message(
			">>>>> One or more lines were truncated. <<<<<") ;
			n=MAXLEN ;
		}
		if (bufins(buffer,n) == ERR) {
			break ;
		}
		if (bufdn() == ERR) {
			break ;
		}
	}
	/* close the file */
	sysclose(file) ;
	/*
	 * redraw the screen so topline will be at top
	 * of the screen after command() does a CR/LF.
	 */
	topline=max(1,bufln()-SCRNL2) ;
	bufout(topline,2,SCRNL2) ;
	bufgo(topline) ;
	message("");
	message(">>>>> File append cycle completed. <<<<<") ;
}

/* global chang command */

change(args)
char *args ;
{
char oldline[MAXLEN1] ;
char newline[MAXLEN1] ;
char oldpat[MAXLEN1] ;
char newpat[MAXLEN1] ;
int from, to, col, n, k ;
	if (get2args(args,&from,&to) == ERR) {
		return ;
	}
	/* get search and change masks into oldpat and newpat */
	fmtsout("Pattern to search for...  ",0) ;
	getcmnd(oldpat,30) ;
	fmtcrlf() ;
	if (oldpat[0] == EOS) {
		return ;
	}
	pmtline() ;
	fmtsout("Pattern to change to....  ",0) ;
	getcmnd(newpat,30) ;
	fmtcrlf() ;
	/* make substitutions for lines between from, to */
	message(
	">>>>> Global change cycle in progress, please wait... <<<<<") ;
	while (from <= to) {
		if (chkkey() == YES) {
			break ;
		}
		if (bufgo(from++) == ERR) {
			break ;
		}
		if (bufatbot() == YES) {
			break ;
		}
		n=bufgetln(oldline,MAXLEN) ;
		n=min(n,MAXLEN) ;
		oldline[n]=EOS ;
		/* '^' anchors search */
		if (oldpat[0] == '^') {
			if (amatch(oldline,oldpat+1,0) == YES) {
				k=replace(oldline,newline,
					oldpat+1,newpat,0) ;
				if (k == ERR) {
					return ;
				}
				fmtcrlf() ;
				putdec(bufln(),5) ;
				fmtsout(newline,5) ;
				outdeol() ;
				bufrepl(newline,k) ;
			}
			continue ;
		}
		/* search oldline for oldpat */
		col=0 ;
		while (col < n) {
			if (amatch(oldline,oldpat,col++) == YES) {
				k=replace(oldline,newline,
					oldpat,newpat,col-1) ;
				if (k == ERR) {
					return ;
				}
				fmtcrlf() ;
				putdec(bufln(),5) ;
				fmtsout(newline,5) ;
				outdeol() ;
				bufrepl(newline,k) ;
				break ;
			}
		}
	}
	fmtcrlf() ;
	message(">>>>> Global change cycle completed. <<<<<") ;
}

/* clear main buffer and filename */

clear()
{
	/* make sure it is ok to clear buffer */
	if (chkbuf() == YES) {
		filename[0]=0 ;
		pmtfile("") ;
		outclr() ;
		outxy(0,SCRNL1) ;
		bufnew() ;
		message(">>>>> The buffer is now cleared. <<<<<") ;
	}
}

/* Block copy command */

copy(args)
char * args;
{
	int i, k;
	int last;
	int fstart, fend, tstart;
	char buffer [MAXLEN1];

	/* Get exactly three args. */
	if (get3args(args, &fstart, &fend, &tstart) == ERR) {
		return;
	}

	/*
		The 'to' and 'from' blocks must not overlap.
		Fstart must be > 0, tstart must be >= 0.
	*/
	if ( (fend < fstart) |
	     (fstart <= 0)   |
	     (tstart < 0)    |
	     ( (tstart >= fstart) & (tstart < fend) )
	   ) {
		message(
	">>>>> ERROR - Please check the copy line number parameters. <<<<<");
		return;
	}

	/* Make sure the last line exists. */
	last = max(tstart, fstart);

	bufgo(last);
	if (bufln() != last) {
		message(">>>>> ERROR - The last line doesn't exist. <<<<<");
		return;
	}		
	
	/*
		Move the 'from block' to the 'to block'.
		Move one line at a time.
	*/
	message(">>>>> Copy cycle in progress, please wait... <<<<<") ;
	i = 0;
	while (i <= fend - fstart) {

		/* Go to next line of 'from block'. */
		if (fstart < tstart) {
			bufgo(fstart + i);
		}
		else {
			bufgo(fstart + i + i);
		}

		if (bufatbot()) {
			/* end of 'from block' */
			break;
		}

		/* Get line of 'from block' into buffer. */
		k = bufgetln(buffer, MAXLEN);

		/* Go to next line of 'to block'. */
		bufgo(tstart + i + 1);

		/* Insert next line into 'to block'. */
		bufins(buffer, k);

		/* Bump the count. */
		i++;
	}
	message(">>>>> Copy cycle completed. <<<<<") ;
}

/* multiple line delete command */

delete(args)
char *args ;
{
int from , to ;
	if (get2args(args,&from,&to) == ERR) {
		return ;
	}
	if (from > to) {
		return ;
	}
	/* go to first line to be deleted */
	if (bufgo(from) == ERR) {
		return ;
	}
	/* delete all lines betwwen from and to */
	if (bufdeln(to-from+1) == ERR) {
		return ;
	}
	/* redraw the screen */
	bufout(bufln(),1,SCRNL1) ;
	message(">>>>> Delete cycle completed. <<<<<") ;
}

/* Edit mode help screen  */

edithelp()
{

message(
"Here is a list of the commands that you can use in the EDIT mode."
); message(
"Control characters (^L form feed and ^G bell) may be used in INSERT mode."
); message(
"Type ? when in COMMAND mode for a list of COMMAND mode commands."
); message(
"---------------------------------------------------------------------------"
); message(
"ESC - enter command mode from edit mode, or edit mode from insert mode"
); message(
"DEL - delete character         RET - move cursor down to start of next line"
); message(
"---------------------------------------------------------------------------"
); message(
"B - go to the beginning of the line        E - go to the end of the line"
); message(
"D - scroll down through the text           U - scroll up through the text"
); message(
"G <n> - go to line <n>                     ? - display this help screen"
); message(
"I or ^I - enter insert mode                K <let> - delete to letter <let>"
); message(
"S <let> - set cursor to letter <let>       X - eXchange text at cursor"
); message(
"---------------------------------------------------------------------------"
); message(
"^A - append (join) 2 lines (if room)       ^S - split line at cursor"
); message(
"^U - insert line above current line, enter insert mode"
); message(
"^X - undo changes to the current line      ^Z - delete the current line"
); message(
"---------------------------------------------------------------------------"
); message(
"^K - move cursor up                        ^J - move cursor down"
); message(
"^H - move cursor left                      ^L - move cursor right"
); message(
"---------------------------------------------------------------------------"
); message(
">>>>>   Type any character to continue editing...   <<<<<"
);
	pmtedit();
	syscin();
}

/* Edit mode help screen end  */

/*
 * searches all lines below the current line for a pattern.
 * return -1 if pattern not found.
 * otherwise, return column number of start of pattern.
 */

find()
{
	return (search1(bufln()+1,HUGE,YES)) ;
}

/* Command mode help screen  */

help()
{

message(
"Here is a list of commands you can use in the COMMAND mode."
); message(
"Type ? when in EDIT mode for more help."
); message(
"---------------------------------------------------------------------------"
); message(
"append <filename>      append a file after the current line"
); message(
"change <n1> <n2>       change all lines in <n1> to <n2> line range"
); message(
"clear                  reset the editor"
); message(
"copy <n1> <n2> <n3>    copy lines <n1> through <n2> after <n3>"
); message(
"delete <n1> <n2>       delete all lines in <n1> to <n2> line range"
); message(
"dos                    exit from the editor"
); message(
"find                   search for a pattern;  enter edit mode if found"
); message(
"g <n>                  enter edit mode at line <n>"
); message(
"g or ^e (^i)           enter edit (or insert) mode at the current line"
); message(
"?                      display this help screen"
); message(
"list <n1> <n2>         list lines <n1> through <n2> to the printer"
); message(
"load <filename>        replace the buffer with <filename>"
); message(
"move <n1> <n2> <n3>    move lines <n1> through <n2> after <n3>"
); message(
"name <filename>        set the filename for the save and resave commands"
); message(
"resave                 save the buffer to the already existing file"
); message(
"save                   save the buffer to a new file"
); message(
"search                 list all lines which contain a pattern"
); message(
"tabs <n>               set tabs to every <n> columns"
);

}

/* Command mode help screen end */

/* list lines to list device */

list(args)
char *args ;
{
char linebuf[MAXLEN1] ;
int n ;
int from , to , line , oldline ;
	/* save the buffers current line */
	oldline=bufln() ;
	/* get starting, ending lines to print */
	if (get2args(args,&from,&to) == ERR) {
		return ;
	}
	/* print lines one at a time to list device */
	message(">>>>> Listing cycle in progress, please wait... <<<<<") ;
	line=from ;
	while (line <= to) {
		/* make sure prompt goes to console */
		fmtassn(NO) ;
		/* check for interrupt */
		if (chkkey() == YES) {
			break ;
		}
		/* print line to list device */
		fmtassn(YES) ;
		if (bufgo(line++) != OK) {
			break ;
		}
		if (bufatbot()) {
			break ;
		}
		n=bufgetln(linebuf,MAXLEN1) ;
		n=min(n,MAXLEN) ;
		linebuf[n]=CR ;
		fmtsout(linebuf,0) ;
		fmtcrlf() ;
	}
	/* redirect output to console */
	fmtassn(NO) ;
	/* restore the cursor */
	bufgo(oldline) ;
	message(">>>>> Listing cycle completed. <<<<<") ;
}

/* load file into buffer */

load(args)
char *args ;
{
char buffer[MAXLEN] ;		/* disk line buffer */
char locfn [SYSFNMAX] ;		/* file name until we check it */
int n ;
int file ;
int topline ;
	/* get filename following command */
	if (name1(args,locfn) == ERR) {
		return ;
	}
	if (locfn[0] == EOS) {
		message(">>>>> ERROR - No file argument. <<<<<") ;
		return ;
	}
	/* give user a chance to save the buffer */
	if (chkbuf() == NO) {
		return ;
	}
	/* open the new file */
	if ((file=sysopen(locfn,"r")) == ERR) {
		message(">>>>> ERROR - File not found. <<<<<") ;
		return ;
	}
	message(">>>>> Load cycle in progress, please wait... <<<<<") ;
	/* update file name */
	syscopfn(locfn,filename) ;
	pmtfile(filename) ;
	/* clear the buffer */
	bufnew() ;
	/* read the file into the buffer */
	while ((n=readline(file,buffer,MAXLEN)) >= 0) {
		if (n > MAXLEN) {
			message(
			">>>>> One or more lines were truncated. <<<<<") ;
			n=MAXLEN ;
		}
		if (bufins(buffer,n) == ERR) {
			break ;
		}
		if (bufdn() == ERR) {
			break ;
		}
	}
	/* close the file */
	sysclose(file) ;
	/* indicate that the buffer is fresh */
	bufsaved() ;
	/* set current line to line */
	bufgo(1) ;
	/*
	 * redraw the screen so that the top line
	 * will be on line 1 after command() does a CR/LF
	 */
	topline=max(1,bufln()-SCRNL2) ;
	bufout(topline,2,SCRNL2) ;
	bufgo(topline) ;
}

/* Block move command. */

move(args)
char * args;
{
	int c, i, k;
	int last;
	int fstart, fend, tstart;
	char buffer [MAXLEN1];

	/* Get exactly three args. */
	if (get3args(args, &fstart, &fend, &tstart) == ERR) {
		return;
	}

	/*
		The 'to' and 'from' blocks must not overlap.
		Fstart must be > 0, tstart must be >= 0.
	*/
	if ( (fend < fstart) |
	     (fstart <= 0)   |
	     (tstart < 0)    |
	     ( (tstart >= fstart) & (tstart <= fend) )
	   ) {
		message(
	">>>>> ERROR - Please check the move line number parameters. <<<<<");
		return;
	}

	/* Make sure the last line exists. */
	if (tstart < fstart) {
		last = fstart;
	}
	else {
		last = tstart;
	}

	bufgo(last);
	if (bufln() != last) {
		return;
	}		
	
	/*
		Move the 'from block' to the 'to block'.
		Move one line at a time.
	*/
	message(">>>>> Move cycle in progress, please wait... <<<<<") ;
	i = c = 0;
	while (c++ <= fend - fstart) {

		/* Go to next line of 'from block'. */
		bufgo(fstart + i);

		if (bufatbot()) {
			/* end of 'from block' */
			break;
		}

		/* Get line of 'from block' into buffer. */
		k = bufgetln(buffer, MAXLEN);

		/* Delete this line. */
		bufdeln(1);

		/* Go to next line of 'to block'. */
		if (tstart < fstart) {

			/* Delete leaves 'to block' numbers. */
			bufgo(tstart + i + 1);
		}
		else {

			/* Delete decreased numbers by one. */
			bufgo(tstart + i);
		}

		/* Insert next line into 'to block'. */
		bufins(buffer, k);

		/* Adjust line numbers if needed. */
		if (tstart < fstart) {

			/* Line numbers increase. */
			i++;
		}
	}
	message(">>>>> Move cycle completed. <<<<<") ;
}

/* change current file name */

name(args)
char *args ;
{
	name1(args,filename) ;
	pmtfile(filename) ;
}

/*
 * checks syntax of args.
 * copy to filename.
 * return OK if the name is valid.
 */

name1(args,filname)
char *args , *filname ;
{
	/* skip command */
	args=skiparg(args) ;
	args=skipbl(args) ;
	/* check filename syntax */
	if (syschkfn(args) == ERR) {
		return (ERR) ;
	}
	/* copy filename */
	syscopfn(args,filname) ;
	return (OK) ;
}

/* save the buffer in an already existing file */

resave()
{
char linebuf[MAXLEN] ;
int file, n, oldline ;
	/* make sure file has a name */
	if (filename[0] == EOS) {
		message(">>>>> ERROR - File not named. <<<<<") ;
		return ;
	}
	/* the file must exist for resave */
	if ((file=sysopen(filename,"r")) == ERR) {
		message(">>>>> ERROR - File not found. <<<<<") ;
		return ;
	}
	if (sysclose(file) == ERR) {
		return ;
	}
	/* open the file for writing */
	if ((file=sysopen(filename,"w")) == ERR) {
		return ;
	}
	/* save the current position of file */
	message(
	">>>>> File resave cycle in progress, please wait... <<<<<") ;
	oldline=bufln() ;
	/* write out the whole file */
	if (bufgo(1) == ERR) {
		sysclose(file) ;
		return ;
	}
	while (bufatbot() == NO) {
		n=bufgetln(linebuf,MAXLEN) ;
		n=min(n,MAXLEN) ;
		if (pushline(file,linebuf,n) == ERR) {
			break ;
		}
		if (bufdn() == ERR) {
			break ;
		}
	}
	/* indicate if all buffer was saved */
	if (bufatbot()) {
		bufsaved() ;
	}
	/* close file and restore line number */
	sysclose(file) ;
	bufgo(oldline) ;
	message(">>>>> File resave cycle completed. <<<<<") ;
}

/* save the buffer in a new file */

save()
{
char linebuf[MAXLEN] ;
int file , n , oldline ;
	/* make sure the file is named */
	if (filename[0] == EOS) {
		message(">>>>> ERROR - File not named. <<<<<") ;
		return ;
	}
	/* file must NOT exist for save */
	if ((file=sysopen(filename,"r")) != ERR) {
		sysclose(file) ;
		message(
	">>>>> WARNING - The Named File Already Exists.  To save the <<<<<") ;
		message(
	">>>>> buffer to an existing file use the resave command.    <<<<<") ;
		return ;
	}
	/* open file for writing */
	if ((file=sysopen(filename,"w")) == ERR) {
		return ;
	}
	message(
	">>>>> File save cycle in progress, please wait... <<<<<") ;
	/* remember current line */
	oldline=bufln() ;
	/* write entire buffer to file */
	if (bufgo(1) == ERR) {
		sysclose(file) ;
		return ;
	}
	while (bufatbot() == NO) {
		n=bufgetln(linebuf,MAXLEN) ;
		n=min(n,MAXLEN) ;
		if (pushline(file,linebuf,n) == ERR) {
			break ;
		}
		if (bufdn() == ERR) {
			break ;
		}
	}
	/* indicate buffer saved if good write */
	if (bufatbot()) {
		bufsaved() ;
	}
	/* restore line and close file */
	bufgo(oldline) ;
	sysclose(file) ;
	message(">>>>> File save cycle completed. <<<<<") ;
}

/* global search commands */

search(args)
char *args ;
{
int from , to ;
	if (get2args(args,&from,&to) == ERR) {
		return ;
	}
	search1(from,to,NO) ;
}

/*
 * search lines for a pattern.
 * if flag == YES:	stop at the first match.
 *			return -1 if no match.
 *			otherwise return column number of match.
 * if flag == NO :	print all matches found.
 */

search1(from,to,flag)
int from , to , flag ;
{
char pat  [MAXLEN1] ;
char line [MAXLEN1] ;
int col , n ;
	/* get search mask into pat  */
	fmtsout("Pattern to search for...  ",0) ;
	getcmnd(pat,30) ;
	fmtcrlf() ;
	if (pat[0] == EOS) {
		return ;
	}
	/* search all lines between from and to for pat */
	message(
	">>>>> Global search cycle in progress, please wait... <<<<<") ;
	while (from <= to) {
		if (chkkey() == YES) {
			break ;
		}
		if (bufgo(from++) == ERR) {
			break ;
		}
		if (bufatbot() == YES) {
			break ;
		}
		n=bufgetln(line,MAXLEN) ;
		n=min(n,MAXLEN) ;
		line[n]=EOS ;
		/* '^' anchors search */
		if (pat[0] == '^') {
			if (amatch(line,pat+1,0) == YES) {
				if (flag == NO) {
					fmtcrlf() ;
					putdec(bufln(),5) ;
					fmtsout(line,5) ;
					outdeol() ;
				}
				else {
					return(0) ;
				}
			}
			continue ;
		}
		/* search whole line for match */
		col=0 ;
		while (col < n) {
			if (amatch(line,pat,col++) == YES) {
				if (flag == NO) {
					fmtcrlf() ;
					putdec(bufln(),5) ;
					fmtsout(line,5) ;
					outdeol() ;
					break ;
				}
				else {
					return(col-1) ;
				}
			}
		}
	}
	/* all searching is finished */
	if (flag == YES) {
		return (-1) ;
	}
	else {
		fmtcrlf() ;
	}
	message(">>>>> Global search cycle completed. <<<<<") ;
}

/* set tab stops for fmt routines */

tabs(args)
char *args ;
{
int n, junk ;
	if (get2args(args,&n,&junk) == ERR) {
		return ;
	}
	fmtset(n) ;
}

/* return YES if buffer may be drastically changed */

chkbuf()
{
	if (bufchng() == NO) {
		/* buffer not changed - no problem! */
		return (YES) ;
	}

	/* if the buffer was changed query to proceed */
	fmtsout("WARNING - The buffer was not saved.  Proceed?  (y/n): ",0) ;

	pmtline() ;

	/* Cancel if return with not y or Y */
	/* note that the logic here is all screwed up. */
	/* the equality with y should proceed, but the exact */
	/* reverse happens.   WHY..... (RDK) */

	if (tolower(syscin()) != 'y') {
		message("   Command Cancelled.") ;
		fmtcrlf() ;
		return(NO) ;
	}

	/* proceed if y or Y */
	else {
		message("   Proceeding...") ;
		fmtcrlf() ;
		return(YES) ;
	}
}

/* print message from a command */

message(s)
char *s ;
{
	fmtsout(s,0) ;
	fmtcrlf() ;
}

/*
 * get two arguments the argument line args
 * no arguments imply 1 HUGE.
 * one argument implies both args the same.
 */

get2args(args,val1,val2)
char *args ;
int *val1, *val2 ;
{
	/* skip over the command */
	args=skiparg(args) ;
	args=skipbl(args) ;
	if (*args == EOS) {
		*val1=1 ;
		*val2=HUGE ;
		return (OK) ;
	}
	/* check first argument */
	if (number(args,val1) == NO) {
		message(">>>>> Bad argument. <<<<<") ;
		return (ERR) ;
	}
	/* skip over first argument */
	args=skiparg(args) ;
	args=skipbl(args) ;
	/* 1 arg : arg 2 is HUGE */
	if (*args == EOS) {
		*val2=HUGE ;
		return (OK) ;
	}
	/* check second argument */
	if (number(args,val2) == NO) {
		message(">>>>> Bad argument. <<<<<") ;
		return (ERR) ;
	}
	else {
		return (OK) ;
	}
}

/* Get exactly three arguments. */

get3args(args, val1, val2, val3)
char *args;
int *val1, *val2, *val3;
{
	/* Skip the command. */
	args = skiparg (args);
	args = skipbl (args);

	/* Check first arg. */
	if (*args == EOS) {
		message(">>>>> ERROR - Missing arguments. <<<<<");
		return ERR;
	}

	if (number (args, val1) == NO) {
		message(">>>>> Bad argument. <<<<<");
		return ERR;
	}

	/* Skip over first argument. */
	args = skiparg(args);
	args = skipbl(args);

	/* Check second argument. */
	if (*args == EOS) {
		message(">>>>> ERROR - Missing arguments. <<<<<");
		return ERR;
	}

	if (number(args, val2) == NO) {
		message(">>>>> Bad argument. <<<<<");
		return ERR;
	}

	/* Skip over third argument. */
	args = skiparg(args);
	args = skipbl(args);

	/* Check third argument. */
	if (*args == EOS) {
		message(">>>>> ERROR - Missing arguments. <<<<<");
		return ERR;
	}

	if (number (args, val3) == NO) {
		message(">>>>> Bad argument. <<<<<");
		return ERR;
	}
	else {
		return OK;
	}
}

/* Get three arguments for some commands - end ---------------- */

/* skip over all except EOS and blanks */

skiparg(args)
char *args ;
{
	while ((*args != EOS) & (*args != ' ')) {
		args++ ;
	}
	return (args) ;
}

/* skip over all blanks */

skipbl(args)
char *args ;
{
	while (*args ==  ' ') {
		args++ ;
	}
	return (args) ;
}

/*
 * return YES if the user has pressed any key.
 * blanks cause a transparent pause.
 */

chkkey()
{
int c ;
	c=syscstat() ;
	if (c == 0) {
		/* No character at keyboard */
		return(NO) ;
	}
	else if (c == ' ') {
		/* pause. another blank ends pause. */
		pmtline() ;
		if (syscin() == ' ') {
			return (NO) ;
		}
	}
	/* we got a nonblank character */
	return (YES) ;
}

/*
 * anchored search for pattern in text line at column col.
 * return YES if the pattern starts at col
 */

amatch(line,pat,col)
char *line , *pat ;
int col ;
{
int k ;
	k=0 ;
	while (pat[k] != EOS) {
		if (pat[k] == line[col]) {
			k++ ;
			col++ ;
		}
		else if ((pat[k] == '?') & (line[col] != EOS)) {
			/* question mark matches any char */
			k++ ;
			col++ ;
		}
		else {
			return (NO) ;
		}
	}
	/* the entire pattern matches */
	return (YES) ;
}

/*
 * replace oldpat in oldline by newpat starting at col.
 * put result in newline.
 * return number of characters in newline.
 */

replace(oldline,newline,oldpat,newpat,col)
char *oldline, *newline, *oldpat, *newpat ;
int col ;
{
int k ;
char *tail, *pat ;
	/* copy oldline preceeding col to newline */
	k=0 ;
	while (k < col) {
		newline[k++]=(*oldline++) ;
	}
	/* remember where end of  oldpat in oldline is */
	tail=oldline ;
	pat=oldpat ;
	while (*pat++ != EOS) {
		tail++ ;
	}
	/*
	 * copy newpat to newline.
	 * use oldline and oldpat to resolve question marks
	 *  in newpat.
	 */
	while (*newpat != EOS) {
		if (k > MAXLEN-1) {
			message(">>>>> ERROR - New line too long. <<<<<") ;
			return (ERR) ;
		}
		if (*newpat != '?') {
			/* copy newpat to newline */
			newline[k++]=(*newpat++) ;
			continue ;
		}
		/* scan for '?' in oldpat */
		while (*oldpat !=  '?') {
			if (*oldpat == EOS) {
				message(
			">>>>> ERROR - Too many ?'s in change mask. <<<<<") ;
				return (ERR) ;
			}
			oldpat++ ;
			oldline++ ;
		}
		/* copy char from oldline too newline */
		newline[k++]=(*oldline++) ;
		oldpat++ ;
		newpat++ ;
	}
	/* copy oldline after oldpat to newline */
	while (*tail != EOS) {
		if (k >= MAXLEN-1) {
			message(">>>>> ERROR - New line too long. <<<<<") ;
			return (ERR) ;
		}
		newline[k++]=(*tail++) ;
	}
	newline[k]=EOS ;
	return(k) ;
}




/*
 * Screen editor:  window module.
 *
 * source: ed4.c
 * version: august 20 1981.
 */

/* data global to this module */

char editbuf[MAXLEN] ;		/* the edit buffer */
int editp ;			/* cursor: buffer index */
int editpmax ;			/* length of buffer */
int edcflag ;			/* buffer change flag */

/* abort any changes made to current line */

edabt()
{
	/* get unchanged line and reset cursor */
	edgetln() ;
	edredraw() ;
	edbegin() ;
	edcflag=NO ;
}

/* put cursor at beginning of current line */

edbegin()
{
	editp=0 ;
	outxy(0,outgety()) ;
}

/*
 * change editbuf[editp] to c.
 * don't make change if line would become too long.
 */

edchng(c)
char c ;
{
char oldc ;
int k ;
	/* if at right margin then insert char */
	if (editp >= editpmax) {
		edins(c) ;
		return ;
	}
	/* change char and print length of line */
	oldc=editbuf[editp] ;
	editbuf[editp]=c ;
	fmtadj(editbuf,editp,editpmax) ;
	k=fmtlen(editbuf,editpmax) ;
	if (k > SCRNW1) {
		/* line would become too long */
		/* undo the change */
		editbuf[editp]=oldc ;
		fmtadj(editbuf,editp,editpmax) ;
	}
	else {
		/* set change flag, redraw line */
		edcflag=YES ;
		editp++ ;
		edredraw() ;
	}
}

/* delete the char to left of cursor if it exists */

eddel()
{
int k ;
	/* just move left one one column if past end of line */
	if (edxpos() < outgetx()) {
		outxy(outgetx()-1,outgety()) ;
		return ;
	}
	/* do nothing if cursor is at left margin */
	if (editp == 0) {
		return ;
	}
	edcflag=YES ;
	/* compress buffer (delete char) */
	k=editp ;
	while (k < editpmax) {
		editbuf[k-1]=editbuf[k] ;
		k++ ;
	}
	/* update pointers, redraw line */
	editp-- ;
	editpmax-- ;
	edredraw() ;
}

/* edit the next line. do not go to end of buffer */

eddn()
{
int oldx ;
	/* save visual position of cursor */
	oldx=outgetx() ;
	/* replace current edit line */
	if (edrepl() != OK) {
		return (ERR) ;
	}
	/* do not go past last non null line */
	if (bufnrbot()) {
		return (OK) ;
	}
	/* move down one line in buffer */
	if (bufdn() != OK) {
		return (ERR) ;
	}
	edgetln() ;
	/*
	 * put cursor as close as possible on this
	 * new line to where it was on the oldline.
	 */
	editp=edscan(oldx) ;
	/* update screen */
	if (edatbot()) {
		edsup(bufln()-SCRNL2) ;
		outxy(oldx,SCRNL1) ;
	}
	else {
		outxy(oldx,outgety()+1) ;
	}
	return (OK) ;
}

/* put cursor at the end of the current line */

edend()
{
	editp=editpmax ;
	outxy(edxpos(),outgety()) ;

	/* comment out ---- put cursor at end of screen -
 	 * outxy(SCRNW1,outgety()) ;
	 * -----end comment out
	 */
}

/*
 * start editing line n
 * redraw the screen with cursor at position p
 */

edgo(n,p)
int n, p ;
{
	/* replace current line */
	if (edrepl() == ERR) {
		return (ERR) ;
	}
	/* go to new line */
	if (bufgo(n) == ERR) {
		return (ERR) ;
	}
	/* prevent going past end of buffer */
	if (bufatbot()) {
		if (bufup() == ERR) {
			return (ERR) ;
		}
	}
	/* redraw the screen */
	bufout(bufln(),1,SCRNL1) ;
	edgetln() ;
	editp=min(p,editpmax) ;
	outxy(edxpos(),1) ;
	return (OK) ;
}

/* insert c into the buffer if possible */

edins(c)
char c ;
{
int k ;
	/* do nothing if edit buffer is full */
	if (editpmax >= MAXLEN) {
		return ;
	}
	/* fill out line if we are past its end */
	if ((editp == editpmax) & (edxpos() < outgetx())) {
		k=outgetx()-edxpos() ;
		editpmax=editpmax+k ;
		while (k-- > 0) {
			editbuf[editp++]=' ' ;
		}
		editp=editpmax ;
	}
	/* make room for inserted character */
	k=editpmax ;
	while (k > editp) {
		editbuf[k]=editbuf[k-1] ;
		k-- ;
	}
	/* insert character, update pointers */
	editbuf[editp]=c ;
	editp++ ;
	editpmax++ ;
	/* recalculate print length of line */
	fmtadj(editbuf,editp-1,editpmax) ;
	k=fmtlen(editbuf,editpmax) ;
	if (k > SCRNW1) {
		/* line would become too long */
		/* delete what we just inserted */
		eddel() ;
	}
	else {
		/* set change flag, redraw line */
		edcflag=YES ;
		edredraw() ;
	}
}

/* join (concatenate) the current line with the one above it */

edjoin()
{
int k ;
	/* do nothing if at top of file */
	if (bufattop()) {
		return ;
	}
	/* replace lower line temporarily */
	if (edrepl() != OK) {
		return ;
	}
	/* get upper line into buffer */
	if (bufup() != OK) {
		return ;
	}
	k=bufgetln(editbuf,MAXLEN) ;
	/* append lower line to buffer */
	if (bufdn() != OK) {
		return ;
	}
	k=k+bufgetln(editbuf+k,MAXLEN-k) ;
	/* abort if the screen isn't wide enough */
	if (k > SCRNW1) {
		return ;
	}
	/* replace upper line */
	if (bufup() != OK) {
		return ;
	}
	editpmax=k ;
	edcflag=YES ;
	if (edrepl() != OK) {
		return ;
	}
	/* delete the lower line */
	if (bufdn() != OK) {
		return ;
	}
	if (bufdel() != OK) {
		return ;
	}
	if (bufup() != OK) {
		return ;
	}
	/* update the screen */
	if (edattop()) {
		edredraw() ;
	}
	else {
		k=outgety()-1 ;
		bufout(bufln(),k,SCRNL-k) ;
		outxy(0,k) ;
		edredraw() ;
	}
}

/* delete chars until end of line or c found */

edkill(c)
char c ;
{
int k, p ;
	/* do nothing if at right margin */
	if (editp == editpmax) {
		return ;
	}
	edcflag=YES ;
	/* count number of deleted chars */
	k=1 ;
	while ((editp+k) < editpmax) {
		if (editbuf[editp+k] == c) {
			break ;
		}
		else {
			k++ ;
		}
	}
	/* compress buffer (delete chars) */
	p=editp+k ;
	while (p < editpmax) {
		editbuf[p-k]=editbuf[p] ;
		p++ ;
	}
	/* update buffer size, redraw line */
	editpmax=editpmax-k ;
	edredraw() ;
}

/*
 * move cursor left one column.
 * never move the cursor off the current line.
 */

edleft()
{
	/* if past right margin move left one column */
	if (edxpos() < outgetx()) {
		outxy(max(0,outgetx()-1),outgety()) ;
	}
	/* inside the line move left one character */
	else if (editp != 0) {
		editp-- ;
		outxy(edxpos(),outgety()) ;
	}
}

/* insert a new blank line below the current line */

ednewdn()
{
int k ;
	/*
	 * make sure there is a current line and
	 * put the current line back into the buffer.
	 */
	if (bufatbot()) {
		if (bufins(editbuf,editpmax) != OK) {
			return ;
		}
	}
	else if (edrepl() != OK) {
		return ;
	}
	/* move past current line */
	if (bufdn() != OK) {
		return ;
	}
	/* insert place holder: zero length line */
	if (bufins(editbuf,0) != OK) {
		return ;
	}
	/* start editing the zero length line */
	edgetln() ;
	/* update the screen */
	if (edatbot()) {
		/* note: bufln() >= SCRNL */
		edsup(bufln()-SCRNL2) ;
		outxy(edxpos(),SCRNL1) ;
	}
	else {
		k=outgety() ;
		bufout(bufln(),k+1,SCRNL1-k) ;
		outxy(edxpos(),k+1) ;
	}
}

/* insert a new blank line above the current line */

ednewup()
{
int k ;
	/* put current line back in buffer */
	if (edrepl() != OK) {
		return ;
	}
	/* insert zero length line at current line */
	if (bufins(editbuf,0) != OK) {
		return ;
	}
	/* start editing the zero length line */
	edgetln() ;
	/* update the screen */
	if (edattop()) {
		edsdn(bufln()) ;
		outxy(edxpos(),1) ;
	}
	else {
		k=outgety() ;
		bufout(bufln(),k,SCRNL-k) ;
		outxy(edxpos(),k) ;
	}
}

/*
 * move cursor right one character.
 * never move the cursor off the current line.
 */

edright()
{
	/* if we are outside the line move right one column */
	if (edxpos() < outgetx()) {
		outxy(min(SCRNW1,outgetx()+1),outgety()) ;
	}
	/* if we are inside a tab, move to the end of it */
	else if (edxpos() > outgetx()) {
		outxy(edxpos(),outgety()) ;
	}
	/* move right one character if inside line */
	else if (editp < editpmax) {
		editp++ ;
		outxy(edxpos(),outgety()) ;
	}
	/* else move past end of line */
	else {
		outxy(min(SCRNW1,outgetx()+1),outgety()) ;
	}
}

/*
 * split the current line into two parts.
 * scroll the first half of the old line up.
 */

edsplit()
{
int p, q ;
int k ;
	/* indicate that edit buffer has been saved */
	edcflag=NO ;
	/* replace current line by the first half of line */
	if (bufatbot()) {
		if (bufins(editbuf,editp) != OK) {
			return ;
		}
	}
	else {
		if (bufrepl(editbuf,editp) != OK) {
			return ;
		}
	}
	/* redraw the first half of the line */
	p=editpmax ;
	q=editp ;
	editpmax=editp ;
	editp=0 ;
	edredraw() ;
	/* move the second half of the line down */
	editp=0 ;
	while (q < p) {
		editbuf[editp++]=editbuf[q++] ;
	}
	editpmax=editp ;
	editp=0 ;
	/* insert second half of the line below the first */
	if (bufdn() != OK) {
		return ;
	}
	if (bufins(editbuf,editpmax) != OK) {
		return ;
	}
	/* scroll the screen up and draw the second half */
	if (edatbot()) {
		edsup(bufln()-SCRNL2) ;
		outxy(1,SCRNL1) ;
		edredraw() ;
	}
	else {
		k=outgety() ;
		bufout(bufln(), k+1, SCRNL1-k) ;
		outxy(1,k+1) ;
		edredraw() ;
	}
}

/*
 * move cursor right until end of line or
 * character c found.
 */

edsrch(c)
char c ;
{
	/* do nothing if at right margin */
	if (editp == editpmax) {
		return ;
	}
	/* scan for search character */
	editp++ ;
	while (editp < editpmax) {
		if (editbuf[editp] == c) {
			break ;
		}
		else {
			editp++ ;
		}
	}
	/* reset cursor */
	outxy(edxpos(),outgety()) ;
}

/* move cursor up one line if possible */

edup()
{
int oldx ;
	/* save visual position of cursor */
	oldx=outgetx() ;
	/* put current line back in buffer */
	if (edrepl() != OK) {
		return (ERR) ;
	}
	/* done if at top of buffer */
	if (bufattop()) {
		return (OK) ;
	}
	/* start editing the previous line */
	if (bufup() != OK) {
		return (ERR) ;
	}
	edgetln() ;
	/*
	 * put cursor on this new line as close as
	 * possible to where it was on the old line.
	 */
	editp=edscan(oldx) ;
	/* update screen */
	if (edattop()) {
		edsdn(bufln()) ;
		outxy(oldx,1) ;
	}
	else {
		outxy(oldx,outgety()-1) ;
	}
	return (OK) ;
}

/* delete the current line */

edzap()
{
int k ;
	/* delete the line in the buffer */
	if (bufdel() != OK) {
		return ;
	}
	/* move up one line if now at bottom */
	if (bufatbot()) {
		if (bufup() != OK) {
			return ;
		}
		edgetln() ;
		/* update screen */
		if (edattop()) {
			edredraw() ;
		}
		else {
			outdelln() ;
			outxy(0,outgety()-1) ;
		}
		return ;
	}
	/* start editing new line */
	edgetln() ;
	/* update screen */
	if (edattop()) {
		edsup(bufln()) ;
		outxy(0,1) ;
	}
	else {
		k=outgety() ;
		bufout(bufln(),k,SCRNL-k) ;
		outxy(0,k) ;
	}
}

/*
 * return true if the current edit line is being
 * displayed on the bottom line of the screen.
 */

edatbot()
{
	return (outgety() == SCRNL1) ;
}

/*
 * return true if the current edit line is being
 * displayed on the top line of the screen.
 */

edattop()
{
	return (outgety() == 1) ;
}

/*
 * redraw edit line from index to end of line.
 * reposition cursor.
 */

edredraw()
{
	fmtadj(editbuf,0,editpmax) ;
	fmtsubs(editbuf,max(0,editp-1),editpmax) ;
	outxy(edxpos(),outgety()) ;
}

/* return the x position of the cursor on screen */

edxpos()
{
	return (min(SCRNW1,fmtlen(editbuf,editp))) ;
}

/*
 * fill edit buffer from current main buffer line.
 * the caller must chaeck to make sure the main
 * buffer is available.
 */

edgetln()
{
int k ;
	/* put cursor on left margin, reset flag */
	editp=0 ;
	edcflag=NO ;
	/* get edit line from main buffer */
	k=bufgetln(editbuf,MAXLEN) ;
	if (k > MAXLEN) {
		error(">>> LINE TRUNCATED. <<<") ;
		editpmax=MAXLEN ;
	}
	else {
		editpmax=k ;
	}
	fmtadj(editbuf,0,editpmax) ;
}

/*
 * replace current main buffer line by edit buffer.
 * the edit buffer is not changed or cleared.
 * return ERR if something goes wrong.
 */

edrepl()
{
	/* do nothing if nothing has changed */
	if (edcflag == NO) {
		return (OK) ;
	}
	/* make sure we dont replace the line twice */
	edcflag=NO ;
	/* insert instead of replace if at bottom of file */
	if (bufatbot()) {
		return (bufins(editbuf,editpmax)) ;
	}
	else {
		return (bufrepl(editbuf,editpmax)) ;
	}
}

/*
 * set editp to the largest index such that
 * buf[editp] will be printed <= xpos.
 */

edscan(xpos)
int xpos ;
{
	editp=0 ;
	while (editp < editpmax) {
		if (fmtlen(editbuf,editp) < xpos) {
			editp++ ;
		}
		else {
			break ;
		}
	}
	return (editp) ;
}

/* scroll the screen up. topline will be new topline. */

edsup(topline)
int topline ;
{
	if (outhasup() == YES) {
		/* hardware scroll */
		outsup() ;
		/* redraw bottom line */
		bufout(topline+SCRNL2,SCRNL1,1) ;
	}
	else {
		/* redraw whole screen */
		bufout(topline,1,SCRNL1) ;
	}
}

/* scroll screen down. topline will be new topline. */

edsdn(topline)
int topline ;
{
	if (outhasdn() == YES) {
		/* hardware scroll */
		outsdn() ;
		/* redraw topline */
		bufout(topline,1,1) ;
	}
	else {
		/* redraw whole screen */
		bufout(topline,1,SCRNL1) ;
	}
}




/*
 * screen editor:   output format module
 *
 * source: ed5.c
 * version: march 6 1981.
 */

/* define variables global to this module */

/* define maximal length of a tab character */

int fmttab ;

/* define the current device and device width */

int fmtdev ;		/* device -- YES/NO = LIST/CONSOLE */
int fmtwidth ;		/* device width.   LISTW/SCRNW1 */

/*
 * int fmtcol[i] is the first column at which
 * buf[i] will be printed.
 * fmtsub() and fmtlen() assume fmtcol() is valid on entry.
 */

int fmtcol[MAXLEN1] ;

fmtassn(listflag)
int listflag ;
{
	fmtdev=NO ;
	fmtwidth=SCRNW1 ;
}

/*
 * adjust fmtcol[] to prepare for calls on fmtout() and fmtlen().
 *
 * NOTE:  This routine is neaded as an efficiency
 *	  measure. Without fmtadj(), calls on
 *	  fmtlen() become too slow.
 */

fmtadj(buf,minind,maxind)
char *buf ;
int minind, maxind ;
{
int k ;
	/* line always starts at left margin */
	fmtcol[0]=0 ;
	/* start scanning at minind */
	k=minind ;
	while (k < maxind) {
		if (buf[k] == CR) {
			break ;
		}
		fmtcol[k+1]=fmtcol[k]+fmtlench(buf[k],fmtcol[k]) ;
		k++ ;
	}
}

/* return column at which buf[i] will be printed */

/*
 * In the Dr.Dobbs source this function had an unused
 * parameter. I'm leaving it in until I sus out
 * what is going on here !!!!
 */

fmtlen(buf,i)
char *buf ;
int i ;
{
	return(fmtcol[i]) ;
}

/*
 * print buf[i] ... buf[j-1] on current device so long as
 * characters will not be printed in last column.
 */

fmtsubs(buf,i,j)
char *buf ;
int i,j ;
{
	if (fmtcol[i] >= fmtwidth) {
		return ;
	}
	outxy(fmtcol[i],outgety()) ;		/* position cursor */
	while (i < j) {
		if (buf[i] == CR) {
			break ;
		}
		if (fmtcol[i+1] > fmtwidth) {
			break ;
		}
		fmtoutch(buf[i],fmtcol[i]) ;
		i++ ;
	}
	outdeol() ;	/* clear rest of line */
}

/*
 * print string which ends with CR or EOS to current device.
 * truncate the string if it is too long.
 */

fmtsout(buf,offset)
char *buf ;
int offset ;
{
char c ;
int col, k ;
	col=0 ;
	while (c=(*buf++)) {
		if (c == CR) {
			break ;
		}
		k=fmtlench(c,col) ;
		if ((col+k+offset) > fmtwidth) {
			break ;
		}
		fmtoutch(c,col) ;
		col=col+k ;
	}
}

/* return length of char c at column col */

fmtlench(c,col)
char c ;
int col ;
{
	if (c == TAB) {
		/* tab every fmttab columns */
		return(fmttab-(col%fmttab)) ;
	}
	else if (c < 32) {
		/* control char */
		return (2) ;
	}
	else {
		return (1) ;
	}
}

/*
 * output one character to current device.
 * convert tabs to blanks.
 */

fmtoutch(c,col)
char c ;
int col ;
{
int k ;
	if (c == TAB) {
		k=fmtlench(TAB,col) ;
		while ((k--) > 0) {
			fmtdevch(' ') ;
		}
	}
	else if (c < 32) {
		fmtdevch('^') ;
		fmtdevch(c+64) ;
	}
	else {
		fmtdevch(c) ;
	}
}

/* output character to current device */

fmtdevch(c)
char c ;
{
	if (fmtdev == YES) {
		syslout(c) ;
	}
	else {
		outchar(c) ;
	}
}

/* output a  CR and LF to the current device */

fmtcrlf()
{
	if (fmtdev == YES) {
		syslout(CR) ;
		syslout(LF) ;
	}
	else {
		/* COCK UP:  this should be in out module.
		 * 	     make sure out module knows position !
		 */
		outxy(0,SCRNL1) ;
		syscout(LF) ;
	}
}

/* set tabs at every n columns */

fmtset(n)
int n ;
{
	fmttab=max(1,n) ;
}




/*
 * screen editor: terminal output module.
 *
 * source: ed6.c
 * version: BEEHIVE B100 TYPE TERMINAL (RDK)
 */

/*
 * THIS FILE REWRITTEN FOR BEEHIVE B100 TYPE
 * TERMINALS WITHOUT FANCY LINE EDITING FEATURES
 * BY R.D. KEYS - 15 JULY 84. 
 */


/* define the current coordinates of the cursor */

int outx, outy ;

/* return the current coordinates of the cursor */

outgetx()
{
	return (outx) ;
}

outgety()
{
	return (outy) ;
}

/* output one printable character to the screen */

outchar(c) char c ;
{
	syscout(c) ;
	outx++;
	return(c);
}

/*
 * position cursor to position x,y on screen.
 * 0,0 is the top left hand corner.
 */

/*
 * CHANGE-HERE ***********************************
 */

outxy(x,y) int x, y ;
{
	outx=x ;
	outy=y ;
	syscout(27) ;
	syscout('F') ;
	syscout(y+32) ;
	syscout(x+32) ;
}

/*
 * Erase the entire screen.
 * make sure the rightmost column is erased.
 */

outclr()
{
int k;
	outxy(0,0);
	syscout(27);
	syscout('H');
	syscout(0);
	syscout(0);
	syscout(0);
	syscout(0);
	syscout(0);
	syscout(0);
	syscout(0);
	syscout(27);
	syscout('E');
	syscout(0);
	syscout(0);
	syscout(0);
	syscout(0);
	syscout(0);
	syscout(0);
	syscout(0);
	outxy(0,0);
}

/* delete the line on which the cursor rests
 * leave the cursor at the left margin.
 */

outdelln()
{
	outxy(0,outy) ;
	outdeol() ;
}

/*
 * delete to end of line.
 * assume the last column is blank.
 */

outdeol()
{
	syscout(27);
	syscout('K');
	syscout(0);
	syscout(0);
	syscout(0);
	syscout(0);
	syscout(0);
	syscout(0);
	syscout(0);
}

/* return YES if terminal has indicated hardware scroll */

outhasup()
{
	return (YES) ;
}

outhasdn()
{
	return (NO) ;
}

/*
 * scroll the screen up.
 * assume the cursor is on the bottom line.
 */

outsup()
{
	outxy(0,SCRNL1);
	syscout(10);
	syscout(0);
	syscout(0);
	syscout(0);
	syscout(0);
	syscout(0);
	syscout(0);
	syscout(0);
}

/*
 * scroll the screen down.
 */

outsdn()
{
}

/*
 * END CHANGE ************************************
 */




/* screen editor: prompt line module.
 *
 * source: ed7.c
 * version: march 6, 1981.
 */

/* define the prompt line data */

char pmtln[MAXLEN] ;		/* mode */
char pmtfn[SYSFNMAX] ;		/* file name */

/*
 * put error message on prompt line.
 * wait for response.
 */

pmtmess(s1,s2)
char *s1,*s2 ;
{
int x,y ;
	/* save cursor */
	x=outgetx() ;
	y=outgety() ;
	outxy(0,0) ;
	/* make sure line is correct */
	outdelln() ;
	pmtln1() ;
	pmtcol1(x) ;
	/* output error message */
	fmtsout(s1,outgetx()) ;
	fmtsout(s2,outgetx()) ;
	/* wait for input from console */
	syscin() ;
	/* redraw prompt line */
	pmtln1() ;
	pmtcol1(x) ;
	pmtfl1(pmtfn) ;
	pmtmd1(pmtln) ;
	/* restore cursor */
	outxy(x,y) ;
}

/* write new mode message on prompt line */

pmtmode(s)
char *s ;
{
int x,y ;			/* save cursor on entry */
	/* save cursor */
	x=outgetx() ;
	y=outgety() ;
	/* redraw whole line */
	outxy(0,0) ;
	outdelln() ;
	pmtln1() ;
	pmtcol1(x) ;
	pmtfl1(pmtfn) ;
	pmtmd1(s) ;
	/* restore cursor */
	outxy(x,y) ;
}

/* update file name on prompt line */

pmtfile(s)
char *s ;
{
int x,y ;
	/* save cursor */
	x=outgetx() ;
	y=outgety() ;
	/* update whole line */
	outxy(0,0) ;
	outdelln() ;
	pmtln1() ;
	pmtcol1(x) ;
	pmtfl1(s) ;
	pmtmd1(pmtln) ;
	/* restore cursor */
	outxy(x,y) ;
}

/* change mode on prompt line to edit */

pmtedit()
{
	pmtmode("EDIT:") ;
}

/* update line and column numbers on prompt line */

pmtline()
{
int x,y ;
	/* save cursor */
	x=outgetx() ;
	y=outgety() ;
	/* redraw whole line */
	outxy(0,0) ;
	outdelln() ;
	pmtln1() ;
	pmtcol1(x) ;
	pmtfl1(pmtfn) ;
	pmtmd1(pmtln) ;
	/* restore cursor */
	outxy(x,y) ;
}

/* update just the column number on the prompt line */

pmtcol()
{
int x,y ;
	/* save cursor */
	x=outgetx() ;
	y=outgety() ;
	/* update column number */
	pmtcol1(x) ;
	/* update cursor */
	outxy(x,y) ;
}

/* update mode:  call getcmnd() to write on prompt line */

pmtcmnd(mode,buffer)
char *mode, *buffer ;
{
int x,y ;
	/* save cursor */
	x=outgetx() ;
	y=outgety() ;
	pmtmd1(mode) ;
	/* user types command on prompt line */
	getcmnd(buffer,outgetx()) ;
	/* restore cursor */
	outxy(x,y) ;  /* correction to Dobbs source (line missing) (KEDB) */
}

/* update and print mode */

pmtmd1(s)
char *s ;
{
int i ;
	outxy(40,0) ;
	fmtsout(s,40) ;
	i=0 ;
	while (pmtln[i++]=(*s++)) {
		;
	}
}

/* print the file name on the prompt line */

pmtfl1(s)
char *s ;
{
int i ;
	outxy(25,0) ;
	if (*s == EOS) {
		fmtsout("No File",25) ;
	}
	else {
		fmtsout(s,25) ;
	}
	i=0 ;
	while (pmtfn[i++]=(*s++)) {
		;
	}
}

/* print the line number on the prompt line */

pmtln1()
{
	outxy(0,0) ;
	fmtsout("LINE: ",0) ;
	putdec(bufln(),5) ;
}

/* print column number of the cursor */

pmtcol1(x)
int x ;
{
	x=x+1;
	outxy(12,0) ;
	fmtsout("COLUMN: ",12) ;
	putdec(x,3) ;
	x=x-1;
}




/*
 * screen editor operating system module.
 *
 * source:  ed8.c
 * version:  cpm
 */

/* all calls to the operating system are made here.
 * only this module and the assembler libraries wil have to
 * be re-written for a new operating system.
 */

/* the routines syscstat() & syscin() & syscout() come in 2 flavours.
 * cpm 2.2 & 1.4.
 * Comment out whatever you don't need.
 */

/* cpm 2.2 versions of syscstat(), syscin() & syscout(). */

/* return -1 if no character is ready from the console.
 * otherwise return the character.
 */

syscstat()
{
	return(cpm(6,-1)) ;
}

/* wait for next character from the console.
 * do not echo it.
 */

syscin()
{
int c ;
	while ((c=cpm(6,-1)) == 0) {
		;
	}
	return (c) ;
}

/* print character on the console */

syscout(c)
char c ;
{
	cpm(6,c) ;
	/* return(c) ; Don't bother cos it isn't used (KEDB) */
}


/* print character on the printer */

syslout(c)
char c  ;
{
	cpm(5,6) ;
	/* return (c) ;		(KEDB) */
}


/* open a file */

sysopen(name, mode)
char *name, *mode ;
{
int file ;
	if ((file=fopen(name,mode)) == 0) {
		return (ERR) ;
	}
	else {
		/* yet another example of a pointless else!! (KEDB) */
		return (file) ;
	}
}

/* close a file */

sysclose(file)
int file ;
{
	/* fclose doesn't reliably return OK */
	fclose(file) ;
	return (OK) ;
}

/* read next character from file */

sysrdch(file)
int file ;
{
int c ;
	if ((c=getc(file)) == -1) {
		return (EOF) ;
	}
	else {
		return (c) ;
	}
}

/* write next char to file */

syspshch(c,file)
char c ;
int file ;
{
	if (putc(c,file) == -1) {
		error(">>> DISK WRITE FAILED. <<<") ;
		return (ERR) ;
	}
	else {
		return (c) ;
	}
}

/* read one char from end of file */

syspopch(file)
int file ;
{
	error(">>> syspopch() NOT IMPLEMENTED. <<<") ;
	return (ERR) ;
}

/* check filename syntax */

syschkfn(args)
char *args ;
{
	return (OK) ;
}

/* copy file name from args to buffer */

syscopfn(args,buffer)
char *args, *buffer ;
{
int n ;
	n=0 ;
	while (n < SYSFNMAX-1) {
		if (args[n] == EOS) {
			break ;
		}
		else {
			buffer[n] = args[n] ;
			n++ ;
		}
	}
	buffer[n] = EOS ;
}


/*
 * screen editor general utilities.
 *
 * Source: ed9.c
 * Version: may 3, 1981.
 */


/* convert lower case to upper case */

toupper(c)
int c ;
{
	if ((c < 'a') | (c >'z')) {
		return (c) ;
	}
	else {
		return (c-32) ;
	}
}

/* convert upper case to lower case */

tolower(c)
int c ;
{
	if ((c < 'A') | (c >'Z')) {
		return (c) ;
	}
	else {
		return (c+32) ;
	}
}


/* return: is first token in args a number ? */
/* return value of number in *val */

number(args,val)
char *args ;
int *val ;
{
char c ;
	c=(*args++) ;
	if ((c < '0') | (c > '9')) {
		return (NO) ;
	}
	*val=c-'0' ;
	while (c=(*args++)) {
		if ((c < '0') | (c > '9')) {
			break ;
		}
		*val=(*val*10)+c-'0' ;
	}
	return (YES) ;
}

/* convert character buffer to numeric */

ctoi(buf,index)
char *buf ;
int index ;
{
int k ;
	while ((buf[index] == ' ') | (buf[index] == TAB)) {
		index++ ;
	}
	k=0 ;
	while ((buf[index] >= '0') & (buf[index] <= '9')) {
		k=(k*10)+buf[index]-'0' ;
		index++ ;
	}
	return (k) ;
}

/* return maximum of m,n */

max(m,n)
int m,n ;
{
	if (m >= n) {
		return (m) ;
	}
	else {
		return (n) ;
	}
}

/* return minimum of m,n */

min(m,n)
int m,n ;
{
	if (m <= n) {
		return (m) ;
	}
	else {
		return (n) ;
	}
}

/*
 * put decimal integer n in field width >= w.
 * left justify the number in the field.
 */

putdec(n,w)
int n,w ;
{
char chars[10] ;
int i,nd ;
	nd=itoc(n,chars,10) ;
	i=0 ;
	while (i < nd) {
		syscout(chars[i++]) ;
	}
	i=nd ;
	while (i++ < w) {
		syscout(' ') ;
	}
}

/* convert integer n to character string in str */

itoc(n,str,size)
int n ;
char *str ;
int size ;
{
int absval ;
int len ;
int i,j,k ;
	absval=abs(n) ;
	/* generate digits */
	str[0]=0 ;
	i=1 ;
	while (i < size) {
		str[i++]=(absval%10)+'0' ;
		absval=absval/10 ;
		if (absval == 0) {
			break ;
		}
	}
	/* generate sign */
	if ((i < size) & (n < 0)) {
		str[i++]='-' ;
	}
	len=i-1 ;
	/* reverse sign, digits */
	i-- ;
	j=0 ;
	while (j < i) {
		k=str[i] ;
		str[i]=str[j] ;
		str[j]=k ;
		i-- ;
		j++ ;
	}
	return (len) ;
}

/* return absolute value of n */

abs(n)
int n ;
{
	if (n < 0) {
		return (-n) ;
	}
	else {
		return (n) ;
	}
}

/* system error routine */

syserr(s)
char *s ;
{
	pmtmess("SYSTEM ERROR: ",s) ;
}

/* user error routine */

error(s)
char *s ;
{
	pmtmess("ERROR: ",s) ;
}

/* disk error routine */

diskerr (s)
char *s ;
{
	pmtmess("DISK ERROR: ",s) ;
}

/* read the next line of the file into
 * the buffer of size n that p points to.
 * succesful calls to readline() read the file
 * from front to back.
 */

readline(file,p,n)
int file;
char *p ;
int n ;
{
int c ;
int k ;
	k=0 ;
	while (1) {
		c=sysrdch(file) ;
		if (c == ERR) {
			return (ERR) ;
		}
		if (c == EOF) {
			/* ignore line without CR */
			return (EOF) ;
		}
		if (c == CR) {
			return (k) ;
		}
		if (k < n) {
			/* move char to buffer */
			*p++ = c ;
		}
		/* always bump count */
		k++ ;
	}
}

/* push (same as write) line to end of file.
 * line is in the buffer of size n that p points to.
 * lines written by this routine may be read by
 * either readline() or popline().
 */

pushline(file,p,n)
int file ;
char *p ;
int n ;
{
	/* write all but trailing CR */
	while ((n--) > 0) {
		if (syspshch(*p++,file) == ERR) {
			return (ERR) ;
		}
	}
	/* write trailing CR */
	return (syspshch(CR,file)) ;
}

/*
 * pop a line from the back of the file.
 * the line should have been pushed using pushline().
 */

popline(file,p,n)
int file ;
char *p ;
int n ;
{
int c ;
int k,kmax,t ;
	/* first char must be CR */
	c=syspopch(file) ;
	if (c == EOF) {
		/* at START of file */
		return (EOF) ;
	}
	if (c == CR) {
		/* put into buffer */
		*p++ = CR ;
		k=1 ;
	}
	/* pop line into buffer in reverse order */
	while (1) {
		c=syspopch(file) ;
		if (c == ERR) {
			return (ERR) ;
		}
		if (c == EOF) {
			break ;
		}
		if (c == CR) {
			/* this ends ANOTHER line */
			/* push it back		  */
			if (syspshch(CR,file) == ERR) {
				return (ERR) ;
			}
			break ;
		}
		/* non-special case */
		if (k < n) {
			/* put into buffer */
			*p++ = c ;
		}
		/* always bump count */
		k++ ;
	}
	/* remember if we truncated the line */
	kmax=k ;
	/* reverse the buffer */
	k=min(k,n-1) ;
	t=0 ;
	while (k > t) {
		/* swap p[t], p[k] */
		c=p[k] ;
		p[k]=p[t] ;
		p[t]=c ;
		k-- ;
		t++ ;
	}
	return (kmax) ;
}




/*
 * Screen editor:  Buffer module.
 *
 * source:  ed10.c
 * version:  April 7, 1981.
 */

/*
 * Define the variables global to this module.
 * buffer must be dclared after all other variables
 * of the entire program.
 * Note: buffer must have non-zero dimension.
 */

int bufcflag ;		/* main buffer changed flag */
char *bufp ;		/* start of current line */
char *bufpmax ;		/* end of last line */
char *bufend ;		/* last byte of buffer */
int bufline ;		/* current line number */
int bufmaxln ;		/* number of lines in buffer */
char buffer[1] ;	/* start of buffer */

/*
 * This code is built around several invariant assumptions.
 * First, the last line is always completely empty.
 * When bufp points to the last line there is NO
 * CR following it.
 * Second, bufp points to the last line if and only if
 * bufline == bufmaxln+1.
 * Third, bufline is always greater than zero.
 * line zero only exists only to make scanning for the
 * start of line 1 easier.
 */

/* clear the main buffer */

bufnew()
{
	/* point past line zero */
	bufp=bufpmax=buffer+1 ;
	/* point at last byte of buffer */
	bufend=sysend()-1000 ;
	/* at line one. no lines in buffer */
	bufline=1 ;
	bufmaxln=0 ;
	/* line zero is always a null line */
	buffer[0]=CR ;
	/* indicate no need to save file yet */
	bufcflag=NO ;
}

/* return current line number */

bufln()
{
	return (bufline) ;
}

/*
 * return YES if the buffer (ie.. the file) has been
 * changed since the last time the file was changed.
 */

bufchng()
{
	return (bufcflag) ;
}

/* the file has been saved. clear bufcflag */

bufsaved()
{
	bufcflag=NO ;
}

/* return number of bytes left in the buffer */

buffree()
{
	return (bufend-bufp) ;
}

/* position buffer pointers to start of indicated line */

bufgo(line)
int line ;
{
	/* put request into range. prevent extension. */
	line=min(bufmaxln+1,line) ;
	line=max(1,line) ;
	/* already at proper line? return. */
	if (line == bufline) {
		return (OK) ;
	}
	/* move through buffer one line at a time */
	while (line < bufline) {
		if (bufup() == ERR) {
			return (ERR) ;
		}
	}
	while (line > bufline) {
		if (bufdn() == ERR) {
			return (ERR) ;
		}
	}
	/* we have reached the line we wanted */
	return (OK) ;
}

/*
 * move one line closer to front of buffer, i.e.,
 * set buffer pointers to start of previous line.
 */

bufup()
{
char *oldbufp ;
	oldbufp=bufp ;
	/* cant move past line 1 */
	if (bufattop()) {
		return (OK) ;
	}
	/* move past CR of previous line */
	if (*--bufp != CR) {
		syserr("bufup: Missing CR") ;
		bufp=oldbufp ;
		return (ERR) ;
	}
	/* move to start of previous line */
	while (*--bufp != CR) {
		;
	}
	bufp++ ;
	/* make sure we havent gone too far !! */
	if (bufp < (buffer+1)) {
		syserr("bufup: bufp Underflow") ;
		bufp=oldbufp ;
		return (ERR) ;
	}
	/* success!! we are at previous line */
	bufline-- ;
	return (OK) ;
}

/*
 * move one line closer to end of buffer, i.e,
 * set buffer pointers to start of next line.
 */

bufdn()
{
char *oldbufp ;
	oldbufp=bufp ;
	/* do nothing silly if at end of buffer */
	if (bufatbot()) {
		return (OK) ;
	}
	/* scan past current line and CR */
	while (*bufp++ != CR) {
		;
	}
	/* make sure we havent gone too far */
	if (bufp > bufpmax) {
		syserr("bufdn: bufp Overflow") ;
		bufp=oldbufp ;
		return (ERR) ;
	}
	/* success!! we are at next line */
	bufline++ ;
	return (OK) ;
}

/*
 * Insert a line before the current line.
 * p points to a line of length n to be inserted.
 * Note: n does not include trailing CR.
 */

bufins(p,n)
char *p ;
int n ;
{
int k ;
	/* make room in the buffer for the line */
	if (bufext(n+1) == ERR) {
		return (ERR) ;
	}
	/* put the line and CR into the buffer */
	k=0 ;
	while (k < n) {
		*(bufp+k)=(*(p+k));
		k++ ;
	}
	*(bufp+k)=CR ;
	/* increase number of lines in buffer */
	bufmaxln++ ;
	/*
	 * special case: inserting a null line at
	 * end of file is not a significant change..
	 */
	if ((n==0) & (bufnrbot())) {
		;
	}
	else {
		bufcflag=YES ;
	}
	return (OK) ;
}

/* delete the current line */

bufdel()
{
	return (bufdeln(1)) ;
}

/* delete n lines, starting with the current line. */

bufdeln(n)
int n ;
{
int oldline, k ;
char *oldbufp ;
	/* remember current buffer parameters */
	oldline=bufline ;
	oldbufp=bufp ;
	/* scan for first line after deleted lines */
	k=0 ;
	while ((n--) > 0) {
		if (bufatbot()) {
			break ;
		}
		if (bufdn() == ERR) {
			bufline=oldline ;
			bufp=oldbufp ;	/*
					 * probable mistake in Dr.Dobbs
					 * corrected. Was oldbufp=bufp !!!!
					 * (KEDB).
					 */
			return (ERR) ;
		}
		k++ ;
	}
	/* compress buffer. Update pointers */
	bufmovup(bufp,bufpmax-1,bufp-oldbufp) ;
	bufpmax=bufpmax-(bufp-oldbufp) ;
	bufp=oldbufp ;
	bufline=oldline ;
	bufmaxln=bufmaxln-k ;
	bufcflag=YES ;
	return (OK) ;
}

/*
 * replace current line with the line that
 * p points to. The new line is of length n.
 */

bufrepl(p,n)
char *p ;
int n ;
{
int oldlen, k ;
char *nextp ;
	/* do not replace null line. just insert */
	if (bufatbot()) {
		return (bufins(p,n)) ;
	}
	/* point nextp at start of next line */
	if (bufdn() == ERR) {
		return (ERR) ;
	}
	nextp=bufp ;
	if (bufup() == ERR) {
		return (ERR) ;
	}
	/* allow for CR at end */
	n=n+1 ;
	/*
	 * see how to move buffer below us.
	 * up, down, or not at all.
	 */
	oldlen=nextp-bufp ;
	if (oldlen < n) {
		/* move buffer down */
		if (bufext(n-oldlen) == ERR) {
			return (ERR) ;
		}
		bufpmax=bufpmax+n-oldlen ;
	}
	else if (oldlen > n) {
		/* move buffer up */
		bufmovup(nextp,bufpmax-1,oldlen-n) ;
		bufpmax=bufpmax-(oldlen-n) ;
	}
	/* put new line in the hole we just made */
	k=0 ;
	while (k < (n-1)) {
		bufp[k]=p[k] ;
		k++ ;
	}
	bufp[k]=CR ;
	bufcflag=YES ;
	return (OK) ;
}

/*
 * copy current line into buffer thet p points to.
 * the maximum size of that buffer is n.
 * return k=length of line in the main buffer.
 * if k>n then truncate n-k characters and only
 * return n characters in the callers buffer.
 */

bufgetln(p,n)
char *p ;
int n ;
{
int k ;
	/* last line is always null */
	if (bufatbot()) {
		return (0) ;
	}
	/* copy line as long as it is not too long */
	k=0 ;
	while (k < n) {
		if (*(bufp+k) == CR) {
			return (k) ;
		}
		*(p+k)=(*(bufp+k)) ;
		k++ ;
	}
	/* count length but move no more chars */
	while (*(bufp+k) != CR) {
		k++ ;
	}
	return (k) ;
}

/* move buffer down (towards HIGH addresses) */

bufmovdn(from,to,length)
char *from, *to ;
int length ;
{
int k ;
	k=to-from+1 ;
	while ((k--) > 0) {
		*(to+length)=(*to) ;
		to-- ;
	}
}


/* move buffer up (towards LOW addresses) */

bufmovup(from,to,length)
char *from, *to ;
int length ;
{
int k ;
	k=to-from+1 ;
	while ((k--) > 0) {
		*(from-length)=(*from) ;
		from++ ;
	}
}

/*
 * return true if at bottom of buffer.
 * NOTE 1: the last line of the buffer is always null.
 * NOTE 2: the last line number is always bufmaxln+1.
 */

bufatbot()
{
	return (bufline>bufmaxln) ;
}

/*
 * return true if at bottom or at the last
 * real line before the bottom.
 */

bufnrbot()
{
	return (bufline >= bufmaxln) ;
}

/* return true if at top of buffer */

bufattop()
{
	return (bufline == 1) ;
}

/*
 * put nlines lines from buffer starting with
 * line topline at position topy of the screen.
 */

bufout(topline,topy,nlines)
int topline, topy, nlines ;
{
char *p ;		/* p is (char *) not int as in Dr.Dobbs. (KEDB) */
int l ;
	/* remember buffers state */
	l=bufline ;
	p=bufp ;
	/* write out one line at a time */
	while ((nlines--) > 0) {
		outxy(0,topy++) ;
		bufoutln(topline++) ;
	}
	/* restore buffers state */
	bufline=l ;
	bufp=p ;
}

/* print line of main buffer on screen */

bufoutln(line)
int line ;
{
	/* error message does NOT go on prompt line */
	if (bufgo(line) == ERR) {
		fmtsout(">>>>> DISK ERROR: LINE DELETED. <<<<<",0) ;
		outdeol() ;
		return ;
	}
	/* blank out lines below last line of buffer */
	if (bufatbot()) {
		outdeol() ;
	}
	/* write one formatted line out */
	else {
		fmtsout(bufp,0) ;
		outdeol() ;
	}
}

/*
 * simple memory version of bufext.
 * create a whole in buffer at current line.
 * length is the size of the whole.
 */

bufext(length)
int length ;
{
	/* make sure there is room for more */
	if ((bufpmax+length) >= bufend) {
		error(">>> THE MAIN BUFFER IS FULL. <<<") ;
		return (ERR) ;
	}
	/* move lines below current line down */
	bufmovdn(bufp,bufpmax-1,length) ;
	bufpmax=bufpmax+length ;
	return (OK) ;
}
/* END OF SOURCE TO EDITOR.C */
