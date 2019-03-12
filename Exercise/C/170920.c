#include <stdio.h>
#include <stdlib.h>
#include "Status.h"

int getMax(int x, int y)
{
	return x>y ? x : y;
}

Status main(void)
{
	int at[3];
	int i, j, k;
	printf("请输入三个数，输入格式如(1 2 3)：");
	scanf("%d %d %d", &at[0], &at[1], &at[2]);
	for(i = 1; i < 3; i++)
	{// 插入排序
		k = at[i];
		for(j = i-1; j >=0 && at[j] > k; j--)
			at[j+1] = at[j]; //向后移位
		at[j+1] = k; //内排序位就位
	}
	for(i = 2; i >= 0; i--) printf("%d ", at[i]);
	printf("\n");

	return OK;
}
