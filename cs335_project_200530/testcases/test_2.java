public class Animal{
    public static int foo() {
      int a;
      a = 0;
      while (a < 10 && a > 0) {
        a = a + 1;
        a--;
        ++a;
      }
      return a;
    }
  }
  
  public class Main {
    public static int foo2() {
      int a;
      a = 0;
      while (a < 10 && a > 0) {
        a = a + 1;
        a--;
        ++a;
      }
      return a;
    }
    public int foo1(int a, int b) {
    //   int b;
      b = 0;
    //   int d = foo();
      while (b < 10) {
        b = b + 1;
      }
      return b + 1;
    }
    public static void main(String[] args) {
      int s;
      Animal a = new Animal();
      s = a.foo();
    }
  }