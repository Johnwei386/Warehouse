#include <stdio.h>
#include <stdlib.h>
#include "include/Status.h"

int Partition(int a[], int low, int high)
{// 一次快速排序的过程，返回枢轴所在位置，low为遍历序列的低端，high为高端
	int pivotkey = a[low]; //定义枢轴，枢轴初始化为所求排序序列的第一条记录
	while(low < high)
	{// 从表的两端交替的向中间扫描
		while(low < high && a[high] >= pivotkey) high--; //等于号，非递减有序
		a[low] = a[high]; //将比枢轴记录小的记录移到低端
		while(low < high && a[low] <= pivotkey) low++;
		a[high] = a[low]; //将比枢轴记录大的记录移到高端
	}
	a[low] = pivotkey; //一次遍历当high等于low时，这个位置即为枢轴所在的中间位置
	return low; //返回枢轴所在的位置
}

void QSort(int a[], int low, int high)
{//对子序列a[low, high]作快速排序，这是一个递归形式的快排操作
	int pivotkey; //定义中间的枢轴
	if(low < high)
	{// 递归出口
		pivotkey = Partition(a, low, high); //将子表a[low, high]一分为二
		QSort(a, low, pivotkey-1); //对低子表作递归排序
		QSort(a, pivotkey+1, high); //对高子表作递归排序
	}
}

Status main(void)
{
	int a[] = {49, 38, 65, 97, 76, 13, 27, 50};
	printf("=================未排序之前======================\n");
	for(int i = 0; i < 8; i++) printf("%d ", a[i]);
	printf("\n================排序之后========================\n");
	QSort(a, 0, 7);
	for(int i = 0; i < 8; i++) printf("%d ", a[i]);
	printf("\n");

	return OK;
}
