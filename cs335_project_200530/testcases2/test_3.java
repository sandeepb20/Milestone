public class test_3 {
    public int artmet(int k, int l, int m, int n, int o, int p, int q){
        
        int t= k+l-m + n*o/p-q;
        return t;
    }

    public int main(){
        int a = 1;
        int b = 4;
        int c = 2;
        int w = artmet(a, b, c, 10, 2, 5, 1);
        println_w();
        return 0;
        
    }
}