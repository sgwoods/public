/*
 * A new version of our interest rate program that compounds
 * interest monthly, rather than yearly.
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
  return 0;                             /* assume program succeeded */
}

/* Print the initial interest rate and starting balance */

void display_values(double yrly_pct, double start_bal)
{
  printf("Interest Rate:    %7.2f%%\n", yrly_pct);
  printf("Starting Balance: %7.2f$\n\n", start_bal);
}

/* Compute a year's ending balance, compounding interest monthly */

double year_end_balance(double intrate, double monthly_bal)
{
  int     month;                        /* current month */
  double  monthly_intrate;              /* % interest per month */

  monthly_intrate = intrate / 12;
  for (month = 0; month < 12; month = month + 1)
    monthly_bal = monthly_bal * monthly_intrate + monthly_bal;
  return monthly_bal;
}
