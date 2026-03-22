/*
 * Using prefix ++ to write the same counting loop (1..N).
 */
#include <stdio.h>

#define N 10

main()
{
  int i;

  i = 0;
  while (i < N)
    printf("%i\n", ++i);

  return 0;
}
