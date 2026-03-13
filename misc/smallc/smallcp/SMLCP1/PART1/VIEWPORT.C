#include <stdio.h>


/*
 * viewport - set up viewport with given size
 */
viewport( toprow, leftcol, height, width )
int toprow, leftcol, height, width ;
{
	putchar( 27 ) ;
	putchar( 'X' ) ;
	putchar( 32+toprow ) ;
	putchar( 32+leftcol ) ;
	putchar( 32+height ) ;
	putchar( 32+width ) ;
}
