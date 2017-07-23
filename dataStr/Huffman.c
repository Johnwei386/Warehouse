# include <string.h>
# include "include/Status.h"
# include "include/LStack.h"

typedef struct{
  size_t wight;
  size_t parent, lchild, rchild;
}HTNode, *HuffmanTree;

typedef char** HuffmanCode; //动态分配数组存储郝夫曼编码表

void select(HTNode ht[], size_t n, int *s1, int *s2)
{
   Stack *S = (Stack*)malloc(sizeof(Stack));
   S->next = NULL;
   int min = 888888; int x;
   for(int i=0; i<=n; i++){
      if((min > ht[i].wight) && (ht[i].parent == 0)){
          min = ht[i].wight;
          x = i;
      }
   }

   push(S,x); min = 888888;
   int y = x;
   for(int i=0; i<=n; i++){
     if(i == y) continue;
     if((min > ht[i].wight) && (ht[i].parent == 0)){
          min = ht[i].wight;
          x = i;
     }
   }

   push(S,x);
   *s2 = pop(S);
   *s1 = pop(S);
   free(S);
}


Status createHuffman(HTNode ht[], size_t m, size_t w[], size_t n)
{//m为数组大小，n为叶节点数, w为权值数组大小为n
  if(n > m) return ERROR;

  //初始化叶节点
  for(int i=0; i<n; i++){
     ht[i].wight  = w[i];
     ht[i].parent = 0;
     ht[i].lchild = 0;
     ht[i].rchild = 0;
  }

  //初始化分支节点
  for(int i=n; i<m; i++){
     ht[i].wight  = 0;
     ht[i].parent = 0;
     ht[i].lchild = 0;
     ht[i].rchild = 0;
  }

  //创建一棵郝夫曼树
  int s1,s2;
  for(int i=n; i<m; i++){
     select(ht, i-1, &s1, &s2);
     ht[s1].parent = i; ht[s2].parent = i;
     ht[i].lchild = s1; ht[i].rchild = s2;
     ht[i].wight = ht[s1].wight + ht[s2].wight;
  }

  return OK;
}

HuffmanCode generateHuffmanCode(HTNode ht[], size_t n)
{
   HuffmanCode hc = (HuffmanCode)malloc(sizeof(char*) * n);
   char* cd = (char*)malloc(sizeof(char) * n); //按字符串最长的情况
   cd[n-1] = '\0';
   for(int i=0; i<n; i++){
      int start = n-1;
      int c,f;
      for(c = i, f = ht[i].parent; f != 0; c = f, f = ht[f].parent)
	 if(ht[f].lchild == c) cd[--start] = '0';
	 else cd[--start] = '1';
      hc[i] = (char*)malloc(sizeof(char) * (n - start));
      strcpy(hc[i], &cd[start]);
   }
   free(cd);
   return hc;
}

int main(void)
{
  size_t n = 8;
  size_t m = 2*n - 1;
  size_t w[] = {1, 2, 3, 4, 5, 6, 7, 8};
  HuffmanTree ht = (HuffmanTree)malloc(sizeof(HTNode) * m);
  createHuffman(ht, m, w, n);
  HuffmanCode hc = generateHuffmanCode(ht, n);
  for(int i=0; i<n; i++) printf("%s\n", hc[i]);

  return OK;
}
