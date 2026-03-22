/*
 * A final version of our interest rate program that both
 * repeatedly reads values and makes use of a set of functions.
 */
#include <stdio.h>

main()
{
  double intrate;                        /* interest rate */
  double balance;                        /* balance at year's end */
  int    period;                         /* length of period */
  int    n;                              /* number of values read */
  void   print_balances(double intrate, double balance, int period);

  printf("Enter interest rate, principal, and period: ");
  while ((n = scanf("%lf %lf %i", &intrate, &balance, &period)) == 3)
  {
    print_balances(intrate, balance, period);
    printf("\nEnter interest rate, principal, and period: ");
  }
  if (n == EOF)
    printf("\n");
  else
    printf("I expected three values.  I quit!\n");
  return 0;
}

void print_balances(double intrate, double balance, int period)
{
  int    year;
  void   display_values(double yrly_pct, double start_bal);
  double year_end_balance(double intrate, double monthly_bal);

  display_values(intrate * 100, balance);
  printf("Year   Balance\n");
  for (year = 1; year <= period; year = year + 1)
    printf("%4i   $ %7.2f\n",
           year, balance = year_end_balance(intrate, balance));
}
