double float(),	/* integer to floating point conversion */
fmod(),		/* mod(x,y) */
fabs(),		/* absolute value */
floor(),	/* largest integer not greater than */
ceil(),		/* smallest integer not less than */
rand();		/* random number in range 0...1 */
int ifix();	/* floating point to integer
		(takes floor first) */
#asm
	GLOBAL	ADDHALF
	GLOBAL	DADD
	GLOBAL	DDIV
	GLOBAL	DGE
	GLOBAL	DIV1
	GLOBAL	DIV17
	GLOBAL	DLOAD
	GLOBAL	DLDPSH
	GLOBAL	DMUL
	GLOBAL	DSTORE
	GLOBAL	DSWAP
	GLOBAL	DSUB
	GLOBAL	DEQ
	GLOBAL	DGT
	GLOBAL	DLE
	GLOBAL	DLT
	GLOBAL	DNE
	GLOBAL	DPUSH
	GLOBAL	DPUSH2
	GLOBAL	EXTRA
	GLOBAL	FA
	GLOBAL	FADD
	GLOBAL	FASIGN
	GLOBAL	FDIV
	GLOBAL	FMUL
	GLOBAL	FSUB
	GLOBAL	HLADD
	GLOBAL	HLSUB
	GLOBAL	ILLFCT
	GLOBAL	LDBCFA
	GLOBAL	LDBCHL
	GLOBAL	LDFABC
	GLOBAL	MINUSFA
	GLOBAL	ODD
	GLOBAL	PUSHFA
	GLOBAL	QCEIL
	GLOBAL	QIFIX
	GLOBAL	QFABS
	GLOBAL	QFLOAT
	GLOBAL	QFLOOR
	GLOBAL	QFMOD
	GLOBAL	QRAND
	GLOBAL	SGN
#endasm
