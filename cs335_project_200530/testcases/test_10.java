// Use recursion to add all of the numbers up to 10.

public class Main {
  int a =1;
  public static void main(String[] args) {
    int result = sum(10);
    System.out.println(result);
  }
  String str = "chill";
  public static int sum(int k, int j) {
    if (k > 0) {
      return k + sum(k - 1, 0);
    } else {
      return 0;
    }
    str = "compiler";
  }

}