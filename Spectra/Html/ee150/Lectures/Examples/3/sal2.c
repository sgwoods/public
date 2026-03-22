/*
 * Adding the hours column to the salary table.
 */
#include <stdio.h>

#define WAGE      8.50       
#define TAX_RATE   .18        

#define MIN_HOURS    5
#define MAX_HOURS   40
#define INCR_HOURS   5

main()
{
  int hours;     

  printf("Hourly pay: %.2f\n", WAGE);
  printf("Tax rate: %.2f%%\n\n", TAX_RATE);

  printf("Hours\n");

  hours = MIN_HOURS;
  while (hours <= MAX_HOURS)
  {
    printf("%i\n", hours);
    hours = hours + INCR_HOURS;
  }
  return 0;
}
