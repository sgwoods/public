/*
 * Define the student structure, prototypes for functions that use it,
 * and prototypes for other useful functions for this assignment.
 */
#include "student.h"

/*
 * lookupStudent - search table for student with given id
 *
 *   Takes a table of students, the number of entries in
 *     the table and a target id.
 *
 *   Returns the position of that student or -1 if it can't 
 *     find the desired student.
 * 
 */
int lookupStudent(struct student t[], int n, int target_id)
{
  int i;

  for (i = 0; i < n; i++)
    if (t[i].id == target_id)
      return i;
  return -1;
}

/*
 * printStudentTable - dump table (useful for debugging).
 *
 *   Takes the table and the number of entries in it.
 */
void printStudentTable(struct student t[], int n)
{
  int i;

  for (i = 0; i < n; i++)
  {
    struct student *ptr = &t[i];
    printf("Entry: %i\nAccount: %s\nName: %s\nId: %i\nAvg: %i\n",
           i, ptr->account, ptr->name, ptr->id, ptr->avg);
  }
}

/*
 * printScoresTable - dump 2-d array (useful for debugging).
 *
 *
 *    Takes the table and the number of rows and columns to dump.
 */
void printScoreTable(int scores[][MAX_SCORES], int rows, int columns)
{
  int r, c;

  for (r = 0; r < rows; r++)
  { 
    for (c = 0; c < columns; c++)
      printf("%i ", scores[r][c]);
    printf("\n");
  }
}

/*
 * readStudentInfo - Read the information in for a student.
 *
 *   The info is:
 *     
 *      account name (on a line by itself)
 *      student name (on a line by itself)
 *      student id (on a line by itself)
 *
 *   This function is passed the following information:
 *
 *       1) array to store account name
 *       2) size of that array - 1
 *       3) array to store student name
 *       4) size of that array - 1
 *       5) pointer to place to put student id
 *
 *   Fills in its parameters with this information.
 *
 *   Returns:
 *     -1: If it hit EOF or an error when trying to read the input.
 *      0: If it terminated normally with a "." when it was trying to
 *         read the account name (in that case, it quietly sets the
 *         names to null strings and the student id to -1).
 *      1: If it read a student normally.
 */
int readStudentInfo(char account[], int maxacct,
                    char name[], int maxname,
                    int *student_id_ptr)
{
  int getline(char line[], int max);
  
  name[0] = '\0';
  *student_id_ptr = 0;

  if (getline(account, maxacct) == -1)
    return -1;        /* EOF when trying to read the account name */

  if (strcmp(account, ".") == 0)
  {
    account[0] = '\0';
    return 0;         /* Hit the line with just . on it */
  }

  if (getline(name, maxname) == -1 || readNumber(student_id_ptr) != 1)
    return -1;        /* EOF or error when reading name/id */

  return 1;    /* read everything alright */
}

/*
 * Read the id and scores for a given student (assuming everything is
 * one per line).
 *
 *   Takes pointer to place to put id, array to put scores, and the
 *   number of scores we expect to read.
 *
 *   Returns -1 if it hits EOF when reading the ID, 0 if it can't read
 *   the id and expected scores, and the number of scores it was 
 *   expected to read if it read all of them.
 */
int readStudentScores(int *id_ptr, int scores[], int expected_scores)
{
  int i;
  int r;

  if ((r = readNumber(id_ptr)) != 1)
    return r;     /* failure to read id */

  for (i = 0; i < expected_scores; i++)
    if (readNumber(&scores[i]) != 1)
      return 0;   /* failure to read a score we expect - assume error */
  return expected_scores;
}

/*
 * Sort a table of students by average.
 * 
 *    Takes table of students and the number of entries in the table.
 */
void sortStudentTableByAverage(struct student t[], int n)
{
  int compare_student_avg(void *, void *);

  qsort(t, n, sizeof(struct student), compare_student_avg);
}

int compare_student_avg(void *s1ptr, void *s2ptr)
{
  struct student *p = s1ptr;
  struct student *q = s2ptr;

  return p->avg - q->avg;
}


/*
 * computeAverage - compute average of an array of integers and
 *   return it as an int (truncating the part after the decimal).
 */
int computeAverage(int t[], int n)
{
  int i;
  long sum = 0;

  for (i = 0; i < n; i++)
    sum += t[i];
  return (n == 0) ? 0 : sum / n;
}

/*
 * copyTable - copy one array of ints into another.  The first parameter is
 *    the array you want to copy, the second is the array to copy it into,
 *    and the last is the number of elements to copy.
 */
void copyTable(int src[], int dest[], int n)
{
  int i;
  
  for (i = 0; i < n; i++)
    dest[i] = src[i];
}

/*
 * readNumber
 *
 *   Reads a single number on a line.  
 *
 *   Takes a pointer to the place to put the number (just like scanf).
 *
 *   Returns -1 if it hits EOF, 0 if there is an error, and 1 if it 
 *   reads the number successfully.
 *
 */
int readNumber(int *ptr)
{
  char line[MAX_INPUT_LEN + 1];

  if (getline(line, MAX_INPUT_LEN) == -1)
    return -1;
  return (sscanf(line, "%i", ptr) == 1) ? 1 : 0;
}

/*
 * getline (see book for description)
 */
int getline(char line[], int max)
{
  int c;
  int i = 0;

  while ((c = getchar()) != '\n' && c != EOF)
    if (i < max)
      line[i++] = c;
  line[i] = '\0';
  return (c == EOF) ? -1 : i;
}
