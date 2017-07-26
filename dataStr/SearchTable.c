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

typedef struct Snode{
	SKeyType       key;
	int            val; 
}Snode;

typedef struct{
	Snode     *elem;
	int       length;	
}STable;

Boolean initSTable(STable *ST, SKeyType key[], int size)
{//初始化线性表
	ST->elem = (Snode*)malloc(sizeof(Snode) * (size+1));
	ST->elem[0].key = NULL; //初始化第一个元素
	ST->elem[0].val = 0;
	for(int i = 1; i <= size; i++)
	{
		ST->elem[i].key = (char*)malloc(sizeof(char) * (strlen(key[i-1])+1));
		strcpy(ST->elem[i].key, key[i-1]);
		ST->elem[i].val = i;
	}
	ST->length = size;
	return TRUE;
}

Status search_Seq(STable *ST, SKeyType key)
{//在顺序表ST中查找其关键字等于key的数据元素，若找到，则返回该元素在数据表中的位置
	ST->elem[0].key = (char*)malloc(sizeof(char) * (strlen(key)+1));
	strcpy(ST->elem[0].key, key); //设置哨兵
	int i;
	for(i = ST->length; !SEQ(ST->elem[i].key, key); i--); //从后往前找
	free(ST->elem[0].key); //释放哨兵
	ST->elem[0].key = NULL;
	return i; //找不到时，i为0
}

Status main(void)
{
	char* key[6] = {"apple", "bob", "chany", "dea", "eng", "fade"};
	STable *ST = (STable*)malloc(sizeof(STable));
	initSTable(ST, key, 6);
	printf("key %s = %d\n", key[5], search_Seq(ST, key[5]));

	return OK;
}
