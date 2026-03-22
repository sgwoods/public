/*
 * Print an array of exactly 10 elements.
 */
#include <stdio.h>

#define ELEMENTS 10

main()
{
  void print_array(int a[ELEMENTS]);

  int table[ELEMENTS];

  table[0] = 0; table[1] = 10; table[2] = 20;
  table[3] = 30; table[4] = 40; table[5] = 50;
  table[6] = 60; table[7] = 70; table[8] = 80;
  table[9] = 90;

  print_array(table);
  return 0;
}

void print_array(int a[ELEMENTS])
{
  int i;

  for (i = 0; i < ELEMENTS; i++)
    printf("%i\n", a[i]);
}
