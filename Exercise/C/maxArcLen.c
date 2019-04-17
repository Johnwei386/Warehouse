#include <stdio.h>

int n;
double a[100000];

int main(void)
{
    double minspot = 888888;
    double maxlen = 0;
    double temp = 0;
    scanf("%d", &n);
    for(int i = 0; i < n; i++) scanf("%lf", &a[i]);
    for(int i = 0; i < n; i++){
        if(minspot > a[i]) minspot = a[i];
    }
    for(int i = 0; i < n; i++){
        if(a[i] == minspot) continue;
        if(a[i] <= (minspot + 180)){
            temp = a[i] - minspot;
            printf("%lf\n", temp);
            if(temp > maxlen) maxlen = temp;
        } else {
            temp = (360 - a[i]) + minspot;
            printf("%lf\n", temp);
            if(temp > maxlen) maxlen = temp;
        }
    }
    printf("minspot: %lf\n", minspot);
    printf("maxlen: %lf\n", maxlen);

    return 0;
}
