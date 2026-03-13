/*
 * zlib - create library from all .obj files on current disk
 *
 * library consists of concatenation of all .obj files
 * (except iolib.obj, which is not included)
 * an index file to each module within the library is also created
 *
 * the index file starts with a list of all modules in the library
 * together with the record number and offset of their starts
 * (that is, the first record after the module name)
 * this is follwed by a blank line
 * next there is a list of symbols in the given module, each of
 * which is followed by the number of the relevant module
 * the number is positive for symbols defined in the module and
 * negative for symbols referenced but not defined
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


char *Index ;	/* table of undefined symbol (each up to 16 bytes) */
int Undef ;		/* number of entries in undefined symbol table */

main(argc, argv)
int argc, *argv ;
{
	int infile ;		/* input file descriptor */
	int libfile ;		/* library file file descriptor */
	int idxfile ;		/* index file file descriptor */
	char record[257];	/* data record from .OBJ file */
	int n ;				/* number of bytes in record */
	char **files ;		/* pointer to input file names */
	int rec ;			/* current record being written */
	int offset ;		/* offset into record */
	int i, j ;

	if ( argc != 2 ) {
		fprintf(stderr, "usage: zlib libname");
		exit() ;
	}

	if ( strchr(argv[1], '.') != 0 ) {
		fprintf(stderr, "library name should not include extension\n") ;
		exit() ;
	}

	/* open library file */
	strcpy(record, argv[1]) ;
	strcat(record, ".LIB") ;
	if ( (libfile=fopen(record,"w")) == 0 ) {
		fprintf(stderr, "unable to open library file");
		exit();
	}

	/* open index file */
	strcpy(record, argv[1]) ;
	strcat(record, ".IDX") ;
	if ( (idxfile=fopen(record,"w")) == 0 ) {
		fprintf(stderr, "unable to open index file") ;
		exit() ;
	}

	/* find .obj files */
	if ( (files=wildcard("????????.OBJ")) == 0 ) {
		fprintf(stderr, "no .OBJ files");
		exit();
	}

	/* process each file in list */
	rec = offset = 0 ;
	j = 0 ;
	while ( files[j] ) {
		/* do not include iolib.obj */
		if ( strcmp(files[j], "IOLIB.OBJ") == 0 ) {
			++j ;
			continue ;
		}
		/* try to open file */
		if ( (infile=fopen(files[j],"r")) == 0 ) {
			fprintf(stderr, "cannot open file: %s", files[j]) ;
			exit();
		}

		while ( (n=getrec(record,infile)) ) {
			/* process each data record */
			if ( record[0] == 1 && n == 2 ) {
				/* ignore null module names */
				continue ;
			}
			/* write data record to library */
			putb(n+1,libfile);
			for ( i=0; i<n; ++i ) {
				putb(record[i],libfile);
			}
			offset += n+1 ;
			rec += offset/128 ;
			offset %= 128 ;
			if ( record[0] == 1 ) {
				/* name of module is not null, write it to index file */
				for ( i=2; i<n; ++i ) {
					putc(record[i], idxfile) ;
				}
				putc(' ', idxfile) ;
				/* write record/offset of given module */
				fprintf(idxfile, "%4d %3d\n", rec, offset) ;
			}
		}

		fclose(infile);
		++j ;
	}

	/* write end of module record */
	putb(2,libfile);
	putb(0,libfile);

	/* write end of index marker */
	fprintf(idxfile, "\n") ;

	fclose(libfile);

	/* now create index of functions within each module */

	/* open library file for read */
	strcpy(record, argv[1]) ;
	strcat(record, ".LIB") ;
	if ( (libfile=fopen(record,"r")) == 0 ) {
		fprintf(stderr, "unable to open file\n");
		exit();
	}

	/* allocate space for index of undefined symbols */
	Index = alloc(4800) ;
	/* process each module in library */

	i = -1 ;
	Undef = 0 ;
	while ( (n=getrec(record,libfile)) ) {
		if ( record[0] == 1 ) {
			/* new module, increase module number, clear Undef table */
			++i ;
			Undef = 0 ;
		}
		if ( record[0] == 4 ) {
			/* only deal with symbol records */
			if ( (record[1] & 6) == 6 ) {
				/* global symbol defined here */
				record[n] = 0 ;
				fprintf(idxfile, "%s %d\n", &record[4], i+1) ;
			}
			else if ( (record[1] & 6) == 4 ) {
				record[n] = 0 ;
				/* global symbol not defined here */
				if ( !already(&record[4]) ) {
					/* only add to file if not there already */
					fprintf(idxfile, "%s %d\n", &record[4], -(i+1) ) ;
					/* add to table too */
					strcpy(&Index[Undef<<4],&record[4]) ;
					if ( ++Undef > 300 ) {
						fprintf(stderr,"symbol table overflow");
						exit() ;
					}
				}
			}
		}
	}
	fclose(libfile) ;
	fclose(idxfile);
}

/*
 * fetch record from file
 * return number of valid bytes, 0 for end of module
 */
getrec(ptr,fd)
char *ptr ;
int fd ;
{
	int i ;				/* count number of bytes from file */
	int j ;				/* number of bytes returned in record */

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

/*
 * already -  check if symbol is already in undefined symbol table for this module
 */
already(s)
char *s ;
{
	int i ;

	i = 0 ;
	while ( i < Undef ) {
		if ( strcmp(s,&Index[i<<4]) == 0 ) {
			/* symbol is in table */
			return 1 ;
		}
		++i ;
	}
	/* symbol not found */
	return 0 ;
}
