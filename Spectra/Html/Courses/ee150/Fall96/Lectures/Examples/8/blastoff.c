/*
 * Counting down using --
 */
#include <stdio.h>

main()
{
  void countdown(int n);

  countdown(10);
  return 0;
}

void countdown(int n)
{
  while (n > 0)
    printf("%i\n", n--);
  printf("Blastoff!\n");
}
