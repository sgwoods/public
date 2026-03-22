/* 
 * Print grade points for grade, written using else-if.
 */
#include <stdio.h>

int main()
{
  int c;
  int points;

  while ((c = getchar()) != EOF)
    if (c != '\n')
    {
      if (c == 'A')
        points = 4;
      else if (c == 'B')
        points = 3;
      else if (c == 'C')
        points = 2;
      else if (c == 'D')
        points = 1;
      else
        points = 0;
      printf("%i\n", points);
    }
  return 0;
}
