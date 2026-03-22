/*
 * Initializing a two-dimensional array using pointers.
 */
#include <stdio.h>

#define MAXROWS 1000
#define MAXCOLS 1000

int bigArray[MAXROWS][MAXCOLS];

main()
{
  void init2dArray(int a[][MAXCOLS], int rows);

  init2dArray(bigArray, MAXROWS);
  return 0;
}

void init2dArray(int a[][MAXCOLS], int rows)
{
  int *p;
  int *endp;

  endp = &a[rows - 1][MAXCOLS - 1];
  for (p = &a[0][0]; p <= endp; p++)
    *p = 0;
}
