/*
 * get option letter from argument vector
 */

#include <stdio.h>
#include <string.h>

int optind = 1 ;		/* index into parent argv vector */
char *optarg ;			/* argument associated with option */

char *argind = "" ;		/* index into arg string */
char nullch  = 0 ;

/*
 * getopt - process command line arguments (like getopt(3))
 */
getopt(nargc, nargv, optstr)
int nargc ;
char **nargv ;
char *optstr ;		/* string of options to be checked */
{
	char *listind ;		/* index into option letter list */
	char optopt ;		/* character checked for validity */

	if ( *argind == 0 ) {		/* update index into args */
		if ( optind >= nargc ) return(-1) ;
		argind = nargv[optind] ;
		if ( *argind != '-' ) return(-1) ;
		if ( *++argind == 0 ) return(-1) ;
		if ( *argind == '-' ) {		/* found "--" */
			++optind ;
			return(-1) ;
		}
	}
	/* option letter OK? */
	optopt = *argind++ ;
	listind = strchr( optstr, optopt ) ;
	if ( optopt == ':' || listind == 0 ) {
		if ( *argind == 0 ) ++optind ;
		puts( "illegal option -- " ) ;
		putchar( optopt ) ;
		puts("\n");
		return('?');
	}
	if ( *++listind != ':' ) {	/* don't need argument */
		optarg = 0 ;
		if ( *argind == 0 ) ++optind ;
	}
	else {				/* need an argument */
		if ( *argind ) optarg = argind  ;	/* no white space */
		else if ( nargc <= ++optind ) {		/* no argument available */
			argind = &nullch ;
			puts( "option requires an argument -- " ) ;
			putchar( optopt ) ;
			puts("\n");
			return('?');
		}
		else optarg = nargv[optind]  ;		/* white space */
		argind = &nullch ;
		++optind ;
	}
	return(optopt) ;	/* return option letter */
}
