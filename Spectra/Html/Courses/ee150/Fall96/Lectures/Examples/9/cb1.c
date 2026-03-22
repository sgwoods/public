/*
 * First pass at checkbook balancer.
 *
 * Has bug: Prints out "Bad Code" for \n's!
 */
#include<stdio.h>

main()
{
  int c;                  /* next input character */

  while ((c = getchar()) != EOF)
  {
    switch(c)
    { 
      case 'b': 
         printf("Balance\n");
         break;
      case 'c':
         printf("Check\n");
         break;
      case 'd':
         printf("Deposit\n");
         break;
      case 's':
         printf("Service charge\n");
         break;
      case 'w':
         printf("Withdrawal\n");
         break;
      default: 
         printf("Bad code: %c\n", c);
         break;
    }
  }
  return 0;
}
