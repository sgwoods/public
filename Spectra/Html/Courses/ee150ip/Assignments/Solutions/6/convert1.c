/*
 * Solution to Program #6, Part #1
 */
#include <stdio.h>
#include <string.h>
#include "helpers.h"

#define MAXLINE 80
#define MAXCODE 80

main()
{
  int readCodes(char from[], char to[]);
  void convert(char in[], char out[], char from[], char to[]);

  char inputline[MAXLINE + 1], outputline[MAXLINE + 1];
  char from[MAXLINE + 1], to[MAXLINE + 1];

  if (readCodes(from, to) != -1)
    while (getline(inputline, MAXLINE) != -1)
    {
      convert(inputline, outputline, from, to);
      printf("%s\n", outputline);
    }
  return 0;
}

int readCodes(char from[], char to[])
{
  char codeline[MAXLINE + 1];
  char blankpos;

  if (getline(codeline, MAXLINE) == -1)
  {
    printf("Missing conversion tables.\n");
    return -1;   /* failure! */
  }
  if ((blankpos = findCharacter(codeline, ' ')) == -1)
  {
    printf("Missing blank.\n");
    return -1;   /* failure! */
  }
  copySubString(codeline, from, 0, blankpos);
  copySubString(codeline, to, blankpos + 1, strlen(codeline) - blankpos - 1);
  if (strlen(from) != strlen(to))
  {
    printf("Can't map \"%s\" to \"%s\".\n", from, to);
    return -1;
  }
  return 0;
}

void convert(char in[], char out[], char from[], char to[])
{
  int i, pos;

  for (i = 0; in[i] != '\0'; i++)
    if ((pos = findCharacter(from, in[i])) != -1)
      out[i] = to[pos];
    else
      out[i] = in[i];
  out[i] = '\0';
}
