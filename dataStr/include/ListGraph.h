#ifndef _LISTGRAPH_H
#define _LISTGRAPH_H

#include <stdio.h>
#include <stdlib.h>
#include "Status.h"
#include "Queue.h"
#define VEX_NUM 6
#define ARC_NUM 8

typedef int VexType;
typedef enum {DG, DN, UDG, UDN} GraphKind;  //{有向图，有向网，无向图，无向网}

typedef struct ArcNode{
    VexType    adjvex;          //弧头所在的顶点的位置
    int        cost;            //该弧的代价
    struct ArcNode  *nextarc;   //指向下一条弧的指针
}ArcNode;

typedef struct {
    char*  info;                 //顶点的相关信息
    ArcNode *firstarc;           //指向第一条依附该顶点的弧的指针
}VNode;

typedef struct {
    VNode          *vertices;        //顶点数组
    int            vexnum, arcnum;   //图的当前顶点数和弧数
    GraphKind      kind;             //图的种类标识
}ALGraph;

Boolean visited[VEX_NUM];

Status throughNode(ArcNode **firstarc, int h, int cost);
Status createDG(ALGraph *G);
Status createDN(ALGraph *G);
Status createGraph(ALGraph *G);
VexType firstAdjVex(ALGraph *G, VexType u);
VexType nextAdjVex(ALGraph *G, VexType u, VexType pre);
void BFSTraverse(ALGraph *G);

#endif
