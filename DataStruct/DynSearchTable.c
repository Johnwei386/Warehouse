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

void inOrderTraver(BiTree *T)
{//中序遍历二叉排序树可得到一个关键字的有序序列
 //这就是说，一个无序序列可以通过构造一棵二叉排序树而变成一个有序序列
 //构造树的过程即为对无序序列进行排序的过程
	if(T)
	{
		inOrderTraver(T->lchild); //遍历左子树
		printf("%d ", T->key);    //输出key
		inOrderTraver(T->rchild); //遍历右子树
	}
}

Boolean deleteNode(BiTree *T, BiTree *Pre)
{//从二叉排序树中删除结点T，并重接它的左右子树
 //二叉排序树的删除要求在删除之后依旧保持二叉排序树的特性
 //这个特性即二叉排序树的中序遍历有序性

	if(!Pre)
	{
		printf("该二叉排序树只有一个结点，不能删除\n");
		return FALSE;
	}

	BiTree *Q = T; //设置一个临时结点，初始化为T
	if (!(T->rchild))
	{//若右子树为NULL，则只需重接它的左子树，当左右子树皆为NULL时
	 //T为叶结点，则只需删除T即可，在这里删除T和重接子树结合到了一起
		if(Pre->lchild == T)
			Pre->lchild = Q->lchild; //重接T的左子树到父结点
		else
			Pre->rchild = Q->lchild;
		free(Q); //删除原来的T结点
	}else if (!(Q->lchild)){//若左子树为NULL，则只需重接它的右子树
		if(Pre->lchild == T)
			Pre->lchild = Q->rchild; //重接T的右子树到父结点
		else
			Pre->rchild = Q->rchild;
		free(Q);
	}else {//左右子树皆不为NULL，则用小于T的左子树下的最大值来替换T的值，这样不改变树的特性
		BiTree *S = T->lchild; 
		while(S->rchild)
		{//先转左，然后向右一直到尽头，然后S将指向小于T的子树中最大的那个结点
		 //即S为T的左子树下一直遍历右子树到最右边的那个结点T，T的右子树为NULL
			Q = S; //Q为S的父结点
			S = S->rchild;
		}

		//通过修改T的值而不是释放T修改链接结构来删除关键字为key的结点
		T->key = S->key; T->val = S->val; //删除T结点

		if (Q != T) //S的父节点不是T，T的子树下的最大值出现在右支
			Q->rchild = S->lchild; //重接Q的右子树为S的左树，因为S的左树比Q大
		else //S的父结点是T，T的子树下的最大值出现在左支，因为子树没有右支
			Q->lchild = S->lchild; //重接Q的左子树为S的左树，因为S的左树比Q小
		free(S); //S的值已赋给了T，删除S结点等效于删除T结点
	}
	return TRUE;
}

Boolean deleteBST(BiTree *T, BiTree *Pre, KeyType key)
{//从二叉排序树中删除关键字等于key的元素结点，成功返回TRUE，失败返回FALSE
	if (!T) return FALSE; //不存在关键字等于key的数据元素，返回FALSE
	else{
		if (key == T->key)
			return deleteNode(T, Pre); //找到关键字等于key的元素删除之
		else if (key < T->key)
			return deleteBST(T->lchild, T, key); //在左子树中继续寻找关键字为key的元素
		else
			return deleteBST(T->rchild, T, key); //在右子树中继续寻找关键字为key的元素
	}
}

Status main(void)
{
	int key[] = {45, 24, 53, 12, 23, 49, 60, 58};
	BiTree *Tree = (BiTree*)malloc(sizeof(BiTree));
	Tree->key = 45; Tree->val = 0; //初始化树根结点
	Tree->lchild = NULL; Tree->rchild = NULL;
	for(int i = 1; i <= 8; i++)
		insertBST(Tree, key[i-1], i);
	inOrderTraver(Tree); printf("\n");
	deleteBST(Tree, NULL, 23);
	inOrderTraver(Tree); printf("\n");

	return OK;
}
