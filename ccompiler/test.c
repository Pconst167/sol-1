#include <stdio.h>

struct list{
	char name[100];
	int number;
	struct list *prev;
	struct list *next;
};

struct list l[10];
struct list *p;

class my_class{
	private:
		int i;
		char c;
	

/*
	public{
		int a;

		constructor void create(char c, int i, int a){
			self.c = c;
			self.i = i;
			self.a = a;
			printf("A new class has been created. Thank you!");
		}

	}

	*/
};

int main() {

	class my_class myClass;
	myClass.create('a', 1, 2);

}