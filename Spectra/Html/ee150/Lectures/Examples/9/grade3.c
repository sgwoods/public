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
    if (score >= 97)
      printf("A+");
    else if (score >= 93)
      printf("A");
    else if (score >= 90)
      printf("A-");
    else if (score >= 87)
      printf("B+");
    else if (score >= 83)
      printf("B");
    else if (score >= 80)
      printf("B-");
    else if (score >= 77)
      printf("C+");
    else if (score >= 73)
      printf("C");
    else if (score >= 70)
      printf("C-");
    else if (score >= 67)
      printf("D+");
    else if (score >= 64)
      printf("D");
    else if (score >= 60)
      printf("D-");
    else
      printf("F");
    putchar('\n');
  }
  return 0;
}
