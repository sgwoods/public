/*
 * Print the initial headings of the salary table.
 */
#include <stdio.h>

#define WAGE      8.50       
#define TAX_RATE   .18        

main()
{
  printf("Hourly pay: %.2f\n", WAGE);
  printf("Tax rate: %.2f%%\n", TAX_RATE);

  return 0;
}
