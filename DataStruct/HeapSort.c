#include <stdio.h>
#include <stdlib.h>
#include "include/Status.h"

void heapAdjust(int h[], int s, int m)
{// 构建序列h[s, m]的堆(完全二叉树)，堆顶h[1]为序列的最大值，s > 0
	int rc = h[s];
	for(int j = 2*s; j <= m; j *= 2)
	{// 遍历一棵完全二叉树，j指向二叉树的左树
		if((j < m) && (h[j] < h[j+1])) j++; //若右子树大于左子树，取右子树 
		if(rc > h[j]) break; //若根比子树大，不需要交换根与子树的值
		h[s] = h[j]; //交换根与子树的值
		s = j; //取子树根再向下遍历知道树叶
	}
	h[s] = rc; //原树根就位
}

void heapSort(int h[], int length)
{// 对序列h进行堆排序
	int temp;
	for(int i = length/2; i > 0; i--) //构建序列h为一个根大于子树的堆(完全二叉树)
		heapAdjust(h, i, length); //i指向子树的根
	for(int i = length; i > 1; i--)
	{// 在已建成堆的情况下，提取最大值，重组堆，直到整个序列有序
		temp = h[i];
		h[i] = h[1];
		h[1] = temp; //互换1与i的值
		heapAdjust(h, 1, i-1);
	}
}

Status main(void)
{
	int h[] = {0, 49, 38, 65, 97, 76, 13, 27, 49, 0};
	printf("==============未排序之前==================\n");
	for(int i = 1; i <= 8; i++)  printf("%d ", h[i]);
	printf("\n==============排序之后==================\n");
	heapSort(h, 8);
	for(int i = 1; i <=8; i++)	printf("%d ", h[i]);
	printf("\n");

	return OK;
}
