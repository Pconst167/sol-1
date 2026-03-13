#include <stdio.h>

/*
 * cursor - position cursor at given row, column
 *          0 <= row <= 30
 *          0 <= column <= 89
 */
cursor(row, column)
int row, column ;
{
	putchar( 27 ) ;
	putchar( 'Y' ) ;
	putchar( 32+row ) ;
	putchar( 32+column ) ;
}
