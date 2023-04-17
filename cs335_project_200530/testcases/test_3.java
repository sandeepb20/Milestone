/******************************************************************************
float int char typecasting and error at line 16
*******************************************************************************/

public class Test3
{
	public int add(int x, int y){
		return x+y;
	}
	
	public void main(String[] args) {
	    int x = 1;
	    x = x+'1';
	    float y = 0.2;
	    y = x+y;
		x = add(x,'2', 2); // number of parameters
	}
}