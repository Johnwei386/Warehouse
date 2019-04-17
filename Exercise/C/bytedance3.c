/*****************************************************************************
* 字节跳动2018年校招算法方向(第一批)---编程三道题(二)
* 给定一个数组序列, 需要求选出一个区间, 使得该区间是所有区间中经过如下计算的值最大的一个：
* 区间中的最小数 * 区间所有数的和最后程序输出经过计算后的最大值即可，不需要输出具体的区间。
* 如给定序列  [6 2 1]则根据上述公式, 可得到所有可以选定各个区间的计算值:
* [6] = 6 * 6 = 36;
* [2] = 2 * 2 = 4;
* [1] = 1 * 1 = 1;
* [6,2] = 2 * 8 = 16;
* [2,1] = 1 * 3 = 3;
* [6, 2, 1] = 1 * 9 = 9;
* 从上述计算可见选定区间 [6] ，计算值为 36， 则程序输出为 36。
* 区间内的所有数字都在[0, 100]的范围内;
* 输入：
* 	3
* 	6 2 1
* 输出：
* 	36
*********************************************************************/

#include <stdio.h>
#include <stdlib.h>

int minelem(int *a, int low, int high)
{
    int min = a[low];
    for(int i = low+1; i <= high; i++){
        if(min > a[i]) min = a[i];
    }
    return min;
}

int sumOfsection(int *a, int low, int high)
{
    int sum = 0;
    for(int i = low; i <= high; i++) sum = sum + a[i];
    return sum;
}

int maxvalue(int a, int b)
{
    if(a > b)
        return a;
    else
        return b;
}

int bisplit(int *a, int low, int high)
{
    if(low == high){ //区间里只要一个元素
        return a[low] * a[low];
    }
    
    int m1,m2,m3,mid,max;
    mid = (low + high) / 2;
    m1 = sumOfsection(a, low, high) * minelem(a, low, high);  
    m2 = bisplit(a, low, mid);
    m3 = bisplit(a, mid+1, high);  
    max = maxvalue(m1, m2);
    max = maxvalue(max, m3);
    return max;
    
}

int main(void)
{
    int n,max;
    scanf("%d", &n);
    int *a = (int*)malloc(sizeof(int) * n);
    for(int i = 0; i < n; i++) scanf("%d", a+i);
    max = bisplit(a, 0, n-1);
    printf("%d", max);
    
    return 0;
}
