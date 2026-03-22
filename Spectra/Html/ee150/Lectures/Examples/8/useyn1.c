/*
 * A main program using yesorno to obtain the answer to one question.
 */
#include <stdio.h>

int main()
{
  int result;      

  printf("Are you awake? ");
  result = yesorno();
  if (result != 0)
    printf("That's good.\n");
  else
    printf("That's bad.\n");
  return 0;
}
