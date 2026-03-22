/*
 * A first pass at a yesorno function.
 *
 * Does not handle the CR following the user's input correctly.
 */
#include <stdio.h>

int yesorno()
{
  int c;          /* the input character */
  int value;      /* 1 if yes, 0 if anything else */

  c = getchar();
  if (c == 'y')
    value = 1;
  else
    value = 0;
  return value;
}
