
public class Example1 {
    int x = 1 + 2;
    int y  = x;
    int k;
    public int setX(int k2){
      this.x = k2;
      return k2;
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
        println_temp();
    }
  }
  // }