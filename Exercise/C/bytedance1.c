/********************************************************************
* 字节跳动2019年编程五道题(一)
* 输入一个矩阵，矩阵的行列数不事先给定，矩阵每个元素可取以下值：
* 0: 表示空格
* 1: 表示产品经理
* 2: 表示程序员
* 现由于业务需求，需要将产品经理转为程序员
* 输出：完成转换的最小时间
**********************************************/


#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define STLEN 1024

typedef enum{False, True} Boolean;

typedef struct Step{
    int x,y;
    int time;
}Step;

typedef struct QNode{
   Step *step;
   struct QNode *next;
}QNode;

typedef struct{
  QNode *front;
  QNode *rear;
}Queue;

int map[10][10];
int visited[10][10];
int dx[] = {-1, 1, 0, 0}; // 下移和上移
int dy[] = {0, 0, -1, 1}; // 左移和右移 

Boolean isEmpty(Queue *Q)
{
    if(Q->front == Q->rear)
        return True;
    else
        return False;
}

void initQueue(Queue *Q)
{
    QNode *head = (QNode*)malloc(sizeof(QNode));
    head->step = NULL;
    head->next = NULL;
    Q->front = head;
    Q->rear = head;
}

void push(Queue *Q, Step *step)
{
    QNode *node = (QNode*)malloc(sizeof(QNode));
    node->step = step;
    node->next = Q->rear->next;
    Q->rear->next = node;
    Q->rear = node;
}

Step* pop(Queue *Q)
{
    if(isEmpty(Q)) return NULL;
    QNode *node = Q->front->next;
    Step *step = node->step;
    Q->front->next = node->next;
    if(node == Q->rear)
        Q->rear = Q->front;
    free(node);
    return step;
}

Step* goStep(int x, int y, int time)
{
    Step *step = (Step*)malloc(sizeof(Step));
    step->x = x;
    step->y = y;
    step->time= time;
    return step;
}

int main(void)
{
	int m = 0, n = 0, k = 0;
	int mintime;
	char *buff = (char*)malloc(sizeof(char) * STLEN);
	while(NULL != fgets(buff, STLEN, stdin) && buff[0] != '\n'){
		k = strlen(buff);
		n = 0;
		for(int i = 0; i < k; i++){
			// 除去空格符和换行符
			if(buff[i] != 0x20 && buff[i] != 0x0a){
				map[m][n] = atoi(buff+i);
				n++;
			}
		}
		m++;
	}
	//printf("%d %d\n", m, n);
	
	if(map[0][0] == 0){
		printf("The original spot is NULL.\n");
		return -1;
	}
	
	Step *origin = (Step*)malloc(sizeof(Step));
    Queue *Q = (Queue*)malloc(sizeof(Queue));
    initQueue(Q);
    
    // 设置(0,0)为出发点
    origin->x = 0;
    origin->y = 0;
    origin->time = 0;
    if(map[origin->x][origin->y] == 1){// 入口点为产品经理
    	map[origin->x][origin->y] = 2; // 将产品经理转换为程序员
    	origin->time = 1; // 出发点完成第一次转换
    }
    mintime = origin->time;
    visited[origin->x][origin->y] = 1;
    
    push(Q, origin);
    Step *p;
    while(!isEmpty(Q)){
    	p = pop(Q);
    	//if(p->time > mintime) mintime = p->time;
    	mintime = p->time;
    	printf("current spot:(%d %d)-time:%d\n", p->x, p->y, p->time);
    	for(int i = 0; i < 4; i++) {
    		int xx = p->x + dx[i], yy = p->y + dy[i];
    		if( xx < 0 || xx >= m || yy < 0 || yy >= n || map[xx][yy] == 0 || visited[xx][yy]) continue;
    		if(map[xx][yy] == 1){ // 下一点为程产品经理,则需要作一次转换
    			Step *nstep = goStep(xx, yy, p->time + 1);
            	push(Q, nstep);
    			visited[xx][yy] = 1; // 该点已被访问
    		} else{ // 下一点为程程序员,则不需要作任何转换
    			Step *nstep = goStep(xx, yy, p->time);
            	push(Q, nstep);
    			visited[xx][yy] = 1; // 该点已被访问
    		}
    	}
    } 
	printf("\nminimum time spent: %d \n", mintime);
	
	return 0;
}
