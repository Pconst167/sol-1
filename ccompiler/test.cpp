#include <stdio.h>
#define SIZE 100

class stack{
  private:
    int tos;
    int stck[SIZE];
  
  public:
    stack();
    void push(int a);
    int pop();
};

stack::stack(){
  tos = 0;
}

stack::push(int a){
  if(tos == SIZE){
    printf("stck is full\n");
    return;
  }
  stck[tos++] = a;
}

int stack::pop(){
  if(tos == 0){
    printf("stack is empty.\n");
    return;
  }
  return stck[--tos];
}

int main() {
  stack my_stack;

  my_stack.push(10);
  my_stack.push(20);

  printf("pop: %d", my_stack.pop());
  printf("pop: %d", my_stack.pop());

  return 0;
}
