/*
 * Generate a table showing interest accumulation.
 */
#include <stdio.h>

#define PRINCIPAL  5000.00               /* start with $5000 */
#define INTRATE       0.06               /* interest rate of 6% */
#define PERIOD        7                  /* over 7-year period */

main()
{
  double balance;                        /* balance at year's end */
  int    year;                           /* year of period */

  printf("Interest Rate:    %7.2f%%\n", INTRATE * 100);
  printf("Starting Balance: %7.2f$\n\n", PRINCIPAL);
  printf("Year     Balance\n");
  balance = PRINCIPAL;
  year = 1;
  while (year <= PERIOD)
  {
    balance = balance + balance * INTRATE;
    printf("%4i   $ %7.2f\n", year, balance);
    year = year + 1;
  }
  return 0;                              /* assume program worked! */
}
