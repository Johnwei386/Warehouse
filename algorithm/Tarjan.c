#include "Status.h"
#define VEX_NUM 8
#define ARC_NUM 13
#define UNDEFINE -1

/***********************************************************
* 使用c语言实现Tarjan算法，Tarjan算法用于从图中找到连通子图
* 本例使用Tarjan算法从一个有向图中寻找其强连通子图集合，并将其
* 输出到屏幕上。
******************************/
typedef int Number;

typedef struct ArcNode{
	Number arcvex; //这条弧的弧头
	struct ArcNode *nextarc;
}ArcNode;

typedef struct{
	//index有两个作用，1.标识访问状态，2.标识节点被访问的先后顺序
	//lowlink标识这个强连通子图的被访问到的索引最小的那个节点，也就是出发点
	Number index;
	Number lowlink;
	Boolean onStack;
	ArcNode *firstarc;
}Node;

typedef struct{
	Node *node; //节点数组
	Number vexnum,arcnum; //顶点数，弧数
}DirectGraph;

typedef struct Stack{
	int node;
	struct Stack *next;
}Stack;

int arc[ARC_NUM][2] = {
			{0,	1},
			{1,	2},
			{2,	0},
			{3,	1},
			{3,	2},
			{3,	4},
			{4,	3},
			{4,	5},
			{5,	2},
			{5,	6},
			{6,	5},
			{7,	4},
			{7,	6}
};

void initStack(Stack *S)
{
	S->node = UNDEFINE;
	S->next = NULL;
}

void push(Stack *S, int n)
{
	Stack *p = (Stack*)malloc(sizeof(Stack));
	p->node = n;
	p->next = S->next;
	S->next = p;
}

int pop(Stack *S)
{
	if(!(S->next)) return ERROR;
	Stack *p = S->next;
	int n = p->node;
	S->next = p->next;
	free(p);
	return n;	
}

Status throughNode(ArcNode **firstarc, int h)
{
	if(!(*firstarc))
	{
		*firstarc = (ArcNode*)malloc(sizeof(ArcNode));
		(*firstarc)->arcvex = h;
		(*firstarc)->nextarc = NULL;
		return OK;
 	}

	ArcNode *prenode = *firstarc;
	ArcNode *node = (*firstarc)->nextarc;
	while(node)
	{
		prenode = prenode->nextarc;
		node = node->nextarc;
	}

	node = (ArcNode*)malloc(sizeof(Node));
	node->arcvex = h;
	node->nextarc = prenode->nextarc;
	prenode->nextarc = node;

	return OK;
}

void createDG(DirectGraph *G)
{// 创建有向图
	int i;
	G->vexnum = VEX_NUM;
	G->arcnum = ARC_NUM;
	G->node = (Node*)malloc(sizeof(Node) * G->vexnum);

	//初始化顶点数组
	for(i = 0; i < G->vexnum; i++)
	{
		G->node[i].index = UNDEFINE;
		G->node[i].lowlink = UNDEFINE;
		G->node[i].onStack = FALSE;
		G->node[i].firstarc = NULL;
	}

	//初始化弧
	int h,t; //弧头和弧尾
	for(i = 0; i < G->arcnum; i++)
	{
		t = arc[i][0];
		h = arc[i][1];
		throughNode(&(G->node[t].firstarc), h);
	}
}

void strongConnect(DirectGraph *G, int i, Stack *S, int *index)
{
	G->node[i].index = *index;
	G->node[i].lowlink = *index;
	*index = (*index)+1;
	push(S, i);
	G->node[i].onStack = TRUE;
	ArcNode *arc = G->node[i].firstarc;
	int w;
	while(arc)
	{
		w = arc->arcvex;
		if(G->node[w].index == UNDEFINE){
			strongConnect(G, w, S, index);
			G->node[i].lowlink = G->node[i].lowlink > G->node[w].lowlink ? \
										G->node[w].lowlink : G->node[i].lowlink;
		}else if(G->node[w].onStack){
			G->node[i].lowlink = G->node[i].lowlink > G->node[w].index ? \
										G->node[w].index : G->node[i].lowlink;
		}

		arc = arc->nextarc;
	}

	if(G->node[i].lowlink == G->node[i].index)
	{
		do{
			w = pop(S);
			G->node[w].onStack = FALSE;
			printf("%d ", w);
		}while(S->next);
		printf("\n");
	}
}

void Tarjan(DirectGraph *G)
{//实现Tarjan算法
	int index = 0;
	Stack *S = (Stack*)malloc(sizeof(Stack));
	initStack(S);
	int i;
	for(i = 0; i < G->vexnum; i++)
	{//深度优先遍历未访问过的节点，只是这里使用index的状态来判定节点是否已被遍历
		if(G->node[i].index == UNDEFINE)
			strongConnect(G, i, S, &index);
	}
}

Status main(void)
{
	DirectGraph *G = (DirectGraph*)malloc(sizeof(DirectGraph));
	createDG(G);
	Tarjan(G);

	return OK;
}
