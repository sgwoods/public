/*
 * Print an array of any number of elements.
 */
#include <stdio.h>

#define ELEMENTS 10

main()
{
  void print_array(int a[], int n);

  int table[ELEMENTS];

  table[0] = 0; table[1] = 10; table[2] = 20;
  table[3] = 30; table[4] = 40; table[5] = 50;
  table[6] = 60; table[7] = 70; table[8] = 80;
  table[9] = 90;

  print_array(table, ELEMENTS);
}

void print_array(int a[], int n)
{
  int i;

  for (i = 0; i < n; i++)
    printf("%i\n", a[i]);
}
