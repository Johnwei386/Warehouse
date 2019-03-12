#include <stdio.h>
#include <stdlib.h>
#include "Status.h"

Boolean Fibonacci(int k, int n)
{// 求k阶斐波那契数列第n项的值
	int m = 0; //前k-2项的和为0
	int fk1 = 1; //第k-1项设为1
	int fk = m; //fk初始设置为m的值，因为在第一次迭代时fk求其本身
	int i;
	fk = fk + fk1; //进行第一次迭代
	if(!(n - k))
	{//若n等于k，则它就等于fk的值
		printf("%d阶斐氏数列第%d项的值为: %d\n", k, n, fk);
		return TRUE;
	}

	for(i = 1; i <= (n - k); i++)
	{// 迭代n-k次之后，fk即是k阶斐氏数列第n项的值
		fk = fk + fk; //因为fk+1=fk+fk-1+m,而fk=fk-1+m,它是一个递归定义
	}

	printf("%d阶斐氏数列第%d项的值为: %d\n", k, n, fk);
	return TRUE;
}

Status main(void)
{
	Fibonacci(1, 1);
	Fibonacci(1, 2);
	Fibonacci(1, 3);
	Fibonacci(1, 4);
	Fibonacci(1, 5);
	Fibonacci(1, 6);
	Fibonacci(1, 7);
	Fibonacci(1, 8);
	Fibonacci(1, 9);
	Fibonacci(1, 10);

	return OK;
}
