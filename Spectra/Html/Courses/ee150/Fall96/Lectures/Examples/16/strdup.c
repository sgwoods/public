/*
 * Dynamically allocate a copy of a string.
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

char *strdup(char s[])
{
  char *ptr;

  ptr = malloc(strlen(s) + 1);
  if (ptr != NULL)
    strcpy(ptr, s);
  return ptr;
}
