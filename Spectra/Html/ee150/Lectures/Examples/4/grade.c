/*
 * Read score and tell student whether passed or failed.
 */
#include <stdio.h>

main()
{
  int score;

  scanf("%i", &score);
  if (score >= 70)
    printf("Yahoo.  You passed!\n");
  else
    printf("How sad.  You failed!\n");
  return 0;
}
