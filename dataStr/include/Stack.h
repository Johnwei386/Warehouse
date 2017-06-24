#ifndef _STACK_H
#define _STACK_H

# include <stdio.h>
# include <stdlib.h>
# include "Tree.h"
# include "Status.h"

typedef struct{
   BitTree top;
   BitTree base;
   size_t capcity;
}Stack;

int initStack(Stack *stack);
void push(Stack *stack, BitNode v);
BitTree pop(Stack *stack);
Boolean emptyStack(Stack *stack);

#endif
