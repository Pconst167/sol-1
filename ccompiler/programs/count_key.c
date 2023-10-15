#include "stdio.h"

struct key 
{
	char *word;
	int count;
};

//struct key keytab[50];

struct key keytab[] =
{
	{"auto", 0},
	{"break", 0},
	{"case", 0},
	{"char", 0},
	{"const", 0},
	{"continue", 0},
	{"default", 0},
	{"do", 0},
	{"double", 0},
	{"else", 0},
	{"enum", 0},
	{"extern", 0},
	{"float", 0},
	{"for", 0},
	{"goto", 0},
	{"if", 0},
	{"int", 0},
	{"long", 0},
	{"register", 0},
	{"return", 0},
	{"short", 0},
	{"signed", 0},
	{"sizeof", 0},
	{"static", 0},
	{"struct", 0},
	{"switch", 0},
	{"typedef", 0},
	{"union", 0},
	{"unsigned", 0},
	{"void", 0},
	{"volatile", 0},
	{"while", 0}
};
	
char buf[100];
int bufp = 0;

int main()
{
	int n;
	char word[100];

	while (getword(word, 100) != 0)
		if (is_alpha(word[0]))
			if ((n = binsearch(word, keytab, 50)) >= 0)
				keytab[n].count++;
	printf("\n");
	for (n = 0; n < 50; n++)
		if (keytab[n].count > 0)
			printf("%4d %s\n", keytab[n].count, keytab[n].word);
	return 0;
}

int binsearch(char *word, struct key tab[], int n)
{
	int cond;
	int low, high, mid;
	
	low = 0;
	high = n - 1;
	while (low <= high)
	{
		mid = (low+high) / 2;
		if ((cond = strcmp(word, tab[mid].word)) < 0)
			high = mid - 1;
		else
			if (cond > 0) low = mid + 1;
		else return mid;
	}
	return -1;
}

int getword(char *word, int lim)
{
	int c;
	char *w = word;
	
	while (is_space(c = getch()));
	if (c != 0x0a) *w++ = c;
	if (!is_alpha(c))
	{
		*w = '\0';
		return 0;
	}
	for ( ; --lim > 0; w++)
		if (!is_alphanum(*w = getch()))
		{
			ungetch(*w);
			break;
   		}
	*w = '\0';
	return word[0];
}

int getch(void)
{
	return (bufp > 0) ? buf[--bufp] : getchar();
}

int is_space(char c){
	return c == ' ' || c == '\t' || c == '\n';
}
int is_alpha(char c){
	return c >= 'a' && c <= 'z' || c >= 'a' && c <= 'z';
}
int is_alphanum(char c){
	return c >= 'a' && c <= 'z' || c >= 'A' && c <= 'Z' || c >= '0' && c <= '9';
}

void ungetch(int c)
{
	if (bufp >= 100)
		printf("Error: too many characters.\n");
	else
		buf[bufp++] = c;
}
