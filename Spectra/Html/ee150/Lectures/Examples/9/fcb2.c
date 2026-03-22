/*
 * Fix the problems with printing multiple errors for bad transaction
 * codes.
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

  int getNextNonBlank();

  balance = 0.0;
  deposits = checks = withdrawals = charges = 0;
  total_deposits = total_checks = total_charges = total_withdrawals = 0.0;

  while ((c = getNextNonBlank()) != EOF)
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
   
    /* HERE IS THE CHANGE.

       This now has to skip characters until it hits the newline */

    c = getchar();   
    while (c != '\n')
      c = getchar();
  }

  /* Summary Info */
 
  if (deposits == 0)
    printf("No deposits\n");
  else
    printf("%i deposits for %.2f (avg: %.2f)\n",
           deposits, total_deposits, total_deposits / deposits);

  if (checks == 0)
    printf("No checks\n");
  else
    printf("%i checks for %.2f (avg: %.2f)\n", 
           checks, total_checks, total_checks / checks);

  if (withdrawals == 0)
    printf("No withdrawals\n");
  else
    printf("%i withdrawals for %.2f (avg: %.2f)\n",
            withdrawals, total_withdrawals, total_withdrawals/withdrawals);

  if (charges == 0)
    printf("No charges\n");
  else
    printf("%i charges for %.2f (avg: %.2f)\n", charges, total_charges);

  printf("Final balance: %.2f\n", balance);

  return 0;
}

int getNextNonBlank()
{
  int c;

  c = getchar();         /* skip over blanks */
  while (c == ' ')
    c = getchar();
  return c;              /* return first non-blank */
}
