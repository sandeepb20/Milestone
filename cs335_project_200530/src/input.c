#include "stdio.h"

int foo(int x, int y, int z){
        int a = 5, b, c, d, e;
        int k = 3 +2 + a;
        printf("%d",k);
        return k + x + y + z;
    }
 int main(){
        int n1 = 5, n2 = 1, n=1, count = 10,i,j,k = 9, l = 1, p = 9, q = 35;

        for(i = 0; i < count ; i++){
            n = foo(2,3,4);
                // n = n1 + n2;
                printf("%d", n);
                n1 = n2;
                n2 = n;
        }
        return 0;
    }