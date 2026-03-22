/*
 * Add rest of the summary information.
 */
#include<stdio.h>

main()
{
  int c;                     /* next input character */
  double balance;            /* hold running balance */
  double amount;             /* amount of transaction */
  int    number;             /* check number */

  int    deposits;           /* deposit count */
  int    checks;             /* check count */
  int    charges;            /* charge count */
  int    withdrawals;        /* withdrawal count */
  double total_deposits;     /* deposit total */
  double total_checks;       /* checks total */
  double total_charges;      /* charges total */
  double total_withdrawals;  /* withdrawals total */

  balance = 0.0;
  deposits = checks = withdrawals = charges = 0;
  total_deposits = total_checks = total_charges = total_withdrawals = 0.0;
  while ((c = getchar()) != EOF)
  {
    switch(c)
    { 
      case 'b': 
      case 'B': 
         printf("Balance is %.2f\n", balance);
         break;
      case 'c':
      case 'C':
         scanf("%i %lf", &number, &amount);
         printf("Check %i is %.2f\n", number, amount);
         balance -= amount;
         checks++;
         total_checks += amount;
         break;
      case 'd':
      case 'D':
         scanf("%lf", &amount);
         printf("Deposit is %.2f\n", amount);
         balance += amount;
         deposits++;
         total_deposits += amount;
         break;
      case 's':
      case 'S':
         scanf("%lf", &amount);
         printf("Service charge is %.2f\n", amount);
         balance -= amount;
         charges++;
         total_charges += amount;
         break;
      case 'w':
      case 'W':
         scanf("%lf", &amount);
         printf("Withdrawal is %.2f\n", amount);
         balance -= amount;
         withdrawals++;
         total_withdrawals += amount;
         break;
      default: 
         printf("Bad code: %c\n", c);
         break;
    }
    c = getchar();   /* pick up the trailing newline */
  }

  /* Summary Info */
 
  printf("%i deposits for %.2f\n", deposits, total_deposits);
  printf("%i checks for %.2f\n", checks, total_checks);
  printf("%i withdrawals for %.2f\n", withdrawals, total_withdrawals);
  printf("%i charges for %.2f\n", charges, total_charges);
  printf("Final balance: %.2f\n", balance);

  return 0;
}
