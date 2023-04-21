public class test_5 {
    public int twice(int w){
        int t = w<<1;
        return t;
    }
    public int main(){

        int y;
        int x;
        int z;
        int a[][][] = new int[5][6][7];
        for(int i=0; i<5;i++){
            for(int j=0; j<6;j++){
                for(int k=0; k<7;k++){
                    x = i+j+k;
                    z = twice(x);
                    a[i][j][k] = z;
                    y = a[i][j][k];
                    println_y();
                }
            }
        }

        return 0;
    }
}