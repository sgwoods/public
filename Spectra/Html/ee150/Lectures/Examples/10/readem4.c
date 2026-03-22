/*
 * Read values into an array up until an error, EOF, or we run out
 * of space in the array.  We just quietly stop reading if we run out
 * of space.
 *
 * This version uses a for instead of a while.
 */
#include <stdio.h>

int fill_array(int a[], int n)
{
  int count;
  int value;
  
  for (count = 0; scanf("%i", &value) == 1; count++)
  {
    if (count >= n)
      break;

    a[count] = value;
  }
  return count;
}
