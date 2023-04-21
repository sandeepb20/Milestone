public class test_3 {
    public void foo(int w){
        int a = 24;
        a %= 7;
        println_a();
        a += 3;
        println_a();
        a -= 2;
        println_a();
        a *= 2;
        println_a();
        a /= 2;
        println_a();
        w = w+1;
        return ;
    }
    public int main(){
        int arr[][][] = new int[5][6][7];
        arr[1][2][3] = 5;
        int x = arr[1][2][3] * 8;
        println_x();
        foo(1);
        x= arr[1][2][3];
        println_x();
        return 0;
    }
}
