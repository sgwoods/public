/*
 * Using the math library to compute exponents (no error checking).
 */
#include <stdio.h>
#include <math.h>

int main()
{
  double x;                             /* user-supplied base */
  double y;                             /* user-supplied exponent */

  while (scanf("%lf %lf", &x, &y) == 2)
    printf("%g^%g = %g\n", x, y, pow(x, y));
  return 0;
}
