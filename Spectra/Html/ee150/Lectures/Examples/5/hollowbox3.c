/*
 * Draw a hollow box of the specified size and print out the number
 * of stars drawing the hollow box required.
 */
#include <stdio.h>

main()
{
  int drawHollowBox(int h, int w);   

  int height;
  int width;
  int stars_written;

  scanf("%i %i", &height, &width);
  stars_written = drawHollowBox(height, width);
  printf("Drawing this box required writing %i stars\n", stars_written);
  return 0;
}

int drawHollowBox(int h, int w)
{
  void drawLine(int length);
  void drawEndPoints(int length);

  int i;
  int stars;

  drawLine(w);
  for (i = 1; i <= h - 2; i = i + 1)
    drawEndPoints(w);
  drawLine(w);
  stars = w + w + (h - 2) * 2;
  return stars;
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
