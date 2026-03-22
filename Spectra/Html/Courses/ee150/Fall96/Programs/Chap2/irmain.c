/*
 * The main program of our separately compilable interest rate program.
 */
#include <stdio.h>

main()
{
  void    display_values(double yrly_pct, double start_bal);
  double  year_end_balance(double intrate, double monthly_bal);

  int     period;                       /* length of period */
  int     year;                         /* year of period */
  double  balance;                      /* balance at end of year */
  double  intrate;                      /* interest rate */

  printf("Enter interest rate, principal, and period: ");
  scanf("%lf %lf %i", &intrate, &balance, &period);
  display_values(intrate * 100, balance);
  printf("Year     Balance\n");
  for (year = 1; year <= period; year = year + 1)
  {
    balance = year_end_balance(intrate, balance);
    printf("%4i   $ %7.2f\n", year, balance);
  }
  return 0;                              /* assume program succeeded */
}
