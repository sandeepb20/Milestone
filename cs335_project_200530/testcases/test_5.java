public class Example1 {
    int x;
    int y;
    int k;
    public void add(int a, int b){
       
        foo(99);
        return;
    }
    public int foo(int c){
        return c;
    }
    Example1(int a, int b) {
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