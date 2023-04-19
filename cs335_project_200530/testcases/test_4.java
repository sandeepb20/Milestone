public class test_4 {
    public int foo(int kkk){
        int lll = 0;
        return kkk + 1;
    }
    public int main(){
       int a[][] = new int[500][2];
        int i = 0; 
        int j = 150;
        int qqqq;
        int x = foo(10);
        a[i][0] = i;
        while(i < j){
            i = i + 1;
            a[i][0] = i;
            // println_i();
        }
        i = 0;
        j = 150;
        while(i < j){
            i = i + 1;
            x = a[i][0];
            // println_x();
        }
        // println_i();
        return 0;
    }
}
