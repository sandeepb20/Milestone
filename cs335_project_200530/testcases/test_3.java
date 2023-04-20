public class test_3 {
    public void foo(int w){
        w = w+1;
        return ;
    }
    public int main(){
        int a[][][] = new int[5][6][7];
        int x = a[1][2][3];
        println_x();
        foo(1);
        x= a[1][2][3];
        println_x();
        return 0;
    }
}
