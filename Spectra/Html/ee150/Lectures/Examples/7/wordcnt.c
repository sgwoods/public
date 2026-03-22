/*
 * Count characters, lines, and words in the input.
 *   (Done using "state machine")
 */
#include <stdio.h>

#define NOT_IN_WORD    0
#define IN_WORD        1

int main()
{
  int c;                                   /* next character */
  int chars;                               /* count characters */
  int lines;                               /* count lines */
  int words;                               /* count words */
  int state;                               /* current state */

  chars = lines = words = 0;
  state = NOT_IN_WORD;
  while ((c = getchar()) != EOF)
  {
    /* This is done in every state */

    chars = chars + 1;
    if (c == '\n')
      lines = lines + 1;
 
    if (state == NOT_IN_WORD)    /* are we in NOT_IN_WORD state? */
    {
      if (isalpha(c) != 0)
      {                          /* we got a letter, */
        state = IN_WORD;         /* so change states and count new word */
        words = words + 1;
      }
    }
    else                         /* we must be in IN_WORD state */
      if (isalpha(c) == 0)
        state = NOT_IN_WORD;     /* got a non-letter, so change states */
  }
  printf("%i %i %i\n", chars, lines, words);
  return 0;
}
