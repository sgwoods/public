/*
 * An example of creating an array, zeroing its elements, assigning
 * values to a few elements, and then printing all array elements.
 */
#include <stdio.h>

#define ELEMENTS 10

int main()
{
  int a[ELEMENTS];     /* make a 10 element array */
  int i;

  for (i = 0; i <= ELEMENTS - 1; i++)
    a[i] = 0;         /* zero each element */

  a[2]= 17;           /* put a 17 in the third element */
  a[4]= 30;           /* put a 30 in the fourth element */
  
  for (i = 0; i <= ELEMENTS - 1; i++)
    printf("%i\n", a[i]);         /* print each element */

  return 0;
}
