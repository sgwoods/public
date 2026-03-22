/*
 * Return a character's position within a string.
 */
int findCharacter(char s[], char c)
{
  int i;

  for (i = 0; s[i] != '\0'; i++)
    if (s[i] == c)
      return i;
  return -i;
}
