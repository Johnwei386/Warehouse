#include <stdio.h>
#include <stdlib.h>
#include "include/Status.h"
#define LH 1    //左高
#define EH 0    //等高
#define RH -1   //右高

typedef int KeyType;
typedef enum{LC, RC} ChildType;	//定义左右孩子的类型
typedef struct BSTNode{   //定义可平衡处理的二叉排序树
	KeyType  key;	//键即数据
	int bf;		//结点的平衡因子
	struct BSTNode *lchild, rchild;
}BSTNode, *BSTree;

void R_Rotate(BSTree P)
{//对以P为根的二叉排序树作右旋处理，处理之后P指向新的树根结点
 //即旋转处理之前的左子树的根结点
	BSTNode *lc = P->lchild;  //lc指向P的左子树根结点，临时指针
	P->lchild = lc->rchild;   //lc的右子树挂接为P的左子树
	lc->rchild = P;		//lc的右子树指向P
	P = lc;			//P指向新的树根结点
}

void L_Rotate(BSTree P)
{//对以P为根的二叉排序树作左旋处理，处理之后P指向新的树根结点
 //即旋转处理之前的右子树的根结点
	BSTNode *rc = P->rchild;  //rc指向P的右子树根结点，临时指针
	P->rchild = rc->lchild;   //rc的左子树挂接为P的右子树
	rc->lchild = P;		//lc的左子树指向P
	P = rc;			//P指向新的树根结点
}

void leftBalance(BSTree T, BSTree Pre, ChildType type)
{//对以指针T为根结点的二叉树做左旋平衡处理，旋转处理之后，指针T指向新的根结点
 //传入T的父结点Pre，用于修改父结点的子树指针，使其指向新的子树根结点
	BSTNode *lc = T->lchild;	//lc指向T的左子树根节点
	switch(lc->bf){		//检查T的左子树的平衡度，并作相应的平衡处理
		case LH:		//新节点插入在T的左孩子的左子树上，要作单右旋处理
			T->bf = EH;	
			lc->bf = EH;
			R_Rotate(T);
			if(!Pre){
				if(type)
					Pre->rchild = T;
				else
					Pre->lchild = T;
			}
			break;
		case RH:		//新节点插入在T的左孩子的右子树上，作双旋处理(先左后右)
			BSTNode *rd = lc->rchild; //rd指向T的左孩子的右子树根
			switch(rd->bf){//修改T及其左孩子的平衡因子,???|_|???
				case LH:
					T->bf = RH;
					lc->bf = EH;
					break;
				case EH:
					T->bf = EH;
					lc->bf = EH;
					break;
				case RH:
					T->bf = EH;
					lc->bf = LH;
					break;
			}
			rd->bf = EH;
			L_Rotate(T->lchild); //对T的左子树作左旋平衡处理
			R_Rotate(T); //对T作右旋平衡处理
			if(!Pre){
				if(type)
					Pre->rchild = T;
				else
					Pre->lchild = T;
			}
			break;
	}
}
