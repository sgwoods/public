/*
 *      Solution to Assignment #3 part 2 A
 */

#include <stdio.h>

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
{ int i;
  for (i=0; i < lines; i++)
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

main()
{
   int lines;
   int length;

   length = 5;
   lines = 5;

   /* draw line */
   drawLine(length);
   printf("\n");
   /* draw left end points */
   drawLeftEndPointNtimes(lines, length);
   printf("\n");
   /* draw right end points */
   drawRightEndPointNtimes(lines, length);
   printf("\n");
   /* draw both end points */
   drawBothEndPointsNtimes(lines, length);
   printf("\n");
}

