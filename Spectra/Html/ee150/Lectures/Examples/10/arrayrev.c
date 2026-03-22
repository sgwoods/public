/*
 * An example of reading all of the input into an array, then printing
 * it in reverse order.
 */
#include <stdio.h>

#define ELEMENTS 100   

int main()
{
  int a[ELEMENTS];     /* room for 100 elements */
  int count;           /* how many values are actually in the array */
  int value;           /* next input value */
  int i;              

  count = 0;
  while (scanf("%i", &value) == 1)
  {
    a[count] = value;  /* save value into an array */
    count++;
  }

  for (i = count - 1; i >= 0; i--)
    printf("%i\n", a[i]);         /* print each element, backwards */

  return 0;
}
