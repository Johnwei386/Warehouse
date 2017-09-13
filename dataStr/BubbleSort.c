#include <stdio.h>
#include <stdlib.h>
#include "include/Status.h"

void bubbleSort(int a[], int size)
{//起泡排序算法，一次起泡排序只寻找剩余序列中的最大值并将其放在最后
	int p;
	for(int i = size; i > 0; i--)
	{
		for(int j = 1; j < i; j++)
		{
			if(a[j-1] > a[j])
			{
				p = a[j];
				a[j] = a[j-1];
				a[j-1] = p;
			}
		}
	}
}

Status main(void)
{
	int a[] = {12, 33, 23, 10, 58, 99, 108, 1024};
	printf("================未排序之前=================\n");
	for(int i = 0; i < 8; i++)
		printf("%d, ", a[i]);
	printf("\n================排序之后====================\n");
	bubbleSort(a, 8);
	for(int i = 0; i < 8; i++)
		printf("%d, ", a[i]);
	printf("\n");

	return OK;
}
