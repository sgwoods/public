/*
 * Solution to Problem #6, Part #2.
 */
#include <stdio.h>
#include <string.h>
#include "helpers.h"

#define MAXLINE 80
#define MAXCODE 80

main()
{
  int  readCodes(char from[], char to[]);
  void convert(char in[], char out[], char from[], char to[]);

  char inputline[MAXLINE + 1], outputline[MAXLINE + 1];
  char from[MAXLINE + 1], to[MAXLINE + 1];

  if (readCodes(from, to) != -1)                  /* no changes to main */
    while (getline(inputline, MAXLINE) != -1)
    {
      convert(inputline, outputline, from, to);
      printf("%s\n", outputline);
    }
  return 0;
}

int readCodes(char from[], char to[])
{
  int verifyLegal(char from[], char to[], char origfrom[], char origto[]);
  int expand(char start[], char expanded[]);

  char codeline[MAXLINE + 1];
  char blankpos;
  char temp_from[MAXLINE + 1], temp_to[MAXLINE + 1];

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
  copySubString(codeline, temp_from, 0, blankpos);
  copySubString(codeline, temp_to,
                blankpos + 1, strlen(codeline) - blankpos - 1);
  if (expand(temp_from, from) == -1 || expand(temp_to, to) == -1  ||
      verifyLegal(from, to, temp_from, temp_to) == -1)
    return -1;   /* failure! */
  return 1;      /* succeeded */
}

#define NO_DASH 0
#define SAW_DASH 1

int expand(char start[], char expanded[])
{
  int state = NO_DASH;
  int next = 0;
  int i;

  if (start[0] == '-' || start[strlen(start) - 1] == '-')
  {
    printf("Dash at start or finish in \"%s\".\n", start);
    return -1;   /* failure */
  }
  
  for (i = 0; start[i] != '\0'; i++)       /* use state machine */
    if (state == NO_DASH)                  /* in NO_DASH state */
    {
      if (start[i] != '-')
        expanded[next++] = start[i];
      else
        state = SAW_DASH;
    }
    else if (start[i] == '-')              /* in SAW_DASH state */
    { 
      printf("Back to back dashes in \"%s\".\n", start);
      return -1;
    }
    else if (start[i] < start[i-2])
    { 
      printf("Illegal range in \"%s\".\n", start);
      return -1;
    }
    else
    {
      next += placeGroup(start[i-2], start[i], expanded, next - 1) - 1;
      state = NO_DASH;
    }
  expanded[next] = '\0';
  return 1;                     /* succeeded */
}

int verifyLegal(char from[], char to[], char origfrom[], char origto[])
{
  if (duplicates(from))
  {
    printf("Duplicate letters in \"%s\".\n", from);
    return -1;
  }
  if (duplicates(to))
  {
    printf("Duplicate letters in \"%s\".\n", to);
    return -1;
  }
  if (strlen(from) != strlen(to))
  {
    printf("Can't map \"%s\" to \"%s\".\n", origfrom, origto);
    return -1;
  }
  return 1;
}

/*
 * Same as before.
 */
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
