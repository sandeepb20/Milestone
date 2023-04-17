public class Example1 {
    int x;
    float y;
    int k=1;
    public void add(int a, int b){
       
        foo(99);
        return;
    }
    public int foo(int c){
        return c;
    }
    Example1(int a, float b) {
        // System.out.println(a,b);
        this.x = a;
        this.y = b;
  
    }
  
    public static void main() {
      Example1 a = new Example1(2,3);
        a.add(1, 2);
        int c = a.x;
        float d = a.y;
    }
  }
  // }