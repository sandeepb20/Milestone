// Use recursion to add all of the numbers up to 10.

public static class Main {
  int a = b;
  Geek(String name, int id)
    {
        this.name = name;
        this.id = id;
    }
  public static void main(String[] args) {
    int result = sum(10);
    System.out.println(result);
  }
  String str = "chill";
  public static int sum(int k, char c) {
    if (k > 0) {
      return k + sum(k - 1);
    } else {
      return 0;
    }
  }
}