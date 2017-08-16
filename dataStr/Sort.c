#include <stdio.h>
#include <stdlib.h>
#include "include/Status.h"
#define MAXSIZE 20

typedef int KeyType;

typedef struct{
	KeyType key; //关键字项
	int elem; //数据项
}RedType; //记录类型

typedef struct{
	RedType R[MAXSIZE];
	int length;
}SqList; //顺序表类型

void insertSort(SqList *L)
{//对顺序表L作插入排序
	int i,j,key;
	int n = L->length;
	for(i = 1; i < n; i++)
	{
		key = L->R[i].key;
		for(j = i-1; (j >= 0) && (L->R[j].key > key); j--)
			L->R[j+1].key = L->R[j].key;
		L->R[j+1].key = key;
	}
}

void bInsertSort(SqList *L)
{//对顺序表L左折半插入排序
	int i,j,key;
	int n = L->length;
	int high, low, m;
	for(i = 1; i < n; i++)
	{
		key = L->R[i].key;
		low = 0;
		high = i-1;
		while(low <= high)
		{
			m = (low + high)/2; //下取整
			if(key <= L->R[m].key)
				high = m-1;
			else
				low = m+1;
		}

		for(j = i-1; j >= high+1; j--) L->R[j+1].key = L->R[j].key;
		L->R[high+1].key = key;
	}
}

Status main(void)
{
	int a[] = {49, 38, 65, 97, 76, 13, 27, 50};
	SqList *L = (SqList*)malloc(sizeof(SqList));
	for(int i = 0; i < 8; i++)
	{
		L->R[i].key = a[i];
		L->R[i].elem = 0;
	}
	L->length = 8;
	insertSort(L);
	printf("OK!\n");	

	return OK;
}
