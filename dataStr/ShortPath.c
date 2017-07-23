#include "include/MatrixGraph.h"

int D[VEX_NUM];  //从v0到终点vi的最短路径长度的数组
Boolean P[VEX_NUM][VEX_NUM];  //从v0出发到终点vi的最短路径映射数组

void shortPath_DIJ(MGraph *G, int v0)
{//用Dijkstra算法求有向网G的v0到其余顶点v的最短路径P[v]和带权长度D[v]
	Boolean final[G->vexnum]; //final为状态数组，final[v]为真，表示已求得从v0到v的最短路径
	for(int i = 0; i < G->vexnum; i++)
	{
		final[i] = FALSE;
		D[i] = G->arcs[v0][i].adj;
		for(int j = 0; j < G->vexnum; j++) P[i][j] = FALSE; //初始化为空路径
		if(D[i] < INFINITY)
		{
			P[i][v0] = TRUE; //v0和vi之间存在路径，vi为路径上的点
			P[i][i] = TRUE;  //对角线置为真，vi与v0有路径相通，其本身也可成为路径上的点
		}
	}

	//初始化v0顶点，v0为已经找到最短路径的顶点
	D[v0] = 0;
	final[v0] = TRUE;

	//主循环，每次求得v0到vi顶点的最短路径和代价
	//设S为已求得最短路径的终点v的集合，则置final[v]为TRUE则是将v加入到S集中
	int v,min;
	for(int i = 1; i < G->vexnum; i++)
	{//遍历vexnum-1次是求除v0外剩下的各个顶点为终点时的最短路径和代价
		min = INFINITY;
		for(int w = 0; w < G->vexnum; w++)
		{
			if(!final[w])	//w顶点在V-S中
			{
				if(D[w] < min)
				{
					v = w; 
					min = D[w];
				}
			}
		}

		final[v] = TRUE; //离顶点v0最近的v加入S集

		for(int w = 0; w < G->vexnum; w++)
		{//更新当前最短路径及距离
			if(!final[w] && ((min + G->arcs[v][w].adj) < D[w]))
			{
				D[w] = min + G->arcs[v][w].adj;
				for(int i = 0; i < G->vexnum; i++) P[w][i] = P[v][i];
				P[w][w] = TRUE;
			}
		}
	}
	
}

Status main(void)
{
	MGraph *G = (MGraph*)malloc(sizeof(MGraph));
	createGraph(G, DN);

	return OK;
}
