/*
 * Define the student structure, prototypes for functions that use it,
 * and prototypes for other useful functions for this assignment.
 */
#include <stdio.h>
#include <string.h>

#define MAX_STUDENTS     20      /* Maximum students in table */
#define MAX_SCORES       10
#define MAX_INPUT_LEN    80

#define MAX_ACCOUNT_LEN   8
#define MAX_NAME_LEN     40

struct student
{
  char account[MAX_ACCOUNT_LEN + 1];
  char name[MAX_NAME_LEN + 1];
  int  id;      
  int  avg;
  int  score_index;              /* Not for part 1--for part 2 */
};

int lookupStudent(struct student t[], int n, int target_id);
void printStudentTable(struct student t[], int n);
void printScoreTable(int scores[][MAX_SCORES], int rows, int columns);

int readStudentInfo(char account[], int maxacct, char name[], int maxname,
                    int *student_id_ptr);
int readStudentScores(int *id_ptr, int scores[], int expected_scores);

int computeAverage(int t[], int n);
int readNumber(int *ptr);
void copyTable(int src[], int dest[], int n);

int getline(char line[], int maxlen);

void sortStudentTableByAverage(struct student t[], int n);
