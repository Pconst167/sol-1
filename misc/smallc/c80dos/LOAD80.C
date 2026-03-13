/* 
Re: Need DOS runnable LASM 8080 assembler

Here is my load program.  Three warnings.
   1.  the fwrite that writes the binary image does
       funny things when compiled with my Borland C/C++.
       It works fine with Sun's C and GCC.
   2.  a cleaner hack would malloc the array that holds
       the binary image.  As it stands, the array size
       is "define"d.
   3.  I think (it's been a while) that this thing really
       uses the address field in the .HEX file to index
       into the binary image.  Watch where you set up
       your "ORG".
I told you it was a hack!!!!

    roger     hanscom@athens.dis.anl.gov
P.S. I hope it transmitted cleanly!

 */

#include <stdio.h>
#include <string.h>
#include <ctype.h>

#define IMSIZE 30000  /* was 32768 (RDK) */
/* #define IMSIZE 8192   */
/* #define IMSIZE 5216   */

/***************************************************
 *						   *
 *   convert a hex char to an integer		   *
 *						   *
 *     pass in the character to convert		   *	
 *						   *
 *     return 0...15 or -1 if char != hex digit    *
 *						   *
 ***************************************************/
unsigned int hextoi ( unsigned char digit )
{
   if ( ! isxdigit(digit) )  return (-1) ;

   switch ( toupper(digit) )
     {
	 case 'A'  :  return(0xA) ;
	 case 'B'  :  return(0xB) ;
	 case 'C'  :  return(0xC) ;
	 case 'D'  :  return(0xD) ;
	 case 'E'  :  return(0xE) ;
	 case 'F'  :  return(0xF) ;
	 default   :  return( digit - 0x30 ) ;
     }
}
/***************************************************
 *						   *
 *   convert an Intel hex. file to a load image	   *
 *						   *
 ***************************************************/
main (int argc, char *argv[])
{
   char line[120] ;
   unsigned char limage[IMSIZE] ;
   int i, addr, count, sum, csum, databyt ;
   FILE *infile, *outfile ;

   if ( argc != 3 ) {
      printf ("\nUsage: load <infile> <outfile>\n") ;
      printf ("         where infile is a valid Intel hex. file\n") ;
      printf ("           and outfile is the load image\n\n") ;
      exit (3) ;
   }

   if ( ( infile = fopen(argv[1], "r") ) == NULL )  {
      printf (" Unable to open input file.\n") ;
      exit (8) ;
   }

   if ( ( outfile = fopen(argv[2], "w") ) == NULL )  {
      printf (" Unable to open output file.\n") ;
      exit (8) ;
   }

   for ( i=0; i<IMSIZE; i++ )  limage[i] = 0 ;

   while (fscanf(infile,"%s",&line) != EOF )  {

     if ( line[0] != ':' ) {
       printf("  invalid record\n") ;
       exit (8) ;
     }

     sum = 0 ;
     count = hextoi(line[1])*0x10 + hextoi(line[2]) ;
     sum += count ;
     databyt = hextoi(line[3])*0x10 + hextoi(line[4]) ;
     sum += databyt ;
     addr = databyt * 0x100 ;
     databyt = hextoi(line[5])*0x10 + hextoi(line[6]) ;
     sum += databyt ;
     addr += databyt ;
     databyt = hextoi(line[7])*0x10 + hextoi(line[8]) ;
     sum += databyt ;

     csum = hextoi(line[9+(count*2)])*0x10 + hextoi(line[10+(count*2)]) ;

     for ( i=0; i<count; i++ ) {
	databyt = hextoi(line[9+(2*i)])*0x10 + hextoi(line[10+(2*i)]) ;
	sum += databyt ;
	limage[addr+i] = databyt ;
     }

     if ( ( ( sum + csum ) % 256 ) != 0 ) {
	printf("  checksum error. %d %d \n",sum,csum) ;
     }
   }

   fwrite(limage,1,IMSIZE,outfile) ;

   fclose (infile) ;
   fclose (outfile) ;

   exit(0) ;

}


