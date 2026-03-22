/*
 * A fixed version of strcmp.
 */
int strcmp(char s1[], char s2[])
{
  int i;

  for (i = 0; s1[i] != '\0'; i++)
    if (s1[i] != s2[i])
      return 1;      /* different */

  if (s2[i] != '\0')
    return 1;        /* different */
  return 0;          /* made it, so same */
}
