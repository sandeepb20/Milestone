public class Example1 {
    int x;
    double y;
    int k=1;
    Example1(int a, double b) {
        this.x = a;
        this.y = b;
    }
  
    public static void main() {
    	Example1 a = new Example1(2,3.14);
        int c = a.x;
        int d = a.y;
    }
  }