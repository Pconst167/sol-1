#include <stdio.h>

/*
 * line - draw line from (x1,y1) to (x2,y2)
 *        uses Bresenham line algorithm, as told in BYTE Nov 85, p229
 */
line( x1, y1, x2, y2, action )
int x1, y1, x2, y2, action ;
{
	int x, y, a, b, d, deltap, deltaq ;
	int dx, dy ;

	dx = x2 - x1 ;
	if (dx < 0) dx = -dx ;
	dy = y2 - y1 ;
	if (dy < 0) dy = -dy ;

	y = y1 ;		/* initialise y */
	x = x1 ;		/* initialise x */

	if (dy <= dx) {		/* slope <= 1 */
		/* now set x increment */
		if (x1 <= x2) a = 1 ;
		else a = -1 ;
		/* now set y increment */
		if (y1 <= y2) b = 1 ;
		else b = -1 ;
		/* initialise decision function and its deltas */
		deltap = dy << 1 ;
		d = deltap - dx ;
		deltaq = d - dx ;
		/* locate and plot points */
		plot( x, y, action ) ;		/* first point */
		while (x != x2) {
			x += a ;
			if (d < 0) d += deltap ;
			else {
				y += b ;
				d += deltaq ;
			}
			plot( x, y, action ) ;
		}
	}
	else { /* dx < dy, so view x as a function of y */
		/* now set y increment */
		if (y1 <= y2) a = 1 ;
		else a = -1 ;
		/* now set x increment */
		if (x1 <= x2) b = 1 ;
		else b = -1 ;
		/* initialise decision function and its deltas */
		deltap = dx << 1 ;
		d = deltap - dy ;
		deltaq = d - dy ;
		/* locate and plot points */
		plot( x, y, action ) ;		/* first point */
		while (y != y2) {
			y += a ;
			if (d < 0) d += deltap ;
			else {
				x += b ;
				d += deltaq ;
			}
			plot( x, y, action ) ;
		}
	}
}
