#ifndef _LSTACK_H
#define _LSTACK_H
# include <stdio.h>
# include <stdlib.h>
# include "Status.h"

typedef int Data;
typedef struct Stack{
  int data;
  struct Stack *next;
}Stack;

void push(Stack *S, int v);
Data pop(Stack *S);
Boolean stackEmpty(Stack *S);
#endif
