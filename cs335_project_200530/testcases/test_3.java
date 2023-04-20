public class test_3 {
    public void foo(int w){
        int pp = 10;
        println_pp();
        w = w+1;
        return ;
    }
    public int main(){
        int a[][][] = new int[5][6][7];
        a[1][2][3] = 5;
        int x = a[1][2][3] * 8;
        println_x();
        foo(1);
        int pp = 9;
        println_pp();
        x= a[1][2][3];
        println_x();
        return 0;
    }
}
