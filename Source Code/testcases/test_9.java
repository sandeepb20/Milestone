public class shorthand {
    public static void main() {
        int[][] arr = new int[2][3];
        int b[][][] = new int[3][4][5];
        b[2][3][4] = 9;
        int c = b[2][3][6]; //Index out of bound
        println_c();
    }
}
