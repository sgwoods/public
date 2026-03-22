/*
 * Demonstrate how array parameters work.
 */
#include <stdio.h>

main()
{
  void testfunc(int a[], int n);

  int table[5];
  int x;
  int i;
 
  table[0] = table[1] = table[2] = table[3] = table[4] = 0;
  x = 20;
  testfunc(table, x);
  
  for (i = 0; i < 5; i++)
    printf("table[%i]=%i\n", i, table[i]);
  printf("x=%i\n", x);
  return 0;
}

void testfunc(int a[], int n)
{
  a[0] = 100;       /* changes table[0] */
  a[2] = 50;        /* changes table[2] */
  n = 15;           /* doesn't change x */
}
