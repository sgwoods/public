/*
 * A function to get a line of input.  Slightly simplified from
 * the program in the book.
 */
#include <stdio.h>

/*
 * Parameters:
 *   Line is an already allocated character array.
 *   Max is the size of the array minus 1 (to leave room for
 *      the null character).
 */
int getline(char line[], int max)
{
  int c;
  int count = 0;

  while ((c = getchar()) != '\n' && c != EOF)
    if (count < max)
    {
      line[count] = c;
      count++;
    }
  line[count] = '\0';
  if (count == 0 && c == EOF)   /* EOF first character */
    return -1;

  return count;                 /* Otherwise return count */
}
