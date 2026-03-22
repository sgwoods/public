/*
 * Print an array of any number of elements in reverse order.
 */
#include <stdio.h>

void print_array_backwards(int a[], int n)
{
  int i;

  for (i = n - 1; i >= 0; i--)
    printf("%i\n", a[i]);
}
