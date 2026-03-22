/* 
 * Read strings into a structure field.
 */
#include <stdio.h>

#define MAXLINE 80
#define ENTRIES 50

struct student
{
  char *name;
};

main()
{
  struct student table[ENTRIES];
  char *strdup(char s[]);
  char inputline[MAXLINE + 1];
  int n = 0;
  int i;

  while (getline(inputline, MAXLINE) != -1)
    table[n++].name = strdup(inputline);
  for (i = 0; i < n; i++)
    printf("%s\n", table[i].name);
  return 0;
}
