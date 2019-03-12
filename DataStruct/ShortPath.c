#include "include/MatrixGraph.h"
#include "include/LStack.h"

int D[VEX_NUM];  //从v0到终点vi的最短路径长度的数组
Boolean P[VEX_NUM][VEX_NUM];  //从v0出发到终点vi的最短路径映射数组

int FD[VEX_NUM][VEX_NUM]; //从v到w的最短路径代价二维数组
Boolean FP[VEX_NUM][VEX_NUM][VEX_NUM]; //保存从v到w的最短路径上的顶点u的三维数组，nice!

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

/************************************************************************************
 * 弗洛伊德算法是一个归纳定义，首先判断在顶点v和w之间是否存在弧，若<v, w>存在
 * 则设中间顶点Xk，k从0到n，n为G的总的顶点数。若<v, Xk>和<Xk, w>分别是
 * 从v到Xk和从Xk到w的中间顶点的序号<= k-1的最短路径，则将<v, Xk, w>和已经得
 * 到的从v到w且中间顶点序号<= k-1的最短路径相比较其长度最小者为当前已得到的从v到w
 * 的中间顶点序号<= k的最短路径，遍历整k的序号空间即得到当前有向网G的最短路径集
*********************************************************************************/
void shortPath_Floyd(MGraph *G)
{//求有向网G的各个顶点的最短路径的弗洛伊德算法，顶点v和w之间的最短路径FP[v][w]
 //和带权长度FD[v][w]，若FP[v][w][u]为TRUE，则u是从v到w当前求得最短
 //路径上的顶点。
	for(int v = 0; v < G->vexnum; v++)
	{//初始化FD和FP
		for(int w = 0; w < G->vexnum; w++)
		{
			FD[v][w] = G->arcs[v][w].adj;
			for(int u = 0; u < G->vexnum; u++) FP[v][w][u] = FALSE;
			if(FD[v][w] < INFINITY)
			{//从v到w有直接路径
				FP[v][w][v] = TRUE;
				FP[v][w][w] = TRUE;
			}
		}
	}

	for(int u = 0; u < G->vexnum; u++)
	{//求最短路径FP和带权长度FD，遍历k的序号空间
		for(int v = 0; v < G->vexnum; v++)
		{//遍历从v到w的二维顶点映射分布，对每一个k，求<v,Xk,w>是否更短
			for(int w = 0; w < G->vexnum; w++)
			{
				if((FD[v][u] + FD[u][w]) < FD[v][w])
				{//从v经u到w存在一条路径更短
					FD[v][w] = FD[v][u] + FD[u][w]; //更新<v,w>的带权长度
					for(int i = 0; i < G->vexnum; i++)
						//将v到w上的路径置为v到u和u到w上的路径上的所有顶点
						FP[v][w][i] = FP[v][u][i] || FP[u][w][i];
				}
			}
		}
	}
}

Status main(void)
{
	MGraph *G = (MGraph*)malloc(sizeof(MGraph));
	createGraph(G, DN);
	getShortPath(G, 0, 5);
	shortPath_Floyd(G);

	return OK;
}
