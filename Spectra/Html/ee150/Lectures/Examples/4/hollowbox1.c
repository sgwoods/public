/*
 * Draw a hollow box of the specified size (using functions).
 */
#include <stdio.h>

main()
{
  void drawHollowBox(int h, int w);   

  int height;
  int width;

  scanf("%i %i", &height, &width);
  drawHollowBox(height, width);
  return 0;
}

void drawHollowBox(int h, int w)
{
  void drawLine(int length);
  void drawEndPoints(int length);

  int i;

  drawLine(w);
  for (i = 1; i <= h - 2; i = i + 1)
    drawEndPoints(w);
  drawLine(w);
}

void drawLine(int length)
{
  int i;

  for (i = 1; i <= length; i = i + 1)
    printf("*");
  printf("\n");
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
