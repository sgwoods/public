/*
 * Next pass at checkbook balancer.
 *
 * Fixes bug by skipping over trailing newlines.
 * Also, allows upper case.
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
      case 'B': 
         printf("Balance\n");
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
         printf("Service charge\n");
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
