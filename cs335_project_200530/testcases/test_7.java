public class squareAndRoot {
    int y;
    int x;
    

    squareAndRoot(int a1, int b1) {
        println_b1();
        this.y = b1;
        this.x = a1;
           
    }

    public int get_y(squareAndRoot sr) {
        int temps = sr.y;
        println_temps();
        return temps;
    }
    public int get_x(squareAndRoot sr) {
        int temp = sr.x;
        println_temp();
        return temp;
    }
    
  
    public static void main() {
        squareAndRoot num = new squareAndRoot(4,16);
        int a = get_x(num);
        int b = get_y(num);
        println_a();println_b();      

    }
  }