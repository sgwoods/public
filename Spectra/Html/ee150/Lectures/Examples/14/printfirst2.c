/*
 * Print just the first name without modifying the string to print.
 */
#include <stdio.h>
#include <string.h>

#define MAXLINE 80

main()
{
  int getline(char s[], int m);

  char name[MAXLINE + 1];
  char temp[MAXLINE + 1];

  while (getline(name, MAXLINE) != -1)
  {
    int blank = findCharacter(name, ' ');

    if (blank == -1)
      printf("No blank in name.\n");
    else
    {
      strncpy(temp, name,blank);  /* copy up to blank in temp */
      printf("%s\n", temp);       /* then print temp */
    }
  }
  return 0;
}
