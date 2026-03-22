/*
 * Line number input.
 */
#include <stdio.h>

#define MAXLINE 80

main()
{
  int getline(char line[], int max);
 
  char inputline[MAXLINE + 1];
  int linecount = 0;

  while (getline(inputline, MAXLINE) != -1)
    printf("%i %s\n", ++linecount, inputline);
  return 0;
}
