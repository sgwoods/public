/*
 * A program to count the number of each test score in the input.
 */
#include <stdio.h>

int counters[101];     /* 0 .. 100 */

main()
{
  void updateCounters();
  void printCounters();

  updateCounters();
  printCounters();
  return 0;
}

void updateCounters()
{
  int score;

  while (scanf("%i", &score) == 1)
    if (score >= 0 && score <= 100)
      counters[score]++;
}

void printCounters()
{
  int i;

  for (i = 100; i >= 0; i--)
    if (counters[i] != 0)
      printf("%i (%i)\n", i, counters[i]);
}
