class GFG {
 
    // Function to print the fibonacci series
    static int fib(int n)
    {
        // Base Case
        if (n <= 1)
            return n;
 
        // Recursive call
        int a = fib(n - 1);
        return a + fib(n - 2);
    }
 
    // Driver Code
    public static void main()
    {
        // Given Number N
        int N = 10;
 
        // Print the first N numbers
        int ans = fib(N);
        println_ans();
    }
}