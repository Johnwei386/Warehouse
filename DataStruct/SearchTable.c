#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include "include/Status.h"
//--- 对数值型关键字
#define IEQ(a, b) ((a) == (b))
#define ILT(a, b) ((a) < (b))
#define ILQ(a, b) ((a) <= (b))
//--- 对字符型关键字
#define SEQ(a, b) (!strcmp(a, b))
#define SLT(a, b) (strcmp(a, b) < 0)
#define SLQ(a, b) (strcmp(a, b) <= 0)

typedef int    IKeyType;   //数值型关键字
typedef char*  SKeyType;   //字符型关键字
typedef enum{IKEY, SKEY} KeyKind;

typedef struct Snode{
	union{
		IKeyType       key;
		SKeyType       skey;	
	};
	int            val; 
}Snode;

typedef struct{
	Snode     *elem;
	int       length;	
}STable;

Boolean initSTable_SK(STable *ST, SKeyType key[], int size)
{//初始化线性表
	ST->elem = (Snode*)malloc(sizeof(Snode) * (size + 1));
	ST->elem[0].skey = NULL; //初始化第一个元素
	ST->elem[0].val = 0;
	for(int i = 1; i <= size; i++)
	{
		ST->elem[i].skey = (char*)malloc(sizeof(char) * (strlen(key[i-1])+1));
		strcpy(ST->elem[i].skey, key[i-1]);
		ST->elem[i].val = i;
	}
	ST->length = size;
	return TRUE;
}

Status search_Seq(STable *ST, SKeyType key)
{//在ST中顺序查找其关键字等于key的数据元素，若找到，则返回该元素在数据表中的位置
	ST->elem[0].skey = (char*)malloc(sizeof(char) * (strlen(key)+1));
	strcpy(ST->elem[0].skey, key); //设置哨兵
	int i;
	for(i = ST->length; !SEQ(ST->elem[i].skey, key); i--); //从后往前找
	free(ST->elem[0].skey); //释放哨兵
	ST->elem[0].skey = NULL;
	return i; //找不到时，i为0
}

Boolean initSTable_IK(STable *ST, int key[], int size)
{
	ST->elem = (Snode*)malloc(sizeof(Snode) * (size + 1));
	ST->elem[0].key = 0;
	ST->elem[0].val = 0;
	for(int i = 1; i <= size; i++)
	{
		ST->elem[i].key = key[i-1];
		ST->elem[i].val = i;
	}
	ST->length = size;
	return TRUE;
}

Status search_Bin(STable *ST, IKeyType key)
{//折半查找ST中关键字为key的元素，ST必须有序
	int low, mid, high; //定义区间标识
	low = 1; high = ST->length; //置区间初始值
	while(low <= high) //当low > high时，表中没有关键字为key的元素，查找失败
	{
		mid = (low + high)/2;
		if (IEQ(key, ST->elem[mid].key)) return mid; //找到待查元素
		else if (ILT(key, ST->elem[mid].key)) high = mid - 1; //继续在前半区查找
		else low = mid + 1; //继续在后半区查找
	}

	return 0;  //找不到则返回0
}

Status main(void)
{
	/** key为字符串
	char* key[6] = {"apple", "bob", "chany", "dea", "eng", "fade"};
	STable *ST = (STable*)malloc(sizeof(STable));
	initSTable_SK(ST, key, 6);
	printf("key %s = %d\n", key[5], search_Seq(ST, key[5]));*/

	int key[] = {5, 13, 19, 21, 37, 56, 64, 75, 80, 88, 92, 102};
	STable *ST = (STable*)malloc(sizeof(STable));
	initSTable_IK(ST, key, 12);
	printf("key %d = %d\n", key[8], search_Bin(ST, key[8]));

	return OK;
}
