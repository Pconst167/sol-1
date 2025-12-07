#include <stdio.h>
#include <math.h>
#include "float.h"

sinh(x)
double x;
{
	double e;

	e = exp(x) ;
	return 0.5*(e-1.0/e) ;
}

cosh(x)
double x;
{
	double e;

	e = exp(x) ;
	return 0.5*(e+1.0/e) ;
}

tanh(x)
double x;
{
	double e;

	e = exp(x) ;
	return (e-1.0/e)/(e+1.0/e) ;
}
