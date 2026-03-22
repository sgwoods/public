/*
 * Find the largest and smallest values in an array.
 */
#include <stdio.h>

main()
{
  void minmax(int a[], int n, int *smallptr, int *largeptr);
  int table[10] = {17, 92, 85, 78, 65, 87, 14, 19, 56, 79};
  int smallest, largest;
  
  minmax(table, 10, &smallest, &largest);
  printf("The smallest value is %i\n", smallest);
  printf("The largest value is %i\n", largest);

  return 0;
}

void minmax(int a[], int n, int *smallptr, int *largeptr)
{
  int i;
  int small, large;

  small = large = a[0];
  for (i = 1; i < n; i++)
  {
    if (a[i] < small)
      small = a[i];
    if (a[i] > large)
      large = a[i];
  }
  *smallptr = small;
  *largeptr = large;
}
