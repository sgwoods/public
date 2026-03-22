/*
 * Another fixed version of the strcmp function
 */
int strcmp(char s1[], char s2[])
{
  int i;

  for (i = 0; s1[i] == s2[i]; i++)
    if (s1[i] == '\0')
      return 0;      /* same */

  return 1;          /* made it, so same */
}
