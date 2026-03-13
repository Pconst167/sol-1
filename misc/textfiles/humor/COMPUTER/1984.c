From: sources-request@mirror.tmc.com

Submitted by: amdahl!chongo (Landon Curt Noll)
Mod.sources: Volume 9, Issue 20
Archive-name: old.bad.code

[  There's been lots of bad code posted to the net in the past; time
   to get some of it into the archives. :-)  --r$  ]


International Obfuscated C Code Contest Winners for 1984, 1985, 1986
This is a shell archive.  Remove anything before this line, then unpack
it by saving it in a file and typing "sh file".

         SEE THE README FILE FOR DETAILS ABOUT THESE SOURCES

--------cut--------here---------
echo x - README
cat > "README" << '//E*O*F README//'

This shar file contains the winning entries of the International
Obfuscated C Code Contest for the years 1984 thru 1986.

Each contest starts near March 15.  The official start consists of the
posting of new contest rules in:

                    comp.lang.c    comp.unix.wizards    

For those people who do not read the above mentioned groups, a short note is 
also posted to mod.announce stating where the new rules have been posted.
Rules may also be obtained by sending Email to (after March 15th):

	judge@nce stating where the new rules have been posted.
Rules may also be obtained by sending Email to (after March 15th):

	judge@amdahl.com  -or-  {decwrl,sun,seismo,hplabs}!amdahl!judge

The winners below are given to serve as examples.  It should be noted
that contest rules change from year to year, so some the previous winning
entries would be disqualified under some rules.  Since some obfuscation
ideas get old (such as #define-ing something to death), some winning
might be eliminated in the first judging round of another year.  All this can
be summed up in the phrase: "read the new rules before you submit an entry".

NOTE:  You are free to distribute/use these programs as long they are not
       used for profit, and as long author's name stays attached to the
       source code.

Enjoy

chongo <Landon Curt Noll, chongo@amdahl.COM> /\cc/\

//E*O*F README//

echo x - 1984
cat > "1984" << '//E*O*F 1984//'
<dis>honorable mention:
------------------------------------------------------------------------------
int i;main(){for(;i["]<i;++i){--i;}"];read('-'-'-',i+++"hell\
o, world!\n",'/'/'/'));}read(j,i,p){write(j/p+p,i---j,i/i);}
-----------------------------------------------------------------------------
anonymous entry   (too embarrassed that he/she could write such trash i guess)



Third place:
---------------------------------------------------------------------------
a[900];		b;c;d=1		;e=1;f;		g;h;O;		main(k,
l)char*		*l;{g=		atoi(*		++l);		for(k=
0;k*k<		g;b=k		++>>1)		;for(h=		0;h*h<=
g;++h);		--h;c=(		(h+=g>h		*(h+1))		-1)>>1;
while(d		<=g){		++O;for		(f=0;f<		O&&d<=g
;++f)a[		b<<5|c]		=d++,b+		=e;for(		f=0;f<O
&&d<=g;		++f)a[b		<<5|c]=		d++,c+=		e;e= -e
;}for(c		=0;c<h;		++c){		for(b=0		;b<k;++
b){if(b		<k/2)a[		b<<5|c]		^=a[(k		-(b+1))
<<5|c]^		=a[b<<5		|c]^=a[		(k-(b+1		))<<5|c]
;printf(	a[b<<5|c	]?"%-4d"	:"    "		,a[b<<5
|c]);}		putchar(	'\n');}}	/*Mike		Laman*/
----------------------------------------------------------------------------
			Mike Laman
			UUCP: {ucbvax,philabs,sdccsu3,sdcsla}!sdcsvax!laman
P.S.  I hope you have the C beautifier! The program accepts ONE positive
      argument.  Seeing is believing!  Try something like "cmd 37" for an
      example.  <ed: also try cmd 4; cmd 9; cmd 16; cmd 25; cmd 36; ...>



Second place award:
---------------------------------------------------------------------------
#defi 25; cmd 36; ...>



Second place award:
---------------------------------------------------------------------------
#define x =
#define double(a,b) int
#define char k['a']
#define union static struct

extern int floor;
double (x1, y1) b,
char x {sizeof(
    double(%s,%D)(*)())
,};
struct tag{int x0,*xO;}

*main(i, dup, signal) {
{
  for(signal=0;*k * x * __FILE__ *i;) do {
   (printf(&*"'\",x);	/*\n\\", (*((double(tag,u)(*)())&floor))(i)));
	goto _0;

_O: while (!(char <<x - dup)) {	/*/*\*/
	union tag u x{4};
  }
}


while(b x 3, i); {
char x b,i;
  _0:if(b&&k+
  sin(signal)		/ *    ((main) (b)-> xO));/*}
  ;
}

*/}}}
-------------------------------------------------------------------------------
By: Dave Decot   hplabs!hpda!hpdsd!decot



First place award goes to:
------------------------------------------------------------------------
/* Portable between VAX11 && PDP11 */

short main[] = {
	277, 04735, -4129, 25, 0, 477, 1019, 0xbef, 0, 12800,
	-113, 21119, 0x52d7, -1006, -7151, 0, 0x4bc, 020004,
	14880, 10541, 2056, 04010, 4548, 3044, -6716, 0x9,
	4407, 6, 5568, 1, -30460, 0, 0x9, 5570, 512, -30419,
	0x7e82, 0760, 6, 0, 4, 02400, 15, 0, 4, 1280, 4, 0,
	4, 0, 0, 0, 0x8, 0, 4, 0, ',', 0, 12, 0, 4, 0, '#',
	0, 020, 0, 4, 0, 30, 0, 026, 0, 0x6176, 120, 25712,
	'p', 072163, 'r', 29303, 29801, 'e'
};
------------------------------------------------------------------------------
		Sjoerd Mullender
		Robbert van Renesse
Both @ Vrije Universiteit, Amsterdam, the Netherlands.
	..!decvax!mcvax!vu44!{sjoerd,cogito}
<ed: try this on your local VAX or pdp-11>
//E*O*F 1984//

echo x - 1985
cat > "1985" << '//E*O*F 1985//'
Since people often request the previous year's winners at the start of
the contest, I include the 1985 winners below.  Please keep in mind that
the rules have chanmged between 1985 and 1986.

------------------------------------------------------------------------

The following programs were judged good (bad? wierd?) enough to win
awards. This year, rather than trying to rank the programs in order of
obfuscatedness, we gave a single award in each of 4 categories and a
grand prize.

________________________________________________________________________

1. The most obscure program:
(submitted by Lennart Augustsson <seismo!mcvax!enea!chalmers!augustss> )

#define p struct c
#define q struct b
#define h a->a
#define i a->b
#define e i->c
#define o a=(*b->a)(b->b,b->c)
#define s return a;}q*
#define n (d,b)p*b;{q*a;p*c;
#define z(t)(t*)malloc(sizeof(t))
q{int a;p{q*(*a)();int b;p*c;}*b;};q*u n a=z(q);h=d;i=z(p);i->a=u;i->b=d+1;s
v n c=b;do o,b=i;while(!(h%d));i=c;i->a=v;i->b=d;e=b;s
w n o;c=i;i=b;i->a=w;e=z(p);e->a=v;e->b=h;e->c=c;s
t n for(;;)o,main(-h),b=i;}main(b){p*a;if(b>0)a=z(p),h=w,a->c=z(p),a->c->a=u,a->c->b=2,t(0,a);putchar(b?main(b/2),-b%2+'0':10);}

________________________________________________________________________

2. The worst abuse of the C preprocessor:
(submitted by Col. G. L. Sicherman <decvax!sunybcs!colonel> )

#define C_C_(_)~' '&_
#define _C_C(_)('\b'b'\b'>=C_C>'\t'b'\n')
#define C_C _|_
#define b *
#define C /b/
#define V _C_C(
main(C,V)
char **V;
/*	C program. (If you don't
 *	understand it look it
 */	up.) (In the C Manual)
{
	char _,__; 
	while (read(0,&__,1) & write((_=(_=C_C_(__),C)),
	_C_,1)) _=C-V+subr(&V);
}
subr(C)
char *C;
{
	C="Lint says "argument Manual isn't used."  What's that
	mean?"; while (write((read(C_C('"'-'/*"'/*"*/))?__:__-_+
	'\b'b'\b'|((_-52)%('\b'b'\b'+C_C_('\t'b'\n'))+1),1),&_,1));
}

[ This program confused the C preprocessor so badly that it left some
comments in the preprocessed version. Also, lint DID complain that
"argument Manual isn't used". ]

________________________________________________________________________

3. The strangest appearing program:
(submitted by Ed Lycklama <decvax!cca!ima!ism780!ed> )

#define o define
#o ___o write
#o ooo (unsigned)
#o o_o_ 1
#o _o_ char
#o _oo goto
#o _oo_ read
#o o_o for
#o o_ main
#o o__ if
#o oo_ 0
#o _o(_,__,___)(void)___o(_,__,ooo(___))
#o __o (o_o_<<((o_o_<<(o_o_<<o_o_))+(o_o_<<o_o_)))+(o_o_<<(o_o_<<(o_o_<<o_o_)))
o_(){_o_ _=oo_,__,___,____[__o];_oo ______;_____:___=__o-o_o_; _______:
_o(o_o_,____,__=(_-o_o_<___?_-o_o_:___));o_o(;__;_o(o_o_,"\b",o_o_),__--);
_o(o_o_," ",o_o_);o__(--___)_oo _______;_o(o_o_,"\n",o_o_);______:o__(_=_oo_(
oo_,____,__o))_oo _____;}

[it looks like tty noise]

________________________________________________________________________

4. The best "small" program:
(submitted by Jack Applin [with help from Robert Heckendorn]
<hplabs!hp-dcd!jack> )

main(v,c)char**c;{for(v[c++]="Hello, world!\n)";(!!c)[*c]&&(v--||--c&&execlp(*c,*c,c[!!c]+!!c,!c));**c=!c)write(!!*c,*c,!!**c);}

________________________________________________________________________

5. The grand prize (most well-rounded in confusion):
(submitted by Carl Shapiro <sdcrdcf!otto!carl> )

#define P(X)j=write(1,X,1)
#define C 39
int M[5000]={2},*u=M,N[5000],R=22,a[4],l[]={0,-1,C-1,-1},m[]={1,-C,-1,C},*b=N,
*d=N,c,e,f,g,i,j,k,s;main(){for(M[i=C*R-1]=24;f|d>=b;){c=M[g=i];i=e;for(s=f=0;
s<4;s++)if((k=m[s]+g)>=0&&k<C*R&&l[s]!=k%C&&(!M[k]||!j&&c>=16!=M[k]>=16))
a[f++]=s;if(f){f=M[e=m[s=a[rand()/(1+2147483647/f)]]+g];j=j<f?f:j;f+=c&-16*!j;
M[g]=c|1<<s;M[*d++=e]=f|1<<(s+2)%4;}else e=d>b++?b[-1]:e;}P(" ");for(s=C;--s;
P("_"))P(" ");for(;P("\n"),R--;P("|"))for(e=C;e--;P("_ "+(*u++/8)%2))
P("| "+(*u/4)%2);}

[As submitted, this program was 3 lines (2 of defines and 1 of code).
To make news/mail/etc. happy we split the last line into 7. Join them
back without the newlines to get the original version]

----------------------------------------------------------------------

Congratulations to the winners (and anyone else who wasted their time
creating such wierd programs).

For your own enjoyment, you can figure out what these programs do. Or 
if this is too hard, compile and run them! All of these compiled and
ran on the vax. Lint was even happy with most of the entries.
//E*O*F 1985//

echo x - 1986
cat > "1986" << '//E*O*F 1986//'


          1986 International Obfuscated C Code Contest Winners


We recommend that you first try to understand the program from just reading
the source.  If you are still confused try sending the source through the C
Preprocessor (/lib/cpp).  If you are still confused, we suggest you read the
judges comments and run each program.  Last, if you are still confused then
you are not alone!


===============================================================================
Best layout:

	Eric Marshall
	System Development Corporation, a Burroughs Company
	P.O. Box 517
	Paoli, PA.
	19301

	[Ed: some compilers have problems with this, see Judges comments below]
	sdcrdcf!burdvax!eric	{sjuvax,ihnp4,akgua,cadre}!psuvax1!burdvax!eric
-------------------------------------------------------------------------------
                                                   extern int
                                                       errno
                                                         ;char
                                                            grrr
                             ;main(                           r,
  argv, argc )            int    argc                           ,
   r        ;           char *argv[];{int                     P( );
#define x  int i,       j,cc[4];printf("      choo choo\n"     ) ;
x  ;if    (P(  !        i              )        |  cc[  !      j ]
&  P(j    )>2  ?        j              :        i  ){*  argv[i++ +!-i]
;              for    (i=              0;;    i++                   );
_exit(argv[argc- 2    / cc[1*argc]|-1<<4 ]    ) ;printf("%d",P(""));}}
  P  (    a  )   char a   ;  {    a  ;   while(    a  >      "  B   "
  /* -    by E            ricM    arsh             all-      */);    }
===============================================================================



===============================================================================
Worst abuse of the C preprocessor:

	Jim Hague
	University of Kent at Canterbury
	Canterbury, Kent
	UK

	..mcvax!ukc!jmh
-------------------------------------------------------------------------------
#define	DIT	(
#define	DAH	)
#define	__DAH	++
#define DITDAH	*
#define	DAHDIT	for
#define	DIT_DAH	malloc
#define DAH_DIT	gets
#define	_DAHDIT	char
_DAHDIT _DAH_[]="ETIANMSURWDKGOHVFaLaPJBXCYZQb54a3d2f16g7c8a90l?e'b.s;i,d:"
;main			DIT			DAH{_DAHDIT
DITDAH			_DIT,DITDAH		DAH_,DITDAH DIT_,
DITDAH			_DIT_,DITDAH		DIT_DAH DIT
DAH,DITDAH		DAH_DIT DIT		DAH;DAHDIT
DIT _DIT=DIT_DAH	DIT 81			DAH,DIT_=_DIT
__DAH;_DIT==DAH_DIT	DIT _DIT		DAH;__DIT
DIT'\n'DAH DAH		DAHDIT DIT		DAH_=_DIT;DITDAH
DAH_;__DIT		DIT			DITDAH
_DIT_?_DAH DIT		DITDAH			DIT_ DAH:'?'DAH,__DIT
DIT' 'DAH,DAH_ __DAH	DAH DAHDIT		DIT
DITDAH			DIT_=2,_DIT_=_DAH_;	DITDAH _DIT_&&DIT
DITDAH _DIT_!=DIT	DITDAH DAH_>='a'?	DITDAH
DAH_&223:DITDAH		DAH_ DAH DAH;		DIT
DITDAH			DIT_ DAH __DAH,_DIT_	__DAH DAH
DITDAH DIT_+=		DIT DITDAH _DIT_>='a'?	DITDAH _DIT_-'a':0
DAH;}_DAH DIT DIT_	DAH{			__DIT DIT
DIT_>3?_DAH		DIT			 DIT_>>1 DAH:'\0'DAH;return
DIT_&1?'-':'.';}__DIT DIT			DIT_ DAH _DAHDIT
DIT_;{DIT void DAH write DIT			1,&DIT_,1 DAH;}
===============================================================================



===============================================================================
Best one liner:

	Jan Stein
	Chalmers Computer Society
	Gothenburg
	Sweden

	..!mcvax!enea!chalmers!gustaf!cd-jan

[The single line has been split to avoid any problems with E-mailers]
-------------------------------------------------------------------------------
typedef char*z;O;o;_=33303285;main(b,Z)z Z;{b=(b>=0||(main(b+1,Z+1),
*Z=O%(o=(_%25))+'0',O/=o,_/=25))&&(b<1||(O=time(&b)%0250600,
main(~5,*(z*)Z),write(1,*(z*)Z,9)));}
===============================================================================



===============================================================================
Most adaptable program:

	Jack Applin
	Hewlett-Packard
	Ft. Collins
	Colorado
	USA

	hplabs!hpfcdc!jack
-------------------------------------------------------------------------------
cat =13 /*/ >/dev/null 2>&1; echo "Hello, world!"; exit
*
*  This program works under cc, f77, and /bin/sh.
*
*/; main() {
      write(
cat-~-cat
     /*,'(
*/
     ,"Hello, world!"
     ,
cat); putchar(~-~-~-cat); } /*
     ,)')
      end
*/
===============================================================================



===============================================================================
Most useful obfuscation:

	Walter Bright
	<Postal address not given>

	decwrl!sun!fluke!uw-beaver!entropy!dataio!bright
-------------------------------------------------------------------------------
#include <stdio.h>
#define O1O printf
#define OlO putchar
#define O10 exit
#define Ol0 strlen
#define QLQ fopen
#define OlQ fgetc
#define O1Q abs
#define QO0 for
typedef char lOL;

lOL*QI[] = {"Use:\012\011dump file\012","Unable to open file '\x25s'\012",
 "\012","   ",""};

main(I,Il)
lOL*Il[];
{	FILE *L;
	unsigned lO;
	int Q,OL[' '^'0'],llO = EOF,

	O=1,l=0,lll=O+O+O+l,OQ=056;
	lOL*llL="%2x ";
	(I != 1<<1&&(O1O(QI[0]),O10(1011-1010))),
	((L = QLQ(Il[O],"r"))==0&&(O1O(QI[O],Il[O]),O10(O)));
	lO = I-(O<<l<<O);
	while (L-l,1)
	{	QO0(Q = 0L;((Q &~(0x10-O))== l);
			OL[Q++] = OlQ(L));
		if (OL[0]==llO) break;
		O1O("\0454x: ",lO);
		if (I == (1<<1))
		{	QO0(Q=Ol0(QI[O<<O<<1]);Q<Ol0(QI[0]);
			Q++)O1O((OL[Q]!=llO)?llL:QI[lll],OL[Q]);/*"
			O10(QI[1O])*/
			O1O(QI[lll]);{}
		}
		QO0 (Q=0L;Q<1<<1<<1<<1<<1;Q+=Q<0100)
		{	(OL[Q]!=llO)? /* 0010 10lOQ 000LQL */
			((D(OL[Q])==0&&(*(OL+O1Q(Q-l))=OQ)),
			OlO(OL[Q])):
			OlO(1<<(1<<1<<1)<<1);
		}
		O1O(QI[01^10^9]);
		lO+=Q+0+l;}
	}
	D(l) { return l>=' '&&l<='\~';
}
===============================================================================



===============================================================================
Best simple task performed in a complex way:

	Bruce Holloway
	Digital Research, Inc.
	Monterey, CA
	USA

	(ucbvax!hplabs!amdahl!drivax!holloway)
-------------------------------------------------------------------------------
#include "stdio.h"
#define	e 3
#define	g (e/e)
#define	h ((g+e)/2)
#define	f (e-g-h)
#define	j (e*e-g)
#define k (j-h)
#define	l(x) tab2[x]/h
#define	m(n,a) ((n&(a))==(a))

long tab1[]={ 989L,5L,26L,0L,88319L,123L,0L,9367L };
int tab2[]={ 4,6,10,14,22,26,34,38,46,58,62,74,82,86 };

main(m1,s) char *s; {
    int a,b,c,d,o[k],n=(int)s;
    if(m1==1){ char b[2*j+f-g]; main(l(h+e)+h+e,b); printf(b); }
    else switch(m1-=h){
	case f:
	    a=(b=(c=(d=g)<<g)<<g)<<g;
	    return(m(n,a|c)|m(n,b)|m(n,a|d)|m(n,c|d));
	case h:
	    for(a=f;a<j;++a)if(tab1[a]&&!(tab1[a]%((long)l(n))))return(a);
	case g:
	    if(n<h)return(g);
	    if(n<j){n-=g;c='D';o[f]=h;o[g]=f;}
	    else{c='\r'-'\b';n-=j-g;o[f]=o[g]=g;}
	    if((b=n)>=e)for(b=g<<g;b<n;++b)o[b]=o[b-h]+o[b-g]+c;
	    return(o[b-g]%n+k-h);
	default:
	    if(m1-=e) main(m1-g+e+h,s+g); else *(s+g)=f;
	    for(*s=a=f;a<e;) *s=(*s<<e)|main(h+a++,(char *)m1);
	}
}
===============================================================================



===============================================================================
Best non-simple performed in a complex way:

	Lennart Augustsson
	Dept. of Comp. Sci.
	Chalmers University of Technology,
	412 96 Gothenburg
	Sweden

	augustss@chalmers.{uucp,csnet}
-------------------------------------------------------------------------------
typedef struct n{int a:3,
b:29;struct n*c;}t;t*
f();r(){}m(u)t*u;{t*w,*z;
z=u->c,q(z),u->b=z->b*10,
w=u->c=f(),w->a=1,w->c=z->
c;}t*k;g(u)t*u;{t*z,*v,*p,
*x;z=u->c,q(z),u->b=z->b,v
=z->c,z->a=2,x=z->c=f(),x
->a=3,x->b=2,p=x->c=f(),p
->c=f(),p->c->a=1,p->c->c=
v;}int i;h(u)t*u;{t*z,*v,*
w;int c,e;z=u->c,v=z->c,q(
v),c=u->b,e=v->b,u->b=z->b
,z->a=3,z->b=c+1,e+9>=c&&(
q(z),e=z->b,u->b+=e/c,w=f(
),w->b=e%c,w->c=z->c,u->c=
w);}int(*y[4])()={r,m,g,h};
char *sbrk();main(){t*e,*p,*o;
o=f(),o->c=o,o->b=1,e=f(),
e->a=2,p=e->c=f(),p->b=2,
p->c=o,q(e),e=e->c,(void)write
(1,"2.",2);for(;;e=e->c){q(e),
e->b=write(1,&e->b["0123456789"],
1);}}t*f(){return i||(i=1000,
k=(t*)sbrk(i*sizeof(t))),k+--i;
}q(p)t*p;{(*y[p->a])(p);}
===============================================================================



===============================================================================
Most illegible code:

 	Michael H. Pawka
	Naval Ocean Systems Center
	San Diego, Ca
	92152

	DDN - PAWKA@NOSC-TECR.ARPA
-------------------------------------------------------------------------------
#include "stdio.h"
#define xyxx char
#define xyyxx putchar
#define xyyyxx while
#define xxyyyx int
#define xxxyyx main
#define xyxyxy if
#define xyyxyy '\n'
xyxx *xyx [] = {
"]I^x[I]k\\I^o[IZ~\\IZ~[I^|[I^l[I^j[I^}[I^n[I]m\\I]h",
"]IZx\\IZx[IZk\\IZk[IZo_IZ~\\IZ~[IZ|_IZl_IZj\\IZj]IZ}]IZn_IZm\\IZm_IZh",
"]IZx\\IZx[I^k[I\\o]IZ~\\IZ~\\I]|[IZl_I^j]IZ}]I^n[IZm\\IZm_IZh",
"]IZx\\IZx[IZk\\IZk[IZo_IZ~\\IZ~_IZ|[IZl_IZj\\IZj]IZ}]IZn_IZm\\IZm]IZh",
"]I^x[I]k\\IZo_I^~[I^|[I^l[IZj\\IZj]IZ}]I^n[I]m^IZh",'\0'};/*xyyxyxyxxxyxxxyy*/
xyxx *xyyx; xxyyyx xyyyx,xyyyyx,xyyyyyx=0x59,xyyyyyyx=0x29,/*yxxyxyyyxxyyyxyy*/
xxyx=0x68;xxxyyx(){xyyyyx=0;xyyyxx(xyx[xyyyyx]){xyyx=xyx[xyyyyx++];/*xyyyxxyx*/
xyyyxx(*xyyx){xyyyx= *xyyx++-xyyyyyx;xyyyxx(xyyyx--)xyyxx(*xyyx-xyyyyyyx);/*x*/
xyxyxy(*xyyx==xxyx)xyyxx(xyyxyy);*xyyx++;}}}/*xyxyxyyyyxxyxxxyyyxyyyxyxxyyy*/
===============================================================================


===============================================================================
The grand prize (most well-rounded in confusion):

 	Larry Wall
	System Development Corporation
	Santa Monica
	California
	US of A

	[ed: modified to run on Sys V, see comments below]
 	{allegra,burdvax,cbosgd,hplabs,ihnp4,sdcsvax}!sdcrdcf!lwall
-------------------------------------------------------------------------------
#define _c(C)_ (C)&('|'+3):c_()(C)>>('\n'-3) __; /**/
#define C char*
#define keyboard ",,B3-u;.(&*5., /(b*(1\036!a%\031m,,,,,\r\n"
#define main(o,oo)oo(o){
#define _ ;case
C
#define c_(cc)c cc=
#define C_(sand)_O(sand)witch
o=keyboard;
#define __ ;break;
C
ccc(
cc)
C
cc;
{
C
cccc=
cc;int
#ifndef lint
#define keyboard "dijs QH.soav Vdtnsaoh DmfpaksoQz;kkt oa, -dijs"
#endif
c;
main(;c_(=(*cc);*cc++)c,for);
#define _O(s)s
main(0xb+(c>>5),C_(s))
_'\v'
:__ _'\f':
main(c,C_(s));
_c(8098)_c(6055)_c(14779)_c(10682)
#define O_(O)_O(O)stem(ccc(
_c(15276)_c(11196)_c(15150)
#define _C ;return
                                               