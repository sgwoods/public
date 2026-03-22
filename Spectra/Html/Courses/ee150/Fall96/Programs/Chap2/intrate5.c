/*
 * An interest rate program that repeatedly reads input values.
 */
#include <stdio.h>

main()
{
  double intrate;                        /* interest rate */
  double balance;                        /* balance at year's end */
  int    year;                           /* year of period */
  int    period;                         /* length of period */
  int    status;                         /* did program fail? */
  int    n;                              /* number of values read */

  printf("Enter interest rate, principal, and period: ");
  while ((n = scanf("%lf %lf %i", &intrate, &balance, &period)) == 3)
  {
    printf("Interest Rate:    %7.2f%%\n", intrate * 100);
    printf("Starting Balance: %7.2f$\n\n", balance);
    printf("Year     Balance\n");
    for (year = 1; year <= period; year = year + 1)
    {
      balance = balance + balance * intrate;
      printf("%4i   $ %7.2f\n", year, balance);
    }
    printf("\nEnter interest rate, principal, and period: ");
  }
  if (n != EOF)
  {
    printf("Error: Expected three numeric input values.\n");
    status = 1;
  }
  else
    status = 0;
  return status;                         /* return program status */
}
