#include "include/MatrixGraph.h"

/***********************************************************************
 * 生成树是一张连通图的极小连通子图，它只有n个顶点的n-1
 * 条边。最小生成树问题指的是在n个顶点中得到其权值之和
 * 最小的n-1条边的问题，例如在n个城市之间铺设网络，每两个
 * 城市之间的网络连接的铺设费用为fn,要使这个sum(fn),n:1 -> n-1，
 * 最少，就是一个求最小生成树的问题。
 * Prim算法：
 * 1.对于无向网G，V是G的的顶点集合，U表示已被访问过的顶点，V-U
 *   表示未被访问到的顶点
 * 2.从U出发，在V-U中寻找使边<U, x>最少的那个顶点x
 * 3.将x纳入到U中，从x出发再去寻找最小边，直到V-U为空
**************************************************************/

// 记录从顶点集U到V-U的代价最小的边的辅助数组定义
typedef struct{
    VertexType      vex; //<u,v>中的u顶点
    VRType      lowcast; //该顶点所有边的权值
}auxArr;

VertexType minimum(auxArr closedge[], int size)
{
   int min = INFINITY;
   int vex = -1;
   for(int j=0; j<size; j++){
      if((closedge[j].lowcast != 0) && (min > closedge[j].lowcast)){
           vex = j;
           min = closedge[j].lowcast;
      }
   }

   return vex;
}

Status miniSpanTree_PRIM(MGraph *G, VertexType u)
{// 用普里姆算法从第u个顶点出发构造网G的最小生成树T，并输出T的各条边
 // 其中，U为已被遍历过的最小生成树的顶点集，V-U为还未被遍历过的顶点集

   //辅助数组初始化
   auxArr closedge[G->vexnum];
   for(int j = 0; j < G->vexnum; j++){
       if(j != u){
            closedge[j].vex = u;
            closedge[j].lowcast = G->arcs[u][j].adj;
       }
   }
   closedge[u].vex = u;
   closedge[u].lowcast = 0; //初始化将u放到U中，U为最小生成树的顶点集

   VertexType k = 0;
   for(int i = 1; i < G->vexnum; i++){
       k = minimum(closedge, G->vexnum); //选出与u相邻的最小权值的边的顶点
       if(k == ERROR) return ERROR;
       printf("边: <%d, %d>\n", closedge[k].vex, G->vexs[k]); //输出生成树的边
       closedge[k].lowcast = 0; //第k个顶点并入U集

       // 新顶点并入U集后更新closedge数组，以新顶点为基准，结合原来的数组,
       // 若原来数组中的权大于新顶点对应边的权，则将原数组与对应顶点的权置为
       // 该边的权。这个新的权表示到目前为止从U到V中顶点之间的最小的那条边的权值
       // 0表示该顶点已经处在U集中，它的权值最小的边已被知晓。
       for(int j = 0; j < G->vexnum; j++){
           if(closedge[j].lowcast > G->arcs[k][j].adj){
                closedge[j].vex = G->vexs[k];
                closedge[j].lowcast = G->arcs[k][j].adj;
           }
       }
   }

   return OK;
}

Status main(void)
{
  MGraph *G = (MGraph*)malloc(sizeof(MGraph));
  createGraph(G, UDN);
  miniSpanTree_PRIM(G, 0);

  return OK;
}
