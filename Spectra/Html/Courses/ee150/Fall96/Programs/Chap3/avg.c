/*
 * Compute average of its input values.
 */
#include <stdio.h>

int main()
{
  int    next;                        /* next input value */
  long   sum;                         /* running total */
  int    n;                           /* number of input values */
  int    result;                      /* did we read another value? */
  double avg;                         /* average of input values */

  sum = 0;
  n = 0;
  while ((result = scanf("%i", &next)) == 1)
  {
    sum = sum + next;
    n = n + 1;
  }
  if (result != EOF)
    printf("Warning: bad input after reading %i values\n", n);
  if (n == 0)
    avg = 0.0;
  else
    avg = (double) sum / n;
  printf("Average of %i values is %f.\n", n, avg);

  return 0;
}
