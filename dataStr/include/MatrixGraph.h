#ifndef _MATRIXGRAPH_H
#define _MATRIXGRAPH_H
# include <stdio.h>
# include <stdlib.h>
# include "Status.h"
# define INFINITY  888 //无穷大，无相邻关系
# define VER_NUM 6 //顶点数目
# define ARC_NUM 10

typedef int VRType;
typedef int VertexType;
typedef enum{DG, DN, UDG, UDN} GraphKind; //{有向图，有向网，无向图，无向网}

typedef struct ArCell{
   VRType  adj;  //顶点关系类型,对应弧的权值
   char*   info; //该弧相关信息的指针
}ArCell, AdjMatrix[VER_NUM][VER_NUM];

typedef struct{
  VertexType  vexs[VER_NUM];     // 顶点向量
  AdjMatrix   arcs;              // 邻接矩阵
  int  	 vexnum, arcnum;    // 图的当前顶点数和弧数
  GraphKind   kind;	       // 图的种类标识
}MGraph;

Boolean visited[VER_NUM];   //定义标志数组

Status createUDN(MGraph *G);
Status createGraph(MGraph *G);
VertexType firstAdjVex(MGraph *G, VertexType v);
VertexType nextAdjVex(MGraph *G, VertexType v, VertexType w);
void DFSTrave(MGraph *G, VertexType v);
void DFSTraverse(MGraph *G);

#endif
