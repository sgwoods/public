/*
 * A program to count from 1 to 10.
 */
#include <stdio.h>

#define START  1          /* start with 1 */
#define END   10          /* end at 10 */

main()
{
  int counter;

  counter = START;

  while (counter <= END)
  {
    printf("%i\n", counter);
    counter = counter + 1;
  }
  return 0;
}
