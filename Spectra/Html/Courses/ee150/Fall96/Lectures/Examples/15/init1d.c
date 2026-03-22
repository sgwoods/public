/*
 * Initializing a one-dimensional array.
 */
#include <stdio.h>

#define MAXELEMENTS 1000

int bigArray[MAXELEMENTS];

main()
{
  void initArray(int a[], int n);

  initArray(bigArray, MAXELEMENTS);
  return 0;
}

void initArray(int a[], int n)
{
  int i;
 
  for (i = 0; i < n; i++)
    a[i] = 0;
}
