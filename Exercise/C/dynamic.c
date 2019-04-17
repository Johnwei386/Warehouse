#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int dp[1000][1000];

int min(int a, int b, int c)
{
	int m = a;
	if(m > b) m = b;
	if(m > c) m = c;
	return m;
}

int main(void)
{
    int l1,l2;
	char *s1 = (char*)malloc(sizeof(char) * 1000);
	char *s2 = (char*)malloc(sizeof(char) * 1000);
	scanf("%s", s1); 
	scanf("%s", s2);
	l1 = strlen(s1);
	l2 = strlen(s2);
	//printf("%d\n", l1);
	//printf("%d\n", l2);
	if(l2 == 0){
		printf("%d", l1);
		return -1;
	}
	
	if(l1 == 0){
		printf("%d", l2);
	}
	
	// 初始化dp路径规划图
	for(int i = 0; i < l1; i++){
		for(int j = 0; j < l2; j++){
			dp[i][j] = 0;
		}
	}
	
	// 迭代求解动态规划问题
	for(int i = 1; i <= l1; i++){
		for(int j = 1; j <= l2; j++){
			if(s1[i-1] == s2[j-1]){
				dp[i][j] = dp[i-1][j-1];
				//printf("%d\n", dp[i][j]);
			} else{
				dp[i][j] = 1 + min(dp[i-1][j-1], dp[i][j-1], dp[i-1][j]);
				//printf("%d\n", dp[i][j]);
			}
		}
	}
	printf("%d", dp[l1][l2]);
	
	return 0;
}
