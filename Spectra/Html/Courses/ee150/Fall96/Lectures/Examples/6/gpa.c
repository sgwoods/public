/*
 * Print a student's GPA, reading in a set of letter grades in the 
 * input.
 *
 * Doesn't quite work (because if the input includes \n's, they're
 * counted as part of the grade).
 */
#include <stdio.h>

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
    total_grades = total_grades + 1;
    points = calculatePoints(grade);
    total_points = total_points + points;
  }
  printf("%.1f\n", total_points / total_grades);
  return 0;
}

int calculatePoints(char g)
{
  int p;

  if (g == 'A')
    p = 4;
  else
  {
    if (g == 'B')
      p = 3;
    else
    {
      if (g == 'C')
        p = 2;
      else
      {
        if (g == 'D')
           p = 1;
        else
           p = 0;
      }
    }
  }
  return p;
}
