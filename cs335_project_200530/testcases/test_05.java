public class Example1 {
    int x;
    double y;  
    Example1(int x, double y) {
   		this.x = x;
      this.y = y;
    }

 public static void main( /*so that we can compile with javac*/) {
 		Example1 a = new Example1(2,3.14);
    int c = a.x;
    int p = 1 + 2 + 7;
 }
}