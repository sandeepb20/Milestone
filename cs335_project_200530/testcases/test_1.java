public class test_1 {
   
    public void foo1(int k, int l, int m){
        if(k == 0){
            return 0;
        }
        k--;
        println_k();
        // foo2(10000000);
        // foo3(8888);
        foo1(k, l, m);
        // k--;
        // return foo1(k);
        return;
    }

    public int main(){
        int a = 69, c = 68;
        println_a();
        foo1(a, c, 0);
        return 0;
        
    }
}
