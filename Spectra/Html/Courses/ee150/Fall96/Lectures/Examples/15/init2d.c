/*
 * Initializing a two-dimensional array using array subscripting.
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
  int r,c;
 
  for (r = 0; r < rows; r++)
    for (c = 0; c < MAXCOLS; c++)
      a[r][c] = 0;
}
