#include <stdio.h>

main()
{
  double power(double x, int y);

  double base;
  int exp;

  scanf("%lf %i", &base, &exp);
  printf("%f\n", power(base, exp));
  return 0;
}
