/*
 * Rewrite of stars program to perform input.
 */
#include <stdio.h>

main()
{
  int wanted_rows;
  int wanted_stars;
  int rows;
  int stars;

  printf("Desired number of rows? ");
  scanf("%i", &wanted_rows);
  printf("Desired number of stars in each row? ");
  scanf("%i", &wanted_stars);

  for (rows = 1; rows <= wanted_rows; rows = rows + 1)
  {
    for (stars = 1; stars <= wanted_stars; stars = stars + 1)
    {
      printf("*");
    }
    printf("\n");
  }
  return 0;
}
