
public class R {

  public static void main() {
    int n = factorialProgram(9);
    println_n();
  }

  /* Java factorial program with recursion. */
  public static int factorialProgram(int n) {
    if (n <= 1) {
      return 1;
    } else {
      return n * factorialProgram(n - 1);
    }
  }
}

