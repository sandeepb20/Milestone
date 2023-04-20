public class test_4 {
    public int foo2(int p){
        println_p();
        return p+1;
    }
    public int foo(int kkk){
        int lll = foo2(98);
        println_lll();

        return kkk + 1;
    }
    public int main(){
       int [][]a = new int[21483646][2];
       for(int i = 0; i < 500000;  i++){
            a[i][0] = i;
       }
       for(int i = 0; i < 500000; i++){
         int x = a[i][0];
         int ppp = foo(9);
         println_x();
         println_i();
   }
    }
}
