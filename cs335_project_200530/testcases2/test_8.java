public class ReverseNumber {
    public static void main() {
        int num = 12345;
        int reversedNum = 0;

        while (num != 0) {
            int digit = num % 10;
            reversedNum = reversedNum * 10 + digit;
            num /= 10;
        }

        println_reversedNum();
    }
}
