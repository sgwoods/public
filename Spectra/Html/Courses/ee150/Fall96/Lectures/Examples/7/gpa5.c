/*
 * Print a student's GPA, reading in a set of letter grades in the input.
 * This version does calculatePoints more simply.
 *
 */
#include <stdio.h>
#include <ctype.h>

main()
{
  int calculatePoints(char g);

  char   grade;    
  double total_points;
  int    points;
  int    total_grades;

  total_points = 0.0;
  total_grades = 0;

  while (scanf("%c", &grade) == 1)
  {
    if (grade != '\n')
    {
      points = calculatePoints(grade);
      if (points != -1)
      {
        total_grades = total_grades + 1;
        total_points = total_points + points;
      }
      else
        printf("Bad input: %c\n", grade);
    }
    else
    {
      if (total_grades != 0)  /* protect against divide by zero */
         printf("%.1f\n", total_points / total_grades);
      total_grades = 0;
      total_points = 0.0;
    }
  }
  return 0;
}

int calculatePoints(char g)
{
  int p;

  g = toupper(g);       /* Make the grade uppercase */
  p = -1;               /* Default is bad parameter */

  if (g == 'A')
    p = 4;
  if (g == 'B')
    p = 3;
  if (g == 'C')
    p = 2;
  if (g == 'D')
    p = 1;
  if (g == 'F')
    p = 0;
  return p;
}
