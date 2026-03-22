/*
 * Now add correct processing for "Service Charge".
 */
#include<stdio.h>

main()
{
  int c;                  /* next input character */
  double balance;         /* hold running balance */
  double amount;          /* amount of transaction */

  balance = 0.0;

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
         printf("Check\n");
         break;
      case 'd':
      case 'D':
         printf("Deposit\n");
         break;
      case 's':
      case 'S':
         scanf("%lf", &amount);
         printf("Service charge is %.2f\n", amount);
         balance -= amount;
         break;
      case 'w':
      case 'W':
         printf("Withdrawal\n");
         break;
      default: 
         printf("Bad code: %c\n", c);
         break;
    }
    c = getchar();   /* pick up the trailing newline */
  }
  return 0;
}
