#include "include/LStack.h"

void push(Stack *S, int v)
{
  Stack *p = (Stack*)malloc(sizeof(Stack));
  p->data = v;
  p->next = S->next;
  S->next = p;
}

Data pop(Stack *S)
{
  if(!(S->next)) return EMPTY;
  Stack *q = S->next;
  Data rdata = q->data;
  S->next = q->next;
  free(q);
  return rdata;
}

Boolean stackEmpty(Stack *S)
{
  if(!(S->next)) return TRUE;
  else return FALSE;
}
