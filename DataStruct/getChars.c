#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#define INIT_SIZE 10
#define INCRE_SIZE 4

typedef struct{
  char *base;
  char *cur;
  size_t size;
  size_t lenght;
}Buffer;

int getChars(Buffer *buf)
{
  buf->base = (char*)malloc(sizeof(char)*INIT_SIZE);
  buf->cur = buf->base;
  buf->lenght = 0;
  buf->size = INIT_SIZE;

  char c;
  while(1){
    scanf("%c",&c);
    if(c == '\n') break;
    if(buf->lenght >= buf->size){
      //使用realloc重新调整字符串数组的大小
      char *newBuf = (char*)realloc(buf->base,sizeof(char)*(buf->size+INCRE_SIZE));
      if(newBuf){
      	free(buf->base);
        return -1;
      }
      buf->cur = newBuf+(buf->cur - buf->base);//重新定位cur指针的位置
      buf->base = newBuf;
    }
    *(buf->cur)++ = c;
  }
  *(buf->cur)='\0';//字符串结束
  return 0;
}

/*
 * 去除字符串前的空格
 * 返回去除空格后的字符串
*/
char* trim(Buffer *buf)
{
   char* old = buf->base;
   char* newer = buf->base;
   //定位前面的空格
   while(*old == ' '){
     old++;
   }

   //复制去除头空格后的字符串
   while(*old){
     *(newer++) = *(old++);//对应赋值
   }
   *(newer)='\0';//设置新字符串结尾
  return (char*)realloc(buf->base,strlen(buf->base)+1);
}

void disArrTest(int arr[],int size)
{
  for(int i=0;i<size;i++) printf("%d\n",arr[i]);
}

int main(void)
{
  Buffer *buf=(Buffer*)malloc(sizeof(Buffer));
  //getChars(buf);
  //printf("%s\n",buf->base);
  //printf("%s\n",trim(buf));
  int arr[5]={1,2,3,4,5};
  disArrTest(arr,5);
  return 0;
}
