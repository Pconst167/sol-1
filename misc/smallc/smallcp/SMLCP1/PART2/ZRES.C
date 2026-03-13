/*
 * zresolve - link preprocessor to resolve library references
 *            this version uses modified zlink to allow loading
 *            of multiple modules from one file
 *
 * Three tables used in this program:
 *
 *  the symbol table holds all symbols used in the program to be linked,
 *  both defined and undefined.  The aim is to define all these symbols.
 *
 *  the library table contains all the symbols defined in the library (as
 *  listed in the index file) together with a pointer to the module in which
 *  they are defined.
 *
 *  the index file contains, for each module, a list of all the symbols
 *  defined and required.  This list is used to update the symbol table
 *  when a library module is loaded.
 *
 * Bug reports, bug fixes and comments should be addressed to the author:
 *
 *    R M Yorston
 *    1 Church Terrace
 *    Lower Field Road
 *    Reading
 *    RG1 6AS
 *
 */

#include <stdio.h>
#include <string.h>

/* symbol type flags */
#define DEFINED 0
#define UNDEFINED 1

#define FALSE 0
#define TRUE 1

#define CR 13
#define NULL 0

/* symbol table format */
#define NAME		0
#define TYPE		17
#define SYMREC		18

/* symbol table parameters */
#define NUMENT		700
#define STARTTAB	Symtab
#define ENDTAB		(STARTTAB + ((NUMENT-1)*SYMREC))
#define SYMSIZE		(NUMENT*SYMREC)

/* library table format */
#define LIBNAME		0
#define MODULE		17
#define LIBREC		18

/* library table parameters */
#define LIBENT		500
#define STARTLIB	Libtab
#define ENDLIB		(STARTLIB + ((LIBENT-1)*LIBREC))
#define LIBSIZE		(LIBENT*LIBREC)

/* index table format */
#define IXNAME		0
#define IXTYPE		17
#define IXREC		18

/* index table parameters */
#define IXENT		600
#define IXSIZE		(IXENT*IXREC)

/* maximum size of symbol */
#define NAMEMAX 16

char *Symtab ;			/* pointer to start of symbol table */
char *Libtab ;			/* pointer to start of library table */
char *Index ;			/* pointer to start of index table */
int  *Module ;			/* array of pointers to module names */
int  *Objptr ;			/* array of pointers to index chains */
int  *Rec ;				/* array of starting records for each module */
int  *Off ;				/* array of offsets into records */
int  Nmod ;				/* number of modules in library */

int Ixused ;			/* number of entries used in index table */
int Libused ;			/* number of entries used in library table */
int Symused ;			/* number of entries used in symbol table */

int Plotflag ;			/* TRUE if a plotting function has been loaded */
int Printflag ;			/* TRUE if _printf has to be loaded */
int Scanflag ;			/* TRUE if _scanf has to be loaded */
int Floatflag ;			/* TRUE if a floating point function has been loaded */
int Ploadflag ;			/* TRUE if printf2 has been loaded */
int Sloadflag ;			/* TRUE if scanf2 has been loaded */

int Libfile ;			/* file descriptor for library */
int Subfile ;			/* file descriptor for submit file */
int Objfile ;			/* file descriptor for .OBJ file */

char Command[128];		/* array in which command is built */

main( argc, argv)
int argc ;
char **argv ;
{
	char temp[40] ;
	int i ;

	/* allocate space for symbol tables and fill them with zeroes */
	Symtab = zalloc(SYMSIZE) ;
	Libtab = zalloc(LIBSIZE) ;
	Index = zalloc(IXSIZE) ;

	/* check arguments */
	if ( argc < 4 ) {
		puts("usage: zres drive libname file1 ...");
		exit() ;
	}
	if ( strchr(argv[2], '.') != 0 ) {
		puts("library name should not have extension") ;
		exit() ;
	}

	/* open submit file */
	if ( (Subfile=fopen("CLIB.SUB", "w")) == 0 ) {
		fprintf(stderr, "Unable to open submit file\n") ;
		exit() ;
	}

	/* open object file for library modules */
	if ( (Objfile=fopen("CLIB.OBJ", "w")) == 0 ) {
		fprintf(stderr, "Unable to open CLIB.OBJ\n") ;
		exit() ;
	}

	/* start building command */
	fprintf(Subfile, "zlink %s=", argv[3]) ;

	/* load all input files on command line */
	i = 2 ;
	while ( ++i < argc ) {
		loadfile(argv[i]) ;
		fprintf(Subfile, "%s,", argv[i]) ;
	}
	/* always load IOLIB.OBJ */
	loadfile("iolib") ;
	fprintf(Subfile, "IOLIB,CLIB\n") ;

	/* fetch library index */
	strcpy(temp, argv[2]) ;
	strcat(temp, ".IDX") ;
	read_index(temp) ;

	/* open library */
	strcpy(temp, argv[2]) ;
	strcat(temp, ".LIB") ;
	if ( (Libfile=fopen(temp, "r")) == 0 ) {
		fprintf(stderr, "Unable to open library file\n") ;
		exit() ;
	}


	/* process all as yet undefined symbols */
	Plotflag = Printflag = Floatflag = Ploadflag = FALSE ;
	Scanflag = Sloadflag = FALSE ;
	/* loop until no more modules are loaded */
	while ( pass() )
		;

	/* load required printf file */
	if ( Printflag && !Ploadflag ) {
		if ( Floatflag )
			copy_module(find_module("PRINTF2")) ;
		else
			copy_module(find_module("PRINTF1")) ;
	}
	/* load required scanf file */
	if ( Scanflag && !Sloadflag ) {
		if ( Floatflag )
			copy_module(find_module("SCANF2")) ;
		else
			copy_module(find_module("SCANF1")) ;
	}

	/* tidy up any new unresolved symbols */
	while ( pass() )
		;

	/* erase temporary library file */
	fprintf(Subfile, "era clib.obj\n") ;

	if ( Plotflag ) {
		/* add plot RSX if required */
		fprintf(Subfile, "\ngencom %s plot\n", argv[3]) ;
	}
	/* copy .com file from M: and return to drive in 1st arg */
	fprintf(Subfile, "%s\npip %s.COM=m:\nera m:clib.sub\n", argv[1], argv[3]) ;

	/* close CLIB.OBJ */
	putb(2, Objfile) ;
	putb(0, Objfile) ;

	fclose(Objfile) ;
	fclose(Subfile) ;
	fclose(Libfile) ;

	/* print usage statistics */
	printf("\nSymbol table   %d/%d\n", Symused, NUMENT) ;
	printf("Library table  %d/%d\n", Libused, LIBENT) ;
	printf("Index table    %d/%d\n", Ixused, IXENT) ;
}

/*
 * pass - make one pass through symbols
 * return true if a module was loaded
 */
pass()
{
	int module_loaded ;
	char *cptr ;			/* pointer into symbol table */
	char *lptr ;			/* pointer into library table */
	char *mod ;				/* name of module being loaded */
	int i ;
		
	module_loaded = FALSE ;
	cptr = Symtab - SYMREC ;
	/* loop for all records in table */
	for ( i=0; i<NUMENT; ++i ) {
		cptr += SYMREC ;
		if ( cptr[NAME] != 0 && cptr[TYPE] == UNDEFINED ) {
			if ( strcmp(cptr+NAME, "Q_PRINTF") == 0 ) {
				/* want to load _printf, but can't yet */
				Printflag = TRUE ;
				cptr[TYPE] = DEFINED ;
				continue ;
			}
			if ( strcmp(cptr+NAME, "Q_SCANF") == 0 ) {
				/* want to load _scanf, but can't yet */
				Scanflag = TRUE ;
				cptr[TYPE] = DEFINED ;
				continue ;
			}
			/* undefined symbol found, look in library */
			lptr = search(cptr+NAME,STARTLIB,LIBREC,ENDLIB,LIBENT,LIBNAME) ;
			if ( lptr == 0 || lptr[LIBNAME] == 0 ) {
				/* symbol not found in library index */
				if ( strcmp(cptr+NAME, "_END") != 0 ) {
					/* don't tell user _END is undefined, it always is */
					printf("%s is unresolved\n", cptr+NAME) ;
				}
				cptr[TYPE] = DEFINED ;
			}
			else {
				/* resolve reference by loading file */
				copy_module(lptr[MODULE]) ;
				mod = Module[lptr[MODULE]] ;
				if ( strcmp(mod,"PLOT") == 0 )
					Plotflag = TRUE ;
				else if ( strcmp(mod,"FLOAT") == 0 )
					Floatflag = TRUE ;
				else if ( strcmp(mod,"PRINTF2") == 0 )
					Ploadflag = TRUE ;
				else if ( strcmp(mod,"SCANF2") == 0 )
					Sloadflag = TRUE ;
				module_loaded = TRUE ;
			}
		}
	}
	return module_loaded ;
}

/*
 * loadfile - load symbols in given object file into symbol table
 */
loadfile(name)
char *name ;
{
	char record[257];		/* record from object file */
	int infile ;			/* file descriptor for input file */
	int n ;					/* number of bytes in record */

	/* open input file */
	strcpy(record, name) ;
	strcat(record, ".OBJ") ;
	if ( (infile=fopen(record,"r")) == 0 ) {
		fprintf(stderr, "Unable to open input file: %s\n", record) ;
		exit();
	}

	/* examine all records in file */
	while ( (n=getrec(record,infile)) ) {
		if ( record[0] == 4 ) {
			/* symbol record */
			record[n] = 0 ;
			if ( (record[1] & 6) == 6 ) {
				/* global symbol defined in this file */
				addsym(&record[4],DEFINED);
			}
			else if ( !(record[1] & 2) ) {
				/* symbol is external */
				addsym(&record[4],UNDEFINED);
			}
		}
	}

	fclose(infile);
}

/*
 * read index file and set up library table and index table
 */
read_index(name)
char *name ;		/* name of index file */
{
	int infile ;			/* input file descriptor */
	char temp[80];			/* temporary string to hold input */
	int last ;				/* number of last module */
	char *nxtptr ;			/* pointer to next empty location in index */
	int n, i ;

	/* read library index */
	if ( (infile=fopen(name, "r")) == 0 ) {
		puts("cannot open index file");
		exit();
	}

	/* find number of modules */
	n = 0 ;
	while ( getline(infile, temp) && strlen(temp) != 0 ) {
		++n ;
	}
	Nmod = n ;

	/* rewind file */
	xseek(infile, 0, 0) ;

	/* read module names */
	Module = zalloc( sizeof(int)*n ) ;
	Objptr = zalloc( sizeof(int)*n ) ;
	Rec = zalloc(sizeof(int)*n) ;
	Off = zalloc(sizeof(int)*n) ;

	for ( i=0; i<n; ++i ) {
		Module[i] = alloc(13) ;
		if (fscanf(infile, "%s %d %d", Module[i], &Rec[i], &Off[i]) != 3 ) {
			puts("index read error") ;
			exit() ;
		}
	}
	printf("bytes free: %u\n", avail() ) ;

	/* discard null line */
	getline(infile, temp) ;

	/* fetch index of functions and put them in table */
	nxtptr = Index - IXREC ;
	last = 0 ;
	while ( fscanf(infile, "%s %d", temp, &n) == 2 ) {
		if ( abs(n) != last ) {
			/* new module coming in now */
			last = abs(n) ;
			/* leave null entry to mark end of previous chain */
			nxtptr += IXREC ;
			++Ixused ;
			Objptr[last-1] = nxtptr ;
		}
		/* add symbol to index */
		strcpy(nxtptr+IXNAME, temp) ;
		if ( n > 0 ) {
			nxtptr[IXTYPE] = DEFINED ;
			/* add defined symbol to library table */
			addlib(temp, (n-1)) ;
		}
		else
			nxtptr[IXTYPE] = UNDEFINED ;
		nxtptr += IXREC ;
		++Ixused ;
		if ( Ixused > IXENT-1 ) {
			printf("index table full\n") ;
			exit() ;
		}
	}
	fclose(infile);
}

/*
 * resolve references to given module
 */
resolve(n)
int n ;			/* number of file in Objptr table */
{
	char *nxtptr ;		/* pointer to next symbol in chain */

	nxtptr = Objptr[n] ;
	/* read down index chain */
	while ( nxtptr[IXNAME] ) {
		addsym(&nxtptr[IXNAME], nxtptr[IXTYPE]) ;
		nxtptr += IXREC ;
	}
}

/*
 * fetch record from file
 * return number of valid bytes, 0 for end of module
 */
getrec(ptr,fd)
char *ptr ;
int fd ;
{
	int j ;				/* number of bytes returned in record */
	int i ;				/* count number of bytes from file */

	i = getb(fd) ;
	if ( i == 2 || i == -1 ) {
		return 0 ;
	}
	j = (--i) & 0xff ;
	while ( i-- ) {
		*ptr++ = getb(fd) ;
	}
	return j ;
}

addsym(str,type)
char *str ;
int type ;
{
	char *cptr ;

	cptr = search(str, STARTTAB, SYMREC, ENDTAB, NUMENT, NAME) ;
	if ( cptr == 0 ) {
		puts("symbol table full\n");
		exit();
	}
	if ( *cptr != 0 ) {
		/* symbol found */
		if ( type == DEFINED ) {
			/* definition found for symbol */
			cptr[TYPE] = DEFINED ;
		}
	}
	else {
		/* symbol not found, add it to table */
		strcpy(cptr+NAME, str);
		cptr[TYPE] = type ;
		++Symused ;
	}
}

addlib(str,modx)
char *str ;				/* symbol to put in table */
int modx ;				/* index of module where symbol is found */
{
	char *cptr ;

	cptr = search(str, STARTLIB, LIBREC, ENDLIB, LIBENT, LIBNAME) ;
	if ( cptr == 0 ) {
		puts("library symbol table full") ;
		exit() ;
	}
	/* add symbol to table (overwriting previous contents) */
	strcpy(cptr+LIBNAME, str) ;
	cptr[MODULE] = modx ;
	++Libused ;
}

/*
 * search for symbol match in table
 * returns pointer to slot found or empty slot
 * returns zero if table full
 */
search(sname, buf, len, end, max, off)
char *sname ;		/* symbol to search for */
char *buf ;			/* start of table */
int len ;			/* length of record */
char *end ;			/* end of table */
int max ;			/* number of entries in table */
int off ;			/* offset of symbol within record */
{
	char *cptr, *cptr2 ;

	cptr = cptr2 = buf + ( (hash(sname)%(max-1)) * len ) ;
	while ( *cptr != 0 ) {
		if ( strncmp(sname, cptr+off, NAMEMAX) == 0 ) {
			/* match, return pointer */
			return cptr ;
		}
		if ( (cptr+=len) >= end ) {
			/* past end of table */
			cptr = buf ;
		}
		if ( cptr == cptr2 ) {
			/* have gone full circle, table full */
			return 0 ;
		}
	}
	/* have found empty slot, return pointer to it */
	return cptr ;
}

/*
 * hash function for table search
 */
hash(sname)
char *sname ;
{
	int i, c ;

	i = 0 ;
	while ( (c=*sname++) ) i = (i << 2) + c ;
	return abs(i) ;
}

/*
 * zalloc - allocate memory and zero it
 *
 * zalloc(count)
 */
#asm
qzalloc: pop hl		;return address
	pop bc			;character count
	push bc
	push hl
	push bc			;character count as arg to alloc()
	call qalloc		;HL points to allocated memory
	pop bc			;count
	dec bc			;adjust count
	push hl			;save pointer to allocated memory
	ld (hl),0		;start zeroing block
	ld d,h			;DE points on byte after HL
	ld e,l
	inc de
	ldir			;zero block
	pop hl			;retrieve block pointer
	ret
#endasm

/*
 * find index of module name corresponding to given string
 */
find_module(string)
char *string ;
{
	int i ;

	for ( i=0; i<Nmod; ++i ) {
		if ( strcmp(Module[i], string) == 0 ) {
			return i ;
		}
	}
	return -1 ;
}

/*
 * copy_module - copy module from library to temporary .obj file
 */
copy_module(modx)
int modx ;			/* index of module to be copied */
{
	int j, i ;

	if ( modx == -1 )
		printf("Unable to find module\n") ;
	else {
		/* resolve references */
		resolve(modx) ;
		printf("Copying %s\n", Module[modx]) ;
		putb(3, Objfile) ;
		putb(1, Objfile) ;
		putb(0, Objfile) ;
		if ( xseek(Libfile, Rec[modx], Off[modx]) != 0 ) {
			fprintf(stderr, "seek failure\n") ;
			exit() ;
		}
		/* copy all records from library to clib.obj */
		while ( (i=getb(Libfile)) != 2 ) {
			/* loop while not end of module record */
			if ( i == -1 ) {
				/* break on end of file */
				break ;
			}
			if ( (j=getb(Libfile)) == 1 ) {
				/* break on start of next module */
				break ;
			}
			putb(i--, Objfile) ;
			putb(j, Objfile) ;
			while ( --i ) {
				putb(getb(Libfile), Objfile) ;
			}
		}
		putb(2, Objfile) ;
		putb(1, Objfile) ;
	}
}

/*
 * getline - fetch line from input channel
 *           puts line at pointer, returns FALSE on end of file
 *           returns TRUE for successful get
 */
getline( fd, pointer )
int fd ;
char *pointer ;
{
	int ch ;

	while ( (ch=getc(fd)) != EOF ) {
		if( ch == CR ) {
			*pointer = NULL ;
			return TRUE ;
		}
		else
			*pointer++ = ch ;
	}
	*pointer = NULL ;
	return FALSE ;
}

extern _fchk(), _ffcb[], _ffirst[], _flast[], _fnext[] ;

#define MREAD 22489

/*
 * seek to given record, and byte offset within record
 * only works for read, record is absolute from start of file
 * return -1 on error, 0 on success
 */
xseek(fd, rec, off)
int fd, rec, off ;
{
	int index, *rrn ;
	char *fcb ;

	index = fd - 5 ;
	if ( _fchk(index) != MREAD )
		return -1 ;
	fcb = _ffcb[index] ;
	rrn = &fcb[33] ;
	*rrn = rec ;
	cpm(26, _ffirst[index]) ;		/* set DMA */
	if ( cpm(33, fcb) ) {			/* perform random read */
		cpm(26, 128) ;
		return -1 ;
	}
	cpm(26, 128) ;					/* reset DMA */
	/* force refresh of buffer */
	_fnext[index] = _flast[index] ;
	/* move forward by offset */
	while ( off-- ) {
		getb(fd) ;
	}
	return 0 ;
}
