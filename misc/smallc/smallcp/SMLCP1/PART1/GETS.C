#include <stdio.h>

/* input a string (editing permitted) */

gets(buf)
char *buf;
{
	char s1,s2;
	int i;

	if (stdin) {	/* input has been redirected */
		i = 80;
		while(i--) {
			s1 = getc(stdin);
			if ( s1==-1 || s1=='\n' )
				break;
			*buf++ = s1;
		}
		*buf = 0;
	}
	else {
		/* save 2 bytes */
		s2 = buf[-2];
		s1 = buf[-1];
		buf[-2] = 80;
		/* assumed string length */
		cpm(10,buf-2);
		/* mark end using count left by cpm */
		buf[buf[-1]] = 0;
		/* restore the bytes */
		buf[-1] = s1;
		buf[-2] = s2;
		putchar('\l');	/* LF */
	}
}
