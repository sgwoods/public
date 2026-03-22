/*
 * Using postfix ++ to write a counting loop (1..N).
 */
#include <stdio.h>

#define N 10

main()
{
  int i;

  i = 1;
  while (i <= N)
    printf("%i\n", i++);

  return 0;
}
