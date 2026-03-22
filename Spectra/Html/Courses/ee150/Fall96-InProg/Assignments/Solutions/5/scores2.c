/*
 * Solution to Assignment 5, Part 2.
 */
#include <stdio.h>
#include "tables.h"

#define MAX_ASSIGNMENTS 10
#define MAX_GRADES 5

main()
{
  double computeWeightedAverage(int scores[], int weights[], int n);
  int    assignGrades(double avg, int min_scores[]);
  void   printSummaryInfo(int counts[], char grades[], int n);
  int    obtainAssignments(int max_assignments);
  int    obtainWeights(int weights[], int assignments);
  int    obtainGrades(int min_scores[]);

  int  assignments;                    /* Number of assignments */
  int  students;                       /* Total number of students */
  int  n;                              /* # of assignments read  for student */

  int  weights[MAX_ASSIGNMENTS];       /* Weights table */
  int  min_scores[MAX_GRADES];         /* Minimum scores table */
  char grades[MAX_GRADES + 1] = {'A', 'B', 'C', 'D', 'F', '?'};
  int  grade_counts[MAX_GRADES + 1];   /* Counters for each grade */
  int  next_scores[MAX_ASSIGNMENTS];   /* Scores from next student */

  if ((assignments = obtainAssignments(MAX_ASSIGNMENTS)) != -1 &&
       obtainWeights(weights, assignments) != -1 &&
       obtainGrades(min_scores) != -1)
  {
    students = 0;
    assignValues(grade_counts, MAX_GRADES, 0);

    while ((n = readValues(next_scores, assignments)) == assignments)
    {
      double avg = computeWeightedAverage(next_scores, weights, assignments);
      int grade = assignGrade(avg, min_scores);
      
      printf("%.2lf %c\n", avg, grades[grade]);
      grade_counts[grade]++;
      students++;
    }
    if (n != -1)
      printf("Can't read scores for student %i.\n", students + 1);
    else
    {
      printf("\nThere are %i students.\n", students);
      printSummaryInfo(grade_counts, grades, MAX_GRADES);
    }
  }
  return 0;
}

/*
 * New functions for part II.
 *   obtainAssignments - get the # of assignments and verify it's legit
 *   obtainWeights - get the weights and verify they're legit.
 *   obtainGrades - get the grading scale and verify it's legit.
 *   printSummaryInfo - print all of the summary information.
 */

int obtainAssignments(int max_assignments)
{
  int num_assignments;

  if (scanf("%i", &num_assignments) != 1)
  {
    printf("Can't read the number of assignments.\n");
    return -1;   /* failed! */
  }
  if (num_assignments > max_assignments)
  {
    printf("Too many assignments (%i).  Can only handle %i\n",
            num_assignments, max_assignments);
    return -1;   /* failed! */
  }
  return num_assignments;      /* succeeded! */
}

int obtainWeights(int weights[], int assignments)
{
  int weight_sum;     /* holds sum of weights */

  if (readValues(weights, assignments) != assignments)
  {
    printf("Can't read expected number of weights.\n");
    return -1;    /* failed! */
  }
  if ((weight_sum = sumValues(weights, assignments)) != 100)
  {
    printf("Weights sum to %i rather than 100.\n", weight_sum);
    return -1;    /* failed! */
  }
  return 1;       /* succeeded! */
}

int obtainGrades(int min_scores[])
{
  if (readValues(min_scores, MAX_GRADES - 1) != MAX_GRADES - 1)
  {
    printf("Can't read minimum scores for grades.\n");
    return -1;    /* failed! */
  }
  min_scores[MAX_GRADES - 1] = 0;   /* Minimum for F */
  return 1;       /* suceeded! */
}

void printSummaryInfo(int counts[], char grades[], int n)
{
  int i;

  for (i = 0; i < n; i++)
    if (counts[i] != 0)
      printf("%c: %i\n", grades[i], counts[i]);
}

/*
 * These functions are unchanged from Part 1.
 */
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
