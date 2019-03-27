#include <stdio.h>
#include <stdlib.h>
 
int n;
double a[100000];
 
void sort(double a[], int cap)
{
    int i,j;
    long key;
    for(i = 1; i < cap; i++){
        key = a[i];
        for(j = i-1; (j >= 0) && (a[j] > key); j--) a[j+1] = a[j];
        a[j+1] = key;
    }
}
 
int main(void)
{
    scanf("%d", &n);
    for(int i = 0; i < n; i++) scanf("%lf", &a[i]);
    sort(a, n);
    double minspot = a[0];
    double maxspan = 0.0;
    double key, span;
    for(int i = n-1; i > 0; i--){
        key = a[i] - minspot;
        if( key > 180.0) span = 360.0 - key;
        else span = key;
        if(span > maxspan) maxspan = span;
    }
    printf("%lf", maxspan);
     
    return 0;
}
