/*
 * Solution to Assignment 5, Part 1.
 */
#include <stdio.h>
#include "tables.h"

#define MAX_ASSIGNMENTS 10
#define MAX_GRADES 5           /* For minimums: A, B, C, D, and F */

main()
{
  double computeWeightedAverage(int scores[], int weights[], int n);
  int    assignGrades(double avg, int min_scores[]);

  int  assignments;                    /* Number of assignments */
  int  weights[MAX_ASSIGNMENTS];       /* Weights table */
  int  min_scores[MAX_GRADES];         /* Minimum scores table */
  char grades[MAX_GRADES + 1] = {'A', 'B', 'C', 'D', 'F', '?'};
  int  next_scores[MAX_ASSIGNMENTS];   /* Scores from next student */

  scanf("%i", &assignments);
  readValues(weights, assignments);

  readValues(min_scores, MAX_GRADES - 1);   
  min_scores[MAX_GRADES - 1] = 0;

  while (readValues(next_scores, assignments) == assignments)
  {
    double avg = computeWeightedAverage(next_scores, weights, assignments);
    int grade = assignGrade(avg, min_scores);

    printf("%.2lf %c\n", avg, grades[grade]);
  }
  return 0;
}

double computeWeightedAverage(int scores[], int weights[], int n)
{
  long weighted_sum = 0;
  int i;

  for (i = 0; i < n; i++)
    weighted_sum += scores[i] * weights[i];
  return weighted_sum / 100.0;
}

int assignGrade(double avg, int min_scores[])
{
  int i;

  for (i = 0; i < MAX_GRADES; i++)
    if (avg >= min_scores[i]) 
      return i;
  return MAX_GRADES;
}
