/*
 * wildcard - return pointer to pointers to filenames of 
 *            all files matching wildcard specification
 *            last pointer is followed by (char *)0
 *            if no files are found to match spec, return (int *)0
 *            Note that in Small-C we can't have a function returning a
 *            pointer to a pointer to a char, so we just return an int
 *
 * NB file spec must be in form FFFFFFFF.EEE
 */

#include <stdio.h>

#define MAXFILES 64

char _dma[128] ;			/* dma buffer */
char **_file ;				/* pointers to file names */


wildcard(spec)
char *spec ;
{
	char fcb[36] ;
	char ch ;
	int code ;
	int i ;

	/* copy filename into fcb */
	i = 1 ;
	while( ch = *spec++ ) {
		if ( ch != '.' ) {
			fcb[i++] = ch ;
		}
	}
	fcb[0] = 0 ;
	fcb[12] = 0 ;

	/* set dma address */
	cpm(26, _dma);
		
	i = 0 ;
	/* look for first matching file */
	if ( (code=cpm(17, fcb)) == -1 ) {
		/* error on first search, return 0 */
		return 0 ;
	}

	/* allocate space for char pointers */
	_file = alloc(MAXFILES*2) ;

	_store(code,&i);

	while ( (code=cpm(18,fcb)) != -1 && i < MAXFILES-1 ) {
		_store(code,&i);
	}

	cpm(26,128) ;			/* reset dma address */
	_file[i] = 0 ;			/* mark end of files */
	return _file ;
}

/*
 * store file name from offset in dma buffer to static area
 * and place pointer in array of filename pointers
 */
_store(offset, num)
int offset ;
int *num ;			/* next empty location in file pointer array */
{
	char *name ;
	char *ptr ;
	int i ;

	/* find start of name in buffer */
	name = _dma + (offset << 5) + 1 ;
	/* make space for name */
	ptr = alloc(13);
	_file[*num] = ptr ;
	*num += 1 ;
	/* copy from buffer to static area */
	for ( i=0; i<12; ++i) {
		if ( i != 8 ) {
			if ( *name != ' ' )
				*ptr++ = *name++ & 0x7f ;
			else
				++name ;
		}
		else
			*ptr++ = '.' ;
	}
	*ptr = 0 ;
}
