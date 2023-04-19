public class test_1 {
    public int foo3(){
        int p=88888;
        println_p();
        return p;
    }
    public int foo2(int z){
        int ppp, ppp2;
        println_z();
        return z;
    }
    public void foo1(int k, int l, int m){
        int xx, yy;
        if(k == 0){
            return 0;
        }
        k--;
        println_k();
        foo2(10000000);
        foo3(8888);
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
