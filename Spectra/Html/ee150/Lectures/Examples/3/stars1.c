/*
 * Write 6 rows of 3 stars.
 */
#include <stdio.h>

#define WANTED_ROWS   3
#define WANTED_STARS  6

main()
{
  int rows;
  int stars;

  rows = 1;
  while (rows <= WANTED_ROWS)
  {
    stars = 1;
    while (stars <= WANTED_STARS)
    {
      printf("*");
      stars = stars + 1;
    }
    printf("\n");
    rows = rows + 1;
  }
  return 0;
}
