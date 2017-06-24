#ifndef _QUEUE_H
#define _QUEUE_H
# include <stdio.h>
# include <stdlib.h>
# include "Status.h"
typedef int Data;

typedef struct QNode{
   Data elem;
   struct QNode *next;
}QNode,*QNodePtr;

typedef struct{
  QNodePtr front;
  QNodePtr rear;
}LinkQueue;

Status initQueue(LinkQueue *q);
Status enQueue(LinkQueue *q, int e);
Data deQueue(LinkQueue *q);
Boolean isQueueEmpty(LinkQueue *Q);

#endif
