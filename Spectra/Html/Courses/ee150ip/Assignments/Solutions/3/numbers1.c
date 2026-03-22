/*
 * Solution to Assignment #3, Part #4.
 */
#include <stdio.h>

main()
{
  void drawZero(int height, int length);
  void drawOne(int height, int length);
  void drawSeven(int height, int length);

  int height;
  int width;

  if (scanf("%i %i", &height, &width) == 2)
  {
    drawZero(height,width); 
    printf("\n");
    drawOne(height,width);
    printf("\n");
    drawSeven(height,width);
    printf("\n");
  }
}

/*
 * Number drawing functions (all of them).
 */
void drawZero(int height, int length)
{
  void drawLine(int length);
  void drawBothEndPointsNtimes(int lines, int length);

  drawLine(length);
  drawBothEndPointsNtimes(height - 2, length);
  drawLine(length);
}

void drawOne(int height, int length)
{
  void drawRightEndPointNtimes(int lines, int length);

  drawRightEndPointNtimes(height, length);
}

void drawSeven(int height, int length)
{
  void drawLine(int length);
  void drawRightEndPointNtimes(int lines, int length);

  drawLine(length);
  drawRightEndPointNtimes(height - 1, length);
}

/*
 * Helper functions.
 */
void drawBothEndPointsNtimes(int lines, int length)
{
  void drawBlanks(int n);
  int i;

  for (i = 0; i < lines; i++)
  {
    printf("x");
    drawBlanks(length - 2);
    printf("x\n");
  }
}

void drawRightEndPointNtimes(int lines, int length)
{
  void drawBlanks(int n);
  int i;

  for (i = 0; i < lines; i++)
  {
    drawBlanks(length - 1);
    printf("x\n");
  }
}

/*
 * Lowest level functions.
 */
void drawLine(int length)
{
  int i;

  for (i = 0; i < length; i++)
    printf("x");
  printf("\n");
}

void drawBlanks(int n)
{
  int i;

  for (i = 0; i < n; i++)
    printf(" ");
}
