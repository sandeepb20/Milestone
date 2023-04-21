public class SortArrayExample3  
{  
    public void main(){  
        //creating an instance of an array  
        int size = 10;
        int[] arr = new int[10];
        for (int i =0 ; i<size;i++)
        {
            arr[i] = size-i;
        } 
        for (int i = 0; i < size; i++)   
        {  
            for (int j = i + 1; j < size; j++)   
            {  
                int tmp = 0;  
                if (arr[i] > arr[j])   
                {  
                    tmp = arr[i];  
                    arr[i] = arr[j];  
                    arr[j] = tmp;  
                }  
            }  
            //prints the sorted element of the array  
            int x = arr[i];
            println_x();  
        }  
    }  
}