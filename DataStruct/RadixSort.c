#include <stdio.h>
#include <stdlib.h>
#include "include/Status.h"
#define CellNum 10
#define MaxSortNum 3

typedef struct{
	int *arr;
	int index; //保存当前分配队列索引，便于向后添加
	Boolean noEmpty;
}Cell;

void radixSort(int a[], int size)
{ // 基数排序, a序列中的数皆为百位数
	Cell* cell[10]; //分配数组定义
	for(int i = 0; i < 10; i++)
	{//cell数组初始化
		cell[i] = (Cell*)malloc(sizeof(Cell));
		cell[i]->arr = (int*)malloc(sizeof(int) * CellNum);
		cell[i]->index = 0;
		cell[i]->noEmpty = FALSE;
	}

	for(int k = 0; k < MaxSortNum; k++)
	{//第k次分配收集操作，取决于待排序序列的元素的位数
		//分配数组，先从单数开始
		int i, j;
		for(i = 0; i < size; i++)
		{
			if(k == 0){//第1次分配个位数
				int t = a[i]%10; //得到个位的值
				cell[t]->arr[cell[t]->index] = a[i];
				cell[t]->index++;
				if(!(cell[t]->noEmpty)) 
					cell[t]->noEmpty = TRUE;
			}

			if(k == 1){//第2次分配十位数
				int t = (a[i]/10)%10; //得到十位的值
				cell[t]->arr[cell[t]->index] = a[i];
				cell[t]->index++;
				if(!(cell[t]->noEmpty)) 
					cell[t]->noEmpty = TRUE;
			}

			if(k == 2){//第3次分配百位数
				int t = (a[i]/100)%10; //得到百位的值
				cell[t]->arr[cell[t]->index] = a[i];
				cell[t]->index++;
				if(!(cell[t]->noEmpty)) 
					cell[t]->noEmpty = TRUE;
			}			
		}

		//收集已分配的序列
		for(i = 0, j = 0; i < CellNum; i++)
		{
			if(!(cell[i]->noEmpty)) continue;
			for(int x = 0; x < cell[i]->index; x++)
				a[j++] = cell[i]->arr[x];
		}

		//重置分配数组
		for(i = 0; i < CellNum; i++)
		{
			cell[i]->index = 0;
			cell[i]->noEmpty = FALSE;
		}
	}
}

Status main(void)
{
	int a[] = {231, 147, 258, 123, 789, 456, 357, 106};
	radixSort(a, 8);
	for(int i = 0; i < 8; i++) printf("%d ", a[i]);
	printf("\n");

	return OK;
}
