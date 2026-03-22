/*
 * Some useful utility functions.
 *   min - returns smaller of two values.
 *   max - returns larger of two values.
 *   inrange - check whether one value is between two others.
 *   put_n_chars - write a character "n" times.
 */
#include <stdio.h>

int min(int x, int y)                 
{
  return (x < y) ? x : y;
}

int max(int x, int y)
{
  return (x > y) ? x : y;
}

int inrange(int min, int max, int v) 
{                       
  return v >= min && v <= max;
}

void put_n_chars(char c, int n)
{                       
  while (n-- > 0)
    putchar(c);
}
