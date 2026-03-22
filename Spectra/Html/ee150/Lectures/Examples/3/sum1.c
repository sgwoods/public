/*
 * Print the values between START and FINISH.
 */
#include <stdio.h>

#define START   3
#define FINISH  7

main()
{
  int value;

  printf("Value\n");

  value = START;
  while (value <= FINISH)
  {
    printf("%i\n", value);
    value = value + 1;
  }
  return 0;
}
