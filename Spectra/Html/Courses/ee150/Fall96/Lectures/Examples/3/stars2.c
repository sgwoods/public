/*
 * Rewrite of stars program using "for" loop.
 */
#include <stdio.h>

#define WANTED_ROWS   3
#define WANTED_STARS  6

main()
{
  int rows;
  int stars;

  for (rows = 1; rows <= WANTED_ROWS; rows = rows + 1)
  {
    for (stars = 1; stars <= WANTED_STARS; stars = stars + 1)
    {
      printf("*");
    }
    printf("\n");
  }
  return 0;
}
