/*
 * Some useful functions
 */
#include "helpers.h"

/*
 * findCharacter:
 *
 *   Returns the position of character c in string s (or -1 if it
 *   can't be found).   For example, findCharacter("alex", 'x')
 *   returns 3.
 */
char findCharacter(char s[], int c)
{
  char *ptr = strchr(s, c);
 
  return (ptr == NULL) ? -1 : ptr - s;
}

/*
 * countCharacter:
 *
 *   Returns the number of times a character appears in a given
 *   string.   For example, countCharacter("alex was here", e)
 *   returns 3.
 */
char countCharacter(char s[], int c)
{
  int count = 0;
  int i;

  for (i = 0; s[i] != '\0'; i++)
    if (s[i] == c)
      count++;
  return count;
}

/*
 * copySubString:
 * 
 *   Copy src[startpos] through src[startpos + n] into dest.
 *
 *   For example, copySubString("alex quilici", temp, 2, 5) results
 *   in temp being the string "ex qu".
 */
void copySubString(char src[], char dest[], int startpos, int n)
{
  int i;

  for (i = 0; i < n && src[startpos + i] != '\0'; i++)
    dest[i] = src[startpos + i];
  dest[i] = '\0';
}

/*
 * placeGroup:
 *
 *    Take a pair of characters, a string, and a place, and put all
 *    characters in that range into the string, starting at the given
 *    place.
 *
 *    Returns the total number of characters in the group.
 * 
 *    For example, placeGroup('a', 'd', temp, 6) will do the following
 *    assignments:
 *
 *       temp[6] = 'a';
 *       temp[7] = 'b';
 *       temp[8] = 'c';
 *       temp[9] = 'd';
 *
 *    and return 4.
 */
int placeGroup(char start, char finish, char dest[], int place)
{
  char nextchar;

  for (nextchar = start; nextchar <= finish; nextchar++)
        dest[place++] = nextchar;
  return finish - start + 1;
}

/*
 * duplicates:
 *
 *    Take a string and determine whether any of the characters in
 *    the string appears more than once.  Returns 1 if it does and
 *    0 otherwise.
 *
 *    For example, duplicates("whatever") will return 1, since the
 *    letter "e" appears more than once, and duplicates("alex") will
 *    return 0, since no character there appears more than once.
 */
int duplicates(char s[])
{
  int i;

  for (i = 0; s[i] != '\0'; i++)
    if (countCharacter(s, s[i]) > 1)
      return 1;   /* duplicates */
  return 0;
}

/*
 * getline (see book for description)
 */
int getline(char line[], int max)
{
  int c;
  int i = 0;

  while ((c = getchar()) != '\n' && c != EOF)
    if (i < max)
      line[i++] = c;
  line[i] = '\0';
  return (c == EOF) ? -1 : i;
}
