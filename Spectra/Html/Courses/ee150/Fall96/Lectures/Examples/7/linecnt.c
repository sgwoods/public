/*
 * Count characters and lines in the input.
 */
#include <stdio.h>

int main()
{
  int c;                                   /* next character */
  int chars;                               /* count characters */
  int lines;                               /* count lines */

  chars = lines = 0;
  while ((c = getchar()) != EOF)
  {
    chars = chars + 1;
    if (c == '\n')
      lines = lines + 1;
  }
  printf("%i %i\n", chars, lines);
  return 0;
}
