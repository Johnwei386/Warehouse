#include <stdio.h>
#include <stdlib.h>
#include "include/Status.h"

typedef int KeyType;

typedef struct BiTree{
	KeyType	key;
	int		val;
	struct BiTree  *lchild;
	struct BiTree  *rchild;
}BiTree;

BiTree* searchBST(BiTree *T, KeyType key, BiTree *Pre)
{//在二叉排序树T中递归地查找其关键字等于key的数据元素，若查找成功，
 //则返回该数据元素结点，否则返回查找路径上访问到的最后一个结点(前一个结点)
	if (!T)
		return Pre; //查找不成功，返回查找路径上的前一个结点
	else if (key == T->key)
		return T; //查找成功，返回当前遍历到的与key匹配的结点
	else if (key < T->key)
		return searchBST(T->lchild, key, T); //在左子树上继续查找
	else 
		return searchBST(T->rchild, key, T); //在右子树上继续查找
}

Boolean insertBST(BiTree *T, KeyType key, int val)
{//在二叉排序树T中修改关键字为key的元素，若不存在则插入之,
 //二叉排序树的插入特点：每次都在树的叶节点处进行插入，这与查找方法有关
 //查找只是遍历这棵树上按大小关系而左右分布的树结构，但不改变树结构
 //若想完全达到二叉排序树的查找效率(log(n))，则必须对其进行平衡处理
 //成功返回TRUE，失败返回FALSE
	BiTree *Item = searchBST(T, key, NULL); //获取查找结果
	if(!Item) return FALSE; //在查找函数中传入的T为NULL

	if(key == Item->key)
	{//结点已存在于二叉排序树中，修改之
		Item->val = val;
		return TRUE;
	}

	if(key < Item->key)
	{
		BiTree *S = (BiTree*)malloc(sizeof(BiTree));
		S->key = key; S->val = val;
		S->lchild = NULL; S->rchild = NULL; //叶结点的左右子树总为空
		Item->lchild = S;	
	}else {
		BiTree *S = (BiTree*)malloc(sizeof(BiTree));
		S->key = key; S->val = val;
		S->lchild = NULL; S->rchild = NULL; //叶结点的左右子树总为空
		Item->rchild = S;
	}

	return TRUE;	
}

Status main(void)
{
	int key[] = {45, 24, 53, 12, 23, 49, 60, 58};
	BiTree *Tree = (BiTree*)malloc(sizeof(BiTree));
	Tree->key = 45; Tree->val = 0; //初始化树根结点
	Tree->lchild = NULL; Tree->rchild = NULL;
	for(int i = 1; i <= 8; i++)
		insertBST(Tree, key[i-1], i);

	return OK;
}
