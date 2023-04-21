// Write a program that takes an array of integers as input and sorts the array using the selection sort algorithm.

public class SelectionSort {
    public static void main(String[] args) {
        int[] array = { 5, 2, 8, 3, 1, 7 };

        for (int i = 0; i < array.length - 1; i++) {
            int minIndex = i;

            for (int j = i + 1; j < array.length; j++) {
                if (array[j] < array[minIndex]) {
                    minIndex = j;
                }
            }

            int temp = array[minIndex];
            array[minIndex] = array[i];
            array[i] = temp;
        }

        for (int i = 0; i < array.length; i++) {
            System.out.print(array[i] + " ");
        }
    }
}
