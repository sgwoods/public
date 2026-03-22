/*
 * Solution to Assignment #3, Part #4.
 */
#include <stdio.h>

main()
{
  void drawZero(int height, int length);
  void drawOne(int height, int length);
  void drawTwo(int height, int length);
  void drawThree(int height, int length);
  void drawFour(int height, int length);
  void drawFive(int height, int length);
  void drawSix(int height, int length);
  void drawSeven(int height, int length);
  void drawEight(int height, int length);
  void drawNine(int height, int length);

  int height;
  int width;

  if (scanf("%i %i", &height, &width) == 2)
  {
    drawZero(height,width); 
    printf("\n");
    drawOne(height,width);
    printf("\n");
    drawTwo(height,width);
    printf("\n");
    drawThree(height,width);
    printf("\n");
    drawFour(height,width);
    printf("\n");
    drawFive(height,width);
    printf("\n");
    drawSix(height,width);
    printf("\n");
    drawSeven(height,width);
    printf("\n");
    drawEight(height,width);
    printf("\n");
    drawNine(height,width);
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

void drawTwo(int height, int length)
{
  void drawLine(int length);
  void drawRightEndPointNtimes(int lines, int length);
  void drawLeftEndPointNtimes(int lines, int length);

  drawLine(length);
  drawRightEndPointNtimes(height / 2 - 1, length);
  drawLine(length);
  drawLeftEndPointNtimes(height / 2 - 1, length);
  drawLine(length);
}

void drawThree(int height, int length)
{
  void drawLine(int length);
  void drawRightEndPointNtimes(int lines, int length);

  drawLine(length);
  drawRightEndPointNtimes(height / 2 - 1, length);
  drawLine(length);
  drawRightEndPointNtimes(height / 2 - 1, length);
  drawLine(length);
}

void drawFour(int height, int length)
{
  void drawLine(int length);
  void drawBothEndPointsNtimes(int lines, int length);
  void drawRightEndPointNtimes(int lines, int length);

  drawBothEndPointsNtimes(height / 2, length);
  drawLine(length);
  drawRightEndPointNtimes(height / 2, length);
}

void drawFive(int height, int length)
{
  void drawLine(int length);
  void drawRightEndPointNtimes(int lines, int length);
  void drawLeftEndPointNtimes(int lines, int length);

  drawLine(length);
  drawLeftEndPointNtimes(height / 2 - 1, length);
  drawLine(length);
  drawRightEndPointNtimes(height / 2 - 1, length);
  drawLine(length);
}

void drawSix(int height, int length)
{
  void drawLine(int length);
  void drawBothEndPointsNtimes(int lines, int length);
  void drawLeftEndPointNtimes(int lines, int length);

  drawLine(length);
  drawLeftEndPointNtimes(height / 2 - 1, length);
  drawLine(length);
  drawBothEndPointsNtimes(height / 2 - 1, length);
  drawLine(length);
}

void drawSeven(int height, int length)
{
  void drawLine(int length);
  void drawRightEndPointNtimes(int lines, int length);

  drawLine(length);
  drawRightEndPointNtimes(height - 1, length);
}

void drawEight(int height, int length)
{
  void drawLine(int length);
  void drawBothEndPointsNtimes(int lines, int length);

  drawLine(length);
  drawBothEndPointsNtimes(height / 2 - 1, length);
  drawLine(length);
  drawBothEndPointsNtimes(height / 2 - 1, length);
  drawLine(length);
}

void drawNine(int height, int length)
{
  void drawLine(int length);
  void drawBothEndPointsNtimes(int lines, int length);
  void drawRightEndPointNtimes(int lines, int length);

  drawLine(length);
  drawBothEndPointsNtimes(height / 2 - 1, length);
  drawLine(length);
  drawRightEndPointNtimes(height / 2 - 1, length);
  drawLine(length);
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

void drawLeftEndPointNtimes(int lines, int length)
{
  int i;

  for (i = 0; i < lines; i++)
    printf("x\n");
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
