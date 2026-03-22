/*
 * Draw a filled box of the specified size.
 */
#include <stdio.h>

main()
{
  void drawFilledBox(int h, int w);   

  int height;
  int width;

  scanf("%i %i", &height, &width);
  drawFilledBox(height, width);
  return 0;
}

void drawFilledBox(int h, int w)
{
  void drawLine(int length);

  int i;

  for (i = 1; i <= h; i = i + 1)
    drawLine(w);
}

void drawLine(int length)
{
  int i;

  for (i = 1; i <= length; i = i + 1)
    printf("*");
  printf("\n");
}
