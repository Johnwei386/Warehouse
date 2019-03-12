#include "include/Stack.h"
#define INIT_SIZE 18
#define INCRE_SIZE 10

int initStack(Stack *stack)
{
  stack->base = (BitTree)malloc(sizeof(BitNode) * INIT_SIZE);
  if(!stack->base)
	return ERROR;
  stack->top = stack->base;
  stack->capcity = INIT_SIZE;
  return OK;
}

void push(Stack *stack, BitNode v)
{
   int len = stack->top - stack->base;
   if(len > stack->capcity)
   {
      stack->base = (BitTree)realloc(stack->base, (stack->capcity + INCRE_SIZE) * sizeof(BitNode));
      stack->top = stack->base + len;
      stack->capcity = stack->capcity + INCRE_SIZE;
   }

   *(stack->top) = v;
   stack->top++;
}

BitTree pop(Stack *stack)
{
   if(emptyStack(stack))
	return NULL;
   return --(stack->top);
}

Boolean emptyStack(Stack *stack)
{ //判断堆栈是否为空，空返回真
   if(stack->top == stack->base) return TRUE;
   else return FALSE;
}

/**************************************************************************
int main(void)
{
  Stack* stack = (Stack*)malloc(sizeof(Stack));
  initStack(stack);
  for(int i=10; i>0; i--) push(stack, i);
  for(int i=0; i<10; i++) printf("%d\n", pop(stack));

  return OK;
}
**********************************************/
