/*
 * This file contains a memory allocation package from
 * 'Dr Dobb's Toolbook of C'.  It was written by Axel Schreiner.
 * It allows allocated memory blocks to be freed in any order.
 * I have not included it in the Small-C/Plus library because
 * I haven't fully tested it, though I certainly intend using it
 * in the future.
 *                                    RMY
 */

#include <stdio.h>

#define NULL 0

/*
 * _slack is the headroom which malloc() always allows for
 * further growth of the stack
 */
int _slack = 1024 ;

/*
 * _heap contains pointer to first element in allocation chain
 * the chain is initialised so that the first element is
 * allocated (it can never be freed)
 * the next element immediately follows the first and is NULL
 */
int *_heap ;

main()
{
	char *ptr1, *ptr2, *ptr3, *ptr4 ;

#asm
	ld hl,_end			;chain starts at an even address
	inc hl
	res 0,l
;
	ld (q_heap),hl		;start of chain in _heap
;
	ld d,h				;first pointer is start of chain + 2
	ld e,l
	inc de
	inc de
;
	ld (hl),e			;set up first pointer
	inc hl
	ld (hl),d
	inc hl
;
	xor a				;set up second pointer (NULL)
	ld (hl),a
	inc hl
	ld (hl),a
#endasm
	ptr1 = malloc(16) ;
	ptr2 = malloc(1024) ;
	ptr3 = malloc(2048) ;
	ptr4 = malloc(4096) ;
	printf("\n") ;
	mstat();
	mfree(ptr3) ;
	ptr3 = malloc(1024) ;
	printf("\n") ;
	mstat();
	ptr3 = malloc(1024) ;
	printf("\n") ;
	mstat();
	mfree(ptr2) ;
	mfree(ptr1) ;
	ptr1 = malloc(1030) ;
	printf("\n") ;
	mstat() ;
}

malloc(len)
int len ;					/* length of block required */
{
	int n ;
	int cell ;				/* current allocation chain cell */
	char *p ;				/* pointer to cell */
	char *np ;				/* pointer in cell */
	int *ip, *wp ;			/* for casting */

	/* make length even */
	if ( (len=(len+1)&~1) == 0 ) {
		return NULL ;
	}
	for ( ip=p=*_heap ; np=(cell=*ip) & ~1 ; ip = p = np ) {

		if ( cell & 1 ) {			/* low bit == 1 means free */
			if ( (n=np-p-2) > len+2 ) {
				/* new block fits in gap in chain with */
				/* room to spare for another block */
				wp = p + len + 2 ;
				*wp = cell ;
				*ip = wp ;
			}
			else if ( n >= len ) {
				/* new block fits exactly in gap or */
				/* leaves only room for pointer, not block */
				*ip = np ;
			}
			else
				continue ;
			return p+2 ;
		}

	}

	/* new block goes at end of chain (if there's room) */
	if ( (wp=p+len+2) > &n-_slack )
		return NULL ;
	*ip = wp ;
	*wp = NULL ;
	return p+2 ;
}

mfree(fp)
int *fp ;
{
	int *p, *np ;

	--fp ;
	for ( p = _heap; np = *p & ~1; p = np ) {
		if ( np == fp ) {
			np = *fp ;
			if ( np & 1 || np == NULL )
				break ;
			if ( *p & 1 ) {
				if ( *np & 1 )
					*p = *np ;
				else if ( *np == NULL )
					*p = NULL ;
				else
					*p = np | 1 ;
			}
			else {
				if ( *np & 1 )
					*fp = *np ;
				else if ( *np == NULL )
					*fp = NULL ;
				else
					*fp |= 1 ;
			}
			return ;
		}
	}
	err("free botch") ;
	exit() ;
}

mstat()
{
	int *p, *np ;

	printf("start  length\n") ;
	for ( p = _heap; np = *p & ~1; p = np ) {
		/* length is multiplied by 2 because p and np are (int *) */
		printf("%4x   %4x  ", p, 2*(np-p)-2) ;
		if ( *p & 1 )
			printf("free\n") ;
		else
			printf("allocated\n") ;
	}
}
