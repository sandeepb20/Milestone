
public class Example1 {
    int x ;
    int y ;
    int k;
    public int setX(int k){
      this.x = k;
      return k;
    }
    Example1(int a, int b) {
        this.x = a;
        this.y = b;
    }

  
    public static void main() {
        int arr[] = new int[10];
        Example1 a = new Example1(29,3);
        Example1 b = new Example1(5, 10);
        int temp = a.setX(100);
        int c = b.x;
        int d = a.x;
        println_c();
        println_d();
    }
  }
  // }