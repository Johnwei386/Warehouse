#include <stdio.h>
#include <math.h>
#define EPSILON 1e-6

int main(void)
{
   int n = 4091721929;
   float x = 2.0;

   int p = (int)(n/2);
   while(p*p > n) p = (int)(p/2);
   if(p*p == n){
     printf("根号%u = %.6f\n", n, p);
     return 0;
   }

   x = p;
   for(int i=0; i<10; i++){
     x = (x + n/x)/2;
   }
   printf("根号%u = %.6f\n", n, x);

   return 0;
}
