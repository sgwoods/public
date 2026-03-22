/*
 * Read values into an array up until an error or EOF.  Return the
 * number of values read in.
 */
#include <stdio.h>

int fill_array(int a[], int n)
{
  int count;
  int value;
  
  while (scanf("%i", &value) == 1)
  {
    a[count] = value;
    count++;
  }
  return count;
}
