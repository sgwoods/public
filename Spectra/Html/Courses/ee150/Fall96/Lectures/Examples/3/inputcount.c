/*
 * Repeatedly read input values and count how many were read.
 */
#include <stdio.h>

main()
{
  int i;
  double d;
  int n;
  int count;

  count = 0;
  printf("Enter an integer and a real: ");
  n = scanf("%i %lf", &i, &d);
  while (n == 2)
  {
    printf("You entered %i and %.2f\n", i, d);
    count = count + 1;
    printf("Enter an integer and a real: ");
    n = scanf("%i %lf", &i, &d);
  }
  printf("You entered a total of %i values.\n", count);
  printf("Aloha.  I quit!\n");
  return 0;
}
