/*
 * Read input and print, printing an error message if the input is bad.
 */
#include <stdio.h>

main()
{
  int i;
  double d;
  int n;

  printf("Enter an integer and a real: ");
  n = scanf("%i %lf", &i, &d);
  if (n == 2)
    printf("You entered %i and %.2f\n", i, d);
  else
    printf("You only entered %i values.\n", n);
  printf("Aloha.  I quit!\n");
  return 0;
}
