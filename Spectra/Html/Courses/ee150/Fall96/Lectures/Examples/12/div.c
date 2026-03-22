/*
 * Writing and using a function to return the quotient and
 * remainder through pointers.
 */

#include <stdio.h>

main()
{
  void divide(int x, int y, int *quotptr, int *remptr);

  int val1, val2;
  int quotient, remainder;

  scanf("%i %i", &val1, &val2);   /* read values */
  divide(val1, val2, &quotient, &remainder);
  printf("%i/%i=%i, %i%%%i=%i\n", val1, val2, quotient,
                                  val1, val2, remainder);
  return 0;
}

void divide(int x, int y, int *quotptr, int *remptr)
{
  *quotptr = x / y;
  *remptr = x % y;
}
