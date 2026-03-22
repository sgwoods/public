/*
 * An example of printing all values in the input that are larger than
 * the average.
 */
#include <stdio.h>

#define ELEMENTS 100   

int main()
{
  int a[ELEMENTS];     /* room for 100 elements */
  int count;           /* how many values are actually in the array */
  int value;           /* next input value */
  int i;              
  int sum;
  double avg;

  /* read in values; just like before */

  count = 0;
  while (scanf("%i", &value) == 1)
  {
    a[count] = value;  /* save value into an array */
    count++;
  }

  /* run through array computing sum */

  sum = 0;
  for (i = 0; i <= count - 1; i++)
    sum += a[i];
  avg = (count > 0) ? (double) sum / count : 0.0;

  /* print larger than average values in array */

  for (i = 0; i <= count - 1; i++)
    if (a[i] > avg)
      printf("%i\n", a[i]);

  return 0;
}
