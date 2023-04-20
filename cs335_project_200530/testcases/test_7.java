public class SortArrayExample3  
{  
    public void main(){  
        //creating an instance of an array  
        int size = 10;
        int[] arr = new int[10];
        for (int k =0 ; k<size;k++)
        {
            arr[k] = size-k;
            arr[k] = arr[k] * 10;
        } 
        for (int i = 0; i < size; i++)   
        {  
            for (int j = i + 1; j < size; j++)   
            {  
                int tmp = 0;  
                int p = arr[i];
                int q = arr[j];
                if ( arr[i] > arr[j])   
                {  
                    tmp = arr[i];
                    arr[i] = arr[j];  
                    arr[j] = tmp;  
                    // println_tmp();
                }  
            }  
            //prints the sorted element of the array  
            int x = arr[i];
            println_x();  
        }  
    }  
}