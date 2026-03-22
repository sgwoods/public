/*
 * Solution to Assignment 5, Part 3.
 */
#include <stdio.h>
#include <stdlib.h>
#include "tables.h"

#define MAX_GRADES 5

main()
{
  double computeWeightedAverage(int scores[], int weights[], int n);
  int    assignGrades(double avg, int min_scores[]);
  void   printSummaryInfo(int counts[], char grades[], int n);
  void   printAverages(double averages[], int n, int min_scores[],
                       char grades[], int grade_counts[]);
  int    obtainKeyValues(int *maxstudentptr);
  int    obtainWeights(int weights[], int assignments);
  int    obtainGrades(int min_scores[]);

  int  assignments;
  int  n;
  int  max_students;
  int  students;
  int  min_scores[MAX_GRADES];
  int  grade_counts[MAX_GRADES + 1];
  char grades[MAX_GRADES + 1] = {'A', 'B', 'C', 'D', 'F', '?'};

  int *next_scores;       /* will be allocated to hold one set of scores */
  int *weights;           /* will be allocated to hold one set of weights */
  double *averages;       /* will be allocated to hold averages of all */

  if ((assignments = obtainKeyValues(&max_students)) != -1)
  {
    next_scores = malloc(sizeof(int) * assignments);
    weights = malloc(sizeof(int) * assignments);
    averages = malloc(sizeof(double) * max_students);

    if (obtainWeights(weights, assignments) && obtainGrades(min_scores))
    {
      students = 0;
      assignValues(grade_counts, MAX_GRADES, 0);

      while ((n = readValues(next_scores, assignments)) == assignments)
      {
        double avg = computeWeightedAverage(next_scores, weights, assignments);

        if (students >= max_students)
        {
          printf("Only first %i students processed.\n", students);
          break;
        }
        insertDoubleValue(averages, students++, avg);
      }
      if (n != -1 && n != assignments)
        printf("Can't read scores for student %i.\n", students + 1);
      else 
      {
        printAverages(averages, students, min_scores, grades, grade_counts);
        printf("\nThere are %i students.\n", students);
        printSummaryInfo(grade_counts, grades, MAX_GRADES);
      }
    }
  }
  return 0;
}

/*
 * New functions for Part III.
 */
void printAverages(double averages[], int n, int min_scores[],
                   char grades[], int grade_counts[])
{
  int i;

  for (i = n - 1; i >= 0; i--)
  {
    int grade = assignGrade(averages[i], min_scores);

    printf("%.2lf %c\n", averages[i], grades[grade]);
    grade_counts[grade]++;
  }
}

/*
 * This function in a modified version of obtainAssignments
 * from Part II.
 */
int obtainKeyValues(int *maxstudentptr)
{
  int num_assignments;

  if (scanf("%i %i", &num_assignments, maxstudentptr) != 2)
  {
    printf("Can't read the number of assignments and students.\n");
    return -1;                 /* failed */
  }
  return num_assignments;      /* succeeded! */
}

/*
 * These functions remain unchanged from Part II.
 */
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
