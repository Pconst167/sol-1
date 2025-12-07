/*
 * define types of various functions
 */

#ifndef SMALL_C
extern void exit() ;
extern char *malloc() ;
#endif

extern SYMBOL *findloc(), *findglb(), *addloc(), *addglb(), *findmemb() ;
extern TAG_SYMBOL *defstruct(), *findtag() ;
extern WHILE_TAB *readwhile() ;

extern int dmul(), ddiv(), dadd(), dsub(), zsub(), zadd(), zor(), zxor(), zand() ;
extern int mult(), div(), zmod(), asr(), asl(), eq0(), zeq(), deq(), zne(), dne() ;
extern int zle(), ule(), dle(), zge(), uge(), dge(), zlt(), ult(), dlt() ;
extern int zgt(), ugt(), dgt(), inc(), dec() ;
extern int testjump(), gt0(), ge0(), lt0(), le0() ;

extern int heir1a(), heir2b(), heir2(), heir3(), heir4(), heir5(), heir6() ;
extern int heir7(), heir8(), heir9(), heira(), heirb() ;
