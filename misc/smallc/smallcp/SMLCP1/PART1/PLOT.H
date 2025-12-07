/*
 * plot.h - header file for plot routines
 */


/* action constants for plot */

#define SET		0
#define RESET	1
#define TOGGLE	2
#define GETBIT	3
#define GETBYTE	4

/* function declarations */

extern int	plot(),
    		cursor(),
    		viewport(),
    		line(),
    		box() ;
