public class squareAndRoot {
    int y;
    int x;
    

    squareAndRoot(int a, int b) {
        if(b==a*a){
            this.x = a;
            this.y = b;
        }
        else{
            this.x = a;
            this.y = a*a;
        }
           
    }
    public int get_y(squareAndRoot sr) {
        int temps = 1+  sr.y;
        println_temps();
        return temps;
    }
    public int get_x(squareAndRoot sr1) {
        int temp = sr1.x;
        println_temp();
        return temp;
    }
    
 
    public static void main() {
        squareAndRoot num = new squareAndRoot(4,19);
        int x1 = num.y;
        println_x1();
        int w = get_x(num);
        int r = get_y(num);     

    }
  }