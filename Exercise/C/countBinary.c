#include <stdio.h>

/***********************************************
* 输入一个整数
* 输出这个整数表示的二进制形式中1的个数
* 负数用反码表示
****************************************/

int main(void)
{
    int m;
    int k = 1;
    scanf("%d", &m);
    printf("0x%x\n", m);
    size_t n = sizeof(m) * 8;
    char a[100];
    size_t count = 0;
    for(int i=0; i < n; i++){
        //printf("%X\n", k);
        //printf("%X\n", m & k);
        //printf("\n");
    	if((m & k) == k){
    		a[i] = '1';
    		count++;
    	} else{ 
    		a[i] = 0;
    	}
    	k = k << 1;
    }
    printf("%lu\n", count);
    
	return 0;
}
