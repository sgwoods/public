/*
 * Echo an input value, along with scanf's return value.
 */
#include <stdio.h>

main()
{
  int i;
  double d;
  int n;

  printf("Enter an integer and a real: ");
  n = scanf("%i %lf", &i, &d);
  printf("You entered %i and %.2f\n", i, d);
  printf("Scanf returned: %i\n", n);
  return 0;
}
