class Test1{
    int a = 1+2+3;
    public static int foo(){
      int[][] arr = new int[4][5];  // Array declaration
      int a = arr[3][4];    // Array Access
      a = 0;
  
      while(a < 10){ // While loop
        a = a + 1;
      }
      return a;
    }
    int foo1(int a, int b){
      
      b = 0; 
      // int b; // B already deaclared
      int d = foo();            // method call
      int e = foo1(9,8);  // Support Recursion
      while( b < 10){
        b = b + 1;
        int c;
      }
      while( b < 10){
        b = b + 1;
        int c;
      }
      return b+1; // Return statement
    }
  };