#include "include/MatrixGraph.h"

int graph[ARC_NUM][3] = {
				{0, 1, 6}, 
				{0, 2, 1}, 
				{0, 3, 5}, 
				{1, 2, 5}, 
				{1, 4, 3}, 			 
				{2, 3, 5}, 
				{2, 4, 6}, 
				{2, 5, 4}, 
				{3, 5, 2}, 
				{4, 5, 6}
			      };

Status createUDN(MGraph *G)
{
  //初始化基本信息
  int v,a;
  printf("请输入图的顶点总数，弧数:\n");
  scanf("%d %d", &v, &a);
  if(v > VER_NUM) return ERROR;
  G->vexnum = v;
  G->arcnum = a;

  //构造顶点向量
  for(int i = 0; i < G->vexnum; i++) G->vexs[i] = i;

  //初始化邻接矩阵
  for(int i = 0; i< G->vexnum; i++){
    for(int j = 0; j< G->vexnum; j++){
       G->arcs[i][j].adj = INFINITY;
       G->arcs[i][j].info = NULL;
    }
  }

  //构建邻接矩阵
  int v1,v2,wight;
  for(int i = 0; i < G->arcnum; i++){
    //printf("请输入弧的顶点和相应的权值\n");
    //scanf("%d %d %d", &v1, &v2, &wight);
    v1 = graph[i][0];
    v2 = graph[i][1];
    wight = graph[i][2];
    G->arcs[v1][v2].adj = wight;
    G->arcs[v2][v1] = G->arcs[v1][v2]; //无向网保证对称
  }

  return OK;
}

Status createGraph(MGraph *G)
{
   //使用数组(邻接矩阵)创建图
  //printf("请输入图的类型:\n");
  //scanf("%d", &(G->kind));
  G->kind = UDN;
  switch(G->kind){
     case UDN: return createUDN(G); //构建无向网
     default: return ERROR;
  }
}

VertexType firstAdjVex(MGraph *G, VertexType v)
{//寻找顶点v的第一条临接点所在
  for(int j = 0; j < G->arcnum; j++){
     if(G->arcs[v][j].adj != INFINITY) return j;
  }
  return ERROR;
}

VertexType nextAdjVex(MGraph *G, VertexType v, VertexType w)
{//寻找v的下一条临接点所在
  for(int j = w; j < G->arcnum; j++){
     if((G->arcs[v][j].adj != INFINITY) && (j != w)) return j;
  }
  return ERROR;
}

void DFSTrave(MGraph *G, VertexType v)
{//从第v个顶点出发递归的深度优先遍历图G
  visited[v] = TRUE;
  printf("%d ", v);
  for(int w = firstAdjVex(G, v); w >= 0; w = nextAdjVex(G, v, w))
	if(!visited[w]) DFSTrave(G, w);  //对v的尚未访问的临接点w深度递归遍历
}

void DFSTraverse(MGraph *G)
{//深度优先遍历整张图G
  for(int v = 0; v < G->vexnum; v++) visited[v] = FALSE; //访问标志数组初始化
  for(int i = 0; i < G->vexnum; i++){
    if(!visited[i]) DFSTrave(G, i);   //对尚未访问的顶点进行深度遍历
  }
}

/*****************************************************************
Status main(void)
{
  MGraph *G = (MGraph*)malloc(sizeof(MGraph));
  createGraph(G);
  DFSTraverse(G);
  printf("\n");

  return OK;
}*****************************************/
