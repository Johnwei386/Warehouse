#include <stdio.h>
#include <stdlib.h>
#include "include/Status.h"
#include "include/Queue.h"
#define VEX_NUM 8
#define ENDNODE -1

typedef enum {DG, DN, UDG, UDN} GraphKind;  //{有向图，有向网，无向图，无向网}
typedef int VexType;

typedef struct ArcNode{
    VexType    adjvex;          //弧头所在的顶点的位置
    struct ArcNode  *nextarc;   //指向下一条弧的指针
    char*  info;                //该弧的相关信息
}ArcNode;

typedef struct {
    char*  info;                 //顶点的相关信息
    ArcNode *firstarc;           //指向第一条依附该顶点的弧的指针
}VNode;

typedef struct {
    VNode          *vertices;         //顶点数组
    int            vexnum, arcnum;   //图的当前顶点数和弧数
    GraphKind      kind;             //图的种类标识
}ALGraph;

Boolean visited[VEX_NUM];

int arc[9][2] = {
			{0, 1},
			{0, 2},
			{1, 3},
			{1, 4},
			{2, 5},
			{2, 6},
			{3, 7},
			{4, 7},
			{5, 7}
};

void throughNode(ArcNode* node, int h)
{
   while(node->nextarc) node = node->nextarc;
   node->adjvex = h;
   node->nextarc = (ArcNode*)malloc(sizeof(ArcNode));
   node->nextarc->adjvex = ENDNODE;
   node->nextarc->info = NULL;
   node->nextarc->nextarc = NULL;
}

Status createDG(ALGraph *G)
{
   //printf("请输入图的顶点数和弧数:\n");
   //scanf("%d %d", &(G->vexnum), &(G->arcnum));
   G->vexnum = 8;
   G->arcnum = 9;
   G->vertices = (VNode*)malloc(sizeof(VNode) * G->vexnum);

   //初始化顶点数组
   for(int i=0; i < G->vexnum; i++){
      G->vertices[i].info = NULL;
      G->vertices[i].firstarc = (ArcNode*)malloc(sizeof(ArcNode));
      (G->vertices[i].firstarc)->nextarc = NULL;
      (G->vertices[i].firstarc)->info = NULL;
   }

   //初始化弧
   int t,h;
   for(int j=0; j < G->arcnum; j++){
      //printf("请输入弧尾和弧头:\n");
      //scanf("%u %u", &t, &h);
      t = arc[j][0];
      h = arc[j][1];
      throughNode(G->vertices[t].firstarc, h);
   }

  return OK;
}

Status createGraph(ALGraph *G)
{
   //printf("请输入图的类型：\n");
   //scanf("%d", &(G->kind));
   G->kind = DG;
   switch(G->kind){
      case DG: return createDG(G);  //构建有向图
      default: return ERROR;
   }
}

VexType firstAdjVex(ALGraph *G, VexType u)
{
   return (G->vertices[u].firstarc)->adjvex;
}

VexType nextAdjVex(ALGraph *G, VexType u, VexType pre)
{
   ArcNode* node = G->vertices[u].firstarc;
   while(node->nextarc){
      if((node->adjvex == pre) && (node->nextarc->adjvex != ENDNODE))
	   return node->nextarc->adjvex;
	node = node->nextarc;
   }
   return ERROR;
}

void BFSTraverse(ALGraph *G)
{
   for(int i = 0; i < G->vexnum; i++) visited[i] = FALSE;
   LinkQueue *Q = (LinkQueue*)malloc(sizeof(LinkQueue));
   initQueue(Q);
   for(int v = 0; v < G->vexnum; v++){
      if(!visited[v]){
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

Status main(void)
{
   ALGraph *G = (ALGraph*)malloc(sizeof(ALGraph));
   createGraph(G);
   BFSTraverse(G);
   printf("\n");

   return OK;
}
