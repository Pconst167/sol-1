/*
 * map2sym - convert .MAP file (from ZMAC) into .SYM file
 *           for use with Z8E
 *
 *           R M Yorston August 1987
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

main(argc, argv)
int argc ;
char **argv ;
{
	char name[50], address[50], junk[50] ;
	int map, sym ;
	int i ;

	if ( argc != 2 ) {
		fprintf(stderr, "usage: map2sym file\n") ;
		exit() ;
	}

	strcpy(name, argv[1]) ;
	strcat(name, ".MAP") ;
	if ( (map=fopen(name,"r")) == 0 ) {
		fprintf(stderr, "map2sym: unable to open input file\n") ;
		exit() ;
	}

	strcpy(name, argv[1]) ;
	strcat(name, ".SYM") ;
	if ( (sym=fopen(name,"w")) == 0 ) {
		fprintf(stderr, "map2sym: unable to open output file\n") ;
		exit() ;
	}

	i = 0 ;
	while ( fscanf(map, "%s %s %s", name, address, junk) == 3 ) {
		fprintf(sym, "%s %s\t", address, name) ;
		if ( ++i == 4 ) {
			i = 0 ;
			fprintf(sym, "\n") ;
		}
	}
	fprintf(sym, "\n") ;

	fclose(map) ;
	fclose(sym) ;
}
