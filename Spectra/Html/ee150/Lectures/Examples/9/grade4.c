/*
 * Grading program using "else-if"s, but extended to do "+'s" and "-'s".
 *
 * This version treats each different grade (A+, A, etc...) as a separate
 * action.
 */
#include <stdio.h>

int main()
{
  int score;

  while (scanf("%i", &score) == 1)
  {
    if (score >= 90)
    {
      printf("A");
      if (score >= 97)
        printf("+");
      if (score < 93)
        printf("-");
    }
    else if (score >= 80)
    {
      printf("B");
      if (score >= 87)
        printf("+");
      if (score < 83)
        printf("-");
    }
    else if (score >= 70)
    {
      printf("C");
      if (score >= 77)
        printf("+");
      if (score < 73)
        printf("-");
    }
    else if (score >= 60)
    {
      printf("D");
      if (score >= 67)
        printf("+");
      if (score < 63)
        printf("-");
    }
    else
      printf("F");
    putchar('\n');
  }
  return 0;
}
