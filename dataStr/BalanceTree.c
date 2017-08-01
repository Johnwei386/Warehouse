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
	struct BSTNode *lchild, *rchild;
}BSTNode, *BSTree;

static Boolean taller = FALSE;

void R_Rotate(BSTree *P)
{//对以P为根的二叉排序树作右旋处理，处理之后P指向新的树根结点
 //即旋转处理之前的左子树的根结点
	BSTNode *lc = (*P)->lchild;  //lc指向P的左子树根结点，临时指针
	(*P)->lchild = lc->rchild;   //lc的右子树挂接为P的左子树
	lc->rchild = *P;		//lc的右子树指向P
	*P = lc;			//P指向新的树根结点
}

void L_Rotate(BSTree *P)
{//对以P为根的二叉排序树作左旋处理，处理之后P指向新的树根结点
 //即旋转处理之前的右子树的根结点
	BSTNode *rc = (*P)->rchild;  //rc指向P的右子树根结点，临时指针
	(*P)->rchild = rc->lchild;   //rc的左子树挂接为P的右子树
	rc->lchild = *P;		//rc的左子树指向P
	*P = rc;			//P指向新的树根结点
}

void leftBalance(BSTree *T, BSTree Pre, ChildType type)
{//对以指针T为根结点的二叉树做左旋平衡处理，旋转处理之后，指针T指向新的根结点
 //传入T的父结点Pre，用于修改父结点的子树指针，使其指向新的子树根结点
	BSTNode *lc = (*T)->lchild;	//lc指向T的左子树根节点
	BSTNode *rd;
	switch(lc->bf){		//检查T的左子树的平衡度，并作相应的平衡处理
		case LH:		//新节点插入在T的左孩子的左子树上，要作单右旋处理
			(*T)->bf = EH;	
			lc->bf = EH;
			R_Rotate(T);
			if(!Pre){
				if(type)
					Pre->rchild = *T;
				else
					Pre->lchild = *T;
			}
			break;
		case RH:		//新节点插入在T的左孩子的右子树上，作双旋处理(先左后右)
			rd = lc->rchild; //rd指向T的左孩子的右子树根
			switch(rd->bf){//修改T及其左孩子的平衡因子,???|_|???
			//二叉排序树的插入特点是自叶节点插入，所以当需对子树做平衡处理时
			//一定是叶节点的插入使上层结点的平衡因子发生了变化，所以这里右子树
			//的根节点总是等高的，因为它是新插入的，所以在这里判断左孩子的右子树
			//的平衡因子是没有任何意义的？？？(不确定，待定)
				case LH:
					(*T)->bf = RH;
					lc->bf = EH;
					break;
				case EH:
					(*T)->bf = EH;
					lc->bf = EH;
					break;
				case RH:
					(*T)->bf = EH;
					lc->bf = LH;
					break;
			}
			rd->bf = EH;
			L_Rotate(&((*T)->lchild)); //对T的左子树作左旋平衡处理
			R_Rotate(T); //对T作右旋平衡处理
			if(!Pre){
				if(type)
					Pre->rchild = *T;
				else
					Pre->lchild = *T;
			}
			break;
	}
}

void rightBalance(BSTree *T, BSTree Pre, ChildType type)
{//对以指针T为根结点的二叉树做右旋平衡处理，旋转处理之后，指针T指向新的根结点
 //传入T的父结点Pre，用于修改父结点的子树指针，使其指向新的子树根结点
	BSTNode *rc = (*T)->lchild;	//lc指向T的右子树根节点
	switch(rc->bf){		//检查T的右子树的平衡度，并作相应的平衡处理
		case RH:		//新节点插入在T的右孩子的右子树上，要作单左旋处理
			(*T)->bf = EH;	
			rc->bf = EH;
			L_Rotate(T);
			if(!Pre){
				if(type)
					Pre->rchild = *T;
				else
					Pre->lchild = *T;
			}
			break;
		case LH:		//新节点插入在T的右孩子的左子树上，作双旋处理(先右后左)
			(*T)->bf = EH;
			rc->bf = EH;
			R_Rotate(&((*T)->rchild)); //对T的右子树作右旋平衡处理
			L_Rotate(T); //对T作左旋平衡处理
			if(!Pre){
				if(type)
					Pre->rchild = *T;
				else
					Pre->lchild = *T;
			}
			break;
	}
}

Boolean insertAVL(BSTree *T, BSTree Pre, KeyType key)
{//若在平衡的二叉排序树中不存在和key相同的结点，则插入一个关键字为key的
 //新结点并返回TRUE，否则返回FALSE，若因插入而使二叉排序树失去平衡，则作
 //平衡旋转处理，布尔变量taller反映T长高与否
	if(!(*T)){// 插入新节点，树T"长高了"，置taller为TRUE
		*T = (BSTree)malloc(sizeof(BSTNode));
		(*T)->key = key;
		(*T)->lchild = NULL; (*T)->rchild = NULL;
		(*T)->bf = EH;
		taller = TRUE;
	}else {
		if(key == (*T)->key) //树中已存在关键字与key相同的结点
		{// 不插入这个结点
			taller = FALSE;
			return FALSE;
		}

		if(key < (*T)->key)
		{// 继续在*T的左子树中进行搜索
			if(!insertAVL(&((*T)->lchild), *T, key)) return FALSE; //在左树插入结点
			if(taller) //已插入到T的左子树中且左子树"长高"
			{
				switch((*T)->bf){ //检查T的平衡度
					case LH: //原本左子树比右子树高，需作左平衡处理
						leftBalance(T, Pre, LC);
						taller = FALSE; //不改变上层结构
						break;
					case EH: //原本左、右子树等高，现因左子树增高而使树增高
						(*T)->bf = LH;
						taller = TRUE;
						break;
					case RH: //原本右子树比左子树高，现左，右子树等高
						(*T)->bf = EH;
						taller = FALSE; //不改变上层结构
						break;
				}
			}
		}else { //继续在T的右子树中进行搜索
			if(!insertAVL(&((*T)->rchild), *T, key)) return FALSE; //在右树插入结点
			if(taller) //已插入到T的右子树且右子树长高
			{
				switch((*T)->bf){ //检查T的平衡度
					case LH: //原本左子树比右子树高，现在左、右子树等高
						(*T)->bf = EH;
						taller = FALSE;
						break;
					case EH: //原本左、右子树等高，现因右子树增高而使树增高
						(*T)->bf = RH;
						taller = TRUE;
						break;
					case RH: //原本右子树比左子树高，需作右平衡处理
						rightBalance(T, Pre, RC);
						taller = FALSE;
						break;
				}
			}

		}
	}
	return TRUE;
}
