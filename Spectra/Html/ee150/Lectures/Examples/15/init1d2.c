/*
 * Initializing a one-dimensional array using pointers.
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
  int *p;
  int *endp;
 
  endp = &a[n - 1];
  for (p = &a[0]; p <= endp; p++)
    *p = 0;
}
