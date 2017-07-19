#include "include/ListGraph.h"
#include "include/LStack.h"
int indegree[VEX_NUM]; //顶点入度计数数组

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
			printf("%d ", v);
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
						printf("%u ", w);
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

Status main(void)
{
	ALGraph *G = (ALGraph*)malloc(sizeof(ALGraph));
	createGraph(G);
	topologicalSort(G);
	printf("\n");

	return OK;
}
