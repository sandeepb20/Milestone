/******************************************************************************
Sir's example
*******************************************************************************/

public class Example1
{
	int x;
	float y;

 	Example1(int x, float y) {
 		this.x = x;
 		this.y = y;
 	}

 	public static void main(String[] args ) {
 		Example1 a = new Example1(2,3.14);
 		int b = a.x;
		float c = a.y;
		c = c + b;
 	}
}