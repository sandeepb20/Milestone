public class test_5 {
    public int twice(int w){
        int t = w<<1;
        return t;
    }
    public int main(){

        int y;
        int x;
        int a[][] = new int[5][6];
        for(int i=0; i<5;i++){
            for(int j=0; j<6;j++){
                x = i+j;
                a[i][j] = twice(x);
                y = a[i][j];
                println_y();
            }
        }

        return 0;
    }
}