#include <stdio.h>
#include <stdlib.h>
#include "include/Status.h"
#define CAPCITY 10

typedef struct{
   int *base;
   size_t front;
   size_t rear;
}LNode;

Status initQueue(LNode *queue)
{
   queue->base = (int*)malloc(sizeof(int) * CAPCITY);
   queue->front = 0;
   queue->rear = 0;

   return OK;
}

Status enQueue(LNode *queue, int val)
{
   if((queue->rear + 1)%10 == (queue->front)%10)//队列已满
	return ERROR;
   *(queue->base + queue->rear) = val;
   queue->rear = (++queue->rear)%10;

   return OK;
}

int deQueue(LNode *queue)
{
  if(queue->front == queue->rear) //队列为空
	return ERROR;
  int rdata = *(queue->base + queue->front);
  queue->front = (++queue->front)%10;

  return rdata;
}

int main(void)
{
  LNode *queue = (LNode*)malloc(sizeof(LNode));
  initQueue(queue);
  for(int i=0; i<10; i++) enQueue(queue, i);
  for(int i=0; i<10; i++) printf("%d\n", deQueue(queue));

  return OK;
}
