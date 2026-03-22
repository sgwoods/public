/*
 * Solution to Program #5, Part #3.
 */
#include "student.h"

main()
{
  int readTheStudentTable(struct student table[], int max_students);
  int printTheStudentTable(struct student table[], int n);

  struct student table[MAX_STUDENTS];
  int students, assignments;
  int pos;

  int nextid, next_scores[MAX_SCORES];

  if (readNumber(&assignments) != 1)
    printf("Can't read number of assignments.\n");
  else if ((students = readTheStudentTable(table, MAX_STUDENTS)) == -1)
    printf("Problem in reading student information into table.\n");
  else
  {
    while (readStudentScores(&nextid, next_scores, assignments) != -1)
    {
      if ((pos = lookupStudent(table, students, nextid)) != -1)
        table[pos].avg = computeAverage(next_scores, assignments);
      else
        printf("No student with id: %i\n", nextid);
    }
    sortStudentTableByAverage(table, students);
    printTheStudentTable(table, students);
  }
  return 0;
}

int readTheStudentTable(struct student table[], int max_students)
{
  char account[MAX_ACCOUNT_LEN];
  char name[MAX_NAME_LEN];
  int  id;
  int  s, r;

  for (s = 0; s < max_students; s++)
  {
    r = readStudentInfo(account, MAX_ACCOUNT_LEN, name, MAX_NAME_LEN, &id);
    if (r == -1)   /* Hit EOF or error */
      break;    
    if (r == 0)    /* Hit "." for account name, so stop reading */
      return s;    
 
    strcpy(table[s].account, account);
    strcpy(table[s].name, name); 
    table[s].id = id;
    table[s].avg = -1;
  }
  return -1;       /* Table was full (extras will be treated as scores) */
}

int printTheStudentTable(struct student table[], int n)
{
  int i, j;

  for (i = n - 1; i >= 0; i--)
  {
    if (table[i].avg == -1)   /* hit a bad average, time to stop printing */
      break;
    printf("%s (%s) - %i\n", table[i].name, table[i].account, table[i].avg);
  }
  for (j = i; j >= 0; j--)
    printf("%s (%s) - no input scores\n", table[j].name, table[j].account);
}
