/*
 * Simple bar-chart producer.
 */
#include <stdio.h>

main()
{
  void drawLine(int length);   

  int count;
  int n;

  n = scanf("%i", &count);
  while (n == 1)
  { 
    drawLine(count);
    n = scanf("%i", &count);
  } 
  return 0;
}

void drawLine(int length)
{
  int i;

  for (i = 1; i <= length; i = i + 1)
    printf("*");
  printf("\n");
}
