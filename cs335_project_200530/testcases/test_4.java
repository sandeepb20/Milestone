/******************************************************************************
Expected ans: error in line 12
*******************************************************************************/

public class Test3
{
	public void main(String[] args) {
	    int x = 1;
	    x = x+'1';
	    float y = 0.2;
	    y = x+y;
	    y = "You are a fool";  // incompatible types: String cannot be converted to float
	}
}