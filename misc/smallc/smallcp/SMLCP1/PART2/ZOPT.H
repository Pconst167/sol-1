/*
 * optimiser for Small-C - include file
 */

#define TRUE	1
#define FALSE	0

#define NULL	0
#define CTRLC	3
#define TAB		9
#define SPACE	32

#define CONIN	6

#define LINELEN 128

extern int Total ;
extern int Compact ;

/* pointers to strings to be matched */
extern char Pophl[] ;
extern char Pushhl[] ;
extern char Popde[] ;
extern char Pushde[] ;
extern char Popbc[] ;
extern char Pushbc[] ;
extern char Ret[] ;
extern char Ldde[] ;
extern char Ldhl[] ;
extern char Ldhl0[] ;
extern char Ldhl2[] ;
extern char Ldhl4[] ;
extern char Ldhl6[] ;
extern char Inchl[] ;
extern char Dechl[] ;
extern char Popix[] ;
extern char Pushix[] ;
extern char Exdehl[] ;
extern char Addhlde[] ;
extern char Addhlhl[] ;
