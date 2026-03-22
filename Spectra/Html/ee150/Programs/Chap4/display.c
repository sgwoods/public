/*
 * Copy the input to the output.
 */
#include <stdio.h>

int main()
{
  int c;                                   /* next character */

  while ((c = getchar()) != EOF)
    putchar(c);
  return 0;
}
