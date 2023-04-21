// Fibonacci using while loop and if else

class FibonacciExample2{  
    public int main(){
       int index =25;   // til 47
       int i=2;
       int x =0, y=1, s=0; 
       if(index ==1){
           println_x();
       }
       else if(index==2) {
           println_x();
           println_y();
       }
       else{
           println_x();
           println_y();
           while (i<index){
               
               s = x+y;
               println_s();
               x = y;
               y = s;
               i++;
           } 
       } 
    }  
}