#include "include/ListGraph.h"
#include "include/LStack.h"
int indegree[VEX_NUM]; //顶点入度计数数组
int ve[VEX_NUM];	 //保存各顶点事件的最早发生时间数组

Status findIndegree(ALGraph *G)
{
	for(int i=0; i<VEX_NUM; i++) indegree[i] = 0;    //入度计数数组初始化
	for(int j=0; j<VEX_NUM; j++) visited[j] = FALSE; //访问数组初始化

	//对图G进行广度优先遍历，获知其每个顶点的入度数
	LinkQueue *Q = (LinkQueue*)malloc(sizeof(LinkQueue));
	initQueue(Q);
	for(int v = 0; v < G->vexnum; v++)
	{
		if(!visited[v])
		{
			visited[v] = TRUE;
			//printf("%d ", v);
			enQueue(Q, v);
			int u;
			while(!isQueueEmpty(Q))
			{
				u = deQueue(Q);
				for(int w = firstAdjVex(G, u); w >= 0; w = nextAdjVex(G, u, w))
				{
					if(!visited[w])
					{
						visited[w] = TRUE;
						//printf("%u ", w); //输出广度优先遍历序列
						enQueue(Q, w);
					}
					indegree[w]++; //弧头为入度，将对应顶点的入度数加1
				} 
			}
		}   
	}
	return OK;
}

Status topologicalSort(ALGraph *G)
{// 求G的拓扑排序, 将其用堆栈返回
	printf("广度优先遍历序列：");
	findIndegree(G);
	printf("\n");
	Stack *S = (Stack*)malloc(sizeof(Stack));
	initStack(S);
	for(int i = 0; i < G->vexnum; i++)
	{//建零入度顶点栈S
		if(!indegree[i]) push(S, i); //入度为0者进栈，即该顶点无前驱
	}
	int count = 0; //对输出顶点计数
	int i,k;
	printf("拓扑有序序列：");
	while(!stackEmpty(S))
	{
		i = pop(S);
		printf("%d ", i); //输出拓扑有序序列
		count++;
		for(ArcNode *p = G->vertices[i].firstarc; p; p = p->nextarc)
		{
			k = p->adjvex; //对i号顶点的每个临接点的入度减1
			if(!(--indegree[k])) push(S, k); //若入度减为0，则入栈
		}
	}

	if(count < G->vexnum)  //该有向图存在回路
		return ERROR;
	else
		return OK;
	
}

Boolean topologicalOrder(ALGraph *G, Stack *T)
{//求各顶点事件的最早发生时间ve和拓扑有序序列T，T为拓扑序列顶点栈
	findIndegree(G);
	Stack *S = (Stack*)malloc(sizeof(Stack));
	initStack(S);
	for(int i = 0; i < G->vexnum; i++)
	{//建零入度顶点栈S
		if(!indegree[i]) push(S, i); //入度为0者进栈，即该顶点无前驱
	}
	initStack(T); //初始化T
	int count = 0; //计数变量初始化为0
	for(int i = 0; i < G->vexnum; i++)
	{// 初始化ve数组
		ve[i] = 0;
	}
	int i,k;
	while(!stackEmpty(S))
	{
		i = pop(S);
		push(T, i); //得到一个逆拓扑排序序列的堆栈
		count++;
		for(ArcNode *p = G->vertices[i].firstarc; p; p = p->nextarc)
		{
			k = p->adjvex; //对i号顶点的每个邻接点的入度减1
			if(--indegree[k] == 0) push(S, k); //若入度减为0，则入栈
			//该顶点上的ve值加这条出度弧的持续时间是否比它下一条邻接顶点的ve值大，
			//当有多条出度弧时，只取最晚发生的那条邻接弧
			//从前向后看的角度来看待工程流
			if((ve[i] + p->cost) >  ve[k])
				//保存下一条邻接顶点的最早开始时间
				//它为前一个顶点的最早开始时间加上这条邻接弧的持续时间
				ve[k] = ve[i] + p->cost;
			
		}
	}

	if(count < G->vexnum)  //该有向图存在回路
	{
		//printf("该有向图存在回路\n");
		return FALSE;
	} else{
		return TRUE;
	}
}

int getMaxTime(int time[], int size)
{
	int max = 0;
	for(int i=0; i<size; i++)
	{
		if(time[i] > max) max = time[i];
	}
	return max;
}

Status criticalPath(ALGraph *G, Stack *T)
{//输出有向网G的各项关键活动，得到G的一条关键路径
	if(!topologicalOrder(G, T)) return ERROR;
	int vl[G->vexnum]; //声明顶点事件的最迟发生时间数组
	for(int i = 0; i < G->vexnum; i++)
		vl[i] = getMaxTime(ve, G->vexnum); //vl初始化为ve中的最大值，即最长的开始时间
	int j,k;
	while(!stackEmpty(T))
	{
		j = pop(T);
		for(ArcNode *p = G->vertices[j].firstarc; p; p = p->nextarc)
		{
			k = p->adjvex;
			//建立vl，vl只取最迟发生时间最早的那条邻接弧
			//从后向前看的角度来观察工程流，最迟开始时间最早
			//它到这个时间必须开始，而比它晚的可以晚点开始
			if((vl[k] - p->cost) < vl[j]) vl[j] = vl[k] - p->cost;
		}
	}

	//输出ve和vl
	printf("ve = ");
	for(int i = 0; i < G->vexnum; i++) printf("%d ", ve[i]);
	printf("\n");
	printf("vl = ");
	for(int i = 0; i < G->vexnum; i++) printf("%d ", vl[i]);
	printf("\n");
	//输出关键路径，关键路径上的所有活动皆为关键活动
	printf("关键路径：");
	int u,ee,el;
	for(int j = 0; j < G->vexnum; j++)
	{
		/******************************************************************************
		for(ArcNode *p = G->vertices[j].firstarc; p; p = p->nextarc)
		{
			u = p->adjvex;
			ee = ve[j];
			el = vl[u] - p->cost;
			if(ee == el) printf("%d => ", j);
		}
		*****************************************************/
		if(ve[j] == vl[j]) printf("%d ", j);
	}
	printf("\n");

	return OK;
}

Status main(void)
{
	ALGraph *G = (ALGraph*)malloc(sizeof(ALGraph));
	Stack *T = (Stack*)malloc(sizeof(Stack));
	createGraph(G);
	//topologicalSort(G);
	//printf("\n");
	criticalPath(G, T);

	return OK;
}
