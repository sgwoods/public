/*
 * Read values into an array up until an error, EOF, or we run out
 * of space in the array.  We just quietly stop reading if we run out
 * of space.
 */
#include <stdio.h>

int fill_array(int a[], int n)
{
  int count;
  int value;

  count = 0;
  while (scanf("%i", &value) == 1 && count < n)
  {
    a[count] = value;
    count++;
  }
  return count;
}
