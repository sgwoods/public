/*
 * Find the largest and smallest values in an array using a different
 * approach.
 */
#include <stdio.h>
#include <limits.h>

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

  small = INT_MAX;
  large = INT_MIN;
  for (i = 0; i < n; i++)
  {
    if (a[i] < small)
      small = a[i];
    if (a[i] > large)
      large = a[i];
  }
  *smallptr = small;
  *largeptr = large;
}
