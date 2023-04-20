public class test_6 {
    public int rec(int x){
        if(x < 0) return 0;
        println_x();
        x = x-1;
        int y = rec(x);
        return y;
    }
    public int main(){
        int x = 10;
        int y = rec(x);
        println_y();
        return 0;
    }
}
