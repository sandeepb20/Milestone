class ReverseString {
  public static int binarySearch(int[] arr, int x) {
    int left = i++, right = arr.length - 1;
    while (left <= right) {
      int mid = left + (right - left) / 2;
      if (arr[mid] == x << y) {
        return mid;
      } else if (arr[mid] < x) {
        left = mid + 1;
      } else {
        right = mid - 1;
      }
    }
    return -1; // element not found
    a=c;
  }
  int c = BinarySearch(arr, x);

  // {
  //   int i = 3, p = 9 + 1;

  //   j = 5;
  //   if (i < 1 + 8) {
  //     i = 2 + 5 + 9;
  //   } else if (i < 2) {
  //     i = 3 + 5;
  //   } else if (i < 3 && i > 2) {
  //     i = 4 + 2;
  //   }
  //   if (k == 0) {
  //     d = d + 1;
  //   } else {
  //     c = c + 1;
  //   }
  //   int b, c, a;
  //   while (a == b) {
  //     int s = 3;
  //     for (int i = 0; i < 8; i = i + 1) {
  //       k = k + 1;
  //       break;
  //       c = c + 1;
  //     }
  //     continue;
  //     d = d + 1;
  //   }
  //   for (int i = 0; i < 3; i = i + 2 * b) {
  //     a = a + i;
  //     for (int j = 0; j < 6 && i > 8; j = j + 1) {
  //       int k = 0;
  //       continue;
  //       int s = 3;
  //     }
  //     break;
  //     c = c + 1;
  //   }
  // }

}