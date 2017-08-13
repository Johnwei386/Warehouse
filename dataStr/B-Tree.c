#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "include/Status.h"
#define m 3 //m为B-树的阶，这里设置为3
#define HOLD -1

typedef struct BTNode{
	int n; //节点中关键字的个数
	struct BTNode *parent; //指向父节点
	int key[m+1]; //关键字向量数组，m+1保证冗余
	struct BTNode *ptr[m+1]; //子树指针向量
}BTNode, *BTree;

typedef struct{
	BTNode *pt; //指向找的的结点
	int index; //关键字序号
	Boolean tag; //查找成功标志位
}Result; //B-树的查找结果类型

int search(BTree p, int K)
{//在P中查找K，找到返回其索引，找不到返回0
	if(!p) return 0;
	p->key[0] = K; //设置哨兵
	int i;
	for(i = (m-1); !(K == p->key[i]); i--);
	return i;	
}

Result* searchBTree(BTree T, int K)
{//在m阶B-树上查找关键字K，若查找成功，tag置为TRUE，指针pt
 //所指结点中第i个关键字等于K，否则tag等于FALSE，pt所指节点
 //的第i个关键字小于K，K应插入在第i个关键字和第i+1个关键字之间
	BTree p = T; //p指向待查结点
	BTree q = NULL; //q指向p的父结点
	Boolean found = FALSE;
	int i = 0;
	Result *res = (Result*)malloc(sizeof(Result));
	while(p && !found)
	{//向下遍历B-树，直到找到K值所在或者到树叶的空结点
		i = search(p, K); //在p的关键字数组中查找K，并返回其索引，找不到返回0
		if((i > 0) && (p->key[i] == K)){
			found = TRUE; //找到K，退出循环
		}else {//找不到继续向下遍历
			q = p;
			p = p->ptr[i];
		}
	
	}

	if(found)
	{
		res->pt = p;
		res->index = i;
		res->tag = TRUE;
	}else {
		res->pt = q;
		res->index = i;
		res->tag = FALSE;		
	}

	return res;
}

Boolean insertNode(BTree p, int key, int i, BTree ap)
{
	if(i == (m-1))
	{//i已位于最后，插入新值到第m+1个位置，不进行移位操作
		p->key[i+1] = key;
		p->ptr[i+1] = ap;
		(p->n)++;
		return TRUE;
	}

	for(int j = m; j > i+1; j--)
	{ //后移元素项，只在i+1处插入新值
		p->key[j] = p->key[j-1];
		p->ptr[j] = p->ptr[j-1];
	}
	p->key[i+1] = key;
	p->ptr[i+1] = ap;
	(p->n)++;
	return TRUE;
}

Boolean split(BTree p, int s, BTree *ap)
{//分裂节点q，将其的另一半移入新节点ap
	*ap = (BTree)malloc(sizeof(BTNode));
	(*ap)->n = m - s;
	(*ap)->parent = p->parent;

	int i,j;
	for(j=s+1, i=1; j <= m; j++, i++)
	{
		(*ap)->key[i] = p->key[j];
		p->key[j] = HOLD;
	}

	for(j=s, i=0; j <= m; j++, i++)
	{
		(*ap)->ptr[i] = p->ptr[j];
		p->ptr[j] = NULL;
	}

	p->n = s-1;
	return TRUE;		
}

void newRoot(BTree *T, BTree q, BTree ap, int K)
{//已到根节点，则分裂根节点并生成一个新的上层根节点
 //其实遍历到根节点，q就是T
	*T = (BTree)malloc(sizeof(BTNode));
	(*T)->n = 1;
	(*T)->key[0] = HOLD;
	(*T)->key[1] = K;
	(*T)->parent = NULL;
	(*T)->ptr[0] = q;
	(*T)->ptr[1] = ap;
	q->parent = *T;
	ap->parent = *T;
}

Boolean insertBTree(BTree T, int key)
{//在m阶B-树上插入关键字key，若引起结点过大，则向上做分裂处理
 //使满足B-树的定义
	Result *R = searchBTree(T, key);
	BTree q = R->pt;
	BTree ap = NULL;
	Boolean finished = FALSE;
	int i = R->index;
	int x = key;
	int s = (int)ceil((double)m/(double)2);

	if(R->tag) return FALSE; //关键字已存在，无需插入
	while(q && !finished)
	{
		insertNode(q, x, i, ap); //将key插入到q
		if(q->n < m) finished = TRUE; //插入完成
		else{	//分裂结点q
			//将q->key[s+1, m], q->ptr[s, m]移入新结点ap
			split(q, s, &ap);
			x = q->key[s];
			q = q->parent; //向上插入中间结点并检查是否超过限定的关键字数值，超过则分裂上层结点
			if(q) i = search(q, x); //在父结点中查找x的插入位置
		}
		
	}

	if(!finished) //向上遍历已到根节点，则分裂根节点，在其上面在新建一个结点作为根节点
		newRoot(&T, q, ap, x); //生成新的根节点，原T和ap作为子树指针
	
	return TRUE;
}
