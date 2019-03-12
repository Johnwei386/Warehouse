#include <stdio.h>
#include <stdlib.h>
#include "Status.h"

#define INFINITY 8888
#define MAX_VER 8
#define VALID_ARC_NUM 12

/*
 * 求解一个正方体使用四种颜色来染色每一个顶点的一个解，任意两个相邻顶点不能同色
*/

typedef struct{
	int inode;
	char color;
}VERTICE;

typedef struct{
	int weight;
}ARC[MAX_VER][MAX_VER];

typedef struct{
	VERTICE vers[MAX_VER];
	ARC arcs;
	int ver_num, arc_num;
}CUBE;

typedef struct Qnode{
	int adjArc;
	struct Qnode *next;
}Qnode;

typedef struct Queue{
	Qnode *front;
	Qnode *rear;
}Queue;

int Valid_Arcs[VALID_ARC_NUM][3]={ //定义正方体的边
	{1,		2,		0},
	{1,		3,		0},
	{1,		5,		0},
	{2,		4,		0},
	{2,		6,		0},
	{3,		4,		0},
	{3,		8,		0},
	{5,		6,		0},
	{5,		8,		0},
	{4,		7,		0},
	{6,		7,		0},
	{7,		8,		0}
}; 

Boolean visited[MAX_VER]; //是否访问了顶点
Boolean vcolor[4] = {FALSE, FALSE, FALSE, FALSE}; //是否访问了颜色数组的值
char color[4] = {'a', 'b', 'c', 'd'}; //定义颜色值数组

void initialQueue(Queue *Q)
{
	Qnode *head = (Qnode*)malloc(sizeof(Qnode));
	head->adjArc = -1;
	head->next = NULL;
	Q->front = head;
	Q->rear = head;
}

Boolean isQEmpty(Queue *Q)
{
	if(Q->front == Q->rear)
		return TRUE;
	else
		return FALSE;
}

void enQueue(Queue *Q, int adj)
{
	Qnode *P = (Qnode*)malloc(sizeof(Qnode));
	P->adjArc = adj;
	P->next = Q->rear->next;
	Q->rear->next = P;
	Q->rear = P;
}

int deQueue(Queue *Q)
{
	if(isQEmpty(Q))
		return ERROR;
	Qnode *P = Q->front->next;
	int e = P->adjArc;
	Q->front->next = P->next;
	if(P == Q->rear) //若所出队列元素为最后一个元素，则将队列清空
		Q->rear = Q->front;
	free(P);
	return e;
}

void initialCube(CUBE *cube)
{
	// 初始化立方体的顶点
	cube->ver_num = MAX_VER;
	cube->arc_num = VALID_ARC_NUM * 2;

	//初始化顶点集
	int i,j;
	for(i = 0; i < cube->ver_num; i++)
	{
		cube->vers[i].inode = i + 1;
		cube->vers[i].color = 'n'; //n表示NULL，空颜色，无颜色
	}

	//初始化弧集
	for(i = 0; i < cube->ver_num; i++)
	{
		for(j = 0; j < cube->ver_num; j++)
		{
			cube->arcs[i][j].weight = INFINITY;
		}
	}

	//构建这个正方体的边，若两个顶点之间没有连线，则二者之间的权值为无穷
	int head,tail;
	for(i = 0; i < VALID_ARC_NUM; i++)
	{
		tail = Valid_Arcs[i][0] - 1;
		head = Valid_Arcs[i][1] - 1;
		cube->arcs[tail][head].weight = Valid_Arcs[i][2];
		cube->arcs[head][tail].weight = cube->arcs[tail][head].weight;
	}
}

char getColor(char t, Boolean vcolor[], int size)
{//得到与出发点不同的相邻点的染色值
	int i,j;
	for(i = 0; i < size; i++){
		if(t == color[i])
			break;
	}

	for(j = 0; j < size; j++)
	{
		if(j == i) 
			continue;
		if(!vcolor[j]){
			vcolor[j] = TRUE;
			break;
		}
	}

	return color[j];
}

void resetVcolor(Boolean vcolor[], int size)
{//重置颜色访问数组，为下一个顶点的广度遍历做准备
	int i;
	for(i = 0; i < size; i++)
		vcolor[i]=FALSE;
}

Status dyeCube(CUBE *cube)
{//对一个正方体求一个四色问题的解，颜色值分别是a、b、c、d
	int i,n;
	for(i = 0; i < cube->ver_num; i++)	visited[i]=FALSE; //初始化访问数组
	Queue *Q = (Queue*)malloc(sizeof(Queue));
	initialQueue(Q); //设置队列，用于广度优先

	//由于正方体不存在孤立的子顶点，故广度优先遍历绝对能遍历完所有顶点
	cube->vers[0].color = 'a'; //设置第1个顶点的颜色值为a
	enQueue(Q, cube->vers[0].inode); //将从第1个顶点开始遍历
	while(!isQEmpty(Q))
	{
		n = deQueue(Q) - 1;
		if(!visited[n])
		{
			visited[n] = TRUE;
			for(i = 0; i < cube->ver_num; i++)
			{
				if(cube->arcs[n][i].weight != INFINITY)
				{
					//若相邻点的颜色值为空，则需设置它的值
					if(cube->vers[i].color == 'n'){
						cube->vers[i].color = getColor(cube->vers[n].color, vcolor, 4);
					}else if(cube->vers[n].color == cube->vers[i].color){
						//当邻接顶点的颜色值与出发点一样时，需要更改该相邻点的颜色值
						cube->vers[i].color = getColor(cube->vers[n].color, vcolor, 4);
					}
					enQueue(Q, i+1);
				}
			}
		}
		resetVcolor(vcolor, 4);
	}
}

Status main(void)
{
	CUBE *cube = (CUBE*)malloc(sizeof(CUBE));
	initialCube(cube);
	dyeCube(cube);
	int i;
	for(i = 0; i < cube->ver_num; i++)
		printf("%d %c\n", i+1, cube->vers[i].color);

	return OK;
}
