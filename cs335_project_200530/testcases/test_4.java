public class test_4 {
    public int foo(int kkk){
        int lll = 0;
        return kkk + 1;
    }
    public int main(){
       int [][]a = new int[21483646][2];
       for(int i = 0; i < 500000;  i = i + 1){
            a[i][0] = i;
       }
       for(int i = 0; i < 500000; i++){
         int x = a[i][0];
         println_x();
   }
    }
}
