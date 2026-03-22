/*
 * Repeatedly read input values.
 */
#include <stdio.h>

main()
{
  int i;
  double d;
  int n;

  printf("Enter an integer and a real: ");
  n = scanf("%i %lf", &i, &d);
  while (n == 2)
  {
    printf("You entered %i and %.2f\n", i, d);
    printf("Enter an integer and a real: ");
    n = scanf("%i %lf", &i, &d);
  }
  printf("Aloha.  I quit!\n");
  return 0;
}
