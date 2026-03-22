/*
 * A main program using yesorno to obtain the answer to two questions.
 * This exposes a bug in our original yesorno.
 */
#include <stdio.h>

int main()
{
  int result;      

  printf("Are you awake? ");
  result = yesorno();
  printf("Result: %i\n", result);
  printf("Really? ");
  result = yesorno();
  printf("Result: %i\n", result);
  return 0;
}
