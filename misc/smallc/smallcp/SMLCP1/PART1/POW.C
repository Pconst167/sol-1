#include <stdio.h>
#include <math.h>
#include "float.h"

/*
 *	transcendental functions: pow
 */

pow(x,y)	/* x to the power y */
double x,y;
{
	return exp(log(x)*y);
}
