#include <stdio.h>
#include <stdlib.h>
#include "include/Status.h"

int min(int x, int y) 
{
	return x < y ? x : y;
}

void merge_sort(int arr[], int len) 
{//使用迭代来实现归并排序，归并排序的核心是分治法，迭代是自底向上归并
	int* a = arr;
	int* b = (int*) malloc(len * sizeof(int));
	int seg, start;
	for (seg = 1; seg < len; seg += seg) 
	{ //seg = 1,2,4,8...设len=8, 当seg=8时，退出外层循环
		for (start = 0; start < len; start += (seg + seg)) 
		{ 	//start = 0, 2, 4, 6, 8...(seg = 1) 2个元素有序
			//start = 0, 4, 8...(seg = 2) 4个元素有序
			//start = 0, 8...(seg = 4) 8个元素有序
			int low = start, mid = min(start + seg, len), high = min(start + seg + seg, len);
			int k = low;
			int start1 = low, end1 = mid; //end*用来控制访问区段
			int start2 = mid, end2 = high;
			while (start1 < end1 && start2 < end2)
				b[k++] = a[start1] < a[start2] ? a[start1++] : a[start2++];
			while (start1 < end1)
				b[k++] = a[start1++];
			while (start2 < end2)
				b[k++] = a[start2++];
		}

		//b只是作为中间的暂存数组来处理数据，关键是每次迭代要使arr局部有序
		//a作为整数指针指向arr,这样在下一次迭代时，arr已经局部有序
		//而在下一次迭代时，b会重新赋予新的排序后的值
		//不断重复这一过程，知道整个序列有序
		//这里存在一个交替变换，即外层循环为单数时，a为b的初始化内存空间
		//而当其为双数时，a指向arr，即a=arr
		int* temp = a;
		a = b;
		b = temp;
	}

	//munmap_chunk(): invalid pointer: 0xbffff2f0
	//free()函数处理的不是由malloc()分配的堆空间内存时返回此错误
	//所以当a没有指向arr的地址空间时，即b指向的是arr的地址空间
	//就需要将b重置回它原本的地址空间，这样在释放它的地址空间时就不会出错
	if (a != arr) {
		int i;
		for (i = 0; i < len; i++)
			b[i] = a[i];
		b = a;
	}

	free(b);
}

void merge_sort_recursive(int arr[], int reg[], int start, int end) 
{// 使用递归来实现归并排序, 递归是自顶向下归并
 // 若无法理解，画图，输入一个序列，按照程序要求一步一步的分解序列
 // 关于它的时间效能，看算法导论
	if (start >= end) return; //分解到只有一个元素时，返回退出递归

	int len = end - start;
	int mid = (len >> 1) + start; //mid = (len/2)+start
	int start1 = start, end1 = mid;
	int start2 = mid + 1, end2 = end;
	//向下分解直到只有一个元素
	merge_sort_recursive(arr, reg, start1, end1); //分解左边的元素序列
	merge_sort_recursive(arr, reg, start2, end2); //分解右边的元素序列

	//用reg保存经比较后局部有序的arr相应位置上的值
	int k = start;
	while (start1 <= end1 && start2 <= end2)
		reg[k++] = arr[start1] < arr[start2] ? arr[start1++] : arr[start2++];
	while (start1 <= end1)
		reg[k++] = arr[start1++];
	while (start2 <= end2)
		reg[k++] = arr[start2++];

	//将中间数组reg的值复制回arr，使其局部有序，从而整体有序
	for (k = start; k <= end; k++)
		arr[k] = reg[k];
}

Status main(void)
{
	int arr[] = {102, 90, 88, 84, 76, 64, 32, 16};
	int len = 8;
	int reg[len];
	//merge_sort(arr, 8);
	merge_sort_recursive(arr, reg, 0, len - 1);
	for(int i = 0; i < 8; i++) printf("%d ", arr[i]);
	printf("\n");
	return OK;
}
