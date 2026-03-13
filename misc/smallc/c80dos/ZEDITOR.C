
/* Screen editor:  main program -- C/80 version
 *
 * Source:  ed2.c
 * Version: August 8, 1982.
 * Transliteration of small-C version of September 5, 1981
 */

/* define globals */

#define EXTERN

/* #include ed1.h */







/* Screen editor:  non-user defined globals
 *
 * Source:  ed1.h
 * Version: May 15, 1980.
 */


/* Define global constants */

/* Define constants describing a text line */

#define MAXLEN	133	/* max chars per line */
#define MAXLEN1	134	/* MAXLEN + 1 */

/* Define operating system constants */

#define SYSFNMAX 15	/* CP/M file name length + 1 */

/* Define misc. constants */

#define EOS	0	/* code sometimes assumes \0 */
#define ERR	-1	/* must be same as ERROR */
#define YES	1	/* must be nonzero */
#define NO	0
#define CR	13	/* carriage return */
#define LF	10	/* line feed */
#define TAB	9	/* tab character */
#define HUGE	32000	/* practical infinity */

#define OK	1
#define EOF	-1






/*
Screen editor:  special key definitions
This file was created by the configuration program:
Version 2:  September 6, 1981.
*/

/*
Define which keys are used for special edit functions.
*/

#define UP1 21
#define DOWN1 13
#define UP2 11
#define DOWN2 10
#define LEFT1 8
#define RIGHT1 12
#define INS1 14
#define EDIT1 5
#define ESC1 27
#define DEL1 127
#define ZAP1 26
#define ABT1 24
#define SPLT1 19
#define JOIN1 16

/*
Define length and width of screen and printer.
*/

#define SCRNW 80
#define SCRNW1 79
#define SCRNL 24
#define SCRNL1 23
#define SCRNL2 22
#define LISTW 80






/*
 * Screen editor:  external definitions (global definitions)
 *
 * Version: August 8, 1982.
 *
 */

/* define flag for startup of editor -- ed2.c */

int	startup;	/* flag for editor startup */
int	argcount;	/* global argc */
char	sname[SYSFNMAX]; /* command line filename */

/* define statics for the command module -- ed3.c */

char filename[SYSFNMAX];	/* file name for (re)save */

/* define statics for the window module -- ed4.c */

char	editbuf[MAXLEN]; /* the edit buffer */
int	editp;		/* cursor: buffer index */
int	editpmax;	/* length of buffer */
int	edcflag;	/* buffer change flag */

/* define statics for the format module -- ed5.c */

int fmttab;		/* max length of tab character */
int fmtdev;		/* device -- YES/NO = LIST/CONSOLE */
int fmtwidth;		/* devide width.  LISTW/SCRNW1 */

/* fmtcol[i] is the first column at which buf[i] is printed.
 * fmtsub() and fmtlen() assume fmtcol[] is valid on entry.
 */

int fmtcol[MAXLEN1];

/* define statics for the terminal module -- ed6.c */

int outx, outy;		/* coordinates of the cursor */

/* define statics for the prompt line module -- ed7.c */

char pmtln[MAXLEN];	/* mode */
char pmtfn[SYSFNMAX];	/* file name */

/* define statics for the operating system module -- ed8.c */

int  iormode;		/* 'r' if file is read mode */

/* define statics for the buffer module -- ed10.c */

/*
 * buffer[] must be the last external variable and it must
 * have a nonzero dimension.
 */

int bufcflag;		/* main buffer changed flag */
char *bufp;		/* start of current line */
char *bufpmax;		/* end of last line */
char *buffer;		/* start of buffer */
char *bufend;		/* last byte of buffer */
int bufline;		/* current line number */
int bufmaxln;		/* number of lines in buffer */








/* define signon message */

#define	SIGNON "Screen Editor, version 2:  August 1982."

/* the main program dispatches the routines that
 * handle the various modes.
 */

#define CMNDMODE 1	/* enter command mode flag */
#define INSMODE  2	/* enter insert modes flag */
#define EDITMODE 3	/* enter edit mode flag */
#define EXITMODE 4	/* exit editor flag */

main(argc,argv)
int argc;
char *argv[];
{
int mode;
	/* fmt output by default goes to screen */
	fmtassn(NO);
	/* set tabs, clear the screen and sign on */
	fmtset(8);
	outclr();
	outxy(0,SCRNL1);
	message(SIGNON);
	outxy(0,1);
	/* clear filename [] for save(), resave() */
	name("");
	/* clear the main buffer */
	bufend=buffer=0;
	bufnew();
	/* start off in command mode */
	mode=CMNDMODE;
	/* set flag for startup command execution */
	startup = YES;
	argcount=argc; /* set startup argument count */
	if (argcount==2)
		strcpy(sname,argv[1]);
	/* get null line 1 for edit() */
	edgetln();
	while(1){
		if (mode == EXITMODE) {
			break;
		}
		else if (mode == CMNDMODE) {
			mode=command();
		}
		else if (mode == EDITMODE) {
			mode=edit();
		}
		else if (mode == INSMODE) {
			mode=insert();
		}
		else {
			syserr("main: no mode");
			mode=EDITMODE;
		}
	}
}

/*
 * handle edit mode.
 * dispatch the proper routine based on one-character commands.
 */

edit()
{
char buffer [SCRNW1];
int v;
int x,y;
char c;
int oldline, topline;
	/* beware of edgetln() or edgo() here because
	 * those calls reset the cursor.
	 */
	pmtedit();
	while(1){
		/* get command */
		c=tolower(syscin());

		if ((c == ESC1) | (c=='c')) {
			/* enter command mode. */
			return(CMNDMODE);
		}
		else if (c == INS1 | c=='i') {
			/* enter insert mode */
			return(INSMODE);
		}
		else if (special(c) == YES) {
			if (c == UP1 | c == DOWN1) {
				return(INSMODE);
			}
			else {
				continue;
			}
		}
		else if (control(c) == YES) {
			continue;
		}
		else if (c == ' ') {
			edright();
			pmtcol();
		}
		else if (c == 'b') {
			edbegin();
			pmtcol();
		}
		else if (c == 'd') {
			/* scroll down */
			pmtmode("edit: scroll");
			oldline=bufln();
			y=outgety();
			topline=oldline-y+1;
			x=outgetx();
			edgo(topline+SCRNL1,x);
			pmtedit();
		}
		else if (c == 'e') {
			edend();
			pmtcol();
		}
		else if (c == 'g') {
			/* save x,y in case don't get number */
			x=outgetx();
			y=outgety();
			pmtcmnd("edit: goto: ",buffer);
			if(number(buffer,fv)) {
				edgo(v,0);
			}
			else {
				outxy(x,y);
			}
			pmtedit();
		}
		else if (c == 'k') {
			pmtmode("edit: kill");
			c=syscin();
			if (special(c) == NO &
			    control(c) == NO) {
				edkill(c);
			}
			pmtedit();
		}
		else if (c == 's') {
			pmtmode("edit: search");
			c=syscin();
			if (special(c) == NO &
			    control(c) == NO) {
				edsrch(c);
			}
			pmtedit();
		}
		else if (c == 'u') {
			/* scroll up */
			pmtmode("edit: scroll");
			oldline=bufln();
			y=outgety();
			topline=oldline-y+1;
			x=outgetx();
			edgo(topline-SCRNL1,x);
			pmtedit();
		}
		else if (c == 'x') {
			pmtmode("edit: eXchange");
			c=syscin();
			if (special(c) == NO &
			    control(c) == NO) {
				edchng(c);
			}
			pmtedit();
		}
		/* do nothing if command not found */
	}
}

/* insert mode.
 * in this mode the UP1, UP2 keys reverse their roles,
 * as do the DOWN1, and DOWN2 keys.
 */

insert()
{
char c;
	pmtmode("insert");
	while (1) {
		/* get command */
		c=syscin();
		if (c == ESC1) {
			/* enter command mode */
			return(CMNDMODE);
		}
		else if (c == EDIT1) {
			/* enter edit mode */
			return(EDITMODE);
		}
		else if (c == INS1) {
			/* do nothing */
			;
		}
		else if (special(c) == YES) {
			if (c == UP2 | c == DOWN2) {
				return(EDITMODE);
			}
			else {
				continue;
			}
		}
		else if (control(c) == YES) {
			/* ignore non-special control chars */
			continue;
		}
		else {
			/* insert one char in line */
			edins(c);
			pmtcol();
		}
	}
}

/* return YES if c is a control char */

control(c) char c;
{
	if (c == TAB) {
		return(NO);	/* tab is regular */
	}
	else if (c>=127) {
		return(YES);	/* del or high bit on */
	}
	else if (c < 32) {
		return(YES);	/* control char */
	}
	else {
		return(NO);	/* normal */
	}
}

/*
 * handle the default actions of all special keys.
 * return YES if c is one of the keys.
 */

special(c) char c;
{
int k;
	if (c == JOIN1) {
		edjoin();
		pmtline();
		return(YES);
	}
	if (c == SPLT1) {
		edsplit();
		pmtline();
		return(YES);
	}
	if (c == ABT1) {
		edabt();
		pmtcol();
		return(YES);
	}
	else if (c == DEL1) {
		eddel();
		pmtcol();
		return(YES);
	}
	else if (c == ZAP1) {
		edzap();
		pmtline();
		return(YES);
	}
	else if (c == UP2) {
		/* move up */
		edup();
		pmtline();
		return(YES);
	}
	else if (c == UP1) {
		/* insert up */
		ednewup();
		pmtline();
		return(YES);
	}
	else if (c == DOWN2) {
		/* move down */
		eddn();
		pmtline();
		return(YES);
	}
	else if (c == DOWN1) {
		/* insert down */
		ednewdn();
		pmtline();
		return(YES);
	}
	else if (c == LEFT1) {
		edleft();
		pmtcol();
		return(YES);
	}
	else if (c == RIGHT1) {
		edright();
		pmtcol();
		return(YES);
	}
	else {
		return(NO);
	}
}

/*
 * command() dispatches command routines while
 * in command mode.
 */

command()
{
int v;
char c;
char args [SCRNW1];
char *argp;
int topline;
int ypos;
int oldline;
int k;
	/* command mode commands may move the current line.
	 * command mode must save the current line on entry
	 * and restore it on exit.
	 */
	edrepl();
	/* remember how the screen was drawn on entry */
	oldline=bufln();
	ypos=outgety();
	topline=oldline-ypos+1;
	while(1) {
		outxy(0,SCRNL1);
		fmtcrlf();
		pmtmode("command:");

		/* if filname on command line use it */
		if (startup == YES & argcount == 2) {
			strcpy(args,"load ");
			strcat(args,sname);
			startup = NO;
		}
		else {
			getcmnd(args,0);
		}
		fmtcrlf();
		pmtline();
		c=args [0];
		if (c == EDIT1 | c==INS1) {
			/* redraw screen */
			if (oldline == bufln()) {
				/* get current line */
				edgetln();
				/* redraw old screen */
				bufout(topline,1,SCRNL1);
				outxy(0,ypos);
			}
			else {
				/* update line and screen */
				edgo(bufln(),0);
			}
			if (c == EDIT1) {
				return (EDITMODE);
			}
			else {
				return (INSMODE);
			}
		}
		else if (tolower(args [0]) == 'g'){
			argp=skipbl(args+1);
			if (argp [0] == EOS) {
				edgo(oldline,0); 
				return(EDITMODE);
			}
			else if (number(argp,fv) == YES) {
				edgo(v,0);
				return(EDITMODE);
			}
			else {
				message("bad line number");
			}
		}
		else if (lookup(args,"append")) {
			append(args);
		}
		else if (lookup(args,"change")) {
			change(args);
		}
		else if (lookup(args,"clear")) {
			clear();
		}
		else if (lookup(args,"delete")) {
			delete(args);
		}
		else if (lookup(args,"dos")) {
			if (chkbuf() == YES) {
				return (EXITMODE);
			}
		}
		else if (lookup(args,"find")) {
			if ((k = find()) >= 0) {
				edgo(bufln(),k);
				return(EDITMODE);
			}
			else {
				/* get current line */
				bufgo(oldline);
				edgetln();
				/* stay in command mode */
				message("pattern not found");
			}
		}
		else if (lookup(args,"list")) {
			list(args);
		}
		else if (lookup(args,"load")) {
			load(args);
		}
		else if (lookup(args,"name")) {
			name(args);
		}
		else if (lookup(args,"resave")) {
			resave();
		}
		else if (lookup(args,"save")) {
			save();
		}
		else if (lookup(args,"search")) {
			search(args);
		}
		else if (lookup(args,"tabs")) {
			tabs(args);
		}
		else {
			message("command not found");
		}
	}
}

/* return YES if line starts with command */

lookup(line,command) char *line, *command;
{
	while(*command) {
		if (tolower(*line++) != *command++) {
			return(NO);
		}
	}
	if(*line == EOS | *line == ' ' | *line == TAB) {
		return(YES);
	}
	else {
		return(NO);
	}
}

/* get next command into argument buffer */

getcmnd(args,offset) char *args; int offset;
{
int j,k;
char c;
	outxy(offset,outgety());
	outdeol();
	k=0;
	while ((c=syscin()) != CR) {
		if (c == EDIT1 | c == INS1) {
			args [0]=c;
			return;
		}
		if (c == DEL1 | c == LEFT1) {
			if (k>0) {
				outxy(offset,outgety());
				outdeol();
				k--;
				j=0;
				while (j < k) {
					outchar(args [j++]);
				}
			}
		}
		else if (c == ABT1) {
			outxy(offset,outgety());
			outdeol();
			k=0;
		}
		else if (c != TAB & (c < 32 | c == 127)) {
			/* do nothing */
			continue;
		}
		else {
			if (k+offset < SCRNW1) {
				args [k++]=c;
				outchar(c);
			}
		}
	}
	args [k]=EOS;
}









/*
 * Screen editor:  command mode commands -- enhanced
 *
 * Source: ed3.c
 * Version: December 20, 1981.
 * Transliteration of small-C version of September 5, 1981
 *
 */

/* define globals */

/* #include ed1.h */

/* data global to these routines */

/* comment out -----
char filename [SYSFNMAX];
----- end comment out */


/* append command.
 * load a file into main buffer at current location.
 * this command does NOT change the current file name.
 */

append(args) char *args;
{
char buffer [MAXLEN];		/* disk line buffer */
int file;
int n;
int topline;
char locfn [SYSFNMAX];		/* local file name */
	/* get file name which follows command */
	if (name1(args,locfn) == ERR) {
		return;
	}
	if (locfn [0] == EOS) {
		message("no file argument");
		return;
	}
	/* open the new file */
	if ((file=sysopen(locfn,"r")) == ERR) {
		message("file not found");
		return;
	}
	/* read the file into the buffer */
	while ((n=readline(file,buffer,MAXLEN)) >= 0) {
		if (n > MAXLEN) {
			message("line truncated");
			n=MAXLEN;
		}
		if (bufins(buffer,n) == ERR) {
			break;
		}
		if (bufdn() == ERR) {
			break;
		}
	}
	/* close the file */
	sysclose(file);
	/* redraw the screen so topline will be at top
	 * of the screen after command() does a CR/LF.
	 */
	topline=max(1,bufln()-SCRNL2);
	bufout(topline,2,SCRNL2);
	bufgo(topline);
}

/* global change command */

change(args) char *args;
{
char oldline [MAXLEN1];		/* reserve space for EOS */
char newline [MAXLEN1];
char oldpat [MAXLEN1];
char newpat [MAXLEN1];
int from, to, col, n, k;
	if (get2args(args,ffrom,fto) == ERR) {
		return;
	}
	/* get search and change masks into oldpat, newpat */
	fmtsout("search mask ?  ",0);
	getcmnd(oldpat,15);
	fmtcrlf();
	if (oldpat [0] == EOS) {
		return;
	}
	pmtline();
	fmtsout("change mask ?  ",0);
	getcmnd(newpat,15);
	fmtcrlf();
	/* make substitution for lines between from, to */
	while (from <= to) {
		if (chkkey() == YES) {
			break;
		}
		if (bufgo(from++) == ERR) {
			break;
		}
		if (bufatbot() == YES) {
			break;
		}
		n=bufgetln(oldline,MAXLEN);
		n=min(n,MAXLEN);
		oldline [n]=EOS;
		/* '^' anchors search */
		if (oldpat [0] == '^') {
			if (amatch(oldline,oldpat+1,0) == YES) {
				k=replace(oldline,newline,
					oldpat+1,newpat,0);
				if (k == ERR) {
					return;
				}
				fmtcrlf();
				putdec(bufln(),5);
				fmtsout(newline,5);
				outdeol();
				bufrepl(newline,k);
			}
			continue;
		}
		/* search oldline for oldpat */
		col=0;
		while (col < n) {
			if (amatch(oldline,oldpat,col++) == YES){
				k=replace(oldline,newline,
					oldpat,newpat,col-1);
				if (k == ERR) {
					return;
				}
				fmtcrlf();
				putdec(bufln(),5);
				fmtsout(newline,5);
				outdeol();
				bufrepl(newline,k);
				break;
			}
		}
	}
	fmtcrlf();
}

/* clear main buffer and file name */

clear()
{
	/* make sure it is ok to clear buffer */
	if (chkbuf() == YES) {
		filename [0]=0;
		pmtfile("");
		outclr();
		outxy(0,SCRNL1);
		bufnew();
		message("buffer cleared");
	}
}

/* multiple line delete command */

delete(args) char *args;
{
int from, to;
	if (get2args(args,ffrom,fto) == ERR) {
		return;
	}
	if (from > to) {
		return;
	}
	/* go to first line to be deleted */
	if (bufgo(from) == ERR) {
		return;
	}
	/* delete all line between from and to */
	if (bufdeln(to-from+1) == ERR) {
		return;
	}
	/* redraw the screen */
	bufout(bufln(),1,SCRNL1);
}

/* search all lines below the current line for a pattern
 * return -1 if pattern not found.
 * otherwise, return column number of start of pattern.
 */

find()
{
	return(search1(bufln()+1,HUGE,YES));
}

/* list lines to list device */

list(args) char *args;
{
char linebuf [MAXLEN1];
int n;
int from, to, line, oldline;
	/* save the buffer's current line */
	oldline=bufln();
	/* get starting, ending lines to print */
	if (get2args(args,ffrom,fto) == ERR) {
		return;
	}
	/* print lines one at a time to list device */
	line=from;
	while (line <= to) {
		/* make sure prompt goes to console */
		fmtassn(NO);
		/* check for interrupt */
		if (chkkey() == YES) {
			break;
		}
		/* print line to list device */
		fmtassn(YES);
		if (bufgo(line++) != OK) {
			break;
		}
		if (bufatbot()) {
			break;
		}
		n=bufgetln(linebuf,MAXLEN1);
		n=min(n,MAXLEN);
		linebuf [n]=CR;
		fmtsout(linebuf,0);
		fmtcrlf();
	}
	/* redirect output to console */
	fmtassn(NO);
	/* restore cursor */
	bufgo(oldline);
}

/* load file into buffer */

load (args) char *args;
{
char buffer [MAXLEN];	/* disk line buffer */
char locfn  [SYSFNMAX];  /* file name until we check it */
int n;
int file;
int topline;
	/* get filename following command */
	if (name1(args,locfn) == ERR) {
		return;
	}
	if (locfn [0] == EOS) {
		message("no file argument");
		return;
	}
	/* give user a chance to save the buffer */
	if (chkbuf() == NO) {
		return;
	}
	/* open the new file */
	if ((file=sysopen(locfn,"r")) == ERR) {
		message("file not found");
		return;
	}
	/* update file name */
	syscopfn(locfn, filename);
	pmtfile(filename);
	/* clear the buffer */
	bufnew();
	/* read the file into the buffer */
	while ((n=readline(file,buffer,MAXLEN)) >= 0) {
		if (n > MAXLEN) {
			message("line truncated");
			n=MAXLEN;
		}
		if (bufins(buffer,n) == ERR) {
			break;
		}
		if (bufdn() == ERR) {
			break;
		}
	}
	/* close the file */
	sysclose(file);
	/* indicate that the buffer is fresh */
	bufsaved();
	/* set current line to line 1 */
	bufgo(1);
	/* redraw the screen so that topline will be
	 * on line 1 after command() does a CR/LF.
	 */
	topline=max(1,bufln()-SCRNL2);
	bufout(topline,2,SCRNL2);
	bufgo(topline);
}

/* change current file name */

name(args) char *args;
{
	name1(args,filename);
	pmtfile(filename);
}

/* check syntax of args.
 * copy to filename.
 * return OK if the name is valid.
 */

name1(args,filename) char *args, *filename;
{
	/* skip command */
	args=skiparg(args);
	args=skipbl(args);
	/* check file name syntax */
	if (syschkfn(args) == ERR) {
		return(ERR);
	}
	/* copy filename */
	syscopfn(args,filename);
	return(OK);
}

/* save the buffer in an already existing file */

resave()
{
char linebuf [MAXLEN];
int file, n, oldline;
	/* make sure file has a name */
	if (filename [0] == EOS) {
		message("file not named");
		return;
	}
	/* the file must exist for resave */
	if ((file=sysopen(filename,"r")) == ERR) {
		message("file not found");
		return;
	}
	if (sysclose(file) == ERR) {
		return;
	}
	/* open the file for writing */
	if ((file=sysopen(filename,"w")) == ERR) {
		return;
	}
	/* save the current position of file */
	oldline=bufln();
	/* write out the whole file */
	if (bufgo(1) == ERR) {
		sysclose(file);
		return;
	}
	while (bufatbot() == NO) {
		n=bufgetln(linebuf,MAXLEN);
		n=min(n,MAXLEN);
		if (pushline(file,linebuf,n) == ERR) {
			break;
		}
		if (bufdn() == ERR) {
			break;
		}
	}
	/* indicate if all buffer was saved */
	if (bufatbot()){
		bufsaved();
	}
	/* close file and restore line number */
	sysclose(file);
	bufgo(oldline);
}

/* save the buffer in a new file */

save()
{
char linebuf [MAXLEN];
int file, n, oldline;
	/* make sure the file is named */
	if (filename [0] == EOS) {
		message("file not named");
		return;
	}
	/* file must NOT exist for save */
	if ((file=sysopen(filename,"r")) != ERR) {
		sysclose(file);
		message("file exists");
		return;
	}
	/* open file for writing */
	if ((file=sysopen(filename,"w")) == ERR) {
		return;
	}
	/* remember current line */
	oldline=bufln();
	/* write entire buffer to file */
	if (bufgo(1) == ERR) {
		sysclose(file);
		return;
	}
	while (bufatbot() == NO) {
		n=bufgetln(linebuf,MAXLEN);
		n=min(n,MAXLEN);
		if (pushline(file,linebuf,n) == ERR) {
			break;
		}
		if (bufdn() == ERR) {
			break;
		}
	}
	/* indicate buffer saved if good write */
	if (bufatbot()) {
		bufsaved();
	}
	/* restore line and close file */
	bufgo(oldline);
	sysclose(file);
}

/* global search command */

search(args) char *args;
{
int from, to;

	if (get2args(args,ffrom,fto) == ERR) {
		return;
	}
	search1(from, to, NO);
}

/* search lines for a pattern.
 * if flag  ==  YES: stop at the first match.
 *                 return -1 if no match.
 *                 otherwise return column number of match.
 * if flag  ==  NO:  print all matches found.
 */

search1(from, to, flag) int from, to, flag;
{
char pat   [MAXLEN1];		/* reserve space for EOS */
char line  [MAXLEN1];
int col, n;
	/* get search mask into pat */
	fmtsout("search mask ?  ",0);
	getcmnd(pat,15);
	fmtcrlf();
	if (pat [0] == EOS) {
		return;
	}
	/* search all lines between from and to for pat */
	while (from <= to) {
		if (chkkey() == YES) {
			break;
		}
		if (bufgo(from++) == ERR) {
			break;
		}
		if (bufatbot() == YES) {
			break;
		}
		n=bufgetln(line,MAXLEN);
		n=min(n,MAXLEN);
		line [n]=EOS;
		/* ^ anchors search */
		if (pat [0] == '^') {
			if (amatch(line,pat+1,0) == YES) {
				if (flag == NO) {
					fmtcrlf();
					putdec(bufln(),5);
					fmtsout(line,5);
					outdeol();
				}
				else {
					return(0);
				}
			}
			continue;
		}
		/* search whole line for match */
		col=0;
		while (col < n) {
			if (amatch(line,pat,col++) == YES) {
				if (flag == NO) {
					fmtcrlf();
					putdec(bufln(),5);
					fmtsout(line,5);
					outdeol();
					break;
				}
				else {
					return(col-1);
				}
			}
		}
	}
	/* all searching is finished */
	if (flag == YES) {
		return(-1);
	}
	else {
		fmtcrlf();
	}
}

/* set tab stops for fmt routines */

tabs(args) char *args;
{
int n, junk;
	if (get2args(args,fn,fjunk) == ERR) {
		return;
	}
	fmtset(n);
}

/* return YES if buffer may be drastically changed */

chkbuf()
{
	if (bufchng() == NO) {
		/* buffer not changed. no problem */
		return(YES);
	}
	fmtsout("buffer not saved. proceed ?  ",0);
	pmtline();
	if (tolower(syscout(syscin())) != 'y') {
		fmtcrlf();
		message("cancelled");
		return(NO);
	}
	else {
		fmtcrlf();
		return(YES);
	}
}

/* print message from a command */

message(s) char *s;
{
	fmtsout(s,0);
	fmtcrlf();
}

/* get two arguments the argument line args.
 * no arguments imply 1 HUGE.
 * one argument implies both args the same.
 */

get2args(args,val1,val2) char *args; int *val1, *val2;
{
	/* skip over the command */
	args=skiparg(args);
	args=skipbl(args);
	if (*args == EOS) {
		*val1=1;
		*val2=HUGE;
		return(OK);
	}
	/* check first argument */
	if (number(args,val1) == NO) {
		message("bad argument");
		return(ERR);
	}
	/* skip over first argument */
	args=skiparg(args);
	args=skipbl(args);
	/* 1 arg: arg 2 is HUGE */
	if (*args == EOS) {
		*val2=HUGE;
		return(OK);
	}
	/* check second argument */
	if (number(args,val2) == NO) {
		message("bad argument");
		return(ERR);
	}
	else {
		return(OK);
	}
}

/* skip over all except EOS, and blanks */

skiparg(args) char *args;
{
	while (*args != EOS & *args!=' ') {
		args++;
	}
	return(args);
}

/* skip over all blanks */

skipbl(args) char *args;
{
	while (*args == ' ') {
		args++;
	}
	return(args);
}

/* return YES if the user has pressed any key.
 * blanks cause a transparent pause.
 */
chkkey()
{
int c;
	c=syscstat();
	if (c == 0) {
		/* no character at keyboard */
		return(NO);
	}
	else if (c == ' ') {
		/* pause.  another blank ends pause */
		pmtline();
		if (syscin() == ' ') {
			return(NO);
		}
	}
	/* we got a nonblank character */
	return(YES);
}

/* anchored search for pattern in text line at column col.
 * return YES if the pattern starts at col.
 */

amatch(line,pat,col) char *line, *pat; int col;
{
int k;
	k=0;
	while (pat [k] != EOS) {
		if (pat [k] == line[col]) {
			k++;
			col++;
		}
		else if (pat [k] == '?' & line[col] != EOS) {
			/* question mark matches any char */
			k++;
			col++;
		}
		else {
			return(NO);
		}
	}
	/* the entire pattern matches */
	return(YES);
}

/* replace oldpat in oldline by newpat starting at col.
 * put result in newline.
 * return number of characters in newline.
 */

replace(oldline,newline,oldpat,newpat,col)
char *oldline, *newline, *oldpat, *newpat; int col;
{
int k;
char *tail, *pat;
	/* copy oldline preceding col to newline */
	k=0;
	while (k < col) {
		newline [k++]= *oldline++;
	}
	/* remember where end of oldpat in oldline is */
	tail=oldline;
	pat=oldpat;
	while (*pat++ != EOS) {
		tail++;
	}
	/* copy newpat to newline.
	 * use oldline and oldpat to resolve question marks
	 * in newpat.
	 */
	while (*newpat != EOS) {
		if (k > MAXLEN-1) {
			message("new line too long");
			return(ERR);
		}
		if (*newpat != '?') {
			/* copy newpat to newline */
			newline [k++]= *newpat++;
			continue;
		}
		/* scan for '?' in oldpat */
		while (*oldpat != '?') {
			if (*oldpat == EOS) {
				message(
				"too many ?'s in change mask"
				);
				return(ERR);
			}
			oldpat++;
			oldline++;
		}
		/* copy char from oldline to newline */
		newline [k++]= *oldline++;
		oldpat++;
		newpat++;
	}
	/* copy oldline after oldpat to newline */
	while (*tail != EOS) {
		if (k >= MAXLEN-1) {
			message("new line too long");
			return(ERR);
		}
		newline [k++]= *tail++;
	}
	newline [k]=EOS;
	return(k);
}











/*
 * Screen editor:  window module
 *
 * Source:  ed4.c
 * Version: August 21, 1981.
 */

/* define global constants, variables */

/* #include ed1.h */

/* data global to this module -----

char	editbuf[MAXLEN];	the edit buffer
int	editp;			cursor: buffer index
int	editpmax;		length of buffer
int	edcflag;		buffer change flag

----- */

/* abort any changes made to current line */

edabt()
{
	/* get unchanged line and reset cursor */
	edgetln();
	edredraw();
	edbegin();
	edcflag = NO;
}

/* put cursor at beginning of current line */

edbegin()
{
	editp = 0;
	outxy(0,outgety());
}

/* change editbuf[editp] to c
 * don't make change if line would become to long
 */

edchng(c) char c;
{
char oldc;
int k;
	/* if at right margin then insert char */
	if (editp >= editpmax) {
		edins(c);
		return;
	}
	/* change char and print length of line */
	oldc = editbuf[editp];
	editbuf[editp] = c;
	fmtadj(editbuf,editp,editpmax);
	k = fmtlen(editbuf,editpmax);
	if (k > SCRNW1) {
		/* line would become too long */
		/* undo the change */
		editbuf[editp] = oldc;
		fmtadj(editbuf,editp,editpmax);
	}
	else {
		/* set change flag, redraw line */
		edcflag = YES;
		editp++;
		edredraw();
	}
}

/* delete the char to left of cursor if it exists */

eddel()
{
int k;
	/* just move left one column if past end of line */
	if (edxpos() < outgetx()) {
		outxy(outgetx()-1, outgety());
		return;
	}
	/* do nothing if cursor is at left margin */
	if (editp == 0) {
		return;
	}
	edcflag = YES;
	/* compress buffer (delete char) */
	k = editp;
	while (k < editpmax) {
		editbuf[k-1] = editbuf[k];
		k++;
	}
	/* update pointers, redraw line */
	editp--;
	editpmax--;
	edredraw();
}

/* edit the next line.  do not go to end of buffer */

eddn()
{
int oldx;
	/* save visual position of cursor */
	oldx = outgetx();
	/* replace current edit line */
	if (edrepl() != OK) {
		return(ERR);
	}
	/* do not go past last non-null line */
	if (bufnrbot()) {
		return(OK);
	}
	/* move down one line in buffer */
	if (bufdn() != OK) {
		return(ERR);
	}
	edgetln();
	/* put cursor as close as possible on this
	 * new line to where it was on the old line.
	 */
	editp = edscan(oldx);
	/* update screen */
	if (edatbot()) {
		edsup(bufln()-SCRNL2);
		outxy(oldx, SCRNL1);
	}
	else {
		outxy(oldx, outgety()+1);
	}
	return(OK);
}

/* put cursor at the end of the current line */

edend()
{
	editp = editpmax;
	outxy(edxpos(),outgety());
	
	/* comment out ----- put cursor at end of screen
	outxy(SCRNW1, outgety());
	----- end comment out */
}

/* start editing line n
 * redraw the screen with cursor at position p
 */

edgo(n, p) int n, p;
{
	/* replace current line */
	if (edrepl() == ERR) {
		return(ERR);
	}
	/* go to new line */
	if (bufgo(n) == ERR) {
		return(ERR);
	}
	/* prevent going past end of buffer */
	if (bufatbot()) {
		if (bufup() == ERR) {
			return(ERR);
		}
	}
	/* redraw the screen */
	bufout(bufln(),1,SCRNL1);
	edgetln();
	editp = min(p, editpmax);
	outxy(edxpos(), 1);
	return(OK);
}

/* insert c into the buffer if possible */

edins(c) char c;
{
int k;

	/* do nothing if edit buffer is full */
	if (editpmax >= MAXLEN) {
		return;
	}
	/* fill out line if we are past its end */
	if (editp == editpmax & edxpos() < outgetx()) {
		k = outgetx() - edxpos();
		editpmax = editpmax + k;
		while (k-- > 0) {
			editbuf [editp++] = ' ';
		}
		editp = editpmax;
	}
	/* make room for inserted character */
	k = editpmax;
	while (k > editp) {
		editbuf[k] = editbuf[k-1];
		k--;
	}
	/* insert character. update pointers */
	editbuf[editp] = c;
	editp++;
	editpmax++;
	/* recalculate print length of line  */
	fmtadj(editbuf,editp-1,editpmax);
	k = fmtlen(editbuf,editpmax);
	if (k > SCRNW1) {
		/* line would become too long */
		/* delete what we just inserted */
		eddel();
	}
	else {
		/* set change flag, redraw line */
		edcflag = YES;
		edredraw();
	}
}

/* join (concatenate) the current line with the one above it */

edjoin()
{
int k;

	/* do nothing if at top of file */
	if (bufattop()) {
		return;
	}
	/* replace lower line temporarily */
	if (edrepl() != OK) {
		return;
	}
	/* get upper line into buffer */
	if (bufup() != OK) {
		return;
	}
	k = bufgetln(editbuf, MAXLEN);
	/* append lower line to buffer */
	if (bufdn() != OK) {
		return;
	}
	k = k + bufgetln(editbuf+k, MAXLEN-k);
	/* abort if the screen isn't wide enough */
	if (k > SCRNW1) {
		/* bug fix */
		bufgetln(editbuf,MAXLEN);
		return;
	}
	/* replace upper line */
	if (bufup() != OK) {
		return;
	}
	editpmax = k;
	edcflag = YES;
	if (edrepl() != OK) {
		return;
	}
	/* delete the lower line */
	if (bufdn() != OK) {
		return;
	}
	if (bufdel() != OK) {
		return;
	}
	if (bufup() != OK) {
		return;
	}
	/* update the screen */
	if (edattop()) {
 		edredraw();
	}
	else {
		k = outgety() - 1;
		bufout(bufln(),k,SCRNL-k);
		outxy(0,k);
		edredraw();
	}
}

/* delete chars until end of line or c found */

edkill(c) char c;
{
int k,p;
	/* do nothing if at right margin */
	if (editp == editpmax) {
		return;
	}
	edcflag = YES;
	/* count number of deleted chars */
	k = 1;
	while ((editp+k) < editpmax) {
		if (editbuf[editp+k] == c) {
			break;
		}
		else {
			k++;
		}
	}
	/* compress buffer (delete chars) */
	p = editp+k;
	while (p < editpmax) {
		editbuf[p-k] = editbuf[p];
		p++;
	}
	/* update buffer size, redraw line */
	editpmax = editpmax-k;
	edredraw();
}

/* move cursor left one column.
 * never move the cursor off the current line.
 */

edleft()
{
int k;

	/* if past right margin, move left one column */
	if (edxpos() < outgetx()) {
		outxy(max(0, outgetx()-1), outgety());
	}
	/* inside the line.  move left one character */
	else if (editp != 0) {
		editp--;
		outxy(edxpos(),outgety());
	}
}

/* insert a new blank line below the current line */

ednewdn()
{
int k;
	/* make sure there is a current line and 
	 * put the current line back into the buffer.
	 */
	if (bufatbot()) {
		if (bufins(editbuf,editpmax) != OK) {
			return;
		}
	}
	else if (edrepl() != OK) {
			return;
	}
	/* move past current line */
	if (bufdn() != OK) {
		return;
	}
	/* insert place holder:  zero length line */
	if (bufins(editbuf,0) != OK) {
		return;
	}
	/* start editing the zero length line */
	edgetln();
	/* update the screen */
	if (edatbot()) {
		/* note: bufln()  >= SCRNL */
		edsup(bufln()-SCRNL2);
		outxy(edxpos(),SCRNL1);
	}
	else {
		k = outgety();
		bufout(bufln(),k+1,SCRNL1-k);
		outxy(edxpos(),k+1);
	}
}

/* insert a new blank line above the current line */

ednewup()
{
int k;
	/* put current line back in buffer */
	if (edrepl() != OK) {
		return;
	}
	/* insert zero length line at current line */
	if (bufins(editbuf,0) != OK) {
		return;
	}
	/* start editing the zero length line */
	edgetln();
	/* update the screen */
	if (edattop()) {
		edsdn(bufln());
		outxy(edxpos(),1);
	}
	else {
		k = outgety();
		bufout(bufln(),k,SCRNL-k);
		outxy(edxpos(),k);
	}
}

/* move cursor right one character.
 * never move the cursor off the current line.
 */

edright()
{
	/* if we are outside the line move right one column */
	if (edxpos() < outgetx()) {
		outxy (min(SCRNW1, outgetx()+1), outgety());
	}
	/* if we are inside a tab move to the end of it */
	else if (edxpos() > outgetx()) {
		outxy (edxpos(), outgety());
	}
	/* move right one character if inside line */
	else if (editp < editpmax) {
		editp++;
		outxy(edxpos(),outgety());
	}
	/* else move past end of line */
	else {
		outxy (min(SCRNW1, outgetx()+1), outgety());
	}
}

/* split the current line into two parts.
 * scroll the first half of the old line up.
 */

edsplit()
{
int p, q;
int k;

	/* indicate that edit buffer has been saved */
	edcflag = NO;
	/* replace current line by the first half of line */
	if (bufatbot()) {
		if (bufins(editbuf, editp) != OK) {
			return;
		}
	}
	else {
		if (bufrepl(editbuf, editp) != OK) {
			return;
		}
	}
	/* redraw the first half of the line */
	p = editpmax;
	q = editp;
	editpmax = editp;
	editp = 0;
	edredraw();
	/* move the second half of the line down */
	editp = 0;
	while (q < p) {
		editbuf [editp++] = editbuf [q++];
	}
	editpmax = editp;
	editp = 0;
	/* insert second half of the line below the first */
	if (bufdn() != OK) {
		return;
	}
	if (bufins(editbuf, editpmax) != OK) {
		return;
	}
	/* scroll the screen up and draw the second half */
	if (edatbot()) {
		edsup(bufln()-SCRNL2);
		outxy(1,SCRNL1);
		edredraw();
	}
	else {
		k = outgety();
		bufout(bufln(), k+1, SCRNL1-k);
		outxy(1, k+1);
		edredraw();
	}
}

/* move cursor right until end of line or
 * character c found.
 */

edsrch(c) char c;
{
	/* do nothing if at right margin */
	if (editp == editpmax) {
		return;
	}
	/* scan for search character */
	editp++;
	while (editp < editpmax) {
		if (editbuf[editp] == c) {
			break;
		}
		else {
			editp++;
		}
	}
	/* reset cursor */
	outxy(edxpos(),outgety());
}

/* move cursor up one line if possible */

edup()
{
int oldx;
	/* save visual position of cursor */
	oldx = outgetx();
	/* put current line back in buffer */
	if (edrepl() != OK) {
		return(ERR);
	}
	/* done if at top of buffer */
	if (bufattop()) {
		return(OK);
	}
	/* start editing the previous line */
	if (bufup() != OK) {
		return(ERR);
	}
	edgetln();
	/* put cursor on this new line as close as
	 * possible to where it was on the old line.
	 */
	editp = edscan(oldx);
	/* update screen */
	if (edattop()) {
		edsdn(bufln());
		outxy(oldx, 1);
	}
	else {
		outxy(oldx, outgety()-1);
	}
	return(OK);
}

/* delete the current line */

edzap()
{
int k;
	/* delete the line in the buffer */
	if (bufdel() != OK) {
		return;
	}
	/* move up one line if now at bottom */
	if (bufatbot()) {
		if (bufup() != OK) {
			return;
		}
		edgetln();
		/* update screen */
		if (edattop()) {
			edredraw();
		}
		else {
			outdelln();
			outxy(0,outgety()-1);
		}
		return;
	}
	/* start editing new line */
	edgetln();
	/* update screen */
	if (edattop()) {
		edsup(bufln());
		outxy(0,1);
	}
	else {
		k = outgety();
		bufout(bufln(),k,SCRNL-k);
		outxy(0,k);
	}
}

/* return true if the current edit line is being
 * displayed on the bottom line of the screen.
 */

edatbot()
{
	return(outgety() == SCRNL1);
}

/* return true if the current edit line is being
 * displayed on the bottom line of the screen.
 */

edattop()
{
	return(outgety() == 1);
}

/* redraw edit line from index to end of line */
/* reposition cursor */

edredraw()
{
	fmtadj(editbuf,0,editpmax);
	fmtsubs(editbuf,max(0,editp-1),editpmax);
	outxy(edxpos(),outgety());
}

/* return the x position of the cursor on screen */

edxpos()
{
	return(min(SCRNW1,fmtlen(editbuf,editp)));
}


/* fill edit buffer from current main buffer line.
 * the caller must check to make sure the main
 * buffer is available.
 */

edgetln()
{
int k;
	/* put cursor on left margin, reset flag */
	editp = 0;
	edcflag = NO;
	/* get edit line from main buffer */
	k = bufgetln(editbuf,MAXLEN);
	if (k > MAXLEN) {
		error("line truncated");
		editpmax = MAXLEN;
	}
	else {
		editpmax = k;
	}
	fmtadj(editbuf,0,editpmax);
}

/* replace current main buffer line by edit buffer.
 * the edit buffer is NOT changed or cleared.
 * return ERR is something goes wrong.
 */

edrepl()
{
	/* do nothing if nothing has changed */
	if (edcflag == NO) {
		return(OK);
	}
	/* make sure we don't replace the line twice */
	edcflag = NO;
	/* insert instead of replace if at bottom of file */
	if (bufatbot()) {
		return(bufins(editbuf,editpmax));
	}
	else {
		return(bufrepl(editbuf,editpmax));
	}
}

/* set editp to the largest index such that
 * buf[editp] will be printed <= xpos
 */

edscan(xpos) int xpos;
{
	editp = 0;
	while (editp < editpmax) {
		if (fmtlen(editbuf,editp) < xpos) {
			editp++;
		}
		else {
			break;
		}
	}
	return(editp);
}

/* scroll the screen up.  topline will be new top line */

edsup(topline) int topline;
{
	if (outhasup() == YES) {
		/* hardware scroll */
		outsup();
		/* redraw bottom line */
		bufout(topline+SCRNL2,SCRNL1,1);
	}
	else {
		/* redraw whole screen */
		bufout(topline,1,SCRNL1);
	}
}

/* scroll screen down.  topline will be new top line */

edsdn(topline) int topline;
{
	if (outhasdn() == YES) {
		/* hardware scroll */
		outsdn();
		/* redraw top line */
		bufout(topline,1,1);
	}
	else {
		/* redraw whole screen */
		bufout(topline,1,SCRNL1);
	}
}









/* Screen editor:  output format module
 *
 * Source: ed5.c
 * Version: May 15, 1981.
 */

/* define globals */

/* #include ed1.h */

/* variables global to this module -----

int fmttab;		maximal tab length
int fmtdev;		device flag -- YES/NO = LIST/CONSOLE
int fmtwidth;		devide width.  LISTW/SCRNW1

fmtcol[i] is the first column at which buf[i] is printed.
fmtsub() and fmtlen() assume fmtcol[] is valid on entry.

int fmtcol[MAXLEN1];

----- */

/* direct output from this module to either the console or
 * the list device.
 */

fmtassn(listflag) int listflag;
{
	if (listflag==YES) {
		fmtdev=YES;
		fmtwidth=LISTW;
	}
	else {
		fmtdev=NO;
		fmtwidth=SCRNW1;
	}
}

/* adjust fmtcol[] to prepare for calls on
 * fmtout() and fmtlen()
 *
 * NOTE:  this routine is needed as an efficiency
 *        measure.  Without fmtadj(), calls on
 *        fmtlen() become too slow.
 */

fmtadj(buf,minind,maxind) char *buf; int minind,maxind;
{
int k;
	/* line always starts at left margin */
	fmtcol[0]=0;
	/* start scanning at minind */
	k=minind;
	while (k<maxind) {
		if (buf[k]==CR) {
			break;
		}
		fmtcol[k+1]=fmtcol[k]+fmtlench(buf[k],fmtcol[k]);
		k++;
	}
}

/* return column at which at which buf[i] will be printed */

fmtlen(buf,i) char *buf; int i;
{
	return(fmtcol[i]);
}

/* print buf[i] ... buf[j-1] on current device so long as
 * characters will not be printed in last column.
 */

fmtsubs(buf,i,j) char *buf; int i, j;
{
int k;
	if (fmtcol[i]>=fmtwidth) {
		return;
	}
	outxy(fmtcol[i],outgety());	/* position cursor */
	while (i<j) {
		if (buf[i]==CR) {
			break;
		}
		if (fmtcol[i+1]>fmtwidth) {
			break;
		}
		fmtoutch(buf[i],fmtcol[i]);
		i++;
	}
	outdeol();	/* clear rest of line */
}

/* print string which ends with CR or EOS to current device.
 * truncate the string if it is too long.
 */

fmtsout(buf,offset) char *buf; int offset;
{
char c;
int col,k;
	col=0;
	while (c= *buf++) {
		if (c==CR) {
			break;
		}
		k=fmtlench(c,col);
		if ((col+k+offset)>fmtwidth) {
			break;
		}
		fmtoutch(c,col);
		col=col+k;
	}
}

/* return length of char c at column col */

fmtlench(c,col) char c; int col;
{
	if (c==TAB) {
		/* tab every fmttab columns */
		return(fmttab-(col%fmttab));
	}
	else if (c<32) {
		/* control char */
		return(2);
	}
	else {
		return(1);
	}
}

/* output one character to current device.
 * convert tabs to blanks.
 */

fmtoutch(c,col) char c; int col;
{
int k;
	if (c==TAB) {
		k=fmtlench(TAB,col);
		while ((k--)>0) {
			fmtdevch(' ');
		}
	}
	else if (c<32) {
		fmtdevch('^');
		fmtdevch(c+64);
	}
	else {
		fmtdevch(c);
	}
}

/* output character to current device */

fmtdevch(c) char c;
{
	if (fmtdev==YES) {
		syslout(c);
	}
	else {
		outchar(c);
	}
}

/* output a CR and LF to the current device */

fmtcrlf()
{
	if (fmtdev==YES) {
		syslout(CR);
		syslout(LF);
	}
	else {
		/* kludge: this should be in out module */
		/* make sure out module knows position */
		outxy(0,SCRNL1);
		syscout(CR);
		syscout(LF);
	}
}

/* set tabs at every n columns */

fmtset(n) int n;
{
	fmttab=max(1,n);
}











/*
Screen editor:  terminal output module
Source:  ed6.c
This file was created by the configuration program:
Version 2:  September 6, 1981.
*/

/* #include ed1.h */

/*
This I/O section is designed for multiple terminals.
Include the following #define for VT100/ANSI escape
sequences, and comment it out for VT52 escape sequences.
*/

/* #define VT100  */

/*
Define the current coordinates of the cursor.
*/

/*
Return the current coordinates of the cursor.
*/

outgetx()
{
	return(outx);
}

outgety()
{
	return(outy);
}

/*
Output one printable character to the screen.
*/

outchar(c) char c;
{
	syscout(c);
	outx++;
	return(c);
}

/*
Position cursor to position x,y on screen.
0,0 is the top left corner.
*/

outxy(x,y) int x,y;
{
	outx=x;
	outy=y;
/* #ifdef VT100 */
	/* syscout(27); */
	/* syscout('['); */
	/* syscout(++y/10+'0'); */
	/* syscout(y%10+'0'); */
	/* syscout(';'); */
	/* syscout(++x/10+'0'); */
	/* syscout(x%10+'0'); */
	/* syscout('H'); */
/* #else */
	syscout(27);
	syscout('Y');
	syscout(y+32);
	syscout(x+32);
/* #endif */
}

/*
Erase the entire screen.
Make sure the rightmost column is erased.
*/

outclr()
{
/* #ifdef VT100 */
	/* syscout(27); */
	/* syscout('['); */
	/* syscout('H'); */
	/* syscout(27); */
	/* syscout('['); */
	/* syscout('J'); */
/* #else */
	syscout(27);
	syscout('H');
	syscout(27);
	syscout('J');
/* #endif */
}

/*
Delete the line on which the cursor rests.
Leave the cursor at the left margin.
*/

outdelln()
{
	outxy(0,outy);
	outdeol();
}

/*
Delete to end of line.
Assume the last column is blank.
*/

outdeol()
{
/* #ifdef VT100 */
	/* syscout(27); */
	/* syscout('['); */
	/* syscout('K'); */
/* #else */
	syscout(27);
	syscout('K');
/* #endif */
}

/*
Return yes if terminal has indicated hardware scroll.
*/

outhasup()
{
	return(YES);
}

outhasdn()
{
	return(YES);
}

/*
Scroll the screen up.
Assume the cursor is on the bottom line.
*/

outsup()
{
	syscout(10);
}

/*
Scroll screen down.
Assume the cursor is on the top line.
*/

outsdn()
{
/* #ifdef VT100 */
	/* syscout(27); */
	/* syscout('['); */
	/* syscout('H'); */
	/* syscout(27); */
	/* syscout('M'); */
/* #else */
	syscout(27);
	syscout('H');
	syscout(27);
	syscout('I');
/* #endif */
	outxy(outx,outy);
}










/* Screen editor:  prompt line module
 *
 * Source:  ed7.c
 * Version: May 15, 1981.
 */

/* define globals */

/* #include ed1.h */

/* globals used by this module -----

char pmtln[MAXLEN];		mode
char pmtfn[SYSFNMAX];		file name

----- */

/* put error message on prompt line.
 * wait for response.
 */

pmtmess(s1,s2) char *s1, *s2;
{
int x,y;
	/* save cursor */
	x=outgetx();
	y=outgety();
	outxy(0,0);
	/* make sure line is correct */
	outdelln();
	pmtlin1();
	pmtcol1(x);
	/* output error message */
	fmtsout(s1,outgetx());
	fmtsout(s2,outgetx());
	/* wait for input from console */
	syscin();
	/* redraw prompt line */
	pmtlin1();
	pmtcol1(x);
	pmtfil1(pmtfn);
	pmtmod1(pmtln);
	/* restore cursor */
	outxy(x,y);
}

/* write new mode message on prompt line */

pmtmode(s) char *s;
{
int x,y;		/* save cursor on entry */
	/* save cursor */
	x=outgetx();
	y=outgety();
	/* redraw whole line */
	outxy(0,0);
	outdelln();
	pmtlin1();
	pmtcol1(x);
	pmtfil1(pmtfn);
	pmtmod1(s);
	/* restore cursor */
	outxy(x,y);
}

/* update file name on prompt line */

pmtfile(s) char *s;
{
int x, y;
	/* save cursor */
	x=outgetx();
	y=outgety();
	/* update whole line */
	outxy(0,0);
	outdelln();
	pmtlin1();
	pmtcol1();
	pmtfil1(s);
	pmtmod1(pmtln);
	/* restore cursor */
	outxy(x,y);
}

/* change mode on prompt line to edit: */

pmtedit()
{
	pmtmode("edit:");
}

/* update line and column numbers on prompt line */

pmtline()
{
int x,y;
	/* save cursor */
	x=outgetx();
	y=outgety();
	/* redraw whole line */
	outxy(0,0);
	outdelln();
	pmtlin1();
	pmtcol1(x);
	pmtfil1(pmtfn);
	pmtmod1(pmtln);
	/* restore cursor */
	outxy(x,y);
}

/* update just the column number on prompt line */

pmtcol()
{
int x,y;
	/* save cursor */
	x=outgetx();
	y=outgety();
	/* update column number */
	pmtcol1(x);
	/* update cursor */
	outxy(x,y);
}

/* update mode.  call getcmnd() to write on prompt line */

pmtcmnd(mode,buffer) char *mode, *buffer;
{
int x,y;
	/* save cursor */
	x=outgetx();
	y=outgety();
	pmtmod1(mode);
	/* user types command on prompt line */
	getcmnd(buffer,outgetx());
	/* restore cursor */
}

/* update and print mode */

pmtmod1(s) char *s;
{
int i;
	outxy(40,0);
	fmtsout(s,40);
	i=0;
	while (pmtln[i++]= *s++) {
		;
	}
}

/* print the file name on the prompt line */

pmtfil1(s) char *s;
{
int i;
	outxy(25,0);
	if (*s==EOS) {
		fmtsout("no file",25);
	}
	else {
		fmtsout(s,25);
	}
	i=0;
	while (pmtfn[i++]= *s++) {
		;
	}
}

/* print the line number on the prompt line */

pmtlin1()
{
	outxy(0,0);
	fmtsout("line: ",0);
	putdec(bufln(),5);
}


/* print column number of the cursor */

pmtcol1(x) int x;
{
	outxy(12,0);
	fmtsout("column: ",12);
	putdec(x,3);
}











/* Screen editor:  operating system module
 *		   C/80 version
 *
 * Source:  ed8.c
 * Version: June 19, 1981.
 */

/* define globals */

/* #include ed1.h */


/* all calls to the operating system are made here.
 * only this module will have to be
 * rewritten for a new operating system.
 */

/* CP/M 2.2 versions of syscstat(), syscin(), syscout() */

/* return -1 if no character is ready from the console. 
 * otherwise, return the character.
 */

syscstat()
{
	return(bdos(6,-1));
}

/* wait for next character from the console.
 * do not echo it.
 */

syscin()
{
int c;
	while ((c=bdos(6,-1))==0) {
		;
	}
	return(c);
}

/* print character on the console */

syscout(c) char c;
{
	bdos(6,c);
	return(c);
}


/* print character on the printer */

syslout(c) char c;
{
	bdos(5,c);
	return(c);
}

/* open a file */

sysopen(name,mode) char *name, *mode;
{
int file;
int m;
	m=tolower(mode[0]);
	if (m=='r' | m=='w') {
		if ((file=fopen(name,mode))==0) {
			iormode='c';
			return(ERR);
		}
		else {
			iormode=m;
			return(file);
		}
	}
	else {
		iormode='c';
		syserr("fopen: bad mode");
		return(ERR);
	}
}

/* close a file */

sysclose(file) int file;
{
	if (iormode=='w') {
		/* write end of file byte */
		putc(26,file);
	}
	iormode='c';
	fclose(file);
	return(OK);
}

/* read next char from file */

sysrdch(file) int file;
{
int c;
	if (iormode!='r') {
		error ("sysrdch:  read in w mode");
		return(ERR);
	}
	if ((c=getc(file))==-1) {
		return(EOF);
	}
	else if (c==26) {
		return(EOF);
	}
	else if (c=='\n') {
		return (CR);
	}
	else {
		return(c);
	}
}

/* write next char to file */

syspshch(c,file) char c; int file;
{
char ch;
	if (iormode!='w') {
		error("syspshch:  write in r mode");
		return(ERR);
	}
	if (c==CR) {
		ch='\n';
	}
	else {
		ch=c;
	}
	if (putc(ch,file)==-1) {
		error("disk write failed");
		return(ERR);
	}
	else {
		return(c);
	}
}

/* read one char from END of file */

syspopch(file) int file;
{
	error("syspopch() not implemented");
	return(ERR);
}

/* check file name for syntax */

syschkfn(args) char *args;
{
	return(OK);
}

/* copy file name from args to buffer */

syscopfn(args,buffer) char *args, *buffer;
{
int n;
	n=0;
	while (n<(SYSFNMAX-1)) {
		if (args[n]==EOS) {
			break;
		}
		else {
			buffer[n]=args[n];
			n++;
		}
	}
	buffer[n]=EOS;
}

/* move a block of n bytes down (towards HIGH addresses).
 * block starts at source and the first byte goes to dest.
 *	src:[<--n-->]   dest:[       ]
 */

sysmovdn(n,dest,source) int n; char *dest, *source;
{
	if (n>0) {
#asm
	DB 0DDH,0E1H	;POP IX = return address in IX
	POP H		;source in HL
	POP D		;dest in DE
	POP B		;count in BC
	PUSH B		;restore args
	PUSH D
	PUSH H
	DB 0DDH,0E5H	;PUSH IX
	XCHG
	DAD B
	XCHG		;dest+count in DE
	DAD B		;source+count in HL
	INX B		;count+1 in BC
	DB 0EDH,0B8H	;LDDR
#endasm
	}
}

/* move a block of n bytes up (towards LOW addresses).
 * the block starts at source and the first byte goes to dest.
 *	dest:[       ]   src:[<--n-->]
 */

sysmovup(n,dest,source) int n; char *dest, *source;
{
	if (n>0) {
#asm
	DB 0DDH,0E1H	;POP IX = return address in IX
	POP H		;source in HL
	POP D		;dest in DE
	POP B		;count in BC
	PUSH B		;restore args
	PUSH D
	PUSH H
	DB 0DDH,0E5H	;PUSH IX
	DB 0EDH,0B0H	;LDIR
#endasm
	}
}

/*
Interfaces with operating system functions
*/

bdos(c,d) int c,d;
{
#asm
	POP H
	POP D
	POP B
	PUSH B
	PUSH D
	PUSH H
	CALL 5
#endasm
}










/* Screen editor:  general utilities
 *		   C/80 version
 *
 * Source:  ed9.c
 * Version: May 15, 1981.
 */

/* define global constants and variables */

/* #include ed1.h */

/* return: is first token in args a number ? */
/* return value of number in *val            */

number(args,val) char *args; int *val;
{
char c;
	c= *args++;
	if ((c<'0') | (c>'9')) {
		return(NO);
	}
	*val=c-'0';
	while (c= *args++) {
		if ((c<'0') | (c>'9')) {
			break;
		}
		*val=(*val*10)+c-'0';
	}
	return(YES);
}

/* convert character buffer to numeric */

ctoi(buf,index) char *buf; int index;
{
int k;
	while ( (buf[index]==' ') |
		(buf[index]==TAB) ) {
		index++;
	}
	k=0;
	while ((buf[index]>='0') & (buf[index]<='9')) {
		k=(k*10)+buf[index]-'0';
		index++;
	}
	return(k);
}


/* put decimal integer n in field width >= w.
 * left justify the number in the field.
 */

putdec(n,w) int n,w;
{
char chars[10];
int i,nd;
	nd=itoc(n,chars,10);
	i=0;
	while (i<nd) {
		syscout(chars[i++]);
	}
	i=nd;
	while (i++<w) {
		syscout(' ');
	}
}

/* convert integer n to character string in str */

itoc(n,str,size) int n; char *str; int size;
{
int absval;
int len;
int i,j,k;
	absval=abs(n);
	/* generate digits */
	str[0]=0;
	i=1;
	while (i<size) {
		str[i++]=(absval%10)+'0';
		absval=absval/10;
		if (absval==0) {
			break;
		}
	}
	/* generate sign */
	if ((i<size) & (n<0)) {
		str[i++]='-';
	}
	len=i-1;
	/* reverse sign, digits */
	i--;
	j=0;
	while (j<i) {
		k=str[i];
		str[i]=str[j];
		str[j]=k;
		i--;
		j++;
	}
	return(len);
}

/* system error routine */

syserr(s) char *s;
{
	pmtmess("system error: ",s);
}

/* user error routine */

error(s) char *s;
{
	pmtmess("error: ",s);
}

/* disk error routine */

diskerr(s) char *s;
{
	pmtmess("disk error: ",s);
}

/* read the next line of the file into
 * the buffer of size n that p points to.
 * Successive calls to readline() read the file
 * from front to back.
 */

readline(file,p,n) int file; char *p; int n;
{
int c;
int k;
	k=0;
	while (1) {
		c=sysrdch(file);
		if (c==ERR) {
			return(ERR);
		}
		if (c==EOF) {
			/* ignore line without CR */
			return (EOF);
		}
		if (c==CR) {
			return(k);
		}
		if (k<n) {
			/* move char to buffer */
			*p++=c;
		}
		/* always bump count */
		k++;
	}
}

/* push (same as write) line to end of file.
 * line is in the buffer of size n that p points to.
 * lines written by this routine may be read by
 * either readline() or popline().
 */

pushline(file,p,n) int file; char *p; int n;
{
	/* write all but trailing CR */
	while ((n--)>0) {
		if (syspshch(*p++,file)==ERR) {
			return(ERR);
		}
	}
	/* write trailing CR */
	return(syspshch(CR,file));
}

/* pop a line from the back of the file.
 * the line should have been pushed using pushline().
 */

popline(file,p,n) int file; char *p; int n;
{
int c;
int k, kmax, t;
	/* first char must be CR */
	c=syspopch(file);
	if (c==EOF) {
		/* at START of file */
		return(EOF);
	}
	if (c==CR) {
		/* put into buffer */
		*p++=CR;
		k=1;
	}
	else {
		syserr("popline: missing CR");
		return(ERR);
	}
	/* pop line into buffer in reverse order */
	while (1) {
		c=syspopch(file);
		if (c==ERR) {
			return(ERR);
		}
		if (c==EOF) {
			break;
		}
		if (c==CR) {
			/* this ends ANOTHER line */
			/* push it back           */
			if (syspshch(CR,file)==ERR) {
				return(ERR);
			}
			break;
		}
		/* non-special case */
		if (k<n) {
			/* put into buffer */
			*p++=c;
		}
		/* always bump count */
		k++;
	}
	/* remember if we truncated the line */
	kmax=k;
	/* reverse the buffer */
	k=min(k,n-1);
	t=0;
	while (k>t) {
		/* swap p[t], p[k] */
		c=p[k];
		p[k]=p[t];
		p[t]=c;
		k--;
		t++;
	}
	return(kmax);
}










/* Screen editor:  buffer module
 *                 C/80 version
 *
 * Source:  ed10.c
 * Version: May 15, 1981.
 */

/* define globals */

/* #include ed1.h */

/* globals used by this module -----

int bufcflag;		main buffer changed flag
char *bufp;		start of current line
char *bufpmax;		end of last line
char *buffer;		start of buffer
char *bufend;		last byte of buffer
int bufline;		current line number
int bufmaxln;		number of lines in buffer

----- */

/* This code is built around several invariant
 * assumptions:
 * First, the last line is always completely empty.
 * When bufp points to the last line there is NO
 * CR following it.
 * Second, bufp points to the last line if and only if
 * bufline==bufmaxln+1.
 * Third, bufline is always greater than zero.
 * Line zero exists only to make scanning for the
 * start of line one easier.
 */


/* Clear the main buffer */

bufnew()
{
int k;
	/* do initial allocation of memory */
	if (buffer==0) {
		k=60;
		while ((buffer=alloc(k*1024))==-1)
			k--;
		bufend=buffer+k*1024;
	}
	/* point past line 0 */
	bufp=bufpmax=buffer+1;
	/* at line one. no lines in buffer */
	bufline=1;
	bufmaxln=0;
	/* line zero is always a null line */
	buffer[0]=CR;
	/* indicate no need to save file yet */
	bufcflag=NO;
}

/* return current line number */

bufln()
{
	return(bufline);
}

/* return YES if the buffer (i.e., file) has been
 * changed since the last time the file was saved.
 */

bufchng()
{
	return(bufcflag);
}

/* the file has been saved.  clear bufcflag. */

bufsaved()
{
	bufcflag=NO;
}

/* return number of bytes left in the buffer */

buffree()
{
	return(bufend-bufp);
}

/* Position buffer pointers to start of indicated line */

bufgo(line) int line;
{
	/* put request into range. prevent extension */
	line=min(bufmaxln+1,line);
	line=max(1,line);
	/* already at proper line? return. */
	if (line==bufline) {
		return(OK);
	}
	/* move through buffer one line at a time */
	while (line<bufline) {
		if (bufup()==ERR) {
			return(ERR);
		}
	}
	while (line>bufline) {
		if (bufdn()==ERR) {
			return(ERR);
		}
	}
	/* we have reached the line we wanted */
	return(OK);
}

/* move one line closer to front of buffer, i.e.,
 * set buffer pointers to start of previous line.
 */

bufup()
{
char *oldbufp;
	oldbufp=bufp;
	/* can't move past line 1 */
	if (bufattop()) {
		return(OK);
	}
	/* move past CR of previous line */
	if (*--bufp!=CR) {
		syserr("bufup: missing CR");
		bufp=oldbufp;
		return(ERR);
	}
	/* move to start of previous line */
	while (*--bufp!=CR) {
		;
	}
	bufp++;
	/* make sure we haven't gone too far */
	if (bufp<(buffer+1)) {
		syserr("bufup: bufp underflow");
		bufp=oldbufp;
		return(ERR);
	}
	/* success!  we ARE at previous line */
	bufline--;
	return(OK);
}

/* Move one line closer to end of buffer, i.e.,
 * set buffer pointers to start of next line.
 */

bufdn()
{
char *oldbufp;
	oldbufp=bufp;
	/* do nothing silly if at end of buffer */
	if (bufatbot()) {
		return(OK);
	}
	/* scan past current line and CR */
	while (*bufp++!=CR) {
		;
	}
	/* make sure we haven't gone too far */
	if (bufp>bufpmax) {
		syserr("bufdn: bufp overflow");
		bufp=oldbufp;
		return(ERR);
	}
	/* success! we are at next line */
	bufline++;
	return(OK);
}

/* Insert a line before the current line.
 * p points to a line of length n to be inserted.
 * Note: n does not include trailing CR.
 */

bufins(p,n) char *p; int n;
{
int k;
	/* make room in the buffer for the line */
	if (bufext(n+1)==ERR) {
		return(ERR);
	}
	/* put the line and CR into the buffer */
	k=0;
	while (k<n) {
		*(bufp+k)= *(p+k);
		k++;
	}
	*(bufp+k)=CR;
	/* increase number of lines in buffer */
	bufmaxln++;
	/* special case: inserting a null line at
	 * end of file is not a significant change.
	 */
	if ((n==0) & (bufnrbot())) {
		;
	}
	else {
		bufcflag=YES;
	}
	return(OK);
}

/* delete the current line */

bufdel()
{
	return(bufdeln(1));
}

/* delete n lines, starting with the current line */

bufdeln(n) int n;
{
int oldline;
int k;
char *oldbufp;
	/* remember current buffer parameters */
	oldline=bufline;
	oldbufp=bufp;
	/* scan for first line after deleted lines */
	k=0;
	while ((n--)>0) {
		if (bufatbot()) {
			break;
		}
		if (bufdn()==ERR) {
			bufline=oldline;
			oldbufp=bufp;
			return(ERR);
		}
		k++;
	}
	/* compress buffer.  update pointers */
	bufmovup(bufp,bufpmax-1,bufp-oldbufp);
	bufpmax=bufpmax-(bufp-oldbufp);
	bufp=oldbufp;
	bufline=oldline;
	bufmaxln=bufmaxln-k;
	bufcflag=YES;
	return(OK);
}

/* replace current line with the line that
 * p points to.  The new line is of length n.
 */

bufrepl(p,n) char *p; int n;
{
int oldlen, k;
char *nextp;
	/* do not replace null line.  just insert */
	if (bufatbot()) {
		return(bufins(p,n));
	}
	/* point nextp at start of next line */
	if (bufdn()==ERR) {
		return(ERR);
	}
	nextp=bufp;
	if (bufup()==ERR) {
		return(ERR);
	}
	/* allow for CR at end */
	n=n+1;
	/* see how to move buffer below us;
	 * up, down, or not at all.
	 */
	oldlen=nextp-bufp;
	if (oldlen<n) {
		/* move buffer down */
		if (bufext(n-oldlen)==ERR) {
			return(ERR);
		}
		bufpmax=bufpmax+n-oldlen;
	}
	else if (oldlen>n) {
		/* move buffer up */
		bufmovup(nextp,bufpmax-1,oldlen-n);
		bufpmax=bufpmax-(oldlen-n);
	}
	/* put new line in the hole we just made */
	k=0;
	while (k<(n-1)) {
		bufp[k]=p[k];
		k++;
	}
	bufp[k]=CR;
	bufcflag=YES;
	return(OK);
}

/* copy current line into buffer that p points to.
 * the maximum size of that buffer is n.
 * return k=length of line in the main buffer.
 * if k>n then truncate n-k characters and only
 * return n characters in the caller's buffer.
 */

bufgetln(p,n) char *p; int n;
{
int k;
	/* last line is always null */
	if (bufatbot()) {
		return(0);
	}
	/* copy line as long as it not too long */
	k=0;
	while (k<n) {
		if (*(bufp+k)==CR) {
			return(k);
		}
		*(p+k)= *(bufp+k);
		k++;
	}
	/* count length but move no more chars */
	while (*(bufp+k)!=CR) {
		k++;
	}
	return(k);
}

/* move buffer down (towards HIGH addresses) */

bufmovdn(from,to,length) char *from, *to; int length;
{
	/* this code needs to be very fast.
	 * use an assembly language routine.
	 */

	sysmovdn(to-from+1,from+length,from);
}

/* the call to sysmovdn() is equivalent to the following code:

int k;
	k=to-from+1;
	while ((k--)>0) {
		*(to+length)= *to;
		to--;
	}

 */

/* move buffer up (towards LOW addresses) */

bufmovup(from,to,length) char *from, *to; int length;
{
	/* this code must be very fast.
	 * use an assembly language routine.
	 */

	sysmovup(to-from+1,from-length,from);
}

/* the call to sysmovup() is equivalent to the following code:

int k;
	k=to-from+1;
	while ((k--)>0) {
		*(from-length)= *from;
		from++;
	}

 */

/* return true if at bottom of buffer.
 * NOTE 1: the last line of the buffer is always null.
 * NOTE 2: the last line number is always bufmaxln+1.
 */

bufatbot()
{
	return(bufline>bufmaxln);
}

/* return true if at bottom or at the last
 * real line before the bottom.
 */

bufnrbot()
{
	return(bufline>=bufmaxln);
}

/* return true if at top of buffer */

bufattop()
{
	return(bufline==1);
}

/* put nlines lines from buffer starting with
 * line topline at position topy of the screen.
 */

bufout(topline,topy,nlines) int topline, topy, nlines;
{
int l,p;
	/* remember buffer's state */
	l=bufline;
	p=bufp;
	/* write out one line at a time */
	while ((nlines--)>0) {
		outxy(0,topy++);
		bufoutln(topline++);
	}
	/* restore buffer's state */
	bufline=l;
	bufp=p;
}

/* print line of main buffer on screen */

bufoutln(line) int line;
{
	/* error message does NOT go on prompt line */
	if (bufgo(line)==ERR) {
		fmtsout("disk error: line deleted",0);
		outdeol();
		return;
	}
	/* blank out lines below last line of buffer */
	if (bufatbot()) {
		outdeol();
	}
	/* write one formatted line out */
	else {
		fmtsout(bufp,0);
		outdeol();
	}
}

/* simple memory version of bufext.
 * create a hole in buffer at current line.
 * length is the size of the hole.
 */

bufext(length) int length;
{
	/* make sure there is room for more */
	if ((bufpmax+length)>=bufend) {
		error("main buffer is full");
		return(ERR);
	}
	/* move lines below current line down */
	bufmovdn(bufp,bufpmax-1,length);
	bufpmax=bufpmax+length;
	return(OK);
}








/*
This module contains library functions missing from C/80
*/

/* 
itoa(n,s) int n; char *s;
{
	char *p;

	p = s;
	if (n == 0) *p++ = '0';
	else {
 		if (n < 0) { *p++ = '-'; n = -n; }
		itoarec(n,fp);
	}
	*p = '\0';
}
*/

/* 
itoarec(n,p) int n; char **p;
{
	if (n) {
		itoarec(n/10,p);
		*(*p)++ = (n%10) + '0';
	}
}
*/

isupper(c) char c;
{
	return (c>='A' & c<='Z');
}

islower(c) char c;
{
	return (c>='a' & c<='z');
}

isalpha(c) char c;
{
	return (isupper(c) | islower(c));
}

isdigit(c) char c;
{
	return (c>='0' & c<='9');
}

isspace(c) char c;
{
	return (c=='\t' | c=='\n' | c==' ');
}

/*
toupper(c) char c;
{
	return (islower(c)? c&32 : c);
}
*/

/*
tolower(c) char c;
{
	return (isupper(c)? c|32 : c);
}
*/

/*
max(a,b) int a,b;
{
	return (a>b? a : b);
}

min(a,b) int a,b;
{
	return (a<b? a : b);
}


abs(i) int i;
{
	return (i<0? -i : i);
}
*/



strcpy(dest,source) char *dest,*source;
{
	while (*dest++ = *source++) {
		;
	}
}

strcat(dest,source) char *dest,*source;
{
	while (*dest++) {
		;
	}
	strcpy(--dest,source);
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

