
#include <stdio.h>

main()
{

  int n, a, b;

  n = scanf("%i %i", &a, &b);
  while ( n == 2 )
  {
    printf( "A = %d, B = %d\n", a, b); 

    n = scanf("%i %i", &a, &b);
  }

  printf ( "N = %d\n", n );

  return 0;
}
