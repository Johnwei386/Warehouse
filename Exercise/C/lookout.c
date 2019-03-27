#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/*********************************************************************************
* 假设一个探险家被困在了地底的迷宫之中，要从当前位置开始找到一条通往迷宫出口的路径。迷宫可以用一个
* 二维矩阵组成，有的部分是墙，有的部分是路。迷宫之中有的路上还有门，每扇门都在迷宫的某个地方有与之
* 匹配的钥匙，只有先拿到钥匙才能打开门。请设计一个算法，帮助探险家找到脱困的最短路径。如前所述，迷
* 宫是通过一个二维矩阵表示的，每个元素的值的含义如下 0-墙，1-路，2-探险家的起始位置，3-迷宫的出口，
* 大写字母-门，小写字母-对应大写字母所代表的门的钥匙。
* 输入：
* 5 5      矩阵的行和列
* 02111    矩阵的具体值
* 01a0A
* 01003
* 01001
* 01111
******************************************************************************/

typedef enum{False, True} Boolean;

typedef struct Step{
    int x,y;
    int status;
    int dis;
}Step;

typedef struct QNode{
   Step *step;
   struct QNode *next;
}QNode;

typedef struct{
  QNode *front;
  QNode *rear;
}Queue;

int m, n, knum; // m:行，n:列
/*char map[5][5] = {{'0', '2', '1', '1', '1'},
                  {'0', '1', 'a', '0', 'A'},
                  {'0', '1', '0', '0', '3'},
                  {'0', '1', '0', '0', '1'},
                  {'0', '1', '1', '1', '1'}};*/
char map[6][10] = {{'a', '1', '1', '0', '0', '0', '0', '0', '1', '1'},
                   {'0', '0', '2', '1', '1', '1', '1', '1', '1', '0'},
                   {'1', '1', '1', '0', '1', '0', '0', '0', 'A', '0'},
                   {'1', '0', '0', '1', '1', '0', '0', '1', '1', '1'},
                   {'1', '0', '0', 'B', '0', '0', '0', '1', '0', '1'},
                   {'1', '1', '0', '3', '0', '0', '0', '1', 'b', '1'}};
int visit[1024][101][101]; // 一定要定义在静态存储空间!!!
int dx[] = {-1, 1, 0, 0}; // 下移和上移
int dy[] = {0, 0, -1, 1}; // 左移和右移 

void initQueue(Queue *Q)
{
    QNode *head = (QNode*)malloc(sizeof(QNode));
    head->step = NULL;
    head->next = NULL;
    Q->front = head;
    Q->rear = head;
}

Boolean isEmpty(Queue *Q)
{
    if(Q->front == Q->rear)
        return True;
    else
        return False;
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

Step* goStep(int x, int y, int status, int dis)
{
    Step *step = (Step*)malloc(sizeof(Step));
    step->x = x;
    step->y = y;
    step->status = status;
    step->dis = dis;
    return step;
}

int main()
{
    m = 6; n = 10; knum = 3;
      
    Step *origin = (Step*)malloc(sizeof(Step));
    Queue *Q = (Queue*)malloc(sizeof(Queue));
    initQueue(Q);

    // scanf("%d %d", &m, &n);
    /*for(int k = 0; k < knum; k++) 其实编译器会置初始值0
        for(int i = 0; i < m; i++)
            for(int j = 0; j < n; j++) visit[k][i][j] = 0;*/

    for(int i = 0; i < m; i++){
        for(int j = 0; j < n; j++){
            // scanf(" %c", &map[i][j]); // %c前面的空格就是用来屏蔽空白符的
            if(map[i][j] == '2'){ // 起点
                origin->x = i;
                origin->y = j;
                origin->status = 0;
                origin->dis = 0;
                goto loop;
            }
        }
    }

    loop:;  
    visit[0][origin->x][origin->y] = 1;
    /*for(int k = 0; k < knum; k++){
        for(int i = 0; i < m; i++){
            for(int j = 0; j < n; j++) printf("%d", visit[k][i][j]);
            printf("\n");
        }
        printf("\n");
    }
    return 0;*/

    push(Q, origin);
    Step *p;
    while(!isEmpty(Q)){
        p = pop(Q);
        printf("%d %d %d %d\n\n", p->status, p->x, p->y, p->dis );
        if(map[p->x][p->y] == '3'){
            printf("%d\n", p->dis);
            break;
        }
        
        for(int i = 0; i < 4; i++) {
            int xx = p->x + dx[i], yy = p->y + dy[i];
            if( xx < 0 || xx >= m || yy < 0 || yy >= n || map[xx][yy] == '0' || visit[p->status][xx][yy]) continue;
            if( map[xx][yy] >= 'A' && map[xx][yy] <= 'Z') {
                if(p->status & (1 << (map[xx][yy] - 'A')) )
                {
                    visit[p->status][xx][yy] = 1;
                    Step *step = goStep(xx, yy, p->status, p->dis + 1);
                    push(Q, step);
                    // printf("A:%d %d %d %d \n", p->status, xx, yy, p->dis + 1 );
                }
            } else if(map[xx][yy] >= 'a' && map[xx][yy] <= 'z') {
                visit[ p->status | (1<<(map[xx][yy]-'a')) ][xx][yy]=1;
                Step *step = goStep(xx, yy, p->status | (1 << (map[xx][yy] - 'a')), p->dis + 1);
                push(Q, step);
                // printf("a:%d %d %d %d \n", p->status, xx, yy, p->dis + 1 );
 
            } else {
                visit[p->status][xx][yy] = 1;
                Step *step = goStep(xx, yy, p->status, p->dis + 1);
                push(Q, step);
                // printf("1:%d %d %d %d \n", p->status, xx, yy, p->dis + 1 ); 
            }
        }
    }
    
    return 0;
}
