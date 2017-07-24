#include "include/MatrixGraph.h"
#include "include/LStack.h"

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
				//交换列
				for(int i = 0; i < G->vexnum; i++) P[i][w] = P[i][v];
				P[w][w] = TRUE;
			}
		}
	}
	
}

Boolean singlePath(MGraph *G, int s, int d, int cost, Stack *S)
{//源点s, 终点d, 当前已知的路径代价cost, 路径堆栈S
	int n = pop(S);
	for(int i = 0; i < G->vexnum; i++)
	{
		if((i == s) || (i == n)) continue;
		if(P[n][i])
		{
			if(i == d)
			{
				cost = cost + G->arcs[n][i].adj;
				if(cost == D[d])
				{
					push(S, n);
					push(S, i);
					return TRUE;
				}else {
					return FALSE;
				}
			}else {
				cost = cost + G->arcs[n][i].adj;
				push(S, n);
				push(S, i);
				if(singlePath(G, s, d, cost, S))
				{
					return TRUE;
				}else {
					pop(S);
					cost = cost - G->arcs[n][i].adj;
				}
			}
		}
	}

	return FALSE;	
}

Boolean getShortPath(MGraph *G, int s, int d)
{//在图G中求从v点到d点的最短路径
	shortPath_DIJ(G, s); //先求以v为源点的最短路径P[v]和带权长度D[v]
	if(s == d)
	{
		printf("从%d点到%d点的最短路径为其本身\n");
		return FALSE;
	}

	if(!P[d][d])
	{
		printf("%d点和%d点无路径相通\n", s, d);
		return FALSE;
	}

	Stack *S = (Stack*)malloc(sizeof(Stack)); //保存最短路径堆栈
	initStack(S);
	for(int i = 0; i < G->vexnum; i++)
	{
		if(P[i][s])
		{// 遍历第s列，s列表示与s有直接路径的顶点集
			int cost = G->arcs[s][i].adj;
			push(S, i);
			singlePath(G, s, d, cost, S);
		}
	}

	//求得最短路径
	printf("从%d点到%d点的最短路径为(逆序)：", s, d);
	while(!stackEmpty(S)) printf("%d ", pop(S));
	printf("\n");

	return TRUE;
}

Status main(void)
{
	MGraph *G = (MGraph*)malloc(sizeof(MGraph));
	createGraph(G, DN);
	getShortPath(G, 0, 5);

	return OK;
}
