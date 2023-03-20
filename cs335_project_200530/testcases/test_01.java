public class ArmstrongNumber {
  public static void main(String[] args) {
    int num = 153, originalNumber, remainder, result = 0, n = 0;

    originalNumber = num;

    for (; originalNumber != 0; originalNumber /= 10, ++n);

    originalNumber = num;

    for (; originalNumber != 0; originalNumber /= 10) {
      remainder = originalNumber % 10;
      result += Math.pow(remainder, n);
    }

    if (result == num)
      System.out.println(num + " is an Armstrong number.");
    else
      System.out.println(num + " is not an Armstrong number.");
  }
}
