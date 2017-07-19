#include "include/ListGraph.h"

int arc[ARC_NUM][3] = {
			{0, 1, 0},
			{0, 2, 0},
			{0, 3, 0},
			{2, 1, 0},
			{2, 4, 0},
			{3, 4, 0},
			{5, 3, 0},
			{5, 4, 0}
};

Status throughNode(ArcNode **firstarc, int h, int cost)
{
   if(!(*firstarc))
    {
      *firstarc = (ArcNode*)malloc(sizeof(ArcNode));
	(*firstarc)->adjvex = h;
	(*firstarc)->cost = cost;
	(*firstarc)->nextarc = NULL;
      return OK;
    }
   ArcNode* prenode = *firstarc;
   ArcNode* node = (*firstarc)->nextarc;
   while(node)
    {
      prenode = prenode->nextarc;
      node = node->nextarc;
    }
   node = (ArcNode*)malloc(sizeof(ArcNode));
   node->adjvex = h;
   node->cost = cost;
   node->nextarc = prenode->nextarc;
   prenode->nextarc = node;

   return OK;
}

Status createDG(ALGraph *G)
{//创建有向图
   //printf("请输入图的顶点数和弧数:\n");
   //scanf("%d %d", &(G->vexnum), &(G->arcnum));
   printf("创建有向图\n");
   G->vexnum = VEX_NUM;
   G->arcnum = ARC_NUM;
   G->vertices = (VNode*)malloc(sizeof(VNode) * G->vexnum);

   //初始化顶点数组
   for(int i=0; i < G->vexnum; i++){
      G->vertices[i].info = NULL;
      G->vertices[i].firstarc = NULL;
   }

   //初始化弧
   int t,h,cost;
   for(int j=0; j < G->arcnum; j++){
      t = arc[j][0];
      h = arc[j][1];
      cost = arc[j][2];
      throughNode(&(G->vertices[t].firstarc), h, cost);
   }

  return OK;
}

Status createDN(ALGraph *G)
{//创建有向网
   printf("创建有向网\n");
   G->vexnum = VEX_NUM;
   G->arcnum = ARC_NUM;
   G->vertices = (VNode*)malloc(sizeof(VNode) * G->vexnum);

   //初始化顶点数组
   for(int i=0; i < G->vexnum; i++){
      G->vertices[i].info = NULL;
      G->vertices[i].firstarc = NULL;
   }

   //初始化弧
   int t,h,cost;
   for(int j=0; j < G->arcnum; j++){
      t = arc[j][0];
      h = arc[j][1];
      cost = arc[j][2];
      throughNode(&(G->vertices[t].firstarc), h, cost);
   }

  return OK;
}

Status createGraph(ALGraph *G)
{
   //printf("请输入图的类型：\n");
   //scanf("%d", &(G->kind));
   G->kind = DN;
   switch(G->kind){
      case DG: return createDG(G);  //构建有向图
      case DN: return createDN(G);  //构建有向网
      default: return ERROR;
   }
}

VexType firstAdjVex(ALGraph *G, VexType u)
{
   if(!(G->vertices[u].firstarc))
	 return ERROR;
   else
	 return (G->vertices[u].firstarc)->adjvex;
}

VexType nextAdjVex(ALGraph *G, VexType u, VexType pre)
{
   ArcNode* node = G->vertices[u].firstarc;
   while(node->nextarc)
   {
      if(node->adjvex == pre) return node->nextarc->adjvex;
	node = node->nextarc;
   }

   return ERROR;
}

void BFSTraverse(ALGraph *G)
{// 广度优先遍历图G
   printf("广度优先遍历序列： ");
   for(int i = 0; i < G->vexnum; i++) visited[i] = FALSE;
   LinkQueue *Q = (LinkQueue*)malloc(sizeof(LinkQueue));
   initQueue(Q);
   for(int v = 0; v < G->vexnum; v++)
   {
      if(!visited[v])
       {
	  visited[v] = TRUE;
	  printf("%d ", v);
	  enQueue(Q, v);
	  int u;
	  while(!isQueueEmpty(Q)){
	     u = deQueue(Q);
	     for(int w = firstAdjVex(G, u); w >= 0; w = nextAdjVex(G, u, w)){
		 if(!visited[w]){
		    visited[w] = TRUE;
		    printf("%u ", w);
		    enQueue(Q, w);
		 }
	      } 
	  }
       }   
   }
}

/*********************************************************************
Status main(void)
{
   ALGraph *G = (ALGraph*)malloc(sizeof(ALGraph));
   createGraph(G);
   BFSTraverse(G);
   printf("\n");

   return OK;
}
***********************************************************/
