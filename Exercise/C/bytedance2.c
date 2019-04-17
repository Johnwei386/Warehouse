/********************************************************************
* 字节跳动2018年校招算法方向(第一批)---编程三道题(一)
* P为给定的二维平面整数点集。定义 P 中某点x，如果x满足 P 中任意点都不在 x 的右
* 上方区域内（横纵坐标都大于x），则称其为“最大的”。求出所有“最大的”点的集合。
* （所有点的横坐标和纵坐标都不重复, 坐标轴范围在[0, 1e9) 内）
* 事例输入：
* 		5
* 		1 2
* 		5 3
* 		4 6
* 		7 5
* 		9 0
* 输出:
* 		4 6
*		7 5
*		9 0
**********************************************/

#include <stdio.h>
#include <string.h>
#include <math.h>
 
typedef struct Point{
    int x,y;
}Point;
 
// 插入排序
void insertSort(Point *spot, int N)
{
    int i,j;
    Point key;
    for(i = 1; i < N; i++){
        key = spot[i];
        // 逆序排列
        for(j = i-1; (j >= 0) && (key.y > spot[j].y); j--) spot[j+1] = spot[j];
        spot[j+1] = key;
    }
}
 
// 快速排序法
int partition(Point *a, int low, int high){
    Point pivotkey = a[low];
    while(low < high)
    {
        while(low < high && a[high].y <= pivotkey.y) high--;
        a[low] = a[high];
        while(low < high && a[low].y >= pivotkey.y) low++;
        a[high] = a[low];
    }
    a[low] = pivotkey;
    return low;
}
   
void quickSort(Point *a, int low, int high)
{
    int pivotkey;
    if(low < high){
        pivotkey = partition(a, low, high);
        quickSort(a, low, pivotkey-1);
        quickSort(a, pivotkey+1, high);
    }
}
 
int main(void)
{
    int N;
    scanf("%d", &N);
    Point *spot = (Point*)malloc(sizeof(Point) * N);
    int x,y;
    for(int i = 0; i < N; i++){
        scanf("%d %d", &x, &y);
        spot[i].x = x;
        spot[i].y = y;
    }
     
    // 先按y逆序排列，然后从第一个元素开始，遍历x，直到最大的那个x坐标值
    // insertSort(spot, N);
    quickSort(spot, 0, N-1);
    //printf("%d %d\n", spot[N-1].x, spot[N-1].y);
    int max_x = -1;
    for(int i = 0; i < N; i++){
        if(spot[i].x > max_x){
            max_x = spot[i].x;
            printf("%d %d\n", spot[i].x, spot[i].y);
        }
    }
     
     
    return 0;
}

