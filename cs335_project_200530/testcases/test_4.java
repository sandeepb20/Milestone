public class test_4 {
    public int foo2(int p){
        println_p();
        return p+1000;
    }
    public int foo(int x, int y, int z){
        int lll = foo2(98);
        println_lll();
        x = x*10;
        println_x();
        println_y();
        println_z();

        return x + 100;
    }
    public int main(){
       int [][]a = new int[21483646][2];
       for(int i = 0; i < 500000;  i++){
            a[i][0] = i;
       }
       int w = foo(101,102,103);
       println_w();
//        for(int i = 0; i < 500000; i++){
//          int x = a[i][0];
//          int ppp = foo(9);
//          println_x();
//          println_i();
//    }
    }
}
