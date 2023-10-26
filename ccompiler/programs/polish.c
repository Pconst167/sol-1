#include "stdio.h"

#define MAXOP	100
#define NUMBER 999
#define MAXVAL 100
#define BUFSIZE 100

int _sp = 0;		/*stack pointer*/
int val[MAXVAL];	/*this is the stack*/
char buf[BUFSIZE];
int bufp = 0;

/*Reverse polish calculator*/

int _atoi(char *s){
	int n;
	asm{
		lea d, @s
		mov a, [d]
		mov d, a
		call strtoint
		mov @n, a
	}
	return n;
}

int main()
{
	int type;
	int op2;
	char s[MAXOP];

	while ((type = getop(s)) != '$')
	{
	switch (type)
		{
		case NUMBER:
			_push(_atoi(s));
			break;
		case '+':
			_push(_pop() + _pop());
			break;
		case '*':
			_push(_pop() * _pop());
			break;
		case '-':
			op2 = _pop();
			_push(_pop() - op2);
			break;
		case '/':
			op2 = _pop();
			if (op2 != 0)
				_push(_pop() / op2);
			else
				print("Divide by zero error\n");
			break;
		case 10:
			printn(_pop());
			print("\n");
			break;
		default:
			print("Unknown input: ");
			print(s);
			print("\n");
			break;
		}
	}
	return 0;
}

void _push (int f)
{
	if (_sp < MAXVAL){
		val[_sp] = f;
		_sp++;
	}
	else{
		print("Error: stack full, can't _push: ");
		printn(f);
	}
	return;
}

int _pop (void)
{
	if (_sp > 0){
		_sp--;
		return val[_sp];
	}
	else
	{
		print("Error: stack empty.\n");
		return 0;
	}
}

int getop(char s[50])
{
	int i;
	char c;
	
	while ((s[0] = (c = getch())) == ' ');
	s[1] = 0;
	if (!isdigit(c)){
		return c;
	}
	i = 0;
	if (isdigit(c)) while (isdigit( s[i++] = (c = getch())) );
	s[i] = 0;
	if (c != '$') ungetch(c);
	return NUMBER;
}

int getch(void)
{
	if(bufp > 0){
		bufp--;
		return buf[bufp];
	}
	else{
		return getch();
	}
	//return (bufp > 0) ? buf[--bufp] : getchar();
}

void ungetch(char c)
{
	if (bufp >= BUFSIZE)
		print("Error: too many characters.\n");
	else{
		buf[bufp] = c;
		bufp++;
	}

	return;
}
	
int isdigit(char c){
	if(c >= '0' && c <= '9') return 1;
	else return 0;
}











			

		
