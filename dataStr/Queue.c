#include "include/Queue.h"

Status initQueue(LinkQueue *Q)
{
   QNodePtr head = (QNodePtr)malloc(sizeof(QNode));
   head->next = NULL;
   Q->front = head;
   Q->rear = head;

   return OK;
}

Status enQueue(LinkQueue *Q,int e)
{
   QNodePtr node = (QNodePtr)malloc(sizeof(QNode));
   node->elem = e;
   node->next = Q->rear->next;
   Q->rear->next = node;
   Q->rear = node;

   return OK;
}

Data deQueue(LinkQueue *Q)
{
   if(isQueueEmpty(Q)) //队列为空
	return ERROR;
   QNodePtr node = Q->front->next;
   int rdata = node->elem;
   if(node == Q->rear) //若所出队列元素为最后一个元素，则将队列清空
	Q->front = Q->rear;
   Q->front->next = node->next;
   free(node);
   return rdata;
}

Boolean isQueueEmpty(LinkQueue *Q)
{
   if(Q->front == Q->rear) return TRUE;
   else return FALSE;
}

/**************************************************************************
Status main(void)
{
  LinkQueue *Queue = (LinkQueue*)malloc(sizeof(LinkQueue));
  initQueue(queue);
  for(int i=0; i<10; i++) enQueue(queue, i);
  for(int i=0; i<10; i++) printf("%d\n",deQueue(queue));

  return OK;
}**********************************/
