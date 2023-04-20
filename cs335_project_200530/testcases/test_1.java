public class test_1 {
    public int foo1(int k, int l, int m){
        k = k - 1;
        println_k();
        return 66;
    }

    public int main(){
        int a = 8;
        int b = 68;
        int c = 67;
        int d = a << 2;
        int e;
        if(a==b || a>b && a<b || a>=b || a<=b){
            e = 1;
        }
        else{
            e = 0;
        }
        for(int i=0; i<10; i++){
            println_i();
        }
        // println_a();
        // println_b();
        // println_c();
        int w = foo1(a, 0, 0);
        println_d();
        return 0;
        
    }
}
