/*
 * An example of a structure containing arrays.
 *
 * Read and print student, assuming no errors.  (Assumes getline and
 * readValues from assignment #5.)
 */
#include <stdio.h>

#define MAX_NAME_LEN 40
#define MAX_SCORES   10

struct student
{
  char name[MAX_NAME_LEN + 1];
  int  scores[MAX_SCORES];
  int  num;
};

main()
{
  int getline(char line[], int max);
  int readValues(int scores[], int expected);
  void printStudent(struct student s);

  struct student s;

  getline(s.name, MAX_NAME_LEN);
  s.num = readValues(s.scores, MAX_SCORES);
  printStudent(s);
  return 0;
}

void printStudent(struct student x)
{
  printf("%s\n", x.name);
  printValues(x.scores, x.num);
}
