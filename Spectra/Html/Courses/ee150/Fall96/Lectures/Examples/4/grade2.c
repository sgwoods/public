/*
 * Read score and tell student whether passed or failed.
 */
#include <stdio.h>

main()
{
  int score;
  int n;

  n = scanf("%i", &score);
  while (n == 1)
  {
    if (score >= 70)
      printf("Yahoo.  You passed!\n");
    else
      printf("How sad.  You failed!\n");
    n = scanf("%i", &score);
  }
  return 0;
}
