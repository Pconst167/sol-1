#include <stdio.h>

/*
 * box - draw box
 */
box(x1, y1, x2, y2, action)
int x1, y1, x2, y2, action ;
{
	line( x1, y1, x2, y1, action ) ;
	line( x2, y1, x2, y2, action ) ;
	line( x2, y2, x1, y2, action ) ;
	line( x1, y2, x1, y1, action ) ;
}
