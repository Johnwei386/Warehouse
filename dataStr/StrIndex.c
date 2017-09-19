#include<stdio.h>
#include<stdlib.h>
#include<string.h>

int indexOf(char *mas, char *pit)
{
	int i=0; //master string index
	int j=0; //pitch string index
	while(i < strlen(mas) || j < strlen(pit)){
		if(mas[i] == pit[j]){
			i++;
			j++;
		}else{
			i=i-j+1; //return back and repitch the string
			j = 0;
		}
	}

	if(j == strlen(pit)) 
		return i-strlen(pit); //success
	else 
		return 0;
}

/*
 * KMP algorithm create j's next array
 * create T's next pitch array
*/
void getNext(char T[], int next[], size_t size)
{// 求模式串T的next函数值并存入数组next
	int i = 0;
	int j = -1;
	next[0] = -1; //recursion last exit
	while(i < size)
	{//书上的输入模式串是从1开始索引的，这里由于是字符串指针，故应从0开始索引
		if(j == -1 || T[i] == T[j]){
			i++;
			j++;
			next[i] = j;
		}else{
			j = next[j];
		}
	}
}

/*
 * KMP algorithm master body implemrnt
*/
int indexKMP(char *mas, char *pit, int next[])
{// 实现上还存在问题，只能匹配到一个字符串，不能匹配在主串中间的字符串
	int i = -1; //mas index
	int j = -1; //pit index
	int m, n;
	m = strlen(mas);
	n = strlen(pit);
	while(i < m || j < n){
		if(j == -1 || mas[i] == pit[j]){
			i++;
			j++;
		}else{
			j = next[j];
		}
	}

	if(j == strlen(pit)) 
		return i - strlen(pit); //pitch success
	else
		return 0;
}

int main(void)
{
	char *s1 = "abertabc";
	char *s2 = "abc";
	int next[strlen(s2)];
	getNext(s2, next, strlen(s2)); //init next array for KMP
	printf("index abc: %u\n", indexOf(s1, s2));
	printf("indexKMP abc: %u\n", indexKMP(s1, s2, next));
	return 0;
}
