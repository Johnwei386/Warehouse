#include "include/Tree.h"
#include "include/Stack.h"
#include "include/Status.h"

/*
 * 传入一个数组先序遍历创建一棵树，size指定数组的大小，i为数组的索引
*/
Status createBitTree(BitTree *T, char a[], int *index, size_t size)
{ //为了后面的遍历输出，故在此需要需要传入一个二维指针
  int i = *index;
  if(i<0 || i>size)
	return ERROR;
  if(a[i] == 'n') T=NULL; //递归出口
  else{
     *T = (BitTree)malloc(sizeof(BitNode));
     if(!(*T)) return ERROR;
     (*T)->data = a[i];
     *index += 1;
     createBitTree(&((*T)->lchild), a, index, size); //创建左子树
     *index += 1;
     createBitTree(&((*T)->rchild), a, index, size); //创建右子树
  }

  return OK;
}

//递归遍历一棵树
Status listTreeD(BitTree T)
{
  if(T){
     listTreeD(T->lchild); //遍历左子树
     printf("%c ", T->data);
     listTreeD(T->rchild); //遍历右子树
  }
  return OK;
}

//使用堆栈遍历一棵树
Status listTreeS(BitTree T)
{
   Stack *S = (Stack*)malloc(sizeof(BitNode));
   initStack(S);
   BitTree p = T;
   while(p || !emptyStack(S))
   {
     if(p){
        push(S, *p);
        p = p->lchild;
      } else{
        p = pop(S);
        printf("%c ", p->data);
        p = p->rchild;
       }
   }
  return OK;
}

Status exchangeTree(BitTree T)
{
  if(T){
     BitTree p = T->lchild;
     T->lchild = T->rchild;
     T->rchild = p;
     exchangeTree(T->lchild);
     exchangeTree(T->rchild);
  }
  return OK;
}

int main(void)
{
  char a[] = {'A', 'B', 'C', 'n',
	      'n', 'D', 'n', 'n',
	      'E', 'F', 'n', 'n',
	      'G', 'n', 'n'};

  int index = 0;

  //创建一棵树
  BitTree T;
  createBitTree(&T, a, &index, 15);

  //中序遍历一棵树
  listTreeS(T);
  printf("\n");

  //交换左右子树后中序输出
  exchangeTree(T);
  listTreeD(T);
  printf("\n");

  return OK;
}
