/*
 * Print just the first name without modifying the string to print.
 */
#include <stdio.h>
#include <string.h>

#define MAXLINE 80

main()
{
  int getline(char s[], int m);

  char name[MAXLINE + 1];      /* first name first */
  char newname[MAXLINE + 1];   /* last name first */

  while (getline(name, MAXLINE) != -1)
  {
    int blank = findCharacter(name, ' ');

    if (blank == -1)
      printf("No blank in name.\n");
    else
    {
      strcpy(newname, &name[blank + 1]);   /* copy last name to first /
      strcat(newname, ", ");               /* add , and space */
      strncat(newname, name, blank);       /* copy up to blank to temp */
      printf("%s\n", newname);             /* then print temp */
    }
  }
  return 0;
}
