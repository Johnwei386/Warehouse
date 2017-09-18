#include<stdio.h>
#include<stdlib.h>
#include<string.h>

int indexOf(char *mas,char *pit)
{
   int i=0;//master string index
   int j=0;//pitch string index
   while(i<=strlen(mas) || j<=strlen(pit)){
     if(mas[i] == pit[j]){
        i++;
        j++;
     }else{
        i=i-j+1; //return back and repitch the string
     }
  }
  if(j>strlen(pit)) return i-strlen(pit); //success
  else return 0;
}

/*
 * KMP algorithm create j's next array
*/
void getNext(char *T,int next[],size_t size)
{
   int i=1;
   int j=0;
   next[1]=0;//recursion last exit
   while(i<size && i<strlen(T)){
     if(j==0 || T[i]==T[j]){
        i++;
    	j++;
     	next[i]=j;
     }else j=next[j];
  }
}

/*
 * KMP algorithm master body implemrnt
*/
int indexKMP(char *mas,char *pit,int next[])
{
   int i=0;//mas index
   int j=0;//pit index
   while(i<=strlen(mas) || j<=strlen(pit)){
    if(j==0 || mas[i]==pit[j]){
        i++;
	j++;
    }else j=next[j];
  }
  if(j>strlen(pit)) return i-strlen(pit); //pitch success
}

int main(void)
{
  char *s1 = "123456abc";
  char *s2 = "abc";
  int next[255];
  getNext(s2,next,255);//init next array for KMP
  printf("index abc: %u\n",indexOf(s1,s2));
  printf("indexKMP abc: %u\n",indexKMP(s1,s2,next));
  return 0;
}
