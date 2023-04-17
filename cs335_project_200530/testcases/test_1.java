/******************************************************************************
Expected ans: error in line 17
*******************************************************************************/

class Test1
{
  float[] a = new float[20];
  int[][] b = new int[10][10];
  int[][] c = new int[10][10];
  int[][][] f = new int[10][15][5];

    public int add(){
        int[] a = new int[10];
        int[][] d = new int[10][10];
        int[][][] e = new int[10][10][10];
        int k = e[3][4][2];
        int l = b[4];  // incompatible types: int[] cannot be converted to int
        int m = d[12][3];
        a[3] = 9;
        c[3][4] = 0;
        f[3][4][2]=4;
    }
}

