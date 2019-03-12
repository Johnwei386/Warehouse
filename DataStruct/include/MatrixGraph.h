#ifndef _MATRIXGRAPH_H
#define _MATRIXGRAPH_H
#include <stdio.h>
#include <stdlib.h>
#include "Status.h"
#define INFINITY  8888 //无穷大，无相邻关系
#define VEX_NUM_UDN 6  //无向图的顶点数和弧数
#define ARC_NUM_UDN 10
#define VEX_NUM_DN 6   //有向图的顶点数和弧数
#define ARC_NUM_DN 8

#define __KIND 1
#if __KIND == 0
#define VEX_NUM VEX_NUM_UDN
#elif __KIND == 1
#define VEX_NUM VEX_NUM_DN
#else
#define VEX_NUM 6
#endif

typedef int VRType;
typedef int VertexType;
typedef enum{DG, DN, UDG, UDN} GraphKind; //{有向图，有向网，无向图，无向网}

typedef struct ArCell{
   VRType  adj;  //顶点关系类型,对应弧的权值
   char*   info; //该弧相关信息的指针
}ArCell, AdjMatrix[VEX_NUM][VEX_NUM];

typedef struct{
  VertexType  vexs[VEX_NUM];     // 顶点向量
  AdjMatrix   arcs;              // 邻接矩阵
  int  	 vexnum, arcnum;    // 图的当前顶点数和弧数
  GraphKind   kind;	       // 图的种类标识
}MGraph;

Boolean visited[VEX_NUM];   //定义标志数组

Status createUDN(MGraph *G);
Status createDN(MGraph *G);
Status createGraph(MGraph *G, GraphKind kind);
VertexType firstAdjVex(MGraph *G, VertexType v);
VertexType nextAdjVex(MGraph *G, VertexType v, VertexType w);
void DFSTrave(MGraph *G, VertexType v);
void DFSTraverse(MGraph *G);

#endif
