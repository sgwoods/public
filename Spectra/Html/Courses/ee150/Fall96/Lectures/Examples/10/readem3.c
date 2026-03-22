/*
 * Read values into an array up until an error, EOF, or we run out
 * of space in the array.  We just quietly stop reading if we run out
 * of space.
 *
 * This version uses break.
 */
#include <stdio.h>

int fill_array(int a[], int n)
{
  int count;
  int value;
  
  count = 0;
  while (scanf("%i", &value) == 1)
  {
    if (count >= n)
      break;

    a[count++] = value;
  }
  return count;
}
