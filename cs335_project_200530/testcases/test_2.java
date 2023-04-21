class FibonacciExample1{  
    public int foo2(int p){
        return p;
    }
    public int foo(int x, int y, int z){
        int a = 5, b, c, d;
        int k = 3 +2 + a;
        // println_k();
        return k + x + y + z + foo2(100);
    }
    public int main(){
        int n1 = 5, n2 = 1, n=1, count = 10,i,j;
        // println_n2(); 
        // while(count > 0){
        //     n = n1 + n2;
        //     println_n();
        //     n1 = n2;
        //     n2 = n;
        //     count--;
        // }
        for(i = 0; i < count ; i++){
            n = foo(2,3,4);
                // n = n1 + n2;
                println_n();
                n1 = n2;
                n2 = n;
        }
        return 0;
    }
    // public void main()  
    // {    
    //  int n1=0,n2=1,n,i,count=10;    
        
    //  for(i=2;i<count;i++)//loop starts from 2 because 0 and 1 are already printed    
    //  {    
    //   n=n1+n2;    
    //   println_n();
    // //   System.out.print(" "+n);    
    //   n1=n2;    
    //   n2=n;    
    //  }    
      
    // }
}  