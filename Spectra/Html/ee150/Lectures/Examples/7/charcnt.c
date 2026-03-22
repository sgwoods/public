/*
 * Count characters in the input.
 */
#include <stdio.h>

int main()
{
  int c;                                   /* next character */
  int chars;                               /* count characters */

  chars = 0;
  while ((c = getchar()) != EOF)
    chars = chars + 1;
  printf("%i\n", chars);
  return 0;
}
