/*
 * The main program for insertion sort.
 *
 * [This program assumes there is enough room in table_insert.]
 */
#include <stdio.h>

#define MAX_ELEMENTS 100

int main()
{
  void table_insert(int a[], int n, int item);

  int table[MAX_ELEMENTS];
  int count;
  int value;
  int i;

  count = 0;
  while (scanf("%i", &value) == 1)
  {
    table_insert(table, count, value);
    count++;
  }

  for (i = 0; i < count; i++)
    printf("%i\n", table[i]);
  return 0;
}
