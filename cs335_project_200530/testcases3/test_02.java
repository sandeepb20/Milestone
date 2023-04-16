public class BinarySearch {
  public static int binarySearch(int[] arr, int x) {
    int left = 0, right = arr.length - 1;
    while (left <= right) {
      int mid = left + (right - left) / 2;
      if (arr[mid] == x) {
        return mid;
      } else if (arr[mid] < x) {
        left = mid + 1;
      } else {
        right = mid - 1;
      }
    }
    return -1; // element not found
  }

  public static void main(String[] args) {
    int[] arr = { 2, 3, 4, 10, 40 };
    int x = 10;

    int result = binarySearch(arr, x);

    if (result == -1)
      System.out.println("Element not found");
    else
      System.out.println("Element found at index " + result);
  }
}
