/*
 * Print the values between START and FINISH and their cumulative sum.
 */
#include <stdio.h>

#define START   3
#define FINISH  7

main()
{
  int value;
  int sum;

  printf("Value\tSum\n");

  value = START;
  sum = 0;
  while (value <= FINISH)
  {
    sum = sum + value;
    printf("%i\t%i\n", value, sum);
    value = value + 1;
  }
  return 0;
}
