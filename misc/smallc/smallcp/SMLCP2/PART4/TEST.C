/*
 *	 I/O demonstration program
 *
 *   This is not a very interesting program, but it was included
 *   with SIG/M 224, so I've carried on the tradition.       RMY
 */

#include <stdio.h>
#include <math.h>
#include "float.h"

int infile, outfile ;
char buf[80], chr ;
int a, b, c, *d, line ;
double e, f ;

main(argc, argv)
int argc ;
char **argv  ;
{
	printf("hello, world\n") ;		/* of course */

	printf(" u: %u \n",-1) ;		/* u: 65535  */
	printf(" x: %x \n",-1) ;		/* x: ffff  */
	printf(" s: %s \n","hello") ;	/* s: hello  */
	printf(" c: %c \n",65) ;		/* c: A  */

	/* string I/O */
	puts("type a string: ") ; gets(buf) ; puts(buf) ;

	/* character I/O */
	puts("\ntype a character:") ; chr = getchar() ;
	puts("  The character was ") ; putchar(chr) ; putchar('\n') ;

	alpha() ;

	printf("The Fibbonacci sequence...%d, %d, %d, %d\n", 1,1,2,3) ;
	printf("the square root of 2 is %15.12f\n",sqrt(2.)) ;
	printf("more numbers: c=%12.3e, mp/me=%9.3e, hbar=%e\n",
										2.9979e8, 1836.11811, 1.054e-27) ;
	printf("-14=%e, -.0014=%e, 14=%e, .0014=%e\n", -14., -.0014, 14., .0014) ;
	line = 0 ;
	&line ;
	outf(1.) ;
	outf(1.1) ;
	outf(1.01) ;
	outf(1.001) ;
	outf(1.0001) ;
	outf(1.00001) ;
	outf(1.000001) ;
	outf(1.0000001) ;
	outf(1.00000001) ;
	outf(1.000000001) ;
	outf(1.0000000001) ;
	outf(1.00000000001) ;
	outf(1.000000000001) ;
	outf(1.0000000000001) ;
	b=17 ;
	c=6 ;
	d=&b ;
	e=2. ;
	f=3. ;
	a=b ;		out(a) ;
	a=e ;		out(a) ;
	a=b|c ;		out(a) ;
	a=b^c ;		out(a) ;
	a=b&c ;		out(a) ;
	putchar('\n') ;
	a=b==c ;		out(a) ;
	a=b==e ;		out(a) ;
	a=e==b ;		out(a) ;
	a=e==f ;		out(a) ;
	a=b!=c ;		out(a) ;
	putchar('\n') ;
	a=b<c ;		out(a) ;
	a=b<=c ;		out(a) ;
	a=b>=c ;		out(a) ;
	a=b>c ;		out(a) ;
	a=b<<c ;		out(a) ;
	putchar('\n') ;
	a=b>>c ;		out(a) ;
	a=b+c ;		out(a) ;
	a=b+e ;		out(a) ;
	a=e+b ;		out(a) ;
	a=e+f ;		out(a) ;
	putchar('\n') ;
	a = b - c ;
	a=b-c ;		out(a) ;
	a=b*c ;		out(a) ;
	a=b*e ;		out(a) ;
	a=e*b ;		out(a) ;
	a=e*f ;		out(a) ;
	putchar('\n') ;
	a=b/c ;		out(a) ;
	a=b%c ;		out(a) ;
	a=b++ ;		out(a) ;
	a= ++b ;		out(a) ;
	a= b-- ;		out(a) ;
	putchar('\n') ;
	a= --b ;		out(a) ;
	a= *d ;		out(a) ;
	a= &b ;		out(a) ;
	e=a ;		out(ifix(e)) ;
	a=d[1] ;		out(a) ;
	putchar('\n') ;

	/* get file names from command line */
	if ( argc < 2 ) exit() ;
	infile = fopen(argv[1], "r") ;
	if ( argc < 3) exit() ;
	outfile=fopen(argv[2],"w") ;

	/* copy first file to second */
	while((c=getc(infile))!=-1)putc(c,outfile) ;
	fclose(outfile) ;
}
 
out(a)
int a ;
{
	printf("\t%d: %d",line++,a) ;
}

alpha()
{
	1 ;
	puts("\nentering alpha") ;
	beta() ;
	gamma() ;
	gamma() ;
	puts("\nalpha signing off") ;
}

beta()
{
	2 ;
	puts("\nentering beta") ;
	gamma() ;
	puts("\nbeta signing off") ;
}

gamma()
{
	3 ;
	puts("\nentering gamma") ;
	err("just testing") ;
	puts("\ngamma signing off") ;
}

putnum(x)
int x ;
{
	if ( x < 0 ) {
		x=-x ;
		putchar('-') ;
	}
	if ( x > 9 )
		putnum(x/10) ;
	putchar('0'+x%10) ;
}

outf(x)
double x ;
{
	printf(" %16.13f \n",x) ;
}
