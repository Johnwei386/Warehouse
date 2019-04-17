#include "include/MatrixGraph.h"

int graph_UDN[10][3] = { //无向网
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

int graph_DN[8][3] = { //有向网
				{0, 2, 10},
				{0, 4, 30},
				{0, 5, 100},
				{1, 2, 5},
				{2, 3, 50},
				{3, 5, 10},
				{4, 3, 20},
				{4, 5, 60}
};

Status createUDN(MGraph *G)
{//创建无向网
  //初始化基本信息
  //int v,a;
  //printf("请输入图的顶点总数，弧数:\n");
  //scanf("%d %d", &v, &a);
  //if(v > VEX_NUM_UDN) return ERROR;
  G->vexnum = VEX_NUM_UDN;
  G->arcnum = ARC_NUM_UDN;

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
    v1 = graph_UDN[i][0];
    v2 = graph_UDN[i][1];
    wight = graph_UDN[i][2];
    G->arcs[v1][v2].adj = wight;
    G->arcs[v2][v1] = G->arcs[v1][v2]; //无向网保证对称
  }

  return OK;
}

Status createDN(MGraph *G)
{//创建有向图
  //初始化基本信息
  G->vexnum = VEX_NUM_DN;
  G->arcnum = ARC_NUM_DN;

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
    v1 = graph_DN[i][0];
    v2 = graph_DN[i][1];
    wight = graph_DN[i][2];
    G->arcs[v1][v2].adj = wight;
  }

  return OK;
}

Status createGraph(MGraph *G, GraphKind kind)
{//使用数组(邻接矩阵)创建图
  //printf("请输入图的类型:\n");
  //scanf("%d", &(G->kind));
  G->kind = kind;
  switch(G->kind){
	case DN: return createDN(G);   //构建有向网
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
  createGraph(G, UDN);
  DFSTraverse(G);
  printf("\n");

  return OK;
}**************************************************/
