/*
 * Generate a table showing interest accumulation.  Now the user
 * provides the initial interest rate, balance, and principal.
 */
#include <stdio.h>

main()
{
  double intrate;                        /* interest rate */
  double balance;                        /* balance at year's end */
  int    year;                           /* year of period */
  int    period;                         /* length of period */

  printf("Enter interest rate, principal, and period: ");
  scanf("%lf %lf %i", &intrate, &balance, &period);
  printf("Interest Rate:    %7.2f%%\n", intrate * 100);
  printf("Starting Balance: %7.2f$\n\n", balance);
  printf("Year     Balance\n");
  for (year = 1; year <= period; year = year + 1)
  {
    balance = balance + balance * intrate;
    printf("%4i   $ %7.2f\n", year, balance);
  }
  return 0;                              /* assume program worked! */
}
