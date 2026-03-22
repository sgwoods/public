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
      switch (c)
      {
        case 'A':  points = 4;
                   break;
        case 'B':  points = 3;
                   break;
        case 'C':  points = 2;
                   break;
        case 'D':  points = 1;
                   break;
        default:   points = 0;
      }
      printf("%i\n", points);
    }
  return 0;
}
