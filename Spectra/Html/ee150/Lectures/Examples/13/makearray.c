/*
 * Create an array, set it to zero, and print it.
 */
#include <stdio.h>
#include <stdlib.h>     /* for malloc */

main()
{
  void printValues(int a[], int n);
  int *table;           
  int n;
  
  scanf("%i", &n);     /* number of values to create */
  table = malloc(n * sizeof(int));
  if (table == 0)
    printf("Couldn't create an array of %i elements\n", n);
  else
  {
    int i;

    for (i = 0; i < n; i++)     /* set all the values to 21 */
      table[i] = 21;
    printValues(table, n);
  }
  return 0;
}

void printValues(int a[], int n)
{
  int i;

  for (i = 0; i < n; i++)
    printf("%i\n", a[i]);
}
