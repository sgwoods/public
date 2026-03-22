/* 
 * Reverse input (strings)
 */
#include <stdio.h>

#define MAXLINE 80
#define ENTRIES 50

main()
{
  char *table[ENTRIES];
  char *strdup(char s[]);
  char inputline[MAXLINE + 1];
  int n = 0;
  int i;

  while (getline(inputline, MAXLINE) != -1)
    table[n++] = strdup(inputline);
  for (i = n - 1; i >= 0; i--)
    printf("%s\n", table[i]);
  return 0;
}
