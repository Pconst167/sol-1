/*
 * cc4.c - fourth part of Small-C/Plus compiler
 *         routines for recursive descent
 */

#include <stdio.h>
#include <string.h>
#include "ccdefs.h"
#include "cclvalue.h"
#include "ccfunc.h"

extern TAG_SYMBOL *tagtab ;
extern SYMBOL *dummy_sym[] ;
extern char *stagenext ;
extern char line[] ;
extern int lptr ;
extern int Zsp ;


/*
 * skim over text adjoining || and && operators
 */
skim(opstr, testfunc, dropval, endval, heir, lval)
char *opstr;
int (*testfunc)(), dropval, endval, (*heir)() ;
LVALUE *lval ;
{
	int droplab, endlab, hits, k ;

	hits = 0 ;
	while (1) {
		k = plnge1(heir, lval) ;
		if ( streq(line+lptr, opstr) == 2 ) {
			inbyte() ;
			inbyte() ;
			if (hits == 0) {
				hits = 1 ;
				droplab = getlabel() ;
			}
			dropout(k, testfunc, droplab, lval) ;
		}
		else if (hits) {
			dropout(k, testfunc, droplab, lval) ;
			const(endval) ;
			jump(endlab=getlabel()) ;
			postlabel(droplab);
			const(dropval);
			postlabel(endlab) ;
			lval->indirect = lval->ptr_type = lval->is_const =
				lval->const_val = 0 ;
			lval->stage_add = NULL_CHAR ;
			return 0 ;
		}
		else return k ;
	}
}

/*
 * test for early dropout from || or && evaluations
 */
dropout(k, testfunc, exit1, lval)
int k, (*testfunc)(), exit1 ;
LVALUE *lval ;
{
	if ( k )
		rvalue(lval) ;
	else if ( lval->is_const )
		const(lval->const_val) ;
	(*testfunc)(exit1) ;		/* jump on false */
}

/*
 * unary plunge to lower level
 */
plnge1(heir, lval)
int (*heir)() ;
LVALUE *lval ;
{
	char *before, *start ;
	int k ;

	setstage(&before, &start) ;
	k = (*heir)(lval) ;
	if ( lval->is_const ) {
		/* constant, load it later */
		clearstage( before, 0 ) ;
	}
	return k ;
}

/*
 * binary plunge to lower level (not for +/-)
 */
plnge2a(heir, lval, lval2, oper, uoper, doper)
int (*heir)() ;
LVALUE *lval, *lval2 ;
int (*oper)(), (*uoper)(), (*doper)();
{
	char *before, *start ;

	setstage(&before, &start) ;
	lval->stage_add = 0 ;		/* flag as not "..oper 0" syntax */
	if ( lval->is_const ) {
		/* constant on left not loaded yet */
		if ( plnge1(heir, lval2) )
			rvalue(lval2) ;
		if ( lval->const_val == 0 )
			lval->stage_add = stagenext ;
		const2(lval->const_val) ;
		dcerror(lval2) ;
	}
	else {
		/* non-constant on left */
		if ( lval->val_type == DOUBLE ) dpush() ;
		else zpush();
		if( plnge1(heir,lval2) ) rvalue(lval2);
		if ( lval2->is_const ) {
			/* constant on right, load primary */
			if ( lval2->const_val == 0 ) lval->stage_add = start ;
			const(lval2->const_val) ;
			dcerror(lval) ;
		}
		if ( lval->val_type != DOUBLE && lval2->val_type != DOUBLE )
			zpop() ;
	}
	lval->is_const &= lval2->is_const ;
	/* ensure that operation is valid for double */
	if ( doper == 0 ) intcheck(lval, lval2) ;
	if ( widen(lval, lval2) ) {
		(*doper)();
		/* result of comparison is int */
		if( doper != dmul && doper != ddiv )
			lval->val_type = CINT;
		return;
	}
	if ( lval->ptr_type || lval2->ptr_type ) {
		(*uoper)();
		lval->binop = uoper ;
		return;
	}
	if ( lval2->symbol ) {
	    if ( lval2->symbol->ident == POINTER ) {
			(*uoper)();
			lval->binop = uoper ;
			return;
		}
	}
	if ( lval->is_const ) {
		/* both operands constant */
		lval->const_val = calc(lval->const_val, oper, lval2->const_val) ;
		clearstage(before, 0) ;
	}
	else {
		/* one or both operands not constant */
		(*oper)();
		lval->binop = oper ;
	}
}

/*
 * binary plunge to lower level (for +/-)
 */
plnge2b(heir, lval, lval2, oper, doper)
int (*heir)() ;
LVALUE *lval, *lval2 ;
int (*oper)(), (*doper)() ;
{
	char *before, *start, *before1, *start1 ;
	int val ;

	setstage(&before, &start) ;
	if ( lval->is_const ) {
		/* constant on left not yet loaded */
		if ( plnge1(heir, lval2) ) rvalue(lval2) ;
		val = lval->const_val ;
		if ( dbltest(lval2, lval) ) {
			/* are adding lval to pointer, adjust size */
			cscale(lval2->ptr_type, lval2->tagsym, &val) ;
		}
		const2(val) ;
		dcerror(lval2) ;
	}
	else {
		/* non-constant on left */
		setstage(&before1, &start1) ;
		if ( lval->val_type == DOUBLE ) dpush() ;
		else zpush() ;
		if ( plnge1(heir, lval2) ) rvalue(lval2) ;
		if ( lval2->is_const ) {
			/* constant on right */
			val = lval2->const_val ;
			if ( dbltest(lval, lval2) ) {
				/* are adding lval2 to pointer, adjust size */
				cscale(lval->ptr_type, lval->tagsym, &val) ;
			}
			if ( oper == zsub ) {
				/* addition on Z80 is cheaper than subtraction */
				val = (-val) ;
				/* skip later diff scaling - constant can't be pointer */
				oper = zadd ;
			}
			/* remove zpush and add int constant to int */
			clearstage(before1, 0) ;
			Zsp = Zsp + 2 ;
			addconst(val) ;
			dcerror(lval) ;
		}
		else {
			/* non-constant on both sides or double +/- int const */
			if (dbltest(lval,lval2))
	    		scale(lval->ptr_type, lval->tagsym);
			if ( widen(lval, lval2) ) {
				/* floating point operation */
				(*doper)();
				lval->is_const = 0 ;
				return ;
			}
			else {
				/* non-constant integer operation */
	    		zpop();
				if ( dbltest(lval2, lval) ) {
	    			swap();
					scale(lval2->ptr_type, lval2->tagsym) ;
					/* subtraction not commutative */
					if (oper == zsub) swap();
				}
			}
		}
	}
	if ( lval->is_const &= lval2->is_const ) {
		/* both operands constant */
		if (oper == zadd) lval->const_val += lval2->const_val ;
		else if (oper == zsub) lval->const_val -= lval2->const_val ;
		else lval->const_val = 0 ;
		clearstage(before, 0) ;
	}
	else if (lval2->is_const == 0) {
		/* right operand not constant */
    	(*oper)();
	}
	if (oper == zsub) {
		/* scale difference between pointers */
		if( lval->ptr_type == CINT && lval2->ptr_type == CINT ) {
			swap();
			const(1) ;
			asr(); /*  div by 2  */
		}
		else if( lval->ptr_type == DOUBLE && lval2->ptr_type == DOUBLE ) {
			swap();
			const(6) ;
			div(); /* div by 6 */
		}
		else if ( lval->ptr_type == STRUCT && lval2->ptr_type == STRUCT ) {
			swap() ;
			const(lval->tagsym->size) ;
			div() ;
		}
	}
    result(lval,lval2);
}

expression(con, val)
int *con, *val ;
{
	LVALUE lval ;

	if ( heir1(&lval) ) {
		rvalue(&lval) ;
	}
	*con = lval.is_const ;
	*val = lval.const_val ;
	return lval.val_type ;
}

heir1(lval)
LVALUE *lval ;
{
	char *before, *start ;
	LVALUE lval2, lval3 ;
	int (*oper)(), (*doper)(), k ;

	setstage(&before, &start) ;
	k = plnge1(heir1a, lval);
	if ( lval->is_const ) const(lval->const_val) ;
	doper = 0 ;
	if ( cmatch('=') ) {
		if ( k == 0 ) {
			needlval() ;
			return 0 ;
		}
		if ( lval->indirect ) smartpush(lval, before);
		if ( heir1(&lval2) ) rvalue(&lval2);
		force(lval->val_type, lval2.val_type);
		smartstore(lval);
		return 0;
	}
	else if ( match("|=") ) oper = zor;
	else if ( match("^=") ) oper = zxor;
	else if ( match("&=") ) oper = zand;
	else if ( match("+=") ) { oper = zadd; doper = dadd; }
	else if ( match("-=") ) { oper = zsub; doper = dsub; }
	else if ( match("*=") ) { oper = mult; doper = dmul; }
	else if ( match("/=") ) { oper = div; doper = ddiv; }
	else if ( match("%=") ) oper = zmod;
	else if ( match(">>=") ) oper = asr;
	else if ( match("<<=") ) oper = asl;
	else return k;

	/* if we get here we have an oper= */
	if ( k == 0 ) {
		needlval() ;
		return 0 ;
	}
	lval3.symbol = lval->symbol ;
	lval3.indirect = lval->indirect ;
	/* don't clear address calc we need it on rhs */
	if ( lval->indirect ) smartpush(lval, 0);
	rvalue(lval) ;
	if ( oper==zadd || oper==zsub )
		plnge2b(heir1, lval, &lval2, oper, doper) ;
	else
		plnge2a(heir1, lval, &lval2, oper, oper, doper) ;
	smartstore(&lval3) ;
	return 0 ;
}

/*
 * heir1a - conditional operator
 */
heir1a(lval)
LVALUE *lval ;
{
	int falselab, endlab, skiplab ;
	LVALUE lval2 ;
	int k ;

	k = heir2a(lval) ;
	if ( cmatch('?') ) {
		/* evaluate condition expression */
		if ( k ) rvalue(lval) ;
		/* test condition, jump to false expression evaluation if necessary */
		force(CINT, lval->val_type) ;
		testjump(falselab=getlabel()) ;
		/* evaluate 'true' expression */
		if ( heir1(&lval2) ) rvalue(&lval2) ;
		needchar(':') ;
		jump(endlab=getlabel()) ;
		/* evaluate 'false' expression */
		postlabel(falselab) ;
		if ( heir1(lval) ) rvalue(lval) ;
		/* check types of expressions and widen if necessary */
		if ( lval2.val_type == DOUBLE && lval->val_type != DOUBLE ) {
			callrts("qfloat") ;
			lval->val_type = DOUBLE ;
			postlabel(endlab) ;
		}
		else if ( lval2.val_type != DOUBLE && lval->val_type == DOUBLE ) {
			jump(skiplab=getlabel()) ;
			postlabel(endlab) ;
			callrts("qfloat") ;
			postlabel(skiplab) ;
		}
		else
			postlabel(endlab) ;
		/* result cannot be a constant, even if second expression is */
		lval->is_const = 0 ;
		return 0 ;
	}
	else
		return k ;
}


heir2a(lval)
LVALUE *lval ;
{
	return skim("||", eq0, 1, 0, heir2b, lval);
}

heir2b(lval)
LVALUE *lval ;
{
	return skim("&&", testjump, 0, 1, heir2, lval);
}

heir234(lval, heir, opch, oper)
LVALUE *lval;
int (*heir)() ;
char opch ;
int (*oper)() ;
{
	LVALUE lval2 ;
	int k ;

	k = plnge1(heir, lval);
	blanks();
	if ((ch() != opch) || (nch() == '=') ||	(nch() == opch)) return k;
	if ( k ) rvalue(lval);
	while(1) {
		if ( (ch() == opch) && (nch() != '=') && (nch() != opch) ) {
			inbyte();
			plnge2a(heir, lval, &lval2, oper, oper, 0) ;
		}
		else return 0;
	}
}

heir2(lval)
LVALUE *lval ;
{
	return heir234(lval, heir3, '|', zor) ;
}

heir3(lval)
LVALUE *lval ;
{
	return heir234(lval, heir4, '^', zxor) ;
}

heir4(lval)
LVALUE *lval ;
{
	return heir234(lval, heir5, '&', zand) ;
}

heir5(lval)
LVALUE *lval ;
{
	LVALUE lval2 ;
	int k ;

	k = plnge1(heir6, lval) ;
	blanks() ;
	if((streq(line+lptr,"==")==0) &&
		(streq(line+lptr,"!=")==0))return k;
	if ( k ) rvalue(lval) ;
	while(1) {
		if (match("==")) {
			plnge2a(heir6, lval, &lval2, zeq, zeq, deq) ;
		}
		else if (match("!=")) {
			plnge2a(heir6, lval, &lval2, zne, zne, dne) ;
		}
		else return 0;
	}
}

heir6(lval)
LVALUE *lval ;
{
	LVALUE lval2 ;
	int k ;

	k = plnge1(heir7, lval) ;
	blanks() ;
	if ( ch() != '<' && ch() != '>' &&
		(streq(line+lptr,"<=")==0) &&
		(streq(line+lptr,">=")==0) ) return k ;
	if ( streq(line+lptr,">>") ) return k ;
	if ( streq(line+lptr,"<<") ) return k ;
	if ( k ) rvalue(lval) ;
	while(1) {
		if (match("<=")) {
			plnge2a(heir7, lval, &lval2, zle, ule, dle) ;
		}
		else if (match(">=")) {
			plnge2a(heir7, lval, &lval2, zge, uge, dge) ;
		}
		else if ( ch() == '<' && nch() != '<' ) {
			inbyte();
			plnge2a(heir7, lval, &lval2, zlt, ult, dlt) ;
		}
		else if ( ch() == '>' && nch() != '>' ) {
			inbyte();
			plnge2a(heir7, lval, &lval2, zgt, ugt, dgt) ;
		}
		else return 0;
	}
}

heir7(lval)
LVALUE *lval ;
{
	LVALUE lval2 ;
	int k ;

	k = plnge1(heir8, lval) ;
	blanks();
	if((streq(line+lptr,">>")==0) &&
		(streq(line+lptr,"<<")==0))return k;
	if ( streq(line+lptr, ">>=") ) return k ;
	if ( streq(line+lptr, "<<=") ) return k ;
	if ( k ) rvalue(lval) ;
	while(1) {
		if ((streq(line+lptr,">>") == 2) &&
			(streq(line+lptr,">>=") == 0) ) {
			inbyte();
			inbyte();
			plnge2a(heir8, lval, &lval2, asr, asr, 0) ;
		}
		else if ((streq(line+lptr,"<<") == 2) &&
			(streq(line+lptr,"<<=") == 0) ) {
			inbyte();
			inbyte();
			plnge2a(heir8, lval, &lval2, asl, asl, 0) ;
		}
		else return 0;
	}
}

heir8(lval)
LVALUE *lval ;
{
	LVALUE lval2 ;
	int k ;

	k = plnge1(heir9, lval) ;
	blanks();
	if ( ch()!='+' && ch()!='-' ) return k;
	if (nch()=='=') return k;
	if ( k ) rvalue(lval) ;
	while(1) {
		if (cmatch('+')) {
			plnge2b(heir9, lval, &lval2, zadd, dadd) ;
		}
		else if (cmatch('-')) {
			plnge2b(heir9, lval, &lval2, zsub, dsub) ;
		}
		else return 0 ;
	}
}

heir9(lval)
LVALUE *lval ;
{
	LVALUE lval2 ;
	int k ;

	k = plnge1(heira, lval) ;
	blanks();
	if ( ch() != '*' && ch() != '/' && ch() != '%' ) return k;
	if ( nch() == '=' ) return k ;
	if ( k ) rvalue(lval) ;
	while(1) {
		if (cmatch('*')) {
			plnge2a(heira, lval, &lval2, mult, mult, dmul);
		}
		else if (cmatch('/')) {
			plnge2a(heira, lval, &lval2, div, div, ddiv);
		}
		else if (cmatch('%')) {
			plnge2a(heira, lval, &lval2, zmod, zmod, 0);
		}
		else return 0;
	}
}

/*
 * perform lval manipulation for pointer dereferencing/array subscripting
 */

#ifndef SMALL_C
SYMBOL *
#endif

deref(lval)
LVALUE *lval ;
{
	/* NB it has already been determind that lval->symbol is non-zero */
	if ( lval->symbol->more == 0 ) {
		/* array of/pointer to variable */
		lval->val_type = lval->indirect = lval->symbol->type ;
		lval->symbol = NULL_SYM ;			/* forget symbol table entry */
		lval->ptr_type = 0 ;				/* flag as not symbol or array */
	}
	else {
		/* array of/pointer to pointer */
		lval->symbol = dummy_sym[lval->symbol->more] ;
		lval->indirect = lval->val_type = CINT ;
		lval->ptr_type = lval->symbol->type ;
		if ( lval->symbol->type == STRUCT )
			lval->tagsym = tagtab + lval->symbol->tag_idx ;
	}
	return lval->symbol ;
}


heira(lval)
LVALUE *lval ;
{
	int k;

	if(match("++")) {
		prestep(lval, 1, inc) ;
		return 0;
	}
	else if(match("--")) {
		prestep(lval, -1, dec) ;
		return 0;
	}
	else if (cmatch('~')) {
		if (heira(lval)) rvalue(lval) ;
		intcheck(lval, lval) ;
		com() ;
		lval->const_val = ~lval->const_val ;
		lval->stage_add = NULL_CHAR ;
		return 0 ;
	}
	else if (cmatch('!')) {
		if (heira(lval)) rvalue(lval) ;
		if (lval->val_type == DOUBLE) callrts("qifix") ;
		lneg() ;
		lval->const_val = !lval->const_val ;
		lval->val_type = CINT ;
		lval->stage_add = NULL_CHAR ;
		return 0 ;
	}
	else if (cmatch('-')) {
		if (heira(lval)) rvalue(lval);
		if (lval->val_type == DOUBLE) dneg();
		else {
			neg();
			lval->const_val = -lval->const_val ;
		}
		lval->stage_add = NULL_CHAR ;
		return 0 ;
	}
	else if ( cmatch('*') ) {			/* unary * */
		if ( heira(lval) ) rvalue(lval) ;
		if ( lval->symbol == 0 ) {
			error("can't dereference") ;
			junk() ;
			return 0 ;
		}
		else {
			deref(lval) ;
		}
		lval->is_const = 0 ;	/* flag as not constant */
		lval->const_val = 1 ;	/* omit rvalue() on func call */
		lval->stage_add = 0 ;
		return 1 ;				/* dereferenced pointer is lvalue */
	}
	else if ( cmatch('&') ) {
		if ( heira(lval) == 0 ) {
			/* OK to take address of struct */
			if ( lval->tagsym == 0 || lval->ptr_type != STRUCT ||
					( lval->symbol && lval->symbol->ident == ARRAY ) ) {
				error("illegal address");
			}
			return 0;
		}
		lval->ptr_type = lval->symbol->type ;
		lval->val_type = CINT ;
		if ( lval->indirect ) return 0 ;
		/* global & non-array */
		address(lval->symbol) ;
		lval->indirect = lval->symbol->type ;
		return 0;
	}
	else {
		k = heirb(lval) ;
		if ( match("++") ) {
			poststep(k, lval, 1, inc, dec) ;
			return 0;
		}
		else if ( match("--") ) {
			poststep(k, lval, -1, dec, inc ) ;
			return 0;
		}
		else return k;
	}
}

heirb(lval)
LVALUE *lval ;
{
	char *before, *start ;
	char *before1, *start1 ;
	char sname[NAMESIZE] ;
	int con, val, direct, k ;
	SYMBOL *ptr ;

	setstage(&before1, &start1);
	k = primary(lval) ;
	ptr = lval->symbol ;
	blanks();
	if ( ch()=='[' || ch()=='(' || ch()=='.' || (ch()=='-' && nch()=='>') )
	while ( 1 ) {
		if ( cmatch('[') ) {
			if ( ptr == 0 ) {
				error("can't subscript");
				junk();
				needchar(']');
				return 0;
			}
			else if ( k && ptr->ident == POINTER ) rvalue(lval) ;
			else if ( ptr->ident != POINTER && ptr->ident != ARRAY ) {
				error("can't subscript");
				k=0;
			}
			setstage(&before, &start) ;
			zpush();
			expression(&con, &val);
			needchar(']');
			if ( con ) {
				Zsp += 2 ;		/* undo push */
				cscale(ptr->type, tagtab+ptr->tag_idx, &val) ;
				if ( ptr->storage == STKLOC && ptr->ident == ARRAY ) {
					/* constant offset to array on stack */
					/* do all offsets at compile time */
					clearstage(before1, 0) ;
					getloc(ptr, val) ;
				}
				else {
					/* add constant offset to address in primary */
					clearstage(before, 0);
					addconst(val) ;
				}
			}
			else {
				/* non-constant subscript, calc at run time */
				scale(ptr->type, tagtab+ptr->tag_idx);
				zpop();
				zadd();
			}
			ptr = deref(lval) ;
			k = 1 ;
		}
		else if ( cmatch('(') ) {
			if ( ptr == 0 ) {
				callfunction(NULL_SYM);
			}
			else if ( ptr->ident != FUNCTION ) {
				if ( k && lval->const_val == 0 ) rvalue(lval);
				callfunction(NULL_SYM);
			}
			else callfunction(ptr);
			k = lval->is_const = lval->const_val = 0 ;
			if ( ptr->more == 0 ) {
				/* function returning variable */
				lval->val_type = ptr->type ;
				ptr = lval->symbol = 0 ;
			}
			else {
				/* function returning pointer */
				ptr = lval->symbol = dummy_sym[ptr->more] ;
				lval->indirect = lval->ptr_type = ptr->type ;
				lval->val_type = CINT ;
				if ( ptr->type == STRUCT ) {
					lval->tagsym = tagtab + ptr->tag_idx ;
				}
			}
		}
		else if ( (direct=cmatch('.')) || match("->") ) {
			if ( lval->tagsym == 0 ) {
				error("can't take member") ;
				junk() ;
				return 0 ;
			}
			if ( symname(sname) == 0 || (ptr=findmemb(lval->tagsym,sname)) == 0 ) {
				error("unknown member") ;
				junk() ;
				return 0 ;
			}
			if ( k && direct == 0 )
				rvalue(lval) ;
			addconst(ptr->offset.i) ;
			lval->symbol = ptr ;
			lval->indirect = lval->val_type = ptr->type ;
			lval->ptr_type = lval->is_const = lval->const_val = 0 ;
			lval->stage_add = NULL_CHAR ;
			lval->tagsym = NULL_TAG ;
			lval->binop = NULL_FN ;
			if ( ptr->type == STRUCT )
				lval->tagsym = tagtab + ptr->tag_idx ;
			if ( ptr->ident == POINTER ) {
				lval->indirect = CINT ;
				lval->ptr_type = ptr->type ;
				lval->val_type = CINT ;
			}
			if ( ptr->ident==ARRAY || (ptr->type==STRUCT && ptr->ident==VARIABLE) ) {
				/* array or struct */
				lval->ptr_type = ptr->type ;
				lval->val_type = CINT ;
				k = 0 ;
			}
			else k = 1 ;
		}
		else return k ;
	}
	if ( ptr && ptr->ident == FUNCTION ) {
		address(ptr->name);
		lval->symbol = 0 ;
		return 0;
	}
	return k;
}
