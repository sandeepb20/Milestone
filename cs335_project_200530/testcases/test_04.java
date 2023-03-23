//Java Program to demonstrate the use of If else-if ladder.  
//It is a program of grading system for fail, D grade, C grade, B grade, A grade and A+.  

// public class IfElseIfExample { 
//     char h; 
//     public static int main(String[] args) { 

//         int a = 1, b =2;
//         int c;
//         if(a == 2){
//             c= 1 + 3;
//         }
//         else{
//             c = 2 / 2 % 1;
//         }
//         int c = a==b?a:a+1;
//         // int a = 0; 
//         // int b = a++ + (a+2)-1;
//         // int c = ++a;
//         // int d = 0;
//         // d = ++ ++d +1;
//         // // int b;
//         // for(int i = 0; i < 10 -2; i++){
//         //     a = a++ +1;
            
//         // }
//         // assert a == 10;
//         // return a + b + c + d;
// }  
// }  



public class Example1 {
    int x;
    double y;
    Example1(int x, double y) {
        this.x = x;
            this.y = y;
    }

    public static void main(String[] args /*so that we can compile with javac*/) {
    		Example1 a = new Example1(2,3.14);
         System.out.println(a.x);
         System.out.println(a.y);
    }
}