#ifndef _TREE_H
#define _TREE_H

#if !defined _INCLUDE_STD
# define _INCLUDE_STD
# include <stdio.h>
# include <stdlib.h>
#endif

typedef struct BitNode{
   char data;
   struct BitNode *lchild, *rchild;
}BitNode, *BitTree;

#endif
