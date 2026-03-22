/*
 * Print just the last name.
 */
#include <stdio.h>

#define MAXLINE 80

main()
{
  int getline(char s[], int m);

  char name[MAXLINE + 1];
  while (getline(name, MAXLINE) != -1)
  {
    int blank = findCharacter(name, ' ');

    if (blank == -1)
      printf("No blank in name.\n");
    else
      printf("%s\n", &name[blank + 1]);
  }
  return 0;
}
