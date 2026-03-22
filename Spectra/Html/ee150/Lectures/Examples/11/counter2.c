/*
 * A program to count the number of each test score in the input.
 * This time we've redone it without the global variable.
 */
#include <stdio.h>

main()
{
  void zeroCounters(int t[], int max);
  void updateCounters(int t[], int max);
  void printCounters(int t[], int max);

  int counters[101];     /* 0 .. 100 */

  zeroCounters(counters, 100);
  updateCounters(counters, 100);
  printCounters(counters, 100);
  return 0;
}

void zeroCounters(int t[], int max)
{
  int i;

  for (i = 0; i <= max; i++)
    t[i] = 0;
}

void updateCounters(int t[], int max)
{
  int score;

  while (scanf("%i", &score) == 1)
    if (score >= 0 && score <= max)
      t[score]++;
}

void printCounters(int t[], int max)
{
  int i;

  for (i = max; i >= 0; i--)
    if (t[i] != 0)
      printf("%i (%i)\n", i, t[i]);
}
