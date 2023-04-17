/******************************************************************************
Expected ans: error in line 14
*******************************************************************************/

public class Test2
{
    float[] a = new float[20];
    int [][]b = new int[10][10];

    public void main(String[] args) {

        int[] a = new int[10];
        int[][] d = new int[10][10];
        a[45]=2;      // out of bound index
        a[3] = 9;

    }
}