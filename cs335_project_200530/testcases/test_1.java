public class test_1 {
    public void foo1(int k){
        // int xx;
        if(k == 0){
            return 0;
        }
        k--;
        println_k();
        foo1(k);
        // k--;
        // return foo1(k);
        return;
    }

    public int main(){
        int a = 69, c = 68;
        println_a();

        foo1(a);
        
        return 0;
        
    }
}
