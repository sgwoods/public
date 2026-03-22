/*
 * Grading program using "nested-if"s.  The braces aren't
 * necessary since we have only one statement inside each if
 * and inside each else.
 */
#include <stdio.h>

int main()
{
  int score;

  while (scanf("%i", &score) == 1)
  {
    if (score >= 90)
      printf("A");
    else
    {
      if (score >= 80)
        printf("B");
      else
      {
        if (score >= 70)
          printf("C");
        else
        {
          if (score >= 60)
            printf("D");
          else
            printf("F");
        }
      }
    }
    putchar('\n');
  }
  return 0;
}
