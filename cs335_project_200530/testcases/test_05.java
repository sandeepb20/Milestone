public class Example1 {
    int x;
    double y;  
    Example1(int a, double b) {
   		this.x = a;
      this.y = b;
    }

 public static void main( /*so that we can compile with javac*/) {
 		Example1 a = new Example1(2,3.14);
    int c = a.x;
    int d = a.y;
    int p = 1 + 2 + 7;
 }
}