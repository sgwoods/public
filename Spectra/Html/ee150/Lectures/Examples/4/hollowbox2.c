/*
 * Draw a hollow box of the specified size (without using functions);
 */
#include <stdio.h>

main()
{
  void drawHollowBox(int h, int w);   

  int height;
  int width;
  int i;
  int j;

  scanf("%i %i", &height, &width);
  for (i = 1; i <= width; i = i + 1)
    printf("*");
  printf("\n");
  for (i = 1; i <= height - 2; i = i + 1)
  {
    printf("*");
    for (j = 1; j <= width - 2; j = j + 1)
      printf(" ");
    printf("*");
    printf("\n");
  }
  for (i = 1; i <= width; i = i + 1)
    printf("*");
  printf("\n");
  return 0;
}

void drawEndPoints(int length)
{
  void drawSpaces(int n);

  printf("*");
  drawSpaces(length - 2);
  printf("*");
  printf("\n");
}

void drawSpaces(int n)
{
  int i;

  for (i = 1; i <= n; i = i + 1)
    printf(" ");
}
