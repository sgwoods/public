/*
 * The functions for our separately compilable interest rate program.
 *   display_values - print initial interest rate and starting balance.
 *   year_end_balance - compute year's ending balance, compounding
 *     interest monthly.
 */
#include <stdio.h>

void display_values(double yrly_pct, double start_bal)
{   
  printf("Interest Rate:    %7.2f%%\n", yrly_pct);
  printf("Starting Balance: %7.2f$\n\n", start_bal);
}

double year_end_balance(double intrate, double monthly_bal)
{
  int     month;
  double  monthly_intrate;

  monthly_intrate = intrate / 12;
  for (month = 0; month < 12; month = month + 1)
    monthly_bal = monthly_bal * monthly_intrate + monthly_bal;
  return monthly_bal;
}
