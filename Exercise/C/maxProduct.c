#include <stdio.h>
#include <stdlib.h>
#include <math.h>
typedef unsigned int uint;

/*************************************************************
** 求一个无序数组中最大的三个数的乘积
** 先排序，然后取最后的是哪个数求积
*************************************************************/

int partition(long long a[], int low, int high){
    long long pivotkey = a[low];
    while(low < high)
    {
        while(low < high && a[high] >= pivotkey) high--;
        a[low] = a[high];
        while(low < high && a[low] <= pivotkey) low++;
        a[high] = a[low];
    }
    a[low] = pivotkey;
    return low;
}

void sort(long long a[], int low, int high)
{
    int pivotkey;
    if(low < high){
        pivotkey = partition(a, low, high);
        sort(a, low, pivotkey-1);
        sort(a, pivotkey+1, high);
    }
}

void printArray(long long a[], int cap)
{
    for(int i = 0; i < cap; i++){
        printf("%lld ", a[i]);
    }
}

int main(int argc, char *argv[])
{   
    if(argc < 4){ // 输入至少3个数值
        return -1;
    }

    long long a[argc - 1];
    for(int i = 1; i < argc; i++){
        a[i-1] = atoi(argv[i]);
        // a[i-1] = abs(a[i-1]);
    }
    uint cap = (uint)(sizeof(a) / sizeof(a[0]));
    printf("cap: %d\n", cap);
    printf("\n");
    printArray(a, cap);
    printf("\n");
    printf("\n");
    sort(a, 0, cap-1);
    printArray(a, cap);
    printf("\n");
    printf("\n");
    long long mas1 = a[0] * a[1] * a[cap - 1];
    long long mas2 = a[cap - 3] * a[cap -2] * a[cap - 1];
    if(mas1 > mas2)
    {
        printf("%lld\n", mas1);
    } else {
        printf("%lld\n", mas2);
    }
    
    return 0;
}
