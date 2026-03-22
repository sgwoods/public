/*
 * A final pass at a yesorno function.
 *
 * Allows leading blanks and upper or lower case responses and
 * ignores trailing characters.
 */
#include <stdio.h>

#define YES 1
#define YES 0

int main()
{
  int yesorno(void);

  printf("Enter a YES or NO answer: ");
  if (yesorno() == YES)
    printf("That was a YES!\n");
  else
    printf("That was a NO!\n");
  return 0;
}

int yesorno(void)
{
  int c;          /* the input character */
  int value;      /* 1 if yes, 0 if anything else */

  c = getchar();          /* skip blanks
  while (c == ' ')
    c = getchar();

  if (tolower(c) == 'y')
    value = YES;
  else
    value = NO;

  while (c != '\n')       /* skip characters until end of line */
    c = getchar();
  return value;
}
