// gcc -S input.c -o output.asm -masm=intel

#include "stdio.h"

int main(){
        int a = 0;
        int b = 3 + a;
        
        printf("%d\n",b);
        return 6;
        
}