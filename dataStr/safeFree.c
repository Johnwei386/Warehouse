#include<stdio.h>
#include<stdlib.h>
#define safeFree(p) saferFree((void**)&(p))
/*
* 安全free函数，释放指针后自动赋值NULL；
* 避免迷途指针。
*/

void saferFree(void **pp){
 if(pp != NULL && *pp != NULL){
  free(*pp);
  *pp = NULL;
 }
}

int main()
{
 int *pi;
 pi=(int*)malloc(sizeof(int));
 *pi = 5;
 printf("Before:%p\n",pi);
 safeFree(pi);
 printf("After:%p\n",pi);
 safeFree(pi);// 由于为NULL，所以函数不会执行，所以不会有重复释放的问题

 return (EXIT_SUCCESS);
}
