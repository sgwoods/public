/*
 * Add summary information about final balance and deposits.
 */
#include<stdio.h>

main()
{
  int c;                     /* next input character */
  double balance;            /* hold running balance */
  double amount;             /* amount of transaction */
  int    number;             /* check number */
  int    deposits;           /* deposit count */
  double total_deposits;     /* deposit total */

  balance = 0.0;
  deposits = 0;  total_deposits = 0.0;
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
         break;
      case 'w':
      case 'W':
         scanf("%lf", &amount);
         printf("Withdrawal is %.2f\n", amount);
         balance -= amount;
         break;
      default: 
         printf("Bad code: %c\n", c);
         break;
    }
    c = getchar();   /* pick up the trailing newline */
  }

  /* Summary Info */
 
  printf("%i deposits for %.2f\n", deposits, total_deposits);
  printf("Final balance: %.2f\n", balance);

  return 0;
}
